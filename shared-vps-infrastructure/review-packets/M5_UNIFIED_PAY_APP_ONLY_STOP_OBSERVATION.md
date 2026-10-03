# M5 — Unified Pay App-Only Stop Observation

## Gate

```text
GATE=M5_UNIFIED_PAY_APP_ONLY_STOP_OBSERVATION
MODE=BOUNDED_PROJECT_RUNTIME_WRITE
ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Read first

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M4B_R1_HISTORICAL_RECORD_RECONCILIATION_M5_REBASE.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M5_OWNER_AUTHORIZED_UNIFIED_PAY_APP_ONLY_STOP.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md

unified-pay-system/REVIEWER_HANDOFF.md
unified-pay-system/PROJECT_STORAGE_MANIFEST.md
unified-pay-system/PROJECT_RECORD.md

dujiao-next/REVIEWER_HANDOFF.md
```

Use canonical strict SSH to ops@srv1970241.

# Phase A — fresh preflight

Verify exact target and no material drift.

Require:

```text
UNIFIED_PAY_APP_STATE=healthy_or_running
UNIFIED_PAY_POSTGRES_STATE=healthy
UNIFIED_PAY_APP_CONTAINER_PRESENT=YES
UNIFIED_PAY_APP_IMAGE_PRESENT=YES
UNIFIED_PAY_COMPOSE_SOURCE_PRESENT=YES
UNIFIED_PAY_DATA_PRESENT=YES
UNIFIED_PAY_BACKUPS_PRESENT=YES
UNIFIED_PAY_SECRET_SOURCE_PRESENT=YES
PAY_TUNNEL_ORIGIN_EXPECTED=http://unified-pay-app:8080
DUJIAO_APP=healthy
DUJIAO_POSTGRES=healthy
DUJIAO_REDIS=healthy
MINICRAFT_PUBLIC=healthy
SHOP_PUBLIC=healthy
XIANYU_RUNTIME=healthy_or_current_expected_state
```

Freshly reconfirm Dujiao current active configuration has no Unified Pay runtime reference using the already-approved safe key/reference-only method. Do not output config values.

If a new current Dujiao Unified Pay reference appears, do not stop Unified Pay; return to Reviewer.

# Phase B — safe pre-stop snapshot

Record only safe metadata:

- Unified Pay app container ID/name/state/restart count;
- app image ID;
- canonical Compose path/hash;
- PostgreSQL container state/restart count;
- safe aggregate current payment/refund/outbox counts;
- latest durable business activity timestamp/class;
- public health/ready baseline;
- rollback command/source needed to start only app.

Do not output Secrets, client IDs, provider transaction IDs, merchant order IDs, amounts, request bodies or raw config values.

# Phase C — stop app only

Stop only the Unified Pay app service via the canonical Compose project/service.

Do not stop PostgreSQL.

Do not use compose down.

Do not remove the app container.

Do not edit Compose.

Do not mutate Cloudflare Tunnel or DNS.

Do not call any Provider.

# Phase D — immediate post-stop readback

Require:

```text
UNIFIED_PAY_APP_STATE=stopped
UNIFIED_PAY_APP_CONTAINER_PRESENT=YES
UNIFIED_PAY_APP_IMAGE_PRESENT=YES
UNIFIED_PAY_POSTGRES_STATE=healthy
UNIFIED_PAY_DATA_PRESENT=YES
UNIFIED_PAY_BACKUPS_PRESENT=YES
UNIFIED_PAY_SECRET_SOURCE_PRESENT=YES
UNIFIED_PAY_RECREATE_PATH_PRESERVED=YES
```

Check pay.spikersun.com. It is expected to be unavailable because the Tunnel still targets the stopped app. Record only the safe HTTP/Tunnel failure class.

# Phase E — known-project regression

Verify all known projects that must remain unaffected:

- Dujiao app/PostgreSQL/Redis healthy;
- shop.spikersun.com normal;
- Mini Craft public endpoints normal;
- Xianyu current runtime state unchanged;
- cloudflared running;
- spikersun-private present;
- Shared Infrastructure monitor/manual health check normal.

Also inspect bounded recent logs/telemetry for credible current business requests to Unified Pay after the stop if such safe telemetry exists. Do not infer from health probes or Tunnel retries alone.

If any known project regresses because Unified Pay was stopped, or credible active-business caller evidence appears:

1. start only the Unified Pay app via canonical Compose;
2. verify app health/ready;
3. verify affected project recovered;
4. return rollback evidence;
5. do not perform further cleanup.

# Expected non-regression

Failure of pay.spikersun.com itself is expected while app is intentionally stopped and is not a rollback trigger.

# Hard boundaries

```text
UNIFIED_PAY_APP_STOP=YES_EXACTLY_ONE
UNIFIED_PAY_APP_START=ROLLBACK_ONLY
UNIFIED_PAY_DB_STOP=NO
UNIFIED_PAY_CONTAINER_REMOVE=NO
UNIFIED_PAY_IMAGE_DELETE=NO
UNIFIED_PAY_COMPOSE_MUTATION=NO
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

# Evidence persistence

Append to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Fresh-read both writes.

# Success return

```text
PASS_CANDIDATE_M5_UNIFIED_PAY_APP_ONLY_STOP_OBSERVATION
DUJIAO_UNIFIED_PAY_RUNTIME_DEPENDENCY=NO
UNIFIED_PAY_APP_STATE=stopped
UNIFIED_PAY_APP_CONTAINER_PRESENT=YES
UNIFIED_PAY_POSTGRES_STATE=healthy
UNIFIED_PAY_DATA_PRESERVED=YES
UNIFIED_PAY_BACKUPS_PRESERVED=YES
UNIFIED_PAY_RECREATE_PATH_PRESERVED=YES
KNOWN_PROJECT_REGRESSION=NO
PAY_PUBLIC_ENDPOINT_EXPECTED_UNAVAILABLE=YES
CREDIBLE_ACTIVE_BUSINESS_CALLER_AFTER_STOP=NO|YES|UNRESOLVED
ROLLBACK_USED=NO|YES
STOP_AT_REVIEWER=YES
```

Do not remove the stopped app container.
Do not stop PostgreSQL.
Do not delete data/backups/Secrets.
Do not mutate Tunnel/DNS.
Do not enter permanent deletion.