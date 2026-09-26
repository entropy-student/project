# G4 Director Language Rules v0.5 — CANONICAL / G4 PASS

> **Status: CANONICAL / OWNER APPROVED / G4 PASS.**
> Purpose: theory-first Director architecture designed to survive new scripts without structural redesign.
> Promotion evidence: Agent / Context-Memory / MCP known-case validation + one unseen Investigation/Discovery blind case.
> Historical G4 v0.1/v0.3 material remains evidence; v0.5 is the current Director baseline.

## 1. Final six-layer architecture

Locked Script + KnowledgeCore
→ 1. Dramatic Hierarchy Map
→ 2. Episode / Sequence Visual Strategy
→ 3. Visual Intention Map
→ 4. Semantic Shot Design
→ 5. Visual Beat Compilation
→ 6. Production-SRT Visual Mapping & Edit Calibration

Cross-cutting QA: Knowledge integrity / Murch cut priority / eye-trace / continuity / anti-PPT / still-image executability.

## 2. McKee responsibility — corrected

Use Sequence → Scene → Beat, not Beat-only.

Beat:
- smallest action/reaction exchange;
- usually changes behavior, tactic, or immediate response;
- does NOT need to create a major value turn by itself.

Scene:
- chain of beats in more-or-less continuous dramatic action;
- should create a perceptible story/value/state turn.

Sequence:
- groups scenes into a larger dramatic movement;
- carries a stronger cumulative change.

McKee decides what changed dramatically. McKee does not decide camera size, angle, composition, or image duration.

## 3. Episode / Sequence Visual Strategy — new missing layer

Before any shot design, define:
- primary visual engine;
- optional secondary visual engine;
- world / scene system;
- recurring motifs, normally 0–2;
- dominant visual components, normally 1–3;
- sequence-level visual intensity arc;
- image-relation grammar per sequence.

Possible visual engines include:
- ACTION_REACTION
- EVOLVING_METAPHOR
- REPEATED_FRICTION
- INVESTIGATION_DISCOVERY
- RELATIONSHIP_DIALOGUE
- PROCESS_TRANSFORMATION
- CONTRAST_COMPARISON
- OBJECT_LED
- ASSOCIATIVE_MONTAGE
- HYBRID

This list is extensible. A new script should select/configure an engine, not require a new Director pipeline.

Image-relation grammar may be:
- CONTINUITY
- PARALLEL
- MONTAGE
- CONTRAST
- METAPHOR
- INSERT_LED
- CLARIFY

Continuity is therefore not forced onto every sequence.

## 4. Visual Intention Map

For each dramatic beat or tight beat cluster, define one PRIMARY intention and optional SECONDARY intention.

Examples:
- ORIENT
- FOLLOW_ACTION
- READ_REACTION
- NOTICE_OBJECT
- SHARE_POV
- FEEL_RELATION
- SEE_CONSEQUENCE
- EXPERIENCE_REVERSAL
- LAND_PAYOFF
- TRACK_METAPHOR_STATE
- COMPARE_STATES
- BUILD_PATTERN
- CLARIFY_MECHANISM

Camera choices come after intention.

## 5. Semantic Shot Design

A Semantic Shot is one coherent visual strategy serving a dramatic unit and visual intention.

Create a new Semantic Shot when a meaningful change occurs in:
- dramatic action/tactic;
- reaction;
- audience information;
- focal subject/object;
- POV;
- relation/blocking;
- location/world state;
- metaphor state;
- consequence/reversal/payoff;
- image-relation grammar;
- required visual intensity.

Do not cut only for visual variety.

Every Semantic Shot needs:
- dramatic reference;
- visual intention;
- shot function;
- subject priority;
- staging/blocking;
- framing strategy / shot-size progression plan;
- POV strategy;
- composition strategy;
- eye-trace in/out;
- screen direction when continuity applies;
- visual intensity;
- image-relation grammar;
- acceptance criteria.

Shot size follows information need:
- wide/full for geography, relation, scale, body action, world-state change;
- medium for interaction, gesture, task, object handling;
- close for meaningful reaction, decision, subtext;
- insert for causal object/UI/detail state.

## 5A. Viewpoint Grammar

Canonical detail:
`docs/G4_VIEWPOINT_GRAMMAR.md`

POV is chosen from dramatic function, not from scene default.

Core distinction:

> **Should the audience watch the protagonist, or see/do the moment with the protagonist?**

Modes:
- `OBSERVER` — reaction/body/behavior is the story;
- `IP_POV` — audience shares reading/discovery;
- `IP_POV_HANDS` — protagonist's own manual action creates the consequence;
- `OVER_SHOULDER_IP` — preserve protagonist ownership + readable target;
- `OBJECTIVE_INSERT` — causal object/evidence must be isolated clearly;
- `RELATIONAL_OBSERVER` — two-subject relation is the story;
- `HYBRID_OBSERVER_POV` — Semantic Shot strategy; child Beats still choose an actual mode.

Every new Visual Beat should record `pov_reason`.

Rules:
- first-person narration does not force all shots to IP_POV;
- exact hand-owned actions should not default to third-party OBSERVER;
- exact evidence may be IP_POV when discovery matters, or OBJECTIVE_INSERT when proof itself matters;
- POV changes require a story/information reason, never variety alone.

Failures:
- `RETURN_POV_UNMOTIVATED`
- `RETURN_POV_SWITCH_UNMOTIVATED`

## 6. Visual Beat Compilation

Relationship: Semantic Shot → 1..N Visual Beats.

Visual Beat is the image-level still unit.

Each Visual Beat locks the actual:
- local visual intention (may inherit or override Semantic Shot intention);
- shot size;
- POV;
- angle / composition delta;
- focal subject/object state;
- timing relation.

Split only when image-level meaning changes:
- intention/setup → action;
- action → result;
- cause → meaningful reaction;
- joke setup → landing;
- focal object/UI state;
- POV discovery;
- metaphor progression;
- comparison A → B;
- montage accumulation step;
- visual-intensity step.

Common still-image grammar: A intention/setup → B action/change → C result/reaction.

Use only the number of states that add meaning. Do not add images merely to imitate motion.

A spoken list / enumeration does NOT automatically become a montage. If several items can coexist in one coherent image state without changing causality, relation, attention, or payoff, keep one Visual Beat.

Examples:
- three remembered preferences may share one notebook insert;
- “桌子大当然有用 / 多摆几份资料更方便” may share one work-surface state;
- repeated verbal clauses should not force extra images when the visual state is unchanged.

Failure:
`RETURN_MONTAGE_INFLATION`.

A Visual Beat may also be a **reveal setup state**: an image that deliberately withholds the final object/result so the next beat can land the payoff. This is valid only when anticipation itself has narrative/comic meaning.

Example:
`AI finished work → hand begins returning one object → reveal: mouse`.

Do not reveal the punchline object early.

## 7. Production-SRT Visual Mapping & Edit Calibration

Meaning decides the visual unit. The locked Production SRT decides the spoken clock.

Director timing therefore means **visual timing**, not speech-rate estimation.

G4 may decide:
- cut / hold / handoff;
- setup → reveal split;
- reaction timing;
- visual beat density;
- visual anchors;
- whether one spoken span is covered by one or several still states.

G4 may not decide:
- chars-per-second;
- TTS speed;
- Production SRT cue duration;
- routine post-TTS retiming.

Historical Jingsui observations remain useful as aesthetic evidence, not authority.

If visual meaning cannot fit the locked speech timeline:
`RETURN_TIMING_VISUAL_CONFLICT`.

## 8. Murch edit priority

Use as priority order, not numeric scoring:
1. Emotion
2. Story
3. Rhythm
4. Eye-trace
5. 2D screen plane
6. 3D spatial continuity

Higher-order story/emotion may justify lower-order continuity sacrifice.
Do not break continuity without a higher-order reason.

## 9. Bruce Block visual structure

Select normally 1–3 dominant visual components per episode:
- space;
- line/shape;
- tone;
- color;
- movement/implied movement;
- rhythm;
- frame density/scale as project adaptations.

Build a sequence-level intensity arc using contrast/affinity and visual complexity.
Do not vary every component at once.

## 10. Montage / juxtaposition support

Adjacent images may create meaning through comparison, repetition, compression, or contrast.

This matters for still-image storytelling because not every sequence should simulate one continuous live-action space.

Use montage when it better serves:
- time compression;
- repeated pattern;
- comparison;
- associative metaphor;
- conceptual recognition.

## 11. Mechanism visualization priority

Try in order:
1. story consequence;
2. character action / decision / handoff;
3. prop or world-rule behavior;
4. evolving metaphor;
5. POV / object / UI;
6. montage / contrast;
7. minimal explicit diagram.

Diagram is last resort.

## 12. Stable framework vs episode configuration

Stable across scripts:
- six-layer architecture;
- McKee dramatic hierarchy;
- visual intention;
- motivated shot grammar;
- Murch priority;
- visual beat compiler;
- anti-PPT hierarchy;
- timing-last principle.

Episode-specific configuration:
- dramatic sequence shape;
- visual engine;
- locations/world;
- motif;
- dominant visual components;
- intensity arc;
- continuity vs montage grammar;
- beat density;
- timing distribution.

Therefore a new script should normally require new configuration, not a new architecture.

## 13. Duration interaction

Director does not pad to a target duration.

The first three G4 cases landed around 2:30–2:52 under the current timing prior.
Treat that as evidence, not yet a universal duration rule.

Do not add material merely to satisfy the old 3–5 minute guidance.
Duration policy should be re-baselined upstream after more episodes.

## 14. Script Coverage Gate

Every spoken line in the locked Script must be accounted for by the Director plan.

Required:
- Semantic Shot narration spans collectively cover 100% of locked spoken script in order;
- Visual Beat narration bindings collectively cover the same spoken script in order;
- no sentence may disappear merely because it is hard to visualize;
- if a spoken line intentionally shares an existing image, bind it to that beat rather than omitting it.

Allowed omissions:
- document headings;
- metadata;
- non-spoken production notes.

Failure:
`RETURN_SCRIPT_COVERAGE_GAP`.

This Gate exists because the first G4 Memory MVP undercounted script coverage and therefore underestimated duration.

## 15. Validation status

The theory-first Director architecture has already passed:
- Agent;
- Context / Memory;
- MCP;
- one unseen Investigation/Discovery case.

Future revalidation is required only after a material Director-contract change, new visual grammar, or repeated production failure class.

## 16. Final principle

McKee defines dramatic hierarchy.
Visual Strategy gives the episode a coherent visual system.
Visual Intention says what the audience must experience now.
Director grammar decides staging and camera.
Visual Beat turns movement into meaningful still states.
Production SRT supplies the spoken clock; Director grammar decides how justified visual states breathe inside that clock.

## 2026-09-26 story-event production patch

For new story-video production packages, also apply `STORY_EVENT_FRAME_PRODUCTION_PATCH_20260926.md` before locking Visual Beats. Its Owner-approved story-event gate returns Beats that merely illustrate a concept with floating cards, paths, arrows or rule diagrams. Keep the locked script and spoken timing authority unchanged.
