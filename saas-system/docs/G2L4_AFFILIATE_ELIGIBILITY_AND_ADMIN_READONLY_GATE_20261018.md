# G2L4 — Affiliate 资格归类与现成后台功能读屏 Gate（2026-10-18）

> GATE_ID=`SAAS-G2L4-AFFILIATE-ELIGIBILITY-AND-ADMIN-READONLY-20261018`
> STATUS=`REVIEWER_READY / NOT_EXECUTED`
> TARGET=`OWNER_WINDOWS_LOCAL_CODEX / EXISTING_RUNNING_VELOBASE`
> FIXED_SHA=`e88e259b974f883913f68ac74a9b8377765d005d`
> AUTHORIZED_WRITES=`NONE_TO_SOURCE_DOCKER_DATABASE_OR_PROVIDER`
> MANDATORY_REVIEW_STOP=`YES`

## OBJECTIVE

不用重新安装、重启或持续重复浏览器错误采集。使用当前已通过原生 UI 登录的本机演示管理员，在其**真实现有 Demo 账户**只读判断 Affiliate 资格状态（禁止赋权/伪造订单），并实际打开上游已经实现的 **Admin Affiliate 佣金与提现管理页面**。结果必须区分“管理员没有个人推广资格，账户页按规则拒绝”和“有资格却发生独立代码/API 缺陷”。一个 G2L4 回合结束后让 Reviewer 明确评估 Velobase，而不是无限追加同类 RETURN。

Reviewer 直接读取固定源码，已证事实：
- `services/demo/seed.ts` 确保 `demo@harness.local` 演示管理员，但不直接授予推广支付/余额资格；
- `src/server/api/routers/affiliate.ts` 的 `getStatus` 使用 `totalPaidCents>=499`、`affiliateEnabledAt` 或佣金账户非零余额推导 `eligible`；`isAdmin` 自身不算个人推广资格；
- `src/app/account/affiliate/page.tsx` 在缺少 `affiliateStatus?.eligible` 时直接 render 中 `router.push('/404')` 与 `return null`，与空白+跳转兼容，但 G2L3 并未读得资格布尔，因此这不是经证实根因；
- `src/app/admin/affiliate/commissions/page.tsx` 和 `src/app/admin/affiliate/payouts/page.tsx` 有**独立管理员 UI**，无需个人推广资格即可通过合法管理员权限访问（仍要真机页面实测）。
- G2L3 Windows 禁代理和容器内 Web HTTP 均 200，**历史 HTTP 000 不再视为当前连续故障**；先不重启 Web。

## MAX_ENDPOINT_THIS_ROUND

仅允许：新鲜只读确认原 Windows 真机/固定项目/服务/原 Docker 镜像及 3003，使用现有已授权的隔离本地 Demo 管理员**浏览器 UI**查看 Admin Affiliate 佣金和提现列表，且为资格归类执行**一次针对固定本地演示账号的只读 DB 聚合查询**，只返回布尔资格状态、非敏感整数计数/区间，不返回真实或演示账号记录值、邮箱、交易详情、钱包地址、卡号、余额细节、Secret、Cookie、Token、完整 SQL 结果原始行。可观察当前浏览器的 `affiliate.getStatus` **只读 Query** 网络 HTTP status / `isError` / `eligible`，但不得直接调用 mutation 或保存响应正文。

禁止变更现有 Demo 用户、销售额、支付、退款、推广启用/资格、角色或佣金/提现；禁止构造伪造 Cookie/JWT、隐形登录 API、模拟购买、补种演示数据、执行写 SQL、Prisma 迁移、应用/容器源码热替换、`docker cp`、安装新工具、镜像 build/pull、容器 recreate/restart、全局 Docker/WSL/代理配置及 Stripe/Provider 行为。

## MANDATORY_REVIEW_STOP

`YES`。完成账户实际资格分类及两个管理员推广列表 UI 读屏就停止，任何已确认错误或没有能力安全确定的分类都作为候选评估结论交 Reviewer，**不直接进入更多同类诊断或软件修改**。服务身份漂移、明显资源风险、其他项目状态变化或未授权副作用停止；保留已有 Docker 资产。不主动关闭共享 Engine、旧业务容器或支付服务。

## TARGET_AND_SCOPE

- Owner Windows 11 Home；现有项目源目录 `%USERPROFILE%\Documents\ChatGPT\Velobase-Harness-e88e259`；仅 `saasvh-e88e259` 的原 Web/Postgres/Redis 容器，原 URL `http://127.0.0.1:3003`，固定 SHA `e88e259b974f883913f68ac74a9b8377765d005d`。
- 按 G2L3 Owner 本机证据，Web 镜像 ID `sha256:9ab2468decb483e8941b18ce99570a1cf51677b3bb4c0c11024c1d6ea79364ef`、三服务 running、DB/Redis healthy；没有 Web 重启。需要新鲜只读确认身份与 HTTP 200，这不是 Reviewer 的真机直接证明。
- 当前 Demo 的管理员由 `demo@harness.local` 初始化；只对该**已知明确的合成本地账号**进行脱敏资格聚合。**不得遍历其它账号**，不得展示表格中的真实/演示用户唯一标识、邮箱/姓名。
- 相关官方路径：`/admin/affiliate/commissions`、`/admin/affiliate/payouts`、`/account/affiliate`。后者属于个人账户功能，并不等同前两个平台后台模块。
- 用户已拒绝 Codespaces；不使用共享 VPS/外部 OAuth/邮箱或公开链接；历史三个旧容器属 Owner 延后恢复，不触碰。

## APPLICABLE_CRITICAL_CONSTRAINTS

遵守 GitHub `entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 通用 §0–10、§11 Trigger、§11A/B/C/D（共享 Docker、身份/演示账号、浏览器认证）、§11E 仅支付禁止边界、§12–13。此 Gate 仅只读，不带来用户/订单业务状态变更。管理员 UI 正例不等于普通用户权限负例 PASS。

## PREFLIGHT / EXECUTION

1. **目标与稳定性预检**：本机 Codex 验证真实 Windows、SHA/工作树、已有 Compose project/三个原容器的精确标签和 Image ID、命名卷、3003 只绑定回环；Postgres/Redis healthy。用一条 Windows `curl.exe --noproxy "*"` 的 HTTP GET 验证当前 Web 200，记录本次退出码/TTFB；无服务即 `RETURN_WEB_STATE_CHANGED`，不重启。
2. **只读确定合成 Demo 管理员的资格**：在已确认本项目独占 `harness_preview` 的既有 Postgres 容器内，允许只使用 `psql` 的只读 transaction（`BEGIN READ ONLY`，全程 SELECT、ROLLBACK），检查固定合成管理员是否实际存在、`isAdmin` 布尔、累计支付是否达 499 cents、`affiliateEnabledAt` 是否非空、本人是否有 AffiliateAccount 及是否存在非零可用/待结/锁定余额。根据本地实际 Prisma 映射做最小的查询，**只输出 5–8 个布尔和整数统计**，禁止整行、列表、邮箱/PII/任何余额数值原样输出，禁止访问其它用户记录。查询前证明它是该 `saasvh-e88e259` 专属 Demo DB 而非共享/生产 DB；如无法确证就不要执行 SQL，记 `QUALIFICATION=UNVERIFIED`，继续做官方 Admin UI 只读。
3. **同源真实应用资格交叉核验（有界）**：保持官方正常 UI 的 Demo 管理员会话，用浏览器 DevTools **只筛选此应用同源的 `affiliate.getStatus` query 元数据**；只记录 HTTP 状态与 `eligible`/error 布尔（如可通过 UI/DevTools 无敏感字段地得到），不得导出 Cookie、原始响应 JSON、钱包/余额字段或账号信息，不强求无法安全捕获的客户端内部状态。若 API 真实响应分类与只读 DB 事实矛盾，只标 `ELIGIBILITY_DISAGREEMENT` 并 STOP，在证据中记录相矛盾的布尔，不修改业务逻辑。
4. **官方 Admin Affiliate 两页读屏**：同一原生已认证管理员浏览器上下文，依次访问 `/admin/affiliate/commissions` 和 `/admin/affiliate/payouts`。对每页核实页面标题/列表或清晰空状态、分页/筛选 UI 的可见性、正常/错误显示，记录最小无敏感 DOM 或去识别截图。**不点任何操作菜单里的状态修改/批准/完成/付款**；管理员佣金/提现相关数据仅报告是否有行与粗略记录数、状态文字类别，不复制用户、交易/钱包详情。
5. **个人 Affiliate 结论（最多一次）**：若 DB+API 表明 `eligible=false`，当前个人推广账户跳转是业务限制的**候选预期行为**，源码 `router.push('/404')` 在 render 中可能造成粗糙空白体验；该页面不记为完整 Affiliate 功能 PASS，但也**不要虚构代码崩溃**。若 `eligible=true` 或 API 报错且页面仍空白，分类为更窄的 `ELIGIBLE_BUT_PAGE_BROKEN` 或 `AFFILIATE_STATUS_QUERY_ERROR`。如果浏览器打不开或查询不可审，分类为 `UNVERIFIED`，不要反复触发登录/导航尝试。
6. **完整状态与退出**：在最后只读检查本项目 Web/DB/Redis、主机资源、非目标容器前后脱敏状态（补足 G2L3 缺失的结束快照）。如本轮出现新真实异常，按规范仅对本项目止损，保留共享 Engine/旧容器/镜像与卷。结果另存独立文件 `saas-system/docs/G2L4_EXECUTION_EVIDENCE_20261018.md` 并报告 Reviewer，不自行封板或进入 Open SaaS。

## REQUIRED_EVIDENCE

`GATE_ID`, `TARGET_WINDOWS_SOURCE_SHA_COMPOSE_IMAGE`, `FIRST_WEB_HTTP_NO_PROXY`, `DB_ISOLATION_PROOF`, `DEMO_ADMIN_ELIGIBILITY_BOOLEANS`, `AFFILIATE_QUERY_HTTP_STATUS_AND_BOOL_IF_SAFE`, `EXPECTED_ELIGIBILITY_CLASSIFICATION`, `ADMIN_AFFILIATE_COMMISSIONS_UI_DOM_STATUS`, `ADMIN_AFFILIATE_PAYOUTS_UI_DOM_STATUS`, `ACCOUNT_AFFILIATE_SINGLE_VISIT_CLASSIFICATION`, `ORDINARY_USER_ROLE_NEGATIVE=UNVERIFIED_UNLESS_TESTED_NORMALLY`, `WORKER_REAL_QUEUE_JOB=UNVERIFIED`, `END_WEB_DB_REDIS_HEALTH`, `RESOURCE_SAMPLES`, `OTHER_CONTAINER_BEFORE_AND_AFTER`, `SECRET_PII_EXPOSURE_COUNT=0`, `DATABASE_SOURCE_DOCKER_MUTATION_COUNT=0`, `PAYMENT_PROVIDER_ACTION_COUNT=0`, `RESULT`.

## ACCEPTANCE_CRITERIA

- Admin Affiliate 平台页面实际呈现/受限有实质证据，个人推广账户的已知资格有只读的权威布尔或明确标记 UNVERIFIED，不使用管理员角色作为付费资格代理。
- 至少把“资格限制 / API 返回错误 / 已有资格但 UI 渲染失败 / 仍不可确定”划入一个**可审的互斥类别**，并明确 Affiliate 功能成熟度（能否评价），不再泛称 Next.js 1 Issue。
- 原有 Web/DB/Redis/隔离和 G2L2 UI 已通过结果不回退；本轮非目标容器前后状态完整证明，无业务写操作。
- 不把 Admin 佣金列表可见性当成真实支付/推广佣金结算/退款回撤通过；不把普通用户权限或 Worker 当作已经验收。

## ROLLBACK_STATUS_OR_PLAN

本轮源代码、DB、镜像、容器、网络、端口和权限均无授权更改，预计 `ROLLBACK=NOT_NEEDED`。如果检查意外揭示真实用户数据/共享数据库的可能性，立即停止 SQL/浏览器进一步访问，仅记录不含敏感数据的目标身份问题。真实运行异常时仅允许项目自有服务止损，绝不操作其它项目/Engine/历史容器。

## OWNER_ONLY_ACTIONS

NONE。此前 Owner 已要求直接在本机继续验收，不需要再审批、密码、Stripe Key、云平台或购买资源。

## REVIEWER_TO_EXECUTOR_RELAY

你是 Owner Windows 本机 Codex，只执行当前 GitHub `main:saas-system/docs/G2L4_AFFILIATE_ELIGIBILITY_AND_ADMIN_READONLY_GATE_20261018.md`。G2L3 已证 Windows 禁代理与 Web 容器内 HTTP 同为 200，Web 不再需要重启；本地 Demo 管理员登录、Dashboard/Admin Users 在 G2L2 已通过，不再重复。固定源码已证 **管理员权限不赋予个人推广资格**，无资格时 `/account/affiliate` render 跳 /404；因此本轮要只读核实这名**合成管理员**的真实资格布尔，并用正常管理员 UI 打开 `/admin/affiliate/commissions` 和 `/admin/affiliate/payouts`。禁止绕过资格、修改账本/订单、重播种/镜像构建/源文件改写或真实支付。一次可审分类和两页实际 DOM 证据即完成，不要重复用通用 CDP 抓错循环；仍无法确定就明确 UNVERIFIED，停 Reviewer。脱敏 Evidence 写入新 G2L4 文件，完整记录其他容器前后状态。

## EXECUTOR_TO_REVIEWER_RELAY

遵循 Governance §9：`结果 / 改动 / 验证 / 问题 / 回滚 / 请 Reviewer 检查 / Owner 转交`，不要自行宣告整个 SaaS PASS。
