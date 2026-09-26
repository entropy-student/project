# K6 D-R6R3 — Private App Validation Reconciliation Execution Pack

Gate:
`K6_PHASE_D_R6R3_PRIVATE_APP_VALIDATION_RECONCILIATION`

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_D_R6R2_RETURN_D_R6R3_PRIVATE_APP_VALIDATION_RECONCILIATION.md`;
- latest accepted `EXECUTION_EVIDENCE.md`;
- latest `EXECUTOR_HANDOFF.md`;
- unique current Shared VPS Handoff;
- accepted K3/K4/K5 PayPal Sandbox / Checkout evidence.

## Objective

Close only the two unresolved D-R6R2 private-validation questions:

1. classify current empty-cart Checkout 302 using its safe redirect target;
2. prove current PPCP local configuration is still Sandbox with Live disabled through an authoritative read-only state path.

No application/database/configuration write is authorized.

## Accepted carry-forward facts

Do not rerun unless fresh preflight finds material drift:

- SSH/host-key/remote identity PASS;
- D-R6 readiness PASS;
- MariaDB exact 52-table root/app set PASS;
- WordPress bootstrap + installed state PASS;
- `home` / `siteurl` exact two-row transaction PASS;
- both scalar origins now target `https://minicraft.spikersun.com`;
- wp-content/media PASS;
- WooCommerce core PASS;
- six private primary routes returned 200;
- WordPress recent fatal count 0;
- restart count 0/stable;
- no public WordPress or DB host port;
- no public Mini Craft ingress;
- no payment/Live action.

## Phase A — minimal continuity preflight

One canonical strict SSH invocation/session is authorized.

Before sudo:
- `whoami=ops`
- `id -un=ops`
- UID nonzero
- `hostname=srv1970241`

Then minimal dynamic read-only checks:
- WordPress running;
- MariaDB running/healthy;
- WordPress restart count stable;
- runtime core present;
- no host ports;
- exact read-only `home/siteurl` = target;
- no public Mini Craft ingress;
- no unrelated/shared material drift.

Do not repeat full DB-table/bootstrap/wp-content/WooCommerce tests absent drift.

## Phase B — Checkout redirect reconciliation

Private request only.

Rules:
- do not add to cart;
- do not create/alter WooCommerce session intentionally;
- do not create order;
- do not select/click payment;
- do not follow redirect;
- do not emit Cookie/session/order-key values.

Capture only:
- HTTP status;
- redirect target reduced to safe scheme/host/path or relative path.

PASS:
- 2xx; or
- expected 3xx to WooCommerce Cart, relative or same canonical origin.

Expected project baseline:
anonymous empty-cart Checkout redirects to Cart.

If target cannot be classified safely:
`RETURN_REVIEWER_D_R6R3_CHECKOUT_REDIRECT_UNRESOLVED`.

## Phase C — authoritative PPCP state read-back

Historical accepted state:
- PPCP 4.1.3 active;
- merchant connected YES;
- Sandbox YES;
- onboarding complete YES;
- Live off;
- K3 Sandbox payment/capture/webhook PASS.

Use the same accepted K3R9/K3R11 read-only PPCP state method/path where practical.

Do not simply probe guessed WordPress option keys.

If the old helper/path is unavailable:
1. inspect the installed PPCP 4.1.3 source read-only;
2. identify the plugin's authoritative getter/service/REST state path for environment/merchant/onboarding;
3. query only required metadata;
4. filter all returned structures in memory to the allowlist below.

Only record:

```text
PPCP_ACTIVE
PPCP_MERCHANT_CONNECTED
PPCP_SANDBOX_ENABLED
PPCP_ONBOARDING_COMPLETED
PPCP_LIVE_ENABLED
```

No raw option dump.
No credential/token/client-id/client-secret/payee/provider payload output or hash.
No Provider call required.
No connect/reconnect.

PASS:
- active YES;
- connected YES;
- sandbox YES;
- onboarding YES;
- live NO.

Current authoritative drift -> `RETURN_REVIEWER_D_R6R3_PPCP_STATE_DRIFT`.

Unable to prove without Secret exposure/mutation -> `RETURN_REVIEWER_D_R6R3_PPCP_MODE_READBACK_UNAVAILABLE`.

## Phase D — closure

If A/B/C pass:
- private WordPress application validation = PASS;
- D-R6 private runtime validation = PASS;
- PayPal local Sandbox configuration state = PASS;
- serialized-safe origin migration remains deferred;
- no public ingress.

Stop at Reviewer.

## Forbidden

No:
- DB write;
- origin rewrite;
- cart/session mutation for testing;
- WordPress/MariaDB lifecycle mutation;
- DB restore/import/reset;
- wp-content rewrite/restore;
- image pull/build;
- plugin setting change;
- PPCP reconnect/onboarding;
- Provider request/payment/capture/refund;
- Secret content/hash access;
- full serialized migration;
- Shared Infra/public ingress mutation;
- unrelated project mutation.

## Evidence markers

```text
SSH_NATIVE_EXIT=
REMOTE_IDENTITY=
WORDPRESS_RUNTIME_CONTINUITY=
WORDPRESS_RESTART_COUNT=
MARIADB_HEALTH=
HOME_SITEURL_READBACK=
WORDPRESS_HOST_PORT=NONE
DB_PUBLIC_PORT=NONE
CHECKOUT_PRIVATE_STATUS=
CHECKOUT_REDIRECT_TARGET=
CHECKOUT_EMPTY_CART_BEHAVIOR=
PPCP_STATE_READ_METHOD=
PPCP_ACTIVE=
PPCP_MERCHANT_CONNECTED=
PPCP_SANDBOX_ENABLED=
PPCP_ONBOARDING_COMPLETED=
PPCP_LIVE_ENABLED=
WORDPRESS_PRIVATE_APP_VALIDATION=
D_R6_PRIVATE_RUNTIME_VALIDATION=
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
DB_WRITES=0
WORDPRESS_RESTART_RECREATE=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
LOCAL_TEMP_CLEANUP=
STOP_AT_REVIEWER=YES
```

## Return

Success:
`PASS_CANDIDATE_K6_PHASE_D_R6R3_PRIVATE_APP_VALIDATION_RECONCILIATION`

Otherwise precise `RETURN_*`.

Do not continue into serialized migration or public ingress.
