# Reviewer Decision — K6 D-R6R2 RETURN Accepted; D-R6R3 Private App Validation Reconciliation

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed result

```text
GATE=K6_PHASE_D_R6R2_REMOTE_IDENTITY_RECONCILIATION_AND_BOOTSTRAP_RESUME
RESULT=RETURN_REVIEWER_D_R6R2_PRIVATE_APP_VALIDATION_FAILED
EXECUTOR_FINAL_COMMIT=a4ce9660bd1f20a0b5f59b2b785a3ede9250a032
```

Reviewer accepts the RETURN as correct and fail-closed.

The RETURN does **not** invalidate the successfully completed D-R6R2 sub-results.

## Accepted D-R6R2 facts

The following are formally accepted and must not be rerun unless fresh read-only preflight finds material drift:

```text
SSH_NATIVE_EXIT=0
SSH_HOST_KEY_MATCH=YES
REMOTE_PRE_SUDO_WHOAMI=ops
REMOTE_PRE_SUDO_ID_UN=ops
REMOTE_PRE_SUDO_UID_NONZERO=YES
REMOTE_HOSTNAME=srv1970241
D_R6_READINESS=PASS
ROOT_TABLE_COUNT=52
ROOT_TABLE_SET_MATCH=YES
APP_TABLE_COUNT=52
APP_TABLE_SET_MATCH=YES
WP_OPTIONS_PRESENT=YES
WORDPRESS_RUNTIME_CORE=PASS
WORDPRESS_BOOTSTRAP=PASS
WORDPRESS_INSTALLED_STATE=YES
HOME_SITEURL_ROW_CARDINALITY=2
HOME_SITEURL_PRESTATE=LOCALHOST_BOTH
HOME_SITEURL_SCALAR_UPDATE=COMMITTED_EXACTLY_TWO_ROWS
HOME_SITEURL_TRANSACTION=COMMITTED_AND_POSTREAD_VERIFIED
HOME=https://minicraft.spikersun.com
SITEURL=https://minicraft.spikersun.com
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WP_CONTENT_MEDIA_STATE=PASS
WOOCOMMERCE_CORE_STATE=PASS
WORDPRESS_RECENT_FATALS=0
WORDPRESS_RESTART_COUNT=0
MARIADB_HEALTH=HEALTHY
DB_PUBLIC_PORT=NONE
WORDPRESS_HOST_PORT=NONE
PUBLIC_INGRESS_CHANGE=0
UNRELATED_SERVICES_CHANGED=NO
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
```

The only unresolved acceptance points are:

1. Checkout returned 302 but D-R6R2 did not retain the redacted redirect target, so the expected empty-cart-to-Cart behavior was not proven in that Gate.
2. PPCP is active, but the ad-hoc bounded setting probe did not establish Sandbox mode and therefore could not prove Live-disabled state.

## Historical accepted facts relevant to reconciliation

Accepted project evidence already establishes:

- K4/K5 repeatedly observed an anonymous **empty-cart Checkout 302 redirect to Cart** and classified it as expected behavior.
- K5 populated Cart → Checkout smoke returned 200.
- K3R9 accepted PPCP state: merchant connected YES, Sandbox YES, onboarding completed YES.
- K3R11 accepted Sandbox mode enabled and healthy client-token/webhook readiness.
- K3 Payment PASS accepted exactly one Sandbox payment/capture/webhook flow with `PAYPAL_LIVE_ENABLED=NO`.
- K5 Release Candidate PASS carried forward that PPCP was active/connected in Sandbox and Live was off.
- No accepted later Gate authorizes PPCP environment change, provider reconnect, or Live enablement.
- The current VPS MariaDB was restored from the accepted K5 SQL source and the exact expected table set is present.

Historical PASS remains accepted absent material drift. The failed D-R6R2 generic mode probe is **not** evidence of a mode change; it is only an inability of that probe to establish the state.

## Current Gate

```text
CURRENT_GATE=K6_PHASE_D_R6R3_PRIVATE_APP_VALIDATION_RECONCILIATION
OWNER_ACTION=NONE
```

This is a narrow read-only reconciliation Gate. No application/config/database write is authorized.

## Phase A — bounded fresh continuity preflight

Use the existing canonical strict SSH contract.

Perform only the minimum fresh dynamic checks necessary before relying on the accepted D-R6R2 baseline:

- pre-sudo identity = ops@srv1970241;
- WordPress running, restart count unchanged/stable;
- MariaDB running/healthy;
- no host-published WordPress/DB ports;
- runtime core still present;
- `home` and `siteurl` both still equal `https://minicraft.spikersun.com` by exact read-only query;
- no public Mini Craft ingress introduced;
- no unrelated/shared-infra material drift.

Do not repeat the 52-table inventory, bootstrap test, wp-content restore validation or WooCommerce core validation unless a fresh check above reveals material drift.

## Phase B — Checkout 302 reconciliation

Use one private/in-container request with **no existing cart/session mutation**.

Requirements:

1. no add-to-cart;
2. no order/payment action;
3. do not follow redirects;
4. request the current canonical Checkout route privately;
5. retain only:
   - HTTP status;
   - redacted/safe redirect scheme+host+path or relative path;
6. never retain cookies/session IDs/order keys.

Accepted outcomes:

- Checkout returns 200 -> PASS;
- Checkout returns 302/301/303/307/308 and redirect target is:
  - relative `/cart/` or equivalent WooCommerce Cart route; or
  - same canonical origin `https://minicraft.spikersun.com/...cart...`;
  then classify:
  `CHECKOUT_EMPTY_CART_BEHAVIOR=PASS_EXPECTED_CART_REDIRECT`.

Do **not** require a populated checkout in this Gate; populated Checkout 200 was already accepted in K4/K5 and there has been no checkout configuration mutation proven after that baseline.

If redirect target is installer/admin/login/unexpected external origin or cannot be safely classified:
`RETURN_REVIEWER_D_R6R3_CHECKOUT_REDIRECT_UNRESOLVED`

## Phase C — PPCP Sandbox-state reconciliation

Do not invent another generic option-key probe.

First reuse the exact read-only PPCP state path/method that produced the accepted K3R9/K3R11 evidence where practical.

Target metadata only:

```text
PPCP_ACTIVE
PPCP_MERCHANT_CONNECTED
PPCP_SANDBOX_ENABLED
PPCP_ONBOARDING_COMPLETED
PPCP_LIVE_ENABLED
```

Rules:

1. no Provider call/payment/capture/refund;
2. no reconnect/onboarding mutation;
3. no PPCP settings write;
4. no credential output/hash;
5. no raw settings/options dump;
6. if the historical helper/path is unavailable, inspect the installed PPCP 4.1.3 source **read-only** to identify the authoritative environment/state getter used by the plugin, then query only the needed boolean/state metadata;
7. if a returned structure contains credential-bearing fields, filter in memory and emit only the allowlisted booleans above;
8. do not infer Sandbox merely from plugin activation.

PASS target:

```text
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_ONBOARDING_COMPLETED=YES
PPCP_LIVE_ENABLED=NO
```

If the authoritative current read-back proves a real material difference from the accepted K5 state:
`RETURN_REVIEWER_D_R6R3_PPCP_STATE_DRIFT`

If the state cannot be established without accessing credential values or mutating Provider/plugin state:
`RETURN_REVIEWER_D_R6R3_PPCP_MODE_READBACK_UNAVAILABLE`

Do not "fix" or reconnect PPCP in this Gate.

## Phase D — private validation closure

If Phase A/B/C all PASS:

```text
WORDPRESS_PRIVATE_APP_VALIDATION=PASS
D_R6_PRIVATE_RUNTIME_VALIDATION=PASS
PAYPAL_SANDBOX_LOCAL_CONFIG_STATE=PASS
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
PUBLIC_INGRESS_CHANGE=0
PAYPAL_LIVE=NO
PAYMENT_ACTIONS=0
```

Do not enter serialized URL migration in the same Gate.

## Hard boundaries

No:
- DB write of any kind;
- `home` / `siteurl` rewrite;
- WordPress/MariaDB restart/recreate;
- DB import/reset/drop/recreate;
- wp-content restore;
- image pull/build;
- cart/session mutation solely to force Checkout 200;
- order/payment/capture/refund;
- PPCP connect/reconnect/onboarding/settings mutation;
- Secret value/hash output;
- serialized URL migration;
- Caddy/cloudflared/DNS/UFW/shared-network mutation;
- public ingress;
- unrelated project changes.

## RETURN semantics

Any RETURN -> stop immediately.
No post-return remote cleanup/lifecycle action.

## Success contract

```text
PASS_CANDIDATE_K6_PHASE_D_R6R3_PRIVATE_APP_VALIDATION_RECONCILIATION
REMOTE_IDENTITY=ops@srv1970241
WORDPRESS_RUNTIME_CONTINUITY=PASS
MARIADB_HEALTH=PASS
HOME_SITEURL_READBACK=PASS_TARGET
CHECKOUT_PRIVATE_STATUS=<2XX_OR_EXPECTED_3XX>
CHECKOUT_REDIRECT_TARGET=<NONE_OR_SAFE_REDACTED_CART_TARGET>
CHECKOUT_EMPTY_CART_BEHAVIOR=PASS
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_ONBOARDING_COMPLETED=YES
PPCP_LIVE_ENABLED=NO
WORDPRESS_PRIVATE_APP_VALIDATION=PASS
D_R6_PRIVATE_RUNTIME_VALIDATION=PASS
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
DB_WRITES=0
WORDPRESS_RESTART_RECREATE=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

A PASS_CANDIDATE does not authorize full serialized migration, public ingress, PayPal Live or real payment.
