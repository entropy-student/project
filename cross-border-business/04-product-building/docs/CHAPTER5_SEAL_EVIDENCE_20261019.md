# 第四部分《产品搭建》4.5章｜Owner授权Reviewer直接修订与正式封板证据

> **DATE：2026-10-19**  
> **STATUS：CHAPTER5_FINAL_SEALED / OWNER_APPROVED_DIRECT_REPAIR / TEXT_QA_PASS**  
> **权威全文：** [CHAPTER5_FINAL_SEALED.md](CHAPTER5_FINAL_SEALED.md)。  
> **冻结基准：** [FROZEN_FRAMEWORK_V2_20261018.md](FROZEN_FRAMEWORK_V2_20261018.md)，本章5H2/12H3。  
> **没有Writer R3交付。** 本轮只是Owner授权Reviewer直接修补Writer R2已有完整原稿；不改变后续Writer先写完整初稿的规范。

## 1. 决策与来源链

Owner在收到[Writer V1独立RETURN](CHAPTER5_WRITER_V1_REVIEW_RETURN_20261019.md)与[Writer R2独立RETURN](CHAPTER5_WRITER_R2_REVIEW_RETURN_20261019.md)之后，特别授权：“这部分内容暂时由你来修改完成之后嗯，正式冻结，然后填入我们的项目库当中。记得记录相关文档。完成之后开启下一个1级问题的部分。”

- Writer R2原ZIP：`第四部分_第五章_独立Writer_R2交付.zip`，**32,598 bytes**，SHA256 `3847e571be5b0cac38c5f6b8b4a196bfb3aa5d4cb9609646ca00717101ab5950`，CRC PASS。
- 原完整Writer R2正文 `第四部分_第五章_独立Writer完整正文_R2.md`：42,946 bytes，SHA256 `74ab7ce8b7e18535bebcb433ef5e8fd664a5cc9e3ad5c6ea0cefa423b0ada3d6`。
- 原完整Writer R2核验 `第四部分_第五章_独立Writer事实核验与逐项返修记录_R2.md`：24,879 bytes，SHA256 `3cd6ebe20b60e6f26a56525d9b44f5349f405b9ac4c857720c5e58d73a224e2d`。
- 正式正文创建commit **`57a9a192b178d7f3fc8c6647df3db07699e591e6`**，GitHub原文blob SHA `d370401cf78c27984350bfaaa9b39b5534ac2636`，回读23282字符。此正式正文**不是Writer R3**，没有伪造Writer继续返修的记录。原R3离线ZIP只是一份曾准备的候选任务资料，Owner后来选择直接授权Reviewer修订。

## 2. C01–C05五组定向修订及核证

| 编号 | 定向变更与必要反例 | 官方事实来源与结果 |
|---|---|---|
| **C01卡密并发唯一性** | §4.5.3.3把原只锁码池一张空闲码的`FOR UPDATE SKIP LOCKED`示例改成**订单行项+交付单位**持久唯一约束，`license_assignments`主键`(order_item_id, unit_no)`且`UNIQUE(key_id)`；同行项可合法买多件；锁具体履约单位、事务分配、冲突回滚和交付事实分层。SQL明确是教学性片段，不假冒可直接生产运行的完整代码 | [PostgreSQL Unique Indexes](https://www.postgresql.org/docs/current/indexes-unique.html)、[Transaction Isolation](https://www.postgresql.org/docs/current/transaction-iso.html)。反例：同订单相同unit两个并发线程各锁不同卡；旧`NOT EXISTS`不具备真正唯一约束。PASS（文本语义） |
| **C02 Stripe对象和资金层次** | §4.5.3.2区分PaymentIntent的`metadata`与Checkout Session的`client_reference_id`；安全关联订单、商户、币种及支付对象；将`PAID`从“已到账”改为**成功付款事实**，区别履约资格、结算/可用余额/银行到账与合法B2B信用交货 | [PaymentIntent](https://docs.stripe.com/api/payment_intents/object)、[Checkout Session](https://docs.stripe.com/api/checkout/sessions/object)；PASS |
| **C03库存双扣和状态冲突** | §4.5.1将Shopify原生`Committed`与自建支付前临时预占分开，**唯一控制点**完成一次占用；预占转付款不可二次扣减。§4.5.2独立记录已履约后退货、部分退款、后续争议，旧通知仅按具体维度/版本去重；库存释放只释放实际有效占用 | [Shopify Inventory States](https://help.shopify.com/en/manual/inventory-and-locations/fundamentals/inventory-states)、[Shopify开发者2026-08-05库存状态变更](https://shopify.dev/changelog/posts/draft-order-and-transfer-shipment-inventory-is-moving-from-reserved-to-committed)；PASS |
| **C04多渠道配额强保证** | §4.5.4保留500分成200/200/100的教学例子，但配额有效依赖各平台严格禁止超额卖出、互不重叠、仓库差异及时记账、跨池转配先撤旧后增新；更正图文“100%杜绝超卖”，主动下架API仍可能有时延 | 平台设置需具体核验；配额是**有条件策略**而非事实绝对承诺。PASS |
| **C05审计PII与留存** | §4.5.2.3用已掩码变更摘要及受控记录引用取代完整门牌号Before/After；§4.5.5说明卡品牌+末四位是低风险展示建议，不是PCI唯一允许显示组合；删除全球统一照片30–90天、地址1年哈希化的法律主张，区分模型假设、合法保留/争议及备份生命周期 | [GDPR Article 5](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng)、[ICO存储期限](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-protection-principles/a-guide-to-the-data-protection-principles/storage-limitation/)、[OWASP Logging](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html)、[PCI SSC FAQ1533](https://www.pcisecuritystandards.org/faqs/1533/)；PASS |

**已完成的跨章节回归**：全文SQL、Mermaid、章节叙述及结尾自检表一致性复查，4.1–4.4正文未修改。无部署/实际支付/发货/真实并发测试；不得把文档封板理解成系统可运行或合规保证。

## 3. 唯一正式冻题逐题索引（重新核对，不直接采信Writer自评）

| 正式问题编号 | 原题 | 层级 |
|---|---|---|
| 4.5.1 | 商品和可卖数量怎么管？ | 二级 |
| 4.5.1.1 | 每个规格、名额或数字码要怎么分别记账？ | 三级 |
| 4.5.1.2 | 商品修改或停售，旧订单如何保持原承诺？ | 三级 |
| 4.5.2 | 订单从创建到完成该怎么记录？ | 二级 |
| 4.5.2.1 | 至少需要哪些状态，什么时候允许变化？ | 三级 |
| 4.5.2.2 | 取消、部分履约及状态错位怎么标记？ | 三级 |
| 4.5.2.3 | 谁能修改订单，修改记录去哪查？ | 三级 |
| 4.5.3 | 怎样核对付款后再交付？ | 二级 |
| 4.5.3.1 | 客户上传付款截图可以直接发货吗？ | 三级 |
| 4.5.3.2 | 通知迟到、重复或不匹配时怎么办？ | 三级 |
| 4.5.3.3 | 哪些业务动作只允许成功一次？ | 三级 |
| 4.5.4 | 同时有人下单，怎样避免超卖？ | 二级 |
| 4.5.4.1 | 下单时预留库存还是付款后扣减？ | 三级 |
| 4.5.4.2 | 多个渠道同时卖同一件货怎样核对？ | 三级 |
| 4.5.5 | 后台员工能访问哪些客户资料？ | 二级 |
| 4.5.5.1 | 客服、仓库和外包需要哪些不同权限？ | 三级 |
| 4.5.5.2 | 哪些资料不应直接展示或长期保存？ | 三级 |

**独立校验**：5二级/12三级，17/17全部标题逐字同序同级PASS；无额外4.5.x冻结题号。正文重要误述残留检查PASS。

## 4. 归档与下一一级

- **CHAPTER5_FINAL_SEALED / OWNER_APPROVED**。Writer V1/R2 RETURN报告为真实历史审核，但应标记为已被Owner决策取代的历史；首稿Gate及旧离线包清单在当前main目录退出，保留正常Git提交历史。
- **NEXT：4.6《怎么把产品交付到客户手里？》**，完整正式冻题为**6二级/16三级**；仅发布独立Writer首稿Gate/全套离线自包含ZIP和可复制话术，Writer自由撰写完整首稿，Reviewer只复审，Owner最后决定封板。不得预写4.6正文、不启动4.7或HTML。