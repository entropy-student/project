# Executor Agent Task — GPT-SoVITS SRT1 → SRT2 Material Generation

## Scope

Given one locked planned SRT1, generate GPT-SoVITS narration by cue, measure actual WAV durations, and produce SRT2 + narration master.

Do not:
- rewrite spoken/subtitle text;
- generate images;
- enter Director / frame production;
- render video;
- force speech to match SRT1 duration;
- promote GPT-SoVITS to canonical.

## Required project truth

Read first:

1. `docs/G6A_AUDIO_QA_AND_TTS_MIGRATION_TRIAL.md`
2. `docs/SRT_AUDIO_TIMING_STANDARD.md`
3. `tools/gpt-sovits/README.md`
4. `tools/gpt-sovits/SRT_BATCH_EXECUTOR.md`

## User-supplied runtime inputs

Fill before execution:

```text
SRT1_PATH=<ABSOLUTE_PATH_TO_PLANNED_SRT>
REFERENCE_AUDIO=<ABSOLUTE_PATH_TO_ACCEPTED_REFERENCE_AUDIO>
REFERENCE_TEXT=<EXACT_TRANSCRIPT_OF_REFERENCE_AUDIO>
OUTPUT_DIR=<OPTIONAL_ABSOLUTE_OUTPUT_DIR>
SYNTHESIS_MAP=<OPTIONAL_JSON_PATH>
```

## Preconditions

Expected local runtime:

```text
GPT-SoVITS root:
C:\AI\GPT-SoVITS

Python:
C:\Users\34707\miniconda3\envs\GPTSoVits\python.exe

API:
http://127.0.0.1:9880
```

If the API is not running, start:

```text
ai-story-showrunner\tools\gpt-sovits\START_GPT_SOVITS_API.bat
```

Current project candidate defaults are encoded in the batch executor.

## Execute

Preferred command:

```bat
C:\Users\34707\miniconda3\envs\GPTSoVits\python.exe ^
  ai-story-showrunner\tools\gpt-sovits\GPT_SOVITS_SRT_BATCH_EXECUTOR.py ^
  --srt "<SRT1_PATH>" ^
  --ref-audio "<REFERENCE_AUDIO>" ^
  --ref-text "<REFERENCE_TEXT>" ^
  --output-dir "<OUTPUT_DIR>"
```

If `SYNTHESIS_MAP` is provided, append:

```text
--synthesis-map "<SYNTHESIS_MAP>"
```

## Execution contract

- one input SRT cue = one TTS unit;
- preserve cue order;
- preserve display text exactly;
- synthesis text may differ only through explicit synthesis map;
- one technical retry is allowed by default;
- no aesthetic retry loop;
- resume existing matching PASS units;
- exact generated WAV duration is SRT2 speech timing truth;
- preserve non-negative inter-cue gaps from SRT1;
- do not time-stretch/compress speech to fit SRT1;
- SRT2 is material-stage timing, not final SRT3.

## Required outputs

```text
tts/
  units/
  narration_master.wav
  tts_execution_report.json

timing/
  SRT1_PLANNED.srt
  SRT2_ACTUAL.srt
  SRT2_TIMELINE.json
```

## Return

Success:

```text
RESULT=PASS_GPT_SOVITS_SRT2_MATERIAL_EXECUTION
TTS_UNIT_COUNT=
PASS_COUNT=
RESUMED_COUNT=
SRT2_TOTAL_DURATION=
NARRATION_MASTER=
SRT2_PATH=
EXECUTION_REPORT=
STOP_AT_AUDIO_MATERIAL_STAGE=YES
```

Failure:
return the smallest exact reason and preserve completed PASS units for resume.

Do not start image/video production.
