# MokerSaaS 页面 / 功能盘点 — 先了解全貌，再集中处理问题

> DATE: 2026-10-17
> METHOD: Static inventory from **ItusiAI/MokerSaaS** pinned upstream `c98f68c68de312cc1378130b96f82418e22bd5f3` plus G1X local Executor report; **not** an inspection of the 22 uncommitted local patches or a logged-in browser traversal.
> SCOPE: Existing separate disposable G1S lab `http://127.0.0.1:3077` only. No DB/source/Compose changes. No new Gate, no credentials or real Provider operations.
> PRINCIPLE: 先核对页面、内部标签、功能及登录权限；用户体验后集中收集 Bug，再决定改造和优先级。不要因为不能登录而误认为页面不存在。

## 0. 阅读方式和状态

- **SOURCE**：上游源码对应的页面或组件存在，但不表示本地完整功能已验证；22 个本地修改未逐行阅读。
- **G1X_SMOKE**：Owner 本机 Executor 曾直接读回相关 HTTP/API 的基础结果，Reviewer 不持有原始浏览器/HTTP 记录，不能推断完整 UI 或金融闭环 PASS。
- **LAB_DISABLED**：G1X LOCAL_LAB 禁用真实 Stripe、OAuth（仅 Credentials）、邮件发送、Cron、提现；按钮存在不代表真实交易可操作。
- **RESTRICTED**：需要 `user` 或 `admin` 授权。首页 HTTP 200 ≠ 用户/管理后台自动可访问。

## 1. 全部 18 个独立页面

| 层级 | 中文名称 | 本地路径（前缀 http://127.0.0.1:3077） | 主要功能 | 访问与限制 |
|---|---|---|---|---|
| 公开 | 营销首页 | `/zh-CN` | Hero、技术架构、功能演示、定价、工程验证、FAQ | 公开；G1X 首页 HTTP 200 |
| 身份 | 登录 | `/zh-CN/auth/signin` | 邮箱密码（Credentials）和会话 | 公开；G1X 曾测试登录/session，但 Owner 个人登录仍待验证；OAuth 本地禁用 |
| 身份 | 注册 | `/zh-CN/auth/signup` | 姓名/邮箱/密码、推荐码注册、注册赠分、邮箱验证 | 公开；G1X 仅验证过 signup HTTP 200；真实邮件抑制 |
| 身份 | 忘记密码 | `/zh-CN/auth/forgot-password` | 申请重置邮件 | 公开；本地邮件抑制，无法据此完成真实投递 |
| 身份 | 重置密码 | `/zh-CN/auth/reset-password` | 令牌重设密码 | 依赖有效 token，勿用随机构造 token 视为 PASS |
| 身份 | 邮箱验证 | `/zh-CN/auth/verify-email` | 令牌验证邮箱 | 依赖有效 token，本地邮件抑制 |
| 身份 | 认证错误 | `/zh-CN/auth/error` | 认证错误提示 | 仅辅助异常页面 |
| 用户 | 用户中心 | `/zh-CN/profile` | 身份状态、订阅、积分购买、积分流水、支付记录 | 需登录；本机 UI 待 Owner 实测；支付禁用 |
| 用户 | 推荐奖励 | `/zh-CN/referral` | 推荐码、关系记录、积分/订阅奖励明细 | 需登录及合成数据 |
| 用户 | 推广返利 | `/zh-CN/affiliate` | 推广码、推荐关系、佣金/收益/提现记录 | 需登录；实际提现本地 503 |
| 用户 | 支付成功页 | `/zh-CN/dashboard` | `PaymentSuccess` 展示 | **不是通用产品工作台**；不应当把它当 App 首页 |
| 管理 | 管理后台 | `/zh-CN/admin` | 统计、用户、流量、推荐、返利、邮件订阅、提醒、召回 | **需 admin 角色**；普通用户不能访问 |
| 法务 | 服务条款 | `/zh-CN/terms` | 服务条款 | 公开 |
| 法务 | 隐私政策 | `/zh-CN/privacy` | 隐私政策 | 公开 |
| 法务 | Cookie 政策 | `/zh-CN/cookies` | Cookie 政策 | 公开 |
| 辅助 | 邮件列表退订 | `/zh-CN/newsletter/unsubscribe` | 邮件订阅退订 | 有相应流程/令牌状态；禁真实发件 |
| 辅助 | 订阅提醒退订 | `/zh-CN/subscription/unsubscribe` | 关闭订阅到期提醒 | 令牌相关流程；禁真实 Cron/邮件 |
| 辅助 | 无权限 | `/zh-CN/unauthorized` | 无权限提示与返回 | 辅助页面，普通用户进 admin 时可能到此 |

> 英文默认 locale 可能不需要路径前缀；这里统一使用截图中当前的 `/zh-CN`。

## 2. 首页内部不是独立页面

`/zh-CN/#orchestration` 技术架构；`/zh-CN/#mission-control` 功能演示；`/zh-CN/#pricing` 定价（另有工程验证、技术 FAQ，需在首页滚动）。这些与营销首页同属一个页面，链接锚点不等于 SaaS 的实际业务功能。

## 3. 用户中心 4 个实际主标签（同一页面）

| 可直达路径 | 功能 | 本地情况 |
|---|---|---|
| `/zh-CN/profile?tab=subscription` | 当前套餐、到期时间、订阅状态、订阅管理 | 真实 Stripe/门户禁用 |
| `/zh-CN/profile?tab=points-purchase` | 积分套餐和购买控件 | 真实 checkout 禁用 |
| `/zh-CN/profile?tab=points-history` | 积分收支流水、分页 | 仅合成数据可验证 |
| `/zh-CN/profile?tab=payment-history` | 交易/支付历史列表 | 本地无真实支付记录 |

源码还有 `connected-accounts`、`account-status` 字符串列入 `VALID_SECTIONS`，但当前 `renderContent()` 没有为它们单独分支，默认退回订阅内容，**不能记为两个已经实现的独立工作台标签**。用户资料卡片、验证状态和账户信息嵌在用户中心布局之中。

## 4. 管理后台 9 个真实内容标签（都在同一 `/admin` 页面）

| 对应链接锚点 | 功能 | 本机验证程度 |
|---|---|---|
| `/zh-CN/admin#overview` | 用户/订阅/收入/积分/推荐/返利汇总及趋势 | SOURCE，admin 浏览器待测 |
| `/zh-CN/admin#traffic` | Umami 访问统计 | SOURCE，LOCAL_LAB 未配置真实 Umami |
| `/zh-CN/admin#users` | 用户查询、账号详情、积分/套餐/历史等管理 | SOURCE，已知非管理员 API 403 |
| `/zh-CN/admin#referral` | 推荐关系、注册奖励、推荐明细 | SOURCE，待合成数据演示 |
| `/zh-CN/admin#affiliate` | 推广佣金、关系、提现申请等后台流程 | SOURCE，真实提现本地禁用 |
| `/zh-CN/admin#newsletter` | Newsletter 订阅列表/统计 | SOURCE，真实邮件禁用 |
| `/zh-CN/admin#reminders` | 订阅到期提醒日志 | SOURCE，Cron/发件禁用 |
| `/zh-CN/admin#reengagement` | 沉睡用户分桶、筛选和分析 | SOURCE，待合成数据展示 |
| `/zh-CN/admin#reengagement-campaigns` | 召回活动、目标用户、发送记录等 | SOURCE，真实发送禁用 |

`#hash` 标签可以在首次打开后台时恢复所选模块，前提是该会话已经有有效的 `admin` 角色。源文件 `app/[locale]/admin/page.tsx` 调用 `requireAdmin()`；此前已禁用危险的匿名 `/api/admin/set-admin`。绝不可为体验而重新开放这个无鉴权提权接口。

## 5. 非独立页面，但已有对应业务 API / 实现

认证（注册、登录、验证、重置密码）；用户资料/关联账号；套餐/Stripe checkout、session、portal、webhook；积分余额与流水、消费；推荐码、奖励；推广码、佣金、提现；Newsletter 订阅；管理员用户/统计/流量/推荐/返利/提醒/沉睡用户/召回活动；到期提醒 Cron。**API 的存在不等于页面可用、支付真实可用或业务闭环验收通过**。

## 6. 用户眼下不能顺利浏览的两个原因

1. G1X Executor 确认一个合成 `user` 注册/会话烟测，但这**不等于 Owner 已拥有其邮箱密码**。Owner 自己登录失败尚未诊断。可以通过 `/zh-CN/auth/signup` 试建独立实验账号，当前 LOCAL_LAB 邮件抑制，不要发送真实邮件；登录逻辑以实际版本为准。
2. admin 后台拒绝普通用户，是权限设计正常运作；目前没有经确认交付给 Owner 的实验管理员账号。要实看九个 admin 标签，需**下一步另行进行范围受限的本地管理员体验身份准备**（只触碰 G1S synthetic account，绝不开放匿名提权 API/触碰 OLD DB）；这是访问准备而不是本轮修 Bug。

## 7. 下一阶段的先后顺序（本轮不执行）

A. 基于本清单在 Owner Windows 浏览器逐页访问，记录 HTTP/UI 结果，允许登录页、admin 和 token 页面标记 `AUTH_REQUIRED` / `TOKEN_REQUIRED`，不误报不存在。
B. 先解决 **Owner 实际能登录用户端、能以经过批准的本地专用 admin 身份访问后台** 两个入口问题，不修改任何全局鉴权策略；必要时专门生成两个非生产实验身份。任何凭证不存 GitHub/chat。
C. 在拿到所有可访问页面 UI 证据后按 P0 登录/权限、P1 页面与 API、P2 数据演示、P3 后续商业化平台适配 集中排期和修复，不对每个错误另开 Gate。
D. 对“通用 SaaS 模板”的最终评价，重点检查是否有 **可插拔业务工作台**；现有 `/dashboard` 只是支付成功页，而非可以直接替换不同 SaaS 核心功能的业务操作台。

## SOURCE POINTERS

- Upstream repo: https://github.com/ItusiAI/MokerSaaS/tree/c98f68c68de312cc1378130b96f82418e22bd5f3
- Actual route files: `app/[locale]/*/page.tsx`, `app/[locale]/page.tsx`; component files: `components/admin/admin-dashboard.tsx`, `components/profile/profile-info.tsx`, `components/referral/referral-page-client.tsx`, `components/affiliate/affiliate-page-client.tsx`, `components/home/home-page-client.tsx`.
- Lab state and smoke limits: `REVIEWER_HANDOFF.md`, `G1X_REVIEWER_ACCEPTANCE_2026-10-17.md`, `EXECUTION_EVIDENCE.md`.
