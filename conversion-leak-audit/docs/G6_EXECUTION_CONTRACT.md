# G6 — VPS Onboarding + Storage Execution Contract

Date: 2026-09-23
Status: READY_FOR_EXECUTOR
Precondition: PASS_G5_FULL_FIX_QUEUE_LLM_DOGFOOD

## Goal

Freeze and verify the project-specific VPS landing zone **before** private application deployment.

G6 is infrastructure onboarding + storage only.

G6 does not deploy the Conversion Leak Audit application stack for service use and does not expose any public route.

## Canonical project paths

The only project-owned VPS roots are:

```text
/srv/apps/conversion-leak-audit
/srv/data/conversion-leak-audit
/srv/backups/conversion-leak-audit
```

Canonical future Compose path:

```text
/srv/apps/conversion-leak-audit/compose.production.yml
```

Canonical Compose project name:

```text
conversion-leak-audit
```

These paths must not be shared with another project.

## Shared-infrastructure hard boundary

The project MUST NOT modify:

- host SSH configuration;
- host firewall / UFW;
- Docker daemon configuration;
- shared reverse proxy;
- shared tunnel / cloudflared;
- shared 80/443 ownership;
- DNS;
- shared Docker networks;
- other projects' Compose stacks;
- other projects' application/data/backup directories;
- host-wide cron/systemd units unless a future Shared Infra Gate explicitly authorizes them.

Read-only inspection of shared infrastructure is allowed when needed to prove isolation or avoid port/path conflicts.

If G6 requires a shared-infrastructure mutation, return:

`RETURN_G6_SHARED_INFRA_CHANGE_REQUIRED`

and STOP_AT_REVIEWER.

## G6A — Target VPS identity + read-only preflight

Before any remote write, prove that the SSH session is on the intended shared VPS.

Record read-only evidence for:

- hostname;
- OS / version;
- kernel;
- uptime;
- CPU count;
- memory total/available;
- root filesystem and `/srv` capacity/free space;
- Docker version;
- Docker Compose version;
- running containers;
- current host published ports;
- current 80/443 owner;
- existing `/srv/apps`, `/srv/data`, `/srv/backups` structure;
- whether the three Conversion Leak Audit project roots already exist;
- current permissions/owners for those roots if they exist.

Do not publish authentication material or private keys in Git/evidence.

If host identity is ambiguous or expected shared infrastructure cannot be safely identified:

`RETURN_G6_TARGET_VPS_UNRESOLVED`

and STOP_AT_REVIEWER.


## Owner approval checkpoint before any VPS write

Owner instruction: before any formal deployment or any write to the VPS, Executor must stop, report the intended write plan, and wait for explicit Owner approval.

Therefore G6 is split into:

```text
read-only VPS preflight
→ report target/resource/path/port/storage plan
→ OWNER_APPROVAL_REQUIRED_BEFORE_REMOTE_WRITE
→ only after explicit Owner approval may project-owned /srv paths or restore canaries be created
```

Before Owner approval, allowed remote actions are read-only only.

Forbidden before approval:
- mkdir/chown/chmod/touch/write under /srv;
- Docker canary creation;
- backup/restore test writes;
- copying Compose/assets to VPS;
- Secret-file creation;
- any deployment action.

Required return before the first write:

`RETURN_G6_OWNER_APPROVAL_REQUIRED_BEFORE_VPS_WRITE`

with:
- target VPS identity;
- proposed project paths;
- proposed resource budget;
- proposed private ports;
- exact categories of remote writes;
- confirmation that shared infrastructure will remain untouched.

After explicit Owner approval, resume the same G6 Gate.

## G6B — Resource budget

G6 must record a project resource budget before G7 deployment.

Do not invent a budget without evidence.

Use:
- current VPS headroom;
- current shared workloads;
- existing local/runtime evidence for WordPress, MariaDB and Scanner/Chromium;
- safety margin for shared-host coexistence.

Freeze at minimum:
- expected steady-state memory budget;
- allowed burst memory;
- expected CPU ceiling / operational assumption;
- minimum free-disk reserve after project data/backups;
- backup storage budget;
- browser/Scanner concurrency assumption.

If the current host cannot safely accommodate the proposed private G7 stack without threatening existing workloads:

`RETURN_G6_RESOURCE_BUDGET_UNRESOLVED`

and STOP_AT_REVIEWER.

G6 must not solve resource pressure by stopping or shrinking another project.

## G6C — Project-owned directory layout

After preflight passes **and explicit Owner approval has been received**, G6 may create only project-owned paths.

Required structure:

```text
/srv/apps/conversion-leak-audit/
/srv/data/conversion-leak-audit/
  db/
  wordpress/
  scanner/
  secrets/
/srv/backups/conversion-leak-audit/
  scheduled/
  pre-change/
  restore-tests/
```

Rules:
- no anonymous durable Docker volumes for project state;
- no cross-project data mounts;
- no shared DB directory;
- no shared WordPress uploads directory;
- no shared Scanner state directory;
- no shared Secret directory;
- no shared backup directory.

Record owner/group/mode for every durable directory.

The `secrets/` directory is metadata/landing-zone only in G6. No production Secret value is required or permitted to be committed.

## G6D — Secret handling freeze

Create a project Secret manifest containing **names and purpose only**, never values.

At minimum account for future runtime categories:
- database application credential;
- WordPress runtime/admin bootstrap credential where required;
- WordPress salts/keys;
- optional G5 LLM provider endpoint/model/key;
- future payment Secrets remain explicitly deferred to G9.

Rules:
- Secret values never in Git;
- never in chat evidence;
- never in screenshots;
- never in Docker Compose source;
- never in world-readable files;
- runtime Secret files must use least-privilege permissions;
- no production Secret is required for G6 PASS.

Freeze an off-host encrypted recovery strategy for production Secrets/backups.

Actual off-host replication may remain deferred before production go-live, but the strategy/format/ownership must be documented.

## G6E — Compose isolation freeze

Create the production Compose design, but do not deploy the application in G6.

Repository source should contain a project-owned production Compose definition/template that:

- uses Compose project name `conversion-leak-audit`;
- defines project-local networks only;
- does not attach to a shared Docker network in G6;
- does not publish 80/443;
- does not expose MariaDB on a host port;
- bind-mounts durable data only from the canonical project data root;
- references Secret values via environment/Secret files, not literals;
- supports WordPress, database and Scanner as isolated services;
- preserves Scanner browser needs without privileged host access;
- does not use host networking;
- does not mount Docker socket;
- does not use privileged containers unless Reviewer explicitly reopens the contract.

G6 validation:

`docker compose -f <manifest> config`

or equivalent static validation only.

Do not run the application stack in G6.

## G6F — Private port plan for G7

G6 must freeze a private-deployment port plan without claiming shared ingress.

Rules:
- no 80/443;
- no wildcard `0.0.0.0` application bind;
- database has no host-published port;
- future WordPress/private app endpoint must be loopback-only;
- future Scanner host exposure, if any, must be loopback-only and only if integration architecture requires it;
- ports must be checked against current host listeners before freezing.

If a chosen port is occupied, choose another high loopback-only port and record it.

Do not change shared reverse proxy or tunnel in G6.

## G6G — Backup design

Freeze backup method for every durable category.

### MariaDB

Live database files must not be copied as the default consistency backup.

Required method:
- logical consistent dump using MariaDB-native tooling;
- compressed archive;
- integrity/readability check;
- stored under the project backup root.

### WordPress durable files

Backup the project-owned WordPress durable file set, excluding replaceable caches where appropriate.

### Scanner state

Backup the durable Scanner state using a consistency-safe method for the actual storage format.

For SQLite, use an SQLite-safe backup/quiesced method rather than assuming arbitrary live file copy is safe.

## G6H — Backup retention freeze

Record a retention policy for:

- scheduled backups;
- pre-change backups;
- restore-test artifacts.

The policy must be justified against measured free disk and estimated backup size.

Do not create a retention plan that can consume the shared VPS indefinitely.

Record:
- retention counts/windows;
- cleanup rule;
- minimum free-disk floor;
- action when the floor would be breached.

No host-wide scheduler is authorized in G6.

Scheduling mechanism may be documented for later private/production deployment.

## G6I — Restore exercise

G6 must prove that the documented restore process is executable **without deploying the product**.

Use disposable project-scoped canary data only.

Required:
- MariaDB consistency backup + restore canary in an isolated temporary container/project with no host ports;
- WordPress file backup + restore of a sentinel file into a disposable restore-test path;
- Scanner storage backup + restore canary appropriate to its storage format;
- verify restored values/checksums;
- destroy only disposable G6 canary containers/data after evidence is captured.

Canary runtime:
- no public ports;
- no shared network;
- no production data;
- no production Secret;
- no changes to other project containers.

If Docker canary activity would require shared-infrastructure mutation, STOP and return to Reviewer.

## G6J — Rollback design

Freeze the G7 rollback procedure before deployment.

At minimum:
- pre-change backup location;
- current/previous application revision reference;
- Compose configuration rollback;
- DB/file restore entry point;
- verification steps after rollback;
- explicit rule that rollback does not modify shared reverse proxy/80/443 in G7.

G6 does not need to execute an application rollback because the application is not yet deployed.

## G6K — Remote-write evidence

For every remote write in G6, evidence must prove it happened on the target VPS.

Record:
- target hostname;
- command category;
- exact project path affected;
- path readback/stat after write;
- before/after project-root tree;
- before/after running-container summary for any canary;
- confirmation that unrelated containers remained running.

Do not rely on a same-named local directory as proof of VPS writes.

## G6L — Required project documents

Create/update:

- `docs/PROJECT_STORAGE_MANIFEST.md`
- `docs/G6_VPS_PREFLIGHT.md`
- `docs/G6_BACKUP_RESTORE.md`
- `docs/G6_SECRET_MANIFEST.md`
- `docs/EXECUTION_EVIDENCE.md`
- `docs/EXECUTOR_HANDOFF.md`

The storage manifest becomes the canonical project storage contract after Reviewer PASS.

## G6M — Repository layout

Add project-owned deployment assets under a clear path such as:

```text
deploy/vps/
```

Recommended contents:
- production Compose source/template;
- environment example containing names/placeholders only;
- project-scoped backup scripts;
- project-scoped restore scripts;
- preflight/read-only helper if useful.

No Secret values.

## G6N — Regression

G6 must not change product behavior.

Required after repository edits:
- Scanner `55/55 PASS`;
- WordPress `20/20 PASS`;
- SEO readiness `44/44 PASS`;
- G4 browser regression PASS;
- G5 contract/browser regression PASS where affected by Compose/env changes.

No visual redesign.

## G6O — Forbidden

G6 must not:
- deploy WordPress/Scanner for service use;
- publish a public endpoint;
- modify Caddy/reverse proxy;
- modify cloudflared/tunnel;
- modify DNS;
- modify UFW/firewall;
- modify Docker daemon;
- take ownership of 80/443;
- attach to shared ingress network;
- enable payment;
- create payment Secrets;
- enable a real LLM provider Secret;
- run production migration;
- delete another project's data/backups;
- install a host-wide scheduler/service without Reviewer approval.

## Acceptance

Required:

```text
TARGET_VPS_PREFLIGHT=PASS
SHARED_INFRA_UNCHANGED=PASS
RESOURCE_BUDGET=FROZEN
PROJECT_PATHS=PASS
STORAGE_MANIFEST=FROZEN_CANDIDATE
SECRET_METADATA=PASS
COMPOSE_STATIC_VALIDATION=PASS
PRIVATE_PORT_PLAN=FROZEN
BACKUP_POLICY=FROZEN
MARIADB_RESTORE_CANARY=PASS
WORDPRESS_RESTORE_CANARY=PASS
SCANNER_RESTORE_CANARY=PASS
ROLLBACK_PLAN=FROZEN
REMOTE_WRITE_EVIDENCE=PASS
OUT_OF_SCOPE_VPS_WRITES=0
PUBLIC_PORTS_OPENED=0
PAYMENT_ACTIONS=0
PRODUCTION_SECRETS=0
```

If any canonical path, persistence category, restore method, Compose identity or resource budget remains unresolved:

`RETURN_STORAGE_LAYOUT_UNRESOLVED`

and STOP_AT_REVIEWER.

## Repository execution rule

Use a fresh project-scoped sparse workspace from latest `origin/main`.

Dedicated branch:

`codex/g6-vps-onboarding-storage`

All repository changes remain under:

`conversion-leak-audit/**`

Do not merge to main before Reviewer PASS.

## Owner intervention

Use existing authorized SSH configuration/agent if available.

Do not ask the Owner to paste passwords/private keys into chat or Git.

If SSH authorization is unavailable and cannot be obtained through the existing authorized setup, return:

`RETURN_G6_OWNER_SSH_AUTH_REQUIRED`

with no credential material.

## Candidate result

`PASS_CANDIDATE_G6_VPS_ONBOARDING_STORAGE`

Then `STOP_AT_REVIEWER`.

Reviewer alone declares final G6 PASS and releases G7.
