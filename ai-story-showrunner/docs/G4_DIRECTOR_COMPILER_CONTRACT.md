# G4 Director / Shot Compiler Contract v0.1

## Status

G4 = IN_PROGRESS

Purpose:
Convert a locked long-form Script into a visually coherent, execution-ready shot design without inventing fake precision before audio timing exists.

G4 uses three internal layers: G4A1 Semantic Director → G4A2 Visual Beat Compiler → G4B Exact Timeline Compiler.

---

## 1. Why Two Phases

The final execution contract requires exact:
- start;
- end;
- duration;
- subtitle timing.

But the current G3R long-form validation scripts do not yet have final voice audio.

Therefore G4 must not pretend estimated timing is final timing.

> **Semantic shot decisions may be locked before audio; exact timestamps may not.**

---

## 2. G4A1 — Semantic Director

### Input

Required:
- locked Script;
- locked KnowledgeCore;
- locked Story / narrative intent;
- channel IP / character context;
- known visual style constraints.

Optional:
- planning SRT;
- rough duration target.

### Output

`SemanticShotPlan`

Each shot locks:
- semantic_shot_id;
- narration_span / script_span;
- story_function;
- visual_state;
- character_ids;
- scene_id;
- action;
- expression;
- composition;
- camera_angle;
- image_intent;
- continuity_role;
- transition_intent;
- subtitle_intent;
- visual_forbidden;
- acceptance_criteria.

It explicitly does **not** lock:
- final start;
- final end;
- final duration.

### Shot boundary rule

Create a new shot when the **visual state meaningfully changes**:
- action state;
- reaction;
- subject;
- location;
- information state;
- visual metaphor state;
- story consequence;
- payoff/reversal.

Do NOT cut mechanically on:
- punctuation;
- every subtitle cue;
- every sentence.

### Visual progression rule

Prefer:
`state A → state B → state C`

over:
`one static diagram explaining A/B/C`.

### Anti-PPT rule

Return when:
- narration is mostly represented by text cards;
- abstract concepts become boxes/arrows without story need;
- same composition is reused with only labels changed;
- character disappears during mechanism explanation when a character action can carry it.

Failure:
`RETURN_DIRECTOR_BECAME_EXPLAINER`

---

## 3. G4A2 — Visual Beat Compiler

### Purpose

Compile each accepted SemanticShot into 1..N low-level visual beats using the calibrated Jingsui pacing profile:

`docs/G4_JINGSUI_TIMING_PROFILE.md`

Relationship:

`SemanticShot → 1..N VisualBeats`

A VisualBeat is the closest planning unit to the final one-image shot.

### Timing mode

Before final audio:

`TIMING_MODE = JINGSUI_CALIBRATED_PROVISIONAL`

Use:
- speech planning rate ≈ 5.9 Chinese chars/s;
- ordinary visual beat ≈ 1.3–4.5s;
- median target ≈ 2.7s;
- fast reaction / punchline ≈ 0.8–1.8s;
- explanation / landing may hold 4–8s.

Provisional times are valid for pacing and image-count planning only.

### Split rule

Split a SemanticShot when one of these changes materially:
- action state;
- reaction/expression;
- focal object/UI state;
- joke setup → landing;
- camera/composition needed to preserve rhythm;
- metaphor progression;
- information state.

Do not split solely because a sentence is long.

### Output

Each VisualBeat locks:
- visual_beat_id;
- semantic_shot_id;
- provisional_start/end/duration;
- narration fragment;
- visual state;
- image intent;
- composition/camera;
- continuity relation;
- transition intent;
- acceptance criteria.

### Density Gate

Return when:
- average visual hold is too slow for the intended Jingsui-like surface rhythm without a deliberate reason;
- repeated 4–8s holds dominate;
- multiple distinct actions/reactions are forced into one image;
- dense text cards are used to avoid proper visual decomposition.

Failure:
`RETURN_VISUAL_BEAT_DENSITY_MISMATCH`

---

## 4. G4B — Exact Timeline Compiler

### Preconditions

One of:
- `AUDIO_MODE = UPSTREAM_TTS` and final audio exists;
- `AUDIO_MODE = EXECUTOR_TTS` and executor TTS has been generated and locked.

Final SRT must match locked script.

### Input

- accepted SemanticShotPlan;
- final audio master;
- final SRT;
- Character / Scene / Style locks.

### Output

Final rows conforming to:
- `schemas/shot.schema.json`;
- `docs/LOW_LEVEL_EXECUTION_PACKAGE.md`.

This phase locks:
- exact start;
- exact end;
- exact duration;
- final subtitle;
- image_id;
- final transition;
- prompt-ready visual state.

### Timeline rule

Exact time follows audio.

If audio changes:
`RETURN_TIMELINE_MISMATCH`
and recompile G4B only.

Do NOT redo G4A unless story/visual semantics also changed.

---

## 5. G4 Gate Acceptance

G4 PASS requires:

### G4A1 + G4A2
- script meaning preserved;
- no KnowledgeCore drift;
- shot boundaries follow visual-state changes;
- each shot has a clear visual reason;
- no PPT/explainer regression;
- continuity requirements are explicit;
- Antigravity has no creative decisions left at shot level.

### G4B
- exact timeline is derived from locked audio/SRT;
- every final shot validates against `shot.schema`;
- no timeline overlap/gap error except intentional silence;
- final shot count matches semantic plan unless a documented timing-only split/merge is approved;
- image and transition intent are executable.

Current gate cannot PASS until both phases have evidence.

---

## 6. Recommended Validation Sequence

1. Agent — event-driven / action-reaction heavy.
2. Context & Memory — metaphor-driven / continuity heavy.
3. MCP — interoperability / repeated friction / concept reveal.

Reason:
Agent is the easiest place to prove whether the Director can preserve story energy without turning dialogue into static explanatory cards.

---

## 7. Current Production Principles

- one small shot ≈ one image;
- more images are acceptable when they reduce execution complexity;
- no automatic camera motion;
- no unexplained transitions;
- no visual effect unless specified;
- missing decision = RETURN, not executor improvisation;
- upstream thinking rich, downstream execution dumb.

---

## 8. Current Audio Dependency

`AUDIO_MODE = TBD`

Therefore:
- G4A1 and G4A2 may proceed now;
- G4A2 may use Jingsui-calibrated provisional timing;
- G4B remains the final exact-timing recompile after real audio exists;
- provisional timing must never be mislabeled as final execution timing.