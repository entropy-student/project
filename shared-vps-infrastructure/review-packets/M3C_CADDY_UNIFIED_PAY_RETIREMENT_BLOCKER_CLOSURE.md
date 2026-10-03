# M3C — Caddy + Unified Pay Retirement Blocker Closure

## Gate

```text
GATE=M3C_CADDY_UNIFIED_PAY_RETIREMENT_BLOCKER_CLOSURE
MODE=BOUNDED_READONLY_RECONCILIATION
ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Read first

Read completely:

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/SHARED_VPS_PORTFOLIO.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M3B_PASS_M3C_RETIREMENT_BLOCKER_CLOSURE.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md

unified-pay-system/REVIEWER_HANDOFF.md
unified-pay-system/PROJECT_STORAGE_MANIFEST.md
unified-pay-system/PROJECT_RECORD.md

dujiao-next/REVIEWER_HANDOFF.md
xianyu/REVIEWER_HANDOFF.md
mini-craft-night-kit/REVIEWER_HANDOFF.md
```

Use canonical strict SSH to `ops@srv1970241`.

Do not modify runtime/config except for the single bounded provider read-only query explicitly authorized below, which must itself be non-mutating.

# Part A — classify the one recent Unified Pay caller

Accepted baseline:

```text
REGISTERED_ACTIVE_CLIENTS=2
RECENT_PAYMENT_AUDIT_EVENTS=2
RECENT_DISTINCT_CLIENT_REFERENCES=1
LATEST_RECENT_EVENT=2026-09-14T16:45:03Z
```

Map the distinct recent client reference to a safe internal purpose/project classification using registration metadata only.

Do not output:
- client ID;
- credential ID;
- client secret;
- token;
- private user identity.

Allowed output:

```text
LIVE_CALLER_CLASS=INTERNAL_PROJECT:<safe project name>
```

or

```text
LIVE_CALLER_CLASS=HISTORICAL_TEST_OR_CANARY
```

or

```text
LIVE_CALLER_CLASS=EXTERNAL_OR_UNKNOWN
```

Correlate its safe activity timestamp/event classes with the one created intent / ambiguous provider-create attempt.

Determine whether there is evidence of any activity after that historical event window.

Return:

```text
UNIFIED_PAY_LIVE_CALLERS=<0|1|UNRESOLVED>
LIVE_CALLER_CLASS=<classification>
LIVE_CALLER_LAST_ACTIVITY=<safe timestamp or NONE>
LIVE_CALLER_ACTIVITY_AFTER_AMBIGUOUS_WINDOW=YES|NO|UNRESOLVED
LIVE_CALLER_RETIREMENT_BLOCKER=YES|NO|UNRESOLVED
```

Do not infer "live" merely because the registration remains active.

# Part B — one bounded Alipay read-only reconciliation

Accepted local state:

```text
PAYMENT_INTENTS_CREATED=1
PROVIDER_CREATE_ATTEMPTS_AMBIGUOUS=1
PROVIDER_CREATE_ATTEMPTS_TERMINAL=0
PROVIDER_EVENTS=0
PROVIDER_PAYMENT_FACTS=0
REFUNDS=0
OUTBOX_EVENTS=0
PROVIDER_ACCOUNT_ACTIVE=true
PROVIDER_ACCOUNT_ENABLED=false
```

Before any provider query, inspect the current adapter/code path read-only and prove that a provider order/status inquiry is read-only and can use existing protected runtime credentials without emitting them.

If and only if that is proven, execute exactly one provider read-only inquiry for the one ambiguous attempt.

Hard requirements:

- no payment create/retry;
- no cancel;
- no refund;
- no webhook replay;
- no provider setting change;
- no database write;
- no credential output;
- no transaction/order/provider identifier output;
- no raw provider request/response output;
- no amount/customer/private data output.

Reduce the provider result immediately to one of:

```text
AMBIGUOUS_PAYMENT_STATE=RECONCILED_TERMINAL
```

```text
AMBIGUOUS_PAYMENT_STATE=PROVEN_NOT_COMMITTED
```

```text
AMBIGUOUS_PAYMENT_STATE=UNRESOLVED
```

Also return:

```text
PROVIDER_QUERY_PATH_PROVEN_READONLY=YES|NO
PROVIDER_QUERY_PERFORMED=YES|NO
PROVIDER_QUERY_COUNT=0|1
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
DATABASE_WRITES=0
```

If a safe query cannot be proven, do not contact Alipay.

# Part C — seal Caddy monitor replacement

Inspect read-only:

- spikersun-infra-health.timer;
- spikersun-infra-health.service;
- current check-shared-infra.sh;
- its current probe set and failure semantics.

Design the smallest replacement that removes dependency on:

`https://localhost:443`

and does not require Caddy or host 80/443.

Prefer checks of the actual desired architecture:

1. target host / Docker availability;
2. cloudflared running/restart state;
3. spikersun-private presence;
4. current public production endpoint health through Cloudflare Tunnel for at least Mini Craft and Shop;
5. Pay only if Unified Pay remains intentionally active at the time of later monitor migration.

Do not edit timer/service/script now.

Return an exact semantic replacement plan:

```text
CADDY_MONITOR_REPLACEMENT_PLAN=SEALED|UNRESOLVED
CURRENT_CADDY_DEPENDENT_PROBE=https://localhost:443
REPLACEMENT_PROBES=<safe semicolon-separated semantic list>
CADDY_DEPENDENT_PROBE_REMOVABLE=YES|NO|UNRESOLVED
MONITOR_ROLLBACK_METHOD=<safe summary>
```

Do not create new monitoring architecture beyond what is necessary to retire Caddy.

# Part D — Unified Pay reversible stop/observe rollback preflight

Read-only prove that a later app-stop Gate can preserve:

- PostgreSQL container/data unchanged;
- /srv/data/unified-pay unchanged;
- /srv/backups/unified-pay unchanged;
- current app image available locally;
- canonical Compose source present;
- current Secret source files present with safe permissions metadata only;
- exact Tunnel route metadata known;
- exact current app container/service identity known.

Return:

```text
UNIFIED_PAY_STOP_OBSERVE_ROLLBACK_READY=YES|NO|UNRESOLVED
ROLLBACK_RESTART_SOURCE=<safe Compose/service summary>
DATA_PRESERVATION_PLAN=SEALED|UNRESOLVED
```

Do not perform restore, stop, restart, recreate or backup mutation.

# Hard boundaries

```text
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
CADDY_MUTATIONS=0
MONITOR_CONFIG_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
DATABASE_WRITES=0
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_OUTPUT=0
BACKUP_MUTATIONS=0
FILE_DELETIONS=0
NETWORK_MUTATIONS=0
BROAD_PRUNE=NO
```

The single provider status inquiry, if safely proven read-only, is not a mutation and is capped at one.

# Evidence persistence

Append to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Fresh-read both GitHub writes.

# Success return

```text
PASS_CANDIDATE_M3C_CADDY_UNIFIED_PAY_RETIREMENT_BLOCKER_CLOSURE
UNIFIED_PAY_LIVE_CALLERS=<0|1|UNRESOLVED>
LIVE_CALLER_CLASS=<safe classification>
LIVE_CALLER_RETIREMENT_BLOCKER=YES|NO|UNRESOLVED
PROVIDER_QUERY_PERFORMED=YES|NO
AMBIGUOUS_PAYMENT_STATE=RECONCILED_TERMINAL|PROVEN_NOT_COMMITTED|UNRESOLVED
CADDY_MONITOR_REPLACEMENT_PLAN=SEALED|UNRESOLVED
CADDY_DEPENDENT_PROBE_REMOVABLE=YES|NO|UNRESOLVED
UNIFIED_PAY_STOP_OBSERVE_ROLLBACK_READY=YES|NO|UNRESOLVED
MUTATIONS=0
STOP_AT_REVIEWER=YES
```
