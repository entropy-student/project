# Reviewer Decision — K6 G-R3R1 Reported RETURN / G-R3R2 Stale Bind-Mount Reconciliation

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper

## Reported G-R3R1 result

GATE=K6_PHASE_G_R3R1_CORRECTED_MOUNT_RECONCILIATION_AND_PUBLIC_SANDBOX_INGRESS_RESUME
RESULT=RETURN_REVIEWER_G_CADDY_MOUNT_BASELINE_DRIFT

The Executor reported that GitHub Evidence/Handoff persistence failed because the GitHub connector returned transport errors. Therefore these facts are not yet accepted as canonical persisted Evidence and must be freshly re-proven by G-R3R2.

Reported facts to reconcile:

HOST_PRE_DEVICE=2049
HOST_PRE_INODE=791399
HOST_PRE_BYTES=76
HOST_PRE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb

CONTAINER_PRE_DEVICE=2049
CONTAINER_PRE_INODE=787439
CONTAINER_PRE_BYTES=153
CONTAINER_PRE_SHA256=126292f6bc2a77929539704a84c5d7a4ab3364ec39364a14abafda176b631837

CROSS_NAMESPACE_INODE_EQUALITY_CHECK=NOT_USED
CADDYFILE_WRITE=0
CADDY_RELOAD=0
DNS_WRITES=0
INDEXING_WRITE=0
PAYMENT_ACTIONS=0

## Reviewer interpretation

If freshly reproduced, the host path and container mount are different file objects with different content.

That would mean:
- the current running Caddy container is pinned to a stale single-file bind-mount inode;
- modifying the current host pathname cannot make the existing container mount see those bytes;
- the historical split between durable host Caddyfile and active/edge-test behavior is no longer safely resolvable by same-inode host writes alone.

A clean durable fix would require the Caddy container to acquire a fresh bind mount to the current host pathname, normally by recreating that Caddy service/container.

Caddy restart/recreate was explicitly forbidden by the existing Phase G authorization. Therefore no recreate is authorized yet.

## Current Gate

CURRENT_GATE=K6_PHASE_G_R3R2_STALE_BIND_MOUNT_RECONCILIATION_AND_RECREATE_PLAN_SEAL
CURRENT_GATE_STATUS=AUTHORIZED_AWAIT_EXECUTOR
OWNER_ACTION=NONE

This Gate is read-only.

## Objective

Freshly prove the stale bind-mount state, seal the exact currently-mounted legacy Caddy configuration as a rollback source, inspect the shared-edge Caddy Compose/runtime topology, determine whether a Caddy-only recreate is bounded and recoverable, and prepare an exact Owner checkpoint.

## Phase A — fresh file-object reconciliation

One strict direct-native SSH session.

Require:
REMOTE_IDENTITY=ops@srv1970241

Read independently:

Host:
- /srv/infra/edge/Caddyfile
- device
- inode
- bytes
- SHA-256
- owner/group/mode

Container:
- spikersun-edge-caddy-1:/etc/caddy/Caddyfile
- device
- inode
- bytes
- SHA-256
- read-only mount status

Do not compare inode equality across namespaces.

Record:
HOST_CADDY_DEVICE=
HOST_CADDY_INODE=
HOST_CADDY_BYTES=
HOST_CADDY_SHA256=
CONTAINER_CADDY_DEVICE=
CONTAINER_CADDY_INODE=
CONTAINER_CADDY_BYTES=
CONTAINER_CADDY_SHA256=

If both views are identical content after all, return precise reconciliation and stop.

If they remain different, require:
STALE_SINGLE_FILE_BIND_MOUNT=CONFIRMED

## Phase B — legacy mounted Caddyfile semantic seal

Read the current container-mounted Caddyfile bytes into process memory only.

Do not persist them in this Gate.

Record only:
LEGACY_MOUNTED_CADDYFILE_BYTES=
LEGACY_MOUNTED_CADDYFILE_SHA256=

Run inside the existing Caddy container:
- caddy adapt on the mounted legacy file;
- caddy fmt to canonicalize in memory if useful.

Require valid adaptation.

Extract and record only non-sensitive semantics:
- exact user hostname matchers;
- handler types;
- edge-test status/body bytes/body hash;
- reverse_proxy upstreams if any;
- localhost route semantics.

Do not output unrelated headers or any Secret-bearing values if unexpectedly present.

Compare legacy mounted adapted semantics to fresh active Admin API config.

Require:
LEGACY_MOUNTED_TO_ACTIVE_SEMANTIC_PARITY=PASS

If not semantically equal, record the exact bounded difference and RETURN for Reviewer.

Seal a rollback candidate:
- either exact raw legacy mounted bytes if valid/stable;
- or caddy-fmt canonicalized equivalent if Reviewer-safe.

Record:
LEGACY_EDGE_ROLLBACK_BYTES=
LEGACY_EDGE_ROLLBACK_SHA256=
LEGACY_EDGE_ROLLBACK_ADAPT=PASS

No write.

## Phase C — active route inventory

From fresh active Admin API config, enumerate every user-defined hostname matcher and material handler/upstream.

Record only bounded non-sensitive route inventory.

Require:
ACTIVE_USER_ROUTE_INVENTORY_COMPLETE=YES

Compare:
- active route inventory
- legacy rollback candidate
- target 199-byte Mini Craft canonical candidate

The target must preserve every unrelated active route.

If target candidate omits any current unrelated route:
RETURN_REVIEWER_G_R3R2_TARGET_ROUTE_SCOPE_INCOMPLETE

## Phase D — Caddy container/Compose topology

Read-only inspect:
- container exact name/id;
- image reference + immutable image ID/digest;
- Entrypoint/Cmd;
- restart policy;
- published ports;
- Docker networks;
- Compose labels/project/service;
- all mounts and read-only flags;
- whether /data is persistent and where;
- whether /config is persistent and where;
- current restart count.

Read:
- /srv/infra/edge/compose.yaml
- SHA-256
- exact Caddy service name
- image
- ports
- networks
- volume/bind definitions
- command/entrypoint overrides

Do not print sensitive environment values.

Require:
CADDY_COMPOSE_SOURCE_IDENTIFIED=PASS
CADDY_SERVICE_NAME=
CADDY_CERT_STATE_PERSISTENCE=PASS
CADDY_CONFIG_STATE_PERSISTENCE=PASS_OR_EXPLAINED
CADDY_RECREATE_DOES_NOT_REQUIRE_COMPOSE_MUTATION=YES

If /data persistence cannot be proven:
RETURN_REVIEWER_G_R3R2_CADDY_CERT_PERSISTENCE_UNPROVEN

## Phase E — Caddy-only recreate plan seal

Do not execute.

Determine the exact no-dependency Caddy-only recreate command from the actual Compose source.

Preferred shape if valid:
sudo -n docker compose -f /srv/infra/edge/compose.yaml up -d --no-deps --force-recreate caddy

Do not assume service name; derive it.

Require:
RECREATE_SCOPE=EXACT_CADDY_SERVICE_ONLY
DOCKER_DAEMON_MUTATION=NO
NETWORK_RECREATE=NO
COMPOSE_FILE_MUTATION=NO
UNRELATED_CONTAINER_RECREATE=NO

Record all user-facing routes that may experience a brief interruption.

Because Caddy owns shared 80/443 and a force-recreate replaces that container, classify:
SHARED_EDGE_BRIEF_DOWNTIME_REQUIRED=YES

Do not claim zero downtime.

## Phase F — proposed future transaction

Seal the future mutation sequence, but do not execute:

1. fresh Cloudflare Dashboard + DNS absence check;
2. fresh SSH/runtime/PPCP check;
3. persist exact legacy mounted rollback candidate under project backup path;
4. verify target canonical 199-byte candidate;
5. atomically replace host /srv/infra/edge/Caddyfile with target canonical candidate;
6. validate host file;
7. recreate only the Caddy Compose service so the new container mounts the current host pathname;
8. prove new container-mounted Caddyfile hash equals target canonical hash;
9. prove localhost/edge-test/unrelated active routes preserved and Mini Craft route present;
10. verify Caddy cert/config persistent state;
11. verify blog_public=0;
12. fresh Cloudflare session/DNS absence check;
13. create exact DNS-only Mini Craft A record;
14. public Sandbox validation.

Rollback if Caddy-only recreate fails:
1. atomically set host Caddyfile to sealed legacy edge rollback candidate;
2. recreate only Caddy service again;
3. prove legacy route inventory restored;
4. do not create DNS.

Rollback after DNS/public failure:
1. delete exact Mini Craft DNS A;
2. restore sealed legacy edge rollback candidate to host;
3. recreate only Caddy service;
4. prove legacy routes restored.

No Compose file/network/daemon mutation.

## Owner checkpoint requirement

If all read-only checks PASS:

RECREATE_PLAN=SEALED
ROLLBACK_PLAN=SEALED
OWNER_CHECKPOINT_REQUIRED=YES

Proposed exact Owner marker:

AUTHORIZE_K6_PHASE_G_R4_SHARED_CADDY_SERVICE_RECREATE

This new authorization is required because the existing Phase G authorization explicitly forbids Caddy restart/recreate and because the operation can briefly interrupt every route served by shared ports 80/443.

## Hard boundaries

No:
- Caddyfile write;
- backup write;
- Caddy reload/restart/recreate;
- Compose mutation;
- Docker network/daemon mutation;
- DNS mutation;
- indexing mutation;
- payment/provider action;
- Secret/credential output;
- unrelated mutation.

## Success

PASS_CANDIDATE_K6_PHASE_G_R3R2_STALE_BIND_MOUNT_RECONCILIATION_AND_RECREATE_PLAN_SEAL

Return at least:
REMOTE_IDENTITY=ops@srv1970241
HOST_CADDY_DEVICE=
HOST_CADDY_INODE=
HOST_CADDY_BYTES=
HOST_CADDY_SHA256=
CONTAINER_CADDY_DEVICE=
CONTAINER_CADDY_INODE=
CONTAINER_CADDY_BYTES=
CONTAINER_CADDY_SHA256=
STALE_SINGLE_FILE_BIND_MOUNT=CONFIRMED
LEGACY_MOUNTED_CADDYFILE_BYTES=
LEGACY_MOUNTED_CADDYFILE_SHA256=
LEGACY_MOUNTED_TO_ACTIVE_SEMANTIC_PARITY=PASS
LEGACY_EDGE_ROLLBACK_BYTES=
LEGACY_EDGE_ROLLBACK_SHA256=
LEGACY_EDGE_ROLLBACK_ADAPT=PASS
ACTIVE_USER_ROUTE_INVENTORY_COMPLETE=YES
TARGET_CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
TARGET_PRESERVES_ALL_UNRELATED_ACTIVE_ROUTES=PASS
CADDY_COMPOSE_SOURCE_IDENTIFIED=PASS
CADDY_SERVICE_NAME=
CADDY_CERT_STATE_PERSISTENCE=PASS
CADDY_CONFIG_STATE_PERSISTENCE=
CADDY_RECREATE_DOES_NOT_REQUIRE_COMPOSE_MUTATION=YES
RECREATE_SCOPE=EXACT_CADDY_SERVICE_ONLY
SHARED_EDGE_BRIEF_DOWNTIME_REQUIRED=YES
RECREATE_PLAN=SEALED
ROLLBACK_PLAN=SEALED
OWNER_CHECKPOINT_REQUIRED=YES
CADDYFILE_WRITE=0
CADDY_RELOAD=0
CADDY_RESTART=0
CADDY_RECREATE=0
DNS_WRITES=0
SHARED_INFRA_WRITES=0
PAYMENT_ACTIONS=0
STOP_AT_REVIEWER=YES
