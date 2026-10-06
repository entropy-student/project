# 3x-ui Three-Node Fast Path

Status: ACTIVE  
Gate: `3XUI_FASTPATH_P0_INSTALL`

## Goal

Use one fresh VPS and 3x-ui as the server control plane, then use one Mihomo subscription in Clash Verge on Windows.

Target nodes:

1. Hysteria2 — intended primary
2. WireGuard — backup 1
3. VLESS + REALITY + XTLS Vision — backup 2

## Active flow

```text
P0  Fresh VPS preflight + install 3x-ui
P1  Create HY2 / WireGuard / VLESS+REALITY inbounds
P2  Create one subscription identity and obtain /mihomo/<sub-id>
P3  Import subscription into Clash Verge
P4  Manually switch each node and verify ordinary ChatGPT/OpenAI browsing
P5  Save minimal panel/database backup + seal
```

## P0 acceptance

- fresh VPS identity and OS recorded;
- 3x-ui installed from the official MHSanaei/3x-ui installer;
- x-ui service active;
- panel reachable;
- generated username/password/access path kept Owner-local and not committed or pasted into chat;
- no legacy custom VPN scripts deployed on the new VPS.

## Ports

Initial planned ports:

- REALITY: TCP/443
- Hysteria2: UDP/8443
- WireGuard: UDP/51820

If the VPS already uses one of these ports, stop and reconcile before creating inbounds.

## Secret rule

Panel credentials, UUIDs, REALITY private keys, HY2 passwords and WireGuard private keys remain Owner-local.

Only sanitized state is returned to Reviewer.

## Subscription target

Clash Verge / Mihomo should use the 3x-ui Mihomo subscription endpoint:

`/mihomo/<sub-id>`

Do not build a hand-maintained merged YAML unless the subscription output proves insufficient.

## Legacy boundary

All pre-cutover custom deployment material is historical reference only. See `docs/archive/LEGACY_PROJECT_INDEX_2026-10-06.md`.
