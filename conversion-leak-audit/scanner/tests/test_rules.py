import json
from pathlib import Path
from app.rules.engine import evaluate
from app.rules.coordinator import evaluate_if_ready

FIX=Path(__file__).parent/"fixtures"/"rule_fixtures.json"

def test_frozen_51_fixture_regression():
    rows=json.loads(FIX.read_text(encoding="utf-8")); failures=[]
    for fx in rows:
        d=evaluate(fx["rule_id"],fx["state"])
        if d.result!=fx["expected_result"]:failures.append((fx["fixture_id"],fx["expected_result"],d.result))
    assert len(rows)==51
    assert failures==[]

def test_missing_required_fact_never_creates_issue():
    out=evaluate_if_ready("PHYS-001",{"physical":True})
    assert out["result"]=="CONTEXT_INSUFFICIENT"
    assert "return_proximity" in out["missing"]
