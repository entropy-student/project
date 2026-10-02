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
GATE_ID=G2C_PRIVATE_REALITY_COMPAT_CANARY
STATE=AUTHORIZED_EXECUTION
OBJECTIVE=Prove the exact Windows Mihomo <-> sing-box VLESS+REALITY+Vision pair works before any public TCP/443 exposure.
MAX_ENDPOINT_THIS_ROUND=One temporary WireGuard-only canary on 10.66.21.1:14443, one real proxied HTTPS handshake, exact cleanup/read-back, then mandatory Reviewer stop.
MANDATORY_REVIEW_STOP=YES
```

### TARGET_AND_SCOPE

Authorized canary only:
- server implementation: sing-box **v1.14.2 stable**, Linux amd64;
- accepted asset: `sing-box-1.14.2-linux-amd64-glibc.tar.gz`;
- accepted SHA256: `5c7bc18461827b28d0e5ee7e89d33b276d3ff7c818531104c8e8d26d85b0656e`;
- temporary listener: **10.66.21.1:14443/TCP only**;
- protocol: VLESS + REALITY + `xtls-rprx-vision`;
- private-canary handshake target: `www.microsoft.com:443` only for interoperability proof; this target is **not** pre-approved for later public fallback;
- Windows client: existing `C:\Program Files\Clash Verge\verge-mihomo.exe`;
- local test proxy: loopback-only temporary mixed port `17990`;
- test endpoint: `https://api.openai.com/v1/models`; curl exit 0 + HTTP 401 is a successful transport/application reachability result.

Explicitly forbidden this round:
- no public `0.0.0.0:443` or public-IP:443 listener;
- no firewall rule, NAT, DNS, provider, sysctl, BBR/fq/GRO, WireGuard, HY2, or routing mutation;
- no persistent systemd service;
- no Clash Verge profile/default-node/system-proxy/TUN mutation;
- no benchmark;
- no protocol candidate expansion;
- no Secret value/hash in chat, GitHub, ordinary logs, stdout/stderr, command arguments, or environment variables.

### APPLICABLE_CRITICAL_CONSTRAINTS

- Foreground work and existing WireGuard/HY2 connectivity remain available.
- Strict SSH trust path is reused exactly: current key reference + known_hosts + `HostKeyAlias=24.199.118.137` + `HostName=10.66.21.1`; no private key copy/export.
- Ephemeral VLESS UUID / REALITY private key / short-id are created and consumed only inside protected process/stdin/runtime-file boundaries.
- Server Secret-bearing runtime material must be root-only and ephemeral; Windows Secret-bearing client config must be current-owner-only and ephemeral.
- sing-box binary is temporary/project-scoped and must be SHA256-verified before execution.
- Failure is fail-closed; cleanup/read-back still runs.
- One real handshake only; no performance comparison.

### PREFLIGHT

Executor must fresh-read:
- this current Gate and `REVIEWER_TO_EXECUTOR_RELAY`;
- current accepted G2-C preflight facts only;
- exact target scripts it creates/uses.

Before mutation prove:
- Windows PowerShell/runtime + existing Mihomo binary;
- WireGuard Manager/tunnel/adapter healthy;
- strict SSH native exit 0 and remote hostname/root identity;
- `10.66.21.1:14443` has no listener;
- public TCP/443 remains free;
- WG UDP/51820 and HY2 UDP/8443 remain healthy;
- no prior canary process/runtime residue.

### EXECUTION

Use one bounded Owner-local/Codex checkpoint. Implementation may be written by Executor, but it must:
1. download the pinned sing-box asset into a temporary non-Secret server workspace and verify the exact SHA256 before extraction/execution;
2. generate the REALITY keypair on the server without exposing the private key; generate/transport VLESS UUID and short-id through reviewed stdin/process-memory handling, never command args/env/stdout;
3. create root-only ephemeral server config under a runtime location, bind exactly `10.66.21.1:14443`, validate with `sing-box check`, then start only the temporary process;
4. positively verify listener is `10.66.21.1:14443` and negatively verify no `0.0.0.0:14443`, public-IP:14443, or TCP/443 listener was created;
5. create owner-only temporary Mihomo client config on Windows with VLESS + REALITY + Vision, server `10.66.21.1:14443`, local proxy `127.0.0.1:17990`, and the matching non-public client parameters;
6. validate Mihomo config, start one temporary Mihomo process, then issue exactly one curl request through `127.0.0.1:17990` to the OpenAI models endpoint;
7. record only sanitized markers such as proxy-used, curl exit, HTTP status, total/connect/appconnect times, listener/process state, and Secret counters;
8. always stop temporary Mihomo and sing-box, remove both Secret configs/runtime material and temporary binary/workspace, then fresh-read WG/HY2 and all canary ports/processes.

### REQUIRED_EVIDENCE

Required sanitized markers:
- `G2C_CANARY_PREFLIGHT=PASS`;
- `SING_BOX_VERSION=1.14.2`;
- `SING_BOX_ASSET_SHA256=PASS`;
- `SERVER_CONFIG_CHECK=PASS`;
- `PRIVATE_LISTENER_10_66_21_1_14443=YES`;
- `PUBLIC_14443_LISTENER=NO`;
- `PUBLIC_TCP443_UNCHANGED_FREE=YES`;
- `MIHOMO_CONFIG_CHECK=PASS`;
- `MIHOMO_TEST_PROXY_READY=YES`;
- `REALITY_CANARY_PROXY_USED=YES`;
- `REALITY_CANARY_CURL_EXIT=0`;
- `REALITY_CANARY_HTTP_STATUS=401`;
- `REALITY_CANARY_ERROR=NONE`;
- `REALITY_CANARY_RESULT=PASS_CANDIDATE`;
- cleanup: server/client canary processes absent, 14443 absent, runtime Secret files absent, temporary binary/workspace absent;
- WG UDP/51820 + HY2 UDP/8443 still healthy;
- `SECRET_VALUES_EMITTED=0`;
- `SECRET_VALUES_COMMITTED=0`;
- cleanup failure count = 0.

### ACCEPTANCE_CRITERIA

Reviewer may PASS this private compatibility canary only when:
- exact pinned sing-box candidate identity is proven;
- exact private-only listener boundary is proven positive + negative;
- existing Mihomo successfully completes the proxied OpenAI HTTPS request through VLESS+REALITY+Vision;
- no public TCP listener/firewall/routing/profile mutation occurred;
- all ephemeral Secret/process/binary residue is removed;
- WG/HY2 remain healthy;
- Evidence is persisted and reviewable.

This PASS would prove **interoperability only**, not public fallback safety or performance.

### ROLLBACK_STATUS_OR_PLAN

Rollback is deterministic cleanup:
- stop only the canary sing-box process by exact PID/identity;
- stop only the temporary Mihomo process;
- remove only the exact canary runtime directories/files created by this Gate;
- do not remove/modify shared or pre-existing services;
- verify TCP/14443 absent and TCP/443 unchanged;
- verify WireGuard and HY2 still healthy.

### OWNER_ONLY_ACTIONS

**AUTHORIZED by Owner on 2026-10-02 for this private canary.**

Authorization includes the temporary server/client writes, ephemeral credential generation, one compatibility handshake, and exact cleanup defined above. It does **not** include public TCP/443 exposure or a persistent service.

### REVIEWER_TO_EXECUTOR_RELAY

Start only from:
1. this Gate;
2. `CURRENT_ACCEPTED_STATE`;
3. `scripts/g2c-vless-reality-preflight.ps1` for the already-accepted SSH/runtime baseline pattern;
4. `scripts/g2b-owner-runner.ps1` only for reusable owner-only runtime-file/Mihomo-process/curl-sanitization patterns, not for G2-B history.

Accepted facts Executor may rely on:
- Owner authorization above is active;
- strict SSH identity exists at the current recorded path and passed immediately before this Gate;
- VPS identity is `ubuntu-s-1vcpu-512mb-10gb-sfo3`, Ubuntu 24.04.5, x86_64;
- TCP/443 was free; WG UDP/51820 and HY2 UDP/8443 healthy;
- server had no sing-box/Xray/Mihomo installation;
- current Windows Mihomo path/version family was already accepted;
- no need to rediscover historical G2-B root-cause work.

Executor must persist sanitized facts to `EXECUTION_EVIDENCE.md`, write its fixed completion packet to `EXECUTOR_HANDOFF.md`, commit project-owned changes, then STOP for Reviewer. Executor must not edit `REVIEWER_HANDOFF.md`.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：临时私有 REALITY canary，或 NONE（若 preflight 阻断）。
验证：sing-box identity / private listener / Mihomo handshake / OpenAI HTTP status / WG+HY2 unchanged。
问题：NONE，或精确阻塞原因。
回滚：临时 server/client process、Secret config、binary/workspace 已清理；14443 absent；443 unchanged。
请 Reviewer 检查：Evidence 是否足以证明 Mihomo <-> sing-box REALITY/Vison 兼容。
Owner 转交：NONE，除非 Executor 无法访问真实 Owner host。
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

- VLESS+REALITY side-by-side viability: TCP/443 ownership, server-core choice, handshake, and client compatibility remain unvalidated on this VPS.
- Peak-hour repeatability: whether HY2 retains its same-window advantage during the user's known evening congestion window.
- Real workload behavior: Codex / OpenAI / image-generation long-task A/B is still untested.
- Final production role: HY2 primary vs on-demand backup vs WireGuard primary remains undecided.
- Final WireGuard security policy: whether the split-default/no-strict-kill-switch state is accepted for v1 or replaced by a different final routing design.
- Optional Linux tuning candidates (BBR/fq/GRO/MTU) remain untested and are not required unless later evidence justifies them.
- MVP v1 seal remains pending G2-C VLESS+REALITY integration, G2-D peak-hour/real-workload validation, and final architecture decision.

## NEXT_STEP

Proposed next checkpoint, not yet authorized:

```text
CHECKPOINT=G2C_PRIVATE_REALITY_COMPAT_CANARY
SERVER_SCOPE=temporary project-local sing-box candidate only
LISTEN=10.66.21.1:14443 over existing WireGuard control network only
PUBLIC_TCP_443=UNCHANGED
CLIENT=existing Windows Mihomo / Clash Verge core
PURPOSE=prove current Mihomo <-> sing-box VLESS+REALITY+Vision interoperability before any public listener is created
SECRETS=ephemeral candidate UUID + REALITY keypair generated inside protected target boundary; no values emitted
CLEANUP=stop/remove temporary process/config/key material after result; preserve WG/HY2
MANDATORY_REVIEW_STOP=YES
```

Reason for the extra canary: current REALITY implementations have active cross-core compatibility churn, and unauthenticated REALITY fallback can forward to the configured handshake target. Therefore public TCP/443 deployment is intentionally deferred until compatibility and fallback-safety design are proven.

## OWNER_ACTION_REQUIRED

**NONE.** Owner has authorized the private canary. Executor may proceed inside the current Gate; public TCP/443 remains unauthorized.

## REVIEWER_TO_EXECUTOR_RELAY

```text
NO_ACTIVE_EXECUTOR_GATE
```

## EXECUTOR_TO_REVIEWER_RELAY

```text
NONE
```

## EVIDENCE_POINTERS

- `EXECUTION_EVIDENCE.md` — append-only execution proof through the successful 60+60 same-window comparison.
- `DECISION_LOG.md` — durable decision rationale for the kill-switch routing change and current production/candidate roles.
- `EXECUTOR_HANDOFF.md` — historical Executor factual notes; not canonical current project truth.
- `scripts/g2b-owner-runner.ps1` — accepted G2-B benchmark/runtime logic.
- `scripts/g2b-comparative-after-killswitch-repair.ps1` — successful final G2-B comparative checkpoint.
- Evidence commit `b85224370a295cc5128e29da9186573b81345d27` — same-window WG vs HY2 results and cleanup proof.
- Reviewer acceptance commit `cfb2d723657a5607c5d8c756705dc873c06babe5` — first formal acceptance of the completed G2-B evidence.

Historical Reviewer narrative remains available in Git history and is intentionally not duplicated in this dashboard.
