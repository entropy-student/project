# Karakeep Local · Reviewer Handoff

> 项目日期：2026-10-16
> 治理：`entropy-student/spike.skill` 最新 main `vps-project-governance/VNEXT.md` v0.2.7
> Current authority：本文件；历史执行事实：同项目 `EXECUTION_EVIDENCE.md`

## PROJECT_GOAL
在 Owner Windows 11 本机最小改动部署 Karakeep 官方原版 Docker 三服务，浏览器仅本机访问 http://127.0.0.1:3000；首次注册/中文设置/真实收藏留在安装 PASS 后。当前不接 Codex、AI API，不改软件源码，不碰其他 Docker 项目。

## PROJECT_STAGE
**G1N_DIAGNOSE_NETWORK_AND_CONDITIONAL_DEPLOY**（待 Owner 本机 Codex 执行）；**NOT_DEPLOYED**。Owner 于 2026-10-16 明确撤销 Reviewer 自定的「部署前宿主可用内存 ≥2.0 GiB」硬门槛；本 Gate 不设置新的固定剩余内存数值。
- G0：只读发现事实已接受（Executor 历史 `RETURN_STORAGE_LAYOUT_UNRESOLVED`）；G1：`RETURN_SECRET_ACCESS_MISMATCH + RETURN_PREFLIGHT_DRIFT` 已接受。
- G1R：Reviewer 已直接读取 `EXECUTION_EVIDENCE.md`，包括最终 blob `67050da8beb674d7f5d822f2fc9194978ccfe5b4`。接受已完成的本机受保护配置创建及磁盘验证证据；**不接受部署 PASS**，因为 pull 返回网络/TLS 分类错误且 pull 后可用 RAM = 1.74 GiB < 2.0 GiB 起步门槛。
- 不重做 G0/G1/G1R 已证明通过的工作。不清理本项目唯一 Secret、不另造密钥，不修改已保护的配置，除非 Reviewer 新 Gate 授权。

## SYSTEM_MAP
- HOST：Owner 实体 Windows 11、PowerShell 7.6.5、Docker Desktop Linux Engine 29.7.2、Compose v5.4.0、context desktop-linux（G1R 观察；运行前重新核实）。
- CONFIG：本机 `$env:USERPROFILE\KarakeepLocal`，现有受保护 `docker-compose.yml` 和 `.env`。二者 ACL 已实测，仅用户、SYSTEM、Administrators 可访问；绝不能输出密钥/文件内容到聊天、GitHub 或日志。
- CONFIG_IDENTITY：本机 Compose SHA-256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`；官方源 Git blob `865bb147cef972926d5dc32e50645876fd110555`；仅 web port 改 `127.0.0.1:3000:3000`。
- SERVICES：原版 web / chrome / meilisearch；`docker compose -p karakeep-local`；卷 `karakeep-local_data`（应用数据库/收藏）和 `karakeep-local_meilisearch`（搜索），G1R 结束时尚未创建。初始化环境文件包含 NEXTAUTH_SECRET、MEILI_MASTER_KEY、NEXTAUTH_URL、KARAKEEP_VERSION；不含 AI 密钥。
- DOCKER STORAGE：Docker Desktop 数据 VHDX 位于宿主系统盘；G1R WSL 数据挂载和隔离诊断容器的 overlay 余量约 950.88 GiB，相差仅 108 KiB；Docker local volume mountpoint 位于 DockerRootDir 对应数据根之下，Host C 盘有 191.36 GiB 空闲。单独容器 df 未直接给出专属 volume 行，**不能写成已单独实测命名卷**；综合证据足以通过初装需 >=8 GiB 的空间准则，部署当次新鲜复核即可。
- OTHER WORKLOADS：既有 WordPress CLI、WordPress web（8189）、MariaDB 三容器，G1R 前后稳定；不重启/改动/清理其他资源。
- NETWORK：Docker Desktop Windows 系统代理与 Docker Desktop image pull/Containers proxy 可能不同；pull 报 network/TLS 类，具体 stderr 子类未保留，根因 UNKNOWN。
- DEFAULT_EXECUTION_CHANNEL：Owner 本机 PowerShell 的 Codex。ChatGPT GitHub Reviewer 不代表 Owner 本机操作已经执行。
- BACKUP/RECOVERY：当前尚无真实用户数据。项目启动异常允许项目专属 `docker compose -p karakeep-local down`，保留项目卷、配置和 Secret；`down -v` / prune 禁止。真实使用前仍需备份/恢复验证，当前为 `RECOVERY_UNVERIFIED`。

## CURRENT_ACCEPTED_STATE
- `DIRECT_READBACK`：G1R 期间安全独立项目目录与受限配置/密钥已经创建；Compose `config --quiet` PASS；服务/网络/卷命名与本地端口限制正确，两个独立 32-byte CSPRNG Secret 保留且没有明文记录。
- `DIRECT_READBACK`：G1R 单个网络隔离只读诊断容器无遗留；Engine 存储有足够空间；3 个现有容器未受影响；Karakeep 目标 tags 未拉取成功、目标容器/卷无创建、3000 未监听。
- `DIRECT_READBACK`：pull 退出 1，分类 `NETWORK_TLS`，低层原因 UNKNOWN；前置 RAM 3.35 GiB，pull 失败后 1.74 GiB。因此不可启动。此前 G1R Reviewer 判 `RETURN_DEPLOY_IMAGE_PULL_NETWORK_TLS + RETURN_PREFLIGHT_DRIFT`，**历史结果原样保留**。
- 目前唯一目标：确定 Docker image pull 层的准确故障类别，资源合格后仅作一次有诊断依据的受限重试；不通过则记录停在诊断，不继续反复重试。

## CURRENT_GATE

**OWNER_MEMORY_POLICY_UPDATE**：官方 Docker Compose / 安装文档未规定「Windows 宿主机部署前必须有 2 GiB 可用 RAM」；之前该值是 Reviewer 的保守操作阈值，不是上游硬性要求。现按 Owner 明确指示删除固定剩余内存门槛，只保留实际健康与隔离回滚检查。此决定不追溯改写 G1R 的真实停止历史，也不影响单独的镜像拉取网络/TLS 阻碍。

**GATE_ID**：`KARAKEEP-WIN-G1N-PULL-DIAG-CONDITIONAL-DEPLOY-20261016`

**OBJECTIVE**：沿用已安全生成的配置，先查 Docker 镜像拉取网络/TLS 的具体原因，若有可验证的可用连接且资源合格，则尝试完成官方三服务部署与 localhost Web 验证。

**MAX_ENDPOINT_THIS_ROUND**：
1. 原生 Windows / Docker Desktop / 项目文件只读 preflight；容器/资源/端口基线。
2. 仅诊断目标镜像 registry（官方 Compose 的 ghcr.io 与 Docker Hub）从 Windows Host 与 Docker Desktop image pull 网络路径的差异。允许只读诊断 DNS、TLS、证书信任/代理模式（仅输出是否配置及模式，不暴露地址/密码/token/证书内容）。不得改代理、Clash、VPN、Docker Desktop/daemon 设置、证书存储、registry mirrors、安全检查。
3. **仅当** preflight 满足、前次错误已尽量按可复核证据缩小到明确类别、没有需要修改宿主/全局配置的阻塞、Docker 数据盘剩余 >=8 GiB，且未观察到系统/其他容器存在实际内存故障或明显不稳定时，可尝试一次受限、官方目标镜像专属 pull 诊断：先单个目标镜像并在进程内脱敏读取错误分类；成功则按原配置完成剩余官方镜像拉取；任何失败立即停止，不重复/不借用其它镜像源或 insecure registry。
4. 三镜像均以可审查 digest 成功拉取、原有服务未退化且未发现实际内存/OOM 故障时，允许 `docker compose -p karakeep-local up -d --pull never`（或当前 Docker Compose 等效可用语义）只启动本项目；验证 web/依赖/本机负面访问边界与资源。不可自动进入 Owner 注册/真实数据阶段。
5. 任一关键条件未达时精确 RETURN，停止对本机进一步写入，保留现有 `.env`/Compose；不执行无依据的下一次 pull。

**MANDATORY_REVIEW_STOP**：诊断完成或条件部署结束后提交 Evidence，必须交 Reviewer 才能决定下一 Gate。

**TARGET_AND_SCOPE**：仅 `$env:USERPROFILE\KarakeepLocal` 现有受保护项目配置与 `karakeep-local` Compose/官方三镜像；禁止更改其他任何 Docker 项目/卷/网络、系统代理、Docker daemon/WSL 设置。初装无真实收藏，不对外发布。

**APPLICABLE_CRITICAL_CONSTRAINTS**：
- **复用已存在的密钥和配置**：验证文件/目录 owner、DACL 和 Compose 文件 hash、`.env` 字段格式（绝不能输出 Secret、行内容或 Secret 摘要），不得替换/旋转/展示两个 Secret。
- G1R 结束 RAM 为 1.74 GiB，是历史观测值，不再视为部署阻断线；Owner 明确取消此前 Reviewer 自定的启动前 ≥2.0 GiB 与启动后 <0.8 GiB 的固定数值门槛，不另设任意数值替代。继续在 pull/up 前后观测宿主可用内存、Karakeep 容器内存和 OOM/restart、Windows 响应、已有三容器健康。若实际发生 OOM/持续异常重启、明显系统失稳或现有服务退化，立即只停止本项目并 RETURN。Executor 不得擅自关闭非目标项目/宿主进程腾内存；正常的低剩余 RAM 数字本身不等于失败。
- Docker Storage 原 G1R 的充分证据不反复要求原方式重采全套，确认目标 data backing 与最小 8 GiB 安全空间无明显漂移即可。
- 原失败没有保存低层消息，不能臆测 TLS 子类。对任何原始 Docker 错误/日志/代理地址/令牌，必须在受保护执行上下文当场转换为 allowlisted 类别：`DNS_FAIL | TCP_CONNECT_FAIL | TLS_HANDSHAKE | CERTIFICATE_VERIFY | PROXY_CONNECT_OR_AUTH | HTTP_401_EXPECTED | HTTP_403 | RATE_LIMIT | TIMEOUT | IMAGE_NOT_FOUND | UNKNOWN`，不得把原始错误复制到 Evidence/聊天。
- 不能通过 `--insecure`、`insecure-registries`、禁用 TLS 验证、全局修改 CA/网络安全设置或镜像替换绕过拉取失败；若某类网络问题必须动 Desktop proxy 或证书，返回 Reviewer 请求独立批准。
- GitHub Evidence 不接触本机 Secret、私人路径/身份、原始日志/代理网址；网络信息只提供分类与脱敏读数。

**PREFLIGHT**：
1. 读回目标本机/用户/权限、Docker 上下文、现有三个非目标容器稳定状态、3000 端口、新鲜宿主可用内存及 Docker 数据存储剩余量，确认无同名项目/镜像/卷意外漂移。内存仅作为观察和前后对照指标，不因低于 2.0 GiB 自动禁止 pull/up；如有实际 OOM、已有服务退化或系统不稳定则按范围停止。
2. 检查既有项目目录和配置是否保持 G1R 提交过的 hash、Leaf ACL、安全边界与期望 `.env` key 数及格式；文件异常即 RETURN，不能自动修复或重生密钥。
3. 从官方 Compose 确定完整目标 image 列表与 tag，读取 Host / Docker Desktop 代理模式及 registry 的 TLS/DNS/tcp 应答，区分浏览器/PowerShell HTTP 可达与 daemon image pull 可用性；必要时一次经过限额的官方单镜像 pull 诊断。
4. 条件允许时正式拉取、复测 RAM 和原三个服务，再启动、核对只绑定 127.0.0.1 的 3000 端口、内部服务状态、Docker image identity 和不修改其他项目。

**REQUIRED_EVIDENCE**：追加本项目 `EXECUTION_EVIDENCE.md` G1N 段落，包含授权、原错误故障分类、Host/Desktop 网络路径差异的脱敏事实、内存前后、是否实际 pull/up、各镜像 identity/digest（非凭空生成）、项目与其他容器/卷/端口的前后状态、资源安全边界、回滚作用与异常；不输出原始日志和任何 Secret/代理 URL。提交 `main` 并读回验证。

**ACCEPTANCE_CRITERIA**：
- 诊断分支：至少获得较 G1R 更具体、可行动的网络错误类，或清楚说明因缺少哪些证据无法分类；不执行超出 Gate 的配置修复。精确 RETURN。
- 条件部署分支：只使用已有受保护密钥与冻结 Compose、官方三镜像完整拉取后启动、无实际内存/OOM 故障且 Web 登录页 `http://127.0.0.1:3000` 可达且非 localhost 不可达、Chrome/Meili 仅内部网络、3 个原有容器维持健康；磁盘空间要求和实际健康检查通过（不以固定空闲 RAM 门槛判定），元数据重启语义和可恢复性标记诚实。无 Owner 注册/真实数据。
- Executor 自报 `PASS_CANDIDATE` 仍需 Reviewer 从 GitHub 查看相关 Evidence 才能正式 PASS。

**ROLLBACK_STATUS_OR_PLAN**：如果 pull 失败，不创建容器；保留已下载到的只属于本轮项目镜像供下一轮只读判定，不 prune 或删除其它镜像。若 up 后失败，只对确证 `karakeep-local` 的容器/网络做 `docker compose -p karakeep-local down`（不带 `-v`），保留配置、密钥和两个命名卷；任何未知对象/镜像别动。数据恢复 `UNVERIFIED`，还没真实数据。

**OWNER_ONLY_ACTIONS**：Owner 需在本轮转交明确授权：仅本项目的受限镜像 pull 和满足 Gate 前提后启动；不授权改系统/代理/证书、清理既有资源、密钥轮换、账户注册、真实收藏。

**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是 Windows 本机 Codex Executor。仅读最新 main `karakeep-local/REVIEWER_HANDOFF.md` 的 CURRENT_GATE、CURRENT_ACCEPTED_STATE、SYSTEM_MAP、CRITICAL_CONSTRAINTS 与 `karakeep-local/EXECUTION_EVIDENCE.md` 最新 G1R 段落。不要重做已经通过的 ACL/存储诊断，不要另造 Secret。执行 `KARAKEEP-WIN-G1N-PULL-DIAG-CONDITIONAL-DEPLOY-20261016`：先做只读 Docker Desktop image-pull 网络/TLS/代理的目标诊断，保护敏感信息，新鲜检查当前 RAM、磁盘、端口、原本三容器及已存在的受保护配置；只在 Gate 前提达到时执行**一次**有诊断依据的官方镜像拉取，全部拉取成功且未出现实际 OOM/系统失稳/原有服务退化时再启动唯一 Karakeep 项目，检查 Web/内部依赖与隔离。如需更改 Docker Desktop 代理、证书、系统网络或其他项目，则不修改、准确 RETURN。追加脱敏 Evidence、提交并读回 GitHub main，按固定格式返还，停在 Reviewer。

**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
不改 Karakeep 源码；不新建/覆盖/输出 Secret；只 localhost；只用官方冻结 Compose 和镜像；不动其他 Docker 项目、系统级代理/安全证书/WSL/daemon；不设宿主剩余 RAM 的强制启动数值门槛，但监测 OOM/重启/Windows 与非目标服务健康并在实际异常时停止本项目；无向 GitHub 或聊天输出的敏感错误。Owner 才能授权越界。

## DEFAULT_EXECUTION_CHANNEL
Owner 本机原生 PowerShell / Codex。

## CURRENT_ROLLBACK_STATUS
G1R 前无 Karakeep 数据；G1R 仅新建受保护配置和密钥、未启动服务/卷，无需 Docker 回滚。G1N 可用的回滚仅为项目级 `down` 保留卷；数据/Secret 独立恢复 `UNVERIFIED`。

## UNRESOLVED
Docker 镜像拉取到底是代理/TLS 证书/网络超时/鉴权的哪类；当前运行实际内存是否稳定；官方三镜像 pull 与 Web 真正运行尚未验证。

## NEXT_STEP
Owner 转交 G1N 给 Windows 本机 Codex，先网络诊断后有条件单次拉取与启动；Reviewer 检查 Evidence 决定 PASS/RETURN。

## OWNER_ACTION_REQUIRED
本轮 Owner 应明确授权**仅 Karakeep 官方镜像单次诊断 pull 与条件启动**；其它系统网络设置修改不在授权内。没有要求 Owner 先清理内存或关闭应用；Codex 不得关闭非目标程序。

## EVIDENCE_POINTERS
`karakeep-local/EXECUTION_EVIDENCE.md`：G0 `ec4f95d`、G1 `c0170cb`、G1R blob `67050da8beb674d7f5d822f2fc9194978ccfe5b4`。G1N 追加新段落。
