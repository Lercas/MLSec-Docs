<a id="primery-approval-records"></a>

# Примеры approval records

Эти примеры используют [agent-approval-record.schema.json](./agent-approval-record.schema.json) как источник требований к форме записи. В примерах нет исходного чувствительного содержимого: доказательства хранятся ссылками в `evidence_uri`, а `agent_id`, `action_id`, `requested_by` и `related_event_ids` служат ключами для последующей проверки связей.

Прохождение схемы не означает действующего согласования. Даты исторические: на 13.11.2026 положительные примеры уже истекли. Схема не сверяет время, людей за ID, scope между записями, точные аргументы и отзыв. Порядок action-bound approval и локальные semantic fixtures — в [инструкции комплекта](./README.md#semantic-validation). `action_id` в этом наборе — каталог действий; для отдельной операции нужен immutable snapshot и отдельный operation reference. Двухстороннее согласование не отменяет запрет `external_side_effects_allowed=false` в демонстрационной policy.

<a id="obycnoe-soglasovanie"></a>

## Обычное согласование

```json
{
  "approval_id": "approval-single-20260518-001",
  "agent_id": "agent-ticket-triage",
  "action_id": "action-execute-ticket-update",
  "requested_at": "2026-05-18T14:00:00Z",
  "approved_at": "2026-05-18T14:07:00Z",
  "approver_id": "agent-owner-42",
  "expires_at": "2026-05-18T18:07:00Z",
  "requested_by": {
    "actor_type": "service_account",
    "actor_id": "svc-agent-ticket-triage",
    "role": "agent_runtime"
  },
  "approved_by": [
    {
      "actor_type": "human_user",
      "actor_id": "agent-owner-42",
      "role": "agent_owner"
    }
  ],
  "approver_ids": [
    "agent-owner-42"
  ],
  "approval_type": "single_approver",
  "approval_status": "approved",
  "approval_scope": {
    "scope_type": "specific_action",
    "agent_id": "agent-ticket-triage",
    "action_ids": [
      "action-execute-ticket-update"
    ],
    "workflow_id": "wf-ticket-update-20260518-001",
    "action_names": [
      "execute_ticket_update"
    ],
    "tool_names": [
      "ticket_writer"
    ],
    "connector_ids": [
      "ticketing-write-placeholder"
    ],
    "max_records": 1,
    "external_side_effect_allowed": false,
    "data_classification_allowed": [
      "internal"
    ],
    "broad_scope_justification": null
  },
  "action_summary": "Обновить один ticket_comment в утверждённом проекте",
  "risk_level": "medium",
  "privileged_action": false,
  "explicit_approval_required": true,
  "policy_reference": {
    "policy_id": "agent-action-policy-example",
    "policy_version": "1.0.0",
    "rule_id": "approval-required-action"
  },
  "justification": "Изменение подготовлено агентом и проверено владельцем агента",
  "conditions": [],
  "denied_at": null,
  "denied_by": null,
  "denied_reason": null,
  "revocation": null,
  "evidence_uri": "evidence://approvals/approval-single-20260518-001",
  "related_event_ids": [
    "event-approval-required-001",
    "event-human-approval-recorded-001"
  ]
}
```

<a id="dvuhstoronnee-soglasovanie"></a>

## Двухстороннее согласование

```json
{
  "approval_id": "approval-two-person-20260518-001",
  "agent_id": "agent-ticket-triage",
  "action_id": "action-run-bulk-update",
  "requested_at": "2026-05-18T15:00:00Z",
  "approved_at": "2026-05-18T15:10:00Z",
  "approver_id": "agent-owner-42",
  "expires_at": "2026-05-18T17:10:00Z",
  "requested_by": {
    "actor_type": "service_account",
    "actor_id": "svc-agent-ticket-triage",
    "role": "agent_runtime"
  },
  "approved_by": [
    {
      "actor_type": "human_user",
      "actor_id": "agent-owner-42",
      "role": "agent_owner"
    },
    {
      "actor_type": "human_user",
      "actor_id": "security-reviewer-07",
      "role": "security_reviewer"
    }
  ],
  "approver_ids": [
    "agent-owner-42",
    "security-reviewer-07"
  ],
  "approval_type": "two_person",
  "approval_status": "approved",
  "approval_scope": {
    "scope_type": "workflow",
    "agent_id": "agent-ticket-triage",
    "action_ids": [
      "action-run-bulk-update"
    ],
    "workflow_id": "wf-bulk-update-20260518-001",
    "action_names": [
      "run_bulk_update"
    ],
    "tool_names": [
      "ticket_writer"
    ],
    "connector_ids": [
      "ticketing-write-placeholder"
    ],
    "max_records": 10,
    "external_side_effect_allowed": false,
    "data_classification_allowed": [
      "internal"
    ],
    "broad_scope_justification": null
  },
  "action_summary": "Выполнить ограниченное bulk-обновление десяти записей в одном workflow",
  "risk_level": "high",
  "privileged_action": true,
  "explicit_approval_required": true,
  "policy_reference": {
    "policy_id": "agent-action-policy-example",
    "policy_version": "1.0.0",
    "rule_id": "bulk-operation"
  },
  "justification": "Операция ограничена одним workflow и требует двух разных согласующих",
  "conditions": [
    {
      "condition_id": "condition-max-records",
      "description": "Не больше десяти записей в рамках указанного workflow",
      "must_be_satisfied_before_execution": true
    }
  ],
  "denied_at": null,
  "denied_by": null,
  "denied_reason": null,
  "revocation": null,
  "evidence_uri": "evidence://approvals/approval-two-person-20260518-001",
  "related_event_ids": [
    "event-approval-required-002",
    "event-human-approval-recorded-002"
  ]
}
```

<a id="otkaz"></a>

## Отказ

```json
{
  "approval_id": "approval-denied-20260518-001",
  "agent_id": "agent-ticket-triage",
  "action_id": "action-delete-record",
  "requested_at": "2026-05-18T16:00:00Z",
  "approved_at": null,
  "approver_id": null,
  "expires_at": null,
  "requested_by": {
    "actor_type": "service_account",
    "actor_id": "svc-agent-ticket-triage",
    "role": "agent_runtime"
  },
  "approved_by": [],
  "approver_ids": [],
  "approval_type": "denial",
  "approval_status": "denied",
  "approval_scope": {
    "scope_type": "specific_action",
    "agent_id": "agent-ticket-triage",
    "action_ids": [
      "action-delete-record"
    ],
    "workflow_id": "wf-delete-attempt-20260518-001",
    "action_names": [
      "delete_record"
    ],
    "tool_names": [
      "ticket_writer"
    ],
    "connector_ids": [
      "ticketing-write-placeholder"
    ],
    "max_records": 1,
    "external_side_effect_allowed": false,
    "data_classification_allowed": [
      "internal"
    ],
    "broad_scope_justification": null
  },
  "action_summary": "Попытка удалить запись вне разрешённой области действия",
  "risk_level": "critical",
  "privileged_action": false,
  "explicit_approval_required": false,
  "policy_reference": {
    "policy_id": "agent-action-policy-example",
    "policy_version": "1.0.0",
    "rule_id": "deny-action"
  },
  "justification": null,
  "conditions": [],
  "denied_at": "2026-05-18T16:02:00Z",
  "denied_by": {
    "actor_type": "human_user",
    "actor_id": "agent-owner-42",
    "role": "agent_owner"
  },
  "denied_reason": "Действие находится в denied_actions и не имеет отдельного утверждённого процесса",
  "revocation": null,
  "evidence_uri": "evidence://approvals/approval-denied-20260518-001",
  "related_event_ids": [
    "event-policy-denied-001"
  ]
}
```

<a id="nevalidnoe-soglasovanie"></a>

## Невалидное согласование

```json
{
  "approval_id": "approval-invalid-20260518-001",
  "agent_id": "agent-ticket-triage",
  "action_id": "action-run-bulk-update",
  "requested_at": "2026-05-18T17:00:00Z",
  "approved_at": "2026-05-18T17:03:00Z",
  "approver_id": "agent-owner-42",
  "expires_at": "2026-05-18T19:03:00Z",
  "requested_by": {
    "actor_type": "service_account",
    "actor_id": "svc-agent-ticket-triage",
    "role": "agent_runtime"
  },
  "approved_by": [
    {
      "actor_type": "human_user",
      "actor_id": "agent-owner-42",
      "role": "agent_owner"
    }
  ],
  "approver_ids": [
    "agent-owner-42"
  ],
  "approval_type": "two_person",
  "approval_status": "approved",
  "approval_scope": {
    "scope_type": "all",
    "agent_id": "agent-ticket-triage",
    "action_ids": [
      "action-run-bulk-update"
    ],
    "workflow_id": null,
    "action_names": [
      "run_bulk_update"
    ],
    "tool_names": [
      "ticket_writer"
    ],
    "connector_ids": [
      "ticketing-write-placeholder"
    ],
    "max_records": 1000,
    "external_side_effect_allowed": true,
    "data_classification_allowed": [
      "internal",
      "confidential"
    ],
    "broad_scope_justification": null
  },
  "action_summary": "Слишком широкое bulk-согласование",
  "risk_level": "high",
  "privileged_action": true,
  "explicit_approval_required": false,
  "policy_reference": {
    "policy_id": "agent-action-policy-example",
    "policy_version": "1.0.0",
    "rule_id": "bulk-operation"
  },
  "justification": null,
  "conditions": [],
  "denied_at": null,
  "denied_by": null,
  "denied_reason": null,
  "revocation": null,
  "evidence_uri": "evidence://approvals/approval-invalid-20260518-001",
  "related_event_ids": [
    "event-approval-required-invalid"
  ]
}
```

Почему не проходит проверку:

- `approval_type=two_person`, но в `approved_by` и `approver_ids` только один согласующий;
- `privileged_action=true`, но `explicit_approval_required=false`;
- `approval_scope.scope_type=all`, но `broad_scope_justification` не заполнен.
