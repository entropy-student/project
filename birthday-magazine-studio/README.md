# Birthday Magazine Studio（生日纪念杂志）

## 项目状态

**G1：需求由 Owner 确认已验证；价格已定 US$39.99；两步式交互样板已完成。生产网站、真实支付和 AI 生成系统尚未开发。**

Owner 已确认美国优先、英语首发、US$39.99 测试价，不设预设预算/订单上限，并选择付款前零 AI Token 的本地模板预览、付款后全 AI 生成。已制作可点击的浏览器样板展示两步体验；样板中的付款、AI 制作和 PDF 下载都是模拟流程。需求验证详情尚未归档；本项目真实支付、AI 生成和交付尚未验证。

## 项目目标

让送礼者通过上传照片、回答关于寿星的问题，获得一本有个人故事感的生日纪念杂志。产品承诺是“替用户完成构思与排版”，让不会使用 Canva 或没有时间设计的人也能准备一份有心意的礼物。

最终体验目标：

~~~text
浏览器本地零 AI Token 预览
→ 支付 US$39.99
→ 上传完整照片并回答问题
→ 服务端全 AI 生成与自动检查
→ 查看个性化 proof
→ 安全交付最终电子 PDF
~~~

当前目标是两步式全 AI 电子版流程；以上是产品目标，不代表支付、模型生成、PDF QA 或安全交付已经实现。实体印刷留待后续。

## 当前项目边界

- 当前项目只做“生日纪念杂志”。家庭食谱书是相邻想法，暂不纳入本项目。
- Offer 的试点价已由 Owner 定为 US$39.99；先验证免费本地预览和付费后生成链路，逐单记录模型与支付成本。
- WordPress + WooCommerce 是建站候选路线，不是已批准或已实施的生产方案。
- 新增 [产品、交付、经济性与 WordPress MVP 调研](./docs/G1_REMAINING_RESEARCH.md)。
- 插件候选细节见 [WordPress 模板与插件候选](./docs/WORDPRESS_STACK_RESEARCH.md)。
- 获客验证逻辑见 [获客验证计划](./docs/ACQUISITION_GROWTH_PLAN.md)。
- 交互样板见 [prototype/index.html](./prototype/index.html)；范围与限制见 [prototype/README.md](./prototype/README.md)。

## 文档索引

- [PROJECT_RECORD.md](./PROJECT_RECORD.md) — 项目事实、决策、阶段状态和下一步
- [docs/PROJECT_CHARTER.md](./docs/PROJECT_CHARTER.md) — 立项目标、范围、验收条件、阶段门与风险
- [docs/G1_DESK_RESEARCH.md](./docs/G1_DESK_RESEARCH.md) — 美国英语市场公开线索、证据强弱、反例与访谈提纲
- [docs/G1_US_FIRST_EXPERIMENT.md](./docs/G1_US_FIRST_EXPERIMENT.md) — 美国优先、海外拓展的数字 PDF 付费试点方案
- [docs/G1_REMAINING_RESEARCH.md](./docs/G1_REMAINING_RESEARCH.md) — 产品、价格、成本和 WordPress MVP 调研
- [docs/G1_TWO_STEP_AI_PRODUCT_FLOW.md](./docs/G1_TWO_STEP_AI_PRODUCT_FLOW.md) — 免费零 Token 预览、付款后全 AI 生成方案
- [docs/ACQUISITION_GROWTH_PLAN.md](./docs/ACQUISITION_GROWTH_PLAN.md) — 证据主干、当前瓶颈和获客最小实验
- [docs/WORDPRESS_STACK_RESEARCH.md](./docs/WORDPRESS_STACK_RESEARCH.md) — 可复用的免费 WordPress 主题、模板和插件候选

## 治理

本目录遵循项目库的一项目一目录、持续更新 PROJECT_RECORD.md、不提交 Secret 的约定。通用治理规则以 [vps-project-governance](https://github.com/entropy-student/spike.skill/tree/main/vps-project-governance) 为准；本项目当前处于产品探索阶段，部署、服务器和支付生产规则只在进入相应阶段后适用。
