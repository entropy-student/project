# Reviewer Decision — K6 D-R5 RETURN Accepted; D-R6 Bootstrap Reconciliation + Private App Validation

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed result

```text
GATE=K6_PHASE_D_R5_WORDPRESS_CORE_RUNTIME_DIAGNOSIS_AND_CONDITIONAL_RECREATE
RESULT=RETURN_REVIEWER_D_R5_RUNTIME_CORE_PRESENT_BEFORE_RECREATE_RECONCILIATION_REQUIRED
EXECUTOR_FINAL_COMMIT=f3ae1f853ed06b892900d24afbefdbfefa9eadbb
EVIDENCE_COMMIT=53282b94d84b60a03a65c86cffed150218b49617
```

Reviewer accepts the RETURN as correct and fail-closed.

## Accepted current runtime state

Fresh read-only evidence establishes:

```text
WORDPRESS_IMAGE_DIGEST=PASS
WORDPRESS_PLATFORM=linux/amd64
WORDPRESS_ENTRYPOINT_COMMAND=PASS
WORDPRESS_TMPFS_MOUNT=PASS;512MiB
WORDPRESS_WP_CONTENT_BIND=PASS
WORDPRESS_SECRET_MOUNTS=PASS;9_OF_9_RO;DB_ROOT_NOT_MOUNTED
SOURCE_CORE_FILES=PASS
RUNTIME_CORE_FILES=PRESENT
WORDPRESS_RECREATE_COUNT=0
WORDPRESS=RUNNING;RESTARTS=0;HOST_PORTS=NONE
MARIADB=RUNNING;HEALTHY
VPS_WRITES=0
DOCKER_MUTATIONS=0
```

The D-R5 conditional recreate trigger is therefore false. Recreate is neither required nor authorized.

## Reconciliation of D-R4 vs D-R5 observations

D-R4's first WordPress bootstrap probe immediately after service start observed a missing runtime core file. D-R5 later observed the same accepted runtime contract with runtime core files present and no intervening recreate or mutation.

The evidence is most consistent with a transient startup/entrypoint initialization timing window while the official WordPress entrypoint populated the tmpfs-backed `/var/www/html`. This is a Reviewer inference, not a proven root-cause claim.

Formal disposition:

```text
D_R4_DATABASE_RESTORE=PASS_ACCEPTED
D_R5_WORDPRESS_RUNTIME_CONTRACT=PASS
WORDPRESS_RECREATE_REQUIRED=NO
WORDPRESS_RECREATE_AUTHORIZED=NO
CURRENT_GATE=K6_PHASE_D_R6_BOOTSTRAP_RECONCILIATION_AND_PRIVATE_APP_VALIDATION
OWNER_ACTION=NONE
```

## D-R6 objective

Prove that the already-running private WordPress runtime can now bootstrap against the accepted 52-table database, update only the two previously authorized scalar origin values, and validate the private application/WooCommerce state.

No rebuild/recreate/restore is needed.

## Phase A — fresh no-write readiness

Before DB write:

1. strict target identity/trust check;
2. verify WordPress and MariaDB remain running with zero host ports;
3. verify WordPress restart count remains stable;
4. verify runtime core files remain present;
5. verify MariaDB remains healthy;
6. metadata-only DB recheck:
   - root table count = 52;
   - app table count = 52;
   - expected table-set match;
   - `wp_options` exists;
7. verify no public ingress change / unrelated service drift.

Any drift -> precise RETURN.

## Phase B — bootstrap reconciliation

Run bounded private bootstrap checks without modifying DB:

1. PHP/WordPress bootstrap must successfully load the current runtime core and connect to the accepted DB;
2. emit only boolean/status metadata, not config/Secret/business content;
3. verify the site is recognized as installed, e.g. through a WordPress-native installed-state check;
4. verify no PHP fatal/bootstrap exception.

If bootstrap fails now with core present:

`RETURN_REVIEWER_D_R6_BOOTSTRAP_FAILED_WITH_CORE_PRESENT`

Do not recreate/restart/reimport.

## Phase C — scalar origin update

Only after bootstrap PASS:

Update exactly two scalar rows in `wp_options`:

- `home`
- `siteurl`

to:

`https://minicraft.spikersun.com`

Requirements:
- exact option-name predicates;
- no broad SQL search/replace;
- no serialized-field modification;
- verify exactly the intended option rows have the target scalar values;
- do not emit unrelated option contents.

Record:

`FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`

## Phase D — private application validation

Using only private/internal Docker-network or in-container access, with no host port/public ingress:

Validate:

- WordPress no longer presents installer state;
- primary routes respond sufficiently to prove application bootstrap:
  - home
  - shop
  - product Mini Craft page
  - cart
  - checkout
  - my-account
  - wp-json
- restored wp-content/media remain present;
- WooCommerce active/core state present;
- accepted product/order schema exists;
- PayPal integration state remains Sandbox / Live disabled, using metadata/config-state checks only and no Provider call/payment;
- recent filtered WordPress/PHP logs contain no fatal startup error;
- MariaDB remains healthy;
- unrelated shared services remain unchanged.

Do not require all legacy serialized `localhost:8093` references to be gone; that is the next Gate.

## Hard boundaries

No:
- WordPress recreate/restart unless an unexpected process exit requires RETURN first;
- MariaDB import/retry/drop/recreate;
- wp-content restore/rewrite;
- image pull/build;
- broad SQL replacement;
- full serialized URL migration;
- Caddy/cloudflared/DNS/UFW/SSH/Docker-daemon/shared-network mutation;
- host ports/public ingress;
- Secret content/hash/rotation/overwrite;
- PayPal Live/payment/refund;
- unrelated project changes.

## RETURN semantics

Any RETURN -> stop immediately. No post-return cleanup or service lifecycle action.

## Success contract

```text
PASS_CANDIDATE_K6_PHASE_D_R6_BOOTSTRAP_RECONCILIATION_AND_PRIVATE_APP_VALIDATION
WORDPRESS_RUNTIME_CORE=PASS
MARIADB_RESTORE_STATE=PASS_52_TABLES
WORDPRESS_BOOTSTRAP=PASS
WORDPRESS_INSTALLED_STATE=PASS
HOME_SITEURL_SCALAR_UPDATE=PASS
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_PRIVATE_PRIMARY_ROUTES=PASS
WP_CONTENT_MEDIA_STATE=PASS
WOOCOMMERCE_CORE_STATE=PASS
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO
WORDPRESS_RECENT_FATALS=0
DB_PUBLIC_PORT=NONE
WORDPRESS_HOST_PORT=NONE
PUBLIC_INGRESS_CHANGE=0
UNRELATED_SERVICES_CHANGED=NO
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

A PASS_CANDIDATE does not authorize serialized URL migration or public ingress.
