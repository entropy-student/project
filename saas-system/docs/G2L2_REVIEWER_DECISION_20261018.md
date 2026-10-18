# SaaS System Lab — G2L2 独立 Reviewer 裁定（2026-10-18）

> GATE_ID=`SAAS-G2L2-LOCAL-DESKTOP-LOGIN-AND-UI-RECHECK-20261018`
> REVIEWER_RESULT=`RETURN_AFFILIATE_BLANK_AND_WEB_HTTP_EMPTY_REPLY`
> PARTIAL_PASS=`LOCAL_DEMO_AUTH / DASHBOARD / ADMIN_USERS_READ_UI`
> RUNTIME_WEB_AVAILABILITY=`UNVERIFIED_AFTER_HTTP_000`
> NEXT_GATE=`G2L3_LOCAL_WEB_AND_AFFILIATE_TARGETED_RECOVERY`
> PROVENANCE=`GITHUB_DIRECT_SOURCE_REVIEW + OWNER_RELAYED_EXECUTOR_RUNTIME`

## 独立审核基础

在 GitHub `main` 直接核查 [G2L2 Executor Evidence](./G2L2_EXECUTION_EVIDENCE_20261018.md)、[G2L2 原 Gate](./G2L2_LOCAL_DESKTOP_AUTH_AND_UI_RECHECK_GATE_20261018.md)、现行 Handoff、Governance v0.2.7。交叉读取固定 `velobase/velobase-harness@e88e259b974f883913f68ac74a9b8377765d005d` 的 `src/app/account/affiliate/page.tsx`、`services/demo/start.mjs`、`Dockerfile.demo`。所有 Docker / 浏览器 / HTTP 结论仍是 Owner 转交本机 Executor 报告，而非本 Reviewer 在 Windows 上的现场读回。执行报告中的精简 DOM 信息已在 main，可审；未独立检查浏览器会话中的图片文件。

## 正式结论

- **G2L2 整轮 RETURN，但前一项阻塞已经解决**：CSS viewport `1280×900`、Mobile media=false、桌面登录按钮可见；经正常可见 UI 登录，`/dashboard` 显示 Local administrator 资料，`/admin/users` 有真实用户管理 UI 与 33 条演示记录。这些已达成本 Gate 登录与 Dashboard/Admin 可操作性正例的读屏范围；不能据此判定全部 Admin 写操作或权限安全已通过。
- **Affiliate 未完成**：已认证 `/account/affiliate` 首次呈现空白并离开该页；`/affiliate` 导向首页。浏览器只采到 Next.js console-error 拦截器，未取得具体异常类型/堆栈，不能以 `UNKNOWN` 取代诊断。
- **Web 可用性实测异常**：04:00 UTC 之后至少三次宿主 curl HTTP `000`/空响应；但 web 容器仍 `running`、restart=0、OOMKilled=false，3003 监听存在。没有 curl 退出码、精确代理绕过标志、connect/TTFB/timeout 分类和容器内 HTTP 对照，因此不能推断 Next.js 崩溃或 Docker 转发失效。形式上不允许从过去首页 200 推断当时及目前仍可用。
- **Worker 与权限仍未通过**：worker 未见本次启动标记也未有队列真实处理行为，记 UNVERIFIED；普通用户 Admin 反例未实施，匿名重定向不替代角色权限。Postgres/Redis healthy，其他 Docker 容器状态基线未改变。
- **资源**：Web 峰值示例 5.208 GiB / CPU 289.77%，其后 CPU 回落，宿主 RAM 约 0.94–0.97 GiB；没有报告真实 OOM 或非目标工作负载回退。负载峰值是需要观测的相关项，不是已证明的 `HTTP 000` 根因。

## 独立镜像指纹校核

G2L2 报告 Web **实际容器 Image ID** 为 `sha256:9ab2468decb483e8941b18ce99570a1cf51677b3bb4c0c11024c1d6ea79364ef`，Docker 当前 tag `saasvh-e88e259-web` 解析到同一 ID。G2L1 历史 Evidence 的 `web` 镜像指纹 `1552F1BBB39573BA` 是对该 Image ID **完整带 `sha256:` 前缀的字符串做 SHA-256 后取前 16 十六进制字符并转大写**所得，已独立算得匹配。因此，G2L1→G2L2 的 Web 实际镜像身份**一致**；不可把 G2L2 中 `com.docker.compose.image` 标签 `88bb7e...` 与实际镜像 ID 的不一致直接定性为镜像被重新构建/替换。标签可为旧 Compose 元数据或不同创建时版本，确切演变原因 UNKNOWN。本轮**不因这个标签差异重建、重拉或重建容器**；可在下一轮仅读 Label 和 Image 元数据留指纹。

## 源码风险定位

固定 `src/app/account/affiliate/page.tsx`：已认证后调用 `api.affiliate.getStatus.useQuery`；当 `!affiliateStatus?.eligible` 时会在 render 期间调用 `router.push("/404")` 并 `return null`。当 API 数据尚未就绪、管理员账户不具备资格或请求返回异常时，这种 render 内跳转**存在潜在失当副作用**，可能与 blank/Next.js Issue 有关，但**没有栈或 API 状态证明就是这次根因**。下一轮应抓取脱敏 query 状态（`pending/error/eligible` 布尔分类）与 console error class，不能读取用户私密字段，更不能激活推广或改数据库。

固定 `services/demo/start.mjs` 在 Web 容器每次启动时运行 `prisma db push --skip-generate`，并在缺少 seed marker 时进行初始化，故 **重启 Web 并非绝对零数据库写入的操作**。若后续恢复 Web，必须先核验现有 Demo 状态卷的 seed 标记与源码固定、项目边界，不得盲目重启或清除容器数据。

## 审核处置

1. G2L2 正式 `RETURN_AFFILIATE_BLANK_AND_WEB_HTTP_EMPTY_REPLY`，其登录/Dashboard/Admin UI 读屏正例成果**接受并保留**，不重复 G2L1/G2L2 登录问题调查。
2. 先做一次定向 [G2L3 现有 Web/ Affiliate 诊断与条件恢复 Gate](./G2L3_LOCAL_WEB_AFFILIATE_TARGETED_RECOVERY_GATE_20261018.md)：`curl.exe --noproxy "*"` 检查 HTTP 000 的确切错误/时间指标，区分 Windows Host、Docker 回环和 Next.js 运行进程；收集窄窗脱敏日志、Next.js 错误类；若在**两条独立通路**都证实 Web 挂起且安全前提符合，允许一次**仅 Web 容器**的受控重启，不 rebuild、不恢复其它项目；恢复后验收已通过的路由及 Affiliate 异常分类。
3. 若直连仍可用、仅代理路径错误，则**不得重启**；若服务内响应正常却宿主转发失效，STOP 并就端口路径单独分类，不以重启 Web 掩盖转发问题。若前提或影响证据不足，只回报最小必要故障域，不试验性扩权。
4. 按项目计划仍先把 Velobase 样板验收到能真实使用，再进入 Stripe/推广后续独立 Gate；Open SaaS/Wave 不并行。
5. 不触碰其他 Docker 工作负载、Docker Desktop/WSL 全局、支付 Provider、私钥/Secret、Windows 系统设置。历史 G2/G2R1 三旧容器归属/退出原因仍 `UNKNOWN`、Owner 暂不恢复。

## 参考

- [G2L2 Executor Evidence](./G2L2_EXECUTION_EVIDENCE_20261018.md)
- [旧 G2L2 Gate](./G2L2_LOCAL_DESKTOP_AUTH_AND_UI_RECHECK_GATE_20261018.md)
- [新 G2L3 Gate](./G2L3_LOCAL_WEB_AFFILIATE_TARGETED_RECOVERY_GATE_20261018.md)
- [项目唯一 Handoff](../REVIEWER_HANDOFF.md)
- [固定 Web 启动器](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/services/demo/start.mjs)
- [固定 Affiliate 页面](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/src/app/account/affiliate/page.tsx)
