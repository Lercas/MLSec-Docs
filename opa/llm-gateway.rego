# LLM Gateway Policy
# Принимает решение о пропуске запроса через корпоративный LLM gateway:
# проверка access matrix, rate-limits, data classification, fail-closed для cloud.
#
# Вход: объект request с user, model, data_classification, rate_state.

package ml.llm_gateway

import future.keywords.if
import future.keywords.in
import future.keywords.every

default allow := false
default verdict := {"allow": false, "reason": "default deny"}

# Матрица «роль × класс данных × тип модели»
# cloud = внешний провайдер (OpenAI, Anthropic, DeepSeek и т.п.)
# sovereign = self-hosted / российский (GigaChat, YandexGPT внутри периметра и т.п.)
# internal = локальный self-hosted open-source

access_matrix := {
	"admin": {"K0": {"cloud", "sovereign", "internal"}, "K1": {"sovereign", "internal"}, "K2": {"internal"}, "K3": {"internal"}, "K4": {"internal"}},
	"analyst": {"K0": {"cloud", "sovereign", "internal"}, "K1": {"sovereign", "internal"}, "K2": {"internal"}, "K3": set(), "K4": set()},
	"developer": {"K0": {"cloud", "sovereign", "internal"}, "K1": {"sovereign", "internal"}, "K2": set(), "K3": set(), "K4": set()},
	"viewer": {"K0": {"sovereign", "internal"}, "K1": set(), "K2": set(), "K3": set(), "K4": set()},
}

# Rate-limits per role (RPM)
role_rate_limits := {
	"admin": 1000,
	"analyst": 300,
	"developer": 60,
	"viewer": 10,
	"anonymous": 5,
}

allow if {
	valid_context
	classification_ok
	rate_limit_ok
	killswitch_ok
	not blocked_user
	input.request.user.status == "active"
	input.request.user.monthly_spend_usd < input.request.user.monthly_budget_usd
}

# Broker-supplied state must be complete; OPA does not reserve budget atomically.
valid_context if {
	is_string(input.request.user.id)
	input.request.user.id != ""
	is_string(input.request.model.id)
	input.request.model.id != ""
	is_number(input.request.rate_state.rpm)
	input.request.rate_state.rpm >= 0
	is_number(input.request.user.monthly_spend_usd)
	input.request.user.monthly_spend_usd >= 0
	is_number(input.request.user.monthly_budget_usd)
	input.request.user.monthly_budget_usd > 0
	is_boolean(input.killswitch.L0_global_stop)
	is_boolean(input.killswitch.L3_cloud_disabled)
	is_array(input.killswitch.L1_blocked_users)
	is_array(input.killswitch.L2_blocked_models)
}

deny_reasons contains "Missing, invalid or unknown authorization context" if {
	not valid_context
}

deny_reasons contains "User must be active" if {
	not input.request.user.status == "active"
}

verdict := {"allow": true, "reason": "ok"} if {
	allow
}

verdict := {"allow": false, "reason": reason} if {
	not allow
	reason := concat("; ", [r | r := deny_reasons[_]])
}

# Проверка access matrix
classification_ok if {
	role := input.request.user.role
	class := input.request.data_classification
	model_type := input.request.model.type
	allowed_types := access_matrix[role][class]
	model_type in allowed_types
}

deny_reasons contains msg if {
	not classification_ok
	role := input.request.user.role
	class := input.request.data_classification
	model_type := input.request.model.type
	msg := sprintf("Access denied: role=%s cannot use class=%s on model_type=%s", [role, class, model_type])
}

# Rate limit
rate_limit_ok if {
	role := input.request.user.role
	current_rpm := input.request.rate_state.rpm
	limit := role_rate_limits[role]
	current_rpm < limit
}

deny_reasons contains msg if {
	not rate_limit_ok
	role := input.request.user.role
	current_rpm := input.request.rate_state.rpm
	limit := role_rate_limits[role]
	msg := sprintf("Rate limit exceeded: role=%s rpm=%v limit=%v", [role, current_rpm, limit])
}

# Kill-switch
killswitch_ok if {
	input.killswitch.L0_global_stop == false
	not cloud_disabled
	not input.request.model.id in input.killswitch.L2_blocked_models
	not input.request.user.id in input.killswitch.L1_blocked_users
}

cloud_disabled if {
	input.killswitch.L3_cloud_disabled == true
	input.request.model.type == "cloud"
}

deny_reasons contains "Kill-switch L0 active (global stop)" if {
	input.killswitch.L0_global_stop
}

deny_reasons contains "Kill-switch L3 active (cloud egress disabled)" if {
	input.killswitch.L3_cloud_disabled
	input.request.model.type == "cloud"
}

deny_reasons contains sprintf("Model %s blocked via kill-switch L2", [input.request.model.id]) if {
	input.request.model.id in input.killswitch.L2_blocked_models
}

deny_reasons contains sprintf("User %s blocked via kill-switch L1", [input.request.user.id]) if {
	input.request.user.id in input.killswitch.L1_blocked_users
}

# Blocked user
blocked_user if {
	input.request.user.status == "blocked"
}

deny_reasons contains "User status=blocked" if {
	blocked_user
}

# Budget
deny_reasons contains msg if {
	input.request.user.monthly_spend_usd >= input.request.user.monthly_budget_usd
	msg := sprintf("Budget exceeded: spent=%v limit=%v", [input.request.user.monthly_spend_usd, input.request.user.monthly_budget_usd])
}
