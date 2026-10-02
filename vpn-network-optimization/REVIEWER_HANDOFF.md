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
G2-D Peak-hour + real workload validation   PENDING
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

## CURRENT_GATE

```text
GATE_ID=G2C_REALITY_SERVER_STATE_DIAGNOSTIC_R2
STATE=PROPOSED_NOT_AUTHORIZED
PREVIOUS_RESULT=PASS_CANDIDATE_DIAGNOSTIC
OBJECTIVE=Determine whether sing-box accepted the REALITY client authentication and where the server-side REALITY handshake stopped, before changing any protocol parameter.
MAX_ENDPOINT_THIS_ROUND=One private 10.66.21.1:14443 setup + one unchanged proxied HTTPS request + sanitized REALITY server-state extraction + exact cleanup + Reviewer stop.
MANDATORY_REVIEW_STOP=YES
ESTIMATED_EXECUTION_TIME=10-20 minutes
TIMING_OVERRUN_POLICY=record-and-diagnose-at-natural-checkpoint-without-delaying-healthy-progress
```

### REVIEWER_ACCEPTANCE_OF_R1

Commit `e2e89aa920bc06fe417428bffa4842aa5119ceec` is accepted as a **diagnostic PASS**, not protocol PASS.

Accepted R1 facts:
- private TCP path Windows -> `10.66.21.1:14443`: PASS;
- VPS -> `www.microsoft.com:443`: TCP PASS, TLS 1.3 PASS;
- sing-box v1.14.2 candidate/config/private-listener checks: PASS;
- Mihomo config/local proxy checks: PASS;
- exactly one request: curl 35 / HTTP 0 / appconnect 0;
- sanitized client class: `MIHOMO_ERROR_CLASS=TIMEOUT`;
- curl and sing-box classes remained generic TLS handshake failure;
- compatibility remains unproven;
- cleanup/read-back PASS; WG/HY2 and Windows network state preserved;
- timing: 24m29s inside the 15–30 minute estimate.

Reviewer conclusion:
- generic network reachability and handshake-target availability are no longer the primary fault domain;
- R1 narrows the fault to the REALITY handshake path, but does not prove whether the sing-box server authenticated the REALITY ClientHello, fell back to the target, or authenticated it and then stalled during the rewritten TLS handshake;
- therefore changing `support-x25519mlkem768`, SNI/target, core, or protocol now would still be speculative.

### TARGET_AND_SCOPE

R2 is a single-state diagnostic using the exact same protocol parameters and versions as R1.

Inside the protected sing-box diagnostic log, map only these non-secret state facts:
- whether REALITY server authentication selected the real client connection (`hs.c.conn == conn`);
- whether fallback forwarding occurred;
- negotiated key-share family: `X25519` / `X25519MLKEM768` / UNKNOWN;
- whether server-side REALITY handshake reached `hs.handshake()`;
- whether `readClientFinished()` completed;
- whether `isHandshakeComplete` became true;
- coarse server error stage/class.

Do **not** emit ClientShortId, AuthKey, private/public key material, UUID, raw session ID, raw certificates, or raw logs.

### REQUIRED_EVIDENCE

- previous R1 baseline fresh-read intact;
- exactly one unchanged proxied request;
- `REALITY_SERVER_AUTH_ACCEPTED=YES/NO/UNKNOWN`;
- `REALITY_SERVER_FALLBACK_USED=YES/NO/UNKNOWN`;
- `REALITY_SERVER_KEY_SHARE=X25519/X25519MLKEM768/UNKNOWN`;
- `REALITY_SERVER_HANDSHAKE_STAGE=<bounded stage>`;
- `REALITY_SERVER_HANDSHAKE_COMPLETE=YES/NO/UNKNOWN`;
- curl/Mihomo/sing-box sanitized classes;
- exact cleanup and WG/HY2 preservation;
- Secret emitted/committed = 0;
- timing record.

### ACCEPTANCE_CRITERIA

R2 diagnostic PASS requires enough state to distinguish at least one of:
1. **AUTH_REJECT_OR_FALLBACK** — repair authentication/client-hello compatibility;
2. **AUTH_ACCEPTED_TLS_REWRITE_STALL** — repair target/SNI/TLS-shape compatibility;
3. **SERVER_HANDSHAKE_COMPLETE_CLIENT_TIMEOUT** — investigate Mihomo client verification/flow;
4. **UNKNOWN_AFTER_R2** — then Reviewer may choose a controlled implementation A/B rather than more blind parameter edits.

No protocol compatibility PASS is possible in this Gate.

### OWNER_ONLY_ACTIONS

**NOT YET AUTHORIZED.** R1 consumed its one-request authorization. R2 requires one fresh private diagnostic request. Public TCP/443, persistent deployment, performance benchmark, and protocol changes remain unauthorized.

### REVIEWER_TO_EXECUTOR_RELAY

After Owner authorization:
- fresh-read this Gate;
- reuse `scripts/g2c-private-reality-canary.ps1` from diagnostic implementation commit `c45a09688ed6eb48ac885f1f85a3b9c98f649923`;
- make only the smallest sanitizer/state-extraction change;
- keep protocol fields byte-for-byte equivalent in meaning;
- one request only;
- persist Evidence + Executor Handoff, commit, STOP.

Do not add `support-x25519mlkem768` yet. Mihomo documents that option for current REALITY compatibility, but the exact sing-box-server failure mode has not been proven and the current server implementation accepts both X25519 and X25519MLKEM768 paths; changing it before observing server auth state would confound diagnosis.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE_DIAGNOSTIC / RETURN_*
改动：仅增加 sing-box REALITY server-state 脱敏提取；协议参数未变。
验证：one request / auth accepted? / fallback? / key-share / handshake stage+complete / cleanup。
问题：AUTH_REJECT_OR_FALLBACK / AUTH_ACCEPTED_TLS_REWRITE_STALL / SERVER_HANDSHAKE_COMPLETE_CLIENT_TIMEOUT / UNKNOWN_AFTER_R2。
回滚：所有临时运行产物清理；14443 absent；443 unchanged；WG/HY2 preserved。
请 Reviewer 检查：是否足以进入单变量修复或 implementation A/B。
Owner 转交：NONE，除非真实 Owner host 不可访问。
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
ROUND=G2C_REALITY_SERVER_STATE_DIAGNOSTIC_R2
ESTIMATED_EXECUTION_TIME=10-20 minutes
ESTIMATE_SCOPE=minimal protected server-log state sanitizer + one unchanged private request + cleanup + Evidence/Handoff commit
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

- VLESS+REALITY compatibility: private listener/config validation and target TLS reachability passed; repeated one-request evidence shows curl 35 and Mihomo TIMEOUT before app-connect. R2 must determine server auth/fallback/handshake state before any parameter change.
- Peak-hour repeatability: whether HY2 retains its same-window advantage during the user's known evening congestion window.
- Real workload behavior: Codex / OpenAI / image-generation long-task A/B is still untested.
- Final production role: HY2 primary vs on-demand backup vs WireGuard primary remains undecided.
- Final WireGuard security policy: whether the split-default/no-strict-kill-switch state is accepted for v1 or replaced by a different final routing design.
- Optional Linux tuning candidates (BBR/fq/GRO/MTU) remain untested and are not required unless later evidence justifies them.
- MVP v1 seal remains pending G2-C VLESS+REALITY integration, G2-D peak-hour/real-workload validation, and final architecture decision.

## NEXT_STEP

Await Owner authorization for **G2C_REALITY_SERVER_STATE_DIAGNOSTIC_R2**. This is intended to be the last unchanged-parameter diagnostic before selecting a repair.

## OWNER_ACTION_REQUIRED

Authorize one additional private diagnostic request on `10.66.21.1:14443` for server-state classification only. No public TCP/443, persistent deployment, benchmark, or parameter change.

## REVIEWER_TO_EXECUTOR_RELAY

No active Executor run until Owner authorizes R2.

## EXECUTOR_TO_REVIEWER_RELAY

Use the fixed R2 packet in `CURRENT_GATE` after authorization.

## EVIDENCE_POINTERS

- `EXECUTION_EVIDENCE.md` — append-only execution proof through the successful 60+60 same-window comparison.
- `DECISION_LOG.md` — durable decision rationale for the kill-switch routing change and current production/candidate roles.
- `EXECUTOR_HANDOFF.md` — historical Executor factual notes; not canonical current project truth.
- `scripts/g2b-owner-runner.ps1` — accepted G2-B benchmark/runtime logic.
- `scripts/g2b-comparative-after-killswitch-repair.ps1` — successful final G2-B comparative checkpoint.
- Evidence commit `b85224370a295cc5128e29da9186573b81345d27` — same-window WG vs HY2 results and cleanup proof.
- Reviewer acceptance commit `cfb2d723657a5607c5d8c756705dc873c06babe5` — first formal acceptance of the completed G2-B evidence.

Historical Reviewer narrative remains available in Git history and is intentionally not duplicated in this dashboard.
