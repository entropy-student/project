# SaaS System Lab — G1 Velobase Reviewer Decision — 2026-10-17

> GATE_ID=`SAAS-G1-VH-READONLY-PREFLIGHT-20261017`
> REVIEWER_RESULT=`RETURN_RESOURCE_HEADROOM_INSUFFICIENT`
> ACCEPTED_SCOPE=`UPSTREAM_STATIC_REVIEW_AND_OWNER_RELAYED_LOCAL_PREFLIGHT`
> RUNTIME_PASS=`NOT_TESTED`
> NEXT_RUNTIME_GATE=`NOT_AUTHORIZED`

## 结论

Owner 转交本机 Codex 的 G1 只读执行报告：`RETURN_RESOURCE_HEADROOM_INSUFFICIENT`。Reviewer 认同**当前不启动**，但不将 `mem_limit: 8g` 错当为最低内存门槛。资源不足是基于两次低可用内存的审慎决策，不代表证明项目技术上无法运行或永远不适合该电脑。G1 进入 Reviewer 已审状态，不反复重做静态源码研究。

## 分类复核

| 字段 | 来源与证据 | Reviewer 判断 |
| --- | --- | --- |
| `SOURCE_COMMIT` | GitHub `velobase/velobase-harness@e88e259b974f883913f68ac74a9b8377765d005d` | **DIRECT_READBACK**；MIT、`compose.demo.yml`、`Dockerfile.demo`、`services/demo/start.mjs`、Affiliate 源码存在 |
| `TARGET_LOCAL_PROOF` | Owner 转交 Codex 报告：Windows 11 Home build 26300；PowerShell 7.6.5；非管理员 | **OWNER_RELAYED_EXECUTOR_REPORT**；Reviewer 未登录其真实主机 |
| `RESOURCE_HEADROOM` | 主机 RAM 15.28 GiB，可用 1.12/1.55 GiB；C 盘可用 169.70 GiB；CPU 6C/12T 负载约 1% | 当前内存余量低，**阻止本轮安装/构建**。下一运行前必须重新采样；不可推导确定的最低 RAM 需求 |
| `DOCKER_RESOURCES` | 引擎可用内存约 7.40 GiB；3 个运行中容器累计约 0.72 GiB；9 个 Compose 项目与 35 个容器（含停止项） | 目前不适合新增重构建负载；8 GiB 为 Web 容器上限而非实际用量；不能为了实验清理其他容器 |
| `TOOLS_AND_PORTS` | Node 24.19.0，pnpm 11.25.0；目标 pnpm 10.12.1/Docker Node 22；3003/54333/56380 未见端口冲突 | 工具链需要**项目隔离固定版本**，但不是本轮 RETURN 的主因；实际运行前再核验 |
| `STRIPE_AND_AFFILIATE` | GitHub 固定 SHA 代码+本机 Codex 静态解释 | 免费 Affiliate 源码成立；部分退款分支将部分退款标记整笔 REFUNDED，计佣按全额 void；支付与推荐失败补偿未实测 |
| `OWNER_SIDE_EFFECT_COUNT` | 本机 Codex 自报 0；无其它证据表明有运行写操作 | **OWNER_RELAYED_EXECUTOR_REPORT**；在此范围接受只读，没有宣称 Reviewer 对物理机完全审计 |

## 源码风险边界（后续 Gate）

1. **部分退款**：`src/server/order/services/refund-payment.ts` 接受部分金额退款，但之后无条件更新 Payment 和 Order 为 `REFUNDED`，发出 `payment:refunded`。佣金反转若整笔 void，则部分退款可能错误撤销全部佣金。须以 TEST 和负例验证，先修复后才可生产。
2. **事件可靠性**：`src/server/modules/affiliate.ts` 发现若干 catch 后仅记录警告；`src/server/events/bus.ts` 使用 `Promise.allSettled`，不能将支付履约 PASS 自动视作推荐记账 PASS。持久化补偿、幂等及重放需证明。
3. **规则可复用性**：30% 佣金/30 天 Stripe 冻结、累计支付 $4.99 激活门槛及 $50 提现门槛是业务规则，不等于通用可视化配置系统；手动转账不是 Stripe Connect 自动提现。
4. **本机资源与共享服务**：`pnpm dev:local` 会操作 Compose 辅助服务，必须锁定独立项目名、资源路径与端口；不得修改任何现有 Compose/镜像/卷。Docker 演示用 development 配置/本地管理员，绝不能公网暴露。

## 下一步与边界

- **本轮就此停止。** 无新 Gate 授权下载、安装、构建、运行、关停任何服务，也不能据此切换到 Open SaaS / Wave 或换 VPS。
- 如果本机资源余量改善：只做**增量资源复检**，复用已确认的 GitHub SHA 与功能审查，不要求重走完整 G1；是否试运行由独立 Gate 判断资源动态、隔离、回滚和可用端口。
- 如果更重视快速体验且本机始终余量不足：可由 Owner **另行选择**隔离云端演示；必须先只读确认服务商、开通要求、计费方式、测试账号及网络/支付边界。云端并非已经免费可用。
- Owner 无需执行系统清理、关闭现有项目或提供任何 Secret。下一次进入真实付款/Stripe 测试须另外授权。

## 资源来源
- [本项目 G1 Gate](./G1_VELOBASE_READONLY_GATE.md)
- [Velobase 固定版本](https://github.com/velobase/velobase-harness/commit/e88e259b974f883913f68ac74a9b8377765d005d)
- [源退款路径](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/src/server/order/services/refund-payment.ts)
- [Affiliate 事件](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/src/server/modules/affiliate.ts)
- [执行证据](../EXECUTION_EVIDENCE.md)
