# 第四部分4.5章 Writer R2｜独立Reviewer审核RETURN及R3完整离线工作包

> **DATE：2026-10-19**  
> **VERDICT：RETURN_CH5_R2_RESIDUAL_CONCURRENCY_PAYMENT_STATE_AND_RETENTION_ERRORS**  
> **CURRENT_STATUS：CHAPTER5_WRITER_R2_REVIEW_RETURN / R3_WRITER_PENDING / NO_SEALED_CH5_BODY**  
> **冻结框架：** [V2正式1核心/9一级/48二级/117三级](FROZEN_FRAMEWORK_V2_20261018.md)，本章5二级/12三级标题逐字、同序、同级PASS；4.1–4.4已封板不变。  
> **前轮审核：** [Writer V1 RETURN与B01–B08](CHAPTER5_WRITER_V1_REVIEW_RETURN_20261019.md)。

## 输入、完整性、结构QA

- Owner上传原始`第四部分_第五章_独立Writer_R2交付.zip`：**32,598 bytes**，SHA256 `3847e571be5b0cac38c5f6b8b4a196bfb3aa5d4cb9609646ca00717101ab5950`；ZIP CRC PASS，两份完整UTF-8 Markdown。
- 完整Writer R2正文：`第四部分_第五章_独立Writer完整正文_R2.md`，42,946 bytes/510行，SHA256 `74ab7ce8b7e18535bebcb433ef5e8fd664a5cc9e3ad5c6ea0cefa423b0ada3d6`。
- 完整核验和B01–B08返修记录：`第四部分_第五章_独立Writer事实核验与逐项返修记录_R2.md`，24,879 bytes/130行，SHA256 `3cd6ebe20b60e6f26a56525d9b44f5349f405b9ac4c857720c5e58d73a224e2d`。
- 一级1/1、二级5/5、三级12/12标题一致PASS；Writer R2对库存四态、分维状态、Webhook可靠落库、跨渠道并发风险、末四位身份误用等做了有价值的修复，**无需推倒重写**。
- **本轮为独立Review，不采信Writer自评FIXED/VERIFIED作封板证据。**

## 五组残余阻断及最低修复条件

| ID | Writer R2准确位置 | 残留风险 | 修复与验收标准 |
|---|---|---|---|
| **C01 HIGH** | §4.5.3.3 L320–351，卡密SQL/流程图 | `FOR UPDATE SKIP LOCKED`锁住不同的未用卡密行，`NOT EXISTS`不是对“同订单/同一履约动作”的并发唯一约束；两请求可分别锁两张卡且同时看不到另一笔未提交更新，重复分配仍可能发生 | 采用订单项+单位/业务动作粒度的DB唯一索引/约束、锁定唯一订单记录的串行化或等效可靠手段；可购买多件时正确处理数量；SQL、Mermaid与原核验记录一致 |
| **C02 HIGH** | §4.5.3.2 L301–310，§4.5.2.1 L176–179 | `client_reference_id`实际属于**Checkout Session**，并非`payment_intent.succeeded`的PaymentIntent通用字段；成功付款被写作“到账” | 按对象/事件类型分别使用PI`metadata`与Checkout Session`client_reference_id`等合法关联字段；确认订单金额/币种/商户，区分付款成功、可履约、结算、银行到账 |
| **C03 MED-HIGH** | §4.5.1.1 L59–71，§4.5.2.2 L205–209，§4.5.4.1 L368–387 | 平台Committed与临时结账预留相混，“下单或付款”同时增Committed可能导致重复扣库存；订单状态全局“只向前”与退货/退款/纠错后续事件冲突 | 分清平台原生库存状态与自建预占、唯一扣减控制点/超时释放/退款补偿；仅在特定维度/事件版本实施不倒退，不拒绝合法售后 |
| **C04 MED-HIGH** | §4.5.4.2 L406–421 | 把三渠道200+200+100静态配额无条件称作“100%杜绝多渠道并发超卖”；不考虑渠道超额卖出、平台设置、库存调拨和不一致 | 保留正确配额示例但说明成立条件、跨池转配、平台与库存异常；共享缓冲降低风险而非零超卖保证 |
| **C05 MED-HIGH** | §4.5.2.3 L217–236；§4.5.5.2 L474–490 | 审计示例仍写出完整地址Before/After，与“已脱敏”自检矛盾；照片30–90天、地址一年哈希化被写成普遍应执行期限；“卡品牌+后四位唯一允许展示”过度解读PCI | 改示例只记必要差量、引用或受控日志；按适用法域、目的、争议及合同判断保留期限，教学数字仅模型假设；PCI最小展示与法律强制条件区分 |

**V1问题回归**：B01 PARTIAL→C03；B02 PARTIAL→C03；B03 PARTIAL→C02；B04 PASS_WITH_NOTE；B05 RETURN→C01；B06 PARTIAL→C04；B07 PARTIAL→C05；B08 PARTIAL→C02–C05。具体反例、实施/事实来源和不重写边界详见对话交付的Reviewer完整报告。

## 本轮独立核查官方来源

- [PostgreSQL事务隔离](https://www.postgresql.org/docs/current/transaction-iso.html)与[唯一索引](https://www.postgresql.org/docs/current/indexes-unique.html)：事务快照下`NOT EXISTS`不会自动强制跨行唯一。
- [Stripe PaymentIntent](https://docs.stripe.com/api/payment_intents/object)与[Checkout Session](https://docs.stripe.com/api/checkout/sessions/object)：两者不是同一API对象，`client_reference_id`属于后者。
- [Shopify Inventory States](https://help.shopify.com/en/manual/inventory-and-locations/fundamentals/inventory-states)：On hand由Available、Committed和Unavailable组成，Committed有平台内特定用途。
- [GDPR Article 5](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng)、[ICO Storage Limitation](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-protection-principles/a-guide-to-the-data-protection-principles/storage-limitation/)、[OWASP Logging](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html)：留存期按必要性与适用义务核定；日志应限量保护个人数据。
- 本轮**静态文稿与规则核验**，未实际登录支付/电商平台或执行PostgreSQL并发实测，不得冒称已实测。

## 本轮提供的完整离线R3包及可追溯文件指纹

- Reviewer报告：`01_独立Reviewer_R2完整审核报告.md`；**10,931 bytes**；SHA256 `088ce59b9f6f0af2dc285a94ae1ed81d282d8f9be8b47fcafb5f152b38d45aae`。
- **R3完整ZIP**：`第四部分_第五章_Writer_R2_R3完整定向返修包_20261019.zip`；**50,991 bytes**；SHA256 `34551c1755259b662e212a9ca6015c9f40f783da34cf1be1f622f67ef3f1d9cf`；**9份UTF-8 Markdown**（8份资料+SHA256清单），ZIP CRC PASS、Writer R2两份完整原稿逐字节保持。
- 内含：先读、完整本轮审稿、**原R2完整正文**、**原R2完整核验记录**、R3定向指令、V2全部导航与本章5/12冻题、上轮V1完整Reviewer报告、官方来源与适用边界、逐文件SHA256清单。Writer **无需GitHub权限**。
- **ZIP只在Owner本轮对话下载，并未上传GitHub二进制，也未将待采纳R2稿冒充正式封板正文**。

**NEXT_STEP**：Owner将完整R3 ZIP与转交话术交独立Writer→Writer在自己R2全文基础上定向修C01–C05，交完整R3正文、逐项核验和ZIP，`STOP_AT_REVIEWER`→Reviewer独立复审→Owner批准才正式封板第4.5章。**第4.6章和HTML未启动。**