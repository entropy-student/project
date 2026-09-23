# P0 Deep Research Review

Date: 2026-09-23  
Reviewer result: `PASS_P0_RESEARCH_AND_PROBLEM_DEFINITION`

## 1. Question

How should a story-first image-sequence production system reduce image-generation cost while maintaining acceptable visual quality, character consistency and long-term reuse?

## 2. Research conclusion

The project should optimize **production economics**, not chase a presumed "cheap semantic art style".

For current GPT Image APIs, official documentation exposes cost/usage through model, quality, size, text/image input tokens and image output tokens. It does not document a pricing rule where pixel art, flat illustration, anime or 3D automatically receives a lower output-token bill at identical generation settings.

Therefore:

```text
Primary cost lever   = fewer NEW_GENERATE calls
Secondary lever      = fewer retries
Third lever          = lower quality/resolution where the visual floor still passes
Fourth lever         = edit/reuse/composite accepted assets
Style selection      = maximize reuse + consistency + readability, not mythical token discount
```

OpenAI also officially supports reference-image generation, multi-image references and edits. That makes a reference-first/derive-first pipeline technically compatible with current image APIs.

Sources:
- https://developers.openai.com/api/docs/guides/image-generation
- https://developers.openai.com/api/docs/guides/image-prompting

## 3. Consistency research

### Story sequences

StoryDiffusion explicitly targets long-range character-consistent image sequences and comic generation.

StoryMaker explicitly targets preservation of face, clothing, hairstyle and body across multi-character scenes and image-series stories.

Sources:
- https://github.com/HVision-NKU/StoryDiffusion
- https://github.com/RedAIGC/StoryMaker

### Reference-driven identity

IP-Adapter demonstrates lightweight image-prompt conditioning that can be combined with text prompts.

InstantID and PuLID show tuning-free identity-preserving generation from reference identity inputs.

DreamO broadens customization to ID/IP/style/multiple conditions, while its own repository states style consistency remains less stable than identity/IP tasks.

Sources:
- https://github.com/tencent-ailab/IP-Adapter
- https://github.com/instantX-research/InstantID
- https://github.com/ToTheBeginning/PuLID
- https://github.com/bytedance/DreamO

Reviewer implication:
**prompt-only repetition should not be the long-term consistency strategy.**
The architecture should preserve accepted reference assets and prefer reference/edit/derive workflows when the provider supports them.

### Structural control

ControlNet demonstrates the broader principle of adding external structural conditions to image generation rather than relying on prose alone.

Source:
- https://github.com/lllyasviel/ControlNet

This does not mean ControlNet is selected for this project. It supports the architectural conclusion that reusable structure/reference inputs are valuable.

## 4. Production-library precedent

Toon Boom Harmony's library can store/reuse puppets, backgrounds, drawings, animations and key poses; templates can be reused across scenes/projects. Its Drawing Substitution workflow is particularly relevant to reusable hands/mouths/poses in cut-out characters.

Storyboarder supports fast duplicate/copy/rearrange of boards and stores timing/shot-type metadata.

Sources:
- https://docs.toonboom.com/help/harmony-27/essentials/library/about-library.html
- https://docs.toonboom.com/help/harmony-25/essentials/library/about-template.html
- https://wonderunit.com/storyboarder/

Reviewer implication:
the project asset is not merely a PNG. It is a production object with identity, metadata, lineage, intended reuse scope and QA status.

## 5. Retrieval research

FAISS is designed for efficient similarity search over dense vectors. CLIP/OpenCLIP-style representations make text/image similarity retrieval possible.

Source:
- https://github.com/facebookresearch/faiss
- https://github.com/openai/CLIP
- https://github.com/mlfoundations/open_clip

Reviewer decision:
do **not** introduce vector retrieval in P0/G1. Structured metadata is sufficient for a small library. Add embeddings only when deterministic tag search becomes operationally painful.

## 6. Style-family shortlist

Three families are fixed for G1 benchmarking.

### A — LIMITED_2D_STORY_COMIC

- clean medium-weight line art;
- flat fills;
- maximum one simple cel-shadow layer;
- limited recurring palette;
- low-texture backgrounds;
- adult proportions;
- strong silhouette/readable emotions;
- cinematic story frame;
- no embedded explanatory text.

Hypothesis:
best balance of audience-facing polish, consistency and reuse.

### B — MONOCHROME_EDITORIAL_STORYBOARD_PLUS

- expressive black/white or 2–4-tone drawing;
- sparse environment;
- strong silhouette;
- limited hatch/texture;
- cinematic board, not rough scribble.

Hypothesis:
lowest retry burden / highest defect tolerance, but may undershoot the desired finish quality.

### C — SIMPLIFIED_ANIME_CEL_STORY_FRAME

- clean anime-inspired adult proportions;
- flat cel color;
- controlled shadows;
- moderately richer environment;
- expressive acting;
- no hyper-detailed rendering.

Hypothesis:
highest audience-facing polish of the three, but likely higher drift/retry burden and lower cross-frame compositing tolerance.

These are **hypotheses**, not a style decision.

## 7. Reuse architecture

Required routing order:

```text
EXACT_REUSE
→ REFRAME
→ DERIVE_EDIT
→ COMPOSITE
→ NEW_GENERATE
```

`NEW_GENERATE` is the fallback.

Each accepted/derived asset must retain lineage.

## 8. Prompt architecture

Prompt compilation is modular:

```text
STYLE_LOCK
+ REFERENCE_BINDINGS
+ SHOT_INTENT
+ CAMERA
+ ACTION / EMOTION
+ ENVIRONMENT
+ MUST_KEEP
+ MUST_NOT
```

Model-sheet/turnaround instructions are a separate asset-generation task and must not leak into ordinary story-frame prompts.

## 9. P0 acceptance checklist

- [x] Cost facts separated from inference.
- [x] Three benchmark style families fixed.
- [x] Minimal asset schema defined.
- [x] Reuse operation taxonomy defined.
- [x] Fixed benchmark shot set defined.
- [x] Measurable criteria defined.
- [x] Provider not prematurely locked.
- [x] Story Showrunner integration remains blocked until pilot evidence exists.

Reviewer decision:

`PASS_P0_RESEARCH_AND_PROBLEM_DEFINITION`

Next:
`G1_STYLE_AND_REUSE_BENCHMARK = READY`
