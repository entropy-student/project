# Visual Beat Grammar v0.1

> Status: PROVISIONAL — derived from full deconstruction of Benchmark A. Suitable for G2 prototype; must be cross-video validated before final Director Skill freeze.

## Core Principle

**Do not animate sentences. Stage meanings.**

The narration is the master timeline. Every meaningful idea can be represented by zero, one or multiple visual beats. A visual beat may also span multiple spoken fragments.

## G01 — Hard Cut Is the Default
Default transition: `HARD_CUT`. Do not add wipes, reveals or dissolves merely to create activity. Change the semantic image instead.

## G02 — Hold Is Normal
Inside a shot, the composition may be completely static for ~1–5 s. Static does not equal dead if the pose and drawing already communicate action/emotion.

## G03 — Target Cadence
- median shot: ~2.2 s
- typical range: ~1.6–3.4 s
- long explanatory hold: up to ~5.4 s
- starting target: 3–5 meaningful visual changes per 10 s

Do not force a cut if meaning has not changed.

## G04 — Pose Is the Performance
Prefer a purpose-built pose over runtime motion. Motion lines and deformation can be drawn into the still asset.

## G05 — Convert Metaphor into a Concrete Gag
When narration contains metaphor, contrast, exaggeration or idiom, do not illustrate literally. Transform it into a visual joke/tableau.

## G06 — Allow 1→N Mapping
One semantic thought may need multiple visual beats: setup → reaction → payoff, before → after, subject → exaggeration, claim → visual proof.

## G07 — Allow N→1 Mapping
A strong image may span multiple narration fragments. Do not regenerate art simply because subtitle text changed.

## G08 — Mix Visual Classes
Rotate between:
1. `CHARACTER_POSE`
2. `NARRATIVE_TABLEAU`
3. `METAPHOR_GAG`
4. `ICON_CARD`
5. `EVIDENCE_INSERT`
6. `SUMMARY_BOARD`

This prevents “same character talking on white” fatigue.

## G09 — Reuse Deliberately
Reuse an exact composition when the same internal state or conceptual function returns. Freshness can come from context, caption and neighboring shots.

## G10 — Create Callbacks
Reintroduce earlier assets near the end to create narrative closure.

## G11 — Use Environment Only When It Adds Meaning
Most shots can remain on a clean background. Add scene context only when spatial context carries the joke or information.

## G12 — Use Graphic Punctuation
Section numbers, props, small text, arrows, impact lines and boards can carry beats without creating a full new scene.

## G13 — Runtime Camera Is Optional
For G2 baseline, `camera = HOLD` unless a specific narrative reason exists. Do not assume pan/zoom is what makes the reference feel alive.

## G14 — Originality Constraint
Learn timing/grammar, but create original character design, poses/art, caption treatment, props and backgrounds.

## Director Output Contract v0.1

```json
{
  "t_in": 0.0,
  "t_out": 2.2,
  "spoken_beat": "semantic fragment",
  "visual_class": "METAPHOR_GAG",
  "narrative_job": "contrast",
  "visual_concept": "what the audience should see",
  "asset_strategy": "REUSE | VARIANT | NEW_ART | EXTERNAL_INSERT",
  "character_pose": "optional pose id",
  "props": [],
  "background": "WHITE | scene-id",
  "camera": "HOLD",
  "transition_in": "HARD_CUT",
  "sfx": [],
  "notes": "why this beat exists"
}
```

The Director's main job is choosing `visual_concept`, `visual_class`, `narrative_job` and `asset_strategy`. Rendering is secondary.
