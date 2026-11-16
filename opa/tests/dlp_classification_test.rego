package ml.dlp_classification

import future.keywords.if

test_K0_cloud_allowed if {
	action == "allow" with input as {
		"request": {"data_classification": "K0", "destination_type": "cloud", "entities_detected": [], "scanner_error": false},
		"policy": {"fail_closed_for_cloud": true, "fail_open_for_internal": true},
	}
}

test_K3_cloud_blocked if {
	action == "block" with input as {
		"request": {"data_classification": "K3", "destination_type": "cloud", "entities_detected": [], "scanner_error": false},
		"policy": {"fail_closed_for_cloud": true, "fail_open_for_internal": true},
	}
}

test_credit_card_always_blocked if {
	action == "block" with input as {
		"request": {
			"data_classification": "K0",
			"destination_type": "internal",
			"entities_detected": [{"type": "CREDIT_CARD", "value": "****"}],
			"scanner_error": false,
		},
		"policy": {"fail_closed_for_cloud": true, "fail_open_for_internal": true},
	}
}

test_fail_closed_cloud_scanner_error if {
	action == "block" with input as {
		"request": {"data_classification": "K1", "destination_type": "cloud", "entities_detected": [], "scanner_error": true},
		"policy": {"fail_closed_for_cloud": true, "fail_open_for_internal": true},
	}
}

test_fail_open_internal_scanner_error if {
	action == "mask" with input as {
		"request": {"data_classification": "K1", "destination_type": "internal", "entities_detected": [], "scanner_error": true},
		"policy": {"fail_closed_for_cloud": true, "fail_open_for_internal": true},
	}
}
