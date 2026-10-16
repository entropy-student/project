# MokerSaaS — G0R RESOURCE READ-ONLY CONFIRMATION

> HISTORICAL GATE ONLY (not PASS): superseded by Owner decision `MOKER-D-20261016-NO-RAM-NUMERIC-GATE` and active `G1_LOCAL_HARDEN_COMPOSE_GATE.md`. Retained verbatim otherwise for audit; the old Relay below is INVALID and MUST NOT be used.
> GATE_ID: MOKER-G0R-RESOURCE-READONLY-20261013
> STATUS: SUPERSEDED_NOT_EXECUTED — Owner 2026-10-16 removed this numerical RAM gate; DO NOT EXECUTE
> MAX_ENDPOINT_THIS_ROUND: read-only latest physical host headroom, Docker engine memory and workload pressure check; chat-only sanitized result
> MANDATORY_REVIEW_STOP: YES
> STOP_AT_REVIEWER=YES

## OBJECTIVE
已接受 G0 源码/端口/环境静态发现，不重跑 G0。针对 G0 当前主机可用内存仅 0.81–1.44 GiB 的单一阻碍做一次只读资源门槛检查。提供可审查的主机和 Docker 内存事实，支持 Reviewer 判断能否授权后续独立 G1 本地源码安全适配与部署。这个 Gate 不允许部署。

## TARGET_AND_SCOPE
Owner 当前真正 Windows 11 本机 Codex 执行环境，排除 WSL/SSH/云端/Grok Bot/VPS。Owner 若已自行保存工作并关闭不必要应用，可以启动本次只读检查；Executor 不关闭进程。Reviewer 已读 Governance v0.2.7；Executor 仅读此 Gate 及 `REVIEWER_HANDOFF.md` 当前目标/约束，不重读整份规范、不遍历项目历史。

## ACCEPTED_BASELINE
- `MOKER-G0-LOCAL-READONLY-DISCOVERY-20261013` 已经 Reviewer 决定 discovery-only PASS，证据在 `EXECUTION_EVIDENCE.md`，但首次 runtime/build 未授权。
- Docker Desktop Engine 响应，29.7.2，Compose 5.4.0，Engine reporting 7.40 GiB, host total 15.28 GiB, previous available 0.81–1.44 GiB.
- G0 3077 / 5432 端口空闲；upstream security/provider/adapter/migration findings have not changed by accepted evidence. Do not repeat any of those probes without a specific discrepancy.
- No previously installed Moker project or accepted source checkout; no local mutation authorized.
- Project-specific conservative planning criterion for first app + Postgres Docker build/run: `HOST_AVAILABLE_RAM_GiB >= ~4` at check time, with no evident memory pressure; not proven upstream minimum, not universal. If under threshold return precise resource failure for Reviewer to decide light footprint alternative; do NOT claim machine cannot ever run Moker.

## APPLICABLE_CONSTRAINTS
- Governance v0.2.7 universal, triggered 11A resources, 11B physical host local proof/Secrets, 11C deployment resource boundary. 11D/11E real auth/payment actions are NOT authorized, they remain future scope.
- READ_ONLY: no clone/install/build/docker pull/up/restart/prune; no filesystem/config changes; no Docker/WSL daemon memory change; no forced app/process termination; no admin elevation; no network/firewall/VPN/Clash/HY2/WireGuard/route/proxy modifications; no reading Secret values, logs with tokens, personal identifiers or raw process commands.
- No need to obtain local project Git checkout for G0R; chat-only handoff and Reviewer GitHub persistence.

## PREFLIGHT AND PROBES
1. Prove the runtime remains genuine native Windows owner local Codex through short sanitized method summary (OS/process context, no identifiers). If ambiguous: `RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE`.
2. `Get-CimInstance Win32_OperatingSystem` memory totals and free, `Get-CimInstance Win32_ComputerSystem` physical memory/CPU count if needed. Report host total/free GiB only (two snapshots if possible, not scripted wait required); never print identity.
3. `docker info --format '{{json .MemTotal}}'` and native `$LASTEXITCODE`. Report only Engine reported RAM GiB. Verify `docker version` and `docker compose version` only if previous values appear stale or Docker is unavailable. No full docker info.
4. If available memory is still below ~4 GiB or fluctuates materially, record actual facts and stop with `RETURN_RESOURCE_HEADROOM_INSUFFICIENT`. Do not auto-close/kill apps. If >= ~4 GiB and stable between two short snapshots, `PASS_CANDIDATE` for resource review only.
5. No ports, source, payment, Neon, admin, Stripe or other deep scan absent specific new contradiction.

## REQUIRED_EVIDENCE
`GATE_ID`, `TARGET_LOCAL_PROOF`, `WINDOWS_VERSION`, `PS_VERSION`, `HOST_RAM_TOTAL_GiB`, `HOST_RAM_AVAILABLE_GiB` (two observations if possible), `DOCKER_ENGINE_RAM_GiB`, `DOCKER_RESPONSE_EXIT`, `RESOURCE_CRITERION`, `RESOURCE_GATE_STATUS`, `ACTUAL_CHANGES=NONE`, `OBSERVED_ERRORS`, `EXECUTOR_RESULT`. Label `OWNER_REPORTED` vs local `DIRECT_READBACK`. No names/paths/IPs/Secrets/raw logs. Fixed six-line completion after compact facts.

## ACCEPTANCE / ROLLBACK
PASS_CANDIDATE means headroom plausibly sufficient to plan G1; does not authorize G1 or guarantee safe build. Reviewer revalidates memory at G1 preflight. Fail below threshold: precise RETURN and Reviewer decides whether to lighten workload or defer. No mutations, rollback NOT_APPLICABLE. Unexpected mutation: stop, preserve bounded evidence, RETURN.

## OWNER_ONLY_ACTIONS
If useful, Owner saves work/closes chosen nonessential apps. No Executor process closing, Docker/WSL reconfiguration, administrator elevation or money/Secret permission. No further Owner decision needed for this read-only probe.

## REVIEWER_TO_EXECUTOR_RELAY
你是 Owner 本机 Windows 11 Codex Executor。只执行 `entropy-student/project` 最新 main:`mokersaas-local-lab/G0R_RESOURCE_READONLY_GATE.md`，必要时只读同目录 Handoff 的 accepted state/constraints。G0 已验收发现范围，不要重新克隆/安装/扫描源码、重复查端口或读治理规范。只读核对当前真正本机的总/可用 RAM、Docker Engine 内存容量及命令 exit；之前 0.81–1.44 GiB 可用内存不足，当前以新证据为准。以约 4 GiB 主机当前可用内存作为**本项目首次组合构建/启动的保守评审线**，不是官方最低要求。不得关闭进程或改系统/网络/VPN/Docker/WSL/Secret。仅在聊天返回 REQUIRED_EVIDENCE + 固定六行交接；若未达标 `RETURN_RESOURCE_HEADROOM_INSUFFICIENT`，达标 `PASS_CANDIDATE`，最后 STOP_AT_REVIEWER=YES；不进入 G1。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_RESOURCE_HEADROOM_INSUFFICIENT / RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE / RETURN_*。
改动：NONE_TARGET。
验证：本机两次内存快照 + Docker Engine 容量与原生命令结果。
问题：NONE，或明确资源不足/目标不明。
回滚：NOT_APPLICABLE。
请 Reviewer 检查：G1 是否允许独立安全补丁/本地 Compose 准备与启动。
Owner 转交：NONE，或仅 Owner 自愿关闭应用后可再次检查。
