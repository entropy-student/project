# K6 Phase E — Serialized-Safe URL Migration Execution Pack

Gate:
`K6_PHASE_E_SERIALIZED_SAFE_URL_MIGRATION`

Authority:
- canonical GitHub `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_D_R6R3R1_PASS_E_SERIALIZED_SAFE_URL_MIGRATION.md`;
- latest accepted Evidence/Handoff;
- unique current Shared VPS Handoff.

## Goal

Replace the two accepted historical WordPress origins with the production origin using a serialized-data-safe WP-CLI path, while preserving GUIDs and keeping the site private.

Known exact origins:

```text
OLD_ORIGIN_A=http://localhost:8093
OLD_ORIGIN_B=https://email-rich-barbie-merchants.trycloudflare.com
TARGET_ORIGIN=https://minicraft.spikersun.com
```

## Accepted baseline

Do not redo:
- DB restore;
- wp-content restore;
- Secret qualification;
- WordPress bootstrap/private-runtime acceptance;
- home/siteurl scalar update.

Current accepted:
- DB exact 52 tables;
- home/siteurl target;
- private runtime healthy;
- Checkout empty-cart -> Cart accepted;
- PPCP active/connected/Sandbox YES/Live NO;
- no public ingress.

## Phase A — preflight and exact tool identity

1. strict SSH identity/trust;
2. WordPress + MariaDB continuity;
3. no host ports/public ingress;
4. current root disk/RAM headroom;
5. WordPress app image exact accepted child:
   `sha256:f5413918c7858c97bb7d2b65f68d3ed38a97472deba9eb58eb3e1ab1eb2c4beb`;
6. WP-CLI exact approved child:
   `docker.io/library/wordpress@sha256:aa31002b5ae67cfff25817c8f4379b0e84aa4f8cc9637c83e16757d435adaf49`
   (WP-CLI 2.12.0, PHP 8.3, linux/amd64);
7. if not cached, pull this exact digest only;
8. no tag-only pull/build/other image.

## Phase B — disposable migration helper

Do not install WP-CLI into the live WordPress container.

Docker tmpfs cannot be shared between containers, so do not rely on `--volumes-from` for the live tmpfs-backed `/var/www/html`.

Create only project-scoped disposable tooling:

1. create an extraction container from the exact WP-CLI image;
2. copy only `/usr/local/bin/wp` to a temporary reconstructible path under:
   `/srv/apps/mini-craft-night-kit/.tmp/`;
3. remove extraction container;
4. create a disposable helper from the accepted WordPress application image;
5. helper:
   - no host port;
   - private DB network only;
   - do NOT join `spikersun-edge`;
   - own 512MiB `/var/www/html` tmpfs;
   - bind current wp-content preferably RO;
   - mount only the nine WordPress Secrets RO; db-root absent;
   - same required non-secret DB settings;
   - mount extracted WP-CLI binary RO;
6. let official WordPress entrypoint initialize its own core/config;
7. verify:
   - WordPress core 7.1.1;
   - WP-CLI 2.12.0;
   - DB connectivity;
   - installed-state;
   - no public exposure.

Any mismatch -> RETURN before DB mutation.

## Phase C — dry run

Run as non-root WordPress runtime identity where practical.

For each exact pair run serialized-safe WP-CLI search-replace with:

- `--all-tables-with-prefix`
- `--skip-columns=guid`
- `--skip-plugins`
- `--skip-themes`
- `--dry-run`
- changed table/column/count metadata only

Pair A:
`http://localhost:8093` -> `https://minicraft.spikersun.com`

Pair B:
`https://email-rich-barbie-merchants.trycloudflare.com` -> `https://minicraft.spikersun.com`

No regex.
No value/content logging.
No GUID mutation.

If both counts = 0:
- `SERIALIZED_URL_MIGRATION=NOOP_ALREADY_CLEAN`;
- skip backup/write;
- continue post-validation.

## Phase D — pre-migration backup

Only if any dry-run count > 0.

1. fresh DB health + exact 52-table recheck;
2. logical MariaDB backup under project backup namespace;
3. current post-home/siteurl state only;
4. protected tmpfs-only DB auth;
5. restrictive file permissions;
6. record file bytes and whole-artifact SHA-256;
7. validate readable dump and 52 expected tables without row-content output.

No migration if backup validation fails.

## Phase E — real migration

Run the exact same command shape without `--dry-run`.

Rules:
- exact old/new origins only;
- one origin at a time;
- skip GUID;
- skip plugins/themes;
- all tables with prefix;
- no regex;
- no broad fragment replace.

Real replacement count must equal immediate dry-run count.

Confirmed nonzero command failure with session still alive:
- no second migration attempt;
- restore exact pre-migration backup under the preauthorized rollback boundary;
- verify D-R6 baseline;
- RETURN `RETURN_REVIEWER_E_MIGRATION_FAILED_ROLLED_BACK`.

Ambiguous SSH/process outcome after migration may have started:
- no retry;
- no blind rollback;
- RETURN `RETURN_REVIEWER_E_MIGRATION_OUTCOME_AMBIGUOUS`.

## Phase F — validation

Require:

- dry-run A now 0;
- dry-run B now 0;
- GUID mutation count 0;
- 52-table set unchanged;
- home/siteurl target;
- bootstrap/installed-state;
- private Home/Shop/Product/Cart/Checkout/My Account/wp-json;
- expected empty-cart Checkout redirect allowed;
- wp-content/media;
- WooCommerce core;
- PPCP active/connected/Sandbox YES/Live NO;
- fatal=0/restart stable;
- no host ports/public ingress;
- unrelated services unchanged.

Do not mutate provider-side webhook registration in this Gate.

## Cleanup

Remove only:
- disposable migration helper;
- extraction helper;
- project-scoped extracted WP-CLI temporary file/directory.

No broad prune.
Do not remove cached WP-CLI image as generic cleanup.

## Forbidden

No:
- live WordPress/MariaDB restart/recreate;
- DB reimport/reset;
- wp-content restore;
- image build/tag-only pull;
- GUID replacement;
- regex/broad/unknown-origin replacement;
- Provider API/webhook mutation;
- public ingress;
- Shared Infra;
- PayPal Live/payment/refund;
- Secret content/hash output;
- unrelated project changes.

## Evidence

```text
WPCLI_IMAGE_IDENTITY=
WPCLI_IMAGE_PULL=
WPCLI_VERSION=
MIGRATION_HELPER=
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
MARIADB_TABLE_SET=UNCHANGED_52
HOME_SITEURL=PASS_TARGET
WORDPRESS_BOOTSTRAP=
WORDPRESS_PRIVATE_ROUTES=
WP_CONTENT_MEDIA_STATE=
WOOCOMMERCE_CORE_STATE=
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO
WORDPRESS_RECENT_FATALS=
WORDPRESS_RESTART_COUNT=
WORDPRESS_HOST_PORT=NONE
DB_PUBLIC_PORT=NONE
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
TEMP_HELPERS_CLEANED=
STOP_AT_REVIEWER=YES
```

Success:
`PASS_CANDIDATE_K6_PHASE_E_SERIALIZED_SAFE_URL_MIGRATION`

Otherwise precise `RETURN_*`.

Do not enter public ingress or Provider configuration after this Gate.
