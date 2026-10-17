# 第七部分 R2｜Reviewer 定向修订与文稿级验收证据

- GATE_ID：`MCPG-CH7-R2-REVIEWER-DIRECT-FINALIZE-20261017`
- Owner 授权：2026-10-17，Reviewer 直接代替 Writer 完成第七章最小范围修改、落 GitHub main，随后把 ①–⑦ 章封板正文打成独立 ZIP。
- TARGET：`modern-commercial-payment-guide/docs/CHAPTER7_FINAL_SEALED.md`；第一至第六章封板正文与 V6 冻结框架只读。
- SOURCE：R1 Writer 全文；上一轮 Reviewer `RETURN_FACTUAL_AND_ACCOUNTING_R2` 报告及 15 项验收。
- SCOPE：文本事实、示例算术、来源、表格勾稽和边界声明；不涉及实际收款、税务申报或真实账户操作。

## 核验结论

**PASS（文稿级）**。本轮从 R1 全文实施约 50 项有定位的最小定向修改，没有推倒重写。V6 第七章 4 个二级、7 个三级问题逐字同序；深圳软件 $29、东莞键盘 $120 两个教学案例保留；前六章和框架没有修改。

## R01–R15 对应处理

| 项目 | 结果 | 审查和改动 |
|---|---|---|
| R01 VAMP | PASS | 同笔 TC40/TC15 两次计数；区分 Acquirer 50/70bps 与商户门槛；2026-04 起美国/欧盟/加拿大/AP 商户 ≥150bps 且 ≥1,500 笔。Mermaid、正文、评分卡、参考附录统一更新。 |
| R02 欧盟关税 | PASS | 明确 €150 低值进口关税豁免已在 2026-07 取消，€3 临时机制预计实施至 2028-07，IOSS 管进口 VAT 不保证免关税或服务费。 |
| R03 出口/退税 | PASS / 条件化 | 不再承诺所有模式均统一一般纳税人/专票要求；$4.55 退税仅为假设满足条件且可确认的案例数值。 |
| R04 对账 | PASS | 原始订单合计 $111→$120；核验 $120−$8.74−$15=$96.26；期初 $15+$96.26−$10+$5−$95=$11.26；$95−$2=$93；$93×7.18−¥3=¥664.74。 |
| R05 官方来源 | PASS / 条件化 | 官方 Visa、Stripe、PCI SSC、IRS、欧盟官方深链接；缺乏个别地区具体报价的地方改 UNKNOWN、MODEL_ASSUMPTION；取消“全部来源已完美核实”的自证措辞。 |
| R06 对外支付备案 | PASS（保留） | 保留“对外支付不等于境外收款”的已通过区分。 |
| R07 个人结汇额度 | PASS（保留） | 保留便利化额度不是经营性绝对结汇上限的适用说明。 |
| R08 收入和现金 | PASS | 明确全生命周期净损益非退款当天银行现金流；PSP 可用余额不等于到账；MoR 净结算额不直接等于收入。 |
| R09 美国州税 | PASS / UNKNOWN | 未取得各州最新深链接的具体数字不当作可依赖的统一规则；保留已知加州规则但附适用条件。 |
| R10 PCI/令牌 | PASS | 不再强制原/新 PSP 均为 Level 1；ROC/AoC/SAQ 依品牌、收单行及角色；Token 迁移需 PSP 正式支持及客户授权。 |
| R11 银行凭据/时限 | PASS / 条件化 | MT103 71F 不是所有银行出金的统一强制凭据；银行时限和风控预留金均依账户合同判断。 |
| R12 平台税/渠道总成本 | PASS | Marketplace、MoR 和 B2B 责任按合同/法域判断；TCO 包括固定单笔费，FX 差异与回收期统一正负号。 |
| R13 指标 | PASS / 教学阈值 | 把商户内部评分阈值与 Visa 官方准入门槛明确分开。 |
| R14 跨章衔接 | PASS（保留） | 章名与七章结构不变。 |
| R15 证据 | PASS | 从最终文件直接生成 SHA256 与行数；来源核验未覆盖的个别地区资格明确 UNKNOWN；不宣称实盘验收。 |

## 官方主要核验来源（2026-10-17）

- Visa VAMP Fact Sheet：https://corporate.visa.com/content/dam/VCOM/corporate/visa-perspectives/security-and-trust/documents/visa-acquirer-monitoring-program-fact-sheet-2025.pdf
- Stripe VAMP FAQs（TC40/TC15 同笔各算一次）：https://support.stripe.com/questions/monitoring-program-faq?locale=zh-CN
- 欧盟委员会 2026 低值进口关税及 €3 过渡机制：https://taxation-customs.ec.europa.eu/news/guidance-and-legal-text-temporary-flat-fee-low-value-imports-which-will-apply-until-1-july-2028-2026-06-08_en
- IRS W-8BEN-E 官方说明：https://www.irs.gov/instructions/iw8bene
- PCI SSC FAQ 1473（合规接受方确定验证方式）：https://www.pcisecuritystandards.org/faqs/1473/
- Stripe 迁移指南：https://docs.stripe.com/implementation-guides/core-payments/migration

## 复核证据与限制

- 最终章节文件：949 行，114,088 UTF-8 字节，SHA256 `efb713a3c052e523556904a51921e96516fbd0cc6603ecbe0ddd544694c8bcab`。
- 注：上面两组教学商户与金额为模拟场景，**不代表真实开户、获批退税或到账验证**。税法、服务商合同、支付网络规则随地区和日期变动；无法证明的动态条款使用 UNKNOWN 或示例参数。
- 外部权威材料为公开一手说明及官网规则，不代表提供法律/税务意见或已执行商户生产验收。
- 费用变化与风险：无真实资金、账户、支付、结汇或站点变更；只提交项目文稿。
- 可恢复路径：使用本轮 GitHub 提交的前一个 `main` commit 恢复原始仓库状态；第①–⑥章 Git blob SHA 应保持与写入前相同。
- ZIP 验证：7 个正式 `CHAPTERx_FINAL_SEALED.md` 文件，从 GitHub 精确读取后统一打包，ZIP 中不得插入候选或审核文档。
