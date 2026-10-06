# VPN Network Optimization — REVIEWER HANDOFF

> Canonical branch: `main`  
> Architecture cutover: 2026-10-06  
> Active implementation: 3x-ui fast path  
> Legacy archive: `docs/archive/LEGACY_PROJECT_INDEX_2026-10-06.md`

## PROJECT_GOAL

On the Owner-selected DigitalOcean VPS, deploy three 3x-ui-managed nodes — Hysteria2, WireGuard, and VLESS + REALITY + XTLS Vision — then expose them through a Mihomo subscription for Clash Verge so the Owner can switch among the three paths locally.

## PROJECT_STAGE

```text
P0 Existing VPS read-only discovery              IN_PROGRESS
P1 3x-ui v3.9.0 unattended install              PENDING
P2 Create HY2 / WireGuard / REALITY inbounds     PENDING
P3 Generate/import Mihomo subscription           PENDING
P4 Three-node ChatGPT/OpenAI smoke               PENDING
P5 Minimal backup + seal                         PENDING
```

## SYSTEM_MAP

```text
Owner Windows host
└─ Clash Verge / Mihomo
   └─ one 3x-ui Mihomo subscription
      ├─ HY2          intended PRIMARY
      ├─ WireGuard    intended BACKUP_1
      └─ VLESS+REALITY+Vision intended BACKUP_2

DigitalOcean target
├─ hostname: ubuntu-s-1vcpu-512mb-10gb-sfo3
├─ region: SFO3
├─ public IPv4: 24.199.118.137
├─ private IPv4: 10.124.0.3
├─ Owner screenshot: Ubuntu 24.04 LTS x64
└─ historical host: may still contain old WG/HY2/REALITY runtime; current reality must be freshly read
```

## CURRENT_ACCEPTED_STATE

- Owner has selected the existing DigitalOcean droplet shown in the 2026-10-06 screenshot as the target.
- This target is the same historical VPS used by the legacy project, so it is **not fresh**.
- The legacy custom deployment chain is `LEGACY_REFERENCE_ONLY`; its runtime claims are not accepted as present truth.
- Current preferred implementation is 3x-ui stable release **v3.9.0**.
- Official 3x-ui supports VLESS+REALITY, WireGuard and Hysteria2, and provides a Mihomo subscription endpoint.
- Fastest intended execution after discovery is unattended 3x-ui installation plus API-driven inbound creation; GUI is fallback, not the default.
- Existing working VPN services must remain untouched until a replacement path has been proven.

## CURRENT_GATE

```text
GATE_ID=3XUI_FASTPATH_P0_EXISTING_VPS_DISCOVERY
STATE=REVIEWER_RELEASED_EXECUTOR_READONLY
TARGET=DigitalOcean_24.199.118.137_SFO3
MAX_ENDPOINT=READONLY_DISCOVERY_AND_EVIDENCE_ONLY
MANDATORY_REVIEW_STOP=YES
TARGET_MUTATION_ALLOWED=NO
SECRET_OUTPUT_ALLOWED=NO
OWNER_ACTION_REQUIRED=NONE_UNLESS_STRICT_SSH_UNAVAILABLE
NEXT_IF_PASS=P1_3XUI_STABLE_UNATTENDED_INSTALL
```

Canonical Gate: `docs/3X_UI_P0_EXISTING_VPS_DISCOVERY.md`.

## CRITICAL_CONSTRAINTS

- Do not stop/restart/edit existing VPN/network services in P0.
- Do not auto-accept SSH host-key drift.
- Do not read Secret-bearing config contents.
- Do not install/update packages in P0.
- No private keys/passwords/UUIDs/tokens/subscription IDs in chat, GitHub or ordinary logs.
- Preserve at least one working Owner network path throughout later migration.
- 512 MB RAM is treated as a resource fact to verify, not assumed sufficient; if needed, swap planning belongs to P1.

## DEFAULT_EXECUTION_CHANNEL

Local Codex/Executor using strict SSH to the selected VPS.

Expected Owner-local identity reference if present:
`C:\Users\34707\.ssh\digitalocean_ed25519`

Expected known-host file:
`C:\Users\34707\.ssh\known_hosts`

No private-key value may be copied into project artifacts.

## CURRENT_ROLLBACK_STATUS

P0 is read-only, so rollback is not applicable. Legacy services remain untouched.

## UNRESOLVED

- Actual current listeners/services on 443/TCP, 8443/UDP and 51820/UDP.
- Current RAM/swap headroom for 3x-ui + Xray and three inbounds.
- Whether existing old services should be preserved on their current ports while 3x-ui canaries use remapped ports.
- Whether public strict SSH trust already works from the Codex host.

## NEXT_STEP

Executor runs P0 only and returns sanitized Evidence. Reviewer then chooses the fastest safe P1 architecture:
- no-conflict direct install;
- install with alternate ports while old VPN stays live;
- or a narrow migration step if a real conflict exists.

## OWNER_ACTION_REQUIRED

**NONE** for P0 unless the existing SSH identity is locked/unavailable or strict trust fails and requires Owner intervention.

## EVIDENCE_POINTERS

- Active Gate: `docs/3X_UI_P0_EXISTING_VPS_DISCOVERY.md`
- Active plan: `docs/3X_UI_THREE_NODE_FASTPATH.md`
- Legacy archive: `docs/archive/LEGACY_PROJECT_INDEX_2026-10-06.md`
