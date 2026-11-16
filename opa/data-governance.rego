# Data Governance Policy
# Проверяет Data Card и обработку датасета на соответствие 152-ФЗ, 242-ФЗ,
# EU AI Act ст. 10, ISO/IEC 5259.
#
# Вход: объект dataset с card, scans, legal.

package ml.data_governance

import future.keywords.if
import future.keywords.in

default allow := false

allow if {
	valid_dataset
	count(violations) == 0
}

# Checks internal evidence shape; does not infer a legal basis or prove anonymity.
valid_dataset if {
	is_object(input.dataset.card)
	input.dataset.signed == true
	input.dataset.card.classification in {"K0", "K1", "K2", "K3", "K4"}
	is_boolean(input.dataset.card.contains_pii)
	is_boolean(input.dataset.card.contains_special_pii)
	regex.match(`^[a-f0-9]{64}$`, input.dataset.card.sha256)
	is_array(input.dataset.card.sources)
	count(input.dataset.card.sources) > 0
	is_array(input.dataset.storage)
	count(input.dataset.storage) > 0
	is_number(input.dataset.card.retention_days)
	input.dataset.card.retention_days > 0
	input.dataset.evidence.verified == true
	input.dataset.legal.localization_assessed == true
	is_boolean(input.dataset.legal.ru_localization_required)
	localization_scope_present
	pii_declaration_checked
	input.dataset.evidence.dataset_sha256 == input.dataset.card.sha256
	input.dataset.evidence.purpose == input.dataset.card.purpose
	is_string(input.dataset.card.purpose)
	input.dataset.card.purpose != ""
	is_number(input.dataset.evidence.expires_at_ns)
	input.dataset.evidence.expires_at_ns > time.now_ns()
}

violations contains "Invalid or incomplete dataset/purpose/retention or stale unverified evidence" if {
	not valid_dataset
}

localization_scope_present if {
	input.dataset.legal.ru_localization_required == false
}

localization_scope_present if {
	input.dataset.legal.ru_localization_required == true
	some storage in input.dataset.storage
	storage.role == "primary-collection"
	storage.region == "RU"
}

pii_declaration_checked if {
	input.dataset.card.contains_pii == true
}

pii_declaration_checked if {
	input.dataset.card.contains_pii == false
	input.dataset.scans.pii_scan.completed == true
	input.dataset.scans.pii_scan.entities_found == 0
}

# 1. Data Card присутствует
violations contains "Data Card отсутствует" if {
	not input.dataset.card
}

required_fields := {"id", "version", "sha256", "owner", "data_steward", "classification", "sources", "legal_basis"}

violations contains msg if {
	input.dataset.card
	missing := required_fields - {k | some k in object.keys(input.dataset.card)}
	count(missing) > 0
	msg := sprintf("Data Card: отсутствуют обязательные поля %v", [missing])
}

# 2. Целостность (SHA-256 присутствует, подписан)
violations contains "Dataset не подписан либо подпись невалидна" if {
	not input.dataset.signed
}

# 3. Для ПДн: правовое основание зафиксировано
violations contains "Для ПДн требуется правовое основание по 152-ФЗ ст. 6 / GDPR art. 6" if {
	input.dataset.card.contains_pii == true
	not input.dataset.card.legal_basis.law_reference
}

# 4. Для специальных категорий ПДн требуется дополнительное основание 152-ФЗ ст. 10
violations contains "Для специальных категорий ПДн требуется основание 152-ФЗ ст. 10 / GDPR art. 9" if {
	input.dataset.card.contains_special_pii == true
	not input.dataset.card.legal_basis.special_category_reference
}

# 5. Applicability is assessed externally; this is not a blanket storage ban.
violations contains "Required primary collection operations are outside the approved RU location" if {
	input.dataset.legal.ru_localization_required == true
	some storage in input.dataset.storage
	storage.role == "primary-collection"
	not storage.region == "RU"
}

# 6. PII-скан проведён, если декларировано «PII отсутствует»
violations contains "PII-скан не проведён, но Data Card декларирует отсутствие PII" if {
	input.dataset.card.contains_pii == false
	not input.dataset.scans.pii_scan.completed
}

# 7. Если PII-скан показал находки, но декларация «нет PII»: противоречие
violations contains "Data Card декларирует отсутствие PII, но сканер обнаружил" if {
	input.dataset.card.contains_pii == false
	input.dataset.scans.pii_scan.entities_found > 0
}

# 8. Retention policy установлена
violations contains "Retention policy не установлена" if {
	not input.dataset.card.retention_days
}

violations contains "Retention > 7 лет требует обоснование" if {
	input.dataset.card.retention_days > 2555
	not input.dataset.card.retention_justification
}

# 9. Для high-risk применений (EU AI Act) требуется проверка repr/completeness
violations contains "Для high-risk AI требуется анализ репрезентативности (EU AI Act ст. 10(3))" if {
	input.dataset.card.eu_ai_act_high_risk == true
	not input.dataset.card.representativeness_analysis
}

# 10. Data poisoning scan для датасетов training Tier 1-2
violations contains "Требуется data poisoning scan для training dataset модели Tier 1-2" if {
	input.dataset.card.used_for in {"training", "finetuning"}
	input.dataset.card.target_tier in {1, 2}
	not input.dataset.scans.poisoning_scan.completed
}
