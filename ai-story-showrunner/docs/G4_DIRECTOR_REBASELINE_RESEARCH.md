# G4 Director Rebaseline Research Notes v0.1

## Status
Research synthesis supporting `G4 Director Language Rules v0.2 — CANDIDATE`.

## Problem discovered
G4 v0.1 validated output quality on three cases, but the rule system was partly case-derived and under-specified in director grammar.

Missing areas:
- explicit dramatic-beat layer;
- visual intention before camera choice;
- motivated shot size / POV / angle;
- blocking/staging;
- eye-trace and spatial continuity;
- edit-priority hierarchy;
- visual-intensity progression across an episode.

## Source map

### Robert McKee
Useful for:
- Beat = behavior exchange in action/reaction;
- beat changes form scene turns;
- scenes should create meaningful value/state change;
- activity without change is not enough.

Project use:
Dramatic Beat Map and state-change gate.

### Walter Murch — In the Blink of an Eye / Rule of Six
Useful for cut priority:
emotion → story → rhythm → eye-trace → 2D plane → 3D space.

Project use:
when continuity and a better emotional/story cut conflict, use explicit priority rather than random aesthetic judgment.

### Steven D. Katz — Film Directing Shot by Shot
Useful for:
- previsualization;
- composition;
- staging;
- continuity style;
- dialogue staging;
- camera angles;
- POV;
- depth;
- movement.

Project use:
shot-function, blocking, camera choice, spatial model.

### Michael Rabiger / Mick Hurbis-Cherrier — Directing: Film Techniques and Aesthetics
Useful for:
- cinematic point of view;
- frame/shot;
- edit language;
- human vantage;
- script exploration;
- visual design;
- shooting script;
- directing actors;
- continuity.

Project use:
visual-intention and human-vantage layer before technical shot fields.

### Bruce Block — The Visual Story
Useful for:
- space;
- line;
- shape;
- tone;
- color;
- movement;
- rhythm;
- contrast / affinity;
- visual structure tied to story structure.

Project use:
sequence-level visual intensity and motif progression.

### Jingsui calibrated source material
Useful for:
- ~5.9 Chinese chars/s;
- visual beat median ~2.7s;
- still-image / limited-animation density.

Project use:
timing calibration only, after dramatic and visual decisions.

## Research conclusion

The Director Compiler should not be one algorithm.

It is a hierarchy:

```text
Story logic
→ Audience intention
→ Staging / camera language
→ Visual structure
→ Image-level beat decomposition
→ Format-specific timing
```

This hierarchy reduces two previous risks:
1. using Jingsui surface style to decide story-level cuts;
2. choosing camera variety without a dramatic reason.

## Sources

- McKee Seminars — Do Your Scenes Turn?
  https://mckeestory.com/do-your-scenes-turn/
- Walter Murch — In the Blink of an Eye / Rule of Six
  surfaced educational PDF excerpt
- Steven D. Katz — Film Directing Shot by Shot, 25th Anniversary Edition
  Google Books / library publisher descriptions
- Michael Rabiger & Mick Hurbis-Cherrier — Directing: Film Techniques and Aesthetics, 6th ed.
  Routledge
- Bruce Block — The Visual Story, 3rd ed.
  Routledge
