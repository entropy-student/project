# Reviewer Decision — M2E Active Runtime PASS / Persistent Retirement NOT PROVEN / R1 Caddy Mount Persistence Reconciliation

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewed:

- Evidence commit `3426fef884988bc401e80863e7d28ab0a03ef6ce`
- Executor Handoff commit `5d3e0b488e63982c91a79146d2bc720037d5caba`

The M2E PASS_CANDIDATE is **not yet accepted as final M2E PASS**.

## Accepted execution facts

```text
TARGET_HOST=srv1970241

PREWRITE_HOST_CADDYFILE=/srv/infra/edge/Caddyfile
PREWRITE_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
ROLLBACK_COPY=/srv/infra/edge/Caddyfile.m2e-prewrite-20260930T091701Z.bak
ROLLBACK_COPY_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

POSTWRITE_HOST_CADDYFILE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
ACTIVE_ADMIN_CONFIG_MINICRAFT_ROUTE=ABSENT
CADDY_RELOAD_COUNT=1
CADDY_RESTART_COUNT=0
CADDY_RECREATE_COUNT=0
CADDY_SERVICE_HEALTH=PASS

MINICRAFT_TUNNEL_PRODUCTION_REGRESSION=PASS
OTHER_CADDY_SITES_REGRESSION=PASS
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
```

The active Caddy configuration and host source both no longer contain the Mini Craft route.

## Blocking persistence inconsistency

The same execution also proved:

```text
CONTAINER_MOUNTED_PATH=/etc/caddy/Caddyfile
CONTAINER_MOUNTED_PATH_POST_BYTES=199
CONTAINER_MOUNTED_PATH_POST_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

HOST_SOURCE_POST_BYTES=143
HOST_SOURCE_POST_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358

CADDY_MOUNT_PERSISTENCE_DIVERGENCE=YES
```

Therefore a future Caddy process/container restart may load the stale mounted configuration and reintroduce the retired Mini Craft route.

Formal classification:

```text
M2E_ACTIVE_RUNTIME_RETIREMENT=PASS
M2E_HOST_SOURCE_RETIREMENT=PASS
M2E_RESTART_PERSISTENCE=NOT_PROVEN
M2E_FORMAL_PASS=NO
MIGRATION_M1_TO_M2E_COMPLETE=NO
```

The 30-byte `/tmp/m2e-edge-body` diagnostic scratch was created and removed in the same Gate. Reviewer records it as:

```text
UNPLANNED_DIAGNOSTIC_SCRATCH=RECORDED_NONCOMPROMISING_EXECUTION_DEVIATION
CURRENT_RESIDUAL=NONE_PROVEN
```

It does not itself require rollback.

## Current Gate

```text
CURRENT_GATE=M2E_R1_CADDY_MOUNT_PERSISTENCE_RECONCILIATION
CURRENT_GATE_STATUS=AUTHORIZED_READONLY_ONLY
```

## R1 objective

Determine exactly why the running container's `/etc/caddy/Caddyfile` does not reflect the updated host source, and identify the smallest restart-safe reconciliation.

R1 must prove, without mutation:

1. exact running Caddy container/service identity;
2. exact Docker mount metadata for destination `/etc/caddy/Caddyfile`, including safe source path, type, read-only flag, and propagation metadata;
3. whether the mount source path equals `/srv/infra/edge/Caddyfile`;
4. host and container file device/inode/bytes/SHA metadata;
5. Caddy startup command/args relevant to config loading, without environment values or Secrets;
6. current active Admin config still lacks the Mini Craft matcher;
7. current host source still lacks the matcher;
8. current mounted file still contains the stale matcher;
9. current Mini Craft Tunnel production path remains healthy;
10. what minimal write would make restart state match active/host state.

Allowed classifications:

```text
CADDY_MOUNT_DIVERGENCE_CLASS=DIFFERENT_HOST_SOURCE_PATH
CADDY_MOUNT_DIVERGENCE_CLASS=SINGLE_FILE_BIND_MOUNT_STALE_REFERENCE
CADDY_MOUNT_DIVERGENCE_CLASS=CONTAINER_FILESYSTEM_NOT_HOST_BIND
CADDY_MOUNT_DIVERGENCE_CLASS=OTHER_PROVEN
CADDY_MOUNT_DIVERGENCE_CLASS=UNRESOLVED
```

## Forbidden in R1

No Caddy edit/reload/restart/recreate, no Docker/Compose mutation, no Cloudflare/DNS/Tunnel mutation, no VPS config write, no cleanup, no payment action, no SSH retry, no Secret/environment-value output.

## Success

```text
PASS_CANDIDATE_M2E_R1_CADDY_MOUNT_PERSISTENCE_RECONCILIATION
CADDY_MOUNT_DIVERGENCE_CLASS=<allowed value>
MINIMAL_RECONCILIATION_PLAN=<metadata only>
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

R1 PASS does not authorize the reconciliation write. A separate Reviewer Gate is required.
