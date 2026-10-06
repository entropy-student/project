# VPN Network Optimization — Legacy Archive Index

Status: LEGACY_REFERENCE_ONLY  
Cutover date: 2026-10-06  
Active replacement: 3x-ui three-node fast path

## Archive rule

Everything in this project that predates the 3x-ui cutover is historical material unless an active post-cutover document explicitly references it.

That includes:

- the former WireGuard / Hysteria2 / VLESS+REALITY custom deployment workflow;
- all G1/G2/G3/G4 Gate chains;
- historical rollback/recovery runners and validators;
- Baidu recovery/provider experiments;
- Windows route, DPAPI, Mihomo and REALITY persistence experiments;
- historical `EXECUTION_EVIDENCE.md`;
- historical scripts under `scripts/`;
- historical docs under `docs/` other than the active post-cutover 3x-ui files.

These files are retained for audit, troubleshooting patterns and performance evidence only. They are **not executable current instructions**.

## Frozen historical snapshots

- `docs/archive/LEGACY_README_2026-10-06.md`
- `docs/archive/LEGACY_REVIEWER_HANDOFF_2026-10-06.md`
- `docs/archive/LEGACY_EXECUTOR_HANDOFF_2026-10-06.md`
- `docs/OWNER_PAUSE_SEAL_2026-10-06.md`

## Historical facts worth retaining

- HY2 performed better than WireGuard in one accepted same-window test.
- VLESS + REALITY + Vision interoperability was proven.
- Clash/Mihomo was proven usable as the common Windows control plane.
- The desired role order was HY2 primary, WireGuard backup 1, REALITY backup 2.
- Secret values must never enter GitHub, ordinary logs or chat.

## Do not resume legacy Gates by default

Future work must not continue R19/R20/R21/R22 or the former G4-B recovery chain unless Owner explicitly reopens the legacy implementation.

The default path is now the 3x-ui fast path.
