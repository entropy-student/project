"""Baidu Handwriting OCR benchmark for the fixed 11 R3B hard cases.

Secrets are read only from environment and are never persisted or printed.
The benchmark never enables paid service; provider/quota errors stop the run.
"""
from __future__ import annotations

import base64
import hashlib
import importlib.util
import io
import json
import os
import platform
import shutil
import sys
import time
import urllib.request
from pathlib import Path

import requests
from PIL import Image

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
BASELINE_ROWS = {
    row["sample_id"]: row
    for row in BASELINE_REVIEW["PP-OCRv6_medium"]["genuine_handwriting_review"]["review_payloads"]
}

EXPECTED_COUNT = 11
FREE_MONTHLY_CALLS_PERSONAL = 500
MAX_CALLS_THIS_BENCHMARK = 11

TOKEN_URL = "https://aip.baidubce.com/oauth/2.0/token"
HANDWRITING_URL = "https://aip.baidubce.com/rest/2.0/ocr/v1/handwriting"

# Provider errors that mean the free path / permission is not usable.
FREE_OR_PERMISSION_BLOCKERS = {6, 17, 19, 216604}
TRANSIENT_QPS = {18}


def write_json(name, value):
    ART.mkdir(parents=True, exist_ok=True)
    (ART / name).write_text(
        json.dumps(value, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def runner_facts():
    disk = shutil.disk_usage("/")
    return {
        "os": platform.platform(),
        "python": sys.version,
        "architecture": platform.machine(),
        "logical_processors": os.cpu_count(),
        "root_disk_total_bytes": disk.total,
        "root_disk_free_bytes": disk.free,
        "runner_name": os.getenv("RUNNER_NAME"),
    }


def validate_inputs():
    ids = [row["sample_id"] for row in SAMPLES]
    if FALLBACK.get("primary") != "PP-OCRv6_medium":
        raise ValueError("fallback set primary mismatch")
    if len(ids) != EXPECTED_COUNT or len(set(ids)) != EXPECTED_COUNT:
        raise ValueError("expected fixed 11 unique samples")
    for sample in SAMPLES:
        spec = SPECS[sample["sample_id"]]
        baseline = BASELINE_ROWS[sample["sample_id"]]
        if (
            spec.get("sample_class") != "GENUINE_HANDWRITING"
            or spec.get("language") != "English"
            or spec.get("source_id") not in SOURCES
            or spec.get("source_reference") != sample.get("source_reference")
            or baseline.get("recognized_text") != sample.get("primary_output")
        ):
            raise ValueError("fixed sample provenance mismatch")
    edit_fields = sum(BASELINE_ROWS[sid]["manual_edit_field_count"] for sid in ids)
    edit_chars = sum(BASELINE_ROWS[sid]["manual_edit_chars"] for sid in ids)
    if (edit_fields, edit_chars) != (13, 69):
        raise ValueError("accepted R3A hard-set baseline changed")
    return {
        "count": EXPECTED_COUNT,
        "sample_ids": ids,
        "baseline_manual_edit_fields": edit_fields,
        "baseline_manual_edit_chars": edit_chars,
    }


def prepare_crops():
    DATA.mkdir(parents=True, exist_ok=True)
    images, source_checks = {}, {}
    for source in SOURCES.values():
        path = DATA / (source["source_id"] + ".jpg")
        if not path.exists():
            request = urllib.request.Request(
                source["image_url"],
                headers={"User-Agent": "FamilyCookbookStudio-G2A1-R3B/1.0"},
            )
            with urllib.request.urlopen(request, timeout=90) as response:
                path.write_bytes(response.read())

        raw = path.read_bytes()
        digest = hashlib.sha1(raw).hexdigest()
        if len(raw) != source["expected_bytes"] or digest != source["expected_sha1"]:
            raise ValueError("public source checksum mismatch")
        images[source["source_id"]] = path
        source_checks[source["source_id"]] = {
            "bytes": len(raw),
            "sha1": digest,
            "verified": True,
        }

    crops = {}
    for sample in SAMPLES:
        spec = SPECS[sample["sample_id"]]
        with Image.open(images[spec["source_id"]]) as page:
            crop = page.crop(tuple(spec["crop"]))
            # Baidu recommends relatively compact images; fixed crops are already small.
            buffer = io.BytesIO()
            crop.save(buffer, format="JPEG", quality=92)
            raw = buffer.getvalue()
        crops[sample["sample_id"]] = {
            "bytes": raw,
            "sha256": hashlib.sha256(raw).hexdigest(),
            "bytes_count": len(raw),
            "width": crop.width,
            "height": crop.height,
        }
    return crops, source_checks


def load_r3a_scorer():
    (DATA / "prepared-corpus.json").write_text(
        json.dumps(
            {"samples": [SPECS[row["sample_id"]] for row in SAMPLES]},
            ensure_ascii=False,
        ),
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
        assessments.append(
            scorer.assess(
                SPECS[sample["sample_id"]],
                {
                    "raw_output": row.get("raw_output", ""),
                    "lines": row.get("recognized_lines", []),
                },
            )
        )
    return assessments


def summarize(assessments):
    return {
        "status": "complete" if len(assessments) == EXPECTED_COUNT else "incomplete",
        "sample_count": len(assessments),
        "critical_field_errors": sum(
            len(row["semantic_critical_errors"]) for row in assessments
        ),
        "missing_critical_fields": sum(
            1
            for row in assessments
            for error in row["semantic_critical_errors"]
            if error["error_type"].startswith("missing_")
        ),
        "silent_critical_errors": sum(
            len(row["silent_critical_errors"]) for row in assessments
        ),
        "confirmed_hallucinations": sum(
            len(row["unsupported_hallucinations"]) for row in assessments
        ),
        "unverified_partial_content_items": sum(
            len(row.get("unverified_extra_content", [])) for row in assessments
        ),
        "manual_edit_fields": sum(
            row["manual_edit_field_count"] for row in assessments
        ),
        "manual_edit_chars": sum(row["manual_edit_chars"] for row in assessments),
        "whole_line_retypes": sum(
            row["whole_line_retype_count"] for row in assessments
        ),
        "reupload_pages": sum(row["reupload_required"] for row in assessments),
        "case_results": assessments,
    }


def baseline(scorer):
    rows = {}
    for sample in SAMPLES:
        review = BASELINE_ROWS[sample["sample_id"]]
        rows[sample["sample_id"]] = {
            "api_status": 200,
            "raw_output": review["recognized_text"],
            "recognized_lines": [
                {"text": line, "confidence": None}
                for line in review["recognized_text"].splitlines()
                if line.strip()
            ],
        }
    return summarize(score_rows(scorer, rows))


def scorer_key(fact):
    if fact["kind"] == "quantity_unit_ingredient":
        fields = ("kind", "quantity", "unit", "ingredient")
    elif fact["kind"] == "temperature":
        fields = ("kind", "value", "scale")
    else:
        fields = ("kind", "value", "unit")
    return tuple(fact.get(field) for field in fields)


def compare(provider, candidate_summary, baseline_summary):
    old_rows = {row["sample_id"]: row for row in baseline_summary["case_results"]}
    new_rows = {row["sample_id"]: row for row in candidate_summary["case_results"]}

    improved, worsened, newly_missing = [], [], []
    recovered = 0

    for sample in SAMPLES:
        sid = sample["sample_id"]
        old = old_rows[sid]
        new = new_rows.get(sid)
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

        old_metric = (
            len(old["semantic_critical_errors"]),
            old["manual_edit_field_count"],
            old["manual_edit_chars"],
            old["whole_line_retype_count"],
        )
        new_metric = (
            len(new["semantic_critical_errors"]),
            new["manual_edit_field_count"],
            new["manual_edit_chars"],
            new["whole_line_retype_count"],
        )

        if new_metric < old_metric:
            improved.append(sid)
        elif new_metric > old_metric:
            worsened.append(sid)

    fields_reduced = (
        baseline_summary["manual_edit_fields"] - candidate_summary["manual_edit_fields"]
    )
    chars_reduced = (
        baseline_summary["manual_edit_chars"] - candidate_summary["manual_edit_chars"]
    )
    unverified_increase = max(
        0,
        candidate_summary["unverified_partial_content_items"]
        - baseline_summary["unverified_partial_content_items"],
    )

    safe = (
        not newly_missing
        and candidate_summary["silent_critical_errors"] == 0
        and candidate_summary["confirmed_hallucinations"] == 0
        and unverified_increase == 0
    )

    critical_path = (
        recovered >= 1
        and candidate_summary["critical_field_errors"]
        < baseline_summary["critical_field_errors"]
        and safe
    )

    edit_path = (
        fields_reduced >= 4
        and chars_reduced >= 18
        and len(improved) >= 3
        and not worsened
        and safe
    )

    return {
        "provider": provider,
        "status": candidate_summary["status"],
        "baseline": {
            "manual_edit_fields": baseline_summary["manual_edit_fields"],
            "manual_edit_chars": baseline_summary["manual_edit_chars"],
            "critical_field_errors": baseline_summary["critical_field_errors"],
            "silent_critical_errors": baseline_summary["silent_critical_errors"],
            "confirmed_hallucinations": baseline_summary["confirmed_hallucinations"],
        },
        "candidate": {
            "manual_edit_fields": candidate_summary["manual_edit_fields"],
            "manual_edit_chars": candidate_summary["manual_edit_chars"],
            "critical_field_errors": candidate_summary["critical_field_errors"],
            "silent_critical_errors": candidate_summary["silent_critical_errors"],
            "confirmed_hallucinations": candidate_summary["confirmed_hallucinations"],
        },
        "manual_edit_fields_reduced": fields_reduced,
        "manual_edit_chars_reduced": chars_reduced,
        "critical_facts_recovered": recovered,
        "newly_missing_previously_correct_facts": newly_missing,
        "improved_sample_ids": improved,
        "worsened_sample_ids": worsened,
        "material_improvement": (
            candidate_summary["status"] == "complete"
            and (critical_path or edit_path)
        ),
        "reason": (
            "critical fact recovery without fidelity regression"
            if critical_path
            else "review burden threshold met without fidelity regression"
            if edit_path
            else "no material improvement under the recorded rule or fidelity regression detected"
        ),
    }


def get_access_token(api_key, secret_key):
    response = requests.post(
        TOKEN_URL,
        params={
            "grant_type": "client_credentials",
            "client_id": api_key,
            "client_secret": secret_key,
        },
        timeout=(15, 35),
    )
    body = response.json()
    token = body.get("access_token")
    if response.status_code != 200 or not token:
        return {
            "ok": False,
            "status": response.status_code,
            "error": str(body.get("error_description") or body.get("error") or "token_error")[:300],
        }
    return {"ok": True, "token": token, "expires_in": body.get("expires_in")}


def baidu_process(crops, access_token):
    rows = {}
    attempted = 0
    successful = 0

    for sample in SAMPLES:
        sid = sample["sample_id"]
        attempted += 1

        form = {
            "image": base64.b64encode(crops[sid]["bytes"]).decode("ascii"),
            "recognize_granularity": "small",
            "probability": "true",
            "detect_direction": "true",
        }

        start = time.perf_counter()
        response = requests.post(
            HANDWRITING_URL,
            params={"access_token": access_token},
            data=form,
            headers={"Content-Type": "application/x-www-form-urlencoded"},
            timeout=(15, 90),
        )
        elapsed = round((time.perf_counter() - start) * 1000, 2)

        try:
            body = response.json()
        except Exception:
            rows[sid] = {
                "api_status": response.status_code,
                "error_type": "non_json_response",
                "latency_ms": elapsed,
                "raw_output": "",
                "recognized_lines": [],
            }
            break

        if "error_code" in body:
            error_code = int(body.get("error_code"))
            rows[sid] = {
                "api_status": response.status_code,
                "provider_error_code": error_code,
                "provider_error_msg": str(body.get("error_msg", ""))[:300],
                "free_or_permission_blocker": error_code in FREE_OR_PERMISSION_BLOCKERS,
                "qps_blocker": error_code in TRANSIENT_QPS,
                "latency_ms": elapsed,
                "raw_output": "",
                "recognized_lines": [],
            }
            break

        words = body.get("words_result") or []
        lines = []
        for item in words:
            probability = item.get("probability") or {}
            lines.append(
                {
                    "text": str(item.get("words", "")).strip(),
                    "confidence": probability.get("average"),
                    "location": item.get("location"),
                    "chars": item.get("chars"),
                }
            )

        raw = "\n".join(line["text"] for line in lines if line["text"])
        rows[sid] = {
            "api_status": 200,
            "provider_log_id": body.get("log_id"),
            "raw_output": raw,
            "baidu_raw_output": raw,
            "recognized_lines": lines,
            "layout": [
                {
                    "text": line["text"],
                    "location": line.get("location"),
                    "confidence": line.get("confidence"),
                }
                for line in lines
            ],
            "direction": body.get("direction"),
            "words_result_num": body.get("words_result_num"),
            "latency_ms": elapsed,
        }
        successful += 1

        # Keep well below the documented free QPS ceiling.
        if sid != SAMPLES[-1]["sample_id"]:
            time.sleep(0.8)

    return {
        "status": (
            "complete"
            if len(rows) == EXPECTED_COUNT
            and all(row.get("api_status") == 200 for row in rows.values())
            else "provider_call_blocked"
        ),
        "rows": rows,
        "attempted_pages": attempted,
        "successful_pages": successful,
    }


def write_not_run(state, preflight):
    write_json(
        "baidu-results.json",
        {
            "provider": "Baidu Handwriting OCR",
            "status": "NOT_RUN",
            "api_called": False,
            "sample_count": EXPECTED_COUNT,
        },
    )
    write_json(
        "baidu-comparison.json",
        {
            "status": "NOT_RUN",
            "reason": state,
            "baseline_manual_edit_fields": 13,
            "baseline_manual_edit_chars": 69,
        },
    )
    write_json(
        "final-fallback-decision.json",
        {
            "primary": "PP-OCRv6_medium",
            "fallback": "UNKNOWN",
            "selection_status": state,
            "baidu_tested": False,
            "baseline_manual_edit_fields": 13,
            "final_manual_edit_fields": None,
            "baseline_manual_edit_chars": 69,
            "final_manual_edit_chars": None,
            "baseline_critical_errors": 1,
            "final_critical_errors": None,
        },
    )


def main():
    ART.mkdir(parents=True, exist_ok=True)
    DATA.mkdir(parents=True, exist_ok=True)

    dataset = validate_inputs()
    api_key = os.getenv("BAIDU_OCR_API_KEY")
    secret_key = os.getenv("BAIDU_OCR_SECRET_KEY")

    preflight = {
        "gate": "G2A1-R3B",
        "provider": "BAIDU_HANDWRITING_OCR",
        "run_id": os.getenv("GITHUB_RUN_ID"),
        "head_sha": os.getenv("GITHUB_SHA"),
        "runner": runner_facts(),
        "dataset": dataset,
        "secret_presence_only": {
            "baidu_api_key": bool(api_key),
            "baidu_secret_key": bool(secret_key),
        },
        "free_path_only": True,
        "documented_personal_free_calls_per_month": FREE_MONTHLY_CALLS_PERSONAL,
        "max_calls_this_benchmark": MAX_CALLS_THIS_BENCHMARK,
        "paid_mode_authorized": False,
    }
    write_json("provider-preflight.json", preflight)

    if not api_key or not secret_key:
        write_not_run("RETURN_G2A1_R3B_BAIDU_CREDENTIAL_REQUIRED", preflight)
        return

    scorer = load_r3a_scorer()
    baseline_summary = baseline(scorer)
    if (
        baseline_summary["manual_edit_fields"],
        baseline_summary["manual_edit_chars"],
        baseline_summary["critical_field_errors"],
        baseline_summary["silent_critical_errors"],
        baseline_summary["confirmed_hallucinations"],
    ) != (13, 69, 1, 0, 0):
        write_not_run("RETURN_G2A1_R3B_ACTIONS_BLOCKED", preflight)
        return

    token_result = get_access_token(api_key, secret_key)
    if not token_result["ok"]:
        preflight["token_status"] = {
            "ok": False,
            "http_status": token_result.get("status"),
            "error": token_result.get("error"),
        }
        write_json("provider-preflight.json", preflight)
        write_not_run("RETURN_G2A1_R3B_BAIDU_AUTH_BLOCKED", preflight)
        return

    preflight["token_status"] = {
        "ok": True,
        "expires_in": token_result.get("expires_in"),
    }

    crops, source_checks = prepare_crops()
    preflight["public_source_integrity"] = source_checks
    preflight["crop_inputs"] = {
        sid: {k: v for k, v in crop.items() if k != "bytes"}
        for sid, crop in crops.items()
    }

    result = baidu_process(crops, token_result["token"])
    preflight["runtime_status"] = result["status"]
    preflight["attempted_pages"] = result["attempted_pages"]
    preflight["successful_pages"] = result["successful_pages"]
    write_json("provider-preflight.json", preflight)

    records = []
    for sample in SAMPLES:
        sid = sample["sample_id"]
        row = dict(
            result["rows"].get(
                sid,
                {
                    "api_status": "not_attempted",
                    "raw_output": "",
                    "recognized_lines": [],
                    "layout": [],
                },
            )
        )
        row.update(
            {
                "sample_id": sid,
                "source_reference": sample["source_reference"],
                "ppocrv6_output": sample["primary_output"],
                "input_crop_sha256": crops[sid]["sha256"],
            }
        )
        records.append(row)

    write_json(
        "baidu-results.json",
        {
            "provider": "Baidu Handwriting OCR",
            "status": result["status"],
            "api_called": result["attempted_pages"] > 0,
            "request_count_attempted": result["attempted_pages"],
            "successful_pages": result["successful_pages"],
            "sample_count": len(records),
            "samples": records,
        },
    )

    if result["status"] != "complete":
        blocker_codes = [
            row.get("provider_error_code")
            for row in result["rows"].values()
            if row.get("provider_error_code") is not None
        ]
        free_blocked = any(
            row.get("free_or_permission_blocker") is True
            for row in result["rows"].values()
        )
        status = (
            "RETURN_G2A1_R3B_BAIDU_FREE_OR_PERMISSION_BLOCKED"
            if free_blocked
            else "RETURN_G2A1_R3B_BAIDU_PROVIDER_BLOCKED"
        )
        write_json(
            "baidu-comparison.json",
            {
                "status": "INCOMPLETE",
                "provider_error_codes": blocker_codes,
                "request_count_attempted": result["attempted_pages"],
                "successful_pages": result["successful_pages"],
                "baseline_manual_edit_fields": 13,
                "baseline_manual_edit_chars": 69,
            },
        )
        write_json(
            "final-fallback-decision.json",
            {
                "primary": "PP-OCRv6_medium",
                "fallback": "UNKNOWN",
                "selection_status": status,
                "baidu_tested": result["attempted_pages"] > 0,
                "baidu_successful_pages": result["successful_pages"],
                "baseline_manual_edit_fields": 13,
                "final_manual_edit_fields": None,
                "baseline_manual_edit_chars": 69,
                "final_manual_edit_chars": None,
                "baseline_critical_errors": 1,
                "final_critical_errors": None,
                "paid_mode_authorized": False,
            },
        )
        return

    provider_rows = result["rows"]
    assessments = score_rows(scorer, provider_rows)
    candidate_summary = summarize(assessments)
    comparison = compare("BAIDU_HANDWRITING_OCR", candidate_summary, baseline_summary)
    write_json("baidu-comparison.json", comparison)

    if comparison["material_improvement"]:
        fallback = "BAIDU_HANDWRITING_OCR"
        final_summary = candidate_summary
        reason = comparison["reason"]
    else:
        fallback = "NONE"
        final_summary = baseline_summary
        reason = "Baidu Handwriting OCR did not materially improve the 11 hard cases without fidelity regression."

    write_json(
        "final-fallback-decision.json",
        {
            "primary": "PP-OCRv6_medium",
            "fallback": fallback,
            "selection_status": "complete",
            "baidu_tested": True,
            "baidu_material_improvement": comparison["material_improvement"],
            "baseline_manual_edit_fields": 13,
            "final_manual_edit_fields": final_summary["manual_edit_fields"],
            "baseline_manual_edit_chars": 69,
            "final_manual_edit_chars": final_summary["manual_edit_chars"],
            "baseline_critical_errors": 1,
            "final_critical_errors": final_summary["critical_field_errors"],
            "new_silent_critical_errors": final_summary["silent_critical_errors"],
            "new_hallucinations": final_summary["confirmed_hallucinations"],
            "successful_baidu_pages": result["successful_pages"],
            "paid_mode_authorized": False,
            "reason": reason,
        },
    )

    print(
        json.dumps(
            {
                "execution_status": "complete",
                "fallback": fallback,
                "baidu_material_improvement": comparison["material_improvement"],
                "manual_edit_fields": final_summary["manual_edit_fields"],
                "manual_edit_chars": final_summary["manual_edit_chars"],
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
