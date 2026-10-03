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

## CURRENT_GATE

```text
GATE_ID=G2C_R3_LOCAL_RUNNER_HARDENING_H1
STATE=AUTHORIZED_EXECUTION
PREVIOUS_RESULT=RETURN_G2C_R3_RUNNER_EXCEPTION_CLASSIFIER_FAILURE
OBJECTIVE=Repair and prove the Windows R3 runner's local failure-classification and dynamic WireGuard preflight invariants without starting any remote server, generating any runtime Secret, or sending any network request.
MAX_ENDPOINT_THIS_ROUND=One project-scoped source patch + local read-only/runtime fixtures + AST/static validation + durable Evidence/Handoff commit + Reviewer stop.
MANDATORY_REVIEW_STOP=YES
ESTIMATED_EXECUTION_TIME=10-20 minutes
```

### REVIEWER_RECONCILIATION_OF_R3_RETRY

Commit `23e025ef6ef158361ac8bb73d3b6ac969f2ad70a` is accepted as a precise **tooling RETURN**.

Accepted facts:
- local no-network empty-argument helper fixture PASS;
- the one runner invocation exited before producing normal bounded result markers;
- top-level catch referenced `[Management.Automation.ParameterBindingValidationException]`, which is not resolvable in the verified PowerShell runtime and itself threw;
- the original exception and original phase were therefore masked;
- request count and REALITY handshake state are `UNKNOWN`; no A/B or compatibility conclusion exists;
- post-run cleanup read-back found no temporary local/remote Mihomo process, listener, or R3 runtime residue;
- WG/HY2 remained active; system proxy remained off; WinHTTP remained direct; TUN count remained zero;
- post-run SFO2-A was Up on ifIndex 9 and the control route to `10.66.21.1` selected the same ifIndex 9;
- Owner reports the Windows PC was rebooted shortly before this observation. A reboot can plausibly coincide with Windows interface-index renumbering, but this is **OWNER_REPORTED context**, not proof that reboot caused the R3 failure;
- regardless of cause, the runner's hardcoded ifIndex 13 is an invalid runtime assumption and must not be used for another real attempt;
- estimate 15–25 minutes; actual 10m58s; no timing overrun.

Authorization consequence:
- because the masked exception leaves whether the prior real request started **UNKNOWN**, the earlier one-request Owner authorization is treated as **ambiguous/consumed for retry purposes**;
- no further OpenAI/REALITY request is allowed until a later Gate receives fresh Owner authorization;
- this H1 Gate is local-only ordinary repair and requires no Owner consequential authorization.

### TARGET_AND_SCOPE

Target file:
- `vpn-network-optimization/scripts/g2c-mihomo-server-r3.ps1`

Allowed repair scope:
1. Replace the fragile top-level exception type literal with a testable failure-code resolver that uses safe runtime facts such as `Exception.GetType().FullName`, `FullyQualifiedErrorId`, and sanitized message/code patterns; the resolver itself must not throw when the original exception is unknown.
2. Remove the hardcoded WireGuard ifIndex `13` requirement. Preserve the actual invariant:
   - adapter name is `SFO2-A`;
   - adapter is Up;
   - discovered WireGuard ifIndex is a positive runtime value obtained fresh in the current process;
   - control route to `10.66.21.1` resolves to `SFO2-A`;
   - control-route ifIndex equals the freshly discovered adapter ifIndex;
   - no specific numeric ifIndex (including 9) is treated as stable across reboot/reconnect.
3. Do not change VLESS, REALITY, Vision, SNI, handshake target, ports, Mihomo versions, Secret handling, SSH trust, server config, curl endpoint, or request-count logic.

### APPLICABLE_CRITICAL_CONSTRAINTS

- Local-only: no SSH connection, no remote download, no VPS process, no temporary private listener, no Mihomo client/server start, no OpenAI URL request.
- No Secret generation/access/output.
- No route/firewall/proxy/TUN/WireGuard configuration mutation.
- Do not weaken checks by deleting them; replace incidental numeric assumptions with runtime invariants.
- Failure-path fixtures must themselves fail closed and emit only non-secret bounded markers.
- Use a project-scoped clean worktree or equivalent source isolation; unrelated `main` activity must not cause fixture replay beyond local no-network tests.

### PREFLIGHT

Before source mutation prove:
- canonical Git root / source provenance / project-owned path;
- target runner is the version reviewed from commit `23e025ef6ef158361ac8bb73d3b6ac969f2ad70a`;
- no unrelated project files will be edited;
- current local SFO2-A and control-route values are read-only facts only and are not mutated;
- treat Owner-reported reboot only as context for why an interface index may have changed; do not use it to infer the masked R3 failure cause.

### REQUIRED_EVIDENCE

- PowerShell AST parse PASS;
- failure resolver fixture PASS using a real locally generated parameter-binding validation error, proving the resolver returns `LOCAL_PROCESS_ARGUMENT_BINDING_FAILED` and does not throw;
- unknown-exception fixture PASS, proving a different local exception returns a bounded generic code and does not throw;
- synthetic local baseline fixture with a positive non-hardcoded ifIndex (for example 9) and matching control-route ifIndex PASS;
- synthetic local baseline mismatch fixture (adapter/control-route indexes differ) FAILS CLOSED with the expected bounded code;
- fresh read-only live-host baseline check PASS using whatever positive ifIndex `SFO2-A` has **at H1 execution time**, without requiring it to equal 9 or 13;
- empty-argument `Start-R3SuppressedProcess` no-network fixture remains PASS;
- static scan confirms no hardcoded `WireGuardIfIndex -eq 13` or `ControlRouteIfIndex -eq 13` remains;
- source diff is limited to local runner hardening plus optional local fixture code;
- network requests = 0; SSH invocations = 0; Secret values emitted/committed = 0;
- timing record.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE_HARDENING requires every required local fixture and static check to pass with zero network/remote action.

This Gate does **not** produce a REALITY/Mihomo A/B result and does not consume or create authorization for a real request.

### ROLLBACK_STATUS_OR_PLAN

Rollback is source-only:
- revert the H1 runner patch if fixtures fail or create new contradictions;
- no runtime rollback should be required because H1 performs no network/remote mutation.

### OWNER_ONLY_ACTIONS

**NONE for H1.**

Fresh Owner authorization **will be required after H1 PASS** before any new real OpenAI/REALITY request, because the previous retry's request state is UNKNOWN.

### REVIEWER_TO_EXECUTOR_RELAY

Start only from:
1. this H1 Gate;
2. `scripts/g2c-mihomo-server-r3.ps1`;
3. the Evidence block `G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3 — authorized retry evidence (2026-10-03)`.

Do not read Governance or historical Gates. Do not start SSH, Mihomo, curl-to-URL, or any remote/server workflow. Patch only the local failure resolver and dynamic WireGuard baseline invariant, run the named fixtures, persist Evidence + Executor Handoff, commit, STOP.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE_HARDENING / RETURN_*
改动：仅修复 R3 runner 的本地异常分类和动态 WireGuard ifIndex 校验。
验证：AST + failure fixtures + dynamic-ifIndex fixtures + empty-argument fixture；网络请求 0、SSH 0。
问题：NONE，或精确说明仍失败的本地 fixture。
回滚：仅源码补丁，可直接 revert；无运行态网络/服务器变更。
请 Reviewer 检查：本地 runner 是否已可在真实重试前可靠 fail-closed。
Owner 转交：NONE。
耗时：预计 10-20 分钟；实际 <elapsed>；超时 YES/NO；原因 <NONE/brief cause>。
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
ROUND=G2C_R3_LOCAL_RUNNER_HARDENING_H1
ESTIMATED_EXECUTION_TIME=10-20 minutes
ESTIMATE_SCOPE=project-scoped local source patch + no-network fixtures + Evidence/Handoff persistence
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

- VLESS+REALITY compatibility remains unresolved. The Mihomo-server A/B has not produced a usable result because R3 runner tooling failed twice; the latest failure masked whether a request started. H1 must harden the local runner before any further real request.
- Peak-hour repeatability and real-workload behavior remain mandatory before final seal, but are intentionally deferred until after G3-A/G3-B so the final validation measures the near-final automated/migratable implementation instead of an intermediate build.
- G3-A remains to implement physical-egress discovery, network-adaptive route/config generation, health checks, and safe role switching without hardcoded WLAN/IP/gateway assumptions.
- G3-B remains to package template-driven VPS migration, per-VPS Secret/certificate lifecycle, staged cutover, rollback, and a bounded migration rehearsal.
- Final production role: HY2 primary vs on-demand backup vs WireGuard primary remains undecided.
- Final WireGuard security policy: whether the split-default/no-strict-kill-switch state is accepted for v1 or replaced by a different final routing design.
- Optional Linux tuning candidates (BBR/fq/GRO/MTU) remain untested and are not required unless later evidence justifies them.
- MVP v1 seal remains pending G2-C integration, G3-A/G3-B engineering closure, G4 peak-hour/real-workload final validation, and final architecture decision.

## NEXT_STEP

Executor performs **G2C_R3_LOCAL_RUNNER_HARDENING_H1** only. No network request or remote server work is allowed in this round.

## OWNER_ACTION_REQUIRED

**NONE for H1.** After H1 PASS, a fresh Owner authorization will be required before a new real R3 Mihomo-server A/B request because the previous retry's request state is UNKNOWN.

## REVIEWER_TO_EXECUTOR_RELAY

Use the H1 relay in `CURRENT_GATE`; patch only the local runner hardening items, run local fixtures, persist Evidence + Executor Handoff, commit, STOP.

## EXECUTOR_TO_REVIEWER_RELAY

Use the fixed H1 packet in `CURRENT_GATE`.

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
