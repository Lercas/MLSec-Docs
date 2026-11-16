# Agent Tool Broker Policy
# Принимает решение о выполнении tool call агентом: allowlist инструментов,
# HITL-требования для destructive ops, проверка egress allowlist.
#
# Вход: объект request с agent, tool, args, session, hitl_state.

package ml.agent_tool

import future.keywords.if
import future.keywords.in

default allow := false

allow if {
	valid_context
	count(violations) == 0
}

# These facts come from the trusted broker/tool registry, never model arguments.
valid_context if {
	input.broker.context_verified == true
	is_string(input.agent.id)
	input.agent.id != ""
	is_string(input.session.principal)
	input.session.principal != ""
	is_string(input.session.tenant)
	input.session.tenant != ""
	is_string(input.action_id)
	input.action_id != ""
	input.tool.risk_class in {"read-only", "reversible", "destructive", "external-side-effect", "financial", "irreversible"}
	is_string(input.tool.name)
	is_string(input.tool.type)
	input.tool.type != ""
	is_string(input.tool.schema_revision)
	input.tool.schema_revision != ""
	is_string(input.tool.args_digest)
	regex.match(`^sha256:[a-f0-9]{64}$`, input.tool.args_digest)
	is_array(input.agent.allowed_tools)
	is_array(input.agent.network_allowlist)
	is_array(input.killswitch.L4_stopped_agents)
	input.tool.execution_identity.type == "service"
	is_number(input.agent.destructive_ops_24h)
	is_number(input.agent.max_destructive_ops_24h)
}

violations contains "Missing, invalid or unverified broker context" if {
	not valid_context
}

# OPA only compares verified facts. Signature verification, one-time consumption,
# atomic quota reservation and target readback belong to the executor.
approval_bound if {
	input.hitl_state.confirmed == true
	input.hitl_state.verified == true
	input.hitl_state.consumed == false
	input.hitl_state.action_id == input.action_id
	input.hitl_state.principal == input.session.principal
	input.hitl_state.tenant == input.session.tenant
	input.hitl_state.tool == input.tool.name
	input.hitl_state.schema_revision == input.tool.schema_revision
	input.hitl_state.args_digest == input.tool.args_digest
	is_number(input.hitl_state.confirmed_at_ns)
	is_number(input.hitl_state.expires_at_ns)
	input.hitl_state.confirmed_at_ns <= time.now_ns()
	input.hitl_state.expires_at_ns > time.now_ns()
	input.hitl_state.expires_at_ns - input.hitl_state.confirmed_at_ns <= 300000000000
}

violations contains "Action-bound approval missing, changed, expired or already consumed" if {
	requires_approval
	not approval_bound
}

requires_approval if {
	input.tool.risk_class in destructive_classes
}

# Conservative sample: every SQL execution/push/send needs approval, even if
# classification metadata incorrectly labels it read-only. SQL regex is not a parser.
requires_approval if {
	input.tool.name in {"sql_execute", "db_query", "git_push", "send_email", "send_message"}
}

# 1. Tool присутствует в allowlist агента
violations contains msg if {
	not input.tool.name in input.agent.allowed_tools
	msg := sprintf("Tool %s не в allowlist агента %s", [input.tool.name, input.agent.id])
}

# 2. Destructive tools требуют HITL
destructive_classes := {"destructive", "external-side-effect", "financial", "irreversible"}

violations contains sprintf("Destructive tool %s требует HITL, но не подтверждён пользователем", [input.tool.name]) if {
	input.tool.risk_class in destructive_classes
	not input.hitl_state.confirmed
}

violations contains sprintf("HITL подтверждение устарело (older than 5 min) для tool %s", [input.tool.name]) if {
	input.tool.risk_class in destructive_classes
	input.hitl_state.confirmed
	time.now_ns() - input.hitl_state.confirmed_at_ns > 300000000000 # 5 минут
}

# 3. Destructive tool в prod требует канала через broker с логированием
violations contains "Destructive op в prod должна быть проброшена через broker с полным логированием" if {
	input.tool.risk_class in destructive_classes
	input.agent.environment == "prod"
	not input.broker.logged_to_siem == true
}

# 4. Network egress к non-allowlisted домену запрещён
violations contains "Missing or invalid network destination" if {
	input.tool.type == "network"
	not valid_network_target
}

valid_network_target if {
	is_string(input.tool.args.destination)
	input.tool.args.destination != ""
	domain_allowed(input.tool.args.destination, input.agent.network_allowlist)
}

violations contains sprintf("Destination %s не в network allowlist агента %s", [input.tool.args.destination, input.agent.id]) if {
	input.tool.type == "network"
	not domain_allowed(input.tool.args.destination, input.agent.network_allowlist)
}

domain_allowed(domain, allowlist) if {
	some allowed in allowlist
	regex.match(`^[a-z0-9]+([.-][a-z0-9]+)*$`, domain)
	domain == allowed
}

domain_allowed(domain, allowlist) if {
	some allowed in allowlist
	regex.match(`^[a-z0-9]+([.-][a-z0-9]+)*$`, domain)
	endswith(domain, concat("", [".", allowed]))
}

# 5. Git tools не могут push в защищённые ветки без специального approval
protected_branches := {"main", "master", "prod", "production", "release"}

violations contains sprintf("Push в защищённую ветку %s требует отдельного approval", [input.tool.args.branch]) if {
	input.tool.name == "git_push"
	input.tool.args.branch in protected_branches
	not input.hitl_state.protected_branch_approved
}

# 6. DB tools: DROP / TRUNCATE / DELETE without WHERE запрещены без HITL
dangerous_sql_patterns := [
	`(?i)^\s*DROP\s+`,
	`(?i)^\s*TRUNCATE\s+`,
	`(?i)^\s*DELETE\s+FROM\s+\w+\s*(WHERE)?$`,
	`(?i)^\s*ALTER\s+TABLE\s+\w+\s+DROP`,
]

violations contains "Dangerous SQL detected; inspect restricted evidence by action_id" if {
	input.tool.name in {"sql_execute", "db_query"}
	some pattern in dangerous_sql_patterns
	regex.match(pattern, input.tool.args.sql)
	not input.hitl_state.dangerous_sql_approved
}

# 7. Email / messaging tools: внешние получатели требуют HITL
violations contains sprintf("External email recipient %s требует HITL", [recipient]) if {
	input.tool.name in {"send_email", "send_message"}
	some recipient in input.tool.args.recipients
	not is_internal_email(recipient)
	not input.hitl_state.external_send_approved
}

is_internal_email(email) if {
	some domain in data.internal_email_domains
	endswith(email, concat("", ["@", domain]))
}

# 8. Rate-limit: не более N destructive ops в сутки на агента
violations contains sprintf("Destructive ops daily limit reached: %v/%v", [input.agent.destructive_ops_24h, input.agent.max_destructive_ops_24h]) if {
	input.tool.risk_class in destructive_classes
	input.agent.destructive_ops_24h >= input.agent.max_destructive_ops_24h
}

# 9. Kill-switch L4 для конкретного агента
violations contains sprintf("Agent %s остановлен через kill-switch L4", [input.agent.id]) if {
	input.agent.id in input.killswitch.L4_stopped_agents
}

# 10. Tool выполняется сервис-аккаунтом с минимальными правами
violations contains "Tool использует персональный аккаунт вместо сервис-аккаунта с минимальными правами" if {
	input.tool.execution_identity.type == "personal"
	input.agent.environment == "prod"
}
