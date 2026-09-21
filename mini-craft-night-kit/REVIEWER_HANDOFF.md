# Mini Craft Night Kit — REVIEWER HANDOFF

Last reviewed: 2026-09-21  
Maintainer: Reviewer

## Current Reviewer Truth

```text
K0_FUNCTIONAL_RESULT=PASS
K0R1_PROJECT_HYGIENE=PASS
K0R2_WORDPRESS_STUDIO_CONSOLIDATION=PASS
CURRENT_CHECKPOINT=OWNER_K3R11_PUBLIC_SANDBOX_MANUAL_CONNECT_REQUIRED
K1_STATUS=SPLIT_K1A_K1B
DOCKER_SOURCE_MUST_BE_RETAINED=YES
K0_MOBILE_375_VISUAL_BASELINE=KNOWN_DEFECT
K1_MUST_FIX_MOBILE_375=YES
VPS=DEFERRED
PRODUCTION_PAYMENT=DEFERRED
GITHUB_HANDOFF_TRIAL_SUCCESS_COUNT=4
```

Formal decisions:

- `docs/REVIEWER_DECISION_K0_PASS.md`
- `docs/REVIEWER_DECISION_K0R1_PASS.md`

## K0R1 Review Summary

Reviewer accepted the cleanup evidence for:

- five K0-generated WooCommerce download/extraction artifacts removed from the shared workspace root;
- no retained artifact required a project-local archive;
- Home / Product / Cart / Checkout still healthy;
- WordPress remains on port 8090;
- MariaDB remains healthy;
- old project on 8088 still healthy;
- unrelated projects/shared files untouched;
- no Docker volume deletion;
- no real payment;
- no VPS;
- no Secret exposure.

K0R1 is formally closed.

## Current Owner checkpoint

Open:

`http://localhost:8090`

Review:
- Home
- Product
- Cart
- Checkout

Return one decision:

```text
OWNER_TEMPLATE_DECISION=USE
```

or

```text
OWNER_TEMPLATE_DECISION=RETURN
```

No K1 implementation is authorized before this decision.

## If Owner chooses USE

Reviewer will run the pre-K1 UI/Growth decision process:

```text
Owner
+ Reviewer
+ Growth / Acquisition Framework
        ↓
K1_UI_DECISION
        ↓
Executor
```

The K1 scope must define:
- KEEP / ADAPT / DROP;
- Offer hierarchy;
- Hero;
- CTA;
- Trust;
- product facts;
- visual adaptation boundary.

clone-ui may only be used after that target is approved.

## Payment Truth

```text
CANONICAL_COMMERCE_SYSTEM=WOOCOMMERCE
MVP_PAYMENT=WOOCOMMERCE_PAYPAL_PAYMENTS
DUJIAO_SECOND_CANONICAL_ORDER_SYSTEM=NO
```

Payment is not part of the current checkpoint.

## GitHub Handoff Trial

```text
SUCCESSFUL_GATES=2
TARGET_FOR_GLOBAL_GOVERNANCE=3
```

Candidate governance lesson validated:
project-generated downloads, extraction folders, caches, helper files and temporary artifacts must be contained under the project directory or removed before PASS_CANDIDATE.

No global Governance update yet.


## Current K0R2 Override

Formal decision: `docs/REVIEWER_DECISION_K0R2_STUDIO_CONSOLIDATION.md`

Current action: migrate the accepted Docker PoC into WordPress Studio using the supported import path. Keep Docker as rollback. Do not enter K1, payment, or VPS work. Executor must update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md` and stop at Reviewer.


## K0R2 Reviewer Reconciliation

Formal decision: `docs/REVIEWER_DECISION_K0R2_RECONCILED_PASS.md`

The Studio migration is accepted because the 375px clipping reproduces on the retained Docker source and therefore is not a Studio migration regression. The earlier K0 mobile-375 PASS subclaim is superseded. K1 must fix the inherited 375px clipping before K1 can PASS.

Current checkpoint: `OWNER_STUDIO_MIGRATION_REVIEW`.

GitHub handoff stability counter remains at 2 because this Gate exposed a truth conflict.


## K1 Authorization

Owner confirmed the Studio-managed `Mini Craft Night Kit` opens normally and is accepted as the active local development base.

Formal decision: `docs/REVIEWER_DECISION_K1_UI_GROWTH_BRAND_ADAPTATION.md`

Current Gate: `K1_UI_GROWTH_DECISION_AND_BRAND_ADAPTATION`.

Executor must follow the approved Growth/UI hierarchy, use the minimum-change strategy, avoid unverified product claims or fake proof, fix the inherited 375px clipping, preserve Gutenberg/WooCommerce behavior, update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`, then stop at Reviewer.


## K1A Override

K1 implementation is paused. Reviewer must first produce the concrete visual direction and growth-to-UI mapping. Owner approval is required before Codex starts K1B implementation.

Formal decision: `docs/REVIEWER_DECISION_K1A_VISUAL_DIRECTION.md`.


## K1A Deliverable Ready

Reviewer completed `docs/K1A_VISUAL_DIRECTION_AND_GROWTH_MAP.md`.

Do not start K1B until Owner explicitly approves the K1A visual direction.


## K1B Authorization

Owner approved K1A visual/growth direction.

Current Gate: `K1B_WORDPRESS_IMPLEMENTATION`.

Codex must implement using Kadence layout lock, must not generate final images, must use existing approved assets or editable placeholders, must fix inherited 375px clipping, preserve Gutenberg/WooCommerce, update Executor evidence, and stop at Reviewer.

Formal decision: `docs/REVIEWER_DECISION_K1B_WORDPRESS_IMPLEMENTATION.md`.


## K1B Technical Review

Formal decision: `docs/REVIEWER_DECISION_K1B_TECHNICAL_PASS_OWNER_VISUAL_PENDING.md`.

Reviewer accepts the technical evidence. K1B final closure is pending Owner visual review of the Studio-managed site. K2 remains unauthorized.

Owner marker: `OWNER_K1B_VISUAL=PASS` or `OWNER_K1B_VISUAL=RETURN` with specific issues.


## K1B Final PASS

Owner confirmed the initial visual implementation.

Formal decision: `docs/REVIEWER_DECISION_K1B_PASS.md`.

Current Gate: `K2_WOOCOMMERCE_COMMERCE_LOOP`.

K2 should verify the local Product → Add to Cart → Cart → Checkout → Order → Confirmation loop. Do not enter PayPal, production payment, VPS, or production deployment.


## K2 Authorization

Formal decision: `docs/REVIEWER_DECISION_K2_WOOCOMMERCE_COMMERCE_LOOP.md`.

Executor should verify the local WooCommerce commerce loop and stop at Reviewer. Do not enter PayPal, real payment, VPS, or production deployment.


## K2 Final PASS

Formal decision: `docs/REVIEWER_DECISION_K2_PASS.md`.

Reviewer accepts the local Product → Add to Cart → Cart → Checkout → Order → Confirmation → Orders admin loop.

Carry-forward: Studio SQLite required a local-only `hold_stock_minutes=0` workaround. It must not become production policy; normal stock reservation must be revalidated on the production database stack.

Current Gate: `K3_PAYPAL_SANDBOX`.

PayPal login/account authorization/KYC/Secrets/production enablement remain Owner checkpoints.

GitHub handoff stable-Gate count is now 4; a separate Governance Change Gate is eligible but has not been opened or promoted automatically.


## K3 Authorization

Formal decision: `docs/REVIEWER_DECISION_K3_PAYPAL_SANDBOX.md`.

Executor should proceed autonomously through official WooCommerce PayPal Payments Sandbox setup and testing until an actual Owner-only PayPal authorization step is required. Never request Secrets in GitHub/chat. If provider callback cannot reach localhost, return `RETURN_K3_PUBLIC_CALLBACK_REQUIRED` rather than creating an unauthorized public endpoint.


## K3 Owner Authorization Checkpoint

Executor correctly returned at `RETURN_OWNER_PAYPAL_SANDBOX_AUTH_REQUIRED`.

Current checkpoint: `OWNER_K3_PAYPAL_SANDBOX_AUTH`.

Owner action: complete PayPal Sandbox login/account authorization in the official WooCommerce PayPal Payments flow. Do not share password, Secret, token, OAuth code, cookie, or webhook secret. After Owner confirmation, resume K3 from the existing checkpoint; do not restart K3 from scratch.


## K3R1 Authorization

Formal decision: `docs/REVIEWER_DECISION_K3R1_PPCP_CONFLICT_ISOLATION.md`.

Temporarily deactivate only WooCommerce PayPal Payments, retest WooCommerce Home/Payments/admin REST/Store API/worker behavior, and stop at Reviewer. Do not uninstall, version-change, restore backup, retry PayPal authorization, expose Secrets, create a public route, or enable Live.


## K3R1 Result / K3R2 Authorization

K3R1 did not isolate the broader WooCommerce runtime/API failure. PPCP remains deactivated.

Formal decision: `docs/REVIEWER_DECISION_K3R2_PRE_K3_PARALLEL_BASELINE_COMPARISON.md`.

Create a separate temporary Studio site from the retained pre-K3 backup and compare current vs pre-K3 baseline. Do not overwrite the current site, reactivate PPCP, change versions, retry PayPal authorization, or touch production/VPS.


## K3R2 Result / K3R3 Authorization

A and B both reproduce the same timeout/one-hot-PHP-worker failure; B has no PPCP. Broader failure is therefore not isolated to the PayPal plugin or K3 mutation.

Formal decision: `docs/REVIEWER_DECISION_K3R3_STUDIO_WOOCOMMERCE_RUNTIME_ISOLATION.md`.

Keep A read-only with PPCP inactive. Create fresh Studio control C, test clean WordPress (C0), then official WooCommerce 10.0.4 only (C1) if C0 is healthy. Use clone B only for the bounded WooCommerce-deactivation comparison described in the decision. Stop at Reviewer.


## K3R3 Result / K3R4 Authorization

Fresh clean WordPress in Studio reproduced the timeout before WooCommerce existed. Treat the current Studio runtime as unreliable for continued Mini Craft execution.

Formal decision: `docs/REVIEWER_DECISION_K3R4_LOCAL_RUNTIME_ESCAPE_DOCKER_MARIADB.md`.

Create a new isolated Docker + MariaDB local control/recovery stack. Keep A/B/C0, the pre-K3 backup, K0 Docker PoC, and old project untouched. Do not resume PayPal in this Gate. If the Studio backup cannot be moved to MariaDB through a supported/safe path, return to Reviewer rather than writing a custom converter.


## K3R4 Final PASS / K3R5 Authorization

Formal pass: `docs/REVIEWER_DECISION_K3R4_PASS.md`.

Active local runtime is now Docker/MariaDB at `http://localhost:8093/`. Studio A/B/C0 remain retained read-only and are no longer the active execution environment.

Current Gate: `K3R5_PAYPAL_SANDBOX_DOCKER`.

Formal decision: `docs/REVIEWER_DECISION_K3R5_PAYPAL_SANDBOX_DOCKER.md`.

First re-test official PPCP 4.1.3 admin/UI health on Docker before any Owner authorization. If healthy, stop only at the actual Owner Sandbox login/consent checkpoint. If localhost later blocks callback/webhook, return to Reviewer instead of creating a public route.


## K3R5 Result / K3R6 Authorization

PPCP 4.1.3 reproduces React #299 on Docker, but K3R5 also showed the direct PayPal settings route and PPCP REST endpoints responding while the broader runtime remains healthy. Before any version change, isolate whether the exception is limited to the generic Payments overview or breaks the actual `section=ppcp-gateway` React mount.

Formal decision: `docs/REVIEWER_DECISION_K3R6_PPCP_PAGE_SCOPE_MOUNT_ISOLATION.md`.

Test the generic Payments overview and direct PayPal section in separate clean page loads. If the direct PayPal section renders correctly, continue only to the real Owner Sandbox login/consent boundary. If the direct section is broken, return without changing versions.


## K3R6 Final PASS / Owner Sandbox Auth

Formal decision: `docs/REVIEWER_DECISION_K3R6_PASS_OWNER_SANDBOX_AUTH.md`.

Accepted: direct PayPal settings UI is healthy enough to continue; React #299 is an overview-page-only known nonblocking admin defect.

Owner should now complete only PayPal Sandbox provider login/authorization on the Docker/MariaDB runtime at `http://localhost:8093/`. After Owner confirmation, resume the same K3 flow; do not restart earlier isolation Gates.


## K3 Automatic Onboarding Callback Result / K3R7

Provider-side completion did not write a local merchant connection: merchant connected=no, onboarding completed=no, merchant ID absent, Sandbox mode=no. Do not treat the prior provider success page as K3 Sandbox PASS.

Formal decision: `docs/REVIEWER_DECISION_K3R7_PAYPAL_SANDBOX_MANUAL_CONNECTION.md`.

Owner should use PPCP `See advanced options` → Sandbox Mode → Manually Connect with SANDBOX REST app credentials entered only in the local WooCommerce UI. Do not expose credentials in chat/GitHub. Public callback/tunnel remains deferred until after Sandbox merchant connection is confirmed.


## K3R7 Result / K3R8 Authorization

Manual Sandbox connection still fails with the official PPCP error. Stop repeated reconnect attempts.

Formal decision: `docs/REVIEWER_DECISION_K3R8_PAYPAL_SANDBOX_CREDENTIAL_PLUGIN_ISOLATION.md`.

First verify container PayPal Sandbox network/TLS without secrets, then have Owner run a local secure direct OAuth check. If OAuth succeeds but PPCP still rejects the same credentials, return a PPCP 4.1.3 manual-connect defect to Reviewer without version changes or source patches.


## K3R8 Phase A PASS / Owner OAuth Checkpoint

Container DNS and HTTPS/TLS reachability to PayPal Sandbox passed. HTTP 403 from an unauthenticated request is not a credential verdict.

Current checkpoint: `OWNER_K3R8_SANDBOX_OAUTH_CHECK_REQUIRED`.

Owner should run the local helper at `.artifacts/k3r8-paypal-sandbox-oauth-check.ps1`, enter Sandbox Client ID and Secret only into the local PowerShell prompts, and report only the helper's redacted PASS/FAIL + HTTP status output.


## K3R8 Owner OAuth Result / K3R8B

The Owner-run helper failed locally before producing a PayPal HTTP authentication result: `LOCAL_REQUEST_FAILURE`. Do not classify the Sandbox credentials yet.

Formal decision: `docs/REVIEWER_DECISION_K3R8B_LOCAL_OAUTH_HELPER_DIAGNOSTIC.md`.

Inspect/fix only the local helper and host request path with redacted diagnostics; then return a corrected Owner-run command. Secrets remain Owner-only.


## K3R8B Owner Checkpoint

Executor completed the host/helper diagnostic and returned `RETURN_OWNER_K3R8B_CORRECTED_HELPER_REQUIRED`. Credentials are still unclassified.

Owner should rerun the corrected helper locally and report only the redacted PASS/FAIL and HTTP/result classification. Do not paste Client ID, Secret, tokens, headers, or response body.


## K3R8B Re-run Result / K3R8C Authorization

Owner re-ran the corrected helper and it still failed at the host PowerShell request layer with `POWERSHELL_REQUEST_EXCEPTION`. This is not a credential verdict.

Formal decision: `docs/REVIEWER_DECISION_K3R8C_CONTAINER_NATIVE_OAUTH_CHECK.md`.

Bypass the host PowerShell HTTP stack. Perform the direct OAuth request inside the active WordPress container with credentials supplied only via Owner interactive STDIN. All future diagnostic returns must include the mandatory `DIAGNOSTIC_PACKET` from `docs/GITHUB_HANDOFF_PROTOCOL.md`; conclusion-only handoffs are incomplete.


## K3R8C Executor Result / Owner Checkpoint

Reviewer reviewed the appended K3R8C evidence and `DIAGNOSTIC_PACKET`. The handoff is materially better than the prior conclusion-only diagnostic returns: environment, trigger, reproduction path, observations, ruled-out hypotheses, remaining hypotheses, artifacts, secret boundary, next discriminating test, and stop reason are all present.

Current checkpoint: `OWNER_K3R8C_CONTAINER_OAUTH_REQUIRED`.

Owner action: run `.artifacts/k3r8c-container-oauth.ps1` locally and return only `CONTAINER_OAUTH_STAGE`, `PAYPAL_SANDBOX_OAUTH`, `HTTP_STATUS`, `TOKEN_RECEIVED`, and `ERROR_CLASS`.


## K3R8C Owner Run Failure / K3R8D Authorization

Owner's exact K3R8C command returned `LOCAL_HELPER_MISSING` before any OAuth HTTP result. Credentials remain unclassified.

This exposes a gap between the prior evidence claim (local helpers retained) and actual Owner checkpoint readiness. K3R8D is limited to repairing and proving the helper artifact/staging chain with no credentials.

Formal decision: `docs/REVIEWER_DECISION_K3R8D_OWNER_HELPER_ARTIFACT_READINESS_REPAIR.md`.

Do not return another Owner command until `DIAGNOSTIC_PACKET` + `OWNER_CHECKPOINT_READINESS` are both present and the exact wrapper path passes a no-secret post-cleanup dry run.

## Owner Note — Handoff Experiment Is Reference Only

Do not modify or reinterpret the original project-management Governance from this project-local experiment.

The proposed Handoff V2 / review-packet approach is not yet validated and is reference-only. Continue using the existing approved Governance and current project-local GitHub handoff protocol.

After the current K3R8* issue reaches a stable resolution, the next Reviewer task is a fresh overall project review based on actual current source/runtime/evidence. Prior Reviewer conclusions must be revalidated where evidence is material.

## K3R8D Review / Owner Checkpoint

Reviewer inspected the K3R8D Executor evidence directly in GitHub rather than accepting the handoff label alone.

Evidence is internally consistent: the previous failure occurred before `docker cp`, the repaired wrapper resolves the PHP helper via `$PSScriptRoot`, the retained helper sizes/hashes are recorded, and two no-secret staging → container execution → cleanup dry runs are recorded as passing.

Reviewer limitation: the actual local `.artifacts` helper bytes are not present in GitHub, so their existence/content cannot be independently verified from the repository. The Owner run is the next decisive verification of that local state.

Current checkpoint: `OWNER_K3R8D_CONTAINER_OAUTH_REQUIRED`.

After the current K3R8* issue is stably resolved, perform the already-requested fresh overall project review against actual current source/runtime/evidence.

## K3R8D Owner OAuth PASS / K3R8C Phase C

Owner's repaired container-native helper reached PayPal Sandbox through WordPress `wp_remote_post` and returned HTTP 200 with an access token present.

Reviewer accepts:

- `PAYPAL_SANDBOX_CREDENTIAL_PAIR=VALID_FOR_THIS_RUN`
- `PAYPAL_SANDBOX_CONTAINER_HTTP=PASS`
- `PAYPAL_SANDBOX_OAUTH_TOKEN_ISSUANCE=PASS`

Do not continue treating invalid credentials as the leading explanation if PPCP rejects this same pair.

Current Gate: `K3R8C_PHASE_C_PPCP_MANUAL_CONNECT_ISOLATION`.

Executor should now inspect the existing failed PPCP manual-connect attempt's redacted REST/log evidence first. Do not ask Owner to re-enter credentials unless existing evidence is insufficient; at most one bounded retry is allowed. No version change, source patch, Live mode, real payment, public tunnel, or VPS action.

## K3R8C Phase C Review / K3R8E Authorization

Reviewer inspected the underlying K3R8C evidence and PPCP 4.1.3 source rather than accepting the Executor return label alone.

Confirmed: manual connect fails in `request_payee()` after valid OAuth. PPCP's source creates a minimal USD 1.00 order, retrieves it, then expects payee merchant ID + email; exceptions are collapsed into the generic `Failed to retrieve payee details.` message.

Not confirmed yet: that PPCP itself is the root-cause defect. The same symptom could still be caused by PayPal Sandbox/app/account behavior in that exact order create/get path.

Current Gate: `K3R8E_PAYEE_PROBE_PARITY_TEST`.

Run one provider-parity test outside PPCP using the same request semantics and Owner-entered Sandbox credentials. No version change, patch, Live, capture, real payment, tunnel, or VPS.

Formal decision: `docs/REVIEWER_DECISION_K3R8E_PAYEE_PROBE_PARITY_TEST.md`.

## K3R8E Review / Owner Checkpoint

Reviewer independently checked the latest K3R8E evidence and the formal parity-test decision rather than accepting the Executor return label by itself.

The intended test is correctly bounded: Sandbox-only OAuth, create one uncaptured USD 1.00 test order, GET that order, and report only whether payee fields are present. It is specifically designed to distinguish PayPal Sandbox/account/app behavior from PPCP 4.1.3's `request_payee()` path.

Recorded readiness evidence is sufficient to proceed to the Owner checkpoint, with one limitation: the local helper source itself is not committed to GitHub, so Reviewer cannot inspect its bytes directly.

Current checkpoint: `OWNER_K3R8E_PAYEE_PROBE_REQUIRED`.


## K3R8E Final Review — PASS / K3R9 Authorization

Owner returned the approved K3R8E redacted parity result:

```text
OAUTH_HTTP=200
ORDER_CREATE_HTTP=201
ORDER_GET_HTTP=200
PAYEE_OBJECT_PRESENT=YES
PAYEE_MERCHANT_ID_PRESENT=YES
PAYEE_EMAIL_PRESENT=YES
ERROR_CLASS=NONE
```

Reviewer accepts `K3R8E_PAYEE_PROBE_PARITY_TEST=PASS`.

This proves that, on the active Docker/MariaDB runtime, the same Sandbox app/account can successfully complete OAuth, create the minimal USD 1.00 uncaptured order, retrieve it, and receive the payee fields PPCP expects.

The provider/app/account path is therefore no longer the isolated failure boundary for this test. The remaining boundary is PPCP 4.1.3's manual-connect client path or an interaction affecting that path inside WordPress.

PPCP 4.1.3 is currently the official latest version, so no upgrade Gate is authorized. The next bounded step follows official support-style conflict isolation before any source patch.

Current Gate: `K3R9_PPCP_MINIMAL_ENV_ISOLATION`.

Formal decision: `docs/REVIEWER_DECISION_K3R8E_PASS_K3R9_MINIMAL_ENV_ISOLATION.md`.

Executor may prepare a rollback point, temporarily reduce active plugins to WooCommerce + WooCommerce PayPal Payments, clear reversible caches/transients, verify the direct settings UI, and stop at an Owner Manual Connect checkpoint. No version change, source patch, theme replacement, Live, payment, tunnel, or VPS action is authorized.


## K3R9 Phase A Review — PASS / Owner Manual Connect

Reviewer independently inspected the latest Executor evidence and accepts the minimal-environment preparation.

```text
K3R9_PPCP_MINIMAL_ENV_PREP=PASS
ROLLBACK_READY=PASS
PLUGIN_ISOLATION=PASS
DIRECT_PAYPAL_SETTINGS=PASS
MINIMAL_ENV_RUNTIME=PASS
OWNER_MANUAL_CONNECT=AUTHORIZED_ONCE
```

Current checkpoint: `OWNER_K3R9_SANDBOX_MANUAL_CONNECT_REQUIRED`.

Owner may perform exactly one Sandbox Manual Connect in the direct PayPal Settings page using locally entered credentials. No retry, Live, payment/capture, source patch, version change, tunnel, or VPS action is authorized.

After the Owner result, Executor must restore the prior plugin activation state exactly and return evidence to Reviewer.

Formal decision: `docs/REVIEWER_DECISION_K3R9_PREP_PASS_OWNER_MANUAL_CONNECT.md`.


## K3R9 Owner Manual Connect — UI SUCCESS / Post-Restore Verification

Owner supplied direct UI evidence showing the visible success toast `Connected to PayPal` in the active local PayPal Payments settings page.

Reviewer accepts:

```text
MANUAL_CONNECT_RESULT=SUCCESS
VISIBLE_MESSAGE=Connected to PayPal
MERCHANT_CONNECTED=UNKNOWN_PENDING_READ_ONLY_VERIFY
SANDBOX_CONNECTED=UNKNOWN_PENDING_READ_ONLY_VERIFY
```

The failure does not reproduce in the minimal plugin environment, which strongly points to a WordPress/plugin interaction rather than PayPal Sandbox provider capability.

K3R9 is not formally closed yet. Executor must restore Kadence Blocks 3.7.11 and Kadence Starter Templates 2.3.4, keep WooCommerce 10.0.4 + PPCP 4.1.3 active, then perform read-only connection/runtime verification and stop at Reviewer. No reconnect, credential entry, version/source change, Live, payment, tunnel, or VPS action.

Current checkpoint: `K3R9_POST_RESULT_RESTORE_AND_VERIFY`.

Formal decision: `docs/REVIEWER_DECISION_K3R9_OWNER_CONNECT_SUCCESS_POST_RESTORE_VERIFY.md`.


## K3R9 Final Review — PASS / K3R10 Authorization

Reviewer independently inspected the post-restore evidence and Executor commit.

Accepted:

```text
K3R9_PPCP_MINIMAL_ENV_ISOLATION=PASS
PLUGIN_STATE_RESTORED=PASS
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_CONNECTED=YES
PPCP_ONBOARDING_COMPLETED=YES
DIRECT_PAYPAL_SETTINGS_AFTER_RESTORE=PASS
WORDPRESS_RUNTIME_AFTER_RESTORE=PASS
WOOCOMMERCE_RUNTIME_AFTER_RESTORE=PASS
```

Important correction: K3R9 does **not** prove Kadence caused the earlier failure. Manual Connect succeeded after minimal-environment/transient isolation, and the connection remained healthy after restoring the complete prior plugin set. The exact historical trigger remains unresolved and is deferred unless it recurs.

Current Gate: `K3R10_PAYPAL_SANDBOX_CHECKOUT_CAPTURE`.

K3R10 resumes the original K3 payment acceptance path: checkout visibility → one Sandbox order → Owner buyer approval if required → capture → WooCommerce paid/processing state → provider/order correlation → callback/webhook inspection. No Live, real payment, tunnel, VPS, source patch, or version change.

Formal decision: `docs/REVIEWER_DECISION_K3R9_PASS_K3R10_SANDBOX_CHECKOUT_CAPTURE.md`.

Project-local side task recorded: `docs/SIDE_TASK_GITHUB_HANDOFF_STRUCTURED_RECEIPT.md`. It is non-blocking and does not yet modify active Governance.


## K3R10 Review — RETURN Accepted / K3R11 Public Sandbox Origin

Reviewer independently inspected the K3R10 evidence and PPCP SDK v6 client-token source.

Accepted:

```text
PAYPAL_CHECKOUT_METHOD_VISIBLE=YES
PPCP_CLIENT_TOKEN=FAIL
PAYPAL_CHECKOUT_BUTTON_RENDERED=NO
BUYER_APPROVAL_REACHED=NO
ORDER_CREATED=NO
WEBHOOK_REGISTER=FAIL_INVALID_PUBLIC_URL
PUBLIC_CALLBACK_REQUIRED=YES
RETURN_K3_PUBLIC_CALLBACK_REQUIRED=ACCEPTED
```

Precision correction: this is a **public Sandbox origin** boundary, not webhook-only. PPCP client-token generation is independent from webhook registration but also derives its domain from WordPress `home_url()`; the current localhost origin is therefore part of both blocked paths.

Security incident: a pre-existing PPCP log line containing Sandbox credential fields was surfaced in diagnostic output. No value was committed to GitHub, but the affected Sandbox Secret must be rotated before reuse.

Current checkpoint: `OWNER_K3R11_SANDBOX_SECRET_ROTATION_REQUIRED`.

After Owner confirms rotation (without sharing the new Secret), Executor may prepare a temporary reversible HTTPS public Sandbox origin. K3R11 stops before buyer approval/capture.

Formal decision: `docs/REVIEWER_DECISION_K3R10_RETURN_K3R11_PUBLIC_SANDBOX_ORIGIN.md`.
Incident: `docs/SECURITY_INCIDENT_K3R10_SANDBOX_CREDENTIAL_OUTPUT.md`.


## K3R11 Owner Secret Rotation — COMPLETE / Execution Authorized

Owner confirmed:

```text
SANDBOX_SECRET_ROTATED=YES
```

Reviewer accepts the security precondition for K3R11. The replacement Sandbox Secret remains Owner-only and must not be pasted into chat/GitHub or surfaced in diagnostic output.

Current Gate: `K3R11_PUBLIC_SANDBOX_ORIGIN`.

Executor is authorized to proceed with the already-approved temporary, reversible HTTPS public Sandbox origin preparation defined in `docs/REVIEWER_DECISION_K3R10_RETURN_K3R11_PUBLIC_SANDBOX_ORIGIN.md`.

If the rotated Secret invalidates the stored PPCP Sandbox connection, Executor must stop at an Owner local-UI reconnect checkpoint; it must not request or read the Secret.


## K3R11 Preflight Review — Owner Sandbox Reconnect Required

Reviewer independently inspected Executor commit `ac80184082607502e2d547e8ec7646c8db58465a`.

Accepted:

```text
ROLLBACK_READY=PASS
SANDBOX_SECRET_ROTATION_CONFIRMED=YES
PPCP_MERCHANT_CONNECTED=NO
PPCP_SANDBOX_MODE=YES
PPCP_ONBOARDING_COMPLETED=YES
PUBLIC_HTTPS_ORIGIN=NOT_CREATED
RUNTIME_HEALTH=PASS
```

Executor correctly stopped before creating a public origin because the rotated Secret invalidated the stored PPCP merchant connection.

Current checkpoint: `OWNER_K3R11_SANDBOX_RECONNECT_REQUIRED`.

Owner may perform exactly one local Sandbox Manual Connect using the rotated credentials in the local PayPal Settings page, then return only a sanitized success/fail UI result. No checkout, capture, Live, tunnel, VPS, or further mutation is authorized at this checkpoint.

Formal decision: `docs/REVIEWER_DECISION_K3R11_OWNER_SANDBOX_RECONNECT.md`.


## K3R11 Owner UI Observation — Reconnect Paused

Owner reached the local PayPal Settings page but no Manual Connect control is present. The UI instead shows Connection status with a Disconnect control and Business/Sandbox account metadata, while the prior Executor REST probe reported `PPCP_MERCHANT_CONNECTED=NO`.

```text
PPCP_ADMIN_UI_CONNECTION_STATE=CONNECTED_PRESENTATION
PPCP_REST_MERCHANT_CONNECTED=NO
OWNER_RECONNECT_ACTION=PAUSED
DISCONNECT_AUTHORIZED=NO
CURRENT_GATE=K3R11_CONNECTION_STATE_RECONCILIATION
```

Do not ask Owner to disconnect merely to reveal Manual Connect. Executor must perform read-only reconciliation of the UI-vs-REST state and return the smallest safe next action.

Formal decision: `docs/REVIEWER_DECISION_K3R11_UI_REST_CONNECTION_STATE_MISMATCH.md`.


## K3R11 Connection-State Reconciliation — PASS / Rebind Prep

Reviewer independently inspected Executor commit `1657c2b815656e493c8100df117a77dbd413608a` and the PPCP authentication/disconnect source.

Accepted:

```text
K3R11_CONNECTION_STATE_RECONCILIATION=PASS
PPCP_ADMIN_UI_CONNECTION_STATE=CONNECTED_PRESENTATION
PPCP_REST_MERCHANT_CONNECTED=YES
PPCP_STATE_MISMATCH=FALSE_PRIOR_PROBE_PATH_ERROR
DISCONNECT_ACTION=NOT_EXECUTED_YET
RECONNECT_ACTION=NOT_EXECUTED
SECRET_VALUES_OUTPUT=NO
```

Correction: the earlier `PPCP_MERCHANT_CONNECTED=NO` result is superseded; the helper parsed `data.merchant` instead of the actual top-level `merchant` object.

Security boundary remains: local PPCP is still bound to credential material stored before Owner rotated the Sandbox Secret, and `OLD_SANDBOX_SECRET_REUSE=FORBIDDEN` remains authoritative.

PPCP official disconnect source clears local merchant/authentication state without requiring Owner credentials. One bounded official disconnect is therefore authorized before public-origin setup.

Current Gate: `K3R11_PUBLIC_ORIGIN_REBIND_PREP`.

Sequence: verify rollback → official local disconnect once → verify old binding cleared → create temporary HTTPS public origin → switch WordPress origin reversibly → verify reachability → stop at Owner Manual Connect using rotated credentials. No buyer approval/capture yet.

Formal decision: `docs/REVIEWER_DECISION_K3R11_CONNECTION_RECONCILED_PUBLIC_ORIGIN_REBIND.md`.


## K3R11 Rebind Prep — Owner Disconnect Confirmation

Reviewer independently inspected Executor commit `29e91674322273dcb8a670b8b528a0e2c51940ec`.

Accepted:

```text
ROLLBACK_POINT_VERIFIED=PASS
DOCKER_WORDPRESS=RUNNING
DOCKER_MARIADB=RUNNING_HEALTHY
LOCAL_HOME_HTTP=200
OFFICIAL_DISCONNECT_CONTROL=LOCATED
DISCONNECT_ACTION=NOT_EXECUTED
PUBLIC_HTTPS_ORIGIN=NOT_CREATED
WORDPRESS_URL_REBIND=NOT_EXECUTED
SECRET_VALUES_OUTPUT=NO
```

Current checkpoint: `OWNER_K3R11_DISCONNECT_CONFIRMATION_REQUIRED`.

Owner must explicitly confirm one official PPCP Disconnect action. After confirmation, Executor may perform exactly one official Disconnect, verify redacted disconnected state/runtime health, then continue the already-authorized public-origin preparation. No credential input, checkout, capture, Live, VPS, or production-domain action is authorized at this checkpoint.


## K3R11 Owner Confirmation / Governance Boundary Correction

Owner explicitly confirmed the single official Disconnect action.

```text
OWNER_K3R11_DISCONNECT_CONFIRMATION=YES
CURRENT_GATE=K3R11_PUBLIC_ORIGIN_REBIND_PREP
```

Governance correction: this Owner checkpoint was unnecessarily conservative. A local, reversible, rollback-protected action that is already explicitly Reviewer-authorized and does not require secrets/provider authorization should not require a second Owner confirmation. Future equivalent actions should proceed without interrupting Owner.

Executor may now perform exactly one official PPCP Disconnect, verify redacted disconnected state/runtime health, and continue public-origin preparation. Stop only at a genuine Owner-only boundary such as Cloudflare account authorization or local entry of rotated Sandbox credentials.

Formal decision: `docs/REVIEWER_DECISION_K3R11_DISCONNECT_CONFIRMED_AND_OWNER_GATE_CORRECTION.md`.


## K3R11 Public-Origin Rebind Prep — PASS / Owner Manual Connect

Reviewer independently inspected Executor commit `8663ef00b7f339e8da482237825fe1827d0b0988`.

Accepted:

```text
K3R11_PUBLIC_ORIGIN_REBIND_PREP=PASS
ROLLBACK_POINT_VERIFIED=PASS
OFFICIAL_DISCONNECT=PASS_ONCE
OLD_CREDENTIAL_BINDING_CLEARED=PASS
PUBLIC_HTTPS_ORIGIN=PASS
WORDPRESS_URL_REBIND=PASS_REVERSIBLE
PUBLIC_FRONTEND=PASS
PUBLIC_WP_ADMIN=PASS_AUTH_REDIRECT
PUBLIC_DIRECT_PAYPAL_SETTINGS=PASS_AUTH_REDIRECT
RUNTIME_HEALTH=PASS
SECRET_VALUES_OUTPUT=NO
```

Temporary public origin: `https://email-rich-barbie-merchants.trycloudflare.com`.

Current checkpoint: `OWNER_K3R11_PUBLIC_SANDBOX_MANUAL_CONNECT_REQUIRED`.

Owner may log into WordPress through the temporary HTTPS origin and perform exactly one Sandbox Manual Connect using the already-rotated credentials. Keep credentials local; after the sanitized UI result, stop before buyer approval/capture.

Quick Tunnel is ephemeral; if it becomes unavailable before Owner completes the action, return to Executor for tunnel re-establishment rather than changing scope.

Formal decision: `docs/REVIEWER_DECISION_K3R11_REBIND_PREP_PASS_OWNER_PUBLIC_MANUAL_CONNECT.md`.
