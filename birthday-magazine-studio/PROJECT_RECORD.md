# Birthday Magazine Studio — PROJECT RECORD

Last updated: 2026-09-26

## Current Truth

| Field | Value |
|---|---|
| PROJECT_STATUS | G1_OWNER_REPORTED_DEMAND_VALIDATED_OFFER_AND_TRANSACTION_PENDING |
| CURRENT_GATE | G1_SAMPLE_OFFER_AND_PAID_PILOT |
| G0_PROJECT_CHARTER | RECORDED |
| G1_DEMAND_VALIDATION | OWNER_REPORTED_VALIDATED_DETAILS_NOT_ARCHIVED |
| G1_PUBLIC_DESK_RESEARCH | US_ENGLISH_COMPLETE |
| G1_OFFER_SPEC_AND_PRICE | RESEARCHED_HYPOTHESIS_OWNER_DECISION_PENDING |
| G1_PRODUCT_SAMPLE | NOT_STARTED |
| G1_OWN_TRANSACTION_TEST | NOT_STARTED |
| G1_REPEATABILITY_AND_ECONOMICS | UNKNOWN |
| G1_EXPERIMENT_REGION | US |
| G1_FIRST_PILOT_FORMAT | DIGITAL_PDF |
| SELLER_MERCHANT_COUNTRY | UNKNOWN |
| PRODUCT_BUILD_STARTED | NO |
| WORDPRESS_THEME_SELECTED | NO |
| PLUGIN_STACK_SELECTED | NO |
| PRODUCTION_DEPLOYMENT | NO |
| LIVE_PAYMENT | NO |
| PHYSICAL_FULFILLMENT | NOT_VERIFIED |
| CURRENT_PRODUCT_SCOPE | BIRTHDAY_MEMORIAL_MAGAZINE |
| FAMILY_RECIPE_BOOK | ADJACENT_IDEA_PARKED |

Owner 已表示需求存在并已验证；项目库尚未记录该验证的时间、样本、渠道和行为结果，故标记为 Owner 报告，而非独立审计结论。Owner 已确认美国英语市场和首轮电子 PDF。完成其余调研后，当前未知项集中于具体样刊/Offer、真实购买、单笔工时与商户收款地；网站开发尚未开始。

## Final Goal

让送礼者上传照片并回答关于寿星的问题，收到一本可预览、可确认的个性化生日纪念杂志；付款后自动交付电子成品。实体版为后续路线，须先验证印刷质量、单位成本、配送区域、数据流、交期及每单个性化文件履约方式。

## Current Stage

**G1 — 需求存在由 Owner 报告为已验证；美国英语数字 PDF 的具体 Offer、样刊、首笔交易和单位经济待验证。**

本阶段不再把“是否存在需求”作为唯一待办；重点转到“买家是否按一个明确价格购买这个具体版本、能否接受成品，以及做一单需要多少时间和成本”。公开竞品页面只帮助设定范围，不证明本项目价格或转化。

## Validation Spine

- Problem Evidence：**Owner 报告已验证；样本、渠道和具体证据未归档**。
- Solution Proof：**竞品可参考；本项目 PDF 样刊未制作**。
- Attention / Interest / Intent：本项目 Offer **未测**。
- Transaction：本项目 **未测**，没有已记录实付订单。
- Repeatability / Economics：**未知**；没有逐单工时、制作/支付成本、返工、退款或 CAC 数据。
- 当前瓶颈：把已报告的需求变成一份可购买、可履约、可计时的 PDF Offer，并验证首笔真实交易与单笔成本；不是主题选型。

## Decisions and Constraints

- 首轮目标买家市场：**美国**；语言：英语（Owner 于 2026-09-26 确认）。
- 首轮付费试点形式：**电子 PDF**（Owner 于 2026-09-26 确认）；实体印刷暂缓。
- 本轮调研提出 12 页 Mini Edition、8–12 张照片、6 个问题、1 次合并修改、建议价格锚点 US$69；它们都是**待 Owner 决策/试点验证的假设，不是已批准的公开承诺**。
- 早期订单可以人工/AI 辅助制作；每单需计素材沟通、制作、校对、修改、支付费用、退款/补做和工具成本。
- WooCommerce 可在付款后开放下载，但原生下载品不是逐单生成器。逐单 proof/final PDF 需要安全订单附件或每单下载授权并实际核验。
- 商户收款主体所在国家/地区未知；不得仅因顾客市场为美国就预设可使用美国 Stripe 费率或开户。
- 美国销售税义务因商户与销售情形而异；WooCommerce 的计算工具不判断义务、不代申报/代缴，需专业确认。
- WooCommerce、主题、上传/附件插件、支付网关、托管与印刷服务均未做最终选型。
- 家庭食谱书保持范围外，需独立立项。

## Next Action

1. Owner 选择首个公开测试价（调研建议锚点 US$69）、试点投入上限和接单数。
2. 制作一份英文 12 页 PDF 样刊并计时，确认实际可交付规格、预览质量和一次修改流程。
3. 确认商户主体/收款账户国家；在 WordPress 暂存环境验证素材关联订单、私有 proof/final PDF、邮件及手机端。
4. 用真实订单验证交付接受度和单笔经济性后，再决定是否搭公开 WordPress MVP及自动化范围。

## Open Owner Input

- 是否用 US$69 作为首个固定公开价；若不是，指定一个试点价。
- 试点预算上限与最大接单数。
- 卖家商户/收款主体注册国家（决定网关、结算、税务和条款配置）。
- 是否接受首批订单后台人工/AI 辅助制作。
- 需求验证摘要：样本数、时间、渠道、发生的可观察行为（可补录，不阻挡其余调研）。

## Decision Log

| Date | Decision / fact | Status |
|---|---|---|
| 2026-09-26 | 建立 Birthday Magazine Studio 独立目录和项目章程 | Recorded |
| 2026-09-26 | 当前范围限定为生日纪念杂志；家庭食谱书暂不纳入 | Provisional boundary |
| 2026-09-26 | Owner 将首轮验证市场定为美国英语市场 | Recorded |
| 2026-09-26 | Owner 将首轮付费试点形式定为电子 PDF | Recorded |
| 2026-09-26 | Owner 报告生日杂志需求已验证；验证详情尚未归档 | Owner input recorded; details pending |
| 2026-09-26 | 完成具体 Offer、竞品价锚、人工履约、单位经济公式和 WordPress MVP 调研 | Research complete; assumptions pending |
| 2026-09-26 | 12 页、8–12 张图、1 次合并修改、US$69 为试点方案假设 | Research hypothesis; not approved |
| 2026-09-26 | 网站开发、样刊、真实付款、插件实测和单位经济仍未开始 | Current gate |
