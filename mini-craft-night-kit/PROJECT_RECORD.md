# Mini Craft Night Kit — PROJECT RECORD

Last updated: 2026-09-21

## Current Truth

```text
STRATEGIC_PIVOT_TO_KADENCE_SINGLE_PRODUCT=APPROVED
OLD_19_PAGE_HIGH_FIDELITY_ROUTE=PAUSED
OLD_PROJECT=KEEP
MANUAL_06_19_REBUILD=STOP

UI_GROWTH_PRE_REVIEW=APPROVED
CLONE_UI_ROLE=VISUAL_ASSIST_ONLY
MINIMAL_PLUGIN_POLICY=APPROVED
CANONICAL_COMMERCE_SYSTEM=WOOCOMMERCE
MVP_PAYMENT=WOOCOMMERCE_PAYPAL_PAYMENTS
DUJIAO_SECOND_ORDER_SYSTEM=NO
GITHUB_HANDOFF_PROTOCOL=TRIAL_APPROVED

K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC=PASS
K0R1_LOCAL_PROJECT_HYGIENE_CLEANUP=PASS
K0R2_WORDPRESS_STUDIO_CONSOLIDATION=PASS_RETAINED_READ_ONLY
ACTIVE_LOCAL_RUNTIME=DOCKER_MARIADB
ACTIVE_LOCAL_URL=http://localhost:8093/
CURRENT_GATE=K3R10_PAYPAL_SANDBOX_CHECKOUT_CAPTURE
K1_STATUS=SPLIT_K1A_K1B
WORDPRESS_STUDIO_CONSOLIDATION=PASS
VPS=DEFERRED
PRODUCTION_PAYMENT=DEFERRED

GITHUB_HANDOFF_TRIAL_SUCCESS_COUNT=4
GITHUB_HANDOFF_TARGET_FOR_GLOBAL_GOVERNANCE=3
```

## Why the route changed

旧路线从 CrossBorder / Medusa 视觉参考出发，手工迁移到 Gutenberg 并计划逐页复刻 01–19。

旧路线已完成：
- 01 Home：高保真 PASS；
- 02–05：高保真 PASS。

随后发现：
- Gutenberg Invalid Block；
- 超宽屏 / zoom-out 响应式迁移不完整；
- 继续实现 06–19 会重复建设 WooCommerce 已有能力。

因此转为成熟 WordPress 电商路线。

## New Architecture

```text
WordPress
→ Kadence Theme
→ Kadence Blocks
→ Kadence Single Product Starter Template
→ WooCommerce
→ Minimal Brand Adaptation
→ WooCommerce PayPal Payments
→ Conversion / Trust
→ RC QA
→ VPS
→ Production Canary
```

## Gate Status

### K0 — Kadence Local PoC — PASS

Verified:
- exact Single Product full-site import;
- Home / Product / Cart / Checkout runtime;
- Gutenberg valid, invalid block count 0;
- WooCommerce baseline;
- mobile/tablet/desktop/ultra-wide responsive baseline;
- old project unchanged;
- no brand customization;
- no payment;
- no VPS.

Formal Reviewer decision:
- `docs/REVIEWER_DECISION_K0_PASS.md`

### K0R1 — Local Project Hygiene Cleanup — PASS

Verified:
- five K0-generated WooCommerce download/extraction artifacts removed;
- shared workspace root no longer contains K0 temporary artifacts;
- project root remains clean;
- Home / Product / Cart / Checkout remain healthy;
- old project unchanged;
- unrelated projects untouched;
- no Docker volume deletion;
- no payment;
- no VPS.

Formal Reviewer decision:
- `docs/REVIEWER_DECISION_K0R1_PASS.md`

### Responsive baseline correction

The earlier K0 375px mobile PASS subclaim is superseded by K0R2 evidence. Current truth:

```text
K0_FUNCTIONAL_BASELINE=PASS
K0_MOBILE_375_VISUAL_BASELINE=KNOWN_DEFECT
K1_MUST_FIX_MOBILE_375=YES
```

The defect reproduces on both Docker source and Studio import, so it is not a Studio migration regression.

Formal Reviewer decision:
- `docs/REVIEWER_DECISION_K0R2_RECONCILED_PASS.md`

### Owner Studio migration review — PASS

Owner confirmed the Studio-managed site opens normally and is accepted as the active local development base.

### Current Gate — K1 UI/Growth Decision + Brand Adaptation

Owner should inspect the Studio-managed `Mini Craft Night Kit` site

At minimum:
- Home
- Product
- Cart
- Checkout

K1 is now approved to execute. The inherited 375px mobile clipping fix is mandatory within K1.

### K1 — UI/Growth Decision + Brand Adaptation

If Owner chooses USE:

Owner + Reviewer + Growth/Acquisition Framework first confirm:
- Offer hierarchy;
- Hero;
- CTA;
- Trust;
- KEEP / ADAPT / DROP;
- required product facts;
- visual adaptation boundary.

Only then Executor implements.

### K2 — WooCommerce Commerce Loop
Product → Cart → Checkout → Order → Confirmation.

### K3 — Payment
MVP fixed as WooCommerce + WooCommerce PayPal Payments.

Dujiao is not a second canonical order system.

### K4 — Conversion & Trust
Home / Product / FAQ / Shipping & Returns / Contact.

### K5 — Release Candidate QA
Responsive, Gutenberg validity, WooCommerce, email, SEO, performance, Secret hygiene.

### K6 — VPS Deployment
Only after local RC PASS.

### K7 — Production Canary
Low-value real order → payment → state → email → refund/cancel → launch.

## UI Governance

clone-ui is visual-assist only.

UI PASS requires:

```text
VISUAL_FIDELITY=PASS
GUTENBERG_VALIDITY=PASS
RESPONSIVE=PASS
WOOCOMMERCE_BEHAVIOR=PASS
OWNER_EDITABILITY=PASS
BUSINESS_TRUTH=PASS
```

## Plugin Policy

K0 baseline:
- Kadence Theme
- Kadence Blocks
- Starter Templates
- WooCommerce

Future plugins are added only when a current MVP capability requires them.

## GitHub Handoff

Reviewer owns:
- `PROJECT_RECORD.md`
- `REVIEWER_HANDOFF.md`
- Reviewer Decision docs

Executor owns:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`
- bounded evidence indexes

Trial status:

```text
SUCCESSFUL_GATES=2
TARGET=3
```

After at least 3 stable Gates, open a Governance Change Gate before promoting this protocol globally.

Candidate Governance rule now validated twice:
- project-generated downloads, extraction directories, helper files, caches, and temporary artifacts must remain inside the project directory or be removed before PASS_CANDIDATE;
- shared workspace roots must not be polluted by project execution.

## Current Documents

- `docs/PROJECT_PLAN_AND_ROADMAP.md`
- `docs/UI_GROWTH_AND_FIDELITY_DECISION.md`
- `docs/PLUGIN_AND_OPERATIONS_PLAN.md`
- `docs/PAYMENT_ARCHITECTURE_DECISION.md`
- `docs/GITHUB_HANDOFF_PROTOCOL.md`
- `docs/REVIEWER_DECISION_K0_PASS.md`
- `docs/REVIEWER_DECISION_K0R1_PROJECT_HYGIENE_RETURN.md`
- `docs/REVIEWER_DECISION_K0R1_PASS.md`

## Current Next Action

Current Gate:

`K1_UI_GROWTH_DECISION_AND_BRAND_ADAPTATION`

Formal decision:
- `docs/REVIEWER_DECISION_K1_UI_GROWTH_BRAND_ADAPTATION.md`

WordPress Studio is the active local development base. Docker PoC remains rollback only. K1 must perform minimal Mini Craft brand/growth adaptation and fix the inherited 375px clipping.


## K1 Split

K1 is now split into:

- K1A: Visual Direction + Growth Mapping
- K1B: WordPress implementation after Owner visual approval

Formal decision: `docs/REVIEWER_DECISION_K1A_VISUAL_DIRECTION.md`.


## K1A Deliverable Ready

Reviewer completed `docs/K1A_VISUAL_DIRECTION_AND_GROWTH_MAP.md`.

Visual source decision: reuse the archived Mini Craft Home visual master as the visual reference while retaining Kadence as the implementation architecture.

Owner review marker: `OWNER_K1A_VISUAL_DIRECTION=PASS` or RETURN with requested direction changes.


## K1A Owner Decision

`OWNER_K1A_VISUAL_DIRECTION=PASS`

K1B is authorized. Codex must not generate final images; use approved existing assets or editable placeholders only.

Formal decision: `docs/REVIEWER_DECISION_K1B_WORDPRESS_IMPLEMENTATION.md`.


## K1B Technical Review

Reviewer accepted the technical implementation evidence.

```text
K1B_TECHNICAL_REVIEW=PASS
K1B_FINAL_REVIEW=PENDING_OWNER_VISUAL
K2_NOT_AUTHORIZED=YES
```

Formal decision: `docs/REVIEWER_DECISION_K1B_TECHNICAL_PASS_OWNER_VISUAL_PENDING.md`.

Owner must visually inspect the Studio-managed site before K1B is formally closed.


## K1B Final Review — PASS

Owner confirmed the initial visual implementation.

```text
OWNER_K1B_VISUAL=PASS
K1_UI_GROWTH_BRAND_ADAPTATION=PASS
```

Formal decision: `docs/REVIEWER_DECISION_K1B_PASS.md`.

Current Gate: `K2_WOOCOMMERCE_COMMERCE_LOOP`.

Final product/lifestyle image replacement remains a later controlled task and does not block K2.


## K2 Authorization

Formal decision: `docs/REVIEWER_DECISION_K2_WOOCOMMERCE_COMMERCE_LOOP.md`.

Current Gate: `K2_WOOCOMMERCE_COMMERCE_LOOP`.

K2 verifies local Product → Add to Cart → Cart → Checkout → Order → Confirmation. PayPal and real payment remain K3.


## K2 Final Review — PASS

Formal decision: `docs/REVIEWER_DECISION_K2_PASS.md`.

```text
K2_WOOCOMMERCE_COMMERCE_LOOP=PASS
CURRENT_GATE=K3_PAYPAL_SANDBOX
STUDIO_SQLITE_HOLD_STOCK_WORKAROUND=LOCAL_ONLY
GOVERNANCE_CHANGE_GATE_ELIGIBLE=YES
```

K2 test values (JPY 1, JPY currency, zero-cost shipping, tax disabled, COD test method, hold-stock=0) are not production business truth.


## K3 Authorization

Formal decision: `docs/REVIEWER_DECISION_K3_PAYPAL_SANDBOX.md`.

Current Gate: `K3_PAYPAL_SANDBOX`.

Use only official WooCommerce PayPal Payments in Sandbox. Owner intervention is limited to PayPal login/account authorization/identity/Secret/Live enablement. If localhost blocks provider callbacks, return to Reviewer instead of creating an unauthorized tunnel or VPS route.


## K3 Owner Checkpoint

Executor reached the approved Owner-only PayPal authorization boundary.

```text
RETURN=RETURN_OWNER_PAYPAL_SANDBOX_AUTH_REQUIRED
CURRENT_CHECKPOINT=OWNER_K3_PAYPAL_SANDBOX_AUTH
PAYPAL_LIVE_ENABLED=NO
REAL_PAYMENT_ACTIONS=0
```

Owner must complete the provider-side Sandbox login/account authorization from WooCommerce → Settings → Payments → PayPal Payments → Connect to PayPal, without sharing credentials or Secrets in chat/GitHub. After Owner confirmation, resume the same K3 Gate.


## K3R1 PPCP Conflict Isolation

K3 diagnostic returned `RETURN_REVIEWER_PPCP_CONFLICT_ISOLATION_REQUIRED` after capturing a PPCP 4.1.3 React mount fatal and associated admin/API timeout signals.

Reviewer authorizes one reversible test: temporarily deactivate only `woocommerce-paypal-payments`, retest WooCommerce admin/API health, and return. No uninstall, version change, backup restore, credential mutation, PayPal re-authorization, Live mode, public tunnel, VPS, or real payment.

Formal decision: `docs/REVIEWER_DECISION_K3R1_PPCP_CONFLICT_ISOLATION.md`.


## K3R1 Result / K3R2 Authorization

K3R1 returned `RETURN_K3R1_CONFLICT_NOT_ISOLATED`.

Accepted finding: PPCP 4.1.3 directly caused the Payments-page blank React mount failure, but broader WooCommerce Home/admin REST/Store API timeouts persisted with PPCP deactivated.

Next Gate is a non-destructive A/B comparison using a separate Studio clone restored from the retained pre-K3 backup. The current site must not be overwritten.

Formal decision: `docs/REVIEWER_DECISION_K3R2_PRE_K3_PARALLEL_BASELINE_COMPARISON.md`.


## K3R2 Result / K3R3 Authorization

K3R2 returned `RETURN_K3R2_STUDIO_OR_WOOCOMMERCE_RUNTIME_SYSTEMIC`: current site A and pre-K3 clone B both hang similarly even though B has no PPCP.

This disproves a K3/PPCP-only explanation for the broader timeout. K3R3 will use a fresh Studio control to separate Studio-runtime vs WooCommerce-on-Studio vs imported Mini Craft state, while keeping current site A read-only.

Formal decision: `docs/REVIEWER_DECISION_K3R3_STUDIO_WOOCOMMERCE_RUNTIME_ISOLATION.md`.


## K3R3 Result / K3R4 Authorization

K3R3 returned `RETURN_K3R3_STUDIO_RUNTIME_SYSTEMIC` after a completely fresh Studio WordPress control (no WooCommerce/PPCP/project data) reproduced the same request-hang and one-hot PHP worker pattern.

Accepted conclusion: the broader timeout is systemic to the current WordPress Studio runtime/host path, not Mini Craft, WooCommerce, or PPCP alone.

Next Gate moves local execution to a new isolated Docker + MariaDB runtime, while retaining all Studio sites and the K0 Docker PoC untouched.

Formal decision: `docs/REVIEWER_DECISION_K3R4_LOCAL_RUNTIME_ESCAPE_DOCKER_MARIADB.md`.


## K3R4 Final Review — PASS

Formal decision: `docs/REVIEWER_DECISION_K3R4_PASS.md`.

```text
K3R4_LOCAL_RUNTIME_ESCAPE_DOCKER_MARIADB=PASS
ACTIVE_LOCAL_RUNTIME=DOCKER_MARIADB
ACTIVE_LOCAL_URL=http://localhost:8093/
STUDIO_RUNTIME=RETAINED_READ_ONLY
```

K3 PayPal Sandbox remains incomplete. Current Gate: `K3R5_PAYPAL_SANDBOX_DOCKER`.

Formal K3R5 decision: `docs/REVIEWER_DECISION_K3R5_PAYPAL_SANDBOX_DOCKER.md`.


## K3R5 Result / K3R6 Authorization

K3R5 returned `RETURN_K3R5_PPCP_4_1_3_DOCKER_UI_CONFLICT` after reproducing React #299 on the healthy Docker/MariaDB runtime. However, the direct PayPal settings route and PPCP REST endpoints still returned HTTP 200, while the broader WooCommerce/runtime remained healthy.

Reviewer therefore does not authorize a version change yet. K3R6 will distinguish an overview-page-only mount defect from a truly broken direct PayPal settings UI.

Formal decision: `docs/REVIEWER_DECISION_K3R6_PPCP_PAGE_SCOPE_MOUNT_ISOLATION.md`.


## K3R6 Final Review — PASS / Owner Checkpoint

K3R6 returned `PASS_CANDIDATE_K3R6_PPCP_OVERVIEW_ONLY_UI_DEFECT` and `RETURN_OWNER_PAYPAL_SANDBOX_AUTH_REQUIRED_DOCKER`.

Reviewer accepts the direct PayPal settings page as usable. The React #299 defect is limited to the generic WooCommerce Payments overview and is carried as a known nonblocking admin defect.

Formal decision: `docs/REVIEWER_DECISION_K3R6_PASS_OWNER_SANDBOX_AUTH.md`.

Current checkpoint: `OWNER_K3_PAYPAL_SANDBOX_AUTH_DOCKER`.


## K3 Automatic Onboarding Callback Result / K3R7

Owner completed the provider-side PayPal flow, but local read-only inspection found no merchant connection, no onboarding completion, no merchant ID, and Sandbox mode remained off. The automatic flow is therefore not accepted as a Sandbox connection.

Reviewer chooses the official manual Sandbox connection path before authorizing any public callback/tunnel.

Formal decision: `docs/REVIEWER_DECISION_K3R7_PAYPAL_SANDBOX_MANUAL_CONNECTION.md`.

Current checkpoint: `OWNER_K3_PAYPAL_SANDBOX_MANUAL_CONNECT`.


## K3R7 Result / K3R8 Authorization

Official PPCP manual Sandbox connection still returns `Could not connect to PayPal. Please verify your credentials and try again.` after Owner re-entered Sandbox credentials.

Reviewer will now separate credential validity, container network/TLS, and PPCP 4.1.3 manual-connect behavior. No more blind reconnect attempts.

Formal decision: `docs/REVIEWER_DECISION_K3R8_PAYPAL_SANDBOX_CREDENTIAL_PLUGIN_ISOLATION.md`.


## K3R8 Phase A Result / Owner OAuth Checkpoint

Phase A passed: DNS and HTTPS/TLS reachability from the active Docker runtime to PayPal Sandbox are healthy. The unauthenticated PayPal Sandbox request returned HTTP 403 and is not treated as a credential result.

Current checkpoint: `OWNER_K3R8_SANDBOX_OAUTH_CHECK_REQUIRED`.

Owner must run the local secure OAuth helper generated by Executor. Only redacted PASS/FAIL + HTTP status may be returned; no Client ID, Secret, access token, Authorization header, or response body may be recorded.


## K3R8 Owner OAuth Result / K3R8B

Owner-run helper returned `PAYPAL_SANDBOX_OAUTH=FAIL ERROR=LOCAL_REQUEST_FAILURE`. This is not a credential verdict because no HTTP auth result was obtained.

Next bounded step is host-side/helper diagnostics with secrets remaining Owner-only.

Formal decision: `docs/REVIEWER_DECISION_K3R8B_LOCAL_OAUTH_HELPER_DIAGNOSTIC.md`.


## K3R8B Host/Helper Diagnostic Result

K3R8B host/helper diagnostics completed without classifying the Sandbox credentials as invalid. Executor returned `RETURN_OWNER_K3R8B_CORRECTED_HELPER_REQUIRED`.

Current checkpoint: `OWNER_K3R8B_CORRECTED_HELPER_REQUIRED`.

Owner should rerun the corrected local OAuth helper and return only its redacted result.


## K3R8B Owner Re-run Result / K3R8C

Corrected host helper still returned `POWERSHELL_REQUEST_EXCEPTION`; credentials remain unclassified. Reviewer will no longer use the Windows PowerShell HTTP stack for the credential verdict.

K3R8C moves the direct OAuth check into the active Docker/WordPress runtime and requires a mandatory diagnostic evidence packet for all further diagnostic handoffs.

Formal decision: `docs/REVIEWER_DECISION_K3R8C_CONTAINER_NATIVE_OAUTH_CHECK.md`.


## K3R8C Executor Result / Owner Container OAuth Checkpoint

Executor completed the container-native helper preparation and supplied a complete `DIAGNOSTIC_PACKET`. Reviewer accepts the evidence packet as sufficient for this checkpoint.

Current checkpoint: `OWNER_K3R8C_CONTAINER_OAUTH_REQUIRED`.

Owner must run the local wrapper and return only the five redacted fields. No Phase C is authorized until the container-native OAuth result is known.


## K3R8C Owner Run Result / K3R8D

Owner ran the exact K3R8C command and received `ERROR_CLASS=LOCAL_HELPER_MISSING` with HTTP status 0. This is not a credential or PayPal verdict.

The result conflicts with K3R8C evidence claiming the local helper artifacts remained available. Reviewer treats this as an Owner-checkpoint artifact readiness defect and requires repair plus post-cleanup end-to-end validation.

Formal decision: `docs/REVIEWER_DECISION_K3R8D_OWNER_HELPER_ARTIFACT_READINESS_REPAIR.md`.

## Owner Note — Handoff Experiment / Fresh Review

The original project-management Governance remains unchanged.

The recently proposed stronger GitHub handoff / review-packet method is **reference-only** and is not an active rule because it has not been proven end-to-end.

Owner request retained:

```text
AFTER_CURRENT_K3R8_ISSUE_RESOLVES=RUN_FRESH_OVERALL_PROJECT_REVIEW
REVIEW_BASIS=ACTUAL_CURRENT_SOURCE_RUNTIME_EVIDENCE
DO_NOT_ACCEPT_EXECUTOR_SUMMARY_AS_TRUTH_BY_ITSELF=YES
```

This is a project review action, not a Governance modification.

## K3R8D Executor Result / Owner OAuth Checkpoint

Reviewer inspected the latest GitHub `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md` for K3R8D.

Accepted at this checkpoint: the Executor's recorded diagnosis is internally consistent with the prior Owner-observed `LOCAL_HELPER_MISSING`, and the recorded repair targets the host-side PHP helper path/staging chain. Evidence records two no-secret end-to-end dry runs, retained local helper hashes/sizes, remote cleanup, and no credential use.

Limitation: the retained `.artifacts` helper files are local-only and are not themselves available through GitHub, so Reviewer has not independently inspected their bytes. The next Owner execution is therefore also the real end-to-end verification of the repaired local artifacts.

Current checkpoint: `OWNER_K3R8D_CONTAINER_OAUTH_REQUIRED`.

Do not classify Sandbox credentials until the Owner run returns an HTTP OAuth result.

## K3R8D Owner OAuth Result — PASS / Phase C Authorized

Owner executed the repaired container-native OAuth helper and returned:

```text
CONTAINER_OAUTH_STAGE=PHP_WP_REMOTE_POST
PAYPAL_SANDBOX_OAUTH=PASS
HTTP_STATUS=200
TOKEN_RECEIVED=YES
ERROR_CLASS=NONE
```

Accepted conclusion: the Sandbox Client ID + Secret pair entered in this run is valid, PayPal Sandbox is reachable from the active WordPress container, and the container WordPress HTTP stack can successfully obtain an OAuth access token.

This eliminates invalid credentials and container network/TLS as explanations for a failure involving the same credential pair.

Current Gate: `K3R8C_PHASE_C_PPCP_MANUAL_CONNECT_ISOLATION`.

Phase C should first inspect the existing PPCP manual-connect failure evidence without asking Owner to re-enter credentials. Only if the existing evidence is insufficient may one bounded retry with the same locally-entered credentials be requested.

## K3R8C Phase C Reviewer Assessment / K3R8E

Reviewer independently inspected the latest Executor evidence and PPCP 4.1.3 source.

Accepted: PPCP manual connect fails in its additional payee-probe stage after a valid Sandbox OAuth token was proven.

Correction: the Executor label `PPCP_MANUAL_CONNECT_DEFECT_CONFIRMED` is too strong. Current evidence still permits two adjacent causes: (1) PPCP 4.1.3's implementation/client path, or (2) PayPal Sandbox/account/app behavior during the exact create-order/get-order payee probe.

Current truth:

`K3R8C_PPCP_MANUAL_CONNECT_PAYEE_PROBE_FAILURE_CONFIRMED`

Next Gate: `K3R8E_PAYEE_PROBE_PARITY_TEST`.

Formal decision: `docs/REVIEWER_DECISION_K3R8E_PAYEE_PROBE_PARITY_TEST.md`.

## K3R8E Executor Result / Owner Payee-Probe Checkpoint

Reviewer inspected the latest K3R8E `EXECUTION_EVIDENCE.md`, `EXECUTOR_HANDOFF.md`, and the formal K3R8E decision.

Accepted for checkpoint readiness: the planned parity test matches the approved semantics (Sandbox OAuth → create USD 1.00 CAPTURE-intent order → GET order → presence-only payee inspection), no capture is performed, no production/Live/VPS/version/source mutation is included, and the recorded helper dry-run/staging/cleanup evidence is internally consistent.

Reviewer limitation remains: the actual local `.artifacts/k3r8e-payee-probe.ps1/.php` bytes are local-only and cannot be independently inspected from GitHub.

Current checkpoint: `OWNER_K3R8E_PAYEE_PROBE_REQUIRED`.


## K3R8E Final Review — PASS / K3R9

Owner's approved provider-parity run returned OAuth 200, order-create 201, order-GET 200, and all expected payee fields present.

```text
K3R8E_PAYEE_PROBE_PARITY_TEST=PASS
PAYPAL_SANDBOX_PROVIDER_PARITY=PASS
PPCP_4_1_3_MANUAL_CONNECT_FAILURE_BOUNDARY=ISOLATED_TO_PPCP_OR_WORDPRESS_INTERACTION
CURRENT_GATE=K3R9_PPCP_MINIMAL_ENV_ISOLATION
```

PPCP 4.1.3 is the current official release; no version upgrade test is available.

K3R9 will temporarily isolate the active WordPress plugin environment to WooCommerce + WooCommerce PayPal Payments, with rollback, then stop for one Owner-run Sandbox Manual Connect retry. No source patch, theme change, Live payment, tunnel, or VPS action is authorized.

Formal decision: `docs/REVIEWER_DECISION_K3R8E_PASS_K3R9_MINIMAL_ENV_ISOLATION.md`.


## K3R9 Phase A — PASS / Owner Checkpoint

Reviewer accepted the rollback, minimal-plugin isolation, transient cleanup, direct PayPal Settings readiness, and runtime evidence.

```text
K3R9_PPCP_MINIMAL_ENV_PREP=PASS
CURRENT_CHECKPOINT=OWNER_K3R9_SANDBOX_MANUAL_CONNECT_REQUIRED
```

Owner is authorized for exactly one Sandbox Manual Connect attempt in the direct PayPal Settings page. After the result, Executor must restore the prior plugin activation state exactly before returning to Reviewer.

Formal decision: `docs/REVIEWER_DECISION_K3R9_PREP_PASS_OWNER_MANUAL_CONNECT.md`.


## K3R9 Owner Manual Connect — SUCCESS UI

Owner supplied direct UI evidence showing `Connected to PayPal` after the single authorized Sandbox Manual Connect attempt in the minimal plugin environment.

```text
K3R9_OWNER_MANUAL_CONNECT_UI=SUCCESS
CURRENT_CHECKPOINT=K3R9_POST_RESULT_RESTORE_AND_VERIFY
```

Executor must now restore the prior Kadence plugin activation state exactly and perform read-only verification that the PayPal merchant/Sandbox connection and runtime remain healthy. K3R9 remains open until that evidence is reviewed.

Formal decision: `docs/REVIEWER_DECISION_K3R9_OWNER_CONNECT_SUCCESS_POST_RESTORE_VERIFY.md`.


## K3R9 Final Review — PASS

Post-restore evidence confirms the full pre-isolation plugin set is restored, PayPal Sandbox merchant connection remains established, onboarding is complete, Direct PayPal Settings remains healthy, and WordPress/WooCommerce runtime remains healthy.

```text
K3R9_PPCP_MINIMAL_ENV_ISOLATION=PASS
PPCP_SANDBOX_CONNECTION_AFTER_RESTORE=PASS
ROOT_CAUSE_EXACT_TRIGGER=UNRESOLVED_NONBLOCKING
CURRENT_GATE=K3R10_PAYPAL_SANDBOX_CHECKOUT_CAPTURE
```

Do not claim Kadence as the proven cause. Further historical conflict isolation is deferred unless the failure recurs.

K3R10 now resumes the actual Sandbox payment flow: checkout option → one test order → Sandbox approval/capture → WooCommerce paid/processing state → provider/order correlation → callback/webhook inspection.

Formal decision: `docs/REVIEWER_DECISION_K3R9_PASS_K3R10_SANDBOX_CHECKOUT_CAPTURE.md`.

### Recorded side task — GitHub handoff receipt

```text
SIDE_TASK_GITHUB_HANDOFF_STRUCTURED_RECEIPT=RECORDED_DEFERRED
MAINLINE_BLOCKING=NO
GLOBAL_GOVERNANCE_CHANGED=NO
```

Goal: retain GitHub as the full evidence/truth plane while requiring compact structured chat receipts containing Gate, result, summary, evidence files, commit, Owner action, and stop/next state.

Reference: `docs/SIDE_TASK_GITHUB_HANDOFF_STRUCTURED_RECEIPT.md`.
