# Reviewer Decision — M3A Caddy + Unified Pay Decommission Assessment

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Owner direction

Owner explicitly requested the next Shared VPS cleanup phase to:

1. assess whether Shared Caddy can be retired entirely;
2. safely remove Unified Pay if and only if active dependencies, recovery requirements, provider/runtime obligations and retained data are first reconciled.

This is accepted as the lifecycle direction:

```text
OWNER_DIRECTION_CADDY=RETIRE_IF_PROVEN_UNUSED
OWNER_DIRECTION_UNIFIED_PAY=DECOMMISSION_AND_REMOVE_IF_SAFE
```

It is **not** treated as authorization for broad or irreversible deletion before the exact dependency and recovery boundary is sealed.

## Current accepted baseline

```text
MINICRAFT_INGRESS_MIGRATION_M1_TO_M2E=COMPLETE
MINICRAFT_CADDY_DEPENDENCY=NO
LEGACY_MINICRAFT_CADDY_ROUTE=ABSENT

CADDY_STATE=RUNNING_SHARED_INFRA
CADDY_HOST_PORTS=80,443
CADDY_CURRENT_CONFIG_BYTES=143

UNIFIED_PAY_RUNTIME_STATE=ACTIVE_HEALTHY
UNIFIED_PAY_APP_HEALTH=PASS
UNIFIED_PAY_POSTGRES_HEALTH=PASS
UNIFIED_PAY_PUBLIC_HOST=pay.spikersun.com
UNIFIED_PAY_PUBLIC_HEALTH=200
UNIFIED_PAY_PUBLIC_READY=200
UNIFIED_PAY_HOST_PORTS=NONE
UNIFIED_PAY_DOWNSTREAM_BUSINESS_DEPENDENCY=UNKNOWN
UNIFIED_PAY_PROVIDER_FLAGS_FRESH_STATE=UNKNOWN
UNIFIED_PAY_DB_BUSINESS_AGGREGATE=UNKNOWN
UNIFIED_PAY_INGRESS_OWNER=CLOUDFLARE_REMOTE_MANAGED_TUNNEL_LIKELY_UNVERIFIED

DUJIAO_UNIFIED_PAY_RUNTIME_DEPENDENCY=UNKNOWN
```

Because Unified Pay is still an active healthy runtime and Dujiao dependency is explicitly UNKNOWN, shutdown or deletion is not yet safe.

## Gate

```text
CURRENT_GATE=M3A_CADDY_UNIFIED_PAY_DECOMMISSION_ASSESSMENT
CURRENT_GATE_STATUS=AUTHORIZED_READONLY_ONLY

CADDY_STOP_AUTHORIZED=NO
CADDY_REMOVE_AUTHORIZED=NO
CADDY_CONFIG_WRITE_AUTHORIZED=NO
UNIFIED_PAY_STOP_AUTHORIZED=NO
UNIFIED_PAY_CONTAINER_REMOVE_AUTHORIZED=NO
UNIFIED_PAY_APP_DELETE_AUTHORIZED=NO
UNIFIED_PAY_DATA_DELETE_AUTHORIZED=NO
UNIFIED_PAY_BACKUP_DELETE_AUTHORIZED=NO
UNIFIED_PAY_PROVIDER_MUTATION_AUTHORIZED=NO
CLOUDFLARE_MUTATION_AUTHORIZED=NO
DNS_MUTATION_AUTHORIZED=NO
TUNNEL_ROUTE_MUTATION_AUTHORIZED=NO
NETWORK_DELETE_AUTHORIZED=NO
BROAD_PRUNE_AUTHORIZED=NO
```

## M3A goal

Produce one exact decommission map for both Caddy and Unified Pay.

### A. Caddy dependency proof

Freshly determine:

- exact current Caddyfile route/site semantics;
- all current Caddy-served hostnames/routes;
- whether any production, rollback, test, management or certificate workflow still requires Caddy;
- all containers attached to `spikersun-edge` and whether the attachment is still needed;
- all Compose/config/script references to Caddy or `spikersun-edge`;
- whether host ports 80/443 are needed after Caddy retirement;
- persistence/recovery significance of `/srv/infra/edge/data` and `/srv/infra/edge/config`;
- exact rollback path if Caddy is later stopped/removed.

Return:

```text
CADDY_PRODUCTION_DEPENDENCIES=<count>
CADDY_ROLLBACK_DEPENDENCIES=<count>
CADDY_MANAGEMENT_TEST_DEPENDENCIES=<count>
CADDY_RETIREMENT_SAFE=YES|NO|UNRESOLVED
```

Do not infer zero dependency merely from the Mini Craft migration.

### B. Unified Pay dependency proof

Freshly determine:

- exact running app/PostgreSQL containers, images, Compose project/source and networks;
- exact current Cloudflare Tunnel/public-hostname route for `pay.spikersun.com`;
- all project/container/config references to:
  - `pay.spikersun.com`
  - `unified-pay`
  - `unified-pay-app`
  - Unified Pay internal service/API identity;
- especially whether Dujiao currently calls Unified Pay;
- whether Xianyu, Mini Craft or any other current project calls it;
- whether any scheduled job, webhook, callback, license/entitlement flow or internal automation targets it;
- fresh non-secret payment/provider enablement state;
- database business aggregates sufficient to classify whether real orders/payments/refunds/entitlements or unreconciled records exist;
- exact durable data and backup inventory;
- exact Secret recovery presence/metadata only, without reading Secret values;
- whether GitHub + durable backup + protected Secret recovery is sufficient to reconstruct the service if later needed.

For runtime/config searching:
- do not print or read Secret values;
- do not dump environment contents;
- if a reference is found in a sensitive file/environment, return only safe metadata such as project, file path, variable/key name, and dependency classification.

Return:

```text
UNIFIED_PAY_ACTIVE_CALLERS=<count>
UNIFIED_PAY_ACTIVE_PROVIDER_OR_WEBHOOK_DEPENDENCIES=<count>
UNIFIED_PAY_UNRECONCILED_BUSINESS_RECORDS=<count_or_safe_aggregate>
UNIFIED_PAY_RECOVERY_BARRIER=PASS|FAIL|UNRESOLVED
UNIFIED_PAY_RUNTIME_RETIREMENT_SAFE=YES|NO|UNRESOLVED
UNIFIED_PAY_DATA_DELETION_SAFE=YES|NO|UNRESOLVED
```

Runtime retirement and durable-data deletion are separate decisions. A service may be safe to stop while its database/backups still must be retained.

### C. Proposed phased decommission plan

If evidence supports retirement, return a phased plan, not a deletion action:

```text
PHASE_1=UNIFIED_PAY_PUBLIC_INGRESS_RETIREMENT
PHASE_2=UNIFIED_PAY_RUNTIME_STOP_AND_OBSERVE
PHASE_3=UNIFIED_PAY_RUNTIME_REMOVAL
PHASE_4=UNIFIED_PAY_DURABLE_DATA_AND_BACKUP_DISPOSITION
PHASE_5=CADDY_STOP_OBSERVE_AND_RETIRE
PHASE_6=SPIKERSUN_EDGE_NETWORK_REVIEW
```

The actual order may be adjusted if evidence shows a safer dependency order.

## Required failure states

Use precise RETURN if any material uncertainty remains, including:

```text
RETURN_M3A_UNIFIED_PAY_ACTIVE_DEPENDENCY_FOUND
RETURN_M3A_UNIFIED_PAY_DEPENDENCY_UNRESOLVED
RETURN_M3A_UNIFIED_PAY_RECOVERY_BARRIER_UNPROVEN
RETURN_M3A_CADDY_ACTIVE_DEPENDENCY_FOUND
RETURN_M3A_CADDY_RETIREMENT_UNRESOLVED
RETURN_M3A_TARGET_HOST_EXECUTION_UNAVAILABLE
```

## Success boundary

```text
PASS_CANDIDATE_M3A_CADDY_UNIFIED_PAY_DECOMMISSION_ASSESSMENT
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

M3A PASS only seals the next exact mutation sequence. It authorizes no shutdown, route deletion, container removal, durable-data deletion, backup deletion, provider mutation, Caddy retirement, network deletion or broad prune.
