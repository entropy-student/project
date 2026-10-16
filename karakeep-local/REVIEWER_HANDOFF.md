# Karakeep Local · Reviewer Handoff

> LAST_REVIEW=2026-10-16
> PROJECT_STATUS=`CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`
> CURRENT_GATE_ID=`KARAKEEP-LOCAL-IMPLEMENTATION-CLOSEOUT-20261016`
> GATE_STATUS=`REVIEWER_CLOSE_PASS_NON_DESTRUCTIVE`
> EXECUTION_CHANNEL=`NONE (closed)`
> GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> `CLOSEOUT_REPORT.md` = 本次正式结项核对；`DECISION_LOG.md` = 决策理由；`EXECUTION_EVIDENCE.md` = append-only 历史执行证据。

## PROJECT_GOAL
在 Owner 原生 Windows 11 本机使用 Karakeep 官方 Docker Compose 部署可访问的三服务收藏管理应用，Web 仅绑定 `127.0.0.1:3000`，不更改其他 Docker 项目。**本机安装及首次登录/UI 语言设置入口确认任务已完成并正式关闭；Karakeep 服务继续留在本机供 Owner 使用。** 不等于软件卸载/服务器退役，也不等于已经验证所有真实收藏功能与备份恢复。

## PROJECT_STAGE
- **G0–G1R**：环境、受保护原 Compose/.env、内部 Secret、磁盘及项目隔离建立；历次诊断记录保留。
- **G1C–G1I**：三份官方镜像最终全部成功拉取；历史 Meili 网络故障已克服。G1I 原 Chrome 主机名 HTTP 探针被 Chromium Host 校验拒绝，导致当时的 Gate RETURN/项目安全停止；后证明该裸探针不能代表真正应用的浏览器连接。
- **G1J 正式 PASS**：三个容器运行健康；登录页 200，Meilisearch health 200；Web 容器内部 Chrome CDP 握手和 `Browser.getVersion` 成功，Worker 浏览器解析/连接路径无重试/断开；仅 Web localhost 映射，非目标 Docker 不变，无观察到 OOM/重启；服务按 Gate 保持运行。
- **G2A Owner 首次使用 `PASS_SCOPED`**：Owner 当前对话中的本机截图显示已进入登录后的 Karakeep 功能页；其后 Owner 反馈已找到 `Interface Language` 选项。实际简体中文是否已经选中且保存未再次验证（`UNVERIFIED`），不是本项目实施 Close 的硬门槛。
- **2026-10-16 Owner 明确要求正式 Close**。Reviewer 判 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`：不再安排开发/调试/登录任务，保留容器与数据卷；真实收藏、备份恢复及长期运维列为 `DEFERRED_NOT_PASS`。

## SYSTEM_MAP
- **运行位置**：Owner Windows 11 + Docker Desktop Linux Engine / Compose，默认以后如要本机技术维护仍用 Owner 原生 PowerShell Codex；**已关闭项目不再有自动执行 Gate**。
- **应用 URL**：`http://localhost:3000`。G1J 验证 Web 仅发布 `127.0.0.1:3000:3000`、非 loopback 负面检查通过；Chrome `9222` 与 Meilisearch `7700` 无主机端口映射。
- **Compose/Secret**：`$env:USERPROFILE\KarakeepLocal\docker-compose.yml` SHA-256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`；同目录 `.env` 有 `KARAKEEP_VERSION/NEXTAUTH_SECRET/MEILI_MASTER_KEY/NEXTAUTH_URL` 四键和两个安全 Secret。严禁输出值/hash、重新生成、上传到 GitHub 或为结项删除。
- **镜像身份**：
  - Web `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`
  - Chrome `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`
  - Meili `getmeili/meilisearch@sha256:860fa4baed04ae1c235de870edab0c8006227546dea1bbb6411fbfc5e27cf1db`（v1.41.0）
- **隔离项目**：`karakeep-local`，服务 `web/chrome/meilisearch`，两个项目卷 `karakeep-local_data`、`karakeep-local_meilisearch`。Owner 已进入登录后页面，卷中可能包含本机账户资料，应作为**保留的持久数据资产**。
- **最后运行事实**：G1J 本机直接读回 2026-10-16T07:37:55Z 目标三容器 running/0 restart/0 OOM、Web healthy；随后 Owner 网页截图再次证明本机应用可被使用。云端 Reviewer 没有对 Owner 本机的持续实时观测。
- **其它项目**：G1J 只新增此项目三个容器和一网络，不更改此前 20 个其它容器/其它项目。原其它容器退出及旧 MariaDB unhealthy 不由本项目修复。
- **网络/资源**：Docker Desktop 代理维持 System proxy / Same as host，不因 Close 修改；不人为强制 2 GiB 空闲 RAM 等静态门槛，未来以实际 OOM/性能/重启作为维护依据。
- **可恢复性边界**：G1I 曾验证仅本项目 `docker compose -p karakeep-local down` 无 `-v` 可停止容器并保留镜像/卷，**不是离机备份或用户数据恢复验证**；原 Secret 和持久卷目前没有已经验收的不同故障域恢复材料。详情见 `CLOSEOUT_REPORT.md`。

## CURRENT_ACCEPTED_STATE
**IMPLEMENTATION_CLOSED_AND_RUNNING**：G1J 技术部署和 G2A 首次登录后 UI 及语言设置入口得到对应等级的证明，Owner 确认结项。没有执行 Close 名义的 Docker down/prune/uninstall/数据删除，服务按已接受运行状态保留。结项并不表示随时在线的实时保证、浏览器抓取 E2E、语言设置已实际应用或完整灾难恢复通过。
**CLOSEOUT_GOVERNANCE**：11F non-destructive closure：Remote 文档/脱敏证据保留 PASS；Remote 可供技术复现的配置/镜像引用已记录，但用户数据库/Secret 离机恢复 **PARTIAL/UNVERIFIED**；Local decommission **NOT_APPLICABLE（明确不做，保留运行中服务）**；Final reconciliation 对**实施结项范围** PASS，数据/Secret 与其它真实产品功能缺口归 `DEFERRED_NOT_PASS`。未做本地文件/未推送修改项清点，因本次不删除任何本地资料。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-LOCAL-IMPLEMENTATION-CLOSEOUT-20261016`
**OBJECTIVE**：应 Owner 要求，将已接受的本机安装与首次使用入口 Gate 关闭，保留所有运行服务及资料，明确延期责任。
**MAX_ENDPOINT_THIS_ROUND**：只更新 GitHub 项目级 Reviewer 交接、决策、Closeout 文档并读回；**无本机 Docker/Windows 写入、无应用卸载、无清理**。
**MANDATORY_REVIEW_STOP**：项目实施任务正式终结于本 Gate，不继续自主规划或自动执行下一 Gate。
**TARGET_AND_SCOPE**：`karakeep-local/REVIEWER_HANDOFF.md`、`karakeep-local/CLOSEOUT_REPORT.md`、`karakeep-local/DECISION_LOG.md`；`EXECUTION_EVIDENCE.md` 原样不动。
**APPLICABLE_CRITICAL_CONSTRAINTS**：Owner 数据/账户/密钥和两卷保留；不删除容器/镜像/工作区；不改 Docker Desktop/代理/证书/其它项目；未验收的功能不能写成 PASS。
**PREFLIGHT**：G1J Evidence main/blob 已核验，Owner 登录后界面与语言入口由本轮会话支持，Owner 明确要求结项；真实异机恢复未验收且本轮无任何 destructive 操作。
**REQUIRED_EVIDENCE**：已接受 G1J Evidence、Owner 当前界面与语言选项反馈（OWNER_REPORTED），GitHub Closeout/Decision/Handoff 文件提交与读回；不需要任何 Secret、账户密码、截图上传或新本机执行。
**ACCEPTANCE_CRITERIA**：实施范围闭合、应用继续运行不受本次改动影响、遗留事项全部标记 DEFERRED_NOT_PASS、不越权处理运行态、GitHub 三文档互相一致并能从 main 读回。
**ROLLBACK_STATUS_OR_PLAN**：只有 GitHub 文档变更；本机运行状态和数据完全不动。今后需要停/迁移/清理须单独新 Gate，不能复用本结项许可。
**OWNER_ONLY_ACTIONS**：Owner 本轮已明确授权“正式 close”安装实施项目；不将此表述视为数据销毁或业务系统退役授权。
**REVIEWER_TO_EXECUTOR_RELAY**：`NONE`（项目实施 Close）。
**EXECUTOR_TO_REVIEWER_RELAY**：`NOT_APPLICABLE`。

## CRITICAL_CONSTRAINTS
已经存在的 Web/Chrome/Meili、Compose/.env/Secret/两卷必须保留；本机仅 127.0.0.1:3000；不清理、不升级镜像、不改其它 Docker 项目；未验证的真实收藏、备份/恢复及长期持久性不是 PASS；无后续自动 Codex 工作。

## DEFAULT_EXECUTION_CHANNEL
`NONE`（实施工作已关闭）。若 Owner 未来新提维护任务，仍优先使用 Owner Windows 原生 PowerShell Codex，并制定新 Gate。

## CURRENT_ROLLBACK_STATUS
本次仅 GitHub 文档结项，无本机回滚；G1I 证明项目级 down（不含 -v）可安全停止并保留两个命名卷，但**不代表**任何账户/书签可以跨设备恢复。真数据前应新 Gate 完成 Secret 及项目卷备份/实际恢复验证。禁止 `down -v` 和 `prune`。

## UNRESOLVED
`DEFERRED_NOT_PASS`：实际 Simplified Chinese 设置是否已完成并刷新保持、真实 URL 收藏抓取/搜索/预览 E2E、可靠数据+Secret 离机备份恢复、Docker Desktop 重启持久性及长期运行。Web 镜像 OCI revision tag 缺失，精确源码 commit `UNVERIFIED`。以上不再触发当前实施工作自动继续。

## NEXT_STEP
`NONE`（实施项目 CLOSED）。Owner 可直接使用 `http://localhost:3000`；首次保管不可丢失的收藏前，应**另开**单独的备份/恢复 Gate；如果要完全卸载则必须另行授权真正 decommission，不得使用此 Closeout 作为清理依据。

## OWNER_ACTION_REQUIRED
`NONE`。保留本机应用、配置、密钥和数据卷；无需向 Reviewer 提供登录密码/Secret。真实重要书签使用前自主发起备份/恢复工作。

## EVIDENCE_POINTERS
- Reviewer 接受的 G1J 证据：`EXECUTION_EVIDENCE.md` commit `b801c2b629b303f730d05329c958cffca61686b3`；blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4`。
- Owner 当前聊天确认：截图显示登录后的 Karakeep 页面；语言设置“找到了”；User report only，未保存敏感资料。
- **正式 Closeout**：`karakeep-local/CLOSEOUT_REPORT.md`；**决策史**：`karakeep-local/DECISION_LOG.md`。
- 项目治理：`entropy-student/spike.skill/main:vps-project-governance/VNEXT.md` v0.2.7，blob `3917c88a7f36df7a53758b3879a92703d659ef9d`；保留全部历史 Evidence。
