# 第四部分4.4章 Writer R2｜独立Reviewer复审RETURN与R3完整离线返修登记

> **DATE：2026-10-19**  
> **INDEPENDENT_VERDICT：RETURN_CH4_R2_RESIDUAL_AWS_PAYMENT_AND_NORMATIVE_SCOPE_ERRORS**  
> **STAGE：CHAPTER4_R2_RETURN / WRITER_R3_PENDING / NO_FINAL_CH4_TEXT**  
> **唯一冻结依据：** [V2 1/9/48/117问题树](FROZEN_FRAMEWORK_V2_20261018.md)；章节4.4全文冻结6二级/13三级标题逐字、同层级、同序全部PASS。  
> **4.1–4.3已封板正文不变；4.5未启动。**

## 本轮真实交付及来源留痕

- 原始Owner上传R2 ZIP：`第四部分_第四章_独立Writer_R2交付.zip`，42,563 bytes，SHA256 `57abc9894059b2eef097f142e9febf488c1de8c5c4c68da8bc7e496f106a88f7`，ZIP CRC PASS；完整2份UTF-8 Markdown。
- Writer R2完整正文 `第四部分_第四章_独立Writer完整正文_R2.md`，**61,784 bytes / 636行**，SHA256 `4935337b0e72bb976cb0b8a55c551122f142ae211da6b1d4716eaa790b138eae`。
- R2核验与R01–R08返修记录 `第四部分_第四章_独立Writer事实核验与R1-R8逐项返修记录_R2.md`，**26,807 bytes / 130行**，SHA256 `729b36b8fcb87ccff7dc3b57f0cf633a8658ded88c6948cd33bf81ceb9024318`。
- 章节结构及知识主体PASS，Writer所有`FIXED/VERIFIED`为自评，不可直接当审核通过。
- [前轮Writer V1独立Review RETURN](CHAPTER4_WRITER_V1_REVIEW_RETURN_20261019.md)，R01–R08八项已大体修复；本轮四组技术/法律边界仍阻断；**不需要推倒重写**。

## 四组当前阻断（详细证据/复审标准见离线Reviewer报告）

| 编号 | R2正文定位 | 关键事实与实施风险 | 定向验收 |
|---|---|---|---|
| **C01 / HIGH** | 4.4.4.2 L367–389及自检R05、核验矩阵 | S3 **POST Policy**的`content-length-range`被错误套用到普通**预签名PUT**；PUT同Key可能覆盖已有对象；上传路径不是订单权限校验的全部 | 精确区分POST Policy条件与PUT上传约束及事后检查、订单授权/大小/隔离/对象覆盖控制 |
| **C02 / HIGH** | 4.4.5.2 L474–495及自检R04 | 应用层仅计数**签发几条临时GET URL**不能严格限制**实际S3 GET/文件下载**次数，一条短效Bearer链接可在有效期内反复使用 | 明确“发链接次数”与“下载次数”两种定义；若需硬限制实际下载次数，须经过逐次可核对的受控分发，不可依普通预签名跳转保证 |
| **C03 / HIGH** | 4.4.3.3 L288–316、4.4.6.3 L595–598 | API幂等键作用仅限**同一请求/参数/有效保留期**，Writer把它写成所有支付请求必需字段及并发“彻底防重”保证；新PaymentIntent、新通道、键失效均可能出现独立付款 | 精确说明Stripe v1幂等键至少24小时/可移除后的行为和API版本差异；同一商家订单查重、未知支付状态、跨通道重复付款风险/人工补偿，图、正文自检一致 |
| **C04 / MED-HIGH** | 4.4.3.3 L259–265，4.4.6.1 L537–541，4.4.6.3、自检L72/77 | `sessionStorage`仍可被XSS读取，不等于自动隐私合规；姓名邮箱地址是个人数据但不必然各法域“特殊敏感数据”；PCI 3.3.1禁存SAD不能推成每商家唯一PSP iframe方案；WCAG 2.2 AA技术符合性写成全球法定统一标准 | 分离事实安全建议与法定义务、具体标准条款和适用地区/版本；个人数据与法律敏感类别区分；自检VERIFIED同步纠正 |

**上轮R01–R08复核结果：**
R01欧盟撤回权PASS_WITH_SCOPE_NOTE；R02订单找回PASS；R03支付幂等PARTIAL→C03；R04下载PARTIAL→C02；R05上传PARTIAL→C01；R06隐私PARTIAL→C04；R07无障碍PARTIAL→C04；R08核验自检PARTIAL→C01/C04。

**建议不另开返修轮的轻修：** N01示例物流时效属于假设；N02商业调研统计与教学假设标签区分；N03对Guest流程、成功页邮件、10秒钱包建议增加适用边界；N04避免把美国地址强制50州或悬浮提示作为唯一说明。

## 独立核证的一手来源（复核日2026-10-19）

- [AWS S3 POST Policy（`content-length-range`）](https://docs.aws.amazon.com/AmazonS3/latest/developerguide/sigv4-HTTPPOSTConstructPolicy.html)
- [AWS S3预签名PUT上传及同Key对象覆盖](https://docs.aws.amazon.com/AmazonS3/latest/userguide/PresignedUrlUploadObject.html)
- [AWS官方预签名URL FAQ（Bearer/可重复使用）](https://docs.aws.amazon.com/prescriptive-guidance/latest/presigned-url-best-practices/faq.html)
- [Stripe API Idempotent Requests（API v1/v2条件和24小时）](https://docs.stripe.com/api/idempotent_requests)
- [OWASP HTML5 Storage安全](https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html)
- [W3C WCAG 2.2 SC 2.5.8](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum)及[W3C政策说明（W3C不制定法规）](https://www.w3.org/WAI/policies/)

## 完整R3离线包已经交Owner

- Reviewer完整报告 `第四部分_第四章_Writer_R2_独立Reviewer完整审核报告_20261019.md`：**12,756 bytes**，SHA256 `7cec6a1974a5679c530894eba8cb7ae4bcd3f42092a54b3368fa9866f6e68fdc`。
- R3 ZIP `第四部分_第四章_Writer_R2_R3完整定向返修包_20261019.zip`：**63,248 bytes**，SHA256 `bc2dbd6896210ba42343e3e848c60872ca4df4d5d1175fa71e404ada29448438`。含**8份UTF-8 Markdown**：独立Reviewer完整报告、独立Writer R2原正文原字节、R2核验自检原字节、历史V1 Reviewer全文、正式6/13题目、Writer R3说明、先读、逐文件SHA256清单。ZIP CRC、UTF-8、原稿字节一致性、6/13题目检查全部PASS。
- ZIP二进制只在当前Owner会话提供下载，**未上传GitHub main**；R2候选正文未当正式正文落库。

**NEXT_STEP：** Owner将R3 ZIP及可转发话术给离线独立Writer→Writer基于完整R2稿定向修C01–C04，交完整R3正文、逐项事实核验记录、ZIP并`STOP_AT_REVIEWER`→Reviewer独立复核→仅Owner批准后可封板4.4；4.5或HTML不能提前启动。
