# K6 Phase G-R3R2R2 — Read-Only Remainder + Recreate Plan Seal

Gate:
K6_PHASE_G_R3R2R2_READONLY_REMAINDER_AND_RECREATE_PLAN_SEAL

Already accepted from Evidence commit 2bbc43eda8c9ccd321f251c9db64e885bcedf833:
- REMOTE_IDENTITY=ops@srv1970241
- host Caddyfile=76 bytes / SHA 12fac82e...
- container mounted Caddyfile=153 bytes / SHA 126292f6...
- bind source/destination/read-only correct
- STALE_SINGLE_FILE_BIND_MOUNT=CONFIRMED
- Caddy service label=caddy
- ports 80/443
- network spikersun-edge
- compose label config=/srv/infra/edge/compose.yaml

Do not redo mount reconciliation.

## One SSH, read-only remainder only

1. Confirm remote identity only.
2. Read the existing 153-byte mounted Caddyfile in memory.
3. Run caddy adapt on it.
4. Read fresh active Admin config.
5. Prove semantic parity or return the exact bounded difference.
6. Seal legacy rollback bytes/hash/adapt status in memory.
7. Enumerate all active user hostname routes and material handlers/upstreams.
8. Compare the existing 199-byte target candidate and prove every unrelated active route is preserved.
9. Read /srv/infra/edge/compose.yaml and record SHA.
10. Run docker compose -f /srv/infra/edge/compose.yaml config read-only.
11. Verify service name caddy, image, ports, network and Caddyfile bind.
12. Use docker inspect --format directly to identify /data and /config mounts; no custom JSON-key parser.
13. Prove /data is persistent across Caddy-only recreate.
14. Classify /config persistence.
15. Derive exact Caddy-only --no-deps --force-recreate command. Do not execute.
16. Seal target transaction and rollback plan.

## Required outputs

LEGACY_MOUNTED_CADDYFILE_BYTES=153
LEGACY_MOUNTED_CADDYFILE_SHA256=126292f6bc2a77929539704a84c5d7a4ab3364ec39364a14abafda176b631837
LEGACY_MOUNTED_TO_ACTIVE_SEMANTIC_PARITY=PASS
LEGACY_EDGE_ROLLBACK_BYTES=
LEGACY_EDGE_ROLLBACK_SHA256=
LEGACY_EDGE_ROLLBACK_ADAPT=PASS
ACTIVE_USER_ROUTE_INVENTORY_COMPLETE=YES
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

## Forbidden

No write/reload/restart/recreate/DNS/indexing/payment/Secret output/local worktree mutation.

## Success

PASS_CANDIDATE_K6_PHASE_G_R3R2R2_READONLY_REMAINDER_AND_RECREATE_PLAN_SEAL
STOP_AT_REVIEWER=YES
