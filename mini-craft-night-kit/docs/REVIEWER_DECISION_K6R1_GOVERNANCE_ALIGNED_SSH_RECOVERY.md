# Reviewer Decision — K6R1 Governance-Aligned SSH Recovery + Shared Infra Reuse

Date: 2026-09-23
Status: AUTHORIZED
Supersedes for current execution:
- docs/REVIEWER_DECISION_K6R1_SSH_TRANSPORT_DIAGNOSIS.md

Parent:
- K6_VPS_PRODUCTION_DEPLOYMENT
- Executor return 82962230c984767a65bbd675df2c2b9698cb5496

## Canonical governance read

Canonical governance source has been re-read from:

- entropy-student/spike.skill/vps-project-governance/SKILL.md
- references/SSH_AND_DELEGATED_SECRET_OPERATIONS.md
- references/TARGET_HOST_REALITY_CONTRACT.md
- references/STORAGE_LAYOUT_CONTRACT.md
- GOVERNANCE_HANDOFF.md

The current Shared VPS handoff was also re-read.

## Reviewer correction

The prior K6R1 diagnostic scope was broader than necessary.

The SSH transport contract was already validated on this shared host and must be reused rather than redesigned.

Canonical connection contract:

- remote: ops@2.24.193.133:22
- recorded identity reference: existing shared ops identity
- BatchMode=yes
- IdentitiesOnly=yes
- StrictHostKeyChecking=yes
- explicit known_hosts
- Docker access through sudo -n docker

The latest accepted Shared VPS factual refresh also records that this governed ops SSH path successfully completed a read-only production probe on 2026-09-19.

Therefore the 2026-09-23 pre-host-key close does NOT establish:
- host-key drift;
- identity/key drift;
- Shared VPS configuration drift.

It establishes only:

SSH_CONNECTION_REQUIRED / CURRENT_READ_ONLY_PROBE_UNAVAILABLE

## Governance classification

Use:

RETURN_SSH_CONNECTION_REQUIRED

for the current failed connection state unless a real presented host key mismatches the recorded pins.

Use:

RETURN_SSH_TRUST_DRIFT

only if a remote host key is actually presented and mismatches.

Do not classify a pre-host-key close as host-key drift.

## Current Gate

GATE=K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY

## Phase A — recover the already-approved connection contract

Do not redesign the connection layer.

1. Read the current Shared VPS handoff.
2. Verify locally, without reading private-key contents:
   - identity path exists;
   - public fingerprint matches recorded metadata;
   - known_hosts contains recorded target pins.
3. Run one canonical strict read-only SSH identity probe using exactly the recorded:
   - remote account/address/port;
   - identity;
   - known_hosts;
   - BatchMode=yes;
   - IdentitiesOnly=yes;
   - StrictHostKeyChecking=yes;
   - bounded ConnectTimeout/ServerAlive settings consistent with Governance.
4. No alternate account.
5. No new key.
6. No alternate trust policy.
7. No StrictHostKeyChecking=no/accept-new.
8. No authorized_keys/sshd/UFW/sudo change.

If the same remote pre-host-key close occurs again:
- do not loop or redesign the client stack;
- stop with RETURN_OWNER_HOSTINGER_CONSOLE_CHECK_REQUIRED.

Owner action must be one bounded failure domain:
- confirm VPS is Running in Hostinger;
- use Hostinger web/serial console if available to report:
  - ssh/sshd active/inactive;
  - port 22 listening/not listening;
  - any immediately visible provider/network block relevant to SSH.
- do not reboot or change firewall/sshd unless a later Reviewer Gate explicitly authorizes it.

If the canonical strict probe succeeds and the host key matches, continue Phase B in the same Gate.

## Phase B — bounded read-only Shared VPS continuity probe

Do not rerun full historical Shared VPS onboarding.

Reuse accepted PASS evidence unless fresh dynamic facts materially differ.

Read only the dynamic facts K6 needs:

- whoami / hostname / OS identity
- CPU/RAM/root disk headroom
- Docker/Compose version
- current container names/status
- current Docker networks
- current host-published ports
- current UFW summary
- current owner of 80/443
- current Caddy container/config source identity
- current cloudflared container/state
- /srv/apps, /srv/data, /srv/backups project namespace inventory
- Mini Craft path/container/network collision
- current health of unrelated existing projects sufficient to prove they are protected

Expected historical baseline is evidence, not a substitute for fresh dynamic facts:
- shared ops role
- Shared Caddy owns 80/443
- shared cloudflared exists
- project-isolated Compose resources
- Shared VPS /srv contract

If fresh facts materially contradict the accepted baseline:
RETURN_REVIEWER_SHARED_VPS_MATERIAL_DRIFT

Otherwise:
PASS_CANDIDATE_K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY

Stop at Reviewer. Do not deploy yet.

## Deployment architecture correction for later K6 phases

The following is now the preferred K6 architecture if Phase B confirms the current shared baseline.

### Reuse, do not rebuild

Reuse:
- existing Docker Engine / Compose
- governed ops SSH path
- /srv namespace contract
- existing Shared Caddy
- existing spikersun-edge network for the public HTTP-facing WordPress service when current topology confirms it
- existing log/backup/shared-host conventions

Do NOT:
- install a second Docker daemon/Compose
- create a second reverse proxy
- bind WordPress or MariaDB directly to public 80/443
- attach MariaDB to the shared edge network
- recreate shared networks
- replace Caddy/cloudflared
- create broad new firewall exposure

### Mini Craft project boundary

Preferred project namespace:

/srv/apps/mini-craft-night-kit
/srv/data/mini-craft-night-kit
/srv/backups/mini-craft-night-kit

Compose project:
mini-craft-night-kit

WordPress:
- project-local application service
- public-facing service may join existing spikersun-edge only after Reviewer-authorized Shared Infra membership change and current topology verification

MariaDB:
- project-local network only
- no host-published DB port
- never joins spikersun-edge

### Ingress

If current topology remains the accepted public-Caddy design:

Internet / Cloudflare DNS
→ shared Caddy on host 80/443
→ spikersun-edge
→ Mini Craft WordPress HTTP service

Do not invent a Mini Craft-specific cloudflared path merely because cloudflared exists for other/private/direct-tunnel routes.

If current topology differs, return to Reviewer rather than creating a second ingress design.

## Storage-governance gap to close before deployment

The Mini Craft K5 deployment manifest is not a substitute for the mandatory Shared VPS Project Storage Manifest.

Before any K6 project deployment write, create:

mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md

using the canonical Governance template.

It must freeze at least:
- apps path
- data path(s)
- backup path
- Compose project name
- WordPress/MariaDB persistent mounts
- database location/type
- uploads location
- secret locations as metadata only
- runtime access/permission metadata
- backup method
- restore method
- retention
- migration unit
- deletion/decommission boundary
- expected disk footprint
- anonymous durable volumes = NO
- cross-project durable-data sharing = NO

If these cannot be resolved:
RETURN_STORAGE_LAYOUT_UNRESOLVED

## Shared VPS Handoff maintenance

Do not rewrite Shared VPS truth while SSH is unavailable.

After strict SSH read-back succeeds, Shared Infrastructure Reviewer should refresh metadata only where proven, including:
- current last-verified date;
- canonical Governance addendum reference from SSH/Delegated Secret Operations rev1 to rev2;
- explicit provider-panel recovery route if verified;
- current container/network/ingress facts.

Do not change historical accepted facts merely for formatting.

## Global Governance decision

No vps-project-governance core/addendum change is required for this Mini Craft incident.

The canonical Governance already contains:
- connection recovery order;
- validated SSH transport reuse;
- Target Host Reality;
- no re-running accepted PASS without material drift;
- bounded diagnostic/Owner-operation minimization;
- Storage Layout Contract;
- Shared Infra/project isolation.

This incident is a project execution-alignment issue, not a missing global Governance rule.

## Return

GATE=K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY
RESULT=<PASS_CANDIDATE_K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY | RETURN_OWNER_HOSTINGER_CONSOLE_CHECK_REQUIRED | RETURN_SSH_CONNECTION_REQUIRED | RETURN_SSH_TRUST_DRIFT | RETURN_REVIEWER_SHARED_VPS_MATERIAL_DRIFT | RETURN_REVIEWER_*>
SUMMARY=
GOVERNANCE_SOURCE_READ=
SHARED_VPS_HANDOFF_READ=
IDENTITY_REFERENCE_CHECK=
PUBLIC_FINGERPRINT_MATCH=
KNOWN_HOSTS_PIN_CHECK=
SSH_CANONICAL_PROBE=
SSH_HOST_KEY_PRESENTED=
SSH_HOST_KEY_MATCH=
SSH_CONNECTION_CLASSIFICATION=
SHARED_VPS_DYNAMIC_PREFLIGHT=
REMOTE_USER=
HOSTNAME=
OS=
CPU_RAM_DISK=
DOCKER_VERSION=
COMPOSE_VERSION=
CURRENT_CONTAINERS=
CURRENT_NETWORKS=
CURRENT_HOST_PORTS=
CURRENT_80_443_OWNER=
UFW_STATE=
CADDY_STATE=
CLOUDFLARED_STATE=
SRV_NAMESPACE_INVENTORY=
MINICRAFT_COLLISION=
RESOURCE_HEADROOM=
EXISTING_PROJECTS_PROTECTED=
VPS_ACTIONS=0
DOCKER_ACTIONS=0
SHARED_INFRA_WRITES=0
OWNER_ACTION=<NONE | CHECK_HOSTINGER_CONSOLE>
EVIDENCE=
COMMIT=
NEXT=STOP_AT_REVIEWER

Do not deploy in this Gate.
