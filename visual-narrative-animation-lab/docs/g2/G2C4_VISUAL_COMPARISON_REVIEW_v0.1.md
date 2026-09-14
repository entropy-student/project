# G2C4 — Visual Comparison Review v0.1

> Review target: `G2C_animatic_v0.mp4`
> Benchmark: G1 reference deconstruction
> Decision: **RETURN**

## What v0 proved

- narration can map to Visual Beats rather than punctuation;
- 1→N and N→1 speech/visual mapping works;
- deliberate reuse/callback works;
- readable copy should be post-overlaid Simplified Chinese;
- hard cuts are sufficient as the baseline transition grammar.

These findings remain locked.

## Why v0 still feels too much like an illustrated slideshow

### 1. Asset compression went too far

18 beats were compressed into only 8 major compositions. This proves reuse efficiency, but removes too many semantic redraws. The benchmark often creates a new pose/object/tableau specifically for a phrase or joke even when the drawing itself is very simple.

**Correction:** for a ~38 s piece, target roughly **12–14 distinct semantic visual states**, with 4–6 explicit callbacks/variants.

### 2. Reuse sometimes changes only the caption

Several beats keep nearly identical staging while the overlay text changes. That is presentation grammar.

**Correction:** when meaning changes, change at least one non-text visual carrier where useful: pose, crop, prop state, highlighted area, inserted object, reaction, screen state, or shot scale.

### 3. Visual-class variety is too narrow

v0 is dominated by polished character/tableau illustrations. The benchmark rotates among character poses, full-body gags, hand/object close-ups, prop-only frames, simple icons/diagrams, screenshots/game footage, callbacks and reaction holds.

**Correction:** each 30–45 s test should include at least 4 visual classes.

### 4. The art is too complete to function cheaply as performance assets

The current anime frames read as finished illustrations, which makes hard cuts feel like a gallery. The benchmark uses simpler, pose-specific drawings whose purpose is to deliver one semantic beat quickly.

**Correction:** keep character identity, but allow simpler compositions, larger gestures, fewer background details, more empty space and more prop/pose-specific frames.

### 5. Punchline staging is underpowered

v0 intentionally omitted motion and SFX. Several beats now need small performance accents: snap crop/punch-in, reaction hold, prop pop-in, one-step lateral reveal and short SFX hits.

**Correction:** add sparse semantic motion only; do not introduce continuous camera animation.

## Diagnosis

> The target feeling comes from **semantic redraw density + visual-class rotation + joke-specific staging**, with motion as a secondary accent.

The problem is not “we need more animation”. The problem is that we reused too much of the same finished composition and asked subtitles to carry meaning that should have been carried by the image.

## Decision

**RETURN — targeted correction only.** Do not redesign the project, character, script or architecture.

Proceed to **G2C5 — Animatic v1 correction**:

1. keep the same voiceover and 18-beat structure;
2. increase distinct semantic states from 8 to ~12–14;
3. replace at least 4 caption-dependent beats with visually self-explanatory staging;
4. include at least 4 visual classes;
5. add sparse performance accents and SFX markers;
6. keep hard cuts as default;
7. do not add wipe/reveal animation.

Highest-value bespoke corrections: S04, S05, S06, S07, S08, S11 and S18.

## Gate status

```text
G2C1 Shot Asset Resolution      PASS
G2C2 Major Art Plates           PASS_CANDIDATE
G2C3 Animatic v0                TECHNICAL PASS
G2C4 Narrative Comparison       RETURN
G2C5 Animatic v1 Correction     ← NEXT
```
