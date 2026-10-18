# 第四部分《产品搭建》4.4章｜Owner授权Reviewer定向修订与正式封板证据

> **DATE：2026-10-19**  
> **VERDICT：CHAPTER4_FINAL_SEALED / OWNER_APPROVED / INDEPENDENT_TEXT_QA_PASS**  
> **唯一正式正文：** [CHAPTER4_FINAL_SEALED.md](CHAPTER4_FINAL_SEALED.md)  
> **正式框架：** [V2冻结1核心/9一级/48二级/117三级](FROZEN_FRAMEWORK_V2_20261018.md)，4.4共**6个二级/13个三级**，逐字一致。  
> **无Writer R3。** 此次是Owner对Reviewer直接在完整Writer R2稿基础上的**一次性特批**，不代表常态Reviewer代写后续首稿。

## 1. 溯源及Owner授权

- Owner上传`第四部分_第四章_独立Writer_R2交付.zip`，42,563 bytes，SHA256 `57abc9894059b2eef097f142e9febf488c1de8c5c4c68da8bc7e496f106a88f7`，两份UTF-8 Markdown CRC PASS。
- 完整Writer R2正文，SHA256 `4935337b0e72bb976cb0b8a55c551122f142ae211da6b1d4716eaa790b138eae`，61,784 bytes；原核验记录，SHA256 `729b36b8fcb87ccff7dc3b57f0cf633a8658ded88c6948cd33bf81ceb9024318`，26,807 bytes。Writer R2全文及自检原样保存在Owner离线交付包，未冒充Writer R3。
- Reviewer历史[Writer V1 RETURN](CHAPTER4_WRITER_V1_REVIEW_RETURN_20261019.md)：8组；[Writer R2 RETURN](CHAPTER4_WRITER_R2_REVIEW_RETURN_20261019.md)：剩C01–C04。Owner随后特别授权：“这部分内容暂时由你来修改完成之后嗯，正式冻结，然后填入我们的项目库当中。记得记录相关文档。完成之后开启下一个1级问题的部分。”
- Reviewer基于完整R2稿做14组局部正文、Mermaid/表格的最小必要更正，2026-10-19将唯一正式正文写入main；创建commit `178125b7ed5b3371efc9131d5d6c8170f4651c78`；回读blob SHA `fa9726576112915afd9ab3bffc577e80f7081aba`，32953 JS字符。
- **不存在独立Writer R3候选**；原R3返修ZIP只是Owner授权前的备用返修资料，本次特批直接修R2完成封板。

## 2. 四组阻断与验收证据

| 原项 | 实际修复 | 复审 |
|---|---|---|
| **C01 AWS S3 PUT/POST** | §4.4.4.2明确`content-length-range`适用预签名**POST Policy**，不能照搬到**PUT**；PUT需订单权限、确定对象Bucket/Key、有效期限、校验上传实际字节与格式，注意同Key可能覆盖及未扫描文件隔离；上传审批与后续对象验证两层相互配合 | [AWS S3 POST Policy](https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-HTTPPOSTConstructPolicy.html)、[AWS预签名PUT及同Key覆盖](https://docs.aws.amazon.com/AmazonS3/latest/userguide/PresignedUrlUploadObject.html)；技术解释PASS |
| **C02 S3下载计数** | §4.4.5.2明确“签发5条临时GET URL”≠“S3实际成功GET最多5次”，Bearer URL可重复使用；真正严格限制实际下载须经过每次都授权、验证和计数的受控交付，定义Range/断点续传/失败重试如何计数；末尾表格同步修复 | [AWS预签名请求可重复使用FAQ](https://docs.aws.amazon.com/prescriptive-guidance/latest/presigned-url-best-practices/faq.html)；反例PASS |
| **C03 Stripe幂等与重复付款** | §4.4.3.3说明API v1请求的同键同参重试、首次响应缓存（含部分失败）、至少24小时后可删除，API v2差异，不能跨新付款对象、支付渠道、已失效键提供“一定不会二次扣费”保证；§4.4.6.3弱网重试断言同步修复 | [Stripe幂等API](https://docs.stripe.com/api/idempotent_requests)；叙述PASS |
| **C04存储、PCI与WCAG事实/法律范围** | `sessionStorage`不能阻止XSS，姓名/邮箱/住址是个人数据但非自动属于所有法域“特殊类别”；PCI v4.x 3.3.1禁止授权后存储SAD，但不等于全球只能PSP iframe；WCAG 2.2 AA SC2.5.8的24×24 CSS目标有明确例外，是技术标准，不是全球统一直接生效的法律尺寸；Mermaid/结尾验收表同步修正 | [OWASP HTML5 Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html)、[PCI SSC FAQ 1533](https://www.pcisecuritystandards.org/faqs/1533/)、[W3C WCAG 2.2 SC2.5.8](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum)；跨章/适用条件PASS |

**回归**：原Writer R2关于欧盟数字内容撤回权、邮箱控制权核查、国际化地址/日期、多端交互与上传隔离的已有正确知识保留；没有改变前三级正文与任何已冻结题目，也未编造真实账户/交易/安全测试结果。

## 3. 正式框架独立核对索引

以下索引由Reviewer从**唯一正式V2框架**与封板后GitHub正文逐字核对，不继承任何Writer自评的笼统“全部通过”：

| 题号 | 正式题目原文 | 层级 |
|---|---|---|
| 4.4.1 | 购买前哪些商品信息必须说清楚？ | 二级 |
| 4.4.1.1 | 怎样让客户在付款前看清自己会收到什么、何时收到以及哪些限制？ | 三级 |
| 4.4.2 | 规格、套餐和定制选项怎么让客户选对？ | 二级 |
| 4.4.2.1 | 哪些选项会改变价格、库存或交付结果？ | 三级 |
| 4.4.2.2 | 选错或组合不合法时如何提醒和纠正？ | 三级 |
| 4.4.3 | 下单时该让客户填写哪些资料？ | 二级 |
| 4.4.3.1 | 必须注册才能买吗？ | 三级 |
| 4.4.3.2 | 地址、电话、日期应该如何适应不同地区？ | 三级 |
| 4.4.3.3 | 客户填错或中断，怎样继续完成订单？ | 三级 |
| 4.4.4 | 上传照片、文件或定制需求，怎么避免出错？ | 二级 |
| 4.4.4.1 | 在哪个环节收资料更合理？ | 三级 |
| 4.4.4.2 | 上传内容怎样核验并让客户更正？ | 三级 |
| 4.4.5 | 客户买完后从哪里查看订单和产品？ | 二级 |
| 4.4.5.1 | 客户怎样确认下单成功并知道下一步？ | 三级 |
| 4.4.5.2 | 过几天重新回来，怎样安全找到已购内容？ | 三级 |
| 4.4.6 | 海外不同设备的客户能否用得顺？ | 二级 |
| 4.4.6.1 | 页面与关键操作在手机上是否完整？ | 三级 |
| 4.4.6.2 | 语言、货币显示和时区是否造成误解？ | 三级 |
| 4.4.6.3 | 网络慢或辅助技术用户能完成操作吗？ | 三级 |

**QA：6/6二级PASS、13/13三级PASS；19/19个标题逐字、同序、同层级；正文关键四组技术修复及尾表/示意图检查PASS。** 仅为文本审核，不声称实际使用AWS、Stripe、支付、订单或触控设备实测。

## 4. 历史归档及下一章

- 4.4`FINAL_SEALED / OWNER_APPROVED`。旧V1/R2审核记录作为历史事实保留，显式标注被Owner正式封板决策取代。已结束的4.4首稿Gate和旧离线工作包登记退出main**当期工作树**，普通Git历史留存，不删除真实版本历史。
- NEXT：**4.5《商品、库存和订单怎么管清楚？》**，正式冻结**5个二级12个三级**。Reviewer只组织独立Writer Gate+完整离线ZIP和转交话术；Writer自主完整撰写、Reviewer复核、Owner决定封板。不得提前写第4.5章正文或4.6章/HTML。