# SRT / Audio Timing Standard v0.2 — CANONICAL

## Status

`CANONICAL / SEMANTIC-TIMING + AUDIO-FEASIBILITY MODEL`

Date: 2026-09-21

## 1. Purpose

This standard defines how locked Script, semantic rhythm, TTS, SRT, Visual Beats and the final Shot Timeline obtain timing.

The key correction is:

> **Natural TTS duration is a feasibility measurement, not the creative timing authority.**

The previous v0.1 over-corrected toward “audio first” and risked erasing deliberate semantic pacing already designed upstream.

The production system therefore uses two different authorities:

- **Semantic Timing Intent** decides how a line should feel: fast / normal / slow / punch / build / reversal / hold / final.
- **Measured TTS Audio** decides what is physically achievable with the locked voice without sounding unnatural.

Final timing must satisfy both.

---

## 2. Two-clock model

### 2.1 Creative clock — Semantic Timing Intent

G4 / Director may intentionally require:
- a quick line;
- a slow landing;
- a compressed build;
- a delayed reveal;
- a punch followed by silence;
- a reversal hold;
- a final line with breathing room.

These are real creative constraints and MUST NOT be discarded simply because TTS at `speed=1.0` has a different natural duration.

### 2.2 Physical clock — Measured Voice Feasibility

The fixed production voice provides:
- raw spoken duration;
- feasible speed range;
- real pause behavior;
- leading/trailing silence;
- pronunciation stability.

This measurement prevents semantic timing targets from demanding physically bad speech.

### 2.3 Final production clock

The final Audio Master is the exact physical timeline **after** semantic timing constraints have been solved.

Therefore:

> **Semantic Timing Intent constrains the schedule; Audio Master freezes the solved schedule.**

Audio Master is not allowed to erase upstream rhythm design.
Semantic timing is not allowed to force obviously unnatural speech.

---

## 3. Separate four timing units

### 3.1 Speech Unit

A natural spoken/prosody unit.

Split by spoken meaning, breath, setup/reveal structure and rhetorical function — not by image count.

### 3.2 Subtitle Cue

A readability unit.

Default:
- one natural semantic unit per cue;
- no blank line inside a cue;
- maximum two visible lines;
- one cue may map to one or multiple Visual Beats;
- one Visual Beat may span multiple cues.

### 3.3 Visual Beat

An image-state / visual-meaning unit controlled by G4.

Visual Beat count never determines subtitle count.

### 3.4 Semantic Timing Unit

A Speech Unit or intentional silence carrying an explicit rhythm contract.

Minimum fields:

- `timing_kind`
- `pace_intent`
- `timing_lock`
- `reference_duration`
- `pause_before_range_ms`
- `pause_after_range_ms`
- `stretch_priority`

---

## 4. Timing kinds and pace intent

Existing G4 timing kinds remain meaningful.

Recommended default interpretation:

| timing_kind | pace_intent | speech behavior | pause behavior |
|---|---|---|---|
| NORMAL | NORMAL | conversational | ordinary |
| BUILD / BUILD_PATTERN | FAST_NORMAL | slightly compressed | low pause |
| PUNCH_SETUP | NORMAL | clear setup | short anticipatory pause |
| PUNCH | FAST_CLEAR | concise, firm | visible post-pause allowed |
| REVERSAL | CONTROLLED | do not rush reveal | stronger post-hold |
| REACTION | N/A or SLOW | often little/no speech | hold matters |
| FINAL | SLOW_NORMAL | allow landing | stronger tail pause |

Initial voice-speed envelopes for calibration:

- `SLOW_NORMAL`: about `0.92–1.00x`
- `NORMAL`: about `0.97–1.05x`
- `FAST_NORMAL`: about `1.02–1.10x`
- `FAST_CLEAR`: about `1.03–1.12x`
- `CONTROLLED`: about `0.97–1.05x`

These are starting envelopes, not universal laws. The current voice must be calibrated by listening.

A line may intentionally be faster than “natural speed=1.0”.
That is different from forcing a line to `1.407x` merely to rescue a bad allocation.

---

## 5. Timing lock classes

### HARD_ANCHOR

Use when exact/near-exact duration is part of meaning:
- deliberate silence;
- reaction hold;
- setup/reveal gap;
- major reversal beat;
- explicitly owner-approved anchor.

This time is protected during rebalancing.

### SEMANTIC_RANGE

Use when pace matters but exact milliseconds do not.

Example:
- punch should be quick;
- final line should land slowly;
- explanation should remain conversational.

The compiler should preserve the intended range, not one arbitrary number.

### ELASTIC

Use for narration/explanation whose exact duration may donate or borrow time while preserving meaning.

Most `NORMAL` exposition is elastic.

---

## 6. Reference duration is a prior, not disposable

A G4 `reference_duration` may encode intentional rhythm and must not be thrown away.

For each Semantic Timing Unit:

1. keep the original reference duration;
2. measure raw TTS duration at calibrated base speed;
3. derive the speed needed to hit the old reference window;
4. compare that speed with the unit's semantic speed envelope.

### If feasible

If the old reference duration can be achieved inside the semantic envelope:

> keep the original window or stay very close to it.

### If infeasible

If the old reference duration requires speech outside the semantic envelope:

> the compiler MUST NOT simply force the speed.

Instead it performs local time reallocation.

---

## 7. Local time reallocation

Reallocation happens in this order:

1. preserve `HARD_ANCHOR` units;
2. preserve semantic pace class;
3. reduce unnecessary technical silence;
4. use allowed speed range for the current timing kind;
5. borrow time from nearby `ELASTIC` units with slack;
6. redistribute within the same Semantic Shot / local Sequence first;
7. preserve section anchor points and overall episode duration when feasible;
8. only expand the section / episode when no acceptable local solution exists.

Hard principle:

> **A high-risk line should borrow time from elastic neighbors before it is forced to sound unnatural.**

A timing change should be as local as possible.

Do not globally convert the entire episode to one “natural” pace merely because one line failed.

---

## 8. Feasibility calculation

For a unit:

- `N` = measured raw spoken duration at calibrated base voice;
- `R` = original reference window;
- `P` = protected/desired pause inside that window;
- `A = R - P` = available spoken time;
- `Q = N / A` = required speed ratio.

Interpretation:

- if `Q` lies inside the semantic speed envelope → reference timing is feasible;
- if `Q` is slightly outside → local redistribution first;
- if `Q` is far outside → reference window is invalid for this voice/text pair.

Do not judge by one universal ratio alone. The acceptable ratio depends on semantic intent.

---

## 9. Pause is semantic, not leftover silence

Technical silence and dramatic pause are different.

### Technical silence

Generated by TTS implementation.
Normalize/remove as needed.

### Semantic pause

Intentionally authored.

Initial ranges:

- ordinary continuation: `60–140ms`
- setup → quote/answer: `80–180ms`
- semantic transition: `140–300ms`
- punch/reversal hold: `250–700ms`
- deliberate silent reaction: `500–1500ms`

Semantic pauses are first-class timing units and must not be silently consumed to fix a dense line unless their lock permits it.

---

## 10. Production procedure

### Phase A — Lock semantic rhythm

From Script + G4:

- segment Speech Units;
- preserve existing `timing_kind`;
- assign `pace_intent`;
- assign `timing_lock`;
- retain old reference durations as priors;
- identify explicit pauses / holds.

### Phase B — Voice calibration dry run

Using fixed Voice Profile:

- generate each Speech Unit at calibrated base speed;
- measure spoken duration;
- normalize technical head/tail silence;
- do not yet assemble final audio.

This is measurement, not final pacing.

### Phase C — Timing solve

For every unit:

- test original reference window against its semantic speed envelope;
- keep feasible windows;
- locally rebalance infeasible windows;
- protect anchors;
- preserve sequence-level rhythm.

### Phase D — Semantic-paced TTS

Generate each Speech Unit at the solved semantic speed.

The episode MAY contain intentionally different speeds when justified by timing kind.

Random speed variation is prohibited.

### Phase E — Build Audio Master

Assemble:
- solved spoken units;
- authored semantic pauses;
- protected holds.

This becomes `FINAL_AUDIO.wav`.

### Phase F — Compile final SRT

Compile exact Subtitle Cue timestamps from the solved Audio Master.

### Phase G — Compile exact Visual Beat timing

Map accepted Visual Beats onto the solved audio timeline while preserving:
- beat order;
- meaning;
- POV;
- setup/reveal relation;
- relative rhythm intent.

---

## 11. High-risk timing gate

Before full production, audit the whole script — not just one arbitrary case.

Flag at minimum:

- high text-density units;
- very short reference windows;
- long quoted lines;
- punch/reversal chains;
- protected silence;
- units requiring speed outside their semantic envelope;
- local regions with insufficient elastic slack.

High-risk sample must include:

1. normal baseline;
2. densest line;
3. short punch;
4. reversal/quote/hold when present.

A failed high-risk case triggers **timing reallocation**, not immediate script rewrite and not blind speed-up.

---

## 12. Blind Search Answer diagnosis

Observed:

### Baseline

- raw TTS: `2.5542s`
- old window: `2.680s`
- feasible at normal pace
- result: PASS

### Tight line

Text:

`所以现在我看 AI 搜索结果，已经不太把“有引用”当成正确证明了。`

- raw TTS: `4.2493s`
- old window: `3.020s`
- required: `1.4070x`
- listening result: unacceptable

Correct diagnosis:

> This does NOT prove that all old timing should be replaced by natural TTS timing.

It proves that this specific reference window is infeasible for its current semantic category + voice + text.

Correct repair:

> preserve its semantic role, enlarge its local speech window, and recover time from nearby elastic beats where possible.

### Punch

- raw TTS: `1.2771s`
- old window: `1.350s`
- feasible
- result: PASS

Therefore the old timeline contains both valid and invalid allocations. It should be **calibrated**, not discarded.

---

## 13. File roles

### `REFERENCE_TIMING.srt`

Contains the original semantic rhythm proposal.

Status:
`REFERENCE / CALIBRATION INPUT`

It is NOT production-final, but it is not meaningless.

### `TIMING_CALIBRATION.json`

Required G6 intermediate artifact.

For each Speech Unit:

- original reference duration;
- timing kind;
- timing lock;
- measured raw TTS duration;
- semantic speed envelope;
- required ratio;
- solved speed;
- borrowed/donated time;
- final duration;
- validation result.

### `FINAL_AUDIO.wav`

Final solved semantic-paced audio.

### `FINAL_AUDIO_ALIGNED.srt`

Final subtitle timestamps.

### `07_SHOT_TIMELINE.csv`

Exact Visual Beat timeline compiled from the solved audio.

---

## 14. G4 / G6 responsibility

### G4 owns

- semantic rhythm;
- `timing_kind`;
- fast/slow/punch/reversal/hold intent;
- reference duration / relative duration design;
- timing anchors.

### G6 owns

- voice feasibility measurement;
- speed-envelope calibration;
- local reallocation;
- final exact milliseconds;
- Audio Master;
- final SRT / Shot Timeline.

G6 may not flatten all timing kinds into one natural speaking speed.

G4 may not demand an infeasible exact duration after voice calibration.

---

## 15. Acceptance gate

Timing passes only when:

- locked text remains unchanged;
- semantic timing intent is preserved;
- protected anchors are preserved;
- Voice Profile is fixed;
- high-risk units have been measured;
- no line is made audibly unnatural merely to preserve a bad numeric window;
- reallocation is local and traceable;
- SRT is structurally valid;
- final Visual Beat timing matches solved audio;
- timing calibration artifact records all exceptions.

Failure codes:

- `RETURN_SRT_STRUCTURE_INVALID`
- `RETURN_SEMANTIC_TIMING_LOST`
- `RETURN_TIMING_WINDOW_INFEASIBLE`
- `RETURN_LOCAL_REALLOCATION_FAILED`
- `RETURN_LOCAL_SPEED_EXCESSIVE`
- `RETURN_TIMELINE_MISMATCH`

---

## 16. Core principle

> **语义先决定“这句话应该怎么快慢”，声音再验证“这个快慢能不能自然做到”。**

Do not force every line to natural speed.

Do not force every line to an arbitrary pre-existing timestamp.

Preserve the designed rhythm, then calibrate only the physically impossible parts.
