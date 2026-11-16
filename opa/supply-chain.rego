# ML Supply Chain Policy
# Проверяет соответствие supply chain требованиям: подписанные images,
# SBOM/ML-BOM, проверенные модели и базовые образы, отсутствие known CVE.
#
# Вход: объект deployment с image, model_artifacts, sbom.

package ml.supply_chain

import future.keywords.if
import future.keywords.in
import future.keywords.every

default allow := false

allow if {
	valid_deployment
	count(violations) == 0
}

# Verifier-owned facts. An empty inventory/scan is unknown, not a clean result.
valid_deployment if {
	input.deployment.type in {"ml-service", "application"}
	input.deployment.image.cosign_verified == true
	trusted_registry(input.deployment.image.base)
	regex.match(`^sha256:[a-f0-9]{64}$`, input.deployment.image.digest)
	is_array(input.deployment.model_artifacts)
	is_array(input.deployment.vulnerabilities)
	input.deployment.scan.status == "complete"
	input.deployment.scan.subject_digest == input.deployment.image.digest
	is_number(input.deployment.scan.expires_at_ns)
	input.deployment.scan.expires_at_ns > time.now_ns()
	input.deployment.sbom.schema_validated == true
	input.deployment.evidence.verified == true
}

violations contains "ML service requires nonempty model inventory and schema-validated ML-BOM" if {
	input.deployment.type == "ml-service"
	not valid_ml_inventory
}

valid_ml_inventory if {
	count(input.deployment.model_artifacts) > 0
	input.deployment.ml_bom.schema_validated == true
	input.deployment.ml_bom.spec_version in {"1.5", "1.6", "1.7"}
	every model in input.deployment.model_artifacts {
		model.sigstore_verified == true
		is_string(model.name)
		regex.match(`^sha256:[a-f0-9]{64}$`, model.digest)
	}
}

violations contains "Incomplete inventory or stale, unknown, unverified digest-bound scan evidence" if {
	not valid_deployment
}

# 1. Docker image подписан cosign
violations contains sprintf("Docker image %s не подписан", [input.deployment.image.name]) if {
	not input.deployment.image.cosign_verified
}

# 2. Базовый образ из trusted registry
violations contains sprintf("Base image %s из ненадёжного registry", [input.deployment.image.base]) if {
	not trusted_registry(input.deployment.image.base)
}

trusted_registry(image) if {
	some registry in data.trusted_registries
	split(image, "/")[0] == registry
}

# 3. SBOM (CycloneDX) присутствует
violations contains "SBOM отсутствует" if {
	not input.deployment.sbom
}

violations contains "SBOM format не CycloneDX" if {
	input.deployment.sbom
	input.deployment.sbom.format != "CycloneDX"
}

# 4. ML-BOM 1.5+ для ML-сервисов
violations contains "ML-BOM отсутствует" if {
	input.deployment.type == "ml-service"
	not input.deployment.ml_bom
}

violations contains "ML-BOM spec_version unsupported or unknown (expected CycloneDX 1.5/1.6/1.7)" if {
	input.deployment.ml_bom
	not input.deployment.ml_bom.spec_version in {"1.5", "1.6", "1.7"}
}

semver_less_than(a, b) if {
	a_parts := split(a, ".")
	b_parts := split(b, ".")
	count(a_parts) == 3
	count(b_parts) == 3
	to_number(a_parts[0]) < to_number(b_parts[0])
}

semver_less_than(a, b) if {
	a_parts := split(a, ".")
	b_parts := split(b, ".")
	count(a_parts) == 3
	count(b_parts) == 3
	to_number(a_parts[0]) == to_number(b_parts[0])
	to_number(a_parts[1]) < to_number(b_parts[1])
}

# 5. Все модели подписаны Sigstore Model Transparency
violations contains sprintf("Model %s не подписан Sigstore Model Transparency", [model.name]) if {
	some model in input.deployment.model_artifacts
	not model.sigstore_verified
}

# 6. Нет CVE Critical/High в компонентах
violations contains sprintf("Critical CVE в компоненте: %s (%s)", [cve.id, cve.component]) if {
	some cve in input.deployment.vulnerabilities
	cve.severity == "CRITICAL"
	not cve.accepted_risk
}

violations contains sprintf("High CVE без mitigation: %s (%s)", [cve.id, cve.component]) if {
	some cve in input.deployment.vulnerabilities
	cve.severity == "HIGH"
	not cve.mitigation_ref
	not cve.accepted_risk
}

# 7. Модели Tier 1 не могут использовать компоненты с неизвестным происхождением
violations contains sprintf("Tier 1 model не может использовать компонент с unknown provenance: %s", [dep.name]) if {
	input.deployment.tier == 1
	some dep in input.deployment.ml_bom.components
	dep.provenance == "unknown"
}

# 8. Зависимости из pip/npm lockfile (pinned)
violations contains "requirements.txt должен быть pinned (hashes)" if {
	input.deployment.type == "ml-service"
	not input.deployment.dependencies.pinned_with_hashes
}

# 9. Pre-trained model сверен с известным хешем (защита от Rules File Backdoor / MCP Tool Poisoning)
violations contains sprintf("Pre-trained model %s не сверен с реестром хешей (risk: supply chain attack)", [model.name]) if {
	some model in input.deployment.model_artifacts
	model.source == "external"
	not model.hash_verified
}

# 10. LoRA adapters проверены, декларирован base model
violations contains sprintf("LoRA adapter %s без декларации base model", [adapter.name]) if {
	some adapter in input.deployment.adapters
	not adapter.base_model_ref
}
