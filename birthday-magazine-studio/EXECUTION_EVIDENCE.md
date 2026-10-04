# Execution Evidence — Birthday Magazine Studio

## Current Gate — G3CR6R1 Frontend Composition Redesign — 2026-10-02

`PASS_CANDIDATE_G3CR6R1_FRONTEND_COMPOSITION_REDESIGN`

Existing PR #64 / `codex/birthday-magazine-g3c-blocksy-wedding-productization`; fresh pre-run HEAD `9f90c1e53058567010fcbd9f505ac99ceaacc6f9`. PR is open and unmerged. Canonical latest Reviewer/return/execution/Owner packets were read in full; scoped rollback was created before changes at `poc/g3c/artifacts/backups/g3cr6r1`, without overwriting G3CR6.

Current rendering is eight Gutenberg chapters, not the historical six-section g3cr4 skeleton: wide gift-editorial Hero; concise value strip; unequal staggered Spread/Cover samples; full-width photo-local Preview; 12-page visual Included story; vertical journey; centered gift offer; separate open FAQ. Footer is editable wp_block1143 with supported Blocksy copyright/placement hooks and no vendor attribution. Product/Cart/Checkout/Account remain native Woo with gift-led presentation; no protected business handler is changed.

Fresh desktop/375 tests pass Preview select/replace/remove/invalid MIME/corrupt image, decoded blob images and old URL revocation. Interaction network capture: model calls0, server photo uploads0, external image POST0. Native Add to Cart, quantity2 / USD79.98, removal, Checkout form load without submit and My Account login form load pass. Order count1→1. Product1113 remains virtual/USD39.99; active plugins/theme unchanged. All10 route/viewport checks have document width equal viewport, no broken images and no blocking horizontal overflow. Mobile viewport375.

Fresh protected source hashes for Compose/commerce workspace/Mailpit/Woo match preflight. Private workspace handler: Owner200/unrelated403/guest403; anonymous HTTP403. In-memory identity tests do not claim authenticated HTTP login. Owner Administrator/edit Home/media/theme-options capabilities and core Gutenberg render roundtrip pass; eight core Groups support section reorder. Gutenberg editor-save behavior was not claimed. Global design tokens use the editable Blocksy palette; supported inline dynamic CSS fixes stale demo-cache colors. No theme/builder switch.

Current full results and evidence boundaries:

- [Execution report](docs/G3CR6R1_EXECUTION_REPORT.md)
- [Preflight and rollback hashes](poc/g3c/artifacts/reports/g3cr6r1-preflight.json)
- [Browser request/geometry/screenshot evidence](poc/g3c/artifacts/reports/g3cr6r1-browser.json)
- [Final machine report](poc/g3c/artifacts/reports/g3cr6r1-final.json)
- [21 final screenshots](poc/g3c/artifacts/screenshots/g3cr6r1/)

Existing gift-hero, sample-spread and sample-cover adopted; new generated assets0. Legacy model/job option counters are absent: zero-provider conclusion is based on implementation/request capture, not default option values. No customer/credential/production backup data was added. Pre-existing G3CR4 screenshot deletions and unrelated untracked ZIP/screenshots remain unstaged.

```text
PR_MERGE=0
THEME_CHANGE=0
BUILDER_CHANGE=0
ELEMENTOR_INSTALL=0
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
CHECKOUT_SUBMISSIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PAID_PURCHASES=0
GLOBAL_DOCKER_PRUNE=0
G4_ACTIONS=0
OWNER_VISUAL_FREEZE=PENDING
STOP_AT_REVIEWER=YES
```

---

## Historical evidence — G3BR1 Sandbox reconciliation, entitlement, and refund — Phase A-D + Phase E cleanup closure

**Historical result:** `PASS_CANDIDATE_G3BR1_CLEANUP_CLOSURE`
**Phase status:** Payment/refund/entitlement was accepted by Reviewer; cleanup-only closure passed. This run performed no payment, provider, order, Docker-start, tunnel-start, or model actions.
**Execution branch:** `codex/birthday-magazine-g3br1-sandbox-reconciliation-entitlement`
**Phase A-D base:** latest GitHub `main` at `290a73131a4d0ace487d2c1986a94145f03ee277`
**Phase E latest main:** `8a4e02e60188bb004fb8a212b45b2aa5d57aab42`, merged into this branch by `4ab613db5fe0c3421faa8daeffb921695a14a327`.
**Previous G3B PR:** #51 was already merged as historical interim RETURN evidence; this Gate uses a new branch and PR.
**GitHub submission:** [PR #54](https://github.com/entropy-student/project/pull/54), open to `main`, not merged. Initial evidence commit: `a557801f0fc2bc7237d215bb4e9420a3d165961e`.
**Refund:** Exactly one full USD 39.99 Sandbox refund was invoked for order #30 through WooCommerce native refund and official PPCP; provider and Woo records correlate.
**Stop point:** `STOP_AT_REVIEWER=YES`; no retry or further refund was attempted.

This G3BR1 continuation used only existing synthetic WooCommerce order #30. No second Sandbox payment/capture/refund, Live payment, real-money payment, or product model call was made. Mini Craft resources were not accessed or changed.

At initial PR submission, GitHub `main` had advanced from `290a731` to `bb90fa0` through Mini Craft-only commits; the branch was then based on `290a731`. The latest Phase E sync is recorded above. The intervening `main` updates contain no Birthday Magazine changes.

## Phase A — fresh runtime and local order read-back

- Fresh Compose read-back found all four `birthday-magazine-g3b` project containers running; MariaDB and Mailpit were healthy. The only project volumes were `birthday-magazine-g3b_database` and `birthday-magazine-g3b_wordpress`; network was `birthday-magazine-g3b_private`.
- Runtime versions: Docker Engine 29.7.2, WordPress 7.1.1, PHP 8.3.33, WooCommerce 11.1.2, official WooCommerce PayPal Payments 4.1.3, MariaDB 11.4.7, and Mailpit 1.31.2. PPCP source/package/hash are recorded in the accepted G3B `poc/g3b/artifacts/ppcp-install.json` (SHA-256 `179e6fa9ede40fb2b05a3ac06c08a47710536e554c171db6e4d1b777d94abb97`).
- The temporary HTTPS origin returned HTTP 200; local HTTP on port 8137 redirects to HTTPS (301). One `cloudflared` process was present. `PAYPAL_LIVE_ENABLED=no`; PPCP connection state was Sandbox connected, not Production.
- Order #30 exists, Woo status `processing`, `paid=true`, total USD 39.99, method `ppcp-gateway`, PPCP mode `sandbox`, and refund count 0. Before Phase C, canonical generation jobs, generation scheduler actions/cron, G3A job counter, and model-call counter were all 0.
- Durable Phase A read-back: [poc/g3br1/artifacts/phase-a-runtime-readback.json](poc/g3br1/artifacts/phase-a-runtime-readback.json).

## Phase B — read-only provider reconciliation

`PROVIDER_QUERY_SEMANTICS=READ_ONLY_VERIFIED` was established before querying. The official PPCP `OrderEndpoint::order()` path is GET-only; capture is a separate POST method and was not called. The event detail endpoint was queried using GET for the exact event ID already stored by PPCP; `/resend` was not used. The two explicit provider read operations were GETs. PPCP may reuse its cached bearer or perform its normal authentication-only `/v1/oauth2/token` POST if the cache is expired; this cannot create/authorize a payment/order, capture, cancel, refund, or change WooCommerce payment state. Webhook verification was enabled, the stored event was not a configured simulation event, and no active `http_request_args` / `pre_http_request` override was present. Source hashes and the sanitized pre-query semantics record are in [poc/g3br1/artifacts/read-only-query-semantics.json](poc/g3br1/artifacts/read-only-query-semantics.json). The helper emitted no raw provider body, credentials, token, cookie, or unredacted provider identifiers.

The provider returned one completed order with one purchase unit and exactly one `COMPLETED` capture. A local transaction-ID read-back found exactly one Woo order candidate, #30. Woo order #30's provider-order metadata hash matched the provider order ID hash (`ab113fb4abe10a9970a51daf45612cb65399f36e8d01676b72af8b61d752558d`); the one capture ID hash (`cac2a5b8a6b86df1e6e086815dcb0d5ea73f52249da10050ad443afc0da3b3f9`) matched Woo's transaction ID hash. Provider order, capture, and Woo total were each USD 39.99. `DUPLICATE_CAPTURE=NO`; `REFUND_ALREADY_EXISTS=NO`. The local candidate count is saved in [poc/g3br1/artifacts/woo-transaction-candidate-readback.json](poc/g3br1/artifacts/woo-transaction-candidate-readback.json).

The exact PPCP-stored event ID hash (`c07c00099b4f95784c2706837a00523415fbe91f0e710ab103d458978e2c6611`) matched the provider's event detail. Its event type was `CHECKOUT.ORDER.APPROVED`, resource type `checkout-order`, and resource ID hash matched the same provider order ID. The event itself had no Woo order-matching custom ID, and it was not a `PAYMENT.CAPTURE.COMPLETED` webhook; the exact callback-to-order link is the matching provider order resource ID, then the current provider order's single capture-to-Woo transaction match. `CALLBACK_WEBHOOK_CORRELATION=PASS` on that basis; no claim is made that a capture-completed webhook was stored.

PPCP's retained debug log did not contain event-ID/handler-success lines within the receipt window, so the log does not independently prove handler response success. The sanitized scan result is [poc/g3br1/artifacts/webhook-log-scan.json](poc/g3br1/artifacts/webhook-log-scan.json); no raw log line or event ID was printed or retained.

Sanitized provider facts: [poc/g3br1/artifacts/payment-reconciliation.json](poc/g3br1/artifacts/payment-reconciliation.json). The exact hashed payment-evidence input consumed by Phase C is preserved at [poc/g3br1/artifacts/payment-reconciliation-phase-c-input.json](poc/g3br1/artifacts/payment-reconciliation-phase-c-input.json); its SHA-256 matches the value stored on order #30 and reported in the Phase C artifact.

## Phase C — paid, intake incomplete

Only order #30 received the synthetic G3BR1 correlation and intake metadata. Intake was read back as `incomplete`; paid entitlement evaluated ineligible. Canonical generation-ready jobs=0, deferred generation Action Scheduler actions=0, generation cron events=0, model calls=0, and refunds=0. See [poc/g3br1/artifacts/phase-c-intake-incomplete.json](poc/g3br1/artifacts/phase-c-intake-incomplete.json).

## Phase D — intake complete and idempotency

Order #30's synthetic intake was marked `complete`. The CLI-only local adapter persisted one canonical `generation-ready-deferred` ledger record in WordPress option `bms_g3br1_canonical_generation_jobs`, uniquely keyed by `order-30`; its job ID and payment reference identifiers are stored as hashes. Five local evaluations ran: initial completion, workspace-refresh reason, order-revisit reason, explicit re-evaluation, and duplicate local event replay. The first created the record; the other four found the same record. The reason labels exercise the common local evaluator; they are not browser page-navigation evidence.

The adapter did not queue an Action Scheduler or cron dispatch because the existing G3A generation feature remains disabled. Deferred generation action count=0 (within the contract maximum of 1), canonical job count remained 1, model/provider invocation=0, refunds=0. This proves local entitlement-record idempotency only; it does not prove production dispatch or model-spend behavior. See [poc/g3br1/artifacts/phase-d-entitlement-idempotency.json](poc/g3br1/artifacts/phase-d-entitlement-idempotency.json), scripts under `poc/g3br1/scripts/`, and [poc/g3br1/artifacts/final-local-readback.json](poc/g3br1/artifacts/final-local-readback.json).

## Phase A-D checkpoint (historical)

At the end of Phase A-D, the Owner refund checkpoint was reached and no refund had been executed. That historical checkpoint was superseded by the Owner's explicit Phase E authorization recorded on latest `main`.

## Phase E — one authorized full Sandbox refund and revocation

Fresh preflight confirmed Sandbox=YES, Live=NO, order #30 existed and remained correlated to the single completed USD 39.99 capture, refund count=0, canonical job count=1 in `generation-ready-deferred`, and model calls=0. The existing G3B runtime was healthy. The temporary HTTPS tunnel had expired; its local-only Cloudflare process was stopped after the native WooCommerce refund flow was prepared. WordPress `home` and `siteurl` were restored to `http://127.0.0.1:8137` and local HTTP returned 200.

The one refund call used `wc_create_refund(refund_payment=true)` on order #30, which invokes the official active PPCP gateway's native refund handler. It returned a WooCommerce refund object for USD 39.99. No direct PayPal REST refund call was used. The one-shot helper wrote an invocation marker before calling the gateway and disallows retries. No refund call was made after this invocation.

Read-only official PPCP order GET then found exactly one completed USD 39.99 provider refund and one capture now in `REFUNDED` state. The provider refund ID hash matched the PPCP-stored Woo refund correlation; Woo held exactly one USD 39.99 refund record with `refundedPaymentFlag=true`. `DUPLICATE_REFUND=NO`; refund amount/currency and provider/Woo correlation passed. See [phase-e-provider-refund-readback.json](poc/g3br1/artifacts/phase-e-provider-refund-readback.json) and [phase-e-local-refund-readback.json](poc/g3br1/artifacts/phase-e-local-refund-readback.json).

The prepared local handler preserved the canonical audit record, changed job state to `cancelled`, set entitlement to `revoked`, and left deferred generation actions=0, cron=0, model provider invoked=false, and model calls=0. Final local read-back passed; see [phase-e-entitlement-revocation.json](poc/g3br1/artifacts/phase-e-entitlement-revocation.json) and [phase-e-final-local-readback.json](poc/g3br1/artifacts/phase-e-final-local-readback.json). Execution scripts and helper hashes are retained under `poc/g3br1/scripts/` and `poc/g3br1/artifacts/`.

At the initial Phase E handoff, cleanup had restored the local WordPress URL, stopped the tunnel, and removed all four `birthday-magazine-g3b` containers, both project volumes, and the project network using only project-scoped Compose `down --volumes --remove-orphans`. Unrelated Docker inventory fingerprints matched before/after and Mini Craft counts were 8/9/4. PowerShell deletion of the ignored `poc/g3b/.tmp/` was blocked, leaving 1,075 files (12,890,802 bytes) at that point; the temporary files were not committed. That intermediate cleanup status is superseded by the cleanup-only closure below. Historical details remain in [phase-e-cleanup-before.json](poc/g3br1/artifacts/phase-e-cleanup-before.json), [phase-e-cleanup-after.json](poc/g3br1/artifacts/phase-e-cleanup-after.json), [phase-e-cleanup-readback.json](poc/g3br1/artifacts/phase-e-cleanup-readback.json), [phase-e-temp-cleanup.json](poc/g3br1/artifacts/phase-e-temp-cleanup.json), and [phase-e-tunnel-cleanup.json](poc/g3br1/artifacts/phase-e-tunnel-cleanup.json).

No second payment/capture/refund, Live PayPal, real money, model/provider call, secret disclosure, or Mini Craft resource change occurred. At the end of the Phase E handoff the result was RETURN; the following cleanup-only closure supersedes that cleanup status. Do not rerun or retry the refund.

## Cleanup-only closure

Preflight resolved Git root and the exact target `birthday-magazine-studio/poc/g3b/.tmp/`, confirmed it was inside the repo, confirmed no path component was a symlink/junction/reparse point, and confirmed `git check-ignore` returned ignored. The only deletion was that exact directory, performed with Python `shutil.rmtree` after the same guards were repeated in the Python process. No wildcard or parent-directory deletion was used.

Read-back: `TMP_DIRECTORY_EXISTS=NO`; `TMP_FILE_COUNT=0`; `PROJECT_G3B_CONTAINERS=0`; `PROJECT_G3B_VOLUMES=0`; `PROJECT_G3B_NETWORKS=0`; `PROJECT_TUNNEL_COUNT=0`; Mini Craft counts remain 8/9/4 and its inventory is included in unchanged unrelated-resource fingerprints; unrelated container/volume/network fingerprints match the pre-Phase-E snapshot. No stopped resource was started. `PAYPAL_ACTIONS_THIS_RUN=0`; `MODEL_CALL_COUNT=0`. Full path-guard and read-back record: [cleanup-closure-readback.json](poc/g3br1/artifacts/cleanup-closure-readback.json).
---

## Historical G3B evidence — updated Owner payment return

**Latest result:** `RETURN_OWNER_SANDBOX_PAYMENT_STATE_REVIEW_REQUIRED`
**Latest read-back:** 2026-09-27 UTC
**Execution branch:** codex/birthday-magazine-g3b-paypal-sandbox-entitlement
**Base:** latest GitHub `main` at `452348ccf5691507c8b9b08481695662b3241bc9`
**Stop point:** `STOP_AT_OWNER_CHECKPOINT=YES`; no entitlement or refund phase started.

This continuation supersedes the earlier Seller-auth checkpoint below. The Owner reports completing login and payment with a PayPal Sandbox personal test account. The PPCP admin surface displayed “Connected to PayPal” and “Business | Sandbox”; the PPCP system-status report showed Onboarded, Webhook status, and Webhook delivery host as healthy. `PAYPAL_LIVE_ENABLED=no` remained set. No Client ID, Secret, token, cookie, authorization header, Buyer credentials, or provider payload was read or recorded.

The checkout used the native WooCommerce USD 39.99 virtual Birthday Magazine product (ID 15). The Sandbox Web SDK v6 core/payment-method resources loaded and the visible `paypal-button` custom element mounted. The checkout button interaction progressed through PPCP's secure-browser handoff. A later safe WooCommerce read-back showed synthetic order #30 at `processing`, `paid=true`, USD 39.99, payment method `ppcp-gateway`; the Owner separately confirmed the Sandbox Buyer login/payment. No provider transaction/capture identifier or raw callback payload was inspected, so provider capture count/correlation is **not independently verified**. The WooCommerce status report's webhook receipt and delivery-host flags were both `yes`; the configured WordPress origin remained HTTPS. The event type and body were not read.

This is not a G3B PASS candidate. The paid-state observation is recorded, but paid-entitlement evaluation, deferred generation-ready job creation/idempotency, and refund were not run. The generation feature flag remains disabled; the dedicated generation-job post count and Action Scheduler generation-action count both read zero. Product model calls remain zero. No agent Buyer login/approval or explicit capture/refund command was performed. No further PayPal interaction was attempted after the paid-order read-back.

Sanitized machine-readable evidence: [poc/g3b/artifacts/post-owner-sandbox-payment.json](poc/g3b/artifacts/post-owner-sandbox-payment.json). The earlier Seller-checkpoint evidence and screenshots remain below as history; its “not connected / unpaid” statements describe that earlier timestamp only.

No new durable screenshot of the PayPal handoff/approval surface was committed. Existing synthetic checkout screenshots remain the pre-submission visual baseline; the continuation evidence is the sanitized PPCP status/DOM summary and WooCommerce order read-back. No PayPal account page, approval URL, or tokenized query string was saved.

---

## Initial Seller checkpoint — historical, superseded by the continuation above

**Historical result:** RETURN_OWNER_PAYPAL_SANDBOX_MERCHANT_AUTH_REQUIRED
**Historical base:** bd8764de926329680d71443ae7b15061954b98ab

The statements in this historical section describe the state before the Owner completed Sandbox Seller connection and Buyer payment.

### Initial Seller-checkpoint detail

**Gate:** G3B_PAYPAL_SANDBOX_PAID_ENTITLEMENT_REFUND
**Historical result:** RETURN_OWNER_PAYPAL_SANDBOX_MERCHANT_AUTH_REQUIRED
**Execution branch:** codex/birthday-magazine-g3b-paypal-sandbox-entitlement
**Base:** latest fetched GitHub main, bd8764de926329680d71443ae7b15061954b98ab
**Stop point:** STOP_AT_OWNER_CHECKPOINT=YES. The Seller login, OAuth consent, and Sandbox merchant authorization belong to the Owner.

This is a readiness return, not a completed G3B payment or entitlement proof. Work stopped at the PPCP Seller-authorization control, before any PayPal account login, connection, capture, refund, paid order state, entitlement, or generation-ready job.

## Completed before the Owner checkpoint

| Area | Result | Evidence |
|---|---|---|
| Latest project baseline | PASS | Branch is based on main at bd8764de. The required Birthday Magazine G3B and product-contract files are unchanged from the previously read c450624 base. The intervening main commits touched Mini Craft files only; no Mini Craft runtime or files were modified by this execution. |
| Project-isolated runtime | PASS | Docker Compose project birthday-magazine-g3b, with four project containers, two project volumes, and one project network. WordPress 7.1.1 / PHP 8.3.33, WooCommerce 11.1.2, MariaDB 11.4.7, Mailpit 1.31.2. WordPress and Mailpit bind to loopback ports 8137 and 8138. MariaDB and SMTP have no host port. See poc/g3b/artifacts/runtime-setup.json and ppcp-install.json. |
| Mini Craft isolation readback | PASS | Before/after inventory count evidence has Mini Craft at 8 containers, 9 volumes, and 4 networks. No Mini Craft container, volume, database, PayPal configuration, or credential was used or modified. |
| WooCommerce baseline | PASS | G3A-derived pre-install smoke and full post-PPCP regression passed. Synthetic Birthday Magazine product ID 15 is a simple virtual USD 39.99 product. Synthetic order remains on-hold and unpaid. Buyer A owner access passed; unrelated buyer and guest workspace access were denied. Generation job and model-call counters remained zero. See journey-report.json and post-ppcp-runtime-regression.json. |
| Official PayPal Payments plugin | PASS | Exactly one PayPal plugin is installed and active: WooCommerce PayPal Payments 4.1.3, downloaded from the official WordPress.org plugin ZIP. The package was 3,309,347 bytes; SHA-256 179e6fa9ede40fb2b05a3ac06c08a47710536e554c171db6e4d1b777d94abb97. Plugin header license is GPL-2.0 and readme says GPLv2. This is the free official package; no paid product, add-on, or license was bought. See ppcp-install.json. |
| Sandbox and Live guard | PASS for readiness only | PPCP Sandbox Mode is selected. Merchant is not connected, no Client ID or Client Secret is present, and the runtime PAYPAL_LIVE_ENABLED value is no. The WooCommerce settings page has no fatal error and displays Activate PayPal Payments. That button is the Owner-only Seller authorization boundary; it was not clicked. See ppcp-settings-health.json, ppcp-settings-public-health.json, and the direct-settings screenshots. |
| Temporary HTTPS origin | PASS for readiness only | A Cloudflare Quick Tunnel exposes only the synthetic local G3B site at https://tutorials-queries-refined-grad.trycloudflare.com. WordPress home and site URL were rebound to this temporary HTTPS origin. No Cloudflare account, production domain, VPS, or Shared Infra setting was changed. The tunnel is active at handoff so the Owner can reach the Seller checkpoint. |
| Public origin commerce path | PASS, no submission | HTTPS Good Issue preview, 375px preview, WooCommerce product, cart, and checkout rendered. Preview had no horizontal overflow at 375px. The public cart accepted the synthetic virtual item; the WooCommerce session cookie was Secure and HttpOnly. Checkout was opened but never submitted. See public-origin-health.json and screenshots prefixed public-. |
| Public origin PPCP settings | PASS for readiness only | A short-lived synthetic inspector administrator logged in over HTTPS; its WordPress auth cookie was Secure/HttpOnly. The account was deleted and read-back found zero matching accounts. The PPCP panel rendered, Sandbox was selected, and Activate PayPal Payments remained visible. No connection control was activated. See ppcp-settings-public-health.json and ppcp-settings-direct-public.png. |
| Plugin network observation | Recorded | During the direct settings-page load, observed GET resources included Google Fonts CSS, PayPal static scripts from www.paypalobjects.com, a t.paypal.com tracking pixel, and two www.sandbox.paypal.com merchantboarding script requests that returned 302. Only host/path/method/status and query parameter names are recorded; query values, cookies, and credentials are not retained. No Seller OAuth, client-token, capture, or webhook action was performed. |

## Remaining G3B proof — not run

The Owner checkpoint was reached before Seller authorization. Therefore no Sandbox merchant connection, checkout button/client-token validation, webhook delivery, Sandbox buyer login or approval, capture, paid WooCommerce state, paid entitlement evaluation, canonical deferred generation-ready job, duplicate entitlement evaluation, or WooCommerce-initiated refund was run. There is no paid order, no entitlement, and no deferred generation action to revoke. The currently observed synthetic order is still unpaid/on-hold. G3B is not PASS_CANDIDATE.

Counters at the checkpoint: generation jobs=0; model calls=0; real payment/capture/refund=0; PayPal Live=disabled; merchant connected=no. No AI, LLM, vision, image API, API key, real customer data, production email, production domain, or real payment was used.

## Owner checkpoint and local runtime state

The Owner must perform any Sandbox Seller login, OAuth consent, or merchant account authorization directly in the WooCommerce admin. Do not send a password, Client ID, Client Secret, token, cookie, or OAuth code to chat or commit it to GitHub. The admin URL is the temporary origin above followed by /wp-admin/. If the synthetic local WordPress admin password is unavailable, reset it locally with the G3B-scoped WP-CLI; do not persist the new password in repository files. After Seller authorization, stop and request Reviewer/Owner direction before any Buyer approval or payment attempt.

The project Compose stack and Quick Tunnel remain active for this checkpoint; this is intentional and not a cleanup PASS. Downloaded PPCP ZIP and extracted plugin package remain only under the project-scoped poc/g3b/.tmp directory and are excluded from Git. No global Docker prune was used. Project-scoped full teardown is deferred until Owner/Reviewer no longer need the runtime.

### Persistent G3B screenshots

- poc/g3b/artifacts/screenshots/good-issue-preview-desktop.png
- poc/g3b/artifacts/screenshots/good-issue-preview-375.png
- poc/g3b/artifacts/screenshots/woocommerce-product.png
- poc/g3b/artifacts/screenshots/checkout-ready.png
- poc/g3b/artifacts/screenshots/order-confirmation.png
- poc/g3b/artifacts/screenshots/woocommerce-admin-order.png
- poc/g3b/artifacts/screenshots/public-good-issue-preview-desktop.png
- poc/g3b/artifacts/screenshots/public-good-issue-preview-375.png
- poc/g3b/artifacts/screenshots/public-woocommerce-product.png
- poc/g3b/artifacts/screenshots/public-woocommerce-cart.png
- poc/g3b/artifacts/screenshots/public-woocommerce-checkout.png
- poc/g3b/artifacts/ppcp-settings-direct.png
- poc/g3b/artifacts/ppcp-settings-direct-public.png

All screenshots use synthetic data. Authentication values, password/reset links, Client ID/Secret, bearer tokens, cookies, order keys, and OAuth codes are not included.

## GitHub submission

The branch is based on latest main bd8764de926329680d71443ae7b15061954b98ab. G3B evidence commit 790bd614b07189c63c1e79055aab8a98129db64e is on codex/birthday-magazine-g3b-paypal-sandbox-entitlement. Reviewer PR #51 (https://github.com/entropy-student/project/pull/51) targets main and remains open/unmerged. This Evidence/Handoff reconciliation is being pushed as a follow-up commit on the same PR.

---

## Current Gate — G3A WordPress / WooCommerce commerce and account loop

- **Gate:** G3A_WORDPRESS_WOOCOMMERCE_COMMERCE_LOOP
- **Execution date:** 2026-09-27
- **Branch:** codex/birthday-magazine-g3a-woocommerce-commerce-account-loop
- **Base:** latest fetched GitHub main at 52ae9f2c1b810d8d61b6b64a42c115b95b93832c
- **Result:** PASS_CANDIDATE_G3A_WORDPRESS_WOOCOMMERCE_COMMERCE_LOOP; Reviewer decision required; not a formal PASS.
- **Stop point:** STOP_AT_REVIEWER=YES; G3B_STARTED=NO.

STATUS CHECKLIST

DOCKER_WORDPRESS_RUNTIME=PASS
MARIADB_RUNTIME=PASS
MAILPIT_LOCAL_CAPTURE=PASS
WOOCOMMERCE_PRODUCT_USD_39_99=PASS
PRODUCT_VIRTUAL=PASS
PREVIEW_TO_NATIVE_COMMERCE_PATH=PASS
ADD_TO_CART=PASS
CART_UPDATE_REMOVE=PASS
CHECKOUT_VALIDATION=PASS
CHECKOUT_SUBMISSION=PASS
LOCAL_OFFLINE_ORDER_CREATED=PASS
ORDER_PAID_STATE=NO
ORDER_STATUS_ON_HOLD_OR_EQUIVALENT=PASS
CHECKOUT_ACCOUNT_CREATE_OR_ATTACH=PASS
ACCOUNT_EMAIL_LOCAL_CAPTURE=PASS
OWNER_ORDER_VISIBILITY=PASS
UNRELATED_ACCOUNT_ORDER_DENIAL=PASS
ORDER_BOUND_WORKSPACE=PASS
WORKSPACE_DIRECT_URL_REPLAY_BY_OTHER_USER=DENIED
GUEST_PRIVATE_WORKSPACE=DENIED
UNPAID_GENERATION_GATE_CLOSED=PASS
GENERATION_JOB_COUNT=0
MODEL_CALL_COUNT=0
PAYPAL_PLUGIN_INSTALLED=NO
PAYPAL_CONNECTED=NO
REAL_PAYMENT=NO
G3B_STARTED=NO
TARGET_HOST_WRITE=NO
CLEANUP_READBACK=PASS
STOP_AT_REVIEWER=YES

### Isolated runtime and components

The proof used the project-scoped Compose project birthday-magazine-g3a:

- Docker client/server 29.7.2; Compose 5.4.0.
- WordPress 7.1.1, PHP 8.3.33; WP-CLI 2.12.0.
- WooCommerce 11.1.2, installed from the official WordPress ZIP (GPL-3.0-or-later, SHA-256 9de9350a1cf5671b9960afb3151f40f7980e223217a441bf2ea5921b5fce8e9e). The 18,005,609-byte ZIP and its container copy were removed after install.
- MariaDB 11.4.7-MariaDB-ubu2404 (community server, GPL-2.0).
- Mailpit v1.31.2 (MIT).
- WordPress and WP-CLI images are official open-source images; immutable image IDs/digests and source/license notes are in poc/g3a/artifacts/runtime-setup.json.

The Good Issue-style G2A1 preview (0.1.0, GPL-2.0-or-later) was mounted read-only. New local-only code is limited to the order-bound workspace placeholder plugin and Mailpit MU plugin (each 0.1.0, GPL-2.0-or-later). WooCommerce core, WordPress, MariaDB and Mailpit were free/open-source components; no paid plugin or service was used.

The site and Mailpit UI were bound only to 127.0.0.1:8127 and 127.0.0.1:8128. MariaDB 3306 and SMTP 1025 were private to birthday-magazine-g3a_private and not published to the host. WordPress preview/product and Mailpit message API returned HTTP 200 at pre-cleanup health read-back. Mailpit readyz exited 0. No browser request reached an external host in the final run.

### Commerce journey

Product ID 14, “Birthday Magazine — G3A Synthetic Proof”, was a simple USD 39.99 product, Virtual, not Downloadable, with stock management off, tax status none for this local proof, and needs_shipping=false. Its product page showed $39.99 and the native WooCommerce Add to cart control.

The existing preview CTA led to the published WooCommerce product permalink. The Good Issue-style preview passed desktop and 375px width checks; the 375px document width was exactly 375px. Cart checks passed at quantity 1 ($39.99), quantity 2 ($79.98), and remove-to-empty. Empty checkout submission produced the WooCommerce validation notice and did not add an order.

Only WooCommerce core Check payments was enabled, titled “Local test only — no payment”. The synthetic checkout created Order 21, total USD 39.99, using cheque; it remains on-hold and is_paid=false. No manual paid-state mutation occurred. The final verification reused this one stored browser-submitted order to avoid creating duplicates; confirmation refresh was also checked.

### Accounts, email and workspace authorization

Guest checkout was disabled. Checkout account creation was enabled, separate My Account registration was disabled, and WooCommerce created/bound Buyer A’s synthetic customer account during checkout. Buyer B was a separate synthetic customer. All test emails use birthday.invalid.

Mailpit captured the account setup email locally (and the final test inbox contains only synthetic local messages). The account message body/reset token was not read or written to GitHub. No real SMTP provider or external email was configured.

The small workspace placeholder binds the order ID and authenticated customer ID in order metadata. Buyer A saw the order in My Account and received HTTP 200 for their workspace. Buyer B’s order list omitted it; WooCommerce core showed “Invalid order.” at HTTP 200 on a direct order-details URL, with no tested Buyer A email/address/product title/total markers. Buyer B’s direct workspace request and a guest direct workspace request both returned HTTP 403. The URL is not a bearer credential.

No photo storage, final PDF delivery, payment entitlement, or generation implementation was added.

### Generation and payment boundary

BMS_G3A_LOCAL_ONLY=true and BMS_G3A_GENERATION_ENABLED=false were explicitly verified in the final runtime. The generation counter, matching Action Scheduler actions, WP-Cron generation events, and model-call counter were all zero at 12 checkpoints, including invalid checkout, unpaid order, confirmation refresh, account creation, Buyer A account/order/workspace open-refresh-revisit, Buyer B denial, guest denial, and final read-back.

The only enabled gateway was cheque; no PayPal/PPCP plugin file was installed, woocommerce_ppcp_settings was absent, and no connected PayPal account/provider or real payment was used. No model provider was installed or invoked. G3B was not started.

### Corrections made before final evidence

The final pre-cleanup audit found that the existing disposable WordPress volume had been initialized before its Compose extra constants were applied. A guest HTTP 403 from that state was a WordPress error page and was not accepted as authorization evidence. The local config was corrected, and configure-g3a.cjs now writes both local-only constants before enabling the plugin.

The same audit found WooCommerce still in Coming soon / store pages only mode, so the public product route showed a placeholder. The configure script now sets both visibility options to no; the final browser run confirmed the real product price and Add to cart control. One intermediate run also observed a default Gravatar request; local avatars were disabled and the final browser report records an empty external-host list. The full browser suite was rerun after these corrections and all checks passed.

### Durable artifacts and cleanup

poc/g3a/artifacts/journey-report.json contains all 17 final checks and 12 zero-count generation snapshots. final-state.json is the sanitized product/order/gateway/flag read-back. runtime-health.json records versions, health, network exposure and local HTTP checks. host-inventory-before-cleanup.json and host-inventory-readback.json record the scoped inventory and cleanup comparison. evidence-manifest.json lists file hashes, sizes and screenshot dimensions.

Synthetic screenshots are under poc/g3a/artifacts/screenshots/: Good Issue desktop/375px, WooCommerce product, cart states, checkout validation/ready/confirmation, Mailpit inbox, Buyer A orders/order details/workspace, Buyer B orders/order denial/workspace denial, guest denial, and WooCommerce admin order.

Cleanup executed only:

    docker compose -p birthday-magazine-g3a -f birthday-magazine-studio/poc/g3a/compose.yaml down --volumes --remove-orphans

Read-back found 0 G3A containers, 0 G3A volumes and 0 G3A networks; the .tmp directory and WooCommerce ZIP were absent. The 40 unrelated container identities, 87 unrelated volume names and 21 unrelated network identities had identical before/after SHA-256 fingerprints. Mini Craft counts remained 8 containers, 9 volumes and 4 networks; those objects are included in the unchanged global fingerprints. No global prune command was used. Docker image cache was left intact.

No Secret, password, cookie, order key, reset token, or real customer information is in the committed evidence. MVP_PRODUCT_CONTRACT.md and Reviewer-owned REVIEWER_HANDOFF.md were not changed. The disposable runtime and its synthetic customer/order database were removed after evidence capture.

### GitHub review handoff

- **Execution base:** 52ae9f2c1b810d8d61b6b64a42c115b95b93832c. The branch was advanced to this fetched main before commit; it contains only Mini Craft updates relative to the initial 688afdf4 execution base.
- **Current PR base:** main at 782ea659040b60bda5f05a841c11b9c793d73c1a. The four intervening main commits touched only Mini Craft files; Birthday Magazine Reviewer/G3A contract files did not change. GitHub reports this PR mergeable.
- **Initial evidence commit:** fbd92b493ab98b2533ccf137206e54b2bbf926d3. This file records the PR in a follow-up commit on the same branch.
- **Reviewer PR:** [#49 — G3A: prove local WooCommerce commerce and account loop](https://github.com/entropy-student/project/pull/49), open and unmerged.

Do not merge; Reviewer is the next decision point.

# Birthday Magazine Studio — Execution Evidence

## Current Gate — G2BR3 Direct Codex Agent Real AI Proof

- **Gate:** `G2BR3_DIRECT_CODEX_AGENT_REAL_AI_PROOF`
- **Execution date:** 2026-09-27
- **Branch:** `codex/birthday-magazine-g2br3-direct-agent-proof`
- **Base:** latest GitHub `main` at `491a7eab7721bd9876e1ebc1292cfc382949c061`
- **Result:** `PASS_CANDIDATE_G2BR3_DIRECT_AGENT_REAL_AI_PROOF`; Reviewer decision required; this is not a formal PASS.
- **Stop point:** `STOP_AT_REVIEWER=YES`; `G3_STARTED=NO`.

### Direct model generation and provenance

The current interactive Codex Agent authored `poc/g2b/artifacts/g2br3/generated-content.json` directly from the synthetic intake and the existing `CONTENT_SCHEMA`. There was exactly one primary generation and zero correction generations. The first JSON Schema validation passed with zero errors, so the authorized correction was not used. The historical `reference-content.json` was not opened/read, copied, adapted, or used as fallback. The strict content JSON contains no provenance-only extra fields; `model-execution-status.json` and `generation-provenance.json` record the required flags and bind provenance to the content SHA-256.

```text
MODEL_AUTHORED_BY_INTERACTIVE_CODEX_AGENT=YES
REFERENCE_FIXTURE_FALLBACK=NO
REAL_MODEL_RUN_COUNT=1
SUCCESSFUL_GENERATION_COUNT=1
CORRECTION_GENERATION_COUNT=0
API_KEY_USED=NO
NESTED_CODEX_EXEC_USED=NO
G3_STARTED=NO
```

The current authenticated ChatGPT interactive session authored the content. The project did not invoke a model-provider API or nested Codex process. Production provider integration remains deferred for a later Owner decision.

### Validation, grounding and modules

- `synthetic-intake.json` snapshots the accepted G2B fictional Mira Vale fixture: six completed narrative answers, 16 deterministic synthetic illustration files, and three must-use IDs (`photo-01`, `photo-02`, `photo-04`). The product contract was not changed.
- `content-schema.json` is exported from the existing `src/provider.mjs` `CONTENT_SCHEMA`. `structured-schema-report.json` records `PASS`, 0 errors, and the SHA-256 of the generated content.
- `grounding-report.json` records 12 grounded fact claims, 17 exact intake excerpts, resolving source references, and the birthday/age check. Every content unit carries sourceRefs; the executor reviewed the synthetic prose against those cited answers.
- Exactly two distinct supported modules passed: The Lore / inside jokes (Q2/Q4) and Current Obsessions (Q5).
- `photoMapping=PASS_METADATA_ONLY`: 12 unique images were selected from 16 using the accepted deterministic synthetic metadata ranking. All three must-use photos are assigned. This is not a visual-semantic photo understanding claim.

### Renderer, PDF and deterministic QA

The existing page architecture and renderer produced `proof-magazine-soft-warm.pdf`: 12 US Letter pages (612 × 792 points each), 379,787 bytes, SHA-256 `a3ed604ae21119d9a073474463dd11d898329b826ce3ed9215a6f59e972f044a`. `pdf-lib` opened the PDF and read 12 pages. Browser read-back found all required page sections, consistent recipient fields, every image loaded, no measured text overflow, and no page overflow. The 375px viewport has no horizontal or text overflow. All 15 existing negative QA mutations were rejected.

Bold Editorial, Soft / Warm, and Retro / Playful retain the same page-architecture hash `fb70862addef3f032be9319d345a98f638bd057c415f24c3c12bd4a21a309ea8`. The browser renderer made 93 loopback requests and 0 external browser requests. Screenshots and a 12-page contact sheet are committed under `poc/g2b/artifacts/g2br3/screenshots/`.

`idempotency-report.json` is explicitly `NOT_TESTED_DIRECT_AGENT_NO_PROVIDER_BOUNDARY`: this proof did not create a provider job or test production provider spend idempotency. No idempotency PASS is claimed for G2BR3.

### Durable artifacts and runtime

The `poc/g2b/artifacts/g2br3/` directory contains the generated content, synthetic intake snapshot, schema snapshot, schema/grounding/QA reports, provenance/status, idempotency limitation, PDF, screenshots, style proof, dependency report, run summary, and SHA-256 manifest. Dependencies/runtime: Node.js 24.19.0; Playwright 1.62.1 (Apache-2.0); pdf-lib 1.17.1 (MIT); Chrome 153.0.8010.54.

No API key, additional credits, real customer data, payment, PayPal, production provider, public deployment, VPS, Cloudflare/Shared Infra change, or G3 work occurred. `MVP_PRODUCT_CONTRACT.md` and Reviewer-owned `REVIEWER_HANDOFF.md` are unchanged. The only shared-pipeline code change adds G2BR3 provenance labeling so the accepted validator/renderer can classify direct interactive Agent output accurately; schema, renderer layout and page architecture were not changed.

### GitHub review handoff

- Branch: `codex/birthday-magazine-g2br3-direct-agent-proof`, from `491a7eab7721bd9876e1ebc1292cfc382949c061`.
- Evidence commit: `0b5c3ef4ff2e6581efc021fa2c62700d1f44af2b`.
- Reviewer PR: [#46 — G2BR3 direct interactive Codex Agent real AI proof](https://github.com/entropy-student/project/pull/46), open against `main`, unmerged. The final Evidence/Handoff reconciliation is pushed as a follow-up commit on this PR.
- GitHub `main` advanced from the execution base `491a7eab7721bd9876e1ebc1292cfc382949c061` to `da09dd1b0e83e614c18980ca043ffab359cd963a` while this run was in progress; the intervening commits concern unrelated mini-craft documentation. PR #46 targets `main`.
- Reviewer is the next decision point. This execution does not make the formal Gate decision or start G3.



## Current Gate — G2BR2 final host result

- **Gate:** `G2BR2_HOST_CODEX_TRANSPORT_AND_REAL_AI_CLOSURE`
- **Date:** 2026-09-27
- **Branch:** `codex/birthday-magazine-g2br2-host-codex-closure`
- **Base:** GitHub `main` at `d3249013f01fdc60b2fc728d0a8f197255643182`.
- **Result:** `RETURN_CODEX_CHATGPT_LOGIN_REQUIRED`; this is not PASS or PASS_CANDIDATE.
- **Stop point:** `STOP_AT_REVIEWER=YES`; G3 not started.

### Bounded real-model attempts

| Attempt | Transport/provider | Result | Safe diagnostic |
|---|---|---|---|
| 1 | Default Codex provider | `RETURN_CODEX_EXEC_FAILED` | `WEBSOCKET_FAILURE`; retry category `TRANSIENT_RUNTIME` |
| 2 | `g2br2_chatgpt_http`, HTTP-only Responses | `RETURN_CODEX_CHATGPT_LOGIN_REQUIRED` | `AUTHENTICATION`, HTTP 401; retry category `null` |

```text
Host codex login status immediately before attempt 2: Logged in using ChatGPT
Codex CLI: 0.149.1
Authorized/consumed model runs: 2 / 2
Successful structured responses: 0
schemaConstrained: true
apiKeyUsed: false
retryCategory after attempt 2: null
```

The preflight result records the host CLI login state. The HTTP-only custom provider request still received HTTP 401; this evidence does not establish successful authentication with that provider. Both actual model-run slots are consumed. No third run or additional retry is authorized or performed.

### AI pipeline result

```text
grounding: NOT RUN (no structured model output)
actual-AI PDF: NOT RUN
deterministic AI QA: NOT RUN
G3: NO
```

No G2BR2 generated-content JSON or actual-AI PDF exists. `poc/g2b/fixtures/reference-content.json` remains only the historical, human-authored G2B renderer fixture and was not used or represented as AI output. The final G2BR2 result is a RETURN because the model output needed for grounding, rendering and QA was not produced.

### Transport repair and scope

- Attempt 2 used the per-invocation custom provider `g2br2_chatgpt_http` with `requires_openai_auth=true`, `supports_websockets=false`, `wire_api="responses"`, and the ChatGPT Codex backend. Its scope was `PER_INVOCATION_CODEX_EXEC_OVERRIDES`.
- The G2BR2 retry reused the accepted G2B/G2BR1 fixture, `CONTENT_SCHEMA`, prompt builder, canonical-job helper, grounding checks, deterministic renderer, PDF path and QA. No product contract, schema, renderer or page architecture was changed.
- No API key or additional credits were used or purchased. No global `~/.codex/config.toml` or project config was changed. G2BR1 history and artifacts remain unchanged.

### Durable sanitized evidence

The final `poc/g2b/artifacts/g2br2/model-execution-status.json` and canonical record under `poc/g2b/artifacts/g2br2/jobs/` retain both attempt outcomes, the two-run count and the HTTP 401 category/status. The synthetic prompt and schema remain alongside them. No token, session/account identifier, cookie, auth header, raw URL credential or raw provider log is recorded.

### GitHub review handoff

- Branch: `codex/birthday-magazine-g2br2-host-codex-closure`, based on `d3249013f01fdc60b2fc728d0a8f197255643182`.
- Final evidence commit: see the current branch head.
- Existing Reviewer PR: [#43 — Prepare G2BR2 host Codex launch path](https://github.com/entropy-student/project/pull/43), open against `main`, unmerged; updated with the final sanitized attempt evidence and this handoff.
- Reviewer is the next decision point. Do not retry, use an API key, or enter G3.

No payment, PayPal, customer data, public deployment, VPS, Cloudflare/Shared Infra change or G3 action occurred. `MVP_PRODUCT_CONTRACT.md` and Reviewer-owned `REVIEWER_HANDOFF.md` are unchanged. `namespace.json` retains the initial preparation snapshot and is not the final run-count evidence.

## Current Gate — G2BR1 Real AI Generation Closure

- **Gate:** G2BR1_REAL_AI_GENERATION_CLOSURE
- **Execution date:** 2026-09-27
- **Branch:** codex/birthday-magazine-g2br1-real-ai-closure
- **Base:** GitHub main at c22f1478973bcee11097c2473ee726925613fc81
- **Result:** RETURN_CODEX_EXEC_FAILED
**Stop point:** STOP_AT_REVIEWER=YES; G3 not started.

### Result separation

| Boundary | Result | Evidence |
|---|---|---|
| Existing G2B intake, photos, schema and renderer | **REUSED** | No fixture or renderer rebuild; accepted baseline remains under poc/g2b/fixtures/ and poc/g2b/src/proof.mjs. |
| ChatGPT login preflight | **PASS** | Both local Codex CLI installations reported ChatGPT login. A first wrapper preflight issue (login text was on stderr) was corrected before any model process started. |
| Codex execution | **RETURN_CODEX_EXEC_FAILED** | Three codex exec child processes started, each exited with code 1; the 3-attempt cap is exhausted. |
| Structured AI output | **NOT PRODUCED** | Successful structured responses = 0; no generated-content.json was created. |
| Grounding and dynamic modules | **NOT RUN** | No successful AI JSON existed to audit. |
| Actual AI PDF and deterministic QA | **NOT RUN** | No G2BR1 PDF or G2BR1 screenshots were produced. The prior G2B reference PDF is not AI output and is not counted here. |
| Duplicate-generation guard | **PASS — failed-job duplicate path only** | A later invocation was rejected before a fourth codex exec; the canonical record remained at 3 invocations and 0 successful generations. This does not pass the overall G2BR1 Gate. |

### Codex attempt record

- Authentication mode was the local ChatGPT login; OPENAI_API_KEY was absent, no API key or account/session identifier was written, and no extra credits were purchased or reset.
- Attempt 1 used Codex CLI 0.155.0-alpha.16.3; it exited nonzero. The initial wrapper did not retain diagnostic output.
- Attempt 2 used Codex CLI 0.155.0-alpha.16.3; it exited 1. The sanitized diagnostic classifier recorded NETWORK_OR_TRANSIENT.
- Attempt 3 used Codex CLI 0.149.1; it exited 1. The sanitized diagnostic classifier recorded NETWORK_OR_TRANSIENT.
- No model identifier was exposed because no Codex process returned a final response.
- The safe diagnostic is a category, not a verified root cause. A TCP check to chatgpt.com:443 succeeded, which does not establish connectivity to the Codex inference route.
- The initial runner preflight rejection was corrected before model execution and did not start a model process. The three process starts above are the complete bounded attempt count.
- No retry remains within this Gate. No purchase or reset was made.

### Local implementation and durable evidence

The branch adds the Codex provider wrapper, G2BR1 orchestration runner, shared canonical-job helper, and G2BR1-mode renderer path. The runner sends the synthetic prompt under --output-schema, strips API-key/endpoint overrides from the child environment, rejects duplicate canonical jobs before provider construction, and never falls back to the human-authored reference fixture for a G2BR1 pass.

Sanitized files retained under poc/g2b/artifacts/g2br1/:

- content-schema.json and synthetic-generation-prompt.txt — inputs to the attempted structured generation.
- model-execution-status.json — CLI versions, invocation count, sanitized outcomes and no-output status.
- jobs/<sha256>.json — one synthetic canonical job, three failed process attempts, zero successful generations.
- idempotency-report.json — follow-up duplicate rejected before a fourth Codex process.

The branch has no G2BR1 generated JSON, grounding report, QA report, PDF or screenshots because the provider did not return structured content. The G2B human-authored reference JSON and PDF remain only historical baseline evidence below.

### Forbidden-action record

No payment, PayPal, API key, AI imagery, real customer data, production email, VPS/public deployment, Cloudflare/Shared Infra change, paid purchase, or G3 work occurred. The product contract and Reviewer-owned handoff were not edited.

### GitHub review handoff

- Branch: codex/birthday-magazine-g2br1-real-ai-closure, based on main commit c22f1478973bcee11097c2473ee726925613fc81.
- Initial implementation/evidence commit: 8de30bfd295a916e8f620fe290b418490746b66d.
- PR: [#40 — G2BR1 bounded Codex execution return](https://github.com/entropy-student/project/pull/40), open against main and unmerged. The PR head contains the final Evidence/Handoff reconciliation.
- Reviewer remains the next decision point; no merge or G3 work is authorized in this execution.

## Historical Gate — G2B Local AI/PDF Solution Proof (accepted partial baseline)

**Gate:** G2B_LOCAL_AI_PDF_SOLUTION_PROOF  
**Execution date:** 2026-09-27  
**Branch:** codex/birthday-magazine-g2b-local-ai-pdf-proof  
**Base:** GitHub main at 77186cac9b01009c401be23e27c998c2b27ee339  
**Result:** RETURN_AI_PROVIDER_CREDENTIAL_REQUIRED  
**Stop point:** STOP_AT_REVIEWER=YES; G3A/G3B not started.

### Result separation

| Boundary | Result | Evidence |
|---|---|---|
| Synthetic intake validation | **PASS** | poc/g2b/artifacts/qa-report.json |
| Deterministic reference render pipeline | **PASS — renderer reference only** | 12-page PDF and browser/PDF QA below |
| Real structured AI generation | **BLOCKED** | No approved protected provider credential/runtime is supplied by the current project handoff/G2B authorization. No model request was made. |
| Grounding | **PASS — human-authored reference fixture only** | 10 fact records; 9 exact source excerpts plus age/date arithmetic; this is not a live-AI grounding result. |
| Metadata photo mapping / must-use | **PASS — metadata only** | 16 source PNGs, 12 unique selected/mapped, all 3 must-use images included. No visual-semantic model was used. |
| Two dynamic modules | **PASS — reference fixture only** | The Lore / inside jokes and Current Obsessions; distinct and supported by Q4/Q5 fixture text. |
| PDF and deterministic QA | **PASS — reference pipeline only** | 12 pages, each US Letter 612 × 792 pt; 376,319 bytes; opens with pdf-lib; SHA-256 82647bf4bc8b178dca8597b1cd25d7f6c96782d223a47904780481a68426205b. Two consecutive renders produced the same size and hash. |
| Local idempotency boundary | **PASS** | One canonical active synthetic job; duplicate rejected before provider boundary; model spend attempts = 0. |

The content fixture at poc/g2b/fixtures/reference-content.json is explicitly human-authored and synthetic. It proves the renderer's downstream input contract only; it is **not** AI-generated content and must not be presented as AI proof.

### Intake, content and photo evidence

- poc/g2b/fixtures/intake.json contains fictional recipient Mira Vale, age 25 on fixture date 2026-09-27, an older-sister relationship, balanced tone, optional pronouns, six complete narrative answers, quick facts, style soft-warm, 16 non-private PNG scene fixtures, and 3 must-use markers.
- Required factual fields, six answers, photo count/type/bytes, age/date consistency, evidence cues and must-use limit passed. Incomplete answers, 11/26 photos, unsupported type and four must-use markers fail closed. The runner validates intake before claiming a generation job or approaching a provider.
- The selected set is 12 unique images. Must-use IDs photo-01, photo-02, photo-04 are all assigned. P4–P5 use Q2-linked metadata; P8–P9 use Q5-linked metadata. P10's Current Obsessions module uses the Q5-linked Sunday-walk/music image.
- The PNG images are deterministic geometric illustrations generated from local SVG scene markup with Playwright. They contain no people or private/customer photos and are not AI-generated. The deterministic metadata cues prove supported-file selection/mapping, not photographic visual understanding.
- Grounding audit checks every structured source reference, exact supporting excerpts, age/birthday arithmetic, and module source eligibility. The audit is limited to the human-authored reference content; semantic entailment of future model prose still needs actual model output review.

### Page, style, PDF and QA evidence

The one shared page schema rendered the frozen map: P1 cover; P2 opening note; P3 profile; P4–P5 memory; P6 module A; P7 why they matter; P8–P9 current-era photo story; P10 module B; P11 birthday letter; P12 back cover. No contents page or extra page was added.

Bold Editorial, Soft / Warm, and Retro / Playful use the same page-layout hash fb70862addef3f032be9319d345a98f638bd057c415f24c3c12bd4a21a309ea8; browser read-back found distinct palette/frame variables and identical 12-page layout order. The complete PDF uses Soft / Warm.

Deterministic QA passed all 15 negative mutation checks, including missing required answer, photo count/type/must-use limits, duplicate/unsupported module, unsupported source quote, omitted must-use image, unknown photo ID, missing page, overlong copy, browser-measured text overflow, broken image detection and missing provider credential fail-closed behavior. Actual browser read-back found 12 required sections, consistent name/age/birthday, all images loaded, no clipping/overflow, and no duplicate unique photo assignments.

poc/g2b/artifacts/qa-report.json records PDF page sizes, file size/hash, browser results, negative checks, style proof, local network counts and limitations. The browser ran against a short-lived 127.0.0.1 server: 93 local renderer requests, 0 external browser requests, 0 AI API requests.

### Durable artifacts

- PDF: poc/g2b/artifacts/proof-magazine-soft-warm.pdf
- Contact sheet: poc/g2b/artifacts/screenshots/12-page-contact-sheet.png
- Desktop: cover-soft-warm-desktop.png, feature-memory-desktop.png, current-era-desktop.png, birthday-letter-desktop.png
- 375px: cover-soft-warm-375px.png (375px document/page width; no horizontal or text overflow)
- Other preset covers: cover-bold-editorial-desktop.png, cover-retro-playful-desktop.png
- Reports: qa-report.json, grounding-report.json, idempotency-report.json, style-proof.json, ai-provider-status.json, dependency-report.json, artifact-hashes.json, run-summary.json
- Fixture and provider contract: poc/g2b/fixtures/, poc/g2b/src/provider.mjs

### Runtime, dependency and cleanup evidence

- Node.js 24.19.0; Playwright 1.62.1 (Apache-2.0); pdf-lib 1.17.1 (MIT); Google Chrome 153.0.8010.54. Exact npm package versions are pinned in package.json / package-lock.json.
- Playwright printed the actual PDF as US Letter; pdf-lib parsed it and independently read all 12 page sizes. No PDF screenshot was substituted for the PDF.
- Dependency installation contacted npm for the pinned open-source packages. The proof runtime made no request to an AI/model endpoint or any non-loopback browser origin.
- Temporary local job registry, loopback HTTP server, browser process, and project-local `node_modules` were removed/stopped after capture. No Docker container, WordPress runtime, email, payment, public route or service was created. Generated synthetic fixture PNGs, PDF, screenshots and reports are deliberate retained evidence.
- No secrets, real customer data, payment data or external provider calls were used. MVP_PRODUCT_CONTRACT.md and REVIEWER_HANDOFF.md were not modified.

### Git submission state

Pushed implementation commit: 8b39e1ab9261d4bcf610f04add5059c4d791f4c4 on codex/birthday-magazine-g2b-local-ai-pdf-proof.
Reviewer PR: [#30 — G2B local AI-to-PDF solution proof](https://github.com/entropy-student/project/pull/30), open against main and unmerged.
This Evidence/Handoff reconciliation is included as a follow-up commit on the same PR.

---

# G2A1 Execution Evidence — Frontend and Reusable Component Feasibility (historical, preserved)

**Original Gate:** `G2A1_FRONTEND_AND_REUSABLE_COMPONENT_FEASIBILITY_POC`
**Original execution date:** 2026-09-26
**Current closure Gate:** `G2A1R1_EVIDENCE_CLOSURE`
**R1 closure date:** 2026-09-27
**Original G2A1 branch:** `codex/birthday-magazine-g2a1-component-feasibility`
**R1 closure branch:** `codex/birthday-magazine-g2a1r1-evidence-closure`
**Pushed evidence commit:** `5ae191b61e2323657c422a22b927cd3845fc5ec3` (ancestor of the current PR head)
**Reviewer PR:** [#22 — G2A1R1 guest evidence closure](https://github.com/entropy-student/project/pull/22), open against `main`, unmerged
**Environment:** disposable local Docker Compose stack at `http://127.0.0.1:8127`; WordPress 7.0.4, PHP 8.3.33, MariaDB 11.4.13, WooCommerce 11.1.2; local Mailpit v1.31.2 added for G2A1R1.
**Scope:** synthetic inputs, no external payment, no customer data, no AI/API credentials, no production or public host.

## Result summary

| Question | Evidence-based finding |
|---|---|
| Frontend route | Route C is the only route that met the current browser-local preview and WooCommerce-path requirements in the installed runtime. It is a Good Issue-style experience rendered by a small WordPress plugin/shortcode and links to a native WooCommerce product. This is a feasibility preference for Reviewer consideration, not a product/contract decision. |
| Storelly | Not accepted for the free preview. The free builder’s image editor uploads to the WordPress server, so a selected photo leaves the browser. In addition, the tested Storelly product page raised a PHP fatal error and returned HTTP 500. Storelly Cloud was not connected. |
| Upload Files | Registered-account order binding, two one-file slots, and the 375px account upload passed. Guest order page could not be fully verified because WooCommerce requires email verification and this local environment has no working mail transport. Return the guest path for Reviewer decision. |
| Attach Me | Registered order access control passed positive and negative checks; direct uploads URL was denied. Guest order delivery was not fully verified because the same WooCommerce email verification step could not be completed. Return the guest path for Reviewer decision. |
| Commerce | Each preview CTA reached the $39.99 WooCommerce product, add-to-cart and cart. Checkout rendered but had no payment method configured. No payment was attempted or submitted. |

## Current G2A1R1 closure result — supersedes the earlier guest-path gaps below

The original G2A1 findings remain historical context. This section records the later guest-order checks and controls the current handoff. The Gate remains open for Reviewer because both plugins' guest download links were replayable from an unrelated guest context.

| Check | Latest result | Evidence |
|---|---|---|
| Local email capture | **PASS** | Mailpit `axllent/mailpit:v1.31.2` (MIT; image digest `sha256:74d609a42ec279aa63c6b4622a6fa9b5408d1ad5b1d76a1c4be40a265ce0863d`). The service UI binds to `127.0.0.1:8128`; SMTP port 1025 has no host port mapping and is reachable by Compose services only. A synthetic `.invalid` `wp_mail()` probe was captured and the inbox was cleared. Guest verification began and ended with zero captured messages: this WooCommerce 11.1.2 flow compares the entered billing email on the order-received page and does not send a verification email/code. The local-only PHPMailer helper points to `mailpit:1025`; no external SMTP provider or relay was configured, and no production mail was sent. |
| Guest upload positive | **PASS** | A verified synthetic guest selected `synthetic-cover.png` in the order page at a 375px viewport. The browser sent the upload to the local WordPress `admin-ajax.php` path (three observed AJAX responses were HTTP 200); the file then appeared in that guest order's plugin metadata and order page. Stored size was 19,575 bytes under `wp-content/uploads/wcuf/{order}/{line}/`. The persisted result is shown in the guest upload screenshot. |
| Guest upload negative and raw file | **PARTIAL / RETURN** | A wrong email remained at the verification form; an unrelated guest order showed no upload record; raw storage URL returned HTTP 403. However, replaying the plugin's secure download link from the unrelated guest context returned HTTP 200. The link is a bearer capability after issuance, so the required unrelated-context denial did not pass. The secure URL is omitted from this document. |
| Guest private delivery positive | **PASS** | The synthetic text fixture was attached to the guest order through the Attach Me HPOS order panel. A verified guest order page displayed the attachment, and an actual download returned HTTP 200. Downloaded size was 112 bytes; SHA-256 `BD0BB9457A549F5C96A149308A8888E3B4B19FAB77311E4D0F72CC35FFE0A115` matched the committed `poc/g2a1/fixtures/synthetic-proof.txt`. |
| Guest private delivery negative and raw file | **PARTIAL / RETURN** | The unrelated guest order page did not list the attachment and the raw protected storage URL returned HTTP 403. Replaying the Attach Me download link in the unrelated guest context returned HTTP 200, so the required unrelated-context denial did not pass. No signed URL, order key, cookie, or token is included here. |
| Browser-local preview | **PASS; existing accepted result re-read** | Fresh run with the optional synthetic cover showed all preview images using `blob:` sources, no HTTP request or POST after selection, no external origin, and the preview CTA reached the dummy WooCommerce product, cart, and checkout routes. No model/API call was made. |
| Durable screenshots | **PASS** | `docs/evidence/g2a1r1/good-issue-wordpress-desktop.png`, `good-issue-wordpress-375px.png`, `guest-upload-result-375px.png`, and `guest-private-delivery-result-375px.png`. Guest screenshots use synthetic data and mask the email value. |

**Current component disposition:** `ORDER_UPLOAD=RETURN` and `PRIVATE_DELIVERY=RETURN` for the strict guest-context boundary. The plugins did bind the uploaded file and attachment to their orders, and raw storage URLs failed closed. The reproducible cross-context replay of each issued guest download link is a material limitation. Do not describe either plugin as accepted for guest delivery on this evidence.

## Test object inventory

| Object | Exact installed version | Source / license boundary | Install and runtime |
|---|---:|---|---|
| WordPress | 7.0.4 | Official WordPress image; GPL project | Local only; bound to loopback. |
| WooCommerce | 11.1.2 | [WordPress.org plugin directory](https://wordpress.org/plugins/woocommerce/); GPL | Active. Dummy product, cart and checkout routes worked. No gateway configured. |
| Kadence theme | 1.5.2 | [WordPress.org theme directory](https://wordpress.org/themes/kadence/); free theme with paid commercial upgrades | Active for Route A shell and shared preview pages. The named Jewelry Shop starter site was not imported. |
| Kadence Starter Templates | 2.3.4 | WordPress.org plugin; free plugin with optional paid template/content offerings | Active. No starter-site import was run. |
| Blocksy theme | 2.1.57 | [WordPress.org theme directory](https://wordpress.org/themes/blocksy/); free theme with paid commercial upgrades | Installed, inactive in final runtime. Route B page was rendered with the Blocksy shell. The named Modern Shop starter site was not imported. |
| Blocksy Companion | 2.1.57 | [WordPress.org plugin directory](https://wordpress.org/plugins/blocksy-companion/); free plugin with optional paid features | Active during Route B capture. No starter-site import was run. |
| Storelly Product Builder for WooCommerce | 1.7.1 | [WordPress.org plugin directory](https://wordpress.org/plugins/storelly-product-builder-for-woocommerce/); free local plugin; optional cloud rendering, dashboard/analytics and premium templates are separate paid capabilities | Installed, activated for runtime probe, then deactivated after product-page fatal. See Storelly evidence below. |
| Vanquish Upload Files for WooCommerce | 1.6.0 | [WordPress.org plugin directory](https://wordpress.org/plugins/vanquish-upload-files-for-woocommerce/); free version; multiple files per field and cloud storage are Premium | Installed and active. Account orders A/B each exposed two one-file fields. Order A desktop upload and Order B 375px upload were bound to their respective orders. |
| Vanquish Attach Me for WooCommerce | 1.1.0 | [WordPress.org plugin directory](https://wordpress.org/plugins/vanquish-attach-me-for-woocommerce/); free version; customer approval, expiry/download limits and some convenience surfaces are Premium | Installed and active. Synthetic proof fixture attached to Order A. Positive/negative authorization checks passed for registered users. |
| `Birthday Magazine G2A1 Preview` local plugin | 0.1.0 | Local PoC code, GPL-2.0-or-later header | Active and mounted read-only. Provides the Good Issue-like input/preview and WooCommerce CTA. |

The official WordPress.org pages above provide the current free/Premium boundary descriptions. The precise installed versions are from the local WordPress plugin/theme inventory. No premium plugin, license or cloud account was purchased or connected. Optional Freemius opt-ins were skipped.

Official ZIP archives were retained temporarily in `poc/g2a1/packages/` during installation. SHA-256 before cleanup:

| Archive | SHA-256 |
|---|---|
| `woocommerce-11.1.2.zip` | `9DE9350A1CF5671B9960AFB3151F40F7980E223217A441BF2EA5921B5FCE8E9E` |
| `kadence-1.5.2.zip` | `4773B41CD2DA71BDD2519AEDC8BB671EC0D4BEC33ACF6DB6592A40C614C2461B` |
| `kadence-starter-templates-2.3.4.zip` | `7EA5234938C589BB9C1B76A5EB97FAC7A17154F74511A0538732AC32E39CD8B8` |
| `blocksy-2.1.57.zip` | `077BA9E5001D01B08A06360E0E0CB4659842C7C5AF7EAAA58B92945E5982173D` |
| `blocksy-companion-2.1.57.zip` | `F77F6738F71F9C18020F576676D6FC829D70323C712AF09AD290D2BAB6C55072` |
| `storelly-1.7.1.zip` | `11906D9BC346B03AD6F5FA1C9C038190A40188929102A7778DC35AADA1A56706` |
| `vanquish-upload-files-1.6.0.zip` | `79D49FDAF7033FD2357CA106F5A850FFB956BB0B8840CD102BF1A0136A38DAC6` |
| `vanquish-attach-me-1.1.0.zip` | `FED1FA68D8D8DDCD0AFCFE847ED85D4A566819676AC9D4D7B1548A381C3E8C64` |

Synthetic fixture SHA-256:

| Fixture | SHA-256 |
|---|---|
| `synthetic-cover.png` | `BD36A1AF8B85EF8CAD9CEAC6FD048FEBF5F5578E3D77FE07D6ED9B404B41339D` |
| `synthetic-detail.png` | `9F1465BC1208D3CE671E44E4E33CD950E56485D9FB557479C48D6BEB55BEC910` |
| `synthetic-proof.txt` | `B4B4CADE0C5F226A25E7C5C9512F5C17A726C63BBCF4DDCAC25BCE2C7F21480D` |

## Routes A/B/C

All three routes used the same minimal WordPress page content and Good Issue-style `[bms_preview product_id="11"]` shortcode to keep the test bounded. Route A used the Kadence shell, Route B the Blocksy shell, and Route C applied the Good Issue page shell inside the same WordPress site. These were not three completed websites. The named Kadence Jewelry Shop and Blocksy Modern Shop starter sites were not imported, so their demo-page fidelity, block composition and import-time dependency/licensing behavior remain unverified.

| Route | Runtime page | Desktop and 375px result | Good Issue migration / code | Editor and WooCommerce fit | Result |
|---|---|---|---|---|---|
| A — Kadence Jewelry Shop + Storelly | `/?page_id=12` | Kadence header/footer around the page. 375px preview fit without body horizontal overflow after a small route CSS override. | Storelly is not viable for the photo-local preview; fallback shortcode is the same local code as C. | Theme header/footer and page shell stay editable in WP. Preview UI labels, copy and behavior are hardcoded in the custom shortcode. The shortcode page links into native WooCommerce. Exact Jewelry Shop starter import not tested. | Return Storelly path; base Kadence shell is feasible but not enough evidence to accept the named starter-site combination. |
| B — Blocksy Modern Shop + Storelly | `/?page_id=125` | Blocksy shell and preview visible at 1440px and 375px. 375px body/document width remained at the 375px viewport. | Same Storelly constraint. Fallback preview uses the same local code as C. | Theme/page shell is WP-editable. Preview UI labels, copy and behavior are hardcoded in the custom shortcode. Native WooCommerce product/cart path remained available. Exact Modern Shop starter import not tested. | Return Storelly path; base Blocksy shell is feasible but not enough evidence to accept the named starter-site combination. |
| C — Good Issue moved into WP + WooCommerce | `/?page_id=126` | Good Issue-style page shell rendered inside WordPress at 1440px and 375px, with no horizontal document overflow. | Approx. 6.5 KB PHP, 2.6 KB JS, 12.2 KB CSS and 1.1 KB route CSS in the local PoC. The JS uses `URL.createObjectURL()` and revokes the blob URL. | Page shell and the shortcode placement are editable in WP. Preview UI content/controls are in custom PHP/CSS/JS and are not field-editable in the WP editor. CTA uses `get_permalink(11)` and the native Woo product, cart and checkout. | Preferred feasibility route, subject to Reviewer decision. |

### Frontend evidence details

- Inputs are name, age, cover style, and optional one local image. The screen renders one cover plus one sample spread immediately; no LLM, vision, image-generation or server-side image rendering is used.
- Synthetic local image preview displayed from a `blob:http://127.0.0.1:8127/...` URL. The browser Network/WordPress access-log check showed page asset GETs but no image POST during this preview. This is distinct from the upload plugin, which intentionally transfers order files to the local WordPress server.
- The local photo was not persisted in WordPress Media Library or an order by the preview code. The selected file remains in the browser page context; `pagehide` revokes the object URL.
- Storelly’s frontend source uses its upload/AJAX path and WordPress sideload handling, which stores the image on the WordPress server. This is a code-inspection finding; the Storelly image editor itself could not be exercised on the test product because the product page failed first.
- Storelly product request for the dummy magazine returned HTTP 500. Local PHP log pointed to `includes/class-request-quote.php:335`, where `SPBWC_Request_Quote->enqueue_assets()` called `get_id()` on a string. Storelly was then deactivated; no patch/workaround was applied.
- No Storelly Cloud account, PDF export, premium template import or external service was connected. Optional Cloud PDF/dashboard capabilities are outside the free local builder boundary.
- Admin editing boundary: WordPress can edit the page and shortcode placement; the preview interface's copy, controls and generation behavior currently require PHP/CSS/JS edits. Theme shell settings remain in the theme editor/customizer. The Vanquish upload/order metadata and Attach Me order attachment records are plugin-specific; no cross-plugin migration was tested.
- The label “US$39.99” on the preview CTA leads to dummy Woo product ID 11, whose WooCommerce price is 39.99. Add-to-cart added one item and the Cart showed that item. Checkout loaded with “There are no payment methods available.” No gateway setup, payment submission or checkout order was performed.
- Desktop and 375px screenshots for A/B/C were captured in the CUA browser during the execution. The 375px Order B upload screen/result was also captured inline in the execution transcript. Screenshot bytes were not exported as project files by the browser-control surface; the project evidence therefore records viewport/DOM measurements rather than linking image files. Reviewer should treat this as a packaging gap if persistent screenshot artifacts are required.
- Syntax checks: local preview PHP passed `php -l`; `node --check` passed for `preview.js`.

## Vanquish Upload Files — order-bound customer uploads

**Exact object:** Vanquish Upload Files for WooCommerce 1.6.0, free WordPress.org build.
**Local synthetic test objects:** dummy product ID 11 at $39.99; registered account Order A ID 128; registered account Order B ID 129; guest Order ID 130. Orders were synthetic and their status was manually set to `processing` for the local order-page probe; that status does not represent a payment.

| Requirement | Evidence |
|---|---|
| Install/runtime | Installed and active. Two independent “Order photo slot” fields appeared on the customer order page. Each input had `multiple=false`, `accept=".jpg,.jpeg,.png,.webp"`, and a one-file maximum. |
| Multiple images | Free version supports one file per configured field. Two fields accepted cover and detail as separate files. Multiple files in one field is Premium. Per-product/category field restriction and per-field size settings are Premium. |
| Order binding | Order A stored `synthetic-cover` and `synthetic-detail` under `wp-content/uploads/wcuf/128/11-0/`. At 375px, customer B uploaded `synthetic-detail.png`; it appeared on Order B #129 and the file existed under `wp-content/uploads/wcuf/129/11-0/`. Customer B could not open Order A (WooCommerce displayed “Invalid order”). |
| Mobile | At a 375px browser viewport, the upload field remained selectable and the synthetic file appeared in the order details. The underlying order table measured about 456px wide while the viewport was 375px, so some table content can be clipped horizontally even though the outer document reports no horizontal overflow. A physical phone was not tested. |
| Format and size | File inputs accepted JPG/JPEG, PNG and WebP. PHP limits were `upload_max_filesize=2M`, `post_max_size=8M`, `wp_max_upload_size=2,097,152` bytes. Free UI did not expose per-field min/max size controls; practical upload ceiling is constrained by the 2 MiB server setting and available disk/time. |
| Storage/URL | Files were stored on the local WordPress server under `wp-content/uploads/wcuf/{order_id}/{product-line}/`. Secure links were enabled (`vanupfi_secure_links=1`) with `order_placed` association. The generated parent `.htaccess` denied direct access; a raw file URL returned HTTP 403. Authorized order page used the plugin’s order access path. |
| Positive access | Customer A’s Order A page displayed both files. Customer B’s Order B page displayed its own uploaded file. |
| Negative access | Customer B requested Order A and received WooCommerce “Invalid order”. A request without the order key did not reveal Order A file content. Raw static uploads URL returned 403. |
| Guest behavior | **Historical initial G2A1 probe; superseded by the G2A1R1 closure section above.** That probe stopped at WooCommerce's guest email-comparison form before local mail capture was added. |
| Network | Order files were intentionally uploaded to the local WordPress instance. No third-party cloud destination was configured; Dropbox/S3/Google Drive are Premium choices and were not enabled. |
| Limitations | Two separate fields are needed for two free uploads. We did not test physical iOS/Android picker behavior, large uploads, every MIME edge case, or guest verification delivery. The plugin exposes separate Free/Premium capability boundaries rather than requiring a custom upload system for the registered-account path. |
| Cleanup | Order files and test orders live only in the disposable project-scoped DB/files volumes, scheduled for removal at the end of this Gate. Synthetic fixtures remain under the PoC directory. |

## Vanquish Attach Me — private proof delivery

**Exact object:** Vanquish Attach Me for WooCommerce 1.1.0, free WordPress.org build.
**Fixture:** synthetic `synthetic-proof.txt` (111 bytes). Attached to Order A ID 128 only.

| Requirement | Evidence |
|---|---|
| Install/runtime | Installed and active. Admin HPOS order screen showed the Attachments panel; the fixture saved with title “Synthetic proof fixture” and a customer order-details link. No email options were selected and no message was sent. |
| Positive access | Customer A’s Order A page showed an Attachments section with a signed Download/View action. The plugin’s actual `Delivery::can_access()` check returned `true` for the owning registered customer. |
| Negative access | The same authorization check returned `false` for unrelated customer B. B could not view Order A through WooCommerce. |
| Storage/URL | Fixture stored under `wp-content/uploads/vanquish-attach-me/128/{unguessable-folder}/synthetic-proof-….txt`; the folder `.htaccess` denies all direct requests. Raw storage URL returned HTTP 403. Customer access routes through the plugin download handler with entitlement checking; it is not merely a hidden `/uploads/...` link. No signed bearer URL is reproduced here. |
| Download verification | Authorized UI link was visible and source/access checks were positive; the browser download event did not complete in this harness, so content delivery was not confirmed by a completed browser download. Reviewer should distinguish the access decision from a confirmed downloaded-byte response. |
| Guest behavior | **Historical initial G2A1 probe; superseded by the G2A1R1 closure section above.** The later verified guest download succeeded, but the issued guest download link replayed successfully in an unrelated guest context, so the current result remains `RETURN`. |
| Free boundary | Free order attachments and protected order access worked. Customer approval and availability/expiry/download-limit controls are Premium. Free files can be kept local and are not sent to an external service unless the optional Freemius opt-in/licensing flow is enabled; opt-in was skipped. |
| Cleanup | Attachment and metadata are confined to the disposable project-scoped WordPress/DB volumes and will be removed with this stack. |

## Network, privacy and external-service record

- No PayPal, payment gateway, sandbox, real payment, production domain, VPS, Cloudflare or shared infrastructure was used.
- No AI, LLM, vision or image-generation API was invoked. No API key or secret was added.
- The free preview used a browser `blob:` URL and made no photo upload request. Storelly’s source path is server-upload based; it did not pass the current photo-local criterion even without an external cloud request.
- Vanquish Upload Files intentionally sent order fixtures to the local WordPress host. Vanquish Attach Me stored its fixture in the local order-bound protected folder. Neither was configured for external cloud storage.
- Optional plugin telemetry/licensing opt-ins were declined/skipped; no plugin account or Storelly Cloud connection was made.
- The original G2A1 run had no local mail transport (sendmail connection refused); G2A1R1 added a loopback-only Mailpit capture sink. The guest order verification flow itself sent no message, and the inbox was empty after the flow. No customer/guest email was sent externally.
- Protected static URL probes returned HTTP 403 for the Order B Upload Files fixture and the Order A Attach Me fixture. Attach Me's `Delivery::can_access()` returned `owner_allowed=true` for Order A customer A and `unrelated_allowed=false` for customer B.

## Original G2A1 cleanup plan — historical, superseded by the R1 read-back below

- Active stack is the project-scoped Compose project `birthday-magazine-g2a1`; cleanup command is `docker compose -p birthday-magazine-g2a1 -f birthday-magazine-studio/poc/g2a1/compose.yaml down --volumes`.
- Remove only the exact temporary plugin/theme ZIPs and WooCommerce split download parts under `birthday-magazine-studio/poc/g2a1/packages/` after retaining source/version/hash evidence. Do not use global Docker prune or remove any other project’s resources.
- Disposable users, orders, uploaded files, local options and dummy product are in this stack’s data volumes and are removed by project-scoped `down --volumes`.
- Keep only the small PoC source and synthetic fixtures in the repository for Reviewer inspection. No changes were made to `REVIEWER_HANDOFF.md` and no commit was created.

## G2A1R1 cleanup and final runtime read-back

- Executed `docker compose -p birthday-magazine-g2a1r1 -f birthday-magazine-studio/poc/g2a1/compose.yaml down --volumes` after capturing evidence. Docker confirmed removal of the three project containers, both named project volumes, and the default network.
- Read-back after cleanup: `birthday-magazine-g2a1r1` containers/volumes/networks = `0/0/0`; the earlier typo-scoped project `birthday-magazine-g2a1` also has `0/0/0` resources.
- Docker inventory returned to the pre-execution counts: 40 containers, 87 volumes, and 21 networks. The pre-execution inventory digest was `95F7B566D566F6298A4ECC9E346EE00ED127CE5BAA60BFAD97CDFA660414AE61`; no broad Docker prune command was run, and cleanup targeted only this PoC's Compose labels.
- `poc/g2a1/.tmp-g2a1r1/` (including extracted source, browser profiles/screens, private seed data, and generated diagnostics) and `poc/g2a1/packages/` (temporary ZIPs) were removed. The durable evidence screenshots and deliberate local Mailpit Compose/MU-plugin wiring remain.
- Mailpit inbox was empty (`total=0`) immediately before teardown. No production or external mail provider was configured.
- No VPS, public domain, Cloudflare, shared infrastructure, payment, AI/API, or paid-plugin actions were used. `REVIEWER_HANDOFF.md` was not changed.

## Original G2A1 reviewer prompts — historical, superseded by the R1 return below

1. Decide whether Route C is preferred for continued WordPress/WooCommerce MVP work, noting the exact A/B starter-site imports were intentionally not run.
2. Decide whether Upload Files is acceptable for registered-account uploads while the guest flow remains unverified, or return for a test environment with local email capture.
3. Decide whether Attach Me is acceptable for registered-account private delivery while the guest flow and completed file download remain unverified, or return for a test environment with local email capture and byte-level download confirmation.
4. Keep this Gate separate from G2A2. This evidence is not a Reviewer PASS and does not freeze product specifications.

## Current G2A1R1 reviewer decision required

1. Decide whether to reject or replace Vanquish Upload Files for guest orders because its issued secure file link returned HTTP 200 when replayed from an unrelated guest context.
2. Decide whether to reject or replace Vanquish Attach Me for guest private delivery because its issued attachment link also returned HTTP 200 when replayed from an unrelated guest context, despite the raw storage URL returning HTTP 403.
3. Keep this Gate at Reviewer. Do not start G2A2 until the Reviewer resolves the two guest-link access-control failures.

## G3C Blocksy Wedding UI/UX productization — current execution evidence

**Gate:** `G3C_BLOCKSY_WEDDING_PRODUCTIZATION`
**Base:** GitHub `main` at `636e1109e031f1c77704f2b88b83ca5dd771e46b`
**Branch:** `codex/birthday-magazine-g3c-blocksy-wedding-productization`
**Current execution status:** `RETURN_PR_CREATION_PENDING_OWNER_GITHUB_AUTH` — local implementation and reports are committed and the branch is pushed. PR creation remains pending because the GitHub connector transport failed and the browser PR page requires Owner login. Independently, the Owner's updated screenshot archive is not available to the Executor for inspection, so this is not a PASS_CANDIDATE.

### Runtime and dependencies

- Project-local Compose stack `birthday-magazine-g3c` is retained for Owner editing at `http://127.0.0.1:8189/`; wp-admin is `http://127.0.0.1:8189/wp-admin/`.
- WordPress 7.1.1; PHP 8.3.33; MariaDB 11.4.7; WooCommerce 11.1.2; Blocksy 2.1.57; Blocksy Companion 2.1.57. The retained Starter Site is Wedding imported with Gutenberg.
- Active free components: Simply Gallery Block 3.4.3, Stackable 3.20.2, WPForms Lite 2.0.2.1, G3A commerce/workspace plugin 0.1.0, G3C Good Issue preview plugin 0.2.0, and local Mailpit MU plugin 0.1.0.
- No Elementor, HT Slider, or WooCommerce PayPal Payments plugin is installed/active. WordPress and Mailpit host ports bind to `127.0.0.1`; Compose uses the project network `birthday-magazine-g3c_private` and named volumes `birthday-magazine-g3c_database` / `birthday-magazine-g3c_wordpress`.
- Runtime read-back: four project containers remain up; MariaDB and Mailpit report healthy. Teardown is intentionally not performed because Owner visual review needs the site online. No global Docker cleanup was run.

### Product page and editor

- Home is WordPress page 858, still a Gutenberg page with 36 blocks and the Good Issue preview shortcode. The content presents the Birthday Magazine product, sample story/gallery, 12-page US Letter digital PDF, steps, US$39.99 offer, and contract-bounded FAQ.
- Final desktop homepage was inspected in the local browser after the last Hero/header changes. The site identity, Home / What You Get navigation, sample magazine cover, and `Create a Free Preview` CTA were visible.
- Removed the imported Wedding swan block and the old off-canvas Wedding text/logo item. Read-back now finds zero references to `footer-logo.svg` or `logo-dark.svg` in the home page, Blocksy theme mods, or post content: `KNOWN_LOGO_404S_RESOLVED=PASS`.
- `bms-owner` is an Administrator. Runtime capability checks passed for editing page text, replacing images (`upload_files`), reordering the Gutenberg blocks, and editing Blocksy global styles (`edit_theme_options`). No credential is included here. The one-time local setup credential remains in ignored `poc/g3c/.tmp/local-owner-admin.json`; Owner can set a private password using the command template in `poc/g3c/README.md`.

### Free preview and WooCommerce

- The G3C preview reuses the G2A1 Good Issue browser-local component. A synthetic selected photo previously produced a browser `blob:` object URL; `preview.js` uses `URL.createObjectURL` and static inspection found no `fetch`, `XMLHttpRequest`, `FormData`, `sendBeacon`, or AJAX photo-submit path. The displayed copy states the photo stays in this browser. `FREE_PREVIEW_MODEL_CALLS=0`, `FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0`, and `FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0`.
- The browser automation surface did not provide a Network-panel export; therefore the no-photo-upload result is supported by the observed blob URL and source inspection, not by a committed HAR. This limitation is retained for Reviewer.
- Product 1113 is a simple virtual WooCommerce product at USD 39.99. `Add to cart` worked; Cart showed one item at USD 39.99; Checkout loaded with required billing fields and the local-only `Local test only — no payment` offline method; account registration is required at checkout and generated username/password are configured. My Account login page loaded. No checkout submission or payment occurred.
- The native path remains `Product → Cart → Checkout → My Account`; the homepage preview CTA and offer link point to WooCommerce product 1113. The order/cart implementation remains WooCommerce; no parallel order system was introduced.

### Private workspace regression and boundaries

- Reused the G3A workspace plugin; synthetic fixture order 1131 remained unpaid. Buyer A opened the workspace successfully (HTTP 200); Buyer B replay and guest direct replay were denied (HTTP 403 each). The fixture is not a paid order.
- Generation jobs and model calls remained zero. PayPal Sandbox actions, PayPal Live actions, real-money actions, production AI calls, production deployment, shared-infrastructure mutations, and paid purchases were all zero.
- Checkout was not submitted. The runtime remains local and available; no cleanup teardown was run.

### Screenshot handoff limitation

- PNG files currently in the local `poc/g3c/artifacts/screenshots/` folder are from before the final Hero/header/logo corrections. They are intentionally not committed or cited as current-state proof.
- The Owner reports that the updated PNGs are in a local archive and will send that archive directly to the Reviewer. The Executor did not inspect that archive. Thus current-state desktop/mobile screenshot evidence is an Owner-to-Reviewer handoff item; 375px layout is not marked PASS by the Executor.
- Required filenames are documented in `poc/g3c/artifacts/screenshots/README.md`. Please review the Owner-supplied archive before deciding the visual freeze.

Machine-readable current reports: `poc/g3c/artifacts/reports/runtime-setup.json`, `productization.json`, and `verification-g3c.json`.

### GitHub submission status

- Local execution commits `75bcf66` and `cde069d` are on the dedicated G3C branch. The first `git push` attempt failed to connect to `github.com:443`; a later retry succeeded and confirmed the remote branch was created. The GitHub PR connector still failed to reach its backend. The browser compare page is at [create G3C PR](https://github.com/entropy-student/project/pull/new/codex/birthday-magazine-g3c-blocksy-wedding-productization) and currently requests GitHub login. No PR has been opened yet.
- The remote branch is available, but no PR exists. Owner must complete GitHub login in the local browser; then resume PR creation. No merge was attempted.

## G3CR4 — G3C visual consolidation execution evidence

**Gate:** `G3CR4_G3C_VISUAL_CONSOLIDATION`
**Execution result:** `PASS_CANDIDATE_G3CR4_G3C_VISUAL_CONSOLIDATION` — Reviewer decision remains pending.
**Branch:** `codex/birthday-magazine-g3c-blocksy-wedding-productization`
**PR:** [#64](https://github.com/entropy-student/project/pull/64), verified open and unmerged before this evidence update.
**Pre-execution HEAD:** `af04fc8252ad414af53fb24394432de447d69bd1`.

The existing local G3C runtime was retained; it was not rebuilt or torn down. WordPress 7.1.1, WooCommerce 11.1.2, Blocksy 2.1.57, and Blocksy Companion 2.1.57 were read back from the running environment. WordPress, MariaDB, and Mailpit containers remain running; MariaDB and Mailpit are healthy. Elementor and HT Slider are not installed.

Before editing, Home page 858's raw Gutenberg content and the relevant Blocksy theme mods were saved to `poc/g3c/artifacts/backups/g3cr4/home-and-blocksy-before-20261001-141123.json` (504,020 bytes; SHA-256 `225f5f03fdadca990cce5995b0aafa75c71fdf433de465023f50c70b9219d6a7`). `scripts/restore-g3cr4-backup.php` restores those values. The current Home content is six editable top-level Group sections: Hero, three representative magazine samples, Free Preview, What You Get, How It Works, and Offer + FAQ. The page remains a normal Gutenberg page, not an opaque template. `bms-owner` is still an Administrator and can edit the page, replace media, reorder blocks, and edit Blocksy global styles.

The previous long/repetitive page is consolidated: the main flow has three sample blocks (two displayed at once on 375px), repeated story labels are absent, Spacer blocks and mouse/scroll decorations are absent, and the Hero cover loads and is legible. At 1440px the document width is 1440px. At a 375px viewport the document width is 375px; the Preview workbench and spread are single-column, required labels and controls are visible, and measured preview elements have no right-edge clipping or internal horizontal overflow.

The existing Good Issue preview shortcode is present once. Selecting the repository's synthetic sample image produced three loaded `blob:` preview images in both desktop and mobile contexts. After file selection the browser recorded zero POST/PUT requests, zero external image requests, and zero model-provider requests. No image was uploaded to WordPress or a third party.

The Offer CTA resolves to the native WooCommerce product page. Product 1113 is virtual at USD 39.99. Its native Add to Cart returned HTTP 200 with WooCommerce's success response; Cart displayed the product and USD 39.99 total. Checkout rendered its form and My Account rendered the login form. No checkout was submitted and no payment/order was created. The only WooCommerce styling change is the authorized global Footer contrast correction; product/cart/checkout templates were not redesigned.

Private Workspace code and routes were not changed. The already accepted G3C/G3A access evidence is reused for this visual-only regression check: owner access 200, unrelated account 403, guest replay 403. The workspace plugin remains active. This execution did not create or mutate a workspace/order fixture.

Fresh synthetic screenshots and the machine read-back are under `poc/g3c/artifacts/screenshots/g3cr4/` and `poc/g3c/artifacts/reports/g3cr4-final.json` (17 PNG files, each recorded with size and SHA-256). The WP Admin/Gutenberg screenshot was not captured because the isolated browser context had no authenticated session; no password or session credential was read or exposed.

| Check | Result |
|---|---|
| Editable Home structure | Six Gutenberg Group sections; three sample blocks; one preview shortcode |
| 375px layout | Document width 375px; preview single-column; no measured clipping/overflow |
| Browser-local photo preview | `blob:` images loaded; 0 image-selection POST/PUT; 0 external image posts |
| Preview model/network calls | 0 model-provider requests |
| Native WooCommerce path | Product → Cart → Checkout → My Account; USD 39.99 product remains virtual |
| Owner editing | Administrator; page edit/media upload/block reorder/Blocksy global-style capabilities present |
| Private workspace | Previously accepted G3C/G3A owner/other-account/guest access result reused; implementation untouched |
| Forbidden actions | PayPal 0; real money 0; model/AI 0; production deployment 0; shared infra 0; paid purchases 0; global prune 0; G4 0 |
| Runtime | Retained for Owner review; no teardown |

Owner visual freeze remains `PENDING`; stop at Reviewer. No Reviewer decision document was modified.

## G3CR5 — visual finish and WooCommerce continuity

**Gate:** `G3CR5_G3C_VISUAL_FINISH_WOO_CONTINUITY`
**Execution result:** `PASS_CANDIDATE_G3CR5_G3C_VISUAL_FINISH_WOO_CONTINUITY` — Reviewer decision is pending.
**Branch:** `codex/birthday-magazine-g3c-blocksy-wedding-productization`
**PR:** #64, continued on the existing open PR; no merge was performed.
**Pre-execution HEAD / rollback point:** `084a4308da57fd96f04e757c4072e24243f8dfb8`.

The retained local runtime was used without rebuild or teardown: WordPress 7.1.1, WooCommerce 11.1.2, Blocksy 2.1.57, Blocksy Companion 2.1.57, and G3C preview plugin 0.2.0. Product 1113 still reads USD 39.99, currency USD, virtual=yes. The Home page remains page 858 with Gutenberg blocks; its raw content SHA-256 before and after is unchanged at `d075824113df48fa75a8abd9d783509b0dfc17d97f396a1e523caa7c57735bcb`.

### Preview composition and privacy

The shortcode now wraps the existing preview image/art hooks in a dedicated `.bms-spread-photo-frame` and places the existing copy in a separate `.bms-photo-copy` region. Existing `preview.js` and its browser-local object URL behavior were not changed. The photo fills its dedicated frame with `object-fit: cover`.

In fresh Playwright/Edge contexts at 1440×1000 and 375×812, a synthetic sample image loaded from a `blob:` URL. The image frame and copy are non-overlapping layout siblings; the kicker, “More life. More stories.” headline, body copy, and page number all fit within the copy region at both widths. The spread and document have no measured horizontal overflow. During image selection, browser request events were browser-local blob image reads only (one per photo-loaded preview); HTTP POST/PUT/PATCH count was 0, external HTTP request count was 0, external image request count was 0, and model-provider request count was 0. Blob object identifiers are redacted in the machine report.

### WooCommerce continuity

Added a project-local CSS skin, enqueued only on WooCommerce Product/Cart/Checkout/My Account routes. Native templates, product identity/price/virtual status, cart behavior, checkout settings, and the order system were not replaced. The skin uses the accepted paper/white/ink palette, Georgia editorial headings, blue header links, coral square CTAs, padded white form/cart/order panels, and the existing dark footer. Non-product Woo page titles now start below the sticky Blocksy header.

The native Product Add to Cart returned HTTP 200 with WooCommerce success; the same isolated browser context showed the US$39.99 item in Cart, loaded Checkout with account-required billing fields and the local-only no-payment gateway, and loaded My Account with the native login form. No checkout/order submission was made. At 375px, Product, Cart, Checkout, and My Account each had `documentElement.scrollWidth=375`; core CTAs and visible form controls fit within the viewport. Computed styles confirm the product price/Add to Cart, cart totals/checkout CTA, checkout billing/order panels/CTA, and account form/login CTA use the shared skin. Browser console/page errors: 0.

### Owner editability, screenshots, and boundaries

Fresh WordPress read-back: `bms-owner` role=Administrator; `user_can(edit_post, 858)=true`; page 858 has Gutenberg blocks and `use_block_editor_for_post(858)=true`; upload-files and Blocksy global-style capabilities remain enabled. No password or session material was read or recorded. Home Gutenberg content was not modified.

Eleven current screenshots and a sanitized machine report are saved under:

- `poc/g3c/artifacts/screenshots/g3cr5/` — required files 01–11 (desktop Home/preview/Product/Cart/Checkout/My Account and 375px selected-photo preview plus mobile Woo pages).
- `poc/g3c/artifacts/reports/g3cr5-final.json` — viewport measurements, overlap checks, sanitized Network read-back, Woo path/skin checks, runtime/version/editor read-back, forbidden-action counts, screenshot byte sizes and SHA-256 inventory.

Runtime read-back after testing: WordPress container is up; MariaDB and Mailpit are up and healthy. Site remains at `http://127.0.0.1:8189/` and wp-admin at `http://127.0.0.1:8189/wp-admin/` for Owner review.

| Check | Result |
|---|---|
| Selected photo dedicated frame / no copy overlap | PASS desktop and 375px; `object-fit: cover` |
| Browser-local preview | `blob:` loaded; 0 server uploads; 0 external HTTP/image requests; 0 model requests |
| Homepage regression | PASS; six accepted sections; 375px width 375; Hero CTA visible; Home content hash unchanged |
| Native Woo Product → Cart → Checkout → My Account | PASS; Add to Cart HTTP 200; product remains virtual USD 39.99; no order submission |
| Woo visual continuity | PASS across Product, Cart, Checkout, and Account computed styles and screenshots |
| Woo 375px / blocking overflow | PASS / NO; four route document widths are 375 and controls fit |
| Owner Gutenberg edit access | PASS; Administrator, editable Home, Gutenberg enabled, media and global-style capabilities present |
| Runtime | Retained for Owner; no rebuild or teardown |
| Forbidden actions | PayPal 0; real money 0; model/AI 0; production deployment 0; shared infra 0; G4 0; paid purchase 0; global prune 0 |

No `REVIEWER_HANDOFF.md` or Reviewer decision file was edited. `OWNER_VISUAL_FREEZE=PENDING`; stop at Reviewer.

## G3CR6 — Frontend Experience + Brand Redesign (2026-10-01)

This append supersedes G3CR5 as the current frontend candidate; historical evidence and Reviewer decisions are preserved.

### Authority / preflight

- Owner latest G3CR6 authorization + main `becb2ab9c644649a07327664cfdb5ae975964ba9` contract and Handoff were read. Canonical GitHub Governance SKILL, Handoff, v0.1.6 reference, source policy, target-host contract and Executor/Evidence templates were read. Local governance copy is a non-authoritative cache.
- Branch: `codex/birthday-magazine-g3c-blocksy-wedding-productization`; pre-run HEAD `b3aff79fd74b0a63bc42ff370c8adb1a5eac82ba`. Continue existing PR #64, open/unmerged.
- Provided ZIP was extracted with absolute destination guards into ignored project `.tmp/g3cr6-pack/`. Both reference images and execution boundary were read. Images set mood, not product structure.
- Existing G3C WordPress/MariaDB/Mailpit runtime remained running on localhost; no rebuild/start/restart/tunnel occurred. No production host touched.
- Existing Owner ZIPs/untracked old screenshots and 17 locally deleted tracked G3CR4 screenshots were present at start and excluded from this commit. The deleted screenshots remain in Git history.

### Scoped backup / writes

- Pre-edit backup: `poc/g3c/artifacts/backups/g3cr6/home-and-blocksy-before.json`; SHA256 `8639434135745daf86cf049722b33a634144e9f28ff8056e87da3447349db710`. Includes Home, allowlisted Blocksy mods and original product thumbnail. Theme mods were not changed.
- Original product copy: `product-copy-before.json`; previous plugin implementation: `preview-plugin-before/` in the same directory. Rollback helper: `scripts/restore-g3cr6.php`; procedure in `artifacts/reports/g3cr6-execution-notes.md`.
- Home remains six editable Gutenberg groups. Reworked copy, sample images, warm gift styling, Hero/header clearance, Preview and Offer/FAQ presentation. Added three fictional marketing media attachments.
- Product 1113: customer-facing title/description and featured image changed; ID/US$39.99/USD/virtual remain. Native gallery uses Woo's standard full-size image filter. Product, Cart, Checkout, Account share the warm paper/coral/serif visual skin.
- Preview frontend rebuilt with dedicated photo frame, visible replace/remove, accessible live status, image decoding and invalid/corrupt-file rejection. Photos still use createObjectURL/revokeObjectURL only.
- Protected backend unchanged: compose, commerce/private-workspace plugin, Woo checkout/payment/order/account semantics, entitlement/job/schema/renderer. File parity hashes appear in the final report.

### Generated asset boundary

- Built-in image_gen, explicitly Owner-authorized: 4 original generations + 1 targeted page-number correction = 5 calls. Four curated assets adopted. Exact prompts and asset paths in `g3cr6-asset-provenance.md`.
- Marketing-only Hero, cover and spread; all people fictional. Original spread 14/15 numbering was rejected and corrected to 04/05. UI labels fictional samples and digital PDF, not print/customer proof.
- Separate synthetic portrait is a local browser screenshot input and was not imported into WordPress. These creative calls are not product-generation or Preview model calls. Production AI remains untouched.

### Verification

- Durable 19 fresh PNGs in `poc/g3c/artifacts/screenshots/g3cr6/`: full Home, Hero, samples, empty/photo Preview, Offer/FAQ, all four native Woo routes at desktop and 375px. File hashes and dimensions/checks in reports.
- Browser report: `artifacts/reports/g3cr6-browser.json`; aggregate: `g3cr6-final.json`; runtime/Owner capabilities: `g3cr6-runtime.json`.
- Desktop 1440x1000 and mobile 375x812: document width equals viewport on Home/Product/Cart/Checkout/Account; no broken image or pageerror/404 in tested routes. Hero clears overlay Header. Photo frames and text do not overlap. Mobile Preview is single-column, internal width343px equals its container.
- Name/age/styles, select/replace/remove, old blob revocation, invalid MIME and corrupt image rejection passed on both viewports. Blob sources loaded successfully. During interaction, four local static GET requests per viewport were observed (WPForms/Blocksy assets); no photo upload, external image POST or model request. Evidence does not claim zero total network traffic.
- Real native Woo Add to Cart HTTP200/success; cart quantity2/US$79.98 and remove-to-empty passed. Checkout/account native forms and visible CTA controls passed. Checkout was not submitted. Synthetic order count before/after remains1.
- Owner Administrator, edit Home, upload media, Gutenberg and edit_theme_options capability read-back passed. Text/images/reordering remain core Gutenberg blocks; Preview only is a shortcode. No administrator credential was read and no admin-session screenshot claimed.
- Existing private-space PHP guard regression under in-memory synthetic identities: Owner200/rendered, unrelated403, guest403. Browser guest direct URL also403. This is not a fresh authenticated HTTP login/session proof; historical accepted account proof is reused and backend unchanged.
- Local counter options are absent and default to0; no product generator/provider was installed or called. No new generation job path was added.

### Anomalies / cleanup

- Initial Home installer wrote successfully, then failed in final report due to undefined theme variable. Fixed durable script, verified saved state directly, no repeated media import. Screenshot harness was corrected to select visible native cart controls and compare frame layout coordinates before CSS transforms; these were test harness issues.
- Runtime retained for Owner review, no teardown. New media/assets and rollback files intentionally retained. Temporary browser contexts closed. Project-only ignored tools/reference extraction retained; no global cleanup/prune, unrelated Docker resources not mutated.
- Resource identity/start-time read-back: `artifacts/reports/g3cr6-resource-readback.txt`.

```text
RESULT=PASS_CANDIDATE_G3CR6_FRONTEND_EXPERIENCE_BRAND_REDESIGN
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
WOO_NATIVE_PATH=PASS
CHECKOUT_SUBMITTED=NO
OWNER_GUTENBERG_EDIT_ACCESS=PASS
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
THEME_CHANGE=0
BUILDER_CHANGE=0
ELEMENTOR_INSTALL=0
PAID_PURCHASES=0
GLOBAL_DOCKER_PRUNE=0
G4_ACTIONS=0
PR_MERGED=NO
G3C_RUNTIME_RETAINED_FOR_OWNER_REVIEW=YES
OWNER_VISUAL_FREEZE=PENDING
STOP_AT_REVIEWER=YES
```

Git submission: this G3CR6 batch continues branch/PR #64; final SHA is the enclosing Git commit and is reported after push/read-back. No Reviewer PASS is asserted.

## G3CR6R3D1 — Focusly visual mapping (2026-10-04)

### Authorized Gate / preflight

- `G3CR6R3D1_FOCUSLY_VISUAL_MAPPING`; documentation/evidence only. Owner's current request and the current Gate/Owner decision authorize public visual observation, source mapping and Reviewer-ready submission, not implementation.
- PR #64 API read-back: open, unmerged, head `36b670c333601624c068b543d7bc3c2f2f9ee346`. Local branch fast-forwarded from `d82e78494c9ece831b71af12aeacee8099b4aa5a` to that approved head; no frontend changes in the sync. Main at fetch `054b65f542ef456733396dd304fa6589da9eceae`; no main-only Birthday Magazine commits in the project-scoped log. Unrelated monorepo commits do not redefine this Gate.
- Canonical governance current SKILL declares v0.2.6 / VNEXT.md; local legacy skill was treated as non-authoritative. Current Gate/relay and Owner decision used. No Reviewer decision/Handoff edited.
- Docker read-only `ps` failed (exit1): Docker Desktop Linux Engine pipe absent. Browser GET to localhost8189 Home, Product, Cart, Checkout, My Account all returned connection-refused. No start/rebuild/repair or alternate runtime was attempted.

### Actual changes / objective read-back

- Only new mapping/documentation and evidence under `docs/G3CR6R3D1_FOCUSLY_VISUAL_MAPPING_REPORT.md` and `docs/evidence/g3cr6r3d1/`, plus this append and Executor Handoff append.
- Directly opened Webflow's Focusly public listing; rendered page links to `https://focusly-template.webflow.io/` as Preview in browser. Actual Home1 HTTP200 was inspected at1440×1000 and375×812 using existing Playwright Core1.62.1 / installed Edge. Exact browser version/times in JSON.
- Captured navigation, full-viewport focus Hero/entrance, introduction, three alternating photo/copy regions, three work cards, sticky closing reveal and footer. Timed focus/filter/opacity samples, heading entrance, hover label/dot behavior, scroll perspective matrices and mobile menu opening retained. Computed typography/background/frame measurements retained without source or original asset extraction.
- All major public desktop/mobile regions were visually inspected. Full-page PNGs alone are explicitly not treated as proof for fixed backgrounds or scroll-dependent card states. Motion-state PNGs and geometry reports supplement them. No specific Webflow animation implementation/library/easing inferred.
- Direct source read-back inventories current enqueued frontend files, shortcode DOM/data hooks/local object-URL logic, eight Group installer/accepted report, native commerce destinations and workspace guard. Three project-owned marketing PNGs opened, all owned candidate PNG dimensions/hashes inventoried. Optional standalone life-moment photo gap identified; required new generation=none; images generated this run=0.
- Per-region mapping distinguishes KEEP/RESTYLE/REORDER/REPLACE_VISUAL_ONLY, asset origin, independently recreated motion and frozen behavior. Proposed ordering/tradeoffs,375px behavior and explicit reduced-motion/no-JS fallback await Reviewer decision.

### Validation / limitations

- Public reference direct observation: PASS at sampled widths; current-source/function inventory: available; fresh current runtime/group/template/menu/CTA/Woo visual read-back: **BLOCKED**. No current-site screenshot or current-runtime PASS claimed. Accepted G3CR6R1 facts are labeled reused historical evidence, not replayed validation.
- Actual WP persisted Home, resolved PHP template, menus/theme mods/media URLs and current counters cannot be freshly read while stopped. Source-supported route intent is documented; a historical sample anchor discrepancy is UNKNOWN until fresh menu read-back, not silently fixed.
- Reduced-motion reference sample retained, full compliance UNVERIFIED. Physical touch/iOS/tablet breakpoints/cross-page transitions not verified. The work-card hover scale sample is confounded by scroll settling and is not claimed as an independent hover effect.
- First observation helper timed out on a hidden mobile nav link; helper was stopped, visibility check added, and evidence collection repeated successfully. This was a tooling/extraction issue, not reference application failure. Successful browser contexts were closed. Temporary observation helpers were project-scoped/ignored and are not application code or submitted source.
- No frontend/WP/CSS/JS/media/DB/runtime mutation; no cart action or Checkout submission; PayPal/real-money/product-model/image-generation/production-deployment/shared-infra actions0. Preview privacy/commerce/account/workspace/entitlement logic untouched. No D2/G4 action, no PR merge.
-17 pre-existing tracked G3CR4 screenshot deletions and Owner ZIPs/untracked files preserved and excluded from commit. No runtime rollback required; docs/evidence can be reverted as a scoped commit. Docker resource fingerprint/health cannot be freshly asserted with daemon unavailable.

### Evidence artifacts / result

- Mapping: `docs/G3CR6R3D1_FOCUSLY_VISUAL_MAPPING_REPORT.md`.
- Public screenshot index, SHA256 manifest and geometry/motion/surface/source/preflight/failed-local-GET reports: `docs/evidence/g3cr6r3d1/`.
- Git submission continues the existing branch/PR #64; the enclosing evidence commit is the immutable submission identity, read back after push. No new PR/merge and no accepted source/evidence history dropped.

```text
RESULT=RETURN_G3CR6R3D1_LOCAL_HOMEPAGE_UNAVAILABLE
PUBLIC_FOCUSLY_OBSERVATION=PASS_AT_SAMPLED_VIEWPORTS
CURRENT_HOME_FRESH_READBACK=BLOCKED
RUNTIME_MUTATIONS=0
FRONTEND_MUTATIONS=0
PAYPAL_ACTIONS=0
CHECKOUT_SUBMISSIONS=0
MODEL_CALLS=0
IMAGE_GENERATION_CALLS=0
SHARED_INFRA_MUTATIONS=0
D2_STARTED=NO
STOP_AT_REVIEWER=YES
OWNER_RELAY=NONE
```
