# Birthday Magazine Studio — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance: `vps-project-governance v0.1.6` + Governance Source Policy rev1 + Production Provider Canary/Recovery Contract rev2  
> Executor facts: `EXECUTOR_HANDOFF.md`  
> Detailed evidence: `EXECUTION_EVIDENCE.md`  
> Last reviewed: 2026-09-30

## 1. Project Goal

- Final goal: let a buyer turn photos and structured answers into a polished, personalized birthday magazine PDF without designing it manually.
- Accepted product direction: browser-local zero-model-cost preview before payment; full personalized production only after confirmed payment and complete intake.
- Current business goal: preserve the now-passed PayPal Sandbox payment/entitlement/refund baseline and decide separately whether/when to enter a bounded Live PayPal Canary. Production AI provider integration remains deferred.
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

### Current implemented / proven artifacts
- Static browser prototype: `prototype/index.html`; simulation only.
- G2B local Solution Proof: synthetic intake → real interactive-model structured content → grounding → deterministic 12-page US Letter PDF → QA.
- G3A local commerce proof: isolated Docker Compose + WordPress + WooCommerce + MariaDB + Mailpit, including account-bound private workspace authorization.
- G3B Sandbox proof package: isolated Docker/MariaDB runtime + official WooCommerce PayPal Payments + temporary HTTPS origin. PR #54 closes the full Sandbox loop: existing payment reconciliation, paid-entitlement/idempotency, one Owner-authorized full refund, entitlement revocation, and scoped cleanup.
- None of the above is a production deployment.

### Production architecture
- Storefront/CMS: **WordPress + WooCommerce — ACCEPTED**.
- Canonical commerce/order system: **WooCommerce**.
- Payment: **PayPal via the official WooCommerce PayPal Payments plugin — ACCEPTED**.
- Payment implementation reference: follow the Mini Craft sequence: local WooCommerce commerce loop first → PayPal Sandbox connection/checkout/capture/callback/refund validation → bounded Live/real-payment Canary later. Do not hand-code PayPal API or introduce a second order system unless a later Reviewer Gate explicitly changes this.
- Payment evidence boundary: Mini Craft is an implementation/reference path only; its current state does not prove Birthday Magazine Live payment.
- Free-value path: deterministic browser-local preview only; **0 LLM / vision / image-generation Token**.
- Paid entitlement boundary: model generation is permitted only after server-side WooCommerce/PayPal paid state is confirmed **and** required intake is complete.
- Frontend foundation: **Blocksy Theme + Wedding starter — OWNER SELECTED on 2026-09-30, Gutenberg preferred**. Full G3C implementation is intentionally held until G3CR2 proves Wedding/Gutenberg importability and WooCommerce/account compatibility in a fresh isolated runtime. The custom Good Issue-style browser-local Free Preview remains the accepted core conversion component. Final visual freeze still requires Owner review after implementation.
- Storelly: **REJECTED for the current free-preview path**.
- Post-payment photo intake: Vanquish Upload Files is a **registered-account reuse candidate**. Its guest-issued secure file link replayed outside the intended guest context, so the guest-private path is **REJECTED AS-IS**.
- Private proof/final attachment: Vanquish Attach Me is a **registered-account reuse candidate**. Actual authorized download/hash passed, but its guest-issued attachment link replayed outside the intended guest context, so strict guest-private delivery is **REJECTED AS-IS**.
- Customer access model: **authenticated customer account is REQUIRED for MVP — Owner decision 2026-09-27**. Guest/no-account private upload and delivery are out of MVP scope.
- Background jobs: use the WordPress/WooCommerce Action Scheduler pattern first; do not introduce Redis/Celery/RabbitMQ without an observed need.
- Generation service/worker: project-specific asynchronous generation boundary; exact runtime/provider = `UNKNOWN`.
- Generation idempotency: one paid order → at most one active canonical generation job; duplicate callback/refresh must not duplicate model spend.
- PDF rendering engine: **Solution Proof uses pdf-lib 1.17.1**; final production render engine remains `UNKNOWN`.
- Data/persistence: **G3A/G3B local proof uses MariaDB**. Final production persistence topology remains `UNKNOWN`.
- Object/file storage: `UNKNOWN`.
- Auth/order-private access: account + WooCommerce-order ownership is accepted and locally proven in G3A; exact production login mechanism (magic link vs standard Woo password setup) remains `UNKNOWN`.
- Deployment target: production `UNKNOWN`; G3 local/Sandbox proof uses isolated Docker Compose + WordPress + MariaDB + Mailpit. G3B may temporarily expose only the local runtime through a bounded HTTPS Sandbox origin.
- Shared VPS dependency: none currently accepted.
- Target-host execution boundary: no target-host or production write is authorized or claimed.

## 4. Current State

```text
P0  Governance Intake / Truth Reconciliation             ✅ PASS
G1  Product / Offer Baseline                            ✅ PASS (Owner decisions; not transaction proof)
G2A1 Frontend + Reusable Component Feasibility PoC      ✅ PASS
G2A1R1 Evidence Closure                                 ⏹ CLOSED — executor RETURN produced final technical finding
G2A2 MVP Product Contract Freeze                        ✅ PASS
G2B  Local AI/PDF Solution Proof                        ✅ PASS — real-AI content/rendering proven; production provider deferred
G2BR1 Real AI Generation Closure                        ↩ RETURN — nested Codex transport failed
G2BR2 Host Codex Transport + Real-AI Closure             ↩ RETURN — WebSocket failure + HTTP 401
G2BR3 Direct Codex Agent Real-AI Content/PDF Proof       ✅ PASS
G3A WordPress + WooCommerce Commerce Loop               ✅ PASS
G3B PayPal Sandbox + Paid Entitlement Flow              ✅ PASS — capture correlation + entitlement/idempotency + refund/revocation
G3BR1 Sandbox Reconciliation + Entitlement/Refund       ✅ PASS — closes parent G3B
G3C UI/UX Productization                               ↩ RETURN — prior Astra Block Editor path failed; parent implementation not complete
G3CR1 Bestselling Author Elementor Closure               ⏹ SUPERSEDED BEFORE EXECUTION — Owner changed selected template
G3CR2 Blocksy Wedding + WooCommerce Canary               ↩ RETURN — merged CLI dependency list ambiguous
G3CR2R1 Wedding Gutenberg Variant Dependency Closure      ↩ RETURN — legacy single-demo endpoint returned false
G3CR2R2 Wedding v2 Dashboard Catalogue Closure            ⏳ CURRENT — query exact current UI catalogue record, then resume canary if clean
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
- `OWNER_DECISION_MVP_AUTHENTICATED_ACCOUNT_REQUIRED_2026-09-27`
- `PASS_G2A2_MVP_PRODUCT_CONTRACT_FREEZE_2026-09-27`
- `RETURN_G2B_REAL_AI_PROOF_REQUIRED_2026-09-27`
- `OWNER_AUTHORIZED_G2BR1_MAX_3_SYNTHETIC_AI_CALLS_2026-09-27`
- `OWNER_SELECTED_G2BR1_CODEX_PLUS_ROUTE_2026-09-27`
- `RETURN_G2BR1_NESTED_CODEX_TRANSPORT_FAILED_2026-09-27`
- `OWNER_AUTHORIZED_G2BR2_MAX_2_HOST_CODEX_RUNS_2026-09-27`
- `RETURN_G2BR2_CODEX_SUBSCRIPTION_PROGRAMMATIC_PATH_UNPROVEN_2026-09-27`
- `OWNER_AUTHORIZED_G2BR3_DIRECT_AGENT_PROOF_2026-09-27`
- `PASS_G2BR3_DIRECT_AGENT_REAL_AI_CONTENT_RENDER_PROOF_2026-09-27`
- `PASS_G2B_CONTENT_RENDERING_SOLUTION_PROOF_2026-09-27`
- `PASS_G3A_WORDPRESS_WOOCOMMERCE_COMMERCE_ACCOUNT_LOOP_2026-09-27`
- `RETURN_G3B_PROVIDER_CAPTURE_CORRELATION_AND_REMAINDER_REQUIRED_2026-09-28`
- `OWNER_AUTHORIZED_G3BR1_ONE_SANDBOX_FULL_REFUND_ORDER_30_2026-09-28`
- `PASS_G3BR1_SANDBOX_RECONCILIATION_ENTITLEMENT_REFUND_2026-09-28`
- `PASS_G3B_PAYPAL_SANDBOX_PAID_ENTITLEMENT_FLOW_2026-09-28`
- `OWNER_CORRECTED_G3C_TEMPLATE_SELECTION_OPEN_2026-09-29`
- `OWNER_SELECTED_G3C_ASTRA_BESTSELLING_AUTHOR_2026-09-29`
- `REVIEWER_OPENED_G3C_UI_UX_PRODUCTIZATION_2026-09-29`
- `RETURN_G3C_BLOCK_EDITOR_STARTER_NOT_FOUND_2026-09-30`
- `REVIEWER_OPENED_G3CR1_ELEMENTOR_CLOSURE_2026-09-30`
- `OWNER_SUPERSEDED_ASTRA_WITH_BLOCKSY_WEDDING_2026-09-30`
- `REVIEWER_OPENED_G3CR2_BLOCKSY_WEDDING_WOOCOMMERCE_CANARY_2026-09-30`
- `REVIEWER_ACCEPTED_G3CR2_DEPENDENCY_AMBIGUITY_RETURN_2026-09-30`
- `REVIEWER_OPENED_G3CR2R1_VARIANT_DEPENDENCY_CLOSURE_2026-09-30`
- `REVIEWER_ACCEPTED_G3CR2R1_VARIANT_METADATA_RETURN_2026-09-30`
- `REVIEWER_OPENED_G3CR2R2_V2_CATALOG_CLOSURE_2026-09-30`

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
- Real-AI content/rendering Solution Proof: proven on the frozen synthetic fixture via G2BR3; unattended production provider integration remains unproven.
- WooCommerce commerce/account/private-workspace loop: proven locally via G3A.
- PayPal Sandbox: **PASS** for one bounded synthetic transaction lifecycle — one completed USD 39.99 capture correlated to Woo order #30, paid-entitlement 0→1 behavior, one Owner-authorized full refund, provider/Woo refund correlation, entitlement revocation, and scoped cleanup.
- Real customer / real-money payment: **not tested**.
- Private production PDF delivery: not implemented/proven.
- Repeatability/economics: unknown.
- Production website: not built/deployed.

## 6. Gate Results and Current Gate

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

### Owner decision accepted

The Owner selected the recommended MVP access model:

- authenticated customer account is required;
- private photo upload, proof review, revision and final PDF access are tied to that authenticated account + WooCommerce order;
- guest/no-account private fulfillment is out of MVP scope;
- the rejected guest bearer-link plugin paths do not need replacement before G2B/G3 for the MVP.

### G2A2 result

G2A2 is **PASS**.

Canonical frozen product contract:
- [docs/MVP_PRODUCT_CONTRACT.md](./docs/MVP_PRODUCT_CONTRACT.md)

Key frozen decisions:
- 12 total pages;
- 12–25 source photos;
- up to 3 must-use;
- ~10–14 selected;
- six required short prompts;
- fixed emotional spine + two dynamic modules;
- three style presets on one page architecture;
- no AI-generated imagery;
- one bounded revision batch;
- account-required private workspace;
- source/intermediate deletion within 24 hours after final approval/delivery;
- final PDF retained for 72 hours.

### G2B Reviewer result

G2B **content/rendering Solution Proof is PASS**.

PR #30 remains the accepted partial/reference baseline. PR #46 / G2BR3 supplies the previously missing real-model content/rendering evidence.

Accepted across the combined evidence:
- synthetic intake validation;
- metadata photo mapping and all must-use handling;
- unchanged structured-content schema;
- real interactive-model structured generation;
- grounding/hallucination audit on actual model-authored output;
- exactly two supported dynamic modules;
- shared 12-page deterministic architecture;
- three style presets;
- actual 12-page US Letter PDF render/open verification;
- 375px/browser overflow verification;
- deterministic QA and negative mutation checks;
- durable artifacts and cleanup;
- no forbidden payment/production actions.

Explicitly deferred rather than misclassified as PASS:
- unattended production provider/runtime;
- remote provider authentication;
- remote provider-spend idempotency;
- per-order production provider cost.

The human-authored reference fixture remains renderer baseline evidence only and was not used as the G2BR3 AI-output fallback.

Current PASS decision:
- [docs/REVIEWER_DECISION_G2BR3_PASS.md](./docs/REVIEWER_DECISION_G2BR3_PASS.md)

### G2BR1 Reviewer result

G2BR1 is **RETURN**, not PASS.

PR #40 is accepted and merged as durable RETURN evidence.

Accepted:
- ChatGPT login preflight passed;
- three authorized Codex child-process attempts started;
- all three failed before any structured model response;
- later failures were categorized only as NETWORK_OR_TRANSIENT;
- no reference fixture fallback was misrepresented as AI output;
- no grounding, actual-AI PDF or actual-AI QA was claimed;
- duplicate invocation after the failed job was rejected before a fourth Codex process;
- no forbidden G3/payment/customer/API-key work occurred.

Reviewer interpretation:
- the accepted G2B schema/renderer/PDF baseline is not invalidated;
- the failing topology was Codex Agent command sandbox → nested codex exec;
- the exact transport/network root cause remains UNKNOWN.

Current decision:
- [docs/REVIEWER_DECISION_G2BR1_RETURN.md](./docs/REVIEWER_DECISION_G2BR1_RETURN.md)

### G2BR2 Reviewer result

G2BR2 is **RETURN**, not PASS.

PR #43 is accepted and merged as durable RETURN evidence.

Accepted:
- host ChatGPT login preflight passed;
- attempt 1 failed with `WEBSOCKET_FAILURE`;
- attempt 2 used an HTTP-only custom provider and failed with HTTP 401 `AUTHENTICATION`;
- authorized model runs are exhausted at 2 / 2;
- successful structured responses = 0;
- no actual-AI grounding/PDF/QA was claimed;
- no reference fixture fallback was misrepresented as AI output;
- no API key, extra credit purchase, payment, customer data, VPS/public deployment or G3 work occurred.

Reviewer interpretation:
- the Owner's Plus/Codex account itself is not proven unusable;
- the specific programmatic subscription path `harness → codex exec → ChatGPT-subscription inference` remains unproven;
- the accepted G2B schema/renderer/PDF baseline remains valid;
- do not spend more time on Codex CLI transport for this Solution Proof.

Current decision:
- [docs/REVIEWER_DECISION_G2BR2_RETURN.md](./docs/REVIEWER_DECISION_G2BR2_RETURN.md)

### G2BR3 Reviewer result

G2BR3 is **PASS**.

PR #46 is accepted and merged.

Verified:
- one primary direct interactive-Agent generation and zero correction generations;
- unchanged accepted schema and unchanged synthetic intake;
- schema validation PASS with zero errors;
- grounding PASS with 12 claims and 17 exact intake excerpts;
- exactly two distinct supported dynamic modules;
- actual model-authored content rendered to a 12-page US Letter PDF;
- browser read-back, 375px checks and 15/15 negative mutations passed;
- reference fixture fallback was not used;
- no API key, nested Codex execution, extra-credit purchase, real customer data or G3 action occurred.

Provider-job/spend idempotency was explicitly NOT TESTED and is deferred to the production provider integration boundary. The exact self-reported model identifier is not independently verified and is not part of the PASS basis.

Decision:
- [docs/REVIEWER_DECISION_G2BR3_PASS.md](./docs/REVIEWER_DECISION_G2BR3_PASS.md)

### G3A Reviewer result

G3A is **PASS**.

PR #49 is accepted and merged.

Verified:
- Docker Compose + WordPress + WooCommerce + MariaDB + Mailpit runtime;
- USD 39.99 virtual product and native WooCommerce cart/checkout;
- offline test order remained unpaid/on-hold;
- checkout-created account without separate pre-checkout registration;
- Buyer A order/workspace ownership;
- Buyer B and guest private-workspace denial, including direct URL replay;
- local entitlement remained closed with generation/model counters at zero;
- no PPCP, PayPal, real payment, public origin, model provider, VPS or G3B work;
- scoped cleanup preserved unrelated Docker identities, including Mini Craft.

Decision:
- [docs/REVIEWER_DECISION_G3A_PASS.md](./docs/REVIEWER_DECISION_G3A_PASS.md)

### G3B / G3BR1 Reviewer final result

G3B and its reconciliation closure G3BR1 are **PASS** at Sandbox scope.

PR #54 is accepted and merged.

Verified:
- official WooCommerce PayPal Payments 4.1.3 in Sandbox;
- exactly one completed provider capture correlated to Woo order #30 at USD 39.99;
- no duplicate capture;
- paid + intake incomplete => 0 canonical generation-ready jobs;
- intake complete => exactly 1 canonical deferred job;
- repeated bounded local entitlement evaluation retained exactly 1 job;
- model calls remained 0;
- exactly one Owner-authorized full USD 39.99 Sandbox refund through WooCommerce + official PPCP;
- provider refund cardinality 1, status COMPLETED;
- Woo/provider refund correlation PASS;
- duplicate refund NO;
- canonical job preserved as audit record and moved to `cancelled`;
- entitlement moved to `revoked`;
- deferred generation action/cron = 0;
- G3B Docker/tunnel/temp resources removed;
- Mini Craft/unrelated resource fingerprints unchanged.

Scope limitation:
- local serial/replay entitlement idempotency is proven;
- production concurrent/atomic job creation and remote model-spend idempotency remain unproven;
- Live/real-money payment is not proven.

Decision:
- [docs/REVIEWER_DECISION_G3BR1_G3B_PASS.md](./docs/REVIEWER_DECISION_G3BR1_G3B_PASS.md)

### Next Gate — G4 Bounded Live PayPal Transaction Canary

Status:
- **HOLD / NOT AUTHORIZED**;
- no Live merchant enablement, real-money payment, real refund, production-domain cutover or production deployment is authorized by the G3B PASS;
- G4 requires a separate bounded Reviewer contract and fresh Owner authorization before execution.

### Current Gate rollback / recovery

- G3BR1 must operate on the already-observed Sandbox transaction; payment replay is not a rollback strategy.
- Before any refund/mutation, use fresh read-only reconciliation and exact correlation.
- The disposable G3B runtime can be reconstructed from committed project-local Docker/WordPress artifacts if needed; do not reuse Mini Craft state.
- Temporary HTTPS origin and WordPress URL rebound are reversible and must be restored/stopped at Gate cleanup.
- No production resource is in scope.

## 7. Confirmed Facts

- The project directory contains the original browser prototype plus accepted G2B/G3A/G3B local/Sandbox proof artifacts and supporting research.
- The browser sample itself does not charge money or call an AI API; separate G3B Sandbox evidence now exists, but no Live/real-money payment has occurred.
- The current proofs do not constitute production payment, unattended production generation, production PDF delivery or independently archived market validation.
- US-first, English-first, digital PDF, US$39.99, zero-token preview and post-payment AI direction are Owner-confirmed.
- WordPress + WooCommerce is now the accepted commerce baseline.
- PayPal through the official WooCommerce PayPal Payments plugin is now the accepted payment path, using Mini Craft as the implementation reference.
- The free path must remain deterministic and zero-model-token; paid AI spend is gated by confirmed payment entitlement plus complete intake.
- The reuse-vs-custom technical route is documented in `docs/TECHNICAL_ROUTE.md`.
- Good Issue-style WordPress preview is the accepted frontend feasibility foundation from G2A1.
- Storelly is rejected for the browser-local free-preview path. **Owner selected Astra Theme + the concrete free “Bestselling Author” starter template for G3C on 2026-09-29.** Kadence/Blocksy/Brandy and other candidates are not selected. The Good Issue preview remains the custom core interaction inside the Astra shell.
- Vanquish Upload Files and Vanquish Attach Me are registered-account reuse candidates only; their guest bearer-link paths are rejected for strict private MVP use.
- Other WordPress/plugin research remains candidate research unless separately accepted.
- Mini Craft's accepted commerce/payment history is an implementation reference for G3A/G3B: Docker/MariaDB is preferred over Studio/SQLite, commerce is proven before PPCP, and public HTTPS origin requirements are deferred to G3B.
- There is no current production deployment.

## 8. UNKNOWN / Open Risks

- archived details of the Owner-reported demand validation;
- exact buyer segment within the US market;

- seller merchant/bank account country;
- PayPal merchant/account eligibility, settlement currency behavior and actual fees for the eventual seller account;
- production generator/model/provider selection remains UNKNOWN; G2BR1 uses ChatGPT-authenticated Codex only as a bounded Solution Proof path;
- real per-order AI/render/storage cost;
- production storage topology and implementation; account/order access policy is accepted and locally proven, while the 24h/72h deletion windows are frozen in the MVP contract;
- final subjective visual/product foundation after G2A2;
- exact account authentication implementation (magic link vs standard WooCommerce password setup), provided it preserves the frozen no-separate-precheckout-registration product requirement;
- exact PDF render engine;
- actual production hosting;
- production refund/cancellation policy; Sandbox refund mechanics are proven, but Live/real-money refund behavior remains unproven;
- real transaction conversion and acquisition cost.

## 9. Owner-only Checkpoints

- Payment/purchase: required before any paid service/plugin/hosting purchase or real buyer payment test.
- Identity/account authorization: required for any payment/hosting/provider account onboarding.
- Secret entry/rotation: Owner-only unless a later exact delegated allowlist is explicitly authorized.
- Irreversible operation: none in current Gate.
- Material production enablement: not authorized.
- Major business/compliance decision: seller merchant country, target-country expansion, final customer terms/refund policy.

## 10. Resource Baseline

- Static prototype and proof source/artifacts are in GitHub.
- G3A proved an isolated project-scoped Docker/MariaDB/Mailpit runtime and scoped cleanup.
- G3B cleanup is complete: project containers/volumes/network = 0, temporary tunnel = 0, ignored project `.tmp` removed, unrelated/Mini Craft fingerprints unchanged.
- Root disk / VPS: N/A for current Gate; no VPS deployment is authorized.
- Production data: none.
- If Shared VPS is selected later, Storage Layout Contract rev1 and `PROJECT_STORAGE_MANIFEST.md` become mandatory before deployment.

## 11. Rollback / Recovery

- Code/document rollback point: Git history.
- G3B runtime is disposable/local; any reconstruction must use committed project-local Compose/scripts rather than Mini Craft resources.
- Temporary HTTPS origin is test-only and must be stopped/restored after G3B closure.
- No production release/image or production customer database exists.
- Sandbox credentials remain Owner-controlled and must not be exported into repository evidence.

## 12. Next Step

- G3B/G3BR1 are closed with Reviewer PASS.
- **PR #59 remains accepted historical RETURN evidence for the prior Astra Block Editor path.**
- The Owner has now superseded Astra Bestselling Author with **Blocksy Wedding**, preferring the Gutenberg variant.
- **G3CR2 and G3CR2R1 RETURNS are accepted. Current Gate: G3CR2R2 Wedding v2 Dashboard Catalogue Closure.**
- Owner decision: `docs/OWNER_DECISION_G3C_BLOCKSY_WEDDING.md`.
- Research proof: `docs/BLOCKSY_WEDDING_SELECTION_PROOF_2026-09-30.md`.
- Parent return decision: `docs/REVIEWER_DECISION_G3CR2_RETURN.md`.
- Latest return decision: `docs/REVIEWER_DECISION_G3CR2R1_RETURN.md`.
- Current closure contract: `docs/G3CR2R2_BLOCKSY_WEDDING_V2_CATALOG_CLOSURE.md`.
- Full G3C visual implementation and Good Issue integration remain HOLD until Reviewer accepts the compatibility canary.
- Owner visual freeze remains pending.
- G4 Live PayPal Canary remains **HOLD / NOT AUTHORIZED** until G3C visual/product review is complete and a separate bounded G4 contract is approved.
- Production AI interface details remain deferred until the Owner supplies them.

## 13. Status Summary

- Overall progress: product direction, clickable sample, commerce baseline, PayPal path and free/paid Token boundary are fixed; production system does not yet exist.
- Final goal: PayPal-paid personalized birthday magazine PDF workflow.
- G2A1: PASS.
- G2A1R1: closed; its Executor RETURN is preserved as the evidence that the current guest plugin links are bearer-replayable and therefore rejected for strict guest-private use.
- G2A2: PASS; `MVP_PRODUCT_CONTRACT.md` is frozen.
- Privacy retention is frozen at 24h for source/intermediate assets and 72h for final PDF.
- G2B: PASS for the real-AI content/rendering Solution Proof; unattended production provider integration is deferred.
- G2BR1: RETURN; three nested Codex CLI attempts failed before model output and the approved 3-run cap is exhausted.
- G2BR2: RETURN; two host-context Codex attempts failed before model output (WebSocket failure, then HTTP 401).
- G2BR3: PASS; one direct interactive-Agent generation passed schema, grounding, modules, 12-page PDF and deterministic QA.
- Current unresolved production boundary: unattended provider/runtime + provider-spend idempotency + per-order provider cost.
- G3A: PASS — local Docker/MariaDB WooCommerce commerce/account/private-workspace loop.
- G3B: PASS — bounded PayPal Sandbox payment/capture correlation, paid-entitlement/idempotency, one full refund, entitlement revocation and cleanup are closed.
- G3BR1: PASS — reconciliation/refund closure completed; parent G3B closed.
- G3C: prior Astra Block Editor implementation attempt RETURN; no product page was built and no visual freeze occurred.
- G3CR1: SUPERSEDED BEFORE EXECUTION by the Owner’s new template choice.
- G3CR2: RETURN accepted — `wp blocksy demo list` merges builder variants and did not provide builder-specific dependency proof.
- G3CR2R1: RETURN accepted — legacy `fetch_single_demo(Wedding,gutenberg,all)` returned false and did not expose dependencies.
- G3CR2R2: CURRENT — use the current dashboard's `v2/demo/get_all` catalogue, select the individual `Wedding` + `gutenberg` record without merging, inspect its own plugin list, then resume the Wedding import + WooCommerce compatibility canary if clean.
- G4: HOLD — Live/real-money Canary requires G3C completion, a new contract + fresh Owner authorization.
- Attention: do not let old research, WordPress candidates or simulated checkout be mistaken for production evidence.
