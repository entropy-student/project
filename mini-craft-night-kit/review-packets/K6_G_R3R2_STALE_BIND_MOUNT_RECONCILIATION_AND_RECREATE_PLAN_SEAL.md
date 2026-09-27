# K6 Phase G-R3R2 — Stale Bind-Mount Reconciliation + Recreate Plan Seal

Gate:
K6_PHASE_G_R3R2_STALE_BIND_MOUNT_RECONCILIATION_AND_RECREATE_PLAN_SEAL

Owner authorization currently remains the prior Phase G authorization only:
AUTHORIZE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION

This Gate is read-only. It does NOT authorize Caddy restart/recreate.

## Goal

Freshly prove the host/container Caddyfile split, identify the exact legacy mounted config and its relation to the active Admin config, inspect the Caddy Compose/runtime persistence topology, and seal a Caddy-only recreate + rollback plan.

## A — one strict SSH, fresh file-object facts

Require:
REMOTE_IDENTITY=ops@srv1970241

Read separately:

Host:
- /srv/infra/edge/Caddyfile
- device/inode/bytes/SHA
- owner/group/mode

Container:
- spikersun-edge-caddy-1:/etc/caddy/Caddyfile
- device/inode/bytes/SHA
- mount type/source/destination/read-only

Never compare host/container inode equality.

If the two content views still differ:
STALE_SINGLE_FILE_BIND_MOUNT=CONFIRMED

## B — legacy mounted config semantic seal

Read current container-mounted Caddyfile into process memory only.

Record:
LEGACY_MOUNTED_CADDYFILE_BYTES=
LEGACY_MOUNTED_CADDYFILE_SHA256=

Run caddy adapt and bounded semantic extraction.

Compare with fresh active Admin API config.

Require:
LEGACY_MOUNTED_TO_ACTIVE_SEMANTIC_PARITY=PASS

Record only:
- user host matchers
- handler types
- static response status/body bytes/body hash
- reverse_proxy upstreams
- localhost behavior

No sensitive values.

Seal a valid rollback source in memory:
LEGACY_EDGE_ROLLBACK_BYTES=
LEGACY_EDGE_ROLLBACK_SHA256=
LEGACY_EDGE_ROLLBACK_ADAPT=PASS

No file write.

## C — active route inventory and target preservation

Freshly enumerate every user-defined active hostname/handler/upstream.

Require:
ACTIVE_USER_ROUTE_INVENTORY_COMPLETE=YES

Compare the existing target canonical candidate:

TARGET_CANONICAL_CANDIDATE_SHA256=
cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

Require:
TARGET_PRESERVES_ALL_UNRELATED_ACTIVE_ROUTES=PASS

If any unrelated active route is absent from the target:
RETURN_REVIEWER_G_R3R2_TARGET_ROUTE_SCOPE_INCOMPLETE

## D — Caddy Compose/runtime topology

Read-only inspect:
- exact Caddy container ID/name
- image reference + immutable image ID/digest
- Entrypoint/Cmd
- RestartCount/restart policy
- published ports
- networks
- Compose labels/project/service
- all mounts
- persistence for /data
- persistence for /config

Read:
/srv/infra/edge/compose.yaml

Record:
CADDY_COMPOSE_SHA256=
CADDY_SERVICE_NAME=
CADDY_COMPOSE_SOURCE_IDENTIFIED=PASS

Do not output sensitive environment values.

Require:
CADDY_CERT_STATE_PERSISTENCE=PASS

Also classify:
CADDY_CONFIG_STATE_PERSISTENCE=PASS|NOT_REQUIRED_BY_STARTUP_PATH|EXPLAINED

Require:
CADDY_RECREATE_DOES_NOT_REQUIRE_COMPOSE_MUTATION=YES

If cert state persistence is unproven:
RETURN_REVIEWER_G_R3R2_CADDY_CERT_PERSISTENCE_UNPROVEN

## E — exact Caddy-only recreate plan

Derive, do not assume, the exact Compose service name.

Seal the no-dependency force-recreate command shape, for example only if exact service is caddy:

sudo -n docker compose -f /srv/infra/edge/compose.yaml up -d --no-deps --force-recreate caddy

Do not execute.

Require:
RECREATE_SCOPE=EXACT_CADDY_SERVICE_ONLY
DOCKER_DAEMON_MUTATION=NO
NETWORK_RECREATE=NO
COMPOSE_FILE_MUTATION=NO
UNRELATED_CONTAINER_RECREATE=NO

Because Caddy owns shared 80/443:
SHARED_EDGE_BRIEF_DOWNTIME_REQUIRED=YES

Enumerate bounded user-facing routes that may be briefly interrupted.

## F — future mutation/rollback plan

Do not execute.

Target path:
1. fresh Cloudflare Dashboard + exact DNS absence
2. fresh SSH/runtime/PPCP
3. persist exact legacy mounted rollback candidate under project backup path
4. verify target canonical 199-byte candidate
5. atomically replace host Caddyfile with target candidate
6. validate host candidate
7. recreate only the Caddy service
8. prove new mount hash == target candidate
9. prove all existing routes preserved + Mini Craft route active
10. prove cert/config persistence healthy
11. blog_public=0
12. fresh Cloudflare pre-DNS check
13. create exact DNS-only Mini Craft A
14. public Sandbox validation

Rollback before DNS if target recreate fails:
1. host Caddyfile <- sealed legacy rollback candidate
2. recreate only Caddy service
3. prove legacy route inventory restored
4. DNS remains absent

Rollback after DNS/public failure:
1. delete exact Mini Craft A
2. host Caddyfile <- sealed legacy rollback candidate
3. recreate only Caddy service
4. prove legacy routes restored

## Owner checkpoint

If all PASS:

RECREATE_PLAN=SEALED
ROLLBACK_PLAN=SEALED
OWNER_CHECKPOINT_REQUIRED=YES

Required future Owner marker:

AUTHORIZE_K6_PHASE_G_R4_SHARED_CADDY_SERVICE_RECREATE

This is a new authorization because current Phase G explicitly forbids Caddy restart/recreate and a Caddy-only force-recreate can briefly interrupt all routes on shared 80/443.

## Forbidden

No Caddyfile/backup write, reload, restart, recreate, Compose/network/daemon mutation, DNS/indexing/payment mutation, Secret/credential output, or unrelated mutation.

## Success

PASS_CANDIDATE_K6_PHASE_G_R3R2_STALE_BIND_MOUNT_RECONCILIATION_AND_RECREATE_PLAN_SEAL

Return:
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
CADDY_COMPOSE_SHA256=
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