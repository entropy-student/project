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
GATE_ID=G2C_REALITY_HANDSHAKE_DIAGNOSTIC_R1
STATE=AUTHORIZED_EXECUTION
PREVIOUS_RESULT=RETURN_G2C_PRIVATE_REALITY_HANDSHAKE_CURL_EXIT_35
OBJECTIVE=Identify the exact REALITY/TLS handshake fault domain without changing protocol architecture or exposing public TCP/443.
MAX_ENDPOINT_THIS_ROUND=One private 10.66.21.1:14443 diagnostic setup + one proxied HTTPS request with sanitized client/server error classification + exact cleanup + Reviewer stop.
MANDATORY_REVIEW_STOP=YES
ESTIMATED_EXECUTION_TIME=15-30 minutes
TIMING_OVERRUN_POLICY=record-and-diagnose-at-natural-checkpoint-without-delaying-healthy-progress
```

### REVIEWER_CLASSIFICATION_OF_PREVIOUS_RETURN

Accepted facts from commit `450a3d18ed5575cf5b0e27edd3c4949262b87cd6`:
- sing-box v1.14.2 identity/hash PASS;
- server config check PASS;
- exact private listener `10.66.21.1:14443` PASS;
- no public 14443 or 443 listener;
- Mihomo config check PASS and local HTTP proxy `127.0.0.1:17990` ready;
- exactly one proxied OpenAI HTTPS request was attempted;
- curl exit 35, HTTP 0, `time_appconnect=0`;
- benchmark not started;
- cleanup/read-back passed and WG/HY2/network/system proxy/TUN were preserved;
- Secret values emitted/committed = 0.

Reviewer interpretation:
- basic local proxy readiness, server process startup, private TCP listener creation, and cleanup are proven;
- end-to-end REALITY compatibility is **not** proven;
- the failure occurred before the destination TLS app-connect completed;
- exact cause remains UNKNOWN because curl stderr and both protocol-core error streams were suppressed rather than converted into sanitized diagnostics;
- do not classify this yet as "sing-box incompatible", "Mihomo bug", "bad SNI", or "network block";
- current external documentation confirms REALITY interoperability is actively changing, including Mihomo's explicit `support-x25519mlkem768` option and known cross-core compatibility issues, so a fault-domain probe is justified before any config change.

### TARGET_AND_SCOPE

Diagnostic only. Reuse the same private canary topology:
- Windows Mihomo v1.19.31 family;
- temporary sing-box v1.14.2;
- server bind exactly `10.66.21.1:14443`;
- local HTTP proxy exactly `127.0.0.1:17990`;
- no public listener, persistent service, benchmark, route/firewall/TUN/system-proxy change.

Do **not** change protocol parameters in R1 merely to "try something". In particular, preserve the previous VLESS/REALITY/Vision parameters for the one diagnostic request. The purpose is to learn why the exact prior configuration failed.

### PREFLIGHT_AND_DIAGNOSTIC

Before the one real request:
1. fresh-read WG/HY2, private port absence, public 443 absence, and no residue;
2. prove Windows can establish ordinary TCP to `10.66.21.1:14443` after the temporary listener is ready;
3. from the VPS, perform a bounded read-only reachability/TLS check to the configured REALITY handshake target `www.microsoft.com:443` with SNI; emit only PASS/FAIL + protocol version/error class, not raw certificate/log payload;
4. start the same Mihomo/sing-box pair with logs captured only inside the protected runtime boundary.

For the single proxied request:
- capture curl stderr in memory and map it to a short sanitized error class;
- capture Mihomo and sing-box error/debug streams in memory or protected temporary files;
- never persist or emit raw streams;
- map relevant lines to an allowlist such as:
  `REALITY_AUTH_OR_VERIFICATION_FAILED`,
  `KEY_SHARE_OR_MLKEM_MISMATCH`,
  `SNI_OR_CERT_MISMATCH`,
  `VLESS_OR_VISION_REJECTED`,
  `HANDSHAKE_TARGET_UNREACHABLE`,
  `CONNECTION_RESET_OR_EOF`,
  `TIMEOUT`,
  `UNKNOWN_TLS_HANDSHAKE_FAILURE`;
- emit only the classification and non-secret timing/status markers.

### REQUIRED_EVIDENCE

- previous accepted candidate identities unchanged;
- handshake-target TCP/TLS read-only check result;
- Windows -> private listener TCP reachability result;
- exactly one proxied request;
- curl exit / HTTP / total-connect-appconnect timing;
- sanitized `CURL_ERROR_CLASS`;
- sanitized `MIHOMO_ERROR_CLASS`;
- sanitized `SING_BOX_ERROR_CLASS`;
- `REALITY_DIAGNOSTIC_CLASSIFICATION=<one bounded class>` or `UNKNOWN_AFTER_DIAGNOSTIC`;
- exact cleanup/read-back and WG/HY2 preserved;
- Secret values emitted/committed = 0;
- timing fields: `ROUND_STARTED_AT`, `ROUND_FINISHED_AT`, `ACTUAL_ELAPSED`, `TIME_OVERRUN`, and cause if needed.

### ACCEPTANCE_CRITERIA

This diagnostic Gate does not PASS protocol compatibility. It PASSes as a diagnostic only if it safely narrows the failure to a reviewable fault domain while preserving cleanup/security boundaries. Reviewer then chooses the smallest repair/protocol-implementation decision.

### OWNER_ONLY_ACTIONS

**AUTHORIZED by Owner on 2026-10-03 for G2C_REALITY_HANDSHAKE_DIAGNOSTIC_R1.**

Authorization covers exactly:
- one private diagnostic setup on `10.66.21.1:14443`;
- one Windows->private-listener TCP reachability check;
- one VPS->`www.microsoft.com:443` bounded TLS reachability check;
- one proxied OpenAI HTTPS request through the unchanged VLESS+REALITY+Vision parameters;
- protected capture/classification of curl/Mihomo/sing-box error streams;
- exact cleanup/read-back and Evidence persistence.

It does **not** authorize public TCP/443 exposure, persistent service installation, benchmark/performance testing, protocol-parameter changes, or expansion to another protocol/core.

### REVIEWER_TO_EXECUTOR_RELAY

Owner authorization is now active. Start only from:
- this Gate;
- the accepted execution section for commit `450a3d18ed5575cf5b0e27edd3c4949262b87cd6`;
- `scripts/g2c-private-reality-canary.ps1`;
- current timing rules.

Do not re-open G2-B history. Do not change REALITY parameters in R1. Instrument/classify the failing handshake, clean up, persist Evidence + Executor Handoff, and STOP.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE_DIAGNOSTIC / RETURN_*
改动：仅诊断增强 + 临时私有 canary；协议参数未变。
验证：handshake target / private TCP / one proxied request / sanitized core error classes / cleanup。
问题：明确 fault-domain classification，或 UNKNOWN_AFTER_DIAGNOSTIC。
回滚：临时进程、Secret config、binary/workspace 全部清理；14443 absent；443 unchanged；WG/HY2 preserved。
请 Reviewer 检查：是否已有足够证据决定最小修复。
Owner 转交：NONE，除非真实 Owner host 不可访问。
耗时：预计 15-30 分钟；实际 <elapsed>；超时 YES/NO；原因 <NONE/brief cause>。
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
ROUND=G2C_REALITY_HANDSHAKE_DIAGNOSTIC_R1
ESTIMATED_EXECUTION_TIME=15-30 minutes
ESTIMATE_SCOPE=same private canary topology + handshake-target check + one request with sanitized client/server error classification + cleanup + Evidence/Handoff commit
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

- VLESS+REALITY compatibility: private listener/config validation passed, but the first real Mihomo -> sing-box REALITY request failed before TLS app-connect (curl 35); exact handshake fault domain remains unresolved.
- Peak-hour repeatability: whether HY2 retains its same-window advantage during the user's known evening congestion window.
- Real workload behavior: Codex / OpenAI / image-generation long-task A/B is still untested.
- Final production role: HY2 primary vs on-demand backup vs WireGuard primary remains undecided.
- Final WireGuard security policy: whether the split-default/no-strict-kill-switch state is accepted for v1 or replaced by a different final routing design.
- Optional Linux tuning candidates (BBR/fq/GRO/MTU) remain untested and are not required unless later evidence justifies them.
- MVP v1 seal remains pending G2-C VLESS+REALITY integration, G2-D peak-hour/real-workload validation, and final architecture decision.

## NEXT_STEP

Executor proceeds with **G2C_REALITY_HANDSHAKE_DIAGNOSTIC_R1** using the current Gate. Keep the exact previous protocol parameters unchanged, add only sanitized diagnostic instrumentation, run one private diagnostic request, clean up, persist Evidence + Executor Handoff, then STOP for Reviewer.

## OWNER_ACTION_REQUIRED

**NONE.** Owner has authorized this diagnostic round. No Administrator PowerShell is required unless a specific required operation independently proves it needs elevation. Public TCP/443 remains unauthorized.

## REVIEWER_TO_EXECUTOR_RELAY

Use the authorized relay in `CURRENT_GATE`. Do not modify protocol parameters, do not benchmark, and do not expand scope.

## EXECUTOR_TO_REVIEWER_RELAY

Use the fixed packet in `CURRENT_GATE`, including the 15–30 minute estimate and actual timing fields.

## EVIDENCE_POINTERS

- `EXECUTION_EVIDENCE.md` — append-only execution proof through the successful 60+60 same-window comparison.
- `DECISION_LOG.md` — durable decision rationale for the kill-switch routing change and current production/candidate roles.
- `EXECUTOR_HANDOFF.md` — historical Executor factual notes; not canonical current project truth.
- `scripts/g2b-owner-runner.ps1` — accepted G2-B benchmark/runtime logic.
- `scripts/g2b-comparative-after-killswitch-repair.ps1` — successful final G2-B comparative checkpoint.
- Evidence commit `b85224370a295cc5128e29da9186573b81345d27` — same-window WG vs HY2 results and cleanup proof.
- Reviewer acceptance commit `cfb2d723657a5607c5d8c756705dc873c06babe5` — first formal acceptance of the completed G2-B evidence.

Historical Reviewer narrative remains available in Git history and is intentionally not duplicated in this dashboard.
