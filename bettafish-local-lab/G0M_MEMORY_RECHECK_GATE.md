# G0M: BettaFish Owner-Triggered Memory Recheck
> GATE_ID: BTFL-G0M-READONLY-MEMORY-RECHECK-20261013
> STATUS: CONDITIONAL_READY (only after Owner voluntarily closes nonessential apps)
> MAX_ENDPOINT_THIS_ROUND: one read-only host and Docker capacity check
> MANDATORY_REVIEW_STOP: YES

## OBJECTIVE
Recheck only the resource blocker after Owner independently saves work and closes unused apps. G0R reported 1.78 GiB host RAM available vs Reviewer conservative ~4 GiB; Docker Engine visible total capacity 7.40 GiB. This is NOT a validated upstream BettaFish minimum.

## TARGET_AND_SCOPE
Owner physical Windows 11 local Codex, PowerShell read-only; no Git checkout needed. Reviewer will handle documentation via GitHub. Earlier Docker version, ports, repo review are not repeated by default.

## CONSTRAINTS
No process stop/kill/restart by Codex, no Docker start/pull/build/recreate, no WSL/daemon memory-setting change, no VPN/Clash/HY2/WG/OS/network/firewall changes, no user credentials/session/cookie/.env/Secret read or output, no API calls or account actions, no Git write.
Do not print host/user identifiers, full environment, process command lines, memory dumps or private process details. If Owner cannot release resources safely, return `RETURN_RESOURCE_HEADROOM_INSUFFICIENT` and HOLD.

## READ-ONLY PREFLIGHT
- Confirm current Codex process runs under a Windows 11 local runtime using sanitized booleans/categories, same basic method as accepted G0R. No names/IDs required.
- Use `Get-CimInstance Win32_OperatingSystem` to read `FreePhysicalMemory` and `TotalVisibleMemorySize` (both KiB). Print host total and available GiB rounded to 2 decimals only.
- Read `docker info --format '{{.MemTotal}}'`, check native exit code; print engine total visible capacity GiB only. This is NOT Docker unused RAM.
- Optionally `Get-CimInstance Win32_OperatingSystem` / Windows UI only; no list of sensitive process args/metadata. One recheck after Owner acts, not an automatic polling loop.

## ACCEPTANCE_CRITERIA
`PASS_CANDIDATE` (for **resource preflight only**) requires same target, host available RAM >= 4 GiB, Docker engine accessible and enough capacity, no unexpected risk, and `ACTUAL_CHANGES=NONE`. Otherwise return a precise `RETURN_*` with reason.
Even on `PASS_CANDIDATE`, no actual BettaFish install/start is authorized; Reviewer later writes a separate G1 deployment Gate.

## REQUIRED_EVIDENCE
Reply sanitized in chat (Reviewer persists):
`GATE_ID`; `TARGET_LOCAL_PROOF`; `HOST_TOTAL_RAM_GiB`; `HOST_AVAILABLE_RAM_GiB`; `DOCKER_ENGINE_RAM_GiB`; `DOCKER_RESPONSE_EXIT`; `RESOURCE_CRITERION`; `ACTUAL_CHANGES=NONE`; `RESULT`; `ANOMALIES`; `STOP_AT_REVIEWER=YES`.
No Git evidence creation by Executor.

## ROLLBACK
Read-only; no local target mutation. Unexpected mutation -> stop and report.

## OWNER_ONLY_ACTIONS
Owner optionally saves and closes unneeded applications; no forced memory freeing. Any service shutdown, settings change or elevated work remains separate authorization.

## REVIEWER_TO_EXECUTOR_RELAY
你是 Owner Windows 11 本地 Codex Executor。请只执行 `entropy-student/project` 最新 `main:bettafish-local-lab/G0M_MEMORY_RECHECK_GATE.md`，前提是 Owner 已经自愿关闭不需要的应用程序。
仅做一次只读内存复测与 Docker Engine 容量读取；不用本地 checkout，也不要重跑此前环境审查。
不得结束进程、修改内存设置、重启 Docker、下载或安装 BettaFish、使用任何密钥或修改 VPN/网络；只在聊天中返回脱敏内存与是否达到 4 GiB 门槛的证据。
结果返回 Reviewer；无论结果如何，`STOP_AT_REVIEWER=YES`。不准进入 G1。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_RESOURCE_HEADROOM_INSUFFICIENT / RETURN_*
改动：NONE_TARGET。
验证：目标/主机可用内存与 Docker 容量只读检查；原生命令退出码。
问题：NONE 或具体阻塞。
回滚：NONE。
请 Reviewer 检查：G1 是否可以单独授权。
Owner 转交：NONE 或明确待 Owner 自己处理的资源问题。
