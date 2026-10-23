"""Bounded single-call adapter. No secret env, retries, or signed-URL files."""
import argparse
import json
from pathlib import Path

import requests
from dotenv import dotenv_values

MODEL = "qwen-audio-3.1-tts-flash"
VOICE = "longzhe_v3.1"


def synthesize(text_path, output_path, approval_path, credentials_path, session=None):
    text_path, output_path, approval_path = map(Path, (text_path, output_path, approval_path))
    project_run = approval_path.resolve().parent
    if not output_path.resolve().is_relative_to(project_run):
        raise ValueError("output must remain under approval run directory")
    approval = json.loads(approval_path.read_text(encoding="utf-8-sig"))
    if not (approval.get("approved") is True
            and approval.get("provider") == "dashscope"
            and approval.get("model") == MODEL and approval.get("voice") == VOICE
            and approval.get("authorization_source")
            and approval.get("quota_or_price_evidence")):
        raise ValueError("bounded Owner authorization and quota/price evidence required")
    text = text_path.read_text(encoding="utf-8-sig").strip()
    if not (1 <= int(approval["max_calls"]) <= 4
            and 1 <= int(approval["max_characters"]) <= 1200):
        raise ValueError("approval exceeds this test Gate budget")
    attempts = list(project_run.rglob("*.tts-attempt.json"))
    previous = [json.loads(p.read_text(encoding="utf-8")) for p in attempts]
    if (not text or len(text) > 600 or len(previous) >= int(approval["max_calls"])
            or len(text) + sum(p["characters"] for p in previous) > int(approval["max_characters"])):
        raise ValueError("empty text or call/character budget exceeded")
    marker = output_path.with_suffix(".tts-attempt.json")
    if output_path.exists() or marker.exists():
        raise FileExistsError("classify existing result before any new request")
    credentials = dotenv_values(credentials_path)
    key = credentials.get("DASHSCOPE_API_KEY")
    workspace = credentials.get("DASHSCOPE_WORKSPACE_ID", "").strip()
    if not key or not workspace or not all(c.isalnum() or c == "-" for c in workspace):
        raise ValueError("credential configuration missing or invalid")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    state = {"phase": "NOT_SENT", "characters": len(text), "model": MODEL, "voice": VOICE}
    with marker.open("x", encoding="utf-8") as handle:
        json.dump(state, handle)

    def save(phase):
        state["phase"] = phase
        marker.write_text(json.dumps(state), encoding="utf-8")

    transport = session or requests.Session()
    endpoint = f"https://{workspace}.cn-beijing.maas.aliyuncs.com/api/v1/services/audio/tts/SpeechSynthesizer"
    try:
        save("SYNTHESIS_MAY_HAVE_STARTED")
        response = transport.post(endpoint, headers={"Authorization": f"Bearer {key}"},
                                  json={"model": MODEL, "input": {"text": text, "voice": VOICE,
                                        "language_hints": ["zh"], "format": "wav", "sample_rate": 24000}},
                                  timeout=120, allow_redirects=False)
        if response.status_code != 200:
            save("SYNTHESIS_RETURNED_ERROR_NO_RETRY")
            return state
        audio_url = response.json().get("output", {}).get("audio", {}).get("url")
        save("SYNTHESIS_RETURNED_DOWNLOAD_PENDING")
        if not audio_url or not audio_url.startswith("https://"):
            return state
        audio = transport.get(audio_url, timeout=120, allow_redirects=False)
        if audio.status_code != 200:
            save("DOWNLOAD_FAILED_DO_NOT_RESYNTHESIZE")
            return state
        payload = audio.content
        if len(payload) < 44 or payload[:4] != b"RIFF" or payload[8:12] != b"WAVE":
            save("INVALID_AUDIO_DO_NOT_RESYNTHESIZE")
            return state
        with output_path.open("xb") as handle:
            handle.write(payload)
        save("AUDIO_SAVED_REQUIRES_QA")
        return state
    except Exception:
        # Preserve the last phase. Exception strings may include endpoints/tokens.
        state["error_class"] = "TRANSPORT_OR_LOCAL_IO_FAILURE"
        marker.write_text(json.dumps(state), encoding="utf-8")
        return state
    finally:
        credentials.clear()
        key = workspace = endpoint = None


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--text", required=True)
    parser.add_argument("--out", required=True)
    parser.add_argument("--approval", required=True)
    args = parser.parse_args()
    try:
        result = synthesize(args.text, args.out, args.approval,
                            Path.home() / "Tools/OpenMontage/.env")
        print(json.dumps(result))
        raise SystemExit(0 if result["phase"] == "AUDIO_SAVED_REQUIRES_QA" else 2)
    except (ValueError, KeyError, FileExistsError, OSError):
        print('{"result":"RETURN_PREFLIGHT_OR_EXISTING_RESULT"}')
        raise SystemExit(2)
