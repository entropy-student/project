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
- H1 local runner hardening is formally accepted from commit `2993756d41d0621471480ed2891c828d6674c7e6`: exception classification is non-throwing and fixture-proven, WireGuard ifIndex validation is dynamic, live SFO2-A/control-route consistency passed, and network/SSH/Secret activity was zero.
- H1 timing: estimated 10–20 minutes, actual 14m45s, no overrun.

## CURRENT_GATE

```text
GATE_ID=G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R4
STATE=AUTHORIZED_EXECUTION
PREVIOUS_RESULT=PASS_G2C_R3_LOCAL_RUNNER_HARDENING_H1
OBJECTIVE=Run one fresh, bounded Mihomo v1.19.31 server-side B experiment with the hardened Windows runner to determine whether changing only the temporary REALITY server implementation changes the observed interoperability result.
MAX_ENDPOINT_THIS_ROUND=local hardening preflight fixtures + one temporary private Mihomo server on 10.66.21.1:14443 + one proxied OpenAI HTTPS request + exact cleanup/read-back + Reviewer stop.
MANDATORY_REVIEW_STOP=YES
ESTIMATED_EXECUTION_TIME=15-25 minutes
```

### REVIEWER_ACCEPTANCE_OF_H1

Commit `2993756d41d0621471480ed2891c828d6674c7e6` is accepted as **PASS** for local runner hardening.

Required Evidence inspected and satisfied:
- PowerShell AST parse PASS;
- real local parameter-binding exception classified as `LOCAL_PROCESS_ARGUMENT_BINDING_FAILED`;
- unknown exception classified to bounded `UNEXPECTED_LOCAL_FAILURE` without classifier self-failure;
- synthetic matching dynamic-ifIndex fixture PASS;
- synthetic mismatch fixture failed closed;
- empty-string process-argument fixture PASS;
- hardcoded ifIndex 13 check PASS;
- live read-only baseline PASS with current `SFO2-A` Up / ifIndex 9 and control route `SFO2-A` / ifIndex 9;
- network requests 0, SSH 0, Secret access 0, network mutation 0;
- source diff limited to failure resolver and dynamic WireGuard baseline invariants;
- estimate 10–20 minutes; actual 14m45s; no overrun.

Reviewer conclusion:
- the two known local runner defects are closed;
- reboot/re-enumeration no longer creates a false failure through a fixed interface number;
- H1 itself does not establish any REALITY/Mihomo interoperability result.

### TARGET_AND_SCOPE

Keep the A-side accepted sing-box evidence unchanged; **do not replay A-side**.

B-side:
- temporary server core: Mihomo v1.19.31 native VLESS+REALITY;
- private bind only `10.66.21.1:14443`;
- Windows client: existing Mihomo v1.19.31;
- VLESS / REALITY / `xtls-rprx-vision`;
- SNI/server-name `www.microsoft.com`;
- REALITY handshake target `www.microsoft.com:443`;
- local HTTP proxy `127.0.0.1:17990`;
- exactly one request to `https://api.openai.com/v1/models`.

No other material variable may change.

### APPLICABLE_CRITICAL_CONSTRAINTS

- Use the hardened runner from/after commit `2993756d41d0621471480ed2891c828d6674c7e6`.
- Before any SSH/server action, rerun the bounded local-only fixtures needed to prove the hardened failure classifier, empty-argument handling, and dynamic SFO2-A/control-route invariant still pass on the current boot.
- Strict SSH trust path only; no private-key export.
- Secret values remain in protected process-memory/stdin/root-only runtime only; no values/hashes in chat/repo/log output.
- Public TCP/443 remains unauthorized.
- No persistent Mihomo service, route/firewall/system-proxy/TUN change, benchmark, protocol tuning, target/SNI change, or sing-box A-side replay.
- Exactly one real proxied OpenAI request is authorized **only after fresh Owner authorization for this Gate**.
- If the real request starts, the request allowance is consumed regardless of outcome; Git reconciliation must never replay it.
- Cleanup/regression is mandatory.

### PREFLIGHT

Before remote mutation prove:
- canonical Git/source provenance and project-scoped worktree;
- hardened runner AST PASS;
- hardened failure-classifier fixture PASS;
- empty-argument local fixture PASS;
- fresh live dynamic SFO2-A/control-route baseline PASS without fixed numeric ifIndex;
- no local Mihomo process/runtime residue and local proxy port free;
- strict SSH native exit 0 and expected VPS identity;
- WG/HY2 healthy;
- private TCP/14443 and TCP/443 free;
- pinned Mihomo v1.19.31 asset/hash identity intact;
- no R3/R4 runtime residue.

### REQUIRED_EVIDENCE

- local hardening fixtures PASS before SSH;
- exact Mihomo v1.19.31 server asset/hash PASS;
- server config validation PASS;
- private listener `10.66.21.1:14443` positive check;
- negative public 14443 / TCP443 checks;
- Windows->private listener TCP PASS;
- exactly one OpenAI proxied request;
- request-start marker, request count, curl exit, HTTP status, timing;
- sanitized client/server error classes;
- `SERVER_IMPLEMENTATION=MIHOMO_V1_19_31_NATIVE`;
- `IMPLEMENTATION_AB_RESULT=MIHOMO_SERVER_SUCCEEDED | MIHOMO_SERVER_FAILED_SIMILARLY | DIFFERENT_FAILURE | UNKNOWN`;
- exact cleanup of local/remote process/config/runtime/binary;
- WG/HY2 preserved; proxy/TUN/network unchanged;
- Secret emitted/committed = 0;
- timing record.

### ACCEPTANCE_CRITERIA

1. curl exit 0 + HTTP 401 => `MIHOMO_SERVER_SUCCEEDED`.
2. curl 35 + HTTP 0 with materially similar timeout/handshake pattern => `MIHOMO_SERVER_FAILED_SIMILARLY`.
3. another bounded, reviewable real-request failure => `DIFFERENT_FAILURE`.
4. ambiguous request state, cleanup failure, or runner failure => precise RETURN; do not replay.

This Gate can classify the B-side. It does not authorize public deployment or a production default.

### ROLLBACK_STATUS_OR_PLAN

Deterministic cleanup:
- stop only the temporary Windows Mihomo client and temporary VPS Mihomo server by exact process identity;
- remove only exact R4 runtime/config/log/binary paths;
- verify local proxy absent, private 14443 absent, TCP443 unchanged;
- verify WG/HY2 and Windows network baseline preserved.

### OWNER_ONLY_ACTIONS

**AUTHORIZED by Owner on 2026-10-03 for this R4 Gate.**

Fresh Owner authorization has now been granted for exactly the bounded R4 endpoint already defined above.

Authorized scope remains exactly the R4 Gate already defined: one bounded private B-side execution, one real request maximum, and exact cleanup/read-back.

Public TCP/443, persistence, benchmark, protocol changes, target/SNI changes, and production-default changes remain unauthorized.

### REVIEWER_TO_EXECUTOR_RELAY

Owner authorization is active. Start only from:
1. this R4 Gate;
2. hardened `scripts/g2c-mihomo-server-r3.ps1` from/after commit `2993756d41d0621471480ed2891c828d6674c7e6`;
3. H1 accepted Evidence block;
4. accepted R3 server-implementation A/B semantics already encoded in this Gate.

Do not reread Governance or historical Gates. Do not replay sing-box A-side. Run local hardening fixtures first; only then run one Mihomo-server B-side request. Persist Evidence + Executor Handoff, commit, fresh read-back, STOP.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE_AB / RETURN_*
改动：仅执行 hardened-runner 下的 Mihomo v1.19.31 私网 B-side；协议参数不变。
验证：local hardening fixtures + pinned asset + private listener + exactly one request + cleanup + WG/HY2 unchanged。
问题：MIHOMO_SERVER_SUCCEEDED / MIHOMO_SERVER_FAILED_SIMILARLY / DIFFERENT_FAILURE / 精确 RETURN 原因。
回滚：临时 server/client/runtime/binary 全部清理；14443 absent；443 unchanged。
请 Reviewer 检查：server-core implementation A/B 是否得到有效分类。
Owner 转交：NONE。
耗时：预计 15-25 分钟；实际 <elapsed>；超时 YES/NO；原因 <NONE/brief cause>。
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
ROUND=G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R4
ESTIMATED_EXECUTION_TIME=15-25 minutes
ESTIMATE_SCOPE=local hardened-runner preflight + one temporary private Mihomo B-side request + cleanup + Evidence/Handoff persistence
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

- VLESS+REALITY compatibility remains unresolved. H1 has now closed the known local runner defects; the next evidence target is one fresh Owner-authorized Mihomo-server B-side request under the hardened runner.
- Peak-hour repeatability and real-workload behavior remain mandatory before final seal, but are intentionally deferred until after G3-A/G3-B so the final validation measures the near-final automated/migratable implementation instead of an intermediate build.
- G3-A remains to implement physical-egress discovery, network-adaptive route/config generation, health checks, and safe role switching without hardcoded WLAN/IP/gateway assumptions.
- G3-B remains to package template-driven VPS migration, per-VPS Secret/certificate lifecycle, staged cutover, rollback, and a bounded migration rehearsal.
- Final production role: HY2 primary vs on-demand backup vs WireGuard primary remains undecided.
- Final WireGuard security policy: whether the split-default/no-strict-kill-switch state is accepted for v1 or replaced by a different final routing design.
- Optional Linux tuning candidates (BBR/fq/GRO/MTU) remain untested and are not required unless later evidence justifies them.
- MVP v1 seal remains pending G2-C integration, G3-A/G3-B engineering closure, G4 peak-hour/real-workload final validation, and final architecture decision.

## NEXT_STEP

Executor proceeds with **G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R4** exactly as defined in the current Gate.

## OWNER_ACTION_REQUIRED

**NONE.** Owner has authorized R4. All exclusions already defined by the Gate remain in force.

## REVIEWER_TO_EXECUTOR_RELAY

Use the authorized R4 relay in `CURRENT_GATE`; local hardening preflight must pass before the single real request.

## EXECUTOR_TO_REVIEWER_RELAY

Use the fixed R4 packet in `CURRENT_GATE` after authorization.

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
