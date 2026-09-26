# Reviewer Decision — K6 D-R2 RETURN Accepted; D-R3 Database Restore Diagnosis + Conditional Retry

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed result

```text
GATE=K6_PHASE_D_R2_COMPOSE_SOT_RECONCILIATION_AND_PRIVATE_RESTORE
RESULT=RETURN_D_R2_MARIADB_RESTORE_INCOMPLETE
EXECUTOR_FINAL_COMMIT=b9c78be18d0e4f9019cbe47a9f6f84cb80ceff59
```

Reviewer accepts the RETURN as correct and fail-closed.

Accepted facts:

- canonical Compose source reconciliation PASSed at the accepted `C52E1...` source;
- digest-pinned resolved Compose rendered and semantic diff was image references only;
- accepted K5 SQL/wp-content staged copies still hash-match;
- wp-content restore PASSed;
- MariaDB container health PASSed;
- target WordPress schema as visible to the application reported zero business tables and `wp_options` absent;
- WordPress therefore redirected to install and was not application-ready;
- `home` / `siteurl` were not changed;
- full serialized migration was not attempted;
- both Mini Craft application containers ended stopped;
- Secret tree and staged K5 sources remained unchanged;
- no host port/public ingress/Shared Infra/payment/Live action occurred.

The SQL recovery source is structurally non-empty: metadata-only parsing recorded 52 table-creation statements and 36 insert statements. Container health therefore does not establish restore success.

## Governance deviation noted

After the Gate had already returned, Executor briefly started the stopped WordPress container solely to remove a temporary non-secret helper, then immediately stopped it and verified the helper absent.

The final state is clean and no Secret/public/shared-infrastructure impact is evidenced, so no rollback is required. However this was a process deviation from the `RETURN -> STOP_AT_REVIEWER` rule.

```text
POST_RETURN_EXECUTION_DEVIATION=RECORDED_NON_COMPROMISING
FUTURE_POST_RETURN_CLEANUP_WITHOUT_REVIEWER=FORBIDDEN
```

Any future RETURN must stop immediately. Residual cleanup requiring service/container start must be separately reviewed.

## Current diagnosis

The unresolved question is not "is MariaDB running?" but:

1. did the accepted dump target `wordpress` or another schema;
2. do tables actually exist under root visibility but not under application-user visibility;
3. did the init import execute against an empty/incorrect database;
4. did the import path silently leave the target schema empty.

Do not assume the cause.

## Current Gate

```text
CURRENT_GATE=K6_PHASE_D_R3_DB_RESTORE_DIAGNOSIS_AND_CONDITIONAL_RETRY
OWNER_ACTION=NONE
```

This Gate is covered by the existing bounded K6 Sandbox-first deployment authorization and is project-local only.

## Phase A — metadata-only DB restore diagnosis

Start **only Mini Craft MariaDB** privately, using the already accepted digest-pinned Compose/runtime state. Do not start WordPress until Phase B acceptance conditions are satisfied.

Before any DB write:

### A1. Recovery source structure

Parse the accepted hash-matching K5 SQL dump without emitting row values.

Record metadata only:

- exact count/set of unique `CREATE TABLE` target identifiers;
- any `CREATE DATABASE` statements;
- any `USE <schema>` statements;
- any schema-qualified DDL target;
- presence/count only of `INSERT` statements;
- presence of destructive/account statements:
  - `DROP DATABASE`
  - `DROP USER`
  - `ALTER USER`
  - `GRANT`
  - `REVOKE`
  - other cross-schema/account mutation.

Do not print INSERT rows or user/business content.

### A2. Current database state

Using a bounded client path that does not expose credentials in argv/env/log/stdout:

- authenticate through the existing Secret file via an in-container, root-only **tmpfs-only** client option file or equivalent reviewed memory-only mechanism;
- never persist the credential file to host/durable container storage;
- delete/zero the temporary client config before command exit;
- query metadata only.

Record as root/admin metadata:

- user-created schema names only;
- table count per user schema;
- exact table-name set for `wordpress`;
- whether `wp_options` exists;
- target application-user account existence and grants metadata without password/hash.

Then record the same target-schema table visibility using the application-user identity, again without exposing credentials.

### A3. Branch decision

**Branch 1 — Root sees the exact expected table set in `wordpress`, app user does not:**

Do not reimport. Reviewer preauthorizes only the minimum DB privilege reconciliation necessary to restore the intended app user's access to `wordpress`, provided:
- app account identity matches the resolved Compose;
- no unexpected existing privilege target is observed;
- no password rotation is required.

After bounded grant repair, recheck exact table visibility.

**Branch 2 — Root sees zero application tables in `wordpress`, dump metadata targets `wordpress`/unqualified target correctly, and no unexpected/destructive cross-schema/account statements are present:**

Authorize one explicit DB-native import retry into the existing empty `wordpress` schema using the accepted K5 SQL source.

The retry must:
- use a credential-safe tmpfs/memory-only client auth path;
- direct the client explicitly to database `wordpress`;
- capture only native exit status + filtered error classification;
- never emit SQL row content or credential values;
- execute exactly once.

**Branch 3 — tables exist in an unexpected schema, `wordpress` is partially populated, dump targets conflict, or destructive/account/cross-schema statements are present:**

`RETURN_REVIEWER_D_R3_SCHEMA_OR_DUMP_DRIFT` before DB mutation.

No dropping/recreating databases or deleting the MariaDB datadir is authorized in D-R3.

## Phase B — restore verification and bounded continuation

Only after Branch 1 repair or Branch 2 explicit import succeeds:

1. compare root-visible target table set to the dump's parsed unique expected table set;
2. require `wp_options` present;
3. require application user to see the expected target tables;
4. run basic DB integrity metadata checks without business-row output;
5. start WordPress privately;
6. require no install redirect;
7. update only scalar `home` and `siteurl` rows to `https://minicraft.spikersun.com`;
8. recheck internal WordPress primary routes and WooCommerce core state;
9. retain:
   `FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`;
10. stop before public ingress.

## Credential safety

Forbidden:
- password/Secret in command argv;
- credential environment variables;
- host plaintext credential temp files;
- output/hash of Secret value;
- durable container plaintext credential file.

A root-only tmpfs client config created/read/deleted within the bounded MariaDB container is permitted solely to bridge the existing Secret file to the database client without value exposure.

## Hard boundaries

No:
- MariaDB datadir deletion/reinitialization;
- database drop/recreate;
- broad import retries;
- wp-content rewrite beyond already restored state;
- full serialized URL migration;
- Caddy/cloudflared/DNS/UFW/SSH/Docker-daemon/shared-network mutation;
- host port/public ingress;
- Secret rotation/overwrite/content/hash;
- PayPal Live/payment/refund;
- unrelated project changes;
- post-RETURN cleanup actions that start containers.

## Required success evidence

```text
PASS_CANDIDATE_K6_PHASE_D_R3_DB_RESTORE_DIAGNOSIS_AND_CONDITIONAL_RETRY
K5_SQL_HASH=PASS
DUMP_EXPECTED_TABLE_SET=RECORDED_METADATA_ONLY
DUMP_SCHEMA_TARGET=PASS
DUMP_DESTRUCTIVE_ACCOUNT_DRIFT=NONE
ROOT_WORDPRESS_TABLE_SET=EXPECTED
WP_OPTIONS_PRESENT=YES
APP_USER_TABLE_VISIBILITY=EXPECTED
RESTORE_PATH=<EXISTING_SCHEMA_PRIVILEGE_REPAIR|EXPLICIT_SINGLE_IMPORT_RETRY>
RESTORE_NATIVE_EXIT=0_OR_NOT_REQUIRED
WORDPRESS_INSTALL_REDIRECT=NO
HOME_SITEURL_SCALAR_UPDATE=PASS
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_INTERNAL_PRIMARY_ROUTES=PASS
WOOCOMMERCE_CORE_STATE=PASS
PAYPAL_LIVE=NO
PUBLIC_INGRESS_CHANGE=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

Otherwise return a precise `RETURN_*` and stop immediately with no post-return service cleanup.
