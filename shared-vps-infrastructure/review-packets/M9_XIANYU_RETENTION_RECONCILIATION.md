# M9 — Xianyu Retention Reconciliation

## Gate

```text
GATE=M9_XIANYU_RETENTION_RECONCILIATION
MODE=STRICT_READ_ONLY
ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Objective

Classify Xianyu legacy/recovery assets before any cleanup. No deletion or mutation is authorized.

## Read first

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/SHARED_VPS_PORTFOLIO.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
xianyu/REVIEWER_HANDOFF.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Use canonical strict SSH to ops@srv1970241.

## A. Current runtime baseline

Freshly verify:

- xianyu current app container identity/state/restart count;
- current Compose/project path;
- current data path;
- current networks;
- safe mode state;
- current public ingress ownership and target if provable read-only;
- public endpoint behavior if a current hostname can be proven;
- cloudflared/shared network state.

Do not mutate Cloudflare/DNS/Tunnel.

## B. Legacy source/build trees

Inspect metadata only for:

```text
/srv/apps/xianyu.pre-x6-20260911-0729
/tmp/xianyu-x6-build-20260911-0719
/tmp/xianyu-x6-build-20260911-0720
```

For each:

- exists/type/size/file count;
- process references;
- active Compose references;
- mount references;
- exact current-runtime reference count;
- compare file manifests/hashes against current source where practical;
- identify unmatched files by relative path/category without exposing secrets.

Classify each:

```text
LEGACY_SOURCE_CLASS=EXACT_DUPLICATE|RECONSTRUCTIBLE_SUPERSEDED|UNIQUE_RECOVERY_VALUE|UNRESOLVED
```

## C. slider_debug

Inspect current location, file count, total size, newest/oldest mtime, active writer references and whether current runtime still writes there.

Classify:

```text
SLIDER_DEBUG_CLASS=ACTIVE_RUNTIME_LOGS|HISTORICAL_DISPOSABLE|UNIQUE_DIAGNOSTIC_VALUE|UNRESOLVED
```

Do not read sensitive log payloads; metadata and safe filenames only.

## D. Eight backup generations

Inventory all Xianyu backup generations:

- safe filename;
- timestamp;
- size;
- type/content class;
- whether valid archive/dump format using non-destructive checks;
- relation to current source/data/version;
- whether later backup provably supersedes earlier backup.

Do not restore or extract into production paths.

For each backup classify:

```text
BACKUP_CLASS=KEEP_CURRENT_RECOVERY|SUPERSEDED_SAFE_DELETE_CANDIDATE|UNIQUE_RECOVERY_POINT|CORRUPT_OR_UNUSABLE|UNRESOLVED
```

Return exact count in each class.

## E. xianyu_xianyu-network

Read-only verify:

- network exists;
- attached container count;
- active Compose declaration count;
- current runtime needs it yes/no;
- any external/shared dependency.

Classify:

```text
XIANYU_LEGACY_NETWORK_CLASS=ACTIVE_REQUIRED|ORPHAN_DELETE_CANDIDATE|UNRESOLVED
```

## F. Cleanup candidate summary

Return only evidence-based candidates. Do not delete anything.

```text
SAFE_DELETE_CANDIDATE_COUNT=<n>
RETENTION_REQUIRED_COUNT=<n>
UNRESOLVED_COUNT=<n>
XIANYU_CLEANUP_WRITE_GATE_READY=YES|NO
```

## Hard boundaries

```text
VPS_WRITES=0
DOCKER_MUTATIONS=0
FILE_DELETIONS=0
BACKUP_MUTATIONS=0
NETWORK_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
SECRET_CONTENT_READS=0
BROAD_PRUNE=NO
```

## Evidence

Append to shared-vps-infrastructure/EXECUTION_EVIDENCE.md and EXECUTOR_HANDOFF.md, then fresh-read both.

## Success return

```text
PASS_CANDIDATE_M9_XIANYU_RETENTION_RECONCILIATION
XIANYU_RUNTIME_HEALTH=PASS
XIANYU_PUBLIC_INGRESS=<safe classification>
LEGACY_SOURCE_SUMMARY=<safe summary>
SLIDER_DEBUG_CLASS=<classification>
BACKUP_KEEP_COUNT=<n>
BACKUP_DELETE_CANDIDATE_COUNT=<n>
BACKUP_UNRESOLVED_COUNT=<n>
XIANYU_LEGACY_NETWORK_CLASS=<classification>
XIANYU_CLEANUP_WRITE_GATE_READY=YES|NO
MUTATIONS=0
STOP_AT_REVIEWER=YES
```