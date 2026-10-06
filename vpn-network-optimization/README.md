# VPN Network Optimization — 3x-ui Fast Path

> Current architecture: **one fresh VPS + 3x-ui + one Mihomo subscription + Clash Verge**.

## Current goal

Build three manually switchable self-hosted nodes on one VPS:

| Role | Protocol | Planned port |
|---|---|---:|
| Primary | Hysteria2 | UDP/8443 |
| Backup 1 | WireGuard | UDP/51820 |
| Backup 2 | VLESS + REALITY + XTLS Vision | TCP/443 |

3x-ui is the server control plane. Clash Verge / Mihomo is the Windows client control plane.

## Active flow

```text
P0  Fresh VPS preflight + install 3x-ui          CURRENT
P1  Create HY2 / WireGuard / REALITY inbounds
P2  Generate one Mihomo subscription
P3  Import into Clash Verge
P4  Three-node manual ChatGPT/OpenAI smoke
P5  Minimal backup + seal
```

Current Gate: `3XUI_FASTPATH_P0_INSTALL`

Active plan: `docs/3X_UI_THREE_NODE_FASTPATH.md`

## Legacy boundary

The former custom WireGuard / HY2 / REALITY engineering project is **fully archived as historical reference**.

Do not resume its G1-G4 / R19-R22 / Baidu recovery / custom live-runner Gates by default.

Archive index:

`docs/archive/LEGACY_PROJECT_INDEX_2026-10-06.md`

Frozen snapshots:

- `docs/archive/LEGACY_README_2026-10-06.md`
- `docs/archive/LEGACY_REVIEWER_HANDOFF_2026-10-06.md`
- `docs/archive/LEGACY_EXECUTOR_HANDOFF_2026-10-06.md`

Historical scripts/docs remain in their original paths to preserve Git references, but they are `LEGACY_REFERENCE_ONLY`.

## Rules

- Never commit or paste panel passwords, UUID secrets, REALITY private keys, HY2 passwords or WireGuard private keys.
- Prefer the 3x-ui generated Mihomo subscription over maintaining merged YAML manually.
- Do not add extra automation until the three-node manual flow is proven.
- Do not modify an existing production VPS under the P0 fresh-VPS Gate.

## Historical performance facts retained

The old project proved enough to justify the new target mix:

- HY2 showed better tail performance than WireGuard in one accepted same-window comparison.
- VLESS + REALITY + Vision interoperability was proven.
- Clash/Mihomo was proven suitable as the common local control plane.

Those results are evidence only; they do not make the old deployment flow active again.
