<a id="primery-runtime-events"></a>

# Примеры runtime events

Эти примеры используют [agent-runtime-events.schema.json](./agent-runtime-events.schema.json) как источник требований к форме события. Значения `event_type`, обязательные поля и условные требования для handoff, tool call и переходов состояния задаёт схема.

«Валидный» ниже означает только schema-valid. Примеры синтетические и исторические; отдельная запись approval для показанного tool call здесь не предоставлена. Хэши — заполнители, а не вычисленное evidence. Эти события сами по себе не подтверждают допустимость действия по `agent-action-policy.yaml`, целостность delegation или фактический внешний эффект. Для проверки исполнения нужен [семантический контракт комплекта](./README.md); недостающие outcome/binding поля хранят отдельно, без неявного изменения enum.

В событиях не хранится исходное чувствительное содержимое. Для входа, выхода и подтверждений используются ссылки, идентификаторы и хэши.

<a id="validnye-primery"></a>

## Валидные примеры

<a id="obycnoe-dejstvie-odnogo-agenta"></a>

### Обычное действие одного агента

```json
{
  "event_id": "2a4b0552-8417-4f1e-a3d5-9af6c96a3a01",
  "event_type": "plan_created",
  "timestamp": "2026-05-18T10:15:00Z",
  "agent_id": "agent-ticket-triage",
  "agent_version": "2026.05.18",
  "session_id": "session-20260518-001",
  "workflow_id": "wf-ticket-triage",
  "workflow_instance_id": "wf-ticket-triage-20260518-001",
  "parent_agent_id": null,
  "child_agent_id": null,
  "handoff_id": null,
  "delegation_scope": null,
  "delegation_scope_hash": null,
  "tool_call_chain_id": null,
  "initiated_by": {
    "actor_type": "human_user",
    "actor_id": "requester-42",
    "agent_id": null
  },
  "executed_by": {
    "actor_type": "agent",
    "actor_id": "runtime-agent-ticket-triage",
    "agent_id": "agent-ticket-triage"
  },
  "actor_type": "agent",
  "actor_id": "runtime-agent-ticket-triage",
  "action_type": "none",
  "tool_id": null,
  "tool_name": null,
  "connector_id": null,
  "action_name": "triage_ticket_intent",
  "action_risk_level": "low",
  "policy_decision": "not_applicable",
  "approval_id": null,
  "input_reference": {
    "reference_type": "ticket_id",
    "reference_value": "ticket-placeholder-1001",
    "content_hash": "sha256:1111111111111111111111111111111111111111111111111111111111111111",
    "data_classification": "internal"
  },
  "output_reference": {
    "reference_type": "object_key",
    "reference_value": "evidence/runtime/wf-ticket-triage-20260518-001/plan.json",
    "content_hash": "sha256:2222222222222222222222222222222222222222222222222222222222222222",
    "data_classification": "internal"
  },
  "data_classification": "internal",
  "memory_operation": "none",
  "external_side_effect": false,
  "status": "completed",
  "error_code": null,
  "correlation_id": "corr-ticket-triage-20260518-001",
  "evidence_uri": "evidence://runtime/wf-ticket-triage-20260518-001/plan"
}
```

Почему проходит проверку: событие не является handoff или tool call, поэтому `parent_agent_id`, `child_agent_id`, `handoff_id`, `delegation_scope`, `delegation_scope_hash` и `tool_call_chain_id` допустимы как `null`. При этом `workflow_instance_id`, `initiated_by` и `executed_by` позволяют отличить исходного инициатора от фактического исполнителя.

<a id="peredaca-zadaci-drugomu-agentu"></a>

### Передача задачи другому агенту

```json
{
  "event_id": "3bfa7b3e-4a22-418e-bda7-7cb5957b8d91",
  "event_type": "agent_handoff_requested",
  "timestamp": "2026-05-18T10:16:00Z",
  "agent_id": "agent-ticket-triage",
  "agent_version": "2026.05.18",
  "session_id": "session-20260518-001",
  "workflow_id": "wf-ticket-triage",
  "workflow_instance_id": "wf-ticket-triage-20260518-001",
  "parent_agent_id": "agent-ticket-triage",
  "child_agent_id": "agent-ticket-writer",
  "handoff_id": "handoff-ticket-triage-to-writer-001",
  "delegation_scope": {
    "scope_type": "approval_required",
    "authority_id": "delegation-ticket-update-001",
    "allowed_action_ids": [
      "prepare_ticket_update",
      "execute_ticket_update"
    ],
    "constraints": [
      "project=EXAMPLE",
      "max_records=1",
      "approval_required_before_execute"
    ],
    "expires_at": "2026-05-18T14:16:00Z"
  },
  "delegation_scope_hash": "sha256:3333333333333333333333333333333333333333333333333333333333333333",
  "tool_call_chain_id": null,
  "initiated_by": {
    "actor_type": "human_user",
    "actor_id": "requester-42",
    "agent_id": null
  },
  "executed_by": {
    "actor_type": "agent",
    "actor_id": "runtime-agent-ticket-triage",
    "agent_id": "agent-ticket-triage"
  },
  "actor_type": "agent",
  "actor_id": "runtime-agent-ticket-triage",
  "action_type": "internal_state_change",
  "tool_id": null,
  "tool_name": null,
  "connector_id": null,
  "action_name": "handoff_ticket_update_task",
  "action_risk_level": "medium",
  "policy_decision": "allow",
  "approval_id": null,
  "input_reference": {
    "reference_type": "object_key",
    "reference_value": "evidence/runtime/wf-ticket-triage-20260518-001/handoff-input.json",
    "content_hash": "sha256:4444444444444444444444444444444444444444444444444444444444444444",
    "data_classification": "internal"
  },
  "output_reference": {
    "reference_type": "object_key",
    "reference_value": "evidence/runtime/wf-ticket-triage-20260518-001/handoff.json",
    "content_hash": "sha256:5555555555555555555555555555555555555555555555555555555555555555",
    "data_classification": "internal"
  },
  "data_classification": "internal",
  "memory_operation": "none",
  "external_side_effect": false,
  "status": "requested",
  "error_code": null,
  "correlation_id": "corr-ticket-triage-20260518-001",
  "evidence_uri": "evidence://runtime/wf-ticket-triage-20260518-001/handoff"
}
```

Почему проходит проверку: для `agent_handoff_requested` схема требует `parent_agent_id`, `child_agent_id`, `handoff_id`, `delegation_scope`, `delegation_scope_hash`, `initiated_by` и `executed_by`.

<a id="vyzov-instrumenta-docernim-agentom"></a>

### Вызов инструмента дочерним агентом

```json
{
  "event_id": "5b85e930-f36f-4a1a-b2f2-0ee561b47f7d",
  "event_type": "tool_call_executed",
  "timestamp": "2026-05-18T10:20:00Z",
  "agent_id": "agent-ticket-writer",
  "agent_version": "2026.05.18",
  "session_id": "session-20260518-001",
  "workflow_id": "wf-ticket-triage",
  "workflow_instance_id": "wf-ticket-triage-20260518-001",
  "parent_agent_id": "agent-ticket-triage",
  "child_agent_id": "agent-ticket-writer",
  "handoff_id": "handoff-ticket-triage-to-writer-001",
  "delegation_scope": {
    "scope_type": "approval_required",
    "authority_id": "delegation-ticket-update-001",
    "allowed_action_ids": [
      "prepare_ticket_update",
      "execute_ticket_update"
    ],
    "constraints": [
      "project=EXAMPLE",
      "max_records=1",
      "approval_required_before_execute"
    ],
    "expires_at": "2026-05-18T14:16:00Z"
  },
  "delegation_scope_hash": "sha256:3333333333333333333333333333333333333333333333333333333333333333",
  "tool_call_chain_id": "tool-chain-ticket-update-001",
  "initiated_by": {
    "actor_type": "human_user",
    "actor_id": "requester-42",
    "agent_id": null
  },
  "executed_by": {
    "actor_type": "agent",
    "actor_id": "runtime-agent-ticket-writer",
    "agent_id": "agent-ticket-writer"
  },
  "actor_type": "agent",
  "actor_id": "runtime-agent-ticket-writer",
  "action_type": "external_state_change",
  "tool_id": "tool-ticket-writer-placeholder",
  "tool_name": "ticket_writer",
  "connector_id": "ticketing-write-placeholder",
  "action_name": "execute_ticket_update",
  "action_risk_level": "high",
  "policy_decision": "approved",
  "approval_id": "approval-ticket-update-20260518-001",
  "input_reference": {
    "reference_type": "object_key",
    "reference_value": "evidence/runtime/wf-ticket-triage-20260518-001/tool-input.json",
    "content_hash": "sha256:6666666666666666666666666666666666666666666666666666666666666666",
    "data_classification": "internal"
  },
  "output_reference": {
    "reference_type": "object_key",
    "reference_value": "evidence/runtime/wf-ticket-triage-20260518-001/tool-output.json",
    "content_hash": "sha256:7777777777777777777777777777777777777777777777777777777777777777",
    "data_classification": "internal"
  },
  "data_classification": "internal",
  "memory_operation": "none",
  "external_side_effect": true,
  "status": "executed",
  "error_code": null,
  "correlation_id": "corr-ticket-triage-20260518-001",
  "evidence_uri": "evidence://runtime/wf-ticket-triage-20260518-001/tool-call"
}
```

Почему проходит проверку: `tool_call_executed` требует непустые `tool_id`, `tool_name` и `tool_call_chain_id`. Так как событие связано с handoff, дополнительно заполнены поля передачи и область делегирования.

<a id="narusenie-policy-v-seredine-zepocki"></a>

### Нарушение policy в середине цепочки

```json
{
  "event_id": "bf5d5941-4c89-4d41-91d9-79c1ecf6137e",
  "event_type": "policy_denied",
  "timestamp": "2026-05-18T10:23:00Z",
  "agent_id": "agent-ticket-writer",
  "agent_version": "2026.05.18",
  "session_id": "session-20260518-001",
  "workflow_id": "wf-ticket-triage",
  "workflow_instance_id": "wf-ticket-triage-20260518-001",
  "parent_agent_id": "agent-ticket-triage",
  "child_agent_id": "agent-ticket-writer",
  "handoff_id": "handoff-ticket-triage-to-writer-001",
  "delegation_scope": {
    "scope_type": "approval_required",
    "authority_id": "delegation-ticket-update-001",
    "allowed_action_ids": [
      "prepare_ticket_update",
      "execute_ticket_update"
    ],
    "constraints": [
      "project=EXAMPLE",
      "max_records=1",
      "approval_required_before_execute"
    ],
    "expires_at": "2026-05-18T14:16:00Z"
  },
  "delegation_scope_hash": "sha256:3333333333333333333333333333333333333333333333333333333333333333",
  "tool_call_chain_id": "tool-chain-ticket-update-002",
  "initiated_by": {
    "actor_type": "human_user",
    "actor_id": "requester-42",
    "agent_id": null
  },
  "executed_by": {
    "actor_type": "agent",
    "actor_id": "runtime-agent-ticket-writer",
    "agent_id": "agent-ticket-writer"
  },
  "actor_type": "agent",
  "actor_id": "runtime-agent-ticket-writer",
  "action_type": "destructive",
  "tool_id": "tool-ticket-writer-placeholder",
  "tool_name": "ticket_writer",
  "connector_id": "ticketing-write-placeholder",
  "action_name": "delete_record",
  "action_risk_level": "critical",
  "policy_decision": "deny",
  "approval_id": null,
  "input_reference": {
    "reference_type": "object_key",
    "reference_value": "evidence/runtime/wf-ticket-triage-20260518-001/policy-denied-input.json",
    "content_hash": "sha256:8888888888888888888888888888888888888888888888888888888888888888",
    "data_classification": "internal"
  },
  "output_reference": null,
  "data_classification": "internal",
  "memory_operation": "none",
  "external_side_effect": false,
  "status": "denied",
  "error_code": "policy_scope_violation",
  "correlation_id": "corr-ticket-triage-20260518-001",
  "evidence_uri": "evidence://runtime/wf-ticket-triage-20260518-001/policy-denied"
}
```

Почему проходит проверку: событие содержит поля предполагаемой остановки цепочки. `agent_id` и `executed_by.agent_id` указывают исполнителя, `parent_agent_id` и `handoff_id` дают ключи связи с передачей задачи. `delegation_scope_hash` нужно независимо пересчитать и сверить с доверенной записью; его наличие не доказывает актуальность полномочий или отсутствие downstream эффекта.

<a id="nevalidnye-primery"></a>

## Невалидные примеры

<a id="handoff-bez-hesa-oblasti-delegirovania"></a>

### Handoff без хэша области делегирования

```json
{
  "event_id": "1d8db9a7-942d-4507-b1c6-f5faec80b3b7",
  "event_type": "agent_handoff_requested",
  "timestamp": "2026-05-18T10:16:00Z",
  "agent_id": "agent-ticket-triage",
  "agent_version": "2026.05.18",
  "session_id": "session-20260518-001",
  "workflow_id": "wf-ticket-triage",
  "workflow_instance_id": "wf-ticket-triage-20260518-001",
  "parent_agent_id": "agent-ticket-triage",
  "child_agent_id": "agent-ticket-writer",
  "handoff_id": "handoff-ticket-triage-to-writer-001",
  "delegation_scope": {
    "scope_type": "approval_required",
    "authority_id": "delegation-ticket-update-001",
    "allowed_action_ids": [
      "execute_ticket_update"
    ],
    "constraints": [
      "approval_required_before_execute"
    ],
    "expires_at": "2026-05-18T14:16:00Z"
  },
  "tool_call_chain_id": null,
  "initiated_by": {
    "actor_type": "human_user",
    "actor_id": "requester-42",
    "agent_id": null
  },
  "executed_by": {
    "actor_type": "agent",
    "actor_id": "runtime-agent-ticket-triage",
    "agent_id": "agent-ticket-triage"
  },
  "actor_type": "agent",
  "actor_id": "runtime-agent-ticket-triage",
  "action_type": "internal_state_change",
  "tool_id": null,
  "tool_name": null,
  "connector_id": null,
  "action_name": "handoff_ticket_update_task",
  "action_risk_level": "medium",
  "policy_decision": "allow",
  "approval_id": null,
  "input_reference": null,
  "output_reference": null,
  "data_classification": "internal",
  "memory_operation": "none",
  "external_side_effect": false,
  "status": "requested",
  "error_code": null,
  "correlation_id": "corr-ticket-triage-20260518-001",
  "evidence_uri": "evidence://runtime/wf-ticket-triage-20260518-001/handoff"
}
```

Почему не проходит проверку: для `agent_handoff_requested` схема требует `delegation_scope_hash`. Наличие поля необходимо для этой формы, но даже корректный хэш не доказывает, что делегация не отозвана и фактическое действие входит в её scope.

<a id="tool-call-bez-zepocki-vyzova"></a>

### Tool call без цепочки вызова

```json
{
  "event_id": "a4f72623-f2f7-4a31-8970-2684e949a2a0",
  "event_type": "tool_call_executed",
  "timestamp": "2026-05-18T10:20:00Z",
  "agent_id": "agent-ticket-writer",
  "agent_version": "2026.05.18",
  "session_id": "session-20260518-001",
  "workflow_id": "wf-ticket-triage",
  "workflow_instance_id": "wf-ticket-triage-20260518-001",
  "parent_agent_id": null,
  "child_agent_id": null,
  "handoff_id": null,
  "delegation_scope": null,
  "delegation_scope_hash": null,
  "tool_call_chain_id": null,
  "initiated_by": {
    "actor_type": "human_user",
    "actor_id": "requester-42",
    "agent_id": null
  },
  "executed_by": {
    "actor_type": "agent",
    "actor_id": "runtime-agent-ticket-writer",
    "agent_id": "agent-ticket-writer"
  },
  "actor_type": "agent",
  "actor_id": "runtime-agent-ticket-writer",
  "action_type": "external_state_change",
  "tool_id": "tool-ticket-writer-placeholder",
  "tool_name": "ticket_writer",
  "connector_id": "ticketing-write-placeholder",
  "action_name": "execute_ticket_update",
  "action_risk_level": "high",
  "policy_decision": "approved",
  "approval_id": "approval-ticket-update-20260518-001",
  "input_reference": null,
  "output_reference": null,
  "data_classification": "internal",
  "memory_operation": "none",
  "external_side_effect": true,
  "status": "executed",
  "error_code": null,
  "correlation_id": "corr-ticket-triage-20260518-001",
  "evidence_uri": "evidence://runtime/wf-ticket-triage-20260518-001/tool-call"
}
```

Почему не проходит проверку: для `tool_call_executed` схема требует непустой `tool_call_chain_id`, а также непустые `tool_id` и `tool_name`. Без `tool_call_chain_id` нельзя связать запрос инструмента, согласование, исполнение и возможный отказ policy.
