# 《现代商业支付系统》第三、第四部分｜正式采纳与最小修订执行记录

**执行日期：** 2026-10-17  
**授权：** Owner 明确要求对本轮返修ZIP自行复核，有问题时最小修正，完成后写入GitHub并启动⑤⑥。
**范围：** 第③、第④章完整正文与文档/索引；①②封板及V6 7/29/42架构保持只读。
**性质：** 基于外部Agent新提交的第二轮候选做独立定向复核和最小修补，不等于所有国家金融法律法规的全面认证。

## 一、输入与文件指纹

- 输入文件：`现代商业支付系统_第三四部分_联合独立写作成果(1).zip`，ZIP SHA256 `8cba1846047269cb480d23bfec8846b80f7f7b3ab4bbaec4102617c78ca6d1e4`，恰好三份Markdown，CRC通过。
- 输入③ `a540e210649e08dcdc62a1a5e33d56ed98e213c06bcd19f3ea82531602cbf6de`；输入④ `77454f8a68b758041cec34dacb61072809295c9370902a14551619880f0187dd`；输入执行记录 `f413bcc9e0a7296fd918b37afc0cb4dce858471170a02df7816d4254b1200168`。

## 二、逐项独立复核与定向修订

状态解释：`FIXED` 是本轮校正残留；`VERIFIED` 为外部候选中已修正且复核继续保留；无法断言各国统一资格/费用，应在正文按条件说明。

| 问题 | 结论 | 修订依据 |
|---|---|---|
| P0-01 Apple Pay browser | **FIXED**：第三部分更新跨浏览器/扫码、可用性地区例外、取消秒级保证 | https://applepaypartners.apple.com/merchants/features/apple-pay-in-third-party-browsers |
| P0-02 3DS | **FIXED**：责任转移限适用欺诈类别，按卡组织与发卡行规则；避免保证无感或固定损失 | https://support.stripe.com/questions/liability-shift-with-frictionless-flow-for-3d-secure-v2-%283ds2%29 |
| P0-03 FTC | **FIXED**：明确2024 Click-to-Cancel修订2025-07-08撤销；ROSCA与州法分开判断 | https://www.govinfo.gov/content/pkg/FR-2026-03-13/html/2026-04952.htm |
| P0-04 Security | **VERIFIED**：候选原已改Magic Link与托管卡字段，复核保留 | https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html |
| P0-05 Payment stages | **FIXED**：图、六层状态、Capture与银行入账/PayPal capture断言同步修正 | https://developer.paypal.com/api/orders/v2/definitions/purchase_unit |
| P0-06 Stripe idempotency | **FIXED**：保留至少24小时，补首请求开始执行缓存条件；同操作安全重试复用原键 | https://docs.stripe.com/api/idempotent_requests |
| P0-07 CAS + Orphan | **VERIFIED**：候选原已做CAS=0状态区分和孤儿人工核验；超时重试图进一步增加同订单全尝试核对 | https://docs.stripe.com/webhooks |
| P0-08 PCI | **FIXED**：保留适用资格判断，删除全体商户每年必须提交确定语气 | https://www.pcisecuritystandards.org/faqs/1588/ |
| P1-01 Metrics | **FIXED**：删无出处精确ROI、弃单及固定冻结费率阈值 | https://docs.stripe.com/payments/checkout |
| P1-02 Costs | **FIXED**：账单跨境费不保证微量或本币展示可免除 | https://docs.stripe.com/currencies |
| P1-03 Failure handling | **VERIFIED**：候选原已加不能重复点与营销法律边界，复核保留 | https://docs.stripe.com/payments/payment-intents |
| P1-04 Webhook/Connect | **FIXED**：Webhook延迟不保证1–3秒，核对Connect事件account归属而非假设Stripe-Account请求头可信 | https://docs.stripe.com/connect/webhooks |
| P1-05 Fulfillment | **FIXED**：履约不保证瞬时/零漏单，区分捕获与余额、退款后条件 | https://docs.stripe.com/webhooks |
| P1-06 Timeout | **FIXED**：幂等键不是查询ID，重试前检查同订单全部支付对象、不能仅看requires_payment_method | https://docs.stripe.com/api/idempotent_requests |
| P1-07 Rendering | **FIXED**：正文LaTeX \text完整，ASCII状态图调整，SOFORT旧独立方式标注已停用 | https://support.stripe.com/questions/sofort-is-being-deprecated-as-a-standalone-payment-method |
| P1-08 Evidence | **FIXED**：本文件替代作者自评PASS；源ZIP独立核验已完成，不把作者执行记录视为出版核验 | https://docs.stripe.com/api/payment_intents |

## 三、最终正文完整性与可读性

- 第三部分仍为4个正式二级、5个三级冻结V6标题；第四部分同为4个正式二级、5个三级。全部文字/顺序逐项与V6权威框架核对。
- 保留原有同一笔29美元软件订单、章节结构、全部核心表格和主要示例；仅删除会误导读者的确定性结论，并局部修订原有状态图，不重写叙事。
- ③④付款方式、价格、支付前体验、支付状态、订单实际核验与履约异常分别落在各自章节；①②主体准入与技术接入仍只读引用；⑤结算/⑥争议尚未写入本文。
- 第三部分正式全文：`现代商业支付系统_第三部分_完整候选稿.md`，51753 bytes，SHA256 `52092ab1b9bd9b29013ebff9e67d6ef9885e2cf20dd2d09402f797a597805040`，459行。
- 第四部分正式全文：`现代商业支付系统_第四部分_完整候选稿.md`，59086 bytes，SHA256 `5e567a4de0818165ce3c2093c1b8ea0aa3c4dc92f573f2e5f1d39ad5701c7759`，516行。

## 四、遗留适用条件与后续界限

1. 支付服务商的准入、用户地区、支付方式呈现和结算配置需按真实商户资格及最新官方政策核定；本文示例不保证某个大陆卖家可立即使用Stripe或PayPal某产品。
2. 3DS责任转移、PCI问卷/扫描及争议申诉以发卡行、收单机构和卡组织的适用规则为准，不作所有交易的一律承诺。
3. 订单和支付金额/币种/环境/商户匹配是必要条件，示意伪代码不是完整可直接部署的生产系统。
4. 本轮没有发起真实支付、退款、验证商户账户或部署Webhook。第五、第六部分仍待外部作者提交，不纳入本轮正式采纳。

## 五、正式采用与版本历史

- GitHub正式正文使用新独立路径 `docs/CHAPTER3_OWNER_ADOPTED_20261017.md` 与 `docs/CHAPTER4_OWNER_ADOPTED_20261017.md`，不覆盖①②。
- 原始候选ZIP与首轮Review报告存于文件库及Git历史；本执行记录为本轮最小修订后的最终证据，与原外部作者自核验报告区分。
- 主文变更、新版本内容指纹、Git Commit及后续⑤⑥写作输入参见唯一 `REVIEWER_HANDOFF.md` 与追加式 `EXECUTION_EVIDENCE.md`；这些项目管理文档不叠入读者正文。
- 由于本执行记录会列出第三、四部分的SHA，而ZIP最终哈希需要在文件写完后才能得出，**ZIP的SHA由打包结束后的外部检验记录，不在被打包文件内部自我引用**。
