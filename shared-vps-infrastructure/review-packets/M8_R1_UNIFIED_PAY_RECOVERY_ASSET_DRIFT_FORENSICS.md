# M8-R1 — Unified Pay Recovery Asset Drift Forensics

## Gate

```text
GATE=M8_R1_UNIFIED_PAY_RECOVERY_ASSET_DRIFT_FORENSICS
MODE=STRICT_READ_ONLY_INCIDENT_FORENSICS
ACCESS_PATH=CANONICAL_STRICT_SSH_PLUS_CANONICAL_PROJECT_HISTORY
STOP_AT_REVIEWER=YES
```

## Read first

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M7_PASS_M8_UNIFIED_PAY_POSTGRES_CONTAINER_DECOMMISSION.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M8_RETURN_R1_RECOVERY_ASSET_DRIFT_FORENSICS.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md

unified-pay-system/REVIEWER_HANDOFF.md
unified-pay-system/PROJECT_STORAGE_MANIFEST.md
unified-pay-system/PROJECT_RECORD.md
```

Use canonical strict SSH to ops@srv1970241.

Do not recreate, restore, mkdir, touch, copy, move, chmod, chown, start containers, mount filesystems, or modify any state.

## A. Freeze and current path truth

Read-only inspect:

```text
/srv/apps/unified-pay
/srv/data/unified-pay
/srv/data/unified-pay/db
/srv/data/unified-pay/secrets
/srv/backups/unified-pay
```

For each, report only:

- exists yes/no;
- type file/dir/symlink;
- owner/group/mode;
- inode if safe;
- mtime/ctime;
- entry count and aggregate size;
- mountpoint yes/no;
- symlink target only if present and non-secret.

Do not print Secret filenames if the canonical Secret names are considered sensitive beyond already-authorized metadata; otherwise use count only.

## B. Search for moved/renamed recovery assets

Read-only search within /srv, /root-safe metadata scopes available via sudo, and known project paths for exact known non-secret artifact names/patterns:

```text
docker-compose.prod.yml
d13-r1-preflight.dump
d13-r1-final.dump
pre-alipay-*-db-*.dump
pre-alipay-*-compose-*.yml
```

Also search by known Compose SHA-256 when practical without writing temporary files:

```text
deb4f91d39a53df951c3d61c9911baba73b1a06bfd4d9079b7f8932221e3ff44
```

Do not scan other project DB contents. Do not emit backup contents.

Return safe paths only.

## C. Command/audit timeline around M8

Inspect read-only system logs around the M8 execution window, including available sudo/auth/journal/Docker daemon audit evidence.

Goal: identify commands or daemon operations that reference:

- docker rm of the known DB container;
- /srv/apps/unified-pay;
- /srv/data/unified-pay;
- /srv/backups/unified-pay;
- rm/rmdir/find -delete/mv/cp/rsync/tar/compose down/volume operations.

Output only timestamp + sanitized command/action classification. Redact Secret-bearing arguments or values if any.

Do not assume absence from logs proves absence of a command.

## D. Docker/container metadata remnants

Read-only inspect Docker events/logs if still available around M8.

Confirm whether the removed DB container had a bind mount to /srv/data/unified-pay/db and whether any volume driver/anonymous volume was involved.

Return:

```text
DB_STORAGE_TYPE=BIND|NAMED_VOLUME|ANONYMOUS_VOLUME|UNRESOLVED
DB_BIND_SOURCE=/srv/data/unified-pay/db|OTHER|UNRESOLVED
DOCKER_RM_WITH_VOLUME_FLAG_EVIDENCE=YES|NO|UNRESOLVED
```

Do not mutate Docker.

## E. Secret survival

Metadata-only verify current Secret recovery state.

Return:

```text
VPS_SECRET_SOURCE_PRESENT=YES|NO|UNRESOLVED
VPS_SECRET_FILE_COUNT=<count_or_unresolved>
SECRET_CONTENT_READS=0
```

Historical accepted external Secret recovery source:

```text
C:\Users\34707\AppData\Local\DujiaoNext\recovery\unified-pay\secrets-20260913T082602Z.tar.dpapi
```

Do not ask Owner to decrypt it in this Gate. If local workstation access is available to Executor, verify existence/size/hash metadata only without decrypting.

## F. External/non-VPS recovery inventory

Use canonical GitHub/project-space history to classify:

- source archive availability;
- reconstructible Compose source availability;
- historical DB dump evidence;
- actual external DB dump bytes availability vs documentation-only evidence;
- Windows DPAPI Secret artifact availability metadata.

Important: documentation proving a dump once existed is NOT an available dump.

Return:

```text
COMPOSE_RECOVERY_SOURCE=VPS|GITHUB_SOURCE_BUNDLE|HISTORICAL_COPY|NONE
DATABASE_EXACT_RECOVERY_SOURCE=VPS_DATA|VPS_DUMP|EXTERNAL_DUMP|NONE|UNRESOLVED
SECRET_RECOVERY_SOURCE=VPS|WINDOWS_DPAPI|NONE|UNRESOLVED
```

## G. Final classification

Return exactly one:

```text
RECOVERY_ASSET_DRIFT_CLASS=MISREAD_OR_PATH_ERROR
RECOVERY_ASSET_DRIFT_CLASS=MOVED_OR_RENAMED_RECOVERABLE
RECOVERY_ASSET_DRIFT_CLASS=DELETED_BUT_EXTERNAL_RECOVERY_AVAILABLE
RECOVERY_ASSET_DRIFT_CLASS=DELETED_EXACT_STATE_NOT_RECOVERABLE
RECOVERY_ASSET_DRIFT_CLASS=UNRESOLVED
```

Include a concise causal-confidence statement:

```text
DOCKER_RM_CAUSALITY=PROVEN|DISPROVEN|NOT_PROVEN
OTHER_DESTRUCTIVE_COMMAND_EVIDENCE=YES|NO|UNRESOLVED
```

## Hard boundaries

```text
VPS_WRITES=0
DOCKER_MUTATIONS=0
CONTAINER_STARTS=0
CONTAINER_CREATES=0
FILES_CREATED=0
FILES_MOVED=0
FILES_DELETED=0
DIRECTORIES_CREATED=0
MOUNTS=0
DATABASE_WRITES=0
RESTORE_ACTIONS=0
BACKUP_ACTIONS=0
SECRET_CONTENT_READS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
PROVIDER_CALLS=0
PAYMENT_ACTIONS=0
```

## Evidence

Append only to shared-vps-infrastructure/EXECUTION_EVIDENCE.md and EXECUTOR_HANDOFF.md, fresh-read both.

## Success return

```text
PASS_CANDIDATE_M8_R1_UNIFIED_PAY_RECOVERY_ASSET_DRIFT_FORENSICS
RECOVERY_ASSET_DRIFT_CLASS=<classification>
DB_STORAGE_TYPE=<classification>
DOCKER_RM_CAUSALITY=PROVEN|DISPROVEN|NOT_PROVEN
OTHER_DESTRUCTIVE_COMMAND_EVIDENCE=YES|NO|UNRESOLVED
COMPOSE_RECOVERY_SOURCE=<classification>
DATABASE_EXACT_RECOVERY_SOURCE=<classification>
SECRET_RECOVERY_SOURCE=<classification>
KNOWN_PROJECT_REGRESSION=NO|YES
FURTHER_MUTATIONS=0
STOP_AT_REVIEWER=YES
```

Do not restore or recreate anything.
