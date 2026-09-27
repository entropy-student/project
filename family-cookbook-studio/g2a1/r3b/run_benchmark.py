"""Google-first, 11-case R3B OCR fallback benchmark; never prints or persists credentials."""
from __future__ import annotations

import base64
import hashlib
import importlib.metadata
import importlib.util
import io
import json
import os
import platform
import re
import shutil
import sys
import time
import urllib.request
from pathlib import Path
from urllib.parse import quote

import requests
from PIL import Image
from google.auth.transport.requests import Request
import google.auth

ROOT = Path(__file__).resolve().parents[3]
R3A = ROOT / "family-cookbook-studio" / "g2a1" / "r3a"
ART = Path(os.environ["G2A1_R3B_ARTIFACT_DIR"])
DATA = Path(os.environ["G2A1_R3B_DATA_DIR"])
FALLBACK = json.loads((R3A / "fallback-evaluation-set.json").read_text(encoding="utf-8"))
CORPUS = json.loads((R3A / "corpus.json").read_text(encoding="utf-8"))
SOURCE_META = json.loads((R3A / "genuine-handwriting-sources.json").read_text(encoding="utf-8"))
BASELINE_REVIEW = json.loads((R3A / "review-burden.json").read_text(encoding="utf-8"))
SAMPLES = FALLBACK["samples"]
SPECS = {row["sample_id"]: row for row in CORPUS["genuine_handwriting"]}
SOURCES = {row["source_id"]: row for row in SOURCE_META["sources"]}
BASELINE_ROWS = {row["sample_id"]: row for row in BASELINE_REVIEW["PP-OCRv6_medium"]["genuine_handwriting_review"]["review_payloads"]}
EXPECTED_COUNT = 11
GOOGLE_RATE = 1.50
MISTRAL_RATE = 4.00
COST_CAP = 0.20


def write_json(name, value):
    ART.mkdir(parents=True, exist_ok=True)
    (ART / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def runner_facts():
    mem = {}
    try:
        for row in Path("/proc/meminfo").read_text().splitlines():
            key, value = row.split(":", 1)
            if key in {"MemTotal", "MemAvailable", "SwapTotal", "SwapFree"}:
                mem[key] = int(value.strip().split()[0]) * 1024
    except Exception:
        pass
    cpu, disk = "unknown", shutil.disk_usage("/")
    try:
        for row in Path("/proc/cpuinfo").read_text().splitlines():
            if row.lower().startswith("model name"):
                cpu = row.split(":", 1)[1].strip()
                break
    except Exception:
        pass
    versions = {}
    for package in ("google-auth", "requests", "Pillow"):
        try:
            versions[package] = importlib.metadata.version(package)
        except Exception:
            versions[package] = "UNKNOWN"
    return {
        "os": platform.platform(), "runner_name": os.getenv("RUNNER_NAME"),
        "image_os": os.getenv("ImageOS"), "image_version": os.getenv("ImageVersion"),
        "architecture": platform.machine(), "cpu_model": cpu, "logical_processors": os.cpu_count(),
        "ram_bytes": mem, "root_disk_total_bytes": disk.total, "root_disk_free_bytes": disk.free,
        "gpu": "not used; API client only", "python": sys.version, "packages": versions,
    }


def validate_inputs():
    ids = [row["sample_id"] for row in SAMPLES]
    if FALLBACK.get("primary") != "PP-OCRv6_medium" or FALLBACK.get("api_called") is not False:
        raise ValueError("R3A fallback set is not the accepted PP-OCRv6 set")
    if len(ids) != EXPECTED_COUNT or len(set(ids)) != EXPECTED_COUNT:
        raise ValueError("R3A fallback set must contain exactly 11 unique samples")
    for sample in SAMPLES:
        spec = SPECS[sample["sample_id"]]
        baseline = BASELINE_ROWS[sample["sample_id"]]
        if (spec.get("sample_class") != "GENUINE_HANDWRITING"
                or spec.get("language") != "English"
                or spec.get("source_id") not in SOURCES
                or spec.get("source_reference") != sample.get("source_reference")
                or baseline.get("recognized_text") != sample.get("primary_output")):
            raise ValueError("fixed sample provenance or PP-OCRv6 output mismatch")
    edit_fields = sum(BASELINE_ROWS[sid]["manual_edit_field_count"] for sid in ids)
    edit_chars = sum(BASELINE_ROWS[sid]["manual_edit_chars"] for sid in ids)
    if (edit_fields, edit_chars) != (13, 69):
        raise ValueError("accepted R3A hard-set edit baseline changed")
    return {"count": EXPECTED_COUNT, "sample_ids": ids, "baseline_manual_edit_fields": edit_fields,
            "baseline_manual_edit_chars": edit_chars}


def prepare_crops():
    DATA.mkdir(parents=True, exist_ok=True)
    images, source_checks = {}, {}
    for source in SOURCES.values():
        path = DATA / (source["source_id"] + ".jpg")
        if not path.exists():
            request = urllib.request.Request(source["image_url"], headers={"User-Agent": "FamilyCookbookStudio-G2A1-R3B/1.0"})
            with urllib.request.urlopen(request, timeout=90) as response:
                path.write_bytes(response.read())
        raw = path.read_bytes()
        digest = hashlib.sha1(raw).hexdigest()
        if len(raw) != source["expected_bytes"] or digest != source["expected_sha1"]:
            raise ValueError("public source checksum mismatch")
        images[source["source_id"]] = path
        source_checks[source["source_id"]] = {"bytes": len(raw), "sha1": digest, "verified": True}
    crops = {}
    for sample in SAMPLES:
        spec = SPECS[sample["sample_id"]]
        with Image.open(images[spec["source_id"]]) as page:
            crop = page.crop(tuple(spec["crop"]))
            buffer = io.BytesIO()
            crop.save(buffer, format="JPEG", quality=95)
            raw = buffer.getvalue()
        crops[sample["sample_id"]] = {
            "bytes": raw, "sha256": hashlib.sha256(raw).hexdigest(), "bytes_count": len(raw),
            "width": crop.width, "height": crop.height,
        }
    return crops, source_checks


def load_r3a_scorer():
    # Reuse the accepted semantic/edit scorer; only its input manifest lives in RUNNER_TEMP.
    (DATA / "prepared-corpus.json").write_text(
        json.dumps({"samples": [SPECS[row["sample_id"]] for row in SAMPLES]}, ensure_ascii=False),
        encoding="utf-8",
    )
    os.environ["G2A1_R3A_ARTIFACT_DIR"] = str(DATA)
    path = R3A / "score_benchmark.py"
    spec = importlib.util.spec_from_file_location("family_cookbook_r3a_scorer", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def score_rows(scorer, provider_rows):
    assessments = []
    for sample in SAMPLES:
        row = provider_rows.get(sample["sample_id"])
        if not row or row.get("api_status") != 200:
            continue
        assessment = scorer.assess(SPECS[sample["sample_id"]], {
            "raw_output": row.get("raw_output", ""), "lines": row.get("recognized_lines", []),
        })
        assessments.append(assessment)
    return assessments


def summarize(assessments):
    return {
        "status": "complete" if len(assessments) == EXPECTED_COUNT else "incomplete",
        "sample_count": len(assessments),
        "critical_field_errors": sum(len(row["semantic_critical_errors"]) for row in assessments),
        "missing_critical_fields": sum(
            1 for row in assessments for error in row["semantic_critical_errors"]
            if error["error_type"].startswith("missing_")
        ),
        "silent_critical_errors": sum(len(row["silent_critical_errors"]) for row in assessments),
        "confirmed_hallucinations": sum(len(row["unsupported_hallucinations"]) for row in assessments),
        "unverified_partial_content_items": sum(len(row.get("unverified_extra_content", [])) for row in assessments),
        "manual_edit_fields": sum(row["manual_edit_field_count"] for row in assessments),
        "manual_edit_chars": sum(row["manual_edit_chars"] for row in assessments),
        "critical_fields_manually_changed": sum(row["critical_fields_manually_changed"] for row in assessments),
        "whole_line_retypes": sum(row["whole_line_retype_count"] for row in assessments),
        "reupload_pages": sum(row["reupload_required"] for row in assessments),
        "cases_with_zero_edits": sum(row["manual_edit_field_count"] == 0 for row in assessments),
        "case_results": assessments,
    }


def baseline(scorer):
    rows = {}
    for sample in SAMPLES:
        review = BASELINE_ROWS[sample["sample_id"]]
        rows[sample["sample_id"]] = {
            "api_status": 200, "raw_output": review["recognized_text"],
            "recognized_lines": [{"text": line, "confidence": None} for line in review["recognized_text"].splitlines() if line.strip()],
        }
    return summarize(score_rows(scorer, rows))


def compare(provider, candidate_summary, baseline_summary):
    old_rows = {row["sample_id"]: row for row in baseline_summary["case_results"]}
    new_rows = {row["sample_id"]: row for row in candidate_summary["case_results"]}
    improved, worsened, per_sample, newly_missing, recovered = [], [], [], [], 0
    for sample in SAMPLES:
        sid = sample["sample_id"]
        old, new = old_rows[sid], new_rows.get(sid)
        if new is None:
            continue
        old_facts = {scorer_key(f) for f in old["recognized_critical_facts"]}
        new_facts = {scorer_key(f) for f in new["recognized_critical_facts"]}
        for fact in new["expected_critical_facts"]:
            key = scorer_key(fact)
            if key in old_facts and key not in new_facts:
                newly_missing.append({"sample_id": sid, "fact": fact})
            if key not in old_facts and key in new_facts:
                recovered += 1
        old_metric = (len(old["semantic_critical_errors"]), old["manual_edit_field_count"],
                      old["manual_edit_chars"], old["whole_line_retype_count"])
        new_metric = (len(new["semantic_critical_errors"]), new["manual_edit_field_count"],
                      new["manual_edit_chars"], new["whole_line_retype_count"])
        if new_metric < old_metric:
            improved.append(sid)
        elif new_metric > old_metric:
            worsened.append(sid)
        per_sample.append({
            "sample_id": sid, "baseline_manual_edit_fields": old["manual_edit_field_count"],
            "candidate_manual_edit_fields": new["manual_edit_field_count"],
            "baseline_manual_edit_chars": old["manual_edit_chars"],
            "candidate_manual_edit_chars": new["manual_edit_chars"],
            "baseline_critical_errors": len(old["semantic_critical_errors"]),
            "candidate_critical_errors": len(new["semantic_critical_errors"]),
            "baseline_unverified_partial_content": len(old.get("unverified_extra_content", [])),
            "candidate_unverified_partial_content": len(new.get("unverified_extra_content", [])),
            "whole_line_retypes": {"baseline": old["whole_line_retype_count"], "candidate": new["whole_line_retype_count"]},
            "improved": sid in improved, "worsened": sid in worsened,
        })
    fields_reduced = baseline_summary["manual_edit_fields"] - candidate_summary["manual_edit_fields"]
    chars_reduced = baseline_summary["manual_edit_chars"] - candidate_summary["manual_edit_chars"]
    unverified_increase = max(0, candidate_summary["unverified_partial_content_items"] - baseline_summary["unverified_partial_content_items"])
    safe = (not newly_missing and candidate_summary["silent_critical_errors"] == 0
            and candidate_summary["confirmed_hallucinations"] == 0 and unverified_increase == 0)
    critical_path = (recovered >= 1
                     and candidate_summary["critical_field_errors"] < baseline_summary["critical_field_errors"]
                     and safe)
    edit_path = (fields_reduced >= 4 and chars_reduced >= 18 and len(improved) >= 3
                 and not worsened and safe)
    return {
        "provider": provider, "status": candidate_summary["status"], "baseline": {k: baseline_summary[k] for k in
            ("manual_edit_fields", "manual_edit_chars", "critical_field_errors", "missing_critical_fields", "silent_critical_errors", "confirmed_hallucinations", "unverified_partial_content_items", "whole_line_retypes", "reupload_pages")},
        "candidate": {k: candidate_summary[k] for k in
            ("manual_edit_fields", "manual_edit_chars", "critical_field_errors", "missing_critical_fields", "silent_critical_errors", "confirmed_hallucinations", "unverified_partial_content_items", "whole_line_retypes", "reupload_pages", "cases_with_zero_edits")},
        "manual_edit_fields_reduced": fields_reduced, "manual_edit_chars_reduced": chars_reduced,
        "critical_facts_recovered": recovered, "newly_missing_previously_correct_facts": newly_missing,
        "new_silent_critical_errors": candidate_summary["silent_critical_errors"],
        "new_hallucinations": candidate_summary["confirmed_hallucinations"],
        "unverified_partial_content_increase": unverified_increase,
        "improved_sample_ids": improved, "worsened_sample_ids": worsened, "per_sample": per_sample,
        "materiality_rule": {
            "critical_path": "recover at least one previously missing critical fact and reduce total critical errors, with no missing previously correct fact, silent critical error, confirmed hallucination, or increase in unverified partial-annotation content",
            "review_burden_path": "reduce >=4 edit fields and >=18 of 69 edit characters across >=3 improved cases, with no worsened cases or fidelity regression",
        },
        "material_improvement": candidate_summary["status"] == "complete" and (critical_path or edit_path),
        "reason": "critical fact recovery without fidelity regression" if critical_path else
                  "review burden threshold met without fidelity regression" if edit_path else
                  "no material improvement under the recorded rule or fidelity regression detected",
    }


def scorer_key(fact):
    if fact["kind"] == "quantity_unit_ingredient":
        fields = ("kind", "quantity", "unit", "ingredient")
    elif fact["kind"] == "temperature":
        fields = ("kind", "value", "scale")
    else:
        fields = ("kind", "value", "unit")
    return tuple(fact.get(field) for field in fields)


def google_text_and_layout(document):
    full_text = document.get("text", "")
    all_lines, pages = [], []
    for index, page in enumerate(document.get("pages", []), 1):
        page_lines = []
        for line in page.get("lines", []):
            layout = line.get("layout", {})
            text = "".join(full_text[int(seg.get("startIndex", 0)):int(seg.get("endIndex", 0))]
                           for seg in layout.get("textAnchor", {}).get("textSegments", []))
            if text.strip():
                row = {"text": text.strip(), "confidence": layout.get("confidence"),
                       "bounding_poly": layout.get("boundingPoly")}
                all_lines.append(row)
                page_lines.append(row)
        pages.append({
            "page_number": page.get("pageNumber", index), "dimension": page.get("dimension"),
            "lines": page_lines,
            "paragraphs": [{"text_anchor": p.get("layout", {}).get("textAnchor"),
                            "confidence": p.get("layout", {}).get("confidence"),
                            "bounding_poly": p.get("layout", {}).get("boundingPoly")}
                           for p in page.get("paragraphs", [])],
        })
    if not all_lines:
        all_lines = [{"text": line.strip(), "confidence": None} for line in full_text.splitlines() if line.strip()]
    return full_text, all_lines, pages


def google_process(crops, token, project, location, processor_id, version_id):
    resource = f"projects/{project}/locations/{location}/processors/{processor_id}/processorVersions/{version_id}"
    url = f"https://{location}-documentai.googleapis.com/v1/" + quote(resource, safe="/") + ":process"
    headers = {"Authorization": "Bearer " + token, "Content-Type": "application/json"}
    rows, attempted = {}, 0
    for sample in SAMPLES:
        sid = sample["sample_id"]
        payload = {
            "rawDocument": {"content": base64.b64encode(crops[sid]["bytes"]).decode("ascii"), "mimeType": "image/jpeg"},
            "processOptions": {"ocrConfig": {"hints": {"languageHints": ["en"]}}},
        }
        start = time.perf_counter()
        attempted += 1
        try:
            response = requests.post(url, headers=headers, json=payload, timeout=(15, 90))
            elapsed = round((time.perf_counter() - start) * 1000, 2)
            if response.status_code != 200:
                rows[sid] = {"api_status": response.status_code, "latency_ms": elapsed,
                             "raw_output": "", "recognized_lines": [], "layout": [], "error_type": "http_error"}
                break
            document = response.json().get("document", {})
            raw, lines, pages = google_text_and_layout(document)
            confidence = [line["confidence"] for line in lines if line.get("confidence") is not None]
            rows[sid] = {
                "api_status": 200, "raw_output": raw, "google_raw_output": raw,
                "recognized_lines": lines, "layout": pages, "google_bbox_layout": pages,
                "google_confidence": {"line_values": confidence,
                                      "mean_line_confidence": round(sum(confidence) / len(confidence), 6) if confidence else None},
                "latency_ms": elapsed, "google_latency_ms": elapsed, "google_model": version_id,
            }
        except Exception as error:
            rows[sid] = {"api_status": "transport_error", "latency_ms": round((time.perf_counter() - start) * 1000, 2),
                         "raw_output": "", "recognized_lines": [], "layout": [], "error_type": type(error).__name__}
            break
    return {"status": "complete" if len(rows) == EXPECTED_COUNT and all(r["api_status"] == 200 for r in rows.values()) else "provider_call_blocked",
            "rows": rows, "attempted_pages": attempted, "model": version_id}


def mistral_process(crops, api_key):
    rows, attempted = {}, 0
    for sample in SAMPLES:
        sid = sample["sample_id"]
        data_url = "data:image/jpeg;base64," + base64.b64encode(crops[sid]["bytes"]).decode("ascii")
        payload = {
            "model": "mistral-ocr-4-1", "document": {"type": "image_url", "image_url": data_url},
            "include_blocks": True, "confidence_scores_granularity": "block",
        }
        start = time.perf_counter()
        attempted += 1
        try:
            response = requests.post("https://api.mistral.ai/v1/ocr",
                headers={"Authorization": "Bearer " + api_key, "Content-Type": "application/json"},
                json=payload, timeout=(15, 90))
            elapsed = round((time.perf_counter() - start) * 1000, 2)
            if response.status_code != 200:
                rows[sid] = {"api_status": response.status_code, "latency_ms": elapsed,
                             "raw_output": "", "recognized_lines": [], "layout": [], "error_type": "http_error"}
                break
            body = response.json()
            pages = body.get("pages", [])
            raw = "\n".join(page.get("markdown", "") for page in pages).strip()
            blocks, lines = [], []
            for page in pages:
                for block in page.get("blocks") or []:
                    content = block.get("content", "")
                    blocks.append({"content": content, "bbox": block.get("bbox"), "label": block.get("label"),
                                   "confidence_scores": block.get("confidence_scores")})
                    lines.extend({"text": line.strip(), "confidence": None} for line in content.splitlines() if line.strip())
            if not lines:
                lines = [{"text": line.strip(), "confidence": None} for line in raw.splitlines() if line.strip()]
            rows[sid] = {
                "api_status": 200, "raw_output": raw, "mistral_raw_output": raw,
                "recognized_lines": lines, "layout": blocks, "mistral_bbox_layout": blocks,
                "mistral_confidence": [b["confidence_scores"] for b in blocks if b.get("confidence_scores") is not None],
                "latency_ms": elapsed, "mistral_latency_ms": elapsed,
                "mistral_api_status": 200, "mistral_model": body.get("model", "mistral-ocr-4-1"),
                "usage_info": body.get("usage_info"),
            }
        except Exception as error:
            rows[sid] = {"api_status": "transport_error", "latency_ms": round((time.perf_counter() - start) * 1000, 2),
                         "raw_output": "", "recognized_lines": [], "layout": [], "error_type": type(error).__name__}
            break
    return {"status": "complete" if len(rows) == EXPECTED_COUNT and all(r["api_status"] == 200 for r in rows.values()) else "provider_call_blocked",
            "rows": rows, "attempted_pages": attempted}


def provider_result(provider, result, crops, other_rows=None):
    records = []
    for sample in SAMPLES:
        sid = sample["sample_id"]
        row = result["rows"].get(sid, {"api_status": "not_attempted", "raw_output": "", "recognized_lines": [], "layout": []})
        row = dict(row)
        row.update({
            "sample_id": sid, "source_reference": sample["source_reference"],
            "ppocrv6_output": sample["primary_output"], "input_crop_sha256": crops[sid]["sha256"],
        })
        if other_rows:
            row["google_output"] = other_rows[sid].get("raw_output", "")
        records.append(row)
    artifact = {
        "provider": provider, "status": result["status"], "api_called": result["attempted_pages"] > 0,
        "request_count_attempted": result["attempted_pages"], "sample_count": len(records), "samples": records,
    }
    return artifact, result["rows"]


def scored_records(scorer, rows):
    assessments = score_rows(scorer, rows)
    summary = summarize(assessments)
    return assessments, summary


def cost_plan():
    google = round(EXPECTED_COUNT * GOOGLE_RATE / 1000, 6)
    mistral = round(EXPECTED_COUNT * MISTRAL_RATE / 1000, 6)
    return {
        "planned_requests_max": 24, "planned_google_ocr_pages": EXPECTED_COUNT,
        "planned_mistral_ocr_pages_if_google_insufficient": EXPECTED_COUNT,
        "google_list_price_usd_per_1000_pages": GOOGLE_RATE,
        "mistral_ocr_4_1_standard_api_usd_per_1000_pages": MISTRAL_RATE,
        "google_estimated_max_usd": google, "mistral_estimated_max_usd": mistral,
        "estimated_max_total_usd": round(google + mistral, 6), "budget_cap_usd": COST_CAP,
        "budget_guard": google + mistral <= COST_CAP,
        "method": "Conservative public standard list price; no free tier/credit assumed; one OCR page per crop; no retries. Two Google metadata GETs are not billable pages.",
        "actual_provider_billing_readback": "UNKNOWN", "api_requests_attempted": 0,
        "estimated_attempted_page_cost_usd": 0.0,
    }


def preflight_record(dataset, secret_flags, google_config, cost):
    return {
        "gate": "G2A1-R3B", "run_id": os.getenv("GITHUB_RUN_ID"),
        "run_attempt": os.getenv("GITHUB_RUN_ATTEMPT"), "head_sha": os.getenv("GITHUB_SHA"),
        "runner": runner_facts(), "dataset": dataset, "secret_presence_only": secret_flags,
        "google_configuration_complete": google_config,
        "mistral_configuration_present": secret_flags["mistral_api_key"],
        "planned_requests": {"max_total_including_two_google_metadata_gets": cost["planned_requests_max"],
                             "google_ocr_pages": EXPECTED_COUNT,
                             "mistral_ocr_pages_only_if_google_insufficient": EXPECTED_COUNT},
        "cost": cost, "model_api_token_cost": 0,
    }


def write_not_run_outputs(state, preflight):
    samples = [{
        "sample_id": row["sample_id"], "source_reference": row["source_reference"],
        "ppocrv6_output": row["primary_output"], "google_api_status": "not_called",
        "google_raw_output": "", "google_confidence": None, "google_bbox_layout": [], "google_latency_ms": None,
    } for row in SAMPLES]
    write_json("google-results.json", {"provider": "Google Enterprise Document OCR", "status": "NOT_RUN",
                                       "api_called": False, "sample_count": EXPECTED_COUNT, "samples": samples})
    write_json("google-comparison.json", {"status": "NOT_RUN", "reason": state,
                                          "baseline_manual_edit_fields": 13, "baseline_manual_edit_chars": 69})
    write_json("final-fallback-decision.json", {
        "primary": "PP-OCRv6_medium", "fallback": "UNKNOWN", "selection_status": state,
        "google_tested": False, "google_material_improvement": None, "mistral_tested": False,
        "mistral_material_improvement": None, "baseline_manual_edit_fields": 13,
        "final_manual_edit_fields": None, "baseline_manual_edit_chars": 69,
        "final_manual_edit_chars": None, "baseline_critical_errors": 1,
        "final_critical_errors": None, "new_silent_critical_errors": None, "new_hallucinations": None,
        "estimated_api_cost_usd": preflight["cost"]["estimated_attempted_page_cost_usd"], "reason": state,
    })
    write_json("cost-summary.json", preflight["cost"])


def append_identity(row, sample, crop):
    row.update({"sample_id": sample["sample_id"], "source_reference": sample["source_reference"],
                "ppocrv6_output": sample["primary_output"], "input_crop_sha256": crop["sha256"]})
    return row


def compare_summary(provider, candidate_summary, baseline_summary):
    return compare(provider, candidate_summary, baseline_summary)


def main():
    ART.mkdir(parents=True, exist_ok=True)
    DATA.mkdir(parents=True, exist_ok=True)
    dataset = validate_inputs()
    flags = {
        "google_credentials": bool(os.getenv("GOOGLE_OAUTH_ACCESS_TOKEN") or os.getenv("GOOGLE_APPLICATION_CREDENTIALS") or os.getenv("GOOGLE_GHA_CREDS_PATH")),
        "google_project": bool(os.getenv("GOOGLE_CLOUD_PROJECT")),
        "google_location": bool(os.getenv("GOOGLE_DOC_AI_LOCATION")),
        "google_processor_id": bool(os.getenv("GOOGLE_DOC_AI_PROCESSOR_ID")),
        "mistral_api_key": bool(os.getenv("MISTRAL_API_KEY")),
    }
    google_config = all(flags[key] for key in ("google_credentials", "google_project", "google_location", "google_processor_id"))
    cost = cost_plan()
    preflight = preflight_record(dataset, flags, google_config, cost)
    write_json("provider-preflight.json", preflight)
    print(json.dumps({"gate": "G2A1-R3B", "run_id": preflight["run_id"], "fixed_samples": EXPECTED_COUNT,
                      "google_config_present": google_config, "mistral_config_present": flags["mistral_api_key"],
                      "estimated_max_cost_usd": cost["estimated_max_total_usd"], "token_cost": 0}, sort_keys=True))
    if not cost["budget_guard"]:
        write_not_run_outputs("RETURN_G2A1_R3B_BUDGET_CHECKPOINT_REQUIRED", preflight)
        return
    if not flags["google_credentials"]:
        write_not_run_outputs("RETURN_G2A1_R3B_GOOGLE_CREDENTIAL_REQUIRED", preflight)
        return
    if not google_config:
        write_not_run_outputs("RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED", preflight)
        return
    try:
        scorer = load_r3a_scorer()
        baseline_summary = baseline(scorer)
        if (baseline_summary["manual_edit_fields"], baseline_summary["manual_edit_chars"],
            baseline_summary["critical_field_errors"], baseline_summary["silent_critical_errors"],
            baseline_summary["confirmed_hallucinations"]) != (13, 69, 1, 0, 0):
            write_not_run_outputs("RETURN_G2A1_R3B_ACTIONS_BLOCKED", preflight)
            return
        try:
            token = os.getenv("GOOGLE_OAUTH_ACCESS_TOKEN")
            if token:
                preflight["google_auth_mode"] = "WORKLOAD_IDENTITY_FEDERATION_ACCESS_TOKEN"
                preflight["google_adc_project_detected"] = os.getenv("GOOGLE_CLOUD_PROJECT")
            else:
                credentials, detected_project = google.auth.default(
                    scopes=["https://www.googleapis.com/auth/cloud-platform"])
                credentials.refresh(Request())
                token = credentials.token
                preflight["google_auth_mode"] = "WORKLOAD_IDENTITY_FEDERATION_ADC"
                preflight["google_adc_project_detected"] = detected_project
            if not token:
                raise RuntimeError("missing_google_access_token")
        except Exception:
            write_not_run_outputs("RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED", preflight)
            return
        project, location, processor_id = (
            os.environ["GOOGLE_CLOUD_PROJECT"], os.environ["GOOGLE_DOC_AI_LOCATION"],
            os.environ["GOOGLE_DOC_AI_PROCESSOR_ID"])
        if not re.fullmatch(r"[A-Za-z0-9-]+", project) or not re.fullmatch(r"[a-z0-9-]+", location) or not re.fullmatch(r"[A-Za-z0-9-]+", processor_id):
            write_not_run_outputs("RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED", preflight)
            return
        root = f"projects/{project}/locations/{location}/processors/{processor_id}"
        api_root = f"https://{location}-documentai.googleapis.com/v1"
        headers = {"Authorization": "Bearer " + token}
        try:
            processor_response = requests.get(api_root + "/" + quote(root, safe="/"), headers=headers, timeout=(15, 35))
        except requests.RequestException as error:
            preflight["google_metadata_error_type"] = type(error).__name__
            preflight["cost"] = cost
            write_json("provider-preflight.json", preflight)
            write_not_run_outputs("RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED", preflight)
            return
        cost["api_requests_attempted"] = 1
        preflight["google_processor_metadata_status"] = processor_response.status_code
        if processor_response.status_code != 200:
            preflight["cost"] = cost
            write_json("provider-preflight.json", preflight)
            write_not_run_outputs("RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED", preflight)
            return
        processor = processor_response.json()
        version_name = processor.get("defaultProcessorVersion", "")
        version_id = version_name.rsplit("/", 1)[-1]
        if (processor.get("type") != "OCR_PROCESSOR" or processor.get("state") != "ENABLED"
                or not version_id or not version_name.endswith("/" + version_id)):
            preflight["google_processor_type"] = processor.get("type")
            preflight["google_processor_state"] = processor.get("state")
            preflight["cost"] = cost
            write_json("provider-preflight.json", preflight)
            write_not_run_outputs("RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED", preflight)
            return
        try:
            version_response = requests.get(api_root + "/" + quote(version_name, safe="/"), headers=headers, timeout=(15, 35))
        except requests.RequestException as error:
            preflight["google_metadata_error_type"] = type(error).__name__
            preflight["cost"] = cost
            write_json("provider-preflight.json", preflight)
            write_not_run_outputs("RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED", preflight)
            return
        cost["api_requests_attempted"] = 2
        preflight["google_processor_version_metadata_status"] = version_response.status_code
        if version_response.status_code != 200 or version_response.json().get("state") != "DEPLOYED":
            preflight["cost"] = cost
            write_json("provider-preflight.json", preflight)
            write_not_run_outputs("RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED", preflight)
            return
        preflight.update({
            "google_processor_type": "OCR_PROCESSOR", "google_processor_version": version_id,
            "google_handwriting_capability": "Enterprise Document OCR officially supports handwritten text",
            "google_handwriting_input_hint": "No handwriting-specific input hint in the current v1 OCR config; English language hint used",
            "google_language_hint": "en",
        })
        crops, source_checks = prepare_crops()
        preflight["public_source_integrity"] = source_checks
        preflight["crop_inputs"] = {sid: {key: value for key, value in crop.items() if key != "bytes"} for sid, crop in crops.items()}
        google = google_process(crops, token, project, location, processor_id, version_id)
        cost["api_requests_attempted"] = 2 + google["attempted_pages"]
        cost["estimated_attempted_page_cost_usd"] = round(google["attempted_pages"] * GOOGLE_RATE / 1000, 6)
        preflight["cost"] = cost
        preflight["google_runtime_status"] = google["status"]
        write_json("provider-preflight.json", preflight)
        google_artifact, google_rows = provider_result("Google Enterprise Document OCR", google, crops)
        for row in google_artifact["samples"]:
            result = google_rows.get(row["sample_id"])
            if result and result.get("api_status") == 200:
                spec = SPECS[row["sample_id"]]
                scored = scorer.assess(spec, {"raw_output": result["raw_output"], "lines": result["recognized_lines"]})
                baseline_row = BASELINE_ROWS[row["sample_id"]]
                row["review_score"] = scored
                row["semantic_comparison"] = {
                    "semantic_critical_errors": scored["semantic_critical_errors"],
                    "missing_critical_fields": [e for e in scored["semantic_critical_errors"] if e["error_type"].startswith("missing_")],
                    "unsupported_hallucinations": scored["unsupported_hallucinations"],
                    "unverified_extra_content": scored["unverified_extra_content"],
                }
                row["manual_edit_comparison"] = {
                    "baseline_manual_edit_fields": baseline_row["manual_edit_field_count"],
                    "google_manual_edit_fields": scored["manual_edit_field_count"],
                    "baseline_manual_edit_chars": baseline_row["manual_edit_chars"],
                    "google_manual_edit_chars": scored["manual_edit_chars"],
                    "whole_line_retype": scored["whole_line_retype_required"],
                    "reupload_required": scored["reupload_required"],
                }
        write_json("google-results.json", google_artifact)
        if google["status"] != "complete":
            write_json("google-comparison.json", {"status": "INCOMPLETE", "request_count_attempted": google["attempted_pages"],
                                                   "baseline_manual_edit_fields": 13, "baseline_manual_edit_chars": 69})
            decision = {"primary": "PP-OCRv6_medium", "fallback": "UNKNOWN",
                        "selection_status": "RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED",
                        "google_tested": google["attempted_pages"] > 0, "google_material_improvement": None, "mistral_tested": False,
                        "baseline_manual_edit_fields": 13, "final_manual_edit_fields": None,
                        "baseline_manual_edit_chars": 69, "final_manual_edit_chars": None,
                        "baseline_critical_errors": 1, "final_critical_errors": None,
                        "new_silent_critical_errors": None, "new_hallucinations": None,
                        "estimated_api_cost_usd": cost["estimated_attempted_page_cost_usd"],
                        "reason": "Google did not complete all 11 fixed samples; Mistral not called."}
            write_json("final-fallback-decision.json", decision)
            write_json("cost-summary.json", cost)
            return
        google_assessments = score_rows(scorer, google_rows)
        google_summary = summarize(google_assessments)
        google_comparison = compare_summary("GOOGLE_ENTERPRISE_DOCUMENT_OCR", google_summary, baseline_summary)
        write_json("google-comparison.json", google_comparison)
        if google_comparison["material_improvement"]:
            final_provider, final_comparison, mistral_tested = "GOOGLE_ENTERPRISE_DOCUMENT_OCR", google_comparison, False
        elif not flags["mistral_api_key"]:
            decision = {"primary": "PP-OCRv6_medium", "fallback": "UNKNOWN",
                        "selection_status": "RETURN_G2A1_R3B_MISTRAL_CREDENTIAL_REQUIRED",
                        "google_tested": True, "google_material_improvement": False, "mistral_tested": False,
                        "mistral_material_improvement": None, "baseline_manual_edit_fields": 13,
                        "final_manual_edit_fields": google_summary["manual_edit_fields"],
                        "baseline_manual_edit_chars": 69, "final_manual_edit_chars": google_summary["manual_edit_chars"],
                        "baseline_critical_errors": 1, "final_critical_errors": google_summary["critical_field_errors"],
                        "new_silent_critical_errors": google_summary["silent_critical_errors"],
                        "new_hallucinations": google_summary["confirmed_hallucinations"],
                        "estimated_api_cost_usd": cost["estimated_attempted_page_cost_usd"],
                        "reason": "Google was insufficient; Mistral credential is absent and no second provider was called."}
            write_json("final-fallback-decision.json", decision)
            write_json("cost-summary.json", cost)
            return
        else:
            mistral = mistral_process(crops, os.environ["MISTRAL_API_KEY"])
            cost["api_requests_attempted"] = 2 + google["attempted_pages"] + mistral["attempted_pages"]
            cost["estimated_attempted_page_cost_usd"] = round(
                google["attempted_pages"] * GOOGLE_RATE / 1000 + mistral["attempted_pages"] * MISTRAL_RATE / 1000, 6)
            preflight["cost"] = cost
            preflight["mistral_runtime_status"] = mistral["status"]
            write_json("provider-preflight.json", preflight)
            mistral_artifact, mistral_rows = provider_result("Mistral OCR 4.1", mistral, crops, google_rows)
            for row in mistral_artifact["samples"]:
                result = mistral_rows.get(row["sample_id"])
                if result and result.get("api_status") == 200:
                    scored = scorer.assess(SPECS[row["sample_id"]], {"raw_output": result["raw_output"], "lines": result["recognized_lines"]})
                    baseline_row = BASELINE_ROWS[row["sample_id"]]
                    row["review_score"] = scored
                    row["semantic_comparison"] = {
                        "semantic_critical_errors": scored["semantic_critical_errors"],
                        "missing_critical_fields": [e for e in scored["semantic_critical_errors"] if e["error_type"].startswith("missing_")],
                        "unsupported_hallucinations": scored["unsupported_hallucinations"],
                        "unverified_extra_content": scored["unverified_extra_content"],
                    }
                    row["manual_edit_comparison"] = {
                        "baseline_manual_edit_fields": baseline_row["manual_edit_field_count"],
                        "mistral_manual_edit_fields": scored["manual_edit_field_count"],
                        "baseline_manual_edit_chars": baseline_row["manual_edit_chars"],
                        "mistral_manual_edit_chars": scored["manual_edit_chars"],
                        "whole_line_retype": scored["whole_line_retype_required"],
                        "reupload_required": scored["reupload_required"],
                    }
            write_json("mistral-results.json", mistral_artifact)
            if mistral["status"] != "complete":
                write_json("mistral-comparison.json", {"status": "INCOMPLETE", "request_count_attempted": mistral["attempted_pages"],
                                                       "baseline_manual_edit_fields": google_summary["manual_edit_fields"],
                                                       "baseline_manual_edit_chars": google_summary["manual_edit_chars"]})
                decision = {"primary": "PP-OCRv6_medium", "fallback": "UNKNOWN",
                            "selection_status": "RETURN_G2A1_R3B_ACTIONS_BLOCKED",
                            "google_tested": True, "google_material_improvement": False, "mistral_tested": False,
                            "baseline_manual_edit_fields": 13, "final_manual_edit_fields": None,
                            "baseline_manual_edit_chars": 69, "final_manual_edit_chars": None,
                            "baseline_critical_errors": 1, "final_critical_errors": None,
                            "new_silent_critical_errors": None, "new_hallucinations": None,
                            "estimated_api_cost_usd": cost["estimated_attempted_page_cost_usd"],
                            "reason": "Mistral did not complete all 11 fixed samples."}
                write_json("final-fallback-decision.json", decision)
                write_json("cost-summary.json", cost)
                return
            mistral_assessments = score_rows(scorer, mistral_rows)
            mistral_summary = summarize(mistral_assessments)
            mistral_comparison = compare_summary("MISTRAL_OCR_4_1", mistral_summary, baseline_summary)
            mistral_comparison["google_material_improvement"] = False
            mistral_comparison["google_manual_edit_fields"] = google_summary["manual_edit_fields"]
            mistral_comparison["google_manual_edit_chars"] = google_summary["manual_edit_chars"]
            write_json("mistral-comparison.json", mistral_comparison)
            if mistral_comparison["material_improvement"]:
                final_provider, final_comparison, mistral_tested = "MISTRAL_OCR_4_1", mistral_comparison, True
            else:
                final_provider, final_comparison, mistral_tested = "NONE", mistral_comparison, True
        final_summary = (google_summary if final_provider == "GOOGLE_ENTERPRISE_DOCUMENT_OCR"
                         else mistral_summary if final_provider == "MISTRAL_OCR_4_1" else baseline_summary)
        decision = {
            "primary": "PP-OCRv6_medium", "fallback": final_provider, "selection_status": "complete",
            "google_tested": True, "google_material_improvement": google_comparison["material_improvement"],
            "mistral_tested": mistral_tested,
            "mistral_material_improvement": final_provider == "MISTRAL_OCR_4_1" if mistral_tested else None,
            "baseline_manual_edit_fields": 13, "final_manual_edit_fields": final_summary["manual_edit_fields"],
            "baseline_manual_edit_chars": 69, "final_manual_edit_chars": final_summary["manual_edit_chars"],
            "baseline_critical_errors": 1, "final_critical_errors": final_summary["critical_field_errors"],
            "new_silent_critical_errors": final_summary["silent_critical_errors"],
            "new_hallucinations": final_summary["confirmed_hallucinations"],
            "estimated_api_cost_usd": cost["estimated_attempted_page_cost_usd"],
            "reason": final_comparison["reason"] if final_provider != "NONE" else
                      "Google and Mistral did not materially improve the 11 hard cases without added fidelity risk.",
        }
        write_json("final-fallback-decision.json", decision)
        write_json("cost-summary.json", cost)
        print(json.dumps({"execution_status": "complete", "fallback": final_provider,
                          "google_material_improvement": google_comparison["material_improvement"],
                          "mistral_tested": mistral_tested, "manual_edit_fields": final_summary["manual_edit_fields"],
                          "manual_edit_chars": final_summary["manual_edit_chars"],
                          "estimated_api_cost_usd": decision["estimated_api_cost_usd"]}, sort_keys=True))
    except Exception as error:
        # Exception strings may contain request metadata; record only the type and preserve API outputs.
        preflight["execution_error_type"] = type(error).__name__
        write_json("provider-preflight.json", preflight)
        if not (ART / "google-results.json").exists():
            write_not_run_outputs("RETURN_G2A1_R3B_ACTIONS_BLOCKED", preflight)
        else:
            if not (ART / "google-comparison.json").exists():
                write_json("google-comparison.json", {
                    "status": "INCOMPLETE", "reason": "scoring_or_execution_exception",
                    "error_type": type(error).__name__,
                })
            write_json("final-fallback-decision.json", {
                "primary": "PP-OCRv6_medium", "fallback": "UNKNOWN",
                "selection_status": "RETURN_G2A1_R3B_ACTIONS_BLOCKED",
                "google_tested": True, "google_material_improvement": None,
                "mistral_tested": bool((ART / "mistral-results.json").exists()),
                "mistral_material_improvement": None, "baseline_manual_edit_fields": 13,
                "final_manual_edit_fields": None, "baseline_manual_edit_chars": 69,
                "final_manual_edit_chars": None, "baseline_critical_errors": 1,
                "final_critical_errors": None, "new_silent_critical_errors": None,
                "new_hallucinations": None, "estimated_api_cost_usd": cost["estimated_attempted_page_cost_usd"],
                "reason": "benchmark stopped after an execution exception; existing provider outputs are preserved.",
                "error_type": type(error).__name__,
            })
            write_json("cost-summary.json", cost)
        print(json.dumps({"execution_status": "RETURN_G2A1_R3B_ACTIONS_BLOCKED",
                          "error_type": type(error).__name__}, sort_keys=True))
        raise SystemExit(1)


if __name__ == "__main__":
    main()
