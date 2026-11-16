"""Local AST replay for a bounded subset; not a Splunk/KUMA runtime emulator."""
from itertools import product
from pathlib import Path
import json

from sigma.collection import SigmaCollection
from sigma.backends.splunk import SplunkBackend
from sigma.conditions import ConditionAND, ConditionOR, ConditionFieldEqualsValueExpression
from sigma.types import SigmaString, SigmaBool, SigmaCompareExpression

ROOT = Path(__file__).resolve().parents[1]


def matches(node, event):
    if isinstance(node, ConditionAND):
        return all(matches(child, event) for child in node.args)
    if isinstance(node, ConditionOR):
        return any(matches(child, event) for child in node.args)
    if not isinstance(node, ConditionFieldEqualsValueExpression):
        raise TypeError(f"Unsupported AST node: {type(node).__name__}")
    if node.field not in event:
        return False
    actual, expected = event[node.field], node.value
    if isinstance(expected, SigmaString):
        return actual == str(expected)
    if isinstance(expected, SigmaBool):
        return actual is expected.boolean
    if isinstance(expected, SigmaCompareExpression) and expected.op.name == "GTE":
        return type(actual) in (int, float) and actual >= expected.number.number
    raise TypeError(f"Unsupported value: {type(expected).__name__}")


def main():
    rules = {}
    for path in sorted((ROOT / "sigma").glob("*.yml")):
        collection = SigmaCollection.from_yaml(path.read_text())
        assert SplunkBackend().convert(collection)
        rules[path.stem] = collection.rules[0].detection.parsed_condition[0].parsed
    cases = []

    def check(rule, case_id, event, expected):
        actual = matches(rules[rule], event)
        assert actual == expected, (case_id, actual, expected)
        cases.append({"case": case_id, "expected": expected, "actual": actual})

    approval = {"event.category": "agent-tool-call", "tool.risk_class": "financial", "hitl.required": True}
    for status in ["invalid", "missing", "expired", "replayed", "unknown", "verified"]:
        check("agent-01-destructive-action", f"approval-{status}", approval | {"approval.validation": status}, status != "verified")
    # Missing enrichment is a coverage failure, not proof of safe execution.
    check("agent-01-destructive-action", "approval-field-absent-no-match", approval, False)
    check("agent-01-destructive-action", "boolean-true-is-not-binding", approval | {"hitl.confirmed": True, "approval.validation": "invalid"}, True)
    for outcome, status in [("unknown", "overdue"), ("unknown", "pending"), ("succeeded", "complete")]:
        check("agent-04-outcome-unknown", f"reconcile-{outcome}-{status}", {"event.category": "agent-action-reconciliation", "action.outcome": outcome, "reconciliation.status": status}, outcome == "unknown" and status == "overdue")
    # Exhaustive truth table for 3-of-5 features on one enrichment event.
    fields = ["client.rps_1h", "gen_ai.request.logprobs", "request.input_entropy", "detection.pattern_score", "client.request_count_24h"]
    positive = [500, True, 0.85, 0.7, 10000]
    negative = [0, False, 0.1, 0.1, 0]
    for bits in product([False, True], repeat=5):
        event = {"event.category": "inference-request"} | {field: positive[i] if bits[i] else negative[i] for i, field in enumerate(fields)}
        check("ml-03-extraction-pattern", "signals-" + "".join(str(int(x)) for x in bits), event, sum(bits) >= 3)
    print(json.dumps({"converted_sigma_rules": len(rules), "synthetic_cases": cases, "limits": "AST replay only; no field pipeline, rolling aggregation, Splunk/KUMA execution or SOAR action tested"}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
