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
- Latest authorized retry completed WireGuard benchmark **60/60 with 0 failures**.
- Latest WG sample: Median 0.604015s, P90 0.764660s, P95 0.797894s, P99 1.333582s, >1s 1, >1.5s 0, >2s 0.
- Runtime Secret config creation and owner-only ACL validation passed.
- Mihomo test proxy reached READY.
- The latest run passed the repaired `proxy_used=1` proxy-path assertion, then returned on the next assertion with `HY2_HANDSHAKE_OR_AUTH_FAILED` before HY2 sample 1.
- Therefore the request reached the local proxy path, but the proxied curl sample did not satisfy `curl exit == 0 && HTTP status == 401`.
- The retained console output did not include that sample's exact curl exit code, HTTP status, or classified error; root cause is still UNKNOWN.
- Cleanup passed: Mihomo stopped, runtime Secret config deleted, plaintext Secret artifacts 0, temporary route removed, production WireGuard restored, final test residue absent.
- No HY2 benchmark sample or protocol-performance conclusion exists yet.

Accepted source:
- Repaired runner commit: `ed4f8216ecd18dcea29f06f12fa0773c97c3cdf4`
- Repaired runner blob: `379ea04f108de20290ab5ae35e6a9dfbd70f02b6`
- Reviewer acceptance commit: `165fc79b906dd6de858fdb6c3521e95f7b749136`

## CURRENT_GATE

```text
GATE_ID=G2B_HY2_Handshake_Only_Probe
STATE=AUTHORIZED_HANDSHAKE_PROBE_PENDING
OBJECTIVE=Run one HY2 handshake-only diagnostic to capture the exact non-secret curl failure fields; do not replay WG/HY2 benchmarks.
MAX_ENDPOINT_THIS_ROUND=One temporary route + one protected Mihomo runtime + one proxied curl handshake + exact cleanup/read-back, then mandatory Reviewer stop.
MANDATORY_REVIEW_STOP=YES
```

### TARGET_AND_SCOPE

After fresh Owner authorization, allow exactly:
- Owner PowerShell 7.6.6 / Administrator / High integrity checkpoint;
- accepted runner/config source only;
- one exact temporary `24.199.118.137/32` ActiveStore route via WLAN;
- protected DPAPI Secret read only to construct the temporary Mihomo runtime config;
- one test-only Mihomo process on localhost port 17890;
- one proxied curl request to the existing OpenAI models endpoint;
- emit only these handshake diagnostics: `proxy_used`, curl native exit, HTTP status, runner error classification, and timing fields;
- mandatory cleanup of Mihomo/runtime config/temporary route and final WireGuard read-back.

Forbidden:
- no WireGuard 60-sample benchmark;
- no HY2 60-sample benchmark;
- no second handshake attempt;
- no MTU/BBR/fq/GRO/sysctl tuning;
- no WireGuard/VPS/HY2 reconfiguration or Secret rotation;
- no Secret values, Secret hashes, raw Mihomo logs, or raw server config output.

### APPLICABLE_CRITICAL_CONSTRAINTS

- Previous full-run authorization is consumed and cannot be reused.
- Production WireGuard remains the baseline.
- Fail closed on any preflight/source/runtime drift.
- The probe exists only to classify the current handshake failure; it must not become another performance run.
- Cleanup is mandatory even when the handshake fails.

### PREFLIGHT

Before the one handshake:
1. verify Owner runtime/elevation;
2. verify accepted runner/config identity;
3. verify production WireGuard and expected public exit;
4. verify exact temporary route and Mihomo/runtime residue are absent;
5. verify canonical DPAPI recovery availability/ACL without printing Secret material;
6. create/read back only the exact temporary route.

### REQUIRED_EVIDENCE

- `HY2_HANDSHAKE_PROXY_USED`;
- `HY2_HANDSHAKE_CURL_EXIT`;
- `HY2_HANDSHAKE_HTTP_STATUS`;
- `HY2_HANDSHAKE_ERROR`;
- handshake timing fields when parseable;
- whether Mihomo reached READY;
- cleanup result;
- temporary route absence;
- production WireGuard restored;
- runtime Secret config absent;
- Secret values emitted/committed = 0.

### ACCEPTANCE_CRITERIA

The Gate is diagnostic-only. PASS_CANDIDATE requires:
- exactly one handshake attempt;
- the four required non-secret failure/success fields are retained;
- no benchmark samples are run;
- exact cleanup passes;
- production WireGuard is restored.

Reviewer then classifies the failure domain and designs the smallest repair. This Gate does not itself PASS G2-B.

### ROLLBACK_STATUS_OR_PLAN

Current baseline is clean and restored. The diagnostic checkpoint must always:
- stop Mihomo;
- delete temporary runtime Secret config;
- remove exact temporary route;
- verify production WireGuard/public exit;
- stop at Reviewer.

### OWNER_ONLY_ACTIONS

**Authorization status: GRANTED** for exactly one HY2 handshake-only diagnostic. This is separate from the consumed full-run authorization and is consumed only when the handshake probe is actually invoked.

### REVIEWER_TO_EXECUTOR_RELAY

Executor should prepare only the handshake-only diagnostic path. It may read:
1. this Current Gate;
2. `scripts/g2b-owner-runner.ps1` around `Invoke-CurlSample`, DPAPI/runtime creation, Mihomo start, handshake, and cleanup;
3. `scripts/g2b-owner-checkpoint.ps1`;
4. `config/clash/sfo3-a-hy2.yaml`;
5. only the newest G2-B return Evidence.

Do not load full Governance or historical project narrative. Do not rerun any benchmark while preparing this probe.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
握手：proxy_used / curl exit / HTTP status / error
验证：一句话说明是否只执行了 1 次握手且无 benchmark。
回滚：一句话说明 Mihomo、runtime config、临时路由、WireGuard 最终状态。
问题：NONE / 实际阻塞原因。
Owner 转交：NONE / 最小必要动作。
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

After Owner authorization, run exactly one HY2 handshake-only diagnostic that captures the missing non-secret curl fields. Do not rerun either 60-sample benchmark.

## OWNER_ACTION_REQUIRED

**Run the prepared one-shot HY2 handshake diagnostic when presented.** No benchmark replay is authorized.

## EVIDENCE_POINTERS

- `EXECUTION_EVIDENCE.md` — append-only execution proof.
- `EXECUTOR_HANDOFF.md` — Executor factual completion notes only; not canonical project truth.
- `scripts/g2b-owner-runner.ps1` — current repaired runner.
- Commit `9b730b81e751099fae7c4c3c61e8a5a5a755877d` — HY2 handshake validator return recorded.
- Commit `ed4f8216ecd18dcea29f06f12fa0773c97c3cdf4` — proxy-use validator repair.
- Commit `3c381726f38950579bceb0f258ba46cc83c68328` — diagnostic/repair evidence record.
- Commit `165fc79b906dd6de858fdb6c3521e95f7b749136` — proxy-use repair acceptance.
- Commit `e9cb20b9acfc3ffae30b27fe7d1cfd5b46181478` — latest Owner G2-B return persisted to Evidence.
- Commit `e683604b5c8e1e4a49af472d2b3e21cfeba6383b` — current diagnostic Gate narrowed to handshake/auth only.

Historical Reviewer narrative before this compact-dashboard takeover remains available in Git history. It is intentionally not duplicated here.
