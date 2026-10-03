# VPN Network Optimization — REVIEWER HANDOFF

> Maintainer: Reviewer only  
> Governance: `entropy-student/spike.skill/vps-project-governance` v0.2.6 / ACTIVE_PROVISIONAL  
> Canonical project state: this file. Detailed execution history/proof remains in `EXECUTION_EVIDENCE.md` and Git history.

## PROJECT_GOAL

建立一套可迁移、可验证、可回滚的自建 VPN 优化标准，重点改善 Codex / OpenAI / AI 生图等长任务的稳定性和尾部表现；以 WireGuard 为当前生产/回退基线，验证 Hysteria2 是否值得进入最终 v1。

## PROJECT_STAGE

```text
P0 Research / Scope                         PASS
G1 Foreground-safe Foundation               PASS
G2-A HY2 side-by-side deployment            PASS
G2-A DPAPI recovery closure                 PASS
G2-B Safe-window WG vs HY2 validation       PASS
G2-C VLESS+REALITY side-by-side candidate  IN_PROGRESS
G3-A Network auto-adaptation + health       PENDING
G3-B VPS migration + rollback package       PENDING
G4 Peak-hour + real workload final validate PENDING
MVP v1 seal                                 PENDING
```

## SYSTEM_MAP

```text
Windows Owner host
├─ Current production / rollback: WireGuard adapter SFO2-A
│  ├─ IPv4 full coverage via 0.0.0.0/1 + 128.0.0.0/1
│  └─ DigitalOcean sfo3 VPS 24.199.118.137
│     └─ Internet / OpenAI
├─ Validated HY2 candidate path
│  └─ temporary localhost Mihomo proxy :17890
│     └─ temporary ActiveStore 24.199.118.137/32 via WLAN
│        └─ Hysteria2 UDP 8443 on same VPS
├─ Validated REALITY private interoperability path
│  └─ Windows Mihomo v1.19.31 client
│     └─ temporary Mihomo v1.19.31 VLESS+REALITY+Vision server on 10.66.21.1:14443
│        └─ one OpenAI request succeeded with expected HTTP 401
└─ Control path
   └─ SSH through WireGuard to 10.66.21.1:22
```

Current known components:
- VPS: DigitalOcean `sfo3`, public IP `24.199.118.137`.
- WireGuard: active MTU 1420; current IPv4 defaults are two `/1` routes, not `0.0.0.0/0`.
- WireGuard Windows strict WFP kill-switch: absent after the accepted G2-B repair.
- Hysteria2: official v2.12.3, independent service on UDP 8443.
- Windows client: Clash Verge 2.5.6; Mihomo v1.19.31 / alpha-f103639 available.
- Owner execution runtime: PowerShell 7.6.6, Administrator, High integrity.
- HY2 recovery: canonical DPAPI CurrentUser recovery artifact validated; do not re-fetch or rotate VPS Secrets.

## CURRENT_ACCEPTED_STATE

- G2-C read-only preflight passed: strict SSH path valid; TCP/443 free; WG/HY2 healthy; no existing sing-box/Xray/Mihomo server-core collision; NTP healthy; about 254 MiB MemAvailable and 6.69 GiB root free.
- G2-B root cause is closed: WireGuard Windows `0.0.0.0/0` strict WFP kill-switch blocked HY2 outer UDP before WLAN.
- Owner replaced IPv4 `0.0.0.0/0` with `0.0.0.0/1, 128.0.0.0/1`; fresh read-back proved both split defaults present and `Block all outbound (IPv4)` absent.
- Post-repair raw UDP/8443 reached the VPS.
- Post-repair HY2 handshake passed: curl exit 0, HTTP 401 from the OpenAI endpoint, `HY2_AUTH=PASS`, `TLS_CERTIFICATE_PINNING=PASS`, `HY2_OUTER_ROUTE=WLAN_DIRECT`.
- Formal same-window comparison completed 60 WireGuard + 60 HY2 samples with zero failures, zero timeouts, and zero resets on both.
- WireGuard: Median 0.796850s, P90 1.502720s, P95 1.735142s, P99 5.745878s, >1s 15, >1.5s 7, >2s 1.
- HY2: Median 0.498499s, P90 0.715330s, P95 0.761820s, P99 1.771594s, >1s 2, >1.5s 1, >2s 0.
- Accepted comparison: `HY2_BETTER_THIS_WINDOW`.
- Not yet proven: `PEAK_HOUR_SUPERIORITY_PROVEN=NO`.
- Cleanup passed: temporary /32 route absent, test Mihomo absent, runtime Secret config absent, plaintext Secret residue 0, production WireGuard restored.
- Secret values emitted/committed: 0.
- Accepted Evidence commit: `b85224370a295cc5128e29da9186573b81345d27`.
- G2-C REALITY diagnostics R1/R2 are accepted as **diagnostic-only** results: repeated private requests reproduced curl 35 / HTTP 0 / Mihomo TIMEOUT while private TCP, target TLS 1.3, cleanup, WG/HY2, and Windows baseline remained healthy.
- R2 protected sing-box trace capture was readable but yielded no allowlisted REALITY internal state markers; accepted classification is `UNKNOWN_AFTER_R2`.
- No VLESS+REALITY interoperability PASS exists yet; no public TCP/443 or persistent REALITY service has been authorized.
- R3 authorized retry returned `RETURN_G2C_R3_RUNNER_EXCEPTION_CLASSIFIER_FAILURE`: local empty-argument fixture PASS, but the runner's top-level catch referenced an unresolvable PowerShell exception type and masked the original failure.
- Post-run cleanup read-back PASS; current SFO2-A is Up on ifIndex 9 and the control route to `10.66.21.1` also uses ifIndex 9. The R3 runner's hardcoded ifIndex 13 invariant is therefore stale.
- Because the masked failure leaves request-count / REALITY-handshake state `UNKNOWN`, the previous one-request authorization is no longer safe to reuse for another real request.
- H1 local runner hardening is formally accepted from commit `2993756d41d0621471480ed2891c828d6674c7e6`: exception classification is non-throwing and fixture-proven, WireGuard ifIndex validation is dynamic, live SFO2-A/control-route consistency passed, and network/SSH/Secret activity was zero.
- H1 timing: estimated 10–20 minutes, actual 14m45s, no overrun.
- R4 private Mihomo-server B-side is formally accepted from commit `7e957ab9adbf59535a9c0ed548183051e7ebcf94`: one unchanged VLESS+REALITY+Vision request through Mihomo v1.19.31 server returned curl 0 / HTTP 401; classification `MIHOMO_SERVER_SUCCEEDED`.
- Implementation A/B conclusion: under the tested private path and unchanged client/protocol semantics, the server-core implementation difference is materially implicated; Mihomo v1.19.31 is the accepted REALITY server candidate for the next G2-C step. This does not prove a universal sing-box defect.
- R4 cleanup/read-back PASS: temporary client/server/runtime/binary removed, TCP14443/TCP443 absent afterward, WG/HY2 and Windows network baseline preserved, Secret emitted/committed 0.
- R4 timing: estimated 15–25 minutes, actual 9m38s, no overrun.


## CURRENT_GATE

```text
GATE_ID=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
STATE=AUTHORIZED
PREVIOUS_RESULT=PASS_G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R4
LAST_EXECUTOR_RESULT=RETURN_CANONICAL_GIT_ROOT_MISMATCH
RUNNER_PREPARATION_REVIEW=PASS_WITH_PROVENANCE_REPAIR_REQUIRED
RUNNER_COMMIT=4a4eae48dac1fd3c21638efb2dfe0fc6b69a4614
LAST_ATTEMPT_CONSEQUENTIAL_ACTION_STARTED=NO
REAL_OPENAI_REQUEST_BUDGET_CONSUMED=0_OF_1
OWNER_RUNTIME_RECONFIRMED=PowerShell_7.6.6_Administrator_High_RID_12288
EXECUTION_BLOCKER=RUNNER_CANONICAL_SOURCE_WORKTREE_ROOT_DISCOVERY_BUG
NEXT_REPAIR_GATE=G2C_P1_CANONICAL_SOURCE_WORKTREE_DISCOVERY_H1
OBJECTIVE=Prove the accepted Mihomo v1.19.31 VLESS+REALITY+Vision candidate over the intended public TCP/443 path, with no persistence and deterministic rollback.
MAX_ENDPOINT_THIS_ROUND=read-only current-state preflight + one temporary public TCP/443 Mihomo server + one temporary exact /32 outer-route bypass to the current physical egress + one proxied OpenAI HTTPS request + exact cleanup/read-back + Reviewer stop.
MANDATORY_REVIEW_STOP=YES
ESTIMATED_EXECUTION_TIME=20-30 minutes
```

### REVIEWER_ACCEPTANCE_OF_R4

Commit `7e957ab9adbf59535a9c0ed548183051e7ebcf94` is accepted as **PASS** for the private Mihomo-server implementation A/B.

Accepted Evidence:
- hardened local preflight PASS;
- pinned Mihomo v1.19.31 server asset/hash PASS;
- private listener/config PASS;
- exactly one authorized request;
- curl exit 0 / HTTP 401;
- `IMPLEMENTATION_AB_RESULT=MIHOMO_SERVER_SUCCEEDED`;
- no client/server error observed;
- exact cleanup and independent post-cleanup read-back PASS;
- WG/HY2 and Windows network baseline preserved;
- Secret values emitted/committed 0;
- estimate 15–25 minutes; actual 9m38s; no overrun.

Interpretation:
- Mihomo v1.19.31 is the accepted server implementation for the remaining G2-C REALITY candidate work.
- The A/B result materially implicates server implementation as the differentiating variable under this tested configuration.
- Do not generalize this into a universal sing-box incompatibility claim.
- No public TCP/443, persistence, production-default, or peak-hour conclusion exists yet.

### TARGET_AND_SCOPE

Public-path candidate:
- server core: Mihomo v1.19.31 native VLESS+REALITY;
- public endpoint: current VPS public IPv4 on TCP/443 only;
- client: Windows Mihomo v1.19.31;
- protocol semantics unchanged from R4: VLESS + REALITY + `xtls-rprx-vision`;
- SNI/server-name and REALITY handshake target unchanged from R4;
- local HTTP proxy remains an ephemeral localhost test proxy;
- exactly one proxied OpenAI request.

Outer-route requirement:
- because WireGuard remains the active full-coverage path, discover the current physical egress/interface/gateway at runtime;
- add one temporary exact `/32` route for the VPS public IPv4 through that physical egress so the REALITY outer TCP/443 connection does not hairpin through WireGuard;
- do not hardcode historical WLAN IP, gateway, or ifIndex;
- remove the exact route during cleanup and prove it is absent afterward.

No persistent server/service/client profile is created in P1.

### APPLICABLE_CRITICAL_CONSTRAINTS

- Public TCP/443 exposure is temporary, bounded, and Owner-only.
- No random alternate public port.
- No systemd persistence or boot enablement.
- No permanent firewall/routing/system-proxy/TUN changes.
- Do not stop/change WireGuard or HY2.
- Use the hardened runner failure handling and dynamic local-network invariants.
- Ephemeral REALITY/VLESS credential material remains protected and is destroyed after the canary; no values/hashes enter repo/chat/ordinary logs.
- Exactly one real OpenAI request after positive preflight.
- If the request starts, it is consumed regardless of outcome; Git reconciliation must not replay it.
- Cleanup includes the temporary public listener and the exact local `/32` route.

### PREFLIGHT

Before public exposure prove:
- real Owner Windows host is running PowerShell 7.6.6 with Administrator role and High integrity token;
- canonical Git/source provenance and project-scoped workspace;
- hardened local runner fixtures PASS;
- current physical egress/interface/gateway dynamically discovered and internally consistent;
- WireGuard SFO2-A/control route healthy;
- strict SSH trust and target VPS identity PASS;
- WG/HY2 healthy;
- TCP/443 has no pre-existing listener;
- no G2-C runtime residue;
- current host firewall/nftables/ufw state is read back without broad changes;
- current VPS public IPv4 identity matches accepted target;
- pinned Mihomo v1.19.31 asset/hash identity intact;
- rollback commands for exact public server process/runtime and exact `/32` route are prepared before mutation.

Any unexpected TCP/443 owner, firewall conflict, target mismatch, or physical-egress ambiguity => RETURN before exposure.

### REQUIRED_EVIDENCE

- preflight facts above;
- exact pre-mutation route state for VPS public IPv4;
- temporary exact `/32` physical-egress route added and selected for the VPS public IPv4;
- temporary Mihomo server config check PASS;
- positive public TCP/443 listener check on the intended public endpoint;
- negative check that private test port 14443 is not left listening;
- Windows public-endpoint TCP reachability PASS;
- exactly one proxied OpenAI request;
- curl exit / HTTP status / timing;
- sanitized client/server error classes;
- `PUBLIC_REALITY_INTEROPERABILITY=PASS | FAIL | UNKNOWN`;
- exact cleanup of client/server/runtime/binary;
- exact temporary `/32` route removed;
- TCP/443 listener absent after cleanup;
- WG/HY2 preserved; system proxy/TUN unchanged;
- Secret emitted/committed 0;
- timing record.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE_PUBLIC_CANARY requires:
- public TCP/443 path selected through the dynamically discovered physical egress;
- exactly one request returns curl 0 / HTTP 401;
- cleanup/read-back fully restores pre-Gate runtime state;
- no persistent/public residue remains.

A failure/ambiguity produces a precise RETURN and does not trigger retry.

### ROLLBACK_STATUS_OR_PLAN

Before mutation, preserve:
- existing WireGuard production path;
- active HY2 service;
- exact preexisting route/listener state.

Rollback:
- stop exact temporary Mihomo client/server processes;
- remove exact temporary runtime/config/binary paths;
- delete only the exact P1 `/32` route created by the Gate;
- verify TCP443 absent and WG/HY2/network baseline restored.

### OWNER_ONLY_ACTIONS

**AUTHORIZED.**

Owner authorization was granted on 2026-10-03 for this Gate only: one temporary public TCP/443 REALITY canary, one temporary exact `/32` physical-egress route, and one OpenAI request.

It does **not** authorize persistence, permanent firewall changes, benchmark, production-default changes, or more than one OpenAI request.

### REVIEWER_TO_EXECUTOR_RELAY

Start only from:
1. the current P1 Gate;
2. `scripts/g2c-reality-public-tcp443-canary-p1.ps1`, specifically `Assert-P1CanonicalSource`;
3. the accepted source-provenance Evidence that records both `CANONICAL_GIT_ROOT=C:\Users\34707\Documents\ChatGPT\VPS搭建` and `EXECUTION_WORKTREE=C:\Users\34707\.codex\worktrees\g2b-runner-binding-cleanup\VPS搭建`;
4. this Reviewer reconciliation of `RETURN_CANONICAL_GIT_ROOT_MISMATCH`.

Repair only canonical source/worktree discovery. Do not assume a fixed number of parent directories above `vpn-network-optimization`. Prefer asking Git from the actual project/script path for `rev-parse --show-toplevel`, then derive and validate the project-relative tracked paths against that returned root. Preserve strict origin allowlist, tracked-file checks, clean target-file checks, Gate authorization/budget checks, and fail-closed behavior. Add no-network fixtures covering the canonical checkout shape and the nested Codex worktree shape, plus a negative mismatched-root/path fixture. Do not run the P1 checkpoint, SSH, VPS preflight, route/listener/runtime mutation, Secret access, or OpenAI request. Persist Evidence + Executor Handoff, commit, fresh read-back, STOP_AT_REVIEWER.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE_PUBLIC_CANARY / RETURN_*
改动：仅临时开放 Mihomo REALITY public TCP/443，并为 VPS public IPv4 添加一次性动态 /32 物理出口路由。
验证：preflight + public 443 listener + one request + route/listener cleanup + WG/HY2 unchanged。
问题：PUBLIC_REALITY_INTEROPERABILITY=PASS / 精确 RETURN 原因。
回滚：临时 client/server/runtime/binary 与 exact /32 route 已清理；443 absent；生产网络恢复。
请 Reviewer 检查：REALITY 是否已在真实 public TCP/443 路径完成互操作。
Owner 转交：NONE。
耗时：预计 20-30 分钟；实际 <elapsed>；超时 YES/NO；原因 <NONE/brief cause>。
```

## ROUND_TIMING_OBSERVABILITY

Starting with the next Executor round, every Gate/round carries a Reviewer time estimate and Executor timing record.

Rules:
- Reviewer sets `ESTIMATED_EXECUTION_TIME` as a practical range for the whole Executor round, excluding deliberate waits requested from Owner (for example waiting until a peak-hour window).
- Executor records `ROUND_STARTED_AT`, `ROUND_FINISHED_AT`, and `ACTUAL_ELAPSED` in sanitized Evidence. Approximate phase timing may be added when it comes naturally from logs; do not add instrumentation that materially complicates the work.
- If `ACTUAL_ELAPSED` exceeds the estimate's upper bound, record `TIME_OVERRUN=YES` and a short `TIME_OVERRUN_CAUSE` classification supported by existing evidence.
- Timing overrun by itself is **not** a failure and does not stop otherwise healthy execution.
- Do not interrupt normal progress merely to investigate elapsed time. Diagnose at the next natural checkpoint or after completion unless there is an actual stall/no-progress condition.
- If the overrun cause is not already evident, perform only one bounded timing diagnostic focused on the slow phase (for example download, SSH, server start, client handshake, benchmark wait, Git persistence). Do not broaden into unrelated project debugging.
- A true stall means no meaningful phase progress for roughly 15 minutes beyond the expected phase behavior; a stall may trigger immediate bounded diagnosis.
- Executor completion packets add one line: `耗时：预计 <range>；实际 <elapsed>；超时 YES/NO；原因 <NONE/brief cause>`.
- Reviewer uses accumulated actual timings to adjust later round estimates; the timing task must never become a reason to delay the project by itself.

Current next Executor round:
```text
ROUND=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
ESTIMATED_EXECUTION_TIME=20-30 minutes
ESTIMATE_SCOPE=dynamic physical-egress preflight + temporary public TCP443 server + one request + exact route/listener cleanup + Evidence/Handoff persistence
OWNER_WAIT_EXCLUDED=YES
```

## CRITICAL_CONSTRAINTS

- Foreground Codex / image-generation work must not be disrupted.
- WireGuard remains the current production/rollback path until a later accepted Gate changes that role.
- HY2 is now the validated UDP/QUIC performance candidate; VLESS+REALITY is the frozen TCP/443 fallback candidate under G2-C; neither is yet the sealed production default.
- Current WireGuard routing intentionally uses two `/1` defaults; this removes the strict WireGuard Windows WFP kill-switch. Treat this as an explicit current security/runtime property.
- Secret values never leave the protected execution boundary.
- No BBR/fq/GRO/MTU or other live tuning is authorized merely because the protocol comparison passed.
- Accepted completed Gates are not replayed without proven material drift.

## DEFAULT_EXECUTION_CHANNEL

For future consequential Windows validation: Owner-run elevated PowerShell 7.6.6 on the real Windows host, with one bounded Reviewer-designed checkpoint and fail-closed cleanup/read-back.

## CURRENT_ROLLBACK_STATUS

```text
PRODUCTION_WIREGUARD=RESTORED
WG_IPV4_DEFAULTS=0.0.0.0/1,128.0.0.0/1
WG_STRICT_WFP_KILLSWITCH=ABSENT
HY2_SERVER=ACTIVE
HY2_PERSISTENT_CLIENT_DEFAULT=NOT_ENABLED
TEMPORARY_VPS_ROUTE=ABSENT
MIHOMO_TEST_PROCESS=ABSENT
RUNTIME_SECRET_CONFIG=ABSENT
PLAINTEXT_SECRET_RESIDUE=0
```

Rollback/recovery assets:
- WireGuard remains directly usable as the current path.
- HY2 server deployment and DPAPI recovery artifact remain available.
- G2-B temporary test artifacts were removed.

## UNRESOLVED

- VLESS+REALITY private interoperability is now proven with Mihomo v1.19.31. Public TCP/443 interoperability, persistence, and final fallback packaging remain unresolved; next target is one temporary public-path canary.
- Peak-hour repeatability and real-workload behavior remain mandatory before final seal, but are intentionally deferred until after G3-A/G3-B so the final validation measures the near-final automated/migratable implementation instead of an intermediate build.
- G3-A remains to implement physical-egress discovery, network-adaptive route/config generation, health checks, and safe role switching without hardcoded WLAN/IP/gateway assumptions.
- G3-B remains to package template-driven VPS migration, per-VPS Secret/certificate lifecycle, staged cutover, rollback, and a bounded migration rehearsal.
- Final production role: HY2 primary vs on-demand backup vs WireGuard primary remains undecided.
- Final WireGuard security policy: whether the split-default/no-strict-kill-switch state is accepted for v1 or replaced by a different final routing design.
- Optional Linux tuning candidates (BBR/fq/GRO/MTU) remain untested and are not required unless later evidence justifies them.
- MVP v1 seal remains pending G2-C integration, G3-A/G3-B engineering closure, G4 peak-hour/real-workload final validation, and final architecture decision.

## NEXT_STEP

Executor performs **G2C_P1_CANONICAL_SOURCE_WORKTREE_DISCOVERY_H1** only: repair the P1 runner's canonical Git root/path discovery so it supports both the canonical checkout and the existing nested Codex worktree without hardcoded parent-depth assumptions. Prove with local no-network fixtures and static review only. Do **not** run SSH, VPS preflight, route/listener/runtime mutation, Secret access, or the OpenAI canary. After repair, persist Evidence + Executor Handoff, commit, fresh read-back, and stop for Reviewer.

## OWNER_ACTION_REQUIRED

**NONE.** The Owner runtime is now reconfirmed as PowerShell 7.6.6 / Administrator=True / High integrity RID 12288. The blocker is a runner source-provenance bug, so Executor must repair and statically verify it before any further Owner-local P1 execution. Do not ask Owner to rerun the current runner.

## REVIEWER_TO_EXECUTOR_RELAY

P1 is authorized. Executor starts only from the P1 Gate above, `scripts/g2c-mihomo-server-r3.ps1`, the accepted R4 Evidence block, and the directly reusable accepted G2-B dynamic physical-egress / exact-route pattern. Do not reread Governance or historical Gates broadly. Run once, clean up exactly, persist sanitized Evidence + Executor Handoff, commit, fresh read-back, STOP.

## EXECUTOR_TO_REVIEWER_RELAY

Use the fixed P1 packet in `CURRENT_GATE` after authorization.

## EVIDENCE_POINTERS

- `EXECUTION_EVIDENCE.md` — append-only execution proof through the successful 60+60 same-window comparison.
- `DECISION_LOG.md` — durable decision rationale for the kill-switch routing change and current production/candidate roles.
- `docs/ROUND_TIMING_RETROSPECTIVE.md` — per-round estimate/actual timing, overrun causes, and reusable execution-efficiency improvements; not canonical project truth.
- `EXECUTOR_HANDOFF.md` — historical Executor factual notes; not canonical current project truth.
- `scripts/g2b-owner-runner.ps1` — accepted G2-B benchmark/runtime logic.
- `scripts/g2b-comparative-after-killswitch-repair.ps1` — successful final G2-B comparative checkpoint.
- Evidence commit `b85224370a295cc5128e29da9186573b81345d27` — same-window WG vs HY2 results and cleanup proof.
- Reviewer acceptance commit `cfb2d723657a5607c5d8c756705dc873c06babe5` — first formal acceptance of the completed G2-B evidence.

Historical Reviewer narrative remains available in Git history and is intentionally not duplicated in this dashboard.
