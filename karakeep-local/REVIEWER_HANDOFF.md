# Karakeep Local · Reviewer Handoff

> LAST_REVIEW=2026-10-16
> PROJECT_STATUS=`CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`（原安装 PASS/Close 保持有效）
> LAST_GATE_ID=`KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016`
> LAST_GATE_REVISION=`R2_STORAGE_LAYOUT_NO_MIGRATION`
> LAST_GATE_STATUS=`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`
> CURRENT_GATE_ID=`KARAKEEP-WIN-G3A-LOCAL-ASSET-INVENTORY-READONLY-20261016`
> CURRENT_GATE_STATUS=`AUTHORIZED_READY_FOR_OWNER_LOCAL_EXECUTOR`
> CURRENT_GATE_FILE=`G3A_LOCAL_ASSET_READONLY_GATE.md`
> OWNER_AUTHORIZED_SCOPE=`READ_ONLY_LOCAL_ASSET_INVENTORY`
> LOCAL_ARCHIVE_PLAN=`LOCAL_ASSET_ARCHIVE_PLAN.md` / PHASE_A=`OWNER_APPROVED_NOT_EXECUTED`
> CANONICAL_GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7 / blob `3917c88a7f36df7a53758b3879a92703d659ef9d`
> DOCUMENT_HOME=`https://github.com/entropy-student/project/tree/main/karakeep-local`
> `README.md` 为索引，**本 Handoff 为唯一当前状态权威**；`DECISION_LOG.md` 为决策及本轮 Reviewer 对中止报告的整理；`EXECUTION_EVIDENCE.md` 仍只包含历次 Executor 已成功提交的执行证据。

## PROJECT_GOAL
在 Owner 实体 Windows 11 本机运行官方 Karakeep，用于本人收藏网页，登录界面可用且仅 `127.0.0.1:3000` 暴露。**安装实施已于 2026-10-16 正式 CLOSE，运行资源和账户保留**。之后 Owner 限定一次 G2B R2：只读核对 Docker 实际存储、测试最多一条可丢弃公开网页收藏、清理能证明无引用的本项目临时文件；**不备份、不恢复、不迁移、不重启、不监控**。本轮被浏览器目标识别阻碍中止。**Owner 已批准按 `LOCAL_ASSET_ARCHIVE_PLAN.md` 开始阶段 A 的本机文件只读盘点**。已制定独立 `G3A_LOCAL_ASSET_READONLY_GATE.md`，**仅本地只读检查 + GitHub 脱敏结果文档写入**；不是重试 G2B，也未授权本机归档、移动、删除。实际 Windows G3A 尚未执行。

## PROJECT_STAGE
- **G0–G1I 历史**：Windows/Docker Desktop、受保护本机 Compose/.env、三份官方镜像最终就绪。此前 Meili 下载异常已经克服；G1I 裸 `Host:chrome` 500 是 Chromium Host 安全限制、与真正 Worker CDP 连接不能简单等同，经过独立研究后不再作为失败依据。G1I 的 project-only `down`（无 `-v`）曾停止目标容器并保留两卷，**不是用户数据灾备证明**。
- **G1J 技术安装 `PASS`（Reviewer 已正式接受）**：Web 登录页 HTTP 200、Meilisearch health 200、Web 容器到 Chrome DevTools 的只读 CDP 握手成功、Worker 浏览器地址解析日志无失败/重试/断连，只有 Web `127.0.0.1:3000` 暴露。三容器健康/无 OOM/重启，G1J 后保留运行。Worker 没有独立 success log，Web OCI revision 缺失，证据边界已接受，**不用再重跑 G1J**。
- **G2A `PASS_SCOPED`（OWNER_REPORTED）**：Owner 登录后的 Karakeep 网页截图表明能进入账户界面；Owner 找到 `Interface Language` 设置，是否实际切换简体中文并刷新持久仍 `UNVERIFIED`，非当前阻碍。
- **原安装实施 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`**：正式记录在 `CLOSEOUT_REPORT.md`，从未授予删除、退役或迁移权限。
- **G3A 只读资产盘点 `READY`（未执行）**：Owner 已确认“没问题，开始吧”，授权前一轮计划中的阶段 A。Reviewer 建立独立 `G3A_LOCAL_ASSET_READONLY_GATE.md`；Executor 只读定位本机运行资产、疑似 `sass/saas` 工作区、Git 独有未提交文件与引用边界，完成后只写脱敏 GitHub inventory/Evidence，停 Reviewer。没有运行态或本机资料改动权限。
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
**安装实施 G1J PASS / `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`**，运行服务与账户保留；G2B R2 `RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`，Computer Use 无法确认浏览器 URL 时已安全停止，Canary `NOT_RUN`、删除 `0`、G2B Evidence 未提交。不要重启 G2B 或重新验证已接受的安装链路。

**本轮 Owner 明确授权新的 G3A 只读本机文件清单 Gate**，但当前只有 Reviewer 已提交的 Gate，**尚无本机 G3A 执行事实**。`sass/saas` 工作区的绝对路径、实际归属、是否有未推送/未跟踪文件、是否被 Karakeep 或其它项目引用仍为 `UNKNOWN`。目标是用有界读操作找出这些事实，确保用户以后整理文件时不误删。

**历史被转交的 G2B 位置报告（`OWNER_REPORTED`，非新的 G3A 证据）**：`%USERPROFILE%\KarakeepLocal` 存 `docker-compose.yml` 和保密的 `.env`；`karakeep-local_data`→Web `/data`→Linux `/var/lib/docker/volumes/karakeep-local_data/_data`；`karakeep-local_meilisearch`→Meili `/meili_data`→Linux `/var/lib/docker/volumes/karakeep-local_meilisearch/_data`；Docker Desktop WSL2 disk location 目录 `%LOCALAPPDATA%\Docker\wsl`，VHDX 文件绝对路径 `UNVERIFIED`。只需必要元数据核对，不能因目录不在一起就迁移/复制数据。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G3A-LOCAL-ASSET-INVENTORY-READONLY-20261016`
**GATE_STATUS**：`AUTHORIZED_READY_FOR_OWNER_LOCAL_EXECUTOR`，**尚未实际执行**。
**GATE_DOC**：`main:karakeep-local/G3A_LOCAL_ASSET_READONLY_GATE.md`（此文件**完整规定**所有字段：`OBJECTIVE`、`MAX_ENDPOINT_THIS_ROUND`、`MANDATORY_REVIEW_STOP`、`TARGET_AND_SCOPE`、`APPLICABLE_CRITICAL_CONSTRAINTS`、`PREFLIGHT`、`REQUIRED_EVIDENCE`、`ACCEPTANCE_CRITERIA`、`ROLLBACK_STATUS_OR_PLAN`、`OWNER_ONLY_ACTIONS`、`REVIEWER_TO_EXECUTOR_RELAY`、`EXECUTOR_TO_REVIEWER_RELAY`）。
**OBJECTIVE**：在用户原生 Windows PowerShell 仅**只读**检查 `KarakeepLocal`、两个 Docker volumes、共享 Docker Desktop 路径/挂载关系及有界 `sass/saas/Karakeep` 疑似工作区；对归属/是否运行引用/有无独有未提交 Git 文件做清晰分类；把脱敏清单 `LOCAL_ASSET_INVENTORY.md` 与新一轮 append-only `EXECUTION_EVIDENCE.md` 写 GitHub main，停 Reviewer。
**MAX_ENDPOINT_THIS_ROUND**：只有**本机只读元数据检查** + GitHub 项目级文档写入/读回；不扫描全盘、不读取数据库或 Secret，不打开浏览器、不运行旧 G2B Canary；不创建、修改、移动或删除本机文件/目录，不改变 Docker/Compose/系统，不做备份、恢复、迁移、重启、监控。搜索未找到 `sass` 时记录范围和 `UNKNOWN`，不能宣称不存在。
**MANDATORY_REVIEW_STOP**：仅生成脱敏库存清单/证据并提交 main 后停止；不自动归档、清理/删除，不进入 Phase B/C。
**REVIEWER_TO_EXECUTOR_RELAY**：直接使用 `G3A_LOCAL_ASSET_READONLY_GATE.md` 的完整 `REVIEWER_TO_EXECUTOR_RELAY`；该文件是本轮自洽的唯一执行说明，禁止让 Executor 自行续跑已停止的 G2B 或整个历史。
**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交（必要时）。

## CRITICAL_CONSTRAINTS
已结项安装不撤回，保留运行服务/两个 named volumes /受保护 Compose/.env/三镜像；不迁移成一个 Windows 文件夹、不打开 VHDX/真实库、不可删除任何真实数据；不做备份/恢复、不做系统/Docker 重启或长期监控。**G3A 仅允许有界本地只读元数据检查 + GitHub 脱敏文档写入；不移动/修改/删除任何本机文件，也不运行浏览器/Computer Use。**
任何 `sass/saas` 候选可能属于其它项目，必须判明归属/未推送/运行引用，不确定即保留。此前 G2B 因浏览器目标不明停止，不允许以本 Gate 绕过。

## DEFAULT_EXECUTION_CHANNEL
**G3A 一次性执行**：Owner 原生 Windows PowerShell Codex；当前已准备好独立只读 Gate，尚须 Owner 将指令贴入其本机 Codex 才会实际盘点。日常 Karakeep 使用不需要 Codex。

## CURRENT_ROLLBACK_STATUS
本轮没有运行态写入、没有收藏和删除动作；**rollback = NOT_REQUIRED**，既有 G1I 的 project-only down（不带 -v）仍是历史技术方法，当前未执行也不授权执行。备份未做，`BACKUP_NOT_REQUESTED/RESTORE_UNVERIFIED`，潜在数据丢失风险未解决。

## UNRESOLVED
G2B R2 Canary 未执行；本轮最终 HTTP 未重新检查；无 G2B Evidence append/readback；底层 Windows VHDX 文件名/路径仍未知。历史语言设置最终保存状态未知；重启/长期运行和备份由 Owner 明确排除，**不是下一位 Reviewer 要擅自推进的事项**。

## NEXT_STEP
**唯一下一步：Owner 将 G3A Gate 指令发给本机 Codex**，完成限量文件元数据/引用/未提交状态发现，在 GitHub main 新增 `karakeep-local/LOCAL_ASSET_INVENTORY.md` 以及向 `EXECUTION_EVIDENCE.md` append 真实 G3A 证据，提交并 readback；Executor 停 Reviewer，不移动/删除任何本机文件。Reviewer 独立验收后才做分类及是否需要未来归档/清理的建议。上次 G2B R2 保持 RETURN，不在本轮处理。

## OWNER_ACTION_REQUIRED
**仅把已准备的 G3A 单轮提示词转给本机 Codex**，不需要直接给文件密码/密钥。若有界目录搜索不能定位 `sass/saas`，后续再请 Owner 提供该目录一个确切完整地址。无需执行任何本地手动删除或备份。

## EVIDENCE_POINTERS
- **现行新 Gate（已授权但未执行）**：`G3A_LOCAL_ASSET_READONLY_GATE.md` / `KARAKEEP-WIN-G3A-LOCAL-ASSET-INVENTORY-READONLY-20261016`；允许新建的脱敏结果文件 `LOCAL_ASSET_INVENTORY.md` **当前尚不存在**。
- **Owner 授权**：2026-10-16 回复“我没问题，开始吧”，对应上一轮 `LOCAL_ASSET_ARCHIVE_PLAN.md` 阶段 A **只读盘点**；不批准删除、移动、备份或迁移。
- **新增无执行权限的资产归档计划**：`LOCAL_ASSET_ARCHIVE_PLAN.md`；Owner 2026-10-16 本轮提出本机文件归档、防误删问题，Reviewer 仅产出 GitHub 文档。决策见 `DECISION_LOG.md` 的 `D-20261016-LOCAL-ARCHIVE-PLAN`。
- **本次 G2B 中止的事实源**：2026-10-16 本轮 Owner 转交 Executor 未完成报告，具体摘要记录 `DECISION_LOG.md#d-20261016-g2b-r2-stop--浏览器目标无法确认未完成并停在-reviewer`（`OWNER_REPORTED`）；**未提交 Executor G2B Evidence / Commit SHA**。
- **历史最后 G1J Executor Evidence**：`main:karakeep-local/EXECUTION_EVIDENCE.md` blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4`，commit `b801c2b629b303f730d05329c958cffca61686b3`。后续若此 blob 变化需核对是否有人重新 append，不能擅自推测本轮已补全。
- **正式 Closeout**：`CLOSEOUT_REPORT.md`；**Storage/no migration**：`README.md` 和 `DECISION_LOG.md` 中 `D-20261016-G2B-R2`；Governance `entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7。
