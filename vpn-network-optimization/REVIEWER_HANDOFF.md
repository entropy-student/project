# VPN Network Optimization — REVIEWER HANDOFF

> Canonical branch: `main`
> Active implementation: 3x-ui fast path
> Legacy archive: `docs/archive/LEGACY_PROJECT_INDEX_2026-10-06.md`

## PROJECT_GOAL

Deploy three 3x-ui-managed nodes on fresh DigitalOcean VPS `143.198.159.233` — Hysteria2, WireGuard, and VLESS + REALITY + XTLS Vision — then consume them through one Mihomo subscription in Clash Verge so the Owner can switch among all three locally.

## PROJECT_STAGE

```text
P0 Fresh VPS trust bootstrap + 3x-ui install      PASS
P1 Contain subscription + create 3 inbounds       IN_PROGRESS
P2 HTTPS Mihomo subscription + Clash import       PENDING
P3 Three-node ChatGPT/OpenAI smoke                PENDING
P4 Minimal backup + seal                          PENDING
```

## SYSTEM_MAP

```text
Owner Windows host
├─ current live Internet/VPN -> OLD VPS 24.199.118.137 (DO NOT MUTATE)
└─ Clash Verge / Mihomo
   └─ future one 3x-ui Mihomo subscription
      ├─ HY2                    intended PRIMARY
      ├─ WireGuard              intended BACKUP_1
      └─ VLESS+REALITY+Vision   intended BACKUP_2

Fresh target 143.198.159.233 / SFO3
├─ Ubuntu 24.04 x64
├─ 1 vCPU / 512 MB / 10 GB
├─ 3x-ui v3.9.0 / SQLite
├─ admin panel 127.0.0.1:54912 only
├─ default subscription server currently *:2096
└─ no VPN inbounds yet
```

## CURRENT_ACCEPTED_STATE

### P0 formally accepted

P0 `3XUI_FASTPATH_P0_FRESH_VPS_BOOTSTRAP_INSTALL` is formally **PASS**.

Accepted facts:

- strict SSH trust and target identity proven;
- pinned 3x-ui v3.9.0 installed;
- SQLite active;
- install-result remains root:root 0600 and its contents were not surfaced;
- admin panel is loopback-only at `127.0.0.1:54912`;
- reserved ports 443/TCP, 8443/UDP and 51820/UDP remained free;
- x-ui service active;
- 458 MB RAM total / 210 MB available / 0 swap / 6276 MB root free;
- x-ui RSS about 90 MB;
- OOM kill counter zero;
- Secret output zero;
- old VPS untouched.

Formal decision:
`docs/REVIEWER_DECISION_3XUI_P0_FRESH_VPS_BOOTSTRAP_INSTALL_PASS.md`

### Subscription listener classification

Executor surfaced `*:2096`.

Reviewer verified against official 3x-ui v3.9.0:

- it is the separate subscription server, not the admin panel;
- default `subEnable=true`, `subPort=2096`, `subListen=all`;
- no client/Sub ID exists yet.

P1 must disable the subscription server **before** creating any client, so no future subscription credential/content becomes available over default HTTP. P2 owns secure HTTPS/Mihomo exposure.

## CURRENT_GATE

```text
GATE_ID=3XUI_FASTPATH_P1_THREE_INBOUNDS_SHARED_CLIENT
STATE=REVIEWER_RELEASED_EXECUTOR_P1
TARGET=DigitalOcean_143.198.159.233_SFO3
TARGET_OLD_VPS=24.199.118.137_OUT_OF_SCOPE
PINNED_3XUI_VERSION=v3.9.0
P0_FORMAL_PASS=YES
MAX_ENDPOINT=SUB_CONTAINMENT_SWAP_THREE_INBOUNDS_SHARED_CLIENT_ENABLE_READBACK
MANDATORY_REVIEW_STOP=YES
EXECUTOR_RELEASED=YES
OWNER_ACTION_REQUIRED=NONE
```

Canonical Gate:
`docs/3X_UI_P1_THREE_INBOUNDS_SHARED_CLIENT.md`

## CRITICAL_CONSTRAINTS

- Never mutate old VPS `24.199.118.137`.
- Before any client creation, contain default public subscription listener by setting `subEnable=false` through the local panel API and verify TCP/2096 closed.
- Admin panel remains loopback-only.
- Panel API token and all generated protocol Secrets stay in target process memory / protected target storage only.
- No Secret in command arguments, env vars, stdout/stderr, GitHub, Evidence or chat.
- Use only official 3x-ui v3.9.0 API/application paths; no direct SQLite edits.
- Create exactly three intended inbounds and one shared client.
- P1 leaves subscription server disabled.
- No Clash import or real traffic smoke until later Gates.

## DEFAULT_EXECUTION_CHANNEL

Local Codex/Executor -> strict SSH -> `143.198.159.233`.

Accepted identity:
`C:\Users\34707\.ssh\digitalocean_ed25519`

Accepted explicit known-host trust from P0 remains valid.

## CURRENT_ROLLBACK_STATUS

P0 installation is accepted baseline.

P1-created objects are new and exact:
- subscription setting change;
- optional project-owned 1 GiB swapfile;
- three new inbounds;
- one new shared client;
- one HY2 project-owned certificate/key.

If P1 partially fails, reconcile exact created IDs/paths before rollback or retry. Do not replay blindly. Old VPS is not part of rollback.

## UNRESOLVED

- P1 three inbound payload/runtime compatibility on this exact v3.9.0 install.
- REALITY scanner-selected target.
- HY2 self-signed certificate pin behavior through generated Mihomo config.
- WireGuard server/client key allocation on the fresh panel.
- final RAM headroom with all three listeners active.

## NEXT_STEP

Executor runs only P1. If PASS_CANDIDATE, Reviewer inspects three listeners, shared-client attachments, resource read-back, subscription containment and Secret boundary. Then P2 will securely expose a Mihomo subscription over HTTPS and import it into Clash Verge.

## OWNER_ACTION_REQUIRED

**NONE.**

## EVIDENCE_POINTERS

- P0 Evidence: `results/3XUI_FASTPATH_P0_FRESH_VPS_BOOTSTRAP_INSTALL_2026-10-06_EXECUTOR_R1.md`
- P0 formal PASS: `docs/REVIEWER_DECISION_3XUI_P0_FRESH_VPS_BOOTSTRAP_INSTALL_PASS.md`
- Active Gate: `docs/3X_UI_P1_THREE_INBOUNDS_SHARED_CLIENT.md`
- Active plan: `docs/3X_UI_THREE_NODE_FASTPATH.md`
- Legacy archive: `docs/archive/LEGACY_PROJECT_INDEX_2026-10-06.md`
