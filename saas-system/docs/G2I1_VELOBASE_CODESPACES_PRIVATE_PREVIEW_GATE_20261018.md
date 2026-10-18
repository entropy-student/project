# G2I1 — Velobase 独立 Codespaces 私有 UI 演示 Gate（2026-10-18）

> GATE_ID=`SAAS-G2I1-VELOBASE-CODESPACES-ZERO-BILLING-PRIVATE-PREVIEW-20261018`
> STATUS=`REVIEWER_READY / NOT_EXECUTED`
> TARGET=`PERSONAL_GITHUB_CODESPACE / ISOLATED_REMOTE_VM`
> OWNER_DIRECTION=`2026-10-18 CONTINUE; OLD_CONTAINERS_DEFER_RECOVERY`
> SOURCE=`velobase/velobase-harness@e88e259b974f883913f68ac74a9b8377765d005d`
> PAYMENT_SPEND_BOUND=`ZERO_ADDITIONAL_BILLABLE_SPEND`
> APPROVED_RUNTIME_CREATION=`CONDITIONAL_ON_VERIFIED_INCLUDED_QUOTA_AND_ZERO_PAID_SPENDING`
> MANDATORY_REVIEW_STOP=`YES`

## OBJECTIVE

以**完全不使用 Owner Windows 现有 Docker Desktop/Engine** 的方式，在 **GitHub 个人账户免费 Codespaces 配额内**使用一个独立云端开发环境，复用已固定、已构建过的 Velobase Demo 入口，实际验证 Landing、Sign in、本地演示管理员、用户 Dashboard、平台 Admin 授权边界、Affiliate 与分层健康。把**能够真实操作页面**作为第一验收目标；Stripe TEST、真实交易和佣金结算仍不在本 Gate。

本 Gate 不保证可用免费额度、机器规格、Docker-in-Docker 或端口代理能够工作。任何费用权限、额度不足或真实故障按精确原因 RETURN，不自动切换收费 VPS。

## MAX_ENDPOINT_THIS_ROUND

在 Owner 现有**个人 GitHub 账户**内，仅当已验证可用**免费计算与存储余量**、零新增收费且 Codespace 创建不会产生任何需购买或预充值的服务时，允许创建**最多一个**从 Velobase 公开上游仓库派生的短期 Codespace（优先选择可选 4 vCPU / 8 GiB；如该规格/余量不可用则 RETURN，不未经评审降规格反复试）；核实源码 SHA；仅使用此云端环境自有的 Docker/Compose 构建/启动 `web/postgres/redis` 和私有预览；如应用网页代理与演示认证的 localhost 源不兼容，允许只做同一 Codespace 范围的私有本地端口转发及**最多一次**非敏感、可回退的项目独立兼容性纠正（不绕过 Demo 的认证/环境保护），再验证并返回 Reviewer。

- 不在 Owner Windows 下载/启动 Docker、WSL 或其他服务；不停止/恢复旧三个容器，也不触碰本机 Velobase 历史数据卷和镜像。
- 不使用已有共享 VPS、DigitalOcean、Hostinger、其他项目 Docker/代理或已有支付账号。
- 不创建 GitHub Actions 工作流/预构建；不推送上游修改、不 fork、不改动其他 GitHub 项目。
- 不升级付费方案、增加付款方式、提高预算、购买云服务器或扩大免费额度消耗边界；**每次收费风险不确定时，停止在账户操作前**。
- 不公开转发端口，不引入 Demo 之外的第三方 Secret、邮箱或真人身份，不调用 Stripe TEST/Live / Webhook / AI Provider；不做真实交易或业务自动化。
- 最多一次 Codespace、一次正常固定源码构建/演示尝试和一次明确问题的定向复测。新增远端资源与作用域都要有脱敏记录。

## MANDATORY_REVIEW_STOP

`YES`。能浏览完整的 Landing、Signin、Dashboard、平台 Admin（正反授权）和 Affiliate，且完成持续短时健康采样/收集非敏感截图之后，停止在 Reviewer；没有完成任一关键项则标记 PARTIAL/UNVERIFIED，不能自称整体 PASS。不要因此自动转向 Open SaaS 或 Wave。即使后续环境免费也不允许转为持续线上服务或对外开放。

## TARGET_AND_SCOPE

- **账户**：Owner 的个人 GitHub 账户，必须先确认账户类型、Codespaces 资源归属、可用额度、当前用量、剩余免费计算和存储、预算/计费边界。只读页面即可，不要求输出账单身份或添加付款信息。其他组织付费资源不得占用。
- **源码**：只在一个新的 Codespace 内检出 `velobase/velobase-harness` 的固定 SHA `e88e259b974f883913f68ac74a9b8377765d005d`；检出前确认仓库与分支/HEAD，不能默默构建移动上游 `main`。不 clone `entropy-student/project` 大仓库来运行 Demo。
- **Demo**：固定上游 `compose.demo.yml`、`Dockerfile.demo`，显式 `-p saasvh-e88e259`；三服务 `web/postgres/redis`。Docker-in-Docker、Compose 命令、磁盘/端口可用性须在此 **Codespace** 内实证。
- **端口**：固定 Web 3003，Postgres/Redis 不向外转发；`Port Visibility = Private` 且验证 GitHub 身份认证。没有公开路由，没有公开 Webhook。注意私有 Codespaces 端口依然有互联网域名入口，只是受 GitHub 登录保护；不得称为物理离线或完全无互联网入口。
- **原生 Demo 来源约束**：`services/demo/start.mjs` 要求 `AUTH_URL=http://localhost:3003`，Compose 同样将 `AUTH_URL`/`APP_URL` 写死为 localhost。直接用 `https://<codespace>-3003.app.github.dev` 浏览会产生 origin/回调不匹配风险；应优先验证 **VS Code Desktop 或 GitHub CLI 认证端口转发至 Owner Windows 本地 `127.0.0.1:3003`**，使浏览器来源和 Demo 校验一致。不会为了远程域名而移除、绕过或篡改上游保护逻辑。若端口绑定的容器网络命名空间不支持该转发路径，则 RETURN 或仅做一轮独立非公开兼容修正，禁止转换为 `0.0.0.0` 公网监听。
- **数据/Secrets**：仅 demo 自动生成的非生产数据；Demo 管理员凭证/Seed 仅运行在该 Codespace 中，不输出 Secret/哈希/敏感原始日志；不创建备份到其他项目/仓库。记录可恢复性和停止后存储费用风险。

## APPLICABLE_CRITICAL_CONSTRAINTS

`entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 的 §0–10、§11 trigger scan、§11A（隔离/存储）、§11B（账户、远端目标身份与 Secret）、§11C（部署/端口/资源健康）、§11D（Demo 登录/Worker 非业务动作）、§11E（支付被禁止的边界）、§12–13；§11F 仅在后来明确授权删除/关闭环境时独立触发。当前不需要也不允许改变共享宿主、网络或项目管理规范。Owner 历史取消固定空闲 RAM 阈值，在新 Codespace 同样不以某个人工 RAM 下限替代实际健康；4vCPU/8GiB 是预选规格，而非最低需求证明。

## PREFLIGHT

1. 读取本 Gate 及 `saas-system/REVIEWER_HANDOFF.md` 的 SYSTEM_MAP / CURRENT_GATE / CRITICAL_CONSTRAINTS。固定源码和 G2 构建已接受，不重做 G1/G2 源码功能研究；来源文档在本 Gate 明确指定。
2. 先通过 GitHub 原生账户界面确认 **Codespaces 由个人账户计费**、本月个人剩余额度足够**一轮有限试验**、机器规格至少可用 4 vCPU/8 GiB、无付费超额风险。Free 账户文档基准 `120 core-hour + 15 GB-month`（不是用户当前剩余数值）；4 核每小时消费 4 core-hour。若账户有付款方式，先只读确认此产品超额预算确实为零且不会产生额外消费，否则 RETURN，不创建；绝不代 Owner 更新预算或付款设置。
3. 只创建单个新的 Codespace，不使用个人已有 Codespace/组织付费空间或共享 VPS。创建后立刻验证 Codespace 宿主身份、资源规格、剩余磁盘、仓库位置、目标权限和 Docker/Compose 是否正常；不跨主机借用 Docker socket。
4. 初次环境仅确认端口 3003 的私有端口转发能否形成**真实 Windows 浏览器 localhost:3003 → 已认证 Codespace → Codespace 端口**链路。测试用临时无敏感内容的单端口服务；先验证、不开始重构建。若依赖 GitHub CLI/VS Code Desktop 而当前机器不具备，可只在用户目录安装/使用**项目范围**工具且无管理员/全局配置风险时实施；否则 RETURN，不改动机器系统全局设置。
5. 从该 Codespace 的源码目录取 `git rev-parse HEAD` 并与固定 SHA 全值匹配；必要时仅在 Codespace 内安全 `git checkout --detach e88...`，前提是不存在未提交的唯一更改；否则 RETURN，不做 `reset --hard`。校验 `compose.demo.yml` 与 `Dockerfile.demo`，无外部 Docker 全局配置变更。
6. 运行期再读资源/端口/内存/已有容器情况；只使用该 Codespace 私有 Docker。使用显式 `docker compose -p saasvh-e88e259 -f compose.demo.yml up -d --build` 语义构建启动。若发生真实资源分配失败、网络不兼容、Codespace 存储压力或止损要求，停止仅此项目相关服务，保留记录。
7. 走一遍 Landing、Login local administrator、Dashboard、Admin 正例与普通用户负例（没有普通用户时记录 UNVERIFIED，不伪造）、Affiliate、账户等能打开的页面；同时独立采样 Web/DB/Redis/Worker 的分层健康。Worker 既然由 `SERVICE_MODE=web,worker` 配置，不应仅因 Compose 无独立 Worker service 就直接判缺失，需查进程/任务路径的可审结果，不执行真实业务事件。
8. 浏览器会话/截图仅含演示数据，不使用私人 Chrome Profile 访问受保护页面；若真实浏览器与 Demo 认证地址仍不兼容，按 Gate 最多一次非敏感、可回退的兼容修正/复测，保持源与测试实际构建候选身份对应。
9. 结束收集 Codespace 名称/资源/端口 visibility/计费剩余（仅必要非敏感元数据）、目标源码 SHA、Compose 健康、Dashboard/Admin/Affiliate 交互截图及差异、实际时长与资源占用；**结束演示时仅停止该 Codespace 计算，保留环境供 Reviewer 复查**。Codespace 停止后存储仍可能计费；若额度不足以保留则先停止计算并由 Owner 决定独立清理 Gate，不擅自删除唯一证据或账本。

## REQUIRED_EVIDENCE

`GATE_ID`, `TARGET_GITHUB_ACCOUNT_TYPE_AND_BILLING_OWNER`, `FREE_QUOTA_AND_UNBILLED_REMAINING_COMPUTE_STORAGE`, `ZERO_ADDITIONAL_SPEND_PROOF`, `CODESPACE_ID_SANITIZED_AND_MACHINE_TYPE`, `TARGET_REMOTE_IDENTITY`, `PINNED_SOURCE_COMMIT`, `COMPOSE_AND_SERVICE_SCOPE`, `PORT_VISIBILITY_AND_LOCALHOST_ORIGIN_MATCH`, `BUILD_START_RESULT`, `WEB_DB_REDIS_WORKER_HEALTH`, `UI_LANDING_SIGNIN_DASHBOARD_ADMIN_AFFILIATE_MATRIX`, `ADMIN_POSITIVE_NEGATIVE_TEST`, `REVIEWABLE_SCREENSHOTS_OR_DOM_EVIDENCE`, `REAL_RUNTIME_RESOURCES`, `ACTUAL_SPEND_DELTA`, `LOCAL_EXISTING_DOCKER_SIDE_EFFECT_COUNT=0`, `STRIPE_TEST_LIVE_TRANSACTION_COUNT=0`, `RESULT`, `RETURN_REASON_IF_ANY`, `END_STATE_AND_STORAGE_RETENTION`.

## ACCEPTANCE_CRITERIA

1. Codespace 属于被证明零额外付费的**个人**隔离试验，未影响任何旧 Docker 容器、共享宿主或支付账户。
2. 固定 SHA 在新环境构建/启动并能够通过认证的非公开通路在 Owner 浏览器里交互，至少 Landing/Signin/Dashboard/Admin 真实可用，普通用户 Admin 不可访问；Affiliate 路径给出可审页面/功能结果或明确缺失。
3. 分层健康独立证实，不能用首页 HTTP 200 替代登录、Admin 和 Worker 健康。
4. 原历史 G2 构建、RETURN 与 G2R1 CAUSE_UNKNOWN 不被改写；不能因本环境 UI PASS 推导 Stripe/部分退款/佣金可靠。
5. 没有新增收费、公开预览或外部真实交易；当前结束时有准确 Codespace compute stopped/存储保留状态与重入方式。
6. 未完成条件报告 `PARTIAL/RETURN`，只由 Reviewer 决定新状态。

## ROLLBACK_STATUS_OR_PLAN

只停止/关闭本 Gate 唯一新 Codespace 的计算，不触碰本机 Engine。云端临时卷/镜像、持久化和实际费用需实测；**停止计算不代表停止存储费用**。删除远端 Codespace/仓库分支/数据不是默认回滚，如需销毁由 Owner/Reviewer 另行核实是否只有可重建的 demo 数据及证据是否已持久化后独立 Gate 处理。对于当次生成的测试服务/临时文件，只能在确证其属于本轮且无唯一证据时局部停止/清理。

## OWNER_ONLY_ACTIONS

- 若 Codex/ChatGPT GitHub 连接不支持创建 Codespace，Owner 在个人 GitHub 已登录界面打开公开上游仓库 `https://github.com/velobase/velobase-harness` 的 **Code → Codespaces**，选择可用的免费 4 核规格并创建**最多一个**私有开发空间；只有在账单归属和零新增付费限制已核实时才能点创建，不要添加支付方式。创建后的 Codex 负责 Gate 规定的部署检查。
- 若未能证实零收费条件，报告 `RETURN_CODESPACES_QUOTA_OR_BILLING_UNKNOWN` 即可，本 Gate 不批准改开付费云主机。Owner 不需提供 GitHub Token、Stripe Key、密码或其他凭据。

## REVIEWER_TO_EXECUTOR_RELAY

你是本项目新 G2I1 受限 Executor，仅执行本文 Gate（不要回用历史 G2/G2R1）。Owner 表示三个旧容器可能是手动停掉的，并要求 SaaS 继续推进；我们仅把它们标记为`OWNER_DEFERRED_RECOVERY`，绝不声明此前退出因果已查明，也不触碰旧容器。必须先证实个人 GitHub Codespaces 零增量收费及资源配额，缺证据就 RETURN；然后最多创建一个隔离 Codespace，在其中锁定 `velobase/velobase-harness@e88e259b974f883913f68ac74a9b8377765d005d`，启动固定 Demo，并通过 Windows localhost 的认证私有端口转发真实验收 Landing/Signin/Dashboard/Admin/Affiliate 和分层健康。不公开演示、不付费、不进支付 Gate、不运行 Open SaaS/Wave。完成或遇到实际异常，停在 Reviewer，返回最小脱敏证据和资源最终状态。

## EXECUTOR_TO_REVIEWER_RELAY

按 Governance §9 固定简报：`结果 / 改动 / 验证 / 问题 / 回滚 / 请 Reviewer 检查 / Owner 转交`；详细非敏感 Evidence 写在项目内独立执行文件，不包含账号 Secret、原始日志或客户信息。

## RESEARCH_SOURCES (public, non-user-account facts)

- [GitHub Codespaces 官方免费额度与计费](https://docs.github.com/en/billing/concepts/product-billing/github-codespaces)
- [GitHub Codespaces 免费使用量限制](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-included-usage)
- [GitHub Codespaces 端口转发](https://docs.github.com/en/codespaces/developing-in-a-codespace/forwarding-ports-in-your-codespace)
- [GitHub Codespaces 端口安全](https://docs.github.com/en/codespaces/reference/security-in-github-codespaces)
- [GitHub Codespaces 默认 Docker-in-Docker](https://docs.github.com/en/codespaces/reference/allowing-your-codespace-to-access-a-private-registry)
- [固定上游 Compose 文件](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/compose.demo.yml)
- [固定上游 Demo 启动器](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/services/demo/start.mjs)
