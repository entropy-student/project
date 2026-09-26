# G5 Shotbook → Frame / Asset / Execution Package Contract v0.4

## Status

`G5 = PASS / CANONICAL`

Canonical sources:
- `docs/G4_DIRECTOR_COMPILER_CONTRACT.md`
- `docs/VISUAL_FRAME_BLUEPRINT_RULES.md`
- `docs/PRODUCTION_VISUAL_STYLE.md`
- `docs/CHARACTER_IDENTITY_LOCK.md`
- `docs/VISUAL_ACQUISITION_REVIEW_GATE.md`

## 1. Purpose

Compile accepted G4 Visual Beats into a deterministic image-production package without delegating creative decisions to the executor.

Principle:

> **G4 decides what the image means. Frame Blueprint decides how attention is arranged. G5 then binds assets and chooses how to execute that exact frame.**

G5 must not change:
- story;
- script;
- Beat count/order;
- timing;
- G4 visual intention;
- G4 shot size / POV.

## 2. Internal pipeline

```text
G5A Episode Asset Requirement Extraction
→ G5B Canonical Reference Lock
→ G5B.5 Visual Acquisition Review
→ G5C1 Frame Blueprint Compilation
→ G5C2 Beat Asset Binding
→ G5C3 Execution Mode Selection
→ G5C4 Prompt / Edit Compiler
→ Automatic Package QA
```

## 2A. Calibration Exception — NOT a normal episode Gate

Manual/high-risk Pilot QA is **calibration-only**.

Trigger it only when:
- a new recurring character is introduced;
- a new visual style is introduced;
- image model/provider changes materially;
- executor changes materially;
- Prompt/Edit Compiler changes materially;
- automated QA reveals a new repeated failure class.

Normal episode flow does not require Owner review of first-batch key frames.

If no calibration trigger exists:
`G5C4 → Automatic Package QA → Production Package`

## 3. G5A — Episode Asset Inventory

Extract possible episode-level:
- characters;
- scenes;
- props;
- UI/documents;
- style assets.

Important:
this is an **inventory**, not final Beat binding.

Do not infer that an asset must appear in a Beat merely because narration mentions it.

## 4. G5B — Canonical Reference Lock

Freeze reusable:
- Character Bible;
- Scene Bible;
- Style Bible;
- Prop/UI Bible;
- Reference Manifest.

No fake paths.
Missing real input remains explicit.

## 5. G5B.5 — Visual Acquisition Review

Canonical:
`docs/VISUAL_ACQUISITION_REVIEW_GATE.md`

Current Control:
`SIMPLIFIED_FLAT_NARRATIVE_COMIC`

Decision:
`KEEP + ITERATE`

Frame architecture outranks decorative style complexity.

## 6. G5C1 — Frame Blueprint Compilation

Canonical:
`docs/VISUAL_FRAME_BLUEPRINT_RULES.md`

Input:
accepted G4 Visual Beat.

Output:
one `Frame Blueprint` per Visual Beat.

It locks:
- dramatic job;
- focus mode;
- P1/P2;
- attention path;
- composition mode;
- density;
- text policy;
- brand mode;
- UI mode;
- continuity preserve;
- frame delta;
- withheld information;
- frame-level acceptance criteria.

It must preserve G4 intent.

## 7. G5C2 — Beat Asset Binding

Only after Blueprint.

Bind only assets that are:
- visible in the frame;
- causally required;
- required to preserve continuity/identity.

Do not bind assets only because narration mentions them.

Failure:
`RETURN_ASSET_BINDING_PREMATURE`

## 8. G5C3 — Execution Mode Selection

Every Beat receives one:

### GENERATE
Use when a genuinely new independent story state must be generated.

### DERIVE_EDIT
Use image-edit generation when an accepted/canonical frame can be preserved and only one main state changes.

Preferred for:
- setup → reveal;
- UI state change;
- matched insert;
- same-scene state delta;
- before/after.

For any recurring character:
- source frame is continuity input only;
- canonical identity reference remains mandatory;
- canonical identity overrides any drift already present in the source frame.

If the source frame already failed identity/maturity/costume QA:
do not derive from it.

### DERIVE_EDIT compatibility boundary

`DERIVE_EDIT` is allowed only when the accepted source can preserve the target frame's locked viewpoint/composition and the change is a local state delta.

Do **not** use `DERIVE_EDIT` when the target requires a material change in:
- POV family (for example OBSERVER → IP_POV / IP_POV_HANDS);
- camera side / angle / crop that changes who is looking;
- visible subject set (for example full character → hands-only insert);
- primary prop/UI geometry that does not yet exist in the source.

In those cases, use `GENERATE` unless a separate approved source already matches the target POV/composition.

Failure:
`RETURN_DERIVE_SOURCE_INCOMPATIBLE`.

### COMPOSITE_CROP
Use when crop/composition of already approved visual sources is more reliable than regenerating the whole frame.

Allowed sources:
- image-model-generated frames/assets that already passed QA;
- owner-provided/approved image assets.

Preferred for:
- evidence source crops;
- source-crop comparisons;
- matched visual excerpts.

Important Owner constraint:
`COMPOSITE_CROP` is NOT a code-drawn UI/table pipeline.
UI / table / document visual assets remain image-generation assets unless the Owner explicitly changes this policy.

Rule:

> `DERIVE_EDIT / COMPOSITE_CROP > GENERATE` when they preserve the intended state more deterministically.

## 9. G5C4 — Prompt / Edit Compiler

### GENERATE row
Must contain:
- blueprint_ref;
- character_refs;
- identity_lock;
- scene_refs;
- prop_ui_refs;
- style_refs;
- prompt;
- negative constraints;
- output name;
- acceptance criteria.

### DERIVE_EDIT row
Must contain:
- blueprint_ref;
- source_frame_ref;
- identity_lock;
- canonical character refs when a recurring character appears;
- immutable locks;
- exact delta;
- forbidden changes;
- output name;
- acceptance criteria.

### COMPOSITE_CROP row
Must contain:
- blueprint_ref;
- source asset/frame refs;
- crop/placement instructions;
- overlay instructions;
- output name;
- acceptance criteria.

Executor must not reinterpret story meaning.

## 10. Text policy

Exact critical text:
`POST_OVERLAY`

Image generation owns:
- shell;
- spacing;
- geometry;
- highlight region;
- visual hierarchy.

Post overlay owns:
- exact Chinese wording;
- verified brand text;
- exact policy text;
- exact amounts/identifiers.

## 11. Brand policy

Default:
`NONE`

No invented brand names/logos for realism.

Real brand only if:
- causally required;
- KnowledgeCore verified;
- explicitly approved.

## 12. Reference policy

Canonical character policy:
`docs/CHARACTER_IDENTITY_LOCK.md`

Reference precedence:

```text
canonical identity
> approved production character master
> approved angle/pose
> previous accepted frame
> prompt prose
```

Canonical identity refs are never replaced by prior generated frames.

Previous accepted frame may be:
- continuity support;
- derive/edit source.

It may not redefine maturity, face geometry, body proportion, costume or hair silhouette.

Any character-containing execution row must explicitly carry an `identity_lock`.
If a source frame already drifted, reject it and return to the nearest accepted source.

`continuity_ref` = adjacent continuity.
`composition_callback_ref` = non-adjacent visual rhyme.

## 13. Default output ratio

`16:9`

Default target:
`1920×1080`

Do not crop away Blueprint focal structure.

## 14. Acceptance gates

### G4 Fidelity
Blueprint/execution preserves G4 meaning.

### Focus Gate
P1 is immediately discoverable.

### Identity Gate
Recurring IP stays recognizably identical AND preserves:
- clearly adult young-male maturity;
- natural eye scale;
- stable jaw/chin/nose geometry;
- canonical adult body proportion;
- canonical wine-red collared costume;
- canonical major hair silhouette.

Juvenile/cute reinterpretation is a hard failure.

Visibility-scoped identity QA:
- evaluate only identity features actually visible in the frame;
- a hands/cuff-only POV frame still binds the canonical character reference when the costume/body cue is identity-bearing;
- do not require off-frame face/jaw/nose/full-body checks;
- do not expose a full character merely to make identity QA easier.

### Scene Gate
Recurring geometry remains stable.

### Style Gate
Production visual style remains within canonical range.

### One-Main-Delta Gate
Continuity Beat changes only what the Blueprint requires.

### Reveal Gate
Setup does not leak payoff.

### Text Gate
Exact text is correct through declared render mode.

### Brand Gate
No unnecessary brand identity.

### Execution Determinism Gate
Executor has no missing creative choice.

## 15. Historical G5C v0.1 outputs

The original Search Case files:
- `10_IMAGE_GENERATION_ROWS.json`
- `11_IMAGE_GENERATION_PLAN.md`
- `12_PILOT_BATCH.json`

are preserved as historical validation evidence but are **SUPERSEDED** because they bound assets before Frame Blueprint and lacked execution-mode selection.

Do not use them for production.

## 16. G5 PASS

Requires at least one full episode where:
1. every Visual Beat has exactly one Blueprint;
2. Blueprint preserves G4;
3. Beat assets are bound after Blueprint;
4. every Beat has execution mode;
5. no fake references;
6. if a calibration exception was triggered, that bounded calibration passes; otherwise no Pilot is required;
7. automatic package QA passes;
8. executor package requires no creative improvisation.

Actual full-episode image generation is downstream evidence; it is not required to define the G5 contract.

## 2026-09-26 Owner production override

Apply `STORY_EVENT_FRAME_PRODUCTION_PATCH_20260926.md` when compiling new story-video image packages. A planned forward `DERIVE_EDIT` source is usable only after the source full image is story-QA-accepted and its binary is accessible. Use the declared `GENERATE` fallback for incompatible POV/geometry/source. `COMPOSITE_CROP` and post-production text overlay are forbidden in this Owner pipeline even where the older Candidate contract permits them.
