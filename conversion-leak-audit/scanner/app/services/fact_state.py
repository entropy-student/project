from __future__ import annotations
from datetime import datetime, timezone
from typing import Any

CADENCE = ("per month","monthly","every 30 days","per year","annually","annual","weekly","per week")
AUTO = ("auto-renew","auto renew","automatically renew","renews automatically","auto-renewing")
TRIAL = ("free trial","trial")

def build_rule_state(page: dict[str,Any], *, region: str | None = None) -> dict[str,Any]:
    facts=page.get("facts",{})
    text=(facts.get("body_text") or "").lower()
    final_url=page.get("final_url")
    status=page.get("status")
    state={
        "http_status":status,
        "dom_complete":page.get("access_state")=="ACCESS_OK",
        "critical_js_complete":True,
        "final_url":final_url,
        "region":region,
        "currency":facts.get("visible_currency") or facts.get("structured_currency"),
        "viewport":"static",
        "timestamp":datetime.now(timezone.utc).isoformat(),
        "geo_redirect":False,
        "core_page":True,
        "direct_purchase":facts.get("direct_purchase_signal"),
        "quote_based":facts.get("quote_based_signal"),
        "price_visible":facts.get("visible_price") is not None,
        "price_rule_visible":False,
        "product_page":facts.get("has_product_schema") or facts.get("direct_purchase_signal"),
        "visible_price":facts.get("visible_price"),
        "visible_currency":facts.get("visible_currency"),
        "structured_price":facts.get("structured_price"),
        "structured_currency":facts.get("structured_currency"),
        "noindex":facts.get("noindex"),
        "intended_indexable_commercial":True if facts.get("direct_purchase_signal") or facts.get("has_product_schema") else None,
        "recurring":facts.get("subscription_signal"),
        "cadence_visible":facts.get("cadence_visible"),
        "auto_renew_visible":facts.get("auto_renew_signal"),
        "cancel_method_visible":facts.get("cancel_signal"),
        "promo_to_standard":facts.get("promo_to_standard"),
        "intro_price_visible":facts.get("intro_price") is not None,
        "standard_price_visible":facts.get("standard_price") is not None,
        "trial_to_paid":facts.get("trial_days") is not None,
        "trial_length_visible":facts.get("trial_days") is not None,
        "post_trial_amount_visible":facts.get("standard_price") is not None,
        "auto_conversion_visible":facts.get("auto_renew_signal"),
    }
    # Keys whose applicability itself is unknown are omitted so coordinator returns CONTEXT_INSUFFICIENT.
    return {k:v for k,v in state.items() if v is not None}
