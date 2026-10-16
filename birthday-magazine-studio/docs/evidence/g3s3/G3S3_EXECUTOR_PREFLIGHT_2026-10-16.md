# G3S3 Executor Evidence — Local WooCommerce / Stripe Test preflight

> Date: 2026-10-16  
> Gate: `G3S3_LOCAL_WOOCOMMERCE_STRIPE_TEST_PREFLIGHT_20261016`  
> Gate source on current `main`: `birthday-magazine-studio/docs/G3S3_LOCAL_WOOCOMMERCE_STRIPE_TEST_PREFLIGHT_2026-10-16.md` (blob `0274a3eb355c0dd5c07e068a8c21fcee80800e7d`)  
> Executor result: `RETURN_PREFLIGHT_DRIFT`; `STOP_AT_REVIEWER=YES`

## Result

The correct Windows 11 machine and `desktop-linux` Docker context were reached, but this Gate cannot prove current WooCommerce, Stripe, product, or checkout settings: all four G3C containers are stopped. The project checkout mounted by Compose is also not the current clean PR #64 source. No container was started and no checkout, database, plugin, account, or payment operation was attempted.

## Fresh local readbacks

| Check | Direct result |
|---|---|
| OS / shell | Windows 11, build 26300; PowerShell 7.6.5. Identity query exit 0. |
| Docker | Current context `desktop-linux`; Docker Engine 29.7.2; info query exit 0. |
| G3C containers | Project-filtered query exit 0. `wpcli` and `db` are Exited (137); `wordpress` and `mailpit` are Exited (0). Finish times were 2026-10-16 04:31–04:32 UTC. Cause of exit 137 is unknown; no restart was attempted. |
| Compose identity / mounts | Inspect exit 0. All four containers carry Compose project `birthday-magazine-g3c` labels and point to the local `g3cr2` checkout's `poc/g3c/compose.yaml`. DB and WordPress named volumes are `birthday-magazine-g3c_database` and `birthday-magazine-g3c_wordpress`; project network `birthday-magazine-g3c_private` exists. No volume contents were read or changed. |
| Local G3C source | Git checkout branch name matches PR #64, but local HEAD is `f50cc974ead65c9811f952cdf0a327c548f14efc`; current PR #64 head is `4cb0d527d77a6d583e123acd3f62c45408669569`. GitHub comparison reports 45 commits ahead at PR head across 300 files. The working tree has pre-existing edits to three G3C source files and 17 tracked screenshot deletions. This Executor made no local source changes. |
| Source correlation | The local HEAD blobs for `poc/g3c/compose.yaml` and `commerce-workspace-plugin/bms-g3a-commerce-loop.php` match PR #64; `preview-plugin/birthday-magazine-poc.php` does not. The current checkout is therefore not a clean representation of the PR source. Existing edits/deletions were preserved. |
| Local site | HTTP status was not probed. With the WordPress container stopped, no fresh `127.0.0.1:8189` response or runtime plugin/config readback is claimed. |

PR #64 was Open / Unmerged and reported non-mergeable before this Evidence commit. The Gate remains on `main`; the G3C Compose and application source are on the PR branch. This Evidence does not merge or rebase the PR.

## Database recovery and residual package inventory

The existing backup folder under `%LOCALAPPDATA%\BirthdayMagazineStudio\G3S1S\20261015T213127-f1ccf9a1` was inventoried without reading SQL contents. PowerShell inventory exited 0:

- `wordpress-db-consistent.sql`: present, 9,802,953 bytes.
- `wordpress-root.tar.gz`: present, 126,003,006 bytes.
- `mounted-source-bindings.tar.gz`: present, 23,740,653 bytes.
- `private-backup-manifest.json`: present, 2,269 bytes.

Two previously known host temporary ZIPs are also present: the complete package (1,568,686 bytes) and incomplete download (1,566,008 bytes). They were not opened or deleted. The WP-CLI container is stopped, so its prior `/tmp` copy was not freshly inspected.

Accepted G3S1SV evidence remains the sole restore proof: isolated MariaDB 11.4.7 import exit 0, 58/58 tables, scratch container removed exit 0. It is not repeated here. Snapshot-to-live row-level equality was not established in that Evidence. Before a later Test-mode configuration/payment write, a newly selected DB + WordPress/uploads recovery point and independently reviewed rollback are still required.

## WooCommerce, Stripe, and intake status

- **Fresh runtime state:** WordPress/WooCommerce status, active payment methods, current product #1113 fields, current order count/ownership, Stripe plugin inventory, and Stripe gateway settings are **UNKNOWN** because the containers are stopped.
- **Accepted prior evidence (not a fresh readback):** official WooCommerce Stripe 11.1.0 was installed inactive, no Stripe gateway was registered, and product #1113 was virtual at USD 39.99. This Gate did not reinstall or activate it.
- **Current PR source read:** the intake JavaScript keeps selected photos as browser object URLs and reads answers from the page. Its five-step page explicitly says photos/answers are not saved to the server in this flow and instructs not to place an order. The checkout handler only POSTs product #1113 to WooCommerce `add_to_cart`, then redirects to native checkout; it does not submit the intake draft. The commerce workspace source binds a workspace to an order/customer after order processing and checks the signed-in order owner; it explicitly has no generation implementation. These are repository-source facts, not current runtime readbacks.
- **Netlify boundary:** the Owner-reported Netlify site is static information/frontend only; it is not the WooCommerce runtime or a Stripe webhook endpoint. Merchant country/legal form, charges/payout status and successful Stripe Test checkout remain unverified.

## Webhook and Test-mode integration plan (proposal only)

The official WooCommerce Stripe Gateway 11.1.0 source handles `?wc-api=wc_stripe` through `woocommerce_api_wc_stripe`, verifies signatures with the mode-specific secret, and exposes a Test Webhook Secret setting. Its `configure_webhooks('test')` path creates a Stripe webhook endpoint and stores its secret, which is a Provider-side write and is outside this Gate.

1. First resolve the source/runtime drift in a separately reviewed local-runtime Gate. Do not clean or reset the existing dirty checkout. Select an exact PR/source commit, prove the runtime's mounted source and current local state, then read back WordPress, WooCommerce, #1113, the active checkout configuration (secrets excluded), and plugin status.
2. Before any Test-mode write, select and verify a fresh recoverable DB + WordPress/uploads/plugin-state point and a scoped rollback/stop procedure. Do not repeat the prior successful restore unless a new Gate requires a fresh recovery proof.
3. A later, separately authorized Gate may enable **Test mode only** and let the Owner perform any required Stripe account connection. Keep credentials and signing secrets out of Evidence. The canonical plugin callback suffix is `?wc-api=wc_stripe`; the exact origin must be established from fresh local settings.
4. Preferred delivery candidate to evaluate: Stripe CLI Test-mode event forwarding to `http://127.0.0.1:8189/?wc-api=wc_stripe`, with its signing secret stored only in the plugin's Test Webhook Secret setting. Confirm the 11.1.0 plugin's connection/webhook configuration does not replace that secret or create a conflicting endpoint before adopting this path. If it cannot support this path, a short-lived HTTPS relay and temporary canonical-origin change need their own explicit Gate, recovery plan, and teardown/readback. Do not use Netlify for callbacks.
5. Use a synthetic test customer/order and Woo native checkout for the payment test; do not treat a Stripe-hosted page or a generated event alone as proof of Woo order correlation. After explicit authorization, cover Test success, cancel/failure, exact order/amount/USD/test-mode correlation, valid signed callback, rejected invalid signature, identical-event replay with no duplicate entitlement, and Test refund with entitlement revocation. Do not send real customer intake through this fixture.
6. The browser-only photo/answer draft is a separate paid-MVP blocker. Persist and bind the completed draft to the canonical Woo order before claiming a real customer can pay and receive the magazine. This Gate did not build or test that flow.

Official version-pinned implementation references:
- [Webhook handler and callback verification](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/class-wc-stripe-webhook-handler.php)
- [Per-mode account/webhook configuration](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/class-wc-stripe-account.php)
- [Test Webhook Secret setting](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/admin/stripe-settings.php)
- [Plugin test helper's callback URL](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/tests/e2e/utils/stripe-webhooks.js)

## Scope and stop

`LOCAL_STATE_MUTATIONS=0`; `CONTAINERS_STARTED=0`; `DB_IMPORT_OR_QUERY=0`; `PLUGIN_INSTALL_OR_ACTIVATION=0`; `STRIPE_ACCOUNT_OR_PROVIDER_ACTIONS=0`; `CHECKOUT_PAYMENT_REFUND=0`; `TUNNEL_OR_DEPLOYMENT=0`; `PAYPAL_CHANGES=0`; `PR_MERGE_OR_REBASE=0`.

`EXECUTOR_RESULT=RETURN_PREFLIGHT_DRIFT`  
`STOP_AT_REVIEWER=YES`  
Reviewer should reconcile the stopped runtime and stale/dirty source identity before issuing any Test-mode integration Gate.
