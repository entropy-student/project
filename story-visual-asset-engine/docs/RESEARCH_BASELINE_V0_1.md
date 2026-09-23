# Research Baseline v0.1 — Cost, Consistency, Reuse and Style

Date: 2026-09-23  
Status: `RESEARCH_BASELINE / NOT STYLE LOCK`

## Executive finding

The project should not optimize primarily for a mythical "cheapest art style token-wise."

For current GPT Image APIs, documented output cost is tied to model/quality/size/token usage; semantic style itself is not documented as a direct pricing knob. Therefore:

```text
primary lever = fewer new generations
secondary lever = fewer retries
tertiary lever = lower acceptable quality/resolution
style choice = maximize reuse + consistency + readability
```

## Candidate style families for G1

### A. LIMITED_2D_STORY_COMIC — preferred hypothesis

Traits:
- clean line art;
- flat fills;
- one simple shadow layer at most;
- 6–12 recurring palette colors;
- low-texture background;
- adult proportions;
- expressive face/body language;
- cinematic shot composition;
- no decorative text baked into the image.

Expected advantages:
- drift is easier to hide;
- crop/reframe is safer;
- character/background/prop separation is easier;
- edits can preserve most of the original;
- lower-quality generation settings may remain acceptable;
- compatible with cutout/limited-motion derivatives.

Risks:
- may feel generic, corporate or PPT-like if staging is weak;
- requires explicit "story frame, not infographic" art direction.

### B. MONOCHROME_EDITORIAL / STORYBOARD_PLUS

Traits:
- black/white or 2–4 tones;
- expressive ink/pencil lines;
- minimal backgrounds.

Expected advantages:
- strongest tolerance to generation defects;
- high reuse;
- fast visual comprehension.

Risks:
- may undershoot desired polish;
- weaker color-based brand identity.

### C. SIMPLIFIED_ANIME / CEL STORY FRAME

Traits:
- cleaner anime proportions;
- flat cel shading;
- somewhat richer environments than A.

Expected advantages:
- stronger perceived polish/emotional appeal.

Risks:
- face/wardrobe drift becomes more visible;
- hand/body/composition failures cost more retries;
- harder to composite mixed assets without style seams.

Do not benchmark photorealistic or pseudo-3D as primary candidates in G1. Their value can be revisited only if the simpler families clearly fail the audience-quality floor.

## Asset model

An accepted asset is not just a file. It is a reusable production object.

Minimum proposed metadata:

```text
asset_id
asset_type
style_version
characters[]
pose
expression
camera_scale
camera_angle
background_id
props[]
aspect_ratio
source_kind
parent_asset_ids[]
prompt_version
provider
model
quality
size
seed_or_determinism
qa_status
reuse_scope
file_ref
created_at
```

### ID proposal

Human-readable stable ID:

`<TYPE>_<SUBJECT>_<VARIANT>_<NNN>`

Examples:
- `CHAR_IP01_MASTER_001`
- `POSE_IP01_EXPLAIN_003`
- `BG_BEDROOM_NIGHT_002`
- `BOARD_SEARCH_CONFUSED_014`

Do not encode every attribute into the ID; metadata owns detailed attributes.

## Reuse router

Before any generation:

```text
QUERY
→ exact structured match?
  → EXACT_REUSE
→ same semantic asset but different framing?
  → REFRAME
→ accepted near-match that can be edited?
  → DERIVE_EDIT
→ reusable character/background/prop combination?
  → COMPOSITE
→ otherwise
  → NEW_GENERATE
```

Every derived asset records parent lineage.

## Prompt compiler

### Shared STYLE_LOCK

Short and stable. It should describe only properties that actually need global consistency.

Candidate skeleton:

```text
2D narrative comic frame; clean medium-weight line art; flat colors; limited recurring palette; one simple cel-shadow layer; low-texture background; readable silhouette and facial expression; cinematic composition; story scene, not infographic; no embedded text.
```

### Character

Prefer reference assets/IDs over repeatedly restating full appearance.

Text fallback:

```text
CHARACTER_LOCK: adult proportions; fixed face shape, hair, wardrobe and palette from CHAR_IP01_MASTER_001.
```

### Scene-specific block

```text
SHOT_INTENT
CAMERA
ACTION
EMOTION
ENVIRONMENT
MUST_KEEP
MUST_NOT
```

### Model-sheet prompt

Model sheets are their own asset-generation task:

```text
character model sheet / turnaround; front, 3/4, side and back; neutral stance; identical wardrobe and proportions; plain background; no perspective distortion; design reference, not story scene.
```

Do not put model-sheet instructions into ordinary scene prompts.

## Retrieval architecture

### P0/G1

Use:
- JSON or SQLite metadata;
- deterministic filters;
- simple text search.

### Later, if needed

Add:
- CLIP/OpenCLIP embeddings;
- FAISS nearest-neighbor retrieval.

Trigger condition is operational pain from library size, not a predetermined asset count.

## G1 benchmark design

Use the same small benchmark set for all three styles:

1. character master / turnaround;
2. neutral medium shot;
3. close-up confusion;
4. side-view thinking at computer;
5. pointing/explaining pose;
6. wide room scene;
7. same room, new camera angle;
8. two-character interaction;
9. object/document insert;
10. derive/edit an accepted prior frame.

For each style record:
- provider/model/settings;
- billed usage if exposed;
- generation latency;
- first-pass PASS/RETURN;
- retries;
- character drift;
- wardrobe drift;
- style drift;
- hand/body defects;
- composition readability;
- derive/edit success;
- reuse potential;
- Owner subjective quality only after technical measurements are captured.

## G1 decision rule

Do not select a style merely because it has the prettiest single best frame.

Select the style family whose **median production behavior** best balances:
- accepted quality floor;
- consistency;
- retry burden;
- reuse potential;
- cost;
- story readability.

Exact weights remain UNKNOWN until the first controlled benchmark.
