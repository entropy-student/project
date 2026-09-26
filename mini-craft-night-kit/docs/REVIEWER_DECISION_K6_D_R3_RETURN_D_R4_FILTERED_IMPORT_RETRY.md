# Reviewer Decision — K6 D-R3 RETURN Accepted; D-R4 Deterministic Filtered Import Retry

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed result

```text
GATE=K6_PHASE_D_R3_DB_RESTORE_DIAGNOSIS_AND_CONDITIONAL_RETRY
RESULT=RETURN_REVIEWER_D_R3_SCHEMA_OR_DUMP_DRIFT
EXECUTOR_FINAL_COMMIT=253c605470ebe797ca4ecab50db1ea6495491005
EVIDENCE_COMMIT=9b9fc283293079d65cdcdad4f857723acdc0ecf0
```

Reviewer accepts this RETURN as correct and fail-closed.

## Accepted diagnosis

The accepted K5 SQL source is unchanged and hash-matching.

Metadata-only parsing established:

```text
DUMP_EXPECTED_TABLE_COUNT=52
CREATE_DATABASE_COUNT=1
CREATE_DATABASE_TARGET=wordpress
CREATE_DATABASE_IF_NOT_EXISTS=NO
USE_COUNT=1
USE_TARGET=wordpress
SCHEMA_QUALIFIED_DDL=NONE
CREATE_TABLE_TARGETS=UNQUALIFIED
INSERT_STATEMENT_COUNT=36
DROP_TABLE_IF_EXISTS_COUNT=52
DROP_TABLE_TARGET_SET_MATCHES_CREATE=YES
DROP_DATABASE=0
DROP_USER=0
ALTER_USER=0
GRANT=0
REVOKE=0
CREATE_USER=0
SET_PASSWORD=0
SET_GLOBAL=0
```

Target state:

```text
ROOT_WORDPRESS_TABLES=0
APP_WORDPRESS_TABLES=0
WP_OPTIONS=ABSENT
APP_SCHEMA_PRIVILEGES=ALREADY_PRESENT
MARIADB=RUNNING_HEALTHY
WORDPRESS=STOPPED
```

Therefore the problem is not app-user privilege visibility. The existing empty target schema conflicts only with the dump's single unguarded `CREATE DATABASE wordpress` statement.

## Technical ruling

Do **not**:

- drop/recreate `wordpress`;
- use `mariadb --force`;
- edit or overwrite the accepted K5 SQL file;
- ignore arbitrary SQL errors;
- rerun the original init-script path.

Instead, D-R4 may construct a one-time **derived import stream** from the accepted K5 SQL that removes exactly one statement:

`CREATE DATABASE ... wordpress ... ;`

subject to the exact constraints below.

The source SQL file remains immutable and is never replaced.

## Deterministic filter contract

Before any DB write:

1. Reverify accepted K5 SQL SHA-256.
2. Parse SQL statements without printing row/business content.
3. Require exactly one statement classified as:
   - statement type = `CREATE DATABASE`;
   - target schema = `wordpress`;
   - unguarded / no `IF NOT EXISTS`.
4. Require exactly one `USE wordpress`.
5. Require all previously accepted D-R3 structural invariants still match.
6. Construct a derived byte stream/file in tmpfs or other reviewed ephemeral project-local location that:
   - removes only the exact byte range of that one `CREATE DATABASE wordpress` statement;
   - preserves every other source byte in order;
   - does not normalize, rewrite, reserialize, or otherwise modify remaining SQL.
7. Prove:
   - removed statement count = 1;
   - source statement inventory minus one CREATE DATABASE equals derived inventory;
   - expected 52 CREATE TABLE targets unchanged;
   - expected 52 DROP TABLE targets unchanged;
   - INSERT statement count remains 36;
   - `USE wordpress` remains exactly once;
   - no new statement/token is introduced.
8. Record the derived stream SHA-256 as non-secret integrity metadata.
9. Never commit the derived SQL stream to GitHub and remove it after the bounded import attempt.

Any parser ambiguity or any second difference -> RETURN before import.

## One explicit import retry

Only after the deterministic filter seal passes and a fresh metadata check still confirms `wordpress` has zero tables:

- import exactly once;
- direct the MariaDB client explicitly to `wordpress`;
- feed only the verified derived stream;
- use the already reviewed tmpfs-only credential option-file path;
- no Secret in argv/env/logs;
- no `--force`;
- native nonzero client exit -> immediate RETURN;
- no second retry in this Gate.

## Post-import acceptance

After native exit 0:

1. root-visible `wordpress` table set must exactly equal the expected 52-table set;
2. app-visible table set must exactly equal the same set;
3. `wp_options` must exist;
4. no unexpected non-system schema may appear;
5. MariaDB remains healthy.

Only then:

6. start WordPress privately;
7. require no install redirect;
8. update only scalar `home` and `siteurl` rows to `https://minicraft.spikersun.com`;
9. verify internal primary routes and WooCommerce core state;
10. retain:
   `FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`;
11. stop before public ingress.

## RETURN semantics

If any RETURN occurs:

- stop immediately;
- no post-return cleanup requiring service/container start;
- report exact residual state;
- leave accepted K5 source, Secret tree and current project DB state intact for Reviewer.

## Current Gate

```text
CURRENT_GATE=K6_PHASE_D_R4_DETERMINISTIC_FILTERED_IMPORT_RETRY
OWNER_ACTION=NONE
```

## Success contract

```text
PASS_CANDIDATE_K6_PHASE_D_R4_DETERMINISTIC_FILTERED_IMPORT_RETRY
K5_SQL_HASH=PASS
FILTERED_STATEMENT_REMOVED=CREATE_DATABASE_WORDPRESS_EXACTLY_ONE
FILTERED_STREAM_INVARIANTS=PASS
FILTERED_STREAM_HASH=RECORDED_METADATA_ONLY
IMPORT_RETRY_COUNT=1
IMPORT_NATIVE_EXIT=0
ROOT_WORDPRESS_TABLE_COUNT=52
ROOT_TABLE_SET_MATCH=PASS
APP_WORDPRESS_TABLE_COUNT=52
APP_TABLE_SET_MATCH=PASS
WP_OPTIONS_PRESENT=YES
WORDPRESS_INSTALL_REDIRECT=NO
HOME_SITEURL_SCALAR_UPDATE=PASS
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_INTERNAL_PRIMARY_ROUTES=PASS
WOOCOMMERCE_CORE_STATE=PASS
PUBLIC_INGRESS_CHANGE=0
PAYPAL_LIVE=NO
REAL_PAYMENT_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

This Gate does not authorize serialized migration or public ingress.
