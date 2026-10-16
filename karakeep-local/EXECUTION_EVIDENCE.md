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
