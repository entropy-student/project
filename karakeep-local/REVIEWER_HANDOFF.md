# Karakeep Local · Reviewer Handoff

> LAST_REVIEW=2026-10-16
> INSTALLATION_STATUS=`CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`（已正式结项，不撤销）
> POST_CLOSE_TASK=`G2B_READY_FOR_EXECUTOR`（一次性功能测试 + 非破坏性本地清理）
> CURRENT_GATE_ID=`KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016`
> GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> DOCUMENT_HOME=`https://github.com/entropy-student/project/tree/main/karakeep-local`
> `README.md` 是**统一文档入口**；本文件是唯一权威当前状态；`CLOSEOUT_REPORT.md` 保留原正式结项；`DECISION_LOG.md` 保留决策；`EXECUTION_EVIDENCE.md` append-only。

## PROJECT_GOAL
Karakeep 官方三服务已在 Owner Windows 11 本机完成安装并由 Reviewer 正式 PASS；Owner 已进入登录后的 Web UI 并找到中文设置。已结项服务继续留在本机 `http://localhost:3000` 运行。最新 Owner 要求：**不做备份、不做恢复演练、不迁移数据、不做 Windows/Docker Desktop 重启测试和长期监控**；只需一次功能测试、严格安全的本地临时文件清理，以及在**同一个 GitHub 目录**整理项目文档与日常启动方法。

## PROJECT_STAGE
- G0–G1I：受保护 Compose/.env 创建、三个官方镜像拉取和历史代理/Chrome 兼容问题处理成功；历史 Evidence 原样保留。
- **G1J=PASS**：Web、Chrome CDP、Meilisearch 和 localhost 端口隔离验收通过，三容器保持运行（现场时间 2026-10-16T07:37:55Z），无当轮 OOM/重启；不等于此刻的实时监控。
- **G2A=PASS_SCOPED**：Owner 显示登录后的 Karakeep 页面、找到 `Interface Language`；是否最终选择并持久保存简体中文 `UNVERIFIED`。
- **INSTALLATION CLOSED**：正式结项 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`，容器、两卷、配置及账户全部保留。
- **G2B 初稿被取消**：上一版 `KARAKEEP-WIN-G2B-ONE-SHOT-BACKUP-CANARY-CLEANUP-20261016` 尚无执行证据，因 Owner 最新指示 `SUPERSEDED_UNEXECUTED`，**绝不可再执行那版备份 Gate**。
- **当前 G2B NEXT**：仅一条可丢弃公开网页的添加/抓取/搜索/预览测试，以及只有可证明属于项目且无人引用的临时文件安全清理；完成后停 Reviewer，维持原安装 CLOSED。
- **明确永久留本机直至 Owner 改变决定**：`BACKUP_NOT_REQUESTED / RESTORE_UNVERIFIED`，目前没有异机/离线的用户数据与 Secret 恢复副本；设备/磁盘故障可能导致账号和收藏不可恢复，这不是 PASS。

## SYSTEM_MAP
- **文档统一位置（GitHub）**：`https://github.com/entropy-student/project/tree/main/karakeep-local`，详见 `README.md`，同目录文件 `REVIEWER_HANDOFF.md`、`CLOSEOUT_REPORT.md`、`DECISION_LOG.md`、`EXECUTION_EVIDENCE.md`。禁止将原数据库、卷备份、账户密码、Secret 或原始敏感日志放进 GitHub。
- **本机运行入口**：Windows Docker Desktop 的 Linux Engine；仅本机 `http://localhost:3000`；Web host publish `127.0.0.1:3000:3000`，Chrome 9222/Meilisearch 7700 仅项目内部。
- **Compose 与 Secret**：`$env:USERPROFILE\KarakeepLocal\docker-compose.yml`，SHA-256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`；同目录的 `.env` 四键 `KARAKEEP_VERSION/NEXTAUTH_SECRET/MEILI_MASTER_KEY/NEXTAUTH_URL`，原密钥只留在本机受保护位置，不输出/再生/提交/清理。
- **数据仅留本机**：Docker 命名卷 `karakeep-local_data`（账户/收藏等应用资产）、`karakeep-local_meilisearch`（搜索状态）。Docker Desktop 管理，不是 GitHub 项目文件；**本轮不备份、不导出、不恢复、不修改卷内容（除了用户本人明确允许的一条公开可丢弃 Canary 收藏）**。
- **已有三官方镜像**：
  - Web `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`
  - Chrome `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`
  - Meilisearch `getmeili/meilisearch@sha256:860fa4baed04ae1c235de870edab0c8006227546dea1bbb6411fbfc5e27cf1db` v1.41.0。
- **项目身份**：Compose `-p karakeep-local`，服务 `web/chrome/meilisearch`；两卷继续留存。非目标既有 WordPress/MariaDB 等容器、Windows/Clash/代理/Docker Engine 共享设置禁止更改。
- **日常重开方法**：Docker Desktop 已启动但 Karakeep 未运行时，PowerShell 执行：
  ```powershell
  Set-Location (Join-Path $env:USERPROFILE 'KarakeepLocal')
  docker compose -p karakeep-local up -d --pull never
  if ($LASTEXITCODE -eq 0) { Start-Process 'http://localhost:3000' }
  ```
  正常运行时直接打开网页即可。不进行故意重启测试；未来如遇故障再具体排查。
- **风险**：`BACKUP_NOT_REQUESTED` 是 Owner 最新指示，**不是已解决数据风险**；没有验证异机数据与 Secret 恢复。用户若开始收藏重要、不可丢失的资料，应知晓仅本机保存的风险。

## CURRENT_ACCEPTED_STATE
原安装 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED` 保持有效；G2B 目前只有 Reviewer 文档计划和 Owner 最新决定，**没有收到任何本机 G2B 执行结果**；不能声称已完成 Canary、清理、备份或恢复。
文档当前统一在 GitHub 同一目录，新增 `README.md` 作为索引。历史 Closeout 中保留当时对备份/恢复的风险记录；后续当前 Owner 决定是**取消实施备份**，不是接受了虚构的安全备份结果。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016`
**OBJECTIVE**：Owner Windows 本机 Karakeep 一次性完成一条无敏感信息的收藏抓取/搜索/预览 Canary、项目本机确证可弃的临时文件安全清理，并记录简单的使用入口与 GitHub 项目文档目录；**备份/恢复、迁移、重启及长期观察全部禁止**。

**MAX_ENDPOINT_THIS_ROUND**：
1. 最小 read-only preflight：真实 Owner Windows PowerShell、本机 Docker context、原 Compose SHA/权限、三服务实际状态及仅 loopback 主机端口、两原卷存在及归属、非目标容器/网络快照、可用资源。无需重新跑 G0–G2A 历史诊断，不以静态剩余 RAM 数值阻断。不得读取/回传原登录密码、Cookie 或 Secret。
2. **一条可丢弃、无隐私的 URL 功能测试**：通过 Owner 当前已登录的 Karakeep 网页手动添加一条公开测试 URL（如 `https://example.com`），最多一条，观察保存、Worker 抓取、搜索命中、页面内容预览以及在产品当前设置下截图/缩略图是否如预期。若需登录，而 Executor 不具备经授权的安全会话，则由 Owner 在网页中完成这一条点击，不要求输入或交出凭据；据产品证据如实标 PASS/PARTIAL。可保留这条公开测试记录；不批量导入/不碰其他已有收藏。
3. **项目本机临时文件清理**：只调查 `KarakeepLocal` 项目明确归属的已废弃日志/诊断下载等文件；逐项证明无活跃引用、可以重新生成、不是唯一资料且删除不会改变运行容器/卷/配置。任何 `UNKNOWN`、权限/归属不明、唯一资料或受保护文件均**保留**。删除只能针对已证明 `LOCAL_DISPOSABLE` 且 Owner 本轮授权的精确文件；不能删除 `docker-compose.yml`、`.env`、Docker 卷、镜像/层、运行容器或整个目录，不能全局 prune。不做“释放空间”式扩大清理。
4. 验证本机 `http://localhost:3000` 与必要服务读回、仅 Web loopback、两命名卷/Secret/非目标 Docker 基线不变；记录清理了多少个无关临时文件及删除前后内容类别，不能包含真实用户信息。无安全候选时记 `CLEANUP_NOT_REQUIRED`，不是失败。
5. **严格不允许任何** Docker 卷备份/快照、复制 .env/Secret、数据或账户导出、恢复演练/隔离恢复副本、云盘上传、备份路径扫描、迁移、Windows/Docker Desktop 重启及长期监控。也不自行升级镜像/修改代理/安装插件/重设账户。
6. 将 G2B 的脱敏 `EXECUTION_EVIDENCE.md` 追加到 GitHub main 并读回，按固定 Executor->Reviewer 六项格式报告，立刻停 Reviewer；不自动继续 G2C、不开启监控或新的清理。

**MANDATORY_REVIEW_STOP**：一次 G2B 完成后即停 Reviewer；安装实施仍 CLOSE，Reviewer 只接受或精确返回本轮结果。
**TARGET_AND_SCOPE**：Owner 实体 Windows 本机 `karakeep-local` 服务/已受保护配置的**必要只读检查**、Owner 账户的一条可弃公开 Canary、经验证项目独有的可弃临时文件；GitHub 项目自身 `EXECUTION_EVIDENCE.md` append。禁止对所有其他 Docker 项目及共享系统设置产生写入。
**APPLICABLE_CRITICAL_CONSTRAINTS**：不备份、不迁移、不恢复、不改 Secret、不能碰真数据卷/镜像/系统设置；任何文件删除经项目归属与引用分类，否则 skip；Canary 单条最小变更；无固定 RAM 门槛、实际 OOM/异常要返回；仅 localhost；脱敏 Evidence。
**PREFLIGHT**：Owner 本次明确取消旧 G2B 的备份内容，授权一轮功能测试及可证明可弃本机文件的安全清理；旧 Gate `SUPERSEDED_UNEXECUTED`。若无经过 Owner 的安全浏览器会话，Canary 交 Owner 一步网页操作。所有写入的对象有精确归属；无关资源不改。
**REQUIRED_EVIDENCE**：原样遵循 `AUTHORIZED_GATE/PREFLIGHT_FACTS/ACTUAL_CHANGES/OBJECTIVE_READBACK/VALIDATION/ANOMALIES/EVIDENCE_ARTIFACTS_AND_PURPOSE/ROLLBACK_EFFECT/RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT/EXECUTOR_RESULT`。增加 Canary 单条入库/抓取/搜索/预览结果；临时文件清理候选+删改计数；明确 `BACKUP_NOT_REQUESTED / RESTORE_UNVERIFIED`、没有备份/重启/迁移行为、Github 文档索引 URL、服务和非目标资源读回；GitHub 不记录账户/资料/Secret。
**ACCEPTANCE_CRITERIA**：单条 Canary 真实可保存并尽可能证明抓取/搜索/预览（实际失败准确 PARTIAL 而不冒充）；清理仅限无引用、可弃的项目确切文件或没有候选即 SKIPPED；没有越权生成备份/恢复材料，所有本机资料/账号和 Docker 项目边界保持；主机 loopback 服务当前可用；main Evidence read-back，交 Reviewer。
**ROLLBACK_STATUS_OR_PLAN**：不覆盖/删除原配置/Secret/卷。Canary 是单条无重要内容的用户可弃记录，默认保留；只删除已证实可弃的独立临时文件，必要时由原内容/工具可重建。若任何非目标状态变化或真正资料风险，停止后续写入并 RETURN，不自动 down 项目或删除其它资源。
**OWNER_ONLY_ACTIONS**：本次新意愿已明确：只保留本机、不做备份，一轮功能测试+安全清理，文件只删除确证可弃物。不需要新的备份位置，不需要任何密码，不做授权外的资料删除。
**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是 Owner 原 Windows 本机 PowerShell Codex Executor。安装项目已 Close，本轮仅执行新 `KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016`。先读取最新 `entropy-student/project` main `karakeep-local/REVIEWER_HANDOFF.md` 的 CURRENT_GATE、SYSTEM_MAP、CURRENT_ACCEPTED_STATE、CRITICAL_CONSTRAINTS 以及同目录 `README.md` 的日常使用位置，勿重跑安装或扫描历史 Evidence。Owner 当前明确**取消前一版 G2B 的全部备份/快照/Secret 恢复/迁移操作**，只授权：①最多一条可弃公开 URL 通过现有登录 UI 添加并检测抓取/搜索/预览，如缺登录会话请 Owner 自行点一次，**绝不索取密码/Cookie**；②本机 `KarakeepLocal` 下只删除经 owner/path/引用/可重建性明确验证的可弃临时文件，没安全候选则不删。**不做数据备份或恢复、不扫描备份路径、不重启 Windows/Docker Desktop、不长期监控、不动任何 Docker 卷/.env/Compose/镜像/代理和其它项目。** 最后确认 `http://localhost:3000` 仍可访问、Web 仅 localhost、非目标状态不变，追加脱敏 G2B Evidence 到 GitHub main 并读回；按固定六项格式交 Reviewer，停止本轮。不自行推进新 Gate。
**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
原安装 Close 有效；**G2B 不备份、不恢复、不迁移、不重启、无监控**；账户/资料仅本机 Docker 两卷且没有恢复副本；原 Compose/.env/Secret 和镜像、运行容器全部保留；只做一条可弃公开 Canary、项目可证明无引用的临时文件清理；其它 Docker 项目、代理和系统不改；GitHub 文件统一由 `README.md` 链接索引。

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 原生 PowerShell Codex（仅当前一次 G2B）。正常使用直接 `http://localhost:3000`，需要唤起时按本 Handoff 或 `README.md` 命令。

## CURRENT_ROLLBACK_STATUS
历史 G1I project-only down（不带 -v）可以停止容器保留卷，但此次不停止项目。Owner 拒绝独立备份和恢复，`BACKUP_NOT_REQUESTED/RESTORE_UNVERIFIED`，**不可把“留在本机”写成已恢复安全性**。本轮所有可弃临时文件须可重新生成；无删除把握就不执行。

## UNRESOLVED
真实网页 Canary 尚未执行；中文语言最终保存未验证；未备份导致的本机故障数据损失风险由 Owner 接受；重启/长期运行行为本次刻意不验证。不得为这些项目扩展额外 Gate。

## NEXT_STEP
Owner 将**最新版而非旧版备份 G2B**的精简提示词交本机 Codex，完成后将 Evidence 交 Reviewer 只审核一次并恢复 CLOSED 静止状态。以后日常使用无需 Codex；访问 `http://localhost:3000` 或 PowerShell 按需启动。所有项目文档统一在 GitHub `karakeep-local/` 目录。

## OWNER_ACTION_REQUIRED
只需要转发当前 G2B 指令。如 Codex 无法使用已登录浏览器，请 Owner 自己在 Karakeep 新建一条非敏感公开测试收藏；不需要提供密码、密钥、备份位置或其他账号。

## EVIDENCE_POINTERS
- 正式技术 G1J PASS 的 `EXECUTION_EVIDENCE.md` commit `b801c2b629b303f730d05329c958cffca61686b3` blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4`。
- 安装正式结项 `CLOSEOUT_REPORT.md`；新 Owner 无备份决定 `DECISION_LOG.md` 的 `D-20261016-G2B-R1`；项目统一文档索引 `README.md`。
- Canonical Governance `entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7。
