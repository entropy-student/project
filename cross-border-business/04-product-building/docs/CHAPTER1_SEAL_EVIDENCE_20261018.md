# 第四部分《产品搭建》4.1章｜Owner授权Reviewer直接定向修订及正式封板记录

> **DATE：2026-10-18**  
> **OWNER_DECISION：** R2完成独立Review后，Owner明确授权：“这部分内容暂时由你来修改完成之后嗯，正式冻结，然后填入我们的项目库当中。记得记录相关文档。完成之后开启下一个1级问题的部分。”  
> **STATUS：CHAPTER1_FINAL_SEALED / OWNER_AUTHORIZED_REVIEWER_DIRECT_REPAIR / QA_PASS**  
> **权威正文：** [CHAPTER1_FINAL_SEALED.md](CHAPTER1_FINAL_SEALED.md)。**不是Writer R3**；下一章重新采用独立Writer首稿机制。

## 1. 基线、决策与权限

- 唯一冻结框架：[V2完整1/9/48/117](FROZEN_FRAMEWORK_V2_20261018.md)，原核心“产品怎么做、怎么交付？”未改。第4.1章冻结4个二级、10个三级。
- 独立Writer R2完整交付：`第四部分_第一章_独立Writer_R2交付.zip`，ZIP SHA256 `fc51608eaadbef35361fc1887e7da9e30b72c3f4db12d9b3956cc704e5627002`；正文 29,762 UTF-8 bytes，SHA256 `087982920bb7d280a96d66cf3bca87f4a1e988fd4368c99e9b314a79957aa19d`；自检24,566 bytes，SHA256 `6386d53e657ba8088f5e8ae580ed4bf1f5e05887fc6ae730592bb0f8e958d6c8`。
- Reviewer R2独立结论：`RETURN_R2_RESIDUAL_FACTUAL_ERRORS_AND_SOURCE_MISMATCH`，只剩B01–B06六组事实/方法与来源阻断。Owner此后特别授权Reviewer基于**完整R2稿**直接最小修改封板。
- **没有Writer R3交付，不得杜撰。** R2原件与Reviewer完整报告保存在原对话可交付ZIP和正常历史记录，main只保存最终正式正文、必要封板证据与当前Writer Gate。

## 2. 六组残留问题的最小修订与核验

| 编号 | 具体修订及正文位置 | 核验依据与边界 | 复核 |
|---|---|---|---|
| **B01** 费用 | §4.1.3.2 Gumroad按销售来源区分直接销售10%+$0.50、Discover引入新买家30%；§4.1.1.3区分自管站点、托管型Shopify等平台交易费与支付机构处理费，不再称“自有网站无平台交易抽成” | [Gumroad定价](https://gumroad.com/pricing)、[Shopify第三方交易手续费](https://help.shopify.com/en/manual/your-account/manage-billing/billing-charges/types-of-charges/third-party-charges/third-party-transaction-fees)；费率随套餐/地区/交易渠道变化 | PASS |
| **B02** PCI范围 | §4.1.1.2取消“托管输入框直接适用SAQ A”；补全部适用条件、付款页元素来源、脚本风险和收单方/支付品牌确认；不展开支付合规教材 | [PCI SSC FAQ1438](https://www.pcisecuritystandards.org/faqs/1438/)、[FAQ1588](https://www.pcisecuritystandards.org/faqs/1588/) | PASS |
| **B03** 权益事件 | §4.1.3.1图区分按已付期限/合同调整权限；正文明确取消下次续费≠立刻终止当前已付期；到期、立即终止、全额/部分退款、已消费服务各按有效合同和已确认状态分流；更新承诺仅在产品确有内容更新约定时成立 | 产品侧权益逻辑与服务条款；退款资金及争议金融判断属于第三板块 | PASS |
| **B04** 形态选择 | §4.1.1.3明确平台+外部交付、托管及自有入口的条件选择；文末定制商品也可在具备平台功能时使用Etsy等；Web可受缓存和旧会话影响 | [Etsy Custom options](https://help.etsy.com/hc/en-us/articles/360000344528-How-to-Offer-Personalized-Listings)，与正文§4.1.2.3的Service Worker/缓存解释一致 | PASS |
| **B05** 失真的UNKNOWN | 未将R2 Writer自检报告的“美国/欧盟尚未生效”抄入正式正文，另明确记录两项已生效政策：美国自2025-08-29暂停有关低价值包裹de minimis免税待遇；欧盟自2026-07-01对规定范围的低于150欧元小包裹按商品类别执行过渡性€3关税；实际适用/豁免另查 | [CBP官方](https://www.help.cbp.gov/s/article/Article-1919?language=en_US)、[欧盟理事会2026-02-11](https://www.consilium.europa.eu/en/press/press-releases/2026/02/11/council-gives-final-green-light-to-new-customs-duty-rules-for-small-parcels/)；这些事实用于纠正自检，不扩写到本章主体的海关教程 | PASS |
| **B06** 来源可靠性 | 不承继Writer R2自检“一切VERIFIED”错误断言，新增本次Reviewer独立修订矩阵；Amazon登录墙G1701仅为需核实的政策入口，不能单凭登录页面宣称公开核证链接例外；PCI替换组织首页为精确官方FAQ；韩国PCCC仍须以具体报关模式及当期海关要求核验，UNI-PASS入口首页不证明每种代码规则 | 精确官方来源与限制；正文保留韩国代码作为按实际场景核查的信息提示，不承诺所有清关方式只用一种代码 | PASS |

**顺手消除的非阻断残留：** §4.1.4.1将资料齐全后起算工期改为下单前披露、双方约定且符合适用规则的条件性说法；§4.1.3.2使MoR税务责任不再“全球无条件适用”；正文保留正确的SmartScreen/IAP/浏览器权限等知识不重写。

## 3. 重新回读正式正文的验收结果

| 审核项目 | 核验结果 |
|---|---|
| 当前main正式正文 | `cross-border-business/04-product-building/docs/CHAPTER1_FINAL_SEALED.md` |
| 正式正文blob SHA | `8c9fb66afe1e0c28f098dae237757dff13477419` |
| 正文文本 | 294行，14,014个JS字符（Unicode计数；真实字节数以Git读取/转码为准） |
| 冻结原题 | 4/4二级，10/10三级；均与最新V2框架逐字、同序、同级，未改一个原题；核心保持原样 |
| 内容闭环 | 15处定向文本修订；涵盖B01–B06及三个直接相关的小边界修正 |
| 独立QA探针 | 直连/Discover费率、Shopify交易费、SAQ A限定、取消续费权益、Web旧版本、Etsy定制、Amazon登录墙、无R3及旧错误语句删除均通过 |
| 性质 | **文稿质量封板**，不是实际经营主体准入、服务商账号获批、收款、清关、系统/软件部署实测 |

## 4. 归档、治理与下一步

- **只读权威：** 本章唯一正式正文为`CHAPTER1_FINAL_SEALED.md`，本文件为必要历史审计证据；Writer R1/R2 RETURN稿不与正式正文并列。
- **框架不变：** V2全部1/9/48/117继续FROZEN；没有改其他四个业务板块或第三板块支付指南。
- **新当前任务：** 第4.2章《第一版先做哪些东西？》，冻结4道二级/10道三级；Reviewer只负责准备离线Writer首稿Gate/工作包/提示词，独立Writer撰写完整候选；没有Owner对4.2正文的代写或封板授权。
- **后续审查：** 独立Writer交完整正文、官方核验与自检记录和ZIP→Reviewer独立Review；若RETURN必须同轮给完整返修ZIP和Owner可直接转发话术；Owner批准后才封板。
