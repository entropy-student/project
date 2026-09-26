# K6 D-R4 — Deterministic Filtered Import Retry Execution Pack

Gate:
`K6_PHASE_D_R4_DETERMINISTIC_FILTERED_IMPORT_RETRY`

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_D_R3_RETURN_D_R4_FILTERED_IMPORT_RETRY.md`;
- latest accepted `EXECUTION_EVIDENCE.md`;
- latest `EXECUTOR_HANDOFF.md`;
- unique current Shared VPS Handoff;
- accepted K5 SQL/wp-content recovery package;
- accepted digest-pinned private runtime state.

## Objective

Repair the MariaDB restore by importing the accepted K5 dump into the existing empty `wordpress` schema while removing only the single conflicting unguarded `CREATE DATABASE wordpress` statement from the import stream.

The accepted source SQL file must remain byte-for-byte unchanged.

## Start state

Expected:
- MariaDB running healthy;
- WordPress stopped;
- `wordpress` schema exists and has 0 tables;
- app user sees 0 tables;
- staged K5 SQL hash matches accepted source;
- wp-content already restored;
- Secrets unchanged;
- no host ports/public ingress.

Material drift -> RETURN before DB mutation.

## Phase A — deterministic filter seal

1. Reverify K5 SQL SHA-256.
2. Parse source SQL without printing row/business contents.
3. Require:
   - CREATE DATABASE count = 1;
   - target = `wordpress`;
   - no IF NOT EXISTS;
   - USE count = 1, target = `wordpress`;
   - CREATE TABLE count = 52;
   - DROP TABLE IF EXISTS count = 52;
   - DROP target set exactly equals CREATE target set;
   - INSERT statement count = 36;
   - no DROP DATABASE / CREATE USER / DROP USER / ALTER USER / GRANT / REVOKE / SET PASSWORD / SET GLOBAL;
   - no cross-schema DDL.
4. Construct an ephemeral derived import stream/file by removing exactly the byte range for the single `CREATE DATABASE wordpress` statement.
5. Do not otherwise normalize or rewrite source bytes.
6. Reparse the derived stream and prove:
   - removed statement count = 1;
   - removed statement is exactly CREATE DATABASE wordpress;
   - CREATE TABLE targets unchanged;
   - DROP TABLE targets unchanged;
   - INSERT count unchanged;
   - USE wordpress remains exactly once;
   - no new statement/token introduced.
7. Record derived stream SHA-256 as integrity metadata.
8. Keep derived stream only in tmpfs or reviewed ephemeral project-local temp location; never GitHub.

Any mismatch -> RETURN before import.

## Phase B — one explicit import attempt

Before import, fresh metadata check must still show:
- root wordpress tables = 0;
- app wordpress tables = 0;
- wp_options absent.

Then:
- use MariaDB client explicitly targeting database `wordpress`;
- feed only the verified derived stream;
- auth via reviewed tmpfs-only root client option file;
- no Secret in argv/env/stdout/stderr/log;
- no `--force`;
- exactly one import attempt;
- native nonzero exit -> immediate RETURN, no retry.

## Phase C — exact restore verification

After native exit 0:

- root-visible wordpress table count = 52;
- root-visible table set exactly equals parsed expected set;
- app-visible table count = 52;
- app-visible table set exactly equals expected set;
- wp_options exists for both intended visibility checks;
- no unexpected non-system schema introduced;
- MariaDB healthy.

If any mismatch -> RETURN immediately.

## Phase D — bounded WordPress continuation

Only after DB verification passes:

1. start WordPress privately;
2. verify no install redirect;
3. update only scalar rows:
   - `home`
   - `siteurl`
   to `https://minicraft.spikersun.com`;
4. verify exact scalar values;
5. verify internal primary routes;
6. verify WooCommerce core state;
7. confirm PayPal remains Sandbox / Live disabled without provider action.

Record:
`FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`

Do not broad search/replace.

## Cleanup

On PASS candidate:
- remove derived import temp stream;
- remove tmpfs auth file;
- verify no host temp SQL/helper remains;
- preserve accepted K5 source and project runtime.

On RETURN:
- stop immediately;
- do not perform post-return service/container cleanup requiring new execution;
- report exact residual state.

## Forbidden

No:
- editing/overwriting accepted K5 SQL source;
- drop/recreate database;
- datadir reset;
- `--force`;
- second import retry;
- full serialized URL migration;
- Caddy/cloudflared/DNS/UFW/SSH/Docker-daemon/shared-network mutation;
- host ports/public ingress;
- Secret content/hash/rotation/overwrite;
- PayPal Live/payment/refund;
- unrelated project changes.

## Evidence markers

```text
K5_SQL_HASH=
SOURCE_CREATE_DATABASE_COUNT=
SOURCE_USE_COUNT=
SOURCE_CREATE_TABLE_COUNT=
SOURCE_DROP_TABLE_COUNT=
SOURCE_INSERT_COUNT=
FILTERED_STATEMENT_REMOVED=
FILTERED_STREAM_INVARIANTS=
FILTERED_STREAM_HASH=
PREIMPORT_ROOT_TABLE_COUNT=
PREIMPORT_APP_TABLE_COUNT=
IMPORT_RETRY_COUNT=
IMPORT_NATIVE_EXIT=
POSTIMPORT_ROOT_TABLE_COUNT=
POSTIMPORT_ROOT_TABLE_SET_MATCH=
POSTIMPORT_APP_TABLE_COUNT=
POSTIMPORT_APP_TABLE_SET_MATCH=
WP_OPTIONS_PRESENT=
MARIADB_HEALTH=
WORDPRESS_INSTALL_REDIRECT=
HOME_SITEURL_SCALAR_UPDATE=
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_INTERNAL_PRIMARY_ROUTES=
WOOCOMMERCE_CORE_STATE=
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO
PUBLIC_INGRESS_CHANGE=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

## Return

Success:
`PASS_CANDIDATE_K6_PHASE_D_R4_DETERMINISTIC_FILTERED_IMPORT_RETRY`

Otherwise return a precise `RETURN_*`.

Do not enter serialized migration or public ingress after this Gate.
