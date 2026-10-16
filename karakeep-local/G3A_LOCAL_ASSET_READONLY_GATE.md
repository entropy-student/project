# Karakeep Local · G3A 本机资产只读盘点 Gate

> GATE_ID=`KARAKEEP-WIN-G3A-LOCAL-ASSET-INVENTORY-READONLY-20261016`
> STATUS=`AUTHORIZED_READY_FOR_OWNER_LOCAL_EXECUTOR`
> OWNER_AUTHORIZATION=2026-10-16 用户明确确认“没问题，开始吧”，授权 `LOCAL_ASSET_ARCHIVE_PLAN.md` 阶段 A **只读盘点**，未批准任何文件移动、删除、备份、恢复或迁移。
> PROJECT_INSTALLATION_STATUS=`CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`（原安装已结项）
> PRIOR_G2B_STATUS=`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`（不重试）
> GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> OWNER_TARGET=Owner Windows 11 / PowerShell，本地 Docker Desktop；云端 Reviewer **无该电脑实际文件系统访问**。

## GATE_ID
`KARAKEEP-WIN-G3A-LOCAL-ASSET-INVENTORY-READONLY-20261016`

## OBJECTIVE
一次性**只读**摸清 Karakeep 的 Windows 运行配置位置、Docker named volumes 与镜像/容器存放关系、疑似旧 `sass` / `saas` 开发工作区是否存在及其归属和引用、有没有独有未提交资料。产出不含秘密的本地资产清单及防误删建议，今后可从 GitHub 同一个 `karakeep-local/` 文档目录找到所有信息。**不删除、不移动、不归档实际文件、不复制用户数据**。

## MAX_ENDPOINT_THIS_ROUND
1. **明确真实本机身份（只读）**：在 Owner 原生 Windows PowerShell 读取操作系统/当前 Shell、Docker context 与仅目标 `karakeep-local` 三容器/两命名卷的身份、网络发布、Compose 文件存在性及 Docker inspect 元数据。不变更 Desktop/engine，**不得启动、停止、重启、pull、recreate 容器或访问浏览器**；Docker Engine 若关闭，只写 `UNVERIFIED` 而不是自行打开/启动。把 G2B 报告中的位置当待验证基线，不重复 G0–G1J 安装诊断。
2. **安全核对受保护配置**：定位 `$env:USERPROFILE\KarakeepLocal`，只记录文件**名称/是否存在/类型/是否被 Compose 引用/不敏感尺寸级别**；允许记录 `.env` 仅“存在/受保护”的布尔元数据，不读其内容、哈希或拷贝；不打印 Compose `config` 解析后环境值，不运行可能展开 Secret 的命令。不改 ACL、所有者或源文件。
3. **Docker 数据与 Windows 磁盘关系**：只读检查 `karakeep-local_data`→Web `/data`、`karakeep-local_meilisearch`→Meili `/meili_data`，及 `docker volume inspect` 的 Linux mountpoint、容器 mounts/labels。现已由 G2B Executor `OWNER_REPORTED`：Linux mountpoints `/var/lib/docker/volumes/karakeep-local_data/_data` 和 `/var/lib/docker/volumes/karakeep-local_meilisearch/_data`，Docker Desktop WSL2 Disk image location 目录 `%LOCALAPPDATA%\Docker\wsl`。这些仅为先前报告，要区分新鲜读回与旧事实；具体 VHDX 路径若无法通过**只读现有界面/文件名元数据**可信判明则 `UNVERIFIED`。不打开或装载 VHDX、读取卷文件、不因文件名搜索广扫 AppData，不移动 Docker 数据。
4. **有界寻找本机旧工作区**：`sass` 或 `saas` 的实际完整路径尚 `UNKNOWN`，可能指**不同产品的通用 SaaS 工作区**，不能因名称相似认定属于 Karakeep。首先在 `%USERPROFILE%` 的**直接子目录**以及常见 `Desktop`/`Documents`/`Downloads` 与已明确的开发根目录**有限深度（最多 2 层）**按目录名/已知 Git 项目名寻找 `sass`、`saas`、`Karakeep` 或明显项目名候选；Windows C 盘根目录仅允许最上层目录名的元数据查询，不做 `C:\` 全盘递归扫描、不浏览他人目录、不递归深入无关项目、`AppData`、`.git`、`node_modules`、浏览器缓存、Docker WSL2、隐藏 Secret 路径。对找到的**明确候选目录**记录相对/环境变量缩写路径、是否含运行配置或 Git repo、顶层子目录类型、合理的有界大小估算与引用证据；估算需要深扫敏感/巨型目录时记录 `SIZE_UNVERIFIED` 而不是强行遍历。
5. **Git 和引用关系（只读）**：如候选是 git repo，只读取 repo root、当前 branch、`git status` 非敏感分类数量（已修改/未跟踪/未推送的存在性；不能输出敏感文件名、远端 URL 中 token 等）、当前 `karakeep-local` Docker inspect labels/mounts 是否直接引用候选；不得运行 pull/fetch/checkout/reset/clean/commit、同步文件或读取工作区源码正文。对其它项目的可能引用仅做**有依据**的最小元数据核对；找不到依据的写 `UNKNOWN` 而不是断言不使用。无法确认目录内容或引用时，只提出让 Owner 提供一个完整路径的最小问题，不在此 Gate 中继续扩大搜索。
6. **创建脱敏清单（仅 GitHub 文档写入）**：向 `entropy-student/project` main `karakeep-local/LOCAL_ASSET_INVENTORY.md` 创建/更新**本轮实际获得的**盘点结果，字段 `LOCATION_REDACTED_OR_ENV_VAR | TYPE | OWNER/PROJECT | RUNTIME_REFERENCE | GIT_UNPUSHED_OR_UNTRACKED | SIZE_CLASS_IF_SAFE | CLASSIFICATION | EVIDENCE_LEVEL | SAFE_NEXT_ACTION`。分类至少 `PROTECTED_ACTIVE / DOCUMENTED_REMOTE / UNIQUE_UNPUSHED / DISPOSABLE_CANDIDATE_UNVERIFIED / UNKNOWN_OR_SHARED`。**任何内容都只标建议**，不得把 `DISPOSABLE_CANDIDATE_UNVERIFIED` 写成已获删权；`sass/saas` 找不到就写 `NOT_FOUND_IN_BOUNDED_SEARCH`，明确搜查界限，而非断言不存在。
7. **Evidence 与停止**：向 main `karakeep-local/EXECUTION_EVIDENCE.md` **追加** G3A 独立的非秘密证据记录（不可覆盖 G1J 的历史）；以最少量“盘点边界+命令类别/元数据结论+不读取 Secret 的措施+资源/目录未更改的依据+不确定项”满足 Governance 必需字段。GitHub 提交+main readback 后报告新 Commit SHA，**立即停止交 Reviewer**。如本机无法证明执行身份或 GitHub 持久化失败，精确 RETURN，不能凭假设标 PASS。

## MANDATORY_REVIEW_STOP
本 Gate 至多做到**本机只读检查 + GitHub 两份脱敏项目文档**（`LOCAL_ASSET_INVENTORY.md` 与 append-only `EXECUTION_EVIDENCE.md`）。不得自动执行阶段 B/C 的本机归档、重命名、移动、删除，也不得进入新的浏览器/功能测试或复活 G2B。Evaluator/Reviewer 只在读取提交的 Evidence 后判 PASS/RETURN。

## TARGET_AND_SCOPE
Owner 实体 Windows 11、本机 PowerShell、本机 `%USERPROFILE%\KarakeepLocal` 的文件**元数据**、仅目标 Docker 三容器/两卷的 inspect 元数据、限量候选普通项目工作区的目录/Git 元数据；GitHub `entropy-student/project` main 下 `karakeep-local/LOCAL_ASSET_INVENTORY.md` 与 `EXECUTION_EVIDENCE.md` 的项目级脱敏写入。没有其它 Windows/WSL/Docker/浏览器/共享项目写权。

## APPLICABLE_CRITICAL_CONSTRAINTS
**禁止一切本机写入**（包括生成脚本/临时报告文件、文件/目录创建、移动、删除、压缩或归档）；禁止读取/输出秘密或任何用户收藏/数据库内容；不能使用 Computer Use/浏览器去绕过前轮 URL 安全停止；禁止 Docker `down` / `up` / `prune` / `rm` / `volume rm` / pull / upgrade、Windows/服务重启、Docker 配置/镜像/卷/VHDX 修改；不改变代理、防火墙、其它项目。**所有候选目录默认保留**，没有已授权本地删除操作。

## PREFLIGHT
- 仅接受 Owner 当前授权的**只读阶段 A**。此前 G2B R2 RETURN 不是本轮功能复测权限，先前安装已 Close。
- 验证本机执行目标与 PowerShell、GitHub 正确 repo/branch/path，可用本地 read-only Git/Docker 命令而不影响共享资源。
- 必须保证所有扫描有界，不含文件正文/密钥；命令可能含 Secret/递归不可控时跳过并标状态。无管理员权限则仅按现有权限观察，**不得提权/修 ACL**。
- 如机器身份无法确认，返回 `RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE`；如候选目录疑似共享/唯一资产，`UNKNOWN_OR_SHARED`。

## REQUIRED_EVIDENCE
统一字段 `AUTHORIZED_GATE / PREFLIGHT_FACTS / ACTUAL_CHANGES / OBJECTIVE_READBACK / VALIDATION / ANOMALIES / EVIDENCE_ARTIFACTS_AND_PURPOSE / ROLLBACK_EFFECT / RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT / EXECUTOR_RESULT`。补充清单：`SCAN_ROOTS_AND_DEPTH_LIMIT / EXCLUSIONS / CONFIG_AND_VOLUMES_REFERENCE / CANDIDATE_COUNT / SASS_OR_SAAS_STATUS / GIT_UNPUSHED_STATUS / SHARED_REFERENCE_STATUS / DELETION_COUNT=0 / MOVE_COUNT=0 / LOCAL_FILES_CREATED=0 / BACKUP=NOT_REQUESTED / HTTP_OR_BROWSER_ACTION=NONE / UNVERIFIED`。文件数、路径、统计不得泄露私人姓名、账户/Secret 或未脱敏私有文件名。可证明的本机执行事实用 `DIRECT_READBACK`；从旧 G2B 来的只标 `OWNER_REPORTED`。

## ACCEPTANCE_CRITERIA
本机 Docker/运行配置等真实资产位置与不可删边界有可审查来源；有界调查 `sass`/`saas` 并说明查找的范围、结果与 Git/运行引用不确定性；清单覆盖已知的配置、账户/收藏、搜索索引、Docker 共享底层、GitHub 管理文档、任何候选工作区；**未造成任何本机文件/Docker/配置更改**；GitHub 只上传脱敏结果，append Evidence 并读回验证。若 `sass` 查不到，明确记录 `UNKNOWN` 与具体需要 Owner 提供的目录，而不因查不到阻断其它已证资产盘点。Reviewer 独立审核，Executor 只可报 `PASS_CANDIDATE`。

## ROLLBACK_STATUS_OR_PLAN
**本机仅只读，无需回滚**；GitHub 文档意外错误只对本轮两份项目文档作有界纠正，不覆写历史 Evidence；错误/异常立即停止。出现实际非目标改变或系统写入应视作违反 Gate，停止并给出证据，不擅自修复。当前尚无离机备份，风险不由本 Gate 消除。

## OWNER_ONLY_ACTIONS
Owner 已明确同意开始阶段 A 只读检查，**没有批准删除/移动/备份/迁移**。Owner 不用交密码、Cookie、Secret；如果有界发现无法定位 `sass/saas`，Executor 只向 Owner 要求一个目录**完整地址**供 Reviewer 下一轮处理，不拓宽搜索。

## REVIEWER_TO_EXECUTOR_RELAY
> 你是**Owner 本机 Windows PowerShell Codex Executor**。请从 `entropy-student/project` 最新 main 读取 `karakeep-local/G3A_LOCAL_ASSET_READONLY_GATE.md`（全部内容）和 `karakeep-local/REVIEWER_HANDOFF.md` 的 `SYSTEM_MAP`/`CURRENT_ACCEPTED_STATE`/`CRITICAL_CONSTRAINTS`，以及 `LOCAL_ASSET_ARCHIVE_PLAN.md` 中阶段 A 的范围。当前仅授权 `KARAKEEP-WIN-G3A-LOCAL-ASSET-INVENTORY-READONLY-20261016`：**只读盘点** `KarakeepLocal` 的配置文件元数据、目标 Docker 容器/卷 Mounts、Docker Desktop 磁盘目录，以及在用户已知 Desktop/Documents/Downloads、用户主目录第一层、已知开发根目录两层范围内找疑似 `sass`/`saas`/Karakeep 旧工作区，分类其 Git 未提交/未推送存在性和是否为运行引用。**不要读取文件内容/Secret/用户收藏，不扫描整个 C 盘/整个 AppData/其它项目，不访问浏览器，不调用 Computer Use，不启动或重启任何服务。** 不移动、删除、压缩、备份、迁移或修改任何本机文件/Docker 数据，找不到 `sass` 只记 `UNKNOWN` 和扫查边界。将脱敏事实写到 GitHub main 的 `karakeep-local/LOCAL_ASSET_INVENTORY.md`，向 `EXECUTION_EVIDENCE.md` append 本轮只读证明，提交并读回 main，报告 Commit SHA 与可归档/需保留/未知的分类及下一步建议。**停在 Reviewer，不做真正归档或清理，不重试旧 G2B Canary。**

## EXECUTOR_TO_REVIEWER_RELAY
按六项：`结果（PASS_CANDIDATE / RETURN_*)`、`改动`、`验证`、`问题`、`回滚`、`请 Reviewer 检查`，附 `Owner 转交` 如确实必需。详情入 `EXECUTION_EVIDENCE.md` 而非长篇聊天或未经审查的日志。
