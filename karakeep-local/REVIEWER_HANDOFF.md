# Karakeep Local · Reviewer Handoff

> 2026-10-16 · 项目仍 `NOT_DEPLOYED`
> 正式治理：`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> Reviewer accepted current truth = 本文件；历史执行事实 = 同目录 `EXECUTION_EVIDENCE.md`（append-only）

## PROJECT_GOAL
最小改动在 Owner Windows 11 实体本机安装 Karakeep 官方 Docker Compose 三服务，访问 `http://127.0.0.1:3000`。不修改上游源码、其他 Docker 项目/Windows/WSL/代理，公网不开放，不提前注册账号或导入真实资料；首装成功后 Owner 自行测试中文 UI 与收藏。

## PROJECT_STAGE
**G1D_MEILISEARCH-PULL-DIAG-AND-CONDITIONAL-DEPLOY**，等待本机 Codex。当前 `NOT_DEPLOYED`。
- 历史 G0、G1、G1R、G1N：事实已接受，RETURN 不重写。G1R 已建立受保护本机目录、官方 Compose 和两个专用 Secret。
- **G1C Reviewer 已核验**：`EXECUTION_EVIDENCE.md` blob `c3d188d3800be0a0714b8785b02e33810e14f793`，commit `20e0434971ad036805aacce3c3370fb077113544`。认可本轮非目标状态及两次官方 GHCR pull 成功的直接读回；认可 `RETURN_PULL_FAILURE_UNKNOWN`，不判部署 PASS：Meilisearch 单次 pull 退出 1，失败子类无法归因；应用从未 up。
- 本轮不再按旧 Gate 重下两个 GHCR 镜像，不恢复停止的别的项目，不因为单纯 RAM 数字不足停止。经历 G1R + G1C 两次同域拉取失败（虽错误类别不完全确定），下轮优先做**一个故障域的受限诊断**而非无依据重试。

## SYSTEM_MAP
- HOST：Owner Windows 11，PowerShell 7.6.5；Docker Desktop Linux Engine 29.7.2；Compose v5.4.0；context `desktop-linux`（G1C）；G1D 前做新鲜最低限度核对。
- PROJECT_CONFIG：受保护的 `$env:USERPROFILE\KarakeepLocal\docker-compose.yml`、`.env`。官方 source Compose blob `865bb147cef972926d5dc32e50645876fd110555`，本机 Compose SHA-256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`；配置和两 Secret 已通过 ACL、格式、Compose quiet-config 检验。严禁输出、改写或重新生成 Secrets。
- PROJECT_DOCKER：`karakeep-local`，服务 web / chrome / meilisearch；唯一 web Host 发布 `127.0.0.1:3000:3000`，两个卷 `karakeep-local_data` + `karakeep-local_meilisearch`（G1C 尚不存在）。没有 Karakeep 容器、卷或公网监听。
- TWO_IMAGE_REPODIGESTS_ACCEPTED：
  - `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`
  - `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`
  以上为 G1C 本机 `image inspect` read-back；下一轮只读确认原 tag/repo digests 仍本地存在且身份未漂移。
- ONLY_MISSING_IMAGE：官方 Compose `getmeili/meilisearch:v1.41.0`，来自 Docker Hub；G1C pull 失败且未记录细分错误；不要换 tag、registry 或私有镜像。
- EXISTING_NON_TARGET：G1C 入口基线 20 个容器（1 created / 19 exited / 0 running）、12 个已有卷、11 个网络；其中原 WordPress CLI(137, OOMKilled=false)、WordPress Web(0)、MariaDB(137, OOMKilled=false, last health unhealthy)均 exited，退出原因 `UNKNOWN`。本项目不启动、恢复、排错、清理其数据和对象，不把已停止容器写成可用。
- STORAGE/RAM：Docker Engine overlay/local-volume 映射及主机磁盘足够初装，G1C C: 余约 185 GiB；RAM 从 2167 MiB 到 1036 MiB，未发现实际 OOM；Owner 取消固定剩余 RAM 门槛，保留实际资源/运行稳定监控。
- NETWORK：Windows Host GHCR TLS 成功；Windows Host `registry-1.docker.io` 443/HTTP 超时，DNS 成功；Docker Desktop pull 上两个 GHCR 成功，Docker Hub pull 失败 `UNKNOWN`。Docker Desktop `Containers proxy` 决定 pull 路径（Docker 官方文档），其工作模式/具体故障尚未确定。不得修改全局代理或安全设置。
- RECOVERY：初装无账户和真实收藏，Karakeep 失败时允许仅本项目 `docker compose -p karakeep-local down` 保留卷和已有 `.env`；`down -v` 与 `prune` 禁止。真实数据和 Secret 离机恢复 `UNVERIFIED`。
- DEFAULT_EXECUTION_CHANNEL：Owner 本机原生 PowerShell Codex，云端 Reviewer 没有直接修改本机能力。

## CURRENT_ACCEPTED_STATE
G1C 已实际完成本机现有配置/ACL/Compose read-back、Docker Engine 命令正常、其他容器退出原因小范围检查；成功 pull 并验证两个 GHCR 镜像的 RepoDigest；未改变任何原有 20 个容器/12 个卷/11 个网络；未启动 Karakeep。Meilisearch pull 1 次退出 1，脱敏分类 UNKNOWN；没有允许的第二次同镜像重试。旧服务末次 MariaDB unhealthy 是另项目已存在的问题，不能推断是 Karakeep 引起，不授权对其动作。
Reviewer 接受实际工作成果，结论仍 **RETURN_PULL_FAILURE_UNKNOWN**。现在专注 Docker Hub / Containers proxy 这一故障域。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G1D-MEILI-HUB-RECOVERY-20261016`

**OBJECTIVE**：获得 Meilisearch Docker Hub 拉取失败的**可复核原因**；只有根据新证据能合理判断网络已恢复或有安全可行的同配置拉取路径，才允许一次新的 Meilisearch-only pull。若镜像成功，复用已存在的两镜像和配置启动仅本项目并验证。

**MAX_ENDPOINT_THIS_ROUND**：
1. 只读确认本机真实执行身份、Docker Engine/context、受保护现有 Compose SHA/ACL/`.env` 字段格式（不打印值）、localhost:3000 冲突、两个 GHCR RepoDigests；以 G1C 已接受的非目标容器/卷/网络状态作为对照，不逐个重新研究停止原因。
2. **单故障域诊断**：只读识别 Docker Desktop 的 `Containers proxy` 与 `Docker Desktop proxy` 选择的模式（非 URL/端口/密码）、Engine 实际 proxy 使用状态、Docker Hub 的 registry/auth endpoints 及镜像层 CDN 的主机名级别（仅有记录安全性时），验证 TCP/TLS/HTTP 状态与超时阶段；区分 Host 网络与 Desktop image pull。可读取官方 Docker Desktop 代理日志/状态的**受限相关片段**，必须在本机内过滤掉 URL、IP、认证头、secret、token、隐私标识，仅输出白名单结论；不读取原有业务日志/DB。
3. 原 G1C 的原始 pull stderr 没有保留，不允许臆造当次低层原因。只读工具/错误解析器如曾因规则漏判 UNKNOWN，可在**不含任何真实 Secret 的纯模拟字符串 fixture**上静态测试分类函数，确保能区分 `DNS_FAIL/TCP_TIMEOUT/PROXY_CONNECT/PROXY_AUTH/TLS_VERIFY/HTTP_403/HTTP_429/TAG_NOT_FOUND/IMAGE_LAYER_ERROR/UNKNOWN`。不能为了补证据而打开非目标容器。
4. **条件**：若步骤 1–3 有新的直接证据证明 Docker Hub 端点可用/上次是可重试暂态错误，且无需更改代理/安全/daemon 全局设置，Owner 本轮授权下**只允许一次** `docker pull getmeili/meilisearch:v1.41.0`（同官方镜像+同 tag）。在受保护本机进程内捕获/即时分类原始错误，不输出/保存原始敏感 stderr。若拉取失败，立即停止，本轮 `RETURN`，记录准确故障阶段/安全分类；不可换 registry、镜像或重试。
5. 若 Meilisearch pull 成功且官方 tag/digest 可本机 read-back，同时另两 GHCR 镜像及配置完整、非目标基线未变、无实际 OOM/系统故障，则可 `docker compose -p karakeep-local up -d --pull never`（仅当此语法由现有 Compose 支持），只部署现有三服务。检查 Web 实际登录页、本机端口回环正/负面、应用→Chrome/Meilisearch 依赖、容器身份/重启/OOM、卷归属、原有对象前后完全无本轮变化。若服务失败，执行已审核的本项目-only 停止，保留卷与 Secret。
6. 若诊断证明需要变更 Docker Desktop Containers proxy、Windows/Clash/VPN、证书、DNS/镜像加速或全局设置，**禁止修改**，准确 RETURN 并报告最小 Owner 决策事项；本轮绝不替换镜像来源、降级 TLS 或新建独立 Meilisearch 部署架构。

**MANDATORY_REVIEW_STOP**：条件诊断 RETURN 或部署候选完成后，追加 Evidence 到 GitHub main、读回验证，停止在 Reviewer，不能自动注册/新增资料或进入下一 Gate。

**TARGET_AND_SCOPE**：Owner Windows 本机已存在的 `$env:USERPROFILE\KarakeepLocal` 文件、`karakeep-local` Compose 和三个官方镜像（新网络写入仅 Meilisearch tag）；不得修改其他 Docker 项目/容器、全局系统/代理/证书设置。

**APPLICABLE_CRITICAL_CONSTRAINTS**：
- 重用已有 `.env` 中两 Secret，不显示、不重新生成、不上传或输出 Secret 摘要；不改 Compose 内容、tag 或地址。
- 只做一次**有新证据支持**的指定 Meilisearch pull；无新线索就停在诊断，避免重复盲目下载。
- RAM 无 2 GiB/0.8 GiB 等任意启动阈值；记前后可用内存、OOM、容器重启、Windows响应。出现实际失稳仅停止 Karakeep；不关闭已存在服务抢资源。
- 当前非目标容器退出视为现状，不自动恢复。只根据新变化/积极异常证据识别风险，任何非目标容器变化原因不明时 RETURN。
- HTTP/registry 返回状态由工具本地受限处理。GitHub/聊天仅存白名单故障分类/非秘密证据，不输出原始 proxy URL/IP、真实凭据、完整日志。
- 只 localhost:3000；无公共路由；不运行 `prune`、`down -v`、`docker login`、镜像构建/替代，禁止更改全局 Docker Desktop 配置。

**PREFLIGHT**：既有受保护 Compose/Secret 校验、项目/端口无冲突、Docker Engine 及可靠磁盘剩余正常（以原已接受存储证据的复核为主）、非目标当前状态可固定、真正有新证据支持一次 Meili pull 的安全/网络条件。不能推出“Docker Hub 必定可拉”，只确定是否允许本轮尝试。

**REQUIRED_EVIDENCE**：
- `EXECUTION_EVIDENCE.md` 追加 G1D：Gate/Owner 授权、新鲜本机与目标验证、Docker Desktop/Engine/Host proxy **模式**和对应故障层结论（无地址与 Secret）、两已存在 image digest read-back、Meili 重试决策的依据、实际 pull 次数/结果与新 digest（成功才写）、本项目服务/卷/loopback 访问证据、原有非目标基线与资源对照、错误分类/精确 RETURN/回滚效果。
- 证据写入 GitHub main 后立即读回 SHA；只写当前项目 Evidence，不覆写历史，不含原始 proxy/日志及用户 Secret。

**ACCEPTANCE_CRITERIA**：
- 诊断分支：明确发现什么新证据、是 Host 或 Desktop image pull 哪一层、为什么能够/不能在不改全局设置下恢复；当期未授权的配置修复不能偷偷执行。
- 条件部署分支：官方 Meilisearch 镜像与另外两个已接受 GHCR image 均可 read-back；三服务可用、Web 登录页/依赖正常、仅 loopback、非目标对象无回归、没有实际 OOM/稳定性问题、密钥/数据隔离完整；提交脱敏 Evidence。
- 不把旧 GHCR pull 或无账户状态写成全套部署 PASS；Executor 只报 `PASS_CANDIDATE`，Reviewer 才能正式审核 PASS。

**ROLLBACK_STATUS_OR_PLAN**：pull 失败则保留已下载的两个 GHCR 镜像、原配置和 Secret，不删除部分镜像层、不修改任何其他对象。启动后出错仅允许对新 `karakeep-local` 项目用已冻结 Compose `down`，不带 `-v`，保留 project named volumes/.env；不触碰用户既有数据。首次无真实收藏，异机恢复 `UNVERIFIED`。

**OWNER_ONLY_ACTIONS**：Owner 提交本 Gate 给本机 Codex 时明确授权：只允许诊断后一回合的 `getmeili/meilisearch:v1.41.0` pull（有新证据才执行），全部镜像健康后仅启动 `karakeep-local`；不授权系统代理/证书/任何既有 Docker 项目的更改或恢复。

**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是 Owner Windows 本机 Codex Executor。只读 `entropy-student/project` 最新 main 的 `karakeep-local/REVIEWER_HANDOFF.md` 中 CURRENT_GATE、SYSTEM_MAP、CURRENT_ACCEPTED_STATE、CRITICAL_CONSTRAINTS，以及 `karakeep-local/EXECUTION_EVIDENCE.md` **仅最新 G1C 段落**。执行 `KARAKEEP-WIN-G1D-MEILI-HUB-RECOVERY-20261016`，不重跑 G0/G1/G1R/G1N/G1C，也不拉已成功的两个 GHCR 镜像。复用受保护 Compose/.env 并读回两镜像 digest。先在只读范围内集中诊断 Docker Desktop Containers proxy 与 Docker Hub reachability，防泄露地分类实际错误，不更改任何代理/VPN/系统/Docker 设置。仅有新的可行动证据和本次 Owner 明确许可时对原版 Meilisearch:v1.41.0 **单次 pull**；成功则核验三镜像，并只启动 `karakeep-local` + 验证 localhost 登录页/三服务/其他对象不变。任何阻碍精确 RETURN。Evidence 追加 main 后读回，按固定 Executor 输出格式汇报并停在 Reviewer。

**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
安全目录/原生 Compose/密钥均已有效，最小化继续；只拉缺失的一个官方镜像；网络和安全不绕过；无任意可用 RAM 下限；只 localhost；不操作原有 20 容器或数据，不提前进行真实收藏/注册；证据脱敏；严格 Gate STOP。

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 11 本机 PowerShell Codex。

## CURRENT_ROLLBACK_STATUS
没有 Karakeep 容器/卷或业务数据；保留已有两 GHCR 镜像与配置密钥。本项目专用 `down`（不带 `-v`）是部署失败回退计划；真实用户数据/密钥跨设备恢复仍 `UNVERIFIED`。

## UNRESOLVED
Meilisearch pull 的真实错误阶段和 Docker Desktop Containers proxy 路径；Docker Hub Host timeout 是否仍存在；之前退出的其他项目运行状态不归本项目治理。Karakeep Web/Meilisearch/Chrome 三服务尚未运行。

## NEXT_STEP
Owner 将 G1D 交给本机 Codex。先单故障域诊断，在新的可审证据下条件单次 pull 缺失镜像并部署；Reviewer 审核最新 Evidence。

## OWNER_ACTION_REQUIRED
Owner 明确授予本轮**有条件单次 Meili pull + 条件启动 Karakeep 项目**权限；不必提供或重新生成密钥，不必处理已有的 MariaDB。

## EVIDENCE_POINTERS
`karakeep-local/EXECUTION_EVIDENCE.md` G1C commit `20e0434971ad036805aacce3c3370fb077113544`，blob `c3d188d3800be0a0714b8785b02e33810e14f793`；G0/G1/G1R/G1N 作为历史留存。
