# M3A — Caddy + Unified Pay Decommission Assessment

## Gate

```text
GATE=M3A_CADDY_UNIFIED_PAY_DECOMMISSION_ASSESSMENT
MODE=READ_ONLY
ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Read first

Read completely:

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/SHARED_VPS_PORTFOLIO.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2E_R3_PASS_MINICRAFT_INGRESS_MIGRATION_COMPLETE.md

unified-pay-system/REVIEWER_HANDOFF.md
unified-pay-system/PROJECT_STORAGE_MANIFEST.md
unified-pay-system/PROJECT_RECORD.md

dujiao-next/REVIEWER_HANDOFF.md
xianyu/REVIEWER_HANDOFF.md
mini-craft-night-kit/REVIEWER_HANDOFF.md
```

Use canonical strict SSH to `ops@srv1970241`. All target-host work is read-only.

## Part 1 — target/runtime inventory

Freshly record:

- target host identity;
- disk/resource summary;
- running/stopped container inventory with project/service/image/state/networks;
- Docker network inventory;
- Compose labels sufficient to identify canonical projects;
- no Secret values.

Identify exactly:

- Shared Caddy;
- cloudflared;
- Unified Pay app + PostgreSQL;
- Dujiao app + PostgreSQL + Redis;
- Xianyu app;
- Mini Craft WordPress + MariaDB.

## Part 2 — Caddy retirement assessment

Fresh-read current Caddy source and runtime metadata.

Collect safe facts only:

- current Caddyfile byte count/hash;
- semantic hostnames/routes only;
- active Admin config hostname/route semantics if safely available;
- exact Compose project/service/path/image/ports/networks/mounts;
- contents/ownership/size metadata for Caddy persistence directories without exposing sensitive certificate material;
- all current containers connected to `spikersun-edge`;
- source/Compose references to `spikersun-edge` and Caddy across active projects;
- public/direct-origin regression for any currently configured Caddy hostname.

Classify each Caddy route as:

```text
PRODUCTION_REQUIRED
ROLLBACK_REQUIRED
TEST_OR_DIAGNOSTIC
UNREFERENCED
UNKNOWN
```

Return exact dependency counts and `CADDY_RETIREMENT_SAFE`.

## Part 3 — Unified Pay ingress and active callers

Freshly identify:

- Unified Pay Compose project/service/source;
- app/PostgreSQL runtime identity;
- networks and aliases;
- current public `pay.spikersun.com` route and Tunnel mapping;
- public health/ready behavior.

Search active project configuration/source and target-host Compose/config metadata for exact Unified Pay references.

At minimum cover:

- Dujiao;
- Xianyu;
- Mini Craft;
- Shared Infra;
- any other currently running project.

Reference patterns include:

```text
pay.spikersun.com
unified-pay
unified-pay-app
known Unified Pay API/base-URL variable names
```

Do not dump `.env`, Docker environment values, credentials or Secret files.

If a sensitive location contains a match, record only:

```text
PROJECT=<name>
LOCATION=<safe path/container>
KEY_NAME=<if safely visible>
DEPENDENCY_REFERENCE=PRESENT
VALUE_REDACTED=YES
```

Do not infer active use from a stale source reference alone; correlate with current runtime/config where safely possible.

## Part 4 — Unified Pay business-state barrier

Use read-only local DB queries that return safe aggregates only.

Do not output customer identifiers, transaction IDs, provider IDs, tokens, addresses, emails, webhook payloads or other private data.

Determine safe aggregate counts/status classes sufficient to answer:

- any real orders/payments present;
- any nonterminal payments;
- any refunds/disputes;
- any issued entitlements/licenses;
- any pending webhook/outbox/retry records;
- latest business activity time only if it can be returned without exposing private data;
- provider/channel enabled/disabled flags only as non-secret booleans or enum states.

If schema uncertainty prevents safe query design, return `UNRESOLVED`; do not explore private rows.

## Part 5 — Unified Pay recovery barrier

Freshly inventory without reading Secret values:

```text
/srv/apps/unified-pay
/srv/data/unified-pay
/srv/backups/unified-pay
```

Record:

- sizes;
- file/directory classes;
- database persistence path;
- existing logical backup/archive artifacts and timestamps;
- backup checksums if practical;
- protected Secret recovery metadata only;
- GitHub reconstructible source state.

Determine separately:

```text
RUNTIME_RECONSTRUCTIBLE=YES|NO|UNRESOLVED
DATABASE_RECOVERABLE=YES|NO|UNRESOLVED
SECRET_RECOVERY_PRESENT=YES|NO|UNRESOLVED
UNIFIED_PAY_RECOVERY_BARRIER=PASS|FAIL|UNRESOLVED
```

Do not delete, rotate, decrypt, copy or expose Secrets.

## Part 6 — dependency-aware decommission design

Return the smallest safe phased plan.

Separate:

1. public ingress retirement;
2. runtime stop/observation;
3. container/network runtime removal;
4. app source disposition;
5. durable database/data disposition;
6. backup retention/deletion;
7. provider/webhook external cleanup;
8. Caddy stop/observation/removal;
9. `spikersun-edge` network disposition.

Each proposed mutation phase must list:

- preconditions;
- exact scope;
- rollback;
- evidence;
- Owner checkpoint requirement.

## Hard boundaries

```text
CADDY_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
UNIFIED_PAY_RUNTIME_MUTATIONS=0
DATABASE_WRITES=0
PROVIDER_MUTATIONS=0
SECRET_MUTATIONS=0
FILE_DELETIONS=0
BACKUP_DELETIONS=0
NETWORK_MUTATIONS=0
BROAD_PRUNE=NO
PAYMENT_ACTIONS=0
```

## Evidence persistence

Append the bounded result to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

If Unified Pay project-specific facts materially advance, also update its Executor-side factual handoff if one exists; do not overwrite Reviewer truth.

Fresh-read GitHub after persistence.

## Success return

```text
PASS_CANDIDATE_M3A_CADDY_UNIFIED_PAY_DECOMMISSION_ASSESSMENT
CADDY_RETIREMENT_SAFE=YES|NO|UNRESOLVED
UNIFIED_PAY_ACTIVE_CALLERS=<count>
UNIFIED_PAY_RUNTIME_RETIREMENT_SAFE=YES|NO|UNRESOLVED
UNIFIED_PAY_DATA_DELETION_SAFE=YES|NO|UNRESOLVED
UNIFIED_PAY_RECOVERY_BARRIER=PASS|FAIL|UNRESOLVED
MUTATIONS=0
STOP_AT_REVIEWER=YES
```
