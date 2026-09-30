# Reviewer Decision — M2E-R1 Runtime Reconciliation Readback Accepted Provisionally / GitHub Evidence Persistence Recovery

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Reviewed return

Reported result:

```text
RESULT=RETURN_GITHUB_EVIDENCE_PERSISTENCE_UNAVAILABLE
RUNTIME_READONLY_CHECKS=PASS
EVIDENCE_HANDOFF_PERSISTENCE=NOT_COMPLETED
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

Reviewer independently re-read the canonical GitHub files after the reported transport failure and confirmed that no M2E-R1 execution entry has yet been appended to:

- `shared-vps-infrastructure/EXECUTION_EVIDENCE.md`
- `shared-vps-infrastructure/EXECUTOR_HANDOFF.md`

Therefore the RETURN is accepted as fail-closed.

## Provisionally accepted runtime facts

The reported target-host readback is internally consistent with the previously observed M2E residual:

```text
TARGET_HOST=srv1970241
CADDY_STATE=running
CADDY_RESTART_COUNT=0
CADDY_STARTUP_CONFIG_SOURCE=/etc/caddy/Caddyfile

MOUNT_TYPE=bind
MOUNT_SOURCE=/srv/infra/edge/Caddyfile
MOUNT_DESTINATION=/etc/caddy/Caddyfile
MOUNT_RW=false
MOUNT_PROPAGATION=rprivate
MOUNT_SOURCE_EQUALS_HOST_CADDYFILE=YES

HOST_SOURCE_BYTES=143
HOST_SOURCE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
HOST_SOURCE_MINICRAFT_MATCHER=ABSENT

CONTAINER_DESTINATION_BYTES=199
CONTAINER_DESTINATION_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
CONTAINER_MOUNTED_FILE_MINICRAFT_MATCHER=PRESENT

ACTIVE_ADMIN_CONFIG_MINICRAFT_MATCHER=ABSENT

MINICRAFT_HOME_HTTP=200
MINICRAFT_SHOP_HTTP=200
MINICRAFT_WP_REST_HTTP=200
MINICRAFT_TLS_VALID=YES
```

The reported classification is technically coherent:

```text
CADDY_MOUNT_DIVERGENCE_CLASS=SINGLE_FILE_BIND_MOUNT_STALE_REFERENCE
RESTART_REINTRODUCTION_RISK=YES
```

However, M2E-R1 is not formally PASSed until the canonical execution record is persisted and fresh-read back.

## Current Gate

```text
CURRENT_GATE=M2E_R1_R2_GITHUB_EVIDENCE_PERSISTENCE_RECOVERY
CURRENT_GATE_STATUS=AUTHORIZED_DOCUMENTATION_ONLY_WITH_READONLY_MISSING_FIELD_RECOVERY
```

## Required recovery

Primary path: persist the already-collected M2E-R1 read-only facts to canonical Evidence/Handoff without re-running the full VPS investigation.

The persisted record must include the packet-required fields that were omitted from the chat summary, including:

```text
CADDY_CONTAINER_ID=
CADDY_CONTAINER_NAME=
CADDY_MOUNT_DIVERGENCE_CLASS=SINGLE_FILE_BIND_MOUNT_STALE_REFERENCE
RESTART_REINTRODUCTION_RISK=YES
RECREATE_OR_RESTART_REQUIRED=
MINIMAL_RECONCILIATION_PLAN=
```

If the prior terminal/output context still contains these exact values, persist them directly.

If any required field is not retained, one fresh bounded Hostinger Web Terminal **read-only** lookup is authorized only for the missing field(s). Do not repeat the entire investigation unnecessarily.

## Expected minimal reconciliation analysis

The persistence record should distinguish restart from recreate:

- a plain Caddy process/container restart is not sufficient if it continues using the already-stale single-file bind mount;
- the likely minimal restart-safe remedy is a bounded **Caddy container recreate/rebind only**, using the current host `/srv/infra/edge/Caddyfile`, followed by proof that `/etc/caddy/Caddyfile` now matches the 143-byte host source and that the retired Mini Craft matcher remains absent after startup.

This is a proposal only. No recreate/restart/write is authorized by this decision.

## Hard boundary

```text
CADDYFILE_WRITES=0
CADDY_RELOADS=0
CADDY_RESTARTS=0
CADDY_RECREATES=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
VPS_MUTATIONS=0
PAYMENT_ACTIONS=0
```

Only GitHub documentation persistence is authorized, plus a bounded read-only lookup if an exact required field was not retained.

## Success

```text
PASS_CANDIDATE_M2E_R1_R2_GITHUB_EVIDENCE_PERSISTENCE_RECOVERY
M2E_R1_RUNTIME_FACTS_PERSISTED=YES
EXECUTION_EVIDENCE_FRESH_READBACK=PASS
EXECUTOR_HANDOFF_FRESH_READBACK=PASS
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

After that, Reviewer will decide formal M2E-R1 PASS and whether to open a separate Owner checkpoint for Caddy container recreate/rebind.
