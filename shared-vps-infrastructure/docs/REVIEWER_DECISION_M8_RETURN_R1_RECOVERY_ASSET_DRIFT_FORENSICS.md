# Reviewer Decision — M8 RETURN / M8-R1 Unified Pay Recovery Asset Drift Forensics

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Independent review

- Executor result: RETURN_M8_POSTDELETE_RECOVERY_ASSET_DRIFT
- Evidence commit: df315047840f384bdddde859207d735d71bec053
- Executor Handoff commit: e9b2de0303d3e9c36fb7e025b62e16a11a48ad3a

The RETURN is accepted fail-closed.

## Verified M8 facts

```text
UNIFIED_PAY_APP_CONTAINER_PRESENT=NO
UNIFIED_PAY_POSTGRES_CONTAINER_PRESENT=NO
UNIFIED_PAY_APP_IMAGE_PRESENT=YES
UNIFIED_PAY_POSTGRES_IMAGE_PRESENT=YES
KNOWN_PROJECT_REGRESSION=NO

PREDELETE_COMPOSE_PRESENT=YES
PREDELETE_DATA_DB_PRESENT=YES
PREDELETE_BACKUP_FILE_COUNT=33
PREDELETE_BACKUP_TOTAL_BYTES=566264

POSTDELETE_COMPOSE_PRESENT=NO
POSTDELETE_DATA_ROOT_PRESENT=YES
POSTDELETE_DATA_DB_PRESENT=NO
POSTDELETE_BACKUP_ROOT_PRESENT=YES
POSTDELETE_BACKUP_FILE_COUNT=0
```

Exactly one stopped PostgreSQL container removal is evidenced. The disappearance of the host Compose file, bind-mounted database directory and backup files is not an expected effect of plain docker rm and currently has no proven causal attribution.

## Current incident classification

```text
M8_RESULT=RETURN_M8_POSTDELETE_RECOVERY_ASSET_DRIFT
UNIFIED_PAY_RECOVERY_BARRIER=FAILED
UNIFIED_PAY_RUNTIME_DECOMMISSIONED=YES
UNIFIED_PAY_EXACT_STATE_RECOVERABILITY=UNRESOLVED
OTHER_PROJECT_IMPACT=NONE_OBSERVED
```

Historical records show Unified Pay was an internal/test-oriented payment infrastructure with no real provider transaction/payment action in the sole ambiguous canary, no current Dujiao runtime dependency, and no known current production business caller. Therefore current business impact appears limited, but the unexpected loss of recovery assets must be investigated before any further Unified Pay cleanup.

## M8-R1 authorization

M8-R1 is strictly read-only incident forensics.

Goals:

1. prove whether the files were deleted, moved, renamed, mounted elsewhere, or merely mis-read;
2. establish exact filesystem metadata/timestamps for surviving parent directories and Secret sources;
3. inspect safe sudo/auth/journal/Docker logs around the M8 window for commands/actions affecting /srv/apps/unified-pay, /srv/data/unified-pay or /srv/backups/unified-pay;
4. search the VPS read-only for uniquely named known recovery artifacts and the canonical Compose hash/name;
5. verify whether Unified Pay Secrets still exist by metadata only;
6. inventory all non-VPS recovery sources already documented: GitHub source bundle, historical project-space records, Windows DPAPI Secret recovery artifact, and any local/database dump copy if discoverable without mutation;
7. classify exact-state recoverability without restoring anything.

## Emergency freeze

Until M8-R1 is reviewed:

```text
UNIFIED_PAY_FURTHER_DELETION_AUTHORIZED=NO
UNIFIED_PAY_RESTORE_AUTHORIZED=NO
UNIFIED_PAY_RECREATE_AUTHORIZED=NO
UNIFIED_PAY_DIRECTORY_CREATION_AUTHORIZED=NO
UNIFIED_PAY_BACKUP_RECREATION_AUTHORIZED=NO
UNIFIED_PAY_SECRET_MUTATION_AUTHORIZED=NO
UNIFIED_PAY_TUNNEL_MUTATION_AUTHORIZED=NO
```

The Owner standing decommission authorization is temporarily suspended for destructive Unified Pay actions until this incident is reconciled.

## Success classifications

Return one of:

```text
RECOVERY_ASSET_DRIFT_CLASS=MISREAD_OR_PATH_ERROR
RECOVERY_ASSET_DRIFT_CLASS=MOVED_OR_RENAMED_RECOVERABLE
RECOVERY_ASSET_DRIFT_CLASS=DELETED_BUT_EXTERNAL_RECOVERY_AVAILABLE
RECOVERY_ASSET_DRIFT_CLASS=DELETED_EXACT_STATE_NOT_RECOVERABLE
RECOVERY_ASSET_DRIFT_CLASS=UNRESOLVED
```

and:

```text
COMPOSE_RECOVERY_SOURCE=VPS|GITHUB_SOURCE_BUNDLE|HISTORICAL_COPY|NONE
DATABASE_EXACT_RECOVERY_SOURCE=VPS_DATA|VPS_DUMP|EXTERNAL_DUMP|NONE|UNRESOLVED
SECRET_RECOVERY_SOURCE=VPS|WINDOWS_DPAPI|NONE|UNRESOLVED
FURTHER_MUTATIONS=0
STOP_AT_REVIEWER=YES
```