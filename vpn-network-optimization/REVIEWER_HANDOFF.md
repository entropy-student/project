# VPN Network Optimization — REVIEWER HANDOFF

> Canonical branch: `main`
> Architecture cutover: 2026-10-06
> Active implementation: 3x-ui fast path
> Legacy archive: `docs/archive/LEGACY_PROJECT_INDEX_2026-10-06.md`

## PROJECT_GOAL

Deploy three 3x-ui-managed nodes on the Owner-selected fresh DigitalOcean VPS — Hysteria2, WireGuard, and VLESS + REALITY + XTLS Vision — then consume them through one Mihomo subscription in Clash Verge so the Owner can switch among all three locally.

## PROJECT_STAGE

```text
P0 Fresh VPS trust bootstrap + 3x-ui install      IN_PROGRESS
P1 Create HY2 / WireGuard / REALITY inbounds      PENDING
P2 Generate/import Mihomo subscription             PENDING
P3 Three-node ChatGPT/OpenAI smoke                 PENDING
P4 Minimal backup + seal                           PENDING
```

## SYSTEM_MAP

```text
Owner Windows host
├─ current live Internet/VPN path -> OLD VPS 24.199.118.137 (DO NOT MUTATE)
└─ Clash Verge / Mihomo
   └─ future one 3x-ui Mihomo subscription
      ├─ HY2                    intended PRIMARY
      ├─ WireGuard              intended BACKUP_1
      └─ VLESS+REALITY+Vision   intended BACKUP_2

Fresh DigitalOcean target
├─ hostname: ubuntu-s-1vcpu-512mb-10gb-sfo3
├─ region: SFO3
├─ public IPv4: 143.198.159.233
├─ private IPv4: 10.124.0.2
├─ Owner screenshot: Ubuntu 24.04 LTS x64
├─ plan: 1 vCPU / 512 MB / 10 GB
└─ created as new 3x-ui target
```

## CURRENT_ACCEPTED_STATE

- Owner replaced the prior existing-host target with fresh droplet `143.198.159.233`.
- The prior Gate `3XUI_FASTPATH_P0_EXISTING_VPS_DISCOVERY` is `SUPERSEDED_NOT_EXECUTED`.
- Old VPS `24.199.118.137` remains the Owner's current working VPN path and is outside mutation scope.
- Current stable 3x-ui target version is pinned to `v3.9.0`.
- SQLite is the default DB.
- Admin panel must be loopback-only after install; management is through strict SSH / tunnel / protected API.
- Target node set is HY2 / WireGuard / VLESS+REALITY+Vision.
- Legacy custom VPN implementation remains `LEGACY_REFERENCE_ONLY`.

## CURRENT_GATE

```text
GATE_ID=3XUI_FASTPATH_P0_FRESH_VPS_BOOTSTRAP_INSTALL
STATE=REVIEWER_RELEASED_EXECUTOR_P0
TARGET=DigitalOcean_143.198.159.233_SFO3
TARGET_FRESH=YES_OWNER_REPORTED
TARGET_OLD_VPS=24.199.118.137_OUT_OF_SCOPE
PINNED_3XUI_VERSION=v3.9.0
MAX_ENDPOINT=HOSTKEY_TRUST_BOOTSTRAP_THEN_INSTALL_AND_LOOPBACK_BIND
MANDATORY_REVIEW_STOP=YES
EXECUTOR_RELEASED=YES
OWNER_ACTION_REQUIRED=NONE
```

Canonical Gate: `docs/3X_UI_P0_FRESH_VPS_BOOTSTRAP_INSTALL.md`.

Target replacement decision: `docs/REVIEWER_DECISION_3XUI_TARGET_REPLACED_WITH_FRESH_DROPLET_2026-10-06.md`.

## CRITICAL_CONSTRAINTS

- Do not mutate old VPS `24.199.118.137`.
- First SSH trust on the new VPS must match an independently Owner-observed ED25519 SHA256 fingerprint.
- Do not auto-accept a host-key mismatch.
- Never emit panel username/password, API token, UUIDs, private keys or subscription IDs.
- Official installer output must be suppressed from automation capture because it prints generated credentials.
- `/etc/x-ui/install-result.env` remains root:root 0600 and its contents are not surfaced.
- Admin panel must not remain publicly bound.
- P0 creates no VPN inbounds.
- 512 MB is verified after install; no automatic swap/resource tuning in P0.

## DEFAULT_EXECUTION_CHANNEL

After host-key trust is released:

Local Codex/Executor -> strict SSH -> fresh VPS `143.198.159.233`.

Expected identity file:
`C:\Users\34707\.ssh\digitalocean_ed25519`

Expected known-host file:
`C:\Users\34707\.ssh\known_hosts`

## CURRENT_ROLLBACK_STATUS

Fresh target contains no accepted project/business data. A failed P0 may be repaired exactly or the fresh droplet may be destroyed/recreated after Reviewer decision. Old VPS remains the live fallback and is not part of rollback mutation.

## UNRESOLVED

- New VPS ED25519 SSH host-key fingerprint was independently relayed by Owner and recorded as `SHA256:KV23raBMofyz5I9FL9chXUR9yrX7V6ARUyhAS3awDRQ`.
- Whether the previously used DigitalOcean private key was attached to this new droplet is not yet proven.
- Actual fresh-target RAM/swap/runtime facts remain to be read after strict SSH.

## NEXT_STEP

Executor now runs the complete released P0 Gate. It must verify the fetched ED25519 key against `SHA256:KV23raBMofyz5I9FL9chXUR9yrX7V6ARUyhAS3awDRQ`, establish explicit known-host trust, then install and verify pinned 3x-ui v3.9.0. No further Owner work unless SSH private-key access itself is unavailable.

## OWNER_ACTION_REQUIRED

**NONE.**

The one-time host-key fingerprint relay is complete. Wait for Executor P0 completion unless it returns a precise Owner-only SSH-key availability issue.

## EVIDENCE_POINTERS

- Active Gate: `docs/3X_UI_P0_FRESH_VPS_BOOTSTRAP_INSTALL.md`
- Target decision: `docs/REVIEWER_DECISION_3XUI_TARGET_REPLACED_WITH_FRESH_DROPLET_2026-10-06.md`
- Active plan: `docs/3X_UI_THREE_NODE_FASTPATH.md`
- Legacy archive: `docs/archive/LEGACY_PROJECT_INDEX_2026-10-06.md`
