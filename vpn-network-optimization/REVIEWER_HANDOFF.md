# VPN Network Optimization — REVIEWER HANDOFF

> Maintainer: Reviewer only  
> Governance: `entropy-student/spike.skill/vps-project-governance` v0.2.6 / ACTIVE_PROVISIONAL  
> Canonical project state: this file. Detailed execution history/proof remains in `EXECUTION_EVIDENCE.md` and Git history.

## PROJECT_GOAL

建立一套可迁移、可验证、可回滚的自建 VPN 优化标准，重点改善 Codex / OpenAI / AI 生图等长任务的稳定性和尾部表现；当前 MVP 以 WireGuard 为生产基线，验证 Hysteria2 是否值得作为备用/增强通道。

## PROJECT_STAGE

```text
P0 Research / Scope                    PASS
G1 Foreground-safe Foundation          PASS
G2-A HY2 side-by-side deployment       PASS
G2-A DPAPI recovery closure            PASS
G2-B Safe-window WG vs HY2 validation  RETURN->DIAGNOSTIC
MVP v1 seal                            PENDING
```

## SYSTEM_MAP

```text
Windows Owner host
├─ Production: WireGuard adapter SFO2-A
│  └─ DigitalOcean sfo3 VPS 24.199.118.137
│     └─ Internet / OpenAI
├─ G2-B candidate path:
│  └─ localhost Mihomo test proxy :17890
│     └─ temporary ActiveStore /32 route via WLAN
│        └─ Hysteria2 UDP 8443 on same VPS
└─ Control path:
   └─ SSH through WireGuard to 10.66.21.1:22
```

Current known components:
- VPS: DigitalOcean `sfo3`, public IP `24.199.118.137`.
- Production VPN: WireGuard, active MTU 1420.
- Hysteria2: official v2.12.3, independent service on UDP 8443.
- Windows client: Clash Verge 2.5.6; Mihomo v1.19.31 / alpha-f103639 available.
- Owner execution runtime: PowerShell 7.6.6, Administrator, High integrity.
- Recovery: canonical DPAPI CurrentUser recovery artifact validated; do not re-fetch or rotate VPS Secrets.

## CURRENT_ACCEPTED_STATE

Latest accepted G2-B facts:
- WireGuard Windows strict WFP kill-switch was proven as the root cause of the prior HY2 TLS failure: production `0.0.0.0/0` plus WireGuard-owned `Block all outbound (IPv4)` dropped direct HY2 outer UDP before WLAN.
- Owner changed IPv4 full-tunnel routing to `0.0.0.0/1, 128.0.0.0/1`; fresh read-back showed `0.0.0.0/0=NO`, both split defaults present, and `Block all outbound (IPv4)=NO`.
- Post-repair raw UDP/8443 reached VPS successfully.
- Post-repair HY2 handshake passed: curl exit 0, HTTP 401 from the OpenAI endpoint, `HY2_AUTH=PASS`, `TLS_CERTIFICATE_PINNING=PASS`, `HY2_OUTER_ROUTE=WLAN_DIRECT`.
- Formal same-window comparison completed 60 WireGuard + 60 HY2 samples with zero failures/timeouts/resets on both.
- WireGuard: Median 0.796850s, P90 1.502720s, P95 1.735142s, P99 5.745878s, >1s 15, >1.5s 7, >2s 1.
- HY2: Median 0.498499s, P90 0.715330s, P95 0.761820s, P99 1.771594s, >1s 2, >1.5s 1, >2s 0.
- Deterministic comparison result: `HY2_BETTER_THIS_WINDOW`.
- `PEAK_HOUR_SUPERIORITY_PROVEN=NO`; do not generalize this one window into universal superiority.
- Cleanup passed: temporary route absent, Mihomo stopped, runtime Secret deleted, plaintext Secret artifacts 0, production WireGuard restored, test residue absent.
- Secret values emitted/committed: 0.

Accepted evidence commit from this review: pending current write.

## CURRENT_GATE

```text
GATE_ID=G2B_Windows_UDP8443_Egress_Probe
STATE=PASS
RESULT=ROOT_CAUSE_REPAIRED_AND_VALIDATED
NETWORK_COMPARISON=HY2_BETTER_THIS_WINDOW
PEAK_HOUR_SUPERIORITY_PROVEN=NO
MANDATORY_REVIEW_STOP=SATISFIED
```

### TARGET_AND_SCOPE

Closed. No further Windows/WFP/HY2 fault diagnostics are authorized or needed from this Gate unless contradictory evidence appears.

### REQUIRED_EVIDENCE

Satisfied:
- local WFP drop proven;
- WireGuard kill-switch ownership confirmed;
- split-default repair fresh-read back;
- UDP/8443 arrival after repair proven;
- HY2 TLS/auth/pinning handshake proven;
- 60/60 same-window WG and 60/60 HY2 benchmark completed;
- exact cleanup and WireGuard restoration proven;
- Secret values emitted/committed = 0.

### ACCEPTANCE_CRITERIA

PASS for this diagnostic/repair Gate.

The same-window network comparison is accepted as `HY2_BETTER_THIS_WINDOW`. It is not accepted as proof of peak-hour or universal superiority.

### ROLLBACK_STATUS_OR_PLAN

Current baseline is clean and restored. Diagnostic cleanup is mandatory.

### OWNER_ONLY_ACTIONS

**Owner standing authorization: GRANTED for this Gate until the current UDP/8443 egress fault is resolved.**

This standing authorization covers repeated bounded diagnostics and the smallest reversible repairs that stay inside `G2B_Windows_UDP8443_Egress_Probe`, including one-at-a-time HY2 handshake reproductions when diagnostically necessary.

It does **not** authorize:
- scope expansion into a different Gate/protocol/architecture;
- destructive or materially irreversible changes;
- purchases/provider billing changes;
- Secret disclosure/rotation unless separately required by a new Gate;
- disabling the production WireGuard control path;
- broad firewall/security weakening.

Reviewer should not ask Owner for repeated authorization for ordinary bounded troubleshooting inside this Gate.

### REVIEWER_TO_OWNER

- 本轮结果：**PASS**。Windows UDP/8443 故障根因已修复；HY2 握手通过；同窗口 60+60 对比完成。
- 当前状态：本 Gate 已关闭。该窗口内 HY2 在 Median/P90/P95/P99 和慢请求尾部计数上均优于 WireGuard，双方均 60/60 成功。
- 当前问题：没有残留故障。唯一未证明的是“晚高峰/长期/真实 Codex 工作负载下 HY2 仍持续更优”。
- 项目进度：G2-B 的同窗口网络对比已完成；README 所述最终 v1 若要求真实 Codex A/B，则应另开一个新 Gate，不应混入本 Gate。
- 下一步：Reviewer 建议先把 HY2 作为已验证候选保留，WireGuard 仍作为生产回退；如 Owner 要继续完成 v1 封板，再授权一个独立的真实 Codex / 晚高峰验证 Gate。
- 你需要做什么：当前无需做任何修复动作。

### REVIEWER_TO_EXECUTOR_RELAY

Current post-killswitch comparative checkpoint:
- `scripts/g2b-comparative-after-killswitch-repair.ps1`
- commit: `6fa3587eb2ccf303a0612d3d260b66207162fa56`
- blob: `c4ca11dbf8c55896cb45159199b1888296465fd5`
- outer checkpoint and internal runner/config fetches use GitHub Contents API; no raw.githubusercontent.com dependency;
- exact accepted runner/config blob SHA verification remains unchanged;
- formal runner invocation occurs exactly once without `-HandshakeOnly`;
- runner performs 60 WireGuard samples and 60 HY2 samples at 5-second spacing;
- HY2 still uses the exact temporary `/32` WLAN route and existing protected DPAPI Secret runtime boundary;
- cleanup removes temporary route/Mihomo/runtime secret material and verifies production WireGuard restoration.

Standing Owner authorization remains valid for this Gate. This is the final comparative validation after root-cause repair; do not reopen Windows/WFP diagnostics unless this run produces new contradictory evidence.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
Windows UDP8443：outbound YES/NO
握手：proxy_used / curl exit / HTTP status / error
验证：one handshake / no benchmark / observer stopped
回滚：route / Mihomo / runtime / WireGuard
Owner 转交：NONE / 最小必要动作
```

## CRITICAL_CONSTRAINTS

- Foreground Codex / image-generation work must not be disrupted.
- WireGuard remains production baseline until Reviewer accepts G2-B evidence.
- Hysteria2 is a candidate, not a predetermined winner.
- Secret values never leave the protected execution boundary.
- No live tuning before the protocol A/B is completed and reviewed.
- Accepted completed Gates are not replayed without proven material drift.

## DEFAULT_EXECUTION_CHANNEL

Owner-run elevated PowerShell 7.6.6 on the real Windows host for the consequential G2-B checkpoint. Reviewer/Executor prepare, inspect, persist non-secret Evidence, and review; Owner is not responsible for debugging/design.

## CURRENT_ROLLBACK_STATUS

```text
PRODUCTION_WIREGUARD=RESTORED
TEMPORARY_VPS_ROUTE=ABSENT
MIHOMO_TEST_PROCESS=ABSENT
TCP_17890_ROWS=0
UDP_17890_ROWS=0
RUNTIME_SECRET_CONFIG=ABSENT
PLAINTEXT_SECRET_RESIDUE=0
```

These are the latest accepted read-backs from the completed diagnostic/cleanup chain. A fresh runtime preflight is required before the next consequential retry.

## UNRESOLVED

- HY2 local proxy usage after the validator repair is proven (`proxy_used=1`); HY2 handshake/auth success is not proven.
- HY2 formal G2-B sample count is 0.
- WireGuard vs Hysteria2 performance/reliability conclusion remains UNKNOWN.
- MVP v1 protocol/config seal remains pending G2-B completion.

## NEXT_STEP

Pktmon all-component counters proved the synthetic UDP datagram is locally dropped at TCP/IPv4 L3/L4 before WLAN transmission. Confirm the WireGuard /0 kill-switch WFP filter read-only before repair.

## OWNER_ACTION_REQUIRED

**No further authorization needed for this read-only confirmation.** Keep WireGuard connected. Do not change kill-switch/firewall semantics yet.

## EVIDENCE_POINTERS

- `EXECUTION_EVIDENCE.md` — append-only execution proof.
- `EXECUTOR_HANDOFF.md` — Executor factual completion notes only; not canonical project truth.
- `scripts/g2b-owner-runner.ps1` — current repaired runner.
- Commit `9b730b81e751099fae7c4c3c61e8a5a5a755877d` — HY2 handshake validator return recorded.
- Commit `ed4f8216ecd18dcea29f06f12fa0773c97c3cdf4` — proxy-use validator repair.
- Commit `3c381726f38950579bceb0f258ba46cc83c68328` — diagnostic/repair evidence record.
- Commit `165fc79b906dd6de858fdb6c3521e95f7b749136` — proxy-use repair acceptance.
- Commit `e9cb20b9acfc3ffae30b27fe7d1cfd5b46181478` — latest Owner G2-B return persisted to Evidence.
- Commit `e683604b5c8e1e4a49af472d2b3e21cfeba6383b` — handshake/auth diagnostic Gate.
- Commit `dea461dcd25dd2497204f49c700cd05609634f04` — healthy HY2 server read-only state persisted.

Historical Reviewer narrative before this compact-dashboard takeover remains available in Git history. It is intentionally not duplicated here.
