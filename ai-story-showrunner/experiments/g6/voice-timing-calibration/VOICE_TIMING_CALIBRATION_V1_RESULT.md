# Voice Timing Calibration v1 — Result

Date: 2026-09-21

Status: `RETURN_PROFILE_INSUFFICIENT`

## Environment

- CosyVoice-300M
- zero_shot
- seed 1986
- Python 3.10.11
- Torch 2.4.1+cpu
- sample rate 22050 Hz
- deterministic energy VAD normalization
- CAL001–CAL003 were regenerated under the same normalization pipeline for comparability

## Training

- train samples: 14
- model: HuberRegressor
- R2: 0.9789
- MAE: 119.9 ms
- median absolute error: 94.3 ms
- max absolute error: 555.0 ms (CAL002)

Frozen coefficients:

- intercept: -0.0076 s
- CJK char: +0.1284 s
- Latin/abbrev token: +0.7370 s
- Arabic-number token: +0.4201 s
- soft punctuation: +0.4680 s
- hard punctuation: +0.2033 s
- short utterance indicator: -0.1311 s

## Held-out

| id | class | predicted | actual | absolute error | direction |
|---|---|---:|---:|---:|---|
| BLD001 | NORMAL | 0.8351s | 1.4215s | 586.4ms | unsafe under-allocation |
| BLD002 | FAST_CLEAR | 2.9927s | 3.0568s | 64.1ms | small under-allocation |
| BLD003 | NORMAL | 4.3892s | 3.5873s | 801.9ms | over-allocation |
| BLD004 | FINAL | 4.7906s | 4.5900s | 200.6ms | over-allocation |

Original symmetric metrics:
- median AE: 393.5 ms
- p90 AE: 737.2 ms
- max AE: 801.9 ms

Original result:
`RETURN_PROFILE_INSUFFICIENT`

## Reviewer diagnosis

The v1 result is valid, but it exposes two different issues.

### 1. The linear model is underfit / unstable

14 training rows for an intercept + six text features is too small for confident generalization.

The learned negative short-utterance coefficient is a warning sign.

The separate Latin and Arabic token coefficients also over-count mixed-token lines when both appear together.

### 2. The original acceptance metric was not aligned with the production objective

For fixed-window TTS, under-allocation and over-allocation are not equally dangerous.

- under-allocation forces speech acceleration and can damage intelligibility/prosody;
- over-allocation creates tail slack/hold, which can affect pacing but does not force speech to become unnaturally fast.

Therefore future acceptance must track:
- required extra speed caused by under-allocation;
- tail slack caused by over-allocation;
- semantic-class-specific slack tolerance.

Absolute error remains diagnostic only; it should not be the sole PASS criterion.

### 3. BLD001 diagnosis must remain cautious

The claim that the word “然后” itself caused a ~500ms implicit pause is plausible but not proven by one pair of examples.

Do not create a keyword-specific “然后 rule” from this evidence.

Preferred fix:
- introduce a conservative SHORT NORMAL minimum-duration floor;
- validate it across several different short NORMAL utterances.

### 4. Mixed Latin + Arabic needs a better representation

Do not sum large independent fixed token penalties.

Candidate v2:
- normalize Latin abbreviations and numbers to approximate spoken syllable/effective-unit counts;
- avoid double startup penalties;
- validate mixed-token combinations directly.

## Decision

Do NOT freeze `VOICE_TIMING_PROFILE_COSYVOICE_300M_V1`.

Do NOT return to full-episode TTS.

Next should be a small targeted v2 calibration focused only on:
- short NORMAL variability;
- mixed Latin + Arabic;
- one long NORMAL control;
- one semantic slow/fast control.

A second full 18-sample sweep is not required unless the targeted v2 still fails.
