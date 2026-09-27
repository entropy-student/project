"""Bounded Google-first / Mistral-second OCR fallback benchmark for the 11 accepted R3A crops."""
from __future__ import annotations

import base64
import hashlib
import io
import json
import math
import os
import platform
import re
import shutil
import sys
import time
import unicodedata
import urllib.request
from difflib import SequenceMatcher
from fractions import Fraction
from pathlib import Path
from urllib.parse import quote

import requests
from PIL import Image
from google.auth.transport.requests import Request
from google.oauth2 import service_account

ROOT = Path(__file__).resolve().parents[3]
R3A = ROOT / "family-cookbook-studio" / "g2a1" / "r3a"
ART = Path(os.environ.get("G2A1_R3B_ARTIFACT_DIR", "artifacts")).resolve()
DATA = Path(os.environ.get("G2A1_R3B_DATA_DIR", "runtime-data")).resolve()
FALLBACK = json.loads((R3A / "fallback-evaluation-set.json").read_text(encoding="utf-8"))
CORPUS = json.loads((R3A / "corpus.json").read_text(encoding="utf-8"))
SOURCES = json.loads((R3A / "genuine-handwriting-sources.json").read_text(encoding="utf-8"))
BURDEN = json.loads((R3A / "review-burden.json").read_text(encoding="utf-8"))
PP_ROWS = {x["sample_id"]: x for x in BURDEN["PP-OCRv6_medium"]["genuine_handwriting_review"]["review_payloads"]}
CORPUS_ROWS = {x["sample_id"]: x for x in CORPUS["genuine_handwriting"]}
SOURCE_ROWS = {x["source_id"]: x for x in SOURCES["sources"]}
SAMPLES = FALLBACK.get("samples", [])
EXPECTED_COUNT = 11
GOOGLE_RATE = 1.50
MISTRAL_RATE = 4.00
COST_CAP = 0.20
QTY = re.compile(r"(?<![A-Za-z])(\d+\s*/\s*\d+|[¼½¾⅓⅔]|\d+(?:\.\d+)?)\s*(tsp|tbsp|teaspoons?|tablespoons?|cups?|c\b|can\b|g\b|ml\b|kg\b|lb\b|lbs\b)", re.I)
TEMP = re.compile(r"(?<!\d)(\d+(?:\.\d+)?)\s*°?\s*([FC])\b", re.I)
TIME = re.compile(r"(?<!\d)(\d+(?:\.\d+)?)\s*(minutes?|mins?|min|hours?|hrs?|hr)\b", re.I)
COUNT = re.compile(r"(?<![A-Za-z])(\d+)\s+(eggs?|pears?|onions?|lemons?|apples?)\b", re.I)
FOOD = set("almond almonds apple apples bean beans berry berries butter carrot carrots cardamom cinnamon chicken cornmeal cream dill egg eggs flour garlic ginger honey milk noodle noodles oil onion onions orange oranges pasta pear pears pepper plum plums potato potatoes raisin raisins rice salt stock sugar squash tomato tomatoes vanilla vinegar water yeast".split())


def write_json(name, value):
    ART.mkdir(parents=True, exist_ok=True)
    (ART / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def meminfo():
    result = {}
    try:
        for line in Path("/proc/meminfo").read_text().splitlines():
            key, value = line.split(":", 1)
            if key in {"MemTotal", "MemAvailable", "SwapTotal", "SwapFree"}:
                result[key] = int(value.strip().split()[0]) * 1024
    except Exception:
        pass
    return result


def runner_facts():
    disk = shutil.disk_usage("/")
    cpu = "unknown"
    try:
        for line in Path("/proc/cpuinfo").read_text().splitlines():
            if line.lower().startswith("model name"):
                cpu = line.split(":", 1)[1].strip()
                break
    except Exception:
        pass
    return {
        "os": platform.platform(),
        "runner_name": os.getenv("RUNNER_NAME"),
        "image_os": os.getenv("ImageOS"),
        "image_version": os.getenv("ImageVersion"),
        "architecture": platform.machine(),
        "cpu_model": cpu,
        "logical_processors": os.cpu_count(),
        "ram_bytes": meminfo(),
        "root_disk_total_bytes": disk.total,
        "root_disk_free_bytes": disk.free,
        "gpu": "not used; hosted Ubuntu CPU-only API client",
        "python": sys.version,
    }


def canon(value):
    value = unicodedata.normalize("NFC", str(value)).casefold().replace("’", "'")
    return re.sub(r"[^a-z0-9¼½¾⅓⅔°]+", " ", value).strip()


def number(raw):
    try:
        if "/" in raw:
            return float(Fraction(raw.replace(" ", "")))
        return float({"¼": ".25", "½": ".5", "¾": ".75", "⅓": ".3333333333", "⅔": ".6666666667"}.get(raw, raw))
    except Exception:
        return None


def unit(raw):
    return {
        "teaspoon": "tsp", "teaspoons": "tsp", "tablespoon": "tbsp",
        "tablespoons": "tbsp", "cups": "cup", "c": "cup", "kg": "g", "lbs": "lb",
    }.get(raw.casefold(), raw.casefold())


def facts(text):
    found = []
    for match in QTY.finditer(text):
        qty, uom = match.groups()
        tail = text[match.end():].strip(" \t:,-.;")
        ingredient = re.match(r"([A-Za-zÀ-ÿ][A-Za-zÀ-ÿ'-]*)", tail)
        found.append({"kind": "quantity_unit_ingredient", "quantity": number(qty), "unit": unit(uom),
                      "ingredient": ingredient.group(1).casefold() if ingredient else None, "raw": match.group(0)})
    for match in COUNT.finditer(text):
        found.append({"kind": "quantity_unit_ingredient", "quantity": number(match.group(1)),
                      "unit": "count", "ingredient": match.group(2).casefold(), "raw": match.group(0)})
    for match in TEMP.finditer(text):
        found.append({"kind": "temperature", "value": number(match.group(1)), "scale": match.group(2).upper(), "raw": match.group(0)})
    for match in TIME.finditer(text):
        found.append({"kind": "timing", "value": number(match.group(1)),
                      "unit": "hr" if match.group(2).casefold().startswith("h") else "min", "raw": match.group(0)})
    return found


def fact_key(fact):
    fields = ("kind", "quantity", "unit", "ingredient") if fact["kind"] == "quantity_unit_ingredient" else (
        ("kind", "value", "scale") if fact["kind"] == "temperature" else ("kind", "value", "unit"))
    return tuple(fact.get(field) for field in fields)


def levenshtein(left, right):
    if len(left) < len(right):
        left, right = right, left
    previous = list(range(len(right) + 1))
    for i, char in enumerate(left, 1):
        row = [i]
        for j, other in enumerate(right, 1):
            row.append(min(row[-1] + 1, previous[j] + 1, previous[j - 1] + (char != other)))
        previous = row
    return previous[-1]


def align(expected, lines):
    remaining = list(lines)
    matched, missing = [], []
    for index, expected_line in enumerate(expected):
        if not remaining:
            missing.append({"line_index": index, "ground_truth": expected_line})
            continue
        best = max(range(len(remaining)), key=lambda i: SequenceMatcher(None, canon(expected_line), canon(remaining[i].get("text", ""))).ratio())
        row = remaining[best]
        similarity = SequenceMatcher(None, canon(expected_line), canon(row.get("text", ""))).ratio()
        if not canon(row.get("text", "")) or similarity < .30:
            missing.append({"line_index": index, "ground_truth": expected_line})
        else:
            matched.append({"line_index": index, "ground_truth": expected_line, "recognized": row["text"],
                            "confidence": row.get("confidence"), "similarity": round(similarity, 3),
                            "char_edits": levenshtein(canon(expected_line), canon(row["text"]))})
            remaining.pop(best)
    return matched, missing, remaining


def material_text_format(left, right):
    strip = lambda value: re.sub(r"\s+", "", unicodedata.normalize("NFC", value).casefold().replace("°", ""))
    return strip(left) == strip(right)


def make_spec(sample):
    spec = CORPUS_ROWS[sample["sample_id"]]
    primary_row = PP_ROWS[sample["sample_id"]]
    if sample.get("source_reference") != spec.get("source_reference") or sample.get("primary_output") != primary_row.get("recognized_text"):
        raise ValueError("fixed R3A fallback-set provenance mismatch")
    return spec


def validate_corpus():
    if FALLBACK.get("primary") != "PP-OCRv6_medium" or FALLBACK.get("api_called") is not False or len(SAMPLES) != EXPECTED_COUNT:
        raise ValueError("fixed R3A fallback set is not exactly the accepted 11 cases")
    for sample in SAMPLES:
        spec = make_spec(sample)
        if spec.get("sample_class") != "GENUINE_HANDWRITING" or not spec.get("source_id") or spec.get("language") != "English":
            raise ValueError("fallback set contains an unexpected input class")
        if spec["source_id"] not in SOURCE_ROWS:
            raise ValueError("fallback sample source mapping is missing")
    ids = [sample["sample_id"] for sample in SAMPLES]
    if len(set(ids)) != EXPECTED_COUNT:
        raise ValueError("fixed fallback sample IDs are not unique")
    baseline_fields = sum(PP_ROWS[sid]["manual_edit_field_count"] for sid in ids)
    baseline_chars = sum(PP_ROWS[sid]["manual_edit_chars"] for sid in ids)
    if (baseline_fields, baseline_chars) != (13, 69):
        raise ValueError("R3A accepted baseline totals changed; do not score against a drifted set")
    return {"count": EXPECTED_COUNT, "sample_ids": ids, "baseline_fields": baseline_fields, "baseline_chars": baseline_chars}


def crop_inputs():
    DATA.mkdir(parents=True, exist_ok=True)
    source_paths = {}
    source_checks = {}
    for source in SOURCE_ROWS.values():
        target = DATA / (source["source_id"] + ".jpg")
        if not target.exists():
            request = urllib.request.Request(source["image_url"], headers={"User-Agent": "FamilyCookbookStudio-G2A1-R3B/1.0"})
            with urllib.request.urlopen(request, timeout=90) as response:
                target.write_bytes(response.read())
        digest = hashlib.sha1(target.read_bytes()).hexdigest()
        if target.stat().st_size != source["expected_bytes"] or digest != source["expected_sha1"]:
            raise ValueError("public source checksum mismatch: " + source["source_id"])
        source_paths[source["source_id"]] = target
        source_checks[source["source_id"]] = {"bytes": target.stat().st_size, "sha1": digest, "verified": True}
    result = {}
    for sample in SAMPLES:
        spec = make_spec(sample)
        with Image.open(source_paths[spec["source_id"]]) as page:
            crop = page.crop(tuple(spec["crop"]))
            if crop.width < 40 or crop.height < 30:
                raise ValueError("invalid source crop")
            buffer = io.BytesIO()
            crop.save(buffer, format="JPEG", quality=95)
            raw = buffer.getvalue()
        result[sample["sample_id"]] = {
            "bytes": raw,
            "sha256": hashlib.sha256(raw).hexdigest(),
            "size_bytes": len(raw),
            "width": crop.width,
            "height": crop.height,
        }
    return result, source_checks


def google_page_lines(document):
    full_text = document.get("text", "")
    rows, pages = [], []
    for page_index, page in enumerate(document.get("pages", []), 1):
        page_lines = []
        for line in page.get("lines", []):
            layout = line.get("layout", {})
            anchor = layout.get("textAnchor", {})
            parts = anchor.get("textSegments", [])
            text = "".join(full_text[int(part.get("startIndex", 0)):int(part.get("endIndex", 0))] for part in parts)
            if text.strip():
                row = {"text": text.strip(), "confidence": layout.get("confidence"),
                       "bounding_poly": layout.get("boundingPoly")}
                rows.append(row)
                page_lines.append(row)
        pages.append({"page_number": page.get("pageNumber", page_index),
                      "dimension": page.get("dimension"), "lines": page_lines,
                      "paragraphs": [{"text_anchor": p.get("layout", {}).get("textAnchor"),
                                      "confidence": p.get("layout", {}).get("confidence"),
                                      "bounding_poly": p.get("layout", {}).get("boundingPoly")}
                                     for p in page.get("paragraphs", [])]})
    return rows, pages, full_text


def response_fact_confidence(lines, fact):
    digit_lines = [row for row in lines if any(ch.isdigit() for ch in row.get("text", ""))]
    values = [row.get("confidence") for row in digit_lines]
    values = [float(value) for value in values if value is not None]
    return max(values) if values else None


def score_sample(spec, raw_text, lines):
    expected = spec.get("ground_truth_lines") or [spec.get("ground_truth", "")]
    lines = [row for row in lines if row.get("text", "").strip()]
    if not lines and raw_text.strip():
        lines = [{"text": line.strip(), "confidence": None} for line in raw_text.splitlines() if line.strip()]
    pairs, missing, extras = align(expected, lines)
    expected_facts = facts("\n".join(expected))
    actual_facts = facts(raw_text)
    actual_keys = [fact_key(f) for f in actual_facts]
    errors, silent = [], []
    for expected_fact in expected_facts:
        if fact_key(expected_fact) in actual_keys:
            continue
        same_kind = [f for f in actual_facts if f["kind"] == expected_fact["kind"]]
        error = {"expected": expected_fact, "recognized_same_kind": same_kind[:3],
                 "error_type": "missing_" + expected_fact["kind"] if not same_kind else "wrong_" + expected_fact["kind"]}
        errors.append(error)
        confidence = response_fact_confidence(lines, expected_fact)
        if same_kind and (confidence is None or confidence >= .90):
            silent.append({**error, "confidence": confidence})
    expected_food = {word for word in re.findall(r"[a-z]+", canon("\n".join(expected))) if word in FOOD}
    actual_food = {word for word in re.findall(r"[a-z]+", canon(raw_text)) if word in FOOD}
    unsupported_food = sorted(actual_food - expected_food)
    extra_facts = [fact for fact in actual_facts if fact_key(fact) not in [fact_key(x) for x in expected_facts]]
    partial = spec.get("annotation_coverage") == "partial"
    unsupported = []
    unverified = []
    if partial:
        unverified += [{"kind": "unannotated_output_line", "text": row.get("text", "")} for row in extras]
        unverified += [{"kind": "unverified_ingredient", "value": word} for word in unsupported_food]
        unverified += [{"kind": "unverified_critical_fact", "fact": fact} for fact in extra_facts]
    else:
        unsupported += [{"kind": "unsupported_ingredient", "value": word} for word in unsupported_food]
        unsupported += [{"kind": "unsupported_critical_fact", "fact": fact} for fact in extra_facts]
    edits, edit_chars, whole = [], 0, []
    format_only = []
    for pair in pairs:
        if canon(pair["ground_truth"]) == canon(pair["recognized"]):
            continue
        if material_text_format(pair["ground_truth"], pair["recognized"]):
            format_only.append({"ground_truth": pair["ground_truth"], "raw_output": pair["recognized"]})
        else:
            edits.append({"type": "line_text", "line_index": pair["line_index"]})
            edit_chars += pair["char_edits"]
            if pair["similarity"] < .62:
                whole.append(pair["line_index"])
    for row in missing:
        edits.append({"type": "line_text", "line_index": row["line_index"], "missing": True})
        edit_chars += len(canon(row["ground_truth"]))
        whole.append(row["line_index"])
    for error in errors:
        edits.append({"type": error["expected"]["kind"], "critical": True, "expected": error["expected"]})
    correct_facts = [fact for fact in expected_facts if fact_key(fact) in actual_keys]
    critical_field_ids = {fact_key(fact) for fact in expected_facts}
    line_manual = len(edits) - len(errors)
    reupload = (not raw_text.strip()) or len(missing) >= max(1, math.ceil(len(expected) / 2))
    return {
        "sample_id": spec["sample_id"], "raw_output": raw_text, "expected_lines": expected,
        "recognized_lines": lines, "line_pairs": pairs, "missing_lines": missing,
        "unmatched_output_lines": extras, "expected_critical_facts": expected_facts,
        "recognized_critical_facts": actual_facts, "semantic_critical_errors": errors,
        "silent_critical_errors": silent, "unsupported_hallucinations": unsupported,
        "unverified_extra_content": unverified, "manual_edit_fields": edits,
        "manual_edit_field_count": len(edits), "manual_edit_chars": edit_chars,
        "critical_fields_manually_changed": len(errors), "whole_line_retype_count": len(set(whole)),
        "whole_line_retype_required": bool(whole), "reupload_required": reupload,
        "correct_critical_fact_count": len(correct_facts),
        "format_only_observations": format_only,
        "visual_confirm_only_fields": len(correct_facts) + sum(canon(p["ground_truth"]) == canon(p["recognized"]) for p in pairs),
        "annotation_coverage": "partial" if partial else "complete",
    }


def provider_score(provider_rows):
    rows = []
    for sample in SAMPLES:
        source = provider_rows.get(sample["sample_id"])
        if source and source.get("api_status") == 200:
            rows.append(score_sample(make_spec(sample), source["raw_output"], source["recognized_lines"]))
    return {
        "status": "complete" if len(rows) == EXPECTED_COUNT else "incomplete",
        "sample_count": len(rows),
        "semantic_critical_errors": sum(len(row["semantic_critical_errors"]) for row in rows),
        "silent_critical_errors": sum(len(row["silent_critical_errors"]) for row in rows),
        "confirmed_hallucinations": sum(len(row["unsupported_hallucinations"]) for row in rows),
        "missing_critical_fields": sum(1 for row in rows for error in row["semantic_critical_errors"] if error["error_type"].startswith("missing_")),
        "critical_field_errors": sum(len(row["semantic_critical_errors"]) for row in rows),
        "manual_edit_fields": sum(row["manual_edit_field_count"] for row in rows),
        "manual_edit_chars": sum(row["manual_edit_chars"] for row in rows),
        "critical_fields_manually_changed": sum(row["critical_fields_manually_changed"] for row in rows),
        "whole_line_retypes": sum(row["whole_line_retype_count"] for row in rows),
        "reupload_pages": sum(row["reupload_required"] for row in rows),
        "cases_with_zero_manual_edits": sum(row["manual_edit_field_count"] == 0 for row in rows),
        "unverified_partial_content_items": sum(len(row["unverified_extra_content"]) for row in rows),
        "case_results": rows,
    }


def baseline_score():
    rows = {}
    for sample in SAMPLES:
        review = PP_ROWS[sample["sample_id"]]
        spec = make_spec(sample)
        lines = [{"text": line, "confidence": None} for line in review["recognized_text"].splitlines() if line.strip()]
        rows[sample["sample_id"]] = {"api_status": 200, "raw_output": review["recognized_text"], "recognized_lines": lines}
    return provider_score(rows)


def compare_candidate(name, candidate_rows, score):
    baseline = baseline_score()
    base_by_id = {row["sample_id"]: row for row in baseline["case_results"]}
    candidate_by_id = {row["sample_id"]: row for row in score["case_results"]}
    per_sample, improved, worsened = [], [], []
    newly_missing = []
    for sid in [sample["sample_id"] for sample in SAMPLES]:
        old, new = base_by_id.get(sid), candidate_by_id.get(sid)
        if not old or not new:
            continue
        old_keys = {fact_key(x) for x in old["expected_critical_facts"] if fact_key(x) in [fact_key(y) for y in old["recognized_critical_facts"]]}
        new_keys = {fact_key(x) for x in new["expected_critical_facts"] if fact_key(x) in [fact_key(y) for y in new["recognized_critical_facts"]]}
        for fact in new["expected_critical_facts"]:
            if fact_key(fact) in old_keys and fact_key(fact) not in new_keys:
                newly_missing.append({"sample_id": sid, "fact": fact})
        old_metric = (len(old["semantic_critical_errors"]), old["manual_edit_field_count"], old["manual_edit_chars"], old["whole_line_retype_count"])
        new_metric = (len(new["semantic_critical_errors"]), new["manual_edit_field_count"], new["manual_edit_chars"], new["whole_line_retype_count"])
        if new_metric < old_metric:
            improved.append(sid)
        elif new_metric > old_metric:
            worsened.append(sid)
        per_sample.append({"sample_id": sid, "baseline_manual_edit_fields": old["manual_edit_field_count"],
                           "candidate_manual_edit_fields": new["manual_edit_field_count"],
                           "baseline_manual_edit_chars": old["manual_edit_chars"],
                           "candidate_manual_edit_chars": new["manual_edit_chars"],
                           "baseline_critical_errors": len(old["semantic_critical_errors"]),
                           "candidate_critical_errors": len(new["semantic_critical_errors"]),
                           "whole_line_retypes": {"baseline": old["whole_line_retype_count"], "candidate": new["whole_line_retype_count"]},
                           "improved": sid in improved, "worsened": sid in worsened})
    recovered = sum(1 for row in baseline["case_results"] for fact in row["expected_critical_facts"]
                    if fact_key(fact) not in [fact_key(x) for x in row["recognized_critical_facts"]]
                    and fact_key(fact) in [fact_key(x) for c in score["case_results"] if c["sample_id"] == row["sample_id"] for x in c["recognized_critical_facts"]])
    fields_reduction = baseline["manual_edit_fields"] - score["manual_edit_fields"]
    chars_reduction = baseline["manual_edit_chars"] - score["manual_edit_chars"]
    no_fidelity_regression = not newly_missing and score["silent_critical_errors"] == 0 and score["confirmed_hallucinations"] == 0
    critical_material = recovered >= 1 and no_fidelity_regression
    burden_material = (
        fields_reduction >= 4
        and chars_reduction >= 18
        and len(improved) >= 3
        and not worsened
        and no_fidelity_regression
    )
    material = score["status"] == "complete" and (critical_material or burden_material)
    return {
        "candidate": name, "status": score["status"], "baseline_manual_edit_fields": baseline["manual_edit_fields"],
        "candidate_manual_edit_fields": score["manual_edit_fields"],
        "manual_edit_fields_reduced": fields_reduction,
        "baseline_manual_edit_chars": baseline["manual_edit_chars"],
        "candidate_manual_edit_chars": score["manual_edit_chars"],
        "manual_edit_chars_reduced": chars_reduction,
        "baseline_critical_errors": baseline["semantic_critical_errors"],
        "candidate_critical_errors": score["semantic_critical_errors"],
        "critical_facts_recovered": recovered, "newly_missing_previously_correct_facts": newly_missing,
        "new_silent_critical_errors": score["silent_critical_errors"],
        "confirmed_hallucinations": score["confirmed_hallucinations"],
        "unverified_partial_content_items": score["unverified_partial_content_items"],
        "baseline_whole_line_retypes": baseline["whole_line_retypes"],
        "candidate_whole_line_retypes": score["whole_line_retypes"],
        "reupload_pages": score["reupload_pages"], "improved_sample_ids": improved,
        "worsened_sample_ids": worsened, "per_sample": per_sample,
        "materiality_rule": {
            "critical_path": "recover at least one previously missing critical fact, with no newly missing previously correct fact, silent critical error, or confirmed hallucination",
            "review_burden_path": "reduce at least 4 edit fields and 18 edit characters (>=25% of the 69-character baseline) across at least 3 improved cases, with no worsened cases or fidelity regression",
        },
        "material_improvement": material,
        "reason": ("critical fact recovery without fidelity regression" if critical_material else
                   "review burden threshold met without fidelity regression" if burden_material else
                   "no material improvement under the recorded rule or a fidelity regression was detected"),
    }


def google_document_text(document):
    lines, pages, raw_text = google_page_lines(document)
    return lines, pages, raw_text


def run_google(crops, token, project, location, processor_id, version_id):
    root = f"projects/{project}/locations/{location}/processors/{processor_id}"
    api_root = f"https://{location}-documentai.googleapis.com/v1"
    headers = {"Authorization": "Bearer " + token, "Content-Type": "application/json"}
    version_url = api_root + "/" + quote(root + "/processorVersions/" + version_id, safe="/")
    output = {}
    attempted = 0
    for sample in SAMPLES:
        sid = sample["sample_id"]
        image = crops[sid]["bytes"]
        payload = {
            "rawDocument": {"content": base64.b64encode(image).decode("ascii"), "mimeType": "image/jpeg"},
            "processOptions": {"ocrConfig": {"hints": {"languageHints": ["en"]}}},
        }
        started = time.perf_counter()
        attempted += 1
        try:
            response = requests.post(version_url + ":process", headers=headers, json=payload, timeout=(15, 90))
            latency_ms = round((time.perf_counter() - started) * 1000, 2)
            if response.status_code != 200:
                output[sid] = {"api_status": response.status_code, "latency_ms": latency_ms,
                               "raw_output": "", "recognized_lines": [], "layout": [], "error_type": "http_error"}
                break
            document = response.json().get("document", {})
            lines, pages, raw_text = google_document_text(document)
            confidence = [row.get("confidence") for row in lines if row.get("confidence") is not None]
            output[sid] = {
                "sample_id": sid, "source_reference": make_spec(sample).get("source_reference"),
                "ppocrv6_output": sample["primary_output"], "input_crop_sha256": crops[sid]["sha256"],
                "google_raw_output": raw_text, "raw_output": raw_text,
                "google_confidence": {"line_values": confidence, "mean_line_confidence": round(sum(confidence) / len(confidence), 6) if confidence else None},
                "google_bbox_layout": pages, "layout": pages, "recognized_lines": lines,
                "google_latency_ms": latency_ms, "latency_ms": latency_ms,
                "google_api_status": response.status_code, "api_status": response.status_code,
                "google_model": version_id,
                "google_style_info": "not requested; no premium add-on; processor natively supports handwritten text",
            }
        except Exception as error:
            output[sid] = {"sample_id": sid, "api_status": "transport_error",
                           "latency_ms": round((time.perf_counter() - started) * 1000, 2),
                           "raw_output": "", "recognized_lines": [], "layout": [],
                           "error_type": type(error).__name__}
            break
    return {"status": "complete" if len(output) == EXPECTED_COUNT and all(r.get("api_status") == 200 for r in output.values()) else "provider_call_blocked",
            "attempted_pages": attempted, "rows": output, "version_id": version_id}

def run_mistral(crops, api_key):
    output = {}
    attempted = 0
    for sample in SAMPLES:
        sid = sample["sample_id"]
        data_url = "data:image/jpeg;base64," + base64.b64encode(crops[sid]["bytes"]).decode("ascii")
        payload = {
            "model": "mistral-ocr-4-1",
            "document": {"type": "image_url", "image_url": data_url},
            "include_blocks": True,
            "confidence_scores_granularity": "block",
        }
        started = time.perf_counter()
        attempted += 1
        try:
            response = requests.post("https://api.mistral.ai/v1/ocr",
                headers={"Authorization": "Bearer " + api_key, "Content-Type": "application/json"},
                json=payload, timeout=(15, 90))
            elapsed = round((time.perf_counter() - started) * 1000, 2)
            if response.status_code != 200:
                output[sid] = {"api_status": response.status_code, "latency_ms": elapsed,
                               "raw_output": "", "recognized_lines": [], "layout": [], "error_type": "http_error"}
                break
            body = response.json()
            pages = body.get("pages", [])
            raw_text = "\n".join(page.get("markdown", "") for page in pages).strip()
            blocks, lines = [], []
            for page in pages:
                for block in page.get("blocks") or []:
                    content = block.get("content", "")
                    blocks.append({"content": content, "bbox": block.get("bbox"),
                                   "label": block.get("label"), "confidence_scores": block.get("confidence_scores")})
                    lines.extend({"text": line.strip(), "confidence": None} for line in content.splitlines() if line.strip())
            if not lines:
                lines = [{"text": line.strip(), "confidence": None} for line in raw_text.splitlines() if line.strip()]
            confidence = [block.get("confidence_scores") for block in blocks if block.get("confidence_scores") is not None]
            output[sid] = {
                "sample_id": sid, "source_reference": make_spec(sample).get("source_reference"),
                "ppocrv6_output": sample["primary_output"], "google_output": "",
                "input_crop_sha256": crops[sid]["sha256"], "mistral_raw_output": raw_text, "raw_output": raw_text,
                "mistral_confidence": confidence, "mistral_bbox_layout": blocks, "layout": blocks,
                "recognized_lines": lines, "mistral_latency_ms": elapsed, "latency_ms": elapsed,
                "mistral_api_status": response.status_code, "api_status": response.status_code,
                "mistral_model": body.get("model", "mistral-ocr-4-1"),
                "usage_info": body.get("usage_info"),
            }
        except Exception as error:
            output[sid] = {"api_status": "transport_error", "latency_ms": round((time.perf_counter() - started) * 1000, 2),
                           "raw_output": "", "recognized_lines": [], "layout": [], "error_type": type(error).__name__}
            break
    return {"status": "complete" if len(output) == EXPECTED_COUNT and all(r.get("api_status") == 200 for r in output.values()) else "provider_call_blocked",
            "attempted_pages": attempted, "rows": output}


def totals():
    return {
        "baseline_manual_edit_fields": 13, "baseline_manual_edit_chars": 69,
        "baseline_critical_errors": 1, "baseline_whole_line_retypes": 0, "baseline_reupload_pages": 0,
    }


def blocked_outputs(preflight, state, google_called=False, google_tested=False, google_comparison=None, mistral_tested=False):
    if not google_called:
        not_called = [{"sample_id": sample["sample_id"], "source_reference": sample["source_reference"],
                       "ppocrv6_output": sample["primary_output"], "google_api_status": "not_called",
                       "google_raw_output": "", "google_confidence": None, "google_bbox_layout": [],
                       "google_latency_ms": None} for sample in SAMPLES]
        write_json("google-results.json", {"provider": "Google Enterprise Document OCR", "status": "NOT_RUN",
                                           "api_called": False, "sample_count": EXPECTED_COUNT, "samples": not_called})
        write_json("google-comparison.json", google_comparison or {"status": "NOT_RUN", "reason": state, "baseline": totals()})
    elif google_comparison is not None:
        write_json("google-comparison.json", google_comparison)
    elif not (ART / "google-comparison.json").exists():
        write_json("google-comparison.json", {"status": "INCOMPLETE", "reason": state, "baseline": totals()})
    decision = {
        "primary": "PP-OCRv6_medium", "fallback": "UNKNOWN", "selection_status": state,
        "google_tested": google_tested, "google_material_improvement": None,
        "mistral_tested": mistral_tested, "mistral_material_improvement": None,
        **totals(), "final_manual_edit_fields": None, "final_manual_edit_chars": None,
        "final_critical_errors": None, "new_silent_critical_errors": None, "new_hallucinations": None,
        "estimated_api_cost_usd": preflight["cost"].get("estimated_attempted_page_cost_usd", 0.0), "reason": state,
    }
    write_json("final-fallback-decision.json", decision)
    write_json("cost-summary.json", preflight["cost"])
    return decision

def main():
    ART.mkdir(parents=True, exist_ok=True)
    DATA.mkdir(parents=True, exist_ok=True)
    dataset = validate_corpus()
    accepted_baseline = baseline_score()
    if (accepted_baseline["manual_edit_fields"], accepted_baseline["manual_edit_chars"],
        accepted_baseline["semantic_critical_errors"], accepted_baseline["silent_critical_errors"],
        accepted_baseline["confirmed_hallucinations"]) != (13, 69, 1, 0, 0):
        raise ValueError("R3B scorer does not reproduce the accepted R3A hard-set baseline")
    env_names = {
        "google_credentials": bool(os.getenv("GOOGLE_DOC_AI_CREDENTIALS_JSON")),
        "google_project": bool(os.getenv("GOOGLE_CLOUD_PROJECT")),
        "google_location": bool(os.getenv("GOOGLE_DOC_AI_LOCATION")),
        "google_processor_id": bool(os.getenv("GOOGLE_DOC_AI_PROCESSOR_ID")),
        "mistral_api_key": bool(os.getenv("MISTRAL_API_KEY")),
    }
    google_config = all(env_names[key] for key in ("google_credentials", "google_project", "google_location", "google_processor_id"))
    cost = {
        "planned_requests_max": 24,
        "planned_google_ocr_pages_max": EXPECTED_COUNT,
        "planned_mistral_ocr_pages_max_if_google_insufficient": EXPECTED_COUNT,
        "google_list_price_usd_per_1000_pages": GOOGLE_RATE,
        "mistral_ocr_4_1_standard_api_usd_per_1000_pages": MISTRAL_RATE,
        "google_estimated_max_usd": round(EXPECTED_COUNT * GOOGLE_RATE / 1000, 6),
        "mistral_estimated_max_usd": round(EXPECTED_COUNT * MISTRAL_RATE / 1000, 6),
        "estimated_max_total_usd": round(EXPECTED_COUNT * (GOOGLE_RATE + MISTRAL_RATE) / 1000, 6),
        "budget_cap_usd": COST_CAP,
        "budget_guard": round(EXPECTED_COUNT * (GOOGLE_RATE + MISTRAL_RATE) / 1000, 6) <= COST_CAP,
        "method": "Conservative public list price, no free tier/credits applied, one OCR page per crop, no retry; processor metadata GETs are not billable pages.",
        "actual_provider_billing_readback": "UNKNOWN",
        "api_requests_attempted": 0,
        "estimated_attempted_page_cost_usd": 0.0,
    }
    preflight = {
        "gate": "G2A1-R3B",
        "accepted_baseline_reproduced": {"manual_edit_fields": accepted_baseline["manual_edit_fields"], "manual_edit_chars": accepted_baseline["manual_edit_chars"], "critical_errors": accepted_baseline["semantic_critical_errors"], "silent_critical_errors": accepted_baseline["silent_critical_errors"]}, "run_id": os.getenv("GITHUB_RUN_ID"), "run_attempt": os.getenv("GITHUB_RUN_ATTEMPT"),
        "head_sha": os.getenv("GITHUB_SHA"), "runner": runner_facts(), "dataset": dataset,
        "secret_presence_only": env_names, "google_configuration_complete": google_config,
        "mistral_configuration_present": env_names["mistral_api_key"],
        "planned_requests": {"max_total_including_two_google_metadata_gets": cost["planned_requests_max"],
                             "google_ocr_pages": EXPECTED_COUNT, "mistral_ocr_pages_only_if_google_insufficient": EXPECTED_COUNT},
        "cost": cost, "model_api_token_cost": 0,
    }
    write_json("provider-preflight.json", preflight)
    print(json.dumps({"gate": "G2A1-R3B", "run_id": preflight["run_id"], "dataset_count": EXPECTED_COUNT,
                      "google_config_present": google_config, "mistral_config_present": env_names["mistral_api_key"],
                      "planned_max_cost_usd": cost["estimated_max_total_usd"], "token_cost": 0}, sort_keys=True))
    if not cost["budget_guard"]:
        blocked_outputs(preflight, "RETURN_G2A1_R3B_BUDGET_CHECKPOINT_REQUIRED")
        return
    if not env_names["google_credentials"]:
        blocked_outputs(preflight, "RETURN_G2A1_R3B_GOOGLE_CREDENTIAL_REQUIRED")
        return
    if not google_config:
        blocked_outputs(preflight, "RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED")
        return
    try:
        try:
            credential_info = json.loads(os.environ["GOOGLE_DOC_AI_CREDENTIALS_JSON"])
            if not all(credential_info.get(key) for key in ("type", "client_email", "private_key", "token_uri")) or credential_info.get("type") != "service_account":
                blocked_outputs(preflight, "RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED")
                return
            credentials = service_account.Credentials.from_service_account_info(
                credential_info, scopes=["https://www.googleapis.com/auth/cloud-platform"])
            credentials.refresh(Request())
            token = credentials.token
        except Exception:
            blocked_outputs(preflight, "RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED")
            return
        version_parts = os.environ["GOOGLE_DOC_AI_PROCESSOR_ID"]
        if not re.fullmatch(r"[A-Za-z0-9-]+", version_parts):
            blocked_outputs(preflight, "RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED")
            return
        project = os.environ["GOOGLE_CLOUD_PROJECT"]
        location = os.environ["GOOGLE_DOC_AI_LOCATION"]
        if not re.fullmatch(r"[a-z0-9-]+", location) or not re.fullmatch(r"[A-Za-z0-9-]+", project):
            blocked_outputs(preflight, "RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED")
            return
        processor_base = f"projects/{project}/locations/{location}/processors/{version_parts}"
        processor_url = f"https://{location}-documentai.googleapis.com/v1/" + quote(processor_base, safe="/")
        metadata_response = requests.get(processor_url, headers={"Authorization": "Bearer " + token}, timeout=(15, 35))
        preflight["google_processor_metadata_status"] = metadata_response.status_code
        if metadata_response.status_code != 200:
            write_json("provider-preflight.json", preflight)
            blocked_outputs(preflight, "RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED")
            return
        processor = metadata_response.json()
        default_name = processor.get("defaultProcessorVersion", "")
        version_id = default_name.rsplit("/", 1)[-1]
        if processor.get("type") != "OCR_PROCESSOR" or not version_id:
            preflight["google_processor_type_valid"] = processor.get("type") == "OCR_PROCESSOR"
            write_json("provider-preflight.json", preflight)
            blocked_outputs(preflight, "RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED")
            return
        version_name = processor_base + "/processorVersions/" + version_id
        version_url = f"https://{location}-documentai.googleapis.com/v1/" + quote(version_name, safe="/")
        version_response = requests.get(version_url, headers={"Authorization": "Bearer " + token}, timeout=(15, 35))
        preflight["google_processor_version_metadata_status"] = version_response.status_code
        if version_response.status_code != 200 or version_response.json().get("state") != "DEPLOYED":
            write_json("provider-preflight.json", preflight)
            blocked_outputs(preflight, "RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED")
            return
        preflight["google_processor_type"] = "OCR_PROCESSOR"
        preflight["google_processor_version"] = version_id
        preflight["google_handwriting_capability"] = "official Enterprise Document OCR supports handwritten text"
        preflight["google_handwriting_input_hint"] = "No handwriting-specific request hint exists in current v1 OCR config; English language hint used."
        preflight["google_language_hint"] = "en"
        write_json("provider-preflight.json", preflight)
        crops, source_checks = crop_inputs()
        preflight["public_source_integrity"] = source_checks
        preflight["crop_inputs"] = {sid: {k: v for k, v in row.items() if k != "bytes"} for sid, row in crops.items()}
        write_json("provider-preflight.json", preflight)
        google = run_google(crops, token, project, location, version_parts, version_id)
        cost["api_requests_attempted"] = 2 + google["attempted_pages"]
        cost["estimated_attempted_page_cost_usd"] = round(google["attempted_pages"] * GOOGLE_RATE / 1000, 6)
        preflight["cost"] = cost
        preflight["google_runtime_status"] = google["status"]
        preflight["google_version"] = google["version_id"]
        write_json("provider-preflight.json", preflight)
        results = []
        for sample in SAMPLES:
            sid = sample["sample_id"]
            row = google["rows"].get(sid)
            if row is None:
                row = {"api_status": "not_attempted", "raw_output": "", "recognized_lines": [], "layout": []}
            row.update({"sample_id": sid, "source_reference": sample["source_reference"],
                        "ppocrv6_output": sample["primary_output"], "input_crop_sha256": crops[sid]["sha256"],
                        "google_api_status": row.get("api_status"), "google_raw_output": row.get("raw_output", ""),
                        "google_confidence": row.get("google_confidence"), "google_bbox_layout": row.get("layout", []),
                        "google_latency_ms": row.get("latency_ms")})
            if row.get("api_status") == 200:
                scored = score_sample(make_spec(sample), row["raw_output"], row["recognized_lines"])
                baseline = PP_ROWS[sid]
                row["semantic_comparison"] = {
                    "ppocrv6_output": sample["primary_output"], "semantic_critical_errors": scored["semantic_critical_errors"],
                    "missing_critical_fields": [error for error in scored["semantic_critical_errors"] if error["error_type"].startswith("missing_")],
                    "unsupported_hallucinations": scored["unsupported_hallucinations"],
                    "unverified_extra_content": scored["unverified_extra_content"],
                }
                row["manual_edit_comparison"] = {
                    "baseline_manual_edit_fields": baseline["manual_edit_field_count"],
                    "google_manual_edit_fields": scored["manual_edit_field_count"],
                    "baseline_manual_edit_chars": baseline["manual_edit_chars"],
                    "google_manual_edit_chars": scored["manual_edit_chars"],
                    "whole_line_retype": scored["whole_line_retype_required"],
                    "reupload_required": scored["reupload_required"],
                }
                row["review_score"] = scored
            results.append(row)
        google_result = {"provider": "Google Enterprise Document OCR", "model": google["version_id"],
                         "status": google["status"], "api_called": google["attempted_pages"] > 0,
                         "request_count_attempted": google["attempted_pages"], "sample_count": len(results), "samples": results}
        write_json("google-results.json", google_result)
        if google["status"] != "complete":
            decision = blocked_outputs(preflight, "RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED", True, False)
            cost["api_requests_attempted"] = 2 + google["attempted_pages"]
            cost["estimated_attempted_page_cost_usd"] = round(google["attempted_pages"] * GOOGLE_RATE / 1000, 6)
            decision["estimated_api_cost_usd"] = cost["estimated_attempted_page_cost_usd"]
            write_json("final-fallback-decision.json", decision)
            write_json("cost-summary.json", cost)
            return
        google_score = provider_score(google["rows"])
        google_comparison = compare_candidate("GOOGLE_ENTERPRISE_DOCUMENT_OCR", google["rows"], google_score)
        google_comparison["provider_score"] = google_score
        write_json("google-comparison.json", google_comparison)
        google_material = google_comparison["material_improvement"]
        if google_material:
            chosen, chosen_comparison, mistral_tested = "GOOGLE_ENTERPRISE_DOCUMENT_OCR", google_comparison, False
        elif not env_names["mistral_api_key"]:
            blocked_outputs(preflight, "RETURN_G2A1_R3B_MISTRAL_CREDENTIAL_REQUIRED", True, True, google_comparison, False)
            decision = json.loads((ART / "final-fallback-decision.json").read_text(encoding="utf-8"))
            decision.update({"google_material_improvement": False, "mistral_tested": False,
                             "final_manual_edit_fields": google_score["manual_edit_fields"],
                             "final_manual_edit_chars": google_score["manual_edit_chars"],
                             "final_critical_errors": google_score["semantic_critical_errors"],
                             "new_silent_critical_errors": google_score["silent_critical_errors"],
                             "new_hallucinations": google_score["confirmed_hallucinations"],
                             "estimated_api_cost_usd": round(google["attempted_pages"] * GOOGLE_RATE / 1000, 6)})
            write_json("final-fallback-decision.json", decision)
            cost["api_requests_attempted"] = 2 + google["attempted_pages"]
            cost["estimated_attempted_page_cost_usd"] = round(google["attempted_pages"] * GOOGLE_RATE / 1000, 6)
            write_json("cost-summary.json", cost)
            return
        else:
            mistral = run_mistral(crops, os.environ["MISTRAL_API_KEY"])
            cost["api_requests_attempted"] = 2 + google["attempted_pages"] + mistral["attempted_pages"]
            cost["estimated_attempted_page_cost_usd"] = round(
                google["attempted_pages"] * GOOGLE_RATE / 1000 + mistral["attempted_pages"] * MISTRAL_RATE / 1000, 6)
            preflight["cost"] = cost
            preflight["mistral_runtime_status"] = mistral["status"]
            write_json("provider-preflight.json", preflight)
            mistral_records = []
            for sample in SAMPLES:
                sid = sample["sample_id"]
                row = mistral["rows"].get(sid)
                if row is None:
                    row = {"api_status": "not_attempted", "raw_output": "", "recognized_lines": [], "layout": []}
                row.update({"sample_id": sid, "source_reference": sample["source_reference"],
                            "ppocrv6_output": sample["primary_output"], "google_output": google["rows"][sid]["raw_output"],
                            "input_crop_sha256": crops[sid]["sha256"], "mistral_api_status": row.get("api_status"),
                            "mistral_raw_output": row.get("raw_output", ""), "mistral_bbox_layout": row.get("layout", []),
                            "mistral_latency_ms": row.get("latency_ms")})
                if row.get("api_status") == 200:
                    scored = score_sample(make_spec(sample), row["raw_output"], row["recognized_lines"])
                    baseline = PP_ROWS[sid]
                    row["semantic_comparison"] = {
                        "semantic_critical_errors": scored["semantic_critical_errors"],
                        "missing_critical_fields": [error for error in scored["semantic_critical_errors"] if error["error_type"].startswith("missing_")],
                        "unsupported_hallucinations": scored["unsupported_hallucinations"],
                        "unverified_extra_content": scored["unverified_extra_content"],
                    }
                    row["manual_edit_comparison"] = {
                        "baseline_manual_edit_fields": baseline["manual_edit_field_count"],
                        "mistral_manual_edit_fields": scored["manual_edit_field_count"],
                        "baseline_manual_edit_chars": baseline["manual_edit_chars"],
                        "mistral_manual_edit_chars": scored["manual_edit_chars"],
                        "whole_line_retype": scored["whole_line_retype_required"],
                        "reupload_required": scored["reupload_required"],
                    }
                    row["review_score"] = scored
                mistral_records.append(row)
            write_json("mistral-results.json", {"provider": "Mistral OCR 4.1",
                         "model": "mistral-ocr-4-1", "status": mistral["status"],
                         "api_called": mistral["attempted_pages"] > 0,
                         "request_count_attempted": mistral["attempted_pages"], "samples": mistral_records})
            if mistral["status"] != "complete":
                write_json("mistral-comparison.json", {
                    "status": "INCOMPLETE", "provider": "Mistral OCR 4.1",
                    "request_count_attempted": mistral["attempted_pages"],
                    "sample_ids": [sample["sample_id"] for sample in SAMPLES],
                    "reason": "provider call did not complete all 11 fixed inputs; no materiality score claimed",
                })
                decision = blocked_outputs(preflight, "RETURN_G2A1_R3B_ACTIONS_BLOCKED", True, True, google_comparison, True)
                decision["google_material_improvement"] = False
                decision["estimated_api_cost_usd"] = cost["estimated_attempted_page_cost_usd"]
                write_json("final-fallback-decision.json", decision)
                write_json("cost-summary.json", cost)
                return
            mistral_score = provider_score(mistral["rows"])
            mistral_comparison = compare_candidate("MISTRAL_OCR_4_1", mistral["rows"], mistral_score)
            mistral_comparison["google_material_improvement"] = False
            mistral_comparison["google_manual_edit_fields"] = google_score["manual_edit_fields"]
            mistral_comparison["google_manual_edit_chars"] = google_score["manual_edit_chars"]
            mistral_comparison["provider_score"] = mistral_score
            write_json("mistral-comparison.json", mistral_comparison)
            if mistral_comparison["material_improvement"]:
                chosen, chosen_comparison, mistral_tested = "MISTRAL_OCR_4_1", mistral_comparison, True
            else:
                chosen, chosen_comparison, mistral_tested = "NONE", mistral_comparison, True
        decision = {
            "primary": "PP-OCRv6_medium", "fallback": chosen, "selection_status": "complete",
            "google_tested": True, "google_material_improvement": google_material,
            "mistral_tested": mistral_tested,
            "mistral_material_improvement": chosen == "MISTRAL_OCR_4_1" if mistral_tested else None,
            **totals(),
            "final_manual_edit_fields": chosen_comparison["candidate_manual_edit_fields"] if chosen != "NONE" else baseline_score()["manual_edit_fields"],
            "final_manual_edit_chars": chosen_comparison["candidate_manual_edit_chars"] if chosen != "NONE" else baseline_score()["manual_edit_chars"],
            "final_critical_errors": chosen_comparison["candidate_critical_errors"] if chosen != "NONE" else baseline_score()["semantic_critical_errors"],
            "new_silent_critical_errors": chosen_comparison["new_silent_critical_errors"] if chosen != "NONE" else 0,
            "new_hallucinations": chosen_comparison["confirmed_hallucinations"] if chosen != "NONE" else 0,
            "estimated_api_cost_usd": cost["estimated_attempted_page_cost_usd"],
            "reason": chosen_comparison["reason"] if chosen != "NONE" else
                      "Google was insufficient and Mistral did not materially improve the 11 hard cases without added fidelity risk.",
        }
        write_json("final-fallback-decision.json", decision)
        write_json("cost-summary.json", cost)
        print(json.dumps({"execution_status": "complete", "fallback": chosen,
                          "google_material_improvement": google_material, "mistral_tested": mistral_tested,
                          "final_manual_edit_fields": decision["final_manual_edit_fields"],
                          "final_manual_edit_chars": decision["final_manual_edit_chars"],
                          "estimated_api_cost_usd": decision["estimated_api_cost_usd"]}, sort_keys=True))
    except Exception as error:
        # Do not print exception strings: auth/provider internals can include request metadata.
        preflight["execution_error_type"] = type(error).__name__
        write_json("provider-preflight.json", preflight)
        state = "RETURN_G2A1_R3B_ACTIONS_BLOCKED"
        blocked_outputs(preflight, state)
        print(json.dumps({"execution_status": state, "error_type": type(error).__name__}, sort_keys=True))
        raise SystemExit(1)


if __name__ == "__main__":
    main()
