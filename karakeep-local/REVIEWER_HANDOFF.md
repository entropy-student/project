# Karakeep Local · Reviewer Handoff

> LAST_REVIEW=2026-10-16
> PROJECT_STATUS=`CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`（原安装 PASS/Close 保持有效）
> LAST_GATE_ID=`KARAKEEP-WIN-G3B-SASS-WORKTREE-READONLY-20261016`
> LAST_GATE_STATUS=`PASS`（限 SaSS 只读资产盘点，含已披露的 .git 浅层数量查询异常；无删除权限）
> HISTORICAL_G3A_STATUS=`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EXECUTOR_EVIDENCE_MISSING`
> HISTORICAL_G2B_STATUS=`RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`
> CURRENT_GATE_ID=`NONE_INVENTORY_REVIEW_COMPLETE`
> CURRENT_GATE_STATUS=`STOP_WAIT_OWNER_FOR_ANY_FURTHER_CHANGE`
> LOCAL_ASSET_STATUS=`INVENTORY_COMPLETED_WITH_RETAINED_UNKNOWN`
> LOCAL_ASSET_INVENTORY=`LOCAL_ASSET_INVENTORY.md`
> ARCHIVE_CANDIDATES=`NONE` / DELETE_ALLOWLIST=`EMPTY`
> CANONICAL_GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7 / blob `3917c88a7f36df7a53758b3879a92703d659ef9d`
> DOCUMENT_HOME=`https://github.com/entropy-student/project/tree/main/karakeep-local`
> `README.md` 为索引，**本 Handoff 为唯一当前状态权威**；`DECISION_LOG.md` 为决策及本轮 Reviewer 对中止报告的整理；`EXECUTION_EVIDENCE.md` 仍只包含历次 Executor 已成功提交的执行证据。

## PROJECT_GOAL
Owner Windows 11 实体电脑上保留正常使用的 Karakeep（原本机安装 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`）。为避免清理电脑时误删该项目的分散资料，完成本机配置、Docker 数据卷和用户指出的 `SaSS` 工作区的**限定范围只读资产清单**，以 GitHub `karakeep-local/` 为唯一项目文档入口。**本轮 Reviewer 已判 G3B PASS（只读盘点），但没有获得任何删除/移动/迁移/备份授权，也没有识别出安全归档候选。** Windows/Docker 真实收藏数据仍只留在 Owner 电脑上，不在 GitHub。旧 G2B 浏览器 Canary 与 G3A 未完成历史保持原样，不因 G3B PASS 被补认为 PASS。

## PROJECT_STAGE
- **G0–G1I 历史**：Owner Windows Docker Desktop 原配置、受保护 Compose/.env、三官方镜像及两个命名卷就绪；历史下载/Chrome Host 探针问题已解决或边界已接受，不重新执行。
- **G1J 技术安装 PASS；原实施正式 CLOSED**：Web 登录页和 Meili health HTTP 200、Web→Chrome CDP 成功、Worker 浏览器连接路径无失败/重试/断连、Web 仅回环 `127.0.0.1:3000`，容器当时无 OOM/restart；技术安装证据已由前 Reviewer 验收。保留运行，不代表卸载授权。
- **G2A PASS_SCOPED（OWNER_REPORTED）**：Owner 成功登录网页并找到 `Interface Language`；是否真正保存中文仍未验证，非现阶段必要动作。
- **G2B R2 RETURN**：此前 Computer Use 无法确认 Windows 浏览器当前 URL，安全停止；未执行单条收藏/抓取/搜索/预览 Canary、未提交 Executor G2B Evidence。该 RETURN 不代表 Karakeep 故障，不重启/重试。
- **G3A RETURN**：从 Owner 转交本机 Executor 报告得知 Compose/ACL/三个容器、两个卷、Docker Desktop WSL2 磁盘目录的只读核查已完成，但 `SaSS` 尚未核查；Computer Use 又因 URL 目标无法确认中止，G3A Executor Evidence 未提交。只将事实当 `OWNER_REPORTED`，保留 RETURN。
- **G3B `PASS`（Reviewer 2026-10-16 审核）**：Owner Windows 原生 PowerShell 对精确 `%USERPROFILE%\Documents\ChatGPT\SaSS` 的只读元数据/Git/目标容器 mounts 检查已经提交脱敏 `LOCAL_ASSET_INVENTORY.md` 与 append-only `EXECUTION_EVIDENCE.md`。Reviewer 直接核实了两次 GitHub 提交、旧 Evidence 完整前缀、文件内容与状态边界，确定本 Gate 的**只读资产盘点 PASS**。未授权实际归档/删除。
- **异常已披露**：G3B 额外只读查询 `.git` 直接子项数量，无名称/正文输出，未改动文件；比最窄预期多进入一层 metadata，但对结论无实质影响。仅作为 Scope Note 接受，未来不能照此扩大其它目录扫描。
- **当前状态**：`INVENTORY_COMPLETED_WITH_RETAINED_UNKNOWN` / `NO_ARCHIVE_CANDIDATES` / `STOP_WAIT_OWNER_FOR_ANY_FURTHER_CHANGE`。没有任何需要自动启动的下一 Gate。

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
**安装实施 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED` / G1J PASS，Karakeep 继续留在本机使用**。本次 G3B 为 `PASS`，仅表示用户明确提出的 `SaSS` 目录被有界盘点且资产清单/Evidence 在 GitHub main 完整持久化；Reviewer 已检查 GitHub，而非亲自连接 Owner Windows 复查，因此本机 `DIRECT_READBACK` 是经审核的 Executor Evidence，不是 Reviewer 亲自的控制面读回。

**已验收资产情况**：
- `%USERPROFILE%\KarakeepLocal`：当前 Karakeep Compose + 受保护 `.env`，`PROTECTED_ACTIVE`，原位保留。
- `karakeep-local_data`：Web `/data` 账户/收藏/抓取等真实持久资料；`karakeep-local_meilisearch`：Meili `/meili_data` 索引；均 `PROTECTED_ACTIVE`，**不可删/移/迁**。
- Docker Desktop WSL2 后端磁盘目录 `%LOCALAPPDATA%\Docker\wsl`，属于共享/未知资源；文件级 VHDX 具体路径 `UNVERIFIED`，禁止动其任何文件。
- `%USERPROFILE%\Documents\ChatGPT\SaSS`：本轮 G3B 读回显示 Git root 就是该目录，普通工作树文件/子目录及 tracked 路径均为 0，唯一顶层条目为 `.git`；staged/modified/untracked/deleted/renamed 均为 0。无 origin/upstream，Git history/objects 是否保存唯一资料 `UNVERIFIED`；没有三个 Karakeep 容器对 SaSS 的直接 bind mount，**其它项目/工具进程的引用仍 `UNKNOWN`**。分类 `UNKNOWN_OR_SHARED`，**不得删除或归档**。
- GitHub `main:karakeep-local/`：单一管理文档目录，`DOCUMENTED_REMOTE`，不含真实收藏、数据库、Secret 或备份恢复文件。
- 其它旧工作区与整个 Windows 硬盘没有获得全面扫描证据；不可据本次发现声称“整台电脑都已整理完毕”。

**已直接审查的证据**：inventory blob `5189a45a15b527b5183243c95e82ce3515bbbb10`，commit `720813d9c073ceeb3673c367be0dc9838518efe4`；Evidence blob `4712a9d09ce94ed612cc6e83e512934064874efa`，commit `0f041fbe9c7321a53e1cb32ad1afdd89e24be226`。Reviewer 已验证原历史 Evidence blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4` 是现有文件的**完整精确前缀**。.git 直接子项数量的多一步只读检查，已记入 Decision 的范围异常，不触发重跑或扩大扫描。

## CURRENT_GATE
**GATE_ID**：`NONE`（已完成 G3B，`PASS`）
**CURRENT_OPERATIONAL_STATUS**：`INVENTORY_COMPLETED_WITH_RETAINED_UNKNOWN`。
**MAX_ENDPOINT_THIS_ROUND**：Reviewer 仅审查 GitHub 两份 G3B 已提交证据及历史依赖，更新 `DECISION_LOG.md`、`REVIEWER_HANDOFF.md`、`README.md` 与归档计划状态；**不触碰 Owner 本机**，不执行新 Git/GitHub worktree 盘点，也不创建文件删除/归档 Gate。
**MANDATORY_REVIEW_STOP**：`STOP_WAIT_OWNER_FOR_ANY_FURTHER_CHANGE`；无待下发 Codex 指令。
**NEXT_SCOPE_BOUNDARY**：若 Owner 将来明确要求移动/归档/删除 `SaSS`，先单独取得 Owner 后果授权，要求证明实际项目归属、Git objects/history 是否独有、无未保存资料、其它引用、确切回滚/重建方案与对应证据；任何一个 UNKNOWN 仍失败闭合。禁止把“空工作树”误用为“无重要数据”。


## CRITICAL_CONSTRAINTS
Owner 没有批准对本机或 Docker 的任何移动、删除、重建、备份/恢复或迁移，且无经验证的异故障域备份 `BACKUP_NOT_REQUESTED/RESTORE_UNVERIFIED`。配置/`.env`、两 named volumes、Docker WSL2、`SaSS` 工作区以及其它未归属资产全部**原地保留**。禁止 `docker system prune`、`down -v`、共享后端清理、浏览器/Computer Use 继续动作、Windows/Docker 重启测试或长期监控。任何真正的归档/清理是新的明确 Owner 许可与独立 Gate，不自动推进。Github 管理文档不可含 Secret 或真实用户收藏数据。

## DEFAULT_EXECUTION_CHANNEL
正常只使用 http://localhost:3000；没有新的本机 Codex 任务。未来若 Owner 单独授权只读/归档或清理工作，再由 Reviewer 发布**新的**有界 Gate，默认本机原生 Windows PowerShell Codex，不依赖此前故障的 Computer Use。

## CURRENT_ROLLBACK_STATUS
G3B 本机无新增文件/运行资源写入，删除、移动、备份或迁移计数均为 0；无需本机回滚。GitHub 仅新增 inventory 和 append-only Evidence，Reviewer 完成必要的文档更新。用户拒绝备份 `BACKUP_NOT_REQUESTED/RESTORE_UNVERIFIED`，不能宣称可恢复。

## UNRESOLVED
`SaSS` 的 Git 历史/对象是否独有、远端保存状态、其它开发项目或进程引用 `UNKNOWN/UNVERIFIED`；Docker WSL2 文件级 VHDX 路径未确认；原 G2B 的网页 Canary、语言设置是否持久化尚未验收。以上是**明确保留的不确定项**，不是自动新开 Gate 的理由。当前资产清单不覆盖全部电脑。

## NEXT_STEP
`NONE_WAIT_OWNER`。G3B 限定只读盘点正式 PASS，`LOCAL_ASSET_INVENTORY.md` 现为可持续使用的防误删地图；Owner 如仅想整理视觉上的文件结构，可保留 SaSS 和 Docker 原位置，不必再运行 Codex。未来若 Owner 明确要求删除/归档 `SaSS`，需要先单独核查独有 Git 历史、其它引用及恢复边界，取得精确路径/后果授权；不能直接把 SaSS 判可删。

## OWNER_ACTION_REQUIRED
`NONE`。无需新的提示词、密码、Secret、备份位置或手动清理操作。**不要删除 SaSS、KarakeepLocal 或 Docker 卷/WSL2 目录。**

## EVIDENCE_POINTERS
- **G3B 已审查的 Executor GitHub 证据**：`main:karakeep-local/LOCAL_ASSET_INVENTORY.md` blob `5189a45a15b527b5183243c95e82ce3515bbbb10`，commit `720813d9c073ceeb3673c367be0dc9838518efe4`；`main:karakeep-local/EXECUTION_EVIDENCE.md` blob `4712a9d09ce94ed612cc6e83e512934064874efa`，commit `0f041fbe9c7321a53e1cb32ad1afdd89e24be226`，旧前缀 G1J blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4` 不变。
- **Reviewer G3B 结论**：`main:karakeep-local/DECISION_LOG.md`，节 `D-20261016-G3B-REVIEW-PASS-SCOPED`，包含 .git 浅层计数的已接受范围异常及 no-delete 决定；`G3B_SASS_WORKTREE_READONLY_GATE.md` 为不可重用的历史执行边界。
- **安装与 G2A 原 Close**：`CLOSEOUT_REPORT.md`；`G1J` 官方完成证据及历史 return 全保留。
- **G3A 中止**：`DECISION_LOG.md` 节 `D-20261016-G3A-RETURN-BROWSER`（`OWNER_REPORTED`），无 G3A Executor GitHub Evidence。
- **G2B 中止**：`DECISION_LOG.md` 节 `D-20261016-G2B-R2-STOP`；没做浏览器 Canary。
- **管理文档主页**：`README.md`；`LOCAL_ASSET_ARCHIVE_PLAN.md` 为已完成“先盘点”的计划存档；Governance `entropy-student/spike.skill:vps-project-governance/VNEXT.md` v0.2.7。
