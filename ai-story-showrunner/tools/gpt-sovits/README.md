# GPT-SoVITS Local Helper

Current local candidate configuration:

```text
GPT-SoVITS: C:\AI\GPT-SoVITS
Python:     C:\Users\34707\miniconda3\envs\GPTSoVits\python.exe
UI locale:  zh_CN
Main port:  9874
```

Status: local environment check PASS for required imports and CUDA; Chinese WebUI has opened successfully. The remaining `faster-whisper → onnxruntime` `pip check` message is treated as non-blocking while `onnxruntime-gpu` imports and runtime remain healthy.

Files:

- `START_GPT_SOVITS_ZH_CN.bat` — one-click local launcher. Uses the exact environment Python; does not depend on `conda activate`.
- `CHECK_GPT_SOVITS_ENV.bat` — local environment diagnostic.
- `../../docs/GPT_SOVITS_QUICKSTART.md` — concise usage guide.

Current project rule:

```text
CosyVoice = current project baseline
GPT-SoVITS = candidate under 5-case A/B
```

Do not train, regenerate the full episode, or modify the portable Story Showrunner Skill until the A/B decision.
