# Birthday Magazine Studio — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance: `vps-project-governance v0.1.6` + Governance Source Policy rev1  
> Executor facts: `EXECUTOR_HANDOFF.md` (not created yet; no execution Gate has started)  
> Detailed evidence: `EXECUTION_EVIDENCE.md` (not created yet; no execution Gate has started)  
> Last reviewed: 2026-09-26

## 1. Project Goal

- Final goal: let a buyer turn photos and structured answers into a polished, personalized birthday magazine PDF without designing it manually.
- Accepted product direction: browser-local zero-model-cost preview before payment; full personalized production only after confirmed payment and complete intake.
- Current business goal: freeze the MVP specification and prove that the current interactive sample represents the intended buying/production experience before any production build.
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
- Storefront/CMS: `UNKNOWN`. WordPress + WooCommerce remains a researched candidate, not an accepted production architecture.
- Generation service/worker: `UNKNOWN`.
- PDF rendering engine: `UNKNOWN`.
- Data/persistence: `UNKNOWN`.
- Object/file storage: `UNKNOWN`.
- Auth/order-private access: `UNKNOWN`.
- Payment provider: `UNKNOWN`; must not be selected until seller merchant/account country is known.
- Deployment target: `UNKNOWN`.
- Shared VPS dependency: none currently accepted.
- Target-host execution boundary: no target-host or production write is authorized or claimed.

## 4. Current State

```text
P0  Governance Intake / Truth Reconciliation             ✅ PASS
G1  Product / Offer Baseline                            ✅ PASS (Owner decisions; not transaction proof)
G2A Interactive Sample Review + MVP Spec Freeze          ← CURRENT
G2B Local AI/PDF Solution Proof                         ⏳ HOLD
G3  Staging Storefront + Test Payment + Private Flow    ⏳ HOLD
G4  Bounded Live Transaction Canary                     ⏳ HOLD
G5  Acquisition + Repeatability + Economics             ⏳ HOLD
G6  Production Hardening / Scale Decision               ⏳ HOLD
```

Current Reviewer decisions:
- `PASS_P0_GOVERNANCE_NORMALIZATION_2026-09-26`
- `PASS_G1_PRODUCT_OFFER_BASELINE_OWNER_DECISIONS_2026-09-26`

Important limitation: the Owner reports demand as already validated, but the underlying sample/channel/behavior evidence has not been archived in this repository. Treat that as an Owner decision/input, not independently verified market or transaction evidence.

## 5. Accepted Baseline

### Product / Offer
- Primary first market: United States.
- First language: English.
- First paid format: digital PDF.
- Test price: **US$39.99**.
- Owner does not require a preset total pilot budget cap or order-count cap.
- Pre-payment preview: browser-local deterministic preview; no model API call.
- Paid production target: confirmed payment + complete intake → personalized content generation → deterministic layout/PDF → QA → private proof → final PDF delivery.
- Family recipe book: out of scope.
- Physical printing: deferred.

### Evidence status
- Browser prototype: exists and is clearly labeled as a simulation.
- Real customer payment: not tested in this project.
- Real AI generation pipeline: not implemented/proven.
- Private production PDF delivery: not implemented/proven.
- Repeatability/economics: unknown.
- Production website: not built/deployed.

## 6. Current Gate — G2A Interactive Sample Review + MVP Spec Freeze

### Goal

Review the existing browser prototype and freeze the exact MVP product contract before authorizing AI/PDF implementation or store/payment work.

### Allowed scope

- inspect and revise the browser-only prototype;
- freeze page count, photo-count range, required questions and content sections;
- freeze the boundary between free preview, paid intake, private proof and final PDF;
- define deterministic PDF QA checks;
- define revision/regeneration policy for the US$39.99 offer;
- define minimum privacy/retention/deletion requirements for customer photos and answers;
- use synthetic/test assets only;
- update Reviewer-owned project documentation.

### Forbidden scope

- live payment or buyer charge;
- production payment-provider activation;
- real customer photo collection;
- production AI/model calls on customer data;
- WordPress/hosting/VPS production deployment;
- Secret creation or entry;
- paid plugin/service purchase;
- treating any current research candidate as an approved architecture.

### Acceptance criteria

1. Reviewer walkthrough of the current interactive sample is completed.
2. Exact MVP content specification is frozen.
3. Exact free-preview vs paid-value boundary is frozen.
4. Exact paid intake requirements are frozen.
5. PDF/QA acceptance checks are written.
6. Included revision/regeneration policy is frozen.
7. Customer data handling baseline is written.
8. G2B can be expressed as one bounded, test-fixture-only execution Gate.

### Evidence required

- reviewed prototype behavior/screens;
- frozen supporting MVP specification;
- explicit remaining UNKNOWN list;
- no claim of payment, AI generation or delivery unless separately evidenced.

### Rollback

Documentation/prototype-only changes are reversible through Git. No production resource is in scope.

## 7. Confirmed Facts

- The project directory contains a browser-only interactive sample and supporting research.
- The current sample does not charge money or call an AI generation API.
- The current sample does not constitute production payment, generation, PDF delivery or market validation.
- US-first, English-first, digital PDF, US$39.99, zero-token preview and post-payment AI direction are Owner-confirmed.
- Existing WordPress/plugin documents are research snapshots, not architecture approval.
- There is no current production deployment.

## 8. UNKNOWN / Open Risks

- archived details of the Owner-reported demand validation;
- exact buyer segment within the US market;
- final page count and photo-count limit;
- final question set/content schema;
- included revision/regeneration count;
- seller merchant/bank account country;
- payment provider and settlement currency behavior;
- generator/model/provider selection;
- real per-order AI/render/storage cost;
- storage, access control and deletion policy;
- actual production architecture and hosting;
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

- Reviewer next action: perform G2A prototype walkthrough and freeze the detailed MVP specification.
- Executor next action: none until G2A PASS produces a bounded G2B prompt.
- Owner intervention required: **YES, at G2A acceptance** for subjective product/visual approval and the final included revision policy. No technical setup is required from Owner now.

## 13. Status Summary

- Overall progress: product direction and clickable sample exist; production system does not.
- Final goal: paid personalized birthday magazine PDF workflow.
- Current Gate: G2A interactive sample review + MVP spec freeze.
- This round completed: governance intake, source-of-truth reconciliation, document classification.
- Next: review/freeze the actual MVP, then local AI/PDF solution proof.
- Attention: do not let old research, WordPress candidates or simulated checkout be mistaken for production evidence.
