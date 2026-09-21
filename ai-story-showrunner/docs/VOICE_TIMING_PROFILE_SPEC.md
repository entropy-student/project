# Voice Timing Profile Specification v0.2 — CANONICAL

## Purpose

Create a reusable timing model for one fixed production voice so production SRT can be compiled at the Writer/Timing stage without routine second-pass retiming after real TTS.

The Voice Timing Profile is calibrated once per materially different voice setup and then reused across episodes.

## Recalibration triggers

Recalibrate only when one of these materially changes:
- TTS model / engine;
- reference voice audio;
- reference transcript;
- speaking-style target;
- language;
- generation settings that materially affect prosody.

A normal new episode does NOT trigger recalibration.

## v1 calibration finding

The first 14-train / 4-held-out Huber regression failed held-out validation.

Key lessons:
- short NORMAL utterances have high lexical/prosodic variance and need a conservative minimum-duration floor;
- separate large Latin-token and number-token penalties can over-count mixed-token lines;
- one keyword pair is insufficient evidence for keyword-specific pause rules;
- the model objective must prioritize safe timing windows, not symmetric absolute-error minimization.

The v1 profile is rejected and must not be used for production.

## Profile dimensions

The profile must model at least:

### Semantic pace class
- SLOW_NORMAL
- NORMAL
- FAST_NORMAL
- FAST_CLEAR / PUNCH
- CONTROLLED / REVERSAL
- FINAL

### Length bucket
- SHORT
- MEDIUM
- LONG

### Text features
- Chinese character count;
- punctuation counts;
- comma/period/question/colon/quote;
- Arabic numbers;
- Latin/English tokens;
- abbreviations such as AI / MCP;
- quoted speech;
- clause count.

### Fixed-cost effects
Short utterances have non-linear onset/offset cost and must not be estimated by chars/sec alone.

A v2 profile should include a conservative `short_normal_min_duration` calibrated across multiple unrelated short utterances, rather than learning a single unconstrained linear short-utterance coefficient.

### Mixed-token normalization
Latin abbreviations and Arabic numbers should be normalized toward approximate spoken/effective units before duration estimation. Avoid independent large fixed penalties that simply add together when multiple token types co-occur.

## Required outputs

For each semantic pace class, store:
- target effective chars/sec;
- preferred lower/upper range;
- hard-risk upper bound;
- minimum utterance duration;
- punctuation pause priors;
- short-utterance fixed cost;
- prediction-error distribution;
- sample count;
- confidence.

Recommended top-level artifact:

`VOICE_TIMING_PROFILE.json`

## Timing prediction

Production SRT estimation should use:

```text
predicted_speech_duration
= lexical_duration
+ punctuation_cost
+ short_utterance_fixed_cost
+ token_adjustments
+ semantic_pace_adjustment
```

Then add authored semantic pauses separately.

Do not use one universal chars/sec value for every line.

## Calibration set

Minimum one-time calibration set should contain 15–24 representative utterances covering:

- short / medium / long NORMAL;
- BUILD / FAST_NORMAL;
- PUNCH;
- REVERSAL / CONTROLLED;
- FINAL / landing;
- comma-heavy sentence;
- question;
- quote;
- colon → quote;
- numbers;
- AI / MCP / English tokens;
- long sentence;
- very short utterance.

Use the canonical reference voice and fixed seed/settings.

## Acceptance target

The profile is good enough for normal production when it prevents unsafe under-allocation and keeps excess slack within semantic tolerance.

Primary safety metrics:

`under_allocation = max(0, actual_duration - allocated_window)`

`required_extra_speed = actual_duration / allocated_window`

Initial technical limits:
- `required_extra_speed <= 1.03x` → PASS;
- `1.03x–1.05x` → PASS_WITH_MINOR;
- `>1.05x` → RETURN_PROFILE_MISS.

Over-allocation is tracked separately:

`tail_slack = max(0, allocated_window - actual_duration)`

Over-allocation does not force bad speech, but excessive slack can damage pacing. Evaluate it by semantic class:
- PUNCH / FAST_CLEAR: preferred <= 300ms;
- NORMAL / FAST_NORMAL: preferred <= 600ms;
- CONTROLLED / FINAL: preferred <= 700ms.

Absolute error remains diagnostic, not the sole PASS criterion.

Do not treat under-allocation and over-allocation as equivalent failure modes.

## Production behavior

Normal episode:

```text
locked script
→ semantic timing classification
→ Voice Timing Profile
→ Production SRT + TTS Manifest
→ Director / assets
→ Antigravity execution
```

Antigravity generates the real TTS according to the locked manifest.

If actual TTS differs only by small technical error, apply bounded technical alignment.

If actual TTS materially exceeds the prediction:
`RETURN_VOICE_TIMING_PROFILE_MISS`

That is a profile/compiler defect, not a normal manual retiming step.

## Execution ownership

Upstream owns:
- text;
- semantic pace;
- target timestamps;
- voice profile;
- per-unit intended speed;
- authored pauses.

Antigravity owns only deterministic execution of the locked TTS recipe.

Antigravity must not:
- rewrite;
- choose a new pace;
- move semantic pauses;
- creatively retime SRT.
