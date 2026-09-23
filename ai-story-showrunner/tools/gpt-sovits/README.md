# GPT-SoVITS Local Helper

Current local candidate configuration:

```text
GPT-SoVITS: C:\AI\GPT-SoVITS
Python:     C:\Users\34707\miniconda3\envs\GPTSoVits\python.exe
UI locale:  zh_CN
Main port:  9874
API port:   9880
```

Current QA candidate:

```text
GPT:         GPT_weights_v2ProPlus/narrator01_v2pp-e5.ckpt
SoVITS:      SoVITS_weights_v2ProPlus/narrator01_v2pp_e8_s248.pth
temperature: 0.8
top_k:       15
top_p:       1
speed:       1
parallel:    false
```

Manual representative listening QA has passed sufficiently to enter automation/timing calibration. e10 and e15 are not current candidates because repeated inference exposed instability.

## Files

- `START_GPT_SOVITS_ZH_CN.bat` — one-click local WebUI launcher.
- `CHECK_GPT_SOVITS_ENV.bat` — local environment diagnostic.
- `PATCH_API_TORCHCODEC.py/.bat` — patches the API inference path to use the already-proven librosa reference-audio loader instead of the failing TorchCodec path.
- `START_GPT_SOVITS_API.bat` — launches official `api_v2.py` on `127.0.0.1:9880`.
- `API_DETERMINISM_SMOKE.py` + `RUN_API_DETERMINISM_SMOKE.bat` — loads e5/e8, uses a fixed seed, synthesizes the same sentence three times, records WAV metadata/SHA256 and retains a smoke report.
- `../../docs/GPT_SOVITS_QUICKSTART.md` — concise usage guide.

## Current gate

Before building a new Voice Timing Profile, validate the production API path itself:

```text
PATCH_API_TORCHCODEC
→ START_GPT_SOVITS_API
→ RUN_API_DETERMINISM_SMOKE
→ listen to retained run-1.wav
→ PASS only if deterministic output is technically valid and subjectively acceptable
```

The fixed seed used by the smoke gate is a candidate reproducibility setting, not canonical until listening QA accepts that API realization.

After API determinism/listening PASS:

```text
GPT-SoVITS timing calibration
→ held-out validation
→ frozen GPT-SoVITS Voice Timing Profile
→ provider adapter/runtime validation
→ only then decide canonical TTS migration
```

CosyVoice remains the current canonical timing baseline until the GPT-SoVITS runtime/adapter path passes. Do not reuse CosyVoice timing coefficients for GPT-SoVITS.
