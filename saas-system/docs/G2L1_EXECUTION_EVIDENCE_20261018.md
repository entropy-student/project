# G2L1 本机 Velobase 恢复与页面验收执行证据

- GATE_ID：SAAS-G2L1-LOCAL-EXISTING-DEMO-RESUME-20261018
- 证据时间：2026-10-18 02:18 UTC（新加坡时间 10:18）
- EXECUTOR_RESULT：RETURN_LOCAL_DEMO_LOGIN_UI_MISSING
- Reviewer 状态：待审核；本报告不代表正式 PASS。

## 结果摘要

已复用原有本机 Velobase 容器、镜像、命名卷和网络，首页可通过 http://127.0.0.1:3003 访问。登录弹窗缺少 Gate 要求的本地管理员演示入口，因此本轮无法完成登录、Dashboard、Admin 正向权限和 Affiliate 登录后功能验收。保持应用运行供 Reviewer 查看；未触碰其他项目，未回滚。

## 本机与 Engine

- TARGET_LOCAL_PROOF：本机 PowerShell 读取 Windows 11 Home、build 26300；目标源码目录存在，Docker context 为 desktop-linux。
- DOCKER_DESKTOP_INITIAL_APP_AND_ENGINE_STATE：首次读取时 Docker Desktop 界面/后端进程正在运行，docker info 成功；Docker Engine 29.7.2、12 vCPU、7.397 GiB Engine 内存，Compose 5.4.0。
- OWNER_AUTHORIZED_SINGLE_DESKTOP_LAUNCH_ACTION_AND_RESULT：未启动；初始 Engine 已 ready，不需启动或重启 Desktop/Engine/WSL。
- SOURCE_SHA_AND_PATH：%USERPROFILE%/Documents/ChatGPT/Velobase-Harness-e88e259；HEAD 为 e88e259b974f883913f68ac74a9b8377765d005d；工作树未提交项 0；compose.demo.yml 与 Dockerfile.demo 均存在。
- 源码未修改；未执行安装、下载、pull、build、recreate、迁移或数据重置。

## 原实例与共享负载

- 原 saasvh-e88e259 的 web/postgres/redis 三个容器均存在；完整容器 ID 的 SHA-256 前 16 位指纹分别为 web 4BE5B7AFFF36FE03、postgres F4F494CD9A450D2F、redis F45BEA79449DB482。镜像指纹分别为 1552F1BBB39573BA、F0C30A6DA289390B、F5AFA6658AB11227；启动前均可本地 inspect 到镜像。
- 两个原命名卷 saasvh-e88e259_preview_data、saasvh-e88e259_demo_state 均存在；项目网络 1 个存在。Web 的命名数据卷、Postgres 数据卷及 Redis 现有匿名卷均未重建或清理。
- Web HostConfig 仅发布 3003/tcp 至 127.0.0.1:3003；Postgres 和 Redis 的 HostConfig 端口映射为空。
- ORIGINAL_WORKLOAD_BASELINE：历史 G2R1 报告的三个旧容器指纹在本轮当前完整容器 ID 指纹清单中未匹配到；一个同属历史脱敏 Compose 项目指纹的当前容器组包含 4 个 exited 容器。精确身份连续性及其变化原因 UNKNOWN。没有启动、停止、删除或调查这些旧容器。
- Velobase 启动前有 35 个非目标容器：34 exited、1 created、0 running。启动后状态集合的脱敏指纹仍为 5739654EEA88B1BF，计数不变；没有其他项目被启动或改变，所有其他项目原样保留。由于 Engine 首次检查时已经运行，本轮没有观察到 Desktop 启动过程。

## 运行操作与健康

- 2026-10-18 02:08:04 UTC：docker compose -p saasvh-e88e259 -f compose.demo.yml start postgres redis，退出码 0。
- 02:08:15 UTC：Postgres、Redis 均显示 healthy。
- 02:08:42 UTC：docker compose -p saasvh-e88e259 -f compose.demo.yml start web，退出码 0。
- 结束状态：web/postgres/redis 均 running；Postgres、Redis 显示 healthy；三容器 RestartCount 均 0，OOMKilled 均 false。
- 本机绕过默认代理后 GET / 返回 HTTP 200，响应约 0.16–0.19 秒；127.0.0.1:3003 由 Docker Desktop 后端监听。默认代理路径曾返回空响应，直连回环地址验证成功。
- Worker：Compose 运行配置为 SERVICE_MODE=web,worker；应用日志中“All workers and schedulers started”启动标记 1 次，最近 10 分钟未匹配到 worker/scheduler error、failed 或 fatal 行。Postgres/Redis 可用，Web 内有 Node 进程。未触发真实任务或外部业务，Worker 实际任务执行仍 NOT_TESTED。
- 最近一次 Docker OOM 事件查询为 0；Web 容器当前未重启、OOMKilled=false。

## 页面与权限矩阵

| 项目 | 结果 | 直接证据 |
| --- | --- | --- |
| Landing | PASS | 隔离的 Codex In-app Browser 显示标题 AI SaaS Framework、首页主标题及功能介绍；访问 http://127.0.0.1:3003/。 |
| 登录弹窗 | PARTIAL | 点击 Log in 后显示 Google、GitHub、Email 三种入口；没有 Gate 指定的本地管理员演示入口。未使用第三方账号，也未输入密码或 OTP。 |
| 本地管理员登录 | UNVERIFIED | 登录后曾确认浏览器已有 demo 会话，先执行应用 Sign out 并 reload；/api/auth/session 返回 JSON null。清除会话后登录弹窗仍缺少本地管理员入口。 |
| 用户 Dashboard | UNVERIFIED | 匿名 GET /dashboard 为 HTTP 200，但隔离浏览器未显示 Dashboard 内容；当前 session 为 null。 |
| 平台 Admin 正向 | UNVERIFIED | 无法通过缺失的本地管理员入口建立新演示管理员会话，未调用隐藏认证接口。 |
| Admin 匿名负向 | PASS（仅匿名范围） | 匿名 GET /admin 返回 307，Location 路径为 /；浏览器回到 Landing。 |
| 普通用户 Admin 负向 | UNVERIFIED | 没有安全可用的普通演示账号；未创建或伪造用户。匿名拦截不能代替普通用户角色权限反例。 |
| Affiliate | PARTIAL / UNVERIFIED | 匿名 GET /affiliate 返回 307 至 /；GET /account/affiliate 返回 200，但浏览器显示空白页和 Next.js “1 Issue”提示，未验收登录后功能或资格状态。 |
| Worker | PARTIAL | 运行启动标记和 Redis/Postgres 健康已验证；没有触发队列任务，业务执行未测试。 |

浏览器 DOM 快照和登录弹窗/空白 Affiliate 页面截图在本次执行会话中捕获；截图未作为二进制文件上传，以上矩阵提供可复核的 DOM、HTTP 和容器状态证据。

## 资源与隔离

- Windows 物理内存约 15.28 GiB；运行采样中可用内存约 0.44–1.75 GiB，结束采样约 0.99 GiB。该数字未作为固定拒绝门槛。
- 结束采样 Web 约 4.42 GiB（约 59.8% of Docker Engine memory）、CPU 约 0.08%；20 秒前一采样 Web 约 4.47 GiB、CPU 瞬时 71.23%，20 秒后内存略降。Postgres 约 62 MiB，Redis 约 18 MiB。
- Windows 系统盘剩余约 184.0 GB（171.4 GiB）。未观察到实际 OOM 或非目标容器状态变化。
- Web runtime 的安全配置读取显示 NEXT_PUBLIC_LOCAL_DEMO=on、NODE_ENV=development、AUTH_URL 为 loopback localhost:3003（无 userinfo）。但当前登录 UI 仍未渲染本地管理员入口。该差异的具体原因 UNKNOWN；客户端构建变量不匹配只是可能解释，未证实。
- REAL_STRIPE_OR_PAYMENT_ACTION_COUNT=0；未连接 Stripe、未创建支付、退款或佣金交易。
- SECRET_EXPOSURE_COUNT=0；未输出密钥、Cookie、完整容器 inspect、原始日志或其他环境变量。worker 日志仅计算匹配计数。

## 回滚与 Reviewer 检查

- ROLLBACK_EFFECT=NONE；未执行 stop。运行中的三容器、原源码、镜像、两命名卷、网络与 Redis 现有匿名卷均保留。非目标状态未改变。
- 当前访问地址：http://127.0.0.1:3003。演示保持运行供 Reviewer 复核 Landing 和登录入口。
- 如 Reviewer 后续要求回滚，只能使用项目限定命令：docker compose -p saasvh-e88e259 -f compose.demo.yml stop --timeout 30；不得停止 Desktop/Engine 或任何其他容器。
- 请 Reviewer 核对：本地管理员登录入口缺失与其运行配置差异、Dashboard/Admin 正向权限未验收、Affiliate 空白页问题、以及是否在新的 Gate 中允许修复客户端演示开关/重新构建。
- Owner 转交：NONE。