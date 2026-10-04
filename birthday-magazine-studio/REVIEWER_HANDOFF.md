# Birthday Magazine Studio — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance: **vps-project-governance v0.2.7**  
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
- complete pre-payment intake + paid entitlement are both required before one canonical generation-ready job;
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
CURRENT_GATE=G3CR7R1R1_EVIDENCE_AND_CLEAN_SOURCE_REPAIR
SOURCE_BASELINE_PREFLIGHT=PASS
TEMPLATE_RESEARCH_QUALITY_BAR=OWNER_APPROVED
TEMPLATE_RESEARCH_CONTRACT=MANDATORY
MAGAZINE_WEB_VIEWER_DIRECTION=CONFIRMED_MAGAZINE_WEB_VIEWER
HOMEPAGE_FOCUSLY=AUTHORIZED_PUBLIC_VISUAL_REFERENCE
HOMEPAGE_HIGH_FIDELITY_REIMPLEMENTATION=AUTHORIZED_AFTER_D1_REVIEWER_PASS
HOMEPAGE_IMPLEMENTATION_STATUS=OWNER_ACCEPTED_WITH_RESERVED_CORE_ENTRY
D2_DESIGN_TIME_IMAGE_GENERATION=AUTHORIZED_QUALITY_FIRST
D2_ARTIFICIAL_LOW_IMAGEGEN_CAP=NONE
D2_TECHNICAL_REVIEW=PASS
D2_VISUAL_FIDELITY_REVIEW=PASS
D2_VISUAL_REVIEW_TRANSPORT=OWNER_MANUAL_IMAGE_UPLOAD
D2R1_OWNER_VISUAL_RELAY=FULFILLED
D2R2_REVIEWER_DECISION=PASS_STATIC_VISUAL_AND_TECHNICAL
D2R3_MOTION_DIAGNOSTIC=PASS
D2R3_ROOT_CAUSE=MOTION_RUNNING_BUT_NOT_PERCEPTIBLE
D2R4_AUTOMATED_REVIEW=PASS
D2R4_OWNER_LIVE_MOTION=PASS_OWNER_REPORTED
OWNER_RUNTIME_MOTION=PASS
OWNER_HOMEPAGE_VISUAL_FREEZE=PASS_WITH_CORE_ENTRY_RESERVED
D2_FORMAL_VISUAL_DECISION=PASS_G3CR6R3D2R2
G3CR6R3C_RESEARCH_STATUS=PARTIAL_CORE_AHA_RESEARCH_PASS_P1_P12_PENDING
CURRENT_UPLOAD_PREVIEW=KEEP_AS_IS
PREVIEW_INTERACTION_CHANGE=HOLD
CORE_AHA_INTERACTION_DIRECTION=REVIEWER_RECOMMENDS_PHOTO_TO_ISSUE_MORPH
CORE_AHA_EXACT_PRESENTATION=PHOTO_TO_COVER_TO_FIRST_SPREAD
CORE_AHA_RESEARCH=PASS
CORE_AHA_RESEARCH_CANDIDATES=82
CORE_AHA_SOURCE_ECOSYSTEMS=8
CORE_AHA_SATURATION=PASS
CORE_AHA_OWNER_SELECTION=PENDING
MAGAZINE_P1_P12_VISUAL_SYSTEM=UNRESOLVED_RESEARCH_AGAIN
PRIOR_G3CR6R3C_SATURATION=SUPERSEDED_FOR_INTERACTION_AND_P1_P12
MAGAZINE_WEB_PAGE_MOTION_MODE=UNRESOLVED
OWNER_VISUAL_FREEZE=HOMEPAGE_PASS_PRODUCT_VISUAL_PENDING
REAL_MONEY_TRANSACTION=UNVERIFIED
REAL_CUSTOMER_ACQUISITION=UNVERIFIED
REPEATABILITY=UNKNOWN
ECONOMICS=UNKNOWN
CUSTOMER_FLOW=HOMEPAGE_FREE_PREVIEW_CORE_FUNCTION_SUBMIT_PAY_GENERATE_VIEW
CORE_FUNCTION_PAGE=REQUIRED_PREPAYMENT_FULL_INTAKE_SURFACE
PREPAYMENT_FULL_INTAKE=OWNER_APPROVED
PREPAYMENT_DRAFT_STORAGE=REQUIRED_TEMPORARY_SERVER_DRAFT
PREPAYMENT_DRAFT_TTL=UNRESOLVED_IMPLEMENTATION_DETAIL
PAYMENT_AFTER_COMPLETE_INTAKE=YES
GENERATION_ONLY_AFTER_PAID_ENTITLEMENT=YES
FRONTEND_THREE_SURFACES=AUTHORIZED
HOMEPAGE_ENTRY_SURFACE=EXECUTOR_CANDIDATE_RUNTIME_PASS_OWNER_PENDING
CORE_FUNCTION_ONBOARDING_SURFACE=EXECUTOR_CANDIDATE_RUNTIME_PASS
POSTPAY_GENERATION_STATUS_SURFACE=PARTIAL_FIXTURE_ONLY_ORDER_RECEIVED_PENDING
P1_P12_VISUAL_WORK=DEFERRED_UNTIL_FRONTEND_THREE_SURFACES_CLOSE
G3CR7_SOURCE_CANDIDATE=REFERENCE_ONLY_NONAUTHORITATIVE
G3CR7_REFERENCE_PROTOTYPE_SOURCE_HEAD=0603706ca0441fb1cb65ff716f47f7a919e2e4f3
G3CR7_ACCEPTED_REPRODUCTION_BASELINE=e71f94377d341a88ba388f2c5da153e7cd6ee8b8
G3CR7_PAYMENT_TRUTH_REVIEW=INVALIDATED_ROLE_SEPARATION
G3CR7_PREVIEW_STYLE_HANDOFF=INVALIDATED_ROLE_SEPARATION
G3CR7_RUNTIME_VISUAL=UNVERIFIED
G3CR7_OWNER_VISUAL=PENDING
G3CR7R1_EXECUTOR_HEAD=88f45f5d712e3c1fe26f4386628703716b8eca3e
G3CR7R1_REVIEW=RETURN_EVIDENCE_INTEGRATION
G3CR7R1_CLEAN_SOURCE_DIFF=RETURN
G3CR7R1_WOO_ORDER_RECEIVED_POSITIVE=RETURN
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
- Free Preview: project-local frontend component; its optional selected photo remains browser-local; no Preview server photo upload and no model request.
- Core function page: separate pre-payment full-intake surface; 12–25 photos + structured answers are stored as a temporary server draft before checkout, with no generation/model entitlement.
- Account/private workspace: checkout creates/attaches authenticated customer + Woo order ownership; successful payment adopts the exact submitted pre-payment intake snapshot into that order/workspace.
- Payment baseline: official WooCommerce PayPal Payments; Sandbox proof accepted. Live/real-money not proven.
- Paid generation: exact production provider/runtime remains UNKNOWN.
- Production deployment/storage/private final delivery: UNKNOWN / not yet proven.
- Shared VPS dependency: NONE accepted for current Gate.

## CURRENT_ACCEPTED_STATE

- **Owner flow correction 2026-10-04:** canonical flow is **Homepage -> Free Preview -> Core function page -> full intake -> Submit -> Payment -> automatic generation -> complete result**. The free Preview remains browser-local/zero-model; the separate core function page may upload/store the complete 12–25 photo + answer draft before payment. Payment still gates all production generation. This supersedes the earlier “paid intake after checkout” wording.

- G2BR3: real-AI structured content + deterministic 12-page PDF Solution Proof PASS.
- G3A: WordPress/WooCommerce commerce/account/private-workspace loop PASS.
- G3B/G3BR1: bounded PayPal Sandbox capture/entitlement/refund/revocation/cleanup PASS.
- G3CR2R3: Blocksy Wedding Gutenberg + Woo compatibility PASS.
- G3CR4/G3CR5: earlier frontend regressions PASS at their tested scope.
- G3CR6: RETURN because the visual direction was underexecuted.
- G3CR6R1: PASS; Warm Birthday Gift composition, Preview privacy, native Woo path, 375px behavior, and Owner editability accepted.
- G3CR6R3D1: RETURN only on fresh local-runtime readback; Focusly public desktop/375/motion evidence and 66 screenshots preserved as reusable evidence.
- G3CR6R3D1R2: PASS; fresh Home 858/runtime/theme/menu/CTA/Preview and read-only Woo route baseline closed at Executor commit `7a0a16cf0169980443f8bb760f7f9e919ff0d68c`.
- G3CR6R3D2: technical acceptance PASS; D2R1 direct visual review identified bounded quality gaps.
- G3CR6R3D2R2: PASS; Owner-uploaded R2 contact sheet was directly inspected. Samples/Selected Work, image diversity, mobile header and mobile rhythm now meet the Reviewer quality bar while accepted Hero/editorial panel/closing/Preview/Woo behavior remains preserved.
- G3CR6R3D2R4: **PASS** at latest PR #64 candidate `f50cc974ead65c9811f952cdf0a327c548f14efc`. Reviewer inspected the Owner-video calibration, dual-image Hero focus, expanded Hero travel, source correlation, 1440/375 multi-state QA and scoped rollback. Owner then reported that the homepage is now essentially satisfactory and authorized moving to the next stage. Homepage structure/visual/motion is frozen except for a future **bounded core-experience entry integration**.
- Owner Visual Checkpoint R2: resolved; Owner broadly accepts the overall composition but now explicitly rates the homepage around 7/10 for the intended quality bar, wants meaningful motion, wants the actual final magazine shown clearly, and rates the current upload-first Preview around 5/10.
- Owner editability at G3CR6R1 evidence scope: Administrator, edit Home, replace media, edit copy, reorder eight major Gutenberg Groups, edit Blocksy global style/palette; footer is editable WordPress block.
- PR #64 remains open/unmerged; latest accepted D1R2 evidence commit is `7a0a16cf0169980443f8bb760f7f9e919ff0d68c`. Project-scoped freshness, not whole-monorepo tip ancestry, controls execution.
- Fresh 2026-10-04 source-baseline closure: reconciliation anchor `83a8ad33ed70e2a391e4a4dacd71e0b812b15ef6` proved the bounded merge strategy and preserved the prior 7 G3C/G3CR6R1 branch commits/evidence. A later Executor correctly returned when unrelated `vpn-network-optimization/` commits moved repository `main`; Reviewer confirmed this was **not Birthday Magazine project drift** and corrected the preflight to project-scoped freshness. The approved PR #64 execution head must descend from the anchor and contain all current-main changes affecting `birthday-magazine-studio/**` or another path explicitly named by the Gate; unrelated monorepo commits do not block.

## CURRENT_GATE

`G3CR7R1R1_EVIDENCE_AND_CLEAN_SOURCE_REPAIR`

G3CR7R1 independent reproduction at `88f45f5d712e3c1fe26f4386628703716b8eca3e` passed baseline, frontend runtime, Preview privacy, checkout handoff, and payment-query negative review, but formal PASS is RETURNed on two narrow evidence/source-boundary issues.

Current repair Gate:
- `docs/G3CR7R1R1_EVIDENCE_AND_CLEAN_SOURCE_REPAIR.md`

Current Reviewer decision:
- `docs/REVIEWER_DECISION_G3CR7R1_RETURN_EVIDENCE_INTEGRATION.md`

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
HOMEPAGE_GLOBAL_REDESIGN=0
HOMEPAGE_ONLY_RESERVED_CHANGE=CORE_AHA_ENTRY_COMPATIBILITY_AFTER_REVIEW
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

1. Executor runs `G3CR7R1R1_EVIDENCE_AND_CLEAN_SOURCE_REPAIR`; do not redesign or replay already-passed intake/Preview checks.
2. Remove the six unused Reviewer-reference prototype files from the final plugin tree and regenerate a complete diff from `e71f943...`.
3. Use a local non-consequential Woo order fixture to capture the **actual order-received route** with the BMS pending continuation at 1440px and 375px; no payment/provider action.
4. Reviewer rechecks only these repaired boundaries, then decides formal G3CR7 PASS / RETURN and hands visual acceptance to Owner.

## OWNER_ACTION_REQUIRED

**NONE.** This is an Executor evidence/source-boundary repair; no Owner credential, payment, or manual action is needed.

## EVIDENCE_POINTERS

Current G3CR7:
1. `docs/REVIEWER_DECISION_G3CR7_SOURCE_PASS_RUNTIME_VISUAL_PENDING.md`
1. `docs/G3CR7_FRONTEND_SOURCE_CANDIDATE.md`
1. `docs/OWNER_DECISION_G3CR7_THREE_FRONTEND_SURFACES_2026-10-04.md`
2. `docs/G3CR7_THREE_FRONTEND_SURFACES.md`


Current product-flow authority:
1. `docs/OWNER_DECISION_PREPAYMENT_FULL_INTAKE_FLOW_2026-10-04.md`
2. `docs/MVP_PRODUCT_CONTRACT.md`

Core Aha current research:
1. `docs/REVIEWER_DECISION_G3CR6R3C_CORE_AHA_RESEARCH_PASS.md`
2. `docs/g3cr6r3c-core-aha/RESEARCH_LEDGER.md`
3. `docs/g3cr6r3c-core-aha/SOURCE_COVERAGE_AND_SATURATION.md`
4. `docs/g3cr6r3c-core-aha/SHORTLIST_AND_RECOMMENDATION.md`
5. `docs/g3cr6r3c-core-aha/REUSE_AND_IMPLEMENTATION_MAP.md`

Preserved parent-Gate / homepage state:
6. `docs/G3CR6R3C_TEMPLATE_SOURCE_DISCOVERY.md`
7. `docs/G3CR6R3C_TEMPLATE_DISCOVERY_RESEARCH_CONTRACT.md`
8. `docs/REVIEWER_DECISION_G3CR6R3D2R4_PASS_HOMEPAGE_FREEZE.md`

Core Aha research is PASS; Owner selection is pending. P1-P12 remains unresolved and was not researched in this round.
