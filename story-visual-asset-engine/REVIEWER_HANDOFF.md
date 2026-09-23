# Story Visual Asset Engine — REVIEWER HANDOFF

Date: 2026-09-23  
Status: `CURRENT TRUTH ONLY / P0 RESEARCH IN_PROGRESS / STYLE NOT LOCKED / ASSET-REUSE ARCHITECTURE UNDER REVIEW`

## 1. Final goal

Create a reusable visual production system for story videos that reduces total generation calls and retry cost while maintaining a stable, readable visual identity.

Target flow:

```text
shot requirement
→ asset retrieval
→ EXACT_REUSE / REFRAME / DERIVE_EDIT / COMPOSITE / NEW_GENERATE
→ QA
→ register accepted asset + lineage
→ board/timeline consumer
```

Long-term integration target:
`ai-story-showrunner`

Integration is blocked until this project proves its style, asset model and reuse policy in a controlled pilot.

## 2. Governance

Canonical governance:
`entropy-student/spike.skill/vps-project-governance`

Roles:
- Owner: product/brand direction, consequential choices, final visual acceptance.
- Reviewer: architecture, Gate definition, evidence review, PASS/RETURN, current truth.
- Executor: bounded tests, asset generation, measurements, evidence.

`PASS_CANDIDATE != PASS`.

## 3. Current Gate

`P0_RESEARCH_AND_PROBLEM_DEFINITION = IN_PROGRESS`

P0 questions:

1. Does a simpler visual style materially reduce billed image tokens, or mainly reduce retries and improve reuse?
2. Which style family best balances audience readability, consistency, reuse and low production cost?
3. What should be stored as a reusable asset versus regenerated?
4. How should characters, poses, expressions, backgrounds, props and complete boards be identified and retrieved?
5. How should prompts be compiled so common style/character constraints are not rewritten ad hoc for every image?
6. Which consistency mechanism should be preferred: prompt-only, reference-image conditioning, edit/derive, composite, or trained identity/style adapters?
7. At what library size does semantic retrieval become useful versus simple structured tags?
8. How should this later plug into Story Showrunner without coupling its creative core to one image provider?

## 4. Current research findings

### Cost truth

Current OpenAI image-generation documentation prices image generation by model/token rate and reports output-token usage as a function of quality/size/model settings. No documented rule says that "pixel art", "flat illustration" or another semantic art style consumes fewer image output tokens at the same model/quality/size.

Reviewer interpretation:
- do not choose a style because it is assumed to be intrinsically cheaper in token accounting;
- choose a style because it reduces retries, makes lower-quality settings usable, and increases asset reuse/edit/composite success;
- the dominant cost strategy should be **generate fewer new images**.

### Industry / research precedent

- StoryDiffusion targets consistent characters across long image sequences.
- StoryMaker targets face, clothing, hairstyle and body consistency for multi-image stories.
- IP-Adapter, InstantID and PuLID show that image-conditioned identity/reference control can outperform prompt-only repetition for subject consistency.
- DreamO extends reference customization to character/object/style/multi-condition workflows, but its own documentation notes style consistency is less stable than identity/IP tasks.
- Toon Boom Harmony treats characters, backgrounds, drawings, key poses and scene structures as reusable library templates across scenes/projects.
- Storyboarder treats frames as ordered boards with shot/timing metadata and fast duplicate/copy/rearrange workflows.

These precedents support a **library-first / reference-first** architecture rather than independent text-to-image calls for every frame.

## 5. Current hypothesis — not yet accepted

Primary candidate style family:

`LIMITED_2D_STORY_COMIC / CUTOUT_FRIENDLY`

Candidate traits:
- 2D;
- clean, medium-weight line art;
- flat fills + at most one simple shadow layer;
- limited palette;
- low-texture backgrounds;
- readable silhouettes and expressions;
- adult proportions;
- cinematic framing rather than infographic/PPT composition;
- minimal embedded text;
- modular character/background/prop separation where useful.

Why it is only a hypothesis:
- simpler style may improve reuse but could reduce perceived quality or become generic;
- a benchmark against at least two alternatives is required before style lock.

## 6. Candidate architecture

### Asset classes

```text
CHARACTER_MASTER
CHARACTER_POSE
CHARACTER_EXPRESSION
BACKGROUND
PROP
UI_OR_DOCUMENT
COMPOSITE_TEMPLATE
BOARD
```

### Reuse decision order

```text
1. EXACT_REUSE
2. REFRAME / CROP
3. DERIVE_EDIT from accepted asset
4. COMPOSITE accepted assets
5. NEW_GENERATE
```

New generation is the last resort, not the default.

### Retrieval

Phase 1:
structured metadata + deterministic filtering.

Possible later phase:
CLIP/OpenCLIP embeddings + FAISS similarity search when the library is large enough that tags alone become cumbersome.

Do not introduce a vector database in P0 merely because it is available.

## 7. Prompt architecture hypothesis

Prompt compilation should be modular:

```text
STYLE_LOCK
+ CHARACTER/ASSET REFERENCES
+ SCENE INTENT
+ CAMERA / COMPOSITION
+ ACTION / EMOTION
+ NEGATIVE / FORBIDDEN CONSTRAINTS
```

Do not re-describe an entire character sheet in every scene if a reference asset/provider reference mechanism is available.

Three-view/model-sheet prompts belong to asset creation, not ordinary story-board prompts.

## 8. P0 acceptance

P0 may PASS only when:
- cost assumptions are separated into documented facts vs inference;
- 3 style families are selected for a controlled benchmark;
- a minimal asset schema is defined;
- reuse operation taxonomy is defined;
- a fixed benchmark shot set is defined;
- measurable evaluation criteria are defined;
- no provider is prematurely locked.

## 9. Proposed next Gate

After P0 PASS:

`G1_STYLE_AND_REUSE_BENCHMARK`

Run the same small shot set across three candidate styles and measure:
- first-pass acceptability;
- character drift;
- composition/readability;
- edit/derive success;
- reuse/composite suitability;
- prompt complexity;
- generation usage/cost if exposed by provider;
- retries required.

No full episode production in G1.

## 10. Owner intervention

`OWNER_ACTION_REQUIRED = NO`

Owner input is useful only when choosing among visually acceptable finalists.
