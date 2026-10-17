# 现代商业支付系统｜第五部分 R2 Reviewer 定向修复与文稿级验收

- GATE_ID：`MCPG-CH5-R2-REVIEWER-DIRECT-REPAIR-20261017`
- OWNER_AUTHORIZATION：Owner 于 2026-10-17 明确要求 Reviewer 代为按最小原则修正第五章、完成后落库并启动第六章。
- INPUT：Writer 第五部分 R1 完整候选正文及独立 Reviewer R1 复审意见 `RETURN_FACTUAL_ROUTE_RECONCILIATION_EVIDENCE_R2`。
- OUTPUT：`CHAPTER5_FINAL_SEALED.md`；验收后第五章正式内容冻结，第六章另立独立 Writer Gate。
- DECISION：`PASS`（仅指**文稿事实、知识结构、计算模型及已核对引用**；不证明真实金融产品可开户、真实交易或结汇已执行）。

## Reviewer 实际修订

1. **资金路径 / F01、F05、F06**：移除无法证明的“首选方案”，把法律卖方与主体 → 上游收单/平台商户资格 → 实际可绑定出金账户 → 受款币种和银行 → 合规/税务 → 完整报价作为必要先验。未证明的大陆 Stripe → 第三方账户 → 人民币路径明确为 `UNKNOWN`；Wise / WorldFirst 的受款账户不能替代商户准入。
2. **贸易、银行和税务 / F02、F03、F04、F12**：保留年等值 USD 50,000 便利化额度并非绝对上限的正确定义；9610/9710 仅为不同监管场景，不由客单价直接决定。移除 MoR 自动零税率、著作权证自动必要、银行固定“待核查专户”、强制 MT103 和固定审核时长等无支持断言。
3. **MoR、费用与预留 / F07–F09**：Lemon Squeezy 与 Paddle 分别说明出金创建/发出/银行可用时间和门槛。跨境收单费、滚动预留金、出金和 FX 费用均按产品与协议适用条件处理。USD 29 与 USD 120 两组算例保留为**假设费用模型**，不能证明大陆商家具备该美国费率与结算通道资格；补充批次取整与预留金可抵扣风险。
4. **Payout、追踪与对账 / F10、F11**：Stripe Payout `paid` 是服务商对该次出金成功的状态记录，并非“仅指令发出”，但少数仍可后续 `failed`；银行最终入账需要独立证据。以“按币种网关期初+变动-出金=期末 / 批次外币 / 银行 FX 实收”取代跨币种错误等号。
5. **官方引用、元数据与表述 / F13–F15**：SAFE [S04] 更换法规与答疑具体链接，WorldFirst [S09] 更换具体产品页并明确营销页不足以证明绑定资格；修订 S01/S03/S05/S12 适用边界；不继续复用 Writer 自评的虚假行号、校验值或全部 PASS 断言。

## Reviewer 验证

- 正文路径：`modern-commercial-payment-guide/docs/CHAPTER5_FINAL_SEALED.md`。
- UTF-8 字节数：**55979**；行数：**511**；SHA256（本地修订正文快照）：`6cc96dde0fed0df96e99dc782cf7b0ef582e72685197fab503b214353df5770e`。
- V6 标题：严格保留第⑤章 4 个二级与 5 个三级问题，数量、标题、顺序均逐字核对。
- 两个主案例及其计算：A 单笔原币净额 `$27.42`、模型人民币 `196.63`；B 现期美元 `$102.42`、模型人民币 `735.19`、假设释放额 `86.11`；均标为教学假设，非服务商真实报价。
- 对账验算：`10.00 + 82.26 - 5.00 + 2.00 - 3.00 - 80.00 = USD 6.26`；`(80.00 - 1.00 - 2.00) × 7.1800 - 3.00 = CNY 549.86`。
- `[S01]`–`[S12]` 引用集合与附录编号存在；并已抽查关键声明对应官方具体页面，无法查实的费率/资格数值不作为商家操作承诺。
- Markdown：图表/代码围栏成对；未更改封板 ①–④ 章及 V6 正式框架。
- 外部可用性：**NOT_APPLICABLE / UNKNOWN**。此次无真实收单账户、现金流、银行流水或监管部门个案审核证据；所有实际服务商资格须交易前二次核验。

## 官方交叉依据（查询日期：2026-10-17）

- Stripe Payout 对象状态：<https://docs.stripe.com/api/payouts/object>；结算与 Payout：<https://docs.stripe.com/payouts>。
- Lemon Squeezy 收款排期：<https://docs.lemonsqueezy.com/help/getting-started/getting-paid>。
- Paddle 收款排期、门槛及银行时延：<https://www.paddle.com/help/manage/get-paid/when-and-how-do-i-get-paid>；Paddle 出金费用：<https://www.paddle.com/help/manage/get-paid/is-there-a-fee-taken-for-payouts>。
- 国家外汇管理局《支付机构外汇业务管理办法》：<https://www.safe.gov.cn/safe/2019/0429/13114.html>；个人跨境电商结售汇具体条件：<https://www.safe.gov.cn/tianjin/2025/0303/2735.html>。
- WorldFirst 产品信息：<https://www.worldfirst.com/cn/events/online-sellers/>；跨境产品及营销信息不得代替个体账户批准：<https://www.worldfirst.com/cn/b2b/mkt-sem/>。

## 结果与停止边界

**PASS 文稿级。** 正文在 GitHub `main` 需经写后回读确认；不得将此 PASS 解释为已取得任何支付机构的真实账户批准、已完成提现或已测试跨境结汇。第六章的写作与审核是独立下一 Gate，Writer 不访问 GitHub。