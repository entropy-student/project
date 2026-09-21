# Voice Timing Profile Specification v0.3 — CANONICAL

## Purpose

A Voice Timing Profile is a reusable empirical timing/safety model for one stable TTS voice setup.

It allows the Timing Compiler to build a safe Production SRT **before** real TTS execution.

The generic Story Showrunner contract is provider-neutral. A concrete profile may belong to CosyVoice, another TTS engine, a human narrator model, or another stable voice setup.

## Canonical lifecycle

```text
CALIBRATION_CANDIDATE
→ held-out validation
→ PASS / PASS_WITH_MINOR
→ FROZEN
→ production use
→ recalibrate only on material drift
```

Normal new episodes do not trigger recalibration.

## Required profile identity

A frozen profile should identify:
- profile_id;
- version;
- TTS engine/model or voice system;
- language;
- reference-voice logical ID;
- deterministic generation settings where applicable;
- normalization method;
- semantic speed map;
- predictor parameters;
- safety branches/floors;
- validation summary;
- status.

Do not store machine-specific absolute paths as canonical identity. Those belong runtime config.

## Required timing dimensions

The profile should model enough information to predict safe duration for the target voice, which may include:
- CJK/spoken-unit count;
- Latin/abbreviation spoken units;
- Arabic-number spoken units;
- punctuation/clause effects;
- short-utterance nonlinearity;
- mixed-token interactions;
- semantic pace class;
- provider/model-specific effects.

A profile is not required to use one universal regression architecture.

## Semantic pace classes

Canonical cross-pipeline classes:
- SLOW_NORMAL
- NORMAL
- FAST_NORMAL
- FAST_CLEAR
- CONTROLLED
- FINAL

Dramatic timing kind → pace-class mapping is defined by:
`docs/SRT_AUDIO_TIMING_STANDARD.md`

## Prediction contract

The profile must expose a deterministic function conceptually equivalent to:

```text
base prediction
+ provider/voice-specific corrections
+ safety branch/floor
→ allocated speech duration
```

Then the Timing Compiler adds authored semantic pauses and performs whole-script scheduling.

Do not use one universal chars/sec value for every line.

## Safety objective

The primary objective is to prevent **unsafe under-allocation**.

`required_extra_speed = max(1.0, actual / allocated)`

Canonical thresholds:
- <=1.03x → PASS
- >1.03x and <=1.05x → PASS_WITH_MINOR
- >1.05x → RETURN_PROFILE_MISS

Track over-allocation separately as tail slack.

Absolute error is diagnostic, not the sole production acceptance metric.

## Current frozen profile

Current validated production profile:

`profiles/voice/VOICE_TIMING_PROFILE_COSYVOICE_300M_V2_1.json`

Status:
`CANONICAL_PASS_WITH_MINOR / FROZEN`

Its current safety rules include:
- short NORMAL minimum window;
- mixed Latin+Arabic interaction correction;
- CONTROLLED semantic floor;
- FINAL semantic floor.

The numerical values belong to that profile, not this generic specification.

## Calibration guidance for a new voice setup

A new profile should cover representative:
- short / medium / long NORMAL;
- FAST_NORMAL / BUILD;
- FAST_CLEAR / PUNCH;
- CONTROLLED / REVERSAL;
- FINAL;
- punctuation-heavy lines;
- questions/quotes;
- numbers;
- Latin/abbreviations;
- mixed token combinations;
- very short utterances.

Use held-out samples that do not influence frozen parameters.

If a profile fails:
- diagnose the failure class;
- run targeted follow-up calibration when possible;
- do not tune against held-out results and call it blind validation;
- do not force a large full sweep when a smaller targeted test resolves the identified class.

## Production behavior

```text
locked spoken script
→ Timing Compiler
→ Voice Timing Profile
→ Production SRT + TTS Manifest
→ Director
→ production package
→ Executor TTS
```

If actual TTS materially exceeds the safe allocation:
`RETURN_VOICE_TIMING_PROFILE_MISS`

Fix the reusable profile/compiler, not the individual episode by default.

## Recalibration triggers

Recalibrate/review only when one of these materially changes:
- TTS engine/model;
- reference voice;
- speaking style target;
- language;
- generation settings affecting prosody;
- repeated material profile misses.

## Historical note

The rejected v1 regression and v2/v2.1 calibration evidence are retained under:
`experiments/g6/voice-timing-calibration/`

Historical failures are evidence, not active profile rules.
