# G4 Director Language Rules v0.2 — CANDIDATE / OWNER REVIEW

> Status: CANDIDATE ONLY.  
> Purpose: rebuild the Director / Shot Compiler from theory-first rules before re-running validation cases.  
> This document does NOT supersede the accepted G4 v0.1 artifacts until Owner approval + fresh case validation.

---

## 0. Why This Rebaseline Exists

G4 v0.1 proved that three scripts could be converted into coherent Shotbooks.

But its rule system was partly inferred from the same cases it validated.

That is acceptable for MVP discovery, but insufficient for a reusable Director Compiler.

The missing middle layer was:

> **Dramatic change → audience attention/emotion → camera/staging/composition choice.**

The rebaseline therefore separates five different decisions that were previously partially collapsed.

---

# 1. Source Responsibility Map

No single reference owns the whole Director system.

## 1.1 McKee — Dramatic structure / behavior change

Use for:
- Beat as changing action/reaction behavior;
- conflict and Gap;
- scene turn;
- meaningful state/value change;
- progressive complication;
- turning point;
- recognition / choice / payoff.

McKee answers:

> **When has the story meaningfully changed?**

McKee does NOT decide:
- shot size;
- camera angle;
- composition;
- edit timing;
- how many still images to generate.

---

## 1.2 Walter Murch — Cut priority

Use as the priority order when deciding whether a cut is worth making.

Priority:
1. Emotion
2. Story
3. Rhythm
4. Eye-trace / point of attention
5. 2D screen plane
6. 3D spatial continuity

Project adaptation:

> **Never preserve lower-level continuity by sacrificing a stronger emotional/story cut.  
> But never break continuity randomly when emotion/story/rhythm do not require it.**

Murch answers:

> **Why should the audience leave this image now?**

---

## 1.3 Katz / Rabiger — Director screen grammar

Use for:
- blocking;
- staging;
- framing;
- shot size;
- camera angle;
- POV;
- screen direction;
- spatial continuity;
- coverage;
- visualizing a scene before production.

They answer:

> **Where should the viewer be placed to understand this dramatic moment?**

---

## 1.4 Bruce Block — Visual structure

Use for:
- space;
- line;
- shape;
- tone;
- color;
- movement;
- rhythm;
- contrast vs affinity;
- visual intensity progression.

Block answers:

> **How should the visual world become more or less intense as the story changes?**

---

## 1.5 Jingsui Calibration — Surface rhythm only

Use for:
- spoken-rate reference;
- visual-beat density;
- hold duration;
- reaction/punchline timing;
- limited-animation / still-image pacing.

Current calibration:
- speech planning rate ≈ 5.9 Chinese chars/s;
- visual beat median ≈ 2.7s;
- ordinary ≈ 1.3–4.5s;
- fast reaction/punchline ≈ 0.8–1.8s;
- landing/explanation may hold 4–8s.

Jingsui answers:

> **How long can this still-image beat remain before the surface rhythm becomes slow?**

It does NOT decide the dramatic beat or shot meaning.

---

# 2. Canonical Director Pipeline

New candidate pipeline:

```text
Locked Script + KnowledgeCore
→ Dramatic Beat Map
→ Visual Intention Map
→ Semantic Shot Plan
→ Visual Beat Shotbook
→ Timing Calibration
```

The key correction is:

> **Do not jump directly from sentence → image.**

---

# 3. Layer 1 — Dramatic Beat Map

## 3.1 Definition

A Dramatic Beat is the smallest meaningful exchange/change in behavior.

Project form:

```text
someone wants / expects something
→ acts or communicates
→ world / AI / another person responds
→ behavior or understanding changes
```

A new Dramatic Beat begins when behavior meaningfully changes.

Not when:
- punctuation changes;
- a sentence ends;
- a new noun appears;
- the narrator takes a breath.

## 3.2 Required Beat fields

Every meaningful segment should identify:
- actor;
- current desire / intention;
- action;
- response / counter-action;
- expectation;
- actual result;
- state change;
- next pressure.

## 3.3 Beat Gate

If nothing changes in:
- behavior;
- knowledge;
- option;
- relationship;
- control;
- stakes;
- strategy;
- meaningful emotion;

then it is probably:
- exposition to merge;
- repetition to compress;
- or narration that does not need a new visual event.

Failure:
`RETURN_NO_DRAMATIC_CHANGE`.

---

# 4. Layer 2 — Visual Intention Map

Before choosing a shot, answer:

> **At this exact moment, what must the audience NOTICE, UNDERSTAND, or FEEL?**

Only one primary intention per visual beat.

Allowed primary intentions:

- ORIENT — understand where / who / relation;
- FOLLOW_ACTION — understand what someone is doing;
- READ_REACTION — understand changed internal state;
- NOTICE_OBJECT — notice a causally important object/UI state;
- SHARE_POV — discover something from a character's perspective;
- FEEL_RELATION — understand distance, power, alignment, isolation;
- SEE_CONSEQUENCE — see the result of an action;
- EXPERIENCE_REVERSAL — feel the expectation-result Gap;
- LAND_PAYOFF — hold the joke / insight / emotional result;
- TRACK_METAPHOR_STATE — see a recurring metaphor/world rule change;
- CLARIFY_MECHANISM — only when story action alone cannot keep the mechanism accurate.

Rule:

> **Camera choices are downstream of Visual Intention.**

Do not choose “close-up” because close-ups look cinematic.
Choose it because the audience now needs to read a reaction/detail.

Failure:
`RETURN_CAMERA_CHOICE_UNMOTIVATED`.

---

# 5. Layer 3 — Semantic Shot

## 5.1 Definition

A Semantic Shot is one coherent visual strategy serving one dramatic/visual intention.

One Semantic Shot may contain:
- one Dramatic Beat;
- or several tightly connected Dramatic Beats if the same staging/viewpoint should continue.

New Semantic Shot when one of these materially changes:

1. dramatic action;
2. response/reaction;
3. audience information;
4. point of view;
5. spatial relation;
6. focal subject/object;
7. metaphor/world state;
8. story consequence;
9. reversal/payoff;
10. required visual-intensity state.

Do NOT create a new Semantic Shot solely for visual variety.

Failure:
`RETURN_CUT_FOR_VARIETY_ONLY`.

---

# 6. Shot Function Taxonomy

Every Semantic Shot must have one primary function.

## ESTABLISH
Show geography, relationship, scale, or a new world state.

## ACTION
Show an intentional behavior that moves the story.

## REACTION
Show a changed internal/behavioral state caused by what just happened.

## RELATION
Show spatial/social relationship between people or person-system.

## POV / DISCOVERY
Let the audience notice information from a character's position.

## INSERT / OBJECT STATE
Show an object, UI, document, prop, money state, status, etc. when that object itself changes the story.

## REVEAL
Expose previously hidden or newly important information.

## REVERSAL
Make the expectation-result Gap perceptible.

## METAPHOR STATE
Advance a recurring visual metaphor that itself carries causal meaning.

## PAYOFF
Land a joke, recognition, decision, emotional result, or controlling idea.

## TRANSITION
Move time/place/state only when the transition itself is useful.

## CLARIFY
Rare. Clarify a mechanism that cannot remain accurate through character/world action alone.

Rule:
Decorative beauty is not a Shot Function.

Failure:
`RETURN_SHOT_WITHOUT_FUNCTION`.

---

# 7. Shot Size Selection

Shot size is selected by information need.

## Wide / Full

Prefer when audience must understand:
- geography;
- body action;
- multiple characters' positions;
- relation to environment;
- scale;
- isolation/crowding;
- a changed world state.

## Medium

Prefer when audience needs:
- interaction;
- gesture;
- task performance;
- object handling;
- two-person exchange;
- body language + enough environment.

This is the default working shot for much of the channel.

## Close-up

Prefer when:
- reaction changes story meaning;
- a decision becomes visible;
- subtext matters;
- one face/detail now outranks geography.

Do not use close-up simply to “increase emotion”.

## Extreme close / Insert

Prefer when:
- one detail/object/status is the dramatic event.

Examples:
- refund completed;
- a hand stops before confirmation;
- one note disappears;
- one door handle is incompatible.

## Shot-size progression

May move:
`wide → medium → close`
as story attention narrows or intensity rises.

May move back wider when:
- geography changes;
- relation changes;
- consequence must be seen in context;
- resolution needs space.

This is a tendency, not a template.

---

# 8. Point of View / Camera Angle

## Eye-level default

Use neutral eye-level unless another angle has a dramatic reason.

## OTS / two-shot

Use when:
- relationship / exchange matters;
- who is confronting whom matters;
- cause and reaction should coexist spatially.

## POV

Use when:
- audience should discover information with the character;
- misunderstanding depends on what the character can currently see.

## High / low angle

Use only when the change in:
- power;
- vulnerability;
- control;
- psychological relationship

is important enough to motivate it.

Do not alternate angles randomly to avoid boredom.

Failure:
`RETURN_RANDOM_CAMERA_LANGUAGE`.

---

# 9. Blocking / Staging Rules

Position and movement are story language.

Character movement should express:
- approach / avoidance;
- control / loss of control;
- desire;
- hesitation;
- interruption;
- handoff;
- separation;
- alliance;
- status change.

For still-image video, convert movement into meaningful key states:

```text
A — intention / preparation
B — action
C — result / reaction
```

Do not generate three images if A/B/C do not change meaning.

Prefer actor/object movement over arbitrary camera movement when both can communicate the same change.

---

# 10. Reaction Shot Rule

Reaction shots are not punctuation.

Create a Reaction Beat only when the reaction:
- reveals new information;
- changes strategy;
- exposes subtext;
- changes relationship;
- changes audience interpretation;
- creates comic/emotional timing.

If the reaction merely repeats what narration already said, remove it.

Rule:

> **Cause → meaningful reaction → next choice**

not:

> every line → face → every line → face.

Failure:
`RETURN_REACTION_REDUNDANT`.

---

# 11. Object / UI / Text Insert Rule

Use an insert only when the object state itself is a Story Event.

Valid:
- system status changes to completed refund;
- a notebook persists into a new task;
- a service placard makes a capability discoverable;
- a mouse is physically returned.

Invalid:
- screenshotting every sentence of narration;
- displaying paragraphs because they are difficult to visualize;
- replacing action with a list.

Text inside the image should be the minimum necessary to understand the event.

Failure:
`RETURN_INSERT_NOT_CAUSAL`.

---

# 12. Spatial Continuity

Maintain a stable spatial model when space matters.

Track:
- character side of frame;
- facing direction;
- eyeline;
- relative positions;
- important props;
- entrances/exits;
- scene axis;
- recurring scene geometry.

Default:
preserve screen direction and eye-trace between adjacent shots.

But use Murch priority:

> Emotion / Story / Rhythm may justify violating lower-level spatial continuity.

If continuity is broken without a higher-level reason:
`RETURN_SPATIAL_CONTINUITY_DRIFT`.

---

# 13. Eye-trace / Point-of-attention

Before a cut identify:
- where is the viewer looking now?
- where should the viewer look immediately after the cut?

Prefer:
- matching or intentionally guiding focal position;
- object/action continuity;
- gaze direction that pulls attention toward the next focal point.

Avoid:
- random subject jumping left/right every image;
- requiring the eye to search the full frame after every cut.

For still-image sequences, eye-trace is especially important because there is less continuous motion to guide attention.

---

# 14. Visual Structure — Bruce Block Adaptation

Each episode should choose **1–2 dominant visual variables** to carry the story arc.

Candidate variables:
- spatial depth;
- open vs closed space;
- frame density / clutter;
- scale;
- line direction;
- shape affinity/contrast;
- tone;
- color;
- implied movement;
- edit rhythm.

Do not try to dramatically vary all components at once.

## Contrast / Affinity principle

Use greater visual contrast when story intensity meaningfully rises.

Use greater affinity/simplicity when:
- story relaxes;
- recognition becomes clear;
- resolution lands.

This can happen through:
- more/less clutter;
- wider/narrower space;
- more/less tonal contrast;
- more/less directional conflict;
- faster/slower visual rhythm.

Rule:

> **Visual intensity should have an arc, not stay flat for the whole episode.**

Failure:
`RETURN_VISUAL_INTENSITY_FLAT`.

---

# 15. Visual Motif / World-rule Progression

A recurring metaphor or prop must change state with the story.

Good:
```text
normal state
→ pressured state
→ broken/overloaded state
→ transformed understanding
→ payoff state
```

Bad:
- same symbol repeated with different captions;
- a metaphor introduced once and abandoned;
- every clever sentence becomes a new unrelated metaphor.

The visual motif must either:
- carry causality;
- carry continuity;
- or carry payoff.

Otherwise remove it.

Failure:
`RETURN_METAPHOR_DECORATIVE`.

---

# 16. Mechanism Visualization Priority

When translating an AI mechanism, try in this order:

1. **Consequence in the story**
2. **Character action / handoff / decision**
3. **Prop or world-rule behavior**
4. **Recurring metaphor with causal progression**
5. **POV / object / UI insert**
6. **Minimal diagram / explicit explanatory frame**

Diagram is last resort.

A diagram is allowed only when:
- accuracy would otherwise be lost;
- story action cannot make the distinction clear;
- it is brief;
- it does not replace the surrounding story.

Failure:
`RETURN_DIRECTOR_BECAME_EXPLAINER`.

---

# 17. Limited-animation / Still-image Grammar

Current production is not live-action cinema.

Therefore adapt film grammar to still-image states.

## Default motion strategy

Prefer:
```text
pose/state A
→ pose/state B
→ reaction/result C
```

over:
- complex generated animation;
- arbitrary pan/zoom;
- one static image held through multiple state changes.

## Camera motion

Default:
NO camera motion.

Allow only when:
- spatial reveal requires it;
- visual attention must deliberately travel;
- the move itself has narrative meaning.

Do not add pan/zoom merely to make stills feel alive.

---

# 18. Cut Decision — Murch Adaptation

Before every cut ask in this order:

### 1. Emotion
Does staying/cutting preserve the emotion/subtext we want?

### 2. Story
Does the cut reveal a new action, consequence, discovery, reaction, or decision?

### 3. Rhythm
Is the current image finished rhythmically?

### 4. Eye-trace
Can the eye find the next focal subject immediately?

### 5. Screen plane
Does the composition change read cleanly?

### 6. Spatial continuity
Will the audience still understand where things are?

Cut when higher-order reasons justify it.

Do NOT cut because:
- 2.7 seconds elapsed;
- a sentence ended;
- “we need visual variety”.

---

# 19. Visual Beat Compiler

After Semantic Shots are correct, split each into 1..N Visual Beats.

Split only if at least one changes:

- action phase;
- reaction/expression;
- focal object;
- POV;
- composition needed for story emphasis;
- metaphor state;
- information state;
- punchline setup → landing.

This is the image-level unit.

Rule:

> **Story logic decides the Semantic Shot.  
> Attention + rhythm decide the Visual Beat.**

---

# 20. Timing Calibration

Timing happens **after** story/visual decisions.

Current reference:
- speech ≈ 5.9 Chinese chars/s;
- median visual beat ≈ 2.7s.

Use the distribution, not a metronome.

### Fast
0.8–1.8s
- quick reaction;
- joke landing;
- fast insert;
- escalation chain.

### Normal
1.8–3.5s
- ordinary action;
- dialogue exchange;
- simple object state.

### Long
3.5–5.0s
- complete micro-scene;
- important spatial read;
- slower recognition.

### Exceptional hold
5–8s
- climax result;
- mechanism clarification;
- final meaning;
- silence with genuine state change.

Failure:
`RETURN_RHYTHM_OVERRIDES_MEANING`.

---

# 21. Sequence-level Density Curve

Do not keep one visual density for the entire episode.

Candidate default:

### Hook
medium-high density
- establish human problem fast.

### Story development
medium density
- let actions read.

### Complication / riff
locally higher density
- reaction/object/action progression.

### Recognition / mechanism reveal
medium-low density
- fewer but stronger images.

### Final payoff
lower density
- let result / final action land.

This is a default curve, not a quota.

---

# 22. Coverage / Variety Rule

Visual variety must come from changed dramatic needs, not from random camera rotation.

Preferred sources of variety:
- blocking;
- changed focal object;
- reaction;
- POV;
- spatial relation;
- foreground/background state;
- shot size motivated by attention;
- changed visual intensity.

Bad variety:
```text
front medium
→ side medium
→ other side medium
→ high-angle medium
```
with no story reason.

Failure:
`RETURN_VARIETY_WITHOUT_MEANING`.

---

# 23. Anti-PPT Gate

Return if:
- narration becomes labels + arrows;
- characters vanish for long mechanism sections without necessity;
- every sentence becomes a card;
- UI text becomes the primary visual layer;
- diagrams explain what character action already proves;
- visuals merely duplicate narration.

Ask:

> **Can a person, object, spatial relation, reaction, or consequence carry this information instead?**

If YES, prefer it.

---

# 24. Director Decision Algorithm

For every script segment:

### Step 1 — Dramatic analysis
What changes in behavior/state/value?

### Step 2 — Visual intention
What must audience notice/feel/understand?

### Step 3 — Shot function
ESTABLISH / ACTION / REACTION / RELATION / POV / INSERT / REVEAL / REVERSAL / METAPHOR / PAYOFF / TRANSITION / CLARIFY

### Step 4 — Staging
Who is where? What do they want? Who moves? What object changes hands/state?

### Step 5 — Camera
What shot size / POV / angle is necessary for the Visual Intention?

### Step 6 — Visual structure
What should happen to space/density/tone/line/rhythm at this point in the story?

### Step 7 — Semantic Shot boundary
Can the current visual strategy continue, or has the dramatic/visual intention changed?

### Step 8 — Visual Beat expansion
Does this Semantic Shot need setup/action/reaction/object/payoff states?

### Step 9 — Timing
Apply calibrated Jingsui-like rhythm.

### Step 10 — Continuity QA
Emotion → Story → Rhythm → Eye-trace → Plane → Space.

---

# 25. Required Shotbook Fields — Candidate

Each Semantic Shot should now add:

- dramatic_beat_id(s);
- dramatic_action;
- dramatic_response;
- state_change;
- visual_intention;
- shot_function;
- subject_priority;
- shot_size;
- pov_mode;
- blocking;
- screen_direction;
- eye_trace_target;
- visual_intensity;
- dominant_visual_component(s);

Existing:
- character_ids;
- scene_id;
- action;
- expression;
- composition;
- camera_angle;
- image_intent;
- continuity_role;
- transition_intent;
- forbidden visuals;
- acceptance criteria.

This is intentionally richer than G4 v0.1.

---

# 26. Director QA Gate

Every Semantic Shot must answer YES:

1. What Dramatic Beat does it serve?
2. What changed from the previous story state?
3. What is the primary Visual Intention?
4. Why does this shot exist?
5. Why this subject?
6. Why this shot size?
7. Why this point of view/angle?
8. What is the blocking/story action?
9. Where should the eye look?
10. Does it preserve or intentionally change spatial continuity?
11. Does visual intensity fit the story intensity?
12. Would removing this shot damage story, emotion, clarity, or rhythm?

If Q12 = NO:
merge/delete.

---

# 27. Failure Codes

- `RETURN_NO_DRAMATIC_CHANGE`
- `RETURN_CAMERA_CHOICE_UNMOTIVATED`
- `RETURN_SHOT_WITHOUT_FUNCTION`
- `RETURN_CUT_FOR_VARIETY_ONLY`
- `RETURN_RANDOM_CAMERA_LANGUAGE`
- `RETURN_REACTION_REDUNDANT`
- `RETURN_INSERT_NOT_CAUSAL`
- `RETURN_SPATIAL_CONTINUITY_DRIFT`
- `RETURN_VISUAL_INTENSITY_FLAT`
- `RETURN_METAPHOR_DECORATIVE`
- `RETURN_DIRECTOR_BECAME_EXPLAINER`
- `RETURN_RHYTHM_OVERRIDES_MEANING`
- `RETURN_VARIETY_WITHOUT_MEANING`

---

# 28. What This Candidate Changes From G4 v0.1

Old:
```text
Script
→ Semantic Shot
→ Visual Beat
→ Jingsui timing
```

Candidate:
```text
Script
→ Dramatic Beat Map
→ Visual Intention Map
→ Semantic Shot
→ Visual Beat
→ Timing
```

Main correction:

> **Jingsui no longer contributes to why a shot exists.  
> It only calibrates how the already-justified visual beat breathes on screen.**

McKee contributes story-change logic.

Murch contributes cut priority.

Katz / Rabiger contribute shot/staging/spatial grammar.

Bruce Block contributes visual-intensity structure.

The Showrunner combines them for still-image story video.

---

# 29. Validation Plan — DO NOT RUN YET

After Owner approves this candidate:

1. Freeze this rule set.
2. Re-run Agent from locked script **from scratch**.
3. Compare with old G4 output.
4. Record what changed and whether the new rules improve motivated framing/staging.
5. Re-run Context / Memory from scratch.
6. Re-run MCP from scratch.
7. Only then decide:
   - promote this contract;
   - revise it;
   - or return specific rules.

Do not patch old Shotbooks and call that validation.

The cases must test the rules, not define them.
