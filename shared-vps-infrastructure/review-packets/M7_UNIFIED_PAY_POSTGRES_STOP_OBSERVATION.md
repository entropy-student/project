# M7 — Unified Pay PostgreSQL Stop Observation

## Gate

```text
GATE=M7_UNIFIED_PAY_POSTGRES_STOP_OBSERVATION
MODE=BOUNDED_PROJECT_RUNTIME_WRITE
ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Read first

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M6_PASS_M7_UNIFIED_PAY_POSTGRES_STOP_CHECKPOINT.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M7_OWNER_STANDING_AUTHORIZATION_UNIFIED_PAY_DECOMMISSION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md

unified-pay-system/REVIEWER_HANDOFF.md
unified-pay-system/PROJECT_STORAGE_MANIFEST.md
unified-pay-system/PROJECT_RECORD.md
dujiao-next/REVIEWER_HANDOFF.md
```

Use canonical strict SSH to ops@srv1970241.

## Phase A — preflight

Freshly verify:

- Unified Pay app container remains absent;
- Unified Pay PostgreSQL is running/healthy;
- exact PostgreSQL container ID/name/project/service;
- canonical Compose source exists and validates;
- /srv/data/unified-pay/db exists;
- /srv/backups/unified-pay exists;
- Secret sources exist by metadata only;
- app image remains present;
- Dujiao Unified Pay runtime dependency remains NO;
- Dujiao/Shop, Mini Craft, Xianyu, cloudflared, spikersun-private and Shared monitor are healthy.

If any material drift or new dependency appears, do not stop PostgreSQL; return to Reviewer.

## Phase B — safe snapshot

Record only safe metadata:

- PostgreSQL container ID/state/restart count;
- Compose path/hash;
- data directory presence/metadata only;
- backup count/size/timestamps without reading backup contents;
- last known Unified Pay durable activity already accepted;
- rollback command/source.

Do not output credentials, DB rows, customer data, IDs, payment data or Secret content.

## Phase C — stop PostgreSQL only

Stop only the Unified Pay PostgreSQL service/container using canonical Compose service stop or exact verified container stop.

Do not remove the container.
Do not use compose down.
Do not delete data/volume/backups/Secrets.

## Phase D — verify

Require:

```text
UNIFIED_PAY_APP_CONTAINER_PRESENT=NO
UNIFIED_PAY_POSTGRES_STATE=stopped
UNIFIED_PAY_POSTGRES_CONTAINER_PRESENT=YES
UNIFIED_PAY_DATA_PRESENT=YES
UNIFIED_PAY_BACKUPS_PRESENT=YES
UNIFIED_PAY_SECRET_SOURCE_PRESENT=YES
UNIFIED_PAY_APP_IMAGE_PRESENT=YES
UNIFIED_PAY_COMPOSE_SOURCE_PRESENT=YES
UNIFIED_PAY_FULL_RUNTIME_RECREATE_PATH_PRESERVED=YES
```

## Phase E — regression observation

Verify Dujiao/Shop, Mini Craft, Xianyu, cloudflared, spikersun-private and Shared monitor remain normal.

pay.spikersun.com remains expected unavailable and is not a rollback trigger.

If any known project regresses due to the DB stop:

1. start only Unified Pay PostgreSQL;
2. verify it becomes healthy;
3. verify affected project recovers;
4. return rollback evidence;
5. stop at Reviewer.

## Hard boundaries

```text
UNIFIED_PAY_POSTGRES_STOP=YES_EXACTLY_ONE
UNIFIED_PAY_POSTGRES_START=ROLLBACK_ONLY
UNIFIED_PAY_POSTGRES_CONTAINER_REMOVE=NO
UNIFIED_PAY_DATA_DELETE=NO
UNIFIED_PAY_BACKUP_DELETE=NO
UNIFIED_PAY_SECRET_DELETE=NO
UNIFIED_PAY_APP_IMAGE_DELETE=NO
UNIFIED_PAY_COMPOSE_DELETE=NO
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
SHARED_INFRA_MUTATIONS=0
PROVIDER_CALLS=0
PAYMENT_ACTIONS=0
BROAD_PRUNE=NO
```

## Evidence

Append to shared-vps-infrastructure/EXECUTION_EVIDENCE.md and EXECUTOR_HANDOFF.md, then fresh-read both.

## Success return

```text
PASS_CANDIDATE_M7_UNIFIED_PAY_POSTGRES_STOP_OBSERVATION
UNIFIED_PAY_APP_CONTAINER_PRESENT=NO
UNIFIED_PAY_POSTGRES_STATE=stopped
UNIFIED_PAY_POSTGRES_CONTAINER_PRESENT=YES
UNIFIED_PAY_DATA_PRESERVED=YES
UNIFIED_PAY_BACKUPS_PRESERVED=YES
UNIFIED_PAY_FULL_RUNTIME_RECREATE_PATH_PRESERVED=YES
KNOWN_PROJECT_REGRESSION=NO
ROLLBACK_USED=NO|YES
STOP_AT_REVIEWER=YES
```

Do not remove PostgreSQL container in M7.
Do not delete data/backups/Secrets.
Do not mutate Tunnel/DNS.
