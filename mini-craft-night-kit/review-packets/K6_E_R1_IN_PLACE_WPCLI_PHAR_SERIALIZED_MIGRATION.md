# K6 Phase E-R1 — In-Place WP-CLI PHAR Serialized Migration

Gate:
`K6_PHASE_E_R1_IN_PLACE_WPCLI_PHAR_SERIALIZED_MIGRATION`

Authority:
- canonical GitHub `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_E_RETURN_E_R1_IN_PLACE_WPCLI_PHAR_MIGRATION.md`;
- latest accepted Evidence/Handoff;
- unique current Shared VPS Handoff.

## Objective

Use the already-running accepted WordPress container as the filesystem/config/runtime target for WP-CLI. Stage only one verified WP-CLI 2.12.0 PHAR into live container `/tmp`, run serialized-safe dry-run/migration as www-data, then remove it.

Do not create a second WordPress helper runtime.

## Frozen artifacts

Live WordPress accepted child digest:
`sha256:f5413918c7858c97bb7d2b65f68d3ed38a97472deba9eb58eb3e1ab1eb2c4beb`

Cached WP-CLI child digest:
`sha256:aa31002b5ae67cfff25817c8f4379b0e84aa4f8cc9637c83e16757d435adaf49`

Expected:
```text
WPCLI_VERSION=2.12.0
WPCLI_SHA512=be928f6b8ca1e8dfb9d2f4b75a13aa4aee0896f8a9a0a1c45cd5d2c98605e6172e6d014dda2e27f88c98befc16c040cbb2bd1bfa121510ea5cdf5f6a30fe8832
```

## Phase A — preflight

Verify:
- strict SSH + ops@srv1970241;
- live WordPress running/restart stable;
- MariaDB healthy;
- no host ports/public ingress;
- exact live WordPress image digest;
- exact cached WP-CLI image digest;
- home/siteurl target;
- exact 52-table baseline;
- resource headroom.

Material drift -> RETURN.

## Phase B — PHAR staging

1. create extraction container from exact cached WP-CLI image;
2. copy only `/usr/local/bin/wp` to unique project temp host path under `/srv/apps/mini-craft-night-kit/.tmp/`;
3. remove extraction container;
4. SHA-512 verify exact frozen value;
5. copy PHAR into live WordPress container at unique `/tmp/mini-craft-wp-cli-2.12.0.phar`;
6. set bounded readable/executable mode;
7. verify same SHA-512 inside container;
8. run version check as UID/GID 33:33 using:
   `php /tmp/mini-craft-wp-cli-2.12.0.phar --version`;
9. all subsequent WP-CLI operations run as UID/GID 33:33 with `--path=/var/www/html`.

No restart/recreate/Compose/mount change.

Failure before DB work -> clean bounded temp artifacts and RETURN.

## Phase C — dry-run

Exact origins:
- A: `http://localhost:8093`
- B: `https://email-rich-barbie-merchants.trycloudflare.com`
- target: `https://minicraft.spikersun.com`

Use WP-CLI search-replace with:
- `--path=/var/www/html`
- `--all-tables-with-prefix`
- `--skip-columns=guid`
- `--skip-plugins`
- `--skip-themes`
- `--dry-run`
- bounded count-only/report metadata
- no verbose/log values

Run A then B separately.

If both counts zero:
- record NOOP;
- no backup/write;
- continue validation.

## Phase D — backup if migration required

If any dry-run count > 0:
- recheck MariaDB health + exact 52 tables;
- create fresh logical backup under project backup namespace;
- protected tmpfs-only DB auth;
- restrictive permissions;
- record bytes + SHA-256 only;
- validate dump readability / expected tables.

Failure -> no migration.

## Phase E — real serialized migration

Run same commands without `--dry-run`.

Rules:
- exact origin only;
- skip GUID;
- no regex;
- no broad/unknown replacement;
- no plugins/themes.

Actual count must match immediate dry-run count.

Confirmed failure while SSH/session alive:
- no second migration;
- restore exact fresh backup;
- verify baseline;
- RETURN rolled-back classification.

Ambiguous outcome:
- no retry;
- no blind rollback;
- RETURN ambiguous.

## Phase F — validation

Require:
- post dry-run A = 0;
- post dry-run B = 0;
- GUID mutations = 0;
- table set = exact 52;
- home/siteurl = target;
- bootstrap/installed state PASS;
- private primary routes PASS;
- empty checkout -> Cart accepted;
- wp-content/media PASS;
- WooCommerce core PASS;
- PPCP active/connected/Sandbox YES/Live NO;
- fatal=0/restart stable;
- no host ports/public ingress;
- unrelated services unchanged.

## Cleanup

Remove and verify absent:
- live container temp PHAR;
- host temp PHAR/path;
- extraction container.

No broad prune.
Keep cached exact WP-CLI image.

## Forbidden

No:
- second WordPress runtime/helper;
- live WordPress/MariaDB restart/recreate;
- Compose/mount/entrypoint mutation;
- image build/tag-only pull;
- GUID replace;
- regex/broad/unknown replace;
- public ingress;
- Shared Infra;
- Provider API/webhook;
- PayPal Live/payment/refund;
- Secret content/hash output;
- unrelated changes.

## Evidence markers

```text
SSH_NATIVE_EXIT=
REMOTE_IDENTITY=
WORDPRESS_RUNTIME_CONTINUITY=
MARIADB_HEALTH=
APP_IMAGE_IDENTITY=
WPCLI_IMAGE_IDENTITY=
WPCLI_IMAGE_PULL=NOT_REQUIRED_CACHED
WPCLI_PHAR_SHA512=
WPCLI_VERSION=
WPCLI_EXECUTION_IDENTITY=
WPCLI_PATH=/var/www/html
OLD_ORIGIN_A_DRYRUN_COUNT=
OLD_ORIGIN_B_DRYRUN_COUNT=
PRE_MIGRATION_BACKUP=
PRE_MIGRATION_BACKUP_BYTES=
PRE_MIGRATION_BACKUP_SHA256=
OLD_ORIGIN_A_REPLACED=
OLD_ORIGIN_B_REPLACED=
POST_MIGRATION_OLD_ORIGIN_A=
POST_MIGRATION_OLD_ORIGIN_B=
GUID_MUTATIONS=0
MARIADB_TABLE_SET=
HOME_SITEURL=
WORDPRESS_BOOTSTRAP=
WORDPRESS_PRIVATE_ROUTES=
WP_CONTENT_MEDIA_STATE=
WOOCOMMERCE_CORE_STATE=
PPCP_ACTIVE=
PPCP_MERCHANT_CONNECTED=
PPCP_SANDBOX_ENABLED=
PPCP_LIVE_ENABLED=
WORDPRESS_RECENT_FATALS=
WORDPRESS_RESTART_COUNT=
WORDPRESS_HOST_PORT=NONE
DB_PUBLIC_PORT=NONE
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
LIVE_CONTAINER_TEMP_PHAR_CLEANED=
HOST_TEMP_PHAR_CLEANED=
STOP_AT_REVIEWER=YES
```

Success:
`PASS_CANDIDATE_K6_PHASE_E_R1_IN_PLACE_WPCLI_PHAR_SERIALIZED_MIGRATION`

Otherwise precise `RETURN_*`.

Do not enter public ingress or Provider configuration after this Gate.
