from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import re
import shutil
import socket
import struct
import time
import urllib.error
import urllib.parse
import urllib.request
import wave
from pathlib import Path
from typing import Any

API_DEFAULT = "http://127.0.0.1:9880"
GPT_HOME_DEFAULT = Path(r"C:\AI\GPT-SoVITS")
GPT_WEIGHT_DEFAULT = GPT_HOME_DEFAULT / "GPT_weights_v2ProPlus" / "narrator01_v2pp-e5.ckpt"
SOVITS_WEIGHT_DEFAULT = GPT_HOME_DEFAULT / "SoVITS_weights_v2ProPlus" / "narrator01_v2pp_e8_s248.pth"

DEFAULT_TTS = {
    "top_k": 15,
    "top_p": 1.0,
    "temperature": 0.8,
    "text_split_method": "cut0",
    "batch_size": 1,
    "batch_threshold": 0.75,
    "split_bucket": False,
    "speed_factor": 1.0,
    "fragment_interval": 0.3,
    "seed": 1986,
    "media_type": "wav",
    "streaming_mode": False,
    "parallel_infer": False,
    "repetition_penalty": 1.35,
    "sample_steps": 32,
    "super_sampling": False,
}

TS_RE = re.compile(
    r"(?P<sh>\d{2}):(?P<sm>\d{2}):(?P<ss>\d{2}),(?P<sms>\d{3})"
    r"\s*-->\s*"
    r"(?P<eh>\d{2}):(?P<em>\d{2}):(?P<es>\d{2}),(?P<ems>\d{3})"
)


def parse_ts(h: str, m: str, s: str, ms: str) -> float:
    return int(h) * 3600 + int(m) * 60 + int(s) + int(ms) / 1000.0


def fmt_ts(sec: float) -> str:
    ms = max(0, int(round(sec * 1000)))
    h, ms = divmod(ms, 3_600_000)
    m, ms = divmod(ms, 60_000)
    s, ms = divmod(ms, 1_000)
    return f"{h:02d}:{m:02d}:{s:02d},{ms:03d}"


def parse_srt(path: Path) -> list[dict[str, Any]]:
    text = path.read_text(encoding="utf-8-sig")
    blocks = re.split(r"\r?\n\s*\r?\n", text.strip())
    rows: list[dict[str, Any]] = []
    for n, block in enumerate(blocks, 1):
        lines = [x.rstrip() for x in block.splitlines()]
        if not lines:
            continue
        if lines[0].strip().isdigit():
            cue_id = int(lines[0].strip())
            lines = lines[1:]
        else:
            cue_id = n
        if not lines:
            raise ValueError(f"SRT cue {cue_id}: missing timestamp")
        m = TS_RE.fullmatch(lines[0].strip())
        if not m:
            raise ValueError(f"SRT cue {cue_id}: invalid timestamp line: {lines[0]!r}")
        d = m.groupdict()
        start = parse_ts(d["sh"], d["sm"], d["ss"], d["sms"])
        end = parse_ts(d["eh"], d["em"], d["es"], d["ems"])
        if end <= start:
            raise ValueError(f"SRT cue {cue_id}: end <= start")
        display_text = "\n".join(lines[1:]).strip()
        if not display_text:
            raise ValueError(f"SRT cue {cue_id}: empty subtitle text")
        rows.append(
            {
                "index": cue_id,
                "unit_id": f"SU{len(rows)+1:03d}",
                "planned_start": start,
                "planned_end": end,
                "planned_duration": end - start,
                "display_text": display_text,
            }
        )
    if not rows:
        raise ValueError("No SRT cues found")
    for i in range(1, len(rows)):
        if rows[i]["planned_start"] < rows[i - 1]["planned_start"]:
            raise ValueError("SRT cues are not in chronological order")
    return rows


def load_synthesis_map(path: Path | None) -> dict[str, Any]:
    if not path:
        return {"by_index": {}, "by_text": {}}
    data = json.loads(path.read_text(encoding="utf-8"))
    return {
        "by_index": {str(k): str(v) for k, v in data.get("by_index", {}).items()},
        "by_text": {str(k): str(v) for k, v in data.get("by_text", {}).items()},
    }


def synthesis_text_for(row: dict[str, Any], mapping: dict[str, Any]) -> str:
    idx = str(row["index"])
    if idx in mapping["by_index"]:
        return mapping["by_index"][idx]
    flat = row["display_text"].replace("\n", " ").strip()
    if flat in mapping["by_text"]:
        return mapping["by_text"][flat]
    return flat


def wait_port(api: str, timeout: int = 45) -> None:
    u = urllib.parse.urlparse(api)
    host = u.hostname or "127.0.0.1"
    port = u.port or 80
    deadline = time.time() + timeout
    while time.time() < deadline:
        try:
            with socket.create_connection((host, port), timeout=1):
                return
        except OSError:
            time.sleep(1.5)
    raise RuntimeError(f"RETURN_GPT_SOVITS_API_NOT_READY: {host}:{port}")


def get_json(api: str, path: str, params: dict[str, Any]) -> dict[str, Any]:
    url = api.rstrip("/") + path + "?" + urllib.parse.urlencode(params)
    try:
        with urllib.request.urlopen(url, timeout=180) as r:
            body = r.read()
            ctype = r.headers.get("content-type", "")
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", "replace")
        raise RuntimeError(f"{path} HTTP {e.code}: {body}") from e
    if "json" in ctype:
        return json.loads(body.decode("utf-8"))
    return {"raw": body.decode("utf-8", "replace")}


def post_tts(api: str, payload: dict[str, Any], timeout: int = 300) -> bytes:
    data = json.dumps(payload, ensure_ascii=False).encode("utf-8")
    req = urllib.request.Request(
        api.rstrip("/") + "/tts",
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            body = r.read()
            ctype = r.headers.get("content-type", "")
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", "replace")
        raise RuntimeError(f"/tts HTTP {e.code}: {body}") from e
    if "json" in ctype:
        raise RuntimeError(body.decode("utf-8", "replace"))
    if len(body) < 44 or body[:4] != b"RIFF":
        raise RuntimeError("RETURN_TTS_NON_WAV_RESPONSE")
    return body


def wav_info(path: Path) -> dict[str, Any]:
    with wave.open(str(path), "rb") as w:
        params = w.getparams()
        frames = w.getnframes()
        duration = frames / params.framerate if params.framerate else 0.0
    return {
        "channels": params.nchannels,
        "sample_width": params.sampwidth,
        "sample_rate": params.framerate,
        "frames": frames,
        "duration_sec": duration,
        "compression": params.comptype,
    }


def atomic_json(path: Path, data: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    tmp.replace(path)


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def previous_report_rows(report_path: Path) -> dict[str, dict[str, Any]]:
    if not report_path.exists():
        return {}
    try:
        data = json.loads(report_path.read_text(encoding="utf-8"))
    except Exception:
        return {}
    return {str(r.get("speech_unit_id")): r for r in data.get("rows", [])}


def can_resume(row: dict[str, Any], old: dict[str, Any] | None, wav_path: Path, config_signature: str) -> bool:
    if not old or old.get("status") != "PASS" or not wav_path.exists():
        return False
    if old.get("display_text") != row["display_text"]:
        return False
    if old.get("synthesis_text") != row["synthesis_text"]:
        return False
    if old.get("config_signature") != config_signature:
        return False
    try:
        info = wav_info(wav_path)
    except Exception:
        return False
    return info["duration_sec"] > 0.1


def build_report(
    source_srt: Path,
    output_dir: Path,
    ref_audio: Path,
    prompt_text: str,
    args: argparse.Namespace,
    rows: list[dict[str, Any]],
    status: str,
) -> dict[str, Any]:
    return {
        "gate": "GPT_SOVITS_SRT1_TO_SRT2_MATERIAL_EXECUTOR",
        "status": status,
        "source_srt": str(source_srt),
        "output_dir": str(output_dir),
        "reference_audio": str(ref_audio),
        "reference_text": prompt_text,
        "candidate": {
            "api": args.api,
            "gpt_weight": str(args.gpt_weight),
            "sovits_weight": str(args.sovits_weight),
            "seed": args.seed,
            "top_k": args.top_k,
            "top_p": args.top_p,
            "temperature": args.temperature,
            "speed": args.speed,
            "parallel_infer": False,
        },
        "contract": {
            "input_srt_cue_is_tts_unit": True,
            "gap_mode": "preserve_planned_intercue_gap",
            "display_text_locked": True,
            "synthesis_text_override_only_via_map": True,
            "no_time_stretch_to_match_srt1": True,
            "srt2_uses_actual_generated_duration": True,
            "scope": "MATERIAL_GENERATION_SRT2_NOT_FINAL_SRT3",
        },
        "rows": rows,
    }


def write_srt2(rows: list[dict[str, Any]], path: Path) -> None:
    parts = []
    for i, r in enumerate(rows, 1):
        parts.append(
            f"{i}\n"
            f"{fmt_ts(r['actual_start_sec'])} --> {fmt_ts(r['actual_end_sec'])}\n"
            f"{r['display_text']}\n"
        )
    path.write_text("\n".join(parts), encoding="utf-8")


def write_timeline(rows: list[dict[str, Any]], path: Path) -> None:
    out = {
        "status": "SRT2_ACTUAL_MATERIAL_TIMELINE",
        "timing_truth": "actual_generated_wav_duration",
        "gap_policy": "preserve_nonnegative_intercue_gap_from_SRT1",
        "rows": [],
        "total_duration_sec": rows[-1]["actual_end_sec"] if rows else 0.0,
    }
    for r in rows:
        out["rows"].append(
            {
                "speech_unit_id": r["speech_unit_id"],
                "cue_index": r["cue_index"],
                "display_text": r["display_text"],
                "synthesis_text": r["synthesis_text"],
                "srt1_planned_start": r["planned_start_sec"],
                "srt1_planned_end": r["planned_end_sec"],
                "srt1_planned_duration": r["planned_duration_sec"],
                "preserved_gap_before_sec": r["preserved_gap_before_sec"],
                "actual_duration_sec": r["actual_duration_sec"],
                "srt2_actual_start": r["actual_start_sec"],
                "srt2_actual_end": r["actual_end_sec"],
                "duration_delta_vs_srt1_ms": r["duration_delta_vs_srt1_ms"],
                "duration_ratio_vs_planned": r["duration_ratio_vs_planned"],
            }
        )
    atomic_json(path, out)


def assemble_master(rows: list[dict[str, Any]], path: Path) -> dict[str, Any]:
    if not rows:
        raise RuntimeError("RETURN_NO_AUDIO_ROWS")
    first = Path(rows[0]["wav_path"])
    with wave.open(str(first), "rb") as w:
        params = w.getparams()
    path.parent.mkdir(parents=True, exist_ok=True)
    total_frames = 0
    with wave.open(str(path), "wb") as out:
        out.setparams(params)
        for r in rows:
            wav_path = Path(r["wav_path"])
            with wave.open(str(wav_path), "rb") as w:
                p = w.getparams()
                if (
                    p.nchannels != params.nchannels
                    or p.sampwidth != params.sampwidth
                    or p.framerate != params.framerate
                    or p.comptype != params.comptype
                ):
                    raise RuntimeError(
                        f"RETURN_WAV_FORMAT_MISMATCH: {r['speech_unit_id']} "
                        f"{p.nchannels}/{p.sampwidth}/{p.framerate}/{p.comptype} "
                        f"!= {params.nchannels}/{params.sampwidth}/{params.framerate}/{params.comptype}"
                    )
                gap_sec = float(r["preserved_gap_before_sec"])
                if gap_sec > 0:
                    gap_frames = int(round(gap_sec * params.framerate))
                    out.writeframes(b"\x00" * gap_frames * params.nchannels * params.sampwidth)
                    total_frames += gap_frames
                pcm = w.readframes(w.getnframes())
                out.writeframes(pcm)
                total_frames += p.nframes
    return {
        "path": str(path),
        "sample_rate": params.framerate,
        "channels": params.nchannels,
        "sample_width": params.sampwidth,
        "frames": total_frames,
        "duration_sec": total_frames / params.framerate,
    }


def config_signature(args: argparse.Namespace, ref_audio: Path, prompt_text: str) -> str:
    raw = json.dumps(
        {
            "gpt": str(args.gpt_weight),
            "sovits": str(args.sovits_weight),
            "seed": args.seed,
            "top_k": args.top_k,
            "top_p": args.top_p,
            "temperature": args.temperature,
            "speed": args.speed,
            "ref_audio": str(ref_audio.resolve()),
            "ref_audio_sha256": sha256_file(ref_audio),
            "prompt_text": prompt_text,
        },
        ensure_ascii=False,
        sort_keys=True,
    ).encode("utf-8")
    return hashlib.sha256(raw).hexdigest()


def resolve_inputs(args: argparse.Namespace) -> tuple[Path, Path, str, Path]:
    srt = args.srt
    if not srt:
        srt = Path(input("SRT1 planned 文件完整路径: ").strip().strip('"'))
    ref_audio = args.ref_audio
    if not ref_audio:
        ref_audio = Path(input("已通过试听的参考音频完整路径: ").strip().strip('"'))
    ref_text = args.ref_text
    if args.ref_text_file:
        ref_text = args.ref_text_file.read_text(encoding="utf-8").strip()
    if not ref_text:
        ref_text = input("参考音频对应的准确文本: ").strip()
    output_dir = args.output_dir or (srt.parent / f"{srt.stem}_gpt_sovits_srt2")
    return srt, ref_audio, ref_text, output_dir


def main() -> int:
    ap = argparse.ArgumentParser(
        description="Material-stage GPT-SoVITS executor: planned SRT1 -> per-cue WAV -> actual SRT2 + narration master."
    )
    ap.add_argument("--srt", type=Path)
    ap.add_argument("--ref-audio", type=Path)
    ap.add_argument("--ref-text")
    ap.add_argument("--ref-text-file", type=Path)
    ap.add_argument("--output-dir", type=Path)
    ap.add_argument("--synthesis-map", type=Path)
    ap.add_argument("--api", default=API_DEFAULT)
    ap.add_argument("--gpt-weight", type=Path, default=GPT_WEIGHT_DEFAULT)
    ap.add_argument("--sovits-weight", type=Path, default=SOVITS_WEIGHT_DEFAULT)
    ap.add_argument("--seed", type=int, default=1986)
    ap.add_argument("--top-k", type=int, default=15)
    ap.add_argument("--top-p", type=float, default=1.0)
    ap.add_argument("--temperature", type=float, default=0.8)
    ap.add_argument("--speed", type=float, default=1.0)
    ap.add_argument("--technical-retries", type=int, default=1)
    ap.add_argument("--force", action="store_true", help="Regenerate even when a matching PASS WAV/report row exists.")
    args = ap.parse_args()

    try:
        srt, ref_audio, prompt_text, output_dir = resolve_inputs(args)
        if not srt.exists():
            raise RuntimeError(f"RETURN_SRT_NOT_FOUND: {srt}")
        if not ref_audio.exists():
            raise RuntimeError(f"RETURN_REFERENCE_AUDIO_NOT_FOUND: {ref_audio}")
        if not prompt_text:
            raise RuntimeError("RETURN_REFERENCE_TEXT_EMPTY")
        if not args.gpt_weight.exists():
            raise RuntimeError(f"RETURN_GPT_WEIGHT_NOT_FOUND: {args.gpt_weight}")
        if not args.sovits_weight.exists():
            raise RuntimeError(f"RETURN_SOVITS_WEIGHT_NOT_FOUND: {args.sovits_weight}")

        cues = parse_srt(srt)
        synth_map = load_synthesis_map(args.synthesis_map)
        output_dir.mkdir(parents=True, exist_ok=True)
        units_dir = output_dir / "tts" / "units"
        timing_dir = output_dir / "timing"
        units_dir.mkdir(parents=True, exist_ok=True)
        timing_dir.mkdir(parents=True, exist_ok=True)
        shutil.copy2(srt, timing_dir / "SRT1_PLANNED.srt")

        report_path = output_dir / "tts" / "tts_execution_report.json"
        old_rows = previous_report_rows(report_path)
        signature = config_signature(args, ref_audio, prompt_text)

        wait_port(args.api)
        print("STEP=LOAD_GPT_WEIGHT")
        print(get_json(args.api, "/set_gpt_weights", {"weights_path": str(args.gpt_weight)}))
        print("STEP=LOAD_SOVITS_WEIGHT")
        print(get_json(args.api, "/set_sovits_weights", {"weights_path": str(args.sovits_weight)}))

        execution_rows: list[dict[str, Any]] = []
        current_report = build_report(srt, output_dir, ref_audio, prompt_text, args, execution_rows, "IN_PROGRESS")
        atomic_json(report_path, current_report)

        for pos, cue in enumerate(cues):
            unit_id = cue["unit_id"]
            synthesis_text = synthesis_text_for(cue, synth_map)
            if not synthesis_text:
                raise RuntimeError(f"RETURN_EMPTY_SYNTHESIS_TEXT: {unit_id}")
            wav_path = units_dir / f"{unit_id}.wav"
            row_for_resume = {
                **cue,
                "synthesis_text": synthesis_text,
            }
            reused = False
            if not args.force and can_resume(
                row_for_resume,
                old_rows.get(unit_id),
                wav_path,
                signature,
            ):
                info = wav_info(wav_path)
                reused = True
                retry_count = int(old_rows[unit_id].get("retry_count", 0))
                print(f"RESUME={unit_id} duration={info['duration_sec']:.4f}s")
            else:
                payload = {
                    "text": synthesis_text,
                    "text_lang": "zh",
                    "ref_audio_path": str(ref_audio),
                    "aux_ref_audio_paths": [],
                    "prompt_text": prompt_text,
                    "prompt_lang": "zh",
                    "top_k": args.top_k,
                    "top_p": args.top_p,
                    "temperature": args.temperature,
                    "text_split_method": DEFAULT_TTS["text_split_method"],
                    "batch_size": DEFAULT_TTS["batch_size"],
                    "batch_threshold": DEFAULT_TTS["batch_threshold"],
                    "split_bucket": DEFAULT_TTS["split_bucket"],
                    "speed_factor": args.speed,
                    "fragment_interval": DEFAULT_TTS["fragment_interval"],
                    "seed": args.seed,
                    "media_type": "wav",
                    "streaming_mode": False,
                    "parallel_infer": False,
                    "repetition_penalty": DEFAULT_TTS["repetition_penalty"],
                    "sample_steps": DEFAULT_TTS["sample_steps"],
                    "super_sampling": False,
                }
                retry_count = 0
                while True:
                    try:
                        body = post_tts(args.api, payload)
                        wav_path.write_bytes(body)
                        info = wav_info(wav_path)
                        if info["duration_sec"] <= 0.1:
                            raise RuntimeError("RETURN_TTS_AUDIO_TOO_SHORT")
                        break
                    except Exception:
                        if retry_count >= args.technical_retries:
                            raise
                        retry_count += 1
                        time.sleep(1.5)
                print(f"PASS={unit_id} duration={info['duration_sec']:.4f}s retries={retry_count}")

            planned_gap_before = (
                max(0.0, cue["planned_start"])
                if pos == 0
                else max(0.0, cue["planned_start"] - cues[pos - 1]["planned_end"])
            )
            planned = cue["planned_duration"]
            actual = float(info["duration_sec"])
            row = {
                "speech_unit_id": unit_id,
                "cue_index": cue["index"],
                "display_text": cue["display_text"],
                "synthesis_text": synthesis_text,
                "wav_path": str(wav_path),
                "wav_sha256": sha256_file(wav_path),
                "sample_rate": info["sample_rate"],
                "channels": info["channels"],
                "sample_width": info["sample_width"],
                "planned_start_sec": cue["planned_start"],
                "planned_end_sec": cue["planned_end"],
                "planned_duration_sec": planned,
                "preserved_gap_before_sec": planned_gap_before,
                "actual_duration_sec": actual,
                "duration_delta_vs_srt1_ms": round((actual - planned) * 1000),
                "duration_ratio_vs_planned": None if planned <= 0 else round(actual / planned, 6),
                "status": "PASS",
                "resume_reused": reused,
                "retry_count": retry_count,
                "config_signature": signature,
                "qa_note": "",
            }
            execution_rows.append(row)
            current_report = build_report(
                srt, output_dir, ref_audio, prompt_text, args, execution_rows, "IN_PROGRESS"
            )
            atomic_json(report_path, current_report)

        clock = 0.0
        for r in execution_rows:
            clock += float(r["preserved_gap_before_sec"])
            r["actual_start_sec"] = round(clock, 6)
            clock += float(r["actual_duration_sec"])
            r["actual_end_sec"] = round(clock, 6)

        srt2_path = timing_dir / "SRT2_ACTUAL.srt"
        timeline_path = timing_dir / "SRT2_TIMELINE.json"
        master_path = output_dir / "tts" / "narration_master.wav"

        write_srt2(execution_rows, srt2_path)
        write_timeline(execution_rows, timeline_path)
        master = assemble_master(execution_rows, master_path)

        final_report = build_report(
            srt, output_dir, ref_audio, prompt_text, args, execution_rows, "PASS"
        )
        final_report["outputs"] = {
            "srt1_copy": str(timing_dir / "SRT1_PLANNED.srt"),
            "srt2": str(srt2_path),
            "srt2_timeline": str(timeline_path),
            "narration_master": master,
        }
        final_report["summary"] = {
            "tts_unit_count": len(execution_rows),
            "pass_count": sum(1 for r in execution_rows if r["status"] == "PASS"),
            "resumed_count": sum(1 for r in execution_rows if r["resume_reused"]),
            "total_duration_sec": master["duration_sec"],
        }
        atomic_json(report_path, final_report)

        print("RESULT=PASS_GPT_SOVITS_SRT2_MATERIAL_EXECUTION")
        print(f"TTS_UNIT_COUNT={len(execution_rows)}")
        print(f"PASS_COUNT={len(execution_rows)}")
        print(f"RESUMED_COUNT={final_report['summary']['resumed_count']}")
        print(f"SRT2_TOTAL_DURATION={master['duration_sec']:.4f}")
        print(f"NARRATION_MASTER={master_path}")
        print(f"SRT2_PATH={srt2_path}")
        print(f"EXECUTION_REPORT={report_path}")
        return 0

    except Exception as e:
        print(f"RESULT=RETURN_GPT_SOVITS_SRT2_EXECUTION")
        print(f"ERROR={type(e).__name__}: {e}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
