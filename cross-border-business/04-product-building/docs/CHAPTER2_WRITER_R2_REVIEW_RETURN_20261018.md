# 第四部分第4.2章 Writer R2独立Review｜RETURN及R3定向返修记录

> **HISTORICAL_REVIEW_ONLY / SUPERSEDED_BY_OWNER_SEAL：** 本文件真实记录Writer R2交稿后当时Reviewer给出的RETURN，不再是当前任务。Owner随后特别授权Reviewer直接在完整R2基线上修复B01–B04并于2026-10-18正式封板，权威全文为[CHAPTER2_FINAL_SEALED.md](CHAPTER2_FINAL_SEALED.md)，封板证据见[CHAPTER2_SEAL_EVIDENCE_20261018.md](CHAPTER2_SEAL_EVIDENCE_20261018.md)。**没有Writer R3，不应再按本报告启动R3返修。**

> **REVIEW_DATE：2026-10-18**  
> **REVIEW_CONCLUSION：RETURN_CH2_R2_RESIDUAL_BUDGET_SOURCE_AND_CONSISTENCY_ERRORS**  
> **现行状态：CHAPTER2_R2_RETURN / R3_WRITER_PENDING / NO_SEALED_CHAPTER2_BODY**  
> **冻结框架：** [V2正式1/9/48/117](FROZEN_FRAMEWORK_V2_20261018.md)；本章4二级10三级全部标题逐字、同序同层级PASS。  
> **历史审核：** [Writer V1审核RETURN](CHAPTER2_WRITER_V1_REVIEW_RETURN_20261018.md)。

## 本轮输入、保全与结构结果

- 收到Owner上传 `第四部分_第二章_独立Writer_R2交付.zip`，ZIP SHA256 `f8ebf582f07e3436283b61405ec36fddaa1d9ca12fc737daf9cba29698146abf`，27,181 bytes，CRC校验PASS，含完整UTF-8 Markdown 2文件。
- Writer R2完整正文：33,347 bytes，359行，SHA256 `19baf267e64cce3c199c31e4436fff274d49a88e46a6a0e70128e9cd64234327`。
- R2核验与R1逐项返修记录：23,067 bytes，120行，SHA256 `a69fa8b334547ca60750b0f72ace4d38633832d4294bbe128e181540c4617cd9`。
- 第4.2章全部4H2/10H3精确通过；Writer R2的外加教学小标题未破坏冻结题目。
- 改进已证实：区分支付成功/结算、表格状态≠并发锁、业务形态分流、模型工时算术、配送区域及部分合规边界。但R2自评FIXED/VERIFIED不是独立验收证据。

## 四组残留阻断及最小返修目标

| 编号 | 正文R2定位 | 独立发现 | 复审通过标准 |
|---|---|---|---|
| **B01（高）** 预算算式 | 4.2.4.1正文L263–279写“5%风险”却乘10%得$150；虽列$3.67/单的逐单变动费，计算“可用采购预算$1,170”时完全没有扣任何预测订单的可发生履约支出。Reviewer举例若假设100订单且维持10%缓冲，则可预留采购余额`1500-180-150-100*3.67=803`，不是1170 | 纠正百分比和资金口径；给Q笔预测订单×逐单成本/人工/缓冲的复算关系，说明收入是否可以用作先期现金流；结论与数字一致 |
| **B02（高）** PCI事实与来源 | 4.2.3.2正文L229–231把PCI DSS v4.0授权后SAD不存储引为Req 3.2（适用核心要求是3.3/3.3.1）；核验L61把FAQ1533指为卡号经短信/聊天传输（实际FAQ1533讲SAD禁存）；另将“所有银行卡输入只能通过托管PSP”及严重处罚写成无条件全球规范 | 按PCI DSS 3.3/4.2.2与FAQ1085/1310分开核证；保留托管结账安全建议但不假称唯一合规方式；把处罚和法域边界写清 |
| **B03（中高）** 首版选择逻辑前后冲突 | 4.2.2.1正文L103把付费交易/对价确认为“唯一必要性尺度”，而L134允许免费试用；终章L350把无外部人工的全自助当必需Pass、L352又要求核心安全与付款“严格程序化”，与B2B人工确认及低量人工核对冲突 | 统一“按业务形态能安全完成承诺的客户任务”为原则；B2B定制、免费试用、平台托管均可通过合理条件验收 |
| **B04（中高）** 不合理的同步回跳验收 | 4.2.1.3正文L90要求支付成功后必须跳转订单确认页且“同时”后台收到异步通知；异步支付方式、通知延迟和用户不回跳是正常情况 | 拆分前台订单/待确认展示与后台支付事实/可履约判定；增加无回跳、延迟/重复事件的最小反例，不能用同步回跳作为付款及履约的硬门槛 |

**非阻断顺修：** L211自动化“即可显著收益”应以成本分析为准；L236“回填锁定”应称状态登记和复核而非真正技术锁；L333“欧盟VAT开票义务”应视卖家角色、交易类型及适用地规则决定。

## V1问题复审矩阵

| V1项目 | R2 Reviewer独立结论 |
|---|---|
| R01 支付事实 | PARTIAL：主要分层改善，B04仍阻断 |
| R02 表格伪锁 | PASS_WITH_NOTE |
| R03 四支柱普适性 | PARTIAL：B03仍阻断 |
| R04 功能裁剪 | PASS_WITH_NOTE |
| R05 数字模型 | PASS_WITH_NOTE |
| R06 预算 | RETURN：B01公式错误 |
| R07 依赖次序 | PASS_WITH_NOTE |
| R08 来源准确性 | RETURN：B02错号错链 |

## 一手核验URL（核验日期2026-10-18）

- [Stripe官方付款后事件及延迟支付](https://docs.stripe.com/payments/existing-customers?platform=web&ui=stripe-hosted)：依事件处理，不以回跳页单独触发履约；异步支付有后续成功/失败。
- [Google LockService](https://developers.google.com/apps-script/reference/lock/lock-service)：状态下拉≠实际代码并发互斥。
- [PCI SSC FAQ1533](https://www.pcisecuritystandards.org/faqs/1533/)：授权后SAD存储，**并非**消息传输。
- [PCI SSC FAQ1085](https://www.pcisecuritystandards.org/faqs/1085/) 与 [FAQ1310](https://www.pcisecuritystandards.org/faqs/1310/)：消息传输PAN保护要求。
- [PCI DSS v4.0 SAQ B](https://listings.pcisecuritystandards.org/documents/PCI-DSS-v4-0-SAQ-B.pdf)：3.3/3.3.1 SAD禁存。
- [FTC商品订单规则](https://www.ftc.gov/business-guidance/resources/business-guide-ftcs-mail-internet-or-telephone-order-merchandise-rule)：有形商品的特定美国邮购/互联网/电话订单，不能套全部服务。
- [Shopify运费区域](https://help.shopify.com/en/manual/shipping/setting-up-shipping-zones)：区域运费需按实际销售区域及成本配置。

## 已向Owner交付离线返修包

- ZIP名：`第四部分_第二章_Writer_R2_R3完整定向返修包_20261018.zip`
- SHA256：`1df9a5d6803e5984e96c9431ade870b97f65e02bf6cb0391c3689fa81957be12`；44,432 bytes，8份UTF-8 Markdown，CRC、逐文件原样和SHA256验收通过。
- 包含本轮完整独立报告、Writer R2 **全文只读基线**、Writer R2 **完整原核验记录**、上轮V1完整Reviewer审核报告、冻结4H2/10H3、完整Writer R3定向指令、逐文件SHA256清单。
- **ZIP仅在本轮Owner对话附件下载，不声称已上传GitHub二进制。**

**职责与下一步：** Owner将R3离线ZIP及提示词转交无GitHub权限的Writer→Writer依据其完整R2定向修正文稿，交完整R3正文+逐项修复/核验记录+ZIP，`STOP_AT_REVIEWER`→Reviewer独立复审→只有Owner批准才写4.2正式封板正文。不修改冻结框架/已封板4.1、不预写4.3章或HTML。
