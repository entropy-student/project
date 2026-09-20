# G5 Shotbook → Image Asset Package Contract v0.1

## Status

`G5 = IN_PROGRESS / G5A PASS / G5B PASS / G5C IN PROGRESS`

Canonical production visual baseline:

`docs/PRODUCTION_VISUAL_STYLE.md`

## 1. Purpose

Compile an accepted G4 Visual Beat Shotbook into a reproducible image-generation package.

G5 does not decide:
- story;
- script;
- beat count;
- timing;
- visual intention;
- shot size / POV already locked by G4.

G5 decides:
- which reusable assets each beat depends on;
- how character / scene / style / prop / UI identity is locked;
- which references must be attached;
- the final image-generation instruction for each beat;
- how continuity is carried from one generated still to the next.

Principle:

> **G4 decides what the image means. G5 decides how to generate that exact image consistently.**

---

## 2. G5 Internal Phases

### G5A — Asset Requirement Extraction

Input:
- accepted G4 Shotbook;
- episode Visual Strategy;
- existing project IP / reference assets when available.

Output:
- Character Asset Requirements;
- Scene Asset Requirements;
- Prop / UI / Document Requirements;
- Style Requirements;
- beat → asset dependency matrix.

Every asset must receive:
- stable asset ID;
- scope: GLOBAL / EPISODE / SEQUENCE / BEAT;
- reuse role;
- required views / states;
- real-reference status.

Real-reference status:
- `AVAILABLE`
- `MISSING_REAL_ASSET`
- `NOT_REQUIRED`
- `TO_GENERATE_CANONICAL`

Do not invent a file path when a real asset does not exist.

### G5B — Canonical Reference Lock

Freeze reusable identity before compiling individual prompts.

Minimum outputs:
- `CHARACTER_BIBLE.md`
- `SCENE_BIBLE.md`
- `STYLE_BIBLE.md`
- `PROP_UI_BIBLE.md`
- `REFERENCE_MANIFEST.json`

Character lock may include:
- face/head silhouette;
- hair;
- age impression;
- body proportion;
- fixed clothing/accessories;
- canonical front / 3/4 / side views;
- prohibited identity drift.

Scene lock may include:
- room geometry;
- furniture positions;
- stable screen axis;
- lighting/time;
- recurring camera anchors;
- allowed state variants;
- prohibited geometry drift.

UI/document lock may include:
- layout;
- stable text regions;
- state variants;
- readable critical phrases;
- fictional branding constraints.

Style lock may include:
- line/render style;
- material texture;
- background treatment;
- color discipline;
- character/world integration;
- prohibited visual styles.

### G5B.5 — Visual Acquisition Review

Required before G5C Pilot.

Canonical:
`docs/VISUAL_ACQUISITION_REVIEW_GATE.md`

Purpose:
treat visual style as a Message / Creative Lever and challenge internal taste with external evidence + a controlled visual-style hypothesis.

Current decision:
`KEEP + ITERATE`

Control:
`SIMPLIFIED_FLAT_NARRATIVE_COMIC`

Challenger:
`ULTRA_SIMPLE_NARRATIVE_LINE_CARTOON`

### G5C — Image Generation Compiler

Current MVP status:
`IN_PROGRESS`

Compile one final image row per accepted Visual Beat.

Minimum row:
- image_id;
- visual_beat_id;
- semantic_shot_id;
- prompt;
- negative_constraints;
- character_refs;
- scene_refs;
- prop_ui_refs;
- style_refs;
- continuity_ref;
- shot_size;
- POV;
- aspect_ratio;
- resolution;
- output_name;
- acceptance_criteria.

Default:
`1 Visual Beat ≈ 1 generated image`.

G5 must not merge or invent beats.

---

## 3. Prompt Architecture

Final prompt should be compiled, not improvised.

Recommended order:

1. identity lock;
2. scene/world lock;
3. exact story action/state;
4. subject priority;
5. framing / POV;
6. composition / eye-trace requirement;
7. prop/UI state;
8. continuity state;
9. style lock;
10. exclusions.

Prompt must describe the exact image to generate.

Do not include Director reasoning prose that the generator cannot act on.

---

## 4. Reference Strategy

### Character reference
Required whenever a recurring character appears.

### Scene reference
Required whenever recurring geometry matters.

### Prop/UI reference
Required when an object/page/interface must remain materially consistent across beats.

### Continuity reference
Use the previous accepted generated image only when:
- same scene continues;
- character pose/state evolves;
- object position must persist;
- matching composition is required.

Do not use continuity refs across intentional discontinuity/montage unless explicitly useful.

---

## 5. Canonical Asset vs Beat Image

Reusable canonical assets are not final story frames.

Examples:
- character turnaround = canonical asset;
- empty workroom = scene canonical;
- policy-page master layout = UI canonical;
- Beat 16 page with second policy line highlighted = generated beat image.

Do not use a beat-specific composition as the only canonical reference if the asset must recur more broadly.

---

## 6. Text / UI Policy

Critical text is allowed only when it is causal to the story.

For text-heavy UI:
- lock a stable master layout;
- minimize visible copy;
- isolate exact critical phrases;
- do not expect the image generator to faithfully render long paragraphs.

If exact typography cannot be reliably generated:
- generate the stable visual shell;
- overlay exact text downstream as a locked edit asset.

Mark:
`TEXT_RENDER_MODE = IMAGE_NATIVE | POST_OVERLAY`.

---

## 7. Resolution / Ratio

Current default video frame:
`16:9`.

Default target image:
`1920×1080` or equivalent 16:9 high-resolution source.

If the generator's native output differs, retain 16:9 and down/up-scale only downstream with no crop that changes composition.

Episode package must specify one canonical ratio unless a deliberate exception exists.

---

## 8. Acceptance Gates

### Identity Gate
Recurring character remains recognizably the same.

Failure:
`RETURN_CHARACTER_DRIFT`

### Scene Gate
Recurring geometry / major prop positions remain stable.

Failure:
`RETURN_SCENE_DRIFT`

### Style Gate
Rendering language remains within accepted Style Bible.

Failure:
`RETURN_STYLE_DRIFT`

### Beat Fidelity Gate
Generated image communicates the exact G4 beat.

Failure:
`RETURN_IMAGE_MISSED_BEAT`

### Text/UI Gate
Critical text/state is accurate enough for the declared render mode.

Failure:
`RETURN_UI_TEXT_FAILURE`

### Reference Resolution Gate
Every required reference is:
- available;
- explicitly marked to generate canonical first;
- or blocks execution as real input.

Failure:
`RETURN_REFERENCE_UNRESOLVED`

---

## 9. G5 PASS

G5 PASS requires at least one full episode where:

1. every Visual Beat maps to exactly one image-generation row unless documented otherwise;
2. reusable character/scene/style/prop/UI assets have stable IDs;
3. required reference status is explicit;
4. final prompts do not require Executor creativity;
5. no fake reference paths exist;
6. package can be handed to the image executor with unresolved items clearly blocking only what they actually block;
7. one end-to-end asset package passes Reviewer inspection.

Actual image generation is downstream execution evidence and is not required to define G5's contract, but unresolved real references may keep an episode at `PASS_CANDIDATE / BLOCKED_BY_REAL_INPUT`.

---

## 10. G5 MVP Sequence

First case:
`blind-search-answer`

Why:
- one main IP;
- one stable desk scene;
- one stable official-policy-page master;
- one cost-sheet prop;
- evidence-focused framing;
- low asset count but nontrivial continuity.

Validation target:
prove that asset locking and prompt compilation can preserve:
- character identity;
- same-page continuity;
- exact reveal states;
- matched contrast frames;
- G4 eye-trace intent.

After MVP:
run a higher-continuity case such as Context / Memory before G5 final PASS.
