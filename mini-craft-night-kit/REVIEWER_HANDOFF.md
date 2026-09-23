# Mini Craft Night Kit — REVIEWER HANDOFF

Last reviewed: 2026-09-21  
Maintainer: Reviewer

## Current Reviewer Truth

```text
K0_FUNCTIONAL_RESULT=PASS
K0R1_PROJECT_HYGIENE=PASS
K0R2_WORDPRESS_STUDIO_CONSOLIDATION=PASS
CURRENT_CHECKPOINT=OWNER_K4_FINAL_UI_EDIT_WINDOW
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


## K3R11 Owner Public Manual Connect — UI SUCCESS / Readiness Verification

Owner supplied direct UI evidence from the temporary public HTTPS origin showing the success toast `Connected to PayPal`.

Reviewer accepts:

```text
OWNER_PUBLIC_MANUAL_CONNECT=SUCCESS
VISIBLE_MESSAGE=Connected to PayPal
```

Current Gate: `K3R11_PUBLIC_ORIGIN_READINESS_VERIFY`.

Executor may now verify merchant connection, Sandbox/onboarding state, SDK v6 client-token generation, PayPal Checkout button rendering, webhook registration/status, direct settings health, and runtime health. No buyer approval, capture, refund, Live, VPS, production-domain cutover, version change, or source patch.

Formal decision: `docs/REVIEWER_DECISION_K3R11_OWNER_PUBLIC_CONNECT_SUCCESS_VERIFY_READINESS.md`.


## K3R11 Final Review — PASS / K3R10 Resumed

Reviewer independently inspected Executor commit `f8c416006dd84d4b00b50a9837e9b6a5f8b30870`.

Accepted:

```text
K3R11_PUBLIC_ORIGIN_READINESS_VERIFY=PASS
SANDBOX_MERCHANT_CONNECTED=PASS
PPCP_CLIENT_TOKEN=PASS
PAYPAL_CHECKOUT_BUTTON_RENDERED=PASS
WEBHOOK_REGISTER=PASS
PUBLIC_HTTPS_ORIGIN=PASS
RUNTIME_HEALTH=PASS
BUYER_APPROVAL=NOT_EXECUTED
CAPTURE_ACTIONS=0
```

K3R11 is formally closed. The temporary HTTPS Quick Tunnel and WordPress public-origin rebind remain active because the resumed Sandbox payment/callback test requires them.

Current Gate: `K3R10_PAYPAL_SANDBOX_CHECKOUT_CAPTURE_RESUME`.

Executor may proceed through the bounded public Checkout until Sandbox buyer authentication/approval is required, then stop at Owner. After Owner approval, exactly one Sandbox payment/capture will be verified together with WooCommerce paid/processing state, redacted provider correlation, physical-fulfillment non-completion, and actual webhook/callback processing.

Formal decision: `docs/REVIEWER_DECISION_K3R11_PASS_RESUME_K3R10_SANDBOX_CAPTURE.md`.


## K3R10 Resumed Checkout — Owner Sandbox Buyer Auth

Reviewer independently inspected Executor commit `d7c14cc5eaa7e92c147231f1d44a02b849c2e146`.

Accepted:

```text
PAYPAL_CHECKOUT_OPEN=PASS
PAYPAL_SELECTED=PASS
BUYER_AUTHENTICATION=OWNER_REQUIRED
BUYER_APPROVAL=NOT_EXECUTED
ORDER_CREATED=NOT_OBSERVED_BEFORE_CHECKPOINT
CAPTURE_ACTIONS=0
REFUND_ACTIONS=0
PUBLIC_HTTPS_ORIGIN=RETAINED
PAYPAL_LIVE_ENABLED=NO
```

Current checkpoint: `OWNER_K3R10_SANDBOX_BUYER_AUTH_REQUIRED`.

Owner may privately complete Sandbox buyer login and approve the single test purchase, then return only a sanitized success/fail result. Do not share buyer credentials or provider payloads.

Formal decision: `docs/REVIEWER_DECISION_K3R10_OWNER_SANDBOX_BUYER_AUTH.md`.


## K3R10 Owner Closed Buyer Flow — Reopen Once Authorized

Owner closed the PayPal popup and prior Checkout page before buyer login/approval.

Accepted prior state remains:

```text
BUYER_APPROVAL=NOT_EXECUTED
ORDER_CREATED=NOT_OBSERVED_BEFORE_CHECKPOINT
CAPTURE_ACTIONS=0
REFUND_ACTIONS=0
```

The prior provider handoff is treated as abandoned before payment. Owner may reopen the current public Checkout and start exactly one fresh Sandbox buyer flow, then privately complete buyer login/approval.

Current checkpoint: `OWNER_K3R10_SANDBOX_BUYER_AUTH_REOPEN_REQUIRED`.

Formal decision: `docs/REVIEWER_DECISION_K3R10_REOPEN_SANDBOX_BUYER_FLOW.md`.


## K3R10 Owner Sandbox Buyer Approval — SUCCESS / Post-Payment Verify

Owner supplied UI evidence showing the WooCommerce order-received page after completing the single Sandbox PayPal buyer flow.

Accepted:

```text
BUYER_APPROVAL_RESULT=SUCCESS
ORDER_RECEIVED_UI=PASS
SINGLE_TEST_FLOW=YES
CAPTURE_STATE=UNKNOWN_PENDING_EXECUTOR_VERIFY
WEBHOOK_PROCESSING=UNKNOWN_PENDING_EXECUTOR_VERIFY
```

Current Gate: `K3R10_POST_PAYMENT_CAPTURE_WEBHOOK_VERIFY`.

Executor may now verify exactly one order/capture, WooCommerce paid/processing state, redacted PayPal correlation, physical-fulfillment non-completion, actual webhook/callback processing, and runtime health. No second payment or refund is authorized.

Formal decision: `docs/REVIEWER_DECISION_K3R10_OWNER_BUYER_APPROVAL_SUCCESS_VERIFY_CAPTURE.md`.


## K3 Final Review — PASS / K4 Authorized

Reviewer independently inspected Executor commit `bc81a85bc70804c3b00cf095508d2595d357a0fa`.

Accepted:

```text
K3_PAYMENT=PASS
SINGLE_SANDBOX_PAYMENT=PASS
PAYPAL_CAPTURE=PASS
WOO_ORDER_PAID_PROCESSING=PASS
PAYPAL_WOO_CORRELATION=PASS_REDACTED
PHYSICAL_FULFILLMENT_AUTO_COMPLETED=NO
WEBHOOK_CALLBACK=PASS
DUPLICATE_PAYMENT=NO
DUPLICATE_CAPTURE=NO
```

K3 Sandbox payment acceptance is formally closed.

Current Gate: `K4_CONVERSION_TRUST`.

At K4 start, Executor should first restore WordPress home/siteurl to the recorded localhost origin and stop the temporary Quick Tunnel after localhost health verification. This is an authorized local cleanup and does not require another Owner checkpoint.

K4 scope follows the project roadmap: Home / Product / FAQ / Shipping & Returns / Contact. Executor must preserve business truth, WooCommerce behavior, Owner editability, responsive behavior, and Gutenberg validity. Missing business facts must be batched into one compact Owner checkpoint rather than asked piecemeal.

Formal decision: `docs/REVIEWER_DECISION_K3_PASS_K4_CONVERSION_TRUST.md`.


## K4 Scope Update — UI Modification Added

Owner requested that explicit UI modification be part of the project flow. K4 remains a single Gate rather than being split further.

```text
CURRENT_GATE=K4_REUSABLE_STOREFRONT_SHELL_SPEC
UI_MODIFICATION_STAGE=ADDED
```

Execution order: UI Modification → Conversion & Trust → K4 acceptance → K5 RC QA.

Owner may directly edit Home / Product / FAQ / Shipping & Returns / Contact during K4. Executor must avoid simultaneous edits to the same page and must re-read the latest page state before resuming work on Owner-edited pages.

Protected without separate Reviewer approval: Cart / Checkout / Account core flows, PayPal configuration, and WooCommerce payment/order state logic.

Formal decision: `docs/REVIEWER_DECISION_K4_UI_CONVERSION_TRUST_SCOPE.md`.


## K4 Implementation Review — PASS / Owner Business Facts

Reviewer independently inspected Executor commit `f6f9166c24389504741f184132cfb9b5f5006899`.

Accepted implementation evidence:

```text
K4_IMPLEMENTATION=PASS
UI_MODIFICATION=PASS
HOME_CONVERSION_TRUST=PASS
PRODUCT_CONVERSION_TRUST=PASS
FAQ=PASS
BUSINESS_TRUTH=PASS
OWNER_EDITABILITY=PASS
RESPONSIVE=PASS
GUTENBERG_VALIDITY=PASS
WOOCOMMERCE_BEHAVIOR=PASS
```

K4 is not formally closed because Shipping & Returns and Contact intentionally remain at safe factual boundaries pending Owner-confirmed business facts.

Current checkpoint: `OWNER_K4_BUSINESS_FACTS_REQUIRED`.

All remaining facts are batched into one Owner checkpoint: final kit contents; duration/difficulty; shipping destinations/method/cost/timing; return window/conditions; missing/damaged-item support channel; public support email/contact channel; and public business/return address if one will be published.

Formal decision: `docs/REVIEWER_DECISION_K4_IMPLEMENTATION_PASS_OWNER_BUSINESS_FACTS.md`.


## K4 Owner Business Facts — CONFIRMED

Owner approved the recommended MVP defaults and confirmed they must remain editable later.

```text
OWNER_K4_BUSINESS_POLICY=CONFIRMED
INITIAL_MARKET=UNITED_STATES
SHIPPING_METHOD=TRACKED_STANDARD_SHIPPING
SHIPPING_COST=DISPLAY_AT_CHECKOUT
FIXED_DELIVERY_PROMISE=NO_UNTIL_VERIFIED
RETURN_WINDOW=14_DAYS_AFTER_DELIVERY
NON_DEFECT_RETURN_CONDITION=UNUSED_UNASSEMBLED_ORIGINAL_PACKAGING
NON_DEFECT_RETURN_SHIPPING=BUYER_PAID
MISSING_DAMAGED_REPORT_WINDOW=7_DAYS
MISSING_DAMAGED_PRIMARY_REMEDY=REPLACEMENT_FIRST
PUBLIC_SUPPORT_CHANNEL=CONTACT_FORM
DOMAIN_SUPPORT_EMAIL=ADD_WHEN_FINALIZED
PUBLIC_HOME_ADDRESS=NO
BUSINESS_RULES_FUTURE_EDITABLE=YES
CURRENT_GATE=K4_REUSABLE_STOREFRONT_SHELL_SPEC
```

Product contents must only reflect supplier-confirmed SKU contents. Difficulty may be described as suitable for beginners/hobbyists, but no fixed completion time may be promised until verified.

Executor may now update Product / FAQ / Shipping & Returns / Contact using these approved rules and perform one final K4 verification pass.

Formal decision: `docs/REVIEWER_DECISION_K4_OWNER_BUSINESS_FACTS_CONFIRMED.md`.


## K4 Owner UI Edit Window — REQUIRED BEFORE FORMAL CLOSE

Owner clarified that no personal UI edits have been made yet. The currently issued Executor K4-finalize run remains valid, but K4 must not be formally closed immediately after that run.

Required sequence: Executor current run → STOP_AT_REVIEWER → Owner UI edit window → bounded delta verification → K4 PASS → K5.

Do not allow concurrent Owner/Executor edits to the same page. Owner may edit Home / Product / FAQ / Shipping & Returns / Contact only; Cart / Checkout / Account core flows and payment/order logic remain protected.

Pending checkpoint after Executor returns: `OWNER_K4_UI_EDIT_WINDOW`.

Formal decision: `docs/REVIEWER_DECISION_K4_OWNER_UI_EDIT_WINDOW_BEFORE_K5.md`.


## K4 Finalize Review — ACCEPTED / Owner UI Edit Window OPEN

Reviewer independently inspected Executor commit `ab635ae3e9890ee7f2a479d879899c171ff7af46`.

Accepted baseline:

```text
K4_FINALIZE_IMPLEMENTATION=PASS
HOME_CONVERSION_TRUST=PASS
PRODUCT_CONVERSION_TRUST=PASS
FAQ=PASS
SHIPPING_RETURNS=PASS
CONTACT=PASS
BUSINESS_TRUTH=PASS
OWNER_EDITABILITY=PASS
RESPONSIVE=PASS
GUTENBERG_VALIDITY=PASS
WOOCOMMERCE_BEHAVIOR=PASS
RUNTIME_HEALTH=PASS
```

K4 is intentionally not closed yet.

Current checkpoint: `OWNER_K4_UI_EDIT_WINDOW`.

Owner may now edit Home / Product / FAQ / Shipping & Returns / Contact. Executor must not concurrently edit those pages. Cart / Checkout / Account core flows and PayPal/WooCommerce payment-order logic remain protected.

After Owner reports UI editing complete, Executor performs one bounded delta verification from the latest Owner-edited state, then returns to Reviewer for formal K4 close.

Formal decision: `docs/REVIEWER_DECISION_K4_FINALIZE_ACCEPT_OWNER_UI_EDIT_WINDOW_OPEN.md`.


## K4 UI Snapshot Pack — PASS / Reusable Shell Spec

Reviewer accepted the read-only 10-page / 20-screenshot archive from commits `53160d147684d6ee7342c723a1272bc607450a22` and `4909653e5f580ff74bd44fa96c675cade2dd4a75`.

```text
SNAPSHOT_PACK=PASS
PAGE_COUNT=10
SCREENSHOT_COUNT=20
PAGE_OR_CONFIGURATION_CHANGES=0
CURRENT_GATE=K4_REUSABLE_STOREFRONT_SHELL_SPEC
```

Caveat: Checkout is the anonymous empty-cart baseline; Thank You currently shows the anonymous login gate. This does not block shell-design work because commerce/transaction page structure remains protected.

Owner's design objective is now explicit: future product-site re-skins should normally require only image replacement, text/content replacement, and global color/token replacement, without page-layout rebuilding or commerce-flow changes.

Executor is authorized to create documentation only: `docs/UI_DESIGN_SYSTEM.md` and `docs/STOREFRONT_RESKIN_MAP.md`, based on the snapshot pack and actual editable page structure. No live page mutation is authorized in this sub-gate.

Formal decision: `docs/REVIEWER_DECISION_K4_UI_SNAPSHOT_PACK_PASS_REUSABLE_SHELL_SPEC.md`.


## K4 Reusable Storefront Shell — SPEC PASS / Implementation Authorized

Reviewer has fixed the reusable storefront design specification.

Authoritative design documents:
- docs/UI_DESIGN_SYSTEM.md
- docs/STOREFRONT_RESKIN_MAP.md
- docs/REVIEWER_DECISION_K4_REUSABLE_SHELL_SPEC_PASS_IMPLEMENTATION.md

Current Gate:
K4_REUSABLE_STOREFRONT_SHELL_IMPLEMENTATION

Owner objective is fixed:
- future re-skins normally change images, text/product data, and global colors only;
- no normal-case layout rebuild;
- no WooCommerce flow rebuild;
- no payment logic rebuild.

Executor image generation is forbidden. Existing approved images / Media Library assets / replaceable neutral placeholders only.

Responsive and function protection outrank visual parity. Required widths remain:
320 / 375 / 390 / 430 / 768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560.

Primary layout adaptation scope:
Home / Product / FAQ / Shipping & Returns / Contact.

Shop / Cart / Checkout / Thank You / My Account remain structurally protected and may inherit only global brand tokens/typography unless separately authorized.

Next:
Executor implements the Reviewer-owned spec, verifies responsive/Gutenberg/WooCommerce/PayPal preservation, and stops at Reviewer.


## K4 Reusable Shell Implementation — ACCEPTED / Text-Only Content Fill

Reviewer accepted Executor commit `1e118131f9d3ec3995c35b09199f255eb27be2a2` as the structural reusable-shell baseline.

```text
K4_REUSABLE_STOREFRONT_SHELL_IMPLEMENTATION=PASS
RESPONSIVE_MATRIX=65_OF_65_PASS
GUTENBERG_INVALID_BLOCK_COUNT=0
IMAGE_GENERATION=NO
WOOCOMMERCE_BEHAVIOR=PASS
PPCP_CONFIGURATION_TOUCHED=NO
CURRENT_GATE=K4_CONTENT_FILL_REVIEWER_COPY
```

Authoritative copy is now Reviewer-owned in:
- `docs/K4_FINAL_COPY_SPEC.md`

This next pass is strictly text-only. Images, global colors, layout, section order, typography settings, responsive logic, CSS, and commerce/payment behavior are frozen.

Formal decision:
- `docs/REVIEWER_DECISION_K4_SHELL_PASS_CONTENT_FILL.md`

After Executor applies the copy, it must rerun responsive/Gutenberg/WooCommerce regression and STOP_AT_REVIEWER.


## K4 Content Fill — PASS / Owner Final UI Edit Window OPEN

Reviewer accepted Executor commit `98a7d3d4c8cd9851f4780a70c63c89ee3f57b092`.

```text
K4_CONTENT_FILL_REVIEWER_COPY=PASS
RESPONSIVE_MATRIX=65_OF_65_PASS
GUTENBERG_INVALID_BLOCK_COUNT=0
COMMERCE_SMOKE=PASS
IMAGE_MEDIA_LAYOUT_CHANGES=NO
CURRENT_CHECKPOINT=OWNER_K4_FINAL_UI_EDIT_WINDOW
```

Owner may now make final visual adjustments on Home / Product / FAQ / Shipping & Returns / Contact, normally limited to images, visible-text micro-edits, and global colors.

Owner should not rebuild layout, section order, responsive rules, Cart/Checkout/Account, WooCommerce payment/order logic, or PayPal.

When done, Owner returns:
`OWNER_K4_UI_EDIT_RESULT=COMPLETE`
plus changed pages/types.

Then Executor performs bounded delta verification only.

Formal decision:
`docs/REVIEWER_DECISION_K4_COPY_PASS_OWNER_FINAL_UI_WINDOW.md`


## K4 Local Artifact Hygiene — PASS

Reviewer accepted Executor commit `68e446115c623b93a87dc9492061b8b2e065396d`.

```text
CLEANED_COUNT=62
CLEANED_BYTES=1071221612
ARCHIVED=NONE
GPT6_HOME_PROTECTED=YES
UNRELATED_PROJECTS_TOUCHED=NO
HOME_HTTP=200
WORDPRESS=UP
MARIADB=HEALTHY
```

`.tmp-cdp-test2` remains unclassified and intentionally untouched.

## K4 Home Detail Polish — AUTHORIZED

Current GPT-6 Home is the visual baseline. Hero is locked for this pass.

Bounded work:
- add four replaceable product/content media slots to the current offer section;
- add restrained native burgundy line icons to steps/value/trust areas;
- make small spacing/border/surface consistency refinements only.

Executor image generation remains forbidden.

Formal decision:
`docs/REVIEWER_DECISION_K4_HOME_DETAIL_POLISH.md`

Parent checkpoint remains `OWNER_K4_FINAL_UI_EDIT_WINDOW`.


## K4 Home Detail Polish — TECHNICAL PASS / Owner Visual Review

Reviewer accepted Executor commit `e5416cf9c585b795f588a03f796342f1e3b36824` on technical evidence.

```text
HOME_HTTP=200
HERO_CHANGED=NO
OFFER_MEDIA_SLOTS=4
NATIVE_ICON_BLOCKS=7
GUTENBERG_INVALID_BLOCK_COUNT=0
RESPONSIVE_MATRIX=13_OF_13_PASS
HORIZONTAL_OVERFLOW=NO
MOBILE_NAV=PASS
COMMERCE_SMOKE=PASS_NO_ORDER
IMAGE_GENERATION=NO
WOOCOMMERCE_PAYPAL_ORDER_STATE=UNCHANGED
CURRENT_CHECKPOINT=OWNER_K4_HOME_VISUAL_REVIEW
```

Owner must visually inspect the current Home and return:
`OWNER_K4_HOME_VISUAL=PASS`
or a bounded RETURN issue.

Formal decision:
`docs/REVIEWER_DECISION_K4_HOME_DETAIL_POLISH_TECH_PASS.md`


## K4 Home Visual Review — Owner Feedback Recorded / Read-Only Capture

Owner visual feedback is now recorded:
- increase Hero visual weight;
- compress sections ②–⑥;
- align newly added icons;
- differentiate visually repetitive sections ② and ③;
- fix missing icon in section ⑧;
- generally reduce vertical looseness outside Hero and product display.

No implementation is authorized yet.

Current Gate:
`K4_HOME_VISUAL_REVIEW_CAPTURE`

Executor must only capture the current Home for Reviewer consolidation. No page/style/config mutation.

Formal decision:
`docs/REVIEWER_DECISION_K4_HOME_VISUAL_REVIEW_CAPTURE.md`


## K4 Home Visual Review Capture — PASS / Final Polish Authorized

Reviewer reviewed the current 1440 desktop and 390 mobile captures.

Consolidated visual findings:
- Hero should carry more visual weight without increasing dead space;
- sections ②/③/④/⑥ are too loose and should be compressed;
- native icon alignment needs normalization;
- sections ② and ③ need clearer visual differentiation;
- section ⑤ product-display should remain visually prominent;
- closing CTA may tighten slightly;
- Footer broken/missing brand visual must be repaired and public theme-credit clutter removed where native controls permit.

Current Gate:
`K4_HOME_FINAL_DENSITY_ALIGNMENT_POLISH`

Formal implementation spec:
`docs/REVIEWER_DECISION_K4_HOME_FINAL_DENSITY_ALIGNMENT_POLISH.md`

No image generation, no business-copy changes, no commerce/payment changes.


## K4 Home Final Density & Alignment Polish — TECHNICAL PASS / Final Visual Confirmation Pending

Reviewer accepted Executor commit `56f4932e21e2883ce2223e8547121d98c725205d` on technical evidence.

```text
HOME_HTTP=200
RESPONSIVE_MATRIX=13_OF_13_PASS
HORIZONTAL_OVERFLOW=NO
CONTENT_CLIPPING=NO
GUTENBERG_INVALID_BLOCK_COUNT=0
NATIVE_HOME_ICONS=7
FOOTER_BROKEN_IMAGE=0
FOOTER_CREDIT=REMOVED_NATIVE_SETTING
COMMERCE_SMOKE=PASS_NO_ORDER_OR_PAYMENT
WOOCOMMERCE_PAYPAL_ORDER_STATE=UNCHANGED
IMAGE_GENERATION=NO
CURRENT_CHECKPOINT=OWNER_K4_FINAL_VISUAL_CONFIRMATION
```

No further Home mutation is authorized until the final desktop/mobile screenshot pair is visually reviewed.

Formal decision:
`docs/REVIEWER_DECISION_K4_HOME_FINAL_POLISH_TECH_PASS_VISUAL_PENDING.md`


## K4 Home Final Density & Alignment Polish — TECHNICAL PASS

Reviewer accepted Executor commit `56f4932e21e2883ce2223e8547121d98c725205d` on technical evidence.

```text
HOME_HTTP=200
RESPONSIVE_MATRIX=13_OF_13_PASS
HORIZONTAL_OVERFLOW=NO
CONTENT_CLIPPING=NO
GUTENBERG_INVALID_BLOCK_COUNT=0
NATIVE_HOME_ICONS=7
FOOTER_BROKEN_IMAGE=0
FOOTER_CREDIT=REMOVED_NATIVE_SETTING
COMMERCE_SMOKE=PASS_NO_ORDER_OR_PAYMENT
WOOCOMMERCE_PAYPAL_ORDER_STATE=UNCHANGED
CURRENT_CHECKPOINT=OWNER_K4_FINAL_VISUAL_CONFIRMATION
```

Owner must visually inspect the current Home and return:
`OWNER_K4_FINAL_VISUAL=PASS`
or a bounded RETURN issue.

If PASS, perform one final bounded K4 delta verification before formal K4 close.

Formal decision:
`docs/REVIEWER_DECISION_K4_HOME_FINAL_POLISH_TECH_PASS.md`


## K4 Home Final Visual Review — RETURN: Remove Redundant Three-step Strip

Owner and Reviewer visually inspected the final desktop/mobile captures.

Decision:
- remove the standalone Three-step strip (Open the box / Make together / Keep the memory);
- keep the Three-value section (Less planning / Easy to begin / Something remains);
- do not relocate the removed process copy elsewhere on Home;
- only normalize the immediate Hero→Three-value spacing after deletion.

Current Gate:
`K4_HOME_SECTION_DEDUP`

This is the last authorized Home structure change before final visual confirmation.

Visual Evidence Protocol is now updated: GitHub screenshot archive remains mandatory, but final Visual PASS requires the Reviewer to actually see screenshot pixels in chat. If connector rendering is unavailable, Owner uploads the final desktop/mobile screenshots manually.

Formal decision:
`docs/REVIEWER_DECISION_K4_HOME_SECTION_DEDUP.md`


## K4 Owner Manual Home/Header Edits — Saved / Finalize Authorized

Owner has manually saved a new protected baseline:
- wide Hero background image with current light left→right overlay;
- current Hero copy/CTA placement;
- current Header/logo branding;
- four new product-display media assignments;
- current remaining Home structure/content.

Two final cleanup items remain:
1. remove redundant Three-step section;
2. remove/repair the invalid child blocks in the Three-value cards so Gutenberg invalid count returns to 0.

Current Gate:
`K4_OWNER_MANUAL_EDITS_FINALIZE`

Executor must protect the current Hero, Header/logo, and four product media assignments exactly as saved.

Formal decision:
`docs/REVIEWER_DECISION_K4_OWNER_MANUAL_EDITS_FINALIZE.md`


## K4 Owner Manual Baseline — Verification Only

Owner has manually deleted the Three-step section and additional Home content, and saved the page.

The CURRENT SAVED Home/Header state is now authoritative. Executor must not restore any deleted section.

The previous `K4_OWNER_MANUAL_EDITS_FINALIZE` instruction is superseded.

Current Gate:
`K4_OWNER_MANUAL_BASELINE_VERIFY`

Three-value invalid-block warnings are verification-only:
- do not delete/repair blocks proactively;
- if invalid count = 0, continue;
- if invalid count > 0, return to Reviewer without mutation.

Formal decision:
`docs/REVIEWER_DECISION_K4_OWNER_MANUAL_BASELINE_VERIFY.md`


## Visual Evidence Delivery — ZIP Standard

Owner requested a simpler visual-review handoff.

Effective immediately for screenshot/UI Gates:
- Executor still commits screenshot evidence to GitHub;
- Executor also packages the Gate's screenshots into one clean ZIP;
- ZIP contains only visual evidence plus a non-sensitive manifest;
- Executor returns the exact local ZIP path;
- Owner uploads that ZIP into the Reviewer chat;
- Reviewer gives Visual PASS only after inspecting the ZIP contents.

Current K4 Gate must return:
`VISUAL_REVIEW_PACKAGE=<absolute local zip path>`
`VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_ZIP_REQUIRED`
`OWNER_ACTION=UPLOAD_VISUAL_REVIEW_ZIP`

No per-image Owner transfer is required unless Reviewer specifically requests it.


## K4 Full Visual Audit + Product Gallery Repair — AUTHORIZED

Owner reported a Product gallery defect: the initial Product page may show a normal large main image, while later gallery interaction can collapse the active media into a small thumbnail-like state and leave a large blank area.

Previous verification-only scope is superseded.

Current Gate:
`K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR`

Scope:
- reproduce and minimally repair the Product gallery defect while preserving canonical WooCommerce gallery behavior;
- do not rebuild Product;
- protect the current Owner Home/Header baseline exactly;
- capture the full latest storefront visual set (desktop 1440 + mobile 390) for Home, Shop, Product, FAQ, Shipping & Returns, Contact, Cart, Checkout, safe existing Thank You if accessible, and Account;
- package all Gate screenshots into one ZIP for Owner upload to Reviewer.

Formal decision:
`docs/REVIEWER_DECISION_K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR.md`


## K4 Full Visual Audit — Product Gallery TECH PASS / Storefront Visual RETURN

Reviewer directly inspected the uploaded visual-review ZIP from Executor commit `7db4f27f647611d0a4702b2b95bc63617f1786cc`.

Accepted:
- canonical WooCommerce Product gallery repair;
- interaction/responsive evidence;
- Home/Header baseline preservation;
- Gutenberg invalid count 0;
- no order/payment mutation.

Visual RETURN issues:
1. English brand pages are mixed with Chinese WooCommerce frontend strings.
2. Legacy demo products (Remote Control / Universal Charger / USB-C Cable) remain visible in Shop and Product Related Products.
3. Contact form visibly lacks Name and Email input controls; only Message textarea renders.
4. FAQ Orders & Support needs native structured FAQ formatting.
5. Shipping & Returns repeats the same page heading inside the content card.

Current Gate:
`K4_STOREFRONT_CLEANUP_AFTER_VISUAL_AUDIT`

Formal decision:
`docs/REVIEWER_DECISION_K4_FULL_VISUAL_AUDIT_RETURN_STOREFRONT_CLEANUP.md`

Home current saved state and the Product gallery repair are protected.


## K4 Strict Storefront Cleanup — AUTHORIZED

The previous storefront-cleanup decision is superseded by a stricter visual remediation Gate based on direct review of the full audit ZIP.

Current Gate:
`K4_STRICT_STOREFRONT_CLEANUP`

Required before K4 Visual PASS:
- customer-facing WooCommerce strings English;
- inherited demo tech products removed from customer-visible Shop/Related Products without hard deletion;
- Mini Craft product category corrected from Accessories to a suitable craft category;
- Product mobile typography tightened while preserving canonical Woo structure;
- Contact native form visibly renders Name / Email / Message / Send message;
- customer-facing internal-governance copy removed from Contact and FAQ;
- FAQ Orders & Support matches native FAQ pattern;
- Shipping & Returns duplicate heading and mobile hierarchy cleaned up;
- Shop excess whitespace reduced and single-product result/sort controls handled natively where reasonable;
- populated Cart and populated Checkout desktop/mobile screenshots captured without order/payment;
- Account English;
- mobile Footer stacked cleanly.

Protected:
- current Home visual baseline;
- Product gallery fix and canonical gallery;
- payment/order state;
- business-policy facts.

Strategic product-model mismatch is recorded but NOT auto-resolved:
`PRODUCT_MODEL_STRATEGY_DECISION=PENDING_OWNER_REVIEW`

Formal decision:
`docs/REVIEWER_DECISION_K4_STRICT_STOREFRONT_CLEANUP.md`


## K4 Strict Cleanup RETURN — Native Block Recovery Authorized

Executor correctly stopped at the Gutenberg recovery boundary before any mutation.

Observed pre-existing invalid blocks:
- Contact page 10: 4 total = 1 Kadence Form + 3 core/column
- FAQ page 1121: 7 core/details
- Shipping & Returns page 9: 0

Current strict-cleanup Gate is PAUSED.

New bounded Gate:
`K4_NATIVE_BLOCK_RECOVERY_CONTACT_FAQ`

Recovery rules:
- no automatic Attempt Recovery;
- no whole-page reserialization;
- no hand-authored Kadence plugin markup;
- replace only invalid targets using registered native/core/Kadence blocks and current block serializers;
- preserve exact copy during this recovery Gate;
- preserve Home/Product Gallery/locale/products/PayPal/orders.

After recovery PASS, Reviewer will resume `K4_STRICT_STOREFRONT_CLEANUP`.

Formal decision:
`docs/REVIEWER_DECISION_K4_NATIVE_BLOCK_RECOVERY_CONTACT_FAQ.md`


## K4 Native Block Recovery — Editor Session Unavailable / Artifact Path Authorized

Executor returned `RETURN_REVIEWER_K4_GUTENBERG_EDITOR_SESSION_UNAVAILABLE` with zero mutation. This is a tooling/session limitation, not a new storefront regression.

Do not retry the same unreliable Gutenberg GUI automation path.

New bounded Gate:
`K4_ARTIFACT_BACKED_BLOCK_RECOVERY`

Strategy:
- discover retained K4 rollback/page snapshots read-only;
- restore the Contact Kadence Form only from an exact known-good serialized form artifact;
- rebuild only invalid core/column and core/details blocks using WordPress core parse/serialize functions;
- preserve current copy and every non-target block;
- if no exact Kadence recovery source exists, stop with zero mutation.

Known evidence includes a K4 content-fill state with invalid count 0 and Contact form render PASS. The retained copy-preflight artifact path is `.artifacts/k4-copy-preflight-20260922-144817/pages.json`, but usability must be proven before recovery.

Formal decision:
`docs/REVIEWER_DECISION_K4_ARTIFACT_BACKED_BLOCK_RECOVERY.md`


## K4 Artifact-Backed Block Recovery — ACCEPTED

Executor commit `e1a64a1e5092142b1391961c28ce4ddd0c428f6d` is accepted for the bounded recovery scope.

Reviewer inspected the recovery ZIP directly:
- Contact desktop/mobile: Name, Email, Message and Send message are visibly restored.
- FAQ desktop/mobile: seven native details items render again.

`GUTENBERG_EDITOR_VISUAL_VALIDATION=PENDING_SESSION` remains a deferred editor-session check; do not force a risky GUI recovery solely to clear this marker.

Formal acceptance:
`docs/REVIEWER_DECISION_K4_ARTIFACT_BACKED_BLOCK_RECOVERY_ACCEPT.md`

## K4 Workspace Hygiene V2 — AUTHORIZED

Before resuming strict storefront cleanup, clean the shared root conservatively.

Current Gate:
`K4_WORKSPACE_HYGIENE_V2`

The goal is classification + safe cleanup + a permanent anti-regression rule. The active runtime `mini-craft-k3r4-mariadb-recovery` is protected and must not be renamed/moved/deleted.

Formal decision:
`docs/REVIEWER_DECISION_K4_WORKSPACE_HYGIENE_V2.md`

After Hygiene V2 PASS, Reviewer may resume `K4_STRICT_STOREFRONT_CLEANUP`.


## K4 Workspace Hygiene V2 — FORMAL PASS

Executor commit `d0b821c91f433ce6cf8e3c534fa6a87d91c43b90` is accepted.

PASS means:
- root inventory/classification completed conservatively;
- no active/rollback/source/runtime item was deleted;
- one durable visual ZIP was moved into the verified project-artifacts archive;
- no new root transients were created;
- future Mini Craft Gates must use the seven-field workspace cleanup contract.

Known root items remain intentionally unresolved:
- `.tmp-cdp-test2` — active Edge references;
- `.tmp-k4-detail-browser-desktop`
- `.tmp-k4-detail-browser-mobile` — ownership not proven.

These do not block K4 continuation, but they are not considered safely deletable yet.

## K4 Strict Storefront Cleanup — RESUMED

Current Gate:
`K4_STRICT_STOREFRONT_CLEANUP_RESUME`

Contact/FAQ repaired block structures are now protected baselines. The strict customer-facing cleanup may continue.

Formal decision:
`docs/REVIEWER_DECISION_K4_STRICT_STOREFRONT_CLEANUP_RESUME.md`


## K4 Strict Storefront Cleanup Resume — TECHNICAL PASS / VISUAL RETURN

Executor commit `152f48aa269e8bd93d5215299ee68c2977a10f1e` is accepted for the intended cleanup implementation and evidence production.

Reviewer directly inspected the uploaded 22-image visual-review ZIP.

Accepted:
- English customer UI;
- demo-product removal;
- Craft Kits category;
- Contact recovery/copy cleanup;
- FAQ native Orders & Support structure;
- Shipping hierarchy;
- Shop controls;
- mobile Footer;
- Home/Gallery protection;
- workspace cleanup contract.

Remaining K4 blockers observed in pixels:
- mobile Cart coupon/update area collision and weak product/shipping hierarchy;
- Checkout defaults/offers shipping in Japan/Tokyo despite approved US-only initial market;
- mobile Checkout field columns are visually broken/staggered;
- final actionable Checkout control is not visibly demonstrated in the capture;
- legacy global mobile typography still leaves Product/Shipping/Contact/FAQ body copy too small/narrow.

Current Gate:
`K4_FINAL_MOBILE_COMMERCE_VISUAL_POLISH`

Formal decision:
`docs/REVIEWER_DECISION_K4_FINAL_MOBILE_COMMERCE_VISUAL_POLISH.md`

Do not enter K5 or Growth/SEO until this Gate returns to Reviewer.


## K4 Final Mobile Commerce Visual Polish — VISUAL/FUNCTIONAL ACCEPTED

Reviewer directly inspected the uploaded visual ZIP from commit `7b5ca9cd80b99e02db4fd982ea2182ad7f18746e`.

Accepted:
- US-only storefront market alignment;
- mobile Cart/Checkout layout;
- visible native final checkout action (not clicked);
- mobile typography cleanup;
- Home and Product Gallery protection;
- no order/payment/live action.

The return reason is workspace-only: completed Gate browser profiles/debug captures were not removed due an execution-policy boundary, and several returned Windows paths were malformed in presentation.

Formal decision:
`docs/REVIEWER_DECISION_K4_VISUAL_ACCEPT_WORKSPACE_RETURN.md`

## Project Directory Consolidation — AUTHORIZED

Current Gate:
`PROJECT_DIRECTORY_CONSOLIDATION`

Goal: create one understandable Mini Craft local workspace, explicitly clean disposable current-Gate artifacts, consolidate/move local runtime/rollback/artifact directories where safe, and use pointers where Git/Docker path constraints make a physical move unsafe.

Target:
`C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\`

Formal decision:
`docs/REVIEWER_DECISION_PROJECT_DIRECTORY_CONSOLIDATION.md`

Do not start Growth/SEO or K5 until Reviewer accepts this consolidation.


## Project Directory Consolidation — STRUCTURAL PASS / OWNER CLEANUP

Executor commit `a33b3bd9ce7b96fffa91a4ffad0d891e28c2342a` is accepted for structural consolidation.

Accepted:
- canonical workspace created;
- local README + repo/runtime/rollback pointers created;
- K4 visual ZIP / manifest / rollback SQL relocated and verified;
- Git and active runtime left in place where path dependencies make physical move unsafe;
- site/runtime/business state unchanged.

The only open item is local deletion blocked by Executor policy. Do not repeat another Codex deletion Gate.

Owner manual cleanup is authorized for:
- shared-root `.tmp-k4-detail-browser-desktop`
- shared-root `.tmp-k4-detail-browser-mobile`
- completed Gate's four browser profiles, two debug screenshots, and empty helpers directory under active-runtime `.artifacts\k4-final-mobile-commerce-visual-polish\`

Do not delete `.tmp-cdp-test2` while Edge references remain.

Formal decision:
`docs/REVIEWER_DECISION_PROJECT_DIRECTORY_CONSOLIDATION_OWNER_CLEANUP.md`


## Owner manual cleanup accepted

Owner manually removed the two shared-root K4 browser-temp folders and elected not to delete the contained Gate-local profile/debug residue. This is accepted as non-blocking because remaining residue is contained inside project artifacts rather than the shared root.

## K4.5 Growth / SEO Readiness Audit — AUTHORIZED

Current Gate:
`K4_5_GROWTH_SEO_READINESS_AUDIT`

This is read-only. It audits technical SEO, structured data, Search/Merchant readiness, keyword/intent architecture, Core Web Vitals, analytics/instrumentation, UTM, purchase truth, privacy/consent, lifecycle email, CRO/trust, and Owner checkpoints.

Growth framework comes from the Mini Craft Growth Playbook and Cross-Border Growth / Acquisition / Conversion playbook. Do not implement analytics/SEO changes in this Gate.

Formal decision:
`docs/REVIEWER_DECISION_K4_5_GROWTH_SEO_READINESS_AUDIT.md`


## K4.5 Growth / SEO Readiness Audit — FORMAL PASS

Executor commit `f69ea6e3f2ee58c5bcb55d0c5dc33981a6f8b7a4` is accepted.

Accepted readiness counts: P0=5, P1=7, P2=5, Defer=4. Dominant constraint is production origin/product truth/measurement/legal-delivery readiness, not SEO content volume.

Formal decision:
`docs/REVIEWER_DECISION_K4_5_GROWTH_SEO_READINESS_AUDIT_PASS.md`

## K4.6 Growth Foundation Spec — AUTHORIZED

Current Gate:
`K4_6_GROWTH_FOUNDATION_SPEC`

Create only a lightweight 05_growth operating specification: Growth System, Unit Economics template, Event Taxonomy, UTM Standard, and evidence-backed CRO Backlog. No site/account/analytics/SEO implementation yet.

Formal decision:
`docs/REVIEWER_DECISION_K4_6_GROWTH_FOUNDATION_SPEC.md`


## K4.6 Growth Foundation Spec — FORMAL PASS

Executor commit `58dd18534b74919e5396b1e6d2eaa880da24544f` is accepted. The five lightweight Growth Foundation documents are now the durable pre-traffic operating spec.

Formal decision:
`docs/REVIEWER_DECISION_K4_6_GROWTH_FOUNDATION_SPEC_PASS.md`

## K4.7 Owner Launch Truth Checkpoint — OPEN

Before P0 implementation, collect only five Owner decisions: PRODUCT_TRUTH launch model, PUBLIC_ORIGIN domain family, initial MEASUREMENT provider, LEGAL_CONSENT path, and DELIVERY_AND_EMAIL provider/mailbox convention.

Reviewer defaults: SINGLE_PLANNED_DATE_NIGHT_KIT; GA4_FIRST; Resend-or-equivalent transactional provider. Owner may override.

Formal checkpoint:
`docs/REVIEWER_DECISION_K4_7_OWNER_LAUNCH_TRUTH_CHECKPOINT.md`


## K4.7 Owner Launch Truth Checkpoint — RESOLVED

Owner decisions:
- PRODUCT_MODEL=`MULTI_CATEGORY_MINI_CRAFT_BRAND`
- PUBLIC_ORIGIN=`https://minicraft.spikersun.com`
- ANALYTICS_PROVIDER=`GA4_FIRST`
- LEGAL_CONSENT_PATH=`DRAFT_FIRST_FOR_OWNER_LEGAL_REVIEW`
- EMAIL_PROVIDER=`RESEND`
- SUPPORT_ADDRESS=`support@minicraft.spikersun.com`
- inbound initial path: Cloudflare Email Routing or equivalent forwarding

Multi-category means future architecture may grow into real categories/collections/products/use-cases, but no empty category or fake product breadth is authorized. Current Night Kit remains the first actual offer.

Formal decision:
`docs/REVIEWER_DECISION_K4_7_OWNER_LAUNCH_TRUTH_RESOLVED.md`

Remaining immediate launch dependency is detailed PRODUCT_TRUTH for the first real product: contents/claims, production price/currency, SKU, stock model, identifiers/brand applicability, and approved production media.


## K4.8 First SKU Product Truth Discovery — AUTHORIZED

Current Gate:
`K4_8_FIRST_SKU_PRODUCT_TRUTH_DISCOVERY`

Owner selected multi-category Mini Craft as the long-term brand model. The next P0 blocker is not analytics or SEO implementation; it is selecting a concrete first launch SKU/source with verified supplier, cost, MOQ, shipping, contents, identifiers, image-rights and risk facts.

This Gate is research-only. No purchase, supplier contact, site mutation, analytics, SEO or Merchant implementation is authorized.

Formal decision:
`docs/REVIEWER_DECISION_K4_8_FIRST_SKU_PRODUCT_TRUTH_DISCOVERY.md`


## K4.8 First SKU Product Truth Discovery — FORMAL PASS

Executor commit `aa92b28544267896645bd783b2b89a3546de30e2` is accepted as a research-only shortlist. No candidate is production-approved.

Best-supported public records: A ORFON ND766 and C Yuhan MWK-001. B Hongda M2411 is a secondary candidate with higher cost/compliance/fragility risk. D remains low-evidence.

Formal decision:
`docs/REVIEWER_DECISION_K4_8_FIRST_SKU_PRODUCT_TRUTH_DISCOVERY_PASS.md`

## K4.9 Supplier Contact — OWNER CHECKPOINT

Supplier contact is an external action and requires explicit Owner authorization. Recommended first contact: A and C; optional B.

Formal checkpoint:
`docs/REVIEWER_DECISION_K4_9_SUPPLIER_CONTACT_OWNER_CHECKPOINT.md`


## Owner launch direction — supplier work deferred

Owner clarified that supplier selection, sourcing, pricing optimization and profit validation belong to later operations. The current project objective is to launch a technically complete, Owner-operable WooCommerce storefront.

`K4_9_SUPPLIER_CONTACT_OWNER_CHECKPOINT` is deferred to operations and no longer blocks launch.

Current Gate:
`K5_RELEASE_CANDIDATE_QA`

K5 validates the platform/admin/storefront/deployment package. Current JPY 1 / stock 8 / MCK-LOCAL-TEST-001 may remain only as local QA data and must not become publicly sellable production truth.

Formal decision:
`docs/REVIEWER_DECISION_SUPPLIER_DEFERRED_K5_RC_QA.md`


## K5 RC QA — RETURN accepted

Executor commit `11115a72e18213f49cca49e928a9a40ea7e793b4` correctly stopped after finding legacy demo tech products in the fresh Product Related Products section. This conflicts with accepted K4 storefront truth, which required demo products hidden from Shop and Related Products.

Current Gate:
`K5R1_RELATED_PRODUCTS_BASELINE_REPAIR`

Scope is narrow: identify whether the cause is product-status drift, stale WooCommerce cache/transients, or inherited static/manual Product related output, then repair only that cause. Demo products must not be deleted. K5 resumes after Reviewer acceptance.

Formal decision:
`docs/REVIEWER_DECISION_K5R1_RELATED_PRODUCTS_BASELINE_REPAIR.md`


## K5R1 Related Products Baseline Repair — FORMAL PASS

Executor commit `61ec3c81a4eb48faa513fd9bb511bfabe98302c4` is accepted. Root cause was stale WooCommerce transient `wc_related_223`; legacy products remained draft. Only that transient was cleared, fresh anonymous Product/Shop no longer expose demo products, and Product Gallery remains intact.

Canonical rollback path includes `\\.artifacts\\` under the active runtime; any earlier `recovery.artifacts` string is a reporting typo.

Formal decision:
`docs/REVIEWER_DECISION_K5R1_RELATED_PRODUCTS_BASELINE_REPAIR_PASS.md`

## K5 Release Candidate QA Resume — AUTHORIZED

Current Gate:
`K5_RELEASE_CANDIDATE_QA_RESUME`

Resume only unfinished K5 checks: Owner-operable admin CRUD/media capability, responsive/storefront regression smoke, cart/checkout, PayPal Sandbox read-only state, language/US market, Gutenberg/application health, and local-only deployment package/backups. Do not replay K4 and do not deploy VPS yet.

Formal decision:
`docs/REVIEWER_DECISION_K5_RELEASE_CANDIDATE_QA_RESUME.md`


## K5 Resume — RETURN accepted / narrow reconciliation

Executor commit `2f8e33022ea8e82b310b3bac44846dc5dce6de5a` completed most remaining K5 evidence: admin CRUD/media, Orders admin, runtime health, Gallery, Contact, backups, and deployment manifest. The valid stop is the missing populated-Checkout final action.

A second deployment-prep issue is now explicit: local container image tag `wordpress:6.8.2-php8.3-apache` differs from actual persistent WordPress core `7.1.1`; production image must be reconciled before deploy.

Current Gate:
`K5R2_CHECKOUT_ACTION_VERSION_RECONCILIATION`

This Gate only isolates native WooCommerce final-action vs PPCP-localhost rendering and resolves the production WordPress image tag. Existing K5 QA/backups are not replayed.

Formal decision:
`docs/REVIEWER_DECISION_K5R2_CHECKOUT_ACTION_VERSION_RECONCILIATION.md`


## K5 Release Candidate — FORMAL PASS

K5 is formally accepted. The latest K5R2 stop was caused by browser automation being unable to establish a reliable fresh anonymous URL/session; no checkout regression was demonstrated.

Accepted basis:
- K4 proved native WooCommerce Place order rendering with the local test gateway;
- K5 current cart/checkout smoke is healthy and PayPal Sandbox is visible/connected;
- K3 proved Sandbox payment/capture/webhook end-to-end;
- no checkout/payment config mutation occurred after K4.

Production WordPress target is resolved to `wordpress:7.1.1-php8.3-apache`; public HTTPS PayPal button rendering remains a Production Canary check, not a deployment blocker.

`BLOCKS_DEPLOYMENT=NONE`

Formal decision:
`docs/REVIEWER_DECISION_K5_RELEASE_CANDIDATE_PASS.md`

## K6 VPS Production Deployment — OWNER CHECKPOINT

Next step is bounded Sandbox-first deployment to `minicraft.spikersun.com` on the shared VPS. Because this writes to an external server/reverse proxy, explicit Owner authorization is required.

Formal checkpoint:
`docs/REVIEWER_DECISION_K6_VPS_PRODUCTION_DEPLOYMENT_OWNER_CHECKPOINT.md`


## K6 VPS Production Deployment — AUTHORIZED

Owner explicitly authorized the VPS deployment phase on 2026-09-23.

Current Gate:
`K6_VPS_PRODUCTION_DEPLOYMENT`

Mode: Sandbox-first public canary on `https://minicraft.spikersun.com`.

Before any write, Executor must re-read and re-prove current Shared VPS truth. Existing shared 80/443/reverse-proxy/cloudflared/app topology must be preserved; Mini Craft is a project-isolated Compose stack only. Production WordPress image is pinned to `wordpress:7.1.1-php8.3-apache`. PayPal remains Sandbox; real payments/Live/Soft Launch are not authorized.

Formal decision:
`docs/REVIEWER_DECISION_K6_VPS_PRODUCTION_DEPLOYMENT.md`


## Local document consolidation — AUTHORIZED / K6 paused

Owner requested local-document cleanup before VPS deployment. `K6_VPS_PRODUCTION_DEPLOYMENT` is paused before execution.

Current Gate:
`LOCAL_DOCUMENT_CONSOLIDATION_CLEANUP`

Goal: consolidate Mini Craft-owned local documentation under `mini-craft-night-kit-workspace\\docs\\{current,deployment,archive}` and delete only proven duplicate/superseded/temporary project-owned documents. Active runtime, Git repo, K5 deployment package/backups, secrets, Docker volumes and unrelated projects are protected.

Formal decision:
`docs/REVIEWER_DECISION_LOCAL_DOCUMENT_CONSOLIDATION_CLEANUP.md`


## Local document consolidation — FORMAL PASS

Executor commit `fd06aa204575d03fb14d692345a337af165a446e` is accepted. Nine historical local Mini Craft documents were moved into the canonical workspace archive; no deletion was performed because no candidate met the proof threshold for safe deletion. Active runtime, Git worktree, K5 package/backups and unrelated projects remained unchanged.

The retained `.tmp-*`/diagnostic residues are intentionally uncertain-retain and do not block deployment.

Formal decision:
`docs/REVIEWER_DECISION_LOCAL_DOCUMENT_CONSOLIDATION_CLEANUP_PASS.md`

## K6 resumed

The temporary cleanup pause is lifted. The Owner's earlier explicit authorization for `K6_VPS_PRODUCTION_DEPLOYMENT` remains valid; no second authorization is required. Resume from K6 Phase A read-only Shared VPS preflight before any mutation.


## K6 Phase A — SSH transport RETURN accepted

Executor commit `82962230c984767a65bbd675df2c2b9698cb5496` correctly stopped. TCP reached the approved SSH endpoint, but the remote side closed during key exchange before presenting a host key. Therefore host-key drift and Shared VPS drift are not proven; remote baseline is simply unavailable.

Current Gate:
`K6R1_SSH_TRANSPORT_DIAGNOSIS`

The next Gate performs at most three bounded strict SSH/client-isolation attempts. It never weakens host-key checking or changes credentials. If SSH recovers and the recorded host key matches, it completes the original Phase A read-only inventory and stops. If the server repeatedly closes before presenting a host key, the next action becomes a minimal Hostinger-console status check by Owner, not blind SSH retries.

Formal decision:
`docs/REVIEWER_DECISION_K6R1_SSH_TRANSPORT_DIAGNOSIS.md`


## K6R1 — Governance-aligned SSH recovery

Canonical `entropy-student/spike.skill/vps-project-governance` and the current Shared VPS handoff were re-read. The prior K6R1 transport-diagnosis scope is superseded because the shared-host SSH transport contract is already validated and must be reused, not redesigned.

The current pre-host-key close is classified as `RETURN_SSH_CONNECTION_REQUIRED`, not proven host-key or Shared VPS drift. A real host-key mismatch remains `RETURN_SSH_TRUST_DRIFT` only if the remote actually presents a mismatching key.

Current Gate:
`K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY`

Use exactly one canonical strict read-only probe. If the same pre-host-key close repeats, stop at a minimal Hostinger console status checkpoint; do not loop through alternate clients/accounts/keys or weaken host-key verification. If SSH recovers, perform only the bounded dynamic Shared VPS continuity probe and stop before deployment.

Deployment correction after this Gate: reuse existing Docker/Compose + Shared Caddy + `/srv` contract; prefer public WordPress app membership on the existing `spikersun-edge` after current-topology confirmation; keep MariaDB project-local; do not invent a second ingress stack. A canonical `PROJECT_STORAGE_MANIFEST.md` is mandatory before K6 project writes.

Formal decision:
`docs/REVIEWER_DECISION_K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY.md`
