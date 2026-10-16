# Karakeep Local · Reviewer Handoff

> REVIEW_DATE=2026-10-16
> PROJECT_STATUS=`DEPLOYED_LOCAL_TECHNICAL_PASS`
> LAST_RUNTIME_PROOF=`2026-10-16T07:37:55Z`（Owner Windows 本机 Executor 直接读回；后续仍可能发生运行状态变化）
> CURRENT_GATE_ID=`KARAKEEP-WIN-G2A-OWNER-FIRST-USE-20261016`
> GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> `REVIEWER_HANDOFF.md` 为当前状态权威；`EXECUTION_EVIDENCE.md` 只追加历史事实，未作历史回写。

## PROJECT_GOAL
在 Owner 实体 Windows 11 本机以官方 Karakeep 三服务 Docker Compose 实现本地收藏管理入口，首装仅 Web 绑定 `127.0.0.1:3000`，保护既有 Docker 项目、Windows/Docker 共享设置及 Secret。当前技术部署已验收；接下来 Owner 自行创建本地账户、验证中文 UI，再进行受控功能/备份验证。不得等同公网生产上线。

## PROJECT_STAGE
| 阶段 | 已接受结果 |
|---|---|
| G0–G1R 环境/Compose/Secret | 基础配置与受保护本机文件及权限验证，历史 RETURN 证据保留 |
| G1C/G1E 镜像与配置现状 | Web、Chrome 两官方 GHCR 镜像和现有 Compose/.env 已验收；G1E 只读 PASS |
| G1F–G1H Docker Hub 代理定位 | 历史 Meili 拉取失败、Docker Desktop 代理模式由 Owner GUI 确认，事实保留 |
| G1I 三镜像/首次启动 | 官方 Meilisearch 拉取 PASS；三容器/Meili/Web 短暂运行；Chrome 直接 Host 探针 500 导致原 Gate RETURN，项目按 Gate down、volumes 保留 |
| **G1J 原配置重新运行/真实浏览器路径** | **Reviewer 正式 PASS**：三镜像和原配置复用，Web/Meili 运行、Worker DNS→IP 行为与成功 CDP 握手相互支持；没有 OOM/重启，隔离正确；项目按 Gate **保持运行** |
| **G2A Owner 首次网页使用** | NEXT：Owner 用本机浏览器访问登录页，可手动建立仅用于本机测试的账户并验证语言/界面；尚无真实书签 |
| 后续真实收藏/恢复能力 | PENDING：先确认数据与 Secret 的可恢复方式，之后做有界真实书签/网页抓取功能测试 |

**G1J 正式 Reviewer 判断**：已逐项实际核对 `main:karakeep-local/EXECUTION_EVIDENCE.md` 的 G1J 全段，commit `b801c2b629b303f730d05329c958cffca61686b3`，blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4`；同时已核实该提交仅修改 `karakeep-local/EXECUTION_EVIDENCE.md`。接受 G1J 的技术部署 `PASS_CANDIDATE` 为**正式技术部署 PASS**，不代表登录后收藏抓取、应用完整业务功能、重启持久性或灾难恢复 PASS。

## SYSTEM_MAP
- Host/Runner：Owner Windows 11 本机 PowerShell 7.6.5；Docker Desktop 4.95.0 Personal、Linux Engine 29.7.2、Compose 5.4.0、context `desktop-linux`（G1J 读回）。默认执行渠道：Owner Windows 本机 Codex。
- 受保护配置：`$env:USERPROFILE\KarakeepLocal\docker-compose.yml`，SHA-256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`；官方源 blob `865bb147cef972926d5dc32e50645876fd110555`，唯一本地端口改为 `127.0.0.1:3000:3000`。`.env` 四键 `KARAKEEP_VERSION/NEXTAUTH_SECRET/MEILI_MASTER_KEY/NEXTAUTH_URL`，两 Secret 当前格式/互异性和 ACL 已验收；绝不输出值/hash/恢复凭据。
- Compose 项目：`karakeep-local`，服务 `web`、`chrome`、`meilisearch`；仅 Web 绑定 loopback 3000，Chrome 9222 与 Meili 7700 仅项目内部网络，不向主机暴露；实际 Chrome 浏览器 CDP 连接在 Web 容器内部成功。
- 镜像：Web `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`；Chrome `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`；Meilisearch `getmeili/meilisearch@sha256:860fa4baed04ae1c235de870edab0c8006227546dea1bbb6411fbfc5e27cf1db`，v1.41.0。G1J 镜像身份 read-back 匹配；Web 没有可用 OCI revision label，精确源码版本 `UNVERIFIED`。
- 数据持久：两个已有项目卷 `karakeep-local_data` 与 `karakeep-local_meilisearch`；G1J 已复用，未创建 Owner 账户、书签或 AI key；离机数据和 Secret 恢复能力 `UNVERIFIED`。
- 最后运行状态：G1J `2026-10-16T07:37:55Z` 本机读回 23 容器/3 running、14 volumes、12 networks；比启动前只新增 3 目标容器和 1 项目 network，20 个其它容器仍未启动/改动。Web `healthy`；全部 0 restart / OOMKilled=false。当前无人从云端实时查询 Owner 本机，后续网页实际打开结果以 Owner 新鲜现场为准。
- URL：`http://localhost:3000` → `/signin`（HTTP 307）；`http://localhost:3000/signin` 200，页面存在 Karakeep 登录标志。
- 代理：Docker Desktop proxy = System proxy / Containers proxy = Same as host proxy；G1I 实际不改代理即成功拉 Meili；G1J 未动代理，不需要进一步网络诊断。Clash 7897 是过去 Owner 提供的候选端口；此时不是部署阻碍。
- 资源：G1J host available RAM 有一次约 424 MiB、随后至约 1.9 GiB；无 OOM/restart，**无静态 RAM 数值 Gate**。Owner Windows 本机 3000 只 loopback，G1J 非 loopback 负面连通不成功；无公网端口。
- Recovery：G1I 验证目标项目 `docker compose -p karakeep-local down` 无 `-v` 可停掉容器+网络、保留原镜像/配置/两个卷。该动作是已验证的仅项目停止能力，**不等于**数据/账户/Secret 灾难恢复通过。G1J PASS 时**未停止服务**。

## CURRENT_ACCEPTED_STATE
**TECHNICAL_INSTALLATION_PASS_AS_OF_G1J**：三官方镜像 identity/readback PASS；原 Compose 与 Secret 安全状态 PASS；Web 登录页/Meili health/Chrome CDP 通路 PASS；Web localhost-only/其他端口未发布、非目标 Docker 不变 PASS；无 observed OOM/restarts，Karakeep 保持运行。
**BROWSER_EVIDENCE_BOUNDARY**：G1J Worker 真实日志显示曾尝试连接 Chrome、成功将 `chrome` 解析成地址；短窗没有其定义的重试/断开/失败标记；来自 Web 容器的独立、只读 CDP 握手返回 `Browser.getVersion` 成功。Worker 未打印独立 success 日志，未登录 admin API 为 401。这些是**行为正证据与交叉印证**，而不是已读取到 Worker 内存中确切连接句柄；正式技术验收将其视为充足，保留账户登录后的书签抓取 E2E 测试未验证。G1I 的人工 `Host: chrome` 500 为浏览器安全机制观测，不能单独否定上述真实连接。
**NOT_YET_VALIDATED**：Owner 网页新鲜手动打开、首个用户注册和认证、中文 UI、收藏内容抓取/截图、账户/数据库/volumes 恢复、Docker Desktop 重启持久性、长时间稳定运行、真实数据备份。不得把技术 PASS 说成全面产品功能 PASS。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G2A-OWNER-FIRST-USE-20261016`
**OBJECTIVE**：Owner 在本机网页确认 Karakeep 登录/注册入口，必要时自己创建一个仅用于测试的本地账户，观察界面语言与基本操作；不要求再跑 Codex、不触碰其它容器。
**MAX_ENDPOINT_THIS_ROUND**：Owner 在运行 Karakeep 的原 Windows 本机打开 `http://localhost:3000`，确认是否重定向到登录页。若页面正常，可选择完成应用自带的首次注册/登录（用户名、邮箱和密码**仅本人在网页内输入，不转发给 Reviewer/Codex**），观察 UI 是否已有中文选项并报告是否成功。此 Gate 不导入真实书签、不连接外部 AI API、不使用支付或公网功能。无需出示密码、Cookie、认证 token、登录后完整截图。
**MANDATORY_REVIEW_STOP**：Owner 将网页可访问/语言/注册结果回传后由 Reviewer 判断下一步；无需 Codex 先写新 Evidence；Owner 完成前不声明首次使用 PASS。
**TARGET_AND_SCOPE**：Owner 原 Windows 本机浏览器与仅 loopback Karakeep Web；可选本地测试账户（存在于已隔离命名卷的项目持久层）。不得修改 Compose、系统代理或其它项目。
**APPLICABLE_CRITICAL_CONSTRAINTS**：证据来源 `OWNER_REPORTED`；登录信息/Secret 不入 Chat/GitHub；本轮不引入真实不可丢失资料；真实收藏前必须明确备份/恢复 Gate。
**PREFLIGHT**：Owner 同一 Windows 本机 Docker Desktop 正在运行、可以访问本机 3000；若打不开，回报无法访问即可，不猜测为 Chrome 问题，不让 Owner 更改系统代理或重建项目。
**REQUIRED_EVIDENCE**：Owner 反馈三个非敏感事实：`PAGE_ACCESS=YES|NO`；`LOCAL_ACCOUNT_TEST=CREATED|SKIPPED|ERROR`；`UI_LANGUAGE=ZH|EN|OTHER|UNKNOWN`；不需要截图。
**ACCEPTANCE_CRITERIA**：当前登录/注册页面可被 Owner 本机访问；若决定创建测试账户，可正常登录且无额外权限范围变化；未向外部输出密码或 token，未在本轮添加真实收藏。
**ROLLBACK_STATUS_OR_PLAN**：Owner 本轮仅查看 UI 或创建空测试账号，无项目配置更改；遇到问题停止后交 Reviewer，不删除用户账号或卷。业务数据/凭据失去仍 `UNVERIFIED`，首次注册后更应安排恢复。
**OWNER_ONLY_ACTIONS**：Owner 自行决定是否创建本地账号（账号权限及密码仅 Owner 掌握），不要将账号密码发给 Codex/ChatGPT。本轮 Owner 只需报告基本结果，不需提供 API key。
**REVIEWER_TO_EXECUTOR_RELAY**：`NONE`；本 Gate 不调用 Codex。
**EXECUTOR_TO_REVIEWER_RELAY**：`NOT_APPLICABLE`；本 Gate 由 Owner 直接完成 UI 只读或本人注册。

## CRITICAL_CONSTRAINTS
所有配置/.env/Secret 继续冻结；三个已验收镜像原样保留；只有 Web 绑定 127.0.0.1:3000，Chrome/Meili 不公开；非目标 Docker 项目不修改；无任何固定剩余 RAM 门槛但真实 OOM/重启要停；禁止 `prune` 和 `down -v`；后续真实数据前的可靠备份、Secret 离机恢复与恢复验证未完成，不能宣称全面产品或灾难恢复 PASS。

## DEFAULT_EXECUTION_CHANNEL
后续需要技术变更时继续 Owner 原生 Windows PowerShell Codex；**当前 G2A 只要 Owner 浏览器操作**。

## CURRENT_ROLLBACK_STATUS
G1I 本项目仅 `down` 不带 `-v` 停止/保留卷的效果已读回；G1J 无需回滚且最后验证三个目标容器仍运行。真实数据及 Secret 跨机器恢复未验证；项目数据备份/实际恢复需独立后续 Gate，不因本次技术 PASS 自动放行。

## UNRESOLVED
网页首次注册及中文界面实测、真实书签/浏览器抓取 E2E、数据和 Secret 离机备份/恢复、restart persistence/长时间运行。Worker 没有独立 success log、Web OCI revision 缺失，但 G1J 可交叉证实浏览器 CDP 可用，不作为重复阻断的前置条件。

## NEXT_STEP
Owner 首先直接打开 `http://localhost:3000`，可选本机账户注册/登录并查看中文 UI。反馈页面可访问/是否成功注册/界面语言三项非敏感事实。然后 Reviewer 依据 Owner 结果决定备份/恢复和单个可丢弃测试书签的最小下一阶段，不开展额外镜像、Chrome、代理建设。

## OWNER_ACTION_REQUIRED
Owner 浏览器访问 `http://localhost:3000`；不要提供账号密码。若能进入页面，可直接由本人注册一个本地测试账号，但**暂勿导入重要收藏或真实文档**，直到完成备份/恢复核验。

## EVIDENCE_POINTERS
- G1J `main:karakeep-local/EXECUTION_EVIDENCE.md`：commit `b801c2b629b303f730d05329c958cffca61686b3`，blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4`，本轮 Reviewer 已实际读取。
- G1I 镜像拉取/项目回滚：commit `e760ea202fe2e46560dd0692218a8fe8178a8bac`，blob `c300dc5d422cbbcbacc554a1bf8acdaf92e2a531`，历史保留。
- Governance `entropy-student/spike.skill` main v0.2.7 `vps-project-governance/VNEXT.md`；官方 Chrome Worker 源 `karakeep-app/karakeep` `apps/workers/workers/utils/browser.ts` main blob `96192428e232c375680d989a49abb58bb897a6fb`，不与 Web frozen image revision 混淆。
