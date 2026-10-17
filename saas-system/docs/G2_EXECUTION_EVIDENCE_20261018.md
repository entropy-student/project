# G2 Velobase 私有演示执行证据（2026-10-18）

## 结论

**PARTIAL / STOPPED，待 Reviewer 审核。** 固定源码构建成功，Postgres、Redis 曾通过健康检查，首页曾返回 HTTP 200。运行期间观察到启动前的三个既有容器全部退出。按 G2 Gate，仅停止本次项目并保留其源码、镜像、卷和网络；未继续 Dashboard、Admin、Affiliate 功能验收。退出原因与本次演示之间的因果关系未确认。

## Gate 与源码

- Gate：`SAAS-G2-VH-PRIVATE-DOCKER-PREVIEW-20261018`
- 上游：`velobase/velobase-harness`
- Reviewer 指定且由 GitHub 插件独立确认的 commit：`e88e259b974f883913f68ac74a9b8377765d005d`
- 许可证：MIT
- 本地目录：`%USERPROFILE%/Documents/ChatGPT/Velobase-Harness-e88e259`
- Git HEAD 与指定 SHA 一致；部署前工作树干净。
- 使用 `compose.demo.yml` 和 `Dockerfile.demo`；没有使用通用 Compose 文件或覆盖文件。
- Compose 项目：`saasvh-e88e259`；服务：`web`、`postgres`、`redis`。
- 唯一宿主机发布端口：`127.0.0.1:3003`；Postgres、Redis 无宿主机端口映射。
- 原始 Web 限额 8 GiB 被 Docker Engine 接受，未创建资源覆盖文件。
- Web 镜像构建成功；冻结锁文件依赖安装成功，Prisma Client 生成成功。
- 已创建项目卷 `demo_state`、`preview_data` 和项目默认网络。

## 本机预检与运行资源

- Windows 11 Home，build `10.0.26300`。
- 工具：Git `2.53.0`、Node `v24.19.0`、pnpm `11.25.0`、Docker Engine `29.7.2`、Compose `5.4.0`。
- Windows 查询报告内存总量约 15.28 GiB；预检可用内存约 0.36 GiB，运行中最低观测值约 0.27 GiB。该数值未作为前置拒绝条件。
- Docker Engine 报告 12 vCPU、约 7.397 GiB 可用容器内存；Windows WMI 的处理器查询报告 1 个逻辑处理器。
- 系统盘预检剩余约 169.52 GiB。
- 运行峰值采样：Web 约 3.866 GiB、396.51% CPU；Postgres 约 72 MiB、Redis 约 15 MiB。Docker stats 的 CPU 百分比可超过 100%。
- 容器退出后 Windows 可用内存回升至约 0.82 GiB；3003 端口无监听。

## 页面与功能矩阵

| 项目 | 结果 | 证据 |
| --- | --- | --- |
| 首页 | PASS（运行期间） | 浏览器显示 AI SaaS 首页；HTTP GET `/` 返回 200。执行会话中捕获了首页及登录弹窗截图。 |
| 登录入口 | PARTIAL | 登录弹窗显示“以本地管理员身份体验”和“仅在本机体验，无需注册或配置账号”。点击后浏览器自动化请求超时，未确认登录完成。 |
| 用户 Dashboard | UNVERIFIED | `/dashboard` 在运行高负载期间 8 秒请求超时；未确认已登录态。 |
| Admin | UNVERIFIED | `/admin` 在运行高负载期间 8 秒请求超时；未完成管理员正向或非管理员反向授权测试。 |
| Affiliate | PARTIAL | `/affiliate` 返回 307，表现为受保护路径重定向；`/account/affiliate` 请求超时。未确认页面功能或资格状态。 |
| Worker / 后台任务 | UNVERIFIED | Demo Compose 不包含 Worker 服务；未发现可用的 Worker 健康接口。 |

未创建普通用户或伪造资格数据。未执行 Stripe 连接、真实支付、支付测试或第三方账号注册。

## 既有负载回归与处置

- 预检时存在 3 个运行中容器；脱敏容器 ID 指纹为 `B1A52AC5143F8D42`、`F80E1D715DDC2D45`、`EA4E534D3ECBA0DE`。
- G2 运行期间复核时，3 个原容器均为 `exited`；退出码分别为 `137`、`0`、`0`。其 Docker `OOMKilled` 标志均为 false，近 15 分钟 Docker OOM 事件查询为空。一个容器退出前健康状态为 `unhealthy`。
- 退出原因未确认；其中退出码 137 表示进程被强制终止的可能性，不能单凭此确认 OOM。由于原先运行负载发生状态回归，依 Gate 停止 G2 项目。
- 执行：`docker compose -p saasvh-e88e259 -f compose.demo.yml stop --timeout 30`，成功；只针对 G2 项目。
- 复核：G2 三容器均已停止，3003 无监听；两卷和项目网络保留。没有删除容器、卷、镜像或网络，没有执行 prune，也没有启动、停止或修改其他项目。
- G2 运行期间观测到的原容器退出时间约为 `2026-10-17 16:32:30–16:32:36 UTC`；退出状态已在停止 G2 后再次复核仍为 `exited`。没有尝试重启其他项目。

## Reviewer 后续

请 Reviewer 检查既有容器退出与 G2 运行的时间关联及本机状态后，再决定是否可以继续。当前演示容器已停止，无法提供可用的 localhost 页面；源码、Web 镜像、两卷和网络保留供审阅。未进行重启复现，也未更新 canonical Handoff。