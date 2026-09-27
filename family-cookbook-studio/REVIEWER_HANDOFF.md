# Family Cookbook Studio — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance: `vps-project-governance v0.1.6` + Governance Source Policy rev1  
> Latest Executor facts: branch `codex/family-cookbook-g2a1-input-ocr-component-feasibility`, `EXECUTOR_HANDOFF.md`, HEAD `ad58cfe3b3fbfcca6a6f1ee3e929754c2c3b14e5`  
> Latest detailed evidence: same branch `EXECUTION_EVIDENCE.md`; R3A Actions run `36289130217` independently reviewed  
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
- MVP OCR architecture principle: **PP-OCRv6_medium primary → deterministic critical-risk checks → at most one bounded API fallback → one consolidated manual-edit review**.
- **PP-OCRv6_medium is now the accepted free/local primary.**
- `PaddleOCR-VL-1.6` is rejected as primary for the current MVP evidence: four missed synthetic temperatures plus materially higher CPU/RAM/storage cost.
- `microsoft/trocr-small-handwritten` remains deprecated.
- API fallback remains optional pending R3B evidence; if no specialized API materially improves the 11 hard cases, fallback will be NONE.
- Tesseract, managed/cloud OCR and VLM/vision remain outside MVP scope unless a later Reviewer decision explicitly reopens them.
- Paid compute policy: local/open-source PP-OCRv6 processes all pages first. External OCR, if retained, is used only for bounded high-risk pages/crops. API cost is therefore expected to be sparse rather than per-page by default.
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
G2A1-R1 OCR Runtime + WP Testbed Remediation/Completion  ↩ RETURNED (resource blocked)
G2A1-R2 Isolated GitHub Actions Runner Completion         ↩ RETURNED (WP/component feasibility accepted; OCR scope not calibrated)
G2A1-D1 Target Language + OCR Acceptance Calibration      ✅ OWNER DECISIONS RESOLVED
G2A1-R3A Free/Local Primary Benchmark                    ✅ PASS — PP-OCRv6_medium
G2A1-R3B Bounded API Fallback Benchmark                  ← CURRENT / READY_FOR_EXECUTOR
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
- `RETURN_G2A1_R1_RESOURCE_BLOCKED_2026-09-27`
- `ACCEPT_G2A1_R1_RESOURCE_PREFLIGHT_EVIDENCE_2026-09-27`
- `OPEN_G2A1_R2_ISOLATED_ACTIONS_RUNNER_COMPLETION_2026-09-27`
- `ACCEPT_G2A1_R2_WP_WOO_KADENCE_UPLOAD_DELIVERY_FEASIBILITY_2026-09-27`
- `ACCEPT_G2A1_R2_OCR_BENCHMARK_OBSERVATIONS_2026-09-27`
- `RETURN_G2A1_R2_OCR_SCOPE_NOT_CALIBRATED_2026-09-27`
- `DEPRECATE_TROCR_SMALL_AS_MVP_FALLBACK_CURRENT_EVIDENCE_2026-09-27`
- `OPEN_G2A1_D1_TARGET_LANGUAGE_OCR_ACCEPTANCE_2026-09-27`
- `ACCEPT_ENGLISH_FIRST_NOT_ENGLISH_ONLY_2026-09-27`
- `ACCEPT_SINGLE_CONSOLIDATED_OCR_REVIEW_WITH_MANUAL_EDIT_2026-09-27`
- `OPEN_G2A1_R3_FREE_LOCAL_PRIMARY_BOUNDED_API_FALLBACK_BENCHMARK_2026-09-27`
- `PASS_G2A1_R3A_LOCAL_PRIMARY_SELECTION_PP_OCRV6_MEDIUM_2026-09-27`
- `REJECT_PADDLEOCR_VL_1_6_AS_PRIMARY_2026-09-27`
- `OPEN_G2A1_R3B_BOUNDED_API_FALLBACK_OWNER_CHECKPOINT_2026-09-27`
- `OWNER_APPROVE_G2A1_R3B_PUBLIC_HARD_CASE_API_TEST_BUDGET_USD_0_20_2026-09-27`
- `OPEN_G2A1_R3B_GOOGLE_FIRST_MISTRAL_SECOND_EXECUTION_2026-09-27`

Important limitation: R3A now selects PP-OCRv6_medium as the local primary, but API fallback value remains unproven. R3A's genuine-handwriting set is small and historical, so modern household handwriting generalization remains UNKNOWN. Payment, full OCR→PDF output quality, repeatability, production hosting and print fulfillment remain unproven.

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
- Earlier accepted evidence remains: synthetic fixture renderer; deterministic routing/provenance/schema tests; static local preview; Windows resource blocker.
- **R2 WordPress/component feasibility accepted:** Actions run `36263385997` artifact reports WordPress 7.1.2, WooCommerce 11.1.2, Kadence 1.5.2, browser-local preview PASS, order-bound upload positive/negative PASS, private delivery positive/negative PASS, cleanup PASS. The workflow's final failure came from a post-test Docker image-inspection command, not these product assertions.
- **R2 OCR observations accepted:** 28 pages processed; exact-line errors 62; missing lines 32; exact critical-token mismatches 13; 60 suspicious crops; 69 confirmations; 2.464 confirmations/page; tested TrOCR-small reduced confirmations by 0.
- **Interpretation constraint:** exact-token mismatches include semantically recoverable formatting changes (for example degree symbols or missing spaces) as well as genuine failures; the genuine handwriting subset is German/general handwriting, while target product language is still UNKNOWN.
- Real structured OCR→recipe→PDF pipeline: not implemented.
- Real payment: not tested.
- Physical printing: not tested.
- Economics: unknown.

## 6. Current Gate — G2A1-D1 Target Language + OCR Acceptance Calibration

Historical G2A1/R1/R2 contracts remain preserved.  
Current Owner checkpoint: [docs/G2A1_D1_TARGET_LANGUAGE_OCR_ACCEPTANCE.md](./docs/G2A1_D1_TARGET_LANGUAGE_OCR_ACCEPTANCE.md)

### Reviewer R2 decision

Reviewer independently checked:
- execution branch HEAD `1d2abddc6e0ea58ec55c75a29033fe1233a34ada`;
- Actions run `36262841714`;
- corrected run `36263385997`;
- jobs/logs/artifacts;
- OCR benchmark JSON;
- WordPress test summary and cleanup evidence.

Decision:

1. **PASS the reusable WordPress/WooCommerce/Kadence preview/upload/private-delivery feasibility portion of G2A1.** Do not retest it in R3 unless implementation materially changes.
2. **Accept the OCR measurements as observations, but do not accept the Executor's broad `OCR_ROUTE_INSUFFICIENT` conclusion as a general product conclusion.**
3. The tested TrOCR-small configuration is rejected as the MVP fallback under current evidence.
4. OCR benchmarking must be recalibrated to one target language and semantic critical-field correctness before G2A1 can close.

Why the broad OCR conclusion is premature:
- target language/market remains an Owner-level UNKNOWN;
- no acceptance threshold for confirmation burden was frozen;
- genuine handwriting fixtures were German/general handwriting;
- the tested TrOCR model/configuration and Paddle recognition setup were not aligned to a frozen target language;
- exact-string critical mismatches overcount semantic failures such as `350°F → 350F` or `1/2 cup → 1/2cup`.

### Owner decisions resolved

Owner decisions:
- **English-first, not English-only**. English is the initial benchmark/product UX priority, while multilingual input remains allowed where the chosen OCR stack supports it.
- **One consolidated user confirmation stage**. After OCR + fallback complete, present all uncertain/high-risk fields together, allow manual edits, then one final approval action.
- Recognition quality must make this a light proof/correction step rather than manual retranscription.
- No silently accepted wrong quantity/unit/temperature/time.
- The earlier suggested hard limit of ≤2 confirmations/page is not frozen; R3 measures actual edit burden.

### G2A1-R3A Reviewer decision

Reviewer independently checked:
- branch HEAD `ad58cfe3b3fbfcca6a6f1ee3e929754c2c3b14e5`;
- Actions run `36289130217` and all job steps;
- identical-input SHA evidence for both candidates;
- semantic score, review burden, comparison and 11-case fallback set.

Decision: **PASS G2A1-R3A.**

Accepted primary: **PP-OCRv6_medium**.

Key evidence:
- 20/20 synthetic recipe pages zero manual edits;
- 77/77 synthetic critical facts correct;
- 0 silent critical errors;
- 0 confirmed hallucinations;
- one genuine-handwriting critical miss: GH04 `8 eggs`;
- complete-handwriting score 82.73% across 7 fully transcribed crops;
- runtime about 133.7 s / 35 inputs, ~2.02 GB sampled RSS, ~165 MB model storage.

PaddleOCR-VL-1.6 is rejected as primary:
- four missing synthetic temperatures;
- ~520 s / 35 inputs;
- ~3.92 GB RSS;
- ~2.05 GB model storage;
- its higher 7-crop handwriting score does not override recipe critical-fidelity priority.

The 11 fallback samples are all hard genuine/historical handwriting cases. API fallback is therefore a long-tail quality optimization, not the normal processing path.

### Current R3B execution

Owner checkpoint is resolved.

Owner authorized:
- 11 public/non-private R3A hard cases only;
- Google Enterprise Document OCR first;
- Mistral OCR 4.1 only if Google is materially insufficient;
- total external API test budget ≤ USD 0.20;
- no Gemini/general VLM;
- no customer/private recipe data;
- no production integration;
- Secrets only through secure provider/GitHub Actions mechanisms.

Formal execution contract: [docs/G2A1_R3B_API_FALLBACK_BENCHMARK.md](./docs/G2A1_R3B_API_FALLBACK_BENCHMARK.md)

If required provider credentials/setup are missing, Executor must return the precise credential/setup blocker rather than requesting Secret values in evidence/chat.

Reusable WordPress/Woo/Kadence/upload/private-delivery evidence remains accepted and must not be rerun.

## 7. Confirmed Facts

- The Owner wants a product that turns family handwritten recipes into a formal cookbook artifact.
- Birthday Magazine Studio provides a reusable architecture/governance reference for WordPress/WooCommerce, zero-token preview, order-bound upload, private delivery and staged payment validation.
- Handwriting OCR is materially different from printed-text OCR and must be benchmarked rather than assumed.
- The product must preserve source images and uncertainty so that cooking facts are not silently invented.
- No current production deployment exists.

## 8. UNKNOWN / Open Risks

- first product/benchmark language is **English-first, not English-only**; multilingual guarantees beyond tested languages remain open;
- test price and exact paid package;
- exact number of recipes/pages/photos per product;
- OCR UX is one consolidated review/approval stage with manual editing; exact acceptable edit burden will be calibrated by R3 rather than frozen as a per-page popup count;
- handwriting/language coverage;
- exact correction UI;
- image preprocessing path;
- whether a bounded specialized OCR API materially improves PP-OCRv6's 11 hard handwriting cases;
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

- G2A1-D1 Owner decisions are resolved.
- R3A is formally PASS with `PP-OCRv6_medium` as the sole local primary.
- Current Gate: **G2A1-R3B bounded API fallback benchmark — READY_FOR_EXECUTOR**.
- Owner authorized Google-first / Mistral-second testing on only the 11 public hard cases, budget cap **USD 0.20**.
- If Google materially improves fidelity/edit burden, stop without Mistral.
- If credentials/provider setup are missing, return a precise Owner blocker; never expose Secret values.
- Do not rerun WordPress/WooCommerce/Kadence/upload/private-delivery.
- G2A2 remains HOLD until R3B selects one fallback or proves FALLBACK=NONE.

## 13. Status Summary

- Overall progress: reusable commerce/input/delivery feasibility is proven; OCR has real benchmark evidence but requires target-language/semantic-threshold calibration.
- Final goal: private, reliable family recipe intake → faithful transcription/structuring → proof → cookbook PDF → later optional print.
- Current Gate: **G2A1-R3B bounded API fallback benchmark**.
- Accepted local primary: **PP-OCRv6_medium**.
- Next after Owner approval: test the 11 hard cases with specialized API fallback → select one fallback or NONE → close G2A1 → G2A2 exact MVP contract.
- Attention: never treat clean OCR demos, model self-confidence or a visually nice PDF as proof that recipe facts are correct.
