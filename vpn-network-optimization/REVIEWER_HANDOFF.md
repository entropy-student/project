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
GATE_ID=G2B_HY2_Handshake_Auth_Diagnostic
STATE=READ_ONLY_DIAGNOSTIC
OBJECTIVE=Determine why the proxied HY2 handshake failed after proxy_used=1, without replaying the consumed full benchmark.
MAX_ENDPOINT_THIS_ROUND=Source/result diagnosis only. Any real-host probe that starts Mihomo, reads the DPAPI Secret, changes routes, or sends a new HY2 handshake requires a new bounded Owner authorization.
MANDATORY_REVIEW_STOP=YES
```

### TARGET_AND_SCOPE

Allowed now:
- inspect accepted runner/config/source;
- inspect the non-secret Owner-reported console output and persisted non-secret result metadata when available;
- identify which missing diagnostic field is needed next;
- prepare a bounded diagnostic repair/probe for later authorization.

Not allowed now:
- no second full runner invocation;
- no new temporary route;
- no Mihomo start;
- no DPAPI Secret read;
- no HY2 handshake replay;
- no MTU / BBR / fq / GRO / sysctl tuning;
- no WireGuard/VPS/HY2 reconfiguration or Secret rotation.

### APPLICABLE_CRITICAL_CONSTRAINTS

- The previous consequential authorization is consumed.
- Production WireGuard is the restored baseline.
- Current failure is not yet classified as TLS, HY2 auth, UDP path, server rejection, or OpenAI-side behavior because the failed handshake sample's curl exit/status/error fields were not retained.
- Diagnose one fault domain at a time; do not infer root cause from the generic failure code.
- Secret values remain inside the protected execution boundary.

### REQUIRED_EVIDENCE

For this diagnostic round:
- exact runner success predicate and failure ordering;
- what the retained output proves and does not prove;
- whether existing non-secret result artifacts contain the missing handshake curl exit / HTTP status / error class;
- if not, the smallest future diagnostic needed to capture those fields without running the 60+60 benchmark again.

### ACCEPTANCE_CRITERIA

This diagnostic Gate passes when Reviewer can state one of:
1. a root cause is proven from existing non-secret evidence; or
2. the exact missing fact is identified and a minimal bounded diagnostic is prepared, with no full benchmark replay.

### ROLLBACK_STATUS_OR_PLAN

Current accepted cleanup:
```text
PRODUCTION_WIREGUARD=RESTORED
TEMPORARY_VPS_ROUTE=ABSENT
MIHOMO_TEST_PROCESS=ABSENT
RUNTIME_SECRET_CONFIG=ABSENT
PLAINTEXT_SECRET_RESIDUE=0
CHECKPOINT_CLEANUP_FAILURE_COUNT=0
```

No new runtime mutation is authorized in this Gate.

### OWNER_ONLY_ACTIONS

Previous full-run authorization: **CONSUMED**.

Current Owner action: **NONE** until Reviewer finishes the read-only diagnosis. Any later real-host handshake diagnostic will receive a separate, narrowly scoped authorization request.

### REVIEWER_TO_EXECUTOR_RELAY

Executor startup for this diagnostic is intentionally narrow.

Read only:
1. this `CURRENT_GATE`;
2. `scripts/g2b-owner-runner.ps1` around `Invoke-CurlSample` and `HY2_OUTER_ROUTE_AND_HANDSHAKE`;
3. `config/clash/sfo3-a-hy2.yaml`;
4. the newest Evidence section `G2-B authorized retry after proxy-use validator repair — 2026-10-02`.

Do not reread full Governance, historical Handoff, old Gates, or the whole Evidence file.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
诊断：一句话说明已证明什么。
缺口：一句话说明还缺哪个具体事实。
下一步：一句话说明是否需要新的 Owner 本机诊断。
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

- HY2 real client handshake/proxy path after the validator repair is not yet proven.
- HY2 formal G2-B sample count is 0.
- WireGuard vs Hysteria2 performance/reliability conclusion remains UNKNOWN.
- MVP v1 protocol/config seal remains pending G2-B completion.

## NEXT_STEP

Diagnose only the HY2 handshake/auth failure. First preserve and inspect non-secret failure facts; do not rerun the full benchmark. If a real-host probe that starts Mihomo or reads the DPAPI Secret is required, obtain a new bounded Owner authorization for that diagnostic only.

## OWNER_ACTION_REQUIRED

**NONE right now.** The one-shot retry was executed and is consumed. Reviewer is diagnosing the HY2 handshake/auth failure before asking you to run anything else.

## EVIDENCE_POINTERS

- `EXECUTION_EVIDENCE.md` — append-only execution proof.
- `EXECUTOR_HANDOFF.md` — Executor factual completion notes only; not canonical project truth.
- `scripts/g2b-owner-runner.ps1` — current repaired runner.
- Commit `9b730b81e751099fae7c4c3c61e8a5a5a755877d` — HY2 handshake validator return recorded.
- Commit `ed4f8216ecd18dcea29f06f12fa0773c97c3cdf4` — proxy-use validator repair.
- Commit `3c381726f38950579bceb0f258ba46cc83c68328` — diagnostic/repair evidence record.
- Commit `165fc79b906dd6de858fdb6c3521e95f7b749136` — Reviewer acceptance and current Gate transition.

Historical Reviewer narrative before this compact-dashboard takeover remains available in Git history. It is intentionally not duplicated here.
