# 第四部分4.4章 Writer V1｜独立Reviewer审核RETURN与R2离线返修包登记

> **HISTORICAL_REVIEW_ONLY / SUPERSEDED_BY_OWNER_APPROVED_SEAL（2026-10-19）**：本文件是对应Writer版本交付时的真实独立Reviewer RETURN记录，**不是当前任务**。Owner随后特别授权Reviewer在完整Writer R2正文基础上修复C01–C04并正式封板，唯一权威全文为[CHAPTER4_FINAL_SEALED.md](CHAPTER4_FINAL_SEALED.md)，具体来源及6/13独立核验见[CHAPTER4_SEAL_EVIDENCE_20261019.md](CHAPTER4_SEAL_EVIDENCE_20261019.md)。**没有Writer R3交付，不应再按本文启动R3返修。**

> **DATE：2026-10-19**  
> **VERDICT：RETURN_CH4_V1_TRANSACTION_ACCESS_LEGAL_SOURCE_ERRORS**  
> **CURRENT_STAGE：CHAPTER4_V1_REVIEW_RETURN / WRITER_R2_PENDING / NOT_SEALED**  
> **唯一冻结问题源：** [V2正式框架1/9/48/117](FROZEN_FRAMEWORK_V2_20261018.md)；4.4章节**6二级、13三级逐字、同序、同级PASS**。  
> **原先4.1–4.3章均已正式封板，不改动。**

## 1. 输入文件独立验收

- Owner上传独立Writer原ZIP `第四部分_第四章_独立Writer交付_V1.zip`：**35,056 bytes**，SHA256 `9ec08473ac60d70296e33686f7d30d0c603d35cad4ccc6337a836d25bb59e955`；2份UTF-8 Markdown，ZIP CRC PASS。
- Writer完整正文：`第四部分_第四章_独立Writer完整正文_V1.md`，**54,612 bytes / 588行**，SHA256 `ba1eeb5e5dfee60f9f60900b9775e034518ebd95c651b16e9c70ce289f16a290`。
- 原核验及自检记录：`第四部分_第四章_独立Writer事实核验与自检_V1.md`，**15,454 bytes / 110行**，SHA256 `0daa0338d4e1534efdc54c3e61988ef95fb4d02c3fc71ebcfeb458da5a1169ad`。
- 4.4一级1/1、二级6/6、三级13/13，逐字顺序及级别PASS；完整知识主体具备，**不需推倒重写**，但事实和实施安全存在8组阻断。

## 2. R01–R08定向阻断及最小修复

| ID | 原文位置 | 已核实问题 | 最小修复方向 |
|---|---|---|---|
| **R01 P0** | 4.4.1.1 L72–76 / 自检L45 | 欧盟数字内容撤回权错误示范以Pay按钮下小字即放弃；漏Article16(m)(iii)、Art8(7)持久合同确认及事先明确同意与购买动作分离；法定撤回/普通退款混同 | 按适用数字内容/服务/实物合同区分，独立同意+承认后果+持久确认，改英文示例和尾表 |
| **R02 P0** | 4.4.5.2 L421–449 / 末表 | “订单号+邮箱”错误称双因素，可在未验证邮箱控制权时直接查看客户住址/数字资产 | 仅以两字段识别订单；敏感资料或下载经已登录授权账号、一次性邮件确认等，说明限流/遮蔽 |
| **R03 P0** | 4.4.3.3 L264–292、4.4.5.1、弱网结尾 | 前台网关返回即更新后台已付/立即交付；Client Secret和Idempotency-Key误为一种令牌，保证绝不重复扣款 | 先核对服务端可信支付/异步事实再授权交付；区分PI客户端秘密与API幂等键；覆盖重复/延迟/不回跳 |
| **R04 P0** | 4.4.5.2 L437–453 | S3预签名URL自带最多5次下载、阻断分享的误述 | URL为有时限Bearer凭据，可重复使用，次数/撤销须应用层/托管平台实现，凭证到期可能提前 |
| **R05 P1** | 4.4.4 L302–368 | 魔术字节+AV扫描被写成“绝对安全”；直传S3说成“物理隔离”；生产时间因付款后条款当然免责 | 按平台原生、托管及自管分流；上传授权、绑定订单、隔离、扫描前不交付、解析安全、数据留存；工期须下单前合法约定 |
| **R06 P1** | 4.4.3 L181–253，4.4.5 L377–413 | 任何SaaS必须账号、详细地址/邮箱称非敏感并无条件localStorage存储、邮件必须独立IP/60秒进入主收件箱 | 合约、商品、身份需求分流；个人资料缓存有用户/设备/时效/清理边界；邮件成本及SLA依套餐和法域 |
| **R07 P1** | 4.4.6 L459–566 | Apple 44pt写成所有网页必须≥44CSS px，WCAG AA/AAA混淆；纽约EST/UTC−5全年不适用；发卡行金额不能由卖家保证完全一致 | 44+Web触控可作推荐，精确标WCAG 2.2 AA 24CSS或间距例外、AAA 44；时区支持DST；区分支付呈现与发卡行结算 |
| **R08 P1** | 自检L39–75及全文 | 自检将PCI DSS v4.0 Req3.2（错误）、组织主页、S3链接限次、按钮尺寸、邮件SLA等标VERIFIED；V1索引混入“R2概要” | 用精确官方条款、日期及适用边界更正对应正文、Mermaid、尾表、自检；假设就地标注 |

**非阻断顺修**：卖货图片双单位、英国邮编长度、所有软件密钥必在成功页明文、W3C WCAG对比度适用条件、产品可选3D打样与邮件条款等细节，不单独增加返修轮次。

### 一手资料（2026-10-19复核）

- [EUR-Lex当期合并2011/83/EU Art16(m)及8(7)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02011L0083-20260927)
- [欧盟委员会关于数字内容放弃撤回权的操作解释](https://commission.europa.eu/document/download/8af13e88-6540-436c-b137-9853e7fe866a_en?filename=Key%2520principles%2520on%2520in-game%2520virtual%2520currencies.pdf)
- [Stripe Idempotency Keys](https://docs.stripe.com/api/idempotent_requests)、[PaymentIntent](https://docs.stripe.com/api/payment_intents)
- [AWS预签名URL多次使用FAQ](https://docs.aws.amazon.com/prescriptive-guidance/latest/presigned-url-best-practices/faq.html)
- [OWASP文件上传防护](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html)、[密码找回](https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html)
- [WCAG 2.2 AA触控尺寸2.5.8](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum)、[PCI SSC FAQ1154](https://www.pcisecuritystandards.org/faqs/1154/)

## 3. 已交Owner完整R2离线工作包（不是封板正文）

- 独立Reviewer报告：`第四部分_第四章_Writer_V1_独立Reviewer审核报告_20261019.md`，17,472bytes，SHA256 `faad18db004ba7b6177722b55f706e5b4205ced29a82740eb2e8821f77de1c4d`。
- **R2完整ZIP**：`第四部分_第四章_Writer_V1_R2完整定向返修包_20261019.zip`，**49,656bytes**，SHA256 `03219cf282793a77b48953563cf762518529a60badcab6d25ed625b1ed05191f`，含**8份UTF-8 Markdown**：先读、Reviewer完整审稿、Writer V1原全文（原始字节）、V1原核验记录（原始字节）、R2定向指令、6/13原题、官方来源与边界、逐文件SHA256清单；CRC及内容验证PASS。
- 本地ZIP只在当前Owner对话可下载，**并未上传二进制GitHub**；候选正文不得作为正式章落库。

**CURRENT_STEP**：Owner将完整R2返修ZIP和转交提示词给无GitHub权限的独立Writer→Writer返回R2完整正文、R01–R08逐项核验记录、ZIP并`STOP_AT_REVIEWER`→Reviewer独立复审→Owner明确批准后才可以封板4.4。不得启动4.5或HTML。
