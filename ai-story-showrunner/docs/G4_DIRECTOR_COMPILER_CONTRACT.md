# G4 Director / Shot Compiler Contract v0.4

## Status

`G4 = PASS / OWNER APPROVED`

Canonical Director rules:
`docs/G4_DIRECTOR_LANGUAGE_RULES.md`

Canonical POV grammar:
`docs/G4_VIEWPOINT_GRAMMAR.md`

Validation:
`experiments/g4r-v03/VALIDATION_SUMMARY.md`

## 1. Purpose

Convert locked Script + KnowledgeCore into a complete, human-reviewable Shotbook where every image-level beat has a dramatic reason, visual strategy, framing logic, and reference timing.

G4 ends at **what each image must communicate**.

It does NOT lock:
- final image-generation prompt;
- canonical character reference paths;
- canonical scene reference paths;
- style reference package;
- final generation output filenames.

Those belong to G5.

## 2. Canonical Six-Layer Pipeline

```text
Locked Script + KnowledgeCore
→ 1. Dramatic Hierarchy Map
→ 2. Episode / Sequence Visual Strategy
→ 3. Visual Intention Map
→ 4. Semantic Shot Design
→ 5. Visual Beat Compilation
→ 6. Timing & Edit Calibration
→ Director Shotboard / Shotbook
```

Cross-cutting QA:
- Knowledge integrity;
- Murch priority;
- eye-trace / spatial continuity where applicable;
- montage / contrast / metaphor relation;
- anti-PPT;
- still-image executability;
- 100% locked-script coverage.

## 3. Dramatic Hierarchy

Use McKee-derived:
`Sequence → Scene → Beat`.

Beat = action/reaction/tactic change.
Scene = perceptible story/value/state turn.
Sequence = larger cumulative dramatic movement.

Failure:
- `RETURN_DRAMATIC_HIERARCHY_FLAT`
- `RETURN_BEAT_OVERSEGMENTED`

## 4. Episode / Sequence Visual Strategy

Before individual shot design, lock:
- primary visual engine;
- optional secondary engine;
- world / scene system;
- 0–2 meaningful motifs;
- 1–3 dominant visual components;
- visual-intensity arc;
- image-relation grammar by sequence.

Allowed relation grammars include:
`CONTINUITY / PARALLEL / MONTAGE / CONTRAST / METAPHOR / INSERT_LED / CLARIFY`.

Failure:
- `RETURN_NO_EPISODE_VISUAL_STRATEGY`
- `RETURN_VISUAL_ENGINE_MISMATCH`

## 5. Visual Intention

Each dramatic unit or cluster must define what the viewer primarily needs to:
`NOTICE / UNDERSTAND / FEEL`.

Camera choices come after intention.

Failure:
`RETURN_CAMERA_CHOICE_UNMOTIVATED`

## 6. Semantic Shot

A Semantic Shot is one coherent Director-level visual strategy.

It locks:
- dramatic refs;
- primary visual intention;
- shot function;
- subject priority;
- staging / blocking;
- framing strategy / shot-size progression plan;
- POV strategy;
- composition strategy;
- eye-trace;
- screen-direction rule where continuity applies;
- visual intensity;
- image-relation grammar;
- visual state;
- acceptance criteria.

It does NOT lock one exact image size/POV for every child beat.

## 7. Visual Beat

Relationship:
`Semantic Shot → 1..N Visual Beats`.

Visual Beat is the closest planning unit to one final generated still.

Each Visual Beat locks:
- narration fragment;
- local visual intention;
- actual shot size;
- actual POV / angle;
- POV reason;
- image-level state;
- image relation;
- visual intensity;
- reference timing.

Split only when image-level meaning changes.

A spoken list does not automatically become montage.

Setup and reveal may be separate beats when withholding information creates the payoff.

POV must be motivated by the Beat:
- reaction/body meaning → OBSERVER;
- shared discovery/read → IP_POV;
- owned manual action → IP_POV_HANDS;
- actor + readable target → OVER_SHOULDER_IP;
- causal object alone → OBJECTIVE_INSERT.

Failures:
- `RETURN_POV_UNMOTIVATED`
- `RETURN_POV_SWITCH_UNMOTIVATED`
- `RETURN_VISUAL_BEAT_REDUNDANT`
- `RETURN_MONTAGE_INFLATION`
- `RETURN_REACTION_REDUNDANT`
- `RETURN_INSERT_NOT_CAUSAL`

## 8. Script Coverage Gate

Semantic Shot spans and Visual Beat narration bindings must cover 100% of the locked spoken script, in order.

A difficult-to-visualize line may share an existing visual state; it may not silently disappear.

Failure:
`RETURN_SCRIPT_COVERAGE_GAP`

## 9. Timing & Edit Calibration

Meaning decides the unit; rhythm decides the duration.

Current Jingsui-calibrated priors:
- speech planning prior ≈ 5.9 Chinese chars/s;
- historical visual-beat median ≈ 2.7s;
- fast reaction/punchline ≈ 0.8–1.8s;
- ordinary observed range ≈ 1.3–4.5s;
- longer explanation/landing may reach 4–8s.

These are priors, not quotas.

Accepted timing source:
- `JINGSUI_CALIBRATED_REFERENCE`; or
- `AUDIO_LOCKED` when real final audio exists.

If later audio materially differs:
`RETURN_TIMELINE_MISMATCH`
and recompile timing only unless visual meaning changed.

## 10. Human Review Output

Every episode should expose a human-readable:

`DIRECTOR_SHOTBOARD.md` or `DIRECTOR_SHOTBOARD.csv`

Minimum columns:
- Beat ID;
- time;
- narration;
- final image state;
- shot size;
- POV;
- visual intention;
- relation / transition notes.

The machine-readable Shotbook remains JSON.

## 11. Gate Evidence

Known cases:
- Agent — ACTION_REACTION;
- Context / Memory — EVOLVING_METAPHOR;
- MCP — REPEATED_FRICTION.

Blind case:
- Search Answer — INVESTIGATION_DISCOVERY.

The blind case required only episode configuration; no seventh layer or material architecture rewrite.

Therefore:
`G4 = PASS`.

## 12. G4 → G5 Boundary

G4 answers:
> What must this image communicate, and why does this image exist?

G5 answers:
> Which locked character/scene/style/prop assets does it use, and what exact prompt/reference package will generate it reproducibly?

Do not fabricate G5 fields inside G4.
