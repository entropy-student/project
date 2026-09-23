# G6 VPS Read-only Preflight

```text
GATE=G6_VPS_ONBOARDING_STORAGE
BASE_MAIN=1c22d4ea4060918de7a849e185e0bbc107c01ca1
BRANCH=codex/g6-vps-onboarding-storage
IMPLEMENTATION_COMMIT=187dc5b20bbd3cf8bad0e77ea306f253430a1376
TARGET_VPS_PREFLIGHT=PASS
VPS_WRITES_EXECUTED=0
OWNER_WRITE_APPROVAL=REQUIRED_BEFORE_ANY_REMOTE_WRITE
```

## Connection and identity

- Connected using the existing authorized `ops` SSH identity; no credential was requested or disclosed.
- The local identity fingerprint and pinned ED25519 host-key fingerprint matched `SHARED_VPS_HANDOFF.md`; SSH used `BatchMode=yes`, `IdentitiesOnly=yes`, and `StrictHostKeyChecking=yes`.
- Remote `hostname` returned `srv1970241`, matching the registered shared VPS.
- Probe date: 2026-09-23. All remote commands below were read-only; no authentication material, environment values, application files, or project secrets were read.

## Host snapshot

| Field | Observed value |
| --- | --- |
| OS | Ubuntu 24.04.5 LTS (Noble Numbat) |
| Kernel | `6.8.0-139-generic` |
| Uptime | 1 week, 5 days, 18 hours, 31 minutes at probe |
| CPU | 2 vCPU; AMD EPYC 9354P 32-Core Processor model |
| Load average | `0.48 0.13 0.10` |
| Memory | 8,131,472 KiB total (7.75 GiB); 5,739,240 KiB available (5.47 GiB) |
| Swap | 2,097,148 KiB total (2.00 GiB); 768 KiB used |
| Root filesystem | `/dev/sda1`, ext4, 102,888,095,744 bytes total (95.80 GiB), 93,575,229,440 bytes available (87.14 GiB), 10% reported used |
| `/srv` filesystem | Same `/dev/sda1` as `/`; 95.80 GiB total, 87.14 GiB available |
| Docker Engine | 29.8.0 |
| Docker Compose | v5.5.1 |

## Shared workload snapshot

`docker ps` and `docker ps -a` both returned the following eight containers: 8 running, 0 stopped.

| Name | Image | Published ports | Status |
| --- | --- | --- | --- |
| `dujiao-next-app-1` | `be0cf7b6d632` | none (`8080/tcp`, container-only) | Up 5 days, healthy |
| `dujiao-next-postgres-1` | `postgres:16-alpine` | none (`5432/tcp`, container-only) | Up 8 days, healthy |
| `dujiao-next-redis-1` | `redis:7-alpine` | none (`6379/tcp`, container-only) | Up 8 days, healthy |
| `unified-pay-app-1` | `dujiao-unified-pay:alipay-r6-audit-final` | none (`8080/tcp`, container-only) | Up 8 days, healthy |
| `unified-pay-db-1` | `postgres:16-alpine` | none (`5432/tcp`, container-only) | Up 9 days, healthy |
| `xianyu-xianyu-app-1` | `xianyu-auto-reply-fix:production` | none (`6080/tcp`, `8090/tcp`, container-only) | Up 11 days, healthy |
| `spikersun-private-cloudflared-1` | `cloudflare/cloudflared:2026.8.3` | none | Up 12 days |
| `spikersun-edge-caddy-1` | `caddy:2-alpine` | `0.0.0.0:80`, `[::]:80`, `0.0.0.0:443`, `[::]:443`; UDP 443 | Up 12 days |

One `docker stats --no-stream` sample totaled approximately 1.44 GiB across these containers. The largest sample was Xianyu at 1.275 GiB. This is an instantaneous snapshot, not a peak or reservation measurement.

## TCP listeners and shared infrastructure

The complete `ss -H -lntp` snapshot contained:

- `0.0.0.0:22` and `[::]:22` — `sshd`;
- `0.0.0.0:80`, `[::]:80`, `0.0.0.0:443`, `[::]:443` — `docker-proxy` for `spikersun-edge-caddy-1` / Shared Caddy;
- `127.0.0.53:53` and `127.0.0.54:53` — `systemd-resolved`;
- `127.0.0.1:65529` — `monarx-agent`.

Ports `18085` and `18124` were not listening in this snapshot. No listener was stopped or changed.

Observed shared infrastructure: Caddy reverse proxy owns 80/443; `cloudflared` is running; Docker networks include `spikersun-edge` and `spikersun-private` as well as the project networks `dujiao-next-internal`, `unified-pay-internal`, and `xianyu_xianyu-network`. No Nginx or Traefik container was observed. Nothing was restarted, reconfigured, or connected to a project network.

## `/srv` directory metadata

Only first-level project directory names and metadata were enumerated; no other project's business files were opened.

| Parent | Parent owner/group/mode | Existing first-level directories (name, owner:group, mode) |
| --- | --- | --- |
| `/srv/apps` | `ops:ops`, `0750` | `dujiao-next` `root:root` `0755`; `unified-pay` `root:65532` `0750`; `xianyu.pre-x6-20260911-0729` `ops:ops` `0750`; `xianyu` `ops:ops` `0775` |
| `/srv/data` | `ops:ops`, `0750` | `dujiao-next` `root:root` `0755`; `unified-pay` `root:65532` `0750`; `xianyu` `ops:ops` `0750` |
| `/srv/backups` | `ops:ops`, `0750` | `dujiao-next` `root:70` `0750`; `shared-infra` `root:ops` `0750`; `unified-pay` `root:root` `0750`; `xianyu` `ops:ops` `0750` |

The following Conversion Leak Audit paths were all absent at preflight; no metadata was created:

```text
/srv/apps/conversion-leak-audit       ABSENT
/srv/data/conversion-leak-audit       ABSENT
/srv/backups/conversion-leak-audit    ABSENT
```

## Resource budget candidate

The limits below are a bounded allocation candidate, not a claim of measured CLA peak usage. The prior local G5 runtime footprint measured 274,991,324 bytes for the whole WordPress local runtime tree and 12,288 bytes for the Scanner SQLite file; it did not record process/container peak memory. Scanner configuration bounds jobs to one concurrent job and the browser fallback to at most two pages.

```text
STEADY_MEMORY_BUDGET=1 GiB reservation target (WP 256 MiB + DB 256 MiB + Scanner 512 MiB)
BURST_MEMORY_BUDGET=2 GiB hard aggregate cap (WP 512 MiB + DB 512 MiB + Scanner 1,024 MiB)
CPU_ASSUMPTION=2 host vCPU; CLA aggregate cap 1.50 vCPU, leaving 0.50 vCPU unallocated by CLA
SCANNER_CONCURRENCY=1 job
CHROMIUM_CONCURRENCY=1 browser worker; max 2 pages within the bounded scan
MIN_FREE_DISK_RESERVE=20 GiB
PROJECT_DATA_BUDGET=8 GiB
BACKUP_STORAGE_BUDGET=8 GiB
```

At this snapshot, 5.47 GiB was available. The proposed 2 GiB hard cap leaves about 3.47 GiB available, above a 3 GiB host-memory admission reserve. For disk, the two 8 GiB project caps would leave about 71.14 GiB free against the 20 GiB reserve. These limits do not take capacity from another project's cgroups; the current shared containers remain untouched. Before any approved write/canary, repeat the headroom check; if available memory is below 5 GiB or projected disk free space after the project caps would be below 20 GiB, do not proceed. G7 must measure real steady/high-water usage before service deployment; if the caps are exceeded, return to Reviewer rather than increasing them silently.

Container image/layer storage is outside the `/srv/data` and backup quotas and must be measured before G7 pulls/builds an image. This is a known unresolved G7 capacity check, not an authorization to pull images now.

## Future private-port candidate

```text
WORDPRESS_PRIVATE_PORT=127.0.0.1:18085 (unoccupied in this snapshot; recheck immediately before G7 bind)
SCANNER_PRIVATE_PORT=NONE (container-internal service port 8000 only; no host publication planned)
DATABASE_HOST_PORT=NONE
```

The WordPress G4 integration currently allowlists local Scanner hostnames rather than Compose service DNS. The Compose candidate uses `http://scanner:8000` on a project-only network; a bounded G7 integration/configuration change and regression must explicitly allow that private service endpoint before deployment. No Scanner host port is added to work around this. This G7 compatibility change is not made in G6.

## First-write plan — not executed

Every item below is conditional on explicit Owner approval and Reviewer clearance. This list is the proposed G6 write set, not a record of completed writes.

| ID | Path / resource | Action after approval | Purpose and risk | Reversible |
| --- | --- | --- | --- | --- |
| WRITE_01 | `/srv/apps/conversion-leak-audit` | Create root; set candidate `ops:ops 0750` | Project app/config namespace; confined to absent project path | YES |
| WRITE_02 | `/srv/data/conversion-leak-audit` | Create root and `db/`, `wordpress/uploads/`, `scanner/`, `secrets/`; apply per-service owners/modes from the storage manifest only after selected-image UID verification | Durable data and empty Secret landing zone; ownership mismatch can prevent startup or expose data | YES |
| WRITE_03 | `/srv/backups/conversion-leak-audit` | Create root and `scheduled/`, `pre-change/`, `restore-tests/`; candidate `root:ops 0750` | Project-only recovery namespace | YES |
| WRITE_04 | `/srv/apps/conversion-leak-audit/deploy/vps/compose.production.yml` | Copy the committed Compose design with owner/mode `ops:ops 0640`; no `up`, pull, build, or service start | Preserve the reviewed project manifest on host | YES |
| WRITE_05 | `/srv/data/conversion-leak-audit/secrets/g6-mariadb-canary.env` | Create a one-use random, non-production canary credential file, `root:root 0600`; never emit or preserve the value | Isolated MariaDB restore canary only | YES |
| WRITE_06 | `/srv/data/conversion-leak-audit/db/restore-canary/` and Docker project/network `cla-g6-restore-mariadb` | Create isolated synthetic DB seed, temporary container and project-local network with no host ports/shared networks; produce `/srv/backups/conversion-leak-audit/restore-tests/mariadb-g6-canary.sql.gz`; restore to an empty canary and verify a synthetic row | Verify logical dump/compress/restore without product data | YES |
| WRITE_07 | `/srv/data/conversion-leak-audit/wordpress/restore-canary/` | Create synthetic sentinel; archive to `/srv/backups/conversion-leak-audit/restore-tests/wordpress-g6-canary.tar.gz`; restore into a separate empty test path and compare checksum | Verify durable-file backup/restore | YES |
| WRITE_08 | `/srv/data/conversion-leak-audit/scanner/restore-canary.sqlite3` | Create a synthetic SQLite fixture, use SQLite backup API, store `/srv/backups/conversion-leak-audit/restore-tests/scanner-g6-canary.sqlite3`, restore and run `PRAGMA integrity_check` plus marker read-back | Verify format-safe Scanner-state backup/restore | YES |
| WRITE_09 | Exact G6 canary resources/files above | After evidence is recorded, remove only the disposable canary container/network, canary database/file trees, and one-use canary env file; retain only the latest non-secret restore-test proof artifact if Reviewer wants it | Leave no canary runtime or credential behind; exact allowlist only | YES |

No host-wide cron/systemd, firewall, reverse-proxy, tunnel, DNS, shared-network, Docker-daemon, 80/443, production-service, payment, or real LLM-provider action is included. There are no proposed production Secret values.

```text
RETURN=RETURN_G6_OWNER_APPROVAL_REQUIRED_BEFORE_VPS_WRITE
OWNER_ACTION=APPROVE_OR_REJECT_FIRST_VPS_WRITES
NEXT=STOP_AT_REVIEWER
```

## Repository/static verification

```text
COMPOSE_STATIC_VALIDATION=PASS (`docker compose ... config --quiet`, local Compose v5.4.0; disposable non-secret env stubs removed afterward; no service/container was started)
COMPOSE_SERVICE_SET=mariadb,scanner,wordpress
WORDPRESS_BIND=127.0.0.1:18085
MARIADB_HOST_PORT=NONE
SCANNER_HOST_PORT=NONE
DATABASE_NETWORK_INTERNAL=YES
DOCKER_SOCKET_MOUNTS=0
SCANNER_REGRESSION=55/55 PASS (`py -3.12 -m pytest -q`)
WORDPRESS_ASSET_REGRESSION=20/20 PASS (`py -3.12 -X utf8 acceptance/run_asset_checks.py`; TOTAL=20 PASS=20 FAIL=0)
```

The Scanner and WordPress asset regressions were run from this clean workspace. SEO, G4 browser, and G5 integration/browser service tests were not started in this read-only-preflight round: no local application stack was started, and this branch changes only documentation/deployment design, not application code or local runtime Compose. Latest `origin/main` records G4.6 SEO readiness `44/44 PASS` and G5 final PASS; Reviewer may request the historical browser suite to be rerun before releasing a later deployment Gate.
