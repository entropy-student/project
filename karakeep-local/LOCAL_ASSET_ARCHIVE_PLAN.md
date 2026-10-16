# Karakeep Local · Windows 本机资产地图与整理计划

> 计划日期：2026-10-16
> STATUS=`PLAN_ONLY_NOT_EXECUTED`
> 适用范围：仅 Owner 电脑上 `karakeep-local` 的配置、Docker 存储和可能遗留的项目工作区；不涉及其它产品。
> **本文件是待执行前审阅的方案，不代表已经完成本机目录盘点，也不授权任何移动、删除、停机、备份或恢复。**
> 权威项目状态：`REVIEWER_HANDOFF.md`；所有项目管理文档统一 `https://github.com/entropy-student/project/tree/main/karakeep-local`。

## 1. 为什么不能直接删一个“项目根目录”

Karakeep 不是把全部文件都放在同一个 Windows 文件夹的普通本地软件。当前已知资产分为：

| 资产类别 | 已知位置/标识 | 当前证据与建议 |
|---|---|---|
| 管理文档 | GitHub `project/karakeep-local/` | main 已有 README、Handoff、Decision、Closeout、Evidence，归档入口，无真实用户数据库 |
| Windows 运行配置 | `%USERPROFILE%\KarakeepLocal\docker-compose.yml`、同目录 `.env` | 历史 G1J PASS；G2B Executor 报告再次核实目录/ACL。**运行中，禁止移动、删除、同步或公开** |
| 用户账户/网页收藏 | Docker named volume `karakeep-local_data` → Web 内 `/data` | **真实资料，禁止删除**；G2B 报告 Linux mountpoint `/var/lib/docker/volumes/karakeep-local_data/_data` |
| 搜索索引 | Docker named volume `karakeep-local_meilisearch` → Meili 内 `/meili_data` | **保留**；G2B 报告 Linux mountpoint `/var/lib/docker/volumes/karakeep-local_meilisearch/_data` |
| Docker 的底层磁盘/镜像/容器 | Docker Desktop WSL2，UI 报告目录 `%LOCALAPPDATA%\Docker\wsl` | **属于共享 Docker 运行时**，绝不能在资源管理器中清理，VHDX 文件全路径仍 `UNVERIFIED` |
| 疑似旧工作区 | Owner 提到的 `sass`（亦可能写成 `saas`）及其它旧项目目录 | **路径、内容、Git 未推送记录、是否被容器引用皆 `UNKNOWN`，不得以名称推断可删** |

上述 G2B 新细节来源于 Owner 转交 Executor 报告，**没有 G2B main Executor Evidence**，此计划不冒称 Reviewer 直接读取当前本机。旧安装 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`，上一 G2B R2 因 Computer Use 无法确认浏览器 URL 中止；**本整理计划不涉及浏览器 Canary**。

## 2. 推荐的三步实施路径

**阶段 A — 一次只读发现，先得到完整“在哪里”清单**（只有 Owner 将来明确授权执行时才开始）：

1. 在**真实 Windows PowerShell** 中只读确认 `$env:USERPROFILE\KarakeepLocal` 及其文件名/类型、`docker compose config --services` 是否会暴露 Secret（如有风险则跳过此命令）、`docker inspect` 目标容器 Mounts/Compose labels、`docker volume inspect` 两项目卷、Docker Desktop UI 中数据盘目录。仅输出非敏感元数据；不读取、打印、hash、复制 `.env`，不扫描数据库内容或 VHDX。
2. 在用户已知的普通文件位置（Desktop、Documents、Downloads、已知开发根路径）**有界发现疑似 `sass`/`saas` 工作区**。记录完整路径（若其中包含私密用户标识则用环境变量表达）、目录层级、受控空间与尺寸、最近改动时间、git root/remote、`git status` 的非敏感分类及未推送/未跟踪文件是否存在。**不要递归遍历整个 C 盘、不要打开文件正文、不要读取隐藏密钥/数据库**。
3. 读清楚当前 Karakeep Compose 所引用的**真实本机路径**及 Docker 挂载来源；判断疑似旧目录是否在本机运行配置目录、Git 工作区、Docker Desktop 数据、其它项目共享区之内。若没有足够证据说明 `sass` 的确切归属，标 `UNKNOWN` 并请 Owner 指出**仅一个完整路径**。
4. 输出一份精简、**不含账号/Secret/文件正文**的 `LOCAL_ASSET_INVENTORY.md` 草案（或表格）供 Reviewer 核对：`路径(脱敏)｜类型｜归属｜是否运行引用｜是否唯一资料/未提交｜保留/可归档/可删/UNKNOWN｜依据`。**发现阶段不删除、不移动、不压缩、不备份、不安装工具**，完成后先停 Reviewer。

**阶段 B — 归档建议（分类后，独立授权才可写入）**：

- `PROTECTED_ACTIVE`：`KarakeepLocal`、`.env`、Compose、两个 named volumes、3 容器/官方镜像、Docker Desktop VHDX 和共享资源。**保持原位**，在 GitHub 项目索引写位置与不可删除的原因，**不需要也不应移动到“统一文件夹”**。
- `DOCUMENTED_REMOTE`：main 中项目管理文档。保持 GitHub 单点来源；不为“归档”另建重复本机文档包。
- `UNIQUE_UNPUSHED`：未推送/未跟踪的独有开发源码、私人用户数据、需要保留的本机工作记录。**不能删除**；有无可安全归档的非敏感部分，先另由 Reviewer 规划，严禁把 Secret 和数据库上传 GitHub。
- `DISPOSABLE_VERIFIED`：**仅**无任何运行引用、已证据化可再生、确属 Karakeep 的项目独有缓存/临时下载/诊断文件，可进入未来精确删除候选，不自动清理。
- `UNKNOWN/SHARED`：`sass` 等身份不明确、Docker 共享层/其它项目文件，一律不移动、不删除。
- **整理成果**：形成一张“项目文件在哪里/谁负责/误删影响”的永久地图；用户后续只需打开 GitHub `README.md` 即可定位原 Windows 配置和两个 Docker 卷。可以归档的旧工作区也只有得到其完整路径、证明当前不被引用、确认没有独有资产，并由 Owner 单独批准后才能移动或删除。

**阶段 C — 可选的真正整理与精确删除**（另一个有删除权限的 Gate）：

- 先确认已收到阶段 A 的证据、阶段 B 的逐路径 allowlist 及 Owner 对**确切路径/后果**的授权。
- 没有可验证的重建条件或任何 `UNKNOWN` 时跳过；尤其当前 Owner **不做备份**，更不能对资料来源唯一的目录做“先删了再说”的操作。
- 只针对获批的少量 disposable 文件（而非整块 Docker 卷、整棵疑似项目根目录、共享资源）做最小变更，前后读回、回归应用及非目标状态，保留确切计数。此阶段**尚未获得授权，也不是现在的计划执行内容**。

## 3. 本次明确不做

- 不删除或迁移 `sass/saas`、`KarakeepLocal`、`.env`、两个 named volumes 或 Docker Desktop WSL2/VHDX；
- 不执行 `docker system prune` / `docker compose down -v` / 重置 Docker / 改 Compose 挂载；不清理其它项目；
- 不执行备份、恢复、迁移、镜像升级、设备重启、长时监控；保持 Owner 以前的决定；
- 不尝试 Windows 浏览器控制、登录、网页收藏 Canary（旧 G2B 已在工具安全停止条件下 RETURN）。

## 4. 执行与验收边界

当前状态仅 `PLAN_ONLY_NOT_EXECUTED`，没有本机新增 Evidence。若 Owner 批准阶段 A，Reviewer 另行建立**只读发现 Gate**并下发本机 PowerShell Codex；需要的结果只有：可审核的非秘密文件路径/目录归属、当前运行引用、候选目录的安全分类和明示不确定项、无副作用证明、GitHub 项目内脱敏证据。完成后停 Reviewer；**没有自动“顺便删除”权限**。

使用入口（Docker Desktop Engine 就绪时）：`http://localhost:3000`。当前机器未有经验证的离机恢复方案：`BACKUP_NOT_REQUESTED / RESTORE_UNVERIFIED`。如果用户只想节省空间，应先估算可弃候选体积，而不是清理被共享的 Docker 磁盘。
