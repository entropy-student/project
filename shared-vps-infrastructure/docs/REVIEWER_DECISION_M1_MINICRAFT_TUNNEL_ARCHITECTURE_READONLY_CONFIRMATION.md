# Reviewer Decision — M1 Mini Craft Tunnel Architecture Read-only Confirmation

Date: 2026-09-29  
Role: Reviewer / Architect / Gatekeeper

## Governance loading

Before opening this Gate, Reviewer re-read the complete canonical `entropy-student/spike.skill/vps-project-governance` tree, including:

- `GOVERNANCE_HANDOFF.md`
- `SKILL.md`
- `README.md` / `README_EN.md`
- `metadata.yml`
- core `GOVERNANCE_V0_1_6.md`
- all active operational addenda:
  - Governance Source Policy rev1
  - Storage Layout Contract rev1
  - SSH / Delegated Secret Operations rev2
  - Target Host Reality Contract rev2
  - Production Provider Canary and Recovery Contract rev2
  - Project Closeout and Workstation Hygiene Contract rev1
- `USAGE_SCENARIOS.md`
- all five current templates
- the historical promoted Closeout candidate proposal

Canonical Governance remains GitHub latest. No Reviewer pin/override changes the active rules for this Gate.

## Owner direction

Owner wants the Shared VPS cleanup to proceed in two major stages:

1. safely migrate Mini Craft from its current direct DNS-A -> shared Caddy ingress to the same reusable Tunnel pattern used by the Shared VPS where technically appropriate;
2. only after that migration is stable, decide and execute any cleanup/decommission work for the remaining VPS assets.

Unified Pay cleanup is intentionally deferred until after the Mini Craft ingress migration is stable.

## Governance classification

The desired change touches:

- shared cloudflared / Tunnel routing;
- Cloudflare DNS;
- shared Docker network membership;
- the current shared Caddy route / host 80/443 rollback path.

Therefore this is a **Shared Infrastructure Change**, not a project-local Mini Craft edit.

Per Governance v0.1.6, the business project must not silently mutate Shared Infra. The migration is governed from `shared-vps-infrastructure` and uses Mini Craft only as the affected application/runtime.

Mini Craft K9 remains accepted and is **not reopened**.

## Current accepted baseline

```text
HOST=srv1970241
VPS_HEALTH=PASS
DISK_PRESSURE=NO

MINI_CRAFT_STAGE=PUBLIC_PLATFORM_OPERATIONAL_PRECOMMERCE
MINI_CRAFT_K9_CLOSEOUT=PASS
MINI_CRAFT_RUNTIME=WORDPRESS+MARIADB_HEALTHY
REAL_COMMERCE_ENABLED=NO
SOFT_LAUNCH_AUTHORIZED=NO

CURRENT_MINICRAFT_PUBLIC_PATH=
Cloudflare DNS-only A
-> 2.24.193.133
-> shared Caddy :80/:443
-> wordpress:80

CURRENT_CADDY_HOST=minicraft.spikersun.com
CURRENT_CADDY_UPSTREAM=wordpress:80
CURRENT_WORDPRESS_SHARED_NETWORK=spikersun-edge

CLOUDFLARED=RUNNING
CLOUDFLARED_LOCAL_MODE=TOKEN_MANAGED
CLOUDFLARED_SHARED_NETWORK=spikersun-private

DUJIAO_INGRESS=CLOUDFLARE_REMOTE_MANAGED_TUNNEL_LIKELY_UNVERIFIED
UNIFIED_PAY_INGRESS=CLOUDFLARE_REMOTE_MANAGED_TUNNEL_LIKELY_UNVERIFIED
```

Historical K6 evidence proves the current Caddy route was deliberately created with rollback controls. It must remain the rollback path until a Tunnel cutover is independently validated.

## M1 Gate

```text
CURRENT_GATE=M1_MINICRAFT_TUNNEL_ARCHITECTURE_READONLY_CONFIRMATION
CURRENT_GATE_STATUS=AUTHORIZED_READONLY_ONLY
```

### Goal

Determine the exact safest target architecture and freeze the later mutation plan **without changing any runtime or control plane**.

The preferred hypothesis to verify is:

```text
Internet
-> Cloudflare Tunnel
-> existing cloudflared
-> spikersun-private
-> Mini Craft WordPress
```

This is a hypothesis, not yet an accepted target.

M1 must compare it with any proven existing Shared VPS Tunnel pattern, especially Dujiao.

### Allowed

Read-only only:

- target-host identity and resource continuity;
- Docker container/network/alias inspection;
- Mini Craft current Compose source/rendered topology;
- shared Caddy current config/readback;
- cloudflared container metadata with token value fully suppressed;
- public DNS/HTTP/TLS probes;
- authenticated Cloudflare Dashboard **read-only** route inspection if a session is already available;
- current Dujiao Tunnel hostname -> service mapping if safely readable;
- collision/reference analysis for adding Mini Craft WordPress to `spikersun-private`;
- rollback-plan design;
- documentation/Evidence updates.

### Forbidden

No:

- DNS create/edit/delete;
- Tunnel/Public Hostname create/edit/delete;
- cloudflared restart/recreate/config change;
- Caddyfile write/reload/restart/recreate;
- Docker network connect/disconnect/create/delete;
- Compose/app changes;
- WordPress/MariaDB writes;
- payment/provider/webhook actions;
- Secret/token/cookie/session value read or output;
- broad cleanup/prune;
- Unified Pay shutdown/deletion;
- Xianyu cleanup.

## Required questions

M1 must answer with fresh evidence:

1. What exact Docker networks does Mini Craft WordPress currently join?
2. What exact aliases does it expose on each network?
3. Is `spikersun-private` externally declared / reusable by project Compose, and can Mini Craft join it without recreating/modifying the network?
4. Would adding alias `wordpress` to `spikersun-private` collide with any existing DNS alias/service name?
5. What networks does `cloudflared` currently join?
6. Is current cloudflared remote-managed token mode confirmed without reading the token?
7. If authenticated Cloudflare route metadata is available, what exact service target does `shop.spikersun.com` use?
8. Does Dujiao prove the pattern `Tunnel -> cloudflared -> spikersun-private -> app alias`, or is another ingress component involved?
9. What is the fresh current Mini Craft DNS record type/value/proxy state?
10. What is the fresh current Caddy Mini Craft route and rollback source?
11. Can a temporary Tunnel canary hostname be used without changing the canonical WordPress site URL, and if so what Host-header/origin override would be required?
12. Which migration plan provides the smallest rollback domain?

## Architecture result

Return exactly one:

```text
TARGET_ARCHITECTURE=DIRECT_TUNNEL_TO_MINICRAFT_APP
TARGET_ARCHITECTURE=TUNNEL_TO_CADDY
TARGET_ARCHITECTURE=OTHER_REVIEW_REQUIRED
TARGET_ARCHITECTURE=UNRESOLVED
```

Do not select a target based only on preference; selection must follow evidence.

## Read-only Cloudflare boundary

If exact remote Tunnel route metadata is necessary but no already-authenticated Cloudflare session/control path is available:

```text
RETURN_OWNER_CLOUDFLARE_READONLY_SESSION_REQUIRED
STOP_AT_REVIEWER=YES
```

Do not ask the Owner for credentials in chat. Do not attempt credential discovery.

## Success

```text
PASS_CANDIDATE_M1_MINICRAFT_TUNNEL_ARCHITECTURE_READONLY_CONFIRMATION
STOP_AT_REVIEWER=YES
```

Success requires a frozen architecture recommendation, exact later mutation units, exact rollback sequence, and zero runtime/control-plane writes.

M1 PASS does **not** authorize M2 migration.
