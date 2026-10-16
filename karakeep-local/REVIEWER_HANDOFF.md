# Karakeep Local · 唯一 Reviewer Handoff（项目正式 CLOSE）

> LAST_REVIEW=2026-10-16
> PROJECT_STATUS=`CLOSED_PROJECT_RUNTIME_RETAINED`
> CLOSE_SCOPE=`INSTALLATION_ACCEPTED; DOCUMENTATION_ARCHIVED; KNOWN_ASSET_MAP_RECORDED`
> LAST_GATE_ID=`KARAKEEP-WIN-G3B-SASS-WORKTREE-READONLY-20261016`
> LAST_GATE_STATUS=`PASS_SCOPED_READONLY_INVENTORY`（Reviewer 已接受限定范围 G3B 的只读盘点）
> HISTORICAL_G2B_STATUS=`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`
> HISTORICAL_G3A_STATUS=`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EXECUTOR_EVIDENCE_MISSING`
> CURRENT_GATE_ID=`NONE`
> ACTIVE_EXECUTOR_TASK=`NONE` / AUTO_FOLLOWUP=`NONE`
> DELETE_ALLOWLIST=`EMPTY` / LOCAL_DECOMMISSION=`NOT_AUTHORIZED`
> OWNER_ACTION_REQUIRED=`NONE`
> GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7（已确认的 Governance blob `3917c88a7f36df7a53758b3879a92703d659ef9d`）
> DOCUMENT_HOME=https://github.com/entropy-student/project/tree/main/karakeep-local
> DAILY_ENTRY=`README.md`
> 决策史在 `DECISION_LOG.md`；已完成的实际本机执行证据在 append-only `EXECUTION_EVIDENCE.md`。本 Handoff 只表述当前结项事实和需要长期保留的边界；不重写历史 Gate。

## PROJECT_GOAL
Owner 已决定**整体关闭 Karakeep Local 的安装、已知资产位置整理和文档归档的项目管理任务**。保持 Owner Windows 11 本机 Karakeep 配置、服务、账号、收藏和两份 Docker named volumes **原位可继续按需使用**。该 CLOSE **不是应用退役、停止、卸载或真实数据删除**；也不代表未执行的收藏业务 Canary、备份恢复、重启持久性等验收自动 PASS。

## PROJECT_STAGE
- `G0–G1I`：历史安装准备已收口，原配置、密钥、镜像和 named volumes 已建立。
- `G1J=PASS`：Reviewer 接受的 Karakeep 技术安装检查；当轮 Web sign-in HTTP 200、Meili health 200、Web→Chrome CDP 只读握手成功，仅 loopback 3000 主机发布，三容器无重启/OOM。原安装项目 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED` 已正式完成并保留。
- `G2A=PASS_SCOPED(OWNER_REPORTED)`：Owner 成功登录且找到 `Interface Language` 设置入口；最终保存简体中文 `UNVERIFIED`。
- `G2B R2=RETURN`：浏览器 Computer Use URL 身份不明触发安全中止；一条公开测试收藏/抓取/搜索/预览 Canary `NOT_RUN`，未提交对应 Executor Evidence。
- `G3A=RETURN`：配置、卷和 Docker Desktop 只读结果来自 Owner 转交 Executor 报告（非该轮正式 G3A Evidence），未完成候选工作区盘点；工具安全停止，无 G3A Evidence。
- `G3B=PASS`（仅本机 SaSS 只读盘点）：`LOCAL_ASSET_INVENTORY.md` 与 G3B `EXECUTION_EVIDENCE.md` 完整提交，历史 Evidence 前缀保持不变；Reviewer 核实后接受范围内元数据结果。仓库其他引用和唯一 Git history `UNKNOWN`，`SaSS` 保留。一次多查 `.git` 直接子项**数量**的只读范围偏差已在 `DECISION_LOG.md` 披露和接受；不构成未来下探或删除授权。
- `2026-10-16 OWNER FINAL CLOSE`：Owner 再次明确要求**确定信息整理到 GitHub `main` 并项目整体 Close**。日常 README 已整合，历史技术档案原目录留存，`ACTIVE_GATE=NONE`；正式记录见 `CLOSEOUT_REPORT.md` 第 10 节和 `DECISION_LOG.md` 的 `D-20261016-FINAL-PROJECT-CLOSE`。

## SYSTEM_MAP
- **Owner 真机/执行边界**：实体 Windows 11 / 原生 Windows PowerShell 7.6.5（历史 G3B 读回），Docker Desktop Linux/WSL2。历史 G1J Docker Desktop 4.95.0 Personal、Engine 29.7.2、Compose 5.4.0、context `desktop-linux`；**不声称这些版本或运行时刻被本轮重新验证**。本云端 Reviewer 无 Owner Windows 实时文件/容器访问。
- **Web 使用入口**：同一台电脑 `http://localhost:3000`；Compose project `karakeep-local`，服务 `web`、`chrome`、`meilisearch`。G1J 验收仅 Web 主机发布 `127.0.0.1:3000:3000`，Chrome CDP 9222 和 Meili 7700 无主机公开发布。最近 G3A/G3B 的容器状态/挂载读回以实际 Evidence/Owner 转交报告为准，**本次文档 Close 没有新的 HTTP 探针**。
- **本机配置（必须保留）**：`%USERPROFILE%\KarakeepLocal`，顶层已报告仅 `docker-compose.yml`、受保护 `.env`。Compose G1J accepted SHA256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`；原 .env 四键 `KARAKEEP_VERSION`、`NEXTAUTH_SECRET`、`MEILI_MASTER_KEY`、`NEXTAUTH_URL`，**绝不读取、输出、提交、哈希或移动 Secret**。此文件夹**不是 Markdown 文档归档目录**。
- **真实持久数据（必须保留）**：Web 挂载 Docker named volume `karakeep-local_data` 到容器 `/data`（账号/收藏/抓取资产）；Meili 挂载 `karakeep-local_meilisearch` 到 `/meili_data`（搜索相关数据）。历史 G3A Executor 报告其 Docker Linux mountpoints 为 `/var/lib/docker/volumes/karakeep-local_data/_data`、`/var/lib/docker/volumes/karakeep-local_meilisearch/_data`，**不是可在 Windows 资源管理器中直接清理的目录**。
- **Docker Desktop 后端（共享、必须保留）**：Owner 转交 Executor 报告 Windows WSL2 数据磁盘目录为 `%LOCALAPPDATA%\Docker\wsl`；确切 `.vhdx` 文件名与绝对路径 `UNVERIFIED`；可能与其它项目共享。禁止手动编辑/删除/迁移虚拟磁盘。
- **冻结的三官方镜像（历史 G1J accepted）**：Web `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`；Chrome `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`；Meili `getmeili/meilisearch@sha256:860fa4baed04ae1c235de870edab0c8006227546dea1bbb6411fbfc5e27cf1db`。不自动 pull/升级。
- **GitHub 项目 Markdown 文档（唯一确认的集中归档）**：`entropy-student/project` `main/karakeep-local/`；普通用户只看 `README.md`，技术详细/历史看 `REVIEWER_HANDOFF.md`、`LOCAL_ASSET_INVENTORY.md`、`DECISION_LOG.md`、`CLOSEOUT_REPORT.md`、`EXECUTION_EVIDENCE.md`、原 `LOCAL_ASSET_ARCHIVE_PLAN.md` 和历史 Gate。**没有证据证明另有本机统一 Markdown 文档归档目录；GitHub 不包含真实账户/Secret/数据库或备份**。
- **非本项目的目录**：历史 `SaSS` 有界盘点报告结果保留在 `LOCAL_ASSET_INVENTORY.md`；Owner 最近明确要求不再触碰该根目录。**不查、不动、不删**，不能依据普通工作树为空而宣布其安全删除。

## CURRENT_ACCEPTED_STATE
- **整体项目管理正式 `CLOSED_PROJECT_RUNTIME_RETAINED`**；文档已集中 GitHub main，日常使用入口在 README，现有 Windows/Docker 运行数据原位保留。
- `LOCAL_ASSET_INVENTORY.md` 为**已知范围**资产地图，`PROTECTED_ACTIVE` 是配置和两 named volumes，Docker WSL2 属共享/未知，历史 SaSS 属 `UNKNOWN_OR_SHARED`。它**不是**整台电脑文件全盘地图。
- 当前已证可以安全删除的项目资产为 **0**，`DELETE_ALLOWLIST=EMPTY`；本轮 Reviewer 仅 GitHub 文档更新，Windows/Docker 写入、删除、移动、迁移、备份/恢复、服务重启**均没有执行**。
- 旧 G2B/G3A 的 `RETURN`、原 G1J/G3B 限定范围 `PASS` 各自保持；未测试过的功能不冒充已经通过。
- `BACKUP_NOT_REQUESTED / RESTORE_UNVERIFIED`；用户明确不安排独立备份、恢复演练、数据迁移、Windows/Docker 重启测试和长期监控，存在磁盘损坏导致独有资料永久丢失的风险，不改变 Owner 的本轮项目管理关闭决定。

## CURRENT_GATE
`GATE_ID=NONE` / `STATUS=CLOSED_PROJECT_RUNTIME_RETAINED`。没有正在授权的 Executor 任务，无自动重试、无人值守巡检、后续清理 Gate；历史 Gate 只是档案。将来出现**新的明确 Owner 需求**，由新的 Reviewer 判断是否需要有界新 Gate，不能把 Close 当作下一轮写入、删除或继续 Computer Use 的授权。

## CRITICAL_CONSTRAINTS
不操作任何其他工作区/根目录，不允许任何项目相关数据删除、迁移、备份、恢复、容器重新部署/系统配置变更；不执行 `docker compose down -v`、`docker system prune`、Docker Desktop Reset 或 VHDX 文件清理。保留原 `KarakeepLocal` 的 Compose/.env 和两个 named volumes；不得将其强行搬到一个新 Windows 文件夹，不上传秘密、数据库或真实收藏到 GitHub。真实的删除/卸载/退役需以后 Owner **独立明确授权**和事前数据/引用/恢复评估。不能续跑 G2B/G3A 的浏览器安全停止任务。

## DEFAULT_EXECUTION_CHANNEL
- **日常访问**：Owner 本机浏览器打开 `http://localhost:3000`。
- **服务若未运行，按需手动启动**（Owner 自主决定；不在本轮实际执行）：
  ```powershell
  Set-Location (Join-Path $env:USERPROFILE 'KarakeepLocal')
  docker compose -p karakeep-local up -d --pull never
  if ($LASTEXITCODE -eq 0) { Start-Process 'http://localhost:3000' }
  ```
  先启动 Docker Desktop 并等待 Engine 就绪，若有异常则另开具体故障排查请求。
- **以后交给本机 Codex**：提供 GitHub 最新 `main/karakeep-local/README.md`，如需技术状态再读本 `REVIEWER_HANDOFF.md`，明确具体问题；默认最小只读，不执行历史 Gate 或无关项目操作。完整用户话术已整合到 README。

## CURRENT_ROLLBACK_STATUS
结项文档操作只发生在 GitHub main，没有对本机运行态修改，无本机回滚需要；未建立可验证的异机备份或数据恢复路径（`BACKUP_NOT_REQUESTED / RESTORE_UNVERIFIED`）。**Docker 卷原位存在不等于灾难恢复备份**。未来若出现真实运行或数据异常，要首先保护剩余数据，另行授权处理。

## UNRESOLVED
真实收藏 E2E Canary `NOT_RUN`；最终界面语言保存情况 `UNVERIFIED`；Windows Docker VHDX 文件完整路径 `UNVERIFIED`；长期重启稳定性与真实数据异机恢复 `NOT_TESTED/NOT_REQUESTED`；历史 SaSS 独有 Git history 及其他项目引用 `UNKNOWN`。**这些是项目正式 CLOSE 时明确列出的排除项**，不要求在本次重新验收或自动开 Gate。

## NEXT_STEP
`NONE`。项目整体已经正式关闭，正常继续使用软件。只有 Owner 将来主动提出新功能、故障修复、备份恢复或真正卸载/清理需求时，才考虑重新开启具体范围的工作。

## OWNER_ACTION_REQUIRED
`NONE`。不需要再运行 Codex、提供密码或清理电脑文件。日常操作见 `README.md`。

## EVIDENCE_POINTERS
- **最新整体关闭的明确 Owner 决定**：2026-10-16 Owner 提出“将确定的信息整理到项目文档当中，GitHub 仓库的 main 当中，本项目正式 close”；记录在 `DECISION_LOG.md#D-20261016-FINAL-PROJECT-CLOSE` 与 `CLOSEOUT_REPORT.md` 第 10 节。
- **主文档归档**：`README.md`（唯一日常入口）、`LOCAL_ASSET_INVENTORY.md`（资产地图）、本 Handoff（项目当前技术状态），都在 GitHub main `karakeep-local/`。
- **G3B 只读 PASS 已被 Reviewer 独立核对**：`LOCAL_ASSET_INVENTORY.md` blob `5189a45a15b527b5183243c95e82ce3515bbbb10`（commit `720813d9c073ceeb3673c367be0dc9838518efe4`）；`EXECUTION_EVIDENCE.md` blob `4712a9d09ce94ed612cc6e83e512934064874efa`（commit `0f041fbe9c7321a53e1cb32ad1afdd89e24be226`）；旧原始证据前缀 G1J blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4` 保留，G3B 的轻微只读范围异常在 `DECISION_LOG.md`。
- **安装历史 CLOSE**：`CLOSEOUT_REPORT.md` 原章节 1–9、`EXECUTION_EVIDENCE.md` 历史 G1J；G2B/G3A 的中止及缺失 Evidence 在 `DECISION_LOG.md`，没有伪造。
