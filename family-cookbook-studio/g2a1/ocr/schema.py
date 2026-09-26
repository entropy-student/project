"""Minimal provenance-preserving recipe schema probe."""
from __future__ import annotations

import re
from typing import Any

QUANTITY_UNIT = re.compile(r"^(?P<quantity>\d+(?:/\d+|\.\d+)?)\s*(?P<unit>tsp|tbsp|cup|g|ml|°F|°C|min|hr)?\s*(?P<ingredient>.*)$", re.I)


def build_record(fixture_id: str, source_image: str, paddle_lines: list[dict[str, Any]], expected_title: str = "") -> dict[str, Any]:
    # A separate immutable source text value is retained; normalization never writes into raw_ocr.
    raw_ocr = "\n".join(str(line.get("text", "")) for line in paddle_lines)
    normalized = raw_ocr.replace("\r\n", "\n").replace("\r", "\n").strip()
    ingredients, steps, notes, temperatures, timing, uncertainties = [], [], [], [], [], []
    title = None
    section = "unknown"
    for index, line in enumerate(paddle_lines):
        original = str(line.get("text", ""))
        text = original.strip()
        folded = text.casefold()
        span = {"line_index": index, "bbox": line.get("bbox")}
        if folded.startswith("recipe:"):
            title = text.split(":", 1)[1].strip() or None
            if expected_title and title != expected_title:
                uncertainties.append({"field": "title", "line_index": index, "reason": "recognized_title_missing_or_differs_from_fixture_reference"})
            continue
        if folded in {"ingredients", "ingredient"}:
            section = "ingredients"
            continue
        if folded in {"method", "instructions", "directions"}:
            section = "steps"
            continue
        if not text:
            continue
        conf = line.get("confidence")
        for m in re.finditer(r"\b\d{2,3}\s*°\s*[FC]\b", text, re.I):
            temperatures.append({"original_text": m.group(0), "confidence": conf, "source_span": span})
        for m in re.finditer(r"\b\d+\s*(?:min|hr|hours?)\b", text, re.I):
            timing.append({"original_text": m.group(0), "confidence": conf, "source_span": span})
        if section == "ingredients":
            match = QUANTITY_UNIT.match(text)
            quantity = match.group("quantity") if match else None
            unit = match.group("unit") if match else None
            ingredient = match.group("ingredient").strip() if match else None
            ingredients.append({"original_text": original, "quantity": quantity, "unit": unit, "ingredient": ingredient, "confidence": conf, "source_span": span})
            if not quantity or not ingredient or not unit:
                uncertainties.append({"field": "ingredient", "line_index": index, "reason": "quantity_unit_or_ingredient_not_deterministically_parsed"})
        elif section == "steps":
            steps.append({"original_text": original, "normalized_text": text, "confidence": conf, "source_span": span})
        else:
            notes.append({"original_text": original, "confidence": conf, "source_span": span})
        if conf is not None and conf < 0.88:
            uncertainties.append({"field": "line", "line_index": index, "reason": "low_ocr_confidence"})
    return {
        "fixture_id": fixture_id,
        "source_image": source_image,
        "raw_ocr": raw_ocr,
        "normalized_transcription": normalized,
        "recipe_schema": {
            "title": title,
            "source/person": None,
            "ingredients": ingredients,
            "steps": steps,
            "temperature": temperatures,
            "timing": timing,
            "notes": notes
        },
        "uncertainties": uncertainties,
        "corrections": [],
        "approval_state": "USER_CONFIRM_REQUIRED" if uncertainties else "UNREVIEWED"
    }
