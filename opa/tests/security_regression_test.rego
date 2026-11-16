package ml.security_regression_test

import rego.v1

# Synthetic verified facts, never real credentials or production attestations.
digest := "sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

agent := {
	"action_id": "act-01",
	"agent": {"id": "a1", "environment": "test", "allowed_tools": ["send_email"], "network_allowlist": ["example.org"], "destructive_ops_24h": 0, "max_destructive_ops_24h": 5},
	"session": {"principal": "u1", "tenant": "t1"},
	"tool": {"name": "send_email", "risk_class": "external-side-effect", "schema_revision": "v2", "args_digest": digest, "type": "network", "args": {"destination": "api.example.org", "recipients": ["test@example.org"]}, "execution_identity": {"type": "service"}},
	"hitl_state": {"confirmed": true, "verified": true, "consumed": false, "action_id": "act-01", "principal": "u1", "tenant": "t1", "tool": "send_email", "schema_revision": "v2", "args_digest": digest, "confirmed_at_ns": 10, "expires_at_ns": 200, "external_send_approved": true},
	"broker": {"context_verified": true}, "killswitch": {"L4_stopped_agents": []},
}

test_bound_approval_allowed if {
	data.ml.agent_tool.allow with input as agent with time.now_ns as 100
}

test_changed_approval_fields_denied if {
	every field in ["action_id", "principal", "tenant", "tool", "schema_revision", "args_digest"] {
		changed := object.union(agent, {"hitl_state": object.union(agent.hitl_state, {field: "changed"})})
		not data.ml.agent_tool.allow with input as changed with time.now_ns as 100
	}
}

test_approval_not_verified_consumed_expired_or_future_denied if {
	every override in [{"verified": false}, {"consumed": true}, {"expires_at_ns": 99}, {"confirmed_at_ns": 101}, {"verified": "true"}] {
		changed := object.union(agent, {"hitl_state": object.union(agent.hitl_state, override)})
		not data.ml.agent_tool.allow with input as changed with time.now_ns as 100
	}
}

test_domain_suffix_confusion_denied if {
	every domain in ["evilexample.org", "example.org.attacker.test", "https://example.org", "example.org:443"] {
		changed := object.union(agent, {"tool": object.union(agent.tool, {"args": object.union(agent.tool.args, {"destination": domain})})})
		not data.ml.agent_tool.allow with input as changed with time.now_ns as 100
	}
}

test_empty_contexts_all_deny if {
	not data.ml.agent_tool.allow with input as {}
	not data.ml.deployment.allow with input as {}
	not data.ml.data_governance.allow with input as {}
	not data.ml.supply_chain.allow with input as {}
	not data.ml.llm_gateway.allow with input as {}
	data.ml.dlp_classification.action == "block" with input as {}
}

gateway := {"request": {"user": {"id": "u1", "role": "admin", "status": "active", "monthly_spend_usd": 10, "monthly_budget_usd": 100}, "model": {"id": "model1", "type": "internal"}, "data_classification": "K0", "rate_state": {"rpm": 0}}, "killswitch": {"L0_global_stop": false, "L3_cloud_disabled": false, "L1_blocked_users": [], "L2_blocked_models": []}}

test_gateway_budget_enforced if {
	data.ml.llm_gateway.allow with input as gateway
	changed := object.union(gateway, {"request": object.union(gateway.request, {"user": object.union(gateway.request.user, {"monthly_spend_usd": 100})})})
	not data.ml.llm_gateway.allow with input as changed
}

test_gateway_missing_killswitch_denied if {
	changed := object.remove(gateway, ["killswitch"])
	not data.ml.llm_gateway.allow with input as changed
}

test_dlp_strict_entity_overrides_internal_fallback if {
	i := {"request": {"data_classification": "K0", "destination_type": "internal", "entities_detected": [{"type": "CREDIT_CARD"}], "scanner_error": true}, "policy": {"fail_open_for_internal": true}}
	data.ml.dlp_classification.action == "block" with input as i
	is_string(data.ml.dlp_classification.reason) with input as i
}

model := {"model": {"card": {"id": "m1", "name": "synthetic", "version": "1", "tier": 2, "owner": "team", "purpose": "test", "training_data_ref": "dataset1", "metrics": {}, "risk_assessment": "ra1", "data_card_approved": true, "processes_pii": false}, "artifact": {"signed": true, "signer": "test-signer", "digest": digest}, "tests": {"metrics": {"accuracy": 0.9, "adversarial_robustness": 0.8}, "adversarial": {"passed": true}, "kill_switch_tested": true}, "signoffs": [{"role": "ml_tech_lead", "approved": true}, {"role": "mlsec_analyst", "approved": true}], "evidence": {"verified": true, "ref": "urn:example:synthetic-report", "artifact_digest": digest, "policy_revision": "test-v1", "expires_at_ns": 200}}}

test_model_positive_and_missing_metrics if {
	data.ml.deployment.allow with input as model with data.trusted_signers as ["test-signer"] with data.deployment_policy_revision as "test-v1" with time.now_ns as 100
	changed := json.patch(model, [{"op": "replace", "path": "/model/tests/metrics", "value": {}}])
	not data.ml.deployment.allow with input as changed with data.trusted_signers as ["test-signer"] with data.deployment_policy_revision as "test-v1" with time.now_ns as 100
}

test_model_stale_unknown_tier_or_wrong_digest_denied if {
	every override in [{"expires_at_ns": 99}, {"expires_at_ns": "tomorrow"}, {"verified": "true"}, {"artifact_digest": "changed"}, {"policy_revision": "old"}] {
		changed := object.union(model, {"model": object.union(model.model, {"evidence": object.union(model.model.evidence, override)})})
		not data.ml.deployment.allow with input as changed with data.trusted_signers as ["test-signer"] with data.deployment_policy_revision as "test-v1" with time.now_ns as 100
	}
	changed_tier := object.union(model, {"model": object.union(model.model, {"card": object.union(model.model.card, {"tier": "2"})})})
	not data.ml.deployment.allow with input as changed_tier with data.trusted_signers as ["test-signer"] with data.deployment_policy_revision as "test-v1" with time.now_ns as 100
}

test_registry_host_boundary if {
	data.ml.supply_chain.trusted_registry("registry.example.org/team/image:1") with data.trusted_registries as ["registry.example.org"]
	not data.ml.supply_chain.trusted_registry("registry.example.org.attacker.test/image:1") with data.trusted_registries as ["registry.example.org"]
}

test_cyclonedx_unsupported_version_flagged if {
	count(data.ml.supply_chain.violations) > 0 with input as {"deployment": {"ml_bom": {"spec_version": "1.4"}}}
}

dataset := {"dataset": {"card": {"id": "d1", "version": "1", "sha256": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "owner": "data-team", "data_steward": "steward", "classification": "K0", "sources": ["handwritten-fixture"], "legal_basis": {"reference": "synthetic-fixture"}, "purpose": "test", "contains_pii": false, "contains_special_pii": false, "retention_days": 7}, "signed": true, "storage": [{"role": "primary-collection", "region": "RU"}], "scans": {"pii_scan": {"completed": true, "entities_found": 0}}, "legal": {"localization_assessed": true, "ru_localization_required": false}, "evidence": {"verified": true, "dataset_sha256": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "purpose": "test", "expires_at_ns": 200}}}

test_dataset_positive if {
	data.ml.data_governance.allow with input as dataset with time.now_ns as 100
}

test_dataset_unknown_stale_wrong_purpose_or_empty_storage_denied if {
	every change in [{"path": "/dataset/evidence/expires_at_ns", "value": "tomorrow"}, {"path": "/dataset/evidence/purpose", "value": "other"}, {"path": "/dataset/storage", "value": []}, {"path": "/dataset/card/sources", "value": []}] {
		i := json.patch(dataset, [{"op": "replace", "path": change.path, "value": change.value}])
		not data.ml.data_governance.allow with input as i with time.now_ns as 100
	}
}

supply := {"deployment": {"type": "ml-service", "tier": 2, "image": {"name": "synthetic", "base": "registry.example.org/base:1", "digest": digest, "cosign_verified": true}, "model_artifacts": [{"name": "synthetic", "digest": digest, "sigstore_verified": true}], "vulnerabilities": [], "scan": {"status": "complete", "subject_digest": digest, "expires_at_ns": 200}, "sbom": {"format": "CycloneDX", "schema_validated": true}, "ml_bom": {"spec_version": "1.5", "schema_validated": true, "components": []}, "evidence": {"verified": true}, "dependencies": {"pinned_with_hashes": true}, "adapters": []}}

test_supply_positive if {
	data.ml.supply_chain.allow with input as supply with data.trusted_registries as ["registry.example.org"] with time.now_ns as 100
}

test_supply_unknown_scan_bad_version_or_empty_inventory_denied if {
	every change in [{"path": "/deployment/scan/status", "value": "unknown"}, {"path": "/deployment/scan/expires_at_ns", "value": "tomorrow"}, {"path": "/deployment/ml_bom/spec_version", "value": "1.4"}, {"path": "/deployment/model_artifacts", "value": []}] {
		i := json.patch(supply, [{"op": "replace", "path": change.path, "value": change.value}])
		not data.ml.supply_chain.allow with input as i with data.trusted_registries as ["registry.example.org"] with time.now_ns as 100
	}
}
