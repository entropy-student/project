# Birthday Magazine Studio（生日纪念杂志）

## 项目状态

**G1：Owner 报告需求已验证；美国英语数字 PDF 的具体 Offer、成交和单位经济待验证。建站尚未开始。**

Owner 已确认需求存在，并选择美国英语市场、首轮电子 PDF。项目库尚未归档需求验证的样本/渠道/具体证据，也没有本项目真实订单；这不影响继续完成产品规格和网站链路调研。

## 项目目标

让送礼者通过上传照片、回答关于寿星的问题，获得一本有个人故事感的生日纪念杂志。产品承诺是“替用户完成构思与排版”，让不会使用 Canva 或没有时间设计的人也能准备一份有心意的礼物。

最终体验目标：

~~~text
选择杂志方案
→ 上传照片并回答问题
→ 系统整理素材、生成杂志
→ 在线查看并确认预览
→ 下单支付
→ 自动交付电子版，或由供应链印刷并寄送实体版
~~~

上述是长期目标。首轮试点暂以人工/AI 辅助制作、客户确认 PDF proof 和逐单交付验证，不代表全自动生成、支付或实体履约已实现。

## 当前项目边界

- 当前项目只做“生日纪念杂志”。家庭食谱书是相邻想法，暂不纳入本项目。
- 先把产品样刊、具体 Offer、真实成交和逐单成本做清楚，再决定需要开发多少自动化。
- WordPress + WooCommerce 是建站候选路线，不是已批准或已实施的生产方案。
- 新增 [产品、交付、经济性与 WordPress MVP 调研](./docs/G1_REMAINING_RESEARCH.md)。
- 插件候选细节见 [WordPress 模板与插件候选](./docs/WORDPRESS_STACK_RESEARCH.md)。
- 获客验证逻辑见 [获客验证计划](./docs/ACQUISITION_GROWTH_PLAN.md)。

## 文档索引

- [PROJECT_RECORD.md](./PROJECT_RECORD.md) — 项目事实、决策、阶段状态和下一步
- [docs/PROJECT_CHARTER.md](./docs/PROJECT_CHARTER.md) — 立项目标、范围、验收条件、阶段门与风险
- [docs/G1_DESK_RESEARCH.md](./docs/G1_DESK_RESEARCH.md) — 美国英语市场公开线索、证据强弱、反例与访谈提纲
- [docs/G1_US_FIRST_EXPERIMENT.md](./docs/G1_US_FIRST_EXPERIMENT.md) — 美国数字 PDF Offer 和首轮付费试点草案
- [docs/G1_REMAINING_RESEARCH.md](./docs/G1_REMAINING_RESEARCH.md) — 产品规格、价格假设、人工交付、成本和 WordPress MVP
- [docs/ACQUISITION_GROWTH_PLAN.md](./docs/ACQUISITION_GROWTH_PLAN.md) — 证据主干、当前瓶颈和获客最小实验
- [docs/WORDPRESS_STACK_RESEARCH.md](./docs/WORDPRESS_STACK_RESEARCH.md) — 可复用的免费 WordPress 主题、模板和插件候选

## 治理

本目录遵循项目库的一项目一目录、持续更新 PROJECT_RECORD.md、不提交 Secret 的约定。通用治理规则以 [vps-project-governance](https://github.com/entropy-student/spike.skill/tree/main/vps-project-governance) 为准；本项目当前处于产品探索阶段，部署、服务器和支付生产规则只在进入相应阶段后适用。
