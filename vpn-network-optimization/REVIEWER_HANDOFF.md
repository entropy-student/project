# VPN Network Optimization — REVIEWER HANDOFF

> Canonical branch: `main`
> Active implementation: 3x-ui fast path
> Legacy archive: `docs/archive/LEGACY_PROJECT_INDEX_2026-10-06.md`

## PROJECT_GOAL

Deploy three 3x-ui-managed nodes on fresh DigitalOcean VPS `143.198.159.233` — Hysteria2, WireGuard, and VLESS + REALITY + XTLS Vision — then consume them through one Mihomo-compatible delivery in Clash Verge so the Owner can switch among all three locally.

## PROJECT_STAGE

```text
P0 Fresh VPS trust bootstrap + 3x-ui install      PASS
P1 Contain subscription + create 3 inbounds       PASS
P2 Secure Mihomo delivery + Clash-ready staging   IN_PROGRESS
P3 Clash import + three-node smoke                PENDING
P4 Minimal backup + seal                          PENDING
```

## CURRENT_ACCEPTED_STATE

### P0 PASS

- strict SSH trust and target identity proven;
- 3x-ui v3.9.0 / SQLite installed;
- admin panel loopback-only at `127.0.0.1:54912`;
- old VPS untouched.

Formal decision:
`docs/REVIEWER_DECISION_3XUI_P0_FRESH_VPS_BOOTSTRAP_INSTALL_PASS.md`

### P1 PASS

Accepted live server state:

```text
TARGET=143.198.159.233
SWAP_TOTAL_MB=1023
SUB_ENABLE=NO
SUB_2096=CLOSED
HY2=SELF-HY2-SFO3 / UDP 8443 / enabled
WG=SELF-WG-SFO3 / UDP 51820 / enabled
REALITY=SELF-REALITY-SFO3 / TCP 443 / enabled
SHARED_CLIENT=owner-main
SHARED_CLIENT_ATTACHMENTS=3
SHARED_CLIENT_SUBID_PRESENT=YES
XRAY_RUNTIME_HEALTHY=YES
ADMIN_LOOPBACK_ONLY=YES
OOM_KILL_COUNTER=0
SECRET_VALUES_EMITTED=0
OLD_VPS_MUTATION=NO
```

HY2 has a pinned self-signed certificate with insecure verification disabled.
REALITY target was selected by the v3.9.0 feasibility scanner.
WireGuard server/client credentials were generated and retained only in protected target state.

Formal decision:
`docs/REVIEWER_DECISION_3XUI_P1_THREE_INBOUNDS_SHARED_CLIENT_PASS.md`

## CURRENT_GATE

```text
GATE_ID=3XUI_FASTPATH_P2_SECURE_MIHOMO_DELIVERY
STATE=REVIEWER_RELEASED_EXECUTOR_P2
TARGET=143.198.159.233
P0_FORMAL_PASS=YES
P1_FORMAL_PASS=YES
PREFERRED_DELIVERY=VALID_HTTPS_IP_SUBSCRIPTION
BOUNDED_FALLBACK=OWNER_LOCAL_STATIC_MIHOMO_SNAPSHOT
ACTIVE_CLASH_PROFILE_MUTATION_ALLOWED=NO
LIVE_TRAFFIC_SWITCH_ALLOWED=NO
EXECUTOR_RELEASED=YES
OWNER_ACTION_REQUIRED=NONE
MANDATORY_REVIEW_STOP=YES
```

Canonical Gate:
`docs/3X_UI_P2_SECURE_MIHOMO_DELIVERY.md`

## P2 INTENT

Preferred fast path:

1. use 3x-ui v3.9.0's official bare-IP Let's Encrypt short-lived certificate capability;
2. securely re-enable the Mihomo subscription server on HTTPS/2096;
3. fetch the shared client's three-node Mihomo profile without exposing Sub ID or credentials;
4. store the URL/profile under Owner-only local ACL outside Git;
5. parse the profile with the installed Clash Verge Mihomo binary;
6. do not activate or switch traffic yet.

If the single bounded IP-certificate attempt is unavailable, P2 may keep public subscription disabled and deliver one Owner-only static Mihomo snapshot instead.

## CRITICAL_CONSTRAINTS

- old VPS `24.199.118.137` is out of scope and must not be contacted;
- no Secret in Git/chat/Evidence/ordinary logs;
- admin panel remains loopback-only;
- no plaintext public subscription;
- no TLS verification bypass;
- no active Clash profile/selector/system-proxy/TUN/WireGuard/route mutation in P2;
- exactly three proxies must exist in the staged Mihomo profile;
- proxy order: HY2 -> WG -> REALITY -> DIRECT;
- P2 stops before import/activation.

## DEFAULT EXECUTION CHANNEL

Local Codex/Executor -> strict SSH -> fresh VPS, plus non-admin local Windows staging/read-only Clash baseline checks.

Owner-only local artifacts:
`%LOCALAPPDATA%\vpn-network-optimization\3xui-fastpath\`

## CURRENT_ROLLBACK_STATUS

P0 + P1 server state is accepted baseline.

If P2 HTTPS subscription setup fails acceptance, restore subscription disabled/TCP2096 closed while preserving the three inbounds/client/swap. If only Windows staging fails after valid server setup, leave the valid HTTPS server setup intact and return the local failure.

## UNRESOLVED

- whether Let's Encrypt IP short-lived issuance succeeds from this droplet/port-80 environment;
- generated Mihomo YAML exact compatibility with the Owner's installed Clash Verge Mihomo;
- final Clash import/activation and per-node real traffic are P3, not yet proven.

## NEXT_STEP

Executor runs only P2 and returns a sanitized completion packet. Reviewer then decides P2 PASS/RETURN and releases P3.

## OWNER_ACTION_REQUIRED

**NONE.**

## EVIDENCE_POINTERS

- P1 Evidence: `results/3XUI_FASTPATH_P1_THREE_INBOUNDS_SHARED_CLIENT_2026-10-06_EXECUTOR_R1.md`
- P1 PASS: `docs/REVIEWER_DECISION_3XUI_P1_THREE_INBOUNDS_SHARED_CLIENT_PASS.md`
- Active Gate: `docs/3X_UI_P2_SECURE_MIHOMO_DELIVERY.md`
- Legacy archive: `docs/archive/LEGACY_PROJECT_INDEX_2026-10-06.md`
