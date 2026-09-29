# Xianyu — REVIEWER HANDOFF

## CURRENT REVIEWER UPDATE — Shared VPS Portfolio Reconciliation R1 — 2026-09-29

```text
PROJECT_ROLE=ACTIVE_RUNTIME
RUNTIME_HEALTH=PASS
CONTAINER=xianyu-xianyu-app-1
RESTART_COUNT=0
AUTOMATION_SAFE_MODE=false

APPS_PATH=/srv/apps/xianyu
DATA_PATH=/srv/data/xianyu
BACKUPS_PATH=/srv/backups/xianyu

PUBLIC_INGRESS=UNKNOWN
CURRENT_GATE=DOCUMENTATION_ONLY
CLEANUP_AUTHORIZED=NO
```

### Current topology

Current production runtime uses `/srv/apps/xianyu` and `/srv/data/xianyu` and is attached to `spikersun-private`.

### Legacy / retention review

```text
/srv/apps/xianyu.pre-x6-20260911-0729 = RETENTION_REVIEW
/tmp/xianyu-x6-build-20260911-0719 = RETENTION_REVIEW
/tmp/xianyu-x6-build-20260911-0720 = RETENTION_REVIEW
slider_debug logs ≈ 76 files / 19.2 MiB = RETENTION_REVIEW
8 backup generations ≈45 MiB = RETENTION_REVIEW
xianyu_xianyu-network = DELETE_CANDIDATE_NOT_AUTHORIZED
```

The old source/build paths have zero current process/Compose/mount references in R1, but metadata comparison still shows unmatched items. Reconstructibility/content equivalence has not been proven.

The eight backup generations have not been proven mutually superseded.

### Current unknowns

- public ingress ownership
- whether all historical backup generations remain independently necessary

No runtime, data, network or backup deletion is authorized by this handoff.
