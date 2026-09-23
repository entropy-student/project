# G6 Backup / Restore Candidate

```text
STATUS=DESIGN_ONLY_PENDING_OWNER_WRITE_APPROVAL
GATE=G6_VPS_ONBOARDING_STORAGE
VPS_BACKUP_WRITES_EXECUTED=0
RESTORE_CANARIES_EXECUTED=0
```

No backup file, restore fixture, container, or scheduler was created. All steps below are proposals for a separately approved project-scoped G6 write set.

## Layout and capacity guard

```text
/srv/backups/conversion-leak-audit/scheduled/
/srv/backups/conversion-leak-audit/pre-change/
/srv/backups/conversion-leak-audit/restore-tests/
```

Candidate limits: `/srv/data` project allocation 8 GiB; backup allocation 8 GiB; shared filesystem reserve at least 20 GiB free. The preflight observed 87.14 GiB free on the shared root/`/srv` filesystem. Before and after every approved archive, calculate projected/actual free space. If the reserve could be breached, do not create the archive and block subsequent writes until Reviewer resolves capacity. No broad prune or unreviewed backup deletion.

## MariaDB

Method: MariaDB-native logical dump, not a live data-directory copy.

Candidate flow for an isolated synthetic canary:

1. Create a one-use canary credential in a mode-0600 project-scoped file only after approval; do not emit or document its value.
2. Create a temporary `mariadb:11.4` canary container and project-only network with no host ports and no shared network. Seed only a synthetic marker row.
3. Run `mariadb-dump --single-transaction` for the canary database, pipe through gzip, and write to `restore-tests/mariadb-g6-canary.sql.gz`.
4. Run `gzip -t`; restore the dump into a fresh empty canary database and query the marker row.
5. Record command/result, file size/checksum, canary container summary, and before/after disk free space. Do not record the one-use credential or database secret values.
6. Remove only the allowlisted disposable canary container/network/data and one-use credential file after evidence is captured. Keep at most the latest tiny, synthetic, non-secret restore proof artifact if Reviewer requests it.

No project/customer database exists on the target at preflight. The canary must not mount any other project's database path.

## WordPress durable files

Only `/srv/data/conversion-leak-audit/wordpress/uploads` is designated durable at this point. WordPress core, plugin/theme source, and caches are replaceable and excluded.

1. After approval, create a synthetic sentinel under a project-scoped `restore-canary` directory; do not use customer data.
2. Archive the sentinel/durable-file fixture with numeric ownership metadata and compression into `restore-tests/wordpress-g6-canary.tar.gz`.
3. Validate archive readability (`tar -tzf`), extract into a separate fresh canary directory, and compare SHA256 of the synthetic sentinel bytes.
4. Record metadata/results only. Remove the synthetic source and restored canary directories after proof; retain only a non-secret manifest/checksum if requested.

## Scanner SQLite

The existing Scanner uses SQLite and its default relative file name `scanner-v0.sqlite3`. The Compose candidate sets the Scanner working directory to `/var/lib/cla-scanner`, bind-mounted to `/srv/data/conversion-leak-audit/scanner`.

1. After approval, create a synthetic SQLite canary database/marker in the CLA scanner data namespace; never use another project's DB.
2. Use Python `sqlite3.Connection.backup()` (or stop/quiesce the disposable canary and take a verified snapshot) to create the backup. Do not assume a byte-copy of a live SQLite file is consistent.
3. Restore to a new empty canary path; require `PRAGMA integrity_check` = `ok` and the marker row to match.
4. Record byte sizes/checksums for synthetic fixtures only. Remove disposable DB files/containers after proof.

## Retention candidate

| Class | Candidate retention | Guard |
| --- | --- | --- |
| `scheduled/` | 7 daily backup sets | 8 GiB total backup cap and 20 GiB free-space floor; measure first real compressed set before enabling a schedule |
| `pre-change/` | 2 most recent verified sets | Do not delete a rollback point while a change is unresolved |
| `restore-tests/` | 1 latest non-secret proof artifact; remove disposable test data | Keep no production Secrets or customer data in this area |

If the cap/floor would be breached, stop the next backup/write and return for review; do not install cron/systemd or auto-delete unrelated data. Any future scheduler is a separate approved deployment step.

## Off-host recovery and rollback

- Backup archives and Secret recovery are separate classes. Ordinary database/WordPress/Scanner backups exclude Secret files.
- Candidate backup encryption: age recipient encryption before any off-host transfer. The private decryption identity remains under Owner custody and outside the VPS; no identity/key or transfer destination currently exists or is created.
- G7 rollback must pin the current/previous reviewed source/image reference, preserve a pre-change backup under `pre-change/`, revert only the project Compose/release state, restore project data only after explicit selection, and verify WordPress health, DB integrity, Scanner SQLite integrity, and scan/report identity. Rollback may not alter Shared Caddy, cloudflared, DNS, firewall, shared networks, or 80/443.
- This is a candidate procedure; no application deployment or rollback was executed in G6.
