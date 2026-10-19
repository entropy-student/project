# 第四部分4.6章 Writer R2独立Reviewer复审：RETURN与完整R3返修包登记

> **REVIEW_DATE：2026-10-19**  
> **VERDICT：RETURN_CH6_R2_RESIDUAL_PAYMENT_FULFILLMENT_AND_COMPLIANCE_ERRORS**  
> **CURRENT_STAGE：CHAPTER6_R2_RETURN / R3_WRITER_PENDING / NOT_SEALED**  
> **唯一冻结问题树：** [V2 1核心/9一级/48二级/117三级](FROZEN_FRAMEWORK_V2_20261018.md)；4.6章节**6H2/16H3逐字、同序、同层级PASS**。  
> **历史首次审稿：** [Writer V1独立Reviewer RETURN（R01–R09）](CHAPTER6_WRITER_V1_REVIEW_RETURN_20261019.md)。前五章4.1–4.5正式封板不变。

## 1. 真正收到的R2文件及原始指纹

- Owner实际上传ZIP：`第四部分_第六章_独立Writer交付_R2.zip`，**47,499 bytes**；SHA256 `4b7718493853a9f2bcf8c6aefaf09248bdf0db60c90692d0612417c61a13b353`；ZIP CRC PASS，两份完整UTF-8 Markdown。
- Writer完整R2正文：`第四部分_第六章_独立Writer完整正文_R2.md`，**64,854 bytes／705行**，SHA256 `0065e4483acd7ce78e3474057dda732a2535251c93d20530d07e5aae5fb1c896`。
- Writer完整R2核验与逐项返修记录：`第四部分_第六章_独立Writer事实核验与逐项返修记录_R2.md`，**36,699 bytes／250行**，SHA256 `596fd0d67c37e71eb51eced40aa3632bd230658e05175a5f5d85f46d9f0b8130`。
- 完整正文冻结一级1/1、二级6/6、三级16/16通过；IATA正确标记例外、S3与CloudFront分流、签名验签、撤销全球沉默验收、Outbox本地事务和退避公式等有实质改善，不重写正文。Writer自评RESOLVED/PASS不是独立Reviewer PASS。

## 2. 独立复审C01–C06六组残留阻断

| 编号 | 定位 | 不能PASS的事实/反例 | Writer R3必须解决 |
|---|---|---|---|
| **C01 HIGH** | 4.6.4 L415–483 / SQL L461–472 | Stripe 2025-03-31 Basil起Subscription顶层周期字段已迁移到Subscription Item；旧Webhook可覆盖新续期；SQL没有有效付款及版本门槛；`NOW()+1year`重复执行3次并不等于自动累计3年 | 按API版本与Item周期分流、同业务期幂等及旧事件防回退、仅确认有效付款时开权；修正文/SQL/状态图/核验 |
| **C02 HIGH** | 4.6.6 L628–666 | Outbox `gen_random_uuid()`在重复支付事件中每次生成新任务，无订单+动作唯一约束；外部3PL可能出两份货，Worker ACK超时会重放。Outbox只保本地订单与意图原子性 | 持久动作唯一约束、Worker领取控制、外部业务幂等、未知状态查询/人工补偿；3PL HTTP200依具体接口而非统一物理出库 |
| **C03 HIGH** | 4.6.1.3 L123–131 | FTC现行规则：普通第三方信用卡付款及其他常见支付方式适用的退款通常为7工作日；“1个账单周期”是**卖家自己作为授信方**的销售类型，原文写反 | 精确按FTC规则付款形式和适用交易类别修正 |
| **C04 HIGH** | 4.6.1 L41–45,143–194；4.6.2 L237–251 | 2025-08-29美国CBP已暂停低值包裹通用800美元de minimis免税，原文仍把国际直邮描述为可利用小额免税；EU CE/RoHS/WEEE对全部电子产品一刀切；CN22/23与DDP/DAP表述条件不足 | 写清2026已核实美国政策与例外；按目的国/商品法规/邮政渠道/实际合同判断，正文/尾表/来源同步 |
| **C05 MED-HIGH** | 4.6.1.2 L90–103；4.6.2 L214–274；4.6.5 L543–550 | “只允许首次物理扫描后发任何发货通知”写成所有物流统一强制，忽略不同承运人/3PL/漏扫及合同定义；“服装必须验针”、定制必须指定印刷规格和输入迟交免责过度绝对化 | 分离面单、真实出库、承运接收与法律风险转移；按品类/合同检查安全与生产标准 |
| **C06 MED** | 4.6.6 L595–621,660,668–689及末表 | 2%错单率同时标`MODEL_ASSUMPTION`又称“强制红线”；Outbox防漏单承诺过强，核验表VERIFIED未反映真实边界 | 经验数字在正文就地标假设，给简短可复算成本决策实例，文/图/表/核验同步 |

**官方事实基础：**
- [Stripe Basil 2025-03-31字段迁移](https://docs.stripe.com/changelog/basil/2025-03-31/deprecate-subscription-current-period-start-and-end)、[SubscriptionItem API](https://docs.stripe.com/api/subscription_items/object)；
- [AWS Transactional Outbox](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html)、[AWS SQS重复消息](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/standard-queues-at-least-once-delivery.html)；
- [FTC 现行退款付款类别](https://www.ftc.gov/business-guidance/resources/business-guide-ftcs-mail-internet-or-telephone-order-merchandise-rule)；
- [CBP 2026-02-13低值暂停说明](https://www.help.cbp.gov/s/article/Article-1902)、[CBP 2026-02-27行政令指引](https://www.help.cbp.gov/s/article/Article-1919?language=en_US)；
- [欧盟委员会CE适用范围](https://single-market-economy.ec.europa.eu/single-market/goods/ce-marking_en)。

审查范围是公开规则与文稿技术一致性，**没有实际Stripe账单、Outbox并发、3PL订单、海关申报或法律合规测试**。完整逐项原因、行号、反例、R01–R09回归矩阵见本轮Owner下载的独立Reviewer完整Markdown报告。

## 3. 本轮R3完整离线工作包真实指纹与流转边界

- **本轮完整Reviewer报告**：`第四部分_第六章_Writer_R2_独立Reviewer完整审核报告_20261019.md`，**14,166 bytes**；SHA256 `d36715d4b4cd637b511b07cc63c904d487e62284ae80942b0c4dda98ab48368d`。
- **R3完整ZIP**：`第四部分_第六章_Writer_R2_R3完整定向返修包_20261019.zip`，**71,579 bytes**；SHA256 `cbffc039cd1377c1c5587e043c0b80614823f7c4544d3a5c36e47b567de3df0d`，**9份UTF-8 Markdown**、ZIP CRC PASS、逐文件SHA256清单PASS，**Writer R2完整正文和原事实核验记录逐字节保留**。
- 包内：先读、完整R2 Reviewer报告、**原R2完整正文**、**原R2完整自检**、R3指令、正式冻题6H2/16H3、官网核证、V1历史Reviewer报告、MANIFEST。**二进制仅在本轮Owner对话下载，没有上传GitHub**；待审正文不可成为`CHAPTER6_FINAL_SEALED.md`。
- **NEXT_STEP：** Owner把完整R3离线ZIP+转交话术发不具GitHub访问权限的Writer，Writer定向修C01–C06→回完整R3正文Markdown、事实核验/逐项返修Markdown及ZIP，`STOP_AT_REVIEWER`→Reviewer独立复审→只有Owner明确批准才能封板。**不启动4.7/HTML，保持4.1–4.5只读**。