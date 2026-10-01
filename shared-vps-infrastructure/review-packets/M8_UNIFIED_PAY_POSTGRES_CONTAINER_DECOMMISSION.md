# M8 — Unified Pay PostgreSQL Container Decommission

## Gate

```text
GATE=M8_UNIFIED_PAY_POSTGRES_CONTAINER_DECOMMISSION
MODE=BOUNDED_PROJECT_RUNTIME_DELETE
ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Read first

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M7_OWNER_STANDING_AUTHORIZATION_UNIFIED_PAY_DECOMMISSION.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M7_PASS_M8_UNIFIED_PAY_POSTGRES_CONTAINER_DECOMMISSION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md

unified-pay-system/REVIEWER_HANDOFF.md
unified-pay-system/PROJECT_STORAGE_MANIFEST.md
unified-pay-system/PROJECT_RECORD.md
dujiao-next/REVIEWER_HANDOFF.md
```

Use canonical strict SSH to ops@srv1970241.

Owner standing authorization applies. No new Owner checkpoint is required for this Gate.

## Phase A — fresh preflight

Verify:

- Unified Pay app container remains absent;
- Unified Pay PostgreSQL container is still stopped/exited;
- exact DB container ID/name/project/service;
- /srv/data/unified-pay/db exists;
- /srv/backups/unified-pay exists;
- backup count remains 33 unless a harmless new backup was independently created outside this Gate; any unexplained drift returns to Reviewer;
- Secret sources exist by metadata only;
- canonical Compose exists and validates;
- app image remains present;
- PostgreSQL image required by Compose is locally available or otherwise reconstructible without changing current state;
- Dujiao Unified Pay dependency remains NO;
- known projects/monitor baseline remain healthy.

If the DB container is running again or any material recovery asset is missing, do not remove it.

## Phase B — remove exact stopped PostgreSQL container

Remove exactly one verified stopped Unified Pay PostgreSQL container.

Use exact container rm by fresh verified ID, or a canonical Compose service rm only if it affects exactly the stopped db service and nothing else.

Do not use compose down.

Do not delete volume/bind data.
Do not delete PostgreSQL image.
Do not delete app image.
Do not delete Compose.
Do not delete backups or Secrets.
Do not delete networks.

## Phase C — recovery verification

Require:

```text
UNIFIED_PAY_APP_CONTAINER_PRESENT=NO
UNIFIED_PAY_POSTGRES_CONTAINER_PRESENT=NO
UNIFIED_PAY_DATA_PRESENT=YES
UNIFIED_PAY_BACKUPS_PRESENT=YES
UNIFIED_PAY_SECRET_SOURCE_PRESENT=YES
UNIFIED_PAY_APP_IMAGE_PRESENT=YES
UNIFIED_PAY_POSTGRES_IMAGE_RECOVERY_AVAILABLE=YES
UNIFIED_PAY_COMPOSE_SOURCE_PRESENT=YES
UNIFIED_PAY_FULL_RUNTIME_RECREATE_PATH_PRESERVED=YES
```

Do not actually recreate containers on success.

## Phase D — regression verification

Verify:

- Dujiao app/PostgreSQL/Redis healthy;
- shop.spikersun.com normal;
- Mini Craft public endpoints normal;
- Xianyu runtime unchanged;
- cloudflared running;
- spikersun-private present;
- Shared Infrastructure monitor manual run PASS.

pay.spikersun.com remaining unavailable is expected.

If a known project regresses because of this removal, recreate only the Unified Pay PostgreSQL service from canonical Compose/data and return to Reviewer.

## Hard boundaries

```text
UNIFIED_PAY_POSTGRES_CONTAINER_REMOVE=YES_EXACTLY_ONE
UNIFIED_PAY_POSTGRES_IMAGE_DELETE=NO
UNIFIED_PAY_APP_IMAGE_DELETE=NO
UNIFIED_PAY_DATA_DELETE=NO
UNIFIED_PAY_BACKUP_DELETE=NO
UNIFIED_PAY_SECRET_DELETE=NO
UNIFIED_PAY_COMPOSE_DELETE=NO
UNIFIED_PAY_NETWORK_DELETE=NO
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
PASS_CANDIDATE_M8_UNIFIED_PAY_POSTGRES_CONTAINER_DECOMMISSION
UNIFIED_PAY_APP_CONTAINER_PRESENT=NO
UNIFIED_PAY_POSTGRES_CONTAINER_PRESENT=NO
UNIFIED_PAY_DATA_PRESENT=YES
UNIFIED_PAY_BACKUPS_PRESENT=YES
UNIFIED_PAY_SECRET_SOURCE_PRESENT=YES
UNIFIED_PAY_APP_IMAGE_PRESENT=YES
UNIFIED_PAY_POSTGRES_IMAGE_RECOVERY_AVAILABLE=YES
UNIFIED_PAY_COMPOSE_SOURCE_PRESENT=YES
UNIFIED_PAY_FULL_RUNTIME_RECREATE_PATH_PRESERVED=YES
KNOWN_PROJECT_REGRESSION=NO
ROLLBACK_USED=NO|YES
STOP_AT_REVIEWER=YES
```

Do not delete database files.
Do not delete backups/Secrets/images/Compose/networks.
Do not mutate Tunnel/DNS.
