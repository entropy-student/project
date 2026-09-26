# Birthday Magazine Studio（生日纪念杂志）

> **Current project truth:** [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md)  
> **Start here:** [00_START_HERE.md](./00_START_HERE.md)  
> **Document roles:** [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md)

## 产品目标

让送礼者用照片和结构化问答，获得一份完整、可送出的个性化生日纪念杂志 PDF；用户不需要自己从空白画布构思、写作和排版。

当前 Owner 已确认的产品方向摘要：

- 美国优先、英语首发；
- 首轮产品为数字 PDF；
- 测试价 **US$39.99**；
- 付款前使用浏览器本地、零模型 API 调用的确定性预览；
- 商店与订单采用 **WordPress + WooCommerce**；
- 支付采用 **PayPal（官方 WooCommerce PayPal Payments）**，实现路径参考 Mini Craft：本地订单闭环 → Sandbox → 后续真实 Canary；
- 免费层严格 **0 模型 Token**；只有服务端确认 PayPal/WooCommerce 已付款且资料完整后，才允许创建唯一 AI generation job；
- 付费后进入个性化 AI 内容生成、确定性排版、QA、私有 proof 和 final PDF 交付；
- 家庭食谱书不属于本项目；
- 实体印刷后置。

**以上只是产品方向摘要。当前 Gate、已验证事实、UNKNOWN 和下一步只以 `REVIEWER_HANDOFF.md` 为准。**

## 当前已有

- [可点击浏览器样板](./prototype/index.html)
- [样板边界说明](./prototype/README.md)
- 市场、产品流、获客、WordPress/插件等调研资料

当前样板是浏览器演示：不真实收款、不调用 AI 生成模型、不建立订单数据库、不自动交付生产 PDF。

当前技术原则：**网站和交易尽量复用 WordPress/WooCommerce 成熟组件，只自研生日杂志生成核心。** 当前 G2A 正在比较 Kadence+Storelly、Blocksy+Storelly 和 Good Issue custom 三条前端路径。

## 文档

- [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — **唯一当前 Reviewer / 项目真相**
- [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md) — 所有文档的角色和权威等级
- [docs/TECHNICAL_ROUTE.md](./docs/TECHNICAL_ROUTE.md) — **当前技术路线：哪些复用、哪些自研**
- [docs/G2A_FRONTEND_COMPONENT_POC.md](./docs/G2A_FRONTEND_COMPONENT_POC.md) — **当前执行 Gate：三方案前端/组件 PoC**
- [docs/G1_TWO_STEP_AI_PRODUCT_FLOW.md](./docs/G1_TWO_STEP_AI_PRODUCT_FLOW.md) — 两步式产品流支持设计
- [docs/ACQUISITION_GROWTH_PLAN.md](./docs/ACQUISITION_GROWTH_PLAN.md) — 获客/验证计划
- [docs/G1_DESK_RESEARCH.md](./docs/G1_DESK_RESEARCH.md) — 市场研究快照
- [docs/G1_REMAINING_RESEARCH.md](./docs/G1_REMAINING_RESEARCH.md) — 产品/经济性/实现候选研究
- [docs/WORDPRESS_STACK_RESEARCH.md](./docs/WORDPRESS_STACK_RESEARCH.md) — WordPress 候选研究
- [docs/PROJECT_CHARTER.md](./docs/PROJECT_CHARTER.md) — 初始立项历史基线
- [PROJECT_RECORD.md](./PROJECT_RECORD.md) — legacy compatibility pointer only

## 治理

本项目采用 [VPS Project Governance v0.1.6](https://github.com/entropy-student/spike.skill/tree/main/vps-project-governance)。

关键规则：

- `REVIEWER_HANDOFF.md` 是唯一当前项目真相；
- `PASS_CANDIDATE != PASS`；
- 研究/计划不能冒充已完成事实；
- UNKNOWN 明确写 UNKNOWN，不猜；
- Executor 不自行扩大 Gate；
- Secret / Token / Cookie / 支付凭据 / 客户私密数据不进入普通仓库文档；
- 未来若进入 Shared VPS，必须先遵守 Storage Layout Contract 并建立 `PROJECT_STORAGE_MANIFEST.md`。
