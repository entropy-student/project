# Story Visual Asset Engine — EXECUTION EVIDENCE

## P0 research evidence — 2026-09-23

### Cost model

OpenAI's current image-generation documentation states that image-generation cost includes text input, image input where applicable, and image output tokens. Output token usage/cost is exposed against model, quality and size settings. The documentation does not state that semantic style complexity such as pixel art vs 3D directly reduces image output-token accounting at fixed model/quality/size.

Evidence source:
- https://developers.openai.com/api/docs/guides/image-generation

Reviewer interpretation:
`STYLE_SIMPLICITY != VERIFIED_DIRECT_TOKEN_DISCOUNT`.

The credible cost mechanisms are:
- fewer generations;
- fewer retries;
- lower acceptable quality/resolution when appropriate;
- reuse/edit/composite instead of redraw;
- prompt/reference caching where a provider supports it.

### Consistency research

StoryDiffusion:
- long-range image/video generation;
- consistent self-attention for character-consistent sequences;
- comic generation is an explicit target.
Source:
- https://github.com/HVision-NKU/StoryDiffusion

StoryMaker:
- preserves faces plus clothing, hairstyles and bodies in multiple-character scenes;
- explicitly positions the method for stories consisting of a series of images.
Source:
- https://github.com/RedAIGC/StoryMaker

IP-Adapter:
- lightweight image-prompt adapter for text-to-image models;
- supports combining image prompts and text prompts.
Source:
- https://github.com/tencent-ailab/IP-Adapter

InstantID:
- tuning-free identity-preserving generation from one image;
- supports stylized synthesis.
Source:
- https://github.com/instantX-research/InstantID

PuLID:
- tuning-free identity customization;
- emphasizes ID fidelity with editability.
Source:
- https://github.com/ToTheBeginning/PuLID

DreamO:
- supports character/object IP, facial ID, style and multi-condition customization;
- repository notes style consistency is less stable than its identity/IP tasks.
Source:
- https://github.com/bytedance/DreamO

### Reuse precedent

Toon Boom Harmony:
- library stores reusable animation, drawings, backgrounds, character models, key poses and scene templates;
- templates are portable across scenes/projects.
Sources:
- https://docs.toonboom.com/help/harmony-25/essentials/reference/view/library-view.html
- https://docs.toonboom.com/help/harmony-25/essentials/library/about-template.html

Storyboarder:
- optimized for fast board creation/duplication/rearrangement;
- board metadata includes timing and shot type;
- supports export into editing workflows.
Source:
- https://wonderunit.com/storyboarder/

### Retrieval precedent

CLIP/OpenCLIP can encode image/text into comparable embeddings; FAISS supports efficient similarity search over dense vectors.

Sources:
- https://github.com/openai/CLIP
- https://github.com/mlfoundations/open_clip
- https://github.com/facebookresearch/faiss

Reviewer interpretation:
semantic image retrieval is viable later, but P0 should start with structured metadata because the initial library is small.


## P0 deep-research closeout — 2026-09-23

Fresh source review added the following evidence:

### OpenAI image-generation/edit path
Official image-generation docs confirm:
- generation cost includes text input, image input where applicable and image output usage;
- quality and size are explicit cost/usage controls;
- existing images can be edited;
- one or more reference images can be used to generate a new image;
- mask-guided local edits are supported.

Sources:
- https://developers.openai.com/api/docs/guides/image-generation
- https://developers.openai.com/api/docs/guides/image-prompting

### Reference/identity control
Fresh review confirmed:
- IP-Adapter combines image prompts with text prompts;
- InstantID provides tuning-free single-image identity preservation;
- PuLID provides tuning-free identity customization;
- DreamO supports ID/IP/style/multiple conditions and explicitly reports style consistency as less stable than its other customization tasks.

Sources:
- https://github.com/tencent-ailab/IP-Adapter
- https://github.com/instantX-research/InstantID
- https://github.com/ToTheBeginning/PuLID
- https://github.com/bytedance/DreamO

### Structural conditioning
ControlNet provides a documented example of external conditions controlling image generation rather than relying only on text prompts.

Source:
- https://github.com/lllyasviel/ControlNet

### Reusable production libraries
Current Toon Boom Harmony documentation confirms libraries/templates can store and reuse puppets, backgrounds, animations and key poses; drawing substitution is especially relevant to reusable body-part/pose variants.

Source:
- https://docs.toonboom.com/help/harmony-27/essentials/library/about-library.html

### Reviewer closeout
P0 acceptance criteria are fully satisfied.

Result:
`PASS_P0_RESEARCH_AND_PROBLEM_DEFINITION`

No style has been promoted. G1 empirical benchmark remains required.
