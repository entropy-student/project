# M3B — Caddy + Unified Pay Dependency Reconciliation

## Gate

```text
GATE=M3B_CADDY_UNIFIED_PAY_DEPENDENCY_RECONCILIATION
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
shared-vps-infrastructure/docs/REVIEWER_DECISION_M3A_PASS_M3B_DEPENDENCY_RECONCILIATION.md
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

This Gate is strictly read-only.

# Part A — classify the 2 registered Unified Pay clients

Do not treat registration as live use.

Using only safe aggregates/metadata, determine whether either registered client has evidence of recent/current requests or durable business activity attributable to it.

Prefer:
- safe aggregate request counters;
- last-activity timestamps without client identity;
- non-private application metrics;
- safe log aggregation by client class if available without outputting IDs, tokens, URLs, request bodies or business identifiers.

Do not emit client IDs/names/credentials.

Return exactly:

```text
UNIFIED_PAY_REGISTERED_ACTIVE_CLIENTS=2
UNIFIED_PAY_LIVE_CALLERS=<0|1|2|UNRESOLVED>
LIVE_CALLER_EVIDENCE=<safe aggregate description>
```

If no trustworthy traffic/activity source exists, return UNRESOLVED.

# Part B — Dujiao current dependency classification

Re-check deployed source/Compose/runtime config for Unified Pay dependency.

Search non-secret active source/config first.

For Secret-mounted current config, key-name/reference classification is allowed only if values can be fully suppressed.

Allowed result shape:

```text
PROJECT=dujiao-next
LOCATION=<safe path>
KEY_NAME=<key name only>
UNIFIED_PAY_REFERENCE_CLASS=PRESENT|ABSENT|UNRESOLVED
VALUE_OUTPUT=NO
```

Never emit:
- URL values;
- tokens;
- passwords;
- provider credentials;
- client IDs/secrets;
- payment account identifiers;
- full Secret lines.

If safe key-only parsing cannot be guaranteed, do not inspect contents; return UNRESOLVED.

Correlate with:
- three payment channel active flags;
- channel_clients aggregate;
- downstream_order_refs aggregate;
- current app runtime behavior/config references.

Return:

```text
DUJIAO_UNIFIED_PAY_DEPENDENCY=YES|NO|UNRESOLVED
```

# Part C — exact pay.spikersun.com Tunnel target

Determine the current remote-managed Cloudflare Tunnel public-hostname mapping for:

`pay.spikersun.com`

Use an already-authenticated read-only control-plane path if available.

Do not request credentials in chat and do not expose Tunnel token/cookie/session data.

Return only safe metadata:

```text
PAY_PUBLIC_HOST=pay.spikersun.com
PAY_TUNNEL=<safe tunnel name/id classification>
PAY_TUNNEL_ORIGIN=<service target only>
PAY_TUNNEL_HTTP_HOST_HEADER=<hostname or NONE>
```

If authenticated control-plane read is unavailable:

```text
RETURN_M3B_CLOUDFLARE_READONLY_SESSION_REQUIRED
```

and stop before any mutation.

# Part D — reconcile the ambiguous payment state

Current accepted local aggregate:

```text
PAYMENT_INTENTS_CREATED=1
PROVIDER_CREATE_ATTEMPTS_AMBIGUOUS=1
PROVIDER_EVENTS=0
PROVIDER_PAYMENT_FACTS=0
REFUNDS=0
OUTBOX_EVENTS=0
```

Perform read-only reconciliation only.

First inspect local durable state/schema safely using aggregate/status-only queries.

If an already-established safe read-only provider query path exists, query only the one ambiguous create attempt using the existing protected credentials without outputting any Secret or private transaction identifier.

No retry/replay/cancel/refund/provider mutation is allowed.

Classify:

```text
AMBIGUOUS_PAYMENT_STATE=RECONCILED_TERMINAL
```

or

```text
AMBIGUOUS_PAYMENT_STATE=PROVEN_NOT_COMMITTED
```

or

```text
AMBIGUOUS_PAYMENT_STATE=UNRESOLVED
```

Also return safe aggregate terminal/nonterminal counts after reconciliation.

Do not alter local rows.

# Part E — Caddy diagnostic route ownership

Current accepted Caddy routes:

```text
edge-test.spikersun.com -> static 200
localhost -> static 200
PRODUCTION_REVERSE_PROXY_ROUTES=0
```

Search active, current runtime sources only for consumers of:
- `edge-test.spikersun.com`;
- Caddy localhost route;
- Caddy Admin/HTTP health probe;
- host ports 80/443;
- Caddy service name/container;
- `spikersun-edge`.

Inspect:
- active Compose sources;
- current systemd units/timers;
- cron;
- active monitoring scripts/config;
- current application Compose/config;
- running container healthchecks;
- current ingress/tunnel configuration metadata.

Historical docs/backups do not count as active consumers.

Return:

```text
CADDY_ACTIVE_ROUTE_CONSUMERS=<count>
CADDY_PORT_80_443_ACTIVE_DEPENDENCIES=<count>
CADDY_RETIREMENT_SAFE=YES|NO|UNRESOLVED
```

If `spikersun-edge` remains attached to an app only as historical network membership but not used for ingress, classify that separately; do not mutate it.

# Hard boundaries

```text
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
CADDY_MUTATIONS=0
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

# Evidence persistence

Append the M3B result to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Fresh-read both commits after persistence.

# Success return

```text
PASS_CANDIDATE_M3B_CADDY_UNIFIED_PAY_DEPENDENCY_RECONCILIATION
UNIFIED_PAY_LIVE_CALLERS=<0|1|2|UNRESOLVED>
DUJIAO_UNIFIED_PAY_DEPENDENCY=YES|NO|UNRESOLVED
PAY_TUNNEL_ORIGIN=<safe origin or unresolved>
AMBIGUOUS_PAYMENT_STATE=RECONCILED_TERMINAL|PROVEN_NOT_COMMITTED|UNRESOLVED
CADDY_ACTIVE_ROUTE_CONSUMERS=<count_or_unresolved>
CADDY_RETIREMENT_SAFE=YES|NO|UNRESOLVED
MUTATIONS=0
STOP_AT_REVIEWER=YES
```
