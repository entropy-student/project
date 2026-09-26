# Reviewer Decision — K6 Phase E RETURN Accepted; E-R1 In-Place WP-CLI PHAR Serialized Migration

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed result

```text
GATE=K6_PHASE_E_SERIALIZED_SAFE_URL_MIGRATION
RESULT=RETURN_REVIEWER_E_MIGRATION_HELPER_INITIALIZATION_FAILED
EVIDENCE_COMMIT=e8f8bbf9792dc7f799d055c0adffc1ed97d281be
HANDOFF_COMMIT=6f7f836df616ed8afd672b3c353cd08ef5991cfd
```

Reviewer accepts the RETURN as correct and fail-closed.

## Accepted Phase E facts

```text
SSH_NATIVE_EXIT=0
SSH_HOST_KEY_MATCH=YES
REMOTE_IDENTITY=ops@srv1970241
WORDPRESS_RUNTIME=RUNNING_RESTART_0
MARIADB_RUNTIME=RUNNING_HEALTHY_RESTART_0
WORDPRESS_HOST_PORT=NONE
DB_PUBLIC_PORT=NONE
ROOT_DISK_USED_PERCENT=12
ROOT_DISK_AVAILABLE_BYTES=91357675520
RAM_AVAILABLE_BYTES=5611958272
MINICRAFT_PUBLIC_INGRESS=NONE
APP_IMAGE_IDENTITY=PASS_EXACT_FROZEN_LINUX_AMD64_DIGEST
WPCLI_IMAGE_PULL=PASS_EXACT_DIGEST
WPCLI_IMAGE_IDENTITY=PASS_EXACT_LINUX_AMD64_DIGEST
DB_WRITES=0
GUID_MUTATIONS=0
TEMP_HELPERS_CLEANED=PASS
```

No WP-CLI command, dry-run, backup, or migration reached the database.

The D-R6 accepted private-runtime baseline remains intact.

## Root cause / design correction

The failed design created a second disposable WordPress application runtime with its own tmpfs docroot and waited for the official application entrypoint to populate core before WP-CLI could run.

That duplication is unnecessary for this migration.

Current Docker Official WordPress CLI packaging installs WP-CLI 2.12.0 as a standalone PHAR at `/usr/local/bin/wp`. The official WordPress CLI usage model requires access to the existing WordPress on-disk files and database.

The already accepted live WordPress container already has:

- the exact accepted WordPress 7.1.1 runtime;
- populated `/var/www/html`;
- current `wp-config.php`/Docker config;
- current wp-content;
- current DB connectivity;
- qualified WordPress Secret mounts;
- no public host port.

Therefore the next Gate does **not** create a second WordPress runtime.

## Current Gate

```text
CURRENT_GATE=K6_PHASE_E_R1_IN_PLACE_WPCLI_PHAR_SERIALIZED_MIGRATION
OWNER_ACTION=NONE
```

## Frozen WP-CLI artifact

Already cached exact image:

`docker.io/library/wordpress@sha256:aa31002b5ae67cfff25817c8f4379b0e84aa4f8cc9637c83e16757d435adaf49`

Current official Dockerfile identifies:

```text
WORDPRESS_CLI_VERSION=2.12.0
WORDPRESS_CLI_SHA512=be928f6b8ca1e8dfb9d2f4b75a13aa4aee0896f8a9a0a1c45cd5d2c98605e6172e6d014dda2e27f88c98befc16c040cbb2bd1bfa121510ea5cdf5f6a30fe8832
ARTIFACT=/usr/local/bin/wp
```

No new pull is required if the exact cached image identity still matches.

## Phase A — fresh preflight

Verify:

1. strict SSH / target identity;
2. live WordPress running, restart count stable;
3. MariaDB healthy;
4. no host ports/public ingress;
5. live WordPress image exact accepted digest;
6. cached WP-CLI image exact accepted digest;
7. `home/siteurl` both target;
8. current 52-table baseline;
9. disk/RAM headroom.

Any material drift -> RETURN.

## Phase B — bounded WP-CLI PHAR staging

Do not alter the live WordPress image, entrypoint, mounts, Compose, or lifecycle.

1. create one extraction container from the exact cached WP-CLI image;
2. copy only `/usr/local/bin/wp` to a project-scoped temporary host path under:
   `/srv/apps/mini-craft-night-kit/.tmp/`;
3. remove extraction container;
4. verify exact SHA-512 against the frozen official value above;
5. copy that exact PHAR into the running WordPress container at a unique path under `/tmp/`;
6. set it read-only/executable as needed;
7. verify inside the running WordPress container:
   - same SHA-512;
   - `php <phar> --version` reports WP-CLI 2.12.0;
8. execute all WP-CLI commands as WordPress runtime identity `33:33` / `www-data`, not root;
9. use `--path=/var/www/html`;
10. no live-container restart/recreate.

This Gate explicitly authorizes this one temporary non-secret PHAR file in live container `/tmp`.
It does not authorize any other live-container filesystem mutation.

If staging/version/hash fails:
- remove the bounded temp PHAR/path;
- RETURN;
- do not enter DB migration.

## Phase C — serialized-safe dry run

Known exact origins:

```text
OLD_ORIGIN_A=http://localhost:8093
OLD_ORIGIN_B=https://email-rich-barbie-merchants.trycloudflare.com
TARGET_ORIGIN=https://minicraft.spikersun.com
```

Using the staged PHAR against the live accepted WordPress filesystem:

- `--path=/var/www/html`
- `--all-tables-with-prefix`
- `--skip-columns=guid`
- `--skip-plugins`
- `--skip-themes`
- `--dry-run`
- `--format=count` or equivalently bounded count-only reporting where supported
- no verbose/log row-value output

Run each exact old -> target pair separately.

No regex.
No broad host fragment replacement.
No GUID changes.

If both dry-run counts are zero:
- `SERIALIZED_URL_MIGRATION=NOOP_ALREADY_CLEAN`;
- skip backup/write;
- continue final validation.

## Phase D — fresh pre-migration backup

Only if at least one count > 0.

1. recheck DB healthy + exact 52-table set;
2. create one current logical DB backup under `/srv/backups/mini-craft-night-kit/`;
3. protected tmpfs-only DB auth;
4. restrictive permissions;
5. record bytes + whole-artifact SHA-256 only;
6. validate dump readability/table structure without row output.

No migration unless recovery point PASS.

## Phase E — real migration

Only after dry-run and required backup PASS.

Run the exact same WP-CLI command shapes without `--dry-run`.

Rules:
- exact origin strings only;
- `--skip-columns=guid`;
- `--all-tables-with-prefix`;
- `--skip-plugins`;
- `--skip-themes`;
- no regex;
- no broad/unknown-origin replacement.

Each real replacement count must match the immediately preceding dry-run count.

Confirmed command failure with SSH/session clearly alive:
- no second attempt;
- restore exact fresh backup;
- verify D-R6 baseline;
- RETURN `RETURN_REVIEWER_E_R1_MIGRATION_FAILED_ROLLED_BACK`.

Ambiguous execution after migration may have started:
- no retry;
- no blind rollback;
- RETURN `RETURN_REVIEWER_E_R1_MIGRATION_OUTCOME_AMBIGUOUS`.

## Phase F — post-validation

Require:

1. both exact old-origin dry-runs now zero;
2. GUID mutation count = 0;
3. exact 52-table set unchanged;
4. home/siteurl target;
5. WordPress bootstrap/installed-state PASS;
6. private primary routes PASS;
7. expected empty-cart Checkout -> Cart accepted;
8. wp-content/media PASS;
9. WooCommerce core PASS;
10. PPCP current critical state remains:
    - active YES;
    - connected YES;
    - Sandbox YES;
    - Live NO;
11. PHP fatal=0/restart stable;
12. no public ingress/host ports;
13. unrelated services unchanged.

No Provider webhook mutation in this Gate.

## Cleanup

After final validation or any pre-migration RETURN:

- remove live-container `/tmp` WP-CLI PHAR;
- verify absent;
- remove project-scoped host temp PHAR/path;
- verify absent;
- remove extraction container if any.

If migration outcome is ambiguous, cleanup may remove only the known non-secret PHAR/helper artifact when doing so does not affect DB reconciliation; no application lifecycle action or DB write.

No broad prune.
Keep the already authorized cached WP-CLI image.

## Hard boundaries

No:
- second WordPress helper runtime;
- live WordPress/MariaDB restart/recreate;
- Compose/mount/entrypoint mutation;
- image build/tag pull;
- GUID replacement;
- regex/broad replacement;
- unknown-origin automatic replacement;
- public ingress;
- Shared Infra mutation;
- Provider webhook/API call;
- PayPal Live/payment/refund;
- Secret content/hash output;
- unrelated project changes.

## Success contract

```text
PASS_CANDIDATE_K6_PHASE_E_R1_IN_PLACE_WPCLI_PHAR_SERIALIZED_MIGRATION
WPCLI_IMAGE_IDENTITY=PASS_EXACT_AMD64_DIGEST
WPCLI_PHAR_SHA512=PASS
WPCLI_VERSION=2.12.0
WPCLI_EXECUTION_IDENTITY=www-data_33_33
WPCLI_PATH=/var/www/html
OLD_ORIGIN_A_DRYRUN_COUNT=
OLD_ORIGIN_B_DRYRUN_COUNT=
PRE_MIGRATION_BACKUP=<PASS_OR_NOT_REQUIRED_NOOP>
OLD_ORIGIN_A_REPLACED=
OLD_ORIGIN_B_REPLACED=
POST_MIGRATION_OLD_ORIGIN_A=0
POST_MIGRATION_OLD_ORIGIN_B=0
GUID_MUTATIONS=0
MARIADB_TABLE_SET=UNCHANGED_52
HOME_SITEURL=PASS_TARGET
WORDPRESS_BOOTSTRAP=PASS
WORDPRESS_PRIVATE_ROUTES=PASS
WP_CONTENT_MEDIA_STATE=PASS
WOOCOMMERCE_CORE_STATE=PASS
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO
WORDPRESS_RECENT_FATALS=0
WORDPRESS_RESTART_COUNT=STABLE
WORDPRESS_HOST_PORT=NONE
DB_PUBLIC_PORT=NONE
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
LIVE_CONTAINER_TEMP_PHAR_CLEANED=PASS
HOST_TEMP_PHAR_CLEANED=PASS
STOP_AT_REVIEWER=YES
```

PASS_CANDIDATE does not authorize public ingress, Provider webhook reconfiguration, PayPal Live, real payment, or launch.
