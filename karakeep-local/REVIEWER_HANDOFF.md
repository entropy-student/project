# Karakeep Local · Reviewer Handoff

> 项目阶段：P0 / Windows 11 本机快速部署
> 治理：`entropy-student/spike.skill` `main:vps-project-governance/VNEXT.md` v0.2.7
> Reviewer 更新时间：2026-10-16

## PROJECT_GOAL
在 Owner 的 Windows 11 本机快速部署 Karakeep 官方原版 Docker Compose，以简体中文 Web UI 访问、保存书签为后续目标。首轮先验证三服务健康和本机 Web 登录页；不改 Karakeep 源码，不接 Codex、不接 AI API、不公网开放，不扰动任何现有 Docker 项目。

## PROJECT_STAGE
G0 完成并由 Reviewer 复核；原 Executor 结果 `RETURN_STORAGE_LAYOUT_UNRESOLVED` 如实保留，但阻碍因素已通过 Reviewer 指定专用项目路径转移为 G1 前置检查。**目前仍未在 Owner Windows 本机部署。**
当前：`G1_LOCAL_DOCKER_DEPLOY_READY`（待 Owner 本机 Codex 执行）。

## SYSTEM_MAP
- TARGET：Owner 指定的 Windows 11 实体本机；原生 PowerShell 7.6.5（Owner 报告 + G0 本机实测），Docker Desktop Linux Engine 29.7.2、Compose v5.4.0，context `desktop-linux`；有效身份每轮重新核实。
- UPSTREAM：官方 `https://raw.githubusercontent.com/karakeep-app/karakeep/main/docker/docker-compose.yml`；G0 读到的 blob `865bb147cef972926d5dc32e50645876fd110555`；3 服务 `web / chrome / meilisearch`，镜像版本应从下载配置与实际 Digest 读回。
- PROJECT_LOCAL_CONFIG：`$env:LOCALAPPDATA\KarakeepLocal` 下存放 Compose 与受保护的 `.env`。这是 Reviewer 给新项目选定的默认路径（不是已验证或已创建的路径）；G1 首先只读检查不存在、或空且无未知文件，否则 RETURN。不向 GitHub 上传本地 Secret。
- DURABLE_DATA：采用官方 Compose 的专属命名卷 `karakeep-local_data` 和 `karakeep-local_meilisearch`（通过 `docker compose -p karakeep-local` 隔离），分别承载应用数据库/资产、搜索索引。不得使用匿名卷、覆盖/复用已有非本项目卷；实际名称部署后 read-back。
- BACKUP/RECOVERY：G1 是无真实资料、无账户的初装空系统；中断时仅 `docker compose -p karakeep-local down` 停止本项目容器、保留持久卷和 `.env`，不得 `down -v`。部署后需要向 Owner 说明，真实收藏投入使用前须落实 `data` 卷备份与至少一次可恢复性核验、Secret 安全恢复方案。首次空系统可全部重建，绝不把未验证备份写成 PASS。
- NETWORK：仅 `127.0.0.1:3000` -> web:3000；Chrome/Meili 不向 Host 暴露端口。仅对官方 Compose 的 web `ports` 行做最小 localhost 限制，其余内容不改。
- AUTH/SECRETS：新装专属 `NEXTAUTH_SECRET` 与 `MEILI_MASTER_KEY` 由 Owner 授权的本机执行产生，存于受限的项目 `.env`，禁止输出/进入 GitHub/普通日志。首次不配置 `OPENAI_API_KEY`；不代 Owner 创建首次管理员账号。
- DEFAULT_EXECUTION_CHANNEL：Owner 本机已验证可执行原生 PowerShell 的 Codex；此云端 Reviewer 不能直接变更该实体主机。
- OTHER_WORKLOADS：G0 有 3 个现有运行容器（WordPress cli/web + MariaDB）；不得停止、更改、清理或重启它们。

## CURRENT_ACCEPTED_STATE
- G0 Evidence 已从 GitHub main 读取：`karakeep-local/EXECUTION_EVIDENCE.md`（2026-10-16，commit ec4f95d）。
- `DIRECT_READBACK`：Windows native, Docker Desktop Linux Engine 可访问（Engine RAM 7.40 GiB）、17 containers/3 running、9 images；3000 Windows/容器端口均空闲；宿主可用 RAM 2.20 GiB、C 盘可用 191.61 GiB。
- `DIRECT_READBACK`：Karakeep 官方三服务 Compose 的文件及官方文档可经 HTTPS 访问；GHCR TLS 可达，但拉镜像及 Docker Engine 后端可用磁盘容量尚未验证。
- `UNKNOWN`：本轮 G1 开始时内存/端口新鲜读数、`$env:LOCALAPPDATA\KarakeepLocal` 的存在与安全性、Docker 实际磁盘剩余可写空间、GHCR 镜像可拉取。
- REVIEWER_DECISION：G0 的存储路径未指定由本 Handoff 明确解决，实际空目录归属检查移至 G1 preflight；内存 2.20 GiB 对三容器全套存在压力但非已证明失败，批准**有资源停止条件的一次受控部署尝试**，禁止为了通过而关闭已有应用。G0 Executor 的 RETURN 原始记录不改写成 PASS。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G1-LOCAL-DOCKER-DEPLOY-20261016`

**OBJECTIVE**：仅为新 Karakeep 项目安装官方 Compose 三服务，确认 `localhost:3000` 可访问、容器与 DB/搜索/浏览器依赖健康、资源未恶化其他项目。

**MAX_ENDPOINT_THIS_ROUND**：在明确的 Preflight 全部通过后，允许下载官方 Compose、仅将 web 端口限制为本机回环，安全生成/安装这次 Karakeep 必需的两个全新 Secret，pull 本项目三镜像，`docker compose -p karakeep-local up -d`，进行健康/资源验证与项目独立回滚。不允许注册管理员、批量导入资料、AI 推理、自动化收藏、公开访问，也不允许下一 Gate。

**MANDATORY_REVIEW_STOP**：运行并完成 G1 后停在 Reviewer；PASS_CANDIDATE 不是 PASS，不自动继续到注册/正式收藏。

**TARGET_AND_SCOPE**：
- 仅 Owner Windows 11 本机、`$env:LOCALAPPDATA\KarakeepLocal`、新 Compose 项目 `karakeep-local`、两个新命名卷；
- 严禁修改已有 Docker daemon、WSL、其他项目、Caddy/代理/VPN、现有 volumes、现有容器或全局网络；
- 不更改 Karakeep 业务源码；只允许 Compose web 端口本地化。

**APPLICABLE_CRITICAL_CONSTRAINTS**：
- G0 的测量是历史值，G1 安装前需要新鲜主机/资源/路径/3000 端口实测；
- 初装资源偏紧：启动前宿主可用 RAM 必须 ≥2.0 GiB；启动后任何明显 OOM/系统变得不稳定、现有容器退化、或稳定空闲时可用 RAM <0.8 GiB，即主动停止**本项目**并 RETURN。此为本轮临时安全阈值，而非通用规范；
- 需要 Docker Engine 实际可用磁盘空间的可信读数（安装及卷需留合理空间，至少 8 GiB），仅宿主 C 盘 191 GiB 不能代替 Engine 读数；无法确认则 RETURN；
- 严禁因资源不足关闭或清理已有 3 个运行容器/执行 prune；
- Secret 不出控制台、命令参数、日志、Git、普通 Evidence；Owner 明确技术委托只可来自其提交的该次 Executor 指令，委托范围须为本机此项目独立 Secret、禁止覆盖现有、恢复/退役边界明确。若无有效 Owner 授权，RETURN_OWNER_ACTION_REQUIRED；
- 安全输出、最小日志，仅报脱敏非 Secret 结论。

**PREFLIGHT**：
1. 再确认原生 Windows 本机、Docker `desktop-linux` Engine、当前 3 个原有容器名称/状态内部基线；3000 端口空闲；新鲜宿主 RAM、Docker 可用磁盘及项目数据/镜像足迹；如 RAM <2.0 GiB、Docker 可用空间 <8 GiB 或无法验证，直接 RETURN。
2. `$env:LOCALAPPDATA\KarakeepLocal` 的真实展开路径与内容只在本机检查，不输出私有用户名；若路径存在非空、symlink/reparse 异常、或者所属 ACL 不明，RETURN，不删除或覆盖。两个 `karakeep-local_*` 命名卷/同名 Compose 项目如已存在，需先只读分类；未知/非空则 RETURN。
3. 核对官方 Compose 来源和当前文件身份，固定本次安装候选；读取 `docker compose config` 时不得向普通日志泄露 Secret（使用安全输出或只验证退出码）；限制发布地址到 127.0.0.1。
4. 验证负责创建 Secret 的本机 Owner 授权范围和权限模型；仅在受限新目录生成 cryptographically secure Secret，拒绝覆盖，备份/恢复状态标记为初装空系统，禁止在 G1 输入真实用户数据。
5. 判断已有运行容器/端口/配置/内存占用的非目标基线，部署后对照。

**REQUIRED_EVIDENCE**：
- 追加到本项目 `EXECUTION_EVIDENCE.md`，标明 Gate、preflight、实际创建的**脱敏**文件/卷/容器名字、官方 Compose 版本/镜像 digest、localhost 端口负面边界、三服务健康与访问层响应、新旧宿主内存、磁盘使用与其他 3 容器是否无变化。
- 对 pull 失败、健康失败、OOM、空间不足或权限/网络问题，记录准确 RETURN 原因和局部回滚效果；不记录 Secret/真实本机私有路径。
- GitHub 证据提交后由 Executor 从 main 读回，与本轮 host 读数对应。

**ACCEPTANCE_CRITERIA**：
- 本机 Web `http://127.0.0.1:3000` 进入登录页，HTTP/应用与三服务运行/依赖状态分别验证，而非只凭容器 `running`；
- 只绑定 127.0.0.1，未对局域网/公网或其他服务开放 Web；Chrome/Meili 不映射 Host；
- 命名卷可识别且归属项目，配置重启持久性得到验证（不得盲目使用会造成重新 pull 或重建的命令），且不引入真实唯一数据；
- 没有影响原本三个正在运行的容器；资源阈值/异常检查通过；无 Secret 泄露；
- 未注册账户、未新建真实收藏、未对其他 Docker 项目写入。

**ROLLBACK_STATUS_OR_PLAN**：
- 新部署错误、低内存、服务冲突：仅对明确项目 `docker compose -p karakeep-local down`，保留 `.env` 和两个命名卷；不 `down -v`、不 Docker prune，不删除陌生文件；
- 镜像/启动失败的部分对象先只读分类再按本项目专属范围停止，避免误动其他服务；
- 首次空系统没有用户数据，恢复方法为同版本镜像和 Compose 重启；实际恢复未验证则明确标记 `RECOVERY_UNVERIFIED`。

**OWNER_ONLY_ACTIONS**：
- Owner 在转交本 Gate 给本机 Codex 时，应明确授予仅限 `KarakeepLocal` 初装、两个新随机 Secret 的创建与本机保护权限（禁止覆盖与输出），并知悉初期不保存真实资料、不得公开访问；
- Owner 本人在部署通过后完成第一次注册/简体中文设置，此事不属于本 Gate。

**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是 Karakeep Windows 本机部署的 Executor。仅读最新 main `karakeep-local/REVIEWER_HANDOFF.md` 的 CURRENT_GATE、CURRENT_ACCEPTED_STATE、SYSTEM_MAP、CRITICAL_CONSTRAINTS，并只读核对 `karakeep-local/EXECUTION_EVIDENCE.md` 的 G0 摘要及 Karakeep 官方 Docker Compose 与必要安装说明。按 `KARAKEEP-WIN-G1-LOCAL-DOCKER-DEPLOY-20261016` 执行，不重跑 G0、不得扩展目标。基于新鲜 Preflight 复核 `$env:LOCALAPPDATA\KarakeepLocal` 及 Docker Engine 实际磁盘可用容量。仅当本次 Owner 转交中有明确的本机项目专属 Secret 创建授权、G1 所有资源/身份前提通过时，完成官方三服务最小部署（Web 只绑定 127.0.0.1），验证 localhost 登录页与其他容器没有退化。发生资源压力按本项目范围回滚；任何未知或阻塞精确 RETURN，不改其他项目。追加脱敏 Evidence，提交 main 并读回，按固定 Executor 格式交 Reviewer，停在 G1。

**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
最小改动、Windows 本机、原版 Compose、仅 localhost、不得动其他项目、不凭空宣称部署、不得向 GitHub/聊天输出 Secret、只在新项目目录使用新 Secret、不注册/导入真实数据、不自动修改系统资源。

## CURRENT_ROLLBACK_STATUS
G0 无主机变更；G1 有明确仅项目内容器停止/保留命名卷的回退方式，尚未实测，标为 `PLAN_ONLY`；数据/Secret 离机恢复未验证，真实使用前需要补齐。

## UNRESOLVED
G1 新鲜内存与 Docker Engine 后端磁盘可用量、目标目录 ACL/空状态、拉 GHCR 权限、三服务实际启动资源变化、浏览器登录页均待 Executor 验证。

## NEXT_STEP
Owner 将 G1 relay 指令转交实体 Windows 本机 Codex；Executor 只在合格 preflight 下执行一次受控安装，交 Reviewer 审查。

## OWNER_ACTION_REQUIRED
Owner 通过转交指令明确授权仅限本机 `KarakeepLocal` 初次安装生成所需新 Secret；无须提供任何 Secret 原文。

## EVIDENCE_POINTERS
G0：`karakeep-local/EXECUTION_EVIDENCE.md` commit `ec4f95d`；后续 G1 Evidence 追加至同一路径。
