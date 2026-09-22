from app.rules.coordinator import evaluate_if_ready

def test_missing_dynamic_facts_are_not_issues():
    for rule in ["CORE-002","CORE-003","CORE-004","CORE-006","PHYS-001","PHYS-002"]:
        out=evaluate_if_ready(rule,{})
        assert out["result"]=="CONTEXT_INSUFFICIENT"

def test_ready_price_fact_can_pass():
    out=evaluate_if_ready("CORE-007",{"direct_purchase":True,"quote_based":False,"price_visible":True})
    assert out["result"]=="PASS"
