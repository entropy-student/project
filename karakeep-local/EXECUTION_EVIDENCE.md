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
