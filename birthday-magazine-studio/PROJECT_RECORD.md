# Birthday Magazine Studio — PROJECT RECORD

Last updated: 2026-09-26

## Current Truth

```text
PROJECT_STATUS=DISCOVERY_VALIDATION_PENDING
CURRENT_GATE=G0_PROJECT_CHARTER_RECORDED
G0_PROJECT_CHARTER=RECORDED
G1_PROBLEM_AND_TRANSACTION_EVIDENCE=NOT_STARTED
PRODUCT_BUILD_STARTED=NO
WORDPRESS_THEME_SELECTED=NO
PLUGIN_STACK_SELECTED=NO
PRODUCTION_DEPLOYMENT=NO
LIVE_PAYMENT=NO
PHYSICAL_FULFILLMENT=NOT_VERIFIED
CURRENT_PRODUCT_SCOPE=BIRTHDAY_MEMORIAL_MAGAZINE
FAMILY_RECIPE_BOOK=ADJACENT_IDEA_PARKED
```

立项文件已写入项目库。这只确认项目记录存在，不代表产品需求、技术方案、付费意愿或履约供应商已获验证。

## Final Goal

建立一个可销售的生日纪念杂志产品：送礼者提交照片和关于寿星的问答素材，收到一份经过预览确认的个性化杂志；订单支付后自动交付电子成品，实体印刷版在生产、运费、地址流转和到货时效验证后再纳入正式承诺。

## Current Stage

**G0 — 项目记录：已完成。**

**G1 — 问题证据和交易意愿：下一阶段，未开始。** 当前没有用户访谈、真实付费或重复成交证据，也没有足够证据证明“不会做 Canva / 不想自己排版”是最重要的购买触发点。

前序调研已找到若干 WordPress 起步候选，但没有一个零配置免费模板覆盖“问答采集 → 杂志生成 → 逐单预览 → 支付 → 独特文件交付/实体印刷”的全链路。详见 `docs/WORDPRESS_STACK_RESEARCH.md`。

## Decisions and Constraints

- 先验证产品价值，再增加自动化和投放。浏览量、点赞、询问、意向、真实付款是不同层级证据；第一笔交易也不等于 PMF。
- 第一轮样品和小规模订单可以由人工/AI 辅助完成；消费者仍应获得清楚的预计交付时间和确认预览的机会。
- WordPress/WooCommerce、主题、插件、支付网关和印刷服务目前都只是候选。插件按最小化原则选择。
- WooCommerce 可交付已经挂到商品上的下载文件；为每位用户单独生成文件并挂到对应订单，还需要打通生成、文件存储、订单授权和失败补偿。
- Printcart / Storelly 的相关设计或云服务涉及第三方。使用前需确认个人照片、订单资料、数据保留、费用、运输地址流转与履约范围。
- 用户未指定目标国家/语言、收款地区、价格带和实体书优先级；这些决定会影响支付插件、税费、运费和供应商选择。
- 家庭食谱书可能复用内容采集、排版和成书能力，但不属于本项目当前范围，需独立验证后另行立项。

## Validation Spine

- Problem Evidence: **未知**。尚未记录目标买家的原话、购买场景、时间压力、替代方案和拒绝原因。
- Solution Proof: **部分技术候选已查到，端到端样品未制作**。
- Customer Behavior: Attention / Interest / Intent / Transaction 均未开始或未记录。
- Repeatability / Economics: 未知；尚无制作工时、印刷和运费成本、退款数据或获客成本。
- Activation: 预期是买家第一次看到“基于自己提供的故事和照片，排成完整杂志”的可信样品时；仍需验证。
- Trust: 重点观察照片隐私、成品质量、交付日期、预览修改机制、退款规则和真实样品。

## Open Owner Decisions

G1 实验启动前，Owner 需要确定：
1. 首发国家/语言与第一类送礼场景；
2. 首发交付优先做电子版、实体版，还是先以电子版完成验证；
3. 测试价格区间及实验的 KEEP / ITERATE / KILL 门槛。

## Next Action

准备一份完整度足以销售的样刊和一页 Offer。用一轮轻量获客实验收集买家真实描述与实际行为；在开始 WordPress 建站或购买印刷服务前，先确认目标市场、交付形态和实验通过/停止条件。

## Decision Log

| Date | Decision / fact | Status |
|---|---|---|
| 2026-09-26 | 建立 Birthday Magazine Studio 独立项目目录，状态设为 Discovery | Recorded |
| 2026-09-26 | 当前范围限定为生日纪念杂志；家庭食谱书暂作相邻项目想法 | Provisional boundary |
| 2026-09-26 | 将“问答与照片到逐单杂志 PDF”的生产能力列为待验证/待设计缺口，不宣称已有免费插件完整覆盖 | Research finding |
| 2026-09-26 | 首轮优先验证需求、样品和真实交易，不直接进入扩量 | Acquisition gate |
