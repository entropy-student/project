# Karakeep Local · Reviewer Handoff

> 项目阶段：P0 / Windows 11 本机快速部署
> 本文件为项目当前 Reviewer 状态与当前 Gate；新项目尚无已接受的主机执行证据。
> 治理：`entropy-student/spike.skill` 的 `main:vps-project-governance/VNEXT.md`（当前 v0.2.7）。
> 更新时间：2026-10-16

## PROJECT_GOAL
在 Owner 的 Windows 11 本机，以最小改动运行 Karakeep 官方原版 Docker Compose，浏览器访问中文 Web 界面，验证可收藏网页。暂不接 Codex/AI API、不改上游代码、不公网开放。

## PROJECT_STAGE
G0_READ_ONLY_DISCOVERY，**未部署、未验证运行状态**。

## SYSTEM_MAP
- TARGET：Owner 实体 Windows 11 本机；PowerShell 7.x；具体当前 host/session/privilege 尚待只读复核。
- APP：Karakeep 官方 Docker Compose，默认包含 web / chrome / meilisearch 三服务。
- UPSTREAM：https://docs.karakeep.app/installation/docker/ ；官方 Compose：https://github.com/karakeep-app/karakeep/blob/main/docker/docker-compose.yml 。
- DATA：官方 Compose 使用 web data 和 meilisearch 命名卷；本机实际目标、备份和恢复方式尚未确认。
- NETWORK：拟仅绑定 `127.0.0.1:3000`，如冲突先 RETURN，不自动换端口；不映射公网/局域网、不建隧道。
- AUTH/SECRETS：后续需本机安全生成 NEXTAUTH_SECRET 与 MEILI_MASTER_KEY，值不得输出、提交或进入 Evidence；初期不设 OPENAI_API_KEY。
- DEFAULT_EXECUTION_CHANNEL：待 G0 确认为 Owner 本机原生 PowerShell / Codex；不假设云执行能操作真实本机。
- OTHER RUNNING WORKLOADS：UNKNOWN，不触碰别的 Docker 容器、卷、镜像或既有配置。

## CURRENT_ACCEPTED_STATE
- Owner 明确选择 Karakeep、目标 Windows 本机、优先快速部署和原生中文 Web UI（OWNER_REPORTED）。
- 仓库中原无本项目的现行 Handoff/部署证据。
- 无直接的本机 preflight、Docker Engine 运行、可用内存、端口和目录验证；一切均为 UNKNOWN。

## CURRENT_GATE
**GATE_ID**：KARAKEEP-WIN-G0-READONLY-DISCOVERY-20261016

**OBJECTIVE**：核实目标 Windows 原生会话、Docker Desktop/Compose、资源、端口和拟用数据路径，交给 Reviewer 直接形成最小部署 Gate。

**MAX_ENDPOINT_THIS_ROUND**：只读发现 + 脱敏证据记录；不得下载、拉取、安装、启动、创建、修改、删改或重启本机任何服务/文件/容器/配置；不得自动开启 Docker Desktop。

**MANDATORY_REVIEW_STOP**：完成 G0 后停在 Reviewer，不得自行继续 G1 安装。

**TARGET_AND_SCOPE**：Owner 当前 Windows 11 本机；Docker Desktop 原生 Windows CLI；项目相关检查以新项目为限。

**APPLICABLE_CRITICAL_CONSTRAINTS**：
- 不接触其他正在运行的 Docker 项目；不运行 docker prune / 清理 / 改 WSL 资源配额。
- 不请求也不输出 Cookie、token、Secret、用户名路径、设备唯一标识等敏感信息。
- 对 Windows 本机身份、Docker Context/Engine、宿主端口 3000、磁盘与内存提供实际只读观测；来自其他机器或 WSL/远程环境不得当成 Owner 实体主机。
- 如 GitHub 正式治理规则和本 Gate 冲突，返回 Reviewer 处理。

**PREFLIGHT**：
1. `$PSVersionTable.PSVersion`、OS 名称/版本、是否原生 Windows、Docker CLI/Compose 版本及 `docker context show`，避免输出隐私标识。
2. `docker info` 是否能连至本机 Docker Desktop Linux Engine，容器/镜像总量；`docker ps` 仅汇报运行容器的名称/镜像/端口（必要时去标识化）。
3. 可用内存（GiB）、系统盘剩余空间（GiB）、Docker Engine 资源与磁盘信息；不可自动更改 Docker/WSL 设置。
4. 检查 TCP 3000 是否被监听、是否被现有容器占用；拟用项目目录是否已存在及是否为空（只读），有未知内容即返回。
5. 确定实际官方 Docker Compose 路径/版本与下载来源，仅做互联网可达性探测，不下载。
6. 记录 Docker 环境异常、代理/联网限制、资源压力和第三方服务冲突的非敏感概要。

**REQUIRED_EVIDENCE**：
- `karakeep-local/EXECUTION_EVIDENCE.md` 首次追加 G0 事实，使用 `DIRECT_READBACK / OWNER_REPORTED / UNKNOWN` 标注来源，明确 `LOCAL_MUTATIONS=0` 或若实际发现例外如实报告。
- 最短回报包括目标身份可信度、Docker 引擎可用性、3000 端口、可用内存/磁盘、项目目录、障碍与下一步建议；不得粘贴原始大日志或 Secret。

**ACCEPTANCE_CRITERIA**：
- Reviewer 有足够只读证据给出 G1 部署配置：具体目标、Docker 运行可用性、端口和资源、存储路径、无影响其他业务的边界。
- 如 Docker 不可用/资源明显不足/路径或端口冲突/目标未证实，精确 RETURN，不猜测成功。

**ROLLBACK_STATUS_OR_PLAN**：G0 只读，除追加项目 Evidence 外不修改本机运行状态；无需本机恢复。G1 需另行冻结：项目专属 Compose、卷、回滚和备份方式。

**OWNER_ONLY_ACTIONS**：本 Gate 无需提供凭据或执行写操作；若无法从 Codex 证明本机执行环境，返回最小 Owner 本机检查动作。

**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是本 Gate 的 Executor。仅阅读 `entropy-student/project` 最新 main 的 `karakeep-local/REVIEWER_HANDOFF.md` 中 CURRENT_GATE，以及 Karakeep 官方 Docker Compose/安装文档所需片段。你正在 Owner Windows 11 本机的 Codex/PowerShell 环境执行 G0 只读检查，严格遵守 `MAX_ENDPOINT_THIS_ROUND`；不要安装、下载、拉取镜像、启动或变更现有 Docker。把脱敏检查结果追加到本项目 `EXECUTION_EVIDENCE.md`，提交到 GitHub，读回验证后按固定 Executor 完成格式报告。遇到无法确认本机身份、Docker 引擎或资源冲突则 RETURN，勿继续部署。

**EXECUTOR_TO_REVIEWER_RELAY**：结果（PASS_CANDIDATE / RETURN_*）；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
原版优先、Windows 本机、最小改动、保护现有 Docker 项目、不用真实外部 API 密钥、仅 localhost、不虚报部署成功。

## CURRENT_ROLLBACK_STATUS
NOT_APPLICABLE_G0（只读）；G1 前需确认后续部署的卷/恢复方案。

## UNRESOLVED
Docker Desktop 实际状态、内存余量、端口冲突、项目数据目录、代理是否影响 GHCR 拉取、权限/运行会话均为 UNKNOWN。

## NEXT_STEP
Owner 将 `REVIEWER_TO_EXECUTOR_RELAY` 发给本机 Codex，完成 G0；Reviewer 根据读回证据设计 G1 最短 Docker Compose 部署 Gate。

## OWNER_ACTION_REQUIRED
将 G0 Executor 指令提交给能访问 Owner 实体 Windows 本机的 Codex 会话。

## EVIDENCE_POINTERS
目前 NONE；正式 G0 证据将存于 `karakeep-local/EXECUTION_EVIDENCE.md`。
