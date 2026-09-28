# K9B-R3R1 — Hostinger Console Remote Recovery Barrier

Status: OWNER_LOCAL_READONLY_CHECKPOINT
Date: 2026-09-29

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K9B_R3_RETURN_HOSTINGER_CONSOLE_RECOVERY_BARRIER.md
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md
- canonical Governance latest
- Target Host Reality Contract rev2

## Goal

Use the Hostinger VPS browser console to freshly prove the Mini Craft remote recovery classes still exist.

No SSH retry.
No local deletion.
No Docker volume deletion.
No VPS mutation.

## Execution boundary

Use the Hostinger browser terminal/console for the known production VPS.

Owner may need to complete Hostinger login. Credentials must not be shared in chat or persisted in project evidence.

## Run exactly one read-only shell block

```bash
set -eu
printf 'HOST='; hostname
printf 'USER='; id -un

for p in   /srv/backups/mini-craft-night-kit   /srv/backups/mini-craft-night-kit/database   /srv/backups/mini-craft-night-kit/manifests
do
  if [ -d "$p" ]; then
    printf 'DIR_PRESENT=%s\n' "$p"
  else
    printf 'DIR_MISSING=%s\n' "$p"
  fi
done

find /srv/backups/mini-craft-night-kit -maxdepth 2 -type f   -printf 'FILE=%p|BYTES=%s|MODE=%m\n' 2>/dev/null   | sed -n '1,120p'

if [ -d /srv/data/mini-craft-night-kit/wp-content ]; then
  echo 'CURRENT_WP_CONTENT_PRESENT=YES'
else
  echo 'CURRENT_WP_CONTENT_PRESENT=NO'
fi

if [ -d /srv/data/mini-craft-night-kit/mysql ]; then
  echo 'CURRENT_MYSQL_PRESENT=YES'
else
  echo 'CURRENT_MYSQL_PRESENT=NO'
fi
```

Do not cat/read backup contents.

## Classification

From the output classify:

```text
PROJECT_BACKUP_ROOT_PRESENT=
DATABASE_RECOVERY_FILE_PRESENT=
WP_CONTENT_RECOVERY_FILE_PRESENT=
MANIFEST_OR_DEPLOYMENT_RECOVERY_FILE_PRESENT=
CURRENT_WP_CONTENT_PRESENT=
CURRENT_MYSQL_PRESENT=
```

Database recovery may be satisfied by the K7 52-table migration backup or another accepted project DB backup.

Wp-content recovery may be satisfied by the accepted staged K5 wp-content archive if still present.

Manifest/deployment recovery may be satisfied by project-scoped files under the backup namespace that support redeploy/rollback continuity.

## Persist

Append exact non-secret metadata-only output summary to:
- EXECUTION_EVIDENCE.md
- EXECUTOR_HANDOFF.md

Do not persist credentials or file contents.

## Success

```text
PASS_CANDIDATE_K9B_R3R1_HOSTINGER_CONSOLE_REMOTE_RECOVERY_BARRIER
HOST=srv1970241
PROJECT_BACKUP_ROOT_PRESENT=YES
DATABASE_RECOVERY_FILE_PRESENT=YES
WP_CONTENT_RECOVERY_FILE_PRESENT=YES
MANIFEST_OR_DEPLOYMENT_RECOVERY_FILE_PRESENT=YES
CURRENT_WP_CONTENT_PRESENT=YES
CURRENT_MYSQL_PRESENT=YES
STOP_AT_REVIEWER=YES
```

Do not resume K9B-R3 deletion automatically.
