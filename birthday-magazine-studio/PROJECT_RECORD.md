# Birthday Magazine Studio — PROJECT RECORD

Last updated: 2026-09-26

## Current Truth

| Field | Value |
|---|---|
| PROJECT_STATUS | G1_INTERACTIVE_SAMPLE_AVAILABLE_PRODUCTION_BUILD_PENDING |
| CURRENT_GATE | G1_SAMPLE_REVIEW_THEN_PRODUCTION_POC |
| G0_PROJECT_CHARTER | RECORDED |
| G1_DEMAND_VALIDATION | OWNER_REPORTED_VALIDATED_DETAILS_NOT_ARCHIVED |
| G1_OFFER_PRICE | USD_39_99_OWNER_CONFIRMED |
| G1_EXPERIMENT_BUDGET_CAP | NONE_OWNER_REQUESTED |
| G1_ORDER_COUNT_CAP | NONE_OWNER_REQUESTED |
| G1_TARGET_MARKETS | US_PRIMARY_OTHER_INTERNATIONAL_MARKETS_TBD |
| G1_FIRST_LANGUAGE | ENGLISH |
| G1_FIRST_PILOT_FORMAT | DIGITAL_PDF |
| G1_PREVIEW_MODE | BROWSER_LOCAL_TEMPLATE_NO_AI_API_CALL |
| G1_PAID_PRODUCTION_MODE | FULL_AI_AFTER_PAYMENT_AND_COMPLETE_INTAKE |
| G1_PRODUCT_SAMPLE | INTERACTIVE_BROWSER_SAMPLE_CREATED_OWNER_REVIEW_PENDING |
| G1_OWN_TRANSACTION_TEST | NOT_STARTED |
| G1_REPEATABILITY_AND_ECONOMICS | UNKNOWN |
| SELLER_MERCHANT_COUNTRY | UNKNOWN |
| PRODUCT_BUILD_STARTED | PROTOTYPE_ONLY |
| WORDPRESS_THEME_SELECTED | NO |
| PLUGIN_STACK_SELECTED | NO |
| PRODUCTION_DEPLOYMENT | NO |
| LIVE_PAYMENT | NO |
| PHYSICAL_FULFILLMENT | NOT_VERIFIED |
| CURRENT_PRODUCT_SCOPE | BIRTHDAY_MEMORIAL_MAGAZINE |
| FAMILY_RECIPE_BOOK | ADJACENT_IDEA_PARKED |

Owner 已确认：首测价 US$39.99；不设置预设预算和订单量上限；美国优先并面向其他海外市场；首发英语；付款前预览不调用模型 API；付款并提交完整素材后全 AI 生成。已制作[可点击两步样板](./prototype/index.html)，展示本地零模型调用预览和模拟付款后的问答、生成、校对、PDF 保存界面。真实网站、支付、生成任务和 PDF 自动交付均尚未实现。具体海外国家、卖家收款主体国家、货币/支付网关、额外 AI 修改政策仍未确定。

需求存在由 Owner 报告为已验证，样本/渠道/行为记录尚未归档。首笔本项目交易、AI 成品接受度、单笔模型成本和整体单位经济仍未知。

## Final Goal

目标产品：用户通过照片和问答获得个性化生日杂志 PDF。付款前能用浏览器本地固定模板快速看见视觉方向，完全不触发模型 API；支付 US$39.99 并补齐材料后，后台 AI 生成内容、确定性模板排版、质量检查，向买家提供订单私有 proof 并自动交付最终 PDF。后续可评估更多国家及实体版。

## Current Stage

**G1 — 需求存在由 Owner 确认；价格、海外拓展意向和两步式全 AI 方向已确认；零 Token 预览及付款后制作的交互样板已完成，等待评审后再进入生产 PoC。**

以下仍未验证：首测国家列表与卖家收款国是否匹配；客户是否按 US$39.99 付款；免费预览是否促成购买；正式成品是否符合期望；支付费、AI 视觉/文本调用、生成重试、存储和获客后的单笔利润。

## Validation Spine

- Problem Evidence：**Owner 报告已验证；摘要待归档**。
- Solution Proof：**可点击的两步式浏览器样板已实现；无真实支付、模型调用或客户样刊**。
- Attention / Interest / Intent：具体产品预览和 Offer **未测**。
- Transaction：**未测**；没有本项目已记录实付订单。
- Repeatability / Economics：**未知**；API 用量、修订、退款、获客费用未测。
- 当前瓶颈：样板可供评审，但“零模型费用预览 → 实际付款 → 已付款触发生成 → 私有 proof/PDF 交付”仍未接通或验证。

## Decisions and Constraints

- 美国为首要顾客市场，英语为首发语言；其他海外国家的开放清单待定。
- 首测价格：**US$39.99**。
- Owner 不要求设置预设的整体试点预算或订单数量上限。
- 两步流：付款前只展示基于静态版式、在浏览器本地合成的低分辨率/watermarked 预览；不上传照片、不请求 LLM/视觉/图像 API。仍会产生正常页面带宽和客户端计算等非 Token 成本。
- 支付后收集完整照片和问题，后端 AI 生成文字；固定模板/排版引擎输出 PDF，自动 QA 后给买家查看个性化 proof 和下载 final。
- 一个已付订单只创建一个幂等的生成任务；刷新、重复 Webhook 不应重复生成。每次真实重跑/改稿要记录 Token 与额外成本。
- 初版建议使用买家原照片与程序化布局；若未来加生成图像，需另计成本并向顾客说明。
- Conversion Leak Audit 仅提供免费确定性体验、付费后增强价值和模型 Token 边界的产品架构参考；其真实支付当前仍是后续阶段，不能当作本项目可直接复用的已上线收费组件。
- Seller merchant country 未知。顾客所在国与商户注册地不同；Stripe/其他支付可用性、提现、跨境费用和税务不能因此预设。
- WordPress + WooCommerce 是候选商店底座；全 AI 生产需要服务端任务/队列、模型 API、PDF 渲染和逐单私有权限，插件组合尚未实测。
- 家庭食谱书仍在范围外；实体印刷后续验证。

## Next Action

1. 评审[交互样板](./prototype/index.html)中的免费预览和付费后体验。
2. 冻结 MVP 的页面、问卷、图片限制、AI 输出格式和质量检查标准。
3. 做支付状态驱动的后台生成 PoC：只有真实支付成功且资料完整才生成；失败任务可恢复。
4. 在正式支付集成前确认卖家收款主体国家与首批允许销售的海外国家。
5. 记录从付款到 proof、PDF 交付、API 用量和订单接受情况；开发是否扩展不以主观评价替代行为数据。

## Open Owner Input

- 卖家收款主体/银行账户注册国家。
- 首批目标国家清单（当前美国优先，其他国家尚未枚举）。
- US$39.99 是否作为其他国家的美元标价，或之后要采用当地币种价格。
- US$39.99 包含的免费重新生成/文本修改次数。该项影响 token 成本，尚未锁定。
- 需求验证摘要可补录；不阻挡无 Token 预览 PoC。

## Decision Log

| Date | Decision / fact | Status |
|---|---|---|
| 2026-09-26 | 建立 Birthday Magazine Studio 独立目录和项目章程 | Recorded |
| 2026-09-26 | Owner 报告生日杂志需求已验证；验证详情尚未归档 | Owner input recorded |
| 2026-09-26 | 首要市场美国、首发英语、首轮格式电子 PDF | Recorded |
| 2026-09-26 | 测试价定为 US$39.99 | Owner confirmed |
| 2026-09-26 | 不设置预设试点预算与订单量上限 | Owner confirmed |
| 2026-09-26 | 付款前提供不调用模型 API 的本地模板预览 | Owner confirmed direction |
| 2026-09-26 | 付款后由 AI 完成实际内容制作与 PDF 生成 | Owner confirmed direction |
| 2026-09-26 | 目标拓展美国以外海外市场；首批国家待列 | Owner input; country list pending |
| 2026-09-26 | 创建免费预览及付款后制作的交互式浏览器样板；只演示流程，不调用模型、不收款 | Prototype created; owner review pending |
| 2026-09-26 | 生产 WordPress 站点、真实支付、AI 生成、私有 PDF 自动交付均未开始 | Current state |
