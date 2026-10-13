# BettaFish G0R — Target and Resource Read-Only Confirmation
> GATE_ID: BTFL-G0R-READONLY-TARGET-RESOURCE-20261013
> MAX_ENDPOINT_THIS_ROUND: sanitized physical host + memory + Docker allocation evidence, no target mutation
> MANDATORY_REVIEW_STOP: YES
> STATUS: READY_FOR_EXECUTOR

## OBJECTIVE
补上 G0 唯二实质缺口：真实 Windows host/runtime identity 和保守内存容量（G0 报告可用 RAM 约 1.4 GiB）。不要重复已报告且未有矛盾证据的端口、源码、镜像或 Docker 平台版本检查。当前 Git checkout 缺失不再是本 Gate 阻塞，因为 Reviewer 负责 GitHub Evidence 归档。

## TARGET_AND_SCOPE
Owner 当前物理 Windows 11 上运行的本地 Codex，**不是**云端 Agent、WSL 测试容器、Grok Bot、VPS 或其他机器。
Canonical doc: `entropy-student/project` `main:bettafish-local-lab/G0R_TARGET_RESOURCE_GATE.md`. Executor can read this exact doc directly via repository URL/API; local Git checkout is NOT required, is NOT to be created this round.
Source baseline: G0 reported Docker Desktop Engine 4.88.1 / Compose 5.4.0, free RAM ~1.4 GiB; these are OWNER_REPORTED facts pending bounded read-back.

## APPLICABLE_CRITICAL_CONSTRAINTS
Governance v0.2.7 already interpreted by Reviewer: sections 0–10, triggered 11A/11B/11C/11D; no Executor broad Governance reread.
READ_ONLY. No installing/building/pulling/up/down/restarting any Docker services; no Git clone/checkout; no adjusting Docker/WSL memory limits, proxy/VPN/Clash/HY2/WG/routing/firewall; no admin elevation; no killing apps/processes; no browsing stored secrets/browser profiles; no charging API or social account login.
All machine/user/host/network/Secret identifiers must be reduced to anonymous boolean or category evidence, not printed as values. Never print raw `docker info`, `docker inspect`, PowerShell process command lines or credential-bearing environment variables.

## PREFLIGHT
Check exact host context before trusting read-back. Suggested read-only commands (equivalents allowed):
- `$PSVersionTable.PSVersion.ToString()` and `[Environment]::OSVersion.VersionString`.
- `Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize,FreePhysicalMemory` (KiB; compute GiB and only output totals); `Get-CimInstance Win32_ComputerSystem | Select-Object TotalPhysicalMemory,NumberOfLogicalProcessors` (bytes, compute GiB).
- `docker info --format '{{json .MemTotal}}'` (Docker engine memory capacity bytes); check native exit code. Print capacity only.
- Confirm local-vs-remote execution by runtime evidence (OS/process parent, sandbox/WSL/SSH-related environment booleans and target identity) without disclosing hostname, username, serial, IP, MAC, auth material. If physical host identity remains uncertain, return `RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE`.
- Optionally repeat narrow Docker/target-port probe only if discrepancy appears; no raw process sensitive data.

## RESOURCE_GATE
Never claim a universal min RAM requirement. For conservative first Docker Compose app+Postgres+multiple Streamlit processes, propose at least ~4 GiB *currently available host memory* before any G1 runtime start, adequate Docker Engine/WSL allocation, and no evidence of memory pressure. This is a **review planning criterion** rather than a proven requirement for BettaFish. G0R must report whether it is met; if not, RETURN `RETURN_RESOURCE_HEADROOM_INSUFFICIENT`. Owner can voluntarily save work and close own unneeded apps, then re-run this G0R read-only check; Codex must not close them automatically.
If total host memory itself low or Docker engine allocation low, report fact and require new Reviewer judgment before any reconfiguration; NEVER auto-change host/global Docker settings.

## REQUIRED_EVIDENCE / ACCEPTANCE
Reply in chat with sanitized evidence compactly:
`GATE_ID`, `TARGET_LOCAL_PROOF` (specific mechanism, no identifier), `PS_VERSION`, `OS`, `HOST_TOTAL_RAM_GiB`, `HOST_AVAILABLE_RAM_GiB`, `DOCKER_ENGINE_RAM_GiB`, `RESOURCE_CRITERION`, `DOCKER_RESPONSE_EXIT`, `ACTUAL_CHANGES=NONE`, `RESULT`, `ANOMALIES`.
If a command is unavailable or fails, state exact sanitized stage and native exit code, not guessed capacity.
No local evidence file or GitHub commit is required or authorized for Executor; Reviewer will durably append the sanitized evidence to `EXECUTION_EVIDENCE.md` after reading/review. This is the explicit relay channel while no safe local checkout exists. The absence of local Git repo is NOT a blocker and is NOT an instruction to clone repo.
`PASS_CANDIDATE` only when target proven and resources sufficiently safe for future G1 consideration. If RAM criterion not met, `RETURN_RESOURCE_HEADROOM_INSUFFICIENT`. No G1 execution under G0R.

## ROLLBACK_STATUS_OR_PLAN
No changes allowed. If any unexpected mutation occurs, stop, report sanitized exact side effects, and `RETURN_*`; do not clean up without Reviewer.

## OWNER_ONLY_ACTIONS
Voluntary app closing / saving work if low available RAM; approve any Docker Desktop settings change, model credential, fee, platform login, public network exposure. None delegated now.

## REVIEWER_TO_EXECUTOR_RELAY
你是 Windows 本机 Codex Executor。只读 `entropy-student/project` 最新 `main:bettafish-local-lab/G0R_TARGET_RESOURCE_GATE.md` 并只执行该 Gate。
此前 G0 已检查 Docker、端口、上游，因没有 Git checkout 返回。**本轮不需要本地 Git checkout，不要创建它，也不要重新跑全部 G0。** 仅确认本轮确实运行在 Owner 实体 Windows 11 环境并核对主机总/可用内存、Docker Engine 可用内存。任何无法证明的信息填 UNKNOWN。
不得部署 BettaFish、运行容器、拉镜像、调整 Docker/WSL/VPN/系统、读取 Secret、调用模型或爬虫。仅在聊天中返回去敏结果，不需要 Codex 写入 GitHub；Reviewer 会归档。
按本 Gate REQUIRED_EVIDENCE 字段给出事实及结果，返回后 STOP_AT_REVIEWER=YES，不得进入 G1。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_RESOURCE_HEADROOM_INSUFFICIENT / RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE / RETURN_*
改动：NONE_TARGET
验证：目标物理 Windows 主机验证方法、主机总内存/可用内存、Docker Engine 内存容量和命令 exit。
问题：NONE 或具体阻塞。
回滚：NONE（只读）。
请 Reviewer 检查：目标同一性、资源是否足以允许独立 G1。
Owner 转交：NONE 或具体需要 Owner 自行做的动作。
