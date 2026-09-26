# K6 D-R5 — WordPress Core Runtime Diagnosis + Conditional Recreate

Gate:
`K6_PHASE_D_R5_WORDPRESS_CORE_RUNTIME_DIAGNOSIS_AND_CONDITIONAL_RECREATE`

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_D_R4_RETURN_D_R5_WORDPRESS_CORE_RUNTIME_RECOVERY.md`;
- latest `EXECUTION_EVIDENCE.md`;
- latest `EXECUTOR_HANDOFF.md`;
- unique current Shared VPS Handoff;
- accepted D-R2/D-R4 digest-pinned private runtime state.

## Objective

Diagnose why the private WordPress container lacks runtime core files despite a complete restored DB, then perform at most one WordPress-only recreate if the accepted image/mount/entrypoint contract is intact.

Do not touch the restored MariaDB data except later scalar `home` / `siteurl` update after WordPress bootstrap PASS.

## Accepted start state

- MariaDB running/healthy;
- restored `wordpress` schema = exact expected 52 tables;
- app/root table sets match;
- `wp_options` exists;
- WordPress container running with no host ports but bootstrap failed;
- wp-content already restored;
- Secrets unchanged;
- no public ingress.

Material drift -> RETURN.

## Phase A — diagnosis only

Before any recreate:

1. Verify WordPress container image digest equals:
   `sha256:f5413918c7858c97bb7d2b65f68d3ed38a97472deba9eb58eb3e1ab1eb2c4beb`.
2. Verify resolved Compose image ref uses that exact digest.
3. Verify no unexpected entrypoint/command override.
4. Verify mount topology:
   - `/var/www/html` tmpfs with accepted 512 MiB bound;
   - `/var/www/html/wp-content` expected project bind;
   - nine intended WordPress Secret binds read-only;
   - db-root Secret absent.
5. Inside current WordPress container, existence/stat only:
   - `/usr/src/wordpress/wp-includes/version.php`
   - `/usr/src/wordpress/index.php`
   - `/var/www/html/wp-includes/version.php`
   - `/var/www/html/index.php`
   - `/var/www/html/wp-content`
6. Record process/command, restart count, mount metadata, and filtered startup-log classification.
7. Do not print file contents, wp-config, Secret values, env values, cookies, DB rows, or business content.

## Branching

### Branch A — accepted runtime contract intact; source core exists

If:
- image digest PASS;
- source core exists under `/usr/src/wordpress`;
- entrypoint/command PASS;
- tmpfs/wp-content/Secret mounts PASS;
- runtime core under `/var/www/html` absent/incomplete;

then perform exactly one WordPress-only recreate using the accepted digest-pinned resolved Compose.

Requirements:
- no image pull/build;
- no MariaDB recreate/restart/import;
- no wp-content restore;
- no Secret change;
- no Shared Infra/public ingress;
- no host ports.

After recreate verify:
- runtime `wp-includes/version.php` exists;
- runtime `index.php` exists;
- WordPress remains running;
- restart count stable;
- wp-content bind still correct;
- DB connectivity/bootstrap works.

Then:
- require no installer redirect;
- update only scalar `home` and `siteurl` to `https://minicraft.spikersun.com`;
- verify exact values;
- verify internal primary routes;
- verify WooCommerce core state;
- confirm PayPal remains Sandbox / Live disabled;
- retain `FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`.

### Branch B — source core/image integrity drift

Return:
`RETURN_REVIEWER_D_R5_WORDPRESS_IMAGE_INTEGRITY_DRIFT`

No recreate.

### Branch C — runtime config drift

Return:
`RETURN_REVIEWER_D_R5_WORDPRESS_RUNTIME_CONFIG_DRIFT`

No recreate.

### Branch D — recreate fails

If the single recreate does not restore core/bootstrap:

`RETURN_REVIEWER_D_R5_WORDPRESS_RECREATE_FAILED`

No second recreate.

## Forbidden

No:
- DB reimport/reset/drop/recreate;
- wp-content re-restore;
- image pull/build;
- second WordPress recreate;
- broad Docker cleanup;
- serialized migration;
- public ingress/host ports;
- Caddy/cloudflared/DNS/UFW/SSH/Docker-daemon/shared-network mutation;
- Secret content/hash/rotation/overwrite;
- PayPal Live/payment/refund;
- unrelated project changes.

## Return semantics

On any RETURN:
- stop immediately;
- no post-return container cleanup/restart;
- report exact residual state.

## Evidence

```text
WORDPRESS_IMAGE_DIGEST=
WORDPRESS_ENTRYPOINT_COMMAND=
WORDPRESS_TMPFS_MOUNT=
WORDPRESS_WP_CONTENT_BIND=
WORDPRESS_SECRET_MOUNTS=
SOURCE_CORE_VERSION_FILE=
SOURCE_CORE_INDEX_FILE=
PRE_RECREATE_RUNTIME_CORE=
WORDPRESS_RECREATE_COUNT=
POST_RECREATE_RUNTIME_CORE=
WORDPRESS_INSTALL_REDIRECT=
HOME_SITEURL_SCALAR_UPDATE=
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_INTERNAL_PRIMARY_ROUTES=
WOOCOMMERCE_CORE_STATE=
MARIADB_RESTORE_STATE=UNCHANGED_52_TABLES
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO
PUBLIC_INGRESS_CHANGE=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

Success:
`PASS_CANDIDATE_K6_PHASE_D_R5_WORDPRESS_CORE_RUNTIME_DIAGNOSIS_AND_CONDITIONAL_RECREATE`

Otherwise precise `RETURN_*`.

Do not enter serialized migration or public ingress after this Gate.
