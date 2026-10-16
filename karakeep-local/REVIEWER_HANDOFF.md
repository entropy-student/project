# Karakeep Local · Reviewer Handoff

> 2026-10-16 · STATUS=`NOT_DEPLOYED`
> GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> CURRENT_GATE=`KARAKEEP-WIN-G1F-MEILI-PULL-AND-DEPLOY-20261016`
> Authority: 本 Handoff 仅为当前项目状态与 Gate；历史执行事实 `EXECUTION_EVIDENCE.md` append-only。

## PROJECT_GOAL
在 Owner 实体 Windows 11 本机使用官方 Docker Compose 原版部署 Karakeep，Web 仅 `http://127.0.0.1:3000` 可用。目标先验证登录页、Web/Chrome/Meilisearch 依赖，不改业务源码、不接 AI API、不注册/导入真实收藏，不操作已有其他 Docker 项目及全局代理/VPN/证书/WSL 设置。

## PROJECT_STAGE
**G1E Reviewer 判定：PASS（read-only reconciliation），但项目整体 NOT_DEPLOYED。**
- Reviewer 已实际检查 `main:karakeep-local/EXECUTION_EVIDENCE.md` G1E 段落（commit `754f3745d6744e1bfaae1a1145965806470eb9bd`，blob `c04540e5bfd29c34744f46c23733f1d31a833370`）。
- **G1E PASS 范围**：已接受的 USERPROFILE `KarakeepLocal` 目录和原 Compose/.env **当前确实存在且安全可读**；Compose SHA-256 与 G1R 的已接受值完全一致；.env 有四个受控键，两 Secret 的当前格式与互异性、安全 ACL 均通过；未发生本机写入。当前网络 11 个（3 默认、8 自定义），间隔 15 秒的两次只读快照对象身份/元数据一致、全部无 attached endpoints。两个 GHCR 镜像身份仍在。
- **历史事实不重写**：G1D 当时报告目录缺失、网络 ID 变化；具体时间/原因仍 UNKNOWN。G1E 的历史 Secret 字节连续性没有对照证据，明确 `UNVERIFIED`；初装尚无用户、数据库、收藏，也无运行实例依赖旧密钥，因此 **Reviewer 接受现存受保护密钥作为首次安装配置**，不把它宣称为已证明与 G1R 的原始字节相同，**不允许重复生成或覆盖**。
- 原有 Docker 网络历史差异无法追溯 ID，但新近两次快照稳定且无 endpoint；不因此无限阻断隔离的新项目。Windows Internet proxy 先后不同，原因仍未知，只把本轮当前设置当 fresh state，不修改宿主代理。
- 仅余 Meilisearch Docker Hub 拉取问题；下一轮在一个 Gate 内执行有诊断价值的单次受限拉取，成功则条件部署，失败精确 RETURN 并输出可行动阻塞，不再循环旧的泛化前置诊断。

## SYSTEM_MAP
- HOST：Owner Windows 11，PowerShell 7.6.5；Docker Desktop Linux Engine 29.7.2 / Compose 5.4.0 / context `desktop-linux`（最近 G1E），每次执行新鲜核验目标与 Engine 可达即可。
- CONFIG：`$env:USERPROFILE\KarakeepLocal\docker-compose.yml`，本地 SHA-256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`；官方 Compose Git blob `865bb147cef972926d5dc32e50645876fd110555`。该目录 `.env` 受保护且有 `KARAKEEP_VERSION / NEXTAUTH_SECRET / MEILI_MASTER_KEY / NEXTAUTH_URL`；两个 64-hex Secret 格式有效，不显示、不再造、不复制/上传、不 hash Secret；没有 AI API key。G1E 目录和文件 owner/DACL 通过。
- PROJECT：Compose `-p karakeep-local`，官方服务 web/chrome/meilisearch；web Host port 仅 `127.0.0.1:3000:3000`，其他服务不发布 Host 端口。计划持久卷 `karakeep-local_data` 与 `karakeep-local_meilisearch`（G1E 尚不存在）；无项目容器/账号/真实数据。
- IMAGES_ACCEPTED：`ghcr.io/karakeep-app/karakeep:release` RepoDigest `sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`，`ghcr.io/karakeep-app/karakeep-chrome:release` RepoDigest `sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`；G1E 再次 readback，通过。**不要重拉这两个镜像**。
- IMAGE_MISSING：仅 `getmeili/meilisearch:v1.41.0`（官方原版配置对应 Docker Hub）；G1C 单次 Docker pull 失败 UNKNOWN。G1D Windows Host `registry-1.docker.io`、`auth.docker.io`、layer CDN TCP/443 timeout；Engine 配置 Docker Desktop 内部代理 alias，其 daemon image-pull 到 Docker Hub 的准确错误阶段尚未证明；不得将 Host timeout 当成 daemon 错误根因。
- NON_TARGET：G1E 20 容器（1 created/19 exited）、12 既有卷、11 networks（3 default/8 custom、0 endpoints）；现有 WordPress CLI/Web、MariaDB 等保持当前退出状态。MariaDB 的历史 unhealthy、容器 Exit 137 原因 UNKNOWN；不启动、不清理、不改非目标对象。部署时以新的 read-only ID/state baseline 前后比较。
- RESOURCE：C: 最近约 185 GiB 空闲，Docker Desktop overlay/volumes 同域空间 G1R 已可信验证，安装前轻量更新。Owner 已取消 2 GiB/0.8 GiB 任意固定剩余 RAM 门槛；记录实际可用内存、OOM/restart、Windows/非目标 Docker 运行稳定性即可。
- RECOVERY：首装无真实业务数据；启动失败时仅允许经身份验证的 `docker compose -p karakeep-local down`（绝不 `-v`），保留两个命名卷与原配置、Secret、已下载镜像；无清理/全局 prune。真实收藏/Secret 离机备份及恢复仍 `UNVERIFIED`，进入真正收藏前另作备份 Gate。
- EXECUTION：Owner Windows 本机原生 PowerShell Codex；云端 Reviewer 不直接修改此 Windows 本机。

## CURRENT_ACCEPTED_STATE
- G1E **正式 PASS：**当前受保护 Compose 和 .env 安全存在；Compose fingerprint 匹配；两 Secret 当前格式有效但历史字节连续性 UNVERIFIED（不影响尚无用户资料的首装）。历史缺失原因 UNKNOWN，当前无需重建。
- Docker Engine 最近可用，20 既有容器 /12 卷 /11 无 endpoint 的网络两次快照稳定；不认为此前未归因的 network ID 漂移可证明业务受损。
- Web/Chrome 官方两镜像已拉取且 digest 验证。Meilisearch v1.41.0 仍缺，Docker Hub 网络及 Desktop proxy 的确切失败层待下一 Gate 诊断。Karakeep 没有运行。
- G1E `PASS_CANDIDATE` 被 Reviewer **接受为本轮 G1E PASS**，不是项目部署 PASS。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G1F-MEILI-PULL-AND-DEPLOY-20261016`

**OBJECTIVE**：以最小、可审计的 Docker Desktop 镜像拉取诊断处理唯一缺失的 Meilisearch 镜像；若拉取成功，使用原 Compose/Secrets、现有另两镜像立即启动 Karakeep 并验证本地登录页。

**MAX_ENDPOINT_THIS_ROUND**：
1. 只读最小 preflight：真 Owner Windows 本机身份、Docker Desktop Engine/context、已接受路径 Compose SHA/ACL 和 `.env` 四键/两 Secret 格式（仅本机受保护进程内检测）、端口 3000 空闲、项目镜像/容器/卷无碰撞，两个已下载的 GHCR digest，Docker 后端磁盘余量无明显退化、非目标对象 baseline 与实际内存状态。**不重复 G1E 文件丢失历史调查、其他容器停机原因或旧 network ID 追溯。**
2. 在不更改任何系统设置前提下，结合本机可用的 Docker Desktop settings/Engine metadata、registry endpoint 受限探测，冻结一份**可真正分类错误**的诊断方案：仅针对 `getmeili/meilisearch:v1.41.0`，在本机受保护内存中捕获拉取产生的 stdout/stderr，并当场以安全白名单归类失败阶段：`DNS | TCP_TIMEOUT | PROXY_CONNECT | PROXY_AUTH | TLS_CERT_VERIFY | TLS_HANDSHAKE | REGISTRY_HTTP_401_OR_403 | RATE_LIMIT | IMAGE_TAG | LAYER_DOWNLOAD_OR_EXTRACT | OTHER_NONSECRET | UNKNOWN`；按实际检查结果如实分类，绝不输出原始日志、URL、凭据、用户信息或 Secret。先用人工合成的无敏感 fixture 验证分类器和 native exit-code 捕捉确实工作；控制拉取时限与次数，杜绝静默吞错变 UNKNOWN。
3. Owner 在本轮明确授权后，允许**一次**带该诊断机制的同官方 tag `docker pull getmeili/meilisearch:v1.41.0`。这**本身是一个受限单故障域诊断探针**，无需先宣称 Docker Hub Host 已恢复或将过去的 UNKNOWN 捏造成已明确分类。不可再拉 Web/Chrome、不换源/tag、不使用无 TLS 镜像镜像站、不自动改代理/证书/daemon/Clash/VPN/DNS。若失败，根据现场 error code 只记录脱敏阶段与修复需要，立即 RETURN；禁止当轮再试/自动进行全局修复。
4. 如果 Meilisearch image 下载成功，执行 `docker image inspect` 读取官方 RepoDigest/本机身份，复核另两镜像及受保护配置/loopback-only 发布、项目非目标对象快照、Docker Engine 活性和实际 OOM/系统稳定性。均通过时允许以已检验的 Compose CLI `docker compose -p karakeep-local up -d --pull never` （确认本机版本支持）仅启动 Karakeep 三容器。检查服务本身、Meilisearch、Chrome 内部依赖，Web `http://127.0.0.1:3000` 登录页、本机 127.0.0.1-only 发布与 LAN/公网不可达负面边界、项目卷身份及非目标对象未变。首轮不注册任何账户、不添加收藏/AI Key。
5. 发生服务异常/实际 OOM/非目标服务退化，仅按预定项目范围停止 `karakeep-local` 并保留卷与 Secret；若目标不明则不 destructive 清理并精确 RETURN。
6. 如拉取失败原因指向必须更改 Docker Desktop Containers proxy、Windows 代理、VPN、系统证书/daemon 等全局配置，**停在 Reviewer**，说明唯一需要的下一步授权类型。不可更改设置，不自行加入其他镜像源/架构，也不进入无限重试。

**MANDATORY_REVIEW_STOP**：本 Gate 在失败或完成候选后追加 Evidence、提交 `main`、再读回，必须停 Reviewer，不自动注册/正式用。

**TARGET_AND_SCOPE**：Windows Owner 实体本机、现有 `USERPROFILE\KarakeepLocal` 受保护文件、三个官方镜像、`karakeep-local` Compose project/new isolated named volumes。其它 Docker 资源/全局代理/Clash/VPN/证书/WSL/daemon 全部只读且不得改。

**APPLICABLE_CRITICAL_CONSTRAINTS**：
- 不更改、重生或输出现有 Secret；不能证实旧 Secret 字节相等不是阻断首装的硬前提，因初装无历史运行状态依赖；文件当前 ACL、格式、应用有效性和保护才是本次前提。
- 不存在新固定 RAM 限制；必须监测真实 OOM/持续重启/Windows 崩溃迹象与非目标状态。
- 已证实的 GHCR 镜像绝不重复拉取；缺失镜像一次有诊断价值的指定官方 pull 失败后即停止。错误本机脱敏不意味着信息完全丢失：保留可行动**阶段、错误类别、pull 时长区间、native exit code、是否开始 layer 下载**，但不可保留敏感原文/凭据/Host 本机个人标识。
- 非目标已有 20 容器退出不是本项目问题，不自动恢复；无 attached endpoints 的 11 网络稳定是最近 G1E read-back，不再无原因停顿。只对新发生的真实状态变化做精准 RETURN。
- Secret/代理 URL/IP、原始 Docker logs、数据库内容不可进 GitHub/聊天。
- 仅 localhost:3000；不 `prune`、不 `down -v`、不停止或更改其他项目。

**PREFLIGHT**：确认 Owner Windows 本机 + Docker Engine 可用、受保护配置与目录现存及 SHA/ACL 正确、目标无现有对象冲突、官方两镜像 read-back、port 3000 空闲、磁盘可用、明确本轮 Owner 有条件拉取/初装授权、错误分类器及本机受保护日志捕获经无秘密 fixture 验证。静态空闲 RAM 数值只记录。

**REQUIRED_EVIDENCE**：项目 `EXECUTION_EVIDENCE.md` 追加 G1F 的 AUTHORIZED_GATE / PREFLIGHT_FACTS / ACTUAL_CHANGES / OBJECTIVE_READBACK / VALIDATION / ANOMALIES / EVIDENCE_ARTIFACTS_AND_PURPOSE / ROLLBACK_EFFECT / RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT / EXECUTOR_RESULT，包含：配置与 existing image digest 结果、拉取次数与捕获机制、Meili 成功 digest 或失败的安全分类和具体阶段、Host vs Engine 路径界限、内存与对象快照、服务/依赖/loopback 安全验证及 project-only rollback、是否本机真实部署。仅脱敏文字提交 GitHub main 并读回；原始错误输出不离开受保护本机进程、Secret 不入 Evidence。

**ACCEPTANCE_CRITERIA**：
- 诊断完成分支：精准说明 Docker Desktop **本次** Meili pull 成败与失败所处域，若无法分类如实 `UNKNOWN` 但必须说明本轮分类器/观察限制；明确下一步是否需要 Owner 授权全局代理等设置。不可把 Host direct TCP timeout 说成 Docker Engine 拉取失败根因。
- 部署分支：三镜像官方身份 read-back、无额外 pull、Karakeep web/chrome/meilisearch 依赖正常、login page 实际可达、web 只监听 127.0.0.1、无 Chrome/Meili host 映射、项目卷可识别、其他项目状态未因本轮变化、宿主实际稳定无 OOM、无 Secret 泄露，GitHub Evidence 有效读回；Executor `PASS_CANDIDATE` 待 Reviewer 正式 PASS。
- 如果失去已有受保护配置或非目标资源发生实际高风险故障，精确 RETURN，不创造新密钥绕过。

**ROLLBACK_STATUS_OR_PLAN**：pull 未成功只保留可重复使用的官方两镜像和已有 Secret；若上层启动失败，只对本项目 `docker compose -p karakeep-local down` 且绝不 `-v`，保留卷/Secret，记录剩余状态；不触及其它 Docker/Windows 项目，禁止 prune。数据备份/异机恢复 `UNVERIFIED`，真实数据前后续另做 Backup Gate。

**OWNER_ONLY_ACTIONS**：Owner 转交本 Gate 时授权仅 `getmeili/meilisearch:v1.41.0` 官方镜像一次受限拉取及通过后 `karakeep-local` 独立初装；不授权修改 Docker Desktop/Windows 全局代理/证书/DNS/WSL/系统设置或非目标项目；不需提供 Secret。

**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是 Owner 实体 Windows 11 本机的 Codex Executor。仅读 `entropy-student/project` 最新 `main:karakeep-local/REVIEWER_HANDOFF.md` 的 CURRENT_GATE、CURRENT_ACCEPTED_STATE、SYSTEM_MAP、CRITICAL_CONSTRAINTS，并只读最近 `karakeep-local/EXECUTION_EVIDENCE.md` 的 G1E 段落。执行 `KARAKEEP-WIN-G1F-MEILI-PULL-AND-DEPLOY-20261016`。Reviewer 已接受 G1E 为 PASS：原受保护 Compose/.env 当前存在/校验通过，11 个网络当前稳定且无 endpoint；历史 Secret 字节连续性无法证明但首装尚无真实数据依赖，不再重复旧路径/网络调查。复用这套配置、现有两个 GHCR 镜像，不重新生成 Secret、不重复 pull。按当前 Gate 用预先验证的脱敏分类工具对 `getmeili/meilisearch:v1.41.0` 做**本轮仅一次**有意义的 Docker Desktop 拉取诊断；若成功且 fresh preflight 合格，就只用冻结 Compose 启动 `karakeep-local` 并验证 `127.0.0.1:3000` /三服务/非目标基线与安全边界。若失败记录安全错误阶段和下一步唯一阻碍，绝不自动改代理/VPN/证书/其它 Docker 项目、不盲目重试。按固定 Executor 完成格式追加脱敏 Evidence 到 GitHub main 并读回，停在 Reviewer。

**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
Windows Owner 本机、现有安全 Compose 与 Secret 复用、不拉已成功 GHCR 镜像、仅一次 Meili 官方 pull 诊断、不动其它 Docker 项目、不改宿主网络全局设置；无静态可用 RAM 门槛，实际稳定性检查；仅回环地址 Web、无账户/真实资料，失效精准 RETURN。

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 本机原生 PowerShell Codex。

## CURRENT_ROLLBACK_STATUS
G1E 无本机写入、无现有 Karakeep runtime/volumes；保留两 GHCR 镜像和受保护配置。G1F 如启动失败只做 Karakeep project-only `down` 保留卷；真正数据/Secret 离机恢复 `UNVERIFIED`。

## UNRESOLVED
Meilisearch Docker Hub 镜像拉取时 daemon/Containers proxy 的确切网络故障域仍 UNKNOWN；历史 G1D 文件可见性差异及网络 identity 漂移原因 UNKNOWN（当前状态稳定，均不独立阻止初装）；Windows host 直连 Hub timeout 可能持续但不是 daemon 网络故障证据。

## NEXT_STEP
Owner 转交 G1F 给本机 Codex；使用经无秘密测试的错误捕获/分类执行一次 Meili pull。成功立即条件启动 Karakeep，失败带可行动诊断返 Reviewer，不修改系统代理。

## OWNER_ACTION_REQUIRED
Owner 通过本轮转交明确授权官方单次 Meili pull 与条件启动 Karakeep；无需重新提供/生成两个 Secret，也无需恢复其他 Docker 容器。

## EVIDENCE_POINTERS
G1E `EXECUTION_EVIDENCE.md` commit `754f3745d6744e1bfaae1a1145965806470eb9bd` blob `c04540e5bfd29c34744f46c23733f1d31a833370`；历史 G0–G1D 保持不改。
