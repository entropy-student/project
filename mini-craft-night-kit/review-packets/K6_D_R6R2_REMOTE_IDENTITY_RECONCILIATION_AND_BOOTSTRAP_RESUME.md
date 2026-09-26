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

At remote payload start, before any sudo and before any sudo-owned wrapper/subshell/helper:
- `whoami`
- `id -un`
- `id -u`
- `hostname`

Run these directly as the authenticated SSH session. Never prefix them with sudo and never derive login identity by looking up UID 0.

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

Only after bootstrap PASS.

Credential boundary:
- use `db-app-password` only through the already-reviewed tmpfs-only MariaDB client option-file pattern;
- no Secret in argv, env, stdout/stderr, logs, Evidence or host plaintext temp files;
- verify tmpfs client option file absent after the bounded DB operation.

Prewrite:
1. lock/select exactly the two `wp_options` rows `home` and `siteurl`;
2. require exact cardinality = 2;
3. accepted pre-state:
   - both = `http://localhost:8093`; or
   - both already = `https://minicraft.spikersun.com`.
4. mixed/unexpected pre-state -> `RETURN_REVIEWER_D_R6R2_ORIGIN_STATE_DRIFT` before write.

If both already equal target:
- no DB write;
- record `HOME_SITEURL_SCALAR_UPDATE=ALREADY_TARGET_NO_WRITE`.

Otherwise:
- begin one DB transaction;
- update only the exact `home` and `siteurl` rows to `https://minicraft.spikersun.com`;
- verify exactly two intended rows and exact target values before commit;
- commit only after verification;
- any pre-commit mismatch/native failure -> rollback and RETURN.

No broad SQL replacement.
No serialized-field mutation.
No full serialized migration.

Record:
`FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`

## Phase E — private app validation

Using private/in-container/Docker-network access only. Do not require public DNS/HTTPS to be live and do not follow redirects to the public Internet.

Probe:
- /
- /shop/
- /product/mini-craft-night-kit/
- /cart/
- /checkout/
- /my-account/
- /wp-json/

Use the canonical Host header where needed. A bounded 2xx response or an expected 3xx canonical redirect to `https://minicraft.spikersun.com` is acceptable for private-route reachability when there is no installer redirect, PHP fatal, or unexpected external target. Record status/redirect class rather than fetching the public destination.
- wp-content/media state;
- WooCommerce core state;
- PayPal Sandbox / Live disabled boolean/config-state metadata only; never emit credential-bearing option contents;
- recent filtered PHP fatal classification;
- WordPress restart count stable;
- MariaDB healthy;
- unrelated services unchanged.

## SSH scope

One fresh canonical strict SSH invocation/session is authorized for the entire Gate.

Capture SSH stderr only in a local non-secret temporary diagnostic sink for bounded classification; raw stderr must not be committed and the local sink must be removed within the same wrapper.

If the connection fails before any DB write:
- return precise transport classification;
- no second attempt inside this Gate.

If the SSH outcome becomes ambiguous after the scalar DB transaction may have started or committed:
- return `RETURN_REVIEWER_D_R6R2_REMOTE_WRITE_OUTCOME_AMBIGUOUS`;
- do not retry;
- do not compensate;
- leave read-only reconciliation to the next Reviewer Gate.

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
- following private-route redirects out to the public Internet;
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
HOME_SITEURL_ROW_CARDINALITY=
HOME_SITEURL_PRESTATE=
HOME_SITEURL_SCALAR_UPDATE=
HOME_SITEURL_TRANSACTION=
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
LOCAL_SSH_DIAGNOSTIC_TEMP_CLEANUP=
REMOTE_TMPFS_DB_AUTH_CLEANUP=
STOP_AT_REVIEWER=YES
```

## Return

Success:
`PASS_CANDIDATE_K6_PHASE_D_R6R2_REMOTE_IDENTITY_RECONCILIATION_AND_BOOTSTRAP_RESUME`

Otherwise precise `RETURN_*`.

Do not enter full serialized migration or public ingress.
