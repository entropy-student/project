# Conversion Leak Audit — Project Storage Manifest

```text
STATUS=FROZEN_CANDIDATE_PENDING_OWNER_WRITE_APPROVAL
GATE=G6_VPS_ONBOARDING_STORAGE
BASE_MAIN=1c22d4ea4060918de7a849e185e0bbc107c01ca1
BRANCH=codex/g6-vps-onboarding-storage
IMPLEMENTATION_COMMIT=187dc5b20bbd3cf8bad0e77ea306f253430a1376
TARGET_HOST=srv1970241 (read-only identity verified)
REMOTE_PATHS_CREATED=NO
```

Canonical paths are frozen as a candidate only. All three paths were absent during the read-only preflight. This document does not assert that any remote directory exists.

## Path plan

| Purpose | Canonical path | Proposed owner/group | Proposed mode | Durable? |
| --- | --- | --- | --- | --- |
| Reconstructible application and Compose source | `/srv/apps/conversion-leak-audit` | `ops:ops` | directories `0750`, regular source/config files `0640` | No; rebuildable from reviewed Git revision |
| Database data | `/srv/data/conversion-leak-audit/db` | MariaDB image runtime identity (`mysql:mysql`; numeric UID/GID must be verified for the selected image before chown) | `0750` | Yes |
| WordPress uploads | `/srv/data/conversion-leak-audit/wordpress/uploads` | WordPress runtime identity (`www-data:www-data`; numeric UID/GID must be verified for selected image) | `0750` | Yes |
| Scanner SQLite state | `/srv/data/conversion-leak-audit/scanner` | `10001:10001` (Compose candidate sets Scanner process UID/GID to 10001) | `0750` | Yes |
| Secret landing zone | `/srv/data/conversion-leak-audit/secrets` | `root:root` | directory `0700`; future env files `0600` | Sensitive; no values created in G6 |
| Backups / restore material | `/srv/backups/conversion-leak-audit` | `root:ops` | directories `0750`; non-secret files `0640` | Yes until retention expiry |

The top-level `/srv/data/conversion-leak-audit` root is proposed as `ops:ops 0750`; runtime subdirectory ownership must be finalized from the exact approved image identities before the first chown. Existing parent `/srv/apps`, `/srv/data`, and `/srv/backups` were observed as `ops:ops 0750`.

## Durable data categories

- MariaDB: `/srv/data/conversion-leak-audit/db` mounted at `/var/lib/mysql`.
- WordPress user uploads: `/srv/data/conversion-leak-audit/wordpress/uploads` mounted at `/var/www/html/wp-content/uploads`.
- Scanner job/report SQLite file: `/srv/data/conversion-leak-audit/scanner`, mounted as the Scanner working directory so the current relative `scanner-v0.sqlite3` path remains persistent. The existing Scanner default is relative to process working directory; no product source/config change is made here.
- Secrets: `/srv/data/conversion-leak-audit/secrets`; metadata/landing-zone only in G6. No secret file or value exists or is planned for creation before Owner approval.
- Replaceable WordPress core, Scanner code, and Compose source live in `/srv/apps/conversion-leak-audit`; none is the only copy of durable user data.

## Compose and network isolation candidate

- Compose project name: `conversion-leak-audit`.
- Canonical file: `/srv/apps/conversion-leak-audit/deploy/vps/compose.production.yml`.
- Services: `wordpress`, `mariadb`, `scanner`.
- Durable bind mounts use only the canonical `/srv/data/conversion-leak-audit` tree.
- WordPress host bind is `127.0.0.1:18085:80` only; `18085` was free in the snapshot and must be rechecked immediately before any G7 bind.
- Scanner listens on container port 8000 and is not host-published; G7 must implement and regression-test the private `scanner` service DNS endpoint because current G4 code only accepts local host aliases.
- MariaDB has no host-published port.
- Two Compose project-local networks isolate DB (internal) and WordPress/Scanner traffic; no shared network is joined.
- No host network, Docker socket, privileged mode, public 80/443 bind, shared ingress, or payment route.
- Scanner image is not yet built/pinned; the Compose variable must be set to a reviewed immutable image before G7. G6 does not pull or build images.

## Capacity candidate

```text
STEADY_MEMORY_BUDGET=1 GiB reservation target (not an observed high-water measurement)
BURST_MEMORY_BUDGET=2 GiB combined hard limit
CPU_ASSUMPTION=1.50 vCPU aggregate cap on a 2-vCPU host
SCANNER_CONCURRENCY=1
CHROMIUM_CONCURRENCY=1
MIN_FREE_DISK_RESERVE=20 GiB
PROJECT_DATA_BUDGET=8 GiB
BACKUP_STORAGE_BUDGET=8 GiB
```

The live snapshot had 5.47 GiB `MemAvailable`; the proposed 2 GiB aggregate hard cap leaves about 3.47 GiB at that snapshot and is gated on at least 5 GiB available immediately before any approved canary. Local G5 ignored runtime measured 274,991,324 bytes for the complete WordPress runtime tree and the Scanner SQLite file measured 12,288 bytes. These sizes are reference evidence, not production growth forecasts. The 8+8 GiB data/backup caps plus a 20 GiB reserve leave 71.14 GiB against 87.14 GiB currently available. Root and `/srv` share the same filesystem. Docker image/layer use is excluded and must be measured before G7.

No memory high-water data exists for a production-shaped WordPress/MariaDB/Chromium service stack. Therefore the memory figures remain candidate limits; G7 must collect actual steady and one-browser burst measurements without exceeding these caps. If real requirements do not fit, stop and return to Reviewer; do not borrow capacity from other projects.

## Backups and recovery

- MariaDB: logical `mariadb-dump --single-transaction` stream, compressed and integrity-checked; never copy live InnoDB files as the default backup.
- WordPress: archive only project-owned durable uploads (and any later explicitly approved durable files), excluding replaceable core/code/caches.
- Scanner: Python SQLite `Connection.backup()` or an equivalent SQLite-safe quiesced snapshot, followed by `PRAGMA integrity_check`; no arbitrary live-file copy.
- Backup roots: `scheduled/`, `pre-change/`, and `restore-tests/` under `/srv/backups/conversion-leak-audit/`.
- Candidate retention: up to 7 daily scheduled sets, 2 pre-change sets, and 1 latest non-secret restore-test artifact, all within the 8 GiB backup cap and 20 GiB minimum-free reserve. Exact cap/retention must be checked against first measured compressed backup sizes before scheduling.
- Backup files exclude Secrets. Candidate off-host recovery uses authenticated encryption (age recipient-based); the decryption identity remains Owner-controlled outside this VPS. No key, ciphertext, off-host destination, or scheduler is created in G6.
- Before producing a backup, require sufficient projected free disk to remain above 20 GiB. If a backup would breach the floor, skip it and stop new writes; do not broad-prune or remove recovery points ad hoc.

## Approval and creation state

```text
APPS_PATH=ABSENT
DATA_PATH=ABSENT
BACKUPS_PATH=ABSENT
STORAGE_MANIFEST=FROZEN_CANDIDATE_PENDING_OWNER_WRITE_APPROVAL
VPS_WRITES_EXECUTED=0
```

No `mkdir`, `chown`, `chmod`, copy, Docker resource, backup, restore, or Secret-file operation has been executed remotely. See `G6_VPS_PREFLIGHT.md` for the exact proposed first-write allowlist.
