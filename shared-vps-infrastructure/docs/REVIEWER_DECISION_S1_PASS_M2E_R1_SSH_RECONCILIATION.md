# Reviewer Decision — S1 Formal PASS / M2E-R1 SSH Reconciliation Open

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewer persisted and fresh-read the S1 bounded result after Executor GitHub transport failure.

Accepted S1 result:

```text
S1_RESTORE_CANONICAL_SSH_CONNECTION_CONTRACT=PASS
SSH_NORMAL_PATH=RESTORED
SSH_NATIVE_EXIT=0
REMOTE_HOSTNAME=srv1970241
REMOTE_USER=ops
REMOTE_OS=Ubuntu 24.04.5 LTS
TARGET_HOST_EXECUTION_PROVEN=PASS
SUDO_NONINTERACTIVE_AVAILABLE=YES
DIRECT_DOCKER_SOCKET_ACCESS=NO
SSH_NETWORK_INVOCATIONS=1
MUTATIONS=0
```

The direct Docker result is not an SSH failure. The accepted privilege model is:

```text
REMOTE_USER=ops
PASSWORDLESS_SUDO=YES
DOCKER_ACCESS_METHOD=BOUNDED_SUDO_DOCKER
```

No Docker-group membership change is required or authorized.

The exact non-secret identity-file reference, client fingerprint, three host-key fingerprints, known_hosts reference and strict options are now promoted into canonical `SHARED_VPS_HANDOFF.md`.

Hostinger Web Terminal returns to fallback/recovery-only status.

## Current M2E status

```text
M2E_ACTIVE_RUNTIME_RETIREMENT=PASS
M2E_HOST_SOURCE_RETIREMENT=PASS
M2E_RESTART_PERSISTENCE=NOT_PROVEN
M2E_FORMAL_PASS=NO

CADDY_MOUNT_DIVERGENCE_CLASS=SINGLE_FILE_BIND_MOUNT_STALE_REFERENCE_PROVISIONAL
RESTART_REINTRODUCTION_RISK=YES
```

The remaining task is to complete the missing Caddy runtime identity/persistence reconciliation using canonical SSH, not browser terminal.

## Current Gate

```text
CURRENT_GATE=M2E_R1_SSH_PERSISTENCE_RECONCILIATION_COMPLETION
CURRENT_GATE_STATUS=AUTHORIZED_READONLY_ONLY
```

This Gate may use strict SSH to `ops@srv1970241` and bounded `sudo docker ...` read-only commands.

No recreate/restart/reload/write is authorized.

## Required facts

Freshly prove:

```text
CADDY_CONTAINER_ID=
CADDY_CONTAINER_NAME=
CADDY_STATE=running
CADDY_RESTART_COUNT=0

MOUNT_TYPE=bind
MOUNT_SOURCE=/srv/infra/edge/Caddyfile
MOUNT_DESTINATION=/etc/caddy/Caddyfile
MOUNT_RW=false

HOST_CADDYFILE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
HOST_CADDYFILE_BYTES=143
HOST_SOURCE_MINICRAFT_MATCHER=ABSENT

CONTAINER_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
CONTAINER_CADDYFILE_BYTES=199
CONTAINER_MOUNTED_FILE_MINICRAFT_MATCHER=PRESENT

ACTIVE_ADMIN_CONFIG_MINICRAFT_MATCHER=ABSENT
CADDY_STARTUP_CONFIG_SOURCE=/etc/caddy/Caddyfile
```

Also prove current public Mini Craft Home / Shop / REST / TLS health.

## Classification

If the facts above remain true:

```text
CADDY_MOUNT_DIVERGENCE_CLASS=SINGLE_FILE_BIND_MOUNT_STALE_REFERENCE
RESTART_REINTRODUCTION_RISK=YES
PLAIN_RESTART_SUFFICIENT=NO
RECREATE_REQUIRED=YES
```

The minimal write proposal is then: recreate only the existing shared Caddy container/service from its canonical deployment definition so the bind mount is re-established against the current 143-byte host Caddyfile; after recreate, verify mounted file == host source, active matcher absent, other Caddy sites healthy, and Mini Craft Tunnel path healthy.

That proposal is **not authorized by this read-only Gate**. It will require a separate Owner-confirmed Shared Infrastructure write Gate.

## Hard boundary

No Caddy write/reload/restart/recreate, no Docker mutation, no Compose mutation, no Cloudflare/DNS/Tunnel mutation, no SSH repair, no key/known_hosts change, no payment/cleanup.

## Success

```text
PASS_CANDIDATE_M2E_R1_SSH_PERSISTENCE_RECONCILIATION_COMPLETION
CADDY_MOUNT_DIVERGENCE_CLASS=SINGLE_FILE_BIND_MOUNT_STALE_REFERENCE
RESTART_REINTRODUCTION_RISK=YES
RECREATE_REQUIRED=YES
MUTATIONS=0
STOP_AT_REVIEWER=YES
```
