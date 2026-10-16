# Karakeep Local · Reviewer Decision Log

> 2026-10-16 · 项目决策及理由，非技术执行证据；原执行事实在 `EXECUTION_EVIDENCE.md`，唯一当前状态在 `REVIEWER_HANDOFF.md`。

## D-20261016-CLOSE — 关闭本机安装实施，保留已运行服务

- **Decision**：Owner 明确要求正式 Close；Reviewer 将 `karakeep-local` 的**本机安装、首次登录及语言设置入口确认**实施工作结束，状态 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`。不执行服务卸载、数据清理或失去运行能力的“完全退役”。
- **Accepted evidence**：G1J 技术部署 PASS（`EXECUTION_EVIDENCE.md` blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4`）；Owner 在真实 Windows 浏览器显示认证后的 Karakeep 页面，并明确反馈已找到 Interface Language 设置（`OWNER_REPORTED`）；未要求/记录用户密码。
- **Why close**：原安装目标达成，继续开展重复 Docker/Chrome/代理 Gate 不增加必要的安装验证价值。
- **Excluded from PASS**：书签抓取端到端、界面语言实际切换结果、数据与 Secret 离机备份/恢复、Docker Desktop 重启后的持久性、精确 Web 源码 revision，均为 `DEFERRED_NOT_PASS` 或 `UNVERIFIED`。
- **Resources retained**：正在使用的本机 Karakeep 三容器、现有受保护 Compose/.env、原三个官方镜像、两个 project named volumes（可能已包含 Owner 账户），以及仅 loopback 的 `http://localhost:3000` 入口。没有授权 `down`/卷删除/卸载/共享配置修改。
- **Closeout disposition**：归档 GitHub 项目 Handoff / Evidence / `CLOSEOUT_REPORT.md`；本机应用继续运行；真实书签成为不可丢失资料前优先单独授权备份/恢复 Gate。完整风险、保留与重建限制见 `CLOSEOUT_REPORT.md`。

## D-20261016-G2B — 已结项项目的一次性维护收尾

- **Owner decision**：安装实施的 Close 状态不撤销；Owner 要求将本地项目安全清理、数据/Secret 备份与隔离恢复、一个可丢弃网页收藏功能验证尽量合并为一次执行；明确不安排 Windows/Docker Desktop 重启测试与长期观察。
- **Reviewer decision**：另立一次 `KARAKEEP-WIN-G2B-ONE-SHOT-BACKUP-CANARY-CLEANUP-20261016`，只授权项目内的安全复制/隔离验证/单条非敏感 Canary/经证明可弃的项目级临时文件精确清理，执行后停 Reviewer；不反复重跑已完成的安装 Gate。
- **Why combined**：同一 Owner Windows/本地 Karakeep、同一证据与安全边界，可串行完成；独立备份目的地或一致性未验证时只能判 PARTIAL，不允许运行中 SQLite/Meili 不一致复制冒充可靠恢复。
- **Explicit exceptions**：如无真正不同故障域且受控的备份位置，`OFF_DEVICE_RECOVERY` 保留 `UNVERIFIED`，不自行上传到 GitHub/外部服务；不删除原卷、Secret、镜像、共享 Docker 对象，不作故意设备重启或长期监控。
- **Normal re-entry**：已冻结的 Compose 位于 Owner 的 `USERPROFILE\KarakeepLocal`，可在 Docker Desktop Engine 就绪后从该目录 `docker compose -p karakeep-local up -d --pull never`，再访问 `http://localhost:3000`。不需要日常调用 Codex，除非出现真实故障。

## D-20261016-G2B-R1 — Owner 取消备份，所有项目文档集中在一个目录

- **Owner latest decision**：目前没有独立备份位置，明确要求**完全取消此次数据和 Secret 备份、快照、恢复验证、迁移及备份介质寻找**。收藏和账户数据直接留在本机 Docker 命名卷；不做设备/Docker Desktop 重启测试或长期观察。
- **Risk accepted, not solved**：`BACKUP_NOT_REQUESTED / OFF_DEVICE_RECOVERY_UNVERIFIED`。单电脑/磁盘故障时账户、网页收藏与搜索数据可能无法找回；不能把 GitHub 文档、原两个 Docker 卷或本机存储当作已验证备份。
- **Reviewer scope adjustment**：此前 `KARAKEEP-WIN-G2B-ONE-SHOT-BACKUP-CANARY-CLEANUP-20261016` 草案在尚无 G2B 执行证据前被 **SUPERSEDED_UNEXECUTED**；当前仅 `KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016`，包含一条公开测试收藏与确证可弃的本机临时/诊断文件清理，绝不进入持久卷/.env 或批量资料清理。
- **Document home**：`https://github.com/entropy-student/project/tree/main/karakeep-local`；新增该目录的 `README.md` 汇总 Handoff、Closeout、Decision、Evidence 的入口与本机路径说明。GitHub 只存脱敏项目文档，不上传原数据库/密钥或原日志。
- **Closeout remains**：最初安装实施状态 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED` 保持不变，剩余一次性 G2B 是 Owner 单独下达的项目级维护，不撤销历史 Close。

## D-20261016-G2B-R2 — 推荐保留 Docker 命名卷，不做目录合并或迁移

- **Owner request**：确认“新增收藏实际保存在哪里、整个本机项目是否在同一处”，同意采用推荐方式；前一轮 Codex 提示词**尚未下发，G2B 尚未执行**。要求把最终决策和足够的有效项目上下文写入 GitHub main，交下任 Reviewer。
- **Reviewer conclusion**：保持原受保护 `$env:USERPROFILE\KarakeepLocal` 目录仅放 Compose/`.env` 配置；实际应用/收藏/账户在 Docker 命名卷 `karakeep-local_data`（容器 `/data`），搜索数据在 `karakeep-local_meilisearch`（容器 `/meili_data`）。Docker 镜像/容器/命名卷使用 Docker Desktop 管理的 Linux 存储，可与其它项目共享底层虚拟磁盘，**不能声称全部在一个 Windows 普通文件夹**。
- **Physical path evidence limit**：这台电脑上的 Docker Desktop **实际磁盘/VHDX 绝对路径尚未在本轮核验**，不能从典型 `AppData\Local\Docker\...` 示例推断。下轮仅通过 Docker volume/mount metadata 和 Desktop 设置（可用时）进行只读核对，记录可信路径类型；不打开/挂载/修改底层虚拟磁盘。
- **Explicit no-migration decision**：不改 Compose volumes 为 Windows bind mounts，不更改 Docker Desktop `Disk image location`、不复制/转移/合并持久卷，不停止或重建项目来“整理文件”。没有备份时这会增加不可逆丢失风险且无现实收益。
- **G2B gate revision**：保持唯一 Gate ID `KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016`，标识 `R2`；增加**最小只读存储布局核验**（不独立拆一轮），继续仅一条公开无敏感 Canary 和确证可弃文件的严格清理。此前含备份的 Gate 是 `SUPERSEDED_UNEXECUTED`；R1 也**尚未下发/未执行**。
- **Risk accepted**：`BACKUP_NOT_REQUESTED / RESTORE_UNVERIFIED`，不导出 Secret/数据库、不创建恢复资料、不虚构灾难恢复 PASS；Windows/Docker Desktop 重启测试和长期监控仍明确排除。
- **Document destination**：全部项目管理文档在 `https://github.com/entropy-student/project/tree/main/karakeep-local`，同目录 `README.md` 是索引、`REVIEWER_HANDOFF.md` 为唯一有效状态、`EXECUTION_EVIDENCE.md` append-only。实际用户数据和 `.env` 绝不上传 GitHub。

## D-20261016-G2B-R2-STOP — 浏览器目标无法确认，未完成并停在 Reviewer

- **Evidence provenance and disposition**：Owner 将本机 Executor 的 G2B R2 中止报告转交 Reviewer；该报告为 `OWNER_REPORTED`（Executor 所述本机读回，**Reviewer 未独立查看原始控制平面**）。按 Governance 接受“报告结果/未完成状态”进入 Handoff，不将未落库的技术运行报告伪装成 `EXECUTION_EVIDENCE.md` 中已验收的独立证据。
- **Decision**：`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`；本次 G2B R2 **未 PASS**。Computer Use 无法足够确定 Windows 当前浏览器 URL 并要求立即停止，Executor 遵循停止条件，未绕过其它方式重新控制浏览器。这是**本轮工具目标识别阻碍**，不是 Karakeep Web/Chrome 功能失败的证明。
- **Reported storage findings（provisional）**：本机 `%USERPROFILE%\KarakeepLocal` 配置目录存在，Compose 指纹及 `.env`/配置保护性 ACL 通过；Web `karakeep-local_data` → `/data`，Docker Linux Mountpoint `/var/lib/docker/volumes/karakeep-local_data/_data`；Meili `karakeep-local_meilisearch` → `/meili_data`，Linux Mountpoint `/var/lib/docker/volumes/karakeep-local_meilisearch/_data`。Docker Desktop UI WSL2 数据磁盘**目录**为 `%LOCALAPPDATA%\Docker\wsl`。**VHDX 文件名与完整文件路径仍 `UNVERIFIED`**；上述 Linux Mountpoints **不是 Windows 的普通文件夹**。只读现状报告不构成任何迁移/备份能力。
- **Reported runtime**：G2B preflight 时 Web/Chrome/Meili 三个目标容器 running、Web healthy、0 restart/0 OOM、Web host publish 仅 loopback 3000、其它 Docker 项目运行数 0。**本轮没有新鲜 HTTP 页面请求**；旧 G1J 的 HTTP PASS 和 Owner G2A 登录截图仍是独立历史证据。
- **Reported cleanup / Canary**：`KarakeepLocal` 顶层只有 `.env` 和 `docker-compose.yml`，**无经核实可弃临时文件候选**；删除文件 `0`，不是清理失败，也没有删除配置/数据。**收藏新增 `0`，抓取/搜索/预览 `NOT_RUN`**；未读取或修改其它个人收藏。
- **Reported change and stop boundary**：无配置、卷、Secret、Docker 设置或非目标项目变更，未备份/迁移/重启；没有执行最终 localhost HTTP 回归。**Executor 没有追加 G2B Evidence，也没有 G2B Commit SHA**；`main:karakeep-local/EXECUTION_EVIDENCE.md` 最后仍为 G1J blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4`，Reviewer 本轮核对了该现状。
- **Current Owner instruction**：等待下一次 Owner 指令，不自动进入新 Gate，不再尝试浏览器 Canary，不补跑后续清理或更新本机环境。此前安装实施 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED` 保持有效；现有登录账户及两 Docker 命名卷全部保留。`BACKUP_NOT_REQUESTED/RESTORE_UNVERIFIED` 继续适用。
- **If explicitly resumed in future**：Reviewer 先设计一次最小的浏览器目标/身份确认与安全手动 Canary 边界，并让 Executor 完整追加 Evidence/main read-back；**不得擅自把当前 STOP 视为已有重试授权**。已报告的存储和无临时文件结论只需必要新鲜确认，不重复 G0–G1J 已接受的历史安装检查。

## D-20261016-LOCAL-ARCHIVE-PLAN — 防误删资产地图，先盘点而非搬迁/删除

- **Owner request**：Owner 不清楚同一 Karakeep 项目在 Windows 电脑上实际分散放在哪些路径，担心整理文件时误删；只知道 GitHub 保存了部分项目文件，另提本机疑似 `sass` 目录，要求先**规划**整理归档。
- **Reviewer disposition**：新增同目录 `LOCAL_ASSET_ARCHIVE_PLAN.md`，状态 `PLAN_ONLY_NOT_EXECUTED`；**不自动开启新本机 Gate、也没有文件删除权限**。建议分阶段：①真实 Owner Windows 只读盘点配置/Docker 卷与疑似旧工作区；②分类形成位置+引用+归属的永久资产地图；③只有 Owner 新授权且对 exact path 完成危险检查后，才独立处理极少可弃文件。
- **Known protected data**：保留 `%USERPROFILE%\KarakeepLocal` 受保护 Compose/`.env`、两个 Docker named volumes `karakeep-local_data`/`karakeep-local_meilisearch`、Docker Desktop WSL2 数据磁盘、3 容器镜像及其它项目共享资源。GitHub 只是管理文档统一入口，不是收藏数据备份。
- **Unknowns**：`sass`/`saas` 的完整绝对路径、Git 状态/未提交文件、是否被别的项目引用 **UNKNOWN**；不可根据目录名称宣布可删。Docker VHDX 文件级绝对路径未证实，也不需要为整理强行访问或移动。
- **Carry forward limits**：此前 G2B R2 因浏览器目标 URL 识别不明安全 STOP，不作为本地文件盘点的阻碍；此新计划完全不接触 Computer Use/浏览器、不重试 Canary。Owner 曾明确取消备份/恢复/迁移/重启/长期监控，继续沿用；当前本地唯一收藏资料无验证备份，进一步要求谨慎处理删除。
- **Status and next authorization**：历史安装 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED` 不变；G2B R2 `RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED` 不变；未来若 Owner 需要真正开始，先明确批准**只读资产盘点**，由 Reviewer 起新 Gate，再让 Codex 输出脱敏清单并停止；归档/清理另行决定。

## D-20261016-G3A-OWNER-AUTHORIZED — 开始只读 Windows 本机资产盘点

- **Owner authorization**：2026-10-16 Owner 在审阅 `LOCAL_ASSET_ARCHIVE_PLAN.md` 的阶段 A 后确认“我没问题，开始吧”；这是**只读资产盘点许可**，**不是删除/归档/备份/迁移或操作浏览器的许可**。
- **New Gate**：`KARAKEEP-WIN-G3A-LOCAL-ASSET-INVENTORY-READONLY-20261016`；独立执行说明在 `G3A_LOCAL_ASSET_READONLY_GATE.md`，`REVIEWER_HANDOFF.md` 当前 Gate 已更新至 G3A。之前 G2B R2 的 `RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED` 原样有效，不重新尝试浏览器 Canary。
- **Target/scope**：Owner 原生 Windows PowerShell Codex 有界只读查询 `KarakeepLocal` 配置文件名称/引用、`karakeep-local_data` 和 `karakeep-local_meilisearch` 卷与三个容器元数据、Docker Desktop disk location 目录、`sass/saas` 在已知用户开发路径的候选目录元数据及 Git 未跟踪/未推送有无。无关项目不能深入扫描。
- **Deliverables / stop**：仅在 GitHub 项目目录创建脱敏 `LOCAL_ASSET_INVENTORY.md` 和对 `EXECUTION_EVIDENCE.md` 追加 G3A Evidence，提交 main/readback 后停 Reviewer；**Windows/Docker 上零写入、零移动、零删除、零备份**。目前这两份 G3A 结果**尚未产生**，不能判 PASS。
- **Safety classification**：项目活跃配置/密钥、真实用户卷和共享 Docker 磁盘绝不因整理而移动或删除；`sass/saas` 绝对路径/是否为 Karakeep/独有未提交内容仍 `UNKNOWN`，未查证前禁止断言可删。
- **Project status**：原安装 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED` 及保留运行不变；没有离机备份 `BACKUP_NOT_REQUESTED / RESTORE_UNVERIFIED`；G3A 不打开浏览器、不重启服务或电脑、不更改 Compose/Secret。

## D-20261016-G3A-RETURN-BROWSER — G3A 只读部分完成，Computer Use 安全停止

- **Provenance**：Owner 转交本机 Codex 报告，`OWNER_REPORTED`（其中“直接读回”是 Executor 的自述，而非 Reviewer 直接访问本机控制面；无正式 G3A GitHub Evidence）。Reviewer 只接受报告**边界和中止状态**，不伪造 G3A Evidence。
- **Decision**：`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EXECUTOR_EVIDENCE_MISSING`。G3A 未完成，不能 PASS。Codex 在切换至浏览器工具时，Computer Use 不能充分确认 Windows 当前 URL 并强制停止；其后没有继续导航或绕过。实际浏览器快捷键操作是否发生/是否生效没有验证，不能断言为零效果；但没有可证的新增 Karakeep 收藏。
- **Reported valid read-only subresults**：G3A Gate blob `1aa0034641c94525a0ccb3d6acea166ab98ec78c`、执行前 Handoff blob `ce42389127dfebd7be8b8c25809903e5d1e31794`；`%USERPROFILE%\KarakeepLocal` 顶层 `.env`、`docker-compose.yml`，Compose SHA 匹配历史、ACL 保护通过且未读取/计算 Secret 内容或 hash；三服务 running、Web healthy/仅 loopback 3000、非目标运行容器 0；两 named volumes 映射到 Web `/data`、Meili `/meili_data`，Linux mountpoint 为 `/var/lib/docker/volumes/karakeep-local_data/_data` 与 `/var/lib/docker/volumes/karakeep-local_meilisearch/_data`；Docker Desktop WSL2 数据磁盘目录 `%LOCALAPPDATA%\Docker\wsl`，VHDX 完整文件路径 `UNVERIFIED`。
- **No changes reported**：删除 0、移动 0、无本机文件/Compose/Secret/Docker 卷更改；未进入归档。**G3A 的 `LOCAL_ASSET_INVENTORY.md` 未创建，`EXECUTION_EVIDENCE.md` 未 append，未提交 main，无 G3A Commit SHA**。
- **Main missing facts**：Owner 报告此工作区的明确路径是 `%USERPROFILE%\Documents\ChatGPT\SaSS`（原 Windows 绝对路径 `C:\Users\34707\Documents\ChatGPT\SaSS`，文档使用环境变量写法避免传播个人目录信息）。但 `SaSS` 的仓库归属、Git 未提交/未推送/未跟踪状态、是否被其它项目引用、文件性质及归档安全性皆 `UNKNOWN`；**绝不可据路径直接删除**。其它候选目录的有界盘点未完成。
- **Reviewer repair strategy**：停止原 G3A，历史安装 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`、G2B R2 `RETURN` 全部不变。单独新设更窄的 `G3B` 只读发现 Gate，只针对**已明确的 SaSS 路径**核实 Git/运行引用和文件类别，不再重复 Docker/ACL/storage 全链路、不使用 Computer Use/任何浏览器，即使需要 GitHub 访问也仅允许 GitHub connector/API 而非 GUI。新 Gate 仅为后续 Owner **再次下发执行指令**的准备，不赋予删除/移动/备份权限。

## D-20261016-G3B-REVIEW-PASS-SCOPED — SaSS 工作区只读盘点验收；保留未知 Git 仓库

- **Reviewer result**：`G3B=PASS`（仅**已授权的 SaSS 精确路径只读资产盘点和脱敏文档归档**；任何文件夹移动、归档、删除、实际 Karakeep 书签测试、整体 C 盘清理均**不在 PASS 范围**）。Owner 转交完成报告后，Reviewer 已直接读取 GitHub main 两份新文件和两个原始提交，独立判断满足 G3B 的有界盘点验收条件。
- **Evidence inspected**：`LOCAL_ASSET_INVENTORY.md` blob `5189a45a15b527b5183243c95e82ce3515bbbb10`，提交 `720813d9c073ceeb3673c367be0dc9838518efe4`（该提交只创建这份清单）；`EXECUTION_EVIDENCE.md` blob `4712a9d09ce94ed612cc6e83e512934064874efa`，提交 `0f041fbe9c7321a53e1cb32ad1afdd89e24be226`（该提交只更新此 Evidence）；main 新 Evidence 的完整前缀与历史 G1J blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4` **逐字符一致，属于真实 append-only**。Reviewer 只能审查 GitHub 已记录本机 Executor 的 `DIRECT_READBACK` 证据，而**不是本人连接用户 Windows 复查**，此边界始终保留。
- **Confirmed reported observations**：目标 `%USERPROFILE%\Documents\ChatGPT\SaSS` 是一个 Git root，工作树只有 `.git` 目录，普通文件/子目录/tracked paths 均为 0；Git staged/modified/untracked/deleted/renamed 计数均为 0；无 origin/upstream，**不能据干净工作树推断已推送或不存在独有历史**。Karakeep 三容器未直接 bind mount SaSS，Compose workdir 与目标路径不同；不证明其他项目、进程、IDE/工具不引用 SaSS。SaSS 明确 `UNKNOWN_OR_SHARED`，继续保留。
- **Protected assets retained**：`%USERPROFILE%\KarakeepLocal` 的 Compose/.env、两个 named volumes `karakeep-local_data` / `karakeep-local_meilisearch` 分类 `PROTECTED_ACTIVE`；Docker Desktop WSL2 `%LOCALAPPDATA%\Docker\wsl` 后端分类共享/未知并保留。历史 G3A 路径/ACL 读回在清单中按 `OWNER_REPORTED` 标记，本轮未伪称重新验证内容。无本机写入、移动、删除、备份或迁移，原 Karakeep 安装 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED` 维持。
- **Disclosed scope note**：Executor 曾额外查询 `.git` **直接子项的数量**，属于较冻结“不要下探 .git”建议更深入一级的**轻微只读范围偏差**；没有输出/读取条目名称或正文、没有改变本机状态，数量也未参与归档或删除结论。Reviewer 认为这一已披露的只读元数据查询**不实质影响 G3B 证据和接受范围**，记录异常、禁止把它解释成未来可任意遍历 `.git`，**不要求重跑已有效核验**。
- **No deletion clearance**：`SaSS` 项目所有权、Git 历史和远端恢复性、其它项目进程的引用均 `UNVERIFIED/UNKNOWN`；即使工作树看似空，也不代表 `.git` 不存独有对象或可以安全删除。**`ARCHIVE_CANDIDATE=NONE`、`DELETE_ALLOWLIST=EMPTY`**。不建议现在继续发散搜索/重复部署；只保持本地原位并在文档注明“不要误删”，未来如 Owner 单独要求删除，再设明确归属+历史+引用+重建证明的受控 Gate。
- **Remaining task disposition**：独立“项目本机文件在哪、防误删资产地图”的已知范围可结束为 `INVENTORY_COMPLETED_WITH_RETAINED_UNKNOWN`；没有下一轮自动 Executor Gate。历史 G3A `RETURN_BROWSER_TARGET_UNVERIFIED_AND_EXECUTOR_EVIDENCE_MISSING`、G2B R2 `RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED` 保持原结论；用户取消备份 `BACKUP_NOT_REQUESTED/RESTORE_UNVERIFIED` 不变，不能将本轮只读文档作为备份。
