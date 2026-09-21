# SRT / Audio Timing Standard v0.3 — CANONICAL

## Status

`CANONICAL / SEMANTIC TIMING + REUSABLE VOICE PROFILE`

Date: 2026-09-21

## 1. Purpose

Production SRT should be compiled correctly near the Writer stage, not routinely redesigned after real audio generation.

The timing system therefore separates:

- **Semantic Timing Intent** — how fast/slow/held a line should feel;
- **Voice Timing Profile** — reusable empirical model of how the fixed production voice behaves;
- **Production SRT** — timestamps predicted from both;
- **Execution TTS** — Antigravity deterministically renders the already-locked timing contract.

Real TTS is primarily a QA signal, not a normal second creative timing pass.

Canonical Voice Timing Profile specification:
`docs/VOICE_TIMING_PROFILE_SPEC.md`

---

## 2. Timing authority

### Creative authority

G3/G4 semantic rhythm decides:
- NORMAL / BUILD / PUNCH / REVERSAL / REACTION / FINAL;
- relative fast/slow behavior;
- protected holds;
- semantic pauses;
- pacing intent.

### Prediction authority

The reusable `VOICE_TIMING_PROFILE.json` predicts physically reasonable duration for the locked voice.

### Exact execution authority

The resulting Production SRT + TTS Manifest are locked before Antigravity execution.

Antigravity must execute them, not redesign them.

If execution materially misses prediction:
`RETURN_VOICE_TIMING_PROFILE_MISS`

---

## 3. Production flow

```text
LOCKED SCRIPT
  ↓
SPEECH UNIT SEGMENTATION
  ↓
SEMANTIC TIMING CLASS
  ↓
VOICE_TIMING_PROFILE
  ↓
PRODUCTION SRT + TTS MANIFEST
  ↓
G4 DIRECTOR
  ↓
G5 ASSET PACKAGE
  ↓
G6 PRODUCTION PACKAGE
  ↓
ANTIGRAVITY
  ├─ deterministic CosyVoice TTS
  ├─ image generation/edit
  ├─ timeline assembly
  └─ final render
```

The normal episode does NOT insert a second creative SRT-calibration stage after TTS.

---

## 4. Timing units

### Speech Unit

A natural spoken/prosody unit.

Split by:
- sentence meaning;
- breath;
- setup → quote;
- question → answer;
- reversal;
- punch;
- intentional pause.

Do not split merely because an image changes.

### Subtitle Cue

A readability unit.

Rules:
- one natural semantic unit by default;
- no blank line inside cue;
- maximum two visible lines;
- may map many-to-many with Visual Beats.

### Visual Beat

A visual meaning/state unit.

Visual Beat count does not determine subtitle count.

### Semantic Pause

An intentional silence/hold.

It is not TTS garbage silence and is not disposable.

---

## 5. Semantic pace classes

Recommended starting classes:

| class | intent | initial voice-speed envelope |
|---|---|---|
| SLOW_NORMAL | reflective / landing | 0.92–1.00x |
| NORMAL | conversational | 0.97–1.05x |
| FAST_NORMAL | compressed build | 1.02–1.10x |
| FAST_CLEAR | punch / concise | 1.03–1.12x |
| CONTROLLED | reversal / important reveal | 0.97–1.05x |
| FINAL | landing / finish | 0.92–1.00x |

These are calibration envelopes, not universal constants.

The Voice Timing Profile may refine them.

---

## 6. Timing lock classes

### HARD_ANCHOR

Exact/near-exact duration matters:
- deliberate silence;
- reversal hold;
- setup/reveal gap;
- owner-approved timing anchor.

### SEMANTIC_RANGE

Pace matters; exact milliseconds do not.

### ELASTIC

Ordinary narration may donate/borrow small amounts of time while preserving meaning.

---

## 7. Production-SRT compilation

For every Speech Unit:

1. identify `timing_kind`;
2. map to semantic pace class;
3. identify lock class;
4. collect text features;
5. predict speech duration using Voice Timing Profile;
6. add semantic pause budget;
7. derive cue start/end;
8. validate local rhythm and target episode duration;
9. output TTS Manifest fields.

The compiler should preserve deliberate relative rhythm from G4 reference timing where useful, but must not blindly inherit a physically implausible numeric window.

---

## 8. Reference timing

Existing G4 reference duration is a semantic prior.

Use it as follows:

### Feasible reference

If Voice Timing Profile predicts the line can fit naturally within the intended semantic speed envelope:

> keep the reference duration or stay close.

### Infeasible reference

If the reference window requires an obviously excessive local speed:

> reallocate locally at compile time before G4/G5 production lock.

Preferred repair order:

1. preserve HARD_ANCHOR;
2. preserve semantic pace class;
3. trim technical/non-semantic slack;
4. use allowed semantic speed envelope;
5. borrow/donate from nearby ELASTIC units;
6. preserve section/episode duration where feasible;
7. expand section only if local solve fails.

This solve should happen before normal downstream production.

---

## 9. Semantic pause priors

Initial calibration priors:

- ordinary continuation: 60–140ms;
- setup → quote/answer: 80–180ms;
- semantic transition: 140–300ms;
- punch/reversal hold: 250–700ms;
- deliberate silent reaction: 500–1500ms.

Voice Timing Profile may refine these.

Technical TTS head/tail silence is separate and should be normalized.

---

## 10. Execution TTS policy

Antigravity receives a locked TTS Manifest containing at least:

- cue / speech_unit_id;
- exact text;
- target start/end;
- semantic pace class;
- intended speed;
- Voice Profile ID;
- reference audio path;
- reference transcript path;
- seed;
- prompt/speaker cache instructions;
- allowed technical alignment tolerance.

Antigravity may:
- load the model once;
- cache speaker features once;
- generate each unit;
- normalize technical silence;
- apply only bounded technical alignment;
- assemble the final audio timeline.

Antigravity may NOT:
- rewrite text;
- choose a different semantic speed;
- redistribute semantic pauses;
- redesign SRT;
- force major per-cue acceleration.

---

## 11. Timing-profile miss

If actual TTS materially differs from predicted Production SRT:

`RETURN_VOICE_TIMING_PROFILE_MISS`

This indicates one of:
- profile lacks a text-feature class;
- semantic classifier is wrong;
- voice/reference changed;
- TTS settings changed;
- predictor is underfit.

Fix the reusable profile/compiler.

Do not normalize this into per-episode manual SRT repair.

---

## 12. Calibration workflow

Voice Timing Profile is calibrated once per materially stable voice setup.

Minimum calibration coverage:
- short / medium / long NORMAL;
- FAST_NORMAL / BUILD;
- PUNCH;
- REVERSAL / CONTROLLED;
- FINAL;
- comma-heavy;
- quote;
- question;
- colon → quote;
- numbers;
- English/AI/MCP tokens;
- very short utterance.

Then validate on held-out utterances.

Target:
- median absolute timing prediction error <= 150ms;
- p90 absolute error <= 300ms;
- no held-out case needs large unplanned speed change.

---

## 13. Current Blind Search Answer evidence

### Baseline

- natural TTS: 2.5542s
- old window: 2.680s
- feasible
- PASS

### Tight line

`所以现在我看 AI 搜索结果，已经不太把“有引用”当成正确证明了。`

- natural TTS: 4.2493s
- old window: 3.020s
- required speed: 1.407x
- listening result: unacceptable

Diagnosis:

> one reference window was infeasible; this does not invalidate semantic timing, and it does not justify flattening the episode to one natural speed.

This case becomes calibration evidence for Voice Timing Profile and the compile-time local solver.

### Punch

- natural TTS: 1.2771s
- old window: 1.350s
- feasible
- PASS

---

## 14. File roles

### `VOICE_TIMING_PROFILE.json`

Reusable voice-specific timing model.

### `PRODUCTION_SUBTITLES.srt`

Production SRT compiled before Director/Asset execution.

### `TTS_MANIFEST.json`

Locked per-unit TTS execution recipe.

### `REFERENCE_TIMING.srt`

Historical / semantic pacing input only.

### `07_SHOT_TIMELINE.csv`

Visual timeline compiled against Production SRT.

---

## 15. Human intervention

Normal production does not require Owner approval of:
- SRT timing;
- final script;
- individual TTS cases.

Escalate only when:
- profile confidence is low;
- a hard timing constraint is infeasible;
- repeated profile misses occur;
- the user explicitly requests a timing/style override.

---

## 16. Core principle

> **语义决定怎么说；Voice Timing Profile 让我们在生成音频之前就知道大概要说多久。**

Production should enter Antigravity with timing already solved.
