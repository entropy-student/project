# Mini Craft Night Kit — PROJECT RECORD

Last updated: 2026-09-23

## CURRENT AUTHORITATIVE GOVERNANCE OVERRIDE — 2026-09-23

Generic governance is not redefined by this project.

```text
GOVERNANCE_SOURCE=entropy-student/spike.skill/vps-project-governance latest
DUPLICATED_PROJECT_GOVERNANCE_RULES=REFERENCE_ONLY
PROJECT_FACT_SOURCE=current Reviewer decision/Handoff + fresh accepted Evidence
CURRENT_GATE=K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY
K0_K5_RERUN=NO_UNLESS_MATERIAL_DRIFT
PROJECT_STORAGE_MANIFEST=mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md
```

Where any Mini Craft document repeats generic Owner/Reviewer/Executor, Gate, SSH, Shared Infra,
Target Host Reality, Secret, Storage, deployment-manifest, Evidence, rollback, resource or
Owner-operation rules, canonical Governance controls unless a current Reviewer decision explicitly
sets a bounded stricter override.

Formal reconciliation:
`docs/REVIEWER_DECISION_K6_GOVERNANCE_RECONCILIATION_PASS.md`.


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
K3_PAYMENT=PASS
DUJIAO_SECOND_ORDER_SYSTEM=NO
GITHUB_HANDOFF_PROTOCOL=TRIAL_APPROVED

K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC=PASS
K0R1_LOCAL_PROJECT_HYGIENE_CLEANUP=PASS
K0R2_WORDPRESS_STUDIO_CONSOLIDATION=PASS_RETAINED_READ_ONLY
ACTIVE_LOCAL_RUNTIME=DOCKER_MARIADB
ACTIVE_LOCAL_URL=http://localhost:8093/
CURRENT_CHECKPOINT=OWNER_K4_FINAL_UI_EDIT_WINDOW
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

### K4 — UI Modification + Conversion & Trust
UI modification first, then conversion/trust refinement across Home / Product / FAQ / Shipping & Returns / Contact.

Owner may directly edit these pages during K4. Cart / Checkout / Account core flows and PayPal/payment logic remain protected unless separately authorized.

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


## K3R10 Review — RETURN / Public Sandbox Origin Required

K3R10 reached Checkout but did not reach buyer approval. PPCP client-token generation failed and PayPal rejected localhost webhook registration.

```text
K3R10_PAYPAL_SANDBOX_CHECKOUT_CAPTURE=RETURN
RETURN_K3_PUBLIC_CALLBACK_REQUIRED=ACCEPTED
PUBLIC_SANDBOX_ORIGIN_REQUIRED=YES
ORDER_CREATED=NO
PAYPAL_CAPTURE_ACTIONS=0
CURRENT_CHECKPOINT=OWNER_K3R11_SANDBOX_SECRET_ROTATION_REQUIRED
```

Reviewer source inspection shows client-token generation is separate from webhook registration but uses the domain derived from WordPress `home_url()`. Therefore the next bounded Gate provides one temporary reversible HTTPS public Sandbox origin for the local runtime rather than a webhook-only workaround.

A Sandbox credential-bearing diagnostic output incident was also recorded. The affected Sandbox Secret must be rotated before any further use; the new Secret remains Owner-only.

Formal decision: `docs/REVIEWER_DECISION_K3R10_RETURN_K3R11_PUBLIC_SANDBOX_ORIGIN.md`.
Incident: `docs/SECURITY_INCIDENT_K3R10_SANDBOX_CREDENTIAL_OUTPUT.md`.


## K3R11 Owner Security Precondition — COMPLETE

Owner confirmed the affected PayPal Sandbox Secret was rotated.

```text
SANDBOX_SECRET_ROTATED=YES
OLD_SANDBOX_SECRET_REUSE=FORBIDDEN
CURRENT_GATE=K3R11_PUBLIC_SANDBOX_ORIGIN
```

The replacement Secret remains Owner-only. K3R11 may now prepare the temporary reversible HTTPS public Sandbox origin. If PPCP requires reconnection after rotation, stop for Owner local UI input rather than requesting credentials in chat.


## K3R11 Preflight — Owner Sandbox Reconnect Checkpoint

Secret rotation invalidated the stored PPCP merchant connection while leaving Sandbox mode, onboarding, and runtime healthy.

```text
K3R11_PREFLIGHT=PASS
PPCP_MERCHANT_CONNECTED=NO
PUBLIC_HTTPS_ORIGIN=NOT_CREATED
CURRENT_CHECKPOINT=OWNER_K3R11_SANDBOX_RECONNECT_REQUIRED
```

Owner must reconnect Sandbox once through the local WooCommerce PayPal Settings UI using the rotated credentials. The replacement Secret remains Owner-only. No public origin or checkout action proceeds until Reviewer receives the sanitized reconnect result.

Formal decision: `docs/REVIEWER_DECISION_K3R11_OWNER_SANDBOX_RECONNECT.md`.


## K3R11 Connection-State Mismatch

Owner UI shows a connected Sandbox account presentation with a Disconnect control, but the preceding read-only PPCP REST probe reported merchant connected = NO.

```text
PPCP_ADMIN_UI_CONNECTION_STATE=CONNECTED_PRESENTATION
PPCP_REST_MERCHANT_CONNECTED=NO
DISCONNECT_AUTHORIZED=NO
CURRENT_GATE=K3R11_CONNECTION_STATE_RECONCILIATION
```

Owner reconnect is paused. Executor must reconcile the state read-only before any disconnect/reconnect or public-origin work continues.

Formal decision: `docs/REVIEWER_DECISION_K3R11_UI_REST_CONNECTION_STATE_MISMATCH.md`.


## K3R11 Connection-State Reconciliation — PASS

Corrected PPCP REST parsing shows the admin UI and REST state agree: merchant connected = YES and Sandbox = YES. The prior disconnected result was a helper response-path bug and is superseded.

```text
K3R11_CONNECTION_STATE_RECONCILIATION=PASS
PPCP_REST_MERCHANT_CONNECTED=YES
PRIOR_DISCONNECTED_RESULT=SUPERSEDED_HELPER_PARSE_ERROR
OLD_SANDBOX_SECRET_REUSE=FORBIDDEN
CURRENT_GATE=K3R11_PUBLIC_ORIGIN_REBIND_PREP
```

Because the local PPCP connection is still bound to credential material stored before the Sandbox Secret rotation, the next bounded phase first uses PPCP's official local disconnect path to remove that old binding, then creates the temporary HTTPS public origin, then stops for Owner Manual Connect with the rotated credentials.

Formal decision: `docs/REVIEWER_DECISION_K3R11_CONNECTION_RECONCILED_PUBLIC_ORIGIN_REBIND.md`.


## K3R11 Rebind Prep — Owner Confirmation Required

Executor verified rollback/runtime readiness and located the official PPCP Disconnect control without executing it.

```text
ROLLBACK_POINT_VERIFIED=PASS
OFFICIAL_DISCONNECT=READY_NOT_EXECUTED
CURRENT_CHECKPOINT=OWNER_K3R11_DISCONNECT_CONFIRMATION_REQUIRED
```

Owner must explicitly authorize one official Disconnect before execution continues.


## K3R11 Disconnect Confirmation / Process Correction

Owner confirmed the single official PPCP Disconnect.

```text
OWNER_K3R11_DISCONNECT_CONFIRMATION=YES
CURRENT_GATE=K3R11_PUBLIC_ORIGIN_REBIND_PREP
```

Process correction: this Owner checkpoint was not actually required by the intended governance boundary because the action was local, reversible, rollback-protected, already Reviewer-authorized, and required no secret/provider authorization. Future equivalent actions should not interrupt Owner.


## K3R11 Public-Origin Rebind Prep — PASS

Executor completed the one-time official Disconnect, cleared the old local credential binding, established the temporary HTTPS Quick Tunnel, reversibly rebound WordPress home/site URL, and verified public reachability.

```text
K3R11_PUBLIC_ORIGIN_REBIND_PREP=PASS
PUBLIC_HTTPS_ORIGIN=https://email-rich-barbie-merchants.trycloudflare.com
OLD_CREDENTIAL_BINDING_CLEARED=PASS
CURRENT_CHECKPOINT=OWNER_K3R11_PUBLIC_SANDBOX_MANUAL_CONNECT_REQUIRED
```

Owner must now perform exactly one Sandbox Manual Connect through the temporary public WordPress UI using the rotated credentials. No buyer approval/capture is authorized yet. The Quick Tunnel is temporary and must be revalidated if it drops.

Formal decision: `docs/REVIEWER_DECISION_K3R11_REBIND_PREP_PASS_OWNER_PUBLIC_MANUAL_CONNECT.md`.


## K3R11 Owner Public Manual Connect — SUCCESS UI

Owner supplied UI evidence showing `Connected to PayPal` while WordPress was operating on the temporary public HTTPS origin.

```text
OWNER_PUBLIC_MANUAL_CONNECT=SUCCESS
CURRENT_GATE=K3R11_PUBLIC_ORIGIN_READINESS_VERIFY
```

Executor must now independently verify Sandbox merchant connection, SDK client token, PayPal Checkout button rendering, webhook registration/status, and runtime health. K3R11 remains open until Reviewer accepts those checks.

Formal decision: `docs/REVIEWER_DECISION_K3R11_OWNER_PUBLIC_CONNECT_SUCCESS_VERIFY_READINESS.md`.


## K3R11 Final Review — PASS

Public-origin readiness is complete.

```text
K3R11_PUBLIC_ORIGIN_READINESS_VERIFY=PASS
SANDBOX_MERCHANT_CONNECTED=PASS
PPCP_CLIENT_TOKEN=PASS
PAYPAL_CHECKOUT_BUTTON_RENDERED=PASS
WEBHOOK_REGISTER=PASS
PUBLIC_HTTPS_ORIGIN=PASS
RUNTIME_HEALTH=PASS
CURRENT_GATE=K3R10_PAYPAL_SANDBOX_CHECKOUT_CAPTURE_RESUME
```

The temporary Quick Tunnel/public WordPress origin remains active for the resumed payment/callback test and must not be torn down yet.

Next mainline: public Checkout → Sandbox buyer approval → exactly one Sandbox capture → WooCommerce paid/processing state → redacted PayPal correlation → verify no automatic physical fulfillment → actual webhook/callback processing.

Formal decision: `docs/REVIEWER_DECISION_K3R11_PASS_RESUME_K3R10_SANDBOX_CAPTURE.md`.


## K3R10 Sandbox Buyer Auth Checkpoint

The resumed public Checkout reached the PayPal Sandbox buyer authentication boundary without creating an order or capture.

```text
PAYPAL_SELECTED=PASS
BUYER_APPROVAL=OWNER_REQUIRED
ORDER_CREATED=NOT_OBSERVED_BEFORE_CHECKPOINT
CAPTURE_ACTIONS=0
CURRENT_GATE=K3R10_POST_PAYMENT_CAPTURE_WEBHOOK_VERIFY
```

Owner must privately complete Sandbox buyer login/approval for the single existing test flow. The temporary public origin remains active and must not be torn down.

Formal decision: `docs/REVIEWER_DECISION_K3R10_OWNER_SANDBOX_BUYER_AUTH.md`.


## K3R10 Buyer Flow Reopen

Owner closed the pre-approval PayPal popup/Checkout page. No order/capture had occurred, so the session is treated as abandoned before payment.

```text
BUYER_APPROVAL=NOT_EXECUTED
ORDER_CREATED=NOT_OBSERVED_BEFORE_CHECKPOINT
CAPTURE_ACTIONS=0
CURRENT_CHECKPOINT=OWNER_K3R10_SANDBOX_BUYER_AUTH_REOPEN_REQUIRED
```

Owner may reopen Checkout and start one fresh Sandbox buyer flow. The temporary public origin remains required.


## K3R10 Owner Buyer Approval — SUCCESS UI

Owner completed the single Sandbox PayPal buyer flow and reached the WooCommerce order-received page.

```text
BUYER_APPROVAL_RESULT=SUCCESS
ORDER_RECEIVED_UI=PASS
CURRENT_GATE=K3R10_POST_PAYMENT_CAPTURE_WEBHOOK_VERIFY
```

Executor must now independently verify the single order/capture, paid/processing status, redacted provider correlation, non-completion of physical fulfillment, actual webhook/callback processing, and runtime health before Reviewer can close K3R10.

Formal decision: `docs/REVIEWER_DECISION_K3R10_OWNER_BUYER_APPROVAL_SUCCESS_VERIFY_CAPTURE.md`.


## K3 Final Review — PASS

The complete PayPal Sandbox acceptance flow has passed: merchant connection, public-origin readiness, buyer approval, exactly one Capture, WooCommerce paid/processing state, redacted provider correlation, real webhook/callback processing, and physical-fulfillment non-completion.

```text
K3_PAYMENT=PASS
SINGLE_SANDBOX_PAYMENT=PASS
PAYPAL_CAPTURE=PASS
WOO_ORDER_PAID_PROCESSING=PASS
PAYPAL_WOO_CORRELATION=PASS_REDACTED
WEBHOOK_CALLBACK=PASS
DUPLICATE_PAYMENT=NO
DUPLICATE_CAPTURE=NO
CURRENT_GATE=K4_REUSABLE_STOREFRONT_SHELL_SPEC
```

The temporary Quick Tunnel/public WordPress origin may now be rolled back at K4 start after localhost health verification. K4 follows the original roadmap: Home / Product / FAQ / Shipping & Returns / Contact.

Formal decision: `docs/REVIEWER_DECISION_K3_PASS_K4_CONVERSION_TRUST.md`.


## K4 Scope Update — UI Modification Added

```text
CURRENT_GATE=K4_REUSABLE_STOREFRONT_SHELL_SPEC
UI_MODIFICATION_STAGE=ADDED
K4_SEQUENCE=UI_MODIFICATION_THEN_CONVERSION_TRUST
```

Owner may directly modify Home / Product / FAQ / Shipping & Returns / Contact during K4. Executor must avoid concurrent edits to the same page and rebase from the latest Owner-approved page state before continuing.

Formal decision: `docs/REVIEWER_DECISION_K4_UI_CONVERSION_TRUST_SCOPE.md`.


## K4 Implementation Review — PASS / Final Facts Pending

The K4 UI and conversion/trust implementation passed technical review. Fake/unverified template content was removed, five scoped pages remain native/editable, responsive/Gutenberg/WooCommerce behavior passed, and K3 temporary public-origin cleanup is complete.

```text
K4_IMPLEMENTATION=PASS
SHIPPING_RETURNS=PASS_SAFE_FACTUAL_BOUNDARY
CONTACT=PASS_SAFE_FACTUAL_BOUNDARY
K4_FINAL_PASS=PENDING_OWNER_BUSINESS_FACTS
CURRENT_GATE=K4_REUSABLE_STOREFRONT_SHELL_SPEC
```

Remaining Owner facts are batched into one checkpoint before final K4 acceptance.

Formal decision: `docs/REVIEWER_DECISION_K4_IMPLEMENTATION_PASS_OWNER_BUSINESS_FACTS.md`.


## K4 Owner Business Policy — CONFIRMED

Owner approved the recommended MVP defaults as editable launch rules.

```text
INITIAL_MARKET=UNITED_STATES
SHIPPING_METHOD=TRACKED_STANDARD_SHIPPING
SHIPPING_COST=DISPLAY_AT_CHECKOUT
FIXED_DELIVERY_PROMISE=NO_UNTIL_VERIFIED
RETURN_WINDOW=14_DAYS_AFTER_DELIVERY
MISSING_DAMAGED_PRIMARY_REMEDY=REPLACEMENT_FIRST
PUBLIC_SUPPORT_CHANNEL=CONTACT_FORM
DOMAIN_SUPPORT_EMAIL=PENDING_FINAL_DOMAIN_MAILBOX
PUBLIC_RETURN_ADDRESS=PENDING_OPERATIONAL_ADDRESS
BUSINESS_RULES_FUTURE_EDITABLE=YES
CURRENT_GATE=K4_REUSABLE_STOREFRONT_SHELL_SPEC
```

These are content/business defaults, not permanent architecture constraints. Executor may finalize K4 pages and return one final PASS_CANDIDATE.

Formal decision: `docs/REVIEWER_DECISION_K4_OWNER_BUSINESS_FACTS_CONFIRMED.md`.


## K4 Owner UI Edit Window — PENDING

Owner has not yet performed the planned manual UI edits. The current Executor K4-finalize run may finish, but formal K4 closure is deferred until Owner gets one edit window and a final bounded delta verification passes.

```text
OWNER_UI_EDIT_COMPLETED=NO
K4_FORMAL_CLOSE=DEFERRED_UNTIL_OWNER_UI_EDIT
CURRENT_GATE=K4_REUSABLE_STOREFRONT_SHELL_SPEC
```

Formal decision: `docs/REVIEWER_DECISION_K4_OWNER_UI_EDIT_WINDOW_BEFORE_K5.md`.


## K4 Finalize Baseline — PASS / Owner UI Edit Window OPEN

Executor commit `ab635ae3e9890ee7f2a479d879899c171ff7af46` passed Reviewer evidence review as the baseline before Owner manual UI edits.

```text
K4_FINALIZE_IMPLEMENTATION=PASS
OWNER_UI_EDIT_COMPLETED=NO
CURRENT_GATE=K4_REUSABLE_STOREFRONT_SHELL_SPEC
K4_FORMAL_CLOSE=DEFERRED_UNTIL_OWNER_UI_EDIT_DELTA_VERIFY
```

Owner may now modify Home / Product / FAQ / Shipping & Returns / Contact. Final K4 close waits for Owner completion plus one bounded delta verification.

Formal decision: `docs/REVIEWER_DECISION_K4_FINALIZE_ACCEPT_OWNER_UI_EDIT_WINDOW_OPEN.md`.


## K4 UI Snapshot Pack — PASS / Reusable Storefront Objective

The 10-page, 20-image read-only UI snapshot pack is accepted as the current visual inventory.

```text
SNAPSHOT_PACK=PASS
PAGE_COUNT=10
SCREENSHOT_COUNT=20
CURRENT_GATE=K4_REUSABLE_STOREFRONT_SHELL_SPEC
```

Owner objective:

```text
FUTURE_RESKIN_NORMAL_SCOPE=IMAGES_TEXT_COLORS
LAYOUT_REBUILD=NORMALLY_NO
WOOCOMMERCE_FLOW_REBUILD=NO
PAYMENT_LOGIC_REBUILD=NO
```

Next work is documentation-only: define the fixed storefront shell, replaceable content layer, replaceable brand tokens, per-page replacement map, and future re-skin checklist before Owner performs manual UI edits.

Formal decision: `docs/REVIEWER_DECISION_K4_UI_SNAPSHOT_PACK_PASS_REUSABLE_SHELL_SPEC.md`.


## K4 Reusable Storefront Shell — Design Spec Complete

Reviewer finalized:
- docs/UI_DESIGN_SYSTEM.md
- docs/STOREFRONT_RESKIN_MAP.md

Current Gate:
K4_REUSABLE_STOREFRONT_SHELL_IMPLEMENTATION

Reusable-shell target:
FUTURE_RESKIN_NORMAL_SCOPE=IMAGES_TEXT_GLOBAL_COLORS
LAYOUT_REBUILD=NORMALLY_NO
WOOCOMMERCE_FLOW_REBUILD=NO
PAYMENT_LOGIC_REBUILD=NO
EXECUTOR_IMAGE_GENERATION=FORBIDDEN

Functionality, responsive behavior, Gutenberg validity, Owner editability, and WooCommerce/PayPal integrity outrank pixel parity.

Formal decision:
docs/REVIEWER_DECISION_K4_REUSABLE_SHELL_SPEC_PASS_IMPLEMENTATION.md


## K4 Reusable Shell — Structural Baseline PASS / Reviewer Copy Fill

Executor commit `1e118131f9d3ec3995c35b09199f255eb27be2a2` is accepted as the reusable shell baseline.

```text
SHELL_STRUCTURAL_BASELINE=PASS
RESPONSIVE_MATRIX=65_OF_65_PASS
GUTENBERG_VALIDITY=PASS
WOOCOMMERCE_BEHAVIOR=PASS
IMAGE_GENERATION=NO
CURRENT_GATE=K4_CONTENT_FILL_REVIEWER_COPY
```

Reviewer finalized customer-facing copy in:
- `docs/K4_FINAL_COPY_SPEC.md`

Next pass changes text only. Images, colors, layout, responsive rules, and commerce/payment behavior stay unchanged.

Formal decision:
- `docs/REVIEWER_DECISION_K4_SHELL_PASS_CONTENT_FILL.md`


## K4 Reviewer Copy — PASS / Owner Final Visual Window

Commit `98a7d3d4c8cd9851f4780a70c63c89ee3f57b092` passed Reviewer evidence review.

```text
COPY_FILL=PASS
RESPONSIVE_MATRIX=65_OF_65_PASS
GUTENBERG_VALIDITY=PASS
COMMERCE_SMOKE=PASS
CURRENT_CHECKPOINT=OWNER_K4_FINAL_UI_EDIT_WINDOW
K4_FORMAL_CLOSE=DEFERRED_UNTIL_OWNER_DELTA_VERIFY
```

Owner now has the final UI edit window for images, visible-text micro-edits, and global colors on the five editable pages. Reusable layout and commerce flows remain protected.

Formal decision:
`docs/REVIEWER_DECISION_K4_COPY_PASS_OWNER_FINAL_UI_WINDOW.md`


## K4 Local Artifact Hygiene — PASS / Home Detail Polish

Local hygiene commit `68e446115c623b93a87dc9492061b8b2e065396d` removed 62 confirmed reproducible Mini Craft K4 temp directories (~1.07 GB) without page/media/config/commerce mutation.

The current GPT-6 Home remains the visual baseline.

Authorized bounded next step:
`K4_HOME_DETAIL_POLISH`

Scope:
- four replaceable product/content media slots;
- native burgundy line icons;
- minor detail polish;
- Hero unchanged;
- no image generation;
- no commerce/payment changes.

Formal decision:
`docs/REVIEWER_DECISION_K4_HOME_DETAIL_POLISH.md`


## K4 Home Detail Polish — Technical PASS

Executor commit `e5416cf9c585b795f588a03f796342f1e3b36824` passed technical review.

Current checkpoint:
`OWNER_K4_HOME_VISUAL_REVIEW`

The Home now contains four replaceable 4:3 offer media slots and seven native burgundy icon blocks while preserving the GPT-6 Hero, responsive behavior, Gutenberg validity, and commerce/payment state.

Formal decision:
`docs/REVIEWER_DECISION_K4_HOME_DETAIL_POLISH_TECH_PASS.md`


## K4 Home Visual Review — Capture Before Final Polish

Owner provided a side-by-side visual review and requested one more read-only screenshot pass before any further modification.

Current Gate:
`K4_HOME_VISUAL_REVIEW_CAPTURE`

Recorded issues:
Hero needs more weight; sections ②–⑥ are too loose; icon alignment is inconsistent; sections ②/③ are repetitive; footer section ⑧ has a missing icon; non-Hero/non-product sections can be compressed.

No visual mutation is authorized until Reviewer consolidates the final change set from the returned screenshots.


## K4 Home Visual Review — Final Modification Plan

Read-only capture commit `2ecee86b6de749d8ab5fcae64b683ba0cdcdf0d7` is accepted as the visual-review baseline.

Next Gate:
`K4_HOME_FINAL_DENSITY_ALIGNMENT_POLISH`

Final plan:
- increase Hero weight modestly;
- compress sections ②/③/④/⑥;
- differentiate ③ from the flat process strip ②;
- preserve section ⑤ product-image prominence;
- standardize native icon alignment;
- slightly tighten closing CTA;
- repair footer broken brand visual and simplify footer attribution.

Formal decision:
`docs/REVIEWER_DECISION_K4_HOME_FINAL_DENSITY_ALIGNMENT_POLISH.md`


## K4 Home Final Density Polish — Technical PASS / Visual Confirmation Pending

Executor commit `56f4932e21e2883ce2223e8547121d98c725205d` passed technical review. The final screenshot pair is archived at:
- docs/ui-k4-final-density-polish/home-desktop-1440.png
- docs/ui-k4-final-density-polish/home-mobile-390.png

Current checkpoint:
`OWNER_K4_FINAL_VISUAL_CONFIRMATION`

K4 is not formally closed until those final captures are visually accepted.


## K4 Home Final Polish — Technical PASS

Executor commit `56f4932e21e2883ce2223e8547121d98c725205d` passed technical Reviewer review.

Current checkpoint:
`OWNER_K4_FINAL_VISUAL_CONFIRMATION`

Technical acceptance includes responsive 13/13, Gutenberg validity, footer repair, standardized native icons, preserved Offer slots, and commerce smoke with WooCommerce/PayPal/order state unchanged.

Formal K4 close still waits for Owner visual PASS plus one bounded final delta verification.


## K4 Home Final Visual Review — Section Dedup

The post-polish Home was visually reviewed in-chat.

The standalone Three-step strip is now judged redundant with the following Three-value section and is authorized for removal.

Next Gate:
`K4_HOME_SECTION_DEDUP`

Scope is intentionally narrow:
- delete Three-step strip only;
- keep Three-value section intact;
- normalize only adjacent spacing;
- no other Home redesign or commerce/payment changes.

The GitHub handoff protocol now also requires actual in-chat screenshot visibility for final Visual PASS; GitHub-only PNG evidence is Technical evidence until the pixels are directly reviewed.


## K4 Owner Manual Edits — Finalization

Owner saved a new Home/Header visual baseline:
- full-width Hero background treatment;
- updated Header/logo;
- four replacement product images in the Offer/product-display section.

The previous `K4_HOME_SECTION_DEDUP` scope is superseded by:
`K4_OWNER_MANUAL_EDITS_FINALIZE`

Final bounded work:
- remove the redundant Three-step section;
- remove/repair the invalid child blocks in the Three-value cards;
- preserve all Owner manual Hero/Header/product-media changes exactly.

Formal decision:
`docs/REVIEWER_DECISION_K4_OWNER_MANUAL_EDITS_FINALIZE.md`


## K4 Owner Manual Baseline — Superseding Verification Gate

Owner manually saved additional Home deletions, including removal of the Three-step section.

Current saved Home/Header is authoritative. No deleted content may be restored by Executor.

Previous `K4_OWNER_MANUAL_EDITS_FINALIZE` scope is superseded by:
`K4_OWNER_MANUAL_BASELINE_VERIFY`

Three-value invalid-block state is now read-only verification. Any remaining invalid blocks must be reported, not repaired, unless Reviewer later authorizes a bounded fix.


## Visual Evidence Handoff Standard — ZIP

Owner standardized UI screenshot review delivery:
all screenshot evidence must be committed to GitHub and additionally packaged into one Gate-specific ZIP for Owner transfer to Reviewer.

The ZIP contains only current-Gate screenshots plus a non-sensitive manifest. Reviewer visual acceptance requires inspecting the uploaded ZIP.


## K4 Full Visual Audit + Product Gallery Repair

Owner requested one consolidated screenshot package for all current storefront pages and reported a Product gallery interaction defect.

Observed symptom: Product initial load can show a normal large image, but later gallery interaction may collapse the active image while leaving excessive blank space.

Current Gate:
`K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR`

This supersedes the prior verification-only Gate. Product repair must remain minimal and preserve canonical WooCommerce gallery behavior. All visual evidence is delivered as one ZIP plus GitHub archive.


## K4 Full Visual Audit — Technical PASS / Visual RETURN

Executor commit `7db4f27f647611d0a4702b2b95bc63617f1786cc` is accepted for the Product gallery repair and technical regression evidence.

Direct review of the full screenshot ZIP found customer-facing cleanup still required:
- WooCommerce frontend locale mismatch (Chinese strings inside English storefront);
- inherited demo tech products visible in Shop/Related Products;
- Contact form Name/Email inputs not visibly rendered;
- FAQ Orders & Support formatting inconsistency;
- redundant Shipping & Returns inner heading.

Next Gate:
`K4_STOREFRONT_CLEANUP_AFTER_VISUAL_AUDIT`

K4 remains open.


## K4 Strict Storefront Cleanup — Authorized

Direct visual review of the full audit ZIP established a stricter K4 close standard.

Current Gate:
`K4_STRICT_STOREFRONT_CLEANUP`

Authoritative remediation scope:
- English customer storefront UI;
- hide inherited demo tech products from Shop/Related Products;
- correct Mini Craft product taxonomy from Accessories;
- tighten Product mobile typography;
- repair Contact form visible Name/Email fields and remove internal governance wording;
- normalize FAQ Orders & Support;
- remove Shipping & Returns heading duplication and tighten mobile hierarchy;
- clean Shop spacing/single-product controls;
- capture populated Cart and actual populated Checkout;
- English Account;
- improve mobile Footer stacking.

The current Home and Product gallery repair are protected.

A separate strategic question remains open and must not be auto-decided by Executor:
single Date Night Kit vs multi-category Mini Craft brand.


## K4 Gutenberg Recovery Boundary — Reviewer Resolution

Executor return `973d9522f1dea09ae9513b2f056829b6a4bd48f1` found 11 pre-existing invalid Gutenberg blocks and correctly stopped with zero site mutation.

Isolated defects:
- Contact: invalid Kadence Form 1 + core/column 3; Name/Email labels exist but their inputs do not render.
- FAQ: invalid core/details 7.
- Shipping & Returns: invalid 0.

A narrow reversible recovery Gate is authorized:
`K4_NATIVE_BLOCK_RECOVERY_CONTACT_FAQ`

It must replace only invalid blocks through registered current block serializers, preserve copy, and not resume the broader storefront cleanup automatically.

The broader `K4_STRICT_STOREFRONT_CLEANUP` remains pending after recovery.


## K4 Block Recovery — Browser Session Fallback

A second safe stop occurred because Gutenberg browser automation could not reliably identify the current editor URL. No site state changed.

Reviewer authorized `K4_ARTIFACT_BACKED_BLOCK_RECOVERY` instead of repeating the same GUI path.

The recovery is restricted to:
- exact known-good serialized Kadence Form artifact restoration if an exact source can be proven;
- WordPress-core serialization repair for Contact core/column and FAQ core/details invalid targets;
- no broad storefront cleanup or unrelated state changes.

The broader `K4_STRICT_STOREFRONT_CLEANUP` remains paused.


## K4 Recovery accepted; Workspace Hygiene V2 required

The artifact-backed recovery at commit `e1a64a1e5092142b1391961c28ce4ddd0c428f6d` is accepted for Contact/FAQ block recovery. Frontend screenshots confirm restored Contact fields and FAQ details. Gutenberg editor GUI validation remains deferred due session availability.

The shared workspace has accumulated root-level Mini-Craft temporary/runtime artifacts again. A second cleanup is required, but this time with a permanent anti-regression rule.

Current Gate:
`K4_WORKSPACE_HYGIENE_V2`

This Gate must inventory and classify root items, delete only proven transient material, preserve the active runtime and unknown/unrelated items, and force future Gates to clean their temporary browser/helper artifacts before returning.


## K4 Workspace Hygiene V2 — PASS

Commit `d0b821c91f433ce6cf8e3c534fa6a87d91c43b90` is accepted.

The workspace cleanup was conservative: no safe-delete candidate was proven, one K4 visual ZIP was archived, and unresolved root browser/profile items were retained rather than guessed away. The permanent workspace closeout contract is now mandatory for future Mini Craft Gates.

## K4 Strict Storefront Cleanup — resumed

Current Gate:
`K4_STRICT_STOREFRONT_CLEANUP_RESUME`

This resumes the previously paused storefront cleanup after:
- Contact/FAQ artifact-backed recovery acceptance;
- Workspace Hygiene V2 PASS.

Growth/SEO Readiness remains planned after K4 visual/functional cleanup and before K5.


## K4 Strict Storefront Cleanup Resume — visual review return

Commit `152f48aa269e8bd93d5215299ee68c2977a10f1e` completed the authorized storefront cleanup and generated the full visual package.

Reviewer pixel inspection accepted the major cleanup, but K4 remains open for one bounded final mobile-commerce polish.

Observed blockers:
- mobile Cart coupon/update controls collide and shipping hierarchy is weak;
- checkout currently defaults to Japan/Tokyo and offers local test shipping, conflicting with the approved United States initial market;
- mobile Checkout billing rows render as staggered half-width fields;
- final checkout action is not visibly evidenced;
- legacy responsive typography remains too small/narrow on several customer pages.

Current Gate:
`K4_FINAL_MOBILE_COMMERCE_VISUAL_POLISH`

After this Gate passes, next intended sequence remains:
K4 close → project directory consolidation → Growth/SEO Readiness → K5.


## K4 final mobile-commerce remediation — accepted; workspace consolidation required

Commit `7b5ca9cd80b99e02db4fd982ea2182ad7f18746e` passes direct visual/functional review for the current local-test storefront.

The Executor's RETURN is limited to local workspace hygiene: Gate-local browser profiles/debug screenshots remain and reported path strings are malformed.

Before Growth/SEO, the project now enters:
`PROJECT_DIRECTORY_CONSOLIDATION`

Target local workspace:
`C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\`

The consolidation may physically move the current runtime only after proving Docker/Git path safety; otherwise it must use a documented pointer rather than risking runtime breakage.


## Project Directory Consolidation — structural PASS

Commit `a33b3bd9ce7b96fffa91a4ffad0d891e28c2342a` established the canonical local workspace and pointers without moving path-sensitive Git/Docker runtimes.

Final cleanup is Owner-manual only because Executor deletion policy blocked the exact disposable-file deletions. No further automated deletion Gate is required for this residue.

Canonical workspace:
`C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace`

After Owner confirms manual cleanup, proceed to Growth/SEO Readiness before K5.


## Local cleanup checkpoint accepted

Owner manually removed the two shared-root K4 browser-temp folders. Remaining Gate-local browser/debug artifacts are intentionally retained and no longer block progress.

## K4.5 Growth / SEO Readiness Audit

Current Gate:
`K4_5_GROWTH_SEO_READINESS_AUDIT`

This audit occurs before K5 and before real traffic. It will establish technical SEO, Search/Merchant readiness, instrumentation, analytics, UTM, structured-data, lifecycle, privacy, CRO/trust, and Owner-action gaps without implementing changes.

The Growth Playbook principle remains: instrumentation before meaningful traffic; prioritize the biggest unknown/constraint rather than mass content production.


## K4.5 Growth / SEO Readiness Audit — PASS

Commit `f69ea6e3f2ee58c5bcb55d0c5dc33981a6f8b7a4` is accepted. Readiness matrix: P0 5 / P1 7 / P2 5 / Defer 4.

The site is functionally strong but remains local/test-state for public search and growth: public HTTPS origin, production commercial truth, minimal measurement, privacy/consent, and delivery/email validation are the P0 constraints.

## K4.6 Growth Foundation Spec

Current Gate: `K4_6_GROWTH_FOUNDATION_SPEC`.

This Gate converts the audit into minimal durable growth docs without touching WordPress or external accounts. Owner decisions remain compressed into five future bundles: PRODUCT_TRUTH, PUBLIC_ORIGIN, MEASUREMENT, LEGAL_CONSENT, DELIVERY_AND_EMAIL.


## K4.6 Growth Foundation Spec — PASS

Commit `58dd18534b74919e5396b1e6d2eaa880da24544f` is accepted. The project now has a durable Growth System, Unit Economics template, Event Taxonomy, UTM Standard, and evidence-backed CRO Backlog.

## K4.7 Owner Launch Truth Checkpoint

Current checkpoint: five bundled Owner decisions before P0 implementation — product model, public origin, analytics provider, legal/consent path, and delivery/email provider/mailbox convention.

No K5 yet.


## K4.7 Owner Launch Truth — resolved

Owner selected multi-category Mini Craft as the long-term brand model, with the current Night Kit as the first actual offer. Public validation origin is `https://minicraft.spikersun.com`; initial analytics is GA4; legal path is draft-first then Owner/legal review; initial transactional email provider is Resend with `support@minicraft.spikersun.com` as the planned support address and inbound forwarding as the low-cost first path.

No empty/fake category expansion is authorized. Product truth for the first production SKU remains pending before production commerce launch.


## K4.8 First SKU Product Truth Discovery

Current Gate: `K4_8_FIRST_SKU_PRODUCT_TRUTH_DISCOVERY`.

Reason: the brand model is now resolved as multi-category, but the current Night Kit remains a concept shell without a concrete supplier/SKU. Product truth is the next P0 dependency before production SEO/feed/schema/analytics launch work can be trusted.

The Gate will shortlist 3–5 real candidate supplier/SKU offers and stop before supplier contact or sample purchase.


## K4.8 First SKU Product Truth Discovery — PASS

Four supplier-offer leads were documented. A ORFON ND766 and C Yuhan MWK-001 have the best public listing completeness, but all candidates still lack verified US landed cost, media rights, supplier-specific remedy terms, and sample validation.

## K4.9 Supplier Contact Owner Checkpoint

Next action requires explicit Owner authorization because it would contact external suppliers. Recommended first bounded inquiry set: A + C; optional B. Inquiry is information-only; no sample purchase/payment/binding commitment is authorized.


## Launch-path correction

Owner has explicitly chosen to launch the platform first and treat supplier selection, sourcing, SEO expansion and profit optimization as post-launch operations.

Supplier contact is deferred. K4.8 remains optional sourcing research only.

Current Gate: `K5_RELEASE_CANDIDATE_QA`.

Launch path is now: K5 RC QA → VPS deployment → production canary on `minicraft.spikersun.com` → Owner uploads/approves real product data → production payment/email/domain checks → Soft Launch → operations.


## K5 RC QA — baseline drift return

K5 commit `11115a72e18213f49cca49e928a9a40ea7e793b4` found fresh Product Related Products still showing USB-C Cable, Universal Charger, and Remote Control. Shop correctly shows only Mini Craft Night Kit, but Related Products conflicts with accepted K4 cleanup truth.

Current bounded remediation: `K5R1_RELATED_PRODUCTS_BASELINE_REPAIR`.

After PASS, resume K5 rather than replay earlier K4 gates.


## K5R1 Related Products Baseline Repair — PASS

Commit `61ec3c81a4eb48faa513fd9bb511bfabe98302c4` is accepted. The apparent K4 baseline drift was a stale `wc_related_223` transient, not product publication drift or template regression. IDs 222/224/117 remained draft and the narrow cache reset restored the accepted storefront state.

## K5 Release Candidate QA — resumed

Current Gate: `K5_RELEASE_CANDIDATE_QA_RESUME`.

Remaining work is RC verification and local deployment-package preparation only. No K4 replay, VPS deployment, Live PayPal, analytics/email/SEO implementation, or supplier work.


## K5 Resume — partial completion / K5R2 reconciliation

Commit `2f8e33022ea8e82b310b3bac44846dc5dce6de5a` proved Owner admin operability, Orders access, Gallery/Contact health, runtime health and created verified local deployment backups/manifest. It stopped because populated Checkout did not expose a final action in the observed PayPal state.

Current Gate: `K5R2_CHECKOUT_ACTION_VERSION_RECONCILIATION`.

The Gate will distinguish core WooCommerce Place-order health from PPCP localhost rendering and will resolve the production WordPress image mismatch (current image tag 6.8.2 vs actual persistent core 7.1.1) without replaying prior QA.


## K5 Release Candidate — PASS

The RC is accepted for deployment. Current inability to repeat the checkout-final-action check was a browser automation limitation, not a demonstrated application regression. Historical/current evidence together establishes WooCommerce core checkout, Sandbox payment integration, storefront/admin operability, backups and deployment readiness.

Target production WordPress image: `wordpress:7.1.1-php8.3-apache`.

## K6 VPS Production Deployment Owner Checkpoint

Next phase is Sandbox-first production deployment to `https://minicraft.spikersun.com` on the shared Hostinger VPS. It requires explicit Owner authorization before any VPS/reverse-proxy write. Live PayPal/real-money sales remain separately blocked.


## K6 VPS Production Deployment — authorized

Owner authorized deployment. Current target is a Sandbox-first public canary at `https://minicraft.spikersun.com` on the existing shared Hostinger VPS.

The deployment must first revalidate shared-host truth, then use a project-isolated WordPress/MariaDB Compose stack under the current `/srv` contract, reuse current shared ingress rather than replacing it, restore the accepted K5 RC, migrate URLs, establish DNS/HTTPS, and verify public Checkout with PayPal still in Sandbox. Real-money payment and Soft Launch remain separately blocked.


## Local document consolidation before K6

Owner paused VPS deployment to clean local project documentation first. Current Gate: `LOCAL_DOCUMENT_CONSOLIDATION_CLEANUP`.

Target is a clean canonical workspace where current/deployment/archive documents live under `mini-craft-night-kit-workspace\\docs\\`, Gate artifacts remain under `artifacts\\`, and loose Mini Craft documentation is removed from the shared `VPS基建` root where safe. Only proven duplicate/superseded/temp project-owned files may be deleted; operational runtime/repo/backups/secrets/unrelated projects remain untouched.


## Local document consolidation — PASS

Commit `fd06aa204575d03fb14d692345a337af165a446e` consolidated 9 historical Mini Craft local documents under the canonical workspace archive. No deletion was justified; uncertain `.tmp-*` and diagnostic residue remain retained rather than guessed away. Runtime, Git, K5 deployment package/backups and unrelated projects were unchanged.

## K6 VPS Production Deployment — resumed

The cleanup pause is lifted. Existing Owner authorization remains in force. Resume K6 at the mandatory read-only Shared VPS preflight; do not replay K5.


## K6 Phase A — SSH transport unavailable

Commit `82962230c984767a65bbd675df2c2b9698cb5496` reached TCP/22 but the remote closed during SSH key exchange before host-key presentation. No remote identity was verified and no VPS read/write occurred. This is classified as SSH transport preflight unavailability, not proven host-key or Shared VPS drift.

Current Gate: `K6R1_SSH_TRANSPORT_DIAGNOSIS`. It performs bounded local/client transport isolation; if strict SSH recovers, it completes the read-only Shared VPS inventory. Deployment writes remain blocked.


## K6 governance realignment

Canonical VPS Governance and the current Shared VPS handoff were re-read before further K6 work. The existing SSH transport contract is already validated and must be reused; the current pre-host-key connection close is `SSH_CONNECTION_REQUIRED`, not proven trust/Shared-VPS drift.

Current Gate: `K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY`.

The Gate makes one canonical strict read-only connection attempt. A repeated pre-host-key close goes to a minimal Hostinger-console status checkpoint rather than alternate-client/key experimentation. If SSH recovers, only the dynamic Shared VPS continuity facts are refreshed.

For later deployment, existing Docker/Compose, Caddy/edge network and `/srv` contracts are reused. Mini Craft also must add the Governance-required `PROJECT_STORAGE_MANIFEST.md` before remote project writes. Global Governance itself needs no change for this incident.


## K6R1 governed SSH recovery — Owner checkpoint

Commit `fe0c5910bbce8d8858ef5273b0d808d2dfa2cac3` followed the canonical SSH contract exactly once. Identity and trust metadata matched locally, but the remote closed before host-key presentation, so K6 cannot yet perform the dynamic Shared VPS read-only preflight.

Current checkpoint: `K6R2_OWNER_HOSTINGER_CONSOLE_CHECK`.

Only provider-side status inspection is requested: VPS Running, browser/serial console availability, ssh/sshd active state, port 22 listening state, and any visible provider network/security block. No configuration mutation is authorized.


## K6R2 Hostinger control-plane fallback

The manual Hostinger console checkpoint is deferred. Before asking Owner to operate a terminal, Executor will use Hostinger's official Codex-compatible Connector/MCP as a read-only provider-control-plane fallback. It may inspect VPS state/metrics, provider firewall, attached SSH-key metadata, action history and Docker Manager project/container state. No provider writes are authorized. If authentication is missing, Owner may only need to complete the browser sign-in/consent flow opened by the official Connector.


## K6R2R1 fresh Codex Hostinger tool-surface check

Historical records confirm the original VPS access was direct governed SSH from the Owner Windows host, using the same ops identity/known_hosts contract that K6R1 already retried. The current failure is therefore not explained by a forgotten SSH command. Because the official Hostinger MCP was registered/authenticated only after the current Executor session began, the next bounded check is a fresh Codex session to determine whether the VPS/API tools load there. No SSH retry or provider write is authorized in this Gate.

## K6R3 governed SSH recovery reconciliation — 2026-09-24

A later independent Reviewer read-only SSH probe succeeded through the recorded `ops` identity and pinned host trust. The previous pre-host-key failure remains historically valid for its attempt, but the Hostinger tool-surface fallback is superseded as the next action. Existing shared applications were healthy, Caddy continued to own 80/443, root disk was 10% used, and no Mini Craft VPS namespace/container existed at the time of the probe. No VPS write occurred.

K5 RC PASS and the Owner's Sandbox-first K6 authorization remain intact. The current Gate is `K6R3_SHARED_VPS_READONLY_PREFLIGHT_COMPLETION`: finish the full shared-host Phase A inventory, then stop for Reviewer decision before any deployment write. Formal decision: `docs/REVIEWER_DECISION_K6R3_SSH_RECOVERY_RECONCILIATION.md`. PayPal Live and real sales remain unauthorized.

## K6R3 shared VPS read-only preflight — PASS

Reviewer accepted the 2026-09-24 Executor inventory after independent strict SSH read-back. The approved host identity, UFW, 80/443 Caddy ownership, Docker/Compose/network state, resource headroom and absence of Mini Craft namespace/container collision were confirmed. Two reported helper command-format failures did not hide a host/trust failure; bounded follow-up and independent read-back completed the required Phase A fields. No remote write, Secret access, payment or Live action occurred. The unrelated pre-existing Xianyu app-root entry remains unclassified and untouched.

Current Gate: `K6_PHASE_B_LOCAL_DEPLOYMENT_PACKAGE_SEAL`. This is local-only preparation of the accepted K5 deployment package, exact production Compose manifest and storage/Secret metadata. K6 deployment has not started. Formal decision: `docs/REVIEWER_DECISION_K6R3_PASS_K6_PHASE_B_PACKAGE_SEAL.md`.
