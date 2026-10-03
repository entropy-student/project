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
LAST_EXECUTOR_RESULT=PASS_VPS_PREFLIGHT_ONLY_OWNER_PROOF
RUNNER_PREPARATION_REVIEW=PASS
CANONICAL_SOURCE_HARDENING_REVIEW=PASS
RUNNER_SOURCE_COMMIT=4065410817c9f206face86c49dfca2f43198223d
HARDENING_COMPLETION_COMMIT=64461d63fb92c6e8944639198e5e1a385e6d8c59
LAST_ATTEMPT_CONSEQUENTIAL_ACTION_STARTED=NO
REAL_OPENAI_REQUEST_BUDGET_CONSUMED=0_OF_1
OWNER_RUNTIME_RECONFIRMED=PowerShell_7.6.6_Administrator_High_RID_12288
CANONICAL_SOURCE_ONLY_PROOF=PASS
LOCAL_PREFLIGHT_ONLY_PROOF=PASS
VPS_PREFLIGHT_ONLY_PROOF=PASS
EXECUTION_BLOCKER=NONE
SIMILAR_PROVENANCE_FAILURE_COUNT=2
BLOCKING_DIAGNOSTIC_GATE=NONE_DIAGNOSTIC_COMPLETED
OWNER_DIRECT_EXECUTION_EXCEPTION=AUTHORIZED_FOR_BOUNDED_LOW_RISK_OWNER_LOCAL_STEPS_WHEN_FASTER_THAN_CODEX
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

## NEXT_STEP

Owner synchronizes the managed worktree to current GitHub `main` and executes the already-authorized real `G2C_REALITY_PUBLIC_TCP443_CANARY_P1` exactly once from PowerShell 7.6.6 Administrator/High using the verified pinned Mihomo v1.19.31 client. Windows and VPS preflight-only proofs are both accepted. The real run must not be retried after any PASS or RETURN and must return to Reviewer for reconciliation.

## OWNER_ACTION_REQUIRED

Run the Reviewer-provided real P1 command exactly once with `-ClientMihomoPath` pointing to the verified pinned v1.19.31 client. Do not use `-LocalPreflightOnly` or `-VpsPreflightOnly`. Request budget remains `0/1` before execution. Any run reaching `REQUEST_COUNT=1` consumes the one-request budget regardless of final outcome.

## REVIEWER_TO_EXECUTOR_RELAY

**NONE required.** Owner direct execution is preferred for this bounded local proof. The repaired runner uses the WinHTTP API, preserves the pre-existing Clash Verge Mihomo baseline, keeps P1 port 17990 exclusive, and stops before SSH when `-LocalPreflightOnly` is set.

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
