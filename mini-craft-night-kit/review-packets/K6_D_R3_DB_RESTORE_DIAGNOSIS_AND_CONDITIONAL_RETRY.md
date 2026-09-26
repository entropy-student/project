# K6 D-R3 — DB Restore Diagnosis + Conditional Retry Execution Pack

Gate:
`K6_PHASE_D_R3_DB_RESTORE_DIAGNOSIS_AND_CONDITIONAL_RETRY`

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_D_R2_RETURN_D_R3_DB_RESTORE_DIAGNOSIS_RETRY.md`;
- latest accepted `EXECUTION_EVIDENCE.md`;
- latest `EXECUTOR_HANDOFF.md`;
- unique current Shared VPS Handoff;
- accepted K5 SQL/wp-content recovery package;
- accepted digest-pinned D-R2 Compose/runtime state.

## Objective

Determine why the accepted K5 MariaDB dump produced no visible WordPress schema, then perform at most one bounded corrective path if and only if diagnosis makes it safe.

Do not rerun image acquisition, Secret provisioning, wp-content restore, Shared Infra work or public ingress.

## Mandatory start state

- WordPress container stopped.
- MariaDB container stopped.
- Existing project mysql state preserved.
- Accepted staged K5 SQL/wp-content remain hash-matching.
- Secret tree unchanged.
- No host ports/public ingress.

If any start-state drift is material, RETURN before mutation.

## Phase A — diagnosis

Start **MariaDB only** using the accepted digest-pinned private runtime.

### 1. Dump metadata parser

Verify K5 SQL hash first.

Parse without outputting business-row contents.

Record only:
- expected unique table-name set/count from CREATE TABLE statements;
- CREATE DATABASE statement targets;
- USE statement targets;
- schema-qualified DDL targets;
- INSERT statement count only;
- presence of DROP DATABASE / DROP USER / ALTER USER / GRANT / REVOKE / cross-schema mutations.

Never print INSERT values.

### 2. Root/admin metadata readback

Use an auth mechanism that does not place Secret values in argv/env/logs.

Permitted method:
- inside MariaDB container, create a root-only mode 0600 client option file on tmpfs only;
- populate it from the existing mounted Secret file entirely inside the container;
- use it for metadata queries;
- delete it before the bounded command exits;
- verify it absent afterward.

Query only metadata:
- non-system schema names;
- table count per non-system schema;
- exact table-name set in `wordpress`;
- `wp_options` existence;
- app account existence;
- app grant metadata without password/hash.

### 3. App-user visibility

Using the same credential-safe tmpfs-only method with `db-app-password`, record:
- selected DB = `wordpress`;
- exact visible table-name set/count;
- `wp_options` visibility.

No row content.

## Conditional branch

### Branch A — exact tables exist as root; app visibility is wrong

If root sees the exact expected table set in `wordpress` and app user does not:

- do NOT import again;
- repair only the minimum privilege scope for the existing exact app account on `wordpress`;
- no password change;
- recheck exact app-visible table set.

Any unexpected account/grant drift -> RETURN.

### Branch B — target DB is truly empty

If root sees zero application tables in `wordpress`, and dump metadata is compatible with target `wordpress`, with no prohibited destructive/account/cross-schema statements:

Perform exactly one explicit import retry:
- direct MariaDB client explicitly to database `wordpress`;
- source only the accepted staged K5 SQL;
- use tmpfs-only client credential config;
- no Secret argv/env;
- do not emit SQL rows;
- record native exit + filtered error class only;
- no second retry inside this Gate.

### Branch C — anything else

If:
- target has a partial/nonzero unexpected table set;
- tables are found in another unexpected schema;
- dump database target conflicts;
- dump contains prohibited account/destructive/cross-schema operations;
- auth/grant state is ambiguous;

return:

`RETURN_REVIEWER_D_R3_SCHEMA_OR_DUMP_DRIFT`

before mutation.

## Post-repair/import verification

Only after Branch A or B succeeds:

- root-visible `wordpress` table set must equal parsed expected set;
- app-visible table set must equal expected set;
- `wp_options` must exist;
- no unexpected extra application schema;
- MariaDB healthy.

Then start WordPress privately and verify:
- no redirect to installer;
- primary internal routes respond;
- WooCommerce core state is present;
- restored wp-content remains present.

Then update only the scalar WordPress options:
- `home`
- `siteurl`

to:

`https://minicraft.spikersun.com`

Use exact row-scoped DB updates only.

Do not perform broad search/replace or serialized migration.

Record:

`FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`

## Cleanup / STOP rule

If Gate returns:
- stop immediately;
- do not start another container for cleanup;
- report exact residual state to Reviewer.

If Gate reaches PASS_CANDIDATE:
- leave the private runtime in the state required by the execution pack and record it exactly;
- remove only temporary tmpfs auth artifacts and transient diagnostic files;
- verify no host temporary files remain.

## Forbidden

No:
- deleting/reinitializing MariaDB datadir;
- dropping/recreating DB;
- multiple import retries;
- broad SQL replacement;
- serialized migration;
- Caddy/cloudflared/DNS/UFW/SSH/Docker-daemon/shared network changes;
- public ingress/host ports;
- Secret content output/hash/rotation/overwrite;
- PayPal Live/payment/refund;
- unrelated project changes.

## Evidence markers

```text
K5_SQL_HASH=
DUMP_EXPECTED_TABLE_COUNT=
DUMP_SCHEMA_TARGET=
DUMP_PROHIBITED_STATEMENTS=
ROOT_WORDPRESS_TABLE_COUNT=
ROOT_WORDPRESS_TABLE_SET_MATCH=
ROOT_WP_OPTIONS_PRESENT=
APP_WORDPRESS_TABLE_COUNT=
APP_WORDPRESS_TABLE_SET_MATCH=
APP_WP_OPTIONS_VISIBLE=
RESTORE_PATH=
RESTORE_NATIVE_EXIT=
MARIADB_HEALTH=
WORDPRESS_INSTALL_REDIRECT=
HOME_SITEURL_SCALAR_UPDATE=
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_INTERNAL_PRIMARY_ROUTES=
WOOCOMMERCE_CORE_STATE=
PUBLIC_INGRESS_CHANGE=0
PAYPAL_LIVE=NO
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

## Return

Success:
`PASS_CANDIDATE_K6_PHASE_D_R3_DB_RESTORE_DIAGNOSIS_AND_CONDITIONAL_RETRY`

Otherwise return a precise `RETURN_*`.

Do not enter serialized migration or public ingress after this Gate.
