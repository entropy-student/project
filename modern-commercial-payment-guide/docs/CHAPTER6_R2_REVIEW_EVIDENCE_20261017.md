# 第六部分 R2｜Reviewer 最小定向修订与文稿级验收记录

- **GATE/Owner 授权**：Owner 于 2026-10-17 要求 Reviewer 代修第六部分、落入 GitHub、开启第七部分离线独立写作。
- **Review 决策**：R1 由 Reviewer 退回 `RETURN_FACTUAL_AND_OPERABILITY_R2`，本轮针对这些问题定向修复后作**文稿级 PASS**；实际金融/税务/支付测试 `NOT_APPLICABLE`。
- **源基线**：`第六部分_R1完整修订候选稿.md`（116,970 bytes、1,019 行、SHA256 `d4aabaef3b96c0081378f30a916709405a2b3f0058f9436f06ba655467f60651`）。
- **结果文件**：`docs/CHAPTER6_FINAL_SEALED.md`（120196 bytes、1011 行、SHA256 `033051bf193d52debb5d5a4ce80707544397147efed882cc0629653cc6764005`）。
- **V6 验收**：正式 4 个 H2、6 个 H3，原文、顺序一致；第①–⑤章与 V6 框架只读。
- **范围**：仅正文里的事实错误、费用案例、退款权益状态机、来源声明与合规表述；未替换结构和两组案例；未执行真实支付、退款、税务或账户操作。

## R01–R15 复核摘要

| 项目 | Reviewer 结论 | 本轮修正 |
|---|---|---|
| R01 VAMP | PASS（文稿） | 单一 `(TC40+TC15)/TC05` 综合笔数率、地区、2026-04-01 注脚及最低笔数；原 DTR/金额 FSR 已删除。 |
| R02 已退款争议 | PASS | 退款 ID/金额/时间/状态为基本凭据；ARN/STAN/RRN 只在实际生成时附上；区分平台证据提交通道。 |
| R03 MoR 平台 | PASS | Lemon 由平台处理争议，后台直接上传证据能力 UNKNOWN；Paddle 与 Lemon 的费率及责任区分。 |
| R04 财务测算 | PASS（独立复算） | 月度统一 `$1.14` 基础费：`1.14+15+1+5=22.14`；6 笔 `$132.84`；36 笔 `$797.04`；原 `$1.58` 单笔案例另属不同费率模型。 |
| R05 退款权益 | PASS（设计检查） | `refund.failed` 只触发待核验，回读当前退款/争议/订阅权益，用幂等事务判断补偿；无条件自动恢复被删除。 |
| R06 EU 撤回权 | 保持先前 PASS | 未改变已经正确的消费者法边界。 |
| R07 Visa CE 3.0 | PASS（文稿） | 允许满足条件的非欺诈争议历史样本；VAMP 剔除依数据提取时点，非自动承诺。 |
| R08 风险冻结/MATCH | PASS（文稿） | 不再承诺期满必付或立即列入 MATCH，按合同、卡组织规则及未决争议核实。 |
| R09 欺诈与信息保护 | 保持先前 PASS | 沿用分级核验与最小必要数据。 |
| R10 Radar | PASS（教学文稿） | 伪代码明确不可直接复制；展示官方 `:cvc_check:` 字段形式，并提示回测和产品权限。 |
| R11 主备通道 | PASS | 禁止用 MoR 转移高拒付流量稀释指标；运营切换须有法律卖方、合约与订单身份核验。 |
| R12 退款/争议矩阵 | PASS（文稿） | RDR 数据剔除/预警升级/费率均标条件与数据截止时点。 |
| R13 官方来源 | PASS（截至核验日） | 官方资料与对应论断重新映射；链接不证明某一商户已获得服务商许可。 |
| R14 文件自证 | PASS | Reviewer 独立从本地最终文件计算行数/bytes/SHA256；本文件不写自己的 SHA 避免自引用。 |
| R15 行文严谨性 | PASS（文稿） | 清理无依据的一定成功/一定列名/统一退款方式和无证据服务费区间。 |

## 算术勘误与可重复回归

前一轮复审报告对 `$1.14+$1+$5` 的小计给出了错误的推导：正确为 **$7.14/笔**、6 笔 **$42.84**、36 笔 **$257.04**；若误写成 $36.84 / $221.04 会再次产生错误。因此本轮保留正确的两个小计；总损失还需加争议费：`6×(7.14+15)=132.84`、`36×(7.14+15)=797.04`。这里“经济损失”包含管理成本等假设，不应直接当财务报表的现金流量。

## 官方事实核对入口（2026-10-17；仅网页/文稿层面）

- Visa VAMP 综合比率与 2026 变更：https://corporate.visa.com/content/dam/VCOM/corporate/visa-perspectives/security-and-trust/documents/visa-acquirer-monitoring-program-fact-sheet-2025.pdf
- Visa CE 3.0 FAQ：https://usa.visa.com/content/dam/VCOM/regional/na/us/support-legal/documents/evolution-of-compelling-evidence-merchant-faqs-mar2023.pdf
- Stripe Radar Rules 101：https://stripe.com/guides/radar-rules-101
- Stripe 退款事件：https://docs.stripe.com/api/events/types
- Lemon Squeezy 退款拒付：https://docs.lemonsqueezy.com/help/payments/refunds-chargebacks
- EU 撤回权：https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A02011L0083-20260927

## 验证/回滚

- `SOURCE_PROVENANCE=OWNER_UPLOADED_R1_ZIP`；`REVIEWER_CHANGE_SCOPE=CH6_ONLY`。
- `VALIDATION=V6_4H2_6H3 + documented finance arithmetic + negative keyword guard + SHA256 bytes + artifact zip CRC + Appendix source spot-check`。
- 不涉及真实资金；回滚可从本轮提交的 parent commit 恢复第六章文件和 Handoff。
- 第⑦章 Writer ZIP 只读使用④–⑥章正式稿，不允许自行封板；最终 HTML `NOT_STARTED`。

## 实施变更摘要

对 R1 原文作 60 处脚本定位修正，随后进行了少量文字/来源边界检查；详细替换键保存在本地 QA 中，正式成果以提交到 GitHub 的正文及本 Evidence 为准。