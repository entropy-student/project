# SRT / Audio Timing Standard v0.1 — CANONICAL

## Status

`CANONICAL / G6 AUDIO-TIMING REBASELINE / OWNER APPROVED`

Date: 2026-09-21

## 1. Purpose

This standard defines how locked script, TTS, SRT, Visual Beats and the final Shot Timeline obtain timing.

It exists because the Blind Search Answer PoC exposed a category error:

> a Visual Beat duration estimate is not a speech-duration contract.

The old reference timeline assigned 3.020s to:

`所以现在我看 AI 搜索结果，已经不太把“有引用”当成正确证明了。`

The locked CosyVoice voice produced the same text naturally in 4.2493s. Forcing it into 3.020s required 1.407x speech speed and was audibly unacceptable.

Therefore exact production timing must be compiled from measured audio, not inherited from G4 visual estimates.

---

## 2. Timing authority

Production timing authority is:

```text
LOCKED SCRIPT
  ↓
SPEECH UNIT SEGMENTATION
  ↓
FIXED VOICE PROFILE + TTS DRY RUN
  ↓
MEASURED AUDIO DURATIONS + EXPLICIT PAUSE BUDGET
  ↓
AUDIO MASTER
  ↓
FINAL SRT
  ↓
VISUAL-BEAT RETIMING
  ↓
SHOT TIMELINE
```

Hard rule:

> **Audio Master is the production clock.**

The following are NOT allowed to act as final production clocks:

- planning speaking-rate estimates;
- G4 Visual Beat estimated start/end;
- image duration guesses;
- subtitle cue count;
- a desired total duration that has not passed audio feasibility review.

---

## 3. Separate the three timing units

### 3.1 Speech Unit

A Speech Unit is a natural TTS/prosody unit.

It is split by spoken meaning and breath/prosody, not by shot count.

Examples that normally become separate Speech Units:

- complete sentences;
- setup line → quoted answer;
- question setup → question;
- reversal line;
- deliberate punch line;
- explicit semantic pause.

Do not merge independent spoken thoughts only to match one Visual Beat.

### 3.2 Subtitle Cue

A Subtitle Cue is a readability unit.

Default:
- one natural semantic unit per cue;
- no blank line inside a cue;
- maximum two visible lines;
- preferred display duration about 1.2–4.5s;
- shorter is allowed for punches;
- longer than about 6s should normally be split at a semantic boundary.

A Subtitle Cue does not need to equal a Visual Beat.

### 3.3 Visual Beat

A Visual Beat is a visual meaning/state unit.

It is controlled by G4 dramatic/visual grammar.

Relationships are explicitly many-to-many:

- one Visual Beat may span several Subtitle Cues;
- one Subtitle Cue may continue across a Visual Beat change;
- neither count constrains the other.

---

## 4. Script → Speech Unit segmentation rules

Split when any of the following is true:

1. a full sentence ends;
2. a colon introduces a quote, answer or reveal;
3. a setup line exists mainly to prepare the next line;
4. a rhetorical question or answer needs its own beat;
5. a contrast/reversal needs an audible reset;
6. the unit is too long for natural single-breath delivery;
7. the writer intentionally inserted a dramatic pause.

Do not split merely because a new image appears.

Do not keep two independent paragraphs in one SRT cue merely because G4 grouped them into one Visual Beat.

`……` or equivalent silent reaction is not spoken subtitle text by default. Represent it as an explicit silence interval.

---

## 5. Voice profile is part of timing

Every production voice must have a fixed Voice Profile:

- TTS engine/model;
- reference audio;
- reference text;
- speaker/prompt cache;
- random seed;
- default TTS speed;
- sample rate;
- silence-normalization policy.

For the current PoC:

- engine: CosyVoice-300M;
- mode: zero-shot;
- reference audio/text: owner local canonical pair;
- speaker prompt: cached once per run;
- random seed: fixed;
- model: loaded once per run.

Changing the reference voice requires a short re-calibration PoC before production use.

---

## 6. Production timing procedure

### Phase A — Planning only

A planning speaking rate such as `5 chars/sec` may estimate rough episode length.

It must be labelled `PLANNING_ONLY`.

It must never be converted directly into final cue timestamps.

### Phase B — Natural TTS dry run

Generate every Speech Unit with the fixed Voice Profile at the episode's single base speed.

Default principle:

> keep one consistent voice speed across the episode.

Measure the actual output duration of every unit.

Normalize technical silence:
- remove abnormal/generated leading silence;
- preserve only a small consistent head margin;
- remove abnormal trailing silence;
- preserve a small natural tail.

Do not cut voiced phonemes.

### Phase C — Explicit pause budget

Pauses are authored separately from speech duration.

Default starting ranges:

- ordinary adjacent sentence: 80–160ms;
- setup → quote/answer: 80–180ms;
- semantic transition: 160–300ms;
- punch/reversal/reaction: 250–700ms;
- deliberate silent dramatic beat: 500–1500ms.

These are calibration ranges, not rigid constants.

### Phase D — Build Audio Master

Concatenate normalized Speech Units and explicit pauses.

The resulting audio timeline defines:
- cue start/end;
- episode duration;
- silence intervals.

### Phase E — Compile SRT

Build SRT from the measured Audio Master.

SRT timestamps must describe the actual spoken audio.

Do not stretch speech to match a pre-existing Visual Beat estimate.

### Phase F — Retime Visual Beats

Preserve:
- Visual Beat order;
- visual intention;
- POV;
- shot function;
- setup/payoff relationship.

Recompile exact Visual Beat start/end against the Audio Master.

G4 reference durations may guide rhythm, but they are soft priors only.

---

## 7. Speed policy

### 7.1 Global speed

If the owner has a preferred total-duration target, first:

1. adjust pause budgets within their allowed ranges;
2. choose one global TTS speed for the episode.

Default preferred global range:

`0.95x–1.08x`

A wider value requires listening review.

### 7.2 Per-cue speed

Per-cue speed changes are NOT the normal way to make timing fit.

Default:
- `1.00x` local speed;
- tiny technical correction only when necessary.

Recommended technical correction:
- automatic: about `0.98x–1.02x`;
- review: about `0.95x–1.05x`;
- outside this range: reallocate timing instead of forcing speech.

Hard principle:

> if one sentence needs major acceleration while nearby cues contain slack, the timeline is wrong.

### 7.3 Hard-duration target

If a hard episode duration cannot be reached with:
- allowed pause compression; and
- one acceptable global speed,

return:

`RETURN_AUDIO_DURATION_TARGET_INCOMPATIBLE`

Do not create local 1.3x–1.5x speech to rescue the schedule.

---

## 8. High-risk timing gate

Before exact Shot Timeline lock, run a full-script timing audit.

At minimum flag:

- unusually long Speech Units;
- very short windows;
- quotation/setup chains;
- reversal/punch sections;
- cues whose natural audio is materially longer than a provisional allocation;
- any local speed requirement beyond the technical correction range.

PoC sampling must include:

1. a normal baseline sentence;
2. the densest/longest high-risk sentence;
3. a short punch;
4. when present, a quote/reversal or deliberate silence case.

A high-risk case failure invalidates the timing model before full-episode execution.

---

## 9. Current Blind Search Answer finding

Observed CosyVoice results:

- baseline:
  - natural 2.5542s;
  - available 2.680s;
  - PASS at 1.00x plus tail silence.

- tight sentence:
  - natural 4.2493s;
  - old Visual-Beat-derived window 3.020s;
  - required 1.4070x;
  - audibly unacceptable;
  - result: reference timing architecture failure, not TTS failure.

- punch:
  - natural 1.2771s;
  - available 1.350s;
  - PASS at 1.00x plus tail silence.

Conclusion:

> `08_REFERENCE_TIMING.srt` remains a planning/reference artifact and MUST NOT be used as the production TTS timing contract.

---

## 10. File roles

### Reference / planning

`REFERENCE_TIMING.srt`

May exist for rough G4 pacing only.

Must be labelled non-production.

### Production

`FINAL_AUDIO.wav`
- canonical production clock.

`FINAL_AUDIO_ALIGNED.srt`
- canonical subtitle timing.

`07_SHOT_TIMELINE.csv`
- exact visual timing compiled from FINAL_AUDIO.

---

## 11. G4 / G6 contract correction

G4 decides:
- what the beat means;
- shot order;
- visual intention;
- viewpoint;
- relative rhythm.

G4 does NOT lock exact speech-constrained timestamps before Audio Master exists.

G6 decides exact production time only after the Audio Master is measured and locked.

---

## 12. Acceptance gate

Production timing may pass only when:

- locked text is unchanged;
- Voice Profile is fixed;
- every Speech Unit has measured duration;
- explicit pauses are represented;
- SRT is structurally valid;
- no cue is forced into unnatural local speed;
- exact Visual Beat timing has been recompiled from audio;
- final Shot Timeline and Audio Master end at the same production time.

Failure codes:

- `RETURN_SRT_STRUCTURE_INVALID`
- `RETURN_SPEECH_UNIT_UNNATURAL`
- `RETURN_LOCAL_SPEED_EXCESSIVE`
- `RETURN_AUDIO_DURATION_TARGET_INCOMPATIBLE`
- `RETURN_TIMELINE_MISMATCH`

---

## 13. Core principle

> **先把话自然地说完，再决定画面在什么时候切。**

Visual rhythm still matters, but exact time is negotiated around real speech instead of forcing speech into guessed visual windows.
