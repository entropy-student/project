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
- One repaired full retry completed WireGuard benchmark **60/60 with 0 failures**.
- Latest accepted WG sample: Median 0.600826s, P90 0.832286s, P95 1.111586s, P99 1.533950s, >1s 4, >1.5s 1, >2s 0.
- Runtime Secret config creation and owner-only ACL validation passed.
- Mihomo test proxy reached READY.
- The run returned before HY2 sample 1 because the old handshake-path validator incorrectly used curl `remote_ip == 127.0.0.1` as proof that the proxy was used.
- Read-only diagnosis proved curl 8.21.0 supports `%{proxy_used}`; direct no-proxy probe returned `proxy_used=0`.
- Current real-host cleanup read-back after that return is clean: TCP 17890 rows 0, UDP 17890 rows 0, Mihomo process count 0, runtime directory/config absent.
- Production WireGuard was restored and the temporary /32 route was removed.
- The repaired runner now uses `proxy_used`: WG requires 0; HY2/proxied requests require 1. TCP occupation preflight now treats only State=Listen as a listener.
- Repair accepted by Reviewer. No HY2 benchmark sample or protocol-performance conclusion exists yet.

Accepted source:
- Repaired runner commit: `ed4f8216ecd18dcea29f06f12fa0773c97c3cdf4`
- Repaired runner blob: `379ea04f108de20290ab5ae35e6a9dfbd70f02b6`
- Reviewer acceptance commit: `165fc79b906dd6de858fdb6c3521e95f7b749136`

## CURRENT_GATE

```text
GATE_ID=G2B_Full_Retry_After_ProxyUse_Repair
STATE=RETURN_TEST_FAILURE_DIAGNOSTIC_REQUIRED
OBJECTIVE=Diagnose the failed HY2 handshake/auth sample without replaying the consumed full benchmark.
MAX_ENDPOINT_THIS_ROUND=Read-only/source diagnosis first; any real-host Secret/Mihomo/handshake probe requires a new bounded Owner authorization.
MANDATORY_REVIEW_STOP=YES
```

### TARGET_AND_SCOPE

Owner authorization is now granted for this one bounded retry:
- Owner Windows host only for the local benchmark/checkpoint.
- Existing production WireGuard stays running.
- Existing Hysteria2 server on UDP 8443 is used as-is.
- One temporary exact `24.199.118.137/32` ActiveStore route via the already accepted WLAN path may be created and must be removed during cleanup.
- One test-only localhost Mihomo proxy on port 17890 may be started and must be stopped during cleanup.
- Canonical DPAPI recovery may be read only inside the protected Owner execution boundary to render the temporary runtime config.
- Non-secret benchmark result artifacts may be persisted.

Not allowed:
- No second runner invocation.
- No MTU / BBR / fq / GRO / sysctl tuning.
- No WireGuard stop/reconfigure.
- No VPS/HY2 redeploy or Secret rotation.
- No Secret value in chat, repo, console output, Handoff, Evidence, command arguments, or ordinary logs.
- No expansion into another protocol or architecture.

### APPLICABLE_CRITICAL_CONSTRAINTS

- Preserve production WireGuard and foreground tasks.
- Source identity must match the accepted repaired runner before consequential execution.
- Fresh runtime/target preflight is still required; static accepted documents are not a substitute for live state.
- Any material drift, ambiguous prior state, unexpected Secret/runtime residue, route mismatch, or cleanup failure returns to Reviewer.
- One authorization covers one consequential runner invocation only.

### PREFLIGHT

Before the one full invocation:
1. prove Owner PowerShell 7.6.6 / Administrator / High integrity;
2. prove accepted runner source/blob identity;
3. prove production WireGuard baseline and expected public exit;
4. prove temporary exact /32 route is absent before creation;
5. prove no Mihomo test process/listener/runtime config residue;
6. prove required WLAN/WireGuard adapter identity and accepted route prerequisites;
7. prove canonical DPAPI recovery artifact is available and protected without emitting Secret material;
8. create/read back only the exact temporary route required for the HY2 outer path;
9. fail closed before Secret access/benchmark if any required preflight item is not satisfied.

### REQUIRED_EVIDENCE

- source/commit identity;
- Owner-host privilege/runtime identity;
- preflight network/client state;
- temporary route creation/read-back;
- WireGuard benchmark sample count and Median/P90/P95/P99/tail metrics;
- HY2 proxy readiness and `proxy_used=1` handshake-path proof;
- HY2 benchmark sample count and same metrics;
- expected public exit/path checks;
- native exit/failure phase if any;
- Mihomo stop, runtime Secret config deletion, plaintext Secret artifact count;
- exact temporary route removal;
- production WireGuard restoration and final network read-back;
- Secret values emitted/committed = 0.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:
- one valid WG sample set;
- one valid HY2 sample set;
- HY2 path proven to use the local proxy and intended outer route;
- no unexpected public-exit/path drift;
- exact cleanup PASS;
- production WireGuard restored;
- no plaintext Secret residue;
- no second consequential invocation;
- complete reviewable non-secret Evidence.

Reviewer alone decides final PASS and whether G2-B supports a v1 protocol/config decision.

### ROLLBACK_STATUS_OR_PLAN

Current accepted baseline is already restored: production WireGuard active, temporary route absent, no Mihomo/runtime-config residue.

During the authorized retry, cleanup is mandatory even on failure:
- stop test Mihomo;
- delete temporary runtime Secret config;
- remove exact temporary /32 route;
- verify production WireGuard and final network state;
- if cleanup is incomplete or ambiguous, RETURN and do not retry.

### OWNER_ONLY_ACTIONS

Authorization status: **CONSUMED** by the 2026-10-02 formal runner invocation.

Scope of this authorization:
- one atomic Owner-local checkpoint;
- one formal runner invocation maximum;
- exact temporary route only;
- existing accepted runner/config only;
- mandatory cleanup/read-back;
- no MTU/BBR/fq/GRO/sysctl tuning;
- no second attempt.

The formal runner was invoked, so this authorization cannot be reused. No second full retry is authorized.

### REVIEWER_TO_EXECUTOR_RELAY

Owner authorization is granted. Executor startup is intentionally narrow.

Prepared Owner checkpoint:
- `scripts/g2b-owner-checkpoint.ps1`
- checkpoint blob: `4756ce6661a3613b80014f663b2f5f25f616ef92`
- checkpoint creation commit: `c94929f478a4856636bc88aa07708de5d23df545`
- it pins the accepted runner/config, creates the exact temporary route, invokes the formal runner at most once, persists non-secret results, and performs fallback cleanup/read-back.

Read:
1. this `CURRENT_GATE` section;
2. `scripts/g2b-owner-checkpoint.ps1`;
3. `scripts/g2b-owner-runner.ps1`;
4. `config/clash/sfo3-a-hy2.yaml`;
5. only the recent G2-B Evidence sections covering:
   - runtime ACL owner repair;
   - retry after ACL repair / HY2 handshake validator return;
   - HY2 proxy-use validator diagnostic and repair.

Accepted facts Executor may rely on are listed in `CURRENT_ACCEPTED_STATE`.

Do **not** reread full Governance, full historical Handoff, old completed Gates, or the whole append-only Evidence file. If a specific missing fact appears, do the smallest targeted read; confirmed material drift returns to Reviewer.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：一句话说明实际执行了什么。
验证：一句话总结关键结果；详细证据写入 EXECUTION_EVIDENCE。
问题：NONE / 实际阻塞原因。
回滚：一句话说明 cleanup 与生产 WireGuard 状态。
请 Reviewer 检查：一句话说明需要核对的 Evidence。
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
