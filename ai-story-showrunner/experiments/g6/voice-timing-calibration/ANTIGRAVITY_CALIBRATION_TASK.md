# Antigravity Task — Voice Timing Profile Calibration v1

## Goal

Build a reusable `VOICE_TIMING_PROFILE.json` for the current canonical CosyVoice voice.

This is a one-time calibration task. Do NOT generate the full episode and do NOT redesign any SRT.

Calibration set:
`ai-story-showrunner/experiments/g6/voice-timing-calibration/CALIBRATION_SET_V1.json`

There are 18 total samples:
- 14 training samples;
- 4 strict held-out samples;
- CAL001/CAL002/CAL003 already have prior observed durations and do not need to be regenerated unless required for measurement compatibility;
- therefore normally generate only the remaining 15 new samples.

## Fixed environment

Use exactly:

- reference wav:
  `C:\Users\34707\Desktop\视频制作流\5.音频制作\reference-clone.wav`
- reference transcript:
  `C:\Users\34707\Desktop\视频制作流\5.音频制作\reference-clone-text.txt`
- CosyVoice:
  `C:\Users\34707\Desktop\视频制作流\5.音频制作\CosyVoice`
- venv:
  `C:\Users\34707\Desktop\视频制作流\5.音频制作\cosyvoice-venv`
- model: current validated CosyVoice-300M
- inference: zero_shot
- seed: `1986`
- load model once
- cache speaker prompt once
- do not reinstall or alter the validated environment

## Execution rules

1. Read the calibration JSON.
2. Do not change any sample text.
3. Generate each new sample once only at its specified `generation_speed`.
4. Do not retry for aesthetic variation.
5. For every sample record:
   - raw duration;
   - normalized/effective duration;
   - sample rate;
   - generation speed;
   - CJK char count;
   - Latin/abbreviation token count;
   - Arabic-number token count;
   - soft punctuation count;
   - hard punctuation count;
   - short-utterance indicator.

### Technical-silence normalization

Use one deterministic energy-based rule for all samples.

Target behavior:
- trim abnormal technical leading/trailing silence;
- keep approximately 60ms head margin;
- keep approximately 120ms tail margin;
- never truncate voiced phonemes.

Record both raw and normalized durations.

Do not treat semantic pauses as technical silence.

## Train / held-out separation

IMPORTANT:

- Fit the timing model using CAL001–CAL014 only.
- BLD001–BLD004 must not influence model fitting or coefficient choices.
- Fit the model first.
- Freeze coefficients/profile.
- Only then evaluate BLD001–BLD004.

Existing prior durations for CAL001–003 may be used as training evidence, but if their measurement method is incompatible with the new normalization method, regenerate those 3 once under the same measurement pipeline and clearly record why.

## Model

Predict an equivalent base-speed duration using only:

- intercept;
- CJK char count;
- Latin/abbreviation token count;
- Arabic-number token count;
- soft punctuation count;
- hard punctuation count;
- short-utterance indicator.

Prefer robust linear regression if already available in the environment.
Otherwise use ordinary least squares.

Do NOT add polynomial terms or manually tune against the held-out samples.

For a generated sample:

`base_equivalent_duration = normalized_duration * generation_speed`

For prediction:

`predicted_duration = predicted_base_equivalent_duration / intended_speed`

## Required output

Create:

1. `VOICE_TIMING_PROFILE.json`
2. `calibration_report.json`
3. `heldout_report.json`

`VOICE_TIMING_PROFILE.json` must include:
- profile_id/version;
- engine/model/reference identifiers;
- seed;
- normalization rule;
- fitted coefficients;
- semantic-class default speed map;
- punctuation priors or observed effects;
- short-utterance handling;
- sample count;
- training error;
- held-out error;
- confidence/status.

`calibration_report.json`:
- all 14 training rows;
- observed normalized duration;
- base-equivalent duration;
- fitted prediction;
- residual/error.

`heldout_report.json`:
for each of the 4 held-out rows:
- id;
- text;
- semantic class;
- intended speed;
- predicted duration;
- actual normalized duration;
- absolute error ms.

Also report:
- median held-out absolute error;
- p90 held-out absolute error;
- max held-out absolute error;
- PASS / PASS_WITH_MINOR / RETURN_PROFILE_INSUFFICIENT.

Acceptance target:
- median absolute error <= 150ms;
- p90 absolute error <= 300ms;
- no held-out sample requires a large unplanned speed change.

## Failure behavior

If acceptance fails:
- do NOT silently tune coefficients using the held-out values;
- diagnose the missing feature/class;
- return `RETURN_PROFILE_INSUFFICIENT`;
- retain only the failing held-out WAV(s) needed for diagnosis.

If acceptance passes:
- delete temporary scripts;
- delete debug logs;
- delete temporary generated calibration WAVs;
- retain only:
  - `VOICE_TIMING_PROFILE.json`
  - `calibration_report.json`
  - `heldout_report.json`

Do not modify the full episode, G4/G5 assets, or current production SRT during this task.

## Final response

Return only:
- environment/model confirmation;
- training metric summary;
- 4-row held-out result table;
- median / p90 / max error;
- overall result;
- retained file paths.
