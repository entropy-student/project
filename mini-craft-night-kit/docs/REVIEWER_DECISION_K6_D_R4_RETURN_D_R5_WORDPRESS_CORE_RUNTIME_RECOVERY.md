# Reviewer Decision — K6 D-R4 RETURN Accepted; D-R5 WordPress Core Runtime Diagnosis + Conditional Recreate

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed result

```text
GATE=K6_PHASE_D_R4_DETERMINISTIC_FILTERED_IMPORT_RETRY
RESULT=RETURN_D_R4_WORDPRESS_CORE_FILES_MISSING
EXECUTOR_FINAL_COMMIT=a8ca725239ea149abc47ac5d043e711f99137451
```

Reviewer accepts the RETURN as correct and fail-closed.

## Accepted database result

D-R4 successfully closed the MariaDB restore problem:

```text
K5_SQL_HASH=PASS
FILTERED_STATEMENT_REMOVED=CREATE_DATABASE_WORDPRESS_EXACTLY_ONE
FILTERED_STREAM_INVARIANTS=PASS
IMPORT_RETRY_COUNT=1
IMPORT_NATIVE_EXIT=0
ROOT_WORDPRESS_TABLE_COUNT=52
ROOT_TABLE_SET_MATCH=PASS
APP_WORDPRESS_TABLE_COUNT=52
APP_TABLE_SET_MATCH=PASS
WP_OPTIONS_PRESENT=YES
NON_SYSTEM_SCHEMA_SET_MATCH=PASS
MARIADB_HEALTH=PASS
```

The database restore is therefore accepted as complete. D-R5 must not reimport SQL or modify the MariaDB schema except the later specifically authorized scalar `home` / `siteurl` update after WordPress bootstrap succeeds.

## Current blocker

The existing private WordPress container started with no host ports, but the first bootstrap probe failed because:

`/var/www/html/wp-includes/version.php`

was absent.

The current accepted Compose design intentionally uses:

- WordPress root `/var/www/html` as a 512 MiB tmpfs;
- persistent nested `/var/www/html/wp-content` bind;
- official WordPress image entrypoint/command;
- no host port.

Earlier accepted K6 Phase B R1 rehearsal proved that with this design, a fresh/forced WordPress recreate reinitializes core files into the tmpfs while preserving the nested wp-content bind.

Therefore the next action is not to modify wp-content or database content. It is to determine whether the current runtime container deviates from the accepted image/mount/entrypoint contract and, only if it does not, perform one bounded WordPress-only recreate.

## Current Gate

```text
CURRENT_GATE=K6_PHASE_D_R5_WORDPRESS_CORE_RUNTIME_DIAGNOSIS_AND_CONDITIONAL_RECREATE
OWNER_ACTION=NONE
```

## Phase A — read-only runtime diagnosis

Do not restart/recreate anything yet.

Inspect only Mini Craft WordPress runtime metadata and no-value file existence/metadata:

1. verify container uses the accepted WordPress linux/amd64 digest:
   `sha256:f5413918c7858c97bb7d2b65f68d3ed38a97472deba9eb58eb3e1ab1eb2c4beb`;
2. verify configured image reference in resolved Compose is the accepted digest;
3. verify configured entrypoint and command match the official accepted image runtime contract and have not been overridden unexpectedly;
4. verify mount topology:
   - `/var/www/html` = tmpfs, 512 MiB as accepted;
   - `/var/www/html/wp-content` = expected project bind;
   - nine WordPress Secret binds = read-only;
   - no `db-root-password` mount;
5. verify inside the current running container, metadata/existence only:
   - `/usr/src/wordpress/wp-includes/version.php`;
   - `/usr/src/wordpress/index.php`;
   - `/var/www/html/wp-includes/version.php`;
   - `/var/www/html/index.php`;
   - wp-content bind path exists;
6. verify current container process/command, restart count, mount state and filtered startup-log classifications without printing Secret/config values.

Do not cat WordPress files, wp-config, Secret files, or business content.

## Conditional repair branches

### Branch A — image source core exists and runtime config matches accepted design

If all are true:

- accepted image digest matches;
- `/usr/src/wordpress/wp-includes/version.php` exists;
- accepted entrypoint/command is intact;
- tmpfs + nested wp-content + Secret mounts match;
- only `/var/www/html` core files are absent/incomplete;

then Reviewer authorizes exactly one WordPress-only controlled recreate using the accepted digest-pinned resolved Compose.

Requirements:

- MariaDB remains untouched/running healthy;
- no image pull/build;
- no DB restore;
- no wp-content rewrite;
- no Shared Infra/public ingress;
- recreate only the WordPress service;
- preserve the existing wp-content bind;
- preserve Secret tree unchanged;
- no host ports;
- after recreate, verify official entrypoint repopulated:
  - `/var/www/html/wp-includes/version.php`
  - `/var/www/html/index.php`;
- verify WordPress process remains running and restart count stable.

Only after those checks PASS:
- verify no installer redirect;
- update only scalar `home` and `siteurl` to `https://minicraft.spikersun.com`;
- verify internal primary routes and WooCommerce core state;
- retain `FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`.

### Branch B — source core missing or image identity mismatch

If `/usr/src/wordpress` core is missing, digest/platform differs, or image metadata is inconsistent:

`RETURN_REVIEWER_D_R5_WORDPRESS_IMAGE_INTEGRITY_DRIFT`

No recreate.

### Branch C — mount/entrypoint/command differs from accepted Compose

If runtime configuration differs from accepted resolved Compose:

`RETURN_REVIEWER_D_R5_WORDPRESS_RUNTIME_CONFIG_DRIFT`

No recreate.

### Branch D — recreate runs but core remains missing/bootstrap still fails

Return:

`RETURN_REVIEWER_D_R5_WORDPRESS_RECREATE_FAILED`

Stop immediately. No second recreate.

## Hard boundaries

No:
- MariaDB import/retry/schema reset;
- wp-content re-restore/rewrite;
- image pull/build;
- second WordPress recreate;
- broad Docker cleanup;
- full serialized migration;
- Caddy/cloudflared/DNS/UFW/SSH/Docker-daemon/shared-network mutation;
- host port/public ingress;
- Secret content/hash/rotation/overwrite;
- PayPal Live/payment/refund;
- unrelated project changes.

## RETURN semantics

Any RETURN -> stop immediately. Do not perform post-return cleanup that starts/stops/recreates containers unless separately reviewed.

## Success contract

```text
PASS_CANDIDATE_K6_PHASE_D_R5_WORDPRESS_CORE_RUNTIME_DIAGNOSIS_AND_CONDITIONAL_RECREATE
WORDPRESS_IMAGE_DIGEST=PASS
WORDPRESS_ENTRYPOINT_COMMAND=PASS
WORDPRESS_TMPFS_MOUNT=PASS
WORDPRESS_WP_CONTENT_BIND=PASS
WORDPRESS_SECRET_MOUNTS=PASS
SOURCE_CORE_VERSION_FILE=PASS
PRE_RECREATE_RUNTIME_CORE=ABSENT_OR_INCOMPLETE
WORDPRESS_RECREATE_COUNT=1
POST_RECREATE_RUNTIME_CORE=PASS
WORDPRESS_INSTALL_REDIRECT=NO
HOME_SITEURL_SCALAR_UPDATE=PASS
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_INTERNAL_PRIMARY_ROUTES=PASS
WOOCOMMERCE_CORE_STATE=PASS
MARIADB_RESTORE_STATE=UNCHANGED_52_TABLES
PUBLIC_INGRESS_CHANGE=0
PAYPAL_LIVE=NO
REAL_PAYMENT_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

This Gate does not authorize serialized migration or public ingress.
