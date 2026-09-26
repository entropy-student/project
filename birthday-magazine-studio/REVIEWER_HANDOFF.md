# Birthday Magazine Studio — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance: `vps-project-governance v0.1.6` + Governance Source Policy rev1  
> Executor facts: `EXECUTOR_HANDOFF.md` (not created yet; no execution Gate has started)  
> Detailed evidence: `EXECUTION_EVIDENCE.md` (not created yet; no execution Gate has started)  
> Last reviewed: 2026-09-26

## 1. Project Goal

- Final goal: let a buyer turn photos and structured answers into a polished, personalized birthday magazine PDF without designing it manually.
- Accepted product direction: browser-local zero-model-cost preview before payment; full personalized production only after confirmed payment and complete intake.
- Current business goal: choose the lowest-custom-work WordPress frontend foundation and freeze the MVP UI/component path before AI/PDF implementation.
- Current scope: birthday magazine only. Family recipe book remains a separate parked idea.

## 2. Authority / Source of Truth

For this project, use:

1. Owner latest explicit instruction
2. Active bounded Reviewer override / current Gate decision
3. This `REVIEWER_HANDOFF.md`
4. Fresh accepted `EXECUTION_EVIDENCE.md` (when execution starts)
5. `EXECUTOR_HANDOFF.md` (when execution starts)
6. Supporting product/research documents
7. README / historical documents / chat

Governance rules are sourced from GitHub `entropy-student/spike.skill/vps-project-governance`.  
`PROJECT_RECORD.md` is now a legacy pointer only and must not be maintained as a competing current-truth file.

## 3. Current Architecture

### Current implemented artifact
- Runtime/framework: static browser-only HTML/CSS/JS prototype at `prototype/index.html`.
- Current prototype capabilities: local preview, simulated checkout, simulated post-payment intake/generation/proof/delivery flow.
- Current prototype boundaries: no real payment, no AI/model API, no server upload/storage, no order database, no email delivery, no production PDF generator.

### Production architecture
- Storefront/CMS: **WordPress + WooCommerce — ACCEPTED**.
- Canonical commerce/order system: **WooCommerce**.
- Payment: **PayPal via the official WooCommerce PayPal Payments plugin — ACCEPTED**.
- Payment implementation reference: follow the Mini Craft sequence: local WooCommerce commerce loop first → PayPal Sandbox connection/checkout/capture/callback/refund validation → bounded Live/real-payment Canary later. Do not hand-code PayPal API or introduce a second order system unless a later Reviewer Gate explicitly changes this.
- Payment evidence boundary: Mini Craft is an implementation/reference path only; its current state does not prove Birthday Magazine Live payment.
- Free-value path: deterministic browser-local preview only; **0 LLM / vision / image-generation Token**.
- Paid entitlement boundary: model generation is permitted only after server-side WooCommerce/PayPal paid state is confirmed **and** required intake is complete.
- Frontend foundation: G2A PoC compares **Kadence Jewelry Shop + Storelly**, **Blocksy Modern Shop + Storelly**, and the existing **Good Issue** prototype as the custom-reference baseline.
- Post-payment photo intake: Vanquish Upload Files is the first PoC candidate; not accepted until guest/order/private-access behavior is verified.
- Private proof/final attachment: Vanquish Attach Me / Woo order-bound private delivery is the first PoC path; not accepted until access-control behavior is verified.
- Background jobs: use the WordPress/WooCommerce Action Scheduler pattern first; do not introduce Redis/Celery/RabbitMQ without an observed need.
- Generation service/worker: project-specific asynchronous generation boundary; exact runtime/provider = `UNKNOWN`.
- Generation idempotency: one paid order → at most one active canonical generation job; duplicate callback/refresh must not duplicate model spend.
- PDF rendering engine: `UNKNOWN`.
- Data/persistence: `UNKNOWN`.
- Object/file storage: `UNKNOWN`.
- Auth/order-private access: `UNKNOWN`.
- Deployment target: `UNKNOWN`.
- Shared VPS dependency: none currently accepted.
- Target-host execution boundary: no target-host or production write is authorized or claimed.

## 4. Current State

```text
P0  Governance Intake / Truth Reconciliation             ✅ PASS
G1  Product / Offer Baseline                            ✅ PASS (Owner decisions; not transaction proof)
G2A Frontend Foundation + Component PoC + MVP UI Freeze ← CURRENT
G2B Local AI/PDF Solution Proof                         ⏳ HOLD
G3A WordPress + WooCommerce Commerce Loop               ⏳ HOLD
G3B PayPal Sandbox + Paid Entitlement Flow              ⏳ HOLD
G4  Bounded Live PayPal Transaction Canary              ⏳ HOLD
G5  Acquisition + Repeatability + Economics             ⏳ HOLD
G6  Production Hardening / Scale Decision               ⏳ HOLD
```

Current Reviewer decisions:
- `PASS_P0_GOVERNANCE_NORMALIZATION_2026-09-26`
- `PASS_G1_PRODUCT_OFFER_BASELINE_OWNER_DECISIONS_2026-09-26`
- `PASS_ARCH_WOOCOMMERCE_PAYPAL_AND_TOKEN_BOUNDARY_2026-09-26`

Important limitation: the Owner reports demand as already validated, but the underlying sample/channel/behavior evidence has not been archived in this repository. Treat that as an Owner decision/input, not independently verified market or transaction evidence.

## 5. Accepted Baseline

### Product / Offer
- Primary first market: United States.
- First language: English.
- First paid format: digital PDF.
- Test price: **US$39.99**.
- Owner does not require a preset total pilot budget cap or order-count cap.
- Pre-payment preview: browser-local deterministic preview; **zero model API calls / zero model Token**.
- Commerce/order baseline: **WordPress + WooCommerce**.
- Payment baseline: **official WooCommerce PayPal Payments**; Sandbox validation precedes any Live payment.
- Paid production target: confirmed WooCommerce/PayPal paid state + complete intake → one idempotent generation job → personalized content generation → deterministic layout/PDF → QA → private proof → final PDF delivery.
- Family recipe book: out of scope.
- Physical printing: deferred.

### Evidence status
- Browser prototype: exists and is clearly labeled as a simulation.
- Real customer payment: not tested in this project.
- Real AI generation pipeline: not implemented/proven.
- Private production PDF delivery: not implemented/proven.
- Repeatability/economics: unknown.
- Production website: not built/deployed.

## 6. Current Gate — G2A Frontend Foundation + Component PoC + MVP UI Freeze

Formal execution contract: [docs/G2A_FRONTEND_COMPONENT_POC.md](./docs/G2A_FRONTEND_COMPONENT_POC.md)

### Goal

Compare three local/test-only routes and select the lowest-custom-work foundation that preserves the core birthday-magazine experience:

1. Kadence Jewelry Shop + Storelly;
2. Blocksy Modern Shop + Storelly;
3. existing Good Issue prototype as the custom-reference baseline.

### Critical experience to preserve

```text
simple inputs
→ immediate cover + 1–2 spread magazine preview
→ zero model Token
→ clear US$39.99 unlock path
→ WooCommerce-compatible checkout path
```

### Allowed scope

- local/test WordPress PoC;
- free/open-source theme/plugin installation needed for comparison;
- synthetic/demo photos only;
- minimal CSS/JS adaptation;
- desktop + 375px screenshots;
- component-fit and custom-code comparison;
- Reviewer documentation updates.

### Forbidden scope

- PayPal connection or real payment;
- AI/model API calls;
- production customer uploads;
- Secret entry;
- paid plugin purchase;
- VPS/domain/public production deployment;
- full 12-page generation engine.

### Acceptance criteria

1. the three routes have comparable evidence, or a route is specifically proven infeasible;
2. selected foundation preserves zero-token local preview;
3. selected foundation remains WooCommerce-compatible;
4. selected foundation can carry the Good Issue editorial visual language;
5. custom-code and plugin-lock-in tradeoffs are explicit;
6. mobile 375px behavior is verified;
7. no payment/AI/customer-data production action occurs.

### Rollback

All G2A changes are local/test and Git-reversible. No production resource is in scope.

## 7. Confirmed Facts

- The project directory contains a browser-only interactive sample and supporting research.
- The current sample does not charge money or call an AI generation API.
- The current sample does not constitute production payment, generation, PDF delivery or market validation.
- US-first, English-first, digital PDF, US$39.99, zero-token preview and post-payment AI direction are Owner-confirmed.
- WordPress + WooCommerce is now the accepted commerce baseline.
- PayPal through the official WooCommerce PayPal Payments plugin is now the accepted payment path, using Mini Craft as the implementation reference.
- The free path must remain deterministic and zero-model-token; paid AI spend is gated by confirmed payment entitlement plus complete intake.
- The reuse-vs-custom technical route is documented in `docs/TECHNICAL_ROUTE.md`.
- Kadence Jewelry Shop + Storelly is the first PoC candidate, not a final selection.
- Blocksy Modern Shop + Storelly is the comparison backup.
- Existing Good Issue remains the editorial/custom-reference baseline.
- Vanquish Upload Files and Vanquish Attach Me remain PoC candidates, not accepted production dependencies.
- Other WordPress/plugin research remains candidate research unless separately accepted.
- There is no current production deployment.

## 8. UNKNOWN / Open Risks

- archived details of the Owner-reported demand validation;
- exact buyer segment within the US market;
- final page count and photo-count limit;
- final question set/content schema;
- included revision/regeneration count;
- seller merchant/bank account country;
- PayPal merchant/account eligibility, settlement currency behavior and actual fees for the eventual seller account;
- generator/model/provider selection;
- real per-order AI/render/storage cost;
- storage, access control and deletion policy;
- final frontend foundation after G2A;
- whether Storelly satisfies the local zero-token preview requirement without unacceptable cloud/paid dependency;
- whether Vanquish upload/attachment plugins pass guest-order and private-access tests;
- exact PDF render engine;
- actual production hosting;
- refund/cancellation handling;
- real transaction conversion and acquisition cost.

## 9. Owner-only Checkpoints

- Payment/purchase: required before any paid service/plugin/hosting purchase or real buyer payment test.
- Identity/account authorization: required for any payment/hosting/provider account onboarding.
- Secret entry/rotation: Owner-only unless a later exact delegated allowlist is explicitly authorized.
- Irreversible operation: none in current Gate.
- Material production enablement: not authorized.
- Major business/compliance decision: seller merchant country, target-country expansion, final customer terms/refund policy.

## 10. Resource Baseline

- Current prototype: static files in GitHub; no server runtime baseline.
- Root disk / VPS: N/A for current Gate.
- Project source/data/backups: no production data exists.
- Production image / BuildKit / browser runtime: N/A.
- If Shared VPS is selected later, Storage Layout Contract rev1 and `PROJECT_STORAGE_MANIFEST.md` become mandatory before deployment.

## 11. Rollback / Recovery

- Current rollback point: Git history.
- No production release/image exists.
- No customer database or recovery pair exists.
- No Secret recovery artifact exists because no production Secret is authorized.

## 12. Next Step

- Reviewer next action: dispatch/review G2A using `docs/G2A_FRONTEND_COMPONENT_POC.md`.
- Executor next action: build the three local PoCs, capture comparable evidence, update `EXECUTION_EVIDENCE.md` + `EXECUTOR_HANDOFF.md`, and stop at Reviewer.
- Owner intervention required: **YES only after technical comparison**, to approve the chosen visual foundation before G2B. No account/payment/Secret action is required now.

## 13. Status Summary

- Overall progress: product direction, clickable sample, commerce baseline, PayPal path and free/paid Token boundary are fixed; production system does not yet exist.
- Final goal: PayPal-paid personalized birthday magazine PDF workflow.
- Current Gate: G2A frontend foundation + component PoC + MVP UI freeze.
- This round completed: reusable technical route frozen; generic commerce/upload/payment/queue/delivery capabilities are assigned to mature WordPress/WooCommerce components where possible; custom work is restricted to the magazine-generation core.
- Next: run the three-route local frontend/component PoC, select the foundation, then enter G2B local AI/PDF solution proof.
- Attention: do not let old research, WordPress candidates or simulated checkout be mistaken for production evidence.
