"""Deterministic suspicious-line routing. Rules flag risk; they never repair text."""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from typing import Any

LOW_CONFIDENCE = 0.88
CRITICAL_CONFIDENCE = 0.93
UNIT_RE = re.compile(r"\b(?:tsp|teaspoons?|tbsp|tablespoons?|cups?|g|grams?|ml|°[FC]|min(?:utes?)?|hr|hours?)\b", re.I)
FRACTION_RE = re.compile(r"\b\d+\s*/\s*\d+\b")
NUMBER_UNIT_RE = re.compile(r"\b(\d+(?:\.\d+)?|\d+\s*/\s*\d+)\s*(tsp|teaspoons?|tbsp|tablespoons?|cups?|g|grams?|ml)\b", re.I)
TEMP_RE = re.compile(r"\b(\d{2,3})\s*°\s*([FC])\b", re.I)
TIME_RE = re.compile(r"\b(\d+)\s*(min(?:utes?)?|hr|hours?)\b", re.I)
AMBIGUOUS_ABBREV_RE = re.compile(r"\b(?:c\.?|T\.?|t\.?|pkg\.?|scant|heaping)\b", re.I)
NUMBER_AT_END_RE = re.compile(r"\b\d+(?:\.\d+|\s*/\s*\d+)?\s*$")
UNIT_AT_START_RE = re.compile(r"^\s*(?:tsp|teaspoons?|tbsp|tablespoons?|cups?|g|grams?|ml)\b", re.I)


@dataclass
class Route:
    fallback: bool
    reasons: list[str] = field(default_factory=list)
    critical: bool = False


def route_line(line: dict[str, Any]) -> Route:
    text = str(line.get("text", ""))
    confidence = line.get("confidence")
    reasons: list[str] = []
    critical = bool(UNIT_RE.search(text) or TEMP_RE.search(text) or TIME_RE.search(text) or FRACTION_RE.search(text))
    if confidence is not None and confidence < LOW_CONFIDENCE:
        reasons.append("paddle_confidence_below_0.88")
    if critical and confidence is not None and confidence < CRITICAL_CONFIDENCE:
        reasons.append("critical_field_confidence_below_0.93")
    if re.search(r"\b(?:tsp|tbsp)\b", text, re.I):
        reasons.append("tsp_tbsp_confusion_risk")
    if FRACTION_RE.search(text):
        reasons.append("fraction_critical_value_crosscheck")
    if TEMP_RE.search(text):
        reasons.append("temperature_unit_crosscheck")
    if TIME_RE.search(text):
        reasons.append("timing_critical_value_crosscheck")
    for match in NUMBER_UNIT_RE.finditer(text):
        value, unit = match.groups()
        if "/" in value:
            numerator, denominator = (int(part.strip()) for part in value.split("/"))
            if denominator == 0 or numerator >= denominator or numerator > 3 or denominator > 16:
                reasons.append("fraction_outside_common_recipe_range")
        elif unit.lower().startswith(("tsp", "teaspoon", "tbsp", "tablespoon")) and float(value) >= 10:
            reasons.append("two_digit_or_large_spoon_quantity")
    for value, unit in TEMP_RE.findall(text):
        amount = int(value)
        unit = unit.upper()
        if (unit == "C" and amount >= 300) or (unit == "F" and (amount < 100 or amount > 550)):
            reasons.append("temperature_outside_common_oven_range")
    for value, unit in TIME_RE.findall(text):
        amount = int(value)
        if unit.lower().startswith("min") and amount > 60:
            reasons.append("minutes_value_over_60_requires_review")
        if unit.lower().startswith("hr") and amount > 24:
            reasons.append("hours_value_over_24_requires_review")
    if AMBIGUOUS_ABBREV_RE.search(text):
        reasons.append("ambiguous_recipe_abbreviation")
    if line.get("quantity_unit_separated") is True:
        reasons.append("quantity_unit_separation_failed")
    if line.get("missing_critical_field") is True:
        reasons.append("expected_critical_field_missing")
    if line.get("structure_mismatch") is True:
        reasons.append("recipe_section_structure_mismatch")
    # Preserve rule identity/order while suppressing duplicate hits from one line.
    reasons = list(dict.fromkeys(reasons))
    return Route(bool(reasons), reasons, critical)


def route_page(lines: list[dict[str, Any]]) -> list[Route]:
    routes = [route_line(line) for line in lines]
    for index in range(len(lines) - 1):
        if NUMBER_AT_END_RE.search(str(lines[index].get("text", ""))) and UNIT_AT_START_RE.search(str(lines[index + 1].get("text", ""))):
            for route in (routes[index], routes[index + 1]):
                route.fallback = True
                route.critical = True
                route.reasons.append("quantity_unit_separation_failed")
                route.reasons = list(dict.fromkeys(route.reasons))
    return routes


def detect_page_structure(lines: list[dict[str, Any]]) -> list[dict[str, Any]]:
    text = "\n".join(str(line.get("text", "")) for line in lines)
    issues = []
    if not re.search(r"\bingredients?\b", text, re.I):
        issues.append({"rule": "missing_ingredients_section", "critical": True})
    if not re.search(r"\b(?:method|instructions?|directions?)\b", text, re.I):
        issues.append({"rule": "missing_instructions_section", "critical": True})
    ingredient_lines = [x for x in lines if NUMBER_UNIT_RE.search(str(x.get("text", "")))]
    if len(ingredient_lines) < 2:
        issues.append({"rule": "recipe_layout_has_fewer_than_two_quantity_unit_lines", "critical": True})
    return issues


def resolve_fallback(paddle_text: str, trocr_text: str | None, reason_for_fallback: list[str]) -> dict[str, Any]:
    if not trocr_text:
        return {"resolved": False, "USER_CONFIRM_REQUIRED": True, "reason": "empty_trocr_result"}
    norm = lambda s: re.sub(r"\s+", " ", s).strip().casefold()
    if norm(paddle_text) != norm(trocr_text):
        return {"resolved": False, "USER_CONFIRM_REQUIRED": True, "reason": "engine_disagreement"}
    residual = route_line({"text": trocr_text, "confidence": None})
    # Independent agreement resolves routing-only cross-check reasons, while
    # impossible values/rule hits still fail closed.
    crosscheck_only = {"tsp_tbsp_confusion_risk", "fraction_critical_value_crosscheck", "temperature_unit_crosscheck", "timing_critical_value_crosscheck"}
    residual.reasons = [r for r in residual.reasons if r not in crosscheck_only]
    residual.fallback = bool(residual.reasons)
    if residual.fallback:
        return {"resolved": False, "USER_CONFIRM_REQUIRED": True, "reason": "critical_rule_still_suspicious"}
    return {"resolved": True, "USER_CONFIRM_REQUIRED": False, "reason": "two_engine_agreement_no_residual_rule"}
