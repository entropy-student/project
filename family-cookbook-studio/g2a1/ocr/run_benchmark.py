"""Run the approved PaddleOCR page pass and crop-only TrOCR fallback."""
from __future__ import annotations

import json
import re
import shutil
import subprocess
import tempfile
import threading
import time
from importlib.metadata import version
from pathlib import Path
from typing import Any

import cv2
import numpy as np
import psutil
from paddleocr import PaddleOCR

from routing import detect_page_structure, resolve_fallback, route_page
from schema import build_record

ROOT = Path(__file__).parent
FIXTURE_DIR = ROOT / "fixtures"
FIXTURES = json.loads((FIXTURE_DIR / "fixtures.json").read_text(encoding="utf-8"))["fixtures"]
OUT = ROOT / "benchmark-output.json"
CRITICAL = re.compile(r"\b\d+(?:\.\d+|\s*/\s*\d+)?\s*(?:tsp|tbsp|teaspoons?|tablespoons?|cup|cups|g|ml|°\s*[FC]|min|hr|hours?)\b", re.I)


def preprocess(source: Path, target: Path) -> dict[str, Any]:
    image = cv2.imread(str(source), cv2.IMREAD_COLOR)
    if image is None:
        raise ValueError(f"Image decode failed: {source.name}")
    # CLAHE is a derived working copy; the synthetic source image remains immutable.
    lab = cv2.cvtColor(image, cv2.COLOR_BGR2LAB)
    light, a, b = cv2.split(lab)
    light = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8)).apply(light)
    derived = cv2.cvtColor(cv2.merge((light, a, b)), cv2.COLOR_LAB2BGR)
    cv2.imwrite(str(target), derived)
    return {"source_size_px": [int(image.shape[1]), int(image.shape[0])], "derived_size_px": [int(derived.shape[1]), int(derived.shape[0])], "operation": "LAB-lightness CLAHE clipLimit=2.0 tileGrid=8x8", "source_immutable": True}


def result_to_lines(result: Any) -> list[dict[str, Any]]:
    payload = getattr(result, "json", {})
    if callable(payload):
        payload = payload()
    if isinstance(payload, str):
        payload = json.loads(payload)
    data = payload.get("res", payload) if isinstance(payload, dict) else {}
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


def expected_lines(fixture: dict[str, Any]) -> list[str]:
    return [str(s).strip() for s in fixture["lines"] if str(s).strip()]


def line_metrics(expected: list[str], actual: list[dict[str, Any]]) -> dict[str, Any]:
    seen = [re.sub(r"\s+", " ", x.get("text", "")).strip().casefold() for x in actual]
    missing = [line for line in expected if re.sub(r"\s+", " ", line).strip().casefold() not in seen]
    return {"expected_line_count": len(expected), "recognized_line_count": len(actual), "raw_line_errors": len(missing), "missing_lines": missing}


def critical_metrics(fixture: dict[str, Any], actual: list[dict[str, Any]], routed_indexes: set[int]) -> dict[str, Any]:
    expected_fields = []
    for line in expected_lines(fixture):
        expected_fields.extend(m.group(0) for m in CRITICAL.finditer(line))
    actual_text = "\n".join(x.get("text", "") for x in actual).casefold()
    errors = [field for field in expected_fields if field.casefold() not in actual_text]
    detected = []
    for i, line in enumerate(actual):
        for m in CRITICAL.finditer(line.get("text", "")):
            if i in routed_indexes:
                detected.append(m.group(0))
    return {"expected_critical_field_count": len(expected_fields), "critical_field_errors": len(errors), "critical_field_error_values": errors, "suspicious_critical_fields_routed": detected}


def crop_line(image_path: Path, bbox: list[int], output_path: Path) -> Path:
    image = cv2.imread(str(image_path))
    h, w = image.shape[:2]
    x1, y1, x2, y2 = bbox
    padx, pady = max(12, int((x2 - x1) * .08)), max(8, int((y2 - y1) * .35))
    crop = image[max(0, y1 - pady):min(h, y2 + pady), max(0, x1 - padx):min(w, x2 + padx)]
    output_path.parent.mkdir(parents=True, exist_ok=True)
    cv2.imwrite(str(output_path), crop)
    return output_path


def nvidia_snapshot() -> str | None:
    executable = shutil.which("nvidia-smi")
    if not executable:
        return None
    result = subprocess.run([executable, "--query-gpu=name,memory.used,memory.total,utilization.gpu", "--format=csv,noheader,nounits"], capture_output=True, text=True, check=False)
    return result.stdout.strip() if result.returncode == 0 else None


def main() -> None:
    proc = psutil.Process()
    ram_start = proc.memory_info().rss
    cpu_start = time.process_time()
    system_ram_start = psutil.virtual_memory().available
    peak_rss = [ram_start]
    peak_available = [system_ram_start]
    monitor_stop = threading.Event()
    def monitor() -> None:
        while not monitor_stop.wait(.1):
            peak_rss[0] = max(peak_rss[0], proc.memory_info().rss)
            peak_available[0] = min(peak_available[0], psutil.virtual_memory().available)
    monitor_thread = threading.Thread(target=monitor, daemon=True)
    monitor_thread.start()
    gpu_start = nvidia_snapshot()
    try:
        import paddle
        paddle_meta = {"paddleocr_version": version("paddleocr"), "paddlepaddle_version": paddle.__version__, "detector_model": "PP-OCRv5_server_det", "recognizer_model": "PP-OCRv5_server_rec", "device": "cpu", "cuda_compiled": bool(paddle.device.is_compiled_with_cuda())}
    except Exception as exc:
        raise RuntimeError(f"Paddle runtime inspection failed: {exc}") from exc
    ocr = PaddleOCR(lang="en", device="cpu", ocr_version="PP-OCRv5", text_detection_model_name="PP-OCRv5_server_det", text_recognition_model_name="PP-OCRv5_server_rec", use_doc_orientation_classify=False, use_doc_unwarping=False, use_textline_orientation=False)
    outputs, fallback_rows = [], []
    trocr = processor = None
    fallback_crop_dir = ROOT / "fallback-crops"
    with tempfile.TemporaryDirectory(prefix="family-cookbook-g2a1-preprocess-") as tmp:
        tmp_path = Path(tmp)
        for fixture in FIXTURES:
            source = FIXTURE_DIR / f"{fixture['id']}.png"
            derived = tmp_path / f"{fixture['id']}.png"
            prep = preprocess(source, derived)
            started = time.perf_counter()
            prediction = ocr.predict(str(derived))
            latency_ms = (time.perf_counter() - started) * 1000
            lines = result_to_lines(prediction[0]) if prediction else []
            routes = list(enumerate(route_page(lines)))
            routed_indexes = {i for i, route in routes if route.fallback}
            page_issues = detect_page_structure(lines)
            recipe_record = build_record(fixture["id"], f"fixtures/{fixture['id']}.png", lines, fixture["title"])
            unresolved_page_issues = bool(page_issues)
            user_required = unresolved_page_issues
            paddle_raw = "\n".join(x["text"] for x in lines)
            for i, route in routes:
                if not route.fallback:
                    continue
                line = lines[i]
                row = {"fixture": fixture["id"], "source_crop": None, "bbox": line.get("bbox"), "paddle_result": line, "trocr_result": None, "reason_for_fallback": route.reasons, "resolved": False, "USER_CONFIRM_REQUIRED": True}
                if not line.get("bbox"):
                    row["reason_for_fallback"].append("source_coordinates_unavailable")
                    fallback_rows.append(row)
                    user_required = True
                    continue
                crop_path = crop_line(source, line["bbox"], fallback_crop_dir / f"{fixture['id']}-line-{i}.png")
                row["source_crop"] = str(crop_path.relative_to(ROOT))
                if processor is None:
                    import torch
                    from PIL import Image
                    from transformers import TrOCRProcessor, VisionEncoderDecoderModel
                    model_id = "microsoft/trocr-base-handwritten"
                    processor = TrOCRProcessor.from_pretrained(model_id)
                    trocr = VisionEncoderDecoderModel.from_pretrained(model_id)
                    device = "cuda" if torch.cuda.is_available() else "cpu"
                    trocr.to(device).eval()
                    paddle_meta["trocr_model_id"] = model_id
                    paddle_meta["trocr_device"] = device
                    paddle_meta["trocr_model_commit"] = getattr(trocr.config, "_commit_hash", None)
                    paddle_meta["transformers_version"] = version("transformers")
                import torch
                from PIL import Image
                device = next(trocr.parameters()).device
                trocr_started = time.perf_counter()
                inputs = processor(images=Image.open(crop_path).convert("RGB"), return_tensors="pt").pixel_values.to(device)
                generated = trocr.generate(inputs, max_new_tokens=96)
                trocr_text = processor.batch_decode(generated, skip_special_tokens=True)[0]
                trocr_latency_ms = (time.perf_counter() - trocr_started) * 1000
                resolution = resolve_fallback(line["text"], trocr_text, route.reasons)
                row.update({"trocr_result": trocr_text, "trocr_latency_ms": round(trocr_latency_ms, 2), "resolved": resolution["resolved"], "USER_CONFIRM_REQUIRED": resolution["USER_CONFIRM_REQUIRED"], "resolution_reason": resolution["reason"]})
                user_required = user_required or resolution["USER_CONFIRM_REQUIRED"]
                fallback_rows.append(row)
            outputs.append({
                "fixture": fixture["id"], "fixture_class": fixture["fixture_class"], "input": str(source.relative_to(ROOT)), "preprocessing": prep,
                "paddle_full_page_raw": paddle_raw, "paddle_lines": lines, "latency_ms": round(latency_ms, 2),
                "line_metrics": line_metrics(expected_lines(fixture), lines),
                "critical_metrics": critical_metrics(fixture, lines, routed_indexes),
                "page_structure_issues": page_issues, "suspicious_line_count": len(routed_indexes),
                "user_confirm_required_count": sum(1 for row in fallback_rows if row["fixture"] == fixture["id"] and row["USER_CONFIRM_REQUIRED"]) + len(page_issues),
                "recipe_record": recipe_record
            })
    fallbacks_done = [r for r in fallback_rows if r["trocr_result"] is not None]
    monitor_stop.set()
    monitor_thread.join(timeout=2)
    try:
        import torch
        torch_meta = {"version": torch.__version__, "cuda_available": torch.cuda.is_available(), "cuda_peak_allocated_bytes": int(torch.cuda.max_memory_allocated()) if torch.cuda.is_available() and trocr is not None else None}
    except Exception:
        torch_meta = None
    summary = {
        "status": "MEASURED", "fixture_count": len(FIXTURES), "paddle": paddle_meta,
        "raw_ocr_error_lines": sum(x["line_metrics"]["raw_line_errors"] for x in outputs),
        "critical_field_errors": sum(x["critical_metrics"]["critical_field_errors"] for x in outputs),
        "missing_lines": sum(len(x["line_metrics"]["missing_lines"]) for x in outputs),
        "suspicious_regions": sum(x["suspicious_line_count"] for x in outputs),
        "trocr_fallback_count": len(fallbacks_done), "fallback_rate": len(fallbacks_done) / len(FIXTURES),
        "fallback_resolved": sum(bool(x["resolved"]) for x in fallbacks_done),
        "fallback_unresolved": sum(bool(x["USER_CONFIRM_REQUIRED"]) for x in fallback_rows),
        "engine_conflicts": sum(x.get("resolution_reason") == "engine_disagreement" for x in fallback_rows),
        "user_confirm_required_total": sum(x["user_confirm_required_count"] for x in outputs),
        "confirmations_per_page": sum(x["user_confirm_required_count"] for x in outputs) / len(outputs),
        "pages_without_confirmation_ratio": sum(x["user_confirm_required_count"] == 0 for x in outputs) / len(outputs),
        "latency_average_ms": round(sum(x["latency_ms"] for x in outputs) / len(outputs), 2),
        "process_cpu_seconds": round(time.process_time() - cpu_start, 3),
        "process_ram_delta_bytes": proc.memory_info().rss - ram_start,
        "process_peak_rss_bytes_sampled": peak_rss[0],
        "system_ram_available_start_bytes": system_ram_start,
        "system_ram_available_min_bytes_sampled": peak_available[0],
        "system_ram_available_end_bytes": psutil.virtual_memory().available,
        "gpu_snapshot_start_nvidia_smi": gpu_start,
        "gpu_snapshot_end_nvidia_smi": nvidia_snapshot(),
        "torch_runtime": torch_meta,
        "model_api_tokens": 0, "cloud_inference": False, "fallbacks": fallback_rows, "fixtures": outputs
    }
    OUT.write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({k: v for k, v in summary.items() if k not in {"fixtures", "fallbacks"}}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
