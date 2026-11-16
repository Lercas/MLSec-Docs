"""Offline synthetic checks; no external APIs and no runtime authorization service."""

import copy
import hashlib
import json
from pathlib import Path
import re
from datetime import datetime, timezone

from jsonschema import Draft202012Validator, FormatChecker
import yaml


ROOT = Path(__file__).resolve().parent


def digest(value):
    # Local example encoding; not a JCS implementation or an authenticity check.
    encoded = json.dumps(value, sort_keys=True, separators=(",", ":"),
                         ensure_ascii=False, allow_nan=False).encode("utf-8")
    return "sha256:" + hashlib.sha256(encoded).hexdigest()


def instant(value):
    if not isinstance(value, str) or not value.endswith("Z"):
        raise ValueError("utc_timestamp_required")
    result = datetime.fromisoformat(value[:-1] + "+00:00")
    if result.tzinfo != timezone.utc:
        raise ValueError("utc_timestamp_required")
    return result


def require(condition, code):
    if not condition:
        raise ValueError(code)


def semantic_check(record, action, binding, current):
    """Illustrate consistency using synthetic trusted state supplied by the fixture.

    Real callers must authenticate all four inputs and reserve execution atomically.
    This function neither checks signatures nor prevents concurrent use/TOCTOU.
    """
    now = instant(current["now"])
    require(record["approval_status"] == "approved", "approval_not_approved")
    require(record["revocation"] is None and not current["approval_revoked"], "approval_revoked")
    require(not current["approval_consumed"], "approval_consumed")
    require(instant(record["requested_at"]) <= instant(record["approved_at"]) <= now
            < instant(record["expires_at"]), "approval_time_invalid")
    require(record["policy_reference"] == current["policy_reference"], "stale_policy")
    require(current["agent_active"] and current["object_acl_allowed"], "current_access_denied")
    grant = current["delegation"]
    require(not grant["revoked"] and instant(grant["granted_at"]) <= now
            < instant(grant["expires_at"]), "delegation_inactive")
    require(instant(record["expires_at"]) <= instant(grant["expires_at"]), "approval_outlives_grant")
    require(action["action_id"] in grant["action_ids"]
            and action["tenant_id"] == grant["tenant_id"]
            and action["agent_id"] == grant["agent_id"], "delegation_scope_mismatch")
    require(current["budget_available"], "budget_unavailable")

    scope = record["approval_scope"]
    require(scope["scope_type"] == "specific_action", "unsupported_broad_scope")
    require(record["agent_id"] == scope["agent_id"] == action["agent_id"], "agent_mismatch")
    require(record["action_id"] == action["action_id"]
            and action["action_id"] in scope["action_ids"], "action_mismatch")
    require(record["requested_by"] == action["requested_by"], "requester_mismatch")
    for field, scope_field in (("action_name", "action_names"),
                               ("tool_name", "tool_names"),
                               ("connector_id", "connector_ids")):
        require(action[field] in scope[scope_field], "scope_mismatch:" + field)
    require(action["workflow_id"] == scope["workflow_id"], "workflow_mismatch")
    require(type(action["records"]) is int and action["records"] > 0
            and scope["max_records"] is not None
            and action["records"] <= scope["max_records"] <= grant["max_records"], "record_limit")
    require(action["data_classification"] in scope["data_classification_allowed"], "data_scope")
    require(not action["external_side_effect"] or
            (scope["external_side_effect_allowed"] and current["external_effects_allowed"]), "external_denied")

    actors = record["approved_by"]
    ids = [actor["actor_id"] for actor in actors]
    require(len(ids) == len(set(ids)) and set(ids) == set(record["approver_ids"])
            and record["approver_id"] in ids, "approver_links")
    directory = current["identity_directory"]
    principals = []
    for actor in actors:
        identity = directory.get(actor["actor_id"])
        require(identity is not None and identity["active"]
                and actor["actor_type"] == "human_user"
                and actor["role"] in identity["roles"]
                and actor["role"] in current["allowed_approver_roles"], "approver_not_authorized")
        principals.append(identity["person_ref"])
    require(len(principals) == len(set(principals)), "same_person_alias")
    minimum = 2 if record["approval_type"] == "two_person" else 1
    require(len(principals) >= minimum, "insufficient_people")
    require(set(current["required_approver_roles"]).issubset({a["role"] for a in actors}), "missing_role")
    require(all(not c["must_be_satisfied_before_execution"]
                or current["condition_results"].get(c["condition_id"]) is True
                for c in record["conditions"]), "condition_not_satisfied")

    require(binding["version"] == "1.0", "binding_version")
    require(binding["approval_id"] == record["approval_id"]
            and binding["approval_record_digest"] == digest(record), "approval_binding_mismatch")
    require(binding["action_digest"] == digest(action), "action_binding_mismatch")
    require(binding["delegation_revision"] == grant["revision"], "delegation_revision_mismatch")
    require(binding["tenant_id"] == action["tenant_id"] == current["tenant_id"], "tenant_mismatch")
    require(binding["workflow_instance_id"] == action["workflow_instance_id"]
            == current["workflow_instance_id"], "run_mismatch")
    require(set(record["related_event_ids"]).issubset(set(current["related_event_ids"])), "event_links")
    return "consistent_synthetic_example"


def json_blocks(name):
    return [json.loads(block) for block in re.findall(
        r"```json\s*\n(.*?)\n```", (ROOT / name).read_text(), re.S)]


def set_path(target, path, value):
    parts = path.split(".")
    for part in parts[:-1]:
        target = target[int(part)] if isinstance(target, list) else target[part]
    if isinstance(target, list):
        target[int(parts[-1])] = value
    else:
        target[parts[-1]] = value


def main():
    schemas = {}
    for name in ("approval-record", "runtime-events"):
        schema = json.loads((ROOT / f"agent-{name}.schema.json").read_text())
        Draft202012Validator.check_schema(schema)
        schemas[name] = Draft202012Validator(schema, format_checker=FormatChecker())
    approvals = json_blocks("agent-approval-record-examples.md")
    events = json_blocks("agent-runtime-events-examples.md")
    structural = []
    for name, values, valid_count in (("approval-record", approvals, 3),
                                       ("runtime-events", events, 4)):
        require(len(values) == valid_count + (1 if name == "approval-record" else 2), "example_count_changed")
        for index, value in enumerate(values):
            valid = not list(schemas[name].iter_errors(value))
            require(valid == (index < valid_count), f"unexpected_schema_result:{name}:{index}")
            structural.append({"schema": name, "index": index, "schema_valid": valid})
    structural_negative = []
    for name, source, field, value in (
        ("approval-record", approvals[0], "approved_at", "not-a-date"),
        ("approval-record", approvals[0], "arguments_digest", "unversioned-field"),
        ("runtime-events", events[0], "event_type", "memory_deleted"),
        ("runtime-events", events[0], "status", "unknown"),
    ):
        candidate = copy.deepcopy(source)
        candidate[field] = value
        require(bool(list(schemas[name].iter_errors(candidate))), "schema_rejection_missing:" + field)
        structural_negative.append({"schema": name, "rejected_field": field, "value": value})
    for name in ("agent-action-policy.yaml", "prometheus-agent-alerts.yaml", "prometheus-agent-alerts.test.yaml"):
        require(isinstance(yaml.safe_load((ROOT / name).read_text()), dict), "yaml_mapping_required")

    fixture = json.loads((ROOT / "agent-semantic-fixtures.json").read_text())
    require(fixture["fixture_version"] == "1.0", "fixture_version")
    base = {"record": approvals[0], **fixture["base"]}
    # This locally assembled binding simulates a trusted approval-service record.
    base["binding"]["approval_record_digest"] = digest(base["record"])
    base["binding"]["action_digest"] = digest(base["action"])
    results = []
    for case in fixture["cases"]:
        test = copy.deepcopy(base)
        for change in case.get("changes", []):
            set_path(test, change["path"], change["value"])
        # Positive two-person fixture simulates approval-service re-attestation;
        # negative mutations never refresh the signed/bound record silently.
        if case.get("synthetic_reattest", False):
            require(case["expected"] == "consistent_synthetic_example", "negative_reattest_forbidden")
            test["binding"]["approval_record_digest"] = digest(test["record"])
        try:
            schemas["approval-record"].validate(test["record"])
            result = semantic_check(**test)
        except ValueError as error:
            result = str(error)
        require(result == case["expected"], f"unexpected_semantic_result:{case['id']}:{result}")
        results.append({"case": case["id"], "result": result})
    print(json.dumps({"scope": "offline synthetic only; no enforcement or external API",
                      "schema_examples": structural, "structural_negative": structural_negative,
                      "semantic_cases": results,
                      "schema_sha256": {n: hashlib.sha256((ROOT / f"agent-{n}.schema.json").read_bytes()).hexdigest()
                                        for n in schemas}}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
