# Karakeep Local · Reviewer Handoff

> 2026-10-16 | PROJECT_STATUS=`NOT_DEPLOYED` | STAGE=`AWAIT_OWNER_PROXY_MODE_READBACK`
> Governance authority: `entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> This file = latest Reviewer-accepted current state and Gate; `EXECUTION_EVIDENCE.md` = append-only historical execution.

## PROJECT_GOAL
在 Owner Windows 11 本机按官方 Compose 安装 Karakeep web/chrome/meilisearch；Web 只在 `127.0.0.1:3000` 可用。首先验证容器依赖与登录页，后续才由 Owner 做注册、中文设置、收藏测试及实际资料前的备份。无 AI key、源码改造或公网开放；严格隔离已有 Docker 项目。

## PROJECT_STAGE
**Reviewer decision: G1G `PASS`（仅只读诊断范围合格），项目仍 `NOT_DEPLOYED`。下一步为 Owner 阅读 Docker Desktop 两个代理模式。**

| 里程碑 | 接受结论 |
|---|---|
| G0/G1 基础环境与边界 | 已验证可继续（历史 Return/细节保留 Evidence） |
| G1R 官方 Compose、受保护 .env、两随机 Secret、磁盘/ACL | PARTIAL（准备成果可复用） |
| G1C Karakeep Web/Chrome 两 GHCR 官方镜像 | PARTIAL（两镜像成功且 RepoDigest 已核对） |
| G1E 当前配置可见、安全、网络快照稳定 | PASS（只读核验） |
| G1F Meilisearch 官方镜像下载 | RETURN（退出码 1；宽泛 layer 类别，细分原因不明） |
| G1G Docker Desktop 代理只读诊断 | PASS（证据边界充分，根因/代理模式仍 `UNVERIFIED`） |
| Owner UI 两代理模式读取 | NEXT（仅查看，不修改） |
| Meilisearch 拉取修复及项目本机启动 | PENDING（需 Reviewer 下一 Gate + Owner 相应授权） |
| 访问、中文及收藏验证/真实数据恢复准备 | PENDING |

**G1G evidence accepted**：`main:karakeep-local/EXECUTION_EVIDENCE.md` commit `2a2ba90bafe0c68048720b87cbba5ddce77c150b` / blob `9c77c352eb2766c308f7dfe1aa7c011fb62a0db4`，经 Reviewer 实际读取。该提交仅改变项目 `EXECUTION_EVIDENCE.md`；不重写任何历史。

**G1G 正式判断**：本机受保护 Compose 指纹匹配，两 GHCR 镜像仍在，Docker Engine 正常。Windows WinINET proxy enabled、WinHTTP direct、Docker Engine HTTP/HTTPS/NO_PROXY 存在，但这些不能证明 Docker Desktop `Containers proxy` 实际模式。既有 settings-store.json 解析成功但无 allowlisted proxy-mode 键。推测时间窗内 httpproxy.log 有 registry/auth CONNECT，**没有可证 CDN/error**；G1F pull 精确时间未保留，日志与失败操作的关联只能 `INFERRED`。日志及 settings 文件 ACL 不具备防篡改证明，不能当作确定因果。合成 fixture 表明宽泛 `failed to copy` 可能掩盖 timeout，但**不能反推 G1F**。据此 G1G 范围 PASS，不代表查出故障根因，也不是安装 PASS。

## SYSTEM_MAP
- HOST：Owner Windows 11 native PowerShell 7.6.5，Docker Desktop Linux Engine 29.7.2 / Compose 5.4.0 / context `desktop-linux`，G1G fresh proof。默认 Executor=Owner 实体 Windows 的本机 Codex。
- CONFIG：受保护 `$env:USERPROFILE\KarakeepLocal\docker-compose.yml` 和同目录 `.env`；Compose SHA-256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`，官方源 blob `865bb147cef972926d5dc32e50645876fd110555`。env 四键 `KARAKEEP_VERSION / NEXTAUTH_SECRET / MEILI_MASTER_KEY / NEXTAUTH_URL`，两 Secret 当前格式正确互异、保护 ACL 通过；无真实使用中的历史用户数据；密钥明文和 hash 从未提交 GitHub。历史 Secret 字节连续性 UNVERIFIED，但当前密钥可作初装使用，不重生。
- DOCKER_TARGET：Compose project `karakeep-local`，三服务 web/chrome/meilisearch，唯一 Host 映射 `127.0.0.1:3000:3000`；Chrome/Meili 不向 Host 发布。计划两个 project volumes `karakeep-local_data`、`karakeep-local_meilisearch`，当前尚未创建；无 Karakeep 容器、账号、收藏或占用 3000。
- IMAGES_EXIST：`ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`、`ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`（本机已读回）。
- IMAGE_MISSING：`getmeili/meilisearch:v1.41.0` 官方 Docker Hub 镜像。G1C/G1F 独立 pull 曾失败；G1F 10 秒内退出码 1，没有实际下载进度旁证；原错误原文按当时 Gate 丢弃，精确子原因 UNKNOWN。可能残留的镜像层保留。
- NON_TARGET：G1F 最后确认 20 容器（1 created/19 exited/0 running）、12 既有 volumes、11 networks。WordPress/MariaDB 等其他项目的停止和旧 MariaDB unhealthy 原因未知，但本项目无权触碰/恢复。
- NETWORK：曾观测 Windows Host 直连 Docker Hub registry/auth/CDN 443 超时，但不等于 Docker Desktop daemon 拉取必超时。官方 Docker Desktop `Containers proxy` 控制所有 `docker image pull`；`Docker Desktop proxy` 仅在前者未配置时作镜像拉取回退。当前两种模式的实际 UI 选择均 `UNVERIFIED`；历史 WinINET 开/关漂移无归因，也不独立阻断后续动作。
- STORAGE：G1F C: 空闲约 184.7 GiB，Docker backend 映射此前通过；无 2 GiB 或 0.8 GiB 静态空闲 RAM 门槛，部署时只监测实际 OOM、重启和宿主/非目标稳定性。
- RECOVERY：无 Karakeep 真实数据，后续服务异常仅对目标项目 `docker compose -p karakeep-local down`（绝不 `-v`）且保留 Secret/volumes；当前项目 rollback 仍 PLAN_ONLY，数据与 Secret 异机恢复 `UNVERIFIED`。正式收藏前须独立备份验证。

## CURRENT_ACCEPTED_STATE
G1G 的 `PASS_CANDIDATE` **仅转成诊断 Gate 的正式 PASS**：完成本机只读证据采集、识别了模式证据不可用以及日志相关性局限，并给出唯一最小 Owner UI 读数动作。Meilisearch 失败根因仍 UNKNOWN；运行服务未启动。
本轮不要求 Owner 提供系统设置截图、代理地址/PAC/凭据；**只要两个代理模式名称**。拿到名称后由 Reviewer 判断下一 Gate：若无须修改共享设置就诊断/部署，或若需要最小 Docker Desktop 全局代理变更则明确影响/回退并另请授权。任何未来 pull/up 均须独立 Gate 和授权。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G1H-OWNER-PROXY-UI-READBACK-20261016`

**OBJECTIVE**：用最小 Owner 只读 GUI 检查消除 Docker Desktop 两项有效代理模式的当前未知状态，确定下一执行 Gate，不改变任何设置。

**MAX_ENDPOINT_THIS_ROUND**：Owner 打开 Docker Desktop → Settings（齿轮）→ Resources → Proxies，只读取当前选择的：
1. `Containers proxy`：`Same as host proxy / System proxy / No proxy / Manual configuration / 未配置 / 找不到` 中的实际 UI 标签。
2. `Docker Desktop proxy`：`System proxy / No proxy / Manual configuration / 未配置 / 找不到` 中的实际 UI 标签。
如界面实际名称不同，以所见文字为准。仅在当前对话回复这**两个模式名称**；不要抄送输入框内容，不分享 URL、IP、端口、PAC、用户名、密码、token、Secret，避免全页截图。不必点击 Apply & restart/Save。

**MANDATORY_REVIEW_STOP**：Owner 回传名称后停 Reviewer；不运行本机 Codex，不发生新的 Docker 操作。Reviewer 将核对模式的实际路径含义并制定下一 Gate。

**TARGET_AND_SCOPE**：Owner Windows Docker Desktop GUI 的代理模式单选项；其他应用、项目、系统设置完全不可碰。

**APPLICABLE_CRITICAL_CONSTRAINTS**：本 Gate 只读，不更改任何 Windows/Docker/代理/VPN/证书设置或其它容器。此时无新 pull/up 权限；不以 RAM 数值为门槛；敏感配置值不出 Owner 屏幕。

**PREFLIGHT**：Owner 当前可在 Docker Desktop GUI 打开 Settings/Resources/Proxies；若无法找到则直接反馈“找不到”，不凭空猜测或修改设置。

**REQUIRED_EVIDENCE**：Owner 在聊天回传两个模式名称（`OWNER_REPORTED`，不标 DIRECT_READBACK），Reviewer 后续将用该反馈更新此 Handoff 的接受状态，并明确下一授权 Gate。无需 Owner 或 Executor 当前向 GitHub 写入任何密码或截图。

**ACCEPTANCE_CRITERIA**：模式名称足以区分 `Containers proxy` 的有效选择与 `Docker Desktop proxy` 的回退选择；若 UI 没有选项则记录 `UNVERIFIED`，只设计最小额外检查。读数本身不能证明 Docker Hub 真实连通，也不能宣布 Karakeep 可部署。

**ROLLBACK_STATUS_OR_PLAN**：只读查看 UI，没有设置变更，无回滚。

**OWNER_ONLY_ACTIONS**：仅 Owner 查看并提供两个模式名称；非手动修复，不授权 Apply、改代理、pull、up 或动其它项目。

**REVIEWER_TO_EXECUTOR_RELAY**：`NONE`。本 Gate 不下发 Codex；Owner 读回后 Reviewer 另立最小修复/部署 Gate 才派发。

**EXECUTOR_TO_REVIEWER_RELAY**：本 Gate `NOT_APPLICABLE`；Owner 只回报两项模式。

## CRITICAL_CONSTRAINTS
复用受保护现有 Compose/.env/Secret 与两个已下载 GHCR 镜像；官方 Meili 镜像 identity 不得替换；不触碰已停止的 WordPress/MariaDB 和其它 Docker 对象；当前 G1H 不拉取/启动、不改全局代理/证书/VPN；不暴露密钥、代理地址或原始日志；没有任意 RAM 数值下限；以最小 Owner 模式读回消除阻碍。

## DEFAULT_EXECUTION_CHANNEL
后续技术执行：Owner 本机原生 PowerShell Codex，尚未派发新技术 Gate。当前只需 Owner Docker Desktop GUI。

## CURRENT_ROLLBACK_STATUS
未部署，无 Karakeep volumes/容器/数据；保留原 Compose、受保护 .env、两 GHCR 镜像。Owner 此轮只读，rollback NONE；真实数据/Secret 离机恢复仍 UNVERIFIED。

## UNRESOLVED
两项 Docker Desktop 代理模式实际值（当前 Owner checkpoint）；Docker Hub Meili layer 失败真实底层原因；历史 WinINET 漂移原因（只记录，不追究）。G1G 的历史日志与 Meili pull 时间关联不足。

## NEXT_STEP
Owner 只回传 Docker Desktop `Containers proxy` 和 `Docker Desktop proxy` 两项当前选择的模式。Reviewer 据此确定唯一下一步操作及授权，再由 Codex 执行最小修复/指定 Meili 下载/条件部署；不重复只读 G1G 或盲 pull。

## OWNER_ACTION_REQUIRED
Owner Docker Desktop GUI：Settings → Resources → Proxies；读出两个模式文字，不要保存或修改设置；在聊天中回复（1）Containers proxy：...（2）Docker Desktop proxy：...；不提供代理敏感信息。

## EVIDENCE_POINTERS
最新 G1G `karakeep-local/EXECUTION_EVIDENCE.md` commit `2a2ba90bafe0c68048720b87cbba5ddce77c150b` blob `9c77c352eb2766c308f7dfe1aa7c011fb62a0db4`；历史 G0–G1F 保留且 Evidence append-only。
