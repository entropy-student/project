# 第四部分4.7章 Writer R2｜独立Reviewer RETURN与R3完整离线返修包登记

> **HISTORICAL_REVIEW_ONLY / SUPERSEDED_BY_OWNER_SEAL（2026-10-19）**：本文件是当时独立Reviewer对该版Writer候选的真实RETURN审核记录，**当前不再执行此返修Gate**。Owner随后明确授权Reviewer基于完整Writer R2直接修C01–C07并正式封板。[唯一正式4.7正文](CHAPTER7_FINAL_SEALED.md)及[审计证据](CHAPTER7_SEAL_EVIDENCE_20261019.md)为最终版本。**没有Writer R3交付**，旧R3完整返修ZIP未执行；当前继续4.8独立Writer首稿。

> **REVIEW_DATE：2026-10-19**  
> **VERDICT：RETURN_CH7_R2_RESIDUAL_REFUND_CANCEL_SECURITY_AND_EVIDENCE_ERRORS**  
> **CURRENT_STAGE：CH7_R2_RETURN / R3_WRITER_PENDING / NO_FINAL_CH7_BODY**  
> **唯一冻结权威：** [V2完整问题树1/9/48/117](FROZEN_FRAMEWORK_V2_20261018.md)，4.7章5H2/14H3逐字、同序、同层级PASS。  
> **原先4.1–4.6章正文均正式封板，不改动；4.8/HTML未启动。**

## 输入原件和审查方法

- Owner当前交付：`第四部分_第七章_独立Writer交付_R2.zip`，**37,549 bytes**，SHA256 `5de2b0eeaa8e176b41240be2f5874781239777c2e360d76e735baaba79c7f326`，ZIP CRC PASS。
- Writer完整R2正文 `第四部分_第七章_独立Writer完整正文_R2.md`，**44,483 bytes/440行**，SHA256 `4e7767f291f6cd950c3b89250ae3ba7f87fe68498cbc0ece57f0ffd9fc1a837f`。
- R2核验与B01–B10记录 `第四部分_第七章_独立Writer事实核验与B01-B10返修记录_R2.md`，**35,874 bytes/261行**，SHA256 `5a9017ef06b400ff0847fd5f817168b4802daf526345889043fe9c86b6f806ce`。
- 已读全文+自检和[上轮Writer V1 RETURN](CHAPTER7_WRITER_V1_REVIEW_RETURN_20261019.md)，按正式冻题核对5/14全部通过。B01–B10不少内容已改善，不能直接采信Writer的`RESOLVED/PASS`作为复审通过凭据。
- 独立复审主要围绕**退款对象与撤权SQL、订阅取消API默认行为、邮箱失联安全、下游3PL重试、补发库存和会计、PCI存储规范、欧盟撤回权与事实核验精准度**。仅静态审核与官方文档核验，未实际执行第三方API/银行账号/仓库流程。

## 7组残留阻断（详细行号、复现反例及验收见离线完整报告）

| 级别 | 编号 | Writer R2位置 | 阻断原因和最低修复 |
|---|---|---|---|
| CRITICAL | **C01 退款事件及撤权SQL** | L228–281 | SQL **先撤权，最后才对event ID插入审计ON CONFLICT**，错误去重顺序；退款事件与订单项/履约单位映射未可信核查；同一行项多份授权会被全部撤销；累计金额无单调校验。需持久退款业务唯一约束、成功状态/币种核对、先判断新业务事实再变更权限，跨系统Outbox与补偿 |
| HIGH | **C02 Stripe订阅取消误述** | L295–304 | Stripe Cancel Subscription API**默认立即取消**，不是“普遍默认期末取消”；`prorate`默认false，不自动生成信用余额。期末取消须`cancel_at_period_end=true`，信用额/实际Refund/授权期独立核实 |
| HIGH | **C03失联邮箱替代验证风险** | L143–150 | 原稿虽不再直接使用卡末4放行，但推荐“银行App专属授权冲正代码、支付渠道短信”作为统一不可伪造凭据，没有可靠通用商户核验接口，易诱导收集银行动态验证码。应改为已认证账户、PSP正式核验流程或安全人工升级 |
| HIGH | **C04外部重试与3PL未知结果** | L313–363 | 对429/502/503默认“安全重试”不能推定不可逆写操作没执行；5–15分钟查无订单也非充分未执行证明；3PL并非天然对商户单号实施唯一约束。按操作风险、下游已验证幂等和事实查询分流，无保证则暂停/人工 |
| MED-HIGH | **C05补发库存及会计硬规则** | L62–81、L89–103 | 仍强制0元子单、再扣Available、保证归保修/营业外支出；平台原生售后可采用不同实现，重复扣减已预占库存危险；P.O.Box收货能力受国家/承运商约束。使用条件分流 |
| MED-HIGH | **C06 PCI条款和保存期** | L406–423 | PCI 3.5.1要求PAN在存储时不可读，但不限于强加密（还可符合要求地截断/哈希/令牌化），3.4.1掩码受BIN/角色影响；3–7年只是假设而不是全球法定期限 |
| MED-HIGH | **C07适用边界、证据与R2自检** | L204–222、L389–398及核验文档 | 欧盟数字豁免三前提改进，但付费数字内容/服务及durable medium（不仅邮箱）要分流；Visa争议证据依理由码、收单行和渠道实际规则；核验多项只有机构名没有精确一手文档，所有题皆PASS不成立；自检说“20处冻题”实际5+14=19题 |

**上轮B01–B10回归**：B01 PARTIAL→C07；B02 PARTIAL→C03；B03 RETURN→C01；B04 RETURN→C02；B05 PARTIAL→C05；B06 PASS_WITH_SCOPE_NOTE；B07 RETURN→C04；B08 PASS_WITH_NOTE；B09 PARTIAL→C06；B10 RETURN→C07。

## 一手核验入口

- [Stripe取消订阅API](https://docs.stripe.com/api/subscriptions/cancel)、[Stripe订阅取消教程](https://docs.stripe.com/billing/subscriptions/cancel)；
- [Stripe事件类型（包含部分退款）](https://docs.stripe.com/api/events/types)、[Refund对象](https://docs.stripe.com/api/refunds/object)；
- [OWASP找回凭据](https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html)；
- [PCI SSC FAQ1492](https://www.pcisecuritystandards.org/faqs/1492/)、[FAQ1071](https://www.pcisecuritystandards.org/faqs/1071/)；
- [欧盟2011/83/EU 16(m)/8(7)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02011L0083-20260927)；
- [Visa CE3.0 10.4](https://usa.visa.com/content/dam/VCOM/regional/na/us/support-legal/documents/evolution-of-compelling-evidence-merchant-faqs-mar2023.pdf)。

## Owner本轮真实获得的完整R3离线包

- 完整独立Reviewer报告：`01_Writer_R2_独立Reviewer完整审核报告_20261019.md`，**13,151 bytes**，SHA256 `613d66226b425f853ace6afc9ac6d140844d5db3b01870f6727ea583188609a2`。
- **R3 ZIP：`第四部分_第七章_Writer_R2_R3完整定向返修包_20261019.zip`**，**60,584 bytes**，SHA256 `59a51d65add3fd502fe43914af19235640786820d9c8df54f3c9878ee6ff5bac`。
- 内含**9份UTF-8 Markdown**（8资料+SHA256清单）：先读、完整R2 Reviewer报告、原R2全文**原字节**、原R2核验**原字节**、R3定向返修、全部5H2/14H3冻题、官网核证、V1原Reviewer完整报告、逐文件指纹。ZIP CRC、UTF-8、逐文件SHA256和与原R2字节一致性PASS。
- **ZIP二进制只在Owner当前对话提供下载，未上传GitHub，R2候选正文不等于正式封板正文。**

**NEXT_STEP**：Owner把R3 ZIP和可复制指令发独立Writer，Writer以自己完整R2正文为基线，修C01–C07并提交R3**完整正文+完整逐项核验+ZIP**，`STOP_AT_REVIEWER`→Reviewer独立复核→只有Owner批准才封板。当前不得写4.8或HTML。
