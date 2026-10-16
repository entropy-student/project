# Karakeep Local · G3B SaSS 工作区精准只读盘点 Gate

> GATE_ID=`KARAKEEP-WIN-G3B-SASS-WORKTREE-READONLY-20261016`
> STATUS=`READY_FOR_OWNER_RELAY_NOT_EXECUTED`
> OWNER_REQUEST=在 G3A 未完成后请求 Reviewer 审核并决定如何完成剩余只读盘点。Owner 曾批准阶段 A 的只读资产盘点，**不授权任何本机写入/删除/移动**；新的 Executor 尝试必须由 Owner 主动下发本 Gate 指令。
> TARGET_PATH=`%USERPROFILE%\Documents\ChatGPT\SaSS`（本机 Executor 将由 `%USERPROFILE%` 解析真实用户目录；不要向 GitHub 披露原生用户名）
> PREVIOUS_G3A=`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EXECUTOR_EVIDENCE_MISSING`
> HISTORIC_G2B=`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`
> INSTALLATION=`CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`
> GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7。

## GATE_ID
`KARAKEEP-WIN-G3B-SASS-WORKTREE-READONLY-20261016`

## OBJECTIVE
只通过**原 Windows 本机 PowerShell**，只读判明已经明确位置的 `SaSS` 工作区是哪个项目、是否在被 Karakeep/其它项目运行引用、是否含唯一且未推送/未提交的资料、是否有可归档的候选。复用已报告的 Karakeep 配置/两卷/WSL2 存储关系，不因“收尾”再次重复检查 Docker 全部资源。输出一张**保留/待归档/不确定**的项目资产清单及可复核证据；**绝不执行归档、移动或删除**。

## MAX_ENDPOINT_THIS_ROUND
1. **Host identity 和路径（最小只读）**：确认执行确为 Owner 原生 Windows PowerShell，不是沙箱/远端/WSL；用 `Join-Path $env:USERPROFILE 'Documents\ChatGPT\SaSS'` 得到目标路径，判定该准确路径是否存在、类型/符号链接或 junction/reparse point、目录父级身份及边界。路径不符、越界或是未知重定向则 `RETURN_TARGET_OR_PATH_UNVERIFIED`，不追随到陌生盘或目录。原 `%USERPROFILE%\KarakeepLocal` 仅作为**独立保护目录**核对路径存在性，不再扫描内容。禁止运行任何浏览器/UI/Desktop Control 工具。
2. **SaSS 目录分布（有界）**：最多对目标根及 **1–2 层**目录名进行元数据列表，按类别计数（受保护/敏感文件只记录存在与否，不显示其名称/内容），记录项目名线索：如 .git **是否存在**、package/README/compose 等公共标识文件**是否存在**，是否明显同仓库多个子项目，粗略数量与可安全评估的大小上限。不要递归大 `node_modules`、`.git`、`.env*`、browser profiles、`AppData`、Docker 虚拟磁盘、数据库/用户内容，目录大小如需深扫则 `SIZE_UNVERIFIED`。**不读取文件正文**，不运行 `npm`/`pnpm` 安装/构建/清缓存。
3. **Git 元数据（只读）**：若为仓库，核对 `git rev-parse --show-toplevel`、`branch --show-current`、已存在的 tracked/untracked/modified/pending push **数量或布尔量**；检验 SaSS 是否在更大共享仓库内而非单独仓库。只允许本机已安装 `git` 的无网络只读命令；设置 `GIT_OPTIONAL_LOCKS=0`，临时通过命令行参数关闭 fsmonitor/untrackedCache 等可能写索引的功能；禁止 `git fetch/pull/checkout/reset/clean/add/commit/push`，不得更改仓库配置或运行可能触发外部脚本的 Git 钩子。无 upstream 时 `UNPUSHED_STATUS=UNVERIFIED`，不能通过本地 clean 宣称远端已备份。状态中可能含敏感文件名/URL 只能在进程内聚合计数，不能原样输出或提交；remote identity 只输出**安全脱敏的仓库归属**或 `UNKNOWN`，禁止显示 token/query/userinfo。
4. **项目归属和引用关系（定点）**：基于 SaSS 的 Git root、**安全的文件名/目录结构**、旧 `main:karakeep-local/REVIEWER_HANDOFF.md` 中记录的 `KarakeepLocal` Compose 主机配置与 named volume（不是 SaSS 下挂载）判断是否有直接 Karakeep 运行依赖。可做一次针对**三 Karakeep 容器** mounts/labels 的只读 docker inspect，用来证明其是否有 SaSS bind mount；若 Docker 不可用则 `RUNTIME_REFERENCE_UNVERIFIED`，禁止启动 Engine。**不能因 Docker 没挂载就推断 SaSS 不被其它开发工具/项目引用**；其他项目或进程关联没有安全充分证据时保持 `UNKNOWN`。不得扫描其它项目文件正文或运行进程命令行（可能含 Secret）。
5. **唯一输出到 GitHub main**：创建 `karakeep-local/LOCAL_ASSET_INVENTORY.md`（不存在才创建，若存在先审查来源避免覆盖）记录先前 `OWNER_REPORTED` 的 Karakeep config/两个卷/WSL2 目录和本轮 `SaSS` 检查，字段：`PATH_REDACTED|ASSET_TYPE|OWNERSHIP|KARAKEEP_RUNTIME_REFERENCE|OTHER_REFERENCE|GIT_DIRTY_OR_UNTRACKED|PUSH_STATUS|DATA_UNIQUENESS|CLASSIFICATION|EVIDENCE_LEVEL|NEXT_SAFE_ACTION`。全部候选只能标 `PROTECTED_ACTIVE / DOCUMENTED_REMOTE / UNIQUE_UNPUSHED / ARCHIVE_CANDIDATE_NOT_AUTHORIZED / UNKNOWN_OR_SHARED`，**没有 `SAFE_TO_DELETE` 结论**，没有私人内容。可选提到其它目录尚未盘点，不能宣布整台电脑搜索完成。
6. **Evidence 写入 + 停止**：仅向 `karakeep-local/EXECUTION_EVIDENCE.md` **追加**脱敏的 `G3B` 真实执行记录，不补造 G3A 中断轮的 Executor Evidence。完成 GitHub main 提交/readback，保留此前全部 append-only 内容，返回 Commit SHA；进入 Reviewer STOP。不修改 `REVIEWER_HANDOFF.md`（由 Reviewer 裁决）；不继续任何清理/迁移/备份或浏览器任务。

## MANDATORY_REVIEW_STOP
G3B 终点仅 **SaSS 精确路径的有界本机只读扫描 + GitHub 两份脱敏文档**。无论成功/受阻都停 Reviewer，**没有删除/移动的后续隐含授权**。

## TARGET_AND_SCOPE
仅 Owner 原 Windows PowerShell、`%USERPROFILE%\Documents\ChatGPT\SaSS` 根及深度 1–2 元数据、必要的只读 git/docker inspect、受保护 `KarakeepLocal` 独立目录存在性；GitHub 仅 `karakeep-local/LOCAL_ASSET_INVENTORY.md` 与 `EXECUTION_EVIDENCE.md`。不检查其他开发项目内部内容，不大范围爬目录。

## APPLICABLE_CRITICAL_CONSTRAINTS
本机 **0 文件/设置写入、0 移动/删除、0 备份/复制**，不读取 .env/账户密码/Token/真实收藏/DB/VHDX 内容；不执行 GUI/Computer Use/Browser 或访问 `localhost:3000`，GitHub 只用可用的 GitHub connector/API，**不得以浏览器替代**。若无法用授权的 GitHub 写渠道保存 Evidence，报告 `RETURN_EVIDENCE_CHANNEL_UNAVAILABLE`，不要为提交强行打开浏览器或把隐私资料写本地临时文件。不得停止/启动/重建 Docker 容器、改代理/权限，绝不复活 G2B。
 
## PREFLIGHT
最新 main Gate/Handoff 只读确认，真实 Owner Windows PowerShell 目标身份与 SaSS 完整路径经过验证，文件权限使用当前用户现有读权，无提权。仅允许纯元数据与短输出；遇链接/重定向、可疑秘密、跨项目结构、无法判明 Git 分支归属立即标 UNKNOWN/RETURN，不扩大权限或扫描。旧 G3A 报告是 `OWNER_REPORTED`，不是此次新鲜的本机读回。

## REQUIRED_EVIDENCE
统一 `AUTHORIZED_GATE/PREFLIGHT_FACTS/ACTUAL_CHANGES/OBJECTIVE_READBACK/VALIDATION/ANOMALIES/EVIDENCE_ARTIFACTS_AND_PURPOSE/ROLLBACK_EFFECT/RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT/EXECUTOR_RESULT`。补充 `EXACT_TARGET_IDENTITY / SCAN_DEPTH / EXCLUSIONS / SASS_OWNERSHIP / GIT_ROOT_AND_DIRTY_COUNTS / UNPUSHED_OR_UPSTREAM_STATUS / CONTAINER_DIRECT_MOUNT_REFERENCE / OTHER_PROJECT_REFERENCE_LIMIT / NO_LOCAL_WRITES / NO_BROWSER_OR_COMPUTER_USE / NO_CLEANUP / HISTORICAL_G3A_REPORTED_ONLY / GITHUB_INVENTORY_AND_EVIDENCE_COMMIT_SHA`。敏感文件名及仓库凭据等不得出现在 Evidence。

## ACCEPTANCE_CRITERIA
对确切 SaSS 路径的存在、目录/Git 归属、未提交/未跟踪/未推送和被 Karakeep **直接**运行引用情况有可审核的只读证据；无法确认项目/其它引用的明确 `UNKNOWN`；两份脱敏 GitHub 文档安全追加并在 main 读回；本机运行数据未被修改。**成功盘点并不等于获得 SaSS 删除/移动许可。**

## ROLLBACK_STATUS_OR_PLAN
正常只读操作无需本机回滚。出现任何意外写入/扫描越界则立即停止不擅自修复。无灾备，原 `KarakeepLocal`、Docker volumes/镜像/共享存储全部原地保留。

## OWNER_ONLY_ACTIONS
Owner 既有阶段 A 只读授权仅覆盖调查，新的本机执行要由 Owner 主动**转发本 Gate**；不得以原 G3A 的已中止动作视作继续授权。未来涉及 SaSS 的精确迁移、压缩、归档或删除另需 Owner 按已确认的内容与风险明确批准。

## REVIEWER_TO_EXECUTOR_RELAY
> 本轮只接手 **`KARAKEEP-WIN-G3B-SASS-WORKTREE-READONLY-20261016`**，先读取最新 main `karakeep-local/G3B_SASS_WORKTREE_READONLY_GATE.md` 和 `REVIEWER_HANDOFF.md` 的 `SYSTEM_MAP/CURRENT_ACCEPTED_STATE/CRITICAL_CONSTRAINTS`。目标只有 Owner **原 Windows PowerShell** 中 `Join-Path $env:USERPROFILE 'Documents\ChatGPT\SaSS'`（绝对路径见 Owner G3A 中断报告）；**直奔该目录，不要再大范围寻找、不重查 Karakeep 安装/两卷**。限深度两层只读目录/Git 元数据，确认这是哪个仓库、是否未提交/未推送/未跟踪、能否证明不被 Karakeep 容器直接挂载或其它运行方引用；不够证据明确 UNKNOWN。**完全禁止 Computer Use、浏览器、Docker Desktop 图形界面**；只允许原生 PowerShell 和 GitHub connector/API。不得写入/删移任何本机文件、读取 Secret/文件内容、运行 Git fetch/pull/npm/install 或改 Docker 状态。不推断“可删”。将脱敏清单写 `main:karakeep-local/LOCAL_ASSET_INVENTORY.md` 并 append `EXECUTION_EVIDENCE.md` 的 G3B 执行证据，提交 main 并读回；如 GitHub connector 不能用，报告阻碍而不通过浏览器重试。返回结果+SHA，**立刻停 Reviewer**。

## EXECUTOR_TO_REVIEWER_RELAY
`结果 PASS_CANDIDATE 或 RETURN_*`；`改动`；`验证`；`问题`；`回滚`；`请 Reviewer 检查`；`Owner 转交（必要时）`。
