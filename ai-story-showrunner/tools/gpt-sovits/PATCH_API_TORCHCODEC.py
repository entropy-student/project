from pathlib import Path
import shutil
import sys

ROOT = Path(r"C:\AI\GPT-SoVITS")
TARGET = ROOT / "GPT_SoVITS" / "TTS_infer_pack" / "TTS.py"
BACKUP = TARGET.with_name("TTS.py.before_api_torchcodec_fix")

OLD = "        raw_audio, raw_sr = torchaudio.load(ref_audio_path)\n"
NEW = (
    "        raw_np, raw_sr = librosa.load(ref_audio_path, sr=None, mono=True)\n"
    "        raw_audio = torch.from_numpy(raw_np).float().unsqueeze(0)\n"
)

if not TARGET.exists():
    raise SystemExit(f"TARGET_NOT_FOUND: {TARGET}")

text = TARGET.read_text(encoding="utf-8")

if NEW in text:
    print("RESULT=PASS_ALREADY_PATCHED")
    print(f"TARGET={TARGET}")
    sys.exit(0)

if OLD not in text:
    raise SystemExit("RESULT=RETURN_PATCH_ANCHOR_NOT_FOUND")

if not BACKUP.exists():
    shutil.copy2(TARGET, BACKUP)

text = text.replace(OLD, NEW, 1)
compile(text, str(TARGET), "exec")
TARGET.write_text(text, encoding="utf-8")

verify = TARGET.read_text(encoding="utf-8")
if NEW not in verify:
    raise SystemExit("RESULT=RETURN_PATCH_VERIFY_FAILED")

print("RESULT=PASS_PATCHED")
print(f"TARGET={TARGET}")
print(f"BACKUP={BACKUP}")
