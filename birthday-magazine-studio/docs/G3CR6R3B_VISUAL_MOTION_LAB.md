> **STATUS: SUPERSEDED BEFORE EXECUTION by `G3CR6R3C_TEMPLATE_SOURCE_DISCOVERY`.**  
> Owner simplified the plan to template/source-first discovery for 12 magazine pages + 1 homepage + 1 core interaction before any implementation.

# G3CR6R3B — Visual + Motion Lab

## Gate

```text
GATE_ID=G3CR6R3B_VISUAL_MOTION_LAB
OBJECTIVE=Validate one high-quality unified visual/motion direction for the 1+1+12 experience before expanding to the full 12-page product
MAX_ENDPOINT_THIS_ROUND=Owner-ready lab prototypes + Reviewer evidence package
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Local design/prototype assets and deterministic frontend/magazine lab only
OWNER_ONLY_ACTIONS=NONE
```

Governance: **vps-project-governance v0.2.6**.

## Accepted facts

- Current full magazine visual is Owner rejected.
- G2BR3 technical content/rendering Solution Proof remains PASS.
- G3CR6R1 website composition remains PASS as a structural baseline only.
- G3CR6R3A full 12-page redesign is superseded before execution by this smaller lab.
- The product remains a static 12-page PDF.
- Website motion and magazine output are separate concerns.
- Free Preview remains browser-local and zero-model.

## Goal

Select a direction that is strong enough to expand into:

```text
1 homepage
+
1 high-impact activation interaction
+
12 static magazine pages
```

The lab must optimize for **purchase desire and perceived product quality**, not merely technical feasibility.

## Shared design-system requirement

All lab outputs should derive from one coherent editorial design system:

- color;
- typography;
- spacing;
- image treatment;
- framing;
- layer/depth rules;
- button/CTA language;
- magazine-paper treatment;
- motion vocabulary.

Do not produce three unrelated brands.

## Part A — Core interaction prototypes

Create **3 distinct interaction directions** for:

```text
one local photo
→ magazine transformation
→ lightweight cover choice
→ reveal of magazine context
→ complete-issue CTA
```

Each direction must be materially different in interaction, not just color.

Examples of acceptable differences:
- Morph-focused;
- Stack/reveal-focused;
- Editorial-stage / layered-composition focused.

Required for each:
- desktop concept;
- 375px mobile concept;
- interaction storyboard or runnable prototype;
- concise motion inventory;
- reduced-motion fallback.

No server upload, no model call.

## Part B — Cover directions

Create **3 deterministic cover directions** that can all accept the same customer photo + title/copy data.

The covers should differ materially in composition, e.g.:
- editorial portrait;
- full-bleed typographic;
- offset/collage.

The goal is lightweight personalization without creating three separate production engines.

## Part C — Four representative magazine pages

Create only four high-signal static page prototypes under the strongest master art direction:

1. Cover
2. Feature Story / two-page spread or equivalent representative story composition
3. Photo Story
4. Birthday Letter

Requirements:
- customer-photo led;
- premium/warm/editorial;
- not scrapbook-heavy;
- not repeated left-text/right-image;
- directly implementable in deterministic HTML/CSS;
- compatible with the frozen content/page-map architecture.

## Image-generation authorization

Image generation may be used for:
- design exploration;
- non-private demo photography;
- staging/reference boards;
- decorative presentation assets.

It may not become a per-order requirement or be presented as customer-generated content.

For implemented magazine prototypes, use clearly labeled non-private demo photos.

## Website motion vocabulary

The lab should test a limited system rather than unrelated effects:

### Reveal
mask/clip/opacity/translate reveals.

### Depth
restrained parallax, tilt, layered motion.

### Morph
photo/card/object transitions between interface states.

### Stack
paper/page layering, fan-out, overlap, collect.

Do not use:
- scroll-jacking;
- constant distracting animation;
- particle-showcase effects;
- interaction that breaks mobile/touch;
- motion that implies the final PDF itself is animated.

## Free Preview contract

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
```

A local photo may be used only in-browser.

## Scope not included

Do not:
- rebuild all 12 magazine pages yet;
- mutate WordPress production/current runtime;
- change Woo/payment/account/private-workspace;
- change price;
- change page count;
- change production AI/provider;
- deploy to VPS;
- merge PR #64.

This is a direction-selection Gate.

## PREFLIGHT

Before mutation:
- fresh read-back current PR #64;
- confirm current website/magazine accepted baselines;
- preserve current proof artifacts;
- create scoped lab workspace/rollback;
- keep lab changes isolated from protected backend/runtime.

## REQUIRED_EVIDENCE

Owner review package must include:

### Interaction
- 3 interaction concepts;
- desktop + mobile for each;
- storyboard or runnable demo;
- motion inventory;
- reduced-motion fallback.

### Covers
- 3 cover directions using the same demo photo/content.

### Magazine
- 4 representative pages under the strongest master direction.

### Comparison
- old rejected magazine sample vs new lab direction;
- concise rationale for why the new direction has higher purchase pull.

### Technical
- deterministic implementability note;
- browser-local Preview note;
- no backend/payment/runtime mutation;
- no production model/provider use.

## ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:

1. At least one interaction direction feels meaningfully more premium and surprising than the current upload→cover flow.
2. At least one cover direction feels purchase-worthy and supports lightweight personalization.
3. The four magazine prototypes establish a credible paid-gift art direction.
4. The homepage/interactions and magazine pages clearly belong to the same brand system.
5. Motion is purposeful, coherent and mobile/reduced-motion safe.
6. The chosen direction can be implemented deterministically without per-order image generation.
7. No protected backend/payment/production scope is touched.

## ROLLBACK_STATUS_OR_PLAN

- lab is additive/reversible;
- current G3CR6R1 website and G2BR3 technical proof remain untouched;
- discard lab assets if rejected.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. `docs/G3CR6R3B_VISUAL_MOTION_LAB.md`
2. `docs/OWNER_DECISION_G3CR6R3B_VISUAL_MOTION_LAB.md`
3. `docs/MVP_PRODUCT_CONTRACT.md` sections 2, 5, 6, 7
4. `docs/REVIEWER_DECISION_G3CR6R1_PASS.md`
5. current rejected G2BR3 contact sheet only as negative baseline
6. target lab/prototype files needed for execution

Do not execute the full 12-page redesign or website integration yet.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：一句话说明3个互动方向、3个封面方向和4个代表页做了什么。
验证：一句话说明移动端、reduced-motion、deterministic feasibility、零上传/零模型边界。
问题：NONE，或具体阻塞点。
回滚：lab为独立可丢弃资产，不影响当前已验收网站/技术证明。
请 Reviewer 检查：哪个互动最惊艳、哪个封面最想买、4个代表页是否足够支撑完整12页。
Owner 转交：NONE
```

Stop at Reviewer.

## Forbidden

```text
FULL_12_PAGE_BUILD=0
WORDPRESS_RUNTIME_MUTATIONS=0
WOO_MUTATIONS=0
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PR_MERGE=0
G4_ACTIONS=0
```
