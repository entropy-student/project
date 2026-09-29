# M1-R1 — Target-host Access Recovery + Mini Craft Tunnel M1 Resume

## Gate

```text
M1_R1_TARGET_HOST_ACCESS_RECOVERY_AND_M1_RESUME
READ_ONLY_ONLY=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest and:

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M1_RETURN_R1_TARGET_HOST_ACCESS_RECOVERY.md
shared-vps-infrastructure/review-packets/M1_MINICRAFT_TUNNEL_ARCHITECTURE_READONLY_CONFIRMATION.md
```

Do not replay the failed browser-terminal attempt.

## Phase A0 — recover existing SSH contract

On the Owner workstation, check for the previously accepted local bootstrap handoff at:

```text
$HOME/Documents/ChatGPT/VPS基建/SHARED_VPS_HANDOFF.md
```

If absent:

```text
RETURN_SSH_CONNECTION_REQUIRED
STOP_AT_REVIEWER=YES
```

Read only connection/trust metadata from it. Never read or emit private-key contents.

Verify locally:

- recorded identity file exists;
- its public key file/fingerprint can be verified without private-key content;
- fingerprint equals canonical accepted:
  `SHA256:qFlRXelvzDEFpatrcX7T4dUBKPAC7YqFqNkyFZh5rYw`;
- normal `known_hosts` contains all three recorded target pins.

If any mismatch:

```text
RETURN_SSH_TRUST_DRIFT
STOP_AT_REVIEWER=YES
```

Do not modify `known_hosts`, keys or SSH config.

## Phase A1 — one strict target-host probe

Use the exact identity and normal known_hosts recovered above.

Required options include:

```text
BatchMode=yes
IdentitiesOnly=yes
StrictHostKeyChecking=yes
ConnectionAttempts=1
bounded ConnectTimeout
no agent forwarding
```

Exactly one initial strict SSH connection attempt.

Remote payload is read-only and must prove before sudo:

```text
whoami=ops
id -un=ops
UID != 0
hostname=srv1970241
```

Then bounded read-only privilege probe:

```text
sudo -n id -u
```

If SSH fails before target identity is proven, do not retry:

```text
RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
STOP_AT_REVIEWER=YES
```

If identity mismatches:

```text
RETURN_TARGET_HOST_IDENTITY_MISMATCH
STOP_AT_REVIEWER=YES
```

## Phase A2 — continue original M1 in the proven SSH session / bounded read-only path

After target identity passes, continue the original M1 requirements B-I.

At minimum produce fresh evidence for:

- Mini Craft WordPress/MariaDB networks and aliases;
- canonical Mini Craft Compose source/rendered network declarations;
- `spikersun-private` attachment inventory and alias collision analysis;
- cloudflared image/state/networks and remote-managed token mode without reading/emitting token value;
- Caddy Mini Craft route/upstream/rollback source;
- current Mini Craft public DNS/TLS/HTTP regression fingerprint;
- Dujiao Tunnel pattern using local evidence plus already-authenticated Cloudflare read-only route metadata if available;
- temporary Tunnel canary feasibility;
- one proposed target architecture;
- frozen M2 mutation units and reverse-order rollback.

If exact Cloudflare remote route metadata is essential and no authenticated read-only session exists:

```text
RETURN_OWNER_CLOUDFLARE_READONLY_SESSION_REQUIRED
STOP_AT_REVIEWER=YES
```

## Canonical Shared VPS handoff promotion data

If SSH succeeds, record in Evidence only the non-secret trust metadata needed for Reviewer promotion:

- identity-file reference;
- client public-key fingerprint;
- expected host-key fingerprints;
- known_hosts reference;
- last verified target identity/date.

Do not edit `SHARED_VPS_HANDOFF.md` yourself unless a later Reviewer decision explicitly delegates it.

## Hard forbidden

No:

- SSH key/known_hosts mutation;
- Hostinger/VPS write;
- DNS/Tunnel mutation;
- cloudflared restart/recreate;
- Caddy write/reload/restart/recreate;
- Docker network connect/disconnect/create/delete;
- Compose/application mutation;
- WordPress/MariaDB write;
- payment/provider/webhook action;
- Secret/token/session/private-key output;
- cleanup/prune;
- Unified Pay deletion;
- Xianyu cleanup.

## Result

Success:

```text
PASS_CANDIDATE_M1_R1_TARGET_HOST_ACCESS_RECOVERY_AND_M1_RESUME
TARGET_HOST_EXECUTION_PROVEN=PASS
TARGET_ARCHITECTURE=<one allowed M1 value>
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
CADDY_MUTATIONS=0
PROJECT_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

Otherwise return the first precise fail-closed reason and stop.
