# Karakeep Local · Reviewer Handoff

> LAST_REVIEW=2026-10-16
> PROJECT_STATUS=`CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`（原安装 PASS/Close 保持有效）
> LAST_GATE_ID=`KARAKEEP-WIN-G3A-LOCAL-ASSET-INVENTORY-READONLY-20261016`
> LAST_GATE_STATUS=`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EXECUTOR_EVIDENCE_MISSING`
> PRIOR_G2B_STATUS=`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`
> CURRENT_GATE_ID=`KARAKEEP-WIN-G3B-SASS-WORKTREE-READONLY-20261016`
> CURRENT_GATE_STATUS=`READY_FOR_OWNER_RELAY_NOT_EXECUTED`
> CURRENT_GATE_FILE=`G3B_SASS_WORKTREE_READONLY_GATE.md`
> OWNER_AUTHORIZED_SCOPE=`PHASE_A_READ_ONLY_ONLY; G3B_NEEDS_OWNER_DISPATCH`
> LOCAL_ARCHIVE_PLAN=`LOCAL_ASSET_ARCHIVE_PLAN.md` / PHASE_A=`PARTIAL_G3A_STOP; G3B_PENDING`
> CANONICAL_GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7 / blob `3917c88a7f36df7a53758b3879a92703d659ef9d`
> DOCUMENT_HOME=`https://github.com/entropy-student/project/tree/main/karakeep-local`
> `README.md` 为索引，**本 Handoff 为唯一当前状态权威**；`DECISION_LOG.md` 为决策及本轮 Reviewer 对中止报告的整理；`EXECUTION_EVIDENCE.md` 仍只包含历次 Executor 已成功提交的执行证据。

## PROJECT_GOAL
在 Owner 实体 Windows 11 本机运行官方 Karakeep，用于本人收藏网页，登录界面可用且仅 `127.0.0.1:3000` 暴露。**安装实施已于 2026-10-16 正式 CLOSE，运行资源和账户保留**。之后 Owner 限定一次 G2B R2：只读核对 Docker 实际存储、测试最多一条可丢弃公开网页收藏、清理能证明无引用的本项目临时文件；**不备份、不恢复、不迁移、不重启、不监控**。本轮被浏览器目标识别阻碍中止。**Owner 已批准按 `LOCAL_ASSET_ARCHIVE_PLAN.md` 开始阶段 A 的本机文件只读盘点**。已制定独立 `G3A_LOCAL_ASSET_READONLY_GATE.md`，**仅本地只读检查 + GitHub 脱敏结果文档写入**；不是重试 G2B，也未授权本机归档、移动、删除。G3A 本机已尝试但因 Computer Use 浏览器目标无法确认而停止，且未提交 Executor Evidence。现只剩精确路径 `SaSS` 的元数据/Git/引用检查，准备由新 G3B 承接；不再重复 Docker 已报告的读回。

## PROJECT_STAGE
- **G0–G1I 历史**：Windows/Docker Desktop、受保护本机 Compose/.env、三份官方镜像最终就绪。此前 Meili 下载异常已经克服；G1I 裸 `Host:chrome` 500 是 Chromium Host 安全限制、与真正 Worker CDP 连接不能简单等同，经过独立研究后不再作为失败依据。G1I 的 project-only `down`（无 `-v`）曾停止目标容器并保留两卷，**不是用户数据灾备证明**。
- **G1J 技术安装 `PASS`（Reviewer 已正式接受）**：Web 登录页 HTTP 200、Meilisearch health 200、Web 容器到 Chrome DevTools 的只读 CDP 握手成功、Worker 浏览器地址解析日志无失败/重试/断连，只有 Web `127.0.0.1:3000` 暴露。三容器健康/无 OOM/重启，G1J 后保留运行。Worker 没有独立 success log，Web OCI revision 缺失，证据边界已接受，**不用再重跑 G1J**。
- **G2A `PASS_SCOPED`（OWNER_REPORTED）**：Owner 登录后的 Karakeep 网页截图表明能进入账户界面；Owner 找到 `Interface Language` 设置，是否实际切换简体中文并刷新持久仍 `UNVERIFIED`，非当前阻碍。
- **原安装实施 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`**：正式记录在 `CLOSEOUT_REPORT.md`，从未授予删除、退役或迁移权限。
- **G3A = RETURN（本机已尝试）**：Owner 转交的 Executor 报告表示配置/ACL、三容器与两个卷的只读检查完成；`SaSS` 与其它候选目录的盘点 **NOT_RUN**。Computer Use 无法确定 Windows 浏览器 URL 并要求停下，Executor 遵循停止，无新增书签或删除。浏览器快捷键是否生效 `UNVERIFIED`；未产生 `LOCAL_ASSET_INVENTORY.md` 或 G3A Executor Evidence/main commit。信息来源仅 `OWNER_REPORTED`，不能标 PASS。
- **G3B READY（尚未执行）**：疑似旧工作区的目标路径现已明确为 `%USERPROFILE%\Documents\ChatGPT\SaSS`；只读核实此文件夹的 Git/内容类型元数据及 Karakeep 直接引用，不再启动 Computer Use/浏览器。完整 Gate `G3B_SASS_WORKTREE_READONLY_GATE.md`。
- **G2B 版本史**：最早含备份的 G2B 草案 `SUPERSEDED_UNEXECUTED`；R1 取消备份 `SUPERSEDED_UNEXECUTED`；Owner **实际下发**的是 G2B `R2_STORAGE_LAYOUT_NO_MIGRATION`，这是**唯一已经实际尝试的 G2B 版本**。后续 Reviewer 不得继续使用含备份的旧提示词。
- **2026-10-16 G2B R2 中止**：Owner 转交本机 Executor 报告（`OWNER_REPORTED`，**不是 Reviewer 亲自读取的本机 Docker 控制面**）。Executor 表示已完成最小只读 Docker/ACL/目录核对；没有发现可删临时文件，实际删除 0；在 Computer Use 无法**充分确定 Windows 浏览器当前 URL**时遵从工具停止条件，**未添加任何 Canary 收藏、未执行抓取/搜索/预览，也未做新的 HTTP 请求**。未提交 G2B Evidence、无 G2B Commit SHA。Reviewer 判 `RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`，保留已有历史 PASS，等待新的 Owner 指令。

## SYSTEM_MAP
- **Target & channel**：Owner 实体 Windows 11 / 本机原生 PowerShell Codex。上次 G1J 的 Windows PowerShell 7.6.5、Docker Desktop 4.95.0 Personal / Linux Engine 29.7.2、Compose 5.4.0，context `desktop-linux`。云端 Reviewer 无法实时读回 Owner 本机，G2B R2 新资料皆来自 Owner 转交 Executor 报告。
- **应用**：Compose project `karakeep-local`，service `web`、`chrome`、`meilisearch`。仅 Web 发布到 `127.0.0.1:3000:3000`；Chrome 9222 与 Meili 7700 无主机端口。网页入口 `http://localhost:3000`，**G2B R2 期间没有新 HTTP 请求，所以当轮实时网页登录 `NOT_RECHECKED`**。
- **本机保护性配置**：`%USERPROFILE%\KarakeepLocal` 即 PowerShell `$env:USERPROFILE\KarakeepLocal`；`docker-compose.yml` SHA256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`（G1J accepted baseline，本轮 Executor 报告再次匹配）；同目录 `.env` 四键 `KARAKEEP_VERSION/NEXTAUTH_SECRET/MEILI_MASTER_KEY/NEXTAUTH_URL`，保护性 ACL 本轮报告 PASS。密钥值/哈希/账户密码/Token 不读出、不传 Chat/GitHub、不轮换。Executor 报告**顶层只有这两文件**，因此无已证明可清理的临时文件。
- **用户真实持久数据**：`karakeep-local_data` → Web `/data`，Executor 报告 Docker Linux mountpoint `/var/lib/docker/volumes/karakeep-local_data/_data`；`karakeep-local_meilisearch` → Meili `/meili_data`，Linux mountpoint `/var/lib/docker/volumes/karakeep-local_meilisearch/_data`。G1J 早已有命名卷名/挂载来源证据，本轮增加**更精确的 Linux 内部路径（OWNER_REPORTED）**，不是 Windows 可直接编辑的普通文件夹。Owner 已注册账户，**两卷必须作为不可删除的真实资料**。
- **Windows Docker Desktop 磁盘**：Executor 称现有 UI 使用 **WSL2**，磁盘位置**目录**为 `%LOCALAPPDATA%\Docker\wsl`；未显示 VHDX 文件名和完整文件路径，故 `WINDOWS_VHDX_EXACT_PATH=UNVERIFIED`。不得把常见默认 `docker_data.vhdx` 文件名猜为此机事实。默认继续使用 Docker named volumes，**不转 Windows bind mount、不修改 Disk image location、不打开 VHDX**。
- **三官方镜像冻结**：
  - Web `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`
  - Chrome `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`
  - Meili `getmeili/meilisearch@sha256:860fa4baed04ae1c235de870edab0c8006227546dea1bbb6411fbfc5e27cf1db` v1.41.0
  - 官方原 Compose `karakeep-app/karakeep` main `docker/docker-compose.yml` blob `865bb147cef972926d5dc32e50645876fd110555`，数据挂载 Web `data:/data`、Meili `meilisearch:/meili_data`；本机 Compose 冻结仅 Web 改 loopback 发布方式。
- **其他 Docker/系统**：G2B preflight Executor 报告三目标容器 running、Web healthy、restart 0/OOM false、仅 Web loopback、非目标 Docker **0 running**。没有修改其他 WordPress/MariaDB/Compose 项目、系统代理、Docker Desktop/Daemon、Clash 或 Windows。由于没有正式 G2B Evidence，不声称本轮健康验证达到 Reviewer formal PASS。
- **使用方法**：Docker Desktop Engine 已启动时访问 `http://localhost:3000`。如果未来目标容器停掉，在 Owner PowerShell 手动按需：
  ```powershell
  Set-Location (Join-Path $env:USERPROFILE 'KarakeepLocal')
  docker compose -p karakeep-local up -d --pull never
  if ($LASTEXITCODE -eq 0) { Start-Process 'http://localhost:3000' }
  ```
  该命令不是此轮新执行动作；**不在本轮为验证而重启电脑、Docker Desktop 或容器**。失败时就具体报错另开 Owner 授权。
- **文档唯一集中目录**：`https://github.com/entropy-student/project/tree/main/karakeep-local`，`README.md` 索引、当前 `REVIEWER_HANDOFF.md`、`DECISION_LOG.md`、历史 `CLOSEOUT_REPORT.md`、历史 append-only `EXECUTION_EVIDENCE.md`。所有文档均脱敏，不上传账号、原数据库、密钥、卷内容/备份。
- **备份风险**：Owner 明确 `BACKUP_NOT_REQUESTED / RESTORE_UNVERIFIED`，电脑/磁盘/Docker 虚拟磁盘损坏可造成永久数据丢失；不把用户数据“留本机”当成恢复证据。

## CURRENT_ACCEPTED_STATE
**原安装已 PASS/CLOSE，运行及账户保留；旧 G2B R2 仍 RETURN。** G3A 在本机已尝试但正式 `RETURN_BROWSER_TARGET_UNVERIFIED_AND_EXECUTOR_EVIDENCE_MISSING`，**不是 G3A 未下发**。Owner 转交的 Executor 自述（仅 `OWNER_REPORTED`）支持：`%USERPROFILE%\KarakeepLocal` 顶层仅 `.env` 和 Compose、指纹匹配/ACL 保护通过；三容器运行且 Web healthy/仅 loopback、非目标运行容器 0；Docker volumes `karakeep-local_data`→`/data`、`karakeep-local_meilisearch`→`/meili_data`，内部 Linux mountpoints 分别 `/var/lib/docker/volumes/karakeep-local_data/_data` 和 `/var/lib/docker/volumes/karakeep-local_meilisearch/_data`；Docker Desktop WSL2 目录 `%LOCALAPPDATA%\Docker\wsl`、确切 VHDX 文件路径 `UNVERIFIED`。**未执行 SaSS/Git 调查；未删/移/备份文件，未提交 G3A Executor Evidence，main 历史 Evidence 仍停 G1J**。浏览器快捷键效果 `UNVERIFIED`，不得等同 Karakeep 故障或 Canary 成功。

`SaSS` 精确候选位置现已由 Owner 报告为 `%USERPROFILE%\Documents\ChatGPT\SaSS`；其项目归属、Git 工作区是否未提交/未跟踪/未推送、其它项目引用和归档安全性均 `UNKNOWN`，**严禁按文件夹名判断可删除**。G3B Gate 已由 Reviewer 编写但**尚未执行**，须 Owner 重新转发给本机 Codex。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G3B-SASS-WORKTREE-READONLY-20261016`
**GATE_STATUS**：`READY_FOR_OWNER_RELAY_NOT_EXECUTED`。
**GATE_DOC**：`main:karakeep-local/G3B_SASS_WORKTREE_READONLY_GATE.md`，该文件包含全部治理 Gate 必填字段，是本轮完整执行说明。
**OBJECTIVE**：在原 Windows PowerShell 仅核查**准确路径** `%USERPROFILE%\Documents\ChatGPT\SaSS` 的 1–2 层目录/Git 元数据，确认仓库归属、独有未推送资料、是否为 Karakeep 直接挂载、其它引用未知项。
**MAX_ENDPOINT_THIS_ROUND**：本机无修改、删除、移动、备份、归档；不重新核查已报告的全部 Docker/ACL，不运行 Computer Use、浏览器或 GUI，不启动/重启任何服务；仅向 GitHub connector/API 写脱敏 `LOCAL_ASSET_INVENTORY.md` 与 append-only `EXECUTION_EVIDENCE.md` G3B 记录，提交/readback。若连接渠道无效则准确 RETURN，不许借浏览器强行提交。
**MANDATORY_REVIEW_STOP**：仅完成只读 SaSS 盘点和文档证据，结束后交 Reviewer；本 Gate 不提供任何删除权。
**REVIEWER_TO_EXECUTOR_RELAY**：只使用 `G3B_SASS_WORKTREE_READONLY_GATE.md` 中完整的 `REVIEWER_TO_EXECUTOR_RELAY`，不再下发 G3A/旧 G2B 指令。
**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交（必要时）。

## CRITICAL_CONSTRAINTS
保留已经 Close 的 Karakeep、`%USERPROFILE%\KarakeepLocal` 受保护 Compose/.env、两个 named volumes、三镜像及 Docker Desktop WSL2 共享磁盘。**本 Gate 严禁任何 Windows 本机写入、文件正文/Secret/用户收藏/数据库读取、备份/迁移/删除/重启/监控**。目录限于确切 `SaSS` 工作区，最多两层元数据及只读 Git 状态/必要三容器 mounts；禁止 Computer Use/浏览器/GUI，禁止其它项目遍历。不能因为 Docker 没直接挂载就断言其它进程/项目不引用 SaSS；不确定全部保留。G3A/旧 G2B 绝不能自动复跑。

## DEFAULT_EXECUTION_CHANNEL
本次 G3B 只读任务由 Owner **再次主动转发**给本机原生 Windows PowerShell Codex（GitHub connector/API 仅用于提交文档，不能开网页）；正常使用 `http://localhost:3000` 不需 Codex。当前新 Gate 仅准备好，**没有 G3B 本机执行证据**。

## CURRENT_ROLLBACK_STATUS
G3A 中止报告称本机资料没有发生修改/删除/移动，`ROLLBACK_NOT_REQUIRED_REPORTED`（非 Reviewer 直接验证）；新 G3B 只读，无本地回滚操作。Owner 取消备份，`BACKUP_NOT_REQUESTED / RESTORE_UNVERIFIED` 风险保留。不得借机停止服务或清理 Docker 数据。

## UNRESOLVED
`SaSS` 归属、Git 状态/独有资料、其它项目是否引用尚未知；其它候选目录未盘点；G3A Executor Evidence 未提交，浏览器快捷键实际效果不可证明；旧 G2B 的 Canary 未执行；Windows VHDX 完整路径未知。备份、重启、长期监控已由 Owner 排除，不得自行增加。

## NEXT_STEP
Reviewer 已根据本轮 G3A RETURN 缩小工作范围并建立独立 G3B 只读 Gate。下一步仅 Owner 再次发给本机 Codex 一条 G3B 指令，**直接检查确切 SaSS 路径，不再大范围搜索或开启任何浏览器**。Executor 在 main 保存脱敏 `LOCAL_ASSET_INVENTORY.md` 和 G3B Evidence，读回后停 Reviewer。只有审核后才能提出归档候选；任何本机清理/删除仍需另一个明确授权。

## OWNER_ACTION_REQUIRED
Owner **只需转发新的 G3B 指令**；无须再提交路径或密码。不要执行旧 G3A 或重试 Computer Use，不操作本地文件。若 GitHub 写连接不可用，Codex 停并报告，不能换成浏览器流程。

## EVIDENCE_POINTERS
- G3A 当前中止及 SaSS 精确路径：Owner 本轮转交 Codex 报告，仅 `OWNER_REPORTED`，在 `DECISION_LOG.md` 的 `D-20261016-G3A-RETURN-BROWSER`；原 G3A Gate blob `1aa0034641c94525a0ccb3d6acea166ab98ec78c`，原 Handoff blob `ce42389127dfebd7be8b8c25809903e5d1e31794`，**无 Executor G3A Evidence / SHA**。
- 新 G3B Gate：`G3B_SASS_WORKTREE_READONLY_GATE.md`，准备好但未执行。
- **现行新 Gate（已授权但未执行）**：`G3A_LOCAL_ASSET_READONLY_GATE.md` / `KARAKEEP-WIN-G3A-LOCAL-ASSET-INVENTORY-READONLY-20261016`；允许新建的脱敏结果文件 `LOCAL_ASSET_INVENTORY.md` **当前尚不存在**。
- **Owner 授权**：2026-10-16 回复“我没问题，开始吧”，对应上一轮 `LOCAL_ASSET_ARCHIVE_PLAN.md` 阶段 A **只读盘点**；不批准删除、移动、备份或迁移。
- **新增无执行权限的资产归档计划**：`LOCAL_ASSET_ARCHIVE_PLAN.md`；Owner 2026-10-16 本轮提出本机文件归档、防误删问题，Reviewer 仅产出 GitHub 文档。决策见 `DECISION_LOG.md` 的 `D-20261016-LOCAL-ARCHIVE-PLAN`。
- **本次 G2B 中止的事实源**：2026-10-16 本轮 Owner 转交 Executor 未完成报告，具体摘要记录 `DECISION_LOG.md#d-20261016-g2b-r2-stop--浏览器目标无法确认未完成并停在-reviewer`（`OWNER_REPORTED`）；**未提交 Executor G2B Evidence / Commit SHA**。
- **历史最后 G1J Executor Evidence**：`main:karakeep-local/EXECUTION_EVIDENCE.md` blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4`，commit `b801c2b629b303f730d05329c958cffca61686b3`。后续若此 blob 变化需核对是否有人重新 append，不能擅自推测本轮已补全。
- **正式 Closeout**：`CLOSEOUT_REPORT.md`；**Storage/no migration**：`README.md` 和 `DECISION_LOG.md` 中 `D-20261016-G2B-R2`；Governance `entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7。
