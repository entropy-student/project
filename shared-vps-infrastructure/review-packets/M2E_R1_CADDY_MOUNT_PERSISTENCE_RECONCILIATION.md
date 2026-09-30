# M2E-R1 — Caddy Mount Persistence Reconciliation

## Gate

```text
M2E_R1_CADDY_MOUNT_PERSISTENCE_RECONCILIATION
READ_ONLY_ONLY=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2E_PARTIAL_PASS_R1_CADDY_MOUNT_PERSISTENCE_RECONCILIATION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Use accepted Hostinger Web Terminal only. Do not retry direct SSH.

## Accepted current facts

```text
HOST_CADDYFILE=/srv/infra/edge/Caddyfile
HOST_CADDYFILE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
HOST_CADDYFILE_BYTES=143

CONTAINER_CADDYFILE=/etc/caddy/Caddyfile
CONTAINER_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
CONTAINER_CADDYFILE_BYTES=199

ACTIVE_ADMIN_CONFIG_MINICRAFT_ROUTE=ABSENT
ROLLBACK_COPY=/srv/infra/edge/Caddyfile.m2e-prewrite-20260930T091701Z.bak
```

Do not assume the mount source path until fresh Docker metadata proves it.

## Phase A — target/runtime identity

Prove:

```text
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
CADDY_CONTAINER_ID=
CADDY_CONTAINER_NAME=
CADDY_STATE=running
CADDY_RESTART_COUNT=
```

## Phase B — exact mount metadata

From safe `docker inspect` metadata only, identify the mount whose Destination is:

`/etc/caddy/Caddyfile`

Return:

```text
MOUNT_TYPE=
MOUNT_SOURCE=
MOUNT_DESTINATION=/etc/caddy/Caddyfile
MOUNT_RW=
MOUNT_PROPAGATION=
MOUNT_SOURCE_EQUALS_HOST_CADDYFILE=YES|NO
```

Do not print container environment values or broad raw inspect JSON.

Also capture any Compose/service labels needed only to identify the deployment source, but no environment values.

## Phase C — file identity comparison

Read metadata only for host source and container destination:

```text
HOST_PATH=
HOST_DEVICE=
HOST_INODE=
HOST_BYTES=
HOST_SHA256=

CONTAINER_PATH=/etc/caddy/Caddyfile
CONTAINER_DEVICE=
CONTAINER_INODE=
CONTAINER_BYTES=
CONTAINER_SHA256=
```

Also, if `MOUNT_SOURCE` differs from `/srv/infra/edge/Caddyfile`, capture the same metadata for the actual mount source path.

Do not output file contents.

## Phase D — startup/load semantics

Read only safe Caddy container command/args and service metadata necessary to determine which path is loaded on process start.

Return a concise classification such as:

```text
CADDY_STARTUP_CONFIG_SOURCE=/etc/caddy/Caddyfile|OTHER
```

Do not output environment values, tokens, labels containing credentials, or Secret mounts.

## Phase E — current state continuity

Freshly prove:

```text
HOST_SOURCE_MINICRAFT_MATCHER=ABSENT
CONTAINER_MOUNTED_FILE_MINICRAFT_MATCHER=PRESENT
ACTIVE_ADMIN_CONFIG_MINICRAFT_MATCHER=ABSENT
CADDY_SERVICE_HEALTH=PASS

MINICRAFT_HOME_HTTP=200
MINICRAFT_SHOP_HTTP=200
MINICRAFT_WP_REST_HTTP=200
MINICRAFT_TLS_VALID=YES
PRODUCTION_INGRESS=CLOUDFLARE_TUNNEL_DIRECT_TO_MINICRAFT_APP
```

No mutation.

## Phase F — classification and minimal plan

Return exactly one:

```text
CADDY_MOUNT_DIVERGENCE_CLASS=DIFFERENT_HOST_SOURCE_PATH
CADDY_MOUNT_DIVERGENCE_CLASS=SINGLE_FILE_BIND_MOUNT_STALE_REFERENCE
CADDY_MOUNT_DIVERGENCE_CLASS=CONTAINER_FILESYSTEM_NOT_HOST_BIND
CADDY_MOUNT_DIVERGENCE_CLASS=OTHER_PROVEN
CADDY_MOUNT_DIVERGENCE_CLASS=UNRESOLVED
```

Then provide:

```text
RESTART_REINTRODUCTION_RISK=YES|NO|UNRESOLVED
MINIMAL_RECONCILIATION_PLAN=<read-only proposal; do not execute>
RECREATE_OR_RESTART_REQUIRED=YES|NO|UNRESOLVED
```

Do not authorize yourself to execute the plan.

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

No cleanup and no SSH repair.

## Evidence

Append the R1 result to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Fresh-read both after commit. Do not modify Reviewer Handoff.

## Result

Success:

```text
PASS_CANDIDATE_M2E_R1_CADDY_MOUNT_PERSISTENCE_RECONCILIATION
CADDY_MOUNT_DIVERGENCE_CLASS=<allowed value>
RESTART_REINTRODUCTION_RISK=<...>
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

Otherwise one precise read-only RETURN.
