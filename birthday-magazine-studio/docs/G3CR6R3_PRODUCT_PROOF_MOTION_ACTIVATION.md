# G3CR6R3 — Final Product Proof + Motion + Preview Activation

## Gate

```text
GATE_ID=G3CR6R3_PRODUCT_PROOF_MOTION_ACTIVATION
OBJECTIVE=Raise the accepted G3CR6R1 frontend from a mostly static 7/10 experience into a persuasive editorial gift experience by showing the real final magazine, adding purposeful motion, and replacing the low-pull upload-first Preview framing
MAX_ENDPOINT_THIS_ROUND=Reviewer evidence package for the bounded frontend experience correction
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Existing local G3C frontend on PR #64
OWNER_ONLY_ACTIONS=NONE
```

Governance: **vps-project-governance v0.2.6**, canonical `VNEXT.md`.

## Accepted facts

- G3CR6R1 = Reviewer PASS.
- Existing PR = #64.
- Accepted frontend head entering this redesign lineage: `15ff73f6232e0ef94f04f313f74372e52389d1e2`.
- Overall Warm Birthday Gift brand direction remains accepted.
- Product = virtual USD 39.99.
- Native Woo commerce/account/private-workspace backend remains protected.
- Free Preview selected images remain browser-local and zero-model.
- Real 12-page G2BR3 magazine proof exists in the repository.

## Supersession

`G3CR6R2_FREE_PREVIEW_ACTIVATION_POLISH` is **SUPERSEDED BEFORE EXECUTION** by this Gate because the Owner's later feedback materially broadened the frontend problem from Preview framing alone to Product Proof + Motion + Activation.

Do not execute G3CR6R2 separately.

## Primary objectives

### A. Show the actual final birthday magazine

The homepage must clearly answer:

> “What am I actually buying?”

Use the accepted G2BR3 real output as the primary truth source:

- `poc/g2b/artifacts/g2br3/proof-magazine-soft-warm.pdf`
- `poc/g2b/artifacts/g2br3/screenshots/12-page-contact-sheet.png`
- representative accepted G2BR3 page screenshots.

Create a prominent final-product showcase such as:
- page-stack;
- page-turn/spread viewer;
- editorial carousel;
- scroll-driven magazine walkthrough;
- equivalent high-quality composition.

The visitor should be able to see several distinct pages / page types, not only one cover.

Do not present generated fake pages as the actual final deliverable.

### B. Add purposeful motion

The homepage should no longer feel mostly static.

Introduce a coherent motion system where it improves the experience, for example:
- Hero magazine entrance / gentle depth motion;
- controlled scroll reveal for editorial sections;
- sample magazine hover/touch tilt or depth;
- page-stack/spread transition in the final-product showcase;
- Preview state transition.

Requirements:
- no gratuitous constant movement;
- no blocking scroll-jacking;
- no major layout shift;
- touch/mobile behavior remains usable;
- support `prefers-reduced-motion`;
- performance must remain reasonable.

The motion language should feel like a premium editorial/gift brand, not a SaaS animation demo.

### C. Replace the low-pull Preview experience

The current “upload photo → instantly show my magazine” framing is not accepted as final.

Reframe so:
1. product value is visible before upload;
2. real magazine proof is already established nearby;
3. personalization is optional;
4. upload is framed as “see how your photo could fit into the magazine experience,” not as the product itself;
5. personalized output preserves cover + interior editorial context;
6. the transition to the complete 12-page US$39.99 product is clear.

The interaction can be redesigned more substantially than G3CR6R2 allowed, as long as the frozen privacy/product contract remains intact.

## Image-generation authorization

Owner authorization for marketing/frontend image generation remains active.

Preferred hierarchy:

1. **Actual G2BR3 rendered pages** for final-product proof.
2. Image generation may create presentation/staging around those real pages.
3. Image generation may create decorative gift/editorial assets.
4. Do not generate materially different magazine pages and imply they are the deliverable.

If image generation is used, record generated/adopted assets and their role.

## Scope allowed

May modify:
- Hero motion/presentation where needed;
- sample section motion;
- new final-magazine showcase;
- Preview section composition/interactions;
- surrounding transition copy;
- section-level motion/reveal system;
- related CSS/JS/frontend assets;
- narrow mobile adaptations.

May not reopen:
- product price;
- 12-page paid scope;
- Woo backend;
- checkout/order/payment semantics;
- account/private workspace;
- entitlement/job semantics;
- DB schema;
- production AI provider;
- overall theme/builder choice.

## Critical constraints

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
WOO_COMMERCE_CANONICAL_ORDER_SYSTEM=YES
REAL_MONEY_ACTIONS=0
PAYPAL_ACTIONS=0
CHECKOUT_SUBMISSIONS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PR_MERGE=0
G4_ACTIONS=0
```

## PREFLIGHT

Before mutation prove:
- canonical Git root;
- existing branch / PR #64 fresh head;
- accepted G3CR6R1 baseline;
- current local runtime;
- current rollback availability;
- protected backend hashes;
- unrelated worktree state;
- G2BR3 actual magazine assets exist and match accepted evidence.

Create a distinct G3CR6R3 rollback point.

## REQUIRED_EVIDENCE

### Visual
- desktop full homepage;
- mobile 375 full homepage;
- Hero motion states / evidence;
- final magazine showcase desktop + mobile;
- representative actual G2BR3 pages visibly used;
- Preview default state;
- Preview personalized state;
- surrounding Free → Paid transition;
- Product page regression;
- at least enough screenshots/video-frame evidence to judge motion endpoints and non-overlap.

### Motion
Provide a concise inventory:
- which elements move;
- trigger;
- duration/easing;
- mobile behavior;
- reduced-motion behavior.

Verify:
- `prefers-reduced-motion` disables/reduces nonessential motion;
- no blocking horizontal overflow;
- no broken interactions;
- no scroll-jacking;
- no persistent distracting motion.

### Preview
- select;
- replace;
- remove;
- invalid MIME;
- corrupt image;
- browser-local blob;
- 0 server photo uploads;
- 0 external image POSTs;
- 0 model requests.

### Regression
- product remains virtual USD 39.99;
- native Woo path unaffected;
- Checkout not submitted;
- order count unchanged;
- Owner editability not reduced;
- protected backend hashes unchanged.

## ACCEPTANCE_CRITERIA

PASS requires all:

1. Visitor can clearly see what the final 12-page magazine looks like.
2. Final-product proof is grounded in actual accepted G2BR3 rendered output.
3. Homepage has purposeful, visible motion and no longer reads as mostly static.
4. Motion feels coherent/premium and respects reduced-motion/accessibility.
5. Preview no longer feels primarily like a low-value cover generator.
6. Personalization is optional and strengthens the magazine proposition.
7. Free → complete 12-page US$39.99 boundary is clear.
8. Preview privacy/network contract remains intact.
9. Protected backend remains unchanged.
10. Desktop + mobile remain usable.
11. No unrelated architecture/product-scope expansion.

## ROLLBACK_STATUS_OR_PLAN

- rollback target: accepted G3CR6R1 state;
- create new scoped G3CR6R3 rollback before write;
- preserve all prior recovery artifacts.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. `docs/G3CR6R3_PRODUCT_PROOF_MOTION_ACTIVATION.md`
2. `docs/REVIEWER_DECISION_G3CR6R1_PASS.md`
3. `docs/OWNER_DECISION_G3CR6R3_MOTION_PRODUCT_PROOF.md`
4. `poc/g2b/artifacts/g2br3/` actual accepted product-proof assets needed for this Gate
5. target Home/Preview/frontend source files
6. fresh PR/runtime/source facts required by Preflight

Do **not** broadly reread Governance, Handoff or historical Gates. This Gate already carries the applicable constraints.

Continue existing PR #64. Do not create or merge another PR.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：一句话说明最终产品展示、动效和 Preview 实际改了什么。
验证：一句话总结真实杂志素材、动效/降级、Preview 隐私和 Woo 回归；详细证据写入 EXECUTION_EVIDENCE。
问题：NONE，或具体阻塞点。
回滚：一句话说明 scoped rollback。
请 Reviewer 检查：最终产品展示是否真实、页面是否真正有动感、Preview 是否更有购买欲、移动端/隐私/后台是否保持。
Owner 转交：NONE
```

Stop at Reviewer.

## Forbidden

```text
PR_MERGE=0
THEME_CHANGE=0
BUILDER_CHANGE=0
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
CHECKOUT_SUBMISSIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
G4_ACTIONS=0
```
