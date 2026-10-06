# VPN Network Optimization — REVIEWER HANDOFF

> Canonical branch: `main`  
> Architecture cutover: 2026-10-06  
> Legacy archive: `docs/archive/LEGACY_PROJECT_INDEX_2026-10-06.md`

## PROJECT_GOAL

Deploy one fresh VPS with 3x-ui and expose three nodes — Hysteria2, WireGuard, and VLESS + REALITY + XTLS Vision — through one Mihomo subscription imported into Clash Verge.

## CURRENT_GATE

```text
GATE_ID=3XUI_FASTPATH_P0_INSTALL
STATE=OWNER_FRESH_VPS_INSTALL
LEGACY_PROJECT_STATE=ARCHIVED_REFERENCE_ONLY
TARGET_CONTROL_PLANE=3x-ui
CLIENT_CONTROL_PLANE=Clash_Verge_Mihomo
TARGET_NODE_1=HYSTERIA2_UDP_8443
TARGET_NODE_2=WIREGUARD_UDP_51820
TARGET_NODE_3=VLESS_REALITY_VISION_TCP_443
AUTOMATION_SCOPE=MINIMAL
OLD_G4B_RELEASED=NO
OWNER_ACTION_REQUIRED=RUN_P0_FRESH_VPS_PREFLIGHT_AND_INSTALL
```

## CURRENT_PLAN

`docs/3X_UI_THREE_NODE_FASTPATH.md`

## P0 ACCEPTANCE

Reviewer needs only sanitized facts:

```text
VPS_HOSTNAME=<non-secret>
OS=<non-secret>
ARCH=<non-secret>
PORT_443_PREEXISTING=YES|NO
PORT_8443_PREEXISTING=YES|NO
PORT_51820_PREEXISTING=YES|NO
XUI_INSTALLED=YES
XUI_SERVICE_ACTIVE=YES
PANEL_REACHABLE=YES
PANEL_CREDENTIALS_EMITTED_TO_CHAT=NO
```

Do not return generated username/password/access credentials to chat. Owner keeps them locally.

## LEGACY RULE

All pre-cutover G1-G4 / R19-R22 / Baidu / custom runner material is historical reference only. It can be read for troubleshooting or prior measurements but must not be executed unless Owner explicitly reopens the legacy architecture.

## NEXT

P0 fresh VPS install, then P1 create three inbounds.

## OWNER_ACTION_REQUIRED

Run the P0 command set on the **new VPS only** and return the sanitized output.
