# Reviewer Decision — K6 G-R3R2R1 RETURN Accepted / Read-Only Remainder Only

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper

## Reviewed result

GATE=K6_PHASE_G_R3R2R1_NATIVE_READONLY_STALE_BIND_MOUNT_RECONCILIATION
RESULT=RETURN_REVIEWER_G_R3R2R1_MOUNT_METADATA_PARSER_ERROR
EVIDENCE_COMMIT=2bbc43eda8c9ccd321f251c9db64e885bcedf833
HANDOFF_COMMIT=491a7eab7721bd9876e1ebc1292cfc382949c061

Reviewer accepts the RETURN as helper/parser failure after sufficient direct-native evidence was already produced.

## Facts now formally accepted

REMOTE_IDENTITY=ops@srv1970241
REMOTE_HOSTNAME=srv1970241

HOST_CADDY_BYTES=76
HOST_CADDY_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
HOST_CADDY_INODE=791399

CONTAINER_CADDY_BYTES=153
CONTAINER_CADDY_SHA256=126292f6bc2a77929539704a84c5d7a4ab3364ec39364a14abafda176b631837
CONTAINER_CADDY_INODE=787439

CADDYFILE_MOUNT_TYPE=bind
CADDYFILE_MOUNT_SOURCE=/srv/infra/edge/Caddyfile
CADDYFILE_MOUNT_DESTINATION=/etc/caddy/Caddyfile
CADDYFILE_MOUNT_READ_ONLY=YES

STALE_SINGLE_FILE_BIND_MOUNT=CONFIRMED

CADDY_RUNTIME_STATE=running
CADDY_RESTART_COUNT=0
CADDY_RESTART_POLICY=unless-stopped
CADDY_IMAGE_REFERENCE=caddy:2-alpine
CADDY_IMAGE_ID=sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648
CADDY_CMD=caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
CADDY_PUBLISHED_PORTS=80/tcp,443/tcp
CADDY_NETWORKS=spikersun-edge
CADDY_COMPOSE_LABEL_PROJECT=spikersun-edge
CADDY_COMPOSE_LABEL_SERVICE=caddy
CADDY_COMPOSE_LABEL_CONFIG=/srv/infra/edge/compose.yaml

## Classification

HELPER_PARSER_ERROR_AFTER_MATERIAL_FACTS_CAPTURED

The false mount-drift marker was caused by case-sensitive parsing of Docker mount JSON keys. Direct Docker inspection already proved the expected bind source, destination and read-only state.

The mount layer is closed. Do not re-run it.

## Current Gate

CURRENT_GATE=K6_PHASE_G_R3R2R2_READONLY_REMAINDER_AND_RECREATE_PLAN_SEAL
CURRENT_GATE_STATUS=AUTHORIZED_AWAIT_EXECUTOR
OWNER_ACTION=NONE

## Objective

Complete only the G-R3R2 checks that remain unresolved:

1. legacy 153-byte mounted Caddyfile semantic parity with active Admin config;
2. complete active user-route inventory;
3. target 199-byte candidate preservation of all unrelated active routes;
4. Compose source hash/service verification;
5. /data certificate-state persistence and /config classification;
6. exact Caddy-only recreate plan and rollback plan seal.

Do not re-check the already accepted stale mount facts unless a direct command unexpectedly shows material contradiction.

## Parser discipline

Do not use custom JSON key parsing for Docker mount metadata.

Prefer direct Docker Go-template output and native commands.

Examples:
- docker inspect --format for labels, mounts, image, restart policy/count;
- sha256sum /srv/infra/edge/compose.yaml;
- docker compose -f /srv/infra/edge/compose.yaml config;
- docker exec ... caddy adapt;
- container-loopback read-only Caddy Admin GET.

No Python command wrapper.

## Hard boundaries

Read-only only.

No:
- Caddyfile/backup write;
- Caddy reload/restart/recreate;
- Compose/network/daemon mutation;
- DNS/indexing/payment mutation;
- Secret/credential output;
- local worktree mutation.

## Success

PASS_CANDIDATE_K6_PHASE_G_R3R2R2_READONLY_REMAINDER_AND_RECREATE_PLAN_SEAL

Required:
STALE_SINGLE_FILE_BIND_MOUNT=ACCEPTED_FROM_2bbc43e
LEGACY_MOUNTED_CADDYFILE_BYTES=153
LEGACY_MOUNTED_CADDYFILE_SHA256=126292f6bc2a77929539704a84c5d7a4ab3364ec39364a14abafda176b631837
LEGACY_MOUNTED_TO_ACTIVE_SEMANTIC_PARITY=PASS
LEGACY_EDGE_ROLLBACK_BYTES=
LEGACY_EDGE_ROLLBACK_SHA256=
LEGACY_EDGE_ROLLBACK_ADAPT=PASS
ACTIVE_USER_ROUTE_INVENTORY_COMPLETE=YES
TARGET_CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
TARGET_PRESERVES_ALL_UNRELATED_ACTIVE_ROUTES=PASS
CADDY_COMPOSE_SOURCE_IDENTIFIED=PASS
CADDY_COMPOSE_SHA256=
CADDY_SERVICE_NAME=caddy
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
