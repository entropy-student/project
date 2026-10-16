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
