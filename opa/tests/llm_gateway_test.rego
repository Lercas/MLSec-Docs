package ml.llm_gateway

import future.keywords.if

test_admin_k3_internal_allowed if {
	allow with input as {
		"request": {
			"user": {"id": "u1", "role": "admin", "status": "active", "monthly_spend_usd": 10, "monthly_budget_usd": 1000},
			"model": {"id": "local-llama", "type": "internal"},
			"data_classification": "K3",
			"rate_state": {"rpm": 5},
		},
		"killswitch": {"L0_global_stop": false, "L3_cloud_disabled": false, "L1_blocked_users": [], "L2_blocked_models": []},
	}
}

test_developer_k2_cloud_denied if {
	not allow with input as {
		"request": {
			"user": {"id": "u2", "role": "developer", "status": "active", "monthly_spend_usd": 10, "monthly_budget_usd": 100},
			"model": {"id": "gpt-4", "type": "cloud"},
			"data_classification": "K2",
			"rate_state": {"rpm": 5},
		},
		"killswitch": {"L0_global_stop": false, "L3_cloud_disabled": false, "L1_blocked_users": [], "L2_blocked_models": []},
	}
}

test_killswitch_L0_denies_all if {
	not allow with input as {
		"request": {
			"user": {"id": "u1", "role": "admin", "status": "active", "monthly_spend_usd": 10, "monthly_budget_usd": 1000},
			"model": {"id": "local-llama", "type": "internal"},
			"data_classification": "K0",
			"rate_state": {"rpm": 5},
		},
		"killswitch": {"L0_global_stop": true, "L3_cloud_disabled": false, "L1_blocked_users": [], "L2_blocked_models": []},
	}
}

test_rate_limit_exceeded if {
	not allow with input as {
		"request": {
			"user": {"id": "u2", "role": "developer", "status": "active", "monthly_spend_usd": 10, "monthly_budget_usd": 100},
			"model": {"id": "local-llama", "type": "internal"},
			"data_classification": "K0",
			"rate_state": {"rpm": 100},
		},
		"killswitch": {"L0_global_stop": false, "L3_cloud_disabled": false, "L1_blocked_users": [], "L2_blocked_models": []},
	}
}
