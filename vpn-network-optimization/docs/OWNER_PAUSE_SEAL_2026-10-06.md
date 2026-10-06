# VPN Network Optimization — Owner Pause / Seal 2026-10-06

Status: PAUSED_BY_OWNER / SAFE_RESUME_REQUIRED

## DECISION

Owner explicitly paused the project before running the released R1 read-only reality checkpoint.

No further Windows/VPS/Baidu/Clash/WireGuard/live-runner action is authorized under the previously released R1 checkpoint.

## TRUSTED RESUME ANCHORS

- Last trusted pre-R20 execution anchor: `85a33288c23e794d200ddf5e48d5bb7ae0d839c0` (R19R1)
- R1 helper/validator implementation candidate: `812f18980f9f10d22e2c8399e7022bcfe347c387`
- R1R1 release-contract repair PASS candidate: `903267dbb531ae56a68f742b12905eec9842d714`
- R1R1 formal Reviewer decision: `docs/REVIEWER_DECISION_G4B_TAKEOVER_REALITY_REBASE_READONLY_RELEASE_REPAIR_R1R1_PASS.md`
- BaiduPCS-Go lifecycle correction: `docs/REVIEWER_CORRECTION_G4B_R1_BAIDUPCS_EPHEMERAL_MODEL.md`

## CURRENT REALITY

`UNKNOWN_NOT_RECHECKED_AFTER_TAKEOVER`

The Owner did not run the R1 checkpoint. Therefore no current Windows/VPS/Baidu reality classification is accepted.

## RELEASE STATE

```text
R1_OWNER_READONLY_CHECKPOINT_RELEASED=NO
FRESH_LIVE_GATE_RELEASED=NO
OWNER_ACTION_REQUIRED=NONE
```

Any future resume requires a fresh Reviewer readback and a newly released Gate.

## LOCAL DATA RETENTION

The Git repository is durable in `main`; however, local untracked `results/` was repeatedly preserved and excluded from commits. It must be inspected before local repo deletion.

Do not treat the following as disposable Codex cache:

- SSH keys / known_hosts;
- Clash Verge / Mihomo profile and application state;
- WireGuard configuration / installed runtime state;
- `%APPDATA%\BaiduPCS-Go` persistent login/config state;
- `%LOCALAPPDATA%\vpn-network-optimization\runtime` and `recovery` until their contents are explicitly classified;
- any retained rollback journal or recovery evidence.

A Codex worktree/repo clone may be deleted only after confirming no wanted untracked files remain locally.

## RESUME

On resume, read current `REVIEWER_HANDOFF.md` and this seal decision first. Do not automatically continue historical R20-R22 Gates or the previously released R1 checkpoint.
