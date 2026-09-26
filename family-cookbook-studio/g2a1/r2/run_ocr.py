"""Run full-page PaddleOCR, deterministic routing and crop-only TrOCR on Actions CPU."""
from __future__ import annotations

import hashlib
import importlib.metadata as metadata
import json
import os
import re
import shutil
import sys
import tempfile
import threading
import time
from pathlib import Path
from typing import Any

import cv2
import numpy as np
import psutil
import torch
from paddleocr import PaddleOCR
from PIL import Image
from transformers import TrOCRProcessor, VisionEncoderDecoderModel

OCR_MODULE_DIR = Path(__file__).resolve().parents[1] / "ocr"
sys.path.insert(0, str(OCR_MODULE_DIR))
from routing import detect_page_structure, resolve_fallback, route_page
from schema import build_record
SYNTHETIC_DIR = Path(os.environ["FCS_SYNTHETIC_DIR"])
GENUINE_DIR = Path(os.environ["FCS_GENUINE_DIR"])
ARTIFACT_DIR = Path(os.environ["G2A1_R2_ARTIFACT_DIR"])
MODEL_ID = "microsoft/trocr-small-handwritten"
MODEL_REVISION = "959398e1e35ce99c83e60f83b35c1187d4508a0b"
CRITICAL_RE = re.compile(r"\b\d+(?:\.\d+|\s*/\s*\d+)?\s*(?:tsp|tbsp|teaspoons?|tablespoons?|cup|cups|g|ml|°\s*[FC]|min|hr|hours?)\b", re.I)


def import_version(name: str) -> str | None:
    try:
        return metadata.version(name)
    except metadata.PackageNotFoundError:
        return None


def load_prediction_json(result: Any) -> dict[str, Any]:
    payload = getattr(result, "json", {})
    if callable(payload):
        payload = payload()
    if isinstance(payload, str):
        payload = json.loads(payload)
    if not isinstance(payload, dict):
        return {}
    return payload.get("res", payload) if isinstance(payload.get("res", payload), dict) else {}


def result_to_lines(result: Any) -> list[dict[str, Any]]:
    data = load_prediction_json(result)
    texts = data.get("rec_texts", [])
    scores = data.get("rec_scores", [])
    boxes = data.get("rec_boxes", data.get("rec_polys", []))
    lines = []
    for i, text in enumerate(texts):
        bbox = None
        if i < len(boxes):
            arr = np.asarray(boxes[i]).reshape(-1, 2)
            bbox = [int(arr[:, 0].min()), int(arr[:, 1].min()), int(arr[:, 0].max()), int(arr[:, 1].max())]
        score = float(scores[i]) if i < len(scores) else None
        lines.append({"text": str(text), "confidence": score, "bbox": bbox})
    return sorted(lines, key=lambda x: ((x["bbox"] or [0, 0])[1], (x["bbox"] or [0, 0])[0]))


def preprocess(source: Path, target: Path) -> dict[str, Any]:
    image = cv2.imread(str(source), cv2.IMREAD_COLOR)
    if image is None:
        raise ValueError(f"Image decode failed: {source.name}")
    lab = cv2.cvtColor(image, cv2.COLOR_BGR2LAB)
    light, a, b = cv2.split(lab)
    light = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8)).apply(light)
    derived = cv2.cvtColor(cv2.merge((light, a, b)), cv2.COLOR_LAB2BGR)
    cv2.imwrite(str(target), derived)
    return {
        "source_size_px": [int(image.shape[1]), int(image.shape[0])],
        "preprocessed_size_px": [int(derived.shape[1]), int(derived.shape[0])],
        "operation": "LAB-lightness CLAHE clipLimit=2.0 tileGrid=8x8",
        "source_immutable": True,
    }


def crop_line(image_path: Path, bbox: list[int], target: Path) -> Path:
    image = cv2.imread(str(image_path), cv2.IMREAD_COLOR)
    if image is None:
        raise ValueError(f"Crop source unreadable: {image_path.name}")
    h, w = image.shape[:2]
    x1, y1, x2, y2 = bbox
    padx, pady = max(12, int((x2 - x1) * 0.08)), max(8, int((y2 - y1) * 0.35))
    crop = image[max(0, y1 - pady):min(h, y2 + pady), max(0, x1 - padx):min(w, x2 + padx)]
    target.parent.mkdir(parents=True, exist_ok=True)
    if crop.size == 0:
        raise ValueError(f"Empty routed crop for {image_path.name}")
    cv2.imwrite(str(target), crop)
    return target


def exact_line_metrics(expected: list[str], actual: list[dict[str, Any]]) -> dict[str, Any]:
    norm = lambda s: re.sub(r"\s+", " ", s).strip().casefold()
    expected_norm = [norm(x) for x in expected]
    actual_norm = [norm(x.get("text", "")) for x in actual if norm(x.get("text", ""))]
    remaining = list(actual_norm)
    missing = []
    for line in expected_norm:
        if line in remaining:
            remaining.remove(line)
        else:
            missing.append(line)
    return {
        "expected_line_count": len(expected_norm),
        "recognized_line_count": len(actual_norm),
        "exact_missing_lines": missing,
        "exact_extra_lines": remaining,
        "raw_line_errors": len(missing) + len(remaining),
    }


def critical_metrics(expected: list[str], actual: list[dict[str, Any]]) -> dict[str, Any]:
    fields = [m.group(0) for line in expected for m in CRITICAL_RE.finditer(line)]
    raw = "\n".join(x.get("text", "") for x in actual)
    missing = [field for field in fields if field.casefold() not in raw.casefold()]
    return {
        "expected_critical_field_count": len(fields),
        "critical_field_errors": len(missing),
        "critical_field_error_values": missing,
    }


def cache_inventory(paths: list[Path]) -> dict[str, Any]:
    files = []
    for root in paths:
        if not root.exists():
            continue
        for item in root.rglob("*"):
            if item.is_file() and item.suffix.lower() in {".pdparams", ".safetensors", ".bin", ".onnx"}:
                try:
                    hasher = hashlib.sha256()
                    with item.open("rb") as stream:
                        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
                            hasher.update(chunk)
                    files.append({"name": item.name, "bytes": item.stat().st_size, "sha256": hasher.hexdigest()})
                except (OSError, PermissionError):
                    continue
    return {"weight_file_count": len(files), "weight_bytes": sum(x["bytes"] for x in files), "weight_files": files}


def read_preflight() -> dict[str, Any]:
    path = ARTIFACT_DIR / "runner-preflight.json"
    return json.loads(path.read_text(encoding="utf-8")) if path.exists() else {}


def main() -> None:
    ARTIFACT_DIR.mkdir(parents=True, exist_ok=True)
    (ARTIFACT_DIR / "ocr").mkdir(exist_ok=True)
    (ARTIFACT_DIR / "ocr" / "fallback-crops").mkdir(exist_ok=True)
    sources_path = GENUINE_DIR / "genuine-handwriting-sources.json"
    genuine_manifest = json.loads(sources_path.read_text(encoding="utf-8"))
    synthetic_meta = json.loads((SYNTHETIC_DIR / "fixtures.json").read_text(encoding="utf-8"))
    synthetic = []
    for item in synthetic_meta["fixtures"]:
        item = dict(item)
        item["source_image_path"] = str(SYNTHETIC_DIR / f"{item['id']}.png")
        synthetic.append(item)
    genuine = []
    for item in genuine_manifest["samples"]:
        genuine.append({
            "id": item["id"], "fixture_class": "GENUINE_HANDWRITING",
            "lines": [item["source_text"]], "title": None,
            "source_image_path": str(GENUINE_DIR / item["source_image_path"]), "source_metadata": item,
        })

    cpu_start = time.process_time()
    disk_free_at_model_start = shutil.disk_usage("/").free
    process = psutil.Process()
    rss_start = process.memory_info().rss
    memory_available_start = psutil.virtual_memory().available
    memory_min = [memory_available_start]
    rss_peak = [rss_start]
    stop_monitor = threading.Event()

    def monitor() -> None:
        while not stop_monitor.wait(0.2):
            try:
                rss_peak[0] = max(rss_peak[0], process.memory_info().rss)
                memory_min[0] = min(memory_min[0], psutil.virtual_memory().available)
            except psutil.Error:
                return

    thread = threading.Thread(target=monitor, daemon=True)
    thread.start()
    gpu_available = torch.cuda.is_available()
    if gpu_available:
        raise RuntimeError("This workflow is specified as CPU-only, but CUDA unexpectedly became available")
    paddle_engine = os.environ.get("FCS_PADDLE_ENGINE", "transformers")
    paddle_version = import_version("paddleocr")
    paddlex_version = import_version("paddlex")
    transformers_version = import_version("transformers")
    torch_version = str(torch.__version__)
    pipeline_start = time.perf_counter()
    ocr = PaddleOCR(
        lang="en",
        device="cpu",
        ocr_version="PP-OCRv5",
        text_detection_model_name="PP-OCRv5_server_det",
        text_recognition_model_name="PP-OCRv5_server_rec",
        use_doc_orientation_classify=False,
        use_doc_unwarping=False,
        use_textline_orientation=False,
        engine=paddle_engine,
    )
    initialization_seconds = time.perf_counter() - pipeline_start
    trocr = None
    processor = None
    trocr_load_seconds = 0.0
    fallback_rows: list[dict[str, Any]] = []
    page_rows: list[dict[str, Any]] = []

    with tempfile.TemporaryDirectory(prefix="family-cookbook-g2a1-r2-preprocess-") as tmp:
        temp_dir = Path(tmp)
        for group_name, dataset in (("SYNTHETIC_TYPOGRAPHY", synthetic), ("GENUINE_HANDWRITING", genuine)):
            for fixture in dataset:
                source = Path(fixture["source_image_path"])
                derived = temp_dir / f"{fixture['id']}.png"
                preprocessing = preprocess(source, derived)
                started = time.perf_counter()
                prediction = ocr.predict(str(derived))
                paddle_latency = (time.perf_counter() - started) * 1000
                result_obj = prediction[0] if prediction else None
                lines = result_to_lines(result_obj) if result_obj is not None else []
                raw_text = "\n".join(line["text"] for line in lines)
                expected = [str(x).strip() for x in fixture.get("lines", []) if str(x).strip()]
                line_metrics = exact_line_metrics(expected, lines)
                critical = critical_metrics(expected, lines) if group_name == "SYNTHETIC_TYPOGRAPHY" else {
                    "expected_critical_field_count": 0, "critical_field_errors": 0, "critical_field_error_values": [],
                }
                page_issues = detect_page_structure(lines) if group_name == "SYNTHETIC_TYPOGRAPHY" else []
                routes = route_page(lines)
                routed = [(i, route) for i, route in enumerate(routes) if route.fallback]
                if group_name == "GENUINE_HANDWRITING" and not lines:
                    # Each genuine fixture is itself one source line crop. A no-text result is a suspicious crop.
                    routed = [(None, type("RouteValue", (), {"fallback": True, "reasons": ["paddle_missing_text_on_known_handwriting_crop"], "critical": True})())]
                unresolved_route_count = 0
                for index, route in routed:
                    if index is None:
                        crop_path = source
                        paddle_line = {"text": "", "confidence": None, "bbox": None}
                    else:
                        paddle_line = lines[index]
                        bbox = paddle_line.get("bbox")
                        if not bbox:
                            unresolved_route_count += 1
                            fallback_rows.append({
                                "fixture": fixture["id"], "fixture_class": group_name,
                                "source_crop": None, "paddle_result": paddle_line,
                                "routing_reason": route.reasons, "trocr_result": None,
                                "resolved": False, "USER_CONFIRM_REQUIRED": True,
                                "latency_ms": None, "status": "BLOCKED_MISSING_SOURCE_COORDINATES",
                            })
                            continue
                        crop_path = crop_line(source, bbox, ARTIFACT_DIR / "ocr" / "fallback-crops" / f"{fixture['id']}-line-{index}.png")
                    if crop_path == source and group_name != "GENUINE_HANDWRITING":
                        unresolved_route_count += 1
                        continue
                    if processor is None:
                        trocr_load_started = time.perf_counter()
                        processor = TrOCRProcessor.from_pretrained(MODEL_ID, revision=MODEL_REVISION)
                        trocr = VisionEncoderDecoderModel.from_pretrained(MODEL_ID, revision=MODEL_REVISION).to("cpu").eval()
                        trocr_load_seconds = time.perf_counter() - trocr_load_started
                    with Image.open(crop_path) as im:
                        pixel_values = processor(images=im.convert("RGB"), return_tensors="pt").pixel_values
                    start_fallback = time.perf_counter()
                    with torch.inference_mode():
                        generated = trocr.generate(pixel_values, max_new_tokens=96)
                    trocr_text = processor.batch_decode(generated, skip_special_tokens=True)[0]
                    fallback_latency = (time.perf_counter() - start_fallback) * 1000
                    resolution = resolve_fallback(paddle_line.get("text", ""), trocr_text, route.reasons)
                    fallback_rows.append({
                        "fixture": fixture["id"], "fixture_class": group_name,
                        "source_crop": str(crop_path.relative_to(ARTIFACT_DIR)) if crop_path.is_relative_to(ARTIFACT_DIR) else "genuine-source-line-crop",
                        "source_crop_sha256": hashlib.sha256(crop_path.read_bytes()).hexdigest(),
                        "paddle_result": paddle_line,
                        "routing_reason": route.reasons,
                        "trocr_result": trocr_text,
                        "resolved": resolution["resolved"],
                        "USER_CONFIRM_REQUIRED": resolution["USER_CONFIRM_REQUIRED"],
                        "resolution_reason": resolution["reason"],
                        "latency_ms": round(fallback_latency, 2),
                    })
                    unresolved_route_count += int(resolution["USER_CONFIRM_REQUIRED"])
                missing_count = len(line_metrics["exact_missing_lines"])
                structure_count = len(page_issues)
                critical_count = critical["critical_field_errors"]
                confirm_without_trocr = max(len(routed), missing_count, structure_count, critical_count)
                confirm_count = max(unresolved_route_count, missing_count, structure_count, critical_count)
                record = None
                if group_name == "SYNTHETIC_TYPOGRAPHY":
                    schema_lines = [dict(line) for line in lines]
                    record = build_record(fixture["id"], "synthetic/" + fixture["id"] + ".png", schema_lines, fixture.get("title"))
                page_rows.append({
                    "fixture": fixture["id"],
                    "fixture_class": group_name,
                    "input": fixture.get("source_metadata", {}).get("source_member") if fixture.get("source_metadata") else f"synthetic/{fixture['id']}.png",
                    "source_image_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
                    "preprocessing": preprocessing,
                    "paddle_full_page_raw": raw_text,
                    "paddle_lines": lines,
                    "paddle_coordinates": [line.get("bbox") for line in lines],
                    "paddle_confidences": [line.get("confidence") for line in lines],
                    "paddle_latency_ms": round(paddle_latency, 2),
                    "line_metrics": line_metrics,
                    "critical_metrics": critical,
                    "page_structure_issues": page_issues,
                    "suspicious_regions": len(routed),
                    "user_confirm_without_trocr_count": confirm_without_trocr,
                    "user_confirm_required_count": confirm_count,
                    "schema_probe": record,
                })

    stop_monitor.set()
    thread.join(timeout=2)
    fallback_done = [x for x in fallback_rows if x["trocr_result"] is not None]
    fallback_fixture_ids = {x["fixture"] for x in fallback_done}
    user_confirm_total = sum(x["user_confirm_required_count"] for x in page_rows)
    no_confirm_pages = sum(x["user_confirm_required_count"] == 0 for x in page_rows)
    pages_by_class = {}
    for class_name in ("SYNTHETIC_TYPOGRAPHY", "GENUINE_HANDWRITING"):
        rows = [x for x in page_rows if x["fixture_class"] == class_name]
        pages_by_class[class_name] = {
            "pages_processed": len(rows),
            "recognized_lines": sum(len(x["paddle_lines"]) for x in rows),
            "raw_ocr_error_lines": sum(x["line_metrics"]["raw_line_errors"] for x in rows),
            "missing_lines": sum(len(x["line_metrics"]["exact_missing_lines"]) for x in rows),
            "critical_field_errors": sum(x["critical_metrics"]["critical_field_errors"] for x in rows),
            "suspicious_regions": sum(x["suspicious_regions"] for x in rows),
            "user_confirm_without_trocr_total": sum(x["user_confirm_without_trocr_count"] for x in rows),
            "user_confirm_required_total": sum(x["user_confirm_required_count"] for x in rows),
            "confirmations_per_page": round(sum(x["user_confirm_required_count"] for x in rows) / len(rows), 3) if rows else None,
            "pages_without_confirmation_ratio": round(sum(x["user_confirm_required_count"] == 0 for x in rows) / len(rows), 4) if rows else None,
            "average_paddle_latency_ms": round(sum(x["paddle_latency_ms"] for x in rows) / len(rows), 2) if rows else None,
        }
    run_seconds = sum(x["paddle_latency_ms"] for x in page_rows) / 1000
    summary = {
        "gate": "G2A1-R2",
        "status": "MEASURED",
        "primary_engine": "PaddleOCR",
        "primary_engine_version": paddle_version,
        "paddlex_version": paddlex_version,
        "paddlepaddle_installed": import_version("paddlepaddle"),
        "paddle_runtime_engine": paddle_engine,
        "transformers_version": transformers_version,
        "torch_version": torch_version,
        "paddle_models": {
            "detector": "PP-OCRv5_server_det",
            "recognizer": "PP-OCRv5_server_rec",
            "model_revision": "PaddleX/PaddleOCR release family 3.7; package source does not publish a Hub revision; downloaded weight hashes recorded below.",
            "device": "CPU",
        },
        "trocr": {
            "model_id": MODEL_ID,
            "model_load_seconds": round(trocr_load_seconds, 3) if trocr is not None else None,
            "revision": MODEL_REVISION,
            "resolved_model_commit": getattr(trocr.config, "_commit_hash", None) if trocr is not None else None,
            "device": "CPU",
            "weight_inventory": cache_inventory([Path.home() / ".cache/huggingface/hub"]),
        },
        "runtime": {
            "runner": read_preflight(),
            "initialization_seconds": round(initialization_seconds, 3),
            "paddle_inference_seconds_total": round(run_seconds, 3),
            "paddle_pages_processed": len(page_rows),
            "ocr_process_cpu_seconds": round(time.process_time() - cpu_start, 3),
            "ocr_process_ram_start_bytes": rss_start,
            "ocr_process_ram_peak_sampled_bytes": rss_peak[0],
            "ocr_process_ram_delta_bytes": process.memory_info().rss - rss_start,
            "system_ram_available_start_bytes": memory_available_start,
            "system_ram_available_min_bytes_sampled": memory_min[0],
            "system_ram_available_end_bytes": psutil.virtual_memory().available,
            "cpu_count_logical": psutil.cpu_count(),
            "root_disk_free_at_model_start_bytes": disk_free_at_model_start,
            "root_disk_free_at_model_end_bytes": shutil.disk_usage("/").free,
            "model_weight_bytes_total": (cache_inventory([Path.home() / ".paddlex", Path.home() / ".cache/paddlex"])["weight_bytes"] + cache_inventory([Path.home() / ".cache/huggingface/hub"])["weight_bytes"]),
            "gpu": {"available": False, "vram_bytes": None, "reason": "GitHub hosted Ubuntu CPU runner"},
            "paddle_model_cache": cache_inventory([Path.home() / ".paddlex", Path.home() / ".cache/paddlex"]),
            "model_api_tokens": 0,
            "cloud_inference": False,
        },
        "metrics_by_fixture_class": pages_by_class,
        "total": {
            "pages_processed": len(page_rows),
            "recognized_lines": sum(len(x["paddle_lines"]) for x in page_rows),
            "raw_ocr_error_lines": sum(x["line_metrics"]["raw_line_errors"] for x in page_rows),
            "missing_lines": sum(len(x["line_metrics"]["exact_missing_lines"]) for x in page_rows),
            "critical_field_errors": sum(x["critical_metrics"]["critical_field_errors"] for x in page_rows),
            "suspicious_regions": sum(x["suspicious_regions"] for x in page_rows),
            "trocr_fallback_count": len(fallback_done),
            "trocr_fallback_rate": round(len(fallback_fixture_ids) / len(page_rows), 4) if page_rows else None,
            "trocr_calls_per_page": round(len(fallback_done) / len(page_rows), 4) if page_rows else None,
            "trocr_resolved_count": sum(bool(x["resolved"]) for x in fallback_done),
            "trocr_unresolved_count": sum(bool(x["USER_CONFIRM_REQUIRED"]) for x in fallback_done),
            "engine_disagreement_count": sum(x.get("resolution_reason") == "engine_disagreement" for x in fallback_done),
            "USER_CONFIRM_REQUIRED": user_confirm_total,
            "user_confirm_without_trocr_total": sum(x["user_confirm_without_trocr_count"] for x in page_rows),
            "user_confirm_reduced_by_trocr": max(0, sum(x["user_confirm_without_trocr_count"] for x in page_rows) - user_confirm_total),
            "confirmations_per_page": round(user_confirm_total / len(page_rows), 3) if page_rows else None,
            "pages_without_confirmation": no_confirm_pages,
            "pages_without_confirmation_ratio": round(no_confirm_pages / len(page_rows), 4) if page_rows else None,
        },
        "fallbacks": fallback_rows,
        "fixtures": page_rows,
    }
    (ARTIFACT_DIR / "ocr" / "ocr-benchmark.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    (ARTIFACT_DIR / "ocr" / "trocr-fallback-results.json").write_text(
        json.dumps({"model_id": MODEL_ID, "revision": MODEL_REVISION, "fallback_count": len(fallback_done), "fallbacks": fallback_rows}, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(json.dumps({"status": summary["status"], "versions": {"paddleocr": paddle_version, "paddlex": paddlex_version, "transformers": transformers_version, "torch": torch_version}, "total": summary["total"], "classes": pages_by_class}, ensure_ascii=False, indent=2))
    if len(page_rows) == 0:
        raise SystemExit("No PaddleOCR inputs were processed")


if __name__ == "__main__":
    main()
