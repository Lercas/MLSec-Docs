# Model Deployment Gate
# Проверяет готовность модели к promote в production: Model Card, подписи, сканы,
# adversarial test pass, sign-off ответственных ролей.
#
# Вход: объект model с полями card, artifact, tests, signoffs.
# Выход: allow (bool) + violations (список причин).

package ml.deployment

import future.keywords.if
import future.keywords.in
import future.keywords.every

default allow := false

allow if {
	valid_model
	count(violations) == 0
}

# Example internal gate, not a legal conformity assessment. Evidence is assembled
# by a trusted verifier; fields supplied by a PR/model are not proof.
valid_model if {
	is_object(input.model.card)
	input.model.card.tier in {1, 2, 3, 4}
	is_object(input.model.tests.metrics)
	is_array(input.model.signoffs)
	is_boolean(input.model.card.processes_pii)
	input.model.artifact.signed == true
	input.model.artifact.signer in data.trusted_signers
	input.model.card.data_card_approved == true
	input.model.tests.adversarial.passed == true
	input.model.tests.kill_switch_tested == true
	input.model.evidence.verified == true
	is_string(input.model.evidence.ref)
	input.model.evidence.ref != ""
	input.model.evidence.artifact_digest == input.model.artifact.digest
	regex.match(`^sha256:[a-f0-9]{64}$`, input.model.artifact.digest)
	input.model.evidence.policy_revision == data.deployment_policy_revision
	is_number(input.model.evidence.expires_at_ns)
	input.model.evidence.expires_at_ns > time.now_ns()
}

violations contains "Invalid model/Tier or missing, stale, unverified release-bound evidence" if {
	not valid_model
}

violations contains sprintf("Model Card: empty field %s", [field]) if {
	some field in required_card_fields
	input.model.card[field] in {"", null}
}

violations contains sprintf("Missing or nonnumeric required metric: %s", [metric]) if {
	some metric in object.keys(tier_min_metrics[input.model.card.tier])
	not is_number(object.get(input.model.tests.metrics, metric, null))
}

# 1. Model Card присутствует и заполнен обязательными полями
violations contains msg if {
	not input.model.card
	msg := "Model Card отсутствует"
}

required_card_fields := {"id", "name", "version", "tier", "owner", "purpose", "training_data_ref", "metrics", "risk_assessment"}

violations contains msg if {
	input.model.card
	missing := required_card_fields - {k | some k in object.keys(input.model.card)}
	count(missing) > 0
	msg := sprintf("Model Card: отсутствуют обязательные поля %v", [missing])
}

# 2. Артефакт подписан
violations contains "Артефакт не подписан (cosign / Sigstore Model Transparency required)" if {
	not input.model.artifact.signed
}

violations contains sprintf("Подпись артефакта не от доверенного удостоверителя: %s", [input.model.artifact.signer]) if {
	input.model.artifact.signed
	not input.model.artifact.signer in data.trusted_signers
}

# 3. Data Card существует и одобрен
violations contains "Data Card отсутствует или не одобрен" if {
	not input.model.card.data_card_approved
}

# 4. Metrics удовлетворяют порогам по Tier
tier_min_metrics := {
	1: {"accuracy": 0.90, "adversarial_robustness": 0.85},
	2: {"accuracy": 0.85, "adversarial_robustness": 0.75},
	3: {"accuracy": 0.80, "adversarial_robustness": 0.70},
	4: {"accuracy": 0.75, "adversarial_robustness": 0.60},
}

violations contains msg if {
	tier := input.model.card.tier
	required := tier_min_metrics[tier]
	some metric, threshold in required
	actual := input.model.tests.metrics[metric]
	actual < threshold
	msg := sprintf("Метрика %s=%v ниже порога %v для Tier %v", [metric, actual, threshold, tier])
}

# 5. Adversarial tests пройдены
violations contains "Adversarial test suite не пройден" if {
	not input.model.tests.adversarial.passed
}

# 6. Red team report есть для Tier 1
violations contains "Для Tier 1 обязателен Red Team report" if {
	input.model.card.tier == 1
	not input.model.tests.red_team_report
}

# 7. Sign-offs: для Tier 1 нужны ML Tech Lead + CISO + AI Risk Committee
required_signoffs := {
	1: {"ml_tech_lead", "ciso", "ai_risk_committee", "data_governance_officer"},
	2: {"ml_tech_lead", "mlsec_analyst"},
	3: {"ml_tech_lead"},
	4: set(),
}

violations contains msg if {
	tier := input.model.card.tier
	required := required_signoffs[tier]
	signers := {s.role | some s in input.model.signoffs; s.approved == true}
	missing := required - signers
	count(missing) > 0
	msg := sprintf("Не хватает sign-off ролей %v для Tier %v", [missing, tier])
}

# 8. Kill-switch проверен
violations contains "Kill-switch RTO не измерен (требуется в последнем rollback тесте)" if {
	not input.model.tests.kill_switch_tested
}

# 9. DPIA/PIA для моделей с ПДн
violations contains "DPIA / PIA отсутствует для модели, обрабатывающей ПДн" if {
	input.model.card.processes_pii == true
	not input.model.card.dpia_ref
}

# 10. Compliance: для EU AI Act High-Risk обязателен conformity assessment
violations contains "Conformity assessment отсутствует для high-risk модели (EU AI Act)" if {
	input.model.card.eu_ai_act_class == "high-risk"
	not input.model.card.eu_ai_act_conformity_ref
}
