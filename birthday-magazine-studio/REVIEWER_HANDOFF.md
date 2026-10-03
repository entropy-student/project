# Birthday Magazine Studio — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance: **vps-project-governance v0.2.6**  
> Canonical operational rules: `spike.skill/vps-project-governance/VNEXT.md`  
> External operational addenda: NONE  
> Last reviewed: 2026-10-03

## PROJECT_GOAL

US-first personalized birthday magazine:
- buyer provides photos + structured answers;
- product delivers a polished personalized **12-page digital PDF**;
- buyer does not need to write or design the magazine manually.

Frozen MVP:
- English first;
- digital PDF;
- test price **US$39.99**;
- browser-local zero-model free Preview;
- authenticated customer account;
- WooCommerce canonical commerce/order system;
- paid + intake complete is required before one canonical generation-ready job;
- one bounded revision batch;
- source/intermediate deletion within 24h after final delivery/approval; final PDF retained 72h;
- physical print deferred.

## PROJECT_STAGE

```text
TECHNICAL_SOLUTION_PROOF=PASS
WOOCOMMERCE_ACCOUNT_PRIVATE_WORKSPACE=PASS
PAYPAL_SANDBOX_LIFECYCLE=PASS
FRONTEND_COMPOSITION_G3CR6R1=PASS
OWNER_OVERALL_VISUAL_DIRECTION=BROADLY_ACCEPTED
CURRENT_GATE=G3CR6R3_PRODUCT_PROOF_MOTION_ACTIVATION
OWNER_VISUAL_FREEZE=PENDING
REAL_MONEY_TRANSACTION=UNVERIFIED
REAL_CUSTOMER_ACQUISITION=UNVERIFIED
REPEATABILITY=UNKNOWN
ECONOMICS=UNKNOWN
COMMERCIAL_STATE=LOW_COST_VALIDATION_NOT_SCALE
G4_LIVE_PAYPAL=HOLD_NOT_AUTHORIZED
```

## SYSTEM_MAP

- CMS/storefront: WordPress 7.1.1 + Blocksy 2.1.57 + Gutenberg.
- Commerce/order: WooCommerce 11.1.2, canonical.
- Current local G3C runtime: project-isolated Docker/MariaDB/Mailpit; retained for Owner/Reviewer frontend review.
- Current local site: `http://127.0.0.1:8189/`.
- Current wp-admin: `http://127.0.0.1:8189/wp-admin/`.
- Product: Woo product 1113, virtual, USD 39.99.
- Free Preview: project-local frontend component; selected photo remains browser-local; no server photo upload and no model request.
- Account/private workspace: authenticated account + Woo order ownership.
- Payment baseline: official WooCommerce PayPal Payments; Sandbox proof accepted. Live/real-money not proven.
- Paid generation: exact production provider/runtime remains UNKNOWN.
- Production deployment/storage/private final delivery: UNKNOWN / not yet proven.
- Shared VPS dependency: NONE accepted for current Gate.

## CURRENT_ACCEPTED_STATE

- G2BR3: real-AI structured content + deterministic 12-page PDF Solution Proof PASS.
- G3A: WordPress/WooCommerce commerce/account/private-workspace loop PASS.
- G3B/G3BR1: bounded PayPal Sandbox capture/entitlement/refund/revocation/cleanup PASS.
- G3CR2R3: Blocksy Wedding Gutenberg + Woo compatibility PASS.
- G3CR4/G3CR5: earlier frontend regressions PASS at their tested scope.
- G3CR6: RETURN because the visual direction was underexecuted.
- G3CR6R1: PASS; Warm Birthday Gift composition, Preview privacy, native Woo path, 375px behavior, and Owner editability accepted.
- Owner Visual Checkpoint R2: resolved; Owner broadly accepts the overall composition but now explicitly rates the homepage around 7/10 for the intended quality bar, wants meaningful motion, wants the actual final magazine shown clearly, and rates the current upload-first Preview around 5/10.
- Owner editability at G3CR6R1 evidence scope: Administrator, edit Home, replace media, edit copy, reorder eight major Gutenberg Groups, edit Blocksy global style/palette; footer is editable WordPress block.
- PR #64 remains open/unmerged at accepted execution head `15ff73f6232e0ef94f04f313f74372e52389d1e2`.

## CURRENT_GATE

`G3CR6R3_PRODUCT_PROOF_MOTION_ACTIVATION`

Objective:
- show the real final magazine clearly;
- add purposeful editorial motion so the homepage is not mostly static;
- redesign the low-pull upload-first Preview so the experience creates stronger purchase desire.

Scope:
- real G2BR3 final-product showcase;
- bounded homepage motion system;
- Preview composition/interactions;
- optional personalization framing;
- Free → complete 12-page US$39.99 transition;
- related Hero/sample/mobile motion/presentation where needed.

Not reopened:
- overall site composition;
- theme/builder;
- Product/Cart/Checkout/Account architecture;
- Woo backend;
- payment;
- account/private-workspace model;
- frozen MVP product contract;
- production AI/provider.

Current Gate file:
- `docs/G3CR6R3_PRODUCT_PROOF_MOTION_ACTIVATION.md`

Current growth diagnosis:
- `docs/GROWTH_VALIDATION_STATE_2026-10-03.md`

## CRITICAL_CONSTRAINTS

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
WOO_COMMERCE_CANONICAL_ORDER_SYSTEM=YES
AUTHENTICATED_ACCOUNT_MVP=YES
GUEST_BEARER_PRIVATE_DELIVERY=NO
REAL_MONEY_ACTIONS=0
PAYPAL_ACTIONS_CURRENT_GATE=0
CHECKOUT_SUBMISSIONS_CURRENT_GATE=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PR_64_MERGE=0
G4_ACTIONS=0
```

Protected backend behavior for G3CR6R2:
- Woo cart/order/checkout business logic;
- payment gateway;
- order state;
- account authorization;
- private-workspace ownership guard;
- entitlement/generation-job semantics;
- database schema;
- production provider.

## DEFAULT_EXECUTION_CHANNEL

- Executor works in the existing local G3C project workspace / branch and updates **existing PR #64**.
- No new PR by default.
- No production/target-host execution in G3CR6R2.

## CURRENT_ROLLBACK_STATUS

- Accepted rollback target: G3CR6R1 state.
- Prior G3CR6/G3CR6R1 rollback evidence must not be overwritten.
- G3CR6R2 is superseded before execution.
- G3CR6R3 must create its own scoped rollback point before mutation.
- Git history remains the source-code recovery baseline.

## UNRESOLVED

- exact buyer segment within the broader US birthday-gift market;
- durable archive of Owner-reported Problem Evidence/VOC;
- real US customer payment at USD 39.99;
- repeatable acquisition;
- CAC/contribution economics;
- real per-order production AI/render/storage cost;
- unattended production provider/runtime and provider-spend idempotency;
- production storage/private delivery/recovery;
- production refund/cancellation policy;
- final visual freeze after G3CR6R2.

## NEXT_STEP

1. Execute **G3CR6R3** only.
2. Reviewer inspects actual-final-product proof, motion behavior, Preview purchase-pull, mobile/accessibility and protected-boundary evidence.
3. Owner performs final visual/experience checkpoint.
4. After visual freeze, stop general polishing and move toward the real-behavior validation path; Live/payment remains a separate Owner-authorized Gate.

## OWNER_ACTION_REQUIRED

`NONE` for G3CR6R3 execution.

Owner action is required later for:
- final subjective visual freeze;
- any real payment/Live provider action;
- account/Secret/provider authorization;
- production enablement.

## EVIDENCE_POINTERS

Current working set:
1. `docs/MVP_PRODUCT_CONTRACT.md`
2. `docs/REVIEWER_DECISION_G3CR6R1_PASS.md`
3. `docs/G3C_OWNER_VISUAL_CHECKPOINT_R2.md`
4. `docs/OWNER_DECISION_G3CR6R3_MOTION_PRODUCT_PROOF.md`
5. `docs/REVIEWER_DECISION_G3CR6R3_EXPERIENCE_REVIEW.md`
6. `docs/G3CR6R3_PRODUCT_PROOF_MOTION_ACTIVATION.md`
7. `docs/GROWTH_VALIDATION_STATE_2026-10-03.md`
7. `EXECUTION_EVIDENCE.md` — accepted execution proof/history
8. `EXECUTOR_HANDOFF.md` — latest Executor facts when current Gate executes

Historical decisions remain in `docs/` and `DOCUMENT_INDEX.md`; they are provenance, not the current dashboard.
