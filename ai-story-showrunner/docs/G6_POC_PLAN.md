# G6 PoC Plan — Blind Search Answer

Date: 2026-09-21

Status: `IN_PROGRESS`

## Goal

Compile one complete deterministic Antigravity Production Package and validate that the executor can generate:

- CosyVoice audio;
- image assets;
- timeline assembly;
- subtitles;
- final video;

without creative reinterpretation.

## Entry conditions

- G4 = PASS;
- G5 = PASS;
- high-risk Pilot = PASS;
- reference-path validation = PASS;
- persistent reference package v1 = available;
- CosyVoice deterministic PoC = PASS.

## Current timing decision

Production timing is no longer solved by routine per-episode post-TTS calibration.

Canonical path:

```text
locked script
→ semantic timing class
→ reusable VOICE_TIMING_PROFILE
→ PRODUCTION_SUBTITLES.srt
→ TTS_MANIFEST.json
→ Director / Asset package
→ Antigravity deterministic execution
```

Canonical contracts:
- `docs/SRT_AUDIO_TIMING_STANDARD.md`
- `docs/VOICE_TIMING_PROFILE_SPEC.md`

The current three-case PoC is calibration evidence:
- baseline: natural 2.5542s vs 2.680s reference — feasible;
- tight line: natural 4.2493s vs 3.020s reference — 1.407x, audibly unacceptable;
- punch: natural 1.2771s vs 1.350s reference — feasible.

This proves the need for a reusable voice-specific timing model, not a routine second-pass retiming workflow.

## Immediate sequence

1. Run one-time Voice Timing Profile calibration on 15–24 representative utterances using the current canonical CosyVoice setup.
2. Produce `VOICE_TIMING_PROFILE.json`.
3. Validate it on held-out utterances.
4. Recompile the current locked script into `PRODUCTION_SUBTITLES.srt` using semantic timing intent + Voice Timing Profile.
5. Produce `TTS_MANIFEST.json` with exact text, semantic pace, intended speed, target start/end, voice/profile references and seed.
6. Compile exact Visual Beat / Shot Timeline against the Production SRT.
7. Assemble the full Antigravity Production Package.
8. Hand the package to Antigravity.
9. Antigravity executes:
   - locked CosyVoice TTS;
   - Nano Banana image generation/edit;
   - exact timeline assembly;
   - subtitles;
   - final export.
10. Run final QA and record any RETURN state.

## Audio execution mode

`AUDIO_MODE = EXECUTOR_LOCKED_COSYVOICE`

Meaning:

Upstream owns:
- script;
- semantic pace;
- SRT;
- timing;
- voice profile;
- TTS manifest.

Antigravity owns:
- deterministic CosyVoice execution only.

Antigravity may not:
- rewrite text;
- choose a different pace;
- redesign SRT;
- redistribute semantic pauses;
- creatively retime speech.

Material timing miss:
`RETURN_VOICE_TIMING_PROFILE_MISS`

## Production package target

Minimum package:

- `00_EXECUTION_ORDER.md`
- `01_SCRIPT.md`
- `02_PRODUCTION_SUBTITLES.srt`
- `03_TTS_MANIFEST.json`
- `04_AUDIO_SPEC.md`
- `05_VISUAL_BEATS.json`
- `06_SHOT_TIMELINE.csv`
- `07_IMAGE_GENERATION.json` or `.csv`
- `08_CHARACTER_BIBLE.md`
- `09_SCENE_BIBLE.md`
- `10_STYLE_BIBLE.md`
- `11_REFERENCE_MANIFEST.json`
- `12_EDIT_INSTRUCTIONS.md`
- `13_OUTPUT_SPEC.md`
- `14_QA_RULES.md`
- `references/`

External local dependencies may remain outside the package:
- canonical reference voice wav;
- matching reference transcript;
- CosyVoice repository/model;
- cosyvoice venv.

## PoC acceptance

- Voice Timing Profile predicts held-out timing within accepted tolerance;
- Production SRT requires no routine creative rework after TTS;
- character refs resolve;
- image rows execute without manual prompt rewriting;
- no executor-added brand/checklist/explainer clutter;
- executor-generated audio follows locked timing contract;
- image timeline matches Production SRT;
- final video is reviewable;
- unresolved contract produces RETURN rather than improvisation.

## Human intervention

Normal G6 execution requires no Owner approval of:
- script;
- SRT;
- Director plan;
- first-batch key frames.

Manual key-frame sampling remains calibration-only for new model/style/character/executor failure classes.

## Deferred

Hotspot portfolio ratio, hotspot integration policy and expanded IP narrative-engine design remain outside this G6 main-line task.
