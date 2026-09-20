# Jingsui Timing Profile for G4 v0.1

## Source

Derived from the calibrated `jingsui-story-video-director` v3.4 source materials in `entropy-student/spike.skill`.

Observed audio samples:
- ~222.1s / 1256 Chinese chars / 5.66 chars/s
- ~243.4s / 1539 Chinese chars / 6.32 chars/s
- ~161.2s / 914 Chinese chars / 5.67 chars/s
- weighted mean ≈ 5.92 chars/s

Canonical planning speech rate:
`5.9 Chinese chars/s`

Observed visual beat profile:
- median ≈ 2.7s
- P25 ≈ 1.8–1.9s
- P75 ≈ 3.5–3.6s
- ordinary working range ≈ 1.3–4.5s
- fast reaction / punchline ≈ 0.8–1.8s
- complete micro-scene / metaphor ≈ 2.8–4.5s
- explanation / landing beat may hold ≈ 4–8s

## Planning Rule

Until final audio exists, G4 may use:
`TIMING_MODE = JINGSUI_CALIBRATED_PROVISIONAL`

This timing is sufficient for:
- visual beat density planning;
- shot-count planning;
- provisional SRT;
- estimating image count;
- testing Director pacing.

It is NOT final execution timing.

When final audio exists:
`provisional timing → force-align / recompile exact G4B timeline`

## Density Rule

Do not equate one semantic story beat with one image.

A single semantic shot may compile into multiple visual beats when:
- the narration contains action → reaction;
- a joke needs setup + landing;
- an object/UI insert carries a key state change;
- a character pose/expression changes materially;
- visual continuity benefits from A → B → C states.

Planning target:
- most visual beats: 2–4s;
- average should normally remain near 2.7–3.3s for a Jingsui-like surface rhythm;
- longer 4–8s holds are reserved for explanation/landing, not default.

## Pause Model

Planning pauses:
- micro reaction: +0.15–0.35s
- punchline landing: +0.25–0.60s
- major reversal: +0.40–0.90s
- final meaning / close: +0.50–1.20s

Do not insert long therapeutic pauses.

## G4 Implication

Semantic Director and Visual Beat Compiler are separate concepts:

`SemanticShot → 1..N VisualBeats`

Final low-level one-image shot is closer to VisualBeat than to SemanticShot.

This preserves:
- semantic coherence;
- Jingsui-like pacing;
- one-small-shot ≈ one-image;
- no fake final timing before audio.