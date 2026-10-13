# MediaCrawler G1M — Windows one-shot read-only RAM pressure attribution
> GATE_ID: MC-G1M-WIN-MEMORY-READONLY-DIAG-20261013
> STATUS: READY_FOR_EXECUTOR_AFTER_OWNER_RELAY
> MAX_ENDPOINT_THIS_ROUND: One approx 45–60-second purely read-only Owner-local Windows memory/commit/process-category snapshot; no files/downloads/installs or processes changed
> MANDATORY_REVIEW_STOP: YES

## OBJECTIVE
Two pre-install stops: G1 missed uv/Python3.11, and G1R failed RAM headroom before ANY file write (latest available 1.091/1.106 GiB vs Gate 1.5 GiB). Prior unrelated BettaFish Docker image pull also saw low RAM but its cause is unknown. Owner needs to keep other projects running AND use original MediaCrawler quickly. **Resolve one narrow uncertainty: where is current RAM pressure and is it sustained, so Reviewer can choose a safe executable next Gate rather than retrying speculatively.** Never infer MediaCrawler app memory consumption: it has not run once.

## TARGET_AND_SCOPE
- Owner physical Windows 11 x64, local Codex/PowerShell 7.6.5. No SSH, WSL shell, VPS, Docker CLI calls, browser/CDP, social platforms.
- All of this Gate is local READ_ONLY metadata probing. No project folder creation, no cache/log files or telemetry uploads. Shell one-liners/in-memory variables only; 3-4 snapshots spaced ~15s, total <75s. If any metric unavailable, mark `UNKNOWN/UNAVAILABLE` and continue only with available read-only data; do not elevated-retry/fix providers.
- Use Windows built-ins with verified version compatibility: `[Microsoft.VisualBasic.Devices.ComputerInfo]` only if assembly already loaded/available without installing (optional) OR `Get-CimInstance Win32_OperatingSystem` `FreePhysicalMemory/TotalVisibleMemorySize/TotalVirtualMemorySize/FreeVirtualMemory` (values KB), and `Get-Counter` for `\\Memory\\Available MBytes`, `\\Memory\\Committed Bytes`, `\\Memory\\Commit Limit` if counters work. Optional `Get-Process` `WorkingSet64` and `PrivateMemorySize64`; do not query any process CommandLine/ExecutablePath/UserName/Title/Environment or `docker inspect`. If alternate sources disagree, report each source separately instead of switching units/claiming one 'total used'.
- Memory buckets only: browsers (msedge/chrome/etc), AI & IDE/editor (Code/Codex/antigravity variants), developer runtimes (node/python), Docker/WSL backend (vmmem/WSL/docker/containers), OS/desktop/security, OTHER. If classification ambiguous, OTHER; no project/app-specific personal names, browser URLs, window titles, process IDs, process command lines, account names, absolute paths. Report bucket working sets / private bytes *aggregated*, process count per bucket, and anonymous TOP 5 process memory quantities + bucket (no process identity if name private). Explain that working sets can double-count shared pages, so categories cannot be simply subtracted from total RAM to prove reclaimable memory.
- Owner prefers keeping existing workflows; **NO program/process stopping or memory cleaning** in this Gate.

## APPLICABLE_CRITICAL_CONSTRAINTS
Canonical Governance `entropy-student/spike.skill` `main:vps-project-governance/VNEXT.md` v0.2.7 universal + 11A/11B/11C/11D triggers as applicable. Executor reads only this Gate, not broad history.
- Never kill, trim, suspend, restart, modify priority/affinity or close user process; no RAM optimizer, no cache purge, pagefile changes, Docker/WSL memory settings, services, Task Scheduler or registry writes. Do not run `docker stats`, `wsl --shutdown` or anything that could spawn heavyweight runtime. No heavy script imports/dependency install, admin, SSH, internet or local project writes. No credentials or private data.
- If task cannot obtain host performance metrics without elevation, do not request elevation; RETURN partial with observed non-sensitive facts. Use two lightweight sampling methods if practical to validate metric provenance; avoid busy polling.
- This Gate does not authorize MediaCrawler cloning/install, uv/Python tool download, browser run, account login, real crawler/API calls, or any network activity.

## PREFLIGHT
1. Prove intended physical Windows local Codex context as far as possible without exposing host identity, usernames or process ancestry full paths. If target unknown, RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE, no guessing.
2. Before read-only sampling, ensure relevant cmdlets work and no unexpectedly heavy privileged target probe is required. No prerequisite RAM minimum for small metadata-only read operations.
3. The recent RAM values are *historical samples*, not current fact; take fresh values. Do not assume any given executable caused the historical 0.587 GiB / 1.091 GiB dips.

## EXECUTION
A. Take initial `Win32_OperatingSystem` read-only memory total/free/commit proxy & `Get-Counter` memory available/committed/limit metrics (or equivalent safe trusted built-in). Cross-check GiB conversion using 1024^3; distinguish physical RAM TOTAL / OS AVAILABLE, commit bytes/limit, and pagefile. Mark uncertainty if data source is not equivalently `available`.
B. Capture lightweight `Get-Process` memory metadata, aggregate into above buckets with generic process name allowlist, summarize working set and private bytes per bucket, not raw process list. A single process can be in a user workflow and must not be labeled `safe to close`.
C. Take total 3–4 samples spaced approximately 15s (within one minute) of host available RAM and commits, ideally also aggregate bucket memory. Record min/max/change and presence of sustained pressure, not an instant passing value. If host responds badly to inspection, stop probe; no repair.
D. Return **evidence-bounded classification** `SUSTAINED_LOW_HEADROOM | INTERMITTENT_PRESSURE | ADEQUATE_AT_SAMPLE | UNKNOWN`, largest categories, confidence `HIGH/MED/LOW` based on measurements. Do not assign cause solely because category is largest or blame Docker/image pull without evidence.
E. Suggest ONE safe next decision: `STAGED_LOCAL_INSTALL_CANDIDATE` only if headroom appears sustained and future Chromium runtime risk addressed; `RETAIN_LOCAL_BUT_DEFER_INSTALL` if memory is fluctuating and already below threshold; `REMOTE_RESOURCE_CHECK_CANDIDATE` only if persistent low headroom and Owner willing to choose another target. Suggestions do not grant permission. No cleanup/execution this round.

## REQUIRED_EVIDENCE
`GATE_ID`, `WINDOWS_TARGET_CLASS`, `SAMPLE_COUNT`, `SAMPLE_DURATION_SECONDS`, `RAM_TOTAL_GiB`, `RAM_AVAILABLE_SOURCE_AND_SAMPLES_GiB`, `RAM_AVAILABLE_MIN_MAX_GiB`, `COMMITTED_GiB_SAMPLES`, `COMMIT_LIMIT_GiB`, `PAGEFILE_TOTAL_OR_UNAVAILABLE`, `BUCKETS_COUNT_WORKINGSET_PRIVATE_GiB`, `TOP5_ANON_MEMORY_BUCKETS`, `CROSS_SOURCE_DISAGREEMENT_OR_NONE`, `PRESSURE_CLASS`, `ROOT_CAUSE_CONFIDENCE`, `NEXT_ACTION_SUGGESTION`, `ACTUAL_CHANGES=NONE`, `NON_TARGET_DELTA=NONE/UNVERIFIED`, `NO_NETWORK_OR_INSTALL_BOOL`, `ANOMALIES`, `RESULT`, `STOP_AT_REVIEWER=YES`.
No usernames, PIDs, process names of private projects, paths, server IPs, command line, cookies, chat content or credentials. Where unavailable mark UNVERIFIED not zero.

## ACCEPTANCE_CRITERIA
`PASS_CANDIDATE` for **read-only resource attribution** if sampled memory and commits with enough confidence for a choice and no writes/process modifications. A resource `PASS_CANDIDATE` is NOT MediaCrawler installation PASS. If metrics sparse, `PARTIAL` and report exact missing fact; if target unproven or command failure material, precise `RETURN_*`, no guessing. Always STOP_AT_REVIEWER; never resume G1R or install uv automatically.

## ROLLBACK_STATUS_OR_PLAN
No writes, no installation, no system/other-app changes, therefore rollback NONE. Any observed accidental state change => stop and report before retry.

## OWNER_ONLY_ACTIONS
Forward relay approves one read-only short RAM diagnosis; no automatic program closing, install, machine-wide settings, credentials, remote servers, paid usage or network. If recommendation would require pausing Owner applications or VPS access, Reviewer will ask Owner specifically in next round.

## REVIEWER_TO_EXECUTOR_RELAY
当前 MediaCrawler 仍未安装：G1R 在 uv 下载前因为 Windows 可用内存约 1.09 GiB 而 `RETURN_RESOURCE_HEADROOM_INSUFFICIENT`。请读取 `entropy-student/project` 最新 main 的 `mediacrawler-local-lab/G1M_WINDOWS_MEMORY_READONLY_DIAGNOSTIC_GATE.md` 并执行 **一次约 45–60 秒的严格只读本机内存诊断**。用 Windows 自带命令检查物理内存总量/可用内存、提交内存和上限，聚合浏览器/开发工具/Node-Python/Docker-WSL/系统/其他进程类别的占用（只输出去敏汇总，绝不输出进程完整命令行、用户名或私有项目名称）。观察三四次，找出是否持续紧张或偶发波动，以及下一步最有依据的方向。不安装软件、不下载、不创建文件、不关程序，不修改 Docker/WSL/Clash/VPN/浏览器或任何系统设置，不连接服务器/社交平台；不得因瞬时内存恢复而擅自重试 G1R。返回去敏诊断、结论及可行下一步，`STOP_AT_REVIEWER=YES`。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / PARTIAL / RETURN_*。
改动：NONE；纯只读。
验证：RAM 可用/提交/上限多次采样、主要内存类别占用及趋势，不输出私人进程细节。
问题：NONE 或有界归因/指标不可得。
回滚：NONE。
请 Reviewer 检查：是否批准分步本机安装，还是选择单独服务器验证。
Owner 转交：NONE。
