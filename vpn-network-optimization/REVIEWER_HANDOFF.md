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
- G2-C REALITY diagnostics R1/R2 are accepted as **diagnostic-only** results: repeated private requests reproduced curl 35 / HTTP 0 / Mihomo TIMEOUT while private TCP, target TLS 1.3, cleanup, WG/HY2, and Windows baseline remained healthy.
- R2 protected sing-box trace capture was readable but yielded no allowlisted REALITY internal state markers; accepted classification is `UNKNOWN_AFTER_R2`.
- No VLESS+REALITY interoperability PASS exists yet; no public TCP/443 or persistent REALITY service has been authorized.

## CURRENT_GATE

```text
GATE_ID=G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3
STATE=PROPOSED_NOT_AUTHORIZED
PREVIOUS_RESULT=PASS_CANDIDATE_DIAGNOSTIC / UNKNOWN_AFTER_R2
OBJECTIVE=Isolate the server-core implementation as the next single variable by replacing only the temporary sing-box REALITY server with Mihomo v1.19.31 native VLESS+REALITY, while keeping the Windows Mihomo client and all protocol semantics unchanged.
MAX_ENDPOINT_THIS_ROUND=One temporary private Mihomo server on 10.66.21.1:14443 + one proxied OpenAI HTTPS request + exact cleanup/read-back + Reviewer stop.
MANDATORY_REVIEW_STOP=YES
ESTIMATED_EXECUTION_TIME=20-35 minutes
TIMING_OVERRUN_POLICY=record-and-diagnose-at-natural-checkpoint-without-delaying-healthy-progress
```

### REVIEWER_ACCEPTANCE_OF_R2

Commit `0d9249ada6fa17223e3587fb7f77c52b0227ffa7` is accepted as **diagnostic PASS only**.

Accepted R2 facts:
- exactly one private request was sent;
- curl exit 35 / HTTP 0 / app-connect 0 reproduced;
- handshake target `www.microsoft.com:443` remained TCP/TLS 1.3 reachable from the VPS;
- protected sing-box trace file was readable and safely filtered;
- all requested REALITY internal state markers remained UNKNOWN;
- cleanup passed; temporary listener removed; WG/HY2 and Windows network baseline preserved;
- Secret values emitted/committed = 0;
- estimate 10–20 minutes; actual 25m12s; overrun was caused by unrelated GitHub `main` advancement requiring fetch/rebase/retry, not by the network diagnostic itself.

Reviewer classification:
- `UNKNOWN_AFTER_R2` is a valid terminal result for the unchanged-parameter diagnostic path;
- further log-parsing or blind parameter edits are not justified by new evidence;
- per Governance §6, repeated materially similar failures now move to a controlled implementation A/B.

### TARGET_AND_SCOPE

Change exactly one material variable: **temporary server implementation only**.

Keep unchanged:
- Windows client: existing Mihomo v1.19.31;
- VLESS;
- REALITY;
- flow `xtls-rprx-vision`;
- private bind `10.66.21.1:14443`;
- local HTTP proxy `127.0.0.1:17990`;
- SNI/server-name `www.microsoft.com`;
- REALITY handshake target `www.microsoft.com:443`;
- one-request limit;
- no public 443, no persistent service, no route/firewall/TUN/system-proxy change.

Temporary server candidate:
- core: **Mihomo v1.19.31** native VLESS listener with `reality-config`;
- official asset: `mihomo-linux-amd64-compatible-v1.19.31.gz`;
- exact SHA256: `04cf9f09671704f839ddbee2e93069dc831a4123a75281e725d1d96ab9ac1afc`;
- generate REALITY keypair with the same temporary Mihomo binary;
- root-only ephemeral server config/runtime/logs;
- bind only `10.66.21.1:14443`.

Mihomo server config must preserve semantic equivalence to the accepted sing-box candidate:
- one VLESS user with the ephemeral UUID;
- `flow: xtls-rprx-vision`;
- `reality-config.dest: www.microsoft.com:443`;
- `reality-config.server-names: [www.microsoft.com]`;
- matching private key + one ephemeral short-id;
- no certificate/private-key TLS mode, no WebSocket/gRPC/XHTTP, no additional listener.

### APPLICABLE_CRITICAL_CONSTRAINTS

- Reuse accepted strict SSH trust path; no private-key export.
- Secret values remain inside protected stdin/process-memory/root-only runtime files; no values or hashes in chat/repo/log output.
- No public `0.0.0.0:14443`, public-IP:14443, or TCP/443 listener.
- Do not stop/change WireGuard or HY2.
- Do not reuse accepted sing-box canary by replay; use its accepted result as A-side evidence.
- No `support-x25519mlkem768` change, target/SNI change, or other parameter tuning in this Gate.
- Cleanup/regression is part of completion.
- Repository concurrency must not cause replay of the consequential request: if push/rebase is needed after execution, reconcile/persist the retained result without rerunning the request.

### PREFLIGHT

Before mutation prove:
- current canonical Git root / isolated project worktree and source provenance;
- current Windows Mihomo v1.19.31 and WireGuard baseline;
- strict SSH native exit 0 and accepted VPS identity;
- `10.66.21.1:14443` and TCP/443 free;
- WG UDP/51820 and HY2 UDP/8443 healthy;
- no prior G2-C runtime residue;
- VPS has enough free memory/disk for the temporary Mihomo binary/process;
- pinned Mihomo asset identity/hash is verified before execution.

### REQUIRED_EVIDENCE

- exact Mihomo v1.19.31 server asset + SHA256 PASS;
- native server config validation PASS;
- positive private-listener check and negative public-listener/443 checks;
- one Windows->private-listener TCP check;
- exactly one proxied OpenAI request;
- curl exit / HTTP / timing;
- sanitized Mihomo-client and Mihomo-server error classes;
- `SERVER_IMPLEMENTATION=MIHOMO_V1_19_31_NATIVE`;
- `IMPLEMENTATION_AB_RESULT=MIHOMO_SERVER_SUCCEEDED | MIHOMO_SERVER_FAILED_SIMILARLY | DIFFERENT_FAILURE | UNKNOWN`;
- resource read-back: server process RSS and post-cleanup MemAvailable;
- exact local/remote cleanup;
- WG/HY2 preserved; network/system proxy/TUN unchanged;
- Secret emitted/committed = 0;
- timing record.

### ACCEPTANCE_CRITERIA

Reviewer may accept this A/B Gate when the single B-side run is safely completed and classified.

Interpretation rules:
1. curl exit 0 + HTTP 401 => `MIHOMO_SERVER_SUCCEEDED`: server-core implementation difference is materially implicated; do **not** yet make Mihomo server production default.
2. same curl 35 / HTTP 0 / Mihomo timeout pattern => `MIHOMO_SERVER_FAILED_SIMILARLY`: sing-box-specific hypothesis weakens; next Reviewer choice should target one other variable such as handshake target/SNI rather than another server-core guess.
3. materially different bounded failure => `DIFFERENT_FAILURE`: Reviewer uses the new evidence before any further change.
4. ambiguous execution or cleanup failure => precise RETURN.

### ROLLBACK_STATUS_OR_PLAN

Deterministic cleanup:
- stop only the temporary Mihomo server by exact process identity;
- stop temporary Windows Mihomo client;
- remove only exact G2-C R3 runtime/config/log/binary paths;
- verify 14443 and 443 listeners absent;
- verify WG/HY2 and Windows baseline unchanged.

No production rollback action should be needed because this Gate has no persistent/public change.

### OWNER_ONLY_ACTIONS

**NOT YET AUTHORIZED.** R3 crosses the previous diagnostic boundary by introducing a different temporary server core and one new real request.

Fresh Owner authorization is required for exactly this private A/B canary. Public TCP/443, persistent deployment, benchmark, protocol-parameter changes, and production default changes remain unauthorized.

### REVIEWER_TO_EXECUTOR_RELAY

After Owner authorization, start only from:
1. this Gate;
2. accepted R2 Evidence block under `G2C_REALITY_SERVER_STATE_DIAGNOSTIC_R2`;
3. `scripts/g2c-private-reality-canary.ps1` only for reusable strict SSH, protected runtime, Windows client, curl, cleanup, and timing patterns;
4. Mihomo v1.19.31 native VLESS listener syntax from the pinned source/docs.

Do not reread Governance or historical Gates. Do not rerun sing-box A-side. Do not change target/SNI/client REALITY options. Build one bounded Mihomo-server B-side checkpoint, execute once, persist Evidence + Executor Handoff, commit, STOP.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE_AB / RETURN_*
改动：仅将临时服务端由 sing-box 换成 Mihomo v1.19.31 native VLESS+REALITY；客户端和协议参数未变。
验证：pinned asset / private listener / one request / A-B classification / cleanup / WG+HY2 unchanged。
问题：MIHOMO_SERVER_SUCCEEDED / MIHOMO_SERVER_FAILED_SIMILARLY / DIFFERENT_FAILURE / 精确 RETURN 原因。
回滚：临时 server/client process、Secret config、binary/workspace 全部清理；14443 absent；443 unchanged。
请 Reviewer 检查：server-core implementation 是否被有效隔离。
Owner 转交：NONE，除非真实 Owner host 不可访问。
耗时：预计 20-35 分钟；实际 <elapsed>；超时 YES/NO；原因 <NONE/brief cause>。
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
ROUND=G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3
ESTIMATED_EXECUTION_TIME=20-35 minutes
ESTIMATE_SCOPE=temporary pinned Mihomo server implementation + one unchanged client request + cleanup + Evidence/Handoff commit; includes modest allowance for shared-main reconciliation
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

- VLESS+REALITY compatibility: private listener/config and target TLS 1.3 reachability passed, but repeated sing-box canaries still fail with curl 35 / Mihomo TIMEOUT; R2 ended `UNKNOWN_AFTER_R2`. Next evidence target is a controlled temporary Mihomo-server implementation A/B, not more sing-box log parsing.
- Peak-hour repeatability: whether HY2 retains its same-window advantage during the user's known evening congestion window.
- Real workload behavior: Codex / OpenAI / image-generation long-task A/B is still untested.
- Final production role: HY2 primary vs on-demand backup vs WireGuard primary remains undecided.
- Final WireGuard security policy: whether the split-default/no-strict-kill-switch state is accepted for v1 or replaced by a different final routing design.
- Optional Linux tuning candidates (BBR/fq/GRO/MTU) remain untested and are not required unless later evidence justifies them.
- MVP v1 seal remains pending G2-C VLESS+REALITY integration, G2-D peak-hour/real-workload validation, and final architecture decision.

## NEXT_STEP

Await Owner authorization for **G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3**. The A-side sing-box failure is already accepted and will not be replayed; the next round runs only the Mihomo-server B-side once.

## OWNER_ACTION_REQUIRED

Authorize one additional **private** A/B request using a temporary Mihomo v1.19.31 server bound only to `10.66.21.1:14443`. No public TCP/443, persistent service, benchmark, target/SNI change, or production switch.

## REVIEWER_TO_EXECUTOR_RELAY

No active Executor run until Owner authorizes R3.

## EXECUTOR_TO_REVIEWER_RELAY

Use the fixed R3 packet in `CURRENT_GATE` after authorization.

## EVIDENCE_POINTERS

- `EXECUTION_EVIDENCE.md` — append-only execution proof through the successful 60+60 same-window comparison.
- `DECISION_LOG.md` — durable decision rationale for the kill-switch routing change and current production/candidate roles.
- `EXECUTOR_HANDOFF.md` — historical Executor factual notes; not canonical current project truth.
- `scripts/g2b-owner-runner.ps1` — accepted G2-B benchmark/runtime logic.
- `scripts/g2b-comparative-after-killswitch-repair.ps1` — successful final G2-B comparative checkpoint.
- Evidence commit `b85224370a295cc5128e29da9186573b81345d27` — same-window WG vs HY2 results and cleanup proof.
- Reviewer acceptance commit `cfb2d723657a5607c5d8c756705dc873c06babe5` — first formal acceptance of the completed G2-B evidence.

Historical Reviewer narrative remains available in Git history and is intentionally not duplicated in this dashboard.
