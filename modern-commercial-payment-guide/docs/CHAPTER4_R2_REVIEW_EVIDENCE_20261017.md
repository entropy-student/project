# 第四部分 R2｜Reviewer 修订与验收证据（2026-10-17）

- GATE_ID：`MCPG-CH4-R2-REVIEWER-REPAIR-ADOPT-20261017`
- OWNER：明确授权本轮 Reviewer 代替 Writer 完成第四部分修改，完成后落库，并开启第五部分。
- INPUT：R1 完整稿、R1 独立复审报告和 R2 返修边界。
- ACCEPTED：`docs/CHAPTER4_FINAL_SEALED.md`，449 行，UTF-8 48,058 字节，SHA256 `86866f8b70c1209413db933ff54dbf30e95e41f650ea377b09033ee6c946e2e7`。
- RESULT：**PASS（仅文稿级）**；不表示任何真实 Stripe、PayPal、银行或提现集成通过。

## 逐项复核（R01–R15、N01–N05）

| 项 | 已执行修复 | 文稿判断 |
|---|---|---|
| R01 | 将授权撤销、实扣退款、inquiry/dispute、退款失败区分；取消“一律接受争议” | PASS |
| R02 | 仓库包裹 HOLD→捕获成功→允许交承运商；失败或超时不放行 | PASS |
| R03 | 本地事务 CAS+Outbox、支持/不支持下游原生幂等两条路径、UNKNOWN 禁止盲重发 | PASS（静态） |
| R04 | PSP 交易、本地订单履约、平台/银行资金结算三轴区分 | PASS |
| R05 | 手动捕获按方式、卡种、CIT/MIT、真实授权期限、BNPL 和物流 SLA 判断 | PASS |
| R06 | Webhook 改为 HTTPS+验签而非加密专线；持久化后 ACK，含游客订单安全查询 | PASS（静态） |
| R07 | Stripe PaymentIntent≠Checkout Session；PayPal APPROVED≠授权，Orders/Payments 两条 Capture 路径分离 | PASS |
| R08 | 订阅对齐 subscription/invoice/权益和账期，不取第一条 invoice line，处理乱序与欠费政策 | PASS |
| R09 | POST 超时无 ID、幂等缓存 500/并发/过期键归入 UNKNOWN；Search 为空不证明未扣款 | PASS |
| R10 | ARN/STAN/RRN/冲正、退款 pending/succeeded/failed 分开；不承诺固定日期及号码长度 | PASS |
| R11 | 托管平台/插件/自研/MoR 责任限定于具体合同和技术能力 | PASS |
| R12 | 16 个一手官方参考入口，提供具体适用范围，不混写 PayPal 与 Stripe 定价 | PASS（引用静态） |
| R13 | V6 第④章 4 H2/5 H3 标题一致；Markdown 围栏成对，SQL 标明 PostgreSQL 示意 | PASS |
| R14 | 去除统一 7 天、取消零成本、所有争议必须接受、捕获即能提现等绝对表述 | PASS |
| R15 | 12 项沙盒/故障注入测试矩阵，覆盖乱序、失败捕获、退款失败、查询不一致、无幂等下游 | PASS（计划） |
| N01 | 第⑤章正式名称改为《资金结算与到账｜如何更快、更省、更安全地拿到钱？》 | PASS |
| N02 | 本轮使用实际 449 行及 SHA，不复用 R1 错位行号 | PASS |
| N03 | 将真实沙盒 API 验收及 Mermaid 图形渲染标为 UNVERIFIED，不滥用 PASS | PASS |
| N04 | 已捕获与“可提现余额”分离 | PASS |
| N05 | 捕获后退款、争议对已交付权益的影响留有第⑥章风险/撤权衔接 | PASS |

## 核验事实与限制

- `DIRECT_READBACK`：第四部分正式稿存在，包含冻结 4 个二级与 5 个三级标题、两商业假设案例、三轴模型、16 项参考来源、12 条沙盒测试计划。
- `WEB_OFFICIAL_DOCS`：核对 Stripe PaymentIntents Search（最终一致）、Place a hold（部分 BNPL 支持、不同授权窗口）、Subscription Webhooks/Invoice Line、Refunds/Disputes、Idempotency；PayPal Orders Expanded Checkout 的 CAPTURE/AUTHORIZE/Authorization Capture、REST Idempotency。各官方 URL 见正式稿附录。
- `UNVERIFIED`：没有执行真实沙盒支付、真实退款、银行提现或实际 Mermaid 浏览器渲染；本项目本轮是文本工作，不是工程系统验收。
- `ROLLBACK`：封板稿的 Git SHA/文件哈希可追踪。没有生产环境和真实客户资金变更。
- `NEXT_GATE`：只开启第五章独立完整写作。Writer 返回候选和事实记录，停在 Reviewer，不能自行采纳。
