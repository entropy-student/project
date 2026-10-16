# Execution Evidence

## G0 — Read-only discovery — 2026-10-16 (Asia/Singapore)

### AUTHORIZED_GATE
`GATE_ID=KARAKEEP-WIN-G0-READONLY-DISCOVERY-20261016`
`SCOPE=Read-only host preflight and durable evidence only; no deployment or changes to other projects.`

### PREFLIGHT_FACTS
- `TARGET_IDENTITY`: `OWNER_REPORTED` Owner designated this Windows 11 local machine. `DIRECT_READBACK` Current shell is native Windows 11, PowerShell 7.6.5, not elevated; a Windows Explorer process is present in the same session and this is not a service session. Console-versus-RDP classification and unique device identity were not collected.
- `DOCKER`: `DIRECT_READBACK` Docker CLI 29.7.2; Compose v5.4.0; context `desktop-linux`; Docker Desktop Linux Engine 29.7.2 reachable, 12 CPUs, engine memory 7.40 GiB, overlayfs. 17 containers total / 3 running; 9 images.
- `RUNNING_CONTAINERS`: names were de-identified. `container-1`: `wordpress:cli-php8.3`, no published ports. `container-2`: `wordpress:7.1.1-php8.3-apache`, published host port 8189 to container port 80 (bind address redacted). `container-3`: `mariadb:11.4.7`, exposed 3306/tcp without a host mapping. No container was changed.
- `HOST_RESOURCES`: `DIRECT_READBACK` 2.20 GiB available of 15.28 GiB physical memory at sampling time. System drive C: has 191.61 GiB free of 475.53 GiB.
- `DOCKER_DISK_USAGE`: `DIRECT_READBACK` images 2.612 GB (9 total / 7 active); containers 5.923 MB (17 / 3); local volumes 509.5 MB (10 / 10); build cache 0. Docker Engine free capacity was not exposed by this aggregate query and remains `UNKNOWN`.
- `PORT_3000`: `DIRECT_READBACK` no Windows TCP listener and no running Docker container publishing host port 3000.
- `PROJECT_DIRECTORY`: `UNKNOWN`. No on-host Compose/project/data directory was specified, so existence and emptiness were not checked. The remote evidence folder and the current workspace were not assumed to be the runtime/data path.
- `NETWORK`: proxy environment variables are configured; their values were not read or recorded. Read-only HTTPS HEAD: Karakeep installation docs HTTP 200 / TLS verified; official Compose source HTTP 200 / TLS verified; GHCR `/v2/` HTTP 405 / TLS verified. GHCR's response confirms TLS reachability only; authentication and image-pull availability were not tested.
- `OFFICIAL_SOURCE`: `DIRECT_READBACK` Karakeep Docker docs show version v0.33.0 and require Docker + Compose; they say the Compose and environment files belong in a new directory. Official Compose file `karakeep-app/karakeep@main:docker/docker-compose.yml`, blob `865bb147cef972926d5dc32e50645876fd110555`; it defines web/chrome/meilisearch, default mapping `3000:3000`, and named volumes `data` / `meilisearch`. No image or installer was downloaded.

### ACTUAL_CHANGES
- Created this first Evidence entry on `entropy-student/project` default branch `main`, as explicitly requested.
- `LOCAL_MUTATIONS=0`: no local files, settings, services, containers, images, volumes, or other project resources were changed. Only read-only PowerShell, Docker metadata/list/usage queries, and HTTP HEAD probes were run.

### OBJECTIVE_READBACK
- Native Windows PowerShell and Docker Desktop Engine were directly observed; TCP/host-published port 3000 is clear; host memory and system disk are recorded; active workloads are summarized with names de-identified.
- The intended runtime/data directory and its empty/existing state remain unverified because no target path is specified.

### VALIDATION
- GitHub `main` Handoff and Gate read; the prior Evidence path returned 404 (no earlier Evidence entry existed).
- Official Compose source and official Docker installation documentation were read through the authorized read-only connectors.
- Windows TCP and Docker published-port checks both report zero port-3000 conflicts.
- Jina Reader request timed out; the official documentation page was successfully read through the web reader fallback. No response body or command output containing secrets was saved.

### ANOMALIES
- `RETURN_STORAGE_LAYOUT_UNRESOLVED`: runtime/project/data path is unspecified, so path existence/emptiness and storage ownership cannot be established.
- Host free memory was 2.20 GiB at the snapshot; no capacity threshold is defined in this Gate, so Reviewer should assess whether this leaves adequate headroom.
- Docker Engine free disk capacity, proxy endpoint/behavior, GHCR authentication, and whether the execution session is console or RDP remain `UNKNOWN`.

### EVIDENCE_ARTIFACTS_AND_PURPOSE
- This file: sanitized direct-readback facts for the G0 Reviewer decision.
- Official docs: https://docs.karakeep.app/installation/docker/ — requirements, directory expectation, and current docs version.
- Official Compose source: https://github.com/karakeep-app/karakeep/blob/main/docker/docker-compose.yml — service, port, volume, and image-source reference.
- No raw Docker logs, credentials, secrets, usernames, filesystem paths, machine identifiers, or unrelated container names were recorded.

### ROLLBACK_EFFECT
No local runtime state changed; no host rollback is needed. This Evidence record is the only repository change and is append-only under project policy.

### RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT
No service/data delta. Existing Docker workload count remains as observed: 3 running containers, 10 active local volumes. Host available memory was 2.20 GiB; system disk free space was 191.61 GiB.

### EXECUTOR_RESULT
`RETURN_STORAGE_LAYOUT_UNRESOLVED` — stop at G0 and ask Reviewer to reconcile the missing target path and assess memory headroom before defining any G1. No deployment was attempted.


## G1 — Deployment preflight RETURN — 2026-10-16 (Asia/Singapore)

### AUTHORIZED_GATE
`GATE_ID=KARAKEEP-WIN-G1-LOCAL-DOCKER-DEPLOY-20261016`
`OWNER_AUTHORIZATION=OWNER_REPORTED` Owner explicitly authorized two fresh Karakeep-only secrets for this first install, with no overwrite, display, or GitHub upload. Authorization was verified; secret generation was not reached because preflight did not pass.

### PREFLIGHT_FACTS
- `TARGET`: `DIRECT_READBACK` native Windows 11, PowerShell 7.6.5, interactive shell in the same session as Windows Explorer, not elevated. Console-versus-RDP was not distinguished. The machine identity was not output.
- `DOCKER`: `DIRECT_READBACK` Docker CLI/Engine 29.7.2, Compose v5.4.0, context `desktop-linux`, Docker Desktop Linux Engine reachable, 12 CPUs, engine memory 7.40 GiB.
- `HOST_RESOURCES`: `DIRECT_READBACK` host available RAM 2.11 GiB of 15.28 GiB (above the 2.0 GiB Gate floor by 0.11 GiB); system drive C: free 191.59 GiB.
- `ENGINE_DISK`: `UNKNOWN`. Docker Engine `DockerRootDir` was not accessible to the standard `docker-desktop` WSL distro probe; the listed overlay mounts could not be positively mapped to Engine root capacity. The required 8 GiB minimum is therefore unverified. Docker system-usage readback: images 2.612 GB (9 total / 7 active), containers 6.431 MB (20 / 3), local volumes 509.5 MB (12 / 12), build cache 0.
- `PORT_3000`: `DIRECT_READBACK` no Windows TCP listener and no Docker container publishing host port 3000.
- `OTHER_WORKLOADS`: `DIRECT_READBACK` three running workloads, all still running; image/port shape matched G0 (WordPress CLI, WordPress web on host port 8189, MariaDB without host publishing). Names were read internally but not recorded. No workload was changed.
- `EXISTING_OBJECT_DRIFT`: Docker now reports 20 total containers and 12 local volumes, compared with G0's 17 and 10; the source is unknown. The 9-image count is unchanged. No cleanup or investigation of unrelated objects was performed.
- `PROJECT_PATH`: `DIRECT_READBACK` the Gate target `%LOCALAPPDATA%\KarakeepLocal` does not exist; its parent is not a reparse point. Parent ACL owner matches the current user and the ACL is readable, but one Allow ACE grants Full Control (including child deletion and permission changes) to a principal outside the current user, SYSTEM, Administrators, and Creator Owner classes. Its identity was not confirmed as trusted. Target directory ACL therefore cannot be safely established under this parent; the target was not created.
- `PROJECT_OBJECTS`: `DIRECT_READBACK` no existing `karakeep-local` Compose project and neither expected named volume (`karakeep-local_data`, `karakeep-local_meilisearch)) exists.
- `OFFICIAL_SOURCE`: `DIRECT_READBACK` official Compose main blob still matches accepted G0 identity `865bb147cef972926d5dc32e50645876fd110555`. No local Compose file was downloaded.

### ACTUAL_CHANGES
- `LOCAL_MUTATIONS=0`: no directory, Compose file, `.env`, secret, image, container, volume, daemon/WSL setting, or other project resource was created or changed. No pull/up/down command was run.
- Appended this preflight return record to `entropy-student/project` `main` as required Evidence. No secret value was included.

### OBJECTIVE_READBACK
- The G1 host, Docker, RAM, C: space, port, project path, project name/volume collisions, and existing running workload checks were performed.
- Deployment did not start: the project path's parent ACL includes an unclassified full-control principal, and Docker Engine free capacity of at least 8 GiB could not be proven.

### VALIDATION
- Current Handoff and G0 Evidence were read from GitHub `main`; the Handoff Gate/blob remained unchanged before this Evidence append.
- Current official Compose file was read from the GitHub plugin and its blob matched the pinned G0 file identity.
- Host port and Docker publish checks both found no port-3000 conflict; exact project volumes and Compose project were absent.
- No Secret generation, Compose config rendering, image pull, service start, account creation, or real data entry occurred.

### ANOMALIES
- `RETURN_SECRET_ACCESS_MISMATCH`: the non-owner Full Control ACE on the parent directory prevents proving that a new secret directory beneath it is protected from other principals.
- `RETURN_PREFLIGHT_DRIFT`: the Gate's minimum Docker Engine free-space requirement remains unverified; do not substitute host C: free space.
- Docker object totals increased since G0 (three additional containers and two additional volumes); ownership/source is unknown and they were left untouched.
- Host RAM passed the minimum narrowly at 2.11 GiB; no deployment occurred, so the post-start 0.8 GiB stop condition was not exercised.

### EVIDENCE_ARTIFACTS_AND_PURPOSE
- This entry: sanitized G1 preflight facts and exact stop reasons.
- Official Compose source: https://github.com/karakeep-app/karakeep/blob/main/docker/docker-compose.yml — pinned source identity.
- Prior G0 measurements: earlier section in this file.
- No Secret, username, expanded private path, machine identifier, raw logs, or unrelated container name was recorded.

### ROLLBACK_EFFECT
No local change occurred, so no host rollback or project stop command was needed. Existing Docker workloads and data were left untouched.

### RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT
No Karakeep service or data delta; no account or bookmark was created. Host free RAM was 2.11 GiB and C: free space was 191.59 GiB. Docker counts changed relative to G0 before this run; no change to those objects was made by this Executor.

### EXECUTOR_RESULT
`RETURN_SECRET_ACCESS_MISMATCH` + `RETURN_PREFLIGHT_DRIFT` — stop before creating the project directory or either secret. Reviewer should resolve a safely protectable target path/ACL and establish a trusted Docker Engine free-space readout before authorizing another G1 attempt.


## G1R — Windows local first-install attempt RETURN — 2026-10-16 (Asia/Singapore)

### AUTHORIZED_GATE
`GATE_ID=KARAKEEP-WIN-G1R-ACL-DISK-DEPLOY-20261016`
`OWNER_AUTHORIZATION=OWNER_REPORTED` Owner explicitly authorized one protected new Karakeep directory, two fresh random secrets, a bounded no-network diagnostic container, and official Compose deployment only after all preflight checks pass. Secret values must not be output or uploaded.

### PREFLIGHT_FACTS
- `TARGET_IDENTITY`: `DIRECT_READBACK` Owner Windows 11 native PowerShell 7.6.5 session; Docker context `desktop-linux`; Docker Desktop Linux Engine 29.7.2; Compose v5.4.0; engine reports 12 CPUs and 7.40 GiB memory.
- `HOST_RAM`: `DIRECT_READBACK` 3.35 GiB free at the final pre-deployment preflight; after the failed image-pull attempt, a fresh read showed 1.74 GiB free, below the 2.0 GiB startup floor. No Karakeep service was started.
- `TARGET_DIRECTORY`: `DIRECT_READBACK` selected the previously absent USERPROFILE candidate. Its existing parent chain has trusted owners, no reparse components, and no external effective Full Control, child deletion, ACL-change, or ownership-change grants; the current user can create the leaf. APPDATA fallback was rejected because its chain had an external high-rights grant. Existing parent ACLs were not changed.
- `LEAF_ACL`: `DIRECT_READBACK` new directory, Compose file, and `.env` have protected DACLs with only the current user, SYSTEM, and Administrators allowed Full Control. Owner readback is the current user. The private absolute path and SIDs are omitted.
- `ENGINE_STORAGE`: `DIRECT_READBACK` Docker reports root `/var/lib/docker` and storage driver `overlayfs`. WSL Docker Desktop data mount reported 1,055,762,868 KiB total and 997,071,484 KiB available (950.88 GiB). A single local-image diagnostic container's overlay root reported the same total and 997,071,376 KiB available; it was within 108 KiB of the WSL readback. The default Docker Desktop WSL data-disk file exists on the host system volume, which had 191.36 GiB free.
- `VOLUME_MAPPING`: `DIRECT_READBACK` all 12 existing volumes use the `local` driver; a metadata-only sample mountpoint is under DockerRootDir's `volumes` directory. No volume contents were read. The diagnostic container's requested application-volume path did not appear as a separate `df` row, so that row was not claimed as a direct volume measurement. Volume capacity is mapped through the local driver mountpoint under the same Docker data root and Docker Desktop data disk. Docker references: [WSL 2 backend](https://docs.docker.com/desktop/features/wsl/), [Docker Desktop backup locations](https://docs.docker.com/desktop/settings-and-maintenance/backup-and-restore/), [Docker local volumes](https://docs.docker.com/engine/storage/volumes/), [Docker data root](https://docs.docker.com/engine/daemon/).
- `DIAGNOSTIC_CONTAINER`: `DIRECT_READBACK` one existing local WordPress CLI image was run with `--rm --pull=never --network=none --read-only --memory=128m --cpus=0.25 --pids-limit=16`; no secret or host/business-data mount was supplied. After exit, the exact probe name was absent and container, volume-name, and network snapshots matched. The three pre-existing running workloads remained running and matched their pre-probe shape.
- `PORT_AND_COLLISIONS`: `DIRECT_READBACK` Windows TCP and Docker published-port checks found no port 3000 listener. No `karakeep-local` Compose project or either expected project volume existed. Existing Docker inventory before/after the probe remained 20 containers (3 running), 12 volumes; no unrelated object was changed.
- `OFFICIAL_SOURCE`: `DIRECT_READBACK` official `karakeep-app/karakeep` main Compose blob `865bb147cef972926d5dc32e50645876fd110555`, unchanged from accepted G0. Official Docker install instructions identify the four environment entries used here (`KARAKEEP_VERSION`, `NEXTAUTH_SECRET`, `MEILI_MASTER_KEY`, `NEXTAUTH_URL`): https://github.com/karakeep-app/karakeep/blob/main/docs/docs/02-installation/01-docker.md.

### ACTUAL_CHANGES
- Created only the selected new project directory, `docker-compose.yml`, and `.env`; the local Compose source is the pinned official file with only the web port changed to `127.0.0.1:3000:3000`. Local Compose SHA-256: `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`.
- Generated exactly two distinct 32-byte CSPRNG values encoded as 64-character hex and stored them only in the protected `.env`. No value, digest, or secret-bearing command output was recorded. The file has the official version, local URL, and two secret keys; no AI API key was added.
- `docker compose config --quiet` returned 0. Read-only normalized config confirmed exactly web/chrome/meilisearch, the resolved project volumes `karakeep-local_data` and `karakeep-local_meilisearch`, loopback-only web binding, and no host ports for Chrome/Meilisearch.
- `docker compose pull` was attempted for those three configured images and exited 1. The sanitized output classifier identified a network/TLS class. The raw error was not retained or displayed. A read-only reconciliation found none of the three target image tags present; Docker aggregate usage remained 9 images / 2.612 GB, 20 containers, and 12 volumes.
- No Compose service was started, no project volume was created, and no account or bookmark was created. No other Docker project, existing directory ACL, Docker/WSL setting, or system configuration was changed.

### OBJECTIVE_READBACK
- Protected project files and the two distinct secret entries read back successfully without displaying their values; all three ACLs remained protected.
- Docker Compose configuration parsed successfully and matched the reviewed service/port/volume scope.
- Deployment stopped before `compose up`: image pull exited with the classified network/TLS failure, and current available host RAM was 1.74 GiB, below the startup floor.

### VALIDATION
- Fresh latest-main Handoff readback still identified G1R before Evidence write; prior Evidence was fetched with blob SHA `5761255fab46af8fcfeeb2ae8f69565821be1940`. This record is appended without rewriting prior G0/G1 history.
- Official Compose file identity and official Docker installation guide were read through the GitHub connector. Docker storage semantics were checked against the linked official Docker documents above.
- Final local reconciliation: both protected ACLs, four expected environment entries, distinct 64-hex secret formats, Compose quiet-config exit 0, zero target image tags, no Compose project/project volumes, no probe residue, three existing workloads unchanged, and no port 3000 listener.
- No raw pull output, Secret value, Windows absolute path, SID, or unrelated container name was saved.

### ANOMALIES
- `RETURN_DEPLOY_IMAGE_PULL_NETWORK_TLS`: the pull exited non-zero and the sanitized classifier matched network/TLS; the exact low-level stderr was intentionally not retained, and no retry was attempted.
- `RETURN_PREFLIGHT_DRIFT`: the latest post-failure host RAM reading was 1.74 GiB, below the 2.0 GiB start threshold; this Executor did not start services.
- Several early local validators were corrected before final readback: one treated the Windows `FullControl` composite enum as a bitmask; one compared Compose's logical volume keys to their resolved project names; the first secret-format regex did not handle CRLF and a later check used the wrong key delimiter length. Corrected read-only checks passed. No existing file was overwritten and no additional secret pair was generated.
- The diagnostic container's `df` output did not show its requested application-volume path as expected; volume mapping was instead established from DockerRootDir, local-driver mountpoint metadata, the matched overlay/data-disk capacity, and the official Docker storage description. Reviewer should assess this storage-domain proof together with the Gate.

### EVIDENCE_ARTIFACTS_AND_PURPOSE
- This appended G1R entry: sanitized host, storage, ACL, configuration, pull, and stop-state readbacks.
- Official Compose: https://github.com/karakeep-app/karakeep/blob/main/docker/docker-compose.yml — source blob `865bb147cef972926d5dc32e50645876fd110555`.
- Official install configuration: https://github.com/karakeep-app/karakeep/blob/main/docs/docs/02-installation/01-docker.md.
- Docker storage references are linked under `PREFLIGHT_FACTS`. No secret-bearing logs or private host paths are attached.

### ROLLBACK_EFFECT
- No service or named volume was created, so no `docker compose down` was needed. No `down -v`, prune, or image cleanup ran. The protected directory, official Compose file, and generated `.env` are retained for Reviewer-directed recovery; there is no Karakeep business data. The temporary diagnostic container left no container, volume, or network residue. Backup/restore of future real data remains `UNVERIFIED`.

### RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT
- No Karakeep runtime or business-data delta. Existing 3 running services, 20 total containers, and 12 volumes remained unchanged. Host free RAM was 3.35 GiB at final preflight and 1.74 GiB after the failed pull. No account, bookmark, AI key, or public port was created.

### EXECUTOR_RESULT
`RETURN_DEPLOY_IMAGE_PULL_NETWORK_TLS + RETURN_PREFLIGHT_DRIFT` — stop before service startup. Reviewer should inspect the pull-failure classification, current RAM headroom, and the overlay/local-volume storage mapping, then define any next Gate. Do not treat this as PASS and do not advance stages.


## G1N — Windows Docker pull diagnosis blocked by preflight drift — 2026-10-16 (Asia/Singapore)

### AUTHORIZED_GATE
`GATE_ID=KARAKEEP-WIN-G1N-PULL-DIAG-CONDITIONAL-DEPLOY-20261016`
`OWNER_AUTHORIZATION=OWNER_REPORTED` Owner authorized one constrained pull of official Karakeep images and startup only when Gate preconditions pass. Owner explicitly canceled fixed 2 GiB / 0.8 GiB RAM thresholds; low free-RAM readings alone are not a blocker. Reuse existing Compose and Secrets; no proxy, certificate, daemon, WSL, or unrelated-project changes.

### PREFLIGHT_FACTS
- `TARGET_IDENTITY`: `DIRECT_READBACK` Windows PowerShell host; Docker context `desktop-linux`; Engine 29.7.2; Compose 5.4.0.
- `PROJECT_CONFIG`: `DIRECT_READBACK` Compose SHA-256 matches accepted G1R value `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`; `docker compose config --quiet` returned 0 and normalized config parsed. Exactly web/chrome/meilisearch services, official image refs `ghcr.io/karakeep-app/karakeep:release`, `ghcr.io/karakeep-app/karakeep-chrome:release`, `getmeili/meilisearch:v1.41.0`; only web publishes `127.0.0.1:3000`; named volumes resolve to `karakeep-local_data` and `karakeep-local_meilisearch`.
- `CONFIG_ACL_AND_ENV`: `DIRECT_READBACK` project directory, Compose, and env file owners match current user; ACLs are protected and contain no ACE for an untrusted principal. Expected four environment keys exist; both existing Secret values match the expected 64-hex shape and are distinct. No Secret values or hashes were read into Evidence.
- `HOST_RESOURCES`: `DIRECT_READBACK` available host memory was 2,064 MiB during preflight; C: had 188.5 GiB free. RAM is recorded for comparison only, not evaluated against a fixed threshold. Docker root and overlayfs driver match the accepted G1R backend; prior trusted Engine data-disk proof remains applicable and host backing capacity shows no material drift.
- `EXISTING_DOCKER_STATE`: `DIRECT_READBACK` Docker reports 20 total containers, all 20 in `exited` state and none running. The accepted Handoff state was 20 total with three existing workloads running. This material runtime drift has unknown cause and was not changed by this read-only execution. No pull or start was attempted.
- `TARGET_COLLISIONS_AND_PORT`: `DIRECT_READBACK` no Karakeep project containers, expected project volumes, or target image tags were present; Windows port 3000 listener and Docker-published port 3000 were absent.
- `NETWORK_DIAGNOSTICS`: `DIRECT_READBACK` host proxy modes were inspected without retaining addresses or values. Windows Internet proxy is enabled, WinHTTP reports direct mode, HTTP proxy environment variable is present; Docker Engine reports HTTP/HTTPS/NO_PROXY configuration present. For `ghcr.io`, DNS, TCP/443, and certificate-validated TLS succeeded; unauthenticated `/v2/` returned expected HTTP 401. For `registry-1.docker.io`, DNS succeeded, while the host TCP/443 probe and host `/v2/` request timed out. These are host-path observations; Docker Desktop's image-pull path was not tested this round.

### ACTUAL_CHANGES
- `LOCAL_MUTATIONS=0`: only read-only host, ACL, Docker metadata, DNS/TCP/TLS, and registry endpoint checks were run. No proxy or certificate settings were changed; no pull/up/down command ran; no image, container, network, volume, or project file was created, replaced, or removed.
- The G1N pull diagnostic was withheld because all previously running Docker workloads are now exited, failing the Gate's existing-service stability precondition. This return does not attribute the state change to Karakeep or to this Executor.

### OBJECTIVE_READBACK
- Reused protected Compose and existing Secrets remain intact and match accepted fingerprints/format.
- Host-to-GHCR path is reachable and the registry's unauthenticated 401 response is expected. Host access to Docker Hub timed out. Actual Docker Desktop image-pull diagnosis remains unperformed, so the original pull failure is not yet narrowed at the daemon layer.
- Deployment remains `NOT_DEPLOYED`; no Karakeep service or volume exists. No Owner registration or real data was created.

### VALIDATION
- Latest Handoff and latest G1R Evidence were read from GitHub `main` before execution. The current G1N Gate explicitly removes fixed free-RAM thresholds and requires actual stability checks.
- Corrected SID-based ACL readback confirmed current-user ownership, protected DACLs, and zero untrusted ACEs on the project directory and both files. An initial helper could not translate the owner string; the corrected read was read-only and passed.
- Docker state counts were independently re-read with `docker ps -a`: 20 exited, zero running. No container identity was written to Evidence.
- No raw Docker error/log, proxy address, private host path, SID, Secret value, or Secret digest was saved.

### ANOMALIES
- `RETURN_PREFLIGHT_DRIFT_EXISTING_CONTAINERS_STOPPED`: Docker's current inventory has zero running containers, compared with three existing workloads running in the accepted state. The cause and timing are unknown. The Gate requires stopping before pull/start when existing services are not stable.
- `RETURN_REGISTRY_HOST_TIMEOUT`: host TCP/443 and `/v2/` request to `registry-1.docker.io` timed out. Docker Desktop's pull path remains untested; no proxy/certificate/system configuration change is authorized.
- No fixed RAM threshold was applied. The observed 2,064 MiB did not independently block the Gate.

### EVIDENCE_ARTIFACTS_AND_PURPOSE
- This G1N entry records sanitized preflight, host registry diagnostics, and the precise stop condition.
- The frozen official Compose identity remains source blob `865bb147cef972926d5dc32e50645876fd110555`; local Compose fingerprint and configured public image refs are recorded above.
- No sensitive local artifact or raw diagnostic output was uploaded.

### ROLLBACK_EFFECT
No rollback was needed because no Docker write was performed. Existing Compose and protected Secrets remain for Reviewer-directed continuation. Existing Docker containers were observed exited; none was started, stopped, or modified by this execution. No Karakeep business data exists; recovery remains `UNVERIFIED`.

### RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT
No Karakeep runtime or business-data delta. No Docker images or objects were added. Host free memory was 2,064 MiB and C: free space was 188.5 GiB at preflight. Docker inventory remained read-only; all 20 containers were exited at verification.

### EXECUTOR_RESULT
`RETURN_PREFLIGHT_DRIFT_EXISTING_CONTAINERS_STOPPED + RETURN_REGISTRY_HOST_TIMEOUT` — stop before image pull or service startup. Reviewer should reconcile the unexpected stopped workloads and define whether/when the bounded Docker Desktop image-pull diagnosis may proceed. Do not treat this as a PASS candidate or advance the stage.


## G1C — Windows Docker Engine/container reconciliation and conditional pull RETURN — 2026-10-16 (Asia/Singapore)

### AUTHORIZED_GATE
`GATE_ID=KARAKEEP-WIN-G1C-EXISTING-STATE-AND-PULL-20261016`
`OWNER_AUTHORIZATION=OWNER_REPORTED` Owner authorized a bounded pull of the three official Karakeep images and project-only startup when Gate conditions pass. Reuse the existing protected Compose and Secrets; no fixed free-RAM threshold; do not restore other containers or change proxy, certificates, daemon, WSL, or global settings.

### PREFLIGHT_FACTS
- `TARGET_IDENTITY`: `DIRECT_READBACK` Windows PowerShell host; Docker context `desktop-linux`; Engine 29.7.2; Compose 5.4.0.
- `ENGINE_STATUS`: `DIRECT_READBACK` `docker info`, `docker version`, and `docker system df` all exited 0 before and after pulls. Docker root remains `/var/lib/docker`, driver `overlayfs`; Docker Desktop backend process was present. The Windows host last boot and Desktop backend start both predate the three recorded container exits; available timestamps do not explain their stop.
- `STOPPED_CONTAINER_CAUSE`: `DIRECT_READBACK` only the three previously running non-target containers were inspected. WordPress CLI: exited, code 137, `OOMKilled=false`, restart count 0, restart policy `no`, State.Error empty. WordPress Web: exited, code 0, `OOMKilled=false`, restart count 0, restart policy `no`, State.Error empty. MariaDB: exited, code 137, `OOMKilled=false`, restart count 0, restart policy `no`, State.Error empty; last retained health status `unhealthy`. No container contents, database data, or raw logs were read. Bounded container-specific Docker event queries returned no records. Stop cause is `UNKNOWN`; no OOM, repeated restart, or Docker Engine failure was observed. The three services were not restored.
- `NON_TARGET_BASELINE`: `DIRECT_READBACK` at Gate entry Docker had 20 containers: one `created`, 19 `exited`, zero running. The three named in the previous accepted baseline were the only matching WordPress CLI, WordPress Web, and MariaDB containers. Container ID/state snapshot, 12-volume names, and 11-network identities were held locally and matched after image pulls. The additional created object was not inspected or changed. No private container name or ID is recorded.
- `PROJECT_CONFIG`: `DIRECT_READBACK` existing Compose SHA-256 matches accepted value `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`; Compose `config --quiet` passed with the exact project file. Services and image refs match the frozen official Compose; only web publishes `127.0.0.1:3000`. Existing four env keys and two distinct 64-hex Secret formats match; directory and both files remain current-user-owned, DACL-protected, with zero untrusted ACEs. No Secret value or hash was emitted.
- `STORAGE_AND_RESOURCES`: `DIRECT_READBACK` current C: free space was 188.3 GiB before pulling and 185 GiB afterward. Docker root/driver and accepted G1R data-disk mapping remain unchanged; `docker system df` succeeded. Host RAM was 2,167 MiB before pull and 1,036 MiB after. These RAM readings are observation only; no fixed threshold was applied. No OOM or visible host instability was observed.
- `NETWORK_DIAGNOSTICS`: `DIRECT_READBACK` host proxy modes and Docker Engine proxy-presence flags were checked without retaining values. Host GHCR DNS/TCP/TLS succeeded and unauthenticated `/v2/` returned expected HTTP 401. Host DNS for `registry-1.docker.io` succeeded, but its TCP/443 and host `/v2/` request timed out. The Engine's official-image pull was tested separately below; no host or Engine proxy change was made.
- `TARGET_COLLISIONS`: `DIRECT_READBACK` no Karakeep project container, either project volume, or target image tag existed before pull. Port 3000 had no listener or published mapping.

### ACTUAL_CHANGES
- Pulled each frozen official target image once. The two GHCR pulls succeeded:
  - `ghcr.io/karakeep-app/karakeep:release` — RepoDigest `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`.
  - `ghcr.io/karakeep-app/karakeep-chrome:release` — RepoDigest `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`.
- The single pull of `getmeili/meilisearch:v1.41.0` exited 1. The in-process allowlist classifier returned `UNKNOWN`; raw Docker output was not retained or displayed. No retry or alternate image source was used.
- No Compose `up` was run because the required third image did not pull successfully. No project container, network, or volume was created. No config, Secret, non-target Docker object, or global setting was changed.

### OBJECTIVE_READBACK
- Post-pull `docker image inspect` confirmed the two GHCR RepoDigests above; the Meilisearch tag remains absent.
- All 20 pre-existing container ID/state pairs, 12 volumes, and 11 networks matched the Gate-entry snapshot. No Karakeep container or project volume exists; port 3000 remains free.
- Deployment remains `NOT_DEPLOYED`; no account, AI key, or real collection data was created.

### VALIDATION
- Latest `REVIEWER_HANDOFF.md` and latest G1N Evidence were read from GitHub `main` before local work. Current Gate permits an `EXISTING_EXITED_BASELINE` after the limited inspect when Engine is available and no actual high-risk system/OOM/restart/data fault is found; other containers were not restarted.
- Local configuration and protected Secret shape were read without printing content. Only the three identified prior containers received `docker inspect`; no business data or raw logs were opened.
- Registry endpoint tests and Docker pull errors were classified locally; proxy values and raw errors were not retained.
- The pull outcome and non-target inventory were re-read after the failure; no unexpected project objects or non-target state changes were found.

### ANOMALIES
- `RETURN_PULL_FAILURE_UNKNOWN`: the one authorized Meilisearch pull failed with an unclassified Docker error. Host Docker Hub TCP/443 and HTTP probes also timed out, but this does not establish the daemon-side root cause. Reviewer should decide whether a new bounded diagnostic Gate is needed.
- `STOP_CAUSE_UNKNOWN`: the three non-target containers exited with the metadata recorded above; Docker event history and available host/backend timestamps did not identify the cause. MariaDB's retained last health status was unhealthy. Its data was not inspected, and it remains stopped as the accepted non-target baseline.

### EVIDENCE_ARTIFACTS_AND_PURPOSE
- This G1C section records the accepted stopped-container baseline, Docker Engine status, sanitized registry findings, official image pull results/digests, and the exact deployment stop point.
- Source remains official Compose blob `865bb147cef972926d5dc32e50645876fd110555`; no raw logs, private paths, container names/IDs, proxy values, or Secrets are attached.

### ROLLBACK_EFFECT
No rollback was needed because no Karakeep service or project volume was created. The two successfully pulled official images are retained for Reviewer-directed continuation; no prune or cleanup ran. All non-target containers, volumes, and networks matched their entry snapshot. Existing Secrets and Compose remain unchanged; real-data backup/restore remains `UNVERIFIED`.

### RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT
Two official GHCR images were added to the local Docker image store; the third pull failed and may have left reusable partial layers. No container/network/volume or business data changed. Host free RAM moved from 2,167 MiB before pulling to 1,036 MiB after; no fixed RAM threshold or OOM occurred. C: free space remained 185 GiB after pulls.

### EXECUTOR_RESULT
`RETURN_PULL_FAILURE_UNKNOWN` — two official GHCR images were pulled and identified by RepoDigest; the single Meilisearch Docker Hub pull failed, so deployment did not start. Stop here for Reviewer assessment; do not retry the failed image or advance the stage in this Gate.


## G1D — Docker Hub and Docker Desktop proxy diagnosis; conditional deployment RETURN — 2026-10-16 (Asia/Singapore)

### AUTHORIZED_GATE
`GATE_ID=KARAKEEP-WIN-G1D-MEILI-HUB-RECOVERY-20261016`
`OWNER_AUTHORIZATION=OWNER_REPORTED` Owner authorized one pull of the existing official Meilisearch tag only if new actionable evidence supports a safe same-configuration route, followed by startup of only `karakeep-local` if all preconditions pass. Reuse the existing Compose and Secrets; no proxy, certificate, system, or unrelated Docker-project changes; no fixed RAM threshold.

### PREFLIGHT_FACTS
- `TARGET_IDENTITY`: `DIRECT_READBACK` Current PowerShell identity matched the interactive Windows session: Explorer and Docker Desktop processes were present in the same session. The current user profile matched Windows' canonical profile path and was not a reparse point, ruling out a Codex path virtualization mismatch for the expected profile location.
- `DOCKER_ENGINE`: `DIRECT_READBACK` Context `desktop-linux`; Engine 29.7.2; Compose 5.4.0. `docker info`, `docker version`, and `docker system df` succeeded. Driver remains `overlayfs`, Docker root matches the accepted `/var/lib/docker` value, Engine memory reports 7.40 GiB.
- `PROJECT_CONFIG`: `DIRECT_READBACK` Neither the accepted `KarakeepLocal` canonical profile location's `docker-compose.yml` nor `.env` was present. A bounded check of the profile Documents, OneDrive Documents, and current-workspace equivalents also found no Compose file. Compose hash, quiet-config, ACL, and existing Secret-shape checks could not be performed; no file was read, created, or modified. No wider disk search was performed.
- `DOCKER_BASELINE`: `DIRECT_READBACK` 20 containers (1 created, 19 exited, 0 running), 12 volumes, 11 networks, and 11 images. No `karakeep-local` container or project volume exists. Port 3000 has no Windows listener or Docker published mapping. No non-target stop reason was re-investigated.
- `IMAGE_READBACK`: `DIRECT_READBACK` The already accepted official images remain present with their expected RepoDigests: Web `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`; Chrome `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`. The Meilisearch tag is absent.
- `HOST_RESOURCES`: `DIRECT_READBACK` Free host RAM was 2,249 MiB and C: free space 185.0 GiB at sampling. These are observations only; no fixed RAM threshold was applied. Docker Engine aggregate disk usage query succeeded.
- `PROXY_MODES`: `DIRECT_READBACK` Windows Internet Settings proxy is disabled, WinHTTP is direct, and only the `HTTP_PROXY` environment-variable presence flag is set (values were never read into Evidence). The .NET system-default route classifies as direct. Docker Engine reports HTTP, HTTPS, and NO_PROXY configuration present; HTTP and HTTPS proxy values are equal and classify as a Docker Desktop internal alias. That alias did not resolve from the Windows host. Raw proxy values and endpoint details were not emitted.
- `DESKTOP_SETTINGS_AND_LOGS`: `DIRECT_READBACK` The bounded standard Docker Desktop settings-file candidates and the targeted backend, daemon, and proxy log paths were absent. Docker Desktop processes are running, but the selected `Containers proxy` / `Docker Desktop proxy` modes and daemon-side Meilisearch failure remain `UNKNOWN`; no raw log was read or retained.
- `HOST_REGISTRY_PROBES`: `DIRECT_READBACK` DNS succeeded for `registry-1.docker.io`, `auth.docker.io`, and `production.cloudflare.docker.com`. Direct host TCP/443 timed out for all three, so TLS and HTTP status were not reached. Requests using the host system-default route also returned no HTTP status. No token endpoint response body, registry credentials, or raw error was retained.
- `NON_TARGET_SNAPSHOT`: `DIRECT_READBACK` Container identity/state and volume snapshots matched the G1D entry snapshot; counts remained 20 and 12. Network count remained 11, but the final identity snapshot differed from the entry snapshot; two consecutive final reads matched. The exact identities were kept local, no Docker write command ran, and the cause of this network identity drift is `UNKNOWN`.

### ACTUAL_CHANGES
- `LOCAL_MUTATIONS=0`: no pull, Compose up/down, Docker object write, configuration/Secret access, or system setting change was performed. The two accepted GHCR images were not downloaded again. This Evidence append is the only planned durable write.

### OBJECTIVE_READBACK
- The new host evidence confirms the Windows direct path to Docker Hub and the image-layer hostname remains blocked at TCP/443. Docker Engine is configured to use a Docker Desktop internal proxy alias, but its Desktop-only route could not be tested from Windows and Desktop proxy mode/log evidence was unavailable.
- No new evidence proves Docker Hub reachable through the Engine's proxy or that G1C's failed pull was transient. The conditional one-pull criterion therefore did not pass. Deployment remains `NOT_DEPLOYED`; no account, bookmark, or business data exists.

### VALIDATION
- Read latest `main` Handoff at blob `1a100f4a0863fef27748303dd400f64af247bd01`, current G1C Evidence at blob `c3d188d3800be0a0714b8785b02e33810e14f793`, and canonical governance `v0.2.7`. G1C records that original Meilisearch pull stderr was not retained; no historical low-level cause was inferred.
- Fresh local reads verified the accepted Engine context/version, both GHCR RepoDigests, missing Meilisearch tag, no target container/volume, port 3000 availability, current resource readings, and the non-target snapshot result above.
- No fixed free-RAM threshold was used. No parser was used to infer the old pull error; network outcomes are recorded by probe stage only.

### ANOMALIES
- `RETURN_CONFIG_NOT_FOUND_AT_ACCEPTED_TARGET`: the protected Compose and Secret files expected for reuse are absent at the verified canonical profile location; their integrity/ACL cannot be revalidated this round.
- `RETURN_DOCKER_HUB_ROUTE_UNVERIFIED`: host direct TCP to registry, auth, and layer CDN timed out; Docker Desktop's internal proxy route could not be verified, so no safe new Meilisearch pull is justified.
- `RETURN_HOST_PROXY_MODE_DRIFT`: G1C recorded Windows Internet proxy enabled, while this fresh read reports it disabled. This Executor made no proxy/system changes; when or why it changed is `UNKNOWN`.
- `RETURN_NON_TARGET_NETWORK_IDENTITY_DRIFT`: network identity snapshot changed during this read-only round while the count stayed 11. No network was inspected, modified, or attributed to Karakeep; cause is `UNKNOWN`.
- G1C's raw Docker pull stderr remains unavailable. This round did not repeat the pull and does not claim a lower-level cause.

### EVIDENCE_ARTIFACTS_AND_PURPOSE
- This G1D section: sanitized Windows host, Engine proxy-presence, bounded endpoint, configuration-presence, and Docker inventory readbacks. It includes no raw proxy address, IP, log line, Secret, private filesystem path, or non-target object identity.

### ROLLBACK_EFFECT
No Karakeep service or project volume was created, so no rollback was needed. The two successful GHCR images remain. No cleanup, `down -v`, or prune ran. Existing Compose/Secret files were not modified; non-target container and volume snapshots matched. The network identity drift remains unexplained and untouched.

### RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT
No Karakeep image, container, volume, network, account, or business-data write was made by this Executor. Observed free RAM was 2,249 MiB and C: free space was 185.0 GiB. Container and volume inventories were unchanged; network count was unchanged but its identity snapshot differed. No fixed RAM floor or OOM conclusion was applied.

### EXECUTOR_RESULT
`RETURN_CONFIG_NOT_FOUND_AT_ACCEPTED_TARGET + RETURN_DOCKER_HUB_ROUTE_UNVERIFIED + RETURN_HOST_PROXY_MODE_DRIFT + RETURN_NON_TARGET_NETWORK_IDENTITY_DRIFT` — do not pull or start Karakeep in this Gate. Reviewer should reconcile the missing reusable project files, unattributed Windows proxy-mode change, and network identity drift, then decide the smallest next Gate. No stage advancement.

## G1E — Read-only path and Docker network reconciliation — 2026-10-16 (Asia/Singapore)

### AUTHORIZED_GATE
GATE_ID=KARAKEEP-WIN-G1E-MISSING-CONFIG-NETWORK-READONLY-20261016
SCOPE=Read-only reconciliation of the accepted local config path, Secret custody state, Docker network metadata, and current proxy mode. Local checks only; no deployment actions authorized or taken.

### PREFLIGHT_FACTS
- GITHUB_BASELINE: DIRECT_READBACK latest main Handoff blob b8464d485fb7a8ef27c136e1aa05c045f3e9963e; prior G1D Evidence blob 8585ff6de1d4b2912f964a6a4409d417be588f6c; canonical Governance v0.2.7 blob 3917c88a7f36df7a53758b3879a92703d659ef9d.
- TARGET_IDENTITY: DIRECT_READBACK native Windows PowerShell session; current profile maps to the Windows canonical profile and the accepted target uses the FileSystem provider. No private absolute path, user name, or SID is recorded.
- ACCEPTED_TARGET: DIRECT_READBACK the accepted KarakeepLocal directory and exact docker-compose.yml and .env filenames are present and accessible. Directory and files are not hidden or reparse points; current-user ownership and protected DACLs were verified, with zero untrusted ACEs. Historical LOCALAPPDATA and APPDATA candidate directories are absent. No Documents, OneDrive, workspace, or wider-disk search was repeated.
- CONFIG_READBACK: DIRECT_READBACK Compose SHA-256 equals the accepted value cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16. Within the validated directory boundary, .env was read only in process to verify the four expected key names and that the two secret fields each have the expected 64-hex format and are distinct. No Secret value or hash was output, copied, or recorded. Current file classification is an exact secure path/config candidate; historical Secret-value continuity remains UNVERIFIED because no prior value or fingerprint exists for comparison.
- FILE_METADATA: DIRECT_READBACK directory and Compose creation/last-write metadata were approximately 2026-10-16 04:12:45Z; .env creation metadata was approximately 04:12:45Z and last-write metadata approximately 04:13:57Z. These are current filesystem timestamps, not a recovered G1D probe time.
- DOCKER_INVENTORY: DIRECT_READBACK read-only Docker metadata queries succeeded. 20 containers (1 created, 19 exited, 0 running), 12 volumes, no Karakeep project container/volume, and no port-3000 listener or published mapping. Existing container and volume summaries remained stable across the local observation interval.
- NETWORK_SNAPSHOTS: DIRECT_READBACK two metadata-only snapshots separated by 15 seconds both showed 11 networks: 3 system defaults and 8 custom. Both snapshots had zero attached endpoints and zero networks with endpoints; no target-project network or Compose-project-labeled network was present. Eight custom networks had labels; private names, IDs, and label values were not emitted. Aggregate driver/scope counts were bridge/local=9, host/local=1, null/local=1. Snapshot IDs and metadata were stable: zero added, removed, or changed objects. Aggregate Created-at range was 2026-09-01T00:33:19Z through 2026-10-16T05:04:19Z.
- IMAGES_AND_PROXY: DIRECT_READBACK both previously accepted GHCR image digests remain present and matching; the Meilisearch tag remains absent. Current Windows Internet proxy mode is disabled and WinHTTP is direct; Docker Engine HTTP/HTTPS/NO_PROXY presence flags are set. No proxy address or value was recorded.

### ACTUAL_CHANGES
- LOCAL_WRITES=0. No local file/config/ACL/Secret, Docker object, proxy, or system setting was created or changed. The only local access to .env was the bounded in-process key/format check after verifying its directory security.
- No Docker pull, Compose up/down, image change, network repair, or container start occurred.
- The only durable write for this Gate is this append-only sanitized Evidence record on GitHub main.

### OBJECTIVE_READBACK
- The exact accepted target now contains an accessible, protected Compose file whose hash matches the historical accepted fingerprint, plus a protected .env with the expected key set and valid distinct Secret formats. This establishes current presence and shape, not that the Secret bytes are the same as those previously created.
- G1D recorded the files absent, while this G1E read found them present. Current metadata timestamps precede the G1D Evidence commit timestamp, but that repository commit time is not the G1D local probe time and does not prove what existed during that probe. No causal evidence establishes whether the earlier result reflected timing, visibility, or another condition; cause remains UNKNOWN.
- Current network state is classified as 3 defaults and 8 custom objects, with no attached endpoints and no changes between the two G1E snapshots. G1D did not persist the exact earlier network IDs, so the identity of the historically differing object and its cause cannot be reconstructed; historical cause remains UNKNOWN.
- Current Windows proxy mode is disabled, consistent with the G1D read and different from G1C's enabled reading. This Gate made no change and establishes no cause.
- Both accepted GHCR images remain; Meilisearch is absent. Karakeep remains NOT_DEPLOYED.

### VALIDATION
- Latest main Handoff, prior G1D Evidence, and canonical Governance were read through the GitHub connector before this append. The G1E Gate ID was rechecked immediately before writing.
- Exact accepted Compose hash, protected directory/file metadata, .env key/format shape, bounded alternate-path absence, and Docker/network/proxy/image summaries were read back locally. No secret-bearing value or digest was recorded.
- Two Docker network snapshots 15 seconds apart had identical IDs/metadata summaries and no endpoints. No container internals, business data, environment, mounts, logs, or private object identities were read.
- No Windows event metadata was queried; no deletion/move cause is claimed. No pull, up/down, file write, ACL change, or system/proxy change occurred.
- This Evidence append was read back from GitHub main and compared with the exact appended text; the existing G0–G1D prefix was preserved.

### ANOMALIES
- RETURN_CONFIG_VISIBILITY_HISTORY_UNKNOWN: the accepted target was reported absent in G1D and is present now. File timestamps alone do not explain the discrepancy, and the exact prior probe time or event evidence is unavailable.
- SECRET_CONTINUITY_UNVERIFIED: the current .env is protected and format-valid, but its Secret bytes cannot be compared with a historical value or fingerprint.
- RETURN_HISTORICAL_NETWORK_IDENTITY_CAUSE_UNKNOWN: G1E current network metadata was stable and no endpoints were attached, but G1D's exact identity set was not retained in Evidence and cannot be reconstructed.
- PROXY_MODE_HISTORY_UNRESOLVED: current mode remains disabled; the G1C/G1D difference is not attributed to this Executor.
- No event-log query, filesystem recovery, broad search, or service operation was performed.

### EVIDENCE_ARTIFACTS_AND_PURPOSE
- This G1E entry: sanitized path/security/config-shape, Docker network, image, and proxy readbacks; no private path, user/SID, Secret value/hash, proxy endpoint, raw logs, private network/container identity, or unrelated business data.
- Handoff baseline: blob b8464d485fb7a8ef27c136e1aa05c045f3e9963e. Prior G1D Evidence baseline: blob 8585ff6de1d4b2912f964a6a4409d417be588f6c. Canonical Governance: blob 3917c88a7f36df7a53758b3879a92703d659ef9d.
- No local diagnostic artifact was created.

### ROLLBACK_EFFECT
No local runtime or system change occurred; no rollback is needed. The GitHub Evidence record is append-only. No cleanup or repair action occurred.

### RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT
No Karakeep service, project volume/network, account, bookmark, or business data was created. Existing Docker containers and volumes were not changed; the two accepted GHCR images remain and no new image was pulled. No fixed RAM threshold or runtime-stability test was applied because this Gate remained read-only and no service ran.

### EXECUTOR_RESULT
PASS_CANDIDATE — G1E read-only scope and required path/network classifications are complete. The accepted Compose is present and fingerprint-matched; current Secret format is safely verified, while historical Secret continuity remains UNVERIFIED. Current Docker networks are classified and stable across two snapshots, but the exact historical changed identity/cause remains UNKNOWN. No local mutation or deployment occurred. Stop here for Reviewer acceptance and next-Gate decision.

## G1F — Meilisearch single-pull diagnostic RETURN — 2026-10-16 (Asia/Singapore)

### AUTHORIZED_GATE
GATE_ID=KARAKEEP-WIN-G1F-MEILI-PULL-AND-DEPLOY-20261016
OWNER_AUTHORIZATION=OWNER_REPORTED Owner authorized one bounded pull of the official getmeili/meilisearch:v1.41.0 image and project-only Karakeep startup only if the pull and all deployment conditions passed. Reuse the existing Compose, Secrets, and two accepted GHCR images. No global proxy, VPN, certificate, Docker Desktop, or system changes were authorized.

### PREFLIGHT_FACTS
- GITHUB_BASELINE: DIRECT_READBACK current main Handoff blob 0e028d79e7843597b188c3bd1ecc1fcef9faa677; accepted G1E Evidence blob c04540e5bfd29c34744f46c23733f1d31a833370. Handoff records Reviewer acceptance of G1E as PASS.
- TARGET_IDENTITY: DIRECT_READBACK native interactive Windows PowerShell 7.6.5; current profile matched the canonical Windows profile. Docker context desktop-linux, Engine 29.7.2, Compose 5.4.0; Engine metadata/version queries succeeded.
- ACCEPTED_CONFIG: DIRECT_READBACK Compose and .env were present at the accepted target. Compose SHA-256 matched cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16. Directory and files were current-user-owned, DACL-protected, and had zero untrusted ACEs. The four expected .env keys were present; the two Secret fields had distinct valid 64-hex formats. Values and Secret hashes were not emitted or saved.
- COMPOSE_SCOPE: DIRECT_READBACK rendered configuration showed exactly the accepted Web loopback binding 127.0.0.1:3000:3000; Chrome and Meilisearch had zero host-port bindings. Compose supported up --pull never. An initial checker treated null port fields as a nonempty array and stopped before pulling; a targeted re-read of the rendered configuration confirmed one Web binding and zero Chrome/Meilisearch bindings. No mutation occurred during this correction.
- EXISTING_IMAGES: DIRECT_READBACK both accepted GHCR RepoDigests still matched the recorded Web and Chrome digests. Neither image was pulled again.
- PRE_PULL_COLLISIONS: DIRECT_READBACK Meilisearch tag absent, no Karakeep project containers/volumes/networks, and port 3000 had no listener or existing published mapping.
- RESOURCE_AND_ENGINE: DIRECT_READBACK C: had 184.7 GiB free in preflight and after the failed pull; Docker system df succeeded after the attempt. Available RAM after the attempt was 2,495 MiB; no fixed RAM threshold was applied.
- PROXY_STATE: DIRECT_READBACK at post-pull readback, Windows Internet proxy was enabled, PAC was absent, and automatic detection was disabled; WinHTTP was direct. Docker Engine HTTP/HTTPS/NO_PROXY configuration-presence flags were set. Proxy values and endpoints were not read into Evidence. G1E had recorded Windows Internet proxy disabled; this round made no proxy or system change.
- POST_PULL_INVENTORY: DIRECT_READBACK after the attempt, 20 containers (1 created, 19 exited, 0 running), 12 volumes, and 11 networks; no Karakeep project object or port-3000 mapping. Two post-pull snapshots 15 seconds apart had stable non-target container ID/state, volume, and network metadata summaries. Counts match the accepted G1E baseline.

### ACTUAL_CHANGES
- Executed exactly one Docker Engine pull for getmeili/meilisearch:v1.41.0. Docker stdout and stderr were captured only in the local PowerShell process memory, classified against the allowlist, and discarded after classification. No raw output, URL, credential, or Secret was displayed, written, or uploaded.
- The pull failed. Docker native process exit code was 1; it completed in under 10 seconds, did not hit the local timeout, and was classified as LAYER_DOWNLOAD_OR_EXTRACT at stage layer_download_or_extract. The capture contained no explicit Downloading, Download complete, Extracting, or Pull complete progress marker; layer progress is recorded as NOT_OBSERVED. The exact low-level line was not retained, so no narrower cause is claimed.
- Classifier fixtures for DNS, proxy-connect, and rate-limit categories passed before the pull. A synthetic native process exit-code probe returned 37 and was captured correctly.
- No Compose up/down, service start, account creation, bookmark, data write, configuration/Secret change, proxy/VPN/certificate change, or non-target Docker change was performed. No retry, prune, or cleanup occurred.

### OBJECTIVE_READBACK
- Post-pull Docker image inspection confirms getmeili/meilisearch:v1.41.0 is still absent as a completed image tag. Partial reusable layers may remain; none were removed.
- Both accepted GHCR images remain present with their accepted digests. No Karakeep project object was created; port 3000 remains free.
- The Docker Engine pull failure is classified at the layer download/extract category. The captured evidence does not establish whether Windows Host connectivity, Docker Desktop proxy routing, TLS, or storage caused it; no such cause is inferred.
- Current Windows Internet proxy mode differs from G1E, while WinHTTP remains direct. This was observed only and is not attributed to the pull or to this Executor.
- Deployment remains NOT_DEPLOYED. No service stability test applies because no service was started.

### VALIDATION
- Latest main Handoff, accepted G1E Evidence, and Governance v0.2.7 were read before local execution. G1F Gate identity was checked again immediately before the Evidence append.
- Fresh local readback verified the protected accepted configuration, exact Compose fingerprint, current Secret shape, rendered host-port scope, both existing GHCR digests, target collision absence, and port availability.
- The single pull used a 600-second ceiling and process-memory-only stdout/stderr capture. Native exit code, elapsed-time bucket, allowlisted class/stage, and progress-marker observation were recorded without raw error text.
- Post-pull read-only checks confirmed Meilisearch tag absence, Docker system df success, target-object absence, port availability, existing GHCR digests, and stable current non-target inventory across two spaced reads.
- No raw Docker logs, container internals, volume contents, Secret values/hashes, proxy endpoint values, private IPs, usernames, SIDs, or private object identities were retained.

### ANOMALIES
- RETURN_MEILI_PULL_LAYER_DOWNLOAD_OR_EXTRACT: the only authorized pull exited 1 and matched the layer download/extract classifier. The exact low-level error text was intentionally discarded after classification; a more specific underlying cause is UNKNOWN. No retry is authorized in this Gate.
- PROXY_MODE_DRIFT: Windows Internet proxy is now enabled versus G1E's disabled reading. WinHTTP is still direct. The Executor made no setting changes; timing and cause remain UNKNOWN.
- PREFLIGHT_VALIDATOR_CORRECTION: the first local port-array validator mishandled absent fields; the corrected targeted Compose parse independently confirmed Chrome and Meilisearch have no host bindings. Pull was not started until that readback passed.
- A failed pull may leave reusable partial image layers. They were retained; no prune or cleanup ran.

### EVIDENCE_ARTIFACTS_AND_PURPOSE
- This G1F entry: sanitized preflight, classifier-fixture/native-exit validation, one-pull result, post-pull inventory, and stop point.
- Handoff baseline: blob 0e028d79e7843597b188c3bd1ecc1fcef9faa677. Accepted G1E Evidence: blob c04540e5bfd29c34744f46c23733f1d31a833370.
- No raw pull output or local diagnostic artifact was saved.

### ROLLBACK_EFFECT
No Karakeep container, network, or project volume was created, so project rollback was unnecessary. The failed pull may have left image layers; they remain available for Reviewer-directed continuation. No existing image was removed, and no cleanup command ran.

### RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT
No service, account, bookmark, or business data was created. Existing Docker inventory counts matched the accepted baseline and remained stable across the post-pull observation window. C: free space was 184.7 GiB before/after the failed attempt; available RAM after it was 2,495 MiB. No fixed RAM threshold was applied.

### EXECUTOR_RESULT
RETURN_MEILI_PULL_LAYER_DOWNLOAD_OR_EXTRACT — exactly one authorized pull was attempted and accurately classified; it failed before deployment. The precise sub-error is UNKNOWN because the Gate required discarding raw output after safe classification. No second pull, service start, proxy/system change, or other-project action occurred. Stop for Reviewer decision on the next bounded diagnostic Gate; any future global proxy/system action requires separate explicit Owner authorization.


## G1G — Docker Hub proxy-root-cause diagnosis — 2026-10-16 (Asia/Singapore)

### AUTHORIZED_GATE
GATE_ID=KARAKEEP-WIN-G1G-HUB-PROXY-ROOTCAUSE-20261016
OWNER_AUTHORIZATION=OWNER_REPORTED Owner authorized only bounded read-only diagnosis, sanitized Evidence append/read-back, and Reviewer handoff. No image pull, Compose start/stop, proxy/VPN/certificate/system change, or other-project action was authorized.
BASELINE=DIRECT_READBACK Handoff blob 222edd363c30082d49b96e370ad57d52d056dd6e; G1F Evidence blob 02b69eae4c6470094d9383b26300c5c60eadc623; Governance v0.2.7 blob 3917c88a7f36df7a53758b3879a92703d659ef9d.

### PREFLIGHT_FACTS
- TARGET_IDENTITY: DIRECT_READBACK native Windows 11, interactive PowerShell 7.6.5 session with Explorer in the same session; Docker context desktop-linux and Engine 29.7.2 reachable.
- ACCEPTED_CONFIG: DIRECT_READBACK the accepted Compose file exists and SHA-256 still matches cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16; Compose and .env are current-user-owned with protected DACLs and three allowlisted principals. .env was not read; no Secret value or hash was inspected or emitted.
- ACCEPTED_IMAGES: DIRECT_READBACK both previously accepted GHCR image digests remain present. No image was pulled or replaced.
- HOST_PROXY_STATE: DIRECT_READBACK WinINET proxy enabled, PAC absent, auto-detect disabled; WinHTTP mode direct. No proxy endpoints, PAC contents, credentials, or environment values were read into Evidence.
- ENGINE_PROXY_FLAGS: DIRECT_READBACK Docker Engine reports HTTP, HTTPS, and NO_PROXY configuration present. Values were not recorded. This does not identify the effective Docker Desktop Containers proxy mode or prove the route used by image pulls.
- DESKTOP_SETTINGS: DIRECT_READBACK the expected settings-store file exists and parses, but its property names contain no Containers proxy, Docker Desktop proxy, or proxy mode keys. No allowlisted mode enum could be extracted; both effective modes remain UNVERIFIED. The file DACL is not protected and includes one non-allowlisted ACE with effective read/write rights; the identity is withheld. The file was inspected only in local process memory and no unrelated setting values were emitted.
- LOG_METADATA: DIRECT_READBACK the official httpproxy.log candidate and one same-directory backend log candidate exist. Their DACLs are not protected and each includes a non-allowlisted ACE with effective read/write rights; identities and paths are withheld. Log contents are therefore treated as local diagnostic observations, not tamper-proof records.
- G1F_TIME_ANCHOR: INFERRED the actual Meilisearch pull timestamp was not recorded. The bounded correlation window used the G1F Evidence commit time 2026-10-16T05:58:57Z +/- 30 minutes only as a proxy, not as the operation time.
- HTTP_PROXY_LOG_WINDOW: DIRECT_READBACK within that inferred window, 12 records at 2026-10-16T05:54Z–05:55Z matched registry/auth domain categories and CONNECT. No CDN category, recognized HTTP status, TLS, EOF, timeout, DNS, authorization, or proxy-connect failure marker was observed; no log line identified the Containers proxy or fallback route. Attribution to the actual pull is INFERRED only.
- BACKEND_LOG_WINDOW: DIRECT_READBACK the bounded same-directory backend log candidate had no matching registry/auth/CDN event in the inferred window. Because the pull timestamp is missing, this does not prove that the pull had no backend event.
- HOST_VS_ENGINE_PATH: DIRECT_READBACK host WinINET/WinHTTP modes and Engine proxy configuration-presence flags were sampled separately. No new host connectivity probe or authenticated/network image request was performed. Neither the historical Windows Host timeout nor the Engine proxy flags establish the effective Containers proxy route or the Meilisearch failure point.
- CLASSIFIER_AUDIT: INFERRED a no-secret synthetic fixture combining “failed to copy”, “failed to do request”, and “i/o timeout” is classified as LAYER_DOWNLOAD_OR_EXTRACT by a broad-marker-first rule but as TIMEOUT by cause-first rules; a synthetic layer-registration fixture remains LAYER_DOWNLOAD_OR_EXTRACT. The exact G1F classifier source and raw error were not retained, so the real G1F failure is not reclassified.

### ACTUAL_CHANGES
- LOCAL_MUTATIONS=0. Read-only metadata, Engine state, allowlisted settings-key parsing, and bounded in-memory log classification only. No Compose/.env readback beyond required file metadata/hash, Docker pull/up/down, network probe, system change, or non-target project action occurred.
- Appended this sanitized G1G Evidence entry to project main. No local diagnostic file or raw log was created or retained.

### OBJECTIVE_READBACK
- The two proxy modes requested by G1G cannot be established from the current settings-store content; the current Windows proxy modes and Docker Engine proxy-presence flags do not substitute for that missing mode readback.
- The available httpproxy log gives only an inferred-time-window registry/auth CONNECT observation. It contains no visible error class or CDN request that can locate the failed layer transfer. The backend candidate adds no matching event in that inferred window.
- Root cause of G1F remains UNVERIFIED: Docker Hub registry/auth or layer CDN failure, proxy routing, and the discarded low-level Docker error cannot be distinguished from retained evidence. The broad G1F layer class is not proof of extraction/storage failure.
- UNIQUE_NEXT_ACTION: Owner performs a read-only view of Docker Desktop > Settings > Resources > Proxies and relays only the displayed Containers proxy mode and Docker Desktop proxy fallback mode (or “not configured”). Do not change the page or relay proxy addresses, PAC text, credentials, or other settings. The current shell readback has no mode fields and no UI state, so this is the smallest direct acquisition. No rollback is needed for a read-only view. Reviewer can then choose a narrowly scoped next Gate; no retry or configuration change is implied here.
- Project remains NOT_DEPLOYED; no service stability claim applies.

### VALIDATION
- Latest main Handoff, latest G1F Evidence, and canonical Governance v0.2.7 were read immediately before the Evidence append and their blob SHAs matched the current G1G baseline.
- Native Windows identity, current Engine/context, accepted Compose fingerprint, .env metadata/protection only, and both accepted GHCR digests were directly read back.
- The settings file was inspected for property names and recognized mode enums only; proxy values and other settings values were not emitted. Logs were bounded to the tail of the named official candidates, processed locally, and reduced to allowlisted categories/time buckets. Raw lines were not retained or shown.
- Synthetic classifier fixtures ran without credentials or project data; no result was used to revise the historical G1F failure.
- No pull, Compose up/down, settings write, or other-project operation was issued. After the append, GitHub main readback was required to match the complete appended content and preserve the prior Evidence prefix.

### ANOMALIES
- UNVERIFIED_CONTAINERS_PROXY_MODE: settings-store.json has no proxy mode keys, so the effective Containers proxy mode and Docker Desktop proxy fallback cannot be identified from shell readback.
- HISTORICAL_PULL_TIME_UNAVAILABLE: G1F records the Evidence commit time, not the actual pull time. Log correlation is therefore explicitly inferred.
- LOG_DIAGNOSTIC_TRUST_LIMIT: settings/log files have an unprotected DACL with a non-allowlisted read/write ACE; no identity details are disclosed, and those files cannot be treated as tamper-proof evidence.
- RETURN_CLASSIFIER_GRANULARITY: synthetic audit demonstrates a broad layer marker can mask an inner network timeout; the actual G1F error and exact classifier implementation are unavailable.

### EVIDENCE_ARTIFACTS_AND_PURPOSE
- This G1G entry: sanitized local proxy-mode availability, time-window log classification, host/Engine distinction, classifier audit, and the one required next action.
- G1F source record: main commit 620137a07297cee3d5cd5716fab42685b06b89b6; Evidence blob 02b69eae4c6470094d9383b26300c5c60eadc623.
- G1G baseline Handoff blob 222edd363c30082d49b96e370ad57d52d056dd6e; canonical Governance v0.2.7 blob 3917c88a7f36df7a53758b3879a92703d659ef9d.
- Raw settings, proxy endpoints, log lines, URLs, IPs, credentials, Secrets, local absolute paths, and unrelated project data are not included.

### ROLLBACK_EFFECT
No local rollback is needed. This append-only Evidence entry is the sole repository change; no Docker or Windows state changed. Existing Compose/.env and GHCR images remain untouched.

### RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT
No image pull, service/container/volume/network creation, account, bookmark, or business data change occurred. The accepted GHCR images remain present; no non-target Docker resource was queried or changed.

### EXECUTOR_RESULT
PASS_CANDIDATE — G1G authorized read-only diagnosis and evidence handling are complete, but the effective Docker Desktop proxy modes and root cause remain UNVERIFIED. The one concrete next action is the Owner’s read-only Proxies-page mode readback specified above. No retry, deployment, or settings change was performed; stop at Reviewer.


## G1I — Scoped proxy recovery and conditional first start — 2026-10-16 (Asia/Singapore)

### AUTHORIZED_GATE
`GATE_ID=KARAKEEP-WIN-G1I-SCOPED-PROXY-RECOVERY-20261016`
`AUTHORITY=Owner-authorized scope recorded in current main Handoff and reconfirmed in this task`
`SCOPE=Read-only proxy diagnosis; at most one official Meilisearch pull; conditional first start of karakeep-local; required project-only rollback on anomaly; sanitized Evidence append/readback`

### PREFLIGHT_FACTS
- `DIRECT_READBACK` Native Windows 11 PowerShell 7.6.5; Docker Desktop 4.95.0 Personal; Linux Engine 29.7.2; Compose 5.4.0; context `desktop-linux`.
- `DIRECT_READBACK` Existing Compose fingerprint matched the Handoff SHA-256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`; protected directory ACL and `.env` shape passed. The four required key names and two distinct 64-hex secret shapes were checked in protected memory only. No secret values or hashes were emitted, copied to GitHub, or changed.
- `DIRECT_READBACK` Both accepted GHCR images were present before deployment with the Handoff RepoDigests. Meilisearch `getmeili/meilisearch:v1.41.0` was absent before this Gate. No `karakeep-local` containers, volumes, or network existed; baseline was 20 containers / 0 running / 12 volumes / 11 networks. Host port 3000 was free. No active pull/build/start or running container workload was found before any optional shared proxy setting could be considered.
- `DIRECT_READBACK` Docker Desktop Proxies UI was read before/after the pull and after Compose start: Docker Desktop proxy selected `System proxy`; Containers proxy selected `Same as host proxy`; Apply disabled. These matched the G1H baseline. No temporary or persistent proxy setting was changed, so no proxy restoration action was needed.
- `DIRECT_READBACK` Windows static System proxy resolved to an existing loopback HTTP proxy candidate. Its protocol was verified as HTTP with successful CONNECT and TLS to Docker Hub registry and auth endpoints; unauthenticated registry response was 401 and auth-root HEAD was 404. No proxy address, port, URL, credential, or environment value is included. A framework-default helper selected a different process proxy route and was not used as evidence for the explicit System-proxy test.
- `DIRECT_READBACK` Bounded Docker Desktop proxy log processing around the actual pull found 42 records across registry/auth/CDN categories and CONNECT activity; no recognized TLS, EOF, timeout, DNS, authentication, or proxy error category. Raw log lines and URLs were not retained or disclosed. These logs are corroborative; the actual successful pull is the authoritative outcome.
- `DIRECT_READBACK` C: free space sampled at approximately 184.4 GiB before and 184.1 GiB after the pull. No fixed free-RAM threshold was applied.

### ACTUAL_CHANGES
- Exactly one authorized pull was executed: `docker pull getmeili/meilisearch:v1.41.0`. Start `2026-10-16T06:58:36.467Z`, end `2026-10-16T06:59:06.664Z`, elapsed 30.2 s, exit code 0. No GHCR image was pulled again. Meilisearch RepoDigest readback: `getmeili/meilisearch@sha256:860fa4baed04ae1c235de870edab0c8006227546dea1bbb6411fbfc5e27cf1db`.
- `docker compose -p karakeep-local up -d --pull never` returned exit code 0 at `2026-10-16T07:01:39Z`. No Compose, `.env`, key, Windows proxy, Clash/VPN, certificate, daemon/WSL setting, or non-target project was modified.
- After finding the Chrome Host-header incompatibility below, the Gate rollback rule was applied using only `docker compose -p karakeep-local down` (no `-v`, no image-removal option), exit code 0.

### OBJECTIVE_READBACK
- `DIRECT_READBACK` While running, all three target containers used the intended official images and RepoDigests: Web `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`; Chrome `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`; Meilisearch digest above.
- `DIRECT_READBACK` At `2026-10-16T07:05:24Z`, Web, Meilisearch, and Chrome were running; Web health was healthy; all had restart count 0 and OOMKilled=false. No healthcheck was configured for the two dependency containers. Host `http://localhost:3000` returned HTTP 200 and HTML contained the Karakeep marker. The only host mapping was Web `127.0.0.1:3000`; Windows listener readback showed loopback only. Meilisearch `/health` returned 200 from the Web container.
- `DIRECT_READBACK` Chrome exposes container TCP 9222, with no host port mapping; the port was reachable from Web. The Web configuration uses the `chrome:9222` service alias. HTTP requests through that alias returned 500 with the sanitized response: “Host header is specified and is not an IP address or localhost.” The same Chrome endpoint returned 200 when the request Host header was the literal `127.0.0.1`. This establishes an actual incompatibility in the frozen internal Web→Chrome route; Chrome container status alone does not satisfy the Gate dependency-availability criterion.
- `DIRECT_READBACK` After rollback: target container count 0; target project network absent; the two project volumes `karakeep-local_data` and `karakeep-local_meilisearch` remain; total containers/running/networks returned to baseline 20/0/11; total volumes are 14 (baseline 12 plus the two preserved project volumes); port 3000 has no listener. All three official images and their RepoDigests remain present.

### VALIDATION
- The no-credential proxy probes used explicit CONNECT/TLS and expected unauthenticated HTTP responses; no image was pulled during these probes. Docker Desktop UI readback verified the proxy modes remained unchanged through the pull and start.
- A credential-free synthetic classifier fixture was checked before the single pull so an inner timeout/TLS/auth cause would take precedence over a broad layer-copy message. The real pull had no error; no historical failure was reclassified.
- Compose startup, service/image identity, Web/Meilisearch HTTP checks, loopback-only port exposure, container OOM/restart state, resource stats, and cleanup were read back with project-scoped commands. At the 07:05Z sample, host available memory was approximately 1,315 MiB and container stats were Web 368 MiB, Meilisearch 28.2 MiB, Chrome 331.7 MiB; at later cleanup host available memory was approximately 2,098 MiB. These are observations, not thresholds. No OOM or restart was observed during the approximately five-minute run.
- After cleanup, all target containers and the host port were absent, both project volumes and all images remained, and non-target inventory counts matched the pre-start baseline. No account, AI key, or bookmark data was added.
- No Secret, proxy address/credential, raw log, raw command output, or unrelated project data was submitted.

### ANOMALIES
- The first internal Chrome probe used port 3000 and was refused; image metadata then directly identified the correct exposed container port 9222. The corrected port test showed TCP reachability.
- The corrected HTTP test exposed the actionable blocker: Chromium rejects the Docker service DNS Host header but accepts a literal IP Host header. Because the frozen Web configuration targets the service alias, Chrome is not usable through the configured internal route. This is not a Docker Hub pull failure.
- Initial Compose startup and the homepage HTTP 200 therefore do not constitute full G1I acceptance. No attempt was made to change the frozen Compose/browser endpoint or Chrome launch flags under this Gate.

### EVIDENCE_ARTIFACTS_AND_PURPOSE
- Current G1I Handoff read from main before execution: blob `115e9428f2f6107ad1267569a66cfa6d1b86f173`.
- Latest prior G1G Evidence baseline: commit `2a2ba90bafe0c68048720b87cbba5ddce77c150b`, blob `9c77c352eb2766c308f7dfe1aa7c011fb62a0db4`.
- Canonical Governance read from `entropy-student/spike.skill` main, `vps-project-governance/VNEXT.md` v0.2.7, blob `3917c88a7f36df7a53758b3879a92703d659ef9d`.
- Docker Desktop proxy behavior reference: https://docs.docker.com/desktop/settings-and-maintenance/settings/
- Local Windows UI, proxy handshake, Docker state, image digest, and bounded log evidence were reduced to the facts above. No screenshot or raw local diagnostic was uploaded.

### ROLLBACK_EFFECT
No Docker Desktop or Windows proxy setting was changed; the G1H proxy modes were read back unchanged, so proxy rollback was not required. The only rollback was project-scoped Compose down without volume removal after the Chrome dependency anomaly. Karakeep containers and its network are stopped/removed; the two named volumes, three official images, Compose, and `.env` remain. No other Docker project or system setting was changed.

### RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT
The temporary first start created three target containers, two target volumes, and one target network. After the required rollback, containers and network were removed, while the two volumes and three images were retained. Baseline non-target totals returned to 20 containers / 0 running / 11 networks; volumes are baseline plus two preserved target volumes. Port 3000 is currently released. No user account or real bookmark data was created. Host memory varied during the run and cleanup; no fixed threshold was used and no OOM/restart was observed.

### EXECUTOR_RESULT
`RETURN — Meilisearch pull succeeded through the unchanged, verified Docker Desktop proxy route and the official three-image set is present. The initial Compose start and localhost Web HTTP 200 succeeded, but G1I acceptance is not met: Web→Chrome requests using the configured service alias receive Chromium HTTP 500 due to the Host-header restriction. The project was stopped with the authorized project-only rollback and volumes retained. The concrete next step is for Reviewer to issue a separate, narrowly scoped Chrome-compatibility Gate: identify a documented supported internal endpoint/Host-header mechanism for the current official Chrome image and frozen Karakeep version, then authorize only the necessary Karakeep-local browser-route change and revalidate without publishing Chrome on a host port. Do not reuse G1I to change Compose or retry deployment. Stop at Reviewer.

Executor-to-Reviewer relay:
结果：G1I RETURN，Meili 镜像下载及临时启动成功，但 Chrome 内部 Host-header 限制阻断完整验收。
改动：只新增官方 Meili 镜像及 Karakeep 初装容器/卷/网络；无代理、Compose、密钥或其他项目设置变更。
验证：Docker Hub HTTP CONNECT/TLS 可用；三镜像 RepoDigest、Web HTTP 200、Meili health 200、Chrome 9222 TCP 均读回；Web→Chrome 服务别名 HTTP 500，字面 IP Host 返回 200；所有容器重启 0、无 OOM、Web 仅绑定 127.0.0.1:3000。
问题：当前官方 Chrome 镜像拒绝 `chrome:9222` 的 Host header；应用首页 200 不代表浏览器依赖已可用。
回滚：已运行项目级 `docker compose -p karakeep-local down` 无 `-v`；卷和镜像保留，代理设置未动，3000 已释放。
请 Reviewer 检查：确认 G1I 结果并决定是否创建独立 Chrome 兼容性 Gate。
Owner 转交：本地服务已停止；当前无可访问地址。等待 Reviewer，不进入下一 Gate。

## G1J — Real browser path revalidation — 2026-10-16 (Asia/Singapore)

### AUTHORIZED_GATE
`GATE_ID=KARAKEEP-WIN-G1J-REAL-BROWSER-PATH-REVALIDATION-20261016`
`AUTHORITY=Owner instruction in this session explicitly authorized one project-only restart using existing Compose, .env, secrets, and local official images; keep running on pass, otherwise project-only down without volume removal`
`SCOPE=G1J preflight, one no-pull start, real Worker/Chrome CDP and service/exposure/stability checks, sanitized Evidence append/readback; no account or bookmark creation`

### PREFLIGHT_FACTS
- `DIRECT_READBACK` Latest project Handoff from main before execution: blob `94500b8104af5405a56ac710d72da6acedf12eee`; accepted G1I Evidence baseline blob `c300dc5d422cbbcbacc554a1bf8acdaf92e2a531`; canonical Governance v0.2.7 blob `3917c88a7f36df7a53758b3879a92703d659ef9d`.
- `DIRECT_READBACK` Native Windows 11 PowerShell 7.6.5; Docker Desktop 4.95.0 Personal; Docker Linux Engine 29.7.2; Compose 5.4.0; context `desktop-linux`.
- `DIRECT_READBACK` Frozen local Compose SHA-256 matched Handoff `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`; `docker compose config -q` passed. Protected project/config/.env ACLs and ownership matched the allowlist. `.env` required key names and two distinct 64-hex secret shapes were checked in protected memory only; no value or secret hash was emitted.
- `DIRECT_READBACK` All three previously accepted official images were already present with expected RepoDigests: Web `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`; Chrome `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`; Meilisearch `getmeili/meilisearch@sha256:860fa4baed04ae1c235de870edab0c8006227546dea1bbb6411fbfc5e27cf1db`.
- `DIRECT_READBACK` Both existing named volumes were labeled for project `karakeep-local`. Before start: 20 containers / 0 running / 14 volumes / 11 networks; no target container/network and host port 3000 was free. No non-target container was running.
- `DIRECT_READBACK` C: free space was approximately 188.1 GiB. Available memory varied during observations; no fixed free-memory threshold was used. Docker Desktop proxy modes matched the recorded state (`System proxy` / `Same as host proxy`) and were not changed.

### ACTUAL_CHANGES
- Started only the existing project once with `docker compose -p karakeep-local up -d --pull never`; exit code 0, start `2026-10-16T07:25:56Z`, completion `2026-10-16T07:25:57Z`. No image pull/build occurred.
- No Compose, .env, Secret, image, proxy, Windows/Docker setting, or non-target project was modified. No account, real bookmark, or AI key was created.

### OBJECTIVE_READBACK
- `DIRECT_READBACK` Final sample at `2026-10-16T07:37:55Z`: Web, Meilisearch, and Chrome all running; Web health `healthy`; all restart counts 0 and OOMKilled=false. Expected RepoDigests remained attached to running target containers.
- `BEHAVIORALLY_VERIFIED` Actual Worker log window from project startup through the ~07:33Z sample contained 91 lines, two `Starting crawler worker` events, one browser connection attempt, and one successful hostname-to-address resolution. It contained zero browser connection failure/retry, disconnect, browserless-mode, or on-demand-mode markers. The Web image has no OCI version/revision labels, so its exact source commit is `UNVERIFIED`; these are actual runtime logs, not proof that the frozen image equals current upstream main.
- `BEHAVIORALLY_VERIFIED` Read-only CDP check from the Web container used the resolved IPv4 endpoint without disclosing the address: `/json/version` returned HTTP 200, the WebSocket opened, and `Browser.getVersion` returned successfully. Chrome logs included its DevTools listening marker. Combined with the Worker resolution/connection attempt and absence of its explicit failure/retry/disconnect path over the observation window, this supports a live Worker browser connection. The Worker image does not emit a separate explicit success log, so that narrow attribution remains behaviorally verified rather than a direct Worker-state API read.
- `DIRECT_READBACK` Meilisearch `/health` returned HTTP 200 with `available`. Host root request returned HTTP 307 to the sign-in route; `/signin` returned HTTP 200 with Karakeep and login markers. The browser-facing URL is `http://localhost:3000`.
- `DIRECT_READBACK` Web was the only service with a host port mapping, bound to loopback port 3000. A connection attempt via a non-loopback host interface to that port was not connected. Meilisearch port 7700 and Chrome CDP port 9222 had no host mappings and remain on the project network.
- `DIRECT_READBACK` Project totals after startup: 23 containers / 3 running / 14 volumes / 12 networks. Relative to the pre-start snapshot, only three target containers and one target network were added; the two target volumes pre-existed. No non-target container was started or changed.

### VALIDATION
- Official upstream `apps/workers/workers/utils/browser.ts` blob `96192428e232c375680d989a49abb58bb897a6fb` exactly matches the Handoff reference. That source resolves the configured browser hostname to an IP before `connectOverCDP`; on connection error it logs an explicit failure and schedules a retry, and on disconnect it logs and reconnects. Current upstream `crawlerWorker.ts` blob `c0b08c04d468c3942e2a39907612ba752595300a` awaits browser-environment initialization before starting the crawler worker. This is source behavior provenance, not a claim that the downloaded release image has that exact revision.
- `DIRECT_READBACK` Independent runtime observations at ~07:27, ~07:31–07:32, ~07:33, and ~07:37 showed all services running, zero restarts/OOM, and Web healthy. Container CPU/memory use remained active but stable in samples; host available RAM varied from roughly 424 MiB in one sample to about 1.9 GiB in later samples. No static memory gate was applied and no instability was observed.
- `DIRECT_READBACK` Final no-proxy curl probe reached loopback: root redirected to `/signin`, and `/signin` returned 200. Meilisearch health and service state were also re-read at the final sample.
- `DIRECT_READBACK` Docker Desktop proxy modes were visually read back and unchanged. No proxy restoration was needed.
- Admin `checkConnections` endpoint returned HTTP 401 without an authenticated account. No account was created. The live CDP handshake and Worker runtime evidence above provide the browser-path evidence without an account.

### ANOMALIES
- An initial internal CDP probe accidentally formed a doubled slash in the path and returned 404; the corrected read-only probe returned 200 and completed the CDP command. This was probe construction, not an application error.
- PowerShell `Invoke-WebRequest` reported `HttpRequestException` in a final host probe. A direct `curl.exe --noproxy '*'` loopback probe immediately succeeded and returned the expected sign-in redirect; `/signin` was 200. The exception cause was not established and is not treated as a service failure.
- The unauthenticated admin status endpoint returned 401; no account was created. The Web release image does not expose OCI revision labels, so exact source revision remains `UNVERIFIED`.
- No standalone Worker success log exists in this runtime output. Worker success is supported by its actual resolved connection attempt, absence of the source-defined failure/retry/disconnect path over the observation window, and a successful live CDP handshake from the Web container; this distinction is retained for Reviewer assessment.

### EVIDENCE_ARTIFACTS_AND_PURPOSE
- This G1J entry: sanitized preflight, project-only start, running image identity, actual Worker/browser behavior, live CDP, service health, loopback exposure, resource stability, and object-isolation readbacks.
- G1J Handoff baseline: main blob `94500b8104af5405a56ac710d72da6acedf12eee`. Prior accepted G1I Evidence baseline: blob `c300dc5d422cbbcbacc554a1bf8acdaf92e2a531`. Governance: `entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7 blob `3917c88a7f36df7a53758b3879a92703d659ef9d`.
- Official upstream source references: browser implementation blob `96192428e232c375680d989a49abb58bb897a6fb`; crawler worker blob `c0b08c04d468c3942e2a39907612ba752595300a`; admin router blob `393114942bd4cc1c6778d12489068db6215d767f`; official Compose blob `865bb147cef972926d5dc32e50645876fd110555`.
- Raw logs, IP address, WebSocket debugger URL, Secret values/hashes, environment values, proxy endpoints, credentials, and unrelated project details are excluded.

### ROLLBACK_EFFECT
No rollback was required because the observed project health, Worker/CDP path, Web/login, exposure, and stability checks passed. Karakeep remains running at the loopback-only endpoint. If Reviewer later requires a stop, the documented target-only recovery is `docker compose -p karakeep-local down` without `-v`; it was not executed in G1J. Existing volumes, images, Compose, and .env remain available.

### RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT
Only three `karakeep-local` containers and one project network were created. Existing two project volumes and all three images were reused. No other container/project, proxy/system setting, external host port, user account, bookmark, or AI key was changed/created. Host memory varied as reported above; no OOM or restart occurred. No fixed RAM threshold was used.

### EXECUTOR_RESULT
`PASS_CANDIDATE` — G1J startup and runtime checks support that the real Karakeep Worker reached the browser connection path and the live Chrome CDP endpoint works. The three official services are running, Meilisearch and the sign-in page respond, only the Web UI is bound to loopback, and no restart/OOM instability was observed. Exact release source revision and an authenticated admin status read remain `UNVERIFIED`; no account was created. Keep Karakeep running at `http://localhost:3000`; stop here for independent Reviewer adjudication.

Executor-to-Reviewer relay:
结果：G1J `PASS_CANDIDATE`，项目保持运行。
改动：仅复用原 Compose/.env/密钥/三镜像/两卷启动 karakeep-local；无 pull、配置或系统代理变更。
验证：Worker 日志显示浏览器连接路径已解析且未进入失败/重试/断连路径；Web 容器只读 CDP 握手成功；Meilisearch health 200；根地址重定向至登录页且 `/signin` 为 200；三个服务运行、无重启/OOM、Web 仅 loopback 暴露。
问题：镜像 OCI revision 标签不可用；admin 状态路由因未注册/未登录返回 401；Worker 没有独立成功日志，具体证据限制已记录。
回滚：未执行，验收候选通过故保持服务运行；若 Reviewer 要求停止，仅使用项目级 down，不带 `-v`。
请 Reviewer 检查：核查 G1J Evidence，独立裁定浏览器依赖证据是否满足 Gate。
Owner 转交：Karakeep 保持运行，可访问 `http://localhost:3000`；不注册账户、不添加真实收藏，等待 Reviewer，不进入下一阶段。
