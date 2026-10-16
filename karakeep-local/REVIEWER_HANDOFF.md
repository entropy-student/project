# Karakeep Local · Reviewer Handoff

> 2026-10-16 · 当前状态：`NOT_DEPLOYED / G1E_READONLY_RECONCILIATION`
> 治理：`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> 角色：本文件由 Reviewer 维护；`EXECUTION_EVIDENCE.md` 保持 append-only。

## PROJECT_GOAL
在 Owner 实体 Windows 11 本机，用官方原版 Docker Compose 最小改动部署 Karakeep（Web、Chrome、Meilisearch），Web 仅 `http://127.0.0.1:3000`。首次账户、中文设置、真实收藏、AI/Codex 接入都不属于当前 Gate。保护其他 Docker 项目、不更改全局代理/网络/系统、不泄露 Secret。

## PROJECT_STAGE
- **当前：G1E 只读状态核对，绝对不允许部署/恢复/重建。** 目前仍 `NOT_DEPLOYED`。
- 历史 G0/G1/G1R/G1N/G1C 的事实和正式 RETURN 保留于 Evidence，不重跑。G1R 曾在 Windows USERPROFILE 下创建受保护 `KarakeepLocal/docker-compose.yml` 和 `.env`（两个独立随机 Secret）；G1C 成功拉取并验证两个官方 GHCR 镜像。
- **G1D Reviewer 审核**：已检查最新 main `karakeep-local/EXECUTION_EVIDENCE.md`，blob `8585ff6de1d4b2912f964a6a4409d417be588f6c`（commit `a65f685bfde15482c83b0b6203f2768f82733f67`）。接受 G1D 的只读结果与 RETURN：原预期位置找不到 Compose/.env、Windows Internet proxy 启用状态与上轮不同、非目标 Docker network ID 集合在本轮读数间变化、Docker Hub Host 路径无法连通而 Desktop proxy 路径未验证；这次没有 Docker /本机文件写入或 pull。
- Reviewer 判断：**配置/Secret 在历史中存在 != 当前仍可恢复或可以重建**；不能未经调查覆盖/再次生成。仅 Docker network ID 变化不自动证明非目标业务受损，但其归属/影响需要确定；Windows proxy 模式差异是读数事实，不归因 Codex。本轮优先缩小文件位置和网络状态故障域。

## SYSTEM_MAP
- HOST：Owner Windows 11，PowerShell 7.6.5，Docker Desktop Linux Engine 29.7.2 / Compose v5.4.0 / `desktop-linux`（G1D）；执行时重新验证身份与当前用户 profile 同源。
- ACCEPTED_TARGET：`$env:USERPROFILE\KarakeepLocal`；G1R/G1C 已验证其下 `docker-compose.yml` SHA-256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`，`.env` 有 `KARAKEEP_VERSION` / `NEXTAUTH_SECRET` / `MEILI_MASTER_KEY` / `NEXTAUTH_URL`。G1D 该目录下目标文件未找到。其实际当前文件/Secret 状态为 **UNKNOWN/MISSING_AT_ACCEPTED_TARGET**；不得凭旧值重建。
- HISTORICAL_ALTERNATES：早期曾讨论 `$env:LOCALAPPDATA\KarakeepLocal` 和 `$env:APPDATA\KarakeepLocal`，但 G1R 实际选择 USERPROFILE。只允许把这两个作为**有限的只读路径排除项**；不能改父/子目录 ACL。G1D 已排除文档/OneDrive Docs/当前工作区的等价候选，不再重复全盘找寻。
- IMAGES：已下载并在 G1D 读回：
  - `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`
  - `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`
  缺失官方 `getmeili/meilisearch:v1.41.0`；G1D 未 pull，Docker Hub Host 直连 registry/auth/layer 443 超时；Desktop Engine proxy 真实拉取路径尚未证明。
- PROJECT_SCOPE：`karakeep-local` Compose 隔离；预期只发布 `127.0.0.1:3000`；两个 named volumes `karakeep-local_data` 和 `karakeep-local_meilisearch`，G1D 均不存在；无 Karakeep 容器、网络/卷、账号及真实收藏。
- NON_TARGET_DOCKER：G1D 为 20 容器（1 created、19 exited、0 running）、12 existing volumes、11 networks；Windows 容器/卷快照前后相同，网络 **数量相同但 ID 快照变化**，原因 UNKNOWN。原 WordPress CLI/Web/MariaDB 停止状态与旧 MariaDB unhealthy 均属非目标，不启动/更改。
- PROXY：G1C 读 Windows Internet proxy 为 enabled，G1D 为 disabled；WinHTTP direct、Engine 配置内部 alias（Windows Host 无法解析，不证明 Docker Desktop 内部 alias 故障）。不更改任何代理或证书。
- RESOURCES：G1D 可用 RAM 2249 MiB、C: 余约 185 GiB；没有固定空闲 RAM 启动门槛，实际 OOM/系统稳定性才作为风险信号；在 G1E 只观察。
- AUTH/RECOVERY：两 Secret 历史只存在于本机 `.env`，从未输出或提交；**当前原始文件找不到且没有已验证的另一处 Secret 恢复副本**。禁止声明已泄露/已丢失/已恢复；禁止自动生成、轮换或恢复。正式安装前必须重新明确 Secret 保管/恢复边界。
- EXECUTION：本机 PowerShell Codex 为已接受默认渠道；云端 Reviewer 没有直接读写 Owner 本地文件能力。

## CURRENT_ACCEPTED_STATE
- G1D 经本机直接读取：Owner profile 匹配 Windows canonical profile，且非 reparse；实际 accepted target 内 Compose 与 `.env` 均未找到，无法核对 ACL/哈希/Secret。当前是否整个目录不存在、叶子 ACL 拒绝/隐藏、误移到别处、磁盘/保护软件影响等均 UNKNOWN，绝不假设删除因果。
- Docker info/version/system df 正常；两 GHCR 镜像 digest 匹配；Meili 不存在；本轮无拉取和启动。
- Windows proxy mode 与 G1C 不同；Host 443 到 Docker Hub 及 auth、CDN timeout；Engine Desktop 内部 proxy 可用性仍 UNKNOWN。
- Docker network IDs 在 G1D 入口与最终观测存在不一致，且末尾连续两次相同。是否临时系统网络更替、监测/对象语义差异、他项目调整或 Docker Desktop 内部维护 UNKNOWN。绝不因差异自动变更非目标项目。
- **REVIEWER_DECISION**：G1D RETURN 正确。停止所有新的本机配置/Secret/Docker/网络修改；本轮设计独立 G1E read-only reconciliation，防止在未分类既有 Secret/网络状态时重建/启动。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G1E-MISSING-CONFIG-NETWORK-READONLY-20261016`

**OBJECTIVE**：以最小只读证据识别已接受配置路径为何找不到文件、现存 Secret 可恢复状态，以及 Docker network ID 变化的类别；只记录当前代理模式，不擅自修复。

**MAX_ENDPOINT_THIS_ROUND**：
1. 仅在 Owner 本机原生 PowerShell / 当前授权用户 session 进行只读核对；验证 OS/user/profile 正确映射、Windows canonical USERPROFILE、path-provider、已接受相对路径大小写/拼接、目标文件和目录的存在/可访问/重解析/隐藏属性与 owner/DACL *元数据*；区分 `PATH_CONTEXT_MISMATCH | ABSENT | ACCESS_DENIED | REPARSE_OR_REDIRECTION | UNKNOWN`，不要将 `Test-Path=False` 直接等同已删除。
2. 仅针对 accepted target `USERPROFILE\KarakeepLocal` 和两个曾被提出的候选 `LOCALAPPDATA\KarakeepLocal`、`APPDATA\KarakeepLocal` 做目录级存在/条目名/ACL 元数据检查，不展开无关文件内容、Documents/OneDrive 不重复扫。若找到同名 Compose/.env，**先验证文件所在目录的安全性和原用户权限**；不得打印或复制内容、Secret 或 hash。Compose 非敏感时可仅核对 SHA-256 是否等于接受值；`.env` 只在已验证保护边界内检查四个**键名与格式**（不输出值/hash），区分 `EXACT_CANDIDATE | UNVERIFIED | COLLISION`。有非已接受路径下的候选不能直接作为新运行目录或启动依据，后续由 Reviewer 决策。
3. 可选最小 Windows 安全/文件系统**元数据**诊断：只在能识别与 `KarakeepLocal` 精确目录相关且无秘密泄露时检查事件记录的存在与时间戳/类别（例如 Defender 隔离记录或文件创建/移动事件若系统本来就有）；无事件即 `UNKNOWN`，不得推断“无删除”。不运行恢复工具、递归全盘搜索、回收站还原、文件挪动/删除，不读取或输出 Secret-bearing 事件原文。
4. 对 Docker 网络仅执行两次间隔适中的**只读**命名空间/ID/driver/scope/labels/created-at/attached endpoint 汇总；必要时仅 `inspect` 本轮实际变化所涉及的 network 元数据，不进入容器，不读 env/log/挂载数据。先区分 Docker 系统默认网络动态 ID、label/项目级命名对象、探针本身观测口径差异；不能从 G1D 只记录的计数重建不存在的旧 ID。若要确认与非目标服务的关系，只读检查这些网络是否承载既有容器 endpoint；不改动网络。
5. 网络与 Windows Internet proxy mode 仅做当前只读采样、与 G1C/G1D 书面事实对照；没有新授权不得触碰系统代理、Desktop Containers proxy、VPN/Clash、daemon/WSL、证书、registry、任何已有镜像/容器/卷/网络。
6. **不允许** `docker pull`、`compose up/down`、任何本机文件创建/写入/复制/移动/删除、Secret 新建或轮换、ACL 修改、Docker network repair/recreate、代理设置变更。唯一允许写入是 GitHub 该项目的脱敏 Evidence append。

**MANDATORY_REVIEW_STOP**：执行 G1E 后不论发现何种结果，追加脱敏 Evidence，commit/read-back 后停 Reviewer；**不能**条件部署、不能私自进下一 Gate。

**TARGET_AND_SCOPE**：Owner 实体 Windows 11 本机。文件仅上述 3 个确知候选目录及路径映射/限定相关事件元数据；Docker 仅 network 对象元数据、目标镜像存在性和项目碰撞做只读核对；非目标容器内部、业务数据/Secrets 一律不读。

**APPLICABLE_CRITICAL_CONSTRAINTS**：
- 此为失踪 Secret/config 的状态核对，不是修复 Gate。出现不明/冲突目录或潜在数据丢失时应原样保留，精确 RETURN。
- 绝不向 Evidence/聊天输出用户姓名路径、SID、Secret 值/摘要、代理 URL/IP/token、非目标网络/容器私有 ID/名称；只输出经脱敏汇总、归属分类和“是否安全候选”。
- 不把一个 Host 路径可达/不可达推断成 Docker Desktop 内部 proxy 路径；网络拉取问题保持 pending。
- 不因静态空闲 RAM 值低于任意数值而改变本轮结论；出现真实不稳定仅记录，不在此 Gate 操作 Docker。
- 任何发现可能影响其他项目或存在未解释 Secret / 数据去向的迹象，停止进一步扩大检查；不得为了让安装继续而“补建”路径或密钥。

**PREFLIGHT**：从当前 Gate 和 G1D 最小证据读取，证实 Owner 本机、只读工具/权限可用；本轮所有诊断不需要容器写入、Admin 提权或本机文件创建；任何环境/权限不允许的探针直接标 `UNVERIFIED`，不请求 Owner 手工进行多步排错。

**REQUIRED_EVIDENCE**：
- `karakeep-local/EXECUTION_EVIDENCE.md` 追加 G1E：AUTHORIZED_GATE、PREFLIGHT_FACTS、ACTUAL_CHANGES（明确本机 0）、OBJECTIVE_READBACK、VALIDATION、ANOMALIES、EVIDENCE_ARTIFACTS_AND_PURPOSE、ROLLBACK_EFFECT、RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT、EXECUTOR_RESULT。
- 记录路径/文件状态、局部候选与 ACL/read-back 分类（无路径/Secret）、旧记录与新事实边界、是否检测到可审核的失踪原因、网络分类与时间观测口径、代理开关当前状态、已下载两镜像是否存在、仍 `NOT_DEPLOYED`。
- GitHub main append-only，执行后读回 blob SHA；不改本 Handoff（Reviewer only）。

**ACCEPTANCE_CRITERIA**：
- 精确说明 `KarakeepLocal` 是否真正不存在、访问受限、仅候选错位或仍未知；若可见文件须能安全证明属于 accepted source/secret custody 或明确 `UNVERIFIED`。不要求证明删除因果，未知如实保留。
- 网络差异至少区分默认/项目自定义与活跃 endpoint、两次当前快照是否稳定；不能观察到历史 ID 时不编造。
- 不改变任何 Windows 文件/设置/Secret/Docker 对象；没有 `pull`/`up`，所有 Evidence 脱敏且 main 可读回。
- 诊断结束仍交 Reviewer 判下一 Gate；不把现有两个镜像称作已部署。

**ROLLBACK_STATUS_OR_PLAN**：仅只读本机，无运行环境回滚；GitHub 追加证据不删除。后续若真的必须重建，先由 Reviewer 把恢复与原 Secret 去向分类后另开授权 Gate；在本 Gate 不授权新 Secret 写入。

**OWNER_ONLY_ACTIONS**：本 Gate 不需 Owner 提供 Secret，也不需修改任何系统设置；Owner 仅转交只读 Gate 给可访问本机的 Codex。若之后需要在原路径重建/替换 Secret，另做明确 Owner 授权和恢复策略。

**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是 Owner Windows 本机 Codex Executor。读取 `entropy-student/project` 最新 main `karakeep-local/REVIEWER_HANDOFF.md` 的 CURRENT_GATE / CURRENT_ACCEPTED_STATE / SYSTEM_MAP / CRITICAL_CONSTRAINTS，以及 `karakeep-local/EXECUTION_EVIDENCE.md` **仅最新 G1D 小节**。执行 `KARAKEEP-WIN-G1E-MISSING-CONFIG-NETWORK-READONLY-20261016`，专注三个已知候选目录的只读路径/ACL/文件存在性与此前 Secret 是否可验证复用，以及非目标 Docker network ID 变化的最低限度元数据鉴别。不要扫描全盘、打印 Secret、探查其他业务数据或历史 Docker 容器日志。只观察当前 Host proxy 模式，不修改代理/网络。**本 Gate 禁止任何 pull、up、配置/密钥重建或系统变更。** 将脱敏结果 append 到 `EXECUTION_EVIDENCE.md` 并提交 main、读回，严格按 Executor 固定格式返回，停在 Reviewer。

**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
真实本机身份、Secret 保密与恢复边界、只读核对、不改系统/代理/其它 Docker 项目、禁止覆盖失踪 Secret、禁止未确认的原路径重建、证据不带隐私/Secret、无固定 RAM 数值门槛、Reviewer 停点。

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 本机 PowerShell Codex（本机执行身份需要新鲜证明）。

## CURRENT_ROLLBACK_STATUS
Karakeep 尚无容器/卷/用户收藏。两个官方 GHCR 镜像保留；历史受保护 Compose/Secret 当前找不到且没有可信异地恢复材料；本轮只有只读诊断无回滚。本项目后续恢复能力仍 `UNVERIFIED`。

## UNRESOLVED
原创建的 Compose/.env 是被移动、隐藏、访问拒绝、路径错配还是删除；是否仍有可受信任的 Secret 副本；Docker networks ID 变化的作用范围、Windows proxy 模式变化原因；Docker Hub 经 Desktop proxy 的真实访问仍未知。

## NEXT_STEP
Owner 将 G1E 只读核对指令转交本机 Codex；Reviewer 在 Evidence 读回后判断是否能恢复既有 Secret，或是否必须发起新的 Owner 授权安装恢复 Gate。Meilisearch pull 暂缓。

## OWNER_ACTION_REQUIRED
转交当前 G1E 只读 Gate，无需新增授权、无需提供任何 Secret，也无需恢复旧容器。

## EVIDENCE_POINTERS
当前 G1D Evidence：`karakeep-local/EXECUTION_EVIDENCE.md`，commit `a65f685bfde15482c83b0b6203f2768f82733f67`，blob `8585ff6de1d4b2912f964a6a4409d417be588f6c`。历史 G1C 及更早记录保持原样。
