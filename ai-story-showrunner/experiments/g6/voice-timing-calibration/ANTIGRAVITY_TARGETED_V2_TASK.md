# Antigravity Task — Voice Timing Profile Targeted v2

## Goal

Repair only the two failure classes exposed by v1:

1. short NORMAL under-allocation;
2. mixed Latin + Arabic over-counting.

Do NOT rerun the full 18-sample calibration.
Do NOT generate the full episode.
Do NOT redesign the semantic speed map.

Input files in this folder:
- `TARGETED_CALIBRATION_SET_V2.json`
- `VOICE_TIMING_PROFILE_V1_REJECTED.json`
- `calibration_report_v1.json`
- `heldout_report_v1.json`

Expected new TTS generations: **6 total**.

## Fixed environment

Use the exact same validated setup as v1:
- CosyVoice-300M
- zero_shot
- seed 1986, reset before each sentence
- load model once
- cache speaker prompt once
- sample rate 22050 Hz
- same reference WAV / transcript
- same deterministic energy-VAD normalization
- do not reinstall or alter the environment

## Important execution order

### Phase 1 — calibration only

First generate ONLY:
- V2C001
- V2C002
- V2C003

Measure raw and normalized durations exactly as in v1.

Using only:
- v1 training evidence;
- reused BLD001 / BLD003 evidence explicitly included in the V2 set;
- V2C001 / V2C002;

derive and freeze exactly two new parameters:

1. `short_normal_floor_sec`
2. `mixed_margin_sec`

Do not look at V2B001–V2B003 actual durations yet.

### Phase 2 — freeze candidate

Create the candidate timing rules exactly as specified in `TARGETED_CALIBRATION_SET_V2.json`.

#### Short NORMAL

- condition: NORMAL + content unit count <= 7;
- remove v1's negative short-utterance correction for this branch;
- `short_normal_floor_sec = max(short-NORMAL calibration actual durations) + 0.05`;
- prediction = max(base prediction, floor).

Do NOT create a special rule for the word “然后”.

#### Mixed Latin + Arabic

When both token types appear:
- do NOT sum both large v1 fixed penalties;
- use `max(total_latin_penalty, total_arabic_penalty)`;
- then add:
  `mixed_margin_sec = max(0, max(actual - candidate_prediction on mixed calibration evidence)) + 0.05`.

All other v1 coefficients and semantic speed defaults remain unchanged for this targeted experiment.

Freeze the candidate BEFORE generating/reading held-out durations.

### Phase 3 — strict held-out

Only after the candidate is frozen, generate:

- V2B001
- V2B002
- V2B003

For each held-out row calculate:

- predicted allocated duration;
- actual normalized duration;
- under_allocation_sec = max(0, actual - allocated);
- required_extra_speed = max(1.0, actual / allocated);
- tail_slack_sec = max(0, allocated - actual);
- absolute_error_ms.

## Acceptance

Primary criterion is one-sided timing safety.

Per held-out sample:

### PASS
- required_extra_speed <= 1.03x; and
- for NORMAL, tail_slack <= 0.60s.

### PASS_WITH_MINOR
- required_extra_speed > 1.03x and <= 1.05x; OR
- NORMAL tail_slack > 0.60s and <= 0.80s.

### RETURN
- required_extra_speed > 1.05x; OR
- NORMAL tail_slack > 0.80s.

Overall:
- PASS only if all held-out rows PASS;
- PASS_WITH_MINOR if none RETURN and at least one row is PASS_WITH_MINOR;
- otherwise `RETURN_PROFILE_INSUFFICIENT_V2`.

Absolute error is diagnostic only and must not override the one-sided safety result.

## Control row

V2C003 is a FINAL semantic-speed control.

Report its observed duration and v1-predicted duration at 0.96x.
Do not use it to tune the two V2 parameters.
If it is wildly inconsistent, flag:
`SEMANTIC_SPEED_MAP_REVIEW_REQUIRED`
but continue the held-out evaluation.

## Outputs

Create:

1. `VOICE_TIMING_PROFILE_V2_CANDIDATE.json`
2. `targeted_calibration_v2_report.json`
3. `targeted_heldout_v2_report.json`

Candidate profile must include:
- inherited v1 model identity;
- explicit status: CANDIDATE / not production canonical yet;
- `short_normal_floor_sec`;
- `mixed_margin_sec`;
- exact branch rules;
- unchanged semantic speed map;
- held-out result summary.

## Cleanup

If PASS or PASS_WITH_MINOR:
- delete temporary scripts/debug logs/new WAVs;
- retain only the three JSON outputs.

If RETURN:
- retain only failed held-out WAV(s) plus the three JSON outputs.

Do not modify episode SRT, G4/G5 artifacts, or production package.

## Final response

Return only:
- V2C001/V2C002/V2C003 measured durations;
- frozen `short_normal_floor_sec`;
- frozen `mixed_margin_sec`;
- 3-row held-out table with allocated / actual / required_extra_speed / tail_slack / result;
- overall result;
- retained file paths.
