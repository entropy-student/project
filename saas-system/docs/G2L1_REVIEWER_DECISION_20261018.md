# G2L1 Reviewer 独立裁定｜2026-10-18

> GATE_ID=`SAAS-G2L1-LOCAL-EXISTING-DEMO-RESUME-20261018`
> REVIEWER_DECISION=`RETURN_LOCAL_DEMO_LOGIN_UI_MISSING`
> RUNTIME_RECOVERY=`PASS_CANDIDATE_ACCEPTED`
> UI_COMPLETE_PASS=`NO`
> CURRENT_RECOMMENDATION=`G2L2_DESKTOP_VIEWPORT_FIRST`
> REPORT_PROVENANCE=`OWNER_RELAYED_EXECUTOR_REPORT`

## 审核来源与证据等级

Reviewer 直接读取 `main:saas-system/docs/G2L1_EXECUTION_EVIDENCE_20261018.md`、当前 G2L1 Gate、唯一 Handoff、Governance v0.2.7，以及 Velobase 固定 SHA `e88e259b974f883913f68ac74a9b8377765d005d` 的认证和 Affiliate 页面源码。GitHub 执行证据中的 Windows/Docker/DOM/HTTP 观测属于**本机 Codex 通过 Owner 转交**，不是 Reviewer 登录 Windows 真机。浏览器截图虽在执行会话捕获，未作为独立文件提交，不能声称本 Reviewer 已实际检查截图。

## 正式判定

1. **环境恢复已达到 Gate 内的部分目标。** 执行报告确认原有 `saasvh-e88e259` 的三个容器复用成功、已有镜像/数据卷/网络保留，Postgres/Redis healthy，HTTP 首页 200，应用仍运行，3003 仅本机监听。Docker Desktop/Engine 在起始时已就绪，故没有执行新的 Desktop 启动。其他非目标容器本轮起止脱敏状态一致；三旧容器历史精确身份连续性仍 UNKNOWN。无支付、下载、build、Docker 全局变更或其他项目操作。
2. **功能 Gate 正式 RETURN。** 登录 UI 缺本地管理员入口，session 清理后依然缺失；无法走正常 UI 建立演示管理员登录，Dashboard/Admin 正例不成立。匿名 Admin 307 只证明匿名拦截；普通用户 Admin 负例未测试。Worker 有启动标记但无任务闭环。Affiliate /account/affiliate 空白 + Next.js "1 Issue" 未查实具体异常，不能计为功能 PASS。
3. **资源不是本轮 RETURN 的已证根因。** Web 约 4.42 GiB，主机可用约 0.99 GiB 是需关注的运行代价，报告中无本轮实际 OOM 或非目标容器状态变化；不恢复人为固定空闲 RAM 下限。

## 源码复查发现：先区分视口而非立即重建

- 固定 SHA `src/components/auth/login-modal.tsx` 使用 `useIsMobile()` 分流；`src/hooks/use-mobile.ts` 的阈值为 **768px**：小于 768 使用 `LoginModalMobile`，否则 `LoginModalDesktop`。
- `src/components/auth/login-content.tsx`（Desktop 使用）在 `login.localDemoEnabled` 为 true 时有 `handleLocalDemoLogin` 按钮；`src/components/auth/use-login.ts` 的开关为 `env.NEXT_PUBLIC_LOCAL_DEMO === "on"`，按钮调用 `signIn("local-demo", { callbackUrl: "/admin" })`。
- `src/components/auth/login-modal-mobile.tsx` 的 main 视图**确实没有相应本地演示按钮**，只包括 OAuth 和 Email 入口。由源码可证明这是响应式功能不一致，**尚不能证明 G2L1 浏览器采用了 Mobile 分支**，因为执行记录未给出 CSS viewport/分支身份。
- `compose.demo.yml` 提供 `NEXT_PUBLIC_LOCAL_DEMO: "on"`，G2L1 报告也已读取此服务环境，但 Next.js 客户端运行值或编译产物是否一致未证，不能预设修改 Docker 环境变量就能解决。
- `src/server/auth/config.ts` 在严格 `localDemoEnabled` 条件成立时注册名为 `local-demo` 的 provider；客户端按钮存在不等于认证成功，下一轮须实际走 UI 及受权路由。

## Affiliate 空白页边界

固定 `src/app/account/affiliate/page.tsx` 是受 session 保护的客户端页：未认证时 `useEffect` 会引导至登录路径，且页面依赖 `affiliate.getStatus`；未得结果/不满足资格时还含有 render 期 `router.push("/404")`。后者有潜在 React 导航副作用隐患，但本次未提供错误内容/堆栈，**不能断定它是此次“1 Issue”的真实成因**。先建立合规的 Demo 登录并记录该 Issue 的经脱敏错误类/调用栈，再决定是否需要应用层修补；不能以匿名请求的 200 响应判定 Affiliate 功能可用。

## 处置

- G2L1 判 `RETURN_LOCAL_DEMO_LOGIN_UI_MISSING`，**G2L1 结束，不复用原 Gate 增权修改应用**。
- **签发 G2L2**：在已经运行的原容器上先只读核验 CSS viewport、Desktop/Mobile 分支、应用可见的 provider 名单和客户端演示开关表现；优先用宽度 ≥ 1024px 的真正 Desktop 浏览器无源码变更重测登录。如出现按钮，仅通过合法可见 UI 登录 Demo、验证 Dashboard/Admin/Affiliate/Worker 与普通用户权限边界。
- 若 Desktop ≥1024 仍无演示入口，则抓取最小非敏感证据（客户端 vs 服务端开关/已发布 JS 的行为差异），定位唯一故障域后交 Reviewer，**不得直接触发全套重建、改 Secret 或走隐藏认证接口**。
- 已运行 Velobase 保留供 Owner/Executor 验证；安全异常或新其他负载回退时停止仅本项目服务；不重演历史三个旧容器事故，不修改 Stripe/Provider。
- 历史 G2 的资源回退原因保留 `CAUSE_UNKNOWN`。Open SaaS 和 Wave 按原串行次序 PENDING。

## 证据指针

- [G2L1 Executor Evidence](./G2L1_EXECUTION_EVIDENCE_20261018.md)
- [G2L1 原运行 Gate](./G2L1_LOCAL_EXISTING_DEMO_RESUME_GATE_20261018.md)
- [后续 G2L2 Gate](./G2L2_LOCAL_DESKTOP_AUTH_AND_UI_RECHECK_GATE_20261018.md)
- [当前 Handoff](../REVIEWER_HANDOFF.md)
- [Desktop / Mobile 分流源码](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/src/components/auth/login-modal.tsx)
- [Mobile 登录源码](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/src/components/auth/login-modal-mobile.tsx)
- [Desktop 登录按钮](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/src/components/auth/login-content.tsx)
- [Affiliate 路由源码](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/src/app/account/affiliate/page.tsx)
