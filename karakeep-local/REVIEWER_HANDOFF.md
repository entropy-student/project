# Karakeep Local · Reviewer Handoff

> 日期：2026-10-16
> 唯一当前治理：`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> 运行：Windows 11 本机；**尚未部署**

## PROJECT_GOAL
以最小改动在 Owner Windows 11 本机安装 Karakeep 官方 Docker Compose 三服务，Web 仅供本机访问，下一轮再由 Owner 完成首次注册/中文界面/收藏验证。不改应用源码、不接 AI API/Codex、不影响其他 Docker 项目。

## PROJECT_STAGE
G0 read-only 已有完整证据，Reviewer 接受其事实；G0 Executor 原始返回 `RETURN_STORAGE_LAYOUT_UNRESOLVED` 保留历史。G1 执行前置检查返回 `RETURN_SECRET_ACCESS_MISMATCH + RETURN_PREFLIGHT_DRIFT`，Reviewer **确认 RETURN 有效**，未发生本机写入。当前 Gate 为改进验证方式的 **G1R 受限重试**，非原 G1 盲目重跑；本机部署状态仍 `NOT_DEPLOYED`。

## SYSTEM_MAP
- HOST：Owner 实体 Windows 11，PowerShell 7.6.5、Docker Desktop Linux Engine 29.7.2、Compose v5.4.0，context `desktop-linux`（G1 实测；新一轮再复核）。
- PROJECT_ID：`karakeep-local`，允许新增且仅新增官方 web/chrome/meilisearch 三服务，独立 Docker Compose project。
- SOURCE：Karakeep 官方 Compose `https://github.com/karakeep-app/karakeep/blob/main/docker/docker-compose.yml`；G0/G1 官方 blob `865bb147cef972926d5dc32e50645876fd110555`，执行时重新验证身份并冻结候选/实际 image digest。
- CONFIG/SECRET_PATH：**废止之前候选** `%LOCALAPPDATA%\KarakeepLocal`，因其父目录有身份未确认的 Full Control ACE；只读评估新的候选 `$env:USERPROFILE\KarakeepLocal`，如其父目录不符合要求可只读评估 `$env:APPDATA\KarakeepLocal`；只允许从二者中挑选一处，必须验证无外部/未知主体的可继承 Full Control、删除子项及权限修改能力，且本身未存在或确认为空且项目独占、无重解析/链接异常。不能假定候选安全。**不得修改既有父目录 ACL**，找不到合格路径即 RETURN。
- PERSISTENCE：官方原版 named volumes，项目专属 `karakeep-local_data`（数据库/上传资料）与 `karakeep-local_meilisearch`（搜索索引）；G1 均确认不存在，G1R 重新检查。持久资料仅此一份；投入真实收藏前必须另做备份/恢复和 Secret 恢复验证。
- NETWORK：仅 localhost `127.0.0.1:3000:3000`，不公开，不开放 Chrome/Meilisearch 的 host ports。
- AUTH/SECRETS：首装两个新随机密钥 NEXTAUTH_SECRET、MEILI_MASTER_KEY；由 Owner 本轮明确授权后在受保护目标本机生成，不能输出、上传 GitHub、泄露日志；不得复用其他项目 Secret。初装 `OPENAI_API_KEY` 未配置。
- OTHER WORKLOADS：G0/G1 期间既有 WordPress CLI/Web（端口 8189）和 MariaDB 三个运行容器；其他 Docker 对象计数 G1 出现非目标变化，来源 UNKNOWN，本项目不得触碰。
- DEFAULT_EXECUTION_CHANNEL：Owner 本机原生 PowerShell Codex。ChatGPT 云端只读 GitHub/Reviewer，不等于对 Owner 本机的执行。

## CURRENT_ACCEPTED_STATE
- `EXECUTION_EVIDENCE.md` 已从 main 直接查验：G0 `ec4f95d`；G1 `c0170cb`。G1 仅做 read-only preflight；本机未创建目录、Secret、Compose、镜像或容器，`LOCAL_MUTATIONS=0`，Reviewer 接受该 RETURN，不授予原 G1 自动重试。
- G1 `DIRECT_READBACK`：Docker Engine 可达，TCP 3000 空闲，宿主可用 RAM 2.11 GiB，C 盘可用 191.59 GiB；Docker Engine 本身实际可用空间仍 `UNKNOWN`。
- G1 `DIRECT_READBACK`：`%LOCALAPPDATA%` 目录具有一个不明身份的非 Owner Full Control ACE（包含 child delete / permission change），不能将新 Secret 放在其下。该未知身份不自动判为恶意，但不视为可信。
- G1 `DIRECT_READBACK`：既有三个运行容器仍正常；Docker 总容器数量从 17 到 20、卷从 10 到 12，其他对象来源 `UNKNOWN`。不得把这些计数增加归因于 Karakeep。
- REVIEWER_DECISION：批准仅针对这两个前置问题的修正 Gate：**更换可验证安全的项目专用目录；利用可信的 Engine 容量探测（必要时创建可撤销的只读临时诊断容器）**。如果前置全部通过，则在本 Gate 同一目标/回滚域内允许首次安装；不得降低资源与 Secret 安全准则。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G1R-ACL-DISK-DEPLOY-20261016`

**OBJECTIVE**：一次性解决 ACL 路径和 Docker Engine 空间读数，在通过后按官方原版安装并验证 localhost:3000；若仍无法通过则只做诊断并 RETURN。

**MAX_ENDPOINT_THIS_ROUND**：
- 首先只读验证目标身份、新候选目录及父链权限、内存、Docker Engine 可用空间、现有其他服务和 3000 端口。
- 允许在 Owner 本轮明确授权后，使用**本机已有镜像**启动一个临时、网络隔离、只读根文件系统、资源受限、无 Secret、无业务挂载的 `docker run --rm --pull=never` 诊断容器，执行 `df` 等只读命令查证 Docker overlay 实际 free bytes；诊断结束必须验证容器/网络没有遗留。不得拉取任何镜像仅为了诊断，不得 `docker exec` 进入既有应用容器；若 probe 无法可信映射到 Engine 数据卷所在存储域，判容量仍 UNKNOWN。
- 只有 **全部** 安全/存储/资源检查 PASS，才允许为单个全新目标目录进行权限受控创建、官方 Compose 下载（仅将 web ports 改 localhost）、密钥生成、拉取本项目镜像、启动官方三服务并验证；否则停止，不实施正式部署。
- 不允许修改非目标项目、系统级 ACL/WSL/Docker daemon、重启 Docker Desktop、清理任何非本项目资源、注册账户、加入真实收藏、配置 AI API 或公网暴露。

**MANDATORY_REVIEW_STOP**：G1R 的真实执行和 Evidence 形成后必须停下等 Reviewer，不得自行继续后续阶段。

**TARGET_AND_SCOPE**：Owner 本机 PowerShell/Docker Desktop；单个经只读验证合格的全新 `$env:USERPROFILE\KarakeepLocal` 或 `$env:APPDATA\KarakeepLocal`；项目 `karakeep-local` 和仅本项目两个新卷。G1 旧本机候选目录不创建、不修改。

**APPLICABLE_CRITICAL_CONSTRAINTS**：
- 当前其他三个运行中的容器、所有既有卷/网络不改不清理；Docker 对象数变化先只读确认不与目标同名；不能据此停止无关项目。
- Secret 路径父链：ACL Owner 应受信任，禁不明主体 Full Control/DELETE_CHILD/WRITE_DAC/WRITE_OWNER 等可继承/有效越权能力；经检查选定的叶子目录由当前用户受限创建，保护继承，验证 SYSTEM/Administrators/Owner 等必要主体可访问，其他非授权主体不得访问；若无法证明则 `RETURN_SECRET_ACCESS_MISMATCH`。不更改任何已有父目录权限、所有权，不为通过验证而赋 Everyone / Users / Authenticated Users 权限。
- 内存：启动前宿主可用 RAM ≥2.0 GiB；正式启动后若出现 OOM、系统不稳定、其他容器退化或稳定空闲时 <0.8 GiB，立即仅停止本项目并 RETURN；不主动停其他项目。磁盘：需要正面证明实际 Docker 镜像/卷所在存储域可用 ≥8 GiB，且宿主后端可用空间充足；不能仅靠 C: 剩余 191 GiB 或 `docker system df` 已用量推断。
- 用官方已核对 Compose，不改变业务源码/服务架构；官方源身份/版本验证后固定本轮候选；本机配置只绑定 127.0.0.1。
- Secret 原文不进入 PowerShell history、命令行参数、stdout/stderr、普通日志、GitHub、回报；产生方式 CSPRNG，新建专属密钥，拒绝覆盖；必须有本次 Owner 明确授权，没有则不写。
- 部署前提出现歧义、ACL 读数或 docker 探测语义不可靠、临时诊断容器无法确切回收、资源不足或重大偏移，精确 RETURN。

**PREFLIGHT**：
1. 新鲜证明目标是真正 Owner Windows 本机原生 PowerShell；Docker Desktop `desktop-linux` Engine；新鲜 3000 监听与项目冲突/卷查询；现有三个运行容器可观察及资源基线；宿主 RAM ≥2.0 GiB。
2. 针对候选 `USERPROFILE\KarakeepLocal`，后备 `APPDATA\KarakeepLocal`，仅在本机检查整条父链权限、所有权、reparse、effective child-delete/写 ACL、目标不存在/空且所有权合规；选一处满足条件的安全路径并冻结；二者都不合格即停止，不得全盘扫描或自行扩大查找范围。
3. 优先只读验证 Docker Engine 磁盘/卷文件系统可用空间；若现有命令不足，则按本 Gate 用 1 个 `--rm`、`--pull=never`、`--network=none`、`--read-only`、限内存/CPU/pids 的临时无业务挂载本地镜像容器做 `df -Pk /` 等只读核验。必须验证结果确实对应 Docker overlay 及卷所在 backend，且实际空闲 ≥8 GiB，并确认宿主 backing volume 仍有余量；否则 RETURN。该临时诊断是项目允许的唯一前置 Docker 可逆写入，失败停止并精确分类遗留容器。
4. 校验官方 Compose 的固定源文件，在任何密钥落盘前确认实际将安装的三服务、两个 project-named volumes、3000 本地绑定；配置解析不输出密钥；核对 ACL 收紧的本机用户身份/权限可行性。
5. 全部前提 PASS 后，在选定单一新目录中以受限权限创建项目文件和密钥，读回权限且拒绝覆盖/既有未知内容；Compose 镜像拉取/启动只对 `karakeep-local` 生效。

**REQUIRED_EVIDENCE**：
- 同一项目 `EXECUTION_EVIDENCE.md` 追加一轮 G1R，记录认证授权、host 验证、ACL 检查是否安全（不输出私人路径与 SID）、Engine free bytes 与核验方式（区分 overlay/volume 同域），临时诊断有无遗留、资源变化、官方 Compose/digest、项目端口绑定及三服务与 localhost Web 的实际健康，原有三容器前后状态。
- 若停止，记录精确原因、是否发生临时诊断或正式部署、剩余本项目对象（不得隐藏残留），以及停止/保留卷的回滚效果。
- 只提交脱敏 Evidence，GitHub main 写回读回验证，不收集 Secret。

**ACCEPTANCE_CRITERIA**：
- preflight 安全路径 + 可信 Engine free ≥8 GiB + host backing free + 宿主启动前 RAM ≥2.0 GiB；
- 仅本项目新建文件、Compose/容器/命名卷；3 服务真实健康，应用能从 `http://127.0.0.1:3000` 返回可用登录页；Chrome/Meili 无 host mapping，非 loopback 负面检查通过；
- 全部必需密钥未泄露，Windows protected leaf ACL 验证，运行配置重启有效性得到可审证据；没有 Owner 注册/保存真实资料；
- 其他三个运行中的容器不受影响，宿主资源低水位约束满足，临时诊断没有遗留（按必要在容器停止后读回）。
- 如未达成，上述条件不能以 G1 历史证据冒充 PASS；报告精确 RETURN。

**ROLLBACK_STATUS_OR_PLAN**：
- 临时诊断：`--rm` 后必须只读确认容器/网络无残留；若启动不成功或 `--rm` 失效，精确识别本次容器并隔离清理该对象，未知归属不得删除。
- 正式初装失败：仅在确认唯一项目身份后 `docker compose -p karakeep-local down`（无 `-v`），保留 .env / 两个命名卷和配置，以便安全调查或后续重试；不清理其他项目、不使用 prune、不自动删 Secret。由于尚无真实收藏，数据恢复未验证，`RECOVERY_UNVERIFIED`，禁止对外宣称已完成备份。

**OWNER_ONLY_ACTIONS**：Owner 本次转交必须明确授权：仅此 Karakeep 本机初装的受限新配置目录及两个随机密钥创建，和一个无 Secret、无业务挂载的受限本地镜像诊断容器；不允许更改现有 ACL/数据、不允许公网暴露。

**REVIEWER_TO_EXECUTOR_RELAY**：
> 作为本机 Codex Executor，仅读 `entropy-student/project` 最新 main 中 `karakeep-local/REVIEWER_HANDOFF.md` 的 CURRENT_GATE、CURRENT_ACCEPTED_STATE、SYSTEM_MAP、CRITICAL_CONSTRAINTS，以及 `karakeep-local/EXECUTION_EVIDENCE.md` 中 G1 的失败证据小节。不重跑 G0/G1。执行 `KARAKEEP-WIN-G1R-ACL-DISK-DEPLOY-20261016`：先只读确认两个候选新路径的父链访问权限和真实 Docker Engine 可用空间；必要时且获得本次 Owner 授权，使用单个资源受限的本地已有镜像、无网络只读临时容器做存储容量诊断，证明没有遗留。仅在 Gate 各项 preflight 证明均合格后，才创建全新受限项目目录/密钥，采用官方 Compose 安装 Karakeep 三服务，并对 localhost 3000、运行资源和其他三个容器做实际验证。无法证实即精确 RETURN，不改旧目录 ACL/其他项目。追加脱敏 Evidence，提交 main 并读回，按 Executor 固定格式交 Reviewer，必须停在本 Gate。

**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
Windows Owner 本机；最小化原版安装；Secret 严格保密；禁止改既有父目录 ACL、Docker/WSL 配置或他项目；只 localhost；不越 Gate；不将临时诊断读数误当成功安装。

## DEFAULT_EXECUTION_CHANNEL
Owner 实体 Windows 11 本机原生 PowerShell / Codex。

## CURRENT_ROLLBACK_STATUS
G0 与 G1：无本机写入；G1R：仅项目专属停止/保留卷恢复计划 `PLAN_ONLY`，真实初装未发生；数据离机备份/恢复仍 `UNVERIFIED`。

## UNRESOLVED
候选路径 ACL 和继承链可信性、Docker backend 实际可用空间、内存是否充足稳定、GHCR pull 是否成功、Karakeep 官方三服务是否健康，均为待实测。

## NEXT_STEP
Owner 转交当前 G1R Gate 到实体 Windows 本机 Codex；Codex 按限制诊断后有条件部署；Reviewer 对 Evidence 读回后判 PASS / RETURN。

## OWNER_ACTION_REQUIRED
Owner 按本 Gate 以转交文字明确本轮受限诊断容器及项目独立密钥和文件创建权限；不需提供任何密钥值。

## EVIDENCE_POINTERS
`karakeep-local/EXECUTION_EVIDENCE.md`，G0 `ec4f95d`、G1 `c0170cb`；本轮记录 G1R 追加。
