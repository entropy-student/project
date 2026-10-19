# 第四部分4.7章｜Writer V1独立Reviewer完整审核RETURN及R2离线返修登记

> **DATE：2026-10-19**  
> **VERDICT：RETURN_CH7_V1_LEGAL_ACCESS_REFUND_AND_EVIDENCE_ERRORS**  
> **CURRENT_STATUS：CHAPTER7_V1_REVIEW_RETURN / WRITER_R2_PENDING / NO_SEALED_CH7_BODY**  
> **冻结权威：** [V2问题树1核心/9一级/48二级/117三级](FROZEN_FRAMEWORK_V2_20261018.md)；4.7章5个二级/14个三级严格逐字、同序、同级PASS。  
> **4.1–4.6六章Owner正式封板正文不变；不得启动4.8或HTML。**

## 1. 原始文件与无损取证

- Owner提供`第四部分_第七章_独立Writer交付_V1.zip`：**28,384 bytes**；SHA256 `b1294c5d82f3d7b81183a5a9eb9ffe37dd28523840666ab87aca4242c6f81d3d`；ZIP CRC PASS，2份完整UTF-8 Markdown。
- 正文`第四部分_第七章_独立Writer完整正文_V1.md`：**40,735 bytes／434行**，SHA256 `7560339c04f0f71cea43bebfa527a17259a35171da8178e3fa3a0966d2622148`。
- 自检`第四部分_第七章_独立Writer事实核验与自检_V1.md`：**17,033 bytes／91行**，SHA256 `2d6ca54d3299bdaaa130ea831424c2da3c16d59f48c52d92dd773682aca66e6a`。
- 正文一级1/1、二级5/5、三级14/14；自检索引二级5/三级14均完整。**知识覆盖PASS，不需推倒重写；自检全表PASS不能替代Reviewer独立核证**。

## 2. 独立审核B01–B10十组阻断

| ID | 位置及实质问题 | Writer R2最小返修门槛 |
|---|---|---|
| **B01 CRITICAL：欧盟撤回权/法定退款错判** | §4.7.3.1 L202–218，图/尾表：数字内容仅勾选+下载就一概不支持无理由退款，漏欧盟Art16(m)(iii)持久合同确认；已发货不能退款/客户须自费退回；服务耗时一律不退款 | 按EU Art16(m)、Art8(7)、服务Art16(a)、质量瑕疵权利及实际法域/合同拆开，不能直接剥夺消费者权利 |
| **B02 CRITICAL：邮箱失联与资产接管** | §4.7.2.2 L141–150：按`pi_/ch_`、金额、末4位匹配便允许换邮箱并转交密钥；这些是交易线索，不是充分身份证据 | 保留业务找回路径，但核对已认证账户、原信道/替代可信身份验证、人工升级/安全延时、验证新信道；支付末四位不作认证 |
| **B03 CRITICAL：退款状态/部分权限/SQL一致性** | §4.7.3.2 L224–237及§4.7.3.3 L245–274：Stripe`charge.refunded`包括部分退款，但SQL将全订单置REFUNDED/CLOSED、全码撤销，无退款状态/金额/币种/单位核对；外部撤权不可能由本地事务一把提交 | 区分退款发起/待确认/成功/失败、行项和累计部分金额、订阅/内容合同权益；本地持久变更+外部幂等撤权和补偿；SQL图/表修复 |
| **B04 HIGH：订阅取消一刀切** | §4.7.3.4 L284–297：把期末取消当Stripe/SaaS全球唯一默认和绝对法律权利；即时终止一律按比例原路退款 | 按合同、实际付款周期、平台API与取消方式分流；取消续费不等于立刻撤权，退款独立核验；事件乱序不能覆盖新权益 |
| **B05 HIGH：补发库存和会计绝对化** | §4.7.1.2 L58–81：一律0美元售后子单和“售后损耗/营业外支出”，引用Shopify编辑订单又称0元订单必带财税风险；缺订单项动作持久唯一 | 结合Shopify原生退换/编辑/工单、手工或自建售后子单分流；正确库存/成本按业务合同财税核实，避免额外收款与重复补寄 |
| **B06 HIGH：物流分类和客户选择误判** | §4.7.1 L30–54、L85–103：20–30日说成法定丢件线、`Undelivered`误为丢失；重量差直接确责；5日不回自动全退/P.O.Box全面不支持 | 物流轨迹和称重为证据线索；分未知、待核查、确认证明与客户法定选择；承运渠道/目的国/合同限定案例，数字就地假设 |
| **B07 HIGH：外部重试与业务幂等** | §4.7.4 L305–356：HTTP504/Timeout说可安全重试；查无单就一定能重下；本地SHA哈希自动保证3PL幂等，漏SKU单位/合法多件 | 先分不可逆副作用和未知结果，再结合API文档、可靠外部查询、持久订单行项动作键、对方实际幂等支持和人工接管；防漏发与重发同步 |
| **B08 CRITICAL：Visa CE3.0错配INR** | §4.7.5.1 L372–395及自检L39/52：CE3.0用于特定无卡欺诈**10.4**，不是“未收到货”INR普适规则；签字POD/多段称重/IP位置不能统一保证胜诉 | 按争议reason code/支付渠道区分INR与10.4；保留有价值的交付事实但不声称普遍必须/必胜；消费者和第三方隐私最小化 |
| **B09 HIGH：PCI条款、举证文件、存储期限** | §4.7.5.2 L398–418：PCI3.3.1（禁止授权后存SAD）误当PAN屏显限制；一律只能品牌+末4、英文单页PDF；3–7年作为普遍保存法则 | 精确区分PCI3.3.1/SAD、3.4.1/PAN掩码、3.5.1/PAN储存；按具体PSP/银行文件要求及法域/目的保留数据 |
| **B10 MED-HIGH：假设与自检的事实幻觉** | 开头及§4.7.2.3、核验L22–85：“数字找回占80%客服量”无可靠证据，响应耗时“完全一致”及强制CAPTCHA过度绝对化，核验全标PASS但主要官方来源只列概括名称/主页 | 删除未证据化比例、纠正OWASP约等时/一致性和按风险选择CAPTCHA，正文中就地标假设/UNKNOWN，自检与SQL/图/尾表逐条同步 |

**更具体反例及逐条验收**见本轮Owner下载的完整Review Markdown（**16,248 bytes，SHA256 `1afe7f53c0ec5acda0753a85d6019e04ecbe6ce8a2948dcf8b9a0b81a187ba09`**）。正文安全与客户资产权利问题是本轮阻断根因，优先改实质错误，不以增字数取代核验。

## 3. 经独立核证的一手参考资料（2026-10-19）

- [欧盟Directive 2011/83/EU Art16(m)、Art8(7)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02011L0083-20260927)、[欧盟CRD官方解释](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:52021XC1229(04))：不同合同的撤回权及例外须满足所有条件。
- [Stripe事件类型](https://docs.stripe.com/api/events/types)、[Stripe订阅取消](https://docs.stripe.com/api/subscriptions/cancel)：`charge.refunded`包含部分退款，`refund.failed`等事件需单独核查，取消不等于保证退款。
- [OWASP Forgot Password](https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html)：一致响应、合理防枚举时序、单次高熵Token及已验证信道，不等于交易号+末四位足以改绑。
- [Shopify编辑订单](https://help.shopify.com/en/manual/fulfillment/managing-orders/editing-orders/products)、[Shopify退换货](https://help.shopify.com/en/manual/orders/refunds-returns/exchanges)：不能将自建0元售后子单声明为唯一方案。
- [Visa CE3.0 10.4商户FAQ](https://usa.visa.com/content/dam/VCOM/regional/na/us/support-legal/documents/evolution-of-compelling-evidence-merchant-faqs-mar2023.pdf)及[Visa争议管理](https://usa.visa.com/dam/VCOM/global/support-legal/documents/merchants-dispute-management-guidelines.pdf)：争议理由与证据规则不可混用。
- [PCI SSC FAQ 1154](https://www.pcisecuritystandards.org/faqs/1154/)、[1071](https://www.pcisecuritystandards.org/faqs/1071/)、[1146](https://www.pcisecuritystandards.org/faqs/1146/)：SAD/PAN不同条款；实际文档仅为安全/合规参考，非对任何个体商户的法律结论。
- [Stripe证据文件限制](https://support.stripe.com/questions/evidence-submission-troubleshooting-faq)及[AWS at-least-once](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/standard-queues-at-least-once-delivery.html)：平台边界与不可逆外部动作需独立核对。

## 4. Owner实际收到的R2完整离线ZIP

- 报告：`第四部分_第七章_Writer_V1_独立Reviewer完整审核报告_20261019.md`；**16,248 bytes**，SHA256 `1afe7f53c0ec5acda0753a85d6019e04ecbe6ce8a2948dcf8b9a0b81a187ba09`。
- **ZIP：`第四部分_第七章_Writer_V1_R2完整定向返修包_20261019.zip`**；**42,618 bytes**，SHA256 `751e37c897765e953890cff6d6073ddb08e4e5d052d45299d4e8b97e3f77458f`，**8份UTF-8 Markdown**，ZIP CRC PASS、逐文件SHA256/原Writer两份文件字节一致性PASS。
- 文件包括先读、Reviewer完整报告、Writer V1完整正文原字节、Writer V1原事实核验原字节、R2指令、V2冻结5/14原题、官方核验边界、SHA256清单。
- ZIP由Owner在本轮对话下载，**ZIP二进制未上传GitHub**；**未生成第七章正式封板正文**，没有Writer R2交付。

**NEXT**：Owner转交R2离线ZIP与提示词→独立Writer在V1全文基础上定向修B01–B10并交完整R2正文、逐项核验、自检Markdown与ZIP，`STOP_AT_REVIEWER`→Reviewer冷审；最终封板与启动4.8只能由Owner批准。