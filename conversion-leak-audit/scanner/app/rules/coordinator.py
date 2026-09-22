from __future__ import annotations
from dataclasses import asdict
from typing import Any
from .engine import evaluate

# Missing input must never silently become an ISSUE. These are minimum fact gates before calling each frozen rule.
REQUIRED = {
    "GATE-001": {"http_status", "dom_complete"},
    "GATE-002": {"final_url", "region", "currency", "viewport", "timestamp"},
    "CORE-001": {"core_page", "http_status"},
    "CORE-002": {"direct_purchase", "in_stock", "cta_present", "cta_action_success"},
    "CORE-003": {"mobile_context", "blocking_overlay", "horizontal_overflow_blocks_task"},
    "CORE-004": {"key_form", "accessible_name"},
    "CORE-006": {"core_internal_link", "target_status"},
    "CORE-007": {"direct_purchase", "quote_based", "price_visible"},
    "CORE-009": {"intended_indexable_commercial", "noindex"},
    "CORE-010": {"product_page", "visible_price", "visible_currency", "structured_price", "structured_currency"},
    "PHYS-001": {"physical", "return_proximity"},
    "PHYS-002": {"physical", "shipping_cost_known", "shipping_timing_known"},
    "SUB-001": {"promo_to_standard", "intro_price_visible", "standard_price_visible"},
    "SUB-002": {"recurring", "cadence_visible"},
    "SUB-003": {"recurring", "auto_renew_visible"},
    "SUB-004": {"trial_to_paid", "trial_length_visible", "post_trial_amount_visible", "auto_conversion_visible"},
    "SUB-005": {"recurring", "cancel_method_visible"},
}


def evaluate_if_ready(rule_id: str, state: dict[str, Any]) -> dict[str, Any]:
    missing = sorted(k for k in REQUIRED[rule_id] if k not in state or state[k] is None)
    if missing:
        return {
            "rule_id": rule_id,
            "result": "CONTEXT_INSUFFICIENT",
            "message": "必要事实不足",
            "confidence": "LOW",
            "evidence_level": "L0",
            "missing": missing,
        }
    return asdict(evaluate(rule_id, state))
