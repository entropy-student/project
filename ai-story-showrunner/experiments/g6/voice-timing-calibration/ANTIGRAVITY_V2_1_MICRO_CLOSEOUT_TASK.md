# Antigravity Task — Voice Timing Profile v2.1 Micro Closeout

## Goal

Perform the final two blind timing checks before Voice Timing Profile freeze.

This is NOT a new calibration sweep.

Generate exactly **2 new TTS samples**:
- V21B001 — CONTROLLED
- V21B002 — FINAL

Input:
`V2_1_MICRO_CLOSEOUT_SET.json`

Do not alter any previously frozen V2 parameters.

## Fixed environment

Use the same exact validated setup:
- CosyVoice-300M
- zero_shot
- seed 1986 reset before each sentence
- same reference WAV/transcript
- same 22050 Hz sample rate
- same deterministic energy-VAD normalization
- load model once
- cache speaker prompt once

## Frozen rules

Keep:
- `short_normal_floor_sec = 1.4715s`
- `mixed_margin_sec = 0.3178s`

Add only these candidate semantic safety floors:

### CONTROLLED

`semantic_floor = cjk_char_count / 5.0 / intended_speed`

### FINAL

`semantic_floor = cjk_char_count / 5.5 / intended_speed`

For each sample:

`allocated_duration = max(existing_v2_candidate_prediction, semantic_floor)`

These floors are safety backstops only.

## Strict blind rule

Do NOT use the actual duration of either V21B sample to change the safe CPS values before evaluation.

The CPS values are frozen before generation:
- CONTROLLED = 5.0
- FINAL = 5.5

## Evaluation

For each sample calculate:

- allocated_duration_sec
- actual_normalized_duration_sec
- under_allocation_sec = max(0, actual - allocated)
- required_extra_speed = max(1.0, actual / allocated)
- tail_slack_sec = max(0, allocated - actual)

### PASS

- required_extra_speed <= 1.03x
- tail_slack <= 0.70s

### PASS_WITH_MINOR

- required_extra_speed <= 1.05x
- tail_slack <= 0.90s
- and not PASS

### RETURN

- required_extra_speed > 1.05x
- OR tail_slack > 0.90s

Overall:
- both PASS → PASS
- no RETURN and at least one minor → PASS_WITH_MINOR
- otherwise → RETURN_PROFILE_INSUFFICIENT_V2_1

## Required output

Create:
- `voice_timing_v2_1_closeout_report.json`

Return only:
- both rows with allocated/actual/required_extra_speed/tail_slack/result
- overall result
- report path

If PASS or PASS_WITH_MINOR:
delete the two WAVs and temporary scripts after measurement.

If RETURN:
retain only the failed WAV(s) plus report.

Do not modify episode SRT or any production files.
