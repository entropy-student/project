# Reviewer Decision — M2E-R1 Formal PASS / M2E-R2 Caddy Recreate Preflight Open

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewer persisted and fresh-read the Executor's complete M2E-R1 SSH reconciliation result after the Executor-side GitHub transport failure.

Accepted result:

```text
M2E_R1_SSH_PERSISTENCE_RECONCILIATION_COMPLETION=PASS

ACCESS_PATH=CANONICAL_STRICT_SSH
TARGET_HOST=srv1970241
REMOTE_USER=ops
SSH_NATIVE_EXIT=0

CADDY_CONTAINER_ID=793a5c8fbcd86d3c2b6dc0ba5a47e51de9d372957210efa0912523b8c1e7b9a2
CADDY_CONTAINER_NAME=/spikersun-edge-caddy-1
CADDY_STATE=running
CADDY_RESTART_COUNT=0

MOUNT_TYPE=bind
MOUNT_SOURCE=/srv/infra/edge/Caddyfile
MOUNT_DESTINATION=/etc/caddy/Caddyfile
MOUNT_RW=false
MOUNT_PROPAGATION=rprivate

HOST_CADDYFILE_BYTES=143
HOST_CADDYFILE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
HOST_SOURCE_MINICRAFT_MATCHER=ABSENT

CONTAINER_CADDYFILE_BYTES=199
CONTAINER_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
CONTAINER_MOUNTED_FILE_MINICRAFT_MATCHER=PRESENT

ACTIVE_ADMIN_CONFIG_MINICRAFT_MATCHER=ABSENT
CADDY_STARTUP_CONFIG_SOURCE=/etc/caddy/Caddyfile

MINICRAFT_HOME_HTTP=200
MINICRAFT_SHOP_HTTP=200
MINICRAFT_WP_REST_HTTP=200
MINICRAFT_TLS_VALID=YES

CADDY_MOUNT_DIVERGENCE_CLASS=SINGLE_FILE_BIND_MOUNT_STALE_REFERENCE
RESTART_REINTRODUCTION_RISK=YES
PLAIN_RESTART_SUFFICIENT=NO
RECREATE_REQUIRED=YES

MUTATIONS=0
```

## Technical conclusion

The retirement is correct in the host source and current active Admin config, but restart-safe persistence is not yet correct.

A plain restart is insufficient because the existing container retains a stale single-file bind reference. The smallest correction is to recreate only the existing shared Caddy service/container from its canonical deployment definition, which should establish a new bind mount to the current 143-byte host Caddyfile.

The recreate itself is **not yet authorized**.

## Current Gate

```text
CURRENT_GATE=M2E_R2_CADDY_RECREATE_PREFLIGHT
CURRENT_GATE_STATUS=AUTHORIZED_READONLY_ONLY

CADDY_RECREATE_AUTHORIZED=NO
CADDY_RESTART_AUTHORIZED=NO
CADDY_RELOAD_AUTHORIZED=NO
DOCKER_MUTATION_AUTHORIZED=NO
COMPOSE_MUTATION_AUTHORIZED=NO
```

## R2 objective

Before asking Owner to authorize the Shared Infrastructure recreate, seal the exact deployment/recreate transaction.

Through canonical SSH, read-only prove:

1. exact current Caddy Compose project and service identity;
2. exact canonical Compose/config file path and working directory;
3. exact current image reference/image ID;
4. restart policy;
5. published ports;
6. networks;
7. all mounts/volumes required for persistence, without Secret contents;
8. exact safe Compose command that would recreate Caddy only;
9. whether the command can guarantee no dependency recreation, no pull and no build;
10. current Caddy config validation PASS using the current 143-byte host source;
11. current public regression baselines for every Caddy-served public endpoint that can be safely identified;
12. Mini Craft Tunnel Home / Shop / REST / TLS remains healthy.

## Expected bounded write proposal

If preflight proves a normal Docker Compose-managed service, the intended future action should be equivalent to:

```text
docker compose -f <exact canonical compose path> up -d --no-deps --force-recreate <exact caddy service>
```

with explicit controls ensuring:

```text
PULL=NO
BUILD=NO
DEPENDENCY_RECREATE=NO
OTHER_SERVICE_RECREATE=NO
```

Do not execute it in R2.

## Important safety properties

The future write Gate must preserve:

- host Caddyfile SHA-256 `f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358`;
- no Mini Craft matcher in host source;
- existing Caddy data/config persistence volumes;
- existing published 80/443 ownership;
- all existing Caddy networks;
- no cloudflared/DNS/Tunnel change;
- no application/database/payment change.

The future recreate must not pull a new image or change the Caddy image version.

## Failure / ambiguity in R2

If canonical deployment source cannot be identified exactly, return:

```text
RETURN_M2E_R2_CADDY_DEPLOYMENT_SOURCE_UNRESOLVED
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

If the canonical Compose definition no longer matches the running container semantics or cannot validate safely:

```text
RETURN_M2E_R2_CADDY_DEPLOYMENT_DRIFT
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

## Success

```text
PASS_CANDIDATE_M2E_R2_CADDY_RECREATE_PREFLIGHT
CADDY_COMPOSE_PROJECT=<exact>
CADDY_COMPOSE_SERVICE=<exact>
CADDY_CANONICAL_COMPOSE_PATH=<exact>
CADDY_RECREATE_COMMAND_PROPOSAL=<exact safe proposal>
PRE_RECREATE_CADDY_CONFIG_VALID=PASS
RECREATE_SCOPE=CADDY_ONLY
PULL=NO
BUILD=NO
DEPENDENCY_RECREATE=NO
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

R2 PASS does not authorize the recreate. Reviewer will then open an explicit Owner checkpoint with the exact sealed command and rollback/regression plan.
