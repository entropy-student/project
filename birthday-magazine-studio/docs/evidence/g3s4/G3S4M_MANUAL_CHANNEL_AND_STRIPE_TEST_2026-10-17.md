# G3S4M — local read-only preflight evidence

Date: 2026-10-17  
Gate: `docs/G3S4M_OWNER_MANUAL_AUTH_AND_VERIFIED_LOCAL_STRIPE_TEST_CHANNEL_2026-10-17.md`  
Reviewer entry: `REVIEWER_HANDOFF.md` current 2026-10-17 entry  
Parent decision: `docs/REVIEWER_DECISION_G3S4AR_CREDENTIAL_RESULT_AND_LOCAL_NEXT_GATE_2026-10-17.md`  
PR: #64, existing branch `codex/birthday-magazine-g3c-blocksy-wedding-productization`  
Pre-write PR head: `4591fb5b6ccb07720771aaa18df91f0070edd953`

## Result

```text
EXECUTOR_RESULT=PASS_CANDIDATE_G3S4M_READ_ONLY_PREFLIGHT
STRIPE_TEST_READINESS=NOT_READY
WEBHOOK_TEST_CHANNEL=NOT_ESTABLISHED
STRIPE_TEST_PAYMENT_OR_REFUND=NOT_STARTED
PLUGIN_OR_PAYMENT_CONFIGURATION_WRITE=0
DATABASE_OR_ORDER_WRITE=0
BACKUP_OR_RESTORE=0
DEPLOYMENT_OR_VPS_ACCESS=0
STOP_AT_REVIEWER=YES
```

This is a read-only readiness result, not Stripe TEST acceptance. The Owner's earlier local WordPress login is `OWNER_REPORTED_SUCCESS` per the current Reviewer handoff; no browser session was inspected or controlled in this round. The Reviewer-required private credential rotation remains `UNVERIFIED`. The separate G3S4M Owner authorization for payment/provider writes remains pending; the request for this round was read-only only.

## Local target and runtime

Direct local readback on the Owner's Windows 11 host (PowerShell 7.6.5), Docker Desktop context `desktop-linux`, engine `29.7.2`, Compose project `birthday-magazine-g3c`:

| Service | Container ID (short) | State | Image / exposure |
| --- | --- | --- | --- |
| WordPress | `21892d72baeb` | running | `wordpress:7.1.1-php8.3-apache`; only `127.0.0.1:8189 -> 80/tcp` |
| WP-CLI | `de9742647e06` | running | `wordpress:cli-php8.3`; no host port |
| MariaDB | `361d58eb5454` | running, healthy | `mariadb:11.4.7`; no host port |
| Mailpit | `35d286e7af50` | exited (0) | no host port |

WordPress core is 7.1.1; both `home` and `siteurl` resolve to the authorized loopback site, whose read-only GET returned HTTP 200. WooCommerce 11.1.2 is active. Product #1113 is published, simple, virtual, USD 39.99. A non-PII order-count query returned 1. No order identifiers, customer records, or payment payloads were read.

The existing Compose working directory and all four read-only source binds (including the shared `.htaccess`) resolve to the expected local project sources for both WordPress and WP-CLI. Corresponding mounts are read-only and the two containers resolve each bind to the same host source. The accepted G3S4R comparison of 44 source files to PR tree `7397dd3bb7ab5fe62bb8575185d51405391f2c63` is reused, not repeated. GitHub comparison from that baseline to current PR head `4591fb5b6ccb07720771aaa18df91f0070edd953` contains only the prior G3S4AR/G3S4R evidence files; no product/source file changed in that interval.

The local worktree remains dirty exactly as last recorded by G3S4R: 3 modified, 17 deleted, 180 untracked (200 entries total). All pre-existing work is retained. No local path was staged, cleaned, or modified.

## Retained backup compatibility readback

Only the three already selected backup files were checked for presence, byte size, and SHA-256; no backup was created, opened, extracted, imported, or restored. All match the prior G3S4R retained values. The containing directory DACL is protected, has no unexpected identity or deny entry, and is not a reparse point.

| Retained file | Bytes | SHA-256 | Readback |
| --- | ---: | --- | --- |
| `wordpress-db-final-r1.sql` | 9,804,037 | `EA2114F00DF992556979991C205B22ACD97514954E74305EF215609345C9361B` | match |
| `wordpress-root-consistent-r1.tar.gz` | 127,422,362 | `C01CDB81FE59052B6C31BC8979B3D9E2F307E8490B3A6EC9A73E6712A1B547D3` | match |
| `g3c-bind-source-r1.tar.gz` | 23,741,093 | `45B00A576FA3147452826A042C6C33BE35F3BF8A336EF761429A493168D5B35D` | match |

The prior isolated restore evidence remains the source for compatibility (58 tables, 18,109 files, 387 uploads); this round did not repeat it. Backup contents were not read.

## Stripe TEST configuration and webhook feasibility

- Official `woocommerce-gateway-stripe` 11.1.0 is installed but **inactive**. No Stripe-named WordPress option exists, the `woocommerce_stripe_settings` row is absent, and the saved gateway ordering has no Stripe entry. Only names and non-secret boolean predicates were used; no key, token, account secret, or secret-bearing environment value was read or emitted.
- No Woo Stripe webhook hook was registered. The only Stripe-named REST route observed belongs to the WPForms setup wizard, not Woo Stripe. A read-only GET to local `/?wc-api=wc_stripe` returned HTTP 400 from `127.0.0.1`; this was not a signed webhook request and does not establish webhook acceptance.
- Stripe CLI, ngrok, and cloudflared executables were not present on the local host. Stripe cannot directly deliver a provider webhook to a private loopback address. **An additional Owner-approved secure TEST forwarding channel is required** before signed first-delivery/replay/invalid-signature verification; no public tunnel was opened or proposed for this round.
- No Stripe account status, connection, OAuth consent, TEST/Live API key, webhook signing secret, or provider endpoint was queried.

## Live-payment and automatic-fulfillment risk

No active Stripe route or Stripe settings were detected, so no current Stripe Live payment path was observed. The installed Stripe plugin remains inactive. No installed/active PayPal or WooPayments plugin was found; existing non-Stripe gateway-order entries, if any, were left untouched and are not treated as proof of provider enablement.

The active local commerce proof plugin reports `BMS_G3A_LOCAL_ONLY=true` and `BMS_G3A_GENERATION_ENABLED=false`. Its inspected source describes generation as absent and blocks generation scheduling while that flag is false. No pending Action Scheduler/cron hook matched Stripe, payment, webhook, entitlement, or magazine-generation patterns. One pending `wc-admin_process_pending_orders_batch` action maps to WooCommerce Admin's `OrdersScheduler::process_pending_batch` analytics import, not payment or magazine fulfillment. Generation/model counter options and `woocommerce_auto_complete_order` are absent, not asserted as zero/false. No checkout or order-status transition was triggered. WooCommerce's behavior for a paid virtual test product and any downstream status hooks therefore remains unexercised and must be contained in any later approved test.

## Boundary and Reviewer stop

This round used the existing local Windows/Docker target only. No old or replacement VPS address/configuration, browser automation, plugin activation, Stripe/provider access, checkout, payment, webhook POST/signature, replay, refund, PayPal change, DB mutation, order/status mutation, source change, backup restore, deployment, or PR merge occurred.

**Technical blocker:** a safe signed-webhook channel is not presently established. Before any later TEST write, the Gate's fresh Owner payment-write authorization and private credential-rotation confirmation remain required. Keep the test isolated; do not substitute Live, a public tunnel, or another unreviewed route.

`STOP_AT_REVIEWER=YES`.


---

## G3S4M continuation — Woo Stripe 11.1.0 / Stripe CLI local forwarding compatibility

Date: 2026-10-17  
Scope: version-specific source and official-document review, plus reversible offline Stripe CLI staging only. The previously accepted runtime, product, backup, source-bind, and dirty-worktree evidence is reused; those checks were not repeated.

### Installed plugin source and compatibility

```text
INSTALLED_PLUGIN_HEADER_VERSION=11.1.0
LOCAL_WEBHOOK_HANDLER_SHA256=e6b1e29d6a5dc6db95d6c8ec059ab329b84b3be19be5f176249ac7079edea7a8
NATIVE_WEBHOOK_ROUTE=woocommerce_api_wc_stripe -> ?wc-api=wc_stripe
TEST_SIGNING_SECRET_SETTING=test_webhook_secret
E2E_SIGNATURE_BYPASS_FLAG=E2E_TESTING
E2E_SIGNATURE_BYPASS_FLAG_STATE=UNSET
PLUGIN_SOURCE_OR_SETTINGS_CHANGED=NO
```

A source-only read of the installed plugin confirmed that the webhook handler chooses `test_webhook_secret` when Woo Stripe Test mode is active, registers `woocommerce_api_wc_stripe`, accepts POST requests to `?wc-api=wc_stripe`, validates the raw request body against `Stripe-Signature` using HMAC-SHA256, and only then dispatches the event. The installed settings source exposes a password-type Test Webhook Secret field. The installed handler has an `E2E_TESTING=true` test-only signature bypass; the non-secret environment flag is currently **unset**, so that bypass is not active. No request was sent.

Stripe CLI's `listen --forward-to` returns its own listener signing secret for the local application. This matches the plugin's supported Test Webhook Secret input and verification code without a source patch or weakened signature check. The local Woo endpoint path is the one Woo documents. Therefore **local transport/signature compatibility is PASS_CANDIDATE**, conditional on a later authorized Owner-only Test configuration using the same Stripe Test account for the Woo Test API keys and CLI listener, and privately entering the CLI listener secret in the Test Webhook Secret field.

The standard Woo OAuth connection path is a separate limitation: Woo documents automatic webhook registration on connection and states that a local or non-HTTPS/unreachable site can prevent the connection. Its automatically configured provider endpoint is an HTTPS site URL, not loopback. This round did not attempt OAuth. The plugin also retains manual API-key/Test Webhook Secret settings, but current Woo guidance favors/requires OAuth re-authentication for merchants; use of manual Test keys on this loopback test target remains a Reviewer decision, not an executed account connection or proof of supported production account onboarding.

Version 11.1.0 release notes include a fix for dropped/double-processed webhooks and skipped pre-order handling when checkout/webhook requests race for the order-payment lock. This is source/release-level evidence only: no authentic event, duplicate/replay, order correlation, entitlement, or refund was run; runtime idempotency remains unverified and must still be exercised in any later authorized TEST phase.

### Official Stripe CLI staging

```text
CLI_RELEASE=v1.53.1
CLI_PLATFORM=Windows x86_64
CLI_PRIVATE_PATH=<LOCALAPPDATA>\BirthdayMagazineStudio\Tools\StripeCLI\1.53.1
RELEASE_SOURCE=https://github.com/stripe/stripe-cli/releases/tag/v1.53.1
CHECKSUM_MANIFEST_SHA256=f78a0eaaac6f21e123084c22ff222d8d0d2b41b4a87425af6def74b58e4ab8c7
WINDOWS_ZIP_SHA256=fa159ae2774d62dcfd0db8f7f8675e3274223ae3e92fae4d182f4c9cfb58fa23
STRIPE_EXE_SHA256=8e504b941ce1fb49c9275d563143ceb0ea4261d368ae78be298e95b770a38797
VERSION_COMMAND=PASS (stripe version 1.53.1)
LISTEN_HELP=PASS (--forward-to present; offline help only)
DIRECTORY_DACL=PROTECTED; OWNER_CURRENT_USER; ALLOWED_CURRENT_USER_AND_SYSTEM; INHERITED=0; DENY=0; OTHER_IDENTITIES=0; REPARSE=0
FILES_DACL=INHERIT_ONLY_FROM_PROTECTED_PRIVATE_DIRECTORY; OTHER_IDENTITIES=0; DENY=0; REPARSE=0
GLOBAL_PATH_SERVICE_OR_PERSISTENT_CONFIG_CHANGE=NO
STRIPE_LOGIN=NOT_RUN
STRIPE_LISTENER_CONNECTION=NOT_RUN
WEBHOOK_SECRET_DISPLAY_OR_EVENT=NOT_RUN
```

The official GitHub release API's SHA-256 for the Windows checksum asset matched the downloaded manifest; the manifest's Windows x86_64 ZIP digest matched both the official release asset digest and the downloaded ZIP. The executable was extracted only inside the Owner-user-scoped private directory. Verification set `STRIPE_NO_AUTO_UPDATE=1` only in the short-lived verification process. No global PATH, service, login, account authorization, listener, tunnel, provider event, key, or signing secret was created or read.

### Current feasibility and exact remaining blockers

```text
LOCAL_STRIPE_CLI_FORWARDING_TRANSPORT=PREPARED_NOT_CONNECTED
LOCAL_WOO_TEST_SIGNATURE_ADAPTER=PASS_CANDIDATE_SOURCE_COMPATIBLE
STANDARD_WOO_OAUTH_TO_LOOPBACK=NOT_ATTEMPTED_DOCUMENTED_REACHABILITY_BLOCKER
WOO_TEST_ACCOUNT_CONNECTION=NOT_DONE
PLUGIN_ACTIVATION_OR_PAYMENT_SETTINGS_WRITE=0
PAYMENT_WEBHOOK_REFUND=NOT_STARTED
PUBLIC_INGRESS_OR_VPS=0
FRESH_G3S4M_TEST_WRITE_AUTH=STILL_REQUIRED_FOR_ANY_PROVIDER_OR_WOO_WRITE
OWNER_PRIVATE_CREDENTIAL_ROTATION=UNVERIFIED
STOP_AT_REVIEWER=YES
```

Next decision: Reviewer should confirm whether the existing Gate may use the plugin's manual Test-key + CLI-listener-secret path on the private loopback site, or requires a separate Owner-controlled HTTPS test target for standard OAuth/webhook provisioning. Only after that decision, the Gate's fresh TEST-write authorization, private credential-rotation checkpoint, and Owner-only authentication may any plugin/account/Test payment or webhook write begin. The CLI is staged and ready for that later bounded step; this Evidence does not claim end-to-end Stripe readiness.

### Official references

- [Stripe CLI local listener and listener signing secret](https://docs.stripe.com/cli/listen)
- [Stripe CLI installation and auto-update note](https://docs.stripe.com/cli/install)
- [Official Stripe CLI v1.53.1 release](https://github.com/stripe/stripe-cli/releases/tag/v1.53.1)
- [WooCommerce Stripe 11.1.0 webhook handler source](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/class-wc-stripe-webhook-handler.php)
- [WooCommerce Stripe 11.1.0 settings source](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/admin/stripe-settings.php)
- [WooCommerce Stripe webhook setup and endpoint](https://woocommerce.com/document/stripe/setup-and-configuration/stripe-webhooks/)
- [WooCommerce Stripe account connection requirements](https://woocommerce.com/document/stripe/setup-and-configuration/connecting-to-stripe/)
- [WooCommerce Stripe 11.1.0 release notes](https://github.com/woocommerce/woocommerce-gateway-stripe/releases/tag/11.1.0)


---

## G3S4M continuation — supported local TEST UI and CLI signing-secret blocker

Date: 2026-10-17  
Scope: version-pinned review of WooCommerce Stripe 11.1.0's actual admin rendering, Test OAuth, webhook configuration, and the existing local plugin activation. No Stripe account/provider operation was initiated.

### Owner checkpoint and recorded direction

```text
OWNER_PRIVATE_WP_PASSWORD_ROTATION=UNCONFIRMED
OWNER_INSTRUCTION=DO_NOT_TREAT_ROTATION_AS_BLOCKER (2026-10-17)
ROTATION_PREWRITE_GATE=UNCONFIRMED; OWNER_DIRECTION_RECORDED_FOR_REVIEW
PLUGIN_ACTIVATION=PERFORMED_AFTER_OWNER_DIRECTION
STRIPE_ACCOUNT_AUTH_OR_KEY_WRITE=0
PAYMENT_OR_WEBHOOK_OR_REFUND=0
PUBLIC_TUNNEL_OR_VPS=0
```

The Owner directed the Executor to proceed without requiring the private password-rotation confirmation. The rotation remains unconfirmed and is not claimed as complete. The official plugin was activated under that direction; Reviewer should assess the unresolved checkpoint against the existing Gate.

### Actual official Test UI and side effects

Reviewed the official `woocommerce-gateway-stripe` 11.1.0 source at its version tag:

- The normal unconnected gateway admin page calls `render_upe_settings()`, hides the classic save button and renders the React settings container. The legacy PHP schema contains Test/Live credential fields, but the standard unconnected page does not expose them as an ordinary manual-key form. [Admin rendering](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/abstracts/abstract-wc-stripe-payment-gateway.php) · [legacy field schema](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/admin/stripe-settings.php)
- The official React account modal has separate Live and Test tabs. Its Test control is “Create or connect a test account” and redirects through the plugin's `wc_stripe_get_oauth_url` OAuth flow with `mode=test`. The Test mode switch remains locked until the Test OAuth account is connected. The source-level HTTPS check applies to Live, not Test; local OAuth return behavior was not attempted. [Account modal](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/client/settings/payment-settings/account-keys-modal.js) · [Connect button](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/client/settings/stripe-auth-account/connect-button.js) · [Test mode switch](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/client/settings/payment-settings/test-mode-checkbox.js) · [OAuth handler](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/connect/class-wc-stripe-connect.php)
- The normal Test account UI does not expose an editable Test Webhook Secret field. Its Test “Configure webhooks” control calls the plugin's configure-webhooks action with the Test mode and account secret, which creates/configures a Stripe-side endpoint and stores the returned secret. This is a provider write and would target the configured site endpoint, not Stripe CLI's local listener secret. It was not clicked or called. [Webhook UI](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/client/settings/stripe-auth-account/configure-webhook-button.js) · [key controller](https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/admin/class-wc-rest-stripe-account-keys-controller.php)
- Stripe CLI local forwarding produces a listener signing secret that must match Woo Stripe's Test Webhook Secret for signature verification. The normal unconnected UI has no supported control to enter that listener secret. Direct REST/controller, SQL, WP option, custom source, and signature-bypass routes are excluded by the existing Reviewer decision.

**Precise result:** official Test OAuth UI exists, but the supported local manual Test Webhook Secret entry needed to pair the private loopback Woo handler with Stripe CLI is unavailable. Clicking “Configure webhooks” instead would make a Stripe-side endpoint write and would not install the CLI listener's signing secret. Therefore this local signed-CLI path cannot satisfy the Gate through the currently rendered supported UI. Stop with `RETURN_MANUAL_TEST_UI_UNAVAILABLE`; do not connect the account, configure a provider webhook, or run checkout/refund until Reviewer selects a supported route.

### Narrow local readback and activation record

Existing accepted target, runtime, and backup evidence was reused. No backup, restore, deployment, broad host scan, or browser automation was repeated.

```text
TARGET=EXISTING_LOCAL_WPCLI_CONTAINER (de9742647e06)
PLUGIN_STATUS_BEFORE=inactive
PLUGIN_STATUS_AFTER=active
STRIPE_OPTION_NAMES_AFTER_ACTIVATION=NONE (woocommerce_stripe*, wc_stripe*)
PREEXISTING_WC_INBOX_VARIANT_OPTION=present_before_activation
ACTIVATION_SOURCE_EFFECT=30-second settings-page redirect transient
STRIPE_LIVE_OR_TEST_KEYS_READ=NO
STRIPE_LIVE_OR_TEST_KEYS_WRITTEN=NO
GATEWAY_ENABLED_OR_MODE_SAVED=NO
```

The pre-activation option-name queries returned no `woocommerce_stripe*` or `wc_stripe*` setting. The existing `woocommerce_inbox_variant_assignment` option was present before activation, so the activation hook's conditional variant write was not needed. The official plugin activation command succeeded; post-activation status is `active`, while both Stripe option-name queries remain empty. Source defaults are gateway `enabled=no` and Test mode `yes` when the Woo settings API first constructs defaults; no setting was saved. The plugin's activation redirect transient is short-lived. No Live payment route or saved Stripe credentials were observed.

### Final execution state for this attempt

```text
OFFICIAL_PLUGIN_ACTIVATION=PASS
NORMAL_TEST_ACCOUNT_UI=OAUTH_AVAILABLE_SOURCE_CONFIRMED
LOCAL_CLI_TEST_WEBHOOK_SECRET_INPUT_UI=UNAVAILABLE
TEST_ACCOUNT_CONNECTION=NOT_STARTED
STRIPE_CLI_LOGIN_OR_LISTENER=NOT_STARTED
TEST_ORDER_1113_USD_39_99=NOT_STARTED
SIGNED_WEBHOOK_FIRST_REPLAY_INVALID=NOT_STARTED
TEST_REFUND_AND_ENTITLEMENT_REVOCATION=NOT_STARTED
LIVE_CONFIGURATION_OR_REAL_PAYMENT=0
PROVIDER_OR_BROWSER_ACTION=0
EXECUTOR_RESULT=RETURN_MANUAL_TEST_UI_UNAVAILABLE
NEXT=REVIEWER_SELECTS_A_SUPPORTED_LOCAL_TEST_WEBHOOK_SECRET_ROUTE_OR_SEPARATE_ISOLATED_HTTPS_TEST_TARGET
STOP_AT_REVIEWER=YES
```

No credentials, account identifier, secret, session, raw provider payload, or customer data was read or written. No Stripe CLI login/listener, OAuth, provider webhook, payment, order, refund, entitlement, or source change occurred. Keep the current plugin installed and active with the gateway disabled; do not use a public tunnel, Live, VPS, direct REST/option write, or signature bypass.
