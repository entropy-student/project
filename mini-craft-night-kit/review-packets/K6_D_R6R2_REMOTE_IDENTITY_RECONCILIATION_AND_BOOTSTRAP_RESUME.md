# K6 D-R6R2 — Remote Identity Reconciliation + Bootstrap Resume

Gate:
`K6_PHASE_D_R6R2_REMOTE_IDENTITY_RECONCILIATION_AND_BOOTSTRAP_RESUME`

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_D_R6R1_RETURN_D_R6R2_IDENTITY_RECONCILIATION_AND_RESUME.md`;
- prior D-R6 decision/pack;
- latest Evidence/Handoff;
- unique current Shared VPS Handoff.

## Objective

Correctly prove the effective SSH login identity before sudo, then resume the already-authorized D-R6 bootstrap/private-app validation in the same canonical SSH session.

## Phase A — pre-sudo identity proof

Use the existing strict SSH contract only.

At remote payload start, before any sudo:
- `whoami`
- `id -un`
- `id -u`
- `hostname`

Require:
- whoami = ops
- id -un = ops
- id -u != 0
- hostname = srv1970241

Do not use UID 0 lookup as a proxy for SSH login identity.

If any identity assertion fails:
`RETURN_REVIEWER_D_R6R2_REMOTE_IDENTITY_MISMATCH`

No further command after mismatch.

## Phase B — D-R6 readiness

Only after Phase A PASS:

- use `sudo -n` only where already required;
- WordPress + MariaDB running;
- no host ports;
- WordPress restart count stable;
- runtime core present;
- MariaDB healthy;
- root/app exact 52-table set;
- wp_options present;
- unrelated shared baseline unchanged;
- no public Mini Craft ingress.

Material drift -> RETURN.

## Phase C — bootstrap + installed state

Run bounded private WordPress bootstrap.

Prove:
- bootstrap completes;
- installed-state true;
- no PHP fatal.

Output only status/boolean metadata.

If bootstrap fails with core present:
`RETURN_REVIEWER_D_R6R2_BOOTSTRAP_FAILED`

Do not recreate/restart.

## Phase D — exact scalar update

Only after bootstrap PASS:
- update wp_options home;
- update wp_options siteurl;
- target = `https://minicraft.spikersun.com`.

Exact predicates only.
No broad SQL replacement.
No serialized migration.

Record:
`FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`

## Phase E — private app validation

Using private/in-container/Docker-network access only:

- /
- /shop/
- /product/mini-craft-night-kit/
- /cart/
- /checkout/
- /my-account/
- /wp-json/
- wp-content/media state;
- WooCommerce core state;
- PayPal Sandbox / Live disabled metadata state;
- recent filtered PHP fatal classification;
- WordPress restart count stable;
- MariaDB healthy;
- unrelated services unchanged.

## SSH scope

One fresh canonical strict SSH invocation/session is authorized for the entire Gate.

If the connection itself fails:
- return precise transport classification;
- no second attempt inside this Gate.

## Forbidden

No:
- alternate SSH account/key/trust;
- WordPress recreate/restart;
- DB import/reset/drop/recreate;
- wp-content restore;
- image pull/build;
- broad SQL replace;
- serialized migration;
- Shared Infra/DNS/public ingress mutation;
- host ports;
- Secret content/hash/rotation/overwrite;
- PayPal Live/payment/refund.

## RETURN rule

Any RETURN -> stop immediately.
No post-return lifecycle cleanup.

## Evidence markers

```text
SSH_NATIVE_EXIT=
SSH_HOST_KEY_MATCH=
REMOTE_PRE_SUDO_WHOAMI=
REMOTE_PRE_SUDO_ID_UN=
REMOTE_PRE_SUDO_UID_NONZERO=
REMOTE_HOSTNAME=
D_R6_READINESS=
ROOT_TABLE_COUNT=
APP_TABLE_COUNT=
WP_OPTIONS_PRESENT=
WORDPRESS_RUNTIME_CORE=
WORDPRESS_BOOTSTRAP=
WORDPRESS_INSTALLED_STATE=
HOME_SITEURL_SCALAR_UPDATE=
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_PRIVATE_PRIMARY_ROUTES=
WP_CONTENT_MEDIA_STATE=
WOOCOMMERCE_CORE_STATE=
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO
WORDPRESS_RECENT_FATALS=
WORDPRESS_RESTART_COUNT=
DB_PUBLIC_PORT=NONE
WORDPRESS_HOST_PORT=NONE
PUBLIC_INGRESS_CHANGE=0
UNRELATED_SERVICES_CHANGED=
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

## Return

Success:
`PASS_CANDIDATE_K6_PHASE_D_R6R2_REMOTE_IDENTITY_RECONCILIATION_AND_BOOTSTRAP_RESUME`

Otherwise precise `RETURN_*`.

Do not enter full serialized migration or public ingress.
