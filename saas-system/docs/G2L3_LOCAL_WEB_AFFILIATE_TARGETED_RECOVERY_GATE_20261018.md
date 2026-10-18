# G2L3 — 本机 Velobase Web 可用性与 Affiliate 有界恢复（2026-10-18）

> GATE_ID=`SAAS-G2L3-LOCAL-WEB-AFFILIATE-TARGETED-RECOVERY-20261018`
> STATUS=`REVIEWER_READY / NOT_EXECUTED`
> TARGET=`OWNER_WINDOWS_LOCAL_CODEX / EXISTING_VELOBASE_WEB`
> SOURCE_SHA=`e88e259b974f883913f68ac74a9b8377765d005d`
> OPTIONAL_WRITE=`MAX_ONE_EXISTING_WEB_CONTAINER_RESTART / ONLY_IF_INDEPENDENTLY_CONFIRMED_UNRESPONSIVE_AND_PREFLIGHT_SAFE`
> MANDATORY_REVIEW_STOP=`YES`

## OBJECTIVE

**不反复部署**：接续 G2L2 已通过的本地管理员正常登录、Dashboard、Admin 用户页能力，先在原有 Windows Docker 环境辨别 `HTTP 000` 是回环代理、端口转发、应用请求超时还是 Web 进程挂起。如果确实是 Web 应用自身无响应，且下列项目专属安全前提全部成立，才允许**至多一次仅本项目既有 Web 容器**的受控重启，随后复核稳定 Web 访问；再收集 Affiliate 页面空白的可判别错误类型与有资格与否的**布尔**结果。无需先重建源码/镜像，也不要求恢复旧三容器或创建云环境。

已经受 Reviewer 接受的 G2L2 事实：1280×900 的真正 Desktop 视口可见本地管理员按钮，合法 UI 登录后已打开 `/dashboard` 和 `/admin/users`（显示 33 条演示用户结构），故**不重复这一认证问题的根因诊断**。用户/普通角色 Admin 负例和 Worker 实际任务为 UNVERIFIED，不能由管理员页面 PASS 推导。

详见 [G2L2 正式独立审查](./G2L2_REVIEWER_DECISION_20261018.md)。

## MAX_ENDPOINT_THIS_ROUND

- 对同一已经运行的 `saasvh-e88e259` Web/Postgres/Redis 项目，仅做有界非敏感只读健康采样、HTTP 故障分类、少量本机受控页面导航与原生 DevTools error class 观察。
- `HTTP 000` 必须以 **curl.exe 退出码与原始失败类别**区分，不以数值 000 直接称作服务宕机；至少在 Windows 回环 `--noproxy "*"` 和 **Web 容器内同一 HTTP GET** 两条独立路径对照。不得盲目改系统代理、全局 Clash、Docker Desktop、虚拟网卡、VPN 或 WSL。
- **唯一可选写操作**：如果两条路径确证 Web 应用本身持续无 HTTP 响应、并且保存最小脱敏错误证据、核实隔离和下述持久化标记后，允许最多一次对**已经存在、身份核实一致**的 Web **单容器**执行正常 `docker restart --time 30 <EXACT_VERIFIED_WEB_CONTAINER_ID>`。不要重启 Postgres/Redis、其它 Compose/Engine、启动/恢复旧容器。不能重建或创建新容器；若 Docker 重启命令可能影响其它资源则 RETURN。
- **启动器副作用明确授权边界**：固定源码 `services/demo/start.mjs` 每次 Web 启动会调用 `prisma db push --skip-generate`，且 seed marker 不存在时会播种；所以 Web 重启并非严格只读。本轮仅当原 `auth-secret`、`harness-preview-seeded`、`harness-admin-demo-v1` **这三个项目专属持久化文件存在且非空**、挂载/源码/ImageID/端口与 G2L2 一致、Postgres/Redis healthy、没有共享业务或外部 Provider/支付绑定、项目历史状态稳定时才允许这一次重启；不打印/读取 Secret 值，不执行额外 `db push`、seed、SQL、migration 或文件写入。任一标记缺失/身份不符/疑似业务数据不可安全重入，则 RETURN 不重启。
- 重启成功只证明服务恢复，不代表消除了 Affiliate 源码 Bug；若现有页面仍空白，只收集一次精确错误类/顶部可脱敏栈及 `affiliate.getStatus` 的网络 **HTTP 状态、query loading/error/eligible 布尔分类**，然后精确 RETURN 或 PARTIAL，交 Reviewer 决定之后一个**最小应用代码改动** Gate；禁止在本轮偷偷修改源码/镜像/运行 Env。
- Web 健康复测可在新隔离本地 Demo 浏览器内用官方**可见**按钮登录一次，重复最小量 Dashboard/Admin 首页是否仍可读，避免多次重载/并发压测。绝不假冒普通用户身份、伪造 JWT/cookie 或开通推广资格。

## MANDATORY_REVIEW_STOP

`YES`。两条通路的有界诊断结束、或一次有条件 Web 重启+恢复验收结束，即停在 Reviewer；不会自动切换 Open SaaS/Wave 或接入支付。出现 Windows 卡死、明确 Docker OOM/其它项目健康回退、目标身份不符、重要卷/数据风险，立即 STOP，精确仅对本轮已恢复/改变的 Velobase 项目处理，**不得停止整个 Docker Desktop/Engine 或动其它项目容器**。若已出现需要人工维护 Windows/Docker 全局的故障，则停并报告，不借 G2L3 修改共享设置。

## TARGET_AND_SCOPE

- **真机**：Owner Windows 11 Home、本机 Codex；历史工作目录 `%USERPROFILE%\Documents\ChatGPT\Velobase-Harness-e88e259`，固定 Git HEAD `e88e259b974f883913f68ac74a9b8377765d005d`，现有 Compose project `saasvh-e88e259`。
- **运行对象**：Web 唯一既有容器和镜像；Postgres/Redis 仅只读健康检查，不重启；保留命名卷 `saasvh-e88e259_preview_data`、`saasvh-e88e259_demo_state` 及历史 Redis 持久化。Container Web `127.0.0.1:3003`；禁止改变端口绑定或公网转发。
- **版本与标签**：G2L2 真实 Web Image ID `sha256:9ab2468decb483e8941b18ce99570a1cf51677b3bb4c0c11024c1d6ea79364ef`，与当前本机 image tag ID 一致。G2L1 对同一字符串 SHA256 截短结果 `1552F1BBB39573BA`，已由 Reviewer 独立计算匹配。Compose 标签中 `88bb7e...` 是历史元数据差异，**不等于已发生镜像替换**，原因未知；只读记录，无须重建或 reset。
- **Provider 与持久化**：仅原隔离 Demo 数据，禁第三方 OAuth/Email 登录、Google/GitHub 身份接入、Stripe TEST/Live、真实支付/退款/佣金/提现、客户私有数据；禁止输出任何 Secrets、Cookies、环境全量、客户资料。
- **外部项目**：其它 35 个非目标容器在 G2L2 前后均为 34 exited + 1 created，运行数 0；但其真实业务身份不明，不要做任何更改。当前快照仅来源 Owner 转交的本机报告，须新鲜核实。
- **资源**：Web G2L2 约 4.37–5.21 GiB，宿主 free RAM ~0.94GiB；不设任意最低空闲 RAM 门槛，但继续采样真实 OOM、响应延迟、其它业务影响。

## APPLICABLE_CRITICAL_CONSTRAINTS

读取 `entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 通用 §0–10、§11 触发规则及 §11A/B/C/D、支付禁止边界 §11E、§12–13；Reviewer 已完成本轮解释，Codex 只按本 Gate 限定入口和目标，不需宽泛重读历史。GitHub 主仓只记录项目级文档，本地原候选源码仍保留固定上游 SHA。

## PREFLIGHT_AND_EXECUTION

1. **核对目标与健康**：只读核实 Windows/工作树固定 SHA/Compose project/容器 ID 与镜像 ID、3 个项目容器 running，Postgres/Redis healthy，本机 3003 端口归属和非目标状态基线；不因 Web HTTP 000 就自动重启 Docker、清理卷或升级系统。若运行状态已漂移（例如 Web 已自动重启或容器重新创建），回报具体 drift，暂不进行重启。
2. **HTTP 000 的真实分类（第一优先级）**：用 PowerShell 的 **`curl.exe`（不是 PowerShell `curl` alias）** 对 `http://127.0.0.1:3003/` 发两个有限的、禁代理 `--noproxy "*"` 请求，例如 `curl.exe --noproxy "*" --http1.1 --connect-timeout 5 --max-time 20 -sS -o NUL -w "http=%{http_code} connect=%{time_connect} ttfb=%{time_starttransfer} total=%{time_total}" http://127.0.0.1:3003/`。分别记录 `$LASTEXITCODE`、错误类别（如 `52 Empty reply from server`、`28 Timeout`、`7 Connect failed`）、connect/TTFB/总用时和 HTTP Code；避免将纯浏览器代理问题混为 Web 崩溃。若一次成功则再间隔采样，仅在重复失败且 Web 内路径也失败时才考虑 Web-only 重启。
3. **容器内独立 HTTP**：仅在确认是现有 `web` 容器后，通过 `docker exec` 调用容器已有 Node `http.get('http://127.0.0.1:3003/')`，设置请求超时与无正文输出，记录连接成功/错误码/TTFB/HTTP status；不安装工具/修改容器 FS、不输出环境。若容器内部路径成功而宿主失败，优先诊断 Docker Desktop 3003 端口转发/代理，不能根据此证据重启 Web 或修改 Engine。
4. **有界只读日志**：只捕捉与该项目、该时间窗相关的 `web` 日志、Web 端 Node/Next 服务存活信号、DB/Redis ready、近 10min 真实 OOM/进程退出事件与 Windows/Docker 当前可用内存；**只提取计数、错误类、时间段、堆栈前两层不含 Secret 的模块名**，不要粘贴 raw env/log/用户资料。观察热点 CPU/memory 与连接失败是否有时间关联，不能光凭进程仍运行就判健康，也不能光凭高 CPU 判 OOM。
5. **条件性受控恢复**：**只有** Windows 禁代理 HTTP 与容器内直连独立复核均显示 Web 持续无响应，并且 Web 进程/日志支持挂起而无正在进行的写入/构建/数据库迁移任务，且 Demo 原认证密钥文件与两种 seed marker 均在**原挂载**中存在非空、固定源码/Image ID 未变、数据库与缓存 healthy、其它项目状态稳定、无 Provider 绑定，才允许一次 `docker restart --time 30 <EXACT_VERIFIED_WEB_CONTAINER_ID>`。操作前后记录 Web restart count、镜像 ID、卷挂载、日志启动时对 DB push/seed 的实际行为分类，保证不出现新建/清理或重播种；如果有明显实际数据风险，就不执行重启。此步可能触发启动器对**专属 demo DB 的 schema sync**；若资源属于真实业务或无法确认专属 demo，禁止重启。
6. **恢复后验收**：若服务经一次 Web-only 重启恢复（或 2–3 次重复直连原本已正常），每隔短暂间隔复测至少三次 Host No-Proxy HTTP status 200/可解释的重定向、Container 内 status 正常；通过独立浏览器合法 Demo UI 登录、只读 Dashboard/Admin，并单次复核 Affiliate 路由。Worker 只读状态/日志错误计数；不得触发真任务或业务自动化。所有结果必须区分 HOST/CNTR/Browser，不把短时首页可访问视为长期健康。
7. **Affiliate 特定诊断**：页面仍空白时，优先记录一次浏览器 Next.js/React 错误的**错误类型、相关组件名、脱敏顶部栈**，及会话有效性、是否因非 eligible 而路由至 /404、`affiliate.getStatus` API 的 HTTP 响应状态与布尔分类（只允许 `isLoading`、`isError`、`eligible`、`canActivate`，不要保留请求体或用户字段）。固定上游 `src/app/account/affiliate/page.tsx` 在 render 内 `router.push('/404')` 属风险线索，不等于已证根因；报告若可定位到具体单文件，建议下一轮补最小变更，不在 G2L3 写源码。
8. **镜像差异按元数据处理**：可只读核实 Compose label `com.docker.compose.image`、Web 实际 ImageID、`saasvh-e88e259-web` tag 与 Git HEAD；不据不一致触发 pull/build/recreate、Docker system prune 或 reset。
9. **结束与证据**：在项目内仅新增 `saas-system/docs/G2L3_EXECUTION_EVIDENCE_20261018.md` 并向 Reviewer 返回固定简报。Web 若稳定则保留运行供 Owner 体验；若进行单 Web 重启后仍 HTTP 失败/数据异常，则不再重启，保持隔离环境现状及原卷，精确报告并由 Reviewer 决定是否需要局部停止项目。未经 Reviewer 新 Gate 不尝试第二轮修复。

## REQUIRED_EVIDENCE

`GATE_ID`, `TARGET_LOCAL_PROOF`, `PRE_EXISTING_SERVICE_IMAGE_AND_VOLUME_IDENTITIES`, `INITIAL_HOST_HTTP_FAIL_CLASS_WITH_CURL_EXIT_CODES`, `HOST_NO_PROXY_VS_CONTAINER_LOCAL_HTTP`, `ERROR_COUNTS_TOP_STACK_SANITIZED`, `WEB_DB_REDIS_WORKER_HEALTH`, `ACTUAL_OOM_EVENTS_AND_RESOURCE_SAMPLES`, `DEMO_PERSISTENCE_MARKER_EXISTS_FLAGS_ONLY`, `CONDITIONAL_RESTART_DECISION_REASON`, `EXACT_WEB_ONLY_RESTART_ACTION_COUNT`, `RESTART_DB_PUSH_AND_SEED_CLASSIFICATION`, `AFTER_HTTP_HOST_CONTAINER_BROWSER_RESULT`, `DASHBOARD_ADMIN_READ_UI_RESULT`, `AFFILIATE_ERROR_CLASS_AND_ELIGIBILITY_BOOLEAN_ONLY`, `WEB_IMAGE_TAG_AND_LABEL_METADATA`, `OTHER_WORKLOAD_DELTA`, `PAYMENT_OR_PROVIDER_ACTION_COUNT_ZERO`, `ROLLBACK_AND_END_STATE`, `EXECUTOR_RESULT`, `OWNER_RELAY_NONE`.

## ACCEPTANCE_CRITERIA

- Windows Host 直连与容器内 Web HTTP 请求分别有退出类别和耗时，证明当前是否真的持续不可用、是否由代理引起；不得虚构原因，且 Web-only 重启至多一次、只在条件成立时。
- 原版 Admin UI 和 Dashboard 只读操作可重演，Web 访问不再持续出现 000；若稳定性不足必须如实部分验收，而非整体 PASS。
- Affiliate 登录后的正常资格状态/界面或明确可追溯的错误类型至少得到一次高质量证据，便于 Reviewer 发一个单点源码修复 Gate（如必要）。
- 项目 ImageID 不变、两卷/网络/DB/Redis 保留，其他所有项目容器零主动修改；不暴露数据/Secret，不接入任何支付或外部 OAuth。
- 普通用户 Admin 权限负例及 Worker 任务业务证明若无正规条件仍为 `UNVERIFIED`，不能伪装为 PASS。
- 若只读证据显示代理/宿主转发问题、本轮恢复条件不成立或 Web 仍不健康，准确 RETURN 并停在最小故障域；不自动转变成 Docker 全局维修工程。

## ROLLBACK_STATUS_OR_PLAN

只在本 Gate 明确批准的一次 Web-only 重启触发真实异常时，允许精准 `docker stop --time 30 <已核实同一Web容器ID>` 作为本项目自有服务止损，保持 Postgres/Redis 和全部数据卷原样；不要关闭 Docker Desktop/WSL、停止其它容器、删除数据库或执行 down/prune。无异常且稳定时保持运行。Web 再次启动前先确认原有运行路径/原镜像可重入。重启可能导致当前 Demo 会话暂时断开，这是允许的小范围副作用；不被视为真实身份重新开通。

## OWNER_ONLY_ACTIONS

NONE。Owner 已批准继续**本机** Velobase 实验与必要的普通项目内技术处置，Reviewer 将权限限定为确证 Web 无响应后一次 Web-only 重启。Owner 不需再批一次、提供密码、添加账户或支付费用。任何需要数据库结构修改、镜像重建、Docker Engine/WSL 全局维护或外部服务的动作，必须另行评价。

## REVIEWER_TO_EXECUTOR_RELAY

你是 Owner Windows 本机 Codex，当前只执行 `main:saas-system/docs/G2L3_LOCAL_WEB_AFFILIATE_TARGETED_RECOVERY_GATE_20261018.md`。G2L2 的本地 Demo 登录、Dashboard、Admin 用户页面已验收，不再重做登录故障研究；**当前 HTTP 000 原因 UNKNOWN，且容器仍 running 并不证明 Web 端点健康**。先新鲜核实当前目标容器/镜像/卷/网络身份，比较 Windows curl.exe `--noproxy "*"` 与 Web 容器内 Node HTTP 的错误和耗时，收集最小脱敏 Next.js 与 Worker 日志；若两个独立路径均持续 Web 挂起，且原 auth-secret/两个 seed-marker 存在非空及 DB/Redis/旧项目状态安全，则仅允许一次对当前 Web 容器 ID 的项目独占 restart，不重新 build。之后稳定性复测并对 Affiliate 取一次错误类型和资格布尔分类。若是代理/端口转发故障不能据此重启 Web。只把脱敏结果写独立 G2L3 Evidence，停 Reviewer；不能改源码、扩大至 Docker/WSL 或 Provider，不操作旧三个容器。

## EXECUTOR_TO_REVIEWER_RELAY

请按 Governance §9 的短格式返回 `结果 / 改动 / 验证 / 问题 / 回滚 / 请 Reviewer 检查 / Owner 转交`；详细非敏感证据存在项目内 G2L3 独立文件。
