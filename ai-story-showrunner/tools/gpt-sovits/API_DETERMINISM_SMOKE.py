from __future__ import annotations

import hashlib
import json
import math
import os
import socket
import struct
import time
import urllib.error
import urllib.parse
import urllib.request
import wave
from pathlib import Path

API = "http://127.0.0.1:9880"
ROOT = Path(r"C:\AI\GPT-SoVITS")
GPT_WEIGHT = ROOT / "GPT_weights_v2ProPlus" / "narrator01_v2pp-e5.ckpt"
SOVITS_WEIGHT = ROOT / "SoVITS_weights_v2ProPlus" / "narrator01_v2pp_e8_s248.pth"
OUT_DIR = ROOT / "TEMP" / "story-showrunner-api-smoke"
TARGET_TEXT = "我原本以为，这只是一次普通的搜索结果。"
SEED = 1986

def clean_path(s: str) -> str:
    return s.strip().strip('"').strip("'")

def wait_port(host: str = "127.0.0.1", port: int = 9880, timeout: int = 180) -> None:
    deadline = time.time() + timeout
    while time.time() < deadline:
        try:
            with socket.create_connection((host, port), timeout=1):
                return
        except OSError:
            time.sleep(2)
    raise SystemExit("RESULT=RETURN_API_NOT_READY")

def get_json(path: str, params: dict) -> dict:
    url = API + path + "?" + urllib.parse.urlencode(params)
    try:
        with urllib.request.urlopen(url, timeout=120) as r:
            body = r.read()
            ctype = r.headers.get("content-type", "")
    except urllib.error.HTTPError as e:
        raise RuntimeError(f"{path} HTTP {e.code}: {e.read().decode('utf-8', 'replace')}") from e
    if "json" in ctype:
        return json.loads(body.decode("utf-8"))
    return {"raw": body.decode("utf-8", "replace")}

def post_tts(payload: dict) -> bytes:
    data = json.dumps(payload, ensure_ascii=False).encode("utf-8")
    req = urllib.request.Request(
        API + "/tts",
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=240) as r:
            body = r.read()
            ctype = r.headers.get("content-type", "")
    except urllib.error.HTTPError as e:
        raise RuntimeError(f"/tts HTTP {e.code}: {e.read().decode('utf-8', 'replace')}") from e
    if "json" in ctype:
        raise RuntimeError(body.decode("utf-8", "replace"))
    return body

def wav_stats(path: Path) -> dict:
    with wave.open(str(path), "rb") as w:
        channels = w.getnchannels()
        width = w.getsampwidth()
        sr = w.getframerate()
        frames = w.getnframes()
        pcm = w.readframes(frames)
    duration = frames / sr if sr else 0.0
    rms_dbfs = None
    peak = None
    if width == 2 and pcm:
        count = len(pcm) // 2
        vals = struct.unpack("<" + "h" * count, pcm)
        sq = sum(v * v for v in vals) / max(1, count)
        rms = math.sqrt(sq)
        peak = max(abs(v) for v in vals)
        rms_dbfs = 20 * math.log10(max(rms, 1e-9) / 32768.0)
    return {
        "sample_rate": sr,
        "channels": channels,
        "sample_width": width,
        "frames": frames,
        "duration_sec": round(duration, 4),
        "rms_dbfs": None if rms_dbfs is None else round(rms_dbfs, 2),
        "peak": peak,
    }

def main() -> None:
    print("GATE=GPT_SOVITS_API_DETERMINISM_SMOKE")
    print(f"GPT={GPT_WEIGHT}")
    print(f"SOVITS={SOVITS_WEIGHT}")
    print(f"SEED={SEED}")
    print(f"TARGET_TEXT={TARGET_TEXT}")

    if not GPT_WEIGHT.exists():
        raise SystemExit(f"RESULT=RETURN_GPT_WEIGHT_NOT_FOUND\nPATH={GPT_WEIGHT}")
    if not SOVITS_WEIGHT.exists():
        raise SystemExit(f"RESULT=RETURN_SOVITS_WEIGHT_NOT_FOUND\nPATH={SOVITS_WEIGHT}")

    ref_audio = clean_path(input("请粘贴本次已通过试听的参考音频完整路径: "))
    prompt_text = input("请粘贴这段参考音频对应的准确文本: ").strip()

    if not Path(ref_audio).exists():
        raise SystemExit(f"RESULT=RETURN_REFERENCE_AUDIO_NOT_FOUND\nPATH={ref_audio}")
    if not prompt_text:
        raise SystemExit("RESULT=RETURN_REFERENCE_TEXT_EMPTY")

    wait_port()

    print("STEP=LOAD_GPT_E5")
    print(get_json("/set_gpt_weights", {"weights_path": str(GPT_WEIGHT)}))
    print("STEP=LOAD_SOVITS_E8")
    print(get_json("/set_sovits_weights", {"weights_path": str(SOVITS_WEIGHT)}))

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    payload = {
        "text": TARGET_TEXT,
        "text_lang": "zh",
        "ref_audio_path": ref_audio,
        "aux_ref_audio_paths": [],
        "prompt_text": prompt_text,
        "prompt_lang": "zh",
        "top_k": 15,
        "top_p": 1.0,
        "temperature": 0.8,
        "text_split_method": "cut0",
        "batch_size": 1,
        "batch_threshold": 0.75,
        "split_bucket": False,
        "speed_factor": 1.0,
        "fragment_interval": 0.3,
        "seed": SEED,
        "media_type": "wav",
        "streaming_mode": False,
        "parallel_infer": False,
        "repetition_penalty": 1.35,
        "sample_steps": 32,
        "super_sampling": False,
    }

    rows = []
    for i in range(1, 4):
        print(f"STEP=GENERATE_{i}")
        body = post_tts(payload)
        path = OUT_DIR / f"seed-{SEED}-run-{i}.wav"
        path.write_bytes(body)
        rows.append({
            "run": i,
            "path": str(path),
            "sha256": hashlib.sha256(body).hexdigest(),
            **wav_stats(path),
        })
        print(json.dumps(rows[-1], ensure_ascii=False))

    identical = len({r["sha256"] for r in rows}) == 1
    durations = [r["duration_sec"] for r in rows]
    valid = all(d > 0.25 for d in durations)

    report = {
        "gate": "GPT_SOVITS_API_DETERMINISM_SMOKE",
        "candidate": {
            "gpt": str(GPT_WEIGHT),
            "sovits": str(SOVITS_WEIGHT),
            "temperature": 0.8,
            "top_k": 15,
            "top_p": 1.0,
            "speed": 1.0,
            "parallel_infer": False,
            "seed": SEED,
        },
        "reference_audio": ref_audio,
        "target_text": TARGET_TEXT,
        "runs": rows,
        "byte_identical": identical,
        "basic_duration_valid": valid,
    }
    report_path = OUT_DIR / "report.json"
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")

    if not valid:
        print("RESULT=RETURN_API_AUDIO_INVALID")
    elif identical:
        print("RESULT=PASS_DETERMINISTIC_BYTE_IDENTICAL")
    else:
        print("RESULT=PASS_GENERATED_REVIEW_NONIDENTICAL")
    print(f"REPORT={report_path}")
    print(f"LISTEN={rows[0]['path']}")

if __name__ == "__main__":
    main()
