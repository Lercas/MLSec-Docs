# DLP Classification Policy
# Определяет, какие DLP-правила применять для комбинации «класс данных × destination».
# Используется внутри DLP engine для выбора стратегии (block / mask / allow).
#
# Вход: объект request с data_classification, destination_type, entities_detected.

package ml.dlp_classification

import future.keywords.if
import future.keywords.in

default action := "block"

# Матрица действий: [class][destination_type] = action
# actions: "allow" | "mask" | "block"
action_matrix := {
	"K0": {"cloud": "allow", "sovereign": "allow", "internal": "allow", "agent": "allow"},
	"K1": {"cloud": "mask", "sovereign": "allow", "internal": "allow", "agent": "mask"},
	"K2": {"cloud": "block", "sovereign": "mask", "internal": "allow", "agent": "mask"},
	"K3": {"cloud": "block", "sovereign": "block", "internal": "mask", "agent": "block"},
	"K4": {"cloud": "block", "sovereign": "block", "internal": "block", "agent": "block"},
}

action := act if {
	not hard_block
	not internal_fallback
	class := input.request.data_classification
	dest := input.request.destination_type
	act := action_matrix[class][dest]
}

# Entity-specific overrides: всегда block, если найден специальный тип PII
strict_block_entities := {"RU_PASSPORT", "RU_SNILS", "RU_INN_FL", "CREDIT_CARD", "RU_DRIVERS_LICENSE", "BIOMETRIC"}

hard_block if {
	some entity in input.request.entities_detected
	entity.type in strict_block_entities
}

# Action for specific classes + PII
hard_block if {
	input.request.data_classification in {"K2", "K3", "K4"}
	input.request.destination_type in {"cloud", "sovereign"}
	count(input.request.entities_detected) > 0
}

# Override: если fail-closed для cloud и scanner error, блокировать
hard_block if {
	input.request.scanner_error
	input.request.destination_type in {"cloud", "sovereign"}
	input.policy.fail_closed_for_cloud == true
}

# Override: если fail-open для internal и scanner error, mask
action := "mask" if {
	not hard_block
	internal_fallback
}

internal_fallback if {
	input.request.scanner_error
	input.request.destination_type == "internal"
	input.policy.fail_open_for_internal == true
}

action := "block" if {
	hard_block
}

# Missing scanner outcome or entities is unknown, never a clean scan.
known_target if {
	action_matrix[input.request.data_classification][input.request.destination_type]
}

hard_block if {
	not known_target
}

hard_block if {
	not is_boolean(input.request.scanner_error)
}

hard_block if {
	not is_array(input.request.entities_detected)
}

hard_block if {
	input.request.scanner_error == true
	not internal_fallback
}

# Explanation для audit
reason := sprintf("matrix class=%s destination=%s", [input.request.data_classification, input.request.destination_type]) if {
	not hard_block
	not internal_fallback
}

reason := "blocked: sensitive entity, scanner failure or unknown scan context" if {
	hard_block
}

reason := "internal scanner failure: mask only if a functioning masker is available" if {
	not hard_block
	internal_fallback
}
