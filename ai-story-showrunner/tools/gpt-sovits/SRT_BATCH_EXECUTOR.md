# GPT-SoVITS SRT1 → SRT2 Batch Executor

Status: **project helper / material-stage candidate**

Purpose:

```text
planned SRT1
→ one cue = one TTS unit
→ GPT-SoVITS API
→ units/*.wav
→ exact actual duration
→ SRT2_ACTUAL.srt
→ narration_master.wav
→ execution report
```

This helper implements the current project-level SRT1 / SRT2 material-generation rule from
`docs/G6A_AUDIO_QA_AND_TTS_MIGRATION_TRIAL.md`.

It does **not** replace the full Speech Unit + TTS Manifest + Runtime Timeline Resolver path when those richer artifacts already exist.

## 1. Preconditions

Start the API first:

```text
START_GPT_SOVITS_API.bat
```

Keep that window open.

Current endpoint:

```text
http://127.0.0.1:9880
```

Current candidate defaults:

```text
GPT:    GPT_weights_v2ProPlus/narrator01_v2pp-e5.ckpt
SoVITS: SoVITS_weights_v2ProPlus/narrator01_v2pp_e8_s248.pth
seed: 1986
temperature: 0.8
top_k: 15
top_p: 1
speed: 1
parallel_infer: false
```

## 2. Simplest use

Double-click:

```text
RUN_GPT_SOVITS_SRT_BATCH.bat
```

Then enter:
- planned SRT1 path;
- accepted reference audio path;
- exact reference transcript.

Or drag an SRT file onto:

```text
RUN_GPT_SOVITS_SRT_BATCH.bat
```

The script will still ask for the reference audio / transcript.

## 3. Command-line use

```bat
C:\Users\34707\miniconda3\envs\GPTSoVits\python.exe ^
  GPT_SOVITS_SRT_BATCH_EXECUTOR.py ^
  --srt "D:\episode\PRODUCTION_SUBTITLES_PLANNED.srt" ^
  --ref-audio "C:\Users\34707\Downloads\morning.mp3" ^
  --ref-text "睡得好吗？希望你今天顺利，别遇到那种一大早就能惹你生气的人。" ^
  --output-dir "D:\episode\gpt-sovits-srt2"
```

## 4. Outputs

```text
<output>/
├─ tts/
│  ├─ units/
│  │  ├─ SU001.wav
│  │  ├─ SU002.wav
│  │  └─ ...
│  ├─ narration_master.wav
│  └─ tts_execution_report.json
└─ timing/
   ├─ SRT1_PLANNED.srt
   ├─ SRT2_ACTUAL.srt
   └─ SRT2_TIMELINE.json
```

## 5. Timing rule

The helper does not force generated speech back into the planned SRT window.

For each cue:

```text
actual_start
= previous actual_end
+ non-negative inter-cue gap preserved from SRT1

actual_end
= actual_start
+ actual WAV duration
```

Therefore:

- SRT1 is planning input;
- generated WAV duration is SRT2 speech truth;
- planned inter-cue gaps are preserved because an SRT-only input cannot distinguish semantic pause from ELASTIC slack;
- final SRT3 may later trim redundant non-semantic gaps after first assembly.

If a full `Speech Units + TTS Manifest` package exists, use the canonical Runtime Timeline Resolver instead because it knows HARD_ANCHOR / SEMANTIC_RANGE / ELASTIC intent.

## 6. Display text vs synthesis text

Default:
`synthesis_text == display_text`.

The helper never silently rewrites subtitle text.

Optional map:

```text
SYNTHESIS_MAP_EXAMPLE.json
```

Example:

```json
{
  "by_index": {
    "12": "A I"
  },
  "by_text": {
    "……等等，这也能算正常？": "等等，这也能算正常？"
  }
}
```

Use:

```bat
python GPT_SOVITS_SRT_BATCH_EXECUTOR.py ^
  --srt "..." ^
  --synthesis-map "SYNTHESIS_MAP_EXAMPLE.json"
```

Only synthesis text changes. SRT2 display text remains locked.

## 7. Resume behavior

The executor is resume-safe.

After each successful unit:
- WAV is already on disk;
- the report is updated immediately.

A prior PASS unit is reused only when:
- WAV exists and is valid;
- display text matches;
- synthesis text matches;
- reference audio + reference transcript + candidate settings match the saved config signature.

Use `--force` to regenerate all units.

## 8. Retries

Default:
- no aesthetic retry loop;
- one technical retry is allowed for API/network failure.

Change with:
`--technical-retries N`.

## 9. Evidence boundary

This tool is added as a reusable project helper, but Windows + local GPT-SoVITS full-episode execution still requires a real local run before claiming runtime PASS.

Static repository integration does not equal local production proof.
