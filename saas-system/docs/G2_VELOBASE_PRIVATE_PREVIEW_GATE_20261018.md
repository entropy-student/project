# SAAS-G2-VH-PRIVATE-DOCKER-PREVIEW-20261018

> STATUS=HISTORICAL_CLOSED / RETURN_EXISTING_WORKLOAD_REGRESSION
> PROJECT=`entropy-student/project` main:`saas-system/`
> GOVERNANCE=`entropy-student/spike.skill` main:`vps-project-governance/VNEXT.md` v0.2.7
> SOURCE_REPOSITORY=https://github.com/velobase/velobase-harness
> PINNED_SOURCE_COMMIT=`e88e259b974f883913f68ac74a9b8377765d005d`
> OWNER_DECISION=2026-10-18「内存不设为限制条件，继续推进」

## GATE_ID
`SAAS-G2-VH-PRIVATE-DOCKER-PREVIEW-20261018`

## OBJECTIVE
在 Owner 的真实 Windows 11 电脑上，**一次性实际启动和浏览 Velobase 全套原生演示**，核实首页、登录、本地演示管理员、用户 Dashboard、Admin 及 Affiliate 页面是真实可用应用而不是官网静态模板，验证 Web+Postgres+Redis 基础健康、资源足迹与业务项目隔离。最小目标是**先能打开看见**，不把 Stripe/裂变账本上线验收捆绑成同一 Gate。

## MAX_ENDPOINT_THIS_ROUND
仅在 `%USERPROFILE%\Documents\ChatGPT\Velobase-Harness-e88e259` **全新独立目录**中获取/检出 pinned upstream commit、项目范围安装/构建，并创建且启动**唯一新 Compose 项目** `saasvh-e88e259` 的 demo Web/Postgres/Redis；以 `http://127.0.0.1:3003` 检查非敏感页面、登录和 Admin 的可见性与权限负例。执行必要的项目内轻微兼容修正，最多**一次实质性修正+复测**，不得扩大到其他候选/服务器、永久系统设置或重构支付逻辑。已运行成功则保留项目实例供 Owner 查看，不自动关闭/清理；失败只停止本项目相关新进程/容器，数据与源码默认保留便于复核。**最终停在 Reviewer。**

## MANDATORY_REVIEW_STOP
`YES`：本轮只审一套演示，不授权转向 Open SaaS/Wave、云平台、VPS、公网部署、Stripe TEST/Live 付款、真实注册营销、退款、提款，亦不授权修改其他项目。固定 RAM 数值不构成独立 STOP；若确有 OOM/操作系统异常、现有项目健康回退、身份/卷/端口冲突或不可安全隔离则暂停并说明真实故障，不许用清理他人资源解决。

## TARGET_AND_SCOPE
- **Owner 真机**：G1 Owner 转交 Windows 11 Home Build 26300，PowerShell 7.6.5，非管理员；进入写入前由 Codex 原地复证。
- **唯一源码路径**：`%USERPROFILE%\Documents\ChatGPT\Velobase-Harness-e88e259`；它在 G1 时尚不存在。若现在出现，先只读分类来源/内容，绝不覆盖未知或非空目录；仅允许创建全新、明确属于此 Gate 的目录。
- **Compose project**：使用命令显式 `-p saasvh-e88e259` 选择 Demo，确保固定上游 `name: harness-demo` 不引发同名资源归属歧义。创建资源前先检查该 project、服务名、镜像/卷/网络均没有被其他人使用。固定 `compose.demo.yml`，不能调用无关的 `docker-compose.yml`。
- **私有端口**：仅 `127.0.0.1:3003`；数据库和 Redis 无宿主映射。确认无其他进程占用、Docker bind 非 `0.0.0.0`。不得在浏览器使用现有个人资料/登录会话。
- **构建及依赖**：Demo Dockerfile 固定 Node22/pnpm10.12.1；构建只生成新项目镜像/缓存。若没有 Docker Engine 正常运行，先调查，不启动/重装/修改共享 Docker Desktop 或设置。缓存允许本项目重用，禁止全局清理。
- **演示认证**：上游 Demo 创建本地专用认证数据及演示管理员，任何演示认证不得暴露到公网或与用户正式凭据混用；不回显生成的密钥或它的哈希。
- **数据**：仅新的 `saasvh-e88e259_*` 命名卷容纳 Demo Postgres/演示会话；无需真实 DB、S3、邮箱或账户。数据非生产，可恢复性的最小边界是记录新项目独有卷列表/隔离和准确启动版本。

## APPLICABLE_CRITICAL_CONSTRAINTS
当前 Owner 明确调整**仅限 Velobase 演示的资源决策**：**禁止把 1.12～1.55 GiB 当前空闲 RAM、8GiB 配置上限、Docker 7.4GiB 引擎总量或任意人工固定空闲 RAM 门槛当作启动前 RETURN 条件**。依旧采样并报告内存、CPU、Docker/磁盘和新进程实际占用；仅在**真实**资源分配失败/OOM、Windows 明显不稳定、现有业务健康回归失败等可观察故障时停止。不得因改变资源决策而修改 Governance、其他项目或系统安全要求。
Governance §0–10、§11A（Docker/卷隔离）、§11B（本机身份/Secret）、§11C（部署/端口/分层健康）、§11D（演示认证/自动行为）、§11E（本轮**不触发**真实 Provider 操作，仅保持支付隔离）、§12–13；项目隔离与安全要求均继续生效。

## PREFLIGHT
1. 读取此 Gate、Handoff 指定字段，核对当前 main 上的 Gate ID/Owner 范围，以及 pinned 上游 SHA、MIT License、Compose YAML/Dockerfile。使用锁定 commit 而非任意 moving main。
2. 刷新真实目标身份、权限、Git 与 Docker/Compose 可用性、3003 监听/映射、磁盘/资源动态情况；只把实际运行的资源结果作为阻塞依据，**不准按剩余 RAM 数字拒绝首次尝试**。
3. 将现有运行中容器、网络、绑定端口、目标目录和项目卷做只读脱敏基线；不得读取/输出现有容器环境变量、Secret 或完整原始日志。若存在未知同名 `saasvh-e88e259` 资源，停止写入并向 Reviewer 返回归属冲突，不执行收编/删除。
4. 在本机独立目录检出精确 SHA，证明 `HEAD`、实际构建上下文与指定 Demo 匹配；禁止全局包管理器、Node/pnpm 全局升级、系统 PATH 修改、Docker Desktop 全局设置更改或修改现有服务。
5. 以最小权限尝试本项目的 Demo Docker Compose。**首选**从新项目目录执行与 `docker compose -p saasvh-e88e259 -f compose.demo.yml up -d --build` 同语义操作。演示镜像会拉取公开依赖，须仅限本项目，不使用真实 Secret。
6. 若只因 Docker **配置声明的 8 GiB 上限超过 Docker Engine 接受范围**而直接拒绝创建容器，在保留原 YAML 的前提下，可在独立目录新增一个**项目专用覆盖文件**将 Web 容器上限调为引擎可接受值（如小于引擎 7.4GiB 的上限），记录精确值和原因后**最多重试一次**。这不是重新设置“空闲内存最低门槛”，只是容器资源上限兼容修正；不得调整 Docker Engine/WLS/全局内存或篡改其他容器。若实际 OOM/系统影响，则停在 Reviewer，不循环降配/重构。
7. 只使用本地演示账户，优先浏览首页、登陆入口、Dashboard、Admin、账户账单、Affiliate 入口；若某功能因无真实 Stripe 或演示用户不满足资格而不可用，标记 `PARTIAL` 而不是擅自真实付款/改资格或伪造 PASS。允许使用上游 Demo 固定种子数据，不允许真实个人身份和凭据进入系统。
8. 通过本地 HTTP 和适当浏览器 DOM/截图或路由/网络响应，验证至少：首页、登录、Dashboard、Admin；管理员和非管理员隔离分别做正/负例（若无法自然获得普通演示用户，不越权生成真人账户，记 `UNVERIFIED`）。健康证据分别记 Web HTTP、DB readiness、Redis readiness、worker/后台任务状态（如未提供健康接口，明确未知）；截图不得显示 Secret。
9. 采集新旧项目服务数量差异、端口绑定、进程/容器资源和可持续访问性、可复现的启动/停止方式。为了“可随时再次查看”，**成功时保持本项目运行**；退出后恢复方法只针对本项目，不影响其他容器。结束前复测原有 3 个运行中容器/关键服务健康无已知回退。
10. 若遇到一次明确可定位的项目兼容性问题，允许**一次**仅项目内、可回退的定向修复并复测；不更新上游仓库 `main` 或移植到其他项目。重复同类故障或缺乏可审证据时停止并报告实际失败，避免长时间盲目返工。

## REQUIRED_EVIDENCE
- `GATE_ID`, `OWNER_RESOURCE_OVERRIDE`, `SOURCE_COMMIT`, `SOURCE_LICENSE`, `TARGET_LOCAL_PROOF`, `PROJECT_PATH`、`PROJECT_NAME`、`COMPOSE_MANIFEST_AND_OVERRIDES`、`OWNER_SIDE_EFFECT_SCOPE`；
- `BEFORE_AFTER_CONTAINERS`、`PROJECT_OWNED_VOLUMES`、`PORT_BINDINGS`、`BUILD_AND_START_RESULT`、`REAL_RESOURCE_USAGE`、`EXISTING_WORKLOAD_REGRESSION`；
- `PAGES_MATRIX`（Landing / Signin / User Dashboard / Admin / Affiliate）、`ADMIN_POSITIVE_NEGATIVE_ACCESS`、`WEB_DB_REDIS_WORKER_HEALTH`、`RESTART_REPRODUCIBILITY`、`SCREENSHOT_OR_SUITABLE_REVIEWABLE_UI_PROOF`；
- `PAYMENT_PROVIDER_CONNECTED=NO`, `REAL_PAYMENT_COUNT=0`, `STRIPE_TEST_ACTION_COUNT=0`、`NEW_EXTERNAL_PROVIDER_ACCOUNT_COUNT=0`，以及 `ROLLBACK_PLAN_STATUS` 和脱敏原始证据指针。
- 若出现不能安全输出的原始 Provider/应用日志，仅报告最小经过脱敏的错误阶段/错误类型，不复制 Secret 和用户数据。

## ACCEPTANCE_CRITERIA
1. 私有本机 `127.0.0.1:3003` 可持续提供上游真实应用，至少首页+登入+用户 Dashboard+平台 Admin 有可审核行为证据，而非单纯 200 空白页；Affiliate 页面若不能进入，应说明是演示资格/功能开关还是代码问题。
2. 访问边界无对外公网路由，普通用户不能取得 Admin 页面权限（若测试负例暂缺，**禁止宣称 Admin 安全验收 PASS**）。
3. 仅创建已声明的新源码/项目镜像/容器/命名卷与构建缓存；既有项目的应用/数据/网络/支付配置都未修改。资源实际采样记录完整；不使用空闲内存的预设数字做 FAIL。
4. 若不能通过，则必须能指出确切根因、已发生的项目写入/影响范围及准确继续/停止/项目内回滚方式，不把“低 RAM 数字”本身当原因。
5. Executor 仅报告 `PASS_CANDIDATE` 或准确 `RETURN_*`；**Reviewer 才能给正式 PASS**。未验证的支付/裂变/部分退款保持 `UNVERIFIED`，不因此阻断**仅 UI 演示**通过。

## ROLLBACK_STATUS_OR_PLAN
- 源码/工作目录：默认保留而非删除，以便下一步审核；如只构建一半，无需扩大清理。
- Demo 容器：必要时使用**仅** `docker compose -p saasvh-e88e259 -f compose.demo.yml [加项目内真实 override] stop`；若成功演示则保持运行，不自动 stop。
- Demo 数据卷：保持持久化，**不执行** `down -v`、Docker prune、系统级卷清理、数据库 reset/迁移到其他项目。
- 演示失败后外部服务无变化；停止后记录新容器状态与原有系统健康。源代码删除、卷删除、公网访问、生产支付须另一个明确 Gate。

## OWNER_ONLY_ACTIONS
Owner 已明确允许继续、取消预设 RAM 阈值。本 Gate 只要求将项目 GitHub 链接交给 Windows 本地 Codex；无需再做单项审批、无需提供管理员密码/Stripe Key/KYC、无需购买服务。首次真实付款、Stripe TEST Webhook 或对外部署都不在授权范围内。

## REVIEWER_TO_EXECUTOR_RELAY
你是 Owner Windows 11 本机 Codex Executor。先读当前 Gate 本文，`saas-system/REVIEWER_HANDOFF.md` 的 SYSTEM_MAP / CURRENT_GATE / CRITICAL_CONSTRAINTS，然后只核验与本次部署直接有关的源码/本机资源。已接受的 G1 SHA、许可证、官方 Demo 能力和已知风险无需重做整轮研究。**把固定剩余 RAM 下限判定废止**；仍执行实时健康监测、严格资源/安全隔离。按本 Gate 从验证 pinned SHA 到仅启动 `saasvh-e88e259` 和浏览本地 Demo 依次推进，完成/出现明确实质异常即停在 Reviewer。不要向 Owner 请求每一步批准；不得执行超范围外部账户/付款/其他项目操作。

## EXECUTOR_TO_REVIEWER_RELAY
按 Governance §9：`结果 / 改动 / 验证 / 问题 / 回滚 / 请 Reviewer 检查 / Owner 转交`，短格式；完整脱敏证据保存为项目内新 G2 execution evidence 路径或 Reviewer 可访问 GitHub 记录，不能只口头说“通过”。可用 GitHub 现有新建项目目录中的独立 `docs/` 留存非敏感验收信息，禁止提交生产 Secret 或源码外部副本。真实主机执行报告可以先交 Owner 转述；Reviewer 审阅后才更新 canonical Handoff。
