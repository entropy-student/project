# Family Cookbook Studio — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance: `vps-project-governance v0.1.6` + Governance Source Policy rev1  
> Latest Executor facts: branch `codex/family-cookbook-g2a1-input-ocr-component-feasibility`, `EXECUTOR_HANDOFF.md`, HEAD `b1bf844096fed4761372f3beea6f9f2d7d081643`  
> Latest detailed evidence: same branch `EXECUTION_EVIDENCE.md`; Reviewer accepted partial facts and returned the Gate  
> Last reviewed: 2026-09-26

## 1. Project Goal

- Final goal: let a buyer turn family handwritten recipes, recipe cards/notebooks, related photos and memories into a polished, reviewable family cookbook without manually transcribing and designing it.
- Core product promise: preserve family recipes faithfully while reducing transcription, organization and layout work.
- Current business goal: prove the hardest technical/value boundary first — handwriting extraction + faithful recipe structuring + uncertainty review — while reusing mature commerce/upload/delivery components.
- Current scope: digital cookbook PDF first for technical proof; physical print is a later fulfillment Gate, not assumed solved.
- Related project: Birthday Magazine Studio is an architecture/reference project only. It does not prove this project's OCR, payment, generation, privacy or delivery behavior.

## 2. Authority / Source of Truth

For this project:

1. Owner latest explicit instruction
2. Active bounded Reviewer override / current Gate decision
3. This `REVIEWER_HANDOFF.md`
4. Fresh accepted `EXECUTION_EVIDENCE.md` (when execution starts)
5. `EXECUTOR_HANDOFF.md` (when execution starts)
6. Supporting product/research documents
7. README / historical documents / chat

Governance rules come from GitHub `entropy-student/spike.skill/vps-project-governance`.

## 3. Current Architecture

### Accepted architecture principles

- Commerce shell: **WordPress + WooCommerce — ACCEPTED REUSE BASELINE**.
- Free preview: browser-local deterministic visual preview; **0 LLM / OCR cloud / vision / image-generation Token**. Current accepted MVP baseline does **not** run real OCR before payment.
- Frontend/theme PoC order: **Kadence first**, with **Brandy** and **Blocksy** as accepted free/open WordPress fallback candidates. Final production theme/visual treatment is not yet frozen.
- Post-payment intake: order-bound private image upload pattern; exact plugin/component = POC.
- Product core: project-specific OCR/handwriting recognition → recipe schema extraction → uncertainty review → deterministic layout/PDF.
- MVP OCR architecture: **PaddleOCR = primary engine; Microsoft TrOCR = fallback engine for low-confidence/critical ambiguous regions; user confirmation = final fail-closed fallback**.
- **Tesseract, managed/cloud OCR and VLM/vision are not part of the MVP OCR architecture.** They may be revisited only if G2A1 proves the accepted two-engine route is insufficient.
- Paid compute policy: local/open-source OCR first and by default only. The intended MVP OCR path consumes **0 model/API Token**; exact CPU/GPU cost and manual-confirmation burden remain to be measured.
- PDF output: deterministic HTML/CSS or equivalent templates; exact render engine = UNKNOWN.
- Private proof/final delivery: Woo order-bound access pattern; exact plugin/component = POC.
- Background work: WordPress/WooCommerce Action Scheduler pattern first for orchestration; OCR/render worker runtime = UNKNOWN.
- Payment: reuse the Birthday/Mini Craft WooCommerce payment integration sequence where practical; exact production provider/account decision for this project = **UNKNOWN / NOT YET AUTHORIZED**.
- Deployment target: UNKNOWN.
- Shared VPS dependency: none currently accepted.
- Target-host execution boundary: no production or host write is authorized or claimed.

### Fidelity invariant

The canonical recipe record must preserve:

1. original uploaded image reference;
2. raw OCR/transcription;
3. normalized/structured fields;
4. confidence / uncertainty markers;
5. user/reviewer corrections;
6. final approved recipe text.

No model may silently replace an uncertain quantity, unit, temperature, cooking time, ingredient or step with a guessed value.

## 4. Current State

```text
P0   Governance Intake / Project Truth Bootstrap          ✅ PASS
G1   Core Product Boundary                               ✅ PASS (concept baseline only)
G2A1 Input + OCR + Reusable Component Feasibility PoC    ↩ RETURNED (partial evidence accepted)
G2A1-R1 OCR Runtime + WP Testbed Remediation/Completion  ← CURRENT
G2A2 MVP Product Contract Freeze                         ⏳ HOLD
G2B  Local OCR → Structured Recipe → PDF Solution Proof  ⏳ HOLD
G3A  WordPress + WooCommerce Local Commerce Loop         ⏳ HOLD
G3B  Payment Sandbox + Paid Entitlement Flow             ⏳ HOLD
G4   Bounded Live Transaction Canary                     ⏳ HOLD
G5   Acquisition + Repeatability + Economics             ⏳ HOLD
G6   Production Hardening / Physical Print Decision      ⏳ HOLD
```

Current Reviewer decisions:
- `PASS_P0_GOVERNANCE_BOOTSTRAP_2026-09-26`
- `PASS_G1_CORE_PRODUCT_BOUNDARY_2026-09-26`
- `PASS_ARCH_REUSE_COMMERCE_CUSTOMIZE_RECIPE_ENGINE_2026-09-26`
- `ACCEPT_FREE_PREVIEW_ZERO_TOKEN_BASELINE_2026-09-26`
- `SUPERSEDED_OCR_BENCHMARK_ORDER_PADDLE_TROCR_TESSERACT_2026-09-26`
- `ACCEPT_MVP_OCR_ARCH_PADDLE_PRIMARY_TROCR_FALLBACK_USER_CONFIRM_2026-09-26`
- `ACCEPT_THEME_POC_SHORTLIST_KADENCE_BRANDY_BLOCKSY_2026-09-26`
- `RETURN_G2A1_OCR_ENVIRONMENT_AND_TESTBED_BLOCKED_2026-09-26`
- `ACCEPT_G2A1_PARTIAL_ROUTING_SCHEMA_STATIC_PREVIEW_EVIDENCE_2026-09-26`
- `OPEN_G2A1_R1_ENVIRONMENT_REMEDIATION_COMPLETION_2026-09-26`

Important limitation: the first G2A1 execution did **not** run PaddleOCR or TrOCR inference and did **not** exercise a Family Cookbook WordPress/WooCommerce testbed. OCR accuracy, fallback value, upload/private-delivery behavior, payment, PDF quality, repeatability, production hosting and print fulfillment remain unproven.

## 5. Accepted Baseline

### Product
- Input concept: handwritten recipes / cards / notebook pages, optionally family photos and short memory/context fields.
- Core outcome: organized, proofable family cookbook PDF.
- Differentiator: faithful preservation + cleanup/organization + layout, not generic OCR alone.
- Digital PDF is the first technical output; physical print is explicitly deferred until the digital chain is reliable.
- The system must expose ambiguity rather than fabricate missing cooking facts.

### Architecture reuse
- WordPress + WooCommerce for generic storefront/order workflow.
- Frontend PoC starts from Kadence; Brandy and Blocksy remain fallback candidates. Use free/open functionality first; no paid theme/plugin purchase is implied.
- Reuse Birthday Magazine component research for theme shell, order-bound upload and private file delivery only after this project's own PoC.
- Do not duplicate generic ecommerce/account/email/payment plumbing without evidence that the shared/reusable path fails.

### Compute / Token boundary
- Free visitor path: browser-local style/title/family-name preview + optional one local image; **0 model Token and no real OCR**.
- Paid processing: OpenCV/library preprocessing → PaddleOCR primary → rule/confidence checks → TrOCR only on suspicious regions → user confirmation if still uncertain.
- MVP OCR/model API Token cost target: **0**. Compute still consumes local CPU/GPU time.
- No cloud OCR or VLM/vision fallback is in MVP scope.

### Evidence status
- G2A1 execution branch/head reviewed: `codex/family-cookbook-g2a1-input-ocr-component-feasibility@b1bf844096fed4761372f3beea6f9f2d7d081643`.
- **Accepted partial evidence:** 20 synthetic fixture definitions/renderer; deterministic routing + provenance/schema unit tests (5/5); static browser-local preview with local blob input and no HTTP/model call.
- **Not accepted as OCR proof:** PaddleOCR pages processed = 0; TrOCR crops processed = 0; all OCR error/fallback/manual-confirmation metrics remain UNKNOWN.
- **Blocked/unproven:** Kadence-integrated Family test site, order-bound upload, private delivery.
- Real structured OCR→recipe→PDF pipeline: not implemented.
- Real payment: not tested.
- Physical printing: not tested.
- Economics: unknown.

## 6. Current Gate — G2A1-R1 OCR Runtime + WordPress Testbed Remediation / Completion

Original G2A1 contract: [docs/G2A1_INPUT_OCR_COMPONENT_POC.md](./docs/G2A1_INPUT_OCR_COMPONENT_POC.md)  
Current remediation contract: [docs/G2A1_R1_ENVIRONMENT_REMEDIATION_AND_COMPLETION.md](./docs/G2A1_R1_ENVIRONMENT_REMEDIATION_AND_COMPLETION.md)

### Reviewer review of returned execution

Reviewer independently read back the branch, final HEAD, evidence, handoff, benchmark JSON and core routing/schema/benchmark code.

Decision: **RETURN accepted. Architecture remains unchanged.**

Accepted carry-forward facts:
- 20 synthetic fixtures and deterministic renderer exist;
- routing/schema tests passed 5/5;
- fail-closed disagreement behavior exists;
- static browser-local preview proved no HTTP/model call;
- no real payment/customer data/third OCR/VLM occurred.

Reasons Gate cannot PASS:
- PaddleOCR inference never ran;
- TrOCR fallback inference never ran;
- OCR quality, critical-field error, fallback resolution and manual-confirmation burden are UNKNOWN;
- Family Cookbook WordPress/Kadence testbed did not exist;
- order-bound upload/private delivery were not exercised.

The next run must complete only the blocked evidence, not re-run accepted work without reason.

### G2A1-R1 remediation goals

1. get PaddleOCR primary inference running without changing OCR product architecture;
2. run TrOCR only on real routed suspicious crops and measure its value;
3. add a small public/open genuine-handwriting subset so typography is not mistaken for handwriting proof;
4. measure OCR accuracy, critical-field errors, routing/fallback and `USER_CONFIRM_REQUIRED` burden;
5. create a dedicated local Family Cookbook WordPress + WooCommerce + Kadence testbed;
6. prove order-bound upload and private delivery positive/negative access behavior;
7. preserve all accepted partial evidence from the first RETURN.

### Accepted MVP OCR route — unchanged

G2A1 is no longer a broad OCR bake-off. Validate this minimal architecture only:

1. **PaddleOCR** processes the full recipe image/page as the primary OCR engine.
2. Deterministic checks identify low-confidence or critical suspicious values such as fractions, quantities, units, temperatures and timing.
3. **TrOCR** is invoked only for those suspicious cropped regions/lines.
4. If the two passes still disagree or remain uncertain, **ask the user/reviewer to confirm against the source crop**.
5. Never add a third OCR/model merely to force an automatic answer.

Tesseract, cloud OCR and VLM/vision are explicitly deferred from MVP and are not required for G2A1 PASS.

### Runtime remediation note

The first attempt stalled on a PaddlePaddle wheel download. Current PaddleOCR documentation supports a Transformers inference engine, so G2A1-R1 may prefer that route while keeping **PaddleOCR as the primary OCR product**. If needed, the official Windows PaddlePaddle/CUDA 12.6 package channel is an allowed fallback within the same architecture.

For TrOCR, Reviewer authorizes `microsoft/trocr-small-handwritten` first to reduce download/runtime footprint because TrOCR is only the fallback path.

### Required OCR fixture set

The benchmark should include a small but deliberately mixed fixture set:
- clear printed/typed recipe;
- synthetic handwriting-like typography;
- **5–10 public/open genuine-handwriting samples with source/license recorded**;
- photographed notebook page with skew/shadow;
- recipe containing fractions, temperatures, units and timing values;
- at least one non-English/mixed-language sample if the initial product may support it.

Do not benchmark only clean screenshots.

### Git / execution delivery contract

G2A1 must be executed on a dedicated branch:

`codex/family-cookbook-g2a1-input-ocr-component-feasibility`

Executor must:
- branch from the current repository baseline before Gate writes;
- commit all allowed PoC code, fixture metadata, benchmark outputs, `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md` back to that branch;
- return the exact branch name and final HEAD commit SHA;
- ensure Reviewer can reproduce/read the evidence from GitHub without depending on the Executor's local workspace;
- **not merge to `main`**, not open the next Gate, and stop at Reviewer.

If the exact branch already exists, classify/read its current state first and continue only if it is the active G2A1 branch; do not overwrite unrelated work.

### Rollback

All G2A1 work is local/test-only and Git-reversible. The Git branch/commit is the execution rollback boundary. No production resource, real payment, customer file or Secret is in scope.

## 7. Confirmed Facts

- The Owner wants a product that turns family handwritten recipes into a formal cookbook artifact.
- Birthday Magazine Studio provides a reusable architecture/governance reference for WordPress/WooCommerce, zero-token preview, order-bound upload, private delivery and staged payment validation.
- Handwriting OCR is materially different from printed-text OCR and must be benchmarked rather than assumed.
- The product must preserve source images and uncertainty so that cooking facts are not silently invented.
- No current production deployment exists.

## 8. UNKNOWN / Open Risks

- first target market and language;
- test price and exact paid package;
- exact number of recipes/pages/photos per product;
- acceptable OCR error rate / manual review burden;
- handwriting/language coverage;
- exact correction UI;
- image preprocessing path;
- whether the accepted PaddleOCR + TrOCR route meets the required accuracy/manual-review threshold;
- exact deterministic recipe-structuring/parser implementation;
- per-order local compute/render cost and manual-confirmation burden;
- file storage/access/deletion policy;
- final production WordPress theme selection among the accepted PoC shortlist, plus exact upload/private-delivery components;
- payment provider/account eligibility;
- final PDF render engine;
- physical print/POD vendor, country coverage, paper/binding/bleed/shipping economics;
- production hosting;
- refund/cancellation/reprint policy;
- real transaction conversion and acquisition cost.

## 9. Owner-only Checkpoints

- Payment/purchase: before paid plugin/service/hosting/OCR provider purchase or real buyer payment.
- Identity/account authorization: payment/hosting/provider onboarding.
- Secret entry/rotation: Owner-only unless an exact delegated allowlist is explicitly authorized.
- Irreversible operation: none in current Gate.
- Material production enablement: not authorized.
- Major business decisions still needed before Paid MVP: target market/language, price/package, final revision promise, physical-print offer.

## 10. Resource Baseline

- Current state: documentation only; no production runtime.
- Root disk/VPS: N/A.
- Project source/data/backups: no production customer data exists.
- Production image/BuildKit/browser runtime: N/A.
- If Shared VPS is selected later, Storage Layout Contract rev1 and `PROJECT_STORAGE_MANIFEST.md` become mandatory before deployment.

## 11. Rollback / Recovery

- Current rollback point: Git history.
- No production release/image exists.
- No customer DB/upload store exists.
- No Secret recovery artifact exists because no production Secret is authorized.

## 12. Next Step

- Reviewer decision: `RETURN_G2A1_OCR_ENVIRONMENT_AND_TESTBED_BLOCKED_2026-09-26`.
- Executor next action: continue the **same branch** and execute [docs/G2A1_R1_ENVIRONMENT_REMEDIATION_AND_COMPLETION.md](./docs/G2A1_R1_ENVIRONMENT_REMEDIATION_AND_COMPLETION.md).
- Do not merge/rebase unrelated Mini Craft-only `main` drift merely to continue this Gate; read current Reviewer truth from `main` first.
- Return branch + final HEAD SHA + `PASS_CANDIDATE_G2A1_R1_*` or precise `RETURN_*`, do not merge `main`, and stop at Reviewer.
- Owner intervention required: **NO** for this remediation unless a genuinely Owner-only blocker (paid purchase, account/identity/Secret action) appears.

## 13. Status Summary

- Overall progress: G2A1 produced valid partial PoC code/evidence but returned on OCR runtime + missing Family WP testbed; no architecture change is needed.
- Final goal: private, reliable family recipe intake → faithful transcription/structuring → proof → cookbook PDF → later optional print.
- Current Gate: **G2A1-R1 environment remediation/completion**.
- Next after PASS: G2A2 exact MVP contract → G2B local OCR-to-PDF proof.
- Attention: never treat clean OCR demos, model self-confidence or a visually nice PDF as proof that recipe facts are correct.
