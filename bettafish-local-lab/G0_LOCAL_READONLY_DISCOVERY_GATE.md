# G0 — Local READ-ONLY Discovery (BettaFish)
> GATE_ID: BTFL-G0-READONLY-DISCOVERY-20261013
> STATUS: READY_FOR_EXECUTOR
> GOVERNANCE_INTERPRETATION: Reviewer; canonical v0.2.7
> UPSTREAM_REFERENCE: https://github.com/666ghj/BettaFish (main observed b67928ff1ce515dd7672408221fb1e9500d0972d)
> STOP_AT_REVIEWER: YES

## OBJECTIVE
在 Owner Windows 11 本地检查 BettaFish 采用 Docker Compose 安全部署的条件，识别现有 Docker、端口、磁盘、Secret、构建/镜像与网络依赖。绝不在 G0 安装或启动服务。目标是给后续 G1 提供可核查、最小化的事实，而不是宣称部署成功。

## MAX_ENDPOINT_THIS_ROUND
只读发现 + 报告文件写入 GitHub `entropy-student/project` 仓库的 `bettafish-local-lab/` 命名空间。绝不进入 G1。

## TARGET_AND_SCOPE
Target: Owner Windows 11 actual local machine, initiated from Owner-local Codex. Workspace: already existing local project repo checkout if available; if no safe checkout, emit exact `OWNER_RELAY` and return rather than guessed路径或越权创建/修改。
Read-only upstream: BettaFish README, LICENSE, Docker Compose, Dockerfile and `.env.example` references needed for compatibility/preflight; no broad unrelated project search.

## ACCEPTED_FACTS
- 官方 BettaFish Compose 使用 GHCR `ghcr.io/666ghj/bettafish:latest` 和 PostgreSQL 15，默认监听主机 5000、8501、8502、8503、5444。网页/数据库启动不自动代表社媒采集已可用。
- `MindSpider` 作为独立采集模块，需另行初始化、平台登录与授权。项目可能调用第三方模型和搜索 API 产生费用。
- Upstream README 声明仅学术/研究/教育用途、禁止商业化；代码仓库标示 GPL-2.0。许可与平台条款须分开对待。
- 尚无任何 Owner 机器上的部署/端口/Docker 状态被 Reviewer 直接验证；`UNKNOWN` 不可填成 `PASS`。

## APPLICABLE_CRITICAL_CONSTRAINTS
- Governance v0.2.7 §§0–10/11/12–13, triggered 11A Shared Storage/Docker resources; 11B Target Host+Secret; 11C Deployment/Network/Resources; 11D Automation/Auth; 11E provider API/account access if relevant. Reviewer already interpreted them; Executor 禁止再读取整份 Governance。
- G0 全面 READ_ONLY：禁止 Docker pull/build/up/start, git clone, 创建部署目录、安装 Docker Desktop/WSL2、修改服务、配置、共享网络、系统代理、VPN、路由、TUN、MTU、注册表、防火墙、端口、现有容器；禁止从现有 credentials/profile/cookies/.env 读取或输出值。
- 禁止访问/使用真实小红书/抖音/其他平台帐号、爬虫、真实 LLM API。不得创建费用，不得下载本地大模型。
- GitHub Evidence 唯一允许的写入范围：`entropy-student/project:main` 的新项目 `bettafish-local-lab/EXECUTION_EVIDENCE.md` 和 `EXECUTOR_HANDOFF.md`（若缺则创建）。记录只写非 Secret 事实。不得操作其他项目或 Governance。
- G0 不得要求管理员 PowerShell，需 Owner 提权/密钥/安装 -> `RETURN_OWNER_ACTION_REQUIRED`，而非自行提权。
- If repo or target identity unclear / unexpected changes present / material contradictions: stop with precise `RETURN_*`.

## PREFLIGHT / READ-ONLY TEST MATRIX
1. Prove *actual physical* Windows target: computer identity (sanitized), Windows version/build, current effective user/privilege, PowerShell version, local-vs-remote/Codex execution context. No value of any Secret.
2. Prove Git canonical local repo root/branch/HEAD/worktree status *if checkout exists* without changing branch or staging unrelated files; confirm no `bettafish-local-lab` local files that could be overwritten and no conflicting local BettaFish install.
3. Read only bounded environment state: `docker --version`, `docker version`, `docker compose version`, Docker Desktop/daemon availability; `wsl --status` only if it can be queried without starting/installing; CPU architecture, available disk and memory. Failure is a fact, not authorization to repair.
4. Check port ownership/read-only state for 5000, 8501, 8502, 8503, 5444 and 80/443, plus project-owned existing container names `bettafish`/`bettafish-db` and Docker networks/volumes as names only. Never `docker inspect` full raw ENV/Secret and never print process command lines containing credentials.
5. Source review: official upstream Compose ports/bind mounts/DB persistence/`.env` dependency, real image type and digest availability via metadata-only commands, model API key classes, startup healthchecks, build context, licenses, code source revision; record any mismatch. Do not pull image.
6. Plan G1 localhost-only port binding (`127.0.0.1:...`), no new firewall/ingress; choose isolated project scope and persistent DB/report paths only after proving no collision. Do not create paths yet.
7. Identify whether a proposed safe non-secret UI/DB smoke can run without model Secret in G1. Classify actual API key/cookie integration `UNRESOLVED` if absent rather than asking for values. No login/crawl.
8. Capture objective non-secret read-back of probes, sanitized commands/exit statuses and concrete blockers; no giant logs, home usernames, external IP, credential or private keys.

## REQUIRED_EVIDENCE
Append-only `bettafish-local-lab/EXECUTION_EVIDENCE.md`:
`AUTHORIZED_GATE`, `TARGET_IDENTITY_PROOF`, `PREFLIGHT_FACTS`, `SOURCE_AND_COMPOSE_FACTS`, `PORT_AND_RESOURCE_CONFLICTS`, `SECRET_AUTH_BOUNDARY`, `NEXT_GATE_DEPLOYMENT_PLAN`, `ACTUAL_CHANGES=NONE_TARGET`, `OBJECTIVE_READBACK`, `ANOMALIES`, `EXECUTOR_RESULT`; evidence source labels `DIRECT_READBACK` / `OWNER_REPORTED` / `INFERRED`. Can be short but exact.

`bettafish-local-lab/EXECUTOR_HANDOFF.md`: fixed six-line completion packet, bounded/secret-free. Commit only project-owned new docs to `entropy-student/project` `main` when current worktree safely allows; fresh remote file read-back, git SHA, and exact changed-file list. If unable to persist, RETURN with sanitized retained local evidence; do not falsely claim canonical persistence.

## ACCEPTANCE_CRITERIA
- Proved correct Windows target, actual Docker/Compose and port/resource state (even if `not installed`), no guessed facts;
- clear assessed feasibility of next G1, source/image version caveats, safe localhost binding and rollback approach; no real platform actions;
- no existing service/network/credential changes, no new costs or downloads;
- bounded, reviewable sanitized Evidence and handoff persisted on main with fresh read-back, or precise RETURN if blocked.
- Only Reviewer decides PASS after inspecting evidence.

## ROLLBACK_STATUS_OR_PLAN
G0 target unchanged: no runtime rollback. If any unintended consequential action appears, stop immediately, record objective non-secret footprint, RETURN for Reviewer reconciliation; do not improvise cleanup.

## OWNER_ONLY_ACTIONS
Install/enabling Docker Desktop or WSL/virtualization; elevation; Secret entry/rotation/account login; LLM API billing; permission/terms decisions; any public binding or production activation. All are DEFERRED, not authorized.

## REVIEWER_TO_EXECUTOR_RELAY
你是 Executor，使用 Owner 当前 Windows 11 本地 Codex，只执行 `BTFL-G0-READONLY-DISCOVERY-20261013`。
从 `entropy-student/project` 的 `main:bettafish-local-lab/G0_LOCAL_READONLY_DISCOVERY_GATE.md` 进入，仅在必要时读取旁边 `REVIEWER_HANDOFF.md` 中的 CURRENT_ACCEPTED_STATE、SYSTEM_MAP、CRITICAL_CONSTRAINTS；再按本 Gate 指名阅读 BettaFish 上游 README、Compose、Dockerfile、LICENSE 和相关 env 示例。
不得重读治理规范、扫描其他项目、改网络/VPN/代理、安装或部署软件、pull 镜像、请求或使用 Secret、调用付费 API 或爬虫。本 Gate 是只读环境发现，不得跨入 Docker 部署 G1。
核实物理 Windows 主机、Docker/Compose 可用性、现有端口/容器/资源、版本、路径冲突、localhost 安全部署约束；结果按 Evidence 契约写入项目独立 `EXECUTION_EVIDENCE.md`、`EXECUTOR_HANDOFF.md`（仅文件级文档写入，目标环境无变更）。只提交这两个非 Secret 文件并进行 GitHub main fresh read-back；不能提交则准确 RETURN。
最后按固定 6 行格式汇报，`STOP_AT_REVIEWER=YES`，不要自行宣称 PASS，也不要进入下一 Gate。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_*。
改动：只读本地诊断；仅向 bettafish-local-lab 写非 Secret Evidence/交接记录。
验证：报告主机/Docker/端口/资源/上游 Compose 事实及 read-back。
问题：NONE，或一条真实阻塞原因。
回滚：未改变本地运行环境；若有偏差则返回 Reviewer 处理。
请 Reviewer 检查：G0 Evidence、部署可行性、G1 Secret/localhost/资源/回滚边界。
Owner 转交：NONE，或必要的精确人工动作。
