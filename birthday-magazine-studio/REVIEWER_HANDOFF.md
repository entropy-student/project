# Birthday Magazine Studio — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance: **vps-project-governance v0.2.6**  
> Canonical operational rules: `spike.skill/vps-project-governance/VNEXT.md`  
> External operational addenda: NONE  
> Last reviewed: 2026-10-04

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
OWNER_OVERALL_VISUAL_DIRECTION=PARTIAL_ONLY
CURRENT_GATE=G3CR6R3D1_FOCUSLY_VISUAL_MAPPING
SOURCE_BASELINE_PREFLIGHT=PASS
TEMPLATE_RESEARCH_QUALITY_BAR=OWNER_APPROVED
TEMPLATE_RESEARCH_CONTRACT=MANDATORY
MAGAZINE_WEB_VIEWER_DIRECTION=CONFIRMED_MAGAZINE_WEB_VIEWER
HOMEPAGE_FOCUSLY=AUTHORIZED_PUBLIC_VISUAL_REFERENCE
HOMEPAGE_HIGH_FIDELITY_REIMPLEMENTATION=AUTHORIZED_AFTER_D1_REVIEWER_PASS
HOMEPAGE_IMPLEMENTATION_STATUS=HOLD_PENDING_D1_REVIEWER_PASS
G3CR6R3C_RESEARCH_STATUS=PAUSED_FOR_OWNER_REPRIORITIZED_HOMEPAGE_GATE
CORE_AHA_INTERACTION=UNRESOLVED_RESEARCH_AGAIN
MAGAZINE_P1_P12_VISUAL_SYSTEM=UNRESOLVED_RESEARCH_AGAIN
PRIOR_G3CR6R3C_SATURATION=SUPERSEDED_FOR_INTERACTION_AND_P1_P12
MAGAZINE_WEB_PAGE_MOTION_MODE=UNRESOLVED
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
- Fresh 2026-10-04 source-baseline closure: reconciliation anchor `83a8ad33ed70e2a391e4a4dacd71e0b812b15ef6` proved the bounded merge strategy and preserved the prior 7 G3C/G3CR6R1 branch commits/evidence. A later Executor correctly returned when unrelated `vpn-network-optimization/` commits moved repository `main`; Reviewer confirmed this was **not Birthday Magazine project drift** and corrected the preflight to project-scoped freshness. The approved PR #64 execution head must descend from the anchor and contain all current-main changes affecting `birthday-magazine-studio/**` or another path explicitly named by the Gate; unrelated monorepo commits do not block.

## CURRENT_GATE

`G3CR6R3D1_FOCUSLY_VISUAL_MAPPING`

The Owner has reprioritized the homepage before the unresolved core-interaction and P1-P12 research.

Objective:
- directly inspect the public Focusly homepage and its actual motion/responsive behavior;
- inventory the current Birthday Magazine homepage, assets and protected functional boundaries;
- produce a one-to-one Focusly -> current-homepage mapping that a later implementation Gate can execute safely;
- maximize public-reference visual fidelity through independent implementation, without copying the paid template source or proprietary assets.

Scope:
- read-only reference/browser inspection and project documentation only;
- no WordPress/source/CSS/JS/media/database/runtime mutation in D1;
- no paid template purchase;
- existing project-owned images may be reused;
- design-time static image generation may be proposed only within existing authorized capability and without introducing a new external paid provider/account/Secret.

Mandatory stop:
- Reviewer must PASS the mapping before D2 implementation opens.

Frozen during this Gate:
- Free Preview privacy and zero-model runtime contract;
- Product/Cart/Checkout/Order semantics;
- Woo backend/payment;
- account/private-workspace and entitlement logic;
- prices/currency/product identity;
- core Aha interaction selection;
- P1-P12 magazine visual selection.

Preserved:
- `magazine-web-viewer` remains the accepted reader direction.
- G3CR6R3C remains unresolved for core interaction and P1-P12, but is paused while the Owner-prioritized homepage Gate runs.

Current Gate file:
- `docs/G3CR6R3D1_FOCUSLY_VISUAL_MAPPING.md`

Current Owner decision:
- `docs/OWNER_DECISION_G3CR6R3D_FOCUSLY_HOMEPAGE_REDESIGN.md`

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

Protected backend behavior for the current visual/research phase:
- Woo cart/order/checkout business logic;
- payment gateway;
- order state;
- account authorization;
- private-workspace ownership guard;
- entitlement/generation-job semantics;
- database schema;
- production provider.

## DEFAULT_EXECUTION_CHANNEL

- Canonical research/Gate authority is current GitHub `main`.
- Existing PR #64 branch is the **approved G3CR6R3C execution baseline** after source reconciliation; Executor should use the current branch head and current Gate/relay, not reconstruct project history.
- Freshness is **project-scoped**: current-main-only changes under `birthday-magazine-studio/**` (or another path explicitly named by this Gate) block execution; unrelated commits elsewhere in the shared monorepo do not.
- Research writes remain project-scoped to `birthday-magazine-studio/`; the 7 historical G3C/G3CR6R1 branch commits/evidence remain preserved.
- No new PR by default. No production/target-host execution in G3CR6R3C.

## CURRENT_ROLLBACK_STATUS

- Accepted rollback target: G3CR6R1 state.
- Prior G3CR6/G3CR6R1 rollback evidence must not be overwritten.
- G3CR6R2 is superseded before execution.
- G3CR6R3 must create its own scoped rollback point before mutation.
- Git history remains the source-code recovery baseline.
- PR #64 branch-only G3C/G3CR6R1 evidence is a preservation requirement during source-baseline repair; do not reset/drop it merely to match `main`.

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
- final visual freeze after template selection and the subsequent bounded implementation/review;
- final visual freeze after template research/selection remains pending; source/branch packaging for G3CR6R3C is resolved.

## NEXT_STEP

1. Execute **G3CR6R3D1** read-only: directly inspect Focusly desktop/mobile/motion behavior and map it onto the current Birthday Magazine homepage.
2. Reviewer checks the mapping, asset plan and frozen functional boundaries.
3. If D1 PASS, open **G3CR6R3D2** for bounded homepage implementation and regression proof.
4. After homepage visual work reaches Owner review, resume the still-unresolved core Aha interaction and P1-P12 research under G3CR6R3C.

## OWNER_ACTION_REQUIRED

`NONE` for G3CR6R3D1; Owner already authorized Focusly-based independent homepage visual reconstruction within the frozen functional boundary.

Owner action is required later for:
- final subjective visual freeze;
- any real payment/Live provider action;
- account/Secret/provider authorization;
- production enablement.

## EVIDENCE_POINTERS

Current working set:
1. `docs/OWNER_DECISION_G3CR6R3D_FOCUSLY_HOMEPAGE_REDESIGN.md`
2. `docs/G3CR6R3D1_FOCUSLY_VISUAL_MAPPING.md`
3. `docs/OWNER_DECISION_G3CR6R3C_RESEARCH_RESET_2026-10-04.md`
2. `docs/REVIEWER_DECISION_G3CR6R3C_PROJECT_SCOPED_PREFLIGHT_FIX.md`
2. `docs/REVIEWER_DECISION_G3CR6R3C_SOURCE_BASELINE_PASS.md`
3. `docs/REVIEWER_DECISION_G3CR6R3C_TAKEOVER_SOURCE_BASELINE.md` — superseded preflight RETURN provenance
2. `docs/MVP_PRODUCT_CONTRACT.md`
2. `docs/REVIEWER_DECISION_G3CR6R1_PASS.md`
3. `docs/G3C_OWNER_VISUAL_CHECKPOINT_R2.md`
4. `docs/OWNER_DECISION_G3CR6R3_MOTION_PRODUCT_PROOF.md`
5. `docs/REVIEWER_DECISION_G3CR6R3_EXPERIENCE_REVIEW.md`
6. `docs/OWNER_DECISION_G3CR6R3C_TEMPLATE_FIRST_VISUAL_SOURCING.md`
7. `docs/G3CR6R3C_TEMPLATE_SOURCE_DISCOVERY.md`
8. `docs/OWNER_DECISION_G3CR6R3C_TEMPLATE_RESEARCH_QUALITY_BAR.md`
9. `docs/G3CR6R3C_TEMPLATE_DISCOVERY_RESEARCH_CONTRACT.md`
8. `docs/OWNER_DECISION_G3CR6R3B_VISUAL_MOTION_LAB.md` — superseded provenance
9. `docs/G3CR6R3B_VISUAL_MOTION_LAB.md` — superseded before execution
8. `docs/OWNER_DECISION_G3CR6R3A_MAGAZINE_VISUAL_REDESIGN.md` — superseded full-build decision provenance
9. `docs/G3CR6R3A_MAGAZINE_VISUAL_REDESIGN.md` — superseded before execution
10. `docs/G3CR6R3_PRODUCT_PROOF_MOTION_ACTIVATION.md` — prepared/hold after lab + magazine visual selection
9. `docs/GROWTH_VALIDATION_STATE_2026-10-03.md`
7. `EXECUTION_EVIDENCE.md` — accepted execution proof/history
8. `EXECUTOR_HANDOFF.md` — latest Executor facts when current Gate executes

Historical decisions remain in `docs/` and `DOCUMENT_INDEX.md`; they are provenance, not the current dashboard.
