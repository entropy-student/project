# K6 Phase G-R3R2R1 — Native Read-Only Stale Bind-Mount Reconciliation

Gate:
K6_PHASE_G_R3R2R1_NATIVE_READONLY_STALE_BIND_MOUNT_RECONCILIATION

Read:
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_G_R3R2_RETURN_G_R3R2R1_NATIVE_READONLY_RETRY.md
- prior G-R3R2 Decision/Execution Pack
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md
- canonical VPS governance

## Rule

Do not use the failed Python tuple/bytes command wrapper.

Exactly one strict direct-native SSH session.

Use simple native commands and bounded parsing.

## Required checks

A. Identity
- whoami -> ops
- hostname -> srv1970241

B. Host/container Caddyfile
- stat device/inode
- byte count
- sha256
- mount source/destination/read-only
- no cross-namespace inode equality check

C. Legacy mounted config
- read in memory only
- caddy adapt
- compare semantics to active Admin config
- seal rollback bytes/hash/adapt in memory only

D. Active route inventory
- enumerate every user hostname + material handler/upstream
- prove target canonical SHA cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8 preserves all unrelated routes

E. Compose/runtime topology
- /srv/infra/edge/compose.yaml SHA
- exact Caddy service name
- image reference + immutable image ID
- ports
- networks
- mounts
- restart policy/count
- /data persistence
- /config persistence
- no sensitive env output

F. Recreate plan seal
- derive exact Caddy-only no-deps force-recreate command
- do not execute
- prove no Compose/network/daemon mutation required
- mark brief shared-edge downtime required
- seal rollback plan

## Success

PASS_CANDIDATE_K6_PHASE_G_R3R2R1_NATIVE_READONLY_STALE_BIND_MOUNT_RECONCILIATION

Return all G-R3R2 success markers plus:
HELPER_MODE=NATIVE_DIRECT_NO_TUPLE_BYTES_WRAPPER
SSH_NETWORK_INVOCATIONS=1
STOP_AT_REVIEWER=YES

## Forbidden

No writes, reload/restart/recreate, DNS/indexing/payment action, Secret output, or local worktree mutation.
