# G2L2｜本机桌面登录入口验证与页面验收（2026-10-18）

> GATE_ID=`SAAS-G2L2-LOCAL-DESKTOP-LOGIN-AND-UI-RECHECK-20261018`
> STATUS=`REVIEWER_READY / NOT_EXECUTED`
> TARGET=`OWNER_WINDOWS_LOCAL_CODEX / EXISTING_RUNNING_VELOBASE`
> SOURCE_SHA=`e88e259b974f883913f68ac74a9b8377765d005d`
> MAX_WRITES=`NO_SOURCE_BUILD_DOCKER_DATA_CHANGES; ONLY_LOCAL_BROWSER_DEMO_SESSION`
> MANDATORY_REVIEW_STOP=`YES`

## OBJECTIVE

不重新安装、构建、重启或修改任何容器，在已恢复的本机 Velobase 上**先识别当前浏览器是否误用移动端登录组件**；然后使用真实桌面浏览器和应用公开的本地演示管理员入口完成 Sign in → Dashboard → Admin → Affiliate 页面验收。若桌面入口仍缺失，仅取得必要证据锁定故障域，返回 Reviewer 制定一次最小修复，而不是盲目 rebuild。

**Reviewer 已直接核实的固定 SHA 源码事实**：`src/components/auth/login-modal.tsx` 根据 `useIsMobile()` 选择 Desktop/Mobile；`src/hooks/use-mobile.ts` 切换阈值 **768px**；`src/components/auth/login-content.tsx` 的桌面登录在 `login.localDemoEnabled` 为真时显示本地管理员按钮；`src/components/auth/login-modal-mobile.tsx` 没有该按钮。**尚不知 G2L1 自动化使用的实际 viewport**，不要据此未经复证修改镜像。查看[正式审核](./G2L1_REVIEWER_DECISION_20261018.md)。

## MAX_ENDPOINT_THIS_ROUND

只读探测现有 `saasvh-e88e259` 和 `http://127.0.0.1:3003`；允许一个新的、隔离的**桌面视口至少 1024 CSS px** 的浏览器会话，通过可见的官方本地演示按钮进行 Demo 登录、生成/结束本会话、操作非付费演示 Dashboard/Admin 的 UI（仅预览/非敏感读取，禁止影响持久化业务状态）并验证权限。可以记录无敏感的浏览器渲染 DOM、特征性截图、控制台错误类型、相关 HTTP 状态与受保护路由行为。

如果 Desktop 界面不出现入口，只做一次受控对比：确认 DOM 实际使用 Desktop 组件、浏览器 CSS 视口，匿名 `/api/auth/providers` 返回的 provider **ID 列表**是否有 `local-demo`，并读取**已经提供的** Docker 项目 Demo 环境开关元数据（仅 `NEXT_PUBLIC_LOCAL_DEMO=on/off` 及 `NODE_ENV` 是否 development；不得打印其他 env/Secret）与日志中相关去敏错误类型。不进行隐藏端点直接登录、伪造 Cookie/JWT、替换管理员角色、清理 session 数据、执行任何重置/种子/SQL。

**不批准**任何项目源码修改、安装、更新、镜像重建、Compose up/recreate、配置切换、完整容器重启、Docker Desktop/WSL 操作、其它项目操作、公网曝光、Stripe TEST/Live/退款/提现/佣金或外部 OAuth/Email/Provider。

## MANDATORY_REVIEW_STOP

`YES`。桌面 UI 演示/负例/静态健康完成后停止在 Reviewer，或遇仍无按钮/非敏感证据无法继续/Next.js 错误关键栈/现有业务状态回退时以具体 `RETURN_*` 结束；不擅自扩大到服务器、自动修复或下一候选。应用当前正运行，如果健康且本轮无实质风险则保持供 Owner 体验；若本轮引起真实资源异常，只允许停止 Velobase 实验项目，绝不操作其他 Compose 或整个 Docker Engine。

## TARGET_AND_SCOPE

- Owner Windows 11，历史 `%USERPROFILE%/Documents/ChatGPT/Velobase-Harness-e88e259`，唯一 Compose `saasvh-e88e259`，Port `127.0.0.1:3003`。
- 历史 G2L1 报告：Postgres/Redis healthy；Web running，Worker 有启动日志标记；无其他工作负载变化；这些是 **OWNER_RELAYED_EXECUTOR_REPORT**，下一轮须新鲜只读确认，不是 Reviewer 的实时宿主直接读回。
- 测试浏览器使用全新/隔离 profile 或 Codex In-app Browser；不用用户个人 Chrome 账号资料。CSS 视口至少 1024px，实际通过 `window.innerWidth`、`matchMedia('(max-width: 767px)')` 和 DOM 表面验证，但不发送任何敏感浏览器信息。
- `src/server/auth/local-demo.ts` 的后端使能同时要求 `NEXT_PUBLIC_LOCAL_DEMO=on`、development、AUTH_URL 为 loopback；服务端 provider 列表只暴露名字不认证，不假设客户端登录按钮和服务端 provider 一定同步。
- `/account/affiliate` 依赖已认证 session 和 `affiliate.getStatus`；匿名页面空白不能替代正式业务验收。原报告中 "Next.js 1 Issue" 的文字及异常类型未知。先在 Demo 已认证下复现，收集安全精简的错误类型/错误位置。
- 非目标 35 容器 G2L1 前后状态相同，但历史原三个容器身份延续未证；本轮不触碰、不追查退出因果。

## APPLICABLE_CRITICAL_CONSTRAINTS

Governance `entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 §0–10、§11A/B/C/D，§11E 仅用于排除支付动作，§12–13；本机目标身份/数据/Secret/共享 Docker 边界保持。Owner 已撤销固定空闲 RAM 事前门槛，但真实 OOM/其他项目回退必须停止。

## PREFLIGHT / EXECUTION

1. 只读取本 Gate 与 `REVIEWER_HANDOFF.md` 的 SYSTEM_MAP、CURRENT_GATE、CRITICAL_CONSTRAINTS；静态源码事实与 G2L1 有界执行结果可直接依本 Gate 和 [正式审查](./G2L1_REVIEWER_DECISION_20261018.md) 接受，不重做源码研究。
2. 新鲜只读核对 Owner Windows 本机、目标源码 SHA（不更改 worktree）、已有三个 Velobase 容器/服务与端口、健康和其它当前 running 负载的脱敏基线。不因 Desktop 初始正常就主动重启。如果原 Web 不可访问/服务身份变化，RETURN，不使用本 Gate 恢复服务或重建。
3. 先记录 G2L1 自动化浏览器的 viewport **如同一执行会话仍可读取**；若不可得，记录 UNKNOWN，不能虚构历史宽度。创建独立桌面浏览器上下文，设置 ≥1024 CSS px，使用 `127.0.0.1:3003` 直连（不经过系统默认代理），新 session 为空，打开登录弹窗。先保存非敏感 DOM、viewport、Desktop/Dialog 或 Mobile/Drawer 的分支特征。
4. 若出现`Explore as local administrator`/中文同义按钮，**直接点击可见按钮登录**，通过匿名到已登录的会话及 `/admin` 页面 DOM/真实表格核验。随后访问用户 Dashboard、Admin 的适量只读页面（例如用户列表/套餐配置可见性），不触发管理写操作；如有可经正规 UI 登录的普通演示用户，可测普通用户 Admin 负例，否则记 UNVERIFIED；匿名 Admin 负例可复用先前证据并按需重新测试。
5. 登录成功后再测试 `/affiliate` 与 `/account/affiliate` 的导航、资格提示、功能 UI；不点击提现、佣金申请或激活伙伴账本按钮。若出现 Next.js Issue，收集仅错误类别、受影响组件/顶层安全栈、用户可见消息，不泄漏请求/response body、Cookie、邮箱等。
6. Worker 仅复核健康标志、无风险错误计数与必要进程状态，不触发业务任务；同时抽样 CPU/内存、其他工作负载前后变化。
7. 如果桌面宽度仍缺本地管理员按钮，不直接调用 `signIn('local-demo')` 或任何隐藏认证 API，仅记录 Desktop/Mobile 分支、`/api/auth/providers` 的允许公开 provider ID 列表及 `NEXT_PUBLIC_LOCAL_DEMO` 是否 on 和 `NODE_ENV` 是否 development；静态代码/运行时 client env 差异为候选根因，未被证实前保持 UNKNOWN。返回 `RETURN_DESKTOP_LOCAL_DEMO_ENTRY_MISSING`。
8. 结果通过 Owner 转交 GitHub `saas-system/docs/G2L2_EXECUTION_EVIDENCE_20261018.md` 给 Reviewer；不直接修改 `REVIEWER_HANDOFF.md`，不自行设下轮 Gate，保留当前 Web 运行（除真实异常）。

## REQUIRED_EVIDENCE

`GATE_ID`, `TARGET_LOCAL_PROOF`, `SOURCE_AND_RUNNING_IMAGE_IDENTITY`, `G2L1_VIEWPORT_IF_RETRIEVABLE`, `NEW_BROWSER_CSS_VIEWPORT`, `DESKTOP_OR_MOBILE_DOM_PROOF`, `LOGIN_BUTTON_VISIBILITY`, `AUTHORIZED_UI_LOGIN_RESULT`, `AUTH_PROVIDER_IDS_WHEN_NEEDED`, `DEMO_FLAG_METADATA_ONLY`, `DASHBOARD_ADMIN_POSITIVE_NEGATIVE_RESULT`, `AFFILIATE_UI_AND_ERROR_CLASS`, `WEB_DB_REDIS_WORKER_HEALTH`, `RESOURCE_AND_OTHER_WORKLOAD_BEFORE_AFTER`, `NO_SOURCE_IMAGE_DOCKER_DATA_MUTATIONS`, `NO_PAYMENT_PROVIDER_ACTIONS`, `END_STATE`, `RESULT`, `REVIEWABLE_SCREENSHOT_OR_DOM_PROOF`.

## ACCEPTANCE_CRITERIA

- 在≥1024px桌面浏览器通过正常 UI 建立新本地管理员演示登录，Dashboard/Admin 有真实页面行为证据，Admin 非管理员权限负例在可能条件下明确测试或保留 UNVERIFIED，不能以匿名拦截冒充普通用户权限验证。
- Affiliate 登陆后能看到明确功能/资格 UI 或可复现、可归类错误；Worker、Postgres、Redis 分层运行健康与非目标容器状态差异已记录；不存在新共享负载回退。
- 不下载、不修改、不重建、不重启项目/共享环境，不操作任何外部 Provider/支付/真人账号。
- 若桌面宽度也无本地体验按钮，形成可审的视口、provider ID/环境开关判别结果并精确 RETURN，**这本身完成本轮诊断端点，不需要反复重试**。

## ROLLBACK_STATUS_OR_PLAN

本 Gate 只产生非敏感 Demo 浏览器会话，不修改数据库/镜像/项目运行状态；可退出/登出本次 Demo 浏览器 profile。真实系统或其它项目异常时只精确停止 `saasvh-e88e259` 的实验容器并保留所有卷/镜像/网络，不能停 Docker Desktop/Engine、删除卷或改变其他项目。正常结束保留应用运行。

## OWNER_ONLY_ACTIONS

NONE。Owner 仅需将 GitHub Gate 链接交给本机 Codex，已有部署无需人工重装、付费、下载或额外密码。Codex 自行完成安全检查与浏览器验收。

## REVIEWER_TO_EXECUTOR_RELAY

你是 Owner Windows 本机 Codex，仅执行 GitHub `main:saas-system/docs/G2L2_LOCAL_DESKTOP_AUTH_AND_UI_RECHECK_GATE_20261018.md`，已接受 G2L1 本机恢复成功而 UI 因没有本地管理员按钮 RETURN 的事实。固定 Velobase SHA 的 Desktop 登录源码**有**本地 Demo 按钮，Mobile 登录源码**没有**；切换阈值 768px。当前只用既有运行容器，在独立浏览器上下文设定 CSS viewport≥1024px，经正常可见 UI 登录本地演示管理员并检查 Dashboard/Admin/Affiliate 和分层健康。若 Desktop 仍缺按钮，就只读比较 DOM 分支、公开 auth provider ID 和 Demo 开关，拿到有用证据后 RETURN；不改代码、不 rebuild、不清数据库、不重启 Docker/旧项目、不进行 Stripe/Provider 操作。结果附脱敏证据写在独立 G2L2 Evidence，停 Reviewer。

## EXECUTOR_TO_REVIEWER_RELAY

按 Governance §9：`结果 / 改动 / 验证 / 问题 / 回滚 / 请 Reviewer 检查 / Owner 转交`。不要直接把 Executor 的 PASS_CANDIDATE 当 Reviewer 结论。
