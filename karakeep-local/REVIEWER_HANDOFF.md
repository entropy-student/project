# Karakeep Local · Reviewer Handoff

> LAST_REVIEW=2026-10-16
> INSTALLATION_STATUS=`CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`（原实施结项不撤销）
> POST_CLOSE_TASK=`G2B_R2_READY_FOR_OWNER_TO_ISSUE`（未下发、未执行）
> CURRENT_GATE_ID=`KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016`
> GATE_REVISION=`R2_STORAGE_LAYOUT_NO_MIGRATION`
> GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7；本轮仅修改项目文档，未修改治理。
> DOCUMENT_HOME=`https://github.com/entropy-student/project/tree/main/karakeep-local`
> `README.md`=统一入口，**本文件=唯一有效当前状态**，`DECISION_LOG.md`=决策，`CLOSEOUT_REPORT.md`=原结项，`EXECUTION_EVIDENCE.md`=append-only 历史事实。

## PROJECT_GOAL
Owner 的 Windows 11 本机 Karakeep 已安装并可登录。原实施任务正式 CLOSED，三服务及数据保留运行。Owner 最终选择**维持 Docker Desktop 原 named volumes 存储方式**（不把数据合并到 `KarakeepLocal`、不迁移/移动/导出/备份/恢复）；GitHub 同一 `karakeep-local/` 目录集中所有项目**管理文档**。仅在 Owner 给本机 Codex 下发 R2 提示词后，进行**一次**存储位置只读确认、单条可丢弃网页收藏测试和项目级可弃临时文件安全清理；不做设备/Docker Desktop 重启或长期监控。若后续有问题再由 Owner 新开具体排查。

## PROJECT_STAGE
- **G0–G1I / 历史**：Windows Docker Desktop 和项目隔离基线、受保护 Compose/`.env` 两独立 Secret、3 官方镜像逐步就绪。Meilisearch 下载曾失败后在 G1I 成功；G1I 的裸 `Host:chrome` HTTP 500 曾导致 RETURN 和项目级 `down`（无 `-v`），后经官方源解析→IP 的实际逻辑发现该探针不能独立代表应用失败。均为历史 Evidence，**不要重新排查**。
- **G1J Reviewer PASS**：原配置 `docker compose -p karakeep-local up -d --pull never`；Web 登录页、Meilisearch 200、Chrome 从 Web 的真实 IP 形式 CDP `Browser.getVersion` 成功，Worker 已尝试连接并解析地址且无失败/重试/断连。三容器 0 restart/OOM；仅 Web loopback。Web release 镜像缺 OCI revision label、Worker 无独立成功日志，这一证据边界已接受，不重复为它加 Gate。G1J 完成后**服务保留运行**。
- **G2A PASS_SCOPED（OWNER_REPORTED）**：Owner 真实浏览器已进入登录后的 Karakeep 页面，找到界面语言 `Interface Language` 选项；是否切换简体中文并持久保存仍 `UNVERIFIED`，不阻止安装 Close。
- **安装实施已正式 CLOSE**：Reviewer 之前更新 `CLOSEOUT_REPORT.md` 等记录；**并非软件卸载或任何数据清理许可**。
- **G2B GATE 演变（仅决策，无本机执行）**：最初 `KARAKEEP-WIN-G2B-ONE-SHOT-BACKUP-CANARY-CLEANUP-20261016` 是旧草案，`SUPERSEDED_UNEXECUTED`；随后 R1 `KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016` 取消备份，也**尚未下发**；现行仅同一 ID 的 **R2**，按 Owner 最新决定补充 Docker/本机存储布局**只读核对、绝不迁移**。Owner 已明确上一轮提示词**没有下发**。**当前 G2B 没有任何执行结果，亦不能标 PASS**。
- **风险接受**：Owner 无可用异故障域备份位置且明确不愿做备份，`BACKUP_NOT_REQUESTED/RESTORE_UNVERIFIED`。收藏和账户数据仅在本机，电脑或 Docker 磁盘损坏可导致永久丢失。不得把 GitHub 文档、命名卷本身或“存到一个文件夹”说成恢复能力。

## SYSTEM_MAP（当前关键事实）
- **目标主机/渠道**：Owner 实体 Windows 11、本机 PowerShell 7.6.5、Docker Desktop 4.95.0 Personal/Linux Engine 29.7.2、Compose 5.4.0、context `desktop-linux`（上次 G1J 本机执行读回）。**云端 Reviewer 不能实时读取 Owner 本机**。未来本机任务使用 Owner 原生 Windows PowerShell Codex；此次只修改 GitHub，不执行本机指令。
- **使用入口/主机端口**：`http://localhost:3000`。项目 `karakeep-local` 运行 `web/chrome/meilisearch`；Web 唯一主机发布 `127.0.0.1:3000:3000`；Chrome 9222、Meilisearch 7700 不发布主机端口；最后 G1J 非 loopback 负面检查通过。
- **本机项目配置**：`$env:USERPROFILE\KarakeepLocal\docker-compose.yml`，已接受 SHA256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`；同目录受保护 `.env` 四键 `KARAKEEP_VERSION`/`NEXTAUTH_SECRET`/`MEILI_MASTER_KEY`/`NEXTAUTH_URL`。配置/.env 属于**真实运行资产**，不是随意可清理的项目临时文件；不得打印、hash、复制、重生成、变更 Secret，也不得上传 GitHub。
- **用户持久数据**：Compose 保留原 Docker named volume `karakeep-local_data`（Web 容器内部 `/data`：账户、收藏、网页内容等）和 `karakeep-local_meilisearch`（Meili 容器内部 `/meili_data`：搜索索引），均由 Docker Desktop 的 Linux 存储管理，不是 `KarakeepLocal` 普通 Windows 文件夹。已出现 Owner 登录账户，因此两卷必须被视为**现存真实资料**。
- **底层物理位置**：Docker Desktop 可以用 Linux/WSL 虚拟磁盘文件托管多个 Docker 项目的层/卷。**该 Windows 机器的实际 `Disk image location`、VHDX 绝对路径、卷内部 SQLite 文件名=UNVERIFIED**。不可根据默认 `AppData\Local\Docker\wsl\...` 范例猜成用户实际路径；G2B 只读通过 Docker `volume inspect`、容器 `Mounts`、Docker Desktop 磁盘位置 UI（若可用）验证路径*类别*与关系，不打开/挂载/复制/改变磁盘文件，也不在 Windows 资源管理器直接编辑容器数据。
- **不做迁移的正式决定**：原 named volumes 原地保留，不换 Windows bind mounts，不修改 Compose `volumes`、不修改 Docker Desktop `Disk image location`、不停止/重建项目来集中文件、不中断现有登录状态。GitHub 文档和用户数据本就属于不同存储目的地。
- **镜像冻结及来源**：
  - Web `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`
  - Chrome `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`
  - Meili `getmeili/meilisearch@sha256:860fa4baed04ae1c235de870edab0c8006227546dea1bbb6411fbfc5e27cf1db` v1.41.0。
  - 官方源 Compose main blob `865bb147cef972926d5dc32e50645876fd110555`：`data:/data`、`meilisearch:/meili_data`；本机 Compose 改过 Web 端口以 loopback 绑定，但数据卷方案保留官方方式。上述本机具体 repo digests/目录指纹来自历史验收，G2B 需小范围新鲜读回。
- **Shared infra**：原非目标 Docker 20 容器（当时均未运行）、其他卷/网络及 WordPress/MariaDB 项目不能变更；Docker daemon/Desktop、Windows 代理、Clash、VPN、证书不修改。Docker Desktop proxy 原 System / Containers Same as host，镜像下载问题已解决。
- **最近实际运行事实**：G1J 2026-10-16T07:37:55Z 三容器运行、Web healthy/0 OOM/0 restart；G2A Owner 更晚的登录后截图再次证明 Web 可用。**没有实时/长时间在线保证**，本轮亦不做持续监控。G1J 曾短时可用 RAM 低但未 OOM；不设虚构的静态 RAM 阈值。
- **使用/按需启动**：Docker Desktop Engine 已启动时打开 `http://localhost:3000`。若 Karakeep 已停止，可在 PowerShell 中：
  ```powershell
  Set-Location (Join-Path $env:USERPROFILE 'KarakeepLocal')
  docker compose -p karakeep-local up -d --pull never
  if ($LASTEXITCODE -eq 0) { Start-Process 'http://localhost:3000' }
  ```
  用于**未来人工按需调用**，本轮不故意停机/重启以演练此命令。命令的依赖前提是原 Compose/.env、3 本地镜像与两 named volumes 存在；失败就针对错误处理，不能盲目清理 Docker。
- **文档目的地**：`https://github.com/entropy-student/project/tree/main/karakeep-local`。同目录 `README.md`（单点入口）、`REVIEWER_HANDOFF.md`（事实权威）、`DECISION_LOG.md`（决策）、`CLOSEOUT_REPORT.md`（原结项）、`EXECUTION_EVIDENCE.md`（历史逐轮证据）。GitHub 从不上传用户数据库、.env、账户明文、Cookie、原始抓取数据或 Docker 卷内容。

## CURRENT_ACCEPTED_STATE
**安装实施 PASS/CLOSED，服务继续留本机供 Owner 使用；本次 G2B R2 尚无任何 Executor 行动。** 数据存储层已可根据已冻结官方 Compose 与既有 Evidence 确认 `/data`、`/meili_data` 与两个 project named volumes 对应；**Windows 物理 Docker 虚拟磁盘路径仍待本机只读确认**。Owner 决定保留这种分离结构、不创建备份/恢复/迁移，责任与风险写入 R2 Decision。原 `CLOSEOUT_REPORT.md` 历史事实不被新 Gate 覆盖。GitHub 本轮文档修改 ≠ 本机已完成清理或收藏测试。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016`
**GATE_REVISION**：`R2_STORAGE_LAYOUT_NO_MIGRATION`（**唯一可执行**，早期备份 G2B 草案 `SUPERSEDED_UNEXECUTED`）
**OBJECTIVE**：在 Owner 本机一次性完成最小**只读存储布局核验**、**单条公开网页收藏测试**、**本项目确证可弃的临时/诊断文件安全清理**，保持已关闭安装的服务继续正常运行，不再新开 Gate。

**MAX_ENDPOINT_THIS_ROUND**：
1. **Preflight / 最小只读事实核验**：在 Owner 实体 Windows 11 PowerShell，验证 `desktop-linux` Docker context/Compose 配置、SHA256、账户/密钥文件的存在及保护性 ACL *元数据*（不显示任何值/哈希）、3 当前服务和容器身份、2 原 named volumes 项目标签、非目标容器/网络基线、Web 仅 `127.0.0.1:3000`、必要磁盘可用空间。只核对本轮相关边界，不复演 G0–G2A，不做长时监控或固定 RAM 门槛。发现实际身份/卷不符则停写返回。
2. **存储结构只读回答（不得迁移）**：`docker volume inspect karakeep-local_data karakeep-local_meilisearch`、目标容器 `Mounts` 只读元数据，核实 Web `/data` 与 Meili `/meili_data`、项目配置真实本机路径、Docker 卷主机位于 Linux/WSL/Docker 受管存储。若可使用 Docker Desktop 现有 UI `Settings→Resources→Advanced→Disk image location` 读取当前磁盘位置且无敏感暴露，可记录是否能获确切 Windows 承载盘/位置；不可读就 `UNVERIFIED`。**不修改任何位置、VHDX、Compose、卷、镜像、挂载方式或创建备份/副本**；输出仅不敏感的结构性事实和必要位置，不能把容器内 Linux mountpoint 当成可用的 Windows 目录。
3. **一条最小功能 Canary**：用户本人已经登录 Karakeep。仅通过已授权的浏览器会话（否则 Owner 自己点击一次，不给 Codex 密码/Cookie/token）添加**最多一条**无隐私的公开 URL，如 `https://example.com`；验证收藏保存、网页抓取任务、搜索命中、预览/截图（只在当前产品支持/可用范围内）。如果已有这一条测试记录则先只读识别避免重复。保留这个可弃收藏即可，不触碰其它收藏，不启动 AI、付费服务、批量导入、第三方帐号或任何额外测试对象。最小可用抓取应有正面证据，不能仅依靠容器健康推断。
4. **极小范围可弃临时文件清理**：只处理已知属于 `KarakeepLocal`、无服务/文档/运行引用、非唯一资产、可再生的诊断/下载临时文件；逐项按 `LOCAL_DISPOSABLE`、`DURABLE`、`SECRET`、`SHARED`、`UNKNOWN` 分类。仅明确 `LOCAL_DISPOSABLE` 且本 Gate Owner 授权的精确 allowlist 允许删除，记录路径类别与数量，不记录可能敏感的文件内容；任何 UNKNOWN、未归档独有代码、真实数据库、Compose/.env、镜像层、原两卷、Docker 虚拟磁盘绝不删除或扫描内容。没有安全候选就 `CLEANUP_NOT_REQUIRED`，**不能为了“清理”而做系统/Docker 全局 prune、删除整个项目文件夹或改变卷位置**。
5. **即时复核和收尾**：只做当场 `http://localhost:3000` 的 Web/应用必要健康、Meili/Chrome 连接相关指标及 Web 仅 loopback、非目标资源未变化、卷仍存在、账户/Secret/Compose 原样。**不做 Windows/Docker Desktop 重启、服务主动 down/up 演练、长期观察、备份/恢复、云端上传或迁移**。若局部 Canary 失败，输出精确 `PARTIAL` 子域；若真实共享资源/持久数据风险出现则停止执行并 RETURN。
6. **Evidence 及停止边界**：仅向 `main:karakeep-local/EXECUTION_EVIDENCE.md` append 一份 G2B R2 脱敏报告并读回旧前缀+blob；报告最小本机布局结论、Canary 测试、删除 allowlist/数量或无删除原因、当前 Karakeep 运行地址、非目标前后、Owner 跳过备份/重启/长期观察的事实。停在 Reviewer，**不自行修改 Handoff/决策/结项状态，不进入 G2C 或继续其它工作**。

**MANDATORY_REVIEW_STOP**：本轮所有可安全执行的内容完成或遇阻后停 Reviewer；安装仍 CLOSE，Reviewer 审核 G2B 证据后关闭此次维护任务。
**TARGET_AND_SCOPE**：Owner 原 Windows Karakeep `web/chrome/meilisearch` 已运行实例、受保护目录只读元数据、两 Docker named volumes 只读 `inspect`、一条账户内公开可弃测试收藏、精确证据化本项目临时文件，以及 GitHub append-only Evidence。其它 Docker 项目/共享 Docker 数据存储/系统设置无变更。
**APPLICABLE_CRITICAL_CONSTRAINTS**：**无备份，无恢复，无迁移/Windows bind mount，无重启，无监控，无任何 Secret 输出**；先证明本机 target/卷归属、路径/删除对象所有权/无引用、仅 Web loopback，任何模糊返回；Canary 单条；无强制空闲 RAM 数值；隐私日志先过滤。
**PREFLIGHT**：Owner 本轮明确采用保留原 Docker named volumes 的推荐方案，确认最终 G2B R2 提示词**尚未执行**；Owner 转交指令即为本次有边界授权。以历史 G1J/G2A 当前验收作为基线并做新鲜 readback；真实身份/卷/配置发生 material drift 时停止写。
**REQUIRED_EVIDENCE**：依 Governance 统一字段 `AUTHORIZED_GATE/PREFLIGHT_FACTS/ACTUAL_CHANGES/OBJECTIVE_READBACK/VALIDATION/ANOMALIES/EVIDENCE_ARTIFACTS_AND_PURPOSE/ROLLBACK_EFFECT/RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT/EXECUTOR_RESULT`，额外 `HOST_CONFIG_LOCATION_CLASS`、`VOLUME_TO_CONTAINER_MOUNTS`、`DOCKER_DISK_IMAGE_LOCATION_STATUS=VERIFIED|UNVERIFIED`（仅可安全共享的事实）、`STORAGE_MIGRATION=NOT_AUTHORIZED`、`BACKUP_NOT_REQUESTED`、`CANARY_RESULT`、`CLEANUP_DELETED_COUNT` 和保持运行状态。不要输出用户数据、密钥/密钥 hash、Cookie/Token、内部浏览地址或原始日志。
**ACCEPTANCE_CRITERIA**：路径关系在本机 Docker 实际读回（与官方事实区分），原两卷/Compose/Secret/宿主边界不变；最多一条公开 URL 对收藏→抓取→搜索→预览给出真实结果（不能证实则 PARTIAL）；只有确证可弃文件才删除，无可删候选可 PASS 并记 0；Web 继续 localhost 访问、共享宿主/其它容器无回归；Evidence append main readback；**不把未做的备份/恢复/重启判 PASS**。
**ROLLBACK_STATUS_OR_PLAN**：本轮默认不停止服务、不改运行配置与原卷。若 Canary 添加成功保留最多一条非隐私记录供 Owner 以后自行处理；临时文件只有可验证可再生才允许删除，否则跳过。出现风险则停止进一步写入、不自动 down/up、恢复/重建/迁移、不运行破坏性清理。
**OWNER_ONLY_ACTIONS**：Owner 已确认不做备份、同意维持当前本机存储方式且尚未下发上轮提示词；如果 Codex 没有已授权会话，Owner 自行在网页只添加**一条公开测试收藏**，无需传账号密码/Secret 或真实收藏内容。任何进一步资料删除/迁移/恢复须另行 Owner 授权。
**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是 Owner **本机 Windows PowerShell Codex Executor**，不是云端容器。Owner 转交的本提示词授权只执行 GitHub `entropy-student/project` `main:karakeep-local/REVIEWER_HANDOFF.md` 当前 **G2B R2**。读取 Handoff 的 `CURRENT_GATE`、`SYSTEM_MAP`、`CURRENT_ACCEPTED_STATE`、`CRITICAL_CONSTRAINTS`，以及 `README.md` 的“Windows 实际位置/按需启动”段；无需重读历史 Evidence/G0–G2A，也无需升级、重装。**先验证真实本机 Karakeep 及原 Compose/两卷/loopback/其它 Docker 边界；仅用 docker volume inspect、目标容器 Mounts 和现有 Docker Desktop UI 只读确定配置目录、收藏卷、搜索卷与 Docker 虚拟磁盘位置的关系（实际 Windows VHDX 绝对路径未核实则 UNVERIFIED），不得改为 bind mount、移动数据或修改磁盘位置。**再通过 Owner 已登录的网页仅加/查一条可丢弃公开 URL，验证保存、抓取、搜索与预览；没有安全会话请 Owner 自行操作，不索要登录密码、cookie、token。最后只清理在 `KarakeepLocal` 内确证无引用、可再生的精确项目临时文件，未知即跳过。不备份/恢复、不复制 .env/卷、不重启电脑/Docker Desktop/服务，不长期监控，不动其它 Docker 项目或系统代理，不删 Compose/两卷/镜像/用户数据/VHDX。复核 localhost:3000、服务/非目标前后，向 `EXECUTION_EVIDENCE.md` 追加脱敏 G2B R2 Evidence，提交 main 并 readback，按六项固定格式交 Reviewer 并停止。**旧含备份 G2B 草案及其 R1 提示词都没有下发，不再使用。**
**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
原安装已 CLOSE（保留服务），G2B R2 尚未执行；使用 Docker named volumes（绝不改为单 Windows bind folder），不迁移、不导出、不备份、不恢复、不重启、不做长期监控；数据库/真实账户/原 .env/Secret/两个卷/3 官方镜像均保留；仅一个可弃公开 Canary 与明确独有、无引用、可再生的临时文件清理；其它 Docker 项目及 Docker 共享 VHDX/daemon/代理不变。Github 不得保存真实资料与 Secret。

## DEFAULT_EXECUTION_CHANNEL
Owner 原 Windows PowerShell Codex 一次性 G2B R2。平时只用网页或已记录 PowerShell 手动启动；无 Codex 自动/后台任务。

## CURRENT_ROLLBACK_STATUS
历史 G1I 只证明 Compose 项目级 `down`（无 `-v`）可保留卷，**没有验证真正异机数据恢复**。Owner 明确不做备份，当前 `BACKUP_NOT_REQUESTED/RESTORE_UNVERIFIED`；本轮绝不以整理目录、恢复演练或清理之名触碰 Docker 原卷/.env/虚拟磁盘。G2B 本身无可安全回滚的生产资料修改权，只有受限公开 Canary 与可再生临时文件精确删除许可。

## UNRESOLVED
实际 Windows Docker Desktop `Disk image location`、底层 VHDX 文件路径，以及容器内更细数据库文件名 `UNVERIFIED`（下一轮仅需最小只读元数据、不必扫描真实库内容）；真实网页收藏抓取/搜索/预览尚未验收；Owner 已找到语言选项但是否最终应用简体中文不明。备份与重启/长时观察已被 Owner **主动排除**，标 `BACKUP_NOT_REQUESTED/DEFERRED_BY_OWNER` 而非技术 PASS。下一位 Reviewer 禁止重复扩大任务。

## NEXT_STEP
**唯一下一步**：Owner 将定稿 G2B R2 话术交**本机** Codex。Executor 完成三件事（只读存储确认、1 条公开 Canary、确证临时文件清理）并 append Evidence main → Reviewer 独立判 `PASS` 或准确 `RETURN/PARTIAL` → 维护任务结束，保持原安装结项/服务继续运行。无后续自动 Gate。项目全部**文档**统一 `https://github.com/entropy-student/project/tree/main/karakeep-local`。

## OWNER_ACTION_REQUIRED
只发送 G2B R2 最终 Codex 指令；除非 Codex 无权安全使用已登录 UI、才需 Owner 亲自在 Karakeep 添加一条无敏感公开网址。无备份目的地/密码/密钥/系统手动修复要求。

## EVIDENCE_POINTERS
- 历史实际执行 **最后一轮 G1J**：`main:karakeep-local/EXECUTION_EVIDENCE.md` blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4`，commit `b801c2b629b303f730d05329c958cffca61686b3`；本轮没有新增 G2B Evidence。
- 正式安装结项：`CLOSEOUT_REPORT.md`；包含 Owner 最新无备份记录；`DECISION_LOG.md` 最后 `D-20261016-G2B-R2`；统一 `README.md`；均在同一 GitHub 目录。
- 官方 Compose 关键挂载：`karakeep-app/karakeep` `main:docker/docker-compose.yml` blob `865bb147cef972926d5dc32e50645876fd110555`，Web `data:/data` / Meili `meilisearch:/meili_data`。
- Governance：`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7 blob `3917c88a7f36df7a53758b3879a92703d659ef9d`。Reviewer 本轮读取 universal 0–10、11 trigger、11A/11B/11C/11D/11F、12–13；未修改 Governance。
