# 第二板块｜第③章《域名与邮箱》Owner授权定向修订与正式封板证据

> 记录日期：2026-10-18  
> 状态：`CHAPTER3_FINAL_SEALED / OWNER_AUTHORIZED_DIRECT_CORRECTION`  
> 本章唯一正式正文：`CHAPTER3_FINAL_SEALED.md`。本文件属于审计/交接记录，不是另一版教学正文。

## 一、来源与授权

- 原始Writer R1经Reviewer判`RETURN_FACTUAL_ACCURACY_AND_IMPLEMENTATION`，标出R01–R12，随后Writer独立提交R2完整正文与来源自检记录。
- R2完整正文：85,219 字节，SHA256 `789b86c6fa098a9b24a83e89b948af42326be8f0497a5747d71c35eb32644d6f`；R2独立核验记录：29,733字节，SHA256 `ad7ffd73690721aca38458e8fdf8586237ed7d831b3124517155c69f98b8858b`。来源：Owner在本次对话上传的《第三部分_域名与邮箱_Writer_R2返修交付.zip》，Reviewer完整读取及校验。
- Reviewer R2结论：`RETURN_R2_FACTUAL_RESIDUALS_AND_SOURCE_MISMATCH`，仅七组阻断B01–B07，其余已经修复的DNS、TLS、DMARC等知识不应反复重写。
- **Owner本轮明确授权**：“这部分内容暂时由你来修改完成之后嗯，正式冻结，然后填入我们的项目库当中。记得记录相关文档。完成之后开启下一个1级问题的部分。”本次授权仅适用于本章的一次性Reviewer直接定向修订；其他章继续独立Writer→独立Reviewer→Owner验收流程。

## 二、B01–B07逐项收尾

| 审核编号 | 最小修复实施 | 验收依据及边界 |
|---|---|---|
| B01 | ICANN FY26浮动交易费不再称提案，注明2025-07-21批准、2025-07-01生效、每年度增量适用交易收取0.20美元 | ICANN正式公告 https://www.icann.org/zh/announcements/details/icann-accredited-registrars-approve-registrar-level-fees-for-fiscal-year-2026-21-07-2025-zh；不等同统一消费者加价 |
| B02 | Amazon品牌备案从无法证实的同域邮箱“常见审核凭据”改为官方品牌备案条件；Stripe普通商户核验引用从Treasury路径改为Stripe Support对应资料；不对其他支付服务商扩展统一要求 | Amazon官方 https://brandservices.amazon.com/brandregistry/eligibility；Stripe官方 https://support.stripe.com/questions/what-do-i-need-to-do-to-verify-my-stripe-account/；并不保证自动获批 |
| B03 | 域名到期续费、RGP恢复的价格和时限按具体后缀与注册商条款，删除未证实的赎回价区间和“标准价”保证 | ICANN https://www.icann.org/resources/pages/registrant-about-errp-2018-12-07-en；零售价格并无统一固定上限/区间 |
| B04 | 198.51.100.22明确为RFC5737 TEST-NET-2教学占位，生产需替换真实公网IPv4；CAA标注是否已配置及Shopify官方指引的条件 | RFC https://www.rfc-editor.org/rfc/rfc5737；Shopify原正确A/AAAA/CNAME示例保留 |
| B05 | Gmail与Yahoo分开写；Gmail适用的5,000封/日分类不可映射Yahoo；一键退订补`List-Unsubscribe`+`List-Unsubscribe-Post`及DKIM覆盖说明、正文退订、事务邮件边界 | Gmail https://support.google.com/mail/answer/81126；Yahoo https://senders.yahooinc.com/faqs/；RFC https://www.rfc-editor.org/rfc/rfc8058 |
| B06 | 移除“域龄30天”与“硬退信率2%统一触发”虚构门槛；保留冷启动/退信监控的条件化建议及无统一阈值说明 | M3AAWG目录页不支持确定的数字阈值；如引用具体服务商警戒线应另核服务商、版本与指标定义 |
| B07 | 1席位预算10–15+72+12–60=$94–147/年；2席位10–15+144+12–60=$166–219/年；阶段4不再无依据给出300–1000+，统一标MODEL_ASSUMPTION；引用索引限定可核查范围 | 仅为演算教学假设，不是实时零售报价，也不包括全套开店或税费成本 |

**额外最小修复：** 域名管理邮箱不应依靠同域邮箱形成恢复死锁；DKIM DNS公钥用于验签而非“解密”；保留原有正确的Shopify DNS、Cloudflare SSL、2026 TLS有效期与邮件认证系统知识。

## 三、结构与范围检查

- 标题对照基线：`FROZEN_FRAMEWORK_V5_20261018.md`，第③章**1一级、5二级、10三级**。正文逐字、同顺序、同层级保留全部5+10原题；未调整全书冻结**8/44/93**。
- 原R2稿知识主体及案例结构保留；本轮仅纠正上述事实、引用、费用与直接相关的保证性表述。
- 正式正文：`CHAPTER3_FINAL_SEALED.md`，**87,009字节**，SHA-256：`0dcf83b2a7ec960895214b658a946352da2068945b80fe8345566c1ece2ad4b8`。以GitHub `main`最终回读为准。
- 官网/协议核验指向具体公开页面；商户准入、价格、注册商实际期限、邮箱实际投递等**不会因本文封板而获得合同或运行保证**；未访问真实注册商后台、未变更生产DNS、未部署邮件服务。
- 没有Writer R3；Owner直接授权Reviewer基于Writer R2完成定向修订与封板。不能把此特殊授权推广为“以后所有RETURN自动放行”。

## 四、版控与下一步

采用第三板块相同的简洁架构：**一份冻结框架＋每章`CHAPTERN_FINAL_SEALED.md`＋唯一交接文件＋必要审计证据**。本章封板后清退已完成的旧第③章 Writer Gate/ZIP，Git自然历史可追溯。

**下一章④《网站与程序运行》**：只发布自包含离线8文件Writer首稿工作包，标题冻结6个二级/13个三级；独立Writer自由决定篇幅、案例、表达、工具选择，交完整正文和核验记录给Reviewer。若需返修，Reviewer必须同步给Owner完整返修ZIP与可转发提示词；未经Owner后续批准不得将④正文封板。
