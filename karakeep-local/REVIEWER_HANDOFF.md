# Karakeep Local · Reviewer Handoff

> LAST_REVIEW=2026-10-16
> PROJECT_STATUS=`CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`（原安装 PASS/Close 保持有效）
> LAST_GATE_ID=`KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016`
> LAST_GATE_REVISION=`R2_STORAGE_LAYOUT_NO_MIGRATION`
> GATE_STATUS=`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`
> NEXT_GATE_ID=`NONE_WAIT_OWNER_INSTRUCTION`（不能自主重试）
> CANONICAL_GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7 / blob `3917c88a7f36df7a53758b3879a92703d659ef9d`
> DOCUMENT_HOME=`https://github.com/entropy-student/project/tree/main/karakeep-local`
> `README.md` 为索引，**本 Handoff 为唯一当前状态权威**；`DECISION_LOG.md` 为决策及本轮 Reviewer 对中止报告的整理；`EXECUTION_EVIDENCE.md` 仍只包含历次 Executor 已成功提交的执行证据。

## PROJECT_GOAL
在 Owner 实体 Windows 11 本机运行官方 Karakeep，用于本人收藏网页，登录界面可用且仅 `127.0.0.1:3000` 暴露。**安装实施已于 2026-10-16 正式 CLOSE，运行资源和账户保留**。之后 Owner 限定一次 G2B R2：只读核对 Docker 实际存储、测试最多一条可丢弃公开网页收藏、清理能证明无引用的本项目临时文件；**不备份、不恢复、不迁移、不重启、不监控**。本轮被浏览器目标识别阻碍中止；Owner 最新指令是**记录未完成并等待下一次 Owner 指令**。

## PROJECT_STAGE
- **G0–G1I 历史**：Windows/Docker Desktop、受保护本机 Compose/.env、三份官方镜像最终就绪。此前 Meili 下载异常已经克服；G1I 裸 `Host:chrome` 500 是 Chromium Host 安全限制、与真正 Worker CDP 连接不能简单等同，经过独立研究后不再作为失败依据。G1I 的 project-only `down`（无 `-v`）曾停止目标容器并保留两卷，**不是用户数据灾备证明**。
- **G1J 技术安装 `PASS`（Reviewer 已正式接受）**：Web 登录页 HTTP 200、Meilisearch health 200、Web 容器到 Chrome DevTools 的只读 CDP 握手成功、Worker 浏览器地址解析日志无失败/重试/断连，只有 Web `127.0.0.1:3000` 暴露。三容器健康/无 OOM/重启，G1J 后保留运行。Worker 没有独立 success log，Web OCI revision 缺失，证据边界已接受，**不用再重跑 G1J**。
- **G2A `PASS_SCOPED`（OWNER_REPORTED）**：Owner 登录后的 Karakeep 网页截图表明能进入账户界面；Owner 找到 `Interface Language` 设置，是否实际切换简体中文并刷新持久仍 `UNVERIFIED`，非当前阻碍。
- **原安装实施 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`**：正式记录在 `CLOSEOUT_REPORT.md`，从未授予删除、退役或迁移权限。
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
**安装实施仍 CLOSED / G1J PASS；G2B R2 正式 `RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`，不得判 PASS。** 当前可引用的 G2B 报告事实仅是 Owner 转交的 Executor 完成包，其“本机直接读回”未由 Reviewer 独立检视及持久化到 `EXECUTION_EVIDENCE.md`；禁止标为 `DIRECT_READBACK` by Reviewer。保留其可用事实供下次**有界复核**，避免无意义的安装检查重做：
`STORAGE_PATHS_REPORTED`；`CLEANUP_CANDIDATES=0_REPORTED`、`FILES_DELETED=0`；`CANARY_ADDED=0`、`CANARY_CRAWL/SEARCH/PREVIEW=NOT_RUN`；`HTTP_RECHECK=NOT_RUN`；`RUNNING_SERVICES=REPORTED_ONLY`；`G2B_EXECUTION_EVIDENCE=NOT_PERSISTED`。**没有证据显示 Karakeep 应用损坏或因 Browser CDP 失败**，工具无法确认浏览器 URL 不等同应用故障。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016` / **REVISION**：`R2_STORAGE_LAYOUT_NO_MIGRATION`
**OBJECTIVE**：一次性只读核实存储、单条可弃公开收藏功能 Canary、明确可弃的本机临时文件清理；原本目标已冻结，**此次执行因浏览器目标不明中止**。
**GATE_STATUS**：`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`，已按停止要求结束，**本 Gate 不再处于 READY 或可直接重试状态**。
**MAX_ENDPOINT_THIS_ROUND**：已执行到配置、磁盘目录/挂载、容器/ACL 等只读探测；未进入 Canary、未执行新 HTTP 最终验收、没有删除；允许 Reviewer 仅更新 GitHub 项目文档并读回；**不能让 Executor 自动继续**。
**MANDATORY_REVIEW_STOP**：`STOP_WAIT_OWNER`；Owner 明确要求等待下一次新指令。
**TARGET_AND_SCOPE**：Owner 本机 `karakeep-local` 及脱敏 GitHub 项目记录；未来是否做 Canary 由 Owner 新指令决定。
**APPLICABLE_CRITICAL_CONSTRAINTS**：不冒用新浏览器/页面身份、不绕过 Computer Use 安全停止；不得复用当前 G2B 的旧授权进行新浏览器动作；原配置/Secret/两卷、其他项目不变；不备份、不迁移、不重启、不长时监控、不全局 Docker 清理。
**PREFLIGHT**：本次从 Owner 报告得知本机配置/卷归属未见漂移、Docker Desktop UI 显示 WSL2；这些只视为本轮回传现状，非下一次写操作的自动有效预检。
**REQUIRED_EVIDENCE**：G2B R2 Gate 规定的单条收藏/抓取/搜索/预览和最终 HTTP/非目标回归以及 Executor main append/readback 均**缺失**。本轮无 G2B SHA；历史 G1J Evidence 保持原 blob。
**ACCEPTANCE_CRITERIA**：存储事实可作为报告结论（OWNER_REPORTED），没有删除的清理子项记 `NO_CANDIDATES_REPORTED`；完整 Gate 因 Canary、HTTP/Evidence 未完成而 `RETURN`，不能以旧 G1J Web PASS 代替当前 Canary。
**ROLLBACK_STATUS_OR_PLAN**：未发生 Karakeep 数据/配置/系统变更，删除 0、收藏 0，故不触发回滚；不再执行 `down`/恢复/迁移，保留当前数据卷及服务。若后续真实状态不同，先只读核验和 Reviewer 研判。
**OWNER_ONLY_ACTIONS**：Owner 下轮若仍希望验证功能，需要**新的明确任务**；当浏览器目标无法自动确认时，应采用可证明身份的最小 Owner 手动交互或另设有界目标核验，绝不要求/使用 Owner 的 Cookie/密码；未授权前不执行。
**REVIEWER_TO_EXECUTOR_RELAY**：`NONE_STOP_WAIT_OWNER`；本轮无新 Executor 指令。
**EXECUTOR_TO_REVIEWER_RELAY**：Owner 已转交本次未完成报告，Reviewer 将结论归档；无新的执行。

## CRITICAL_CONSTRAINTS
已结项安装不撤回，保留运行服务/两个 named volumes /受保护 Compose/.env/三镜像；不迁移成单个 Windows 文件夹、不打开 VHDX、不可删除任何真实数据；不做备份/恢复、不做系统/Docker 重启或长期监控；只在将来新 Owner 授权下考虑一条非隐私公开 URL Canary；旧 G2B R1/备份草案绝对不可执行。Chrome 连接验收 G1J 已 PASS，不因 Computer Use URL 定位问题而回退。

## DEFAULT_EXECUTION_CHANNEL
正常状态无 Codex 任务，Owner 可直接网页使用。若 Owner 将来明确重开维护，默认在 Owner Windows 原生 PowerShell Codex 执行，但必须有 Reviewer **新 Gate**，不能续跑已停止的本轮。

## CURRENT_ROLLBACK_STATUS
本轮没有运行态写入、没有收藏和删除动作；**rollback = NOT_REQUIRED**，既有 G1I 的 project-only down（不带 -v）仍是历史技术方法，当前未执行也不授权执行。备份未做，`BACKUP_NOT_REQUESTED/RESTORE_UNVERIFIED`，潜在数据丢失风险未解决。

## UNRESOLVED
G2B R2 Canary 未执行；本轮最终 HTTP 未重新检查；无 G2B Evidence append/readback；底层 Windows VHDX 文件名/路径仍未知。历史语言设置最终保存状态未知；重启/长期运行和备份由 Owner 明确排除，**不是下一位 Reviewer 要擅自推进的事项**。

## NEXT_STEP
`WAIT_OWNER_INSTRUCTION`。Reviewer 本次只把中止判断和 Owner 转交的事实写入 main Handoff / Decision、保持 `EXECUTION_EVIDENCE.md` 历史不动，并读回核验。**不创建下一 Gate、不发下一执行提示词、不自行处理浏览器或执行手动 Canary**。如 Owner 将来请求继续，首先用已保存现状设计最小新 Gate，确认浏览器目标/会话安全后再做剩余单条 Canary，避免重跑已核对的整个安装链路。

## OWNER_ACTION_REQUIRED
`NONE_NOW`。仅等待 Owner 未来是否希望继续此功能测试。无需新密码、Cookie、Secret、备份介质或本机操作。

## EVIDENCE_POINTERS
- **本次 G2B 中止的事实源**：2026-10-16 本轮 Owner 转交 Executor 未完成报告，具体摘要记录 `DECISION_LOG.md#d-20261016-g2b-r2-stop--浏览器目标无法确认未完成并停在-reviewer`（`OWNER_REPORTED`）；**未提交 Executor G2B Evidence / Commit SHA**。
- **历史最后 G1J Executor Evidence**：`main:karakeep-local/EXECUTION_EVIDENCE.md` blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4`，commit `b801c2b629b303f730d05329c958cffca61686b3`。后续若此 blob 变化需核对是否有人重新 append，不能擅自推测本轮已补全。
- **正式 Closeout**：`CLOSEOUT_REPORT.md`；**Storage/no migration**：`README.md` 和 `DECISION_LOG.md` 中 `D-20261016-G2B-R2`；Governance `entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7。
