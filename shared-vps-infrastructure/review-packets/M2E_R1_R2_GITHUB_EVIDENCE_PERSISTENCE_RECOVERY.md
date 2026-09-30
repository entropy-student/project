# M2E-R1-R2 — GitHub Evidence Persistence Recovery

## Gate

```text
M2E_R1_R2_GITHUB_EVIDENCE_PERSISTENCE_RECOVERY
DOCUMENTATION_ONLY=YES
READONLY_MISSING_FIELD_RECOVERY_ONLY=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2E_R1_RETURN_R2_GITHUB_EVIDENCE_PERSISTENCE_RECOVERY.md
shared-vps-infrastructure/review-packets/M2E_R1_CADDY_MOUNT_PERSISTENCE_RECONCILIATION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

## Objective

Persist the already-completed M2E-R1 read-only reconciliation result to GitHub.

Do not repeat the full host investigation unless an exact required field was not retained.

## Facts to persist

Include at minimum:

```text
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
CADDY_CONTAINER_ID=<exact retained/read-only value>
CADDY_CONTAINER_NAME=<exact retained/read-only value>
CADDY_STATE=running
CADDY_RESTART_COUNT=0
CADDY_STARTUP_CONFIG_SOURCE=/etc/caddy/Caddyfile

MOUNT_TYPE=bind
MOUNT_SOURCE=/srv/infra/edge/Caddyfile
MOUNT_DESTINATION=/etc/caddy/Caddyfile
MOUNT_RW=false
MOUNT_PROPAGATION=rprivate
MOUNT_SOURCE_EQUALS_HOST_CADDYFILE=YES

HOST_DEVICE=2049
HOST_INODE=787446
HOST_BYTES=143
HOST_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358

CONTAINER_DEVICE=2049
CONTAINER_INODE=788944
CONTAINER_BYTES=199
CONTAINER_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

HOST_SOURCE_MINICRAFT_MATCHER=ABSENT
CONTAINER_MOUNTED_FILE_MINICRAFT_MATCHER=PRESENT
ACTIVE_ADMIN_CONFIG_MINICRAFT_MATCHER=ABSENT

MINICRAFT_HOME_HTTP=200
MINICRAFT_SHOP_HTTP=200
MINICRAFT_WP_REST_HTTP=200
MINICRAFT_TLS_VALID=YES

CADDY_MOUNT_DIVERGENCE_CLASS=SINGLE_FILE_BIND_MOUNT_STALE_REFERENCE
RESTART_REINTRODUCTION_RISK=YES
RECREATE_OR_RESTART_REQUIRED=<exact conclusion>
MINIMAL_RECONCILIATION_PLAN=<concise metadata-only proposal>

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
STOP_AT_REVIEWER=YES
```

Do not infer cross-namespace inode identity from numeric equality/inequality; record values only.

## Missing-field recovery

If `CADDY_CONTAINER_ID`, `CADDY_CONTAINER_NAME`, or the exact recreate/restart conclusion was not retained, use the already-open accepted Hostinger Web Terminal for one bounded read-only lookup of only those missing facts.

No direct SSH.

## GitHub persistence

Append exactly one M2E-R1 reconciliation section to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Do not modify Reviewer Handoff.

Commit each file and fresh-read it back. Ensure the new M2E-R1 record occurs exactly once in each file.

## Result

```text
PASS_CANDIDATE_M2E_R1_R2_GITHUB_EVIDENCE_PERSISTENCE_RECOVERY
M2E_R1_RUNTIME_FACTS_PERSISTED=YES
EXECUTION_EVIDENCE_FRESH_READBACK=PASS
EXECUTOR_HANDOFF_FRESH_READBACK=PASS
VPS_RUNTIME_MUTATIONS=0
STOP_AT_REVIEWER=YES
```

If GitHub transport still fails, return the precise persistence failure with no runtime mutation.
