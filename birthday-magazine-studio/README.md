# Birthday Magazine Studio（生日纪念杂志）

## 项目状态

**G1 / 美国英语桌面调研完成；首轮试点为电子 PDF，真实买家验证待做**

这是一个个性化礼物产品项目。立项记录已建立；目前没有开始网站开发、上线或真实支付，也没有把任何主题、插件或印刷服务定为最终选型。

## 项目目标

让送礼者通过上传照片、回答关于寿星的问题，获得一本有个人故事感的生日纪念杂志。产品承诺是“替用户完成构思与排版”，让不会使用 Canva 或没有时间设计的人也能准备一份有心意的礼物。

最终体验目标：

```text
选择杂志方案
→ 上传照片并回答问题
→ 系统整理素材、生成杂志
→ 在线查看并确认预览
→ 下单支付
→ 自动交付电子版，或由供应链印刷并寄送实体版
```

上述是目标体验，不代表全自动生成、支付或实体履约已被验证。第一阶段允许后台人工/AI 辅助制作，以真实订单验证价值和交付成本。

## 当前项目边界

- 当前项目只做“生日纪念杂志”。家庭食谱书是相邻想法，暂不纳入本项目范围。
- 先验证需求与可交付样品，再决定需要开发多少自动化。
- WordPress + WooCommerce 是候选建站路线，不是已批准的实施决策。
- 插件研究结果见 [WordPress 模板与插件候选](./docs/WORDPRESS_STACK_RESEARCH.md)。
- 获客验证框架与第一轮 Lite Experiment 见 [获客验证计划](./docs/ACQUISITION_GROWTH_PLAN.md)。

## 文档索引

- [PROJECT_RECORD.md](./PROJECT_RECORD.md) — 项目长期事实、决策、阶段状态和下一步
- [docs/PROJECT_CHARTER.md](./docs/PROJECT_CHARTER.md) — 立项目标、范围、验收条件、阶段门与风险
- [docs/G1_DESK_RESEARCH.md](./docs/G1_DESK_RESEARCH.md) — 美国英语市场公开线索、证据强弱、反例与访谈提纲
- [docs/G1_US_FIRST_EXPERIMENT.md](./docs/G1_US_FIRST_EXPERIMENT.md) — 美国首轮访谈、样刊和付费试点草案
- [docs/ACQUISITION_GROWTH_PLAN.md](./docs/ACQUISITION_GROWTH_PLAN.md) — 证据主干、当前瓶颈和获客最小实验
- [docs/WORDPRESS_STACK_RESEARCH.md](./docs/WORDPRESS_STACK_RESEARCH.md) — 可复用的免费 WordPress 主题、模板和插件候选

## 治理

本目录遵循项目库的一项目一目录、持续更新 `PROJECT_RECORD.md`、不提交 Secret 的约定。通用治理规则以 [vps-project-governance](https://github.com/entropy-student/spike.skill/tree/main/vps-project-governance) 为准；本项目当前处于产品探索阶段，部署、服务器和支付生产规则只在进入相应阶段后适用。
