from app.services.runner import _fact_refs_for, _public_facts
from app.models import PageEvidence


def test_issue_evidence_refs_and_raw_body_not_persisted():
    page = PageEvidence(
        requested_url="https://shop.test/p",
        final_url="https://shop.test/p",
        status=200,
        access_state="ACCESS_OK",
        facts={"visible_price": 49.0, "direct_purchase_signal": True},
    )
    refs = _fact_refs_for("CORE-007", "ISSUE", page)
    assert refs
    public = _public_facts({"body_text": "x" * 5000, "visible_price": 49.0, "internal_links": [str(i) for i in range(100)]})
    assert "body_text" not in public
    assert len(public["bounded_text_snippet"]) == 1000
    assert len(public["internal_links"]) == 20
