# Birthday Magazine Studio — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance: `vps-project-governance v0.1.6` + Governance Source Policy rev1  
> Executor facts: `EXECUTOR_HANDOFF.md`  
> Detailed evidence: `EXECUTION_EVIDENCE.md`  
> Last reviewed: 2026-09-26

## 1. Project Goal

- Final goal: let a buyer turn photos and structured answers into a polished, personalized birthday magazine PDF without designing it manually.
- Accepted product direction: browser-local zero-model-cost preview before payment; full personalized production only after confirmed payment and complete intake.
- Current business goal: first prove which WordPress/frontend/upload/private-delivery components are safely reusable; then freeze the exact MVP product contract before AI/PDF implementation.
- Current scope: birthday magazine only. Family Cookbook Studio is now a separate active project at `../family-cookbook-studio/` and remains out of scope here.

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
- Frontend foundation: **Good Issue-style preview inside WordPress + WooCommerce is the accepted technical foundation candidate** from G2A1. Final subjective visual/product freeze remains G2A2.
- Storelly: **REJECTED for the current free-preview path**.
- Post-payment photo intake: Vanquish Upload Files is a **registered-account reuse candidate**. Its guest-issued secure file link replayed outside the intended guest context, so the guest-private path is **REJECTED AS-IS**.
- Private proof/final attachment: Vanquish Attach Me is a **registered-account reuse candidate**. Actual authorized download/hash passed, but its guest-issued attachment link replayed outside the intended guest context, so strict guest-private delivery is **REJECTED AS-IS**.
- Guest access model: whether the MVP requires authenticated accounts or guest/no-account fulfillment is a **G2A2 product decision**.
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
G2A1 Frontend + Reusable Component Feasibility PoC      ✅ PASS
G2A1R1 Evidence Closure                                 ⏹ CLOSED — executor RETURN produced final technical finding
G2A2 MVP Product Contract Freeze                        ⏳ HOLD / NOT STARTED
G2B  Local AI/PDF Solution Proof                        ⏳ HOLD
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
- `RETURN_G2A1_EVIDENCE_CLOSURE_REQUIRED_2026-09-26`
- `PASS_G2A1_COMPONENT_FEASIBILITY_WITH_GUEST_PATH_REJECTION_2026-09-27`

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
- Family Cookbook Studio: separate project; out of scope for Birthday Magazine Studio.
- Physical printing: deferred.

### Evidence status
- Browser prototype: exists and is clearly labeled as a simulation.
- Real customer payment: not tested in this project.
- Real AI generation pipeline: not implemented/proven.
- Private production PDF delivery: not implemented/proven.
- Repeatability/economics: unknown.
- Production website: not built/deployed.

## 6. Latest Reviewer Decision — G2A1 PASS / G2A2 Not Started

Current Reviewer decision: [docs/REVIEWER_DECISION_G2A1_PASS.md](./docs/REVIEWER_DECISION_G2A1_PASS.md)

Earlier RETURN decision: [docs/REVIEWER_DECISION_G2A1_RETURN.md](./docs/REVIEWER_DECISION_G2A1_RETURN.md)

Closure execution contract: [docs/G2A1R1_EVIDENCE_CLOSURE.md](./docs/G2A1R1_EVIDENCE_CLOSURE.md)

Original execution contract: [docs/G2A1_COMPONENT_FEASIBILITY_POC.md](./docs/G2A1_COMPONENT_FEASIBILITY_POC.md)

### Reviewer result

G2A1 is now **PASS**.

Reason:
- the technical frontend/free-preview question is answered;
- Storelly is explicitly rejected;
- registered-account reuse behavior is evidenced;
- guest positive flows were proven;
- guest bearer-link replay was reproducibly proven, so the current guest plugin paths are explicitly rejected rather than left UNKNOWN;
- download/hash, screenshots, cleanup/read-back and GitHub handoff are complete.

The G2A1R1 Executor `RETURN` remains a valid historical execution fact. Reviewer does not reinterpret the failed guest negative checks as PASS; instead, those failures become the technical basis for rejecting the guest plugin paths.

### Product decision deferred to G2A2

G2A2 must choose:
- authenticated customer account required; or
- guest/no-account fulfillment required.

If guest/no-account is required, a later bounded technical Gate must select or implement a guest-safe private access mechanism before production delivery.

G2A2 is **not started in this Reviewer round**.

### Rollback

All G2A1 changes are local/test and Git-reversible. No production resource is in scope.

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
- final page count and paid photo-count limit (must be frozen in G2A2);
- final question set/content schema (must be frozen in G2A2);
- included revision/regeneration count (must be frozen in G2A2);
- seller merchant/bank account country;
- PayPal merchant/account eligibility, settlement currency behavior and actual fees for the eventual seller account;
- generator/model/provider selection;
- real per-order AI/render/storage cost;
- storage, access control and deletion policy;
- final subjective visual/product foundation after G2A2;
- MVP customer access model: authenticated account required vs guest/no-account;
- if guest/no-account is selected, replacement/wrapper guest-safe upload/private-delivery access mechanism;
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

- Reviewer next action: none in G2A1; stop at Reviewer with G2A2 still HOLD.
- Executor next action: none.
- Owner intervention required: **NO for this closure**. The next product-spec round will require Owner input on account-required vs guest/no-account experience, along with the other G2A2 product decisions.

## 13. Status Summary

- Overall progress: product direction, clickable sample, commerce baseline, PayPal path and free/paid Token boundary are fixed; production system does not yet exist.
- Final goal: PayPal-paid personalized birthday magazine PDF workflow.
- G2A1: PASS.
- G2A1R1: closed; its Executor RETURN is preserved as the evidence that the current guest plugin links are bearer-replayable and therefore rejected for strict guest-private use.
- G2A2: HOLD / not started.
- Next product question, when authorized: freeze the MVP contract including whether customers must authenticate or may remain guest/no-account.
- Attention: do not let old research, WordPress candidates or simulated checkout be mistaken for production evidence.
