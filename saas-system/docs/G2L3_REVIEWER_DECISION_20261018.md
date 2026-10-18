# SaaS System Lab — G2L3 独立 Reviewer 裁定（2026-10-18）

> GATE_ID=`SAAS-G2L3-LOCAL-WEB-AFFILIATE-TARGETED-RECOVERY-20261018`
> REVIEWER_DECISION=`PARTIAL_G2L3_WEB_RESPONSIVE_AFFILIATE_UNVERIFIED`
> WEB_HOST_AND_CONTAINER_HTTP=`PASS_AT_G2L3_SAMPLED_TIMES`
> AFFILIATE=`UNVERIFIED / BLANK_AND_REDIRECT_OBSERVED`
> WORKER_AND_ORDINARY_USER_ROLE_NEGATIVE=`UNVERIFIED`
> HISTORICAL_HTTP_000_CAUSE=`UNKNOWN`
> NEXT_GATE=`G2L4_AFFILIATE_ELIGIBILITY_AND_ADMIN_READONLY_CLASSIFICATION`
> SOURCE_PROVENANCE=`OWNER_RELAYED_EXECUTOR_RUNTIME / REVIEWER_GITHUB_CODE_DIRECT_READBACK`

## 审核证据与事实等级

直接读取 [G2L3 Executor Evidence](./G2L3_EXECUTION_EVIDENCE_20261018.md)、[G2L3 执行 Gate](./G2L3_LOCAL_WEB_AFFILIATE_TARGETED_RECOVERY_GATE_20261018.md)、现行 Handoff、Governance v0.2.7 和固定上游 SHA `e88e259b974f883913f68ac74a9b8377765d005d` 源码。Windows、浏览器、Docker 观测属于 Owner 转交本机 Codex 的执行报告，不是 Reviewer 直接控制 Windows。没有单独移交可供 Reviewer 审核的原生浏览器会话。

## 已接受与未接受

1. **Web 当前两通路可响应（本轮时点 PASS）**：本机 `curl.exe --noproxy '*'` 连续四次 HTTP 200（第一笔 TTFB 约 5.05 秒，随后约 0.21–0.31 秒），已存在 Web 容器内 Node 访问本机监听 HTTP 200。其结果不证明任意长时间 24/7 稳定；G2L2 历史 HTTP 000 的原始 `curl` 退出码与原因未知。Windows 进程有代理变量，但仅能说明代理参与路径**可能**影响历史结果，不能宣称代理为根因。
2. **不重启正确**：G2L3 双通路挂起触发条件不成立，Web-only restart 0 次，存储标记未读取属于正常的分支未触发；Postgres/Redis healthy，原镜像/挂载/网络保留。现有 Web 无 Docker healthcheck，Worker 无队列处理正例；仅运行容器不能证明业务 Worker 功能。
3. **Affiliate 仍 UNVERIFIED**：已登录的演示管理员访问 `/account/affiliate` 空白、重载后回首页；非敏感客户端观测没有取得 `affiliate.getStatus` 的 HTTP/资格/错误布尔分类，只有 generic console error。不能据此直接称为核心裂变模块代码异常，也不能直接判定正常无资格跳转。
4. **非目标工作负载**：Executor 未作任何非目标容器主动操作。报告有开场库存 `0 running/1 created/34 exited`，但**没有结束库存**，所以不能写成“本轮其他容器前后状态已独立证明不变”；真实其它项目状态变化 UNKNOWN，没有报告事故。
5. **资源**：Web CPU 约 388.84% 后 113.08%，内存约 5.73–5.77 GiB，宿主可用 1.4–2.15 GB（终点约 1.8 GB）；无 OOMKilled/Windows System Event 2004。压力值得关注，但不是经证实的服务故障。

## 新增源码逻辑校核：可能是资格限制而非崩溃

- `services/demo/seed.ts` 只为本地 `demo@harness.local` 演示管理员创建/保证 `isAdmin=true`，**不直接赋予推广资格、支付记录或推广佣金**。
- `services/demo/seed-admin.ts` 建立更多演示用户/支付/推广展示记录；其示例用户与登录管理员不是同一人。本地已有数据库真实变化/历史数据若存在仍需新鲜核实。
- `src/server/api/routers/affiliate.ts:getStatus` 依据账户累计支付是否 >=499 cents、推广开通状态或佣金账户非零余额计算 `eligible`。管理员角色不等于 `eligible`。
- `src/app/account/affiliate/page.tsx` 在 `!affiliateStatus?.eligible`（也含响应缺失）时直接在 render 阶段 `router.push('/404')`、返回 `null`。这条代码路径与空白及跳转**高度相容**，并且 render 中发起导航具有前端时序/渲染风险，但目前不能断言历史本机账户一定满足该分支、不能假设后端 status 正常。
- 已有独立平台级页面 `/admin/affiliate/commissions`、`/admin/affiliate/payouts`，可使用现有 Demo 管理员进行**只读** UI 验收，不需伪造普通用户、不需修改资格或发起交易。

## Reviewer 处置

- 正式结果 `PARTIAL_G2L3_WEB_RESPONSIVE_AFFILIATE_UNVERIFIED`；G2L3 结束，Web 当前访问问题不再作为持续故障 BLOCKER。保存 G2L2 已通过登录/Dashboard/Admin 的读屏事实。
- 签发 [G2L4 最终资格归类与现成推广后台页面验收 Gate](./G2L4_AFFILIATE_ELIGIBILITY_AND_ADMIN_READONLY_GATE_20261018.md)。核心不是继续盲抓浏览器错误，而是**用原 Demo 的只读账户资格事实与后台官方 UI**判断这一模板究竟具备可观察的推广后台、个人 Affiliate 是否因资格规则被阻拦。
- 本轮不授权代码修复、镜像重建、数据库播种、模拟交易或管理员角色/资格绕过。若账户明确无资格，就将个人页面按业务资格分类，不要求通过它来验收完整裂变闭环；若已资格却空白，则确认为更窄的前端/请求缺陷，交 Reviewer 作有限补丁决策。
- 对仍无法可审的功能不累计无限 RETURN：G2L4 的结论可正式判为 `AVAILABLE_ADMIN_UI / INDIVIDUAL_AFFILIATE_RESTRICTED`、`AFFILIATE_CODE_BUG_CONFIRMED`、或 `UNVERIFIED`，由 Reviewer 决定候选评价与是否转入 Open SaaS，而不是重新开始安装 Velobase。

## 证据指针

- [G2L3 Executor Evidence](./G2L3_EXECUTION_EVIDENCE_20261018.md)
- [G2L3 原 Gate](./G2L3_LOCAL_WEB_AFFILIATE_TARGETED_RECOVERY_GATE_20261018.md)
- [后续 G2L4 Gate](./G2L4_AFFILIATE_ELIGIBILITY_AND_ADMIN_READONLY_GATE_20261018.md)
- [唯一 Handoff](../REVIEWER_HANDOFF.md)
- [上游本地 Demo 初始化](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/services/demo/seed.ts)
- [上游 Affiliate 资格 API](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/src/server/api/routers/affiliate.ts)
- [上游 Affiliate 页面](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/src/app/account/affiliate/page.tsx)
