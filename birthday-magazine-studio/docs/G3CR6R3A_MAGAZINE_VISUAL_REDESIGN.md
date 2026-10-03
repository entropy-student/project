# G3CR6R3A — Magazine Visual Redesign

## Gate

```text
GATE_ID=G3CR6R3A_MAGAZINE_VISUAL_REDESIGN
OBJECTIVE=Replace the technical-proof-looking 12-page magazine with a customer-grade static editorial gift design while preserving the accepted content/schema/QA architecture
MAX_ENDPOINT_THIS_ROUND=Reviewer evidence package + Owner-ready before/after visual artifacts
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Local deterministic magazine renderer/templates and synthetic visual-review fixtures only
OWNER_ONLY_ACTIONS=NONE
```

Governance: **vps-project-governance v0.2.6**.

## Accepted facts

- G2BR3 technical content/rendering Solution Proof remains PASS.
- The current magazine visual system is **Owner rejected**.
- The current output is a static 12-page US Letter PDF.
- The three style presets share one deterministic architecture.
- Content AI is allowed to author structured copy, not page geometry.
- No production Provider, payment, WordPress commerce or website-motion work is part of this Gate.

## Design goal

Produce a static magazine that looks credible as a **US$39.99 personalized birthday gift**, not like a renderer demo.

Desired character:
- premium but warm;
- contemporary editorial;
- human/photo-led;
- gift-worthy;
- varied page rhythm;
- emotionally specific;
- cleaner and more sophisticated than the current geometric proof.

Do not imitate a third-party magazine brand.

## Required structural improvement

The redesigned 12 pages must no longer read as repeated “text-left + illustration-right” templates.

Use the existing frozen emotional spine/page map, but create enough visual variety to make the magazine feel intentionally art-directed.

At minimum, the shared architecture should include distinct families for:
- Front Cover;
- Opening Note / Profile;
- Feature Memory two-page story;
- Dynamic Module;
- Why They Matter / quote-led feature;
- Photo Story / Current Era;
- Birthday Letter;
- Back Cover.

Across the 12 pages, demonstrate at least **5 materially distinct composition patterns** while remaining deterministic and reusable.

Appropriate techniques:
- large/full-bleed photo treatments;
- asymmetric editorial grids;
- image-first pages;
- controlled collage;
- pull quotes;
- caption systems;
- overlapping type/image where readable;
- strong whitespace used intentionally;
- paired-page rhythm;
- restrained decorative motifs.

Avoid:
- repetitive identical card layouts;
- clip-art / geometric-placeholder feel;
- tiny body copy floating in large empty pages without purpose;
- every page using the same left-text/right-image split;
- excessive decorative scrapbook styling.

## Photo-fixture requirement

Owner-facing visual review must not be dominated by the old geometric SVG placeholders.

Use a clearly labeled **non-private demo photo fixture** suitable for layout review.

Requirements:
- no real customer/private data;
- provenance recorded;
- representative portrait / everyday-memory / detail / travel-or-place / celebration-style photographs;
- fixture exists only to show how real customer photos would sit in the static layout;
- production renderer must remain source-photo driven and must not depend on generated imagery.

If existing fictional/demo marketing photos are reused, record that they are demo-only and not customer evidence.

## Three preset requirement

Keep the shared architecture and three working visual presets:
- Bold Editorial;
- Soft / Warm;
- Retro / Playful.

Preset differences may include:
- palette;
- typography variables;
- line/frame treatment;
- shape/decorative system;
- image treatment.

They must not become three separate renderers.

Primary Owner review should use the best default candidate, likely **Soft / Warm**, but all three presets must remain technically coherent.

## AI-before / AI-after proof

The redesigned renderer must generate two directly comparable contact sheets:

### BEFORE REAL AI
Input:
- existing human-authored synthetic reference content.

Output:
- 12-page contact sheet using the redesigned static visual system.

### AFTER REAL AI
Input:
- accepted G2BR3 model-authored structured content.

Output:
- 12-page contact sheet using the **same redesigned static visual system**.

The comparison must make it visually obvious that:
- layout/design system is the same;
- AI changes copy/headlines/captions/dynamic modules;
- AI is not secretly redesigning pages.

## Design exploration

Design concept exploration may use:
- image generation;
- multimodal layout ideation;
- reference boards.

But final implementation must be deterministic code/templates.

If image generation is used:
- retain only adopted design references;
- record prompts/role at a high level;
- do not include generated imagery as customer magazine content;
- do not imply generated concept art is the production output.

## Frozen product contracts

Preserve:
- 12-page US Letter PDF;
- fixed emotional spine + 2 dynamic module slots;
- recipient/factual consistency;
- 12–25 source-photo input contract;
- up to 3 must-use photos;
- 10–14 approximate selected-photo target;
- one bounded revision batch;
- no AI-generated imagery in the delivered MVP magazine;
- AI content grounded only in supplied intake;
- deterministic PDF generation and QA.

## Scope not included

Do not modify:
- WordPress homepage;
- website animation;
- Free Preview;
- Woo Product / Cart / Checkout / Account;
- payment;
- account/private workspace;
- entitlement/job semantics;
- production AI/provider;
- database;
- Shared Infra.

G3CR6R3 website motion/Preview work remains HOLD until this Gate passes and Owner accepts the magazine visual direction.

## PREFLIGHT

Before mutation:
- prove canonical Git root and exact branch;
- fresh read-back PR #64 / source state;
- record current G2B renderer/template hashes;
- preserve current G2B/G2BR3 proof artifacts;
- create scoped rollback for magazine-renderer changes;
- confirm no unrelated worktree contamination.

## REQUIRED_EVIDENCE

Owner-review visuals:
1. redesigned BEFORE-AI 12-page contact sheet;
2. redesigned AFTER-AI 12-page contact sheet;
3. redesigned AFTER-AI full 12-page PDF;
4. three preset cover screenshots;
5. at least four representative full-size interior page screenshots;
6. side-by-side or clearly labeled old-vs-new visual comparison.

Machine/architecture:
- page count = 12;
- US Letter dimensions;
- no clipping/overflow;
- no broken/missing images;
- same content schema accepted;
- same page map/emotional spine;
- exactly two supported dynamic modules;
- grounding/QA still pass on G2BR3 model content;
- deterministic renderer still produces stable output for same input;
- three presets still share one renderer/page architecture.

## ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:

1. Owner-review output no longer resembles the current technical proof.
2. Magazine looks plausible as a paid personalized gift.
3. At least five materially distinct composition patterns appear across 12 pages.
4. Photography is the dominant visual material; old geometric-placeholder feel is absent from Owner-facing review.
5. Soft/Warm default looks premium, warm and contemporary.
6. Bold Editorial and Retro/Playful remain coherent variants of the same architecture.
7. Before-AI and After-AI versions clearly show content change without visual-architecture drift.
8. Existing G2BR3 grounding/schema/QA contracts still pass.
9. Static PDF / deterministic renderer / no generated-image delivery boundary remains intact.
10. No website/Woo/payment/backend scope is touched.

## ROLLBACK_STATUS_OR_PLAN

- preserve existing accepted G2B/G2BR3 artifacts unchanged;
- new renderer/template work gets its own scoped rollback;
- on failure, return to existing technical proof renderer without rewriting historical evidence.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:
1. `docs/G3CR6R3A_MAGAZINE_VISUAL_REDESIGN.md`
2. `docs/OWNER_DECISION_G3CR6R3A_MAGAZINE_VISUAL_REDESIGN.md`
3. `docs/MVP_PRODUCT_CONTRACT.md` sections 5–7
4. `docs/REVIEWER_DECISION_G2BR3_PASS.md`
5. `poc/g2b/src/` renderer/provider files actually needed
6. `poc/g2b/artifacts/` and `poc/g2b/artifacts/g2br3/` accepted proof assets needed for before/after regression
7. fresh source/runtime facts required by Preflight

Do not reread broad project history or Governance by default.

Do not work on website motion/Preview in this Gate.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：一句话说明杂志视觉系统、照片 fixture 和 preset 实际改了什么。
验证：一句话总结 before/after-AI、12页PDF、QA/grounding/三preset/确定性回归。
问题：NONE，或具体阻塞点。
回滚：一句话说明 magazine renderer scoped rollback。
请 Reviewer 检查：重点看新杂志是否达到付费礼物级、12页构图是否有足够变化、before/after AI 是否解释清楚。
Owner 转交：NONE
```

Stop at Reviewer.

## Forbidden

```text
WEBSITE_MUTATIONS=0
WORDPRESS_MUTATIONS=0
WOO_MUTATIONS=0
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PR_MERGE=0
G4_ACTIONS=0
```
