# Visual Frame Design Rules v0.1 — CANDIDATE

## Status

`CANDIDATE / RESEARCH-BACKED / NOT_YET_CANONICAL`

Purpose:
define how one generated frame should be composed so that it is:
- narratively necessary;
- visually legible;
- attention-efficient;
- stable for AI generation;
- consistent across a still-image video.

This sits downstream of G4 Visual Beat and upstream of final G5C prompt execution.

---

## 1. Source Roles

### McKee — dramatic necessity
Use for:
- desire;
- action;
- conflict;
- turning point;
- setup/payoff;
- change.

McKee determines:
> what must change / be understood in this beat.

McKee does NOT provide a complete shot-composition system.

### Bruce Block — visual structure
Use:
- space;
- line;
- shape;
- tone;
- color;
- movement;
- rhythm;
- contrast / affinity.

Rule:
visual intensity should be intentionally related to story intensity.

### Walter Murch — priority and eye-trace
Adapted priority:
1. emotion;
2. story;
3. rhythm;
4. eye-trace;
5. two-dimensional screen logic;
6. three-dimensional continuity.

For still-image production:
story/emotion may justify breaking lower-level spatial continuity, but not vice versa.

### Multimedia / attention research
Use:
- coherence;
- signaling;
- split-attention;
- redundancy;
- spatial contiguity.

Operational meaning:
remove non-causal material; guide attention; do not force viewers to mentally integrate many distant information sources.

---

## 2. Core Definition of a Good Frame

A good frame has:

> **one dramatic job, one primary focal point, one clear attention path, and no element that competes without narrative reason.**

Viewer test:

1. What should the viewer notice first?
2. What should they notice second, if anything?
3. What changed from the previous beat?
4. Which element could be removed without losing meaning?

If Q1 has multiple competing answers, simplify.
If Q4 identifies decorative elements, remove or suppress them.

---

## 3. One-Beat / One-Job Rule

Each Visual Beat receives one primary job:

- REACTION
- ACTION
- REVEAL
- EVIDENCE
- COMPARISON
- ORIENTATION
- PAYOFF
- TRANSITION / SETUP

A frame may contain several objects, but only one primary narrative job.

Failure:
`RETURN_FRAME_MULTI_JOB_OVERLOAD`

---

## 4. Focal Hierarchy

Default hierarchy:

```text
PRIMARY FOCUS
→ optional SECONDARY SUPPORT
→ LOW-CONTRAST WORLD ANCHORS
```

### Primary Focus
Exactly one dominant point of attention.

Examples:
- IP face;
- mouse being returned;
- policy sentence;
- notebook;
- empty desk;
- department door handle.

### Secondary Support
0–1 secondary narrative element by default.

It must clarify the primary focus, not create another equal story.

### Background
Only:
- spatial anchors;
- identity/world anchors;
- causally necessary props.

Background should usually have lower:
- contrast;
- detail;
- saturation;
- text density.

Failure:
`RETURN_COMPETING_FOCAL_POINTS`

---

## 5. Information Budget

Do not count raw objects mechanically.
Count **meaningful attention targets**.

Default target:
- 1 primary target;
- 0–1 secondary target;
- stable low-salience background anchors.

If a frame requires 3+ equally important targets, first attempt:
1. sequential Visual Beats;
2. matched comparison;
3. tighter crop;
4. remove non-causal material.

Only keep 3+ important targets when simultaneity itself is the story.

Failure:
`RETURN_INFORMATION_DENSITY_HIGH`

---

## 6. Frame Archetypes

### A. HUMAN_REACTION
Use when emotional/cognitive change is the story.

Frame:
- face/body is primary;
- causal object may remain partially visible;
- no floating explanatory cards.

### B. HUMAN_ACTION
Use when a concrete action changes state.

Frame:
- actor + one action object;
- action line immediately legible;
- remove unrelated UI.

### C. OBJECT_INSERT
Use when object identity/state is causal.

Frame:
- object dominates;
- minimal surrounding context;
- no character unless reaction/action is also required.

### D. EVIDENCE_UI
Use when exact evidence wording/state is causal.

Frame:
- one stable UI/document master;
- one highlighted causal region;
- exact text via POST_OVERLAY where needed;
- no fake browser clutter.

### E. TWO-WAY_COMPARISON
Use only when comparison itself is the beat.

Frame:
- exactly two comparable states/objects;
- balanced or deliberately weighted;
- no third competing panel.

### F. ESTABLISHING_WORLD
Use to orient space/state.

Frame:
- show only anchors needed to understand later action;
- no exposition wall of labels.

### G. SETUP_REVEAL
Setup:
- preserve composition;
- withhold final information.

Reveal:
- same or matched composition;
- new focal information enters cleanly.

---

## 7. Text Rule

Audio narration is primary.

Do not repeat narration as on-screen text by default.

Allow visible text when:
1. exact wording is evidence;
2. a label is needed to distinguish causal objects;
3. a document/UI state is itself the plot;
4. a short title/number is necessary for orientation.

Operational default:
- one focal text region;
- preferably one key phrase;
- avoid long paragraphs;
- long exact text = POST_OVERLAY, not native generation.

Failure:
- `RETURN_TEXT_REDUNDANCY`
- `RETURN_TEXT_DENSITY_HIGH`

---

## 8. Brand / Logo Rule

Default:
`GENERIC_FICTIONAL_BRANDING`

Do NOT allow the image model to invent:
- OpenAI;
- ChatGPT;
- Alipay;
- Taobao;
- other real brands/logos;

unless the real brand is causally necessary to the episode and explicitly approved upstream.

If the story only needs:
- “AI answer”;
- “official help center”;
- “payment platform”;
use a stable fictional/generic system.

Reason:
real/invented brand marks create distraction, factual confusion and unnecessary visual targets.

Failure:
`RETURN_UNAUTHORIZED_BRAND_INSERTION`

---

## 9. Speech Bubble / Floating Card Rule

Default:
`DO_NOT_ADD`

Do not add:
- thought bubbles;
- speech balloons;
- floating checklist cards;
- explanatory arrows;
- badges;
- decorative UI cards;

unless G4 explicitly says that visual form is causal.

Narration should not be converted into bubbles merely because the generator can draw them.

Failure:
`RETURN_PRESENTATION_LAYER_INFLATION`

---

## 10. Eye-Trace Rule

Every Beat should declare:

- `attention_entry`
- `primary_focus`
- `attention_exit`

Adjacent beats should intentionally choose one of:

### HOLD
same focal region, state changes.

### HANDOFF
eye moves from A to B.

### RESET
new scene/cut places new primary element in an immediately discoverable position.

### WITHHOLD → REVEAL
eye path is preserved but information changes.

Avoid accidental jumps caused by random layout changes.

Failure:
`RETURN_EYE_TRACE_BREAK`

---

## 11. Contrast / Affinity Rule

Contrast increases visual intensity.
Affinity reduces visual intensity.

Do NOT maximize contrast in every frame.

Use:
- exposition / explanation → higher affinity;
- conflict / surprise → controlled increase in contrast;
- reveal / climax → strongest relevant contrast;
- resolution → reduce visual intensity.

Only 1–2 visual components should usually carry the intensity shift:
- scale;
- tone;
- color;
- space;
- line/shape;
- movement relation;
- rhythm.

Failure:
`RETURN_VISUAL_INTENSITY_UNMOTIVATED`

---

## 12. Density Rule

Default production frame:
`RAREFIED_TO_MEDIUM`

Dense composition is allowed only when density itself expresses:
- overload;
- chaos;
- accumulation;
- crowding;
- pressure.

Examples:
Memory desk overflow = dense on purpose.
Search evidence reveal = sparse on purpose.

Never use density merely to make a frame feel “rich”.

---

## 13. Background Rule

Recurring background has two jobs:
1. establish world continuity;
2. support current beat.

Use stable anchors.

Every extra background object must answer:
> Does this help orientation, character identity, or this beat?

If no:
- remove;
- simplify;
- lower contrast/detail.

---

## 14. UI / Document Rule

A generated UI/document should have:

- stable layout ID;
- stable geometry;
- minimal chrome;
- minimal non-causal navigation;
- no random brand names;
- one causal state per beat.

Use crop progression:
```text
full context
→ relevant region
→ causal evidence
```

Do not show entire realistic web pages when one sentence is the beat.

---

## 15. Comparison Rule

Comparison is powerful but easy to turn into PPT.

Allowed:
- two real story states;
- before/after;
- answer/source;
- character/object relationship.

Avoid:
- four-card grids;
- checklist dashboards;
- decorative “VS” graphics;
- multi-column educational posters.

If comparison needs labels, keep labels short and subordinate.

---

## 16. Reveal Rule

A reveal must own its own visual state when its identity/information is the payoff.

Setup must not leak:
- object identity;
- final sentence;
- result;
- punchline.

Prefer:
```text
setup
→ anticipation
→ reveal
→ reaction
```

Not every reveal needs all four beats.

---

## 17. Composition Rule

No universal rule-of-thirds mandate.

Composition follows story function.

Default choices:

### Center / near-center
use when:
- one object must be found immediately;
- a reveal must be unmistakable;
- a new scene must rapidly orient attention.

### Off-center / negative space
use when:
- another subject/object will enter;
- absence itself has meaning;
- gaze direction needs room;
- tension/imbalance is intentional.

### Balanced
use when two states have equal comparison weight.

### Weighted / unbalanced
use when one side should dominate.

---

## 18. Shot Scale Rule

### Wide
use to understand:
- world;
- spatial relation;
- scale;
- accumulation.

### Medium
default for:
- action;
- object interaction;
- two-subject relation.

### Close
use when:
- reaction is the turn;
- fine object detail is causal.

### Insert
use only when:
- exact object/evidence identity changes story.

Do not use close/insert merely for variety.

---

## 19. AI Generation Stability Rule

Stable generation prefers:
- fewer salient elements;
- repeated scene masters;
- repeated costume;
- repeated prop geometry;
- low background entropy;
- explicit exclusions;
- one state delta per continuity beat.

Prompt should describe:
> what changes now

while canonical refs carry:
> what must stay the same.

---

## 20. Frame QA — 10 Questions

Before accepting a frame:

1. What is the one dramatic job?
2. What is the first focal point?
3. Is there more than one equal competitor?
4. Does the viewer need every visible object?
5. Does visible text add information not already supplied by narration?
6. Are any brand/logo elements unnecessary?
7. Does the composition support the emotional/story intensity?
8. Does eye-trace connect to adjacent beats?
9. Is the background quieter than the causal foreground?
10. Could this frame be simplified by 20% without losing meaning?

If #10 = yes:
simplify first.

---

## 21. Hard Defaults for Current Project

```text
ONE_PRIMARY_FOCUS = YES
SECONDARY_FOCUS_MAX = 1 by default
UNAUTHORIZED_REAL_BRANDS = 0
SPEECH_BUBBLES = OFF
FLOATING_INFO_CARDS = OFF
TEXT_NATIVE_LONG_FORM = OFF
TEXT_RENDER_MODE = POST_OVERLAY when exact
BACKGROUND_DETAIL = LOW_TO_MEDIUM
FRAME_DENSITY = RAREFIED_TO_MEDIUM
VISUAL_CHANGE_PER_CONTINUITY_BEAT = ONE_MAIN_DELTA
```

---

## 22. Validation Plan

Before canonical promotion:

Recompile the Search pilot using these rules.

Required comparison:
- old VB001 / new VB001;
- old VB009 / new VB009;
- old VB012 / new VB012;
- old VB015 / new VB015;
- old VB016 / new VB016;
- old VB022 / new VB022;
- old VB025 / new VB025;
- old VB044 / new VB044.

Pass if:
- attention target is faster to identify;
- brand/logo noise disappears;
- UI/card clutter decreases;
- story meaning remains equal or stronger;
- continuity becomes easier to generate;
- character/world identity remains recognisable.

Do not promote based only on visual taste.
