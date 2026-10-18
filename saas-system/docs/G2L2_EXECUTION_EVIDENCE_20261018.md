# G2L2 本机执行证据（2026-10-18）

## 执行结论

- GATE_ID: SAAS-G2L2-LOCAL-DESKTOP-LOGIN-AND-UI-RECHECK-20261018
- RESULT: RETURN_AFFILIATE_BLANK_AND_WEB_HTTP_EMPTY_REPLY
- 按 G2L2 停在 Reviewer；不继续修复、重建或恢复服务。

## 目标与版本证明

- 执行时间：2026-10-18 03:56–04:03 UTC；Windows 11 家庭版，目标目录为 %USERPROFILE%/Documents/ChatGPT/Velobase-Harness-e88e259。
- 本地源码 HEAD：e88e259b974f883913f68ac74a9b8377765d005d，与 Gate SOURCE_SHA 一致；git status --short 为空。
- Docker Engine 29.7.2；Compose 标签 5.4.0。saasvh-e88e259 现有 web、postgres、redis 三个容器均 running。
- Web 容器使用 tag saasvh-e88e259-web；容器实际 Image ID 与该 tag 当前 Image ID 相同：sha256:9ab2468decb483e…；Compose image 标签记录为 sha256:88bb7e47c5fe9442…，与实际 Image ID 不同。此标签差异是本轮只读发现，未更改；需 Reviewer 判断是否为陈旧元数据。
- 端口映射仍为 127.0.0.1:3003。G2L1 当时浏览器 viewport 无历史可读证据，本轮记 UNKNOWN。

## 桌面登录与 UI 验收

- 使用新的 Codex In-app Browser 标签；CSS viewport 1280×900，window.innerWidth=1280，matchMedia('(max-width: 767px)')=false。登录弹窗为 Desktop 分支，显示按钮“以本地管理员身份体验”。因此未读取 Auth provider ID 或 NEXT_PUBLIC_LOCAL_DEMO/NODE_ENV 元数据（Gate 的缺按钮分支条件未触发）。
- 正常点击可见的本地管理员按钮后，浏览器进入 /admin/users；页面可访问性 DOM 显示 Local administrator、管理员徽标，用户管理页标题、筛选/搜索控件、表格及分页控件；表格报告 33 条记录。证据仅保留 UI 结构与计数，未转存姓名、邮箱或记录 ID。
- 已认证 Dashboard：/dashboard 页面显示“欢迎回来，Local administrator”、概览、资料、账单、设置及管理员快捷入口；标题与内容 DOM 可见。
- Admin 正例：/admin/users 已加载真实用户表格，管理员徽标可见；本轮只读，不点击行操作、写入控制、筛选/搜索或分页。
- 普通用户访问 Admin 的负例：UNVERIFIED。本轮没有已提供的普通用户凭据或本地普通用户登录 UI；未猜密码、未使用 Email/OAuth。匿名 /admin 曾在 G2L1 证据中 307 回首页，本轮未重复，不能替代普通用户权限测试。
- /affiliate 导航回到 /。/account/affiliate 首次观测时 URL 为该路径但 body 无可见文本、标题或按钮；随后页面回到 /。安全化浏览器日志只表明 Next.js console-error 拦截器记录过 affiliate 相关错误，错误类、组件/安全栈均未能从日志中确认，记 UNKNOWN。未点击推广激活、佣金、提现或支付控件。

## 服务、Worker 与资源

- 03:56:53 UTC 基线：web 约 4.369 GiB、0.15% CPU；Postgres 61.63 MiB；Redis 15.9 MiB。宿主可用 RAM 0.94 GiB / 总计 15.28 GiB。
- 04:00:37 UTC 抽样：web 约 5.208 GiB、CPU 289.77%；Postgres 63.12 MiB；Redis 15.89 MiB；宿主可用 RAM 0.97 GiB，Windows CPU load 37%，C 盘可用约 174.6 GiB。
- 04:01:02 UTC 复采：web CPU 回落至 0.02%、内存约 5.064 GiB；容器仍 running，restart count=0、OOMKilled=false。未观察到宿主内存耗尽证据。
- Web 无 Docker healthcheck；Postgres 与 Redis health=healthy。三个目标容器 restart count 均为 0、OOMKilled 均为 false。3003 仍有本地监听，但 04:00 后至少三次对 http://127.0.0.1:3003/ 的只读 curl 均为空响应，HTTP 状态显示 000。该连通性异常的根因 UNKNOWN；不能将其描述为当前健康。
- Docker 中运行容器总数为 3，全部是目标项目；其他项目当前 running=0。非目标容器状态计数前后均为 created=1、exited=34，本轮未发现状态差异。
- Compose 状态仅显示 web/postgres/redis；无独立 worker 容器。web 有 Node 进程匹配（docker top 返回 8 行、其中 6 行匹配 node）；最近抽样日志（最多 2,500 行 / 2 小时）未捕获 Worker 启动标记或 Worker 错误模式（各 0 次）。这不足以证明队列消费正常，Worker 功能状态记 UNVERIFIED。

## 改动、支付、回滚与 Reviewer 请求

- 未改源码、镜像、容器、Compose、网络、数据卷、数据库业务记录或其他 Docker 资源；无安装/下载/构建/重启/停止/清理操作。唯一应用状态动作是 Gate 授权的本地管理员演示登录；其余页面操作为只读导航。
- 未访问 Stripe 或其他外部 Provider，未进行支付、退款、佣金或提现操作；未读取、记录或输出 Secret/Cookie/客户字段。
- END_STATE：web/postgres/redis 仍 running；Postgres/Redis healthy；所有镜像、卷、网络保留，无回滚。浏览器演示会话留在本机 In-app Browser 供复核；未登出，因为服务的当前 HTTP 请求无响应。
- 请 Reviewer 检查：桌面登录与 Dashboard/Admin 正例可通过；Affiliate 空白和当前 Web HTTP 空响应需审查；错误类别、普通用户权限负例、Worker 队列健康，以及 Compose image 标签差异保持 UNKNOWN/UNVERIFIED。除后续明确 Gate 外不扩大操作。