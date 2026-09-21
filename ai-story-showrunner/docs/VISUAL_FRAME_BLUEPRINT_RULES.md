# Visual Frame Blueprint Rules v0.4 — CANONICAL

## Status

`CANONICAL / OWNER APPROVED / G5`

Purpose:
compile an accepted G4 Visual Beat into a clear, attention-efficient, generation-stable single-frame plan before asset binding and prompt execution.

Core principle:

> **故事决定该看什么；Frame Blueprint 决定观众怎样第一眼就看到它。**

> **丰富来自状态推进，不来自单帧堆料。**

## 1. Boundary

Frame Blueprint is NOT a seventh G4 layer.

G4 locks:
- dramatic meaning;
- visual intention;
- shot size;
- POV;
- timing;
- image relation.

Frame Blueprint compiles:
- primary/secondary focus;
- layout;
- attention path;
- density;
- text/brand policy;
- continuity preserve;
- one main delta;
- withheld information.

If Blueprint conflicts with G4:
`RETURN_FRAME_BLUEPRINT_CONFLICTS_G4`.

## 2. Theory roles

### McKee
Use for dramatic necessity:
desire / action / conflict / turn / setup-payoff / state-value change.

### Bruce Block
Use for visual structure:
space / line / shape / tone / color / movement / rhythm / contrast / affinity.

### Murch
Priority:
emotion → story → rhythm → eye-trace → 2D plane → 3D continuity.

### Multimedia / attention research
Use for coherence, signaling, redundancy, spatial contiguity and split-attention reduction.
Do not treat learning/comprehension evidence as proof of platform growth.

## 3. Good Frame

A good frame has:
- one dominant dramatic job;
- a clear visual subject;
- a predictable attention path;
- minimum necessary information.

Required questions:
1. What is the Dramatic Job?
2. What is P1?
3. What supports P1?
4. What changed from the previous Beat?
5. What can be removed without losing meaning?

## 4. Focus Modes

### SINGLE — default
P1 = 1
P2 = 0–1
Background = low salience.

### DUAL
Only when the relation/comparison itself is the Beat.
Exactly two primary targets.
No third equal competitor.

### FIELD
Only when multiplicity/density itself is the story:
overload / accumulation / crowding / chaos / group-state.
Requires `density_reason`.

## 5. Frame Archetypes

- CHARACTER_REACTION
- CHARACTER_ACTION
- RELATIONAL_TWO_SUBJECT
- OBJECT_EVIDENCE_INSERT
- WORLD_STATE
- DUAL_COMPARE
- MATCHED_SETUP_REVEAL

Archetype implements G4 intent; it does not replace it.

## 6. Salience / Dominance

Primary focus must win through one or more:
- scale;
- tone/value;
- color;
- isolation;
- sharpness/detail;
- gaze/gesture;
- directional line;
- centrality/framing.

P2 must support P1.
If P2 competes:
`RETURN_COMPETING_FOCAL_POINTS`.

## 7. Diegetic-first

Preferred order:

```text
character action/reaction
> story prop
> diegetic UI/document
> minimal overlay
> standalone infographic
```

If the story can show it, do not explain it first.

## 8. Composition Modes

- CENTER_NEAR_CENTER
- OFF_CENTER_GAZE_SPACE
- BALANCED_DUAL
- WEIGHTED_DUAL
- DEPTH_LAYERED
- CALLBACK_MATCH

No universal rule-of-thirds mandate.

## 9. Attention Path

Required:
- `attention_entry`
- `primary_focus`
- `attention_exit`
- `transition_mode`

Transition modes:
- HOLD
- HANDOFF
- RESET
- WITHHOLD_REVEAL
- INTENTIONAL_BREAK

Attention zones:
```text
LU | CU | RU
LM | CM | RM
LL | CL | RL
```

## 10. Caption / Text / Evidence

### Caption Layer
Separate global video layer.
Bottom ~15% is treated as a production caption-safe heuristic.

### Diegetic Text
Only when causal.
Exact wording:
`POST_OVERLAY`.

### Explanatory Overlay
Default:
`OFF`.

Default forbidden:
- speech bubble;
- thought bubble;
- floating card;
- checklist;
- decorative arrow;
- narration duplicated as large text.

## 11. Brand Policy

Default:
`BRAND_MODE = NONE`.

Use `REAL_CAUSAL` only when brand identity itself is causal and verified.
Use `REAL_CONTEXT` only when necessary context exists and keep it low salience.

Generic labels such as “Official Source” are allowed only when needed.
Do not invent brands merely to make UI look realistic.

## 12. UI / Document Grammar

Use progressive disclosure:

```text
CONTEXT
→ REGION
→ EVIDENCE
```

UI master locks shell geometry.
Beat changes only causal content/highlight/cursor/selection.

Do not regenerate a new random webpage per Beat.

## 13. Density

Allowed:
- LOW
- MEDIUM
- HIGH_JUSTIFIED

Default:
`LOW_TO_MEDIUM`.

HIGH requires a story reason.
“为了丰富” is invalid.

## 14. One Main Delta

Continuity Beat default:

> only one main visual state changes.

Do not simultaneously change camera, scene, color, character count, UI shell and reveal unless a higher-order montage/transformation reason exists.

## 15. Withhold / Reveal Safety

Setup must explicitly declare `withheld_information`.

Withhold must not leak through:
- exact wording;
- semantic polarity;
- warning/success color;
- alert icon;
- emphasis box;
- decorative number badge.

Defaults:
```text
WITHHOLD_TEXT_LEAK = OFF
WITHHOLD_COLOR_LEAK = OFF
WITHHOLD_ICON_LEAK = OFF
WITHHOLD_POLARITY_LEAK = OFF
DECORATIVE_NUMBER_BADGE = OFF
```

Reveal intensity should come primarily from the information/state change.

## 16. Dual Compare

Default:
`SOURCE_CROP_FIRST`.

Prefer:
story source A crop + story source B crop.

Avoid:
- VS;
- arrows;
- != graphics;
- conclusion card;
- dashboard;
- multi-column educational poster.

If sequential matched cuts work, prefer them over a same-frame dual.

## 17. Background Economy

Classify:
- WORLD_ANCHOR
- STORY_PROP
- DECORATIVE

Decorative items default to remove/suppress.
Background must be quieter than causal foreground.

## 18. Production Style

Current production Control:
`SIMPLIFIED_FLAT_NARRATIVE_COMIC`.

Frame design outranks decorative style.
A simpler art style does not fix bad focal architecture.

## 19. Asset Binding Order

Episode assets may be inventoried early.

But Beat-level asset binding must occur AFTER Frame Blueprint:

```text
Episode Asset Inventory
→ G4 Visual Beat
→ Frame Blueprint
→ Beat Asset Binding
→ Execution Mode
→ Prompt/Edit Compiler
```

Do not bind an asset merely because narration mentions it.

Failure:
`RETURN_ASSET_BINDING_PREMATURE`.

## 20. Continuity and Callback

`continuity_ref`:
adjacent state continuity.

`composition_callback_ref`:
non-adjacent visual rhyme / opening-ending callback / motif return.

These are distinct.

## 21. Execution Mode

After Blueprint + Asset Binding choose:

### GENERATE
new independent story state.

### DERIVE_EDIT
same canonical/accepted frame with one main delta.
Preferred for:
- setup → reveal;
- UI state changes;
- same-scene pose/state delta;
- matched inserts;
- before/after.

### COMPOSITE_CROP
meaning comes from arranging already-existing story sources/assets.
Preferred for:
- source-crop comparisons;
- exact UI/evidence excerpts;
- deterministic layout.

Rule:
`DERIVE/COMPOSITE > REGENERATE` when continuity can be preserved deterministically.

## 22. Blueprint Schema — minimum fields

```yaml
visual_beat_id:
g4_lock:
  visual_intention:
  shot_size:
  pov:

frame_archetype:
focus_mode:
dramatic_job:

primary_focus:
secondary_focus:

primary_zone:
secondary_zone:

attention_entry:
attention_exit:
transition_mode:

composition_mode:
composition_callback_ref:

density:
density_reason:
visual_intensity:
intensity_drivers:

background_anchors:
story_props:
remove_or_suppress:

text_policy:
brand_mode:
ui_mode:

continuity_preserve:
continuity_ref:
frame_delta:
withheld_information:

asset_binding:
execution_mode:

subtitle_safe_check:
acceptance_criteria:
```

## 23. Mobile / Small-screen QA

- 1-second P1 test
- 25% scale test
- squint test
- caption-safe test

## 24. Hard Defaults

```text
FOCUS_MODE = SINGLE
P1 = 1
P2 = 0–1
DENSITY = LOW_TO_MEDIUM
BACKGROUND_DETAIL = LOW

DIEGETIC_FIRST = YES
INFOGRAPHIC_LAST = YES

BRAND_MODE = NONE
SPEECH_BUBBLE = OFF
THOUGHT_BUBBLE = OFF
FLOATING_CARD = OFF
DECORATIVE_ARROW = OFF

EXACT_TEXT = POST_OVERLAY
CAPTION_LAYER = SEPARATE

ONE_MAIN_DELTA = YES
ASSET_BINDING_AFTER_BLUEPRINT = YES
SOURCE_CROP_COMPARE_FIRST = YES
DERIVE_BEFORE_REGENERATE = YES
```

## 25. Frame QA

Before PASS:
1. one dramatic job?
2. P1 clear?
3. P1 wins?
4. P2 supports P1?
5. removable clutter?
6. background quiet?
7. visible text causal?
8. brand necessary?
9. eye-trace intentional?
10. one main delta?
11. reveal protected?
12. 25% scale readable?
13. caption safe?
14. assets bound from visible/causal need?
15. could simplify another 20% without losing meaning?

If yes to #15:
simplify first.

## 26. Validation Evidence

Validated on Search Answer:
- 8 high-risk Blueprint cases;
- real-frame tests for Character Reaction, Withhold, Reveal, Dual Compare;
- focused v0.4 micro-tests;
- deterministic derive/crop validation.

Result:
`PASS / READY_CANONICAL`.
