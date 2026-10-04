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
CURRENT_GATE=G3CR6R3D1R2_LOCAL_HOMEPAGE_READBACK_CLOSURE
SOURCE_BASELINE_PREFLIGHT=PASS
TEMPLATE_RESEARCH_QUALITY_BAR=OWNER_APPROVED
TEMPLATE_RESEARCH_CONTRACT=MANDATORY
MAGAZINE_WEB_VIEWER_DIRECTION=CONFIRMED_MAGAZINE_WEB_VIEWER
HOMEPAGE_FOCUSLY=AUTHORIZED_PUBLIC_VISUAL_REFERENCE
HOMEPAGE_HIGH_FIDELITY_REIMPLEMENTATION=AUTHORIZED_AFTER_D1_REVIEWER_PASS
HOMEPAGE_IMPLEMENTATION_STATUS=HOLD_PENDING_D1R2_REVIEWER_PASS
G3CR6R3C_RESEARCH_STATUS=PAUSED_FOR_OWNER_REPRIORITIZED_HOMEPAGE_GATE
CURRENT_UPLOAD_PREVIEW=KEEP_AS_IS
PREVIEW_INTERACTION_CHANGE=HOLD
CORE_AHA_INTERACTION_DIRECTION=UNRESOLVED
CORE_AHA_EXACT_PRESENTATION=UNRESOLVED
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

`G3CR6R3D1R2_LOCAL_HOMEPAGE_READBACK_CLOSURE`

The Owner has reprioritized the Focusly-inspired homepage while explicitly placing upload/Preview interaction changes on hold.

Objective:
- reuse the already-captured Focusly public visual/motion evidence without replay;
- close only the fresh readback blocker for the current retained local Birthday Magazine homepage;
- prove the exact current homepage/template/menu/CTA/Preview surface before implementation;
- provide the final precondition for a bounded homepage-only D2 implementation Gate.

Scope:
- bounded availability of the existing retained local runtime + read-only current-site inspection + project documentation;
- no homepage or Preview implementation;
- no Preview benchmark research;
- no paid template purchase;
- no build/pull/recreate/volume reset/migration/global Docker configuration or cleanup.

Mandatory stop:
- Reviewer must PASS D1R2 before D2 homepage implementation opens.

Frozen during this Gate:
- existing upload/Preview interaction and privacy behavior;
- Product/Cart/Checkout/Order semantics;
- Woo backend/payment;
- account/private-workspace and entitlement logic;
- prices/currency/product identity;
- unresolved core Aha interaction;
- P1-P12 magazine visual selection.

Preserved:
- Focusly public observation + mapping from D1 remain reusable evidence.
- `magazine-web-viewer` remains the accepted reader direction.
- G3CR6R3C remains unresolved for core interaction and P1-P12, but is paused while the Owner-prioritized homepage Gate runs.

Current Gate file:
- `docs/G3CR6R3D1R2_LOCAL_HOMEPAGE_READBACK_CLOSURE.md`

Current Reviewer decision:
- `docs/REVIEWER_DECISION_G3CR6R3D1_RETURN_SCOPE_RECONCILIATION_2026-10-04.md`

Latest Owner decision:
- `docs/OWNER_DECISION_G3CR6R3D_PREVIEW_INTERACTION_HOLD_2026-10-04.md`

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

1. Execute **G3CR6R3D1R2**: reuse the accepted Focusly evidence and close only the fresh current-local-homepage readback blocker.
2. Reviewer checks the fresh Home/runtime/template/menu/CTA/Preview readback and exact D2 mutation boundary.
3. If D1R2 PASS, open **G3CR6R3D2** for bounded Focusly-inspired homepage visual implementation while keeping the existing upload/Preview interaction unchanged.
4. After homepage visual work reaches Owner review, resume the unresolved core Aha interaction and P1-P12 visual research separately.

## OWNER_ACTION_REQUIRED

`NONE` by default for G3CR6R3D1R2. If Docker Desktop requires GUI/elevation/login/update/install action that the Executor cannot safely perform, Executor returns the smallest exact Owner runtime-start action.

Owner action is required later for:
- final subjective visual freeze;
- any future decision to reopen/change the upload/Preview interaction;
- any real payment/Live provider action;
- account/Secret/provider authorization;
- production enablement.

## EVIDENCE_POINTERS

Current working set:
1. `docs/OWNER_DECISION_G3CR6R3D_PREVIEW_INTERACTION_HOLD_2026-10-04.md`
2. `docs/REVIEWER_DECISION_G3CR6R3D1_RETURN_SCOPE_RECONCILIATION_2026-10-04.md`
3. `docs/G3CR6R3D1R2_LOCAL_HOMEPAGE_READBACK_CLOSURE.md`
4. `docs/G3CR6R3D1_FOCUSLY_VISUAL_MAPPING_REPORT.md`
5. `docs/evidence/g3cr6r3d1/`
6. `docs/OWNER_DECISION_G3CR6R3D_FOCUSLY_HOMEPAGE_REDESIGN.md` — homepage direction; its earlier Preview-update subsection is superseded by the latest Owner hold
7. `docs/REVIEWER_DECISION_G3CR6R3D1_RETURN_LOCAL_HOMEPAGE.md` — earlier D1 return provenance
8. `docs/G3CR6R3D1R1_RUNTIME_AND_PREVIEW_BENCHMARK_CLOSURE.md` — superseded before execution
9. `docs/REVIEWER_DECISION_G3CR6R1_PASS.md` — accepted homepage/runtime functional baseline
10. `docs/G3CR6R3C_TEMPLATE_SOURCE_DISCOVERY.md` — paused unresolved core interaction + P1-P12 research
11. `EXECUTION_EVIDENCE.md` — execution proof/history
12. `EXECUTOR_HANDOFF.md` — latest Executor facts

Historical decisions remain in `docs/` and `DOCUMENT_INDEX.md`; they are provenance, not the current dashboard.
