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
P2 Secure Mihomo delivery + Clash-ready staging   PASS
P3 Clash import + three-node functional smoke     IN_PROGRESS
P4 Final cutover + minimal backup + seal          PENDING
```

## CURRENT_ACCEPTED_STATE

### P0 PASS
- strict SSH trust and target identity proven;
- 3x-ui v3.9.0 / SQLite installed;
- admin panel loopback-only at `127.0.0.1:54912`;
- old VPS untouched.

### P1 PASS
- exactly three enabled inbounds:
  - `SELF-HY2-SFO3` UDP/8443
  - `SELF-WG-SFO3` UDP/51820
  - `SELF-REALITY-SFO3` TCP/443
- one shared client attached to all three;
- HY2 certificate pinning enabled, insecure verification disabled;
- 1 GiB project-owned swap active;
- Xray healthy.

### P2 PASS

```text
DELIVERY_MODE=VALID_HTTPS_IP_SUBSCRIPTION
SUB_2096=TLS
HTTPS_CERT_NORMAL_VALIDATION=PASS
HTTPS_CERT_IP_SAN=PASS
CERT_AUTO_RENEW=PASS
PUBLIC_REAL_MIHOMO_STATUS=200
PUBLIC_RANDOM_SUB_NEGATIVE=PASS
PROXY_COUNT=3
MIHOMO_PROFILE_PARSE=PASS
WINDOWS_OWNER_ONLY_PROFILE=PASS
WINDOWS_OWNER_ONLY_SUB_URL=PASS
ACTIVE_CLASH_PROFILE_CHANGED=NO
SYSTEM_PROXY_CHANGED=NO
TUN_CHANGED=NO
WIREGUARD_BASELINE_CHANGED=NO
ROUTE_SNAPSHOT_CHANGED=NO
SECRET_VALUES_EMITTED=0
OLD_VPS_MUTATION=NO
```

Owner-only staged artifacts:
- `%LOCALAPPDATA%\vpn-network-optimization\3xui-fastpath\subscription.url`
- `%LOCALAPPDATA%\vpn-network-optimization\3xui-fastpath\self-vpn-3xui.yaml`

Formal P2 decision:
`docs/REVIEWER_DECISION_3XUI_P2_SECURE_MIHOMO_DELIVERY_PASS.md`

## CURRENT_GATE

```text
GATE_ID=3XUI_FASTPATH_P3_CLASH_IMPORT_THREE_NODE_SMOKE
STATE=REVIEWER_RELEASED_EXECUTOR_P3_INTERACTIVE
TARGET=143.198.159.233
P0_FORMAL_PASS=YES
P1_FORMAL_PASS=YES
P2_FORMAL_PASS=YES
OWNER_UI_INTERACTION_REQUIRED=YES_BOUNDED
LIVE_SERVER_MUTATION_ALLOWED=NO
OLD_VPS_MUTATION_ALLOWED=NO
EXECUTOR_RELEASED=YES
MANDATORY_REVIEW_STOP=YES
```

Canonical Gate:
`docs/3X_UI_P3_CLASH_IMPORT_THREE_NODE_SMOKE.md`

## P3 INTENT

- import the already-secure HTTPS remote subscription in Clash Verge;
- activate it with system proxy/TUN still OFF;
- manually select HY2, WG and REALITY one at a time;
- for each selection Executor sends exactly two explicit-Clash requests:
  - OpenAI `/v1/models` -> expected HTTP 401;
  - public IP -> must equal `143.198.159.233`;
- after all three PASS, restore the exact pre-P3 active Clash profile while keeping the new remote subscription imported.

No benchmark is required.

## CRITICAL_CONSTRAINTS

- system proxy remains OFF throughout P3;
- Clash TUN remains OFF throughout P3;
- old standalone WireGuard remains connected throughout P3 as rollback protection;
- no persistent route is added;
- no server protocol/config mutation in P3;
- subscription URL/Sub ID must not appear in chat/Git/Evidence;
- old VPS `24.199.118.137` may carry existing production traffic but must not be mutated;
- P3 intentional smoke traffic is capped at six requests.

## DEFAULT EXECUTION CHANNEL

Local Codex/Executor coordinates P3.

Owner participates only in the bounded Clash Verge GUI prompts emitted by Executor.

## CURRENT ROLLBACK STATUS

P0-P2 are accepted baseline.

On any P3 node failure:
- stop further node tests;
- restore pre-P3 active Clash profile;
- keep system proxy/TUN off;
- keep old WG connected;
- leave new subscription imported unless it is unsafe/corrupt;
- return sanitized failure for a narrow repair Gate.

## UNRESOLVED

- actual remote subscription import into running Clash Verge;
- actual visibility/selectability of all three nodes in the GUI;
- functional OpenAI/public-exit smoke for each of HY2, WG and REALITY;
- final cutover away from old standalone WireGuard belongs to P4.

## NEXT_STEP

Executor runs only P3 interactively and returns a sanitized completion packet. Reviewer decides PASS/RETURN, then releases P4 final cutover/seal.

## OWNER_ACTION_REQUIRED

**During the P3 Executor run only:** perform the exact Clash Verge GUI import/selector actions requested by Executor and enter its structured acknowledgements.

No VPS/Web Console action is required.

## EVIDENCE_POINTERS

- P2 Evidence: `results/3XUI_FASTPATH_P2_SECURE_MIHOMO_DELIVERY_2026-10-06_EXECUTOR_R1.md`
- P2 PASS: `docs/REVIEWER_DECISION_3XUI_P2_SECURE_MIHOMO_DELIVERY_PASS.md`
- Active Gate: `docs/3X_UI_P3_CLASH_IMPORT_THREE_NODE_SMOKE.md`
