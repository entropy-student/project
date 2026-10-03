# M6 — Unified Pay App Container Decommission

## Gate

```text
GATE=M6_UNIFIED_PAY_APP_CONTAINER_DECOMMISSION
MODE=BOUNDED_PROJECT_RUNTIME_DELETE
ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Read first

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M5_PASS_M6_UNIFIED_PAY_APP_CONTAINER_DECOMMISSION_CHECKPOINT.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M6_OWNER_AUTHORIZED_UNIFIED_PAY_APP_CONTAINER_DECOMMISSION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md

unified-pay-system/REVIEWER_HANDOFF.md
unified-pay-system/PROJECT_STORAGE_MANIFEST.md
unified-pay-system/PROJECT_RECORD.md
dujiao-next/REVIEWER_HANDOFF.md
```

Use canonical strict SSH to ops@srv1970241.

## Phase A — fresh preflight

Freshly verify:

- target host identity;
- Unified Pay app container is still stopped/exited;
- exact app container ID/name;
- app image still local;
- PostgreSQL still running/healthy;
- canonical Compose source exists and hash is unchanged;
- /srv/data/unified-pay exists;
- /srv/backups/unified-pay exists;
- Secret source directory/files exist by metadata only;
- Dujiao current Unified Pay runtime dependency remains NO;
- Dujiao/Shop, Mini Craft, Xianyu, cloudflared and Shared monitor baseline remain healthy.

If app is running again, PostgreSQL is unhealthy, rollback assets are missing, Dujiao dependency reappears, or any material baseline regresses: do not remove anything; return to Reviewer.

## Phase B — remove stopped app container only

Remove exactly the verified stopped Unified Pay app container.

Preferred: exact container removal by verified container identity, or a canonical Compose service rm command only if it provably affects exactly the stopped app container and no dependency/network lifecycle.

Forbidden:

- compose down;
- stopping PostgreSQL;
- removing PostgreSQL container;
- docker system/container/image/network/volume prune;
- image rm;
- network rm;
- volume rm;
- deleting Compose;
- deleting /srv/data/unified-pay;
- deleting /srv/backups/unified-pay;
- deleting Secret sources;
- Cloudflare/DNS/Tunnel mutation;
- Provider/payment action;
- unrelated service mutation.

## Phase C — verify preserved recovery path

Require:

```text
UNIFIED_PAY_APP_CONTAINER_PRESENT=NO
UNIFIED_PAY_APP_IMAGE_PRESENT=YES
UNIFIED_PAY_POSTGRES_STATE=healthy
UNIFIED_PAY_COMPOSE_SOURCE_PRESENT=YES
UNIFIED_PAY_DATA_PRESENT=YES
UNIFIED_PAY_BACKUPS_PRESENT=YES
UNIFIED_PAY_SECRET_SOURCE_PRESENT=YES
UNIFIED_PAY_RECREATE_PATH_PRESERVED=YES
```

Recreate path means the retained image + Compose + Secrets + PostgreSQL/data are sufficient to create the app container again if a later rollback is authorized.

Do not actually recreate during a success path.

## Phase D — regression verification

Verify:

- Dujiao app/PostgreSQL/Redis healthy;
- shop.spikersun.com normal;
- Mini Craft Home/Shop/wp-json normal;
- Xianyu current runtime unchanged;
- cloudflared running;
- spikersun-private present;
- Shared Infrastructure monitor manual run PASS.

pay.spikersun.com remaining unavailable is expected and is not itself a regression.

If any known project regresses due to removal, do not improvise. Recreate only the Unified Pay app from preserved canonical assets as rollback, verify recovery, and return to Reviewer.

## Hard boundaries

```text
UNIFIED_PAY_APP_CONTAINER_REMOVE=YES_EXACTLY_ONE
UNIFIED_PAY_APP_IMAGE_DELETE=NO
UNIFIED_PAY_DB_STOP=NO
UNIFIED_PAY_DB_CONTAINER_REMOVE=NO
UNIFIED_PAY_COMPOSE_DELETE=NO
UNIFIED_PAY_DATA_DELETE=NO
UNIFIED_PAY_BACKUP_DELETE=NO
UNIFIED_PAY_SECRET_DELETE=NO
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
DATABASE_WRITES=0
PROVIDER_CALLS=0
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
BROAD_PRUNE=NO
```

## Evidence

Append to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Fresh-read both after persistence.

## Success return

```text
PASS_CANDIDATE_M6_UNIFIED_PAY_APP_CONTAINER_DECOMMISSION
UNIFIED_PAY_APP_CONTAINER_PRESENT=NO
UNIFIED_PAY_APP_IMAGE_PRESENT=YES
UNIFIED_PAY_POSTGRES_STATE=healthy
UNIFIED_PAY_COMPOSE_SOURCE_PRESENT=YES
UNIFIED_PAY_DATA_PRESENT=YES
UNIFIED_PAY_BACKUPS_PRESENT=YES
UNIFIED_PAY_SECRET_SOURCE_PRESENT=YES
UNIFIED_PAY_RECREATE_PATH_PRESERVED=YES
KNOWN_PROJECT_REGRESSION=NO
ROLLBACK_USED=NO|YES
STOP_AT_REVIEWER=YES
```

Do not stop/remove PostgreSQL.
Do not delete image/Compose/data/backups/Secrets.
Do not mutate Tunnel/DNS.
Do not enter permanent deletion.