# Xianyu

Xianyu 现在按两个互不混淆的轨道管理：

~~~text
MARKET_SELECTION_TRACK
→ 闲鱼虚拟商品 / 数字服务 / 工具选品
→ 当前主线

AUTOMATION_RUNTIME_TRACK
→ 已存在的 Shared VPS 自动化运行时
→ 保留 accepted baseline，本轮不修改
~~~

## 当前目标

从零重新研究闲鱼市场，不继承任何旧 shortlist、评分或推荐结论。

~~~text
市场需求充分调研
> 真实付款 / 成交结构
> 搜索意图与可触达性
> 竞争与价格压缩
> 交付 / 货源可行性
> 自动化与人效
~~~

货源暂时未知不会在 Discovery 阶段淘汰高需求候选；版权、平台规则和合法交付能力仍是后续硬 Gate。

## 阅读顺序

1. [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — 当前项目真相与 Gate
2. [docs/PRODUCT_SELECTION_RESEARCH_2026-10.md](./docs/PRODUCT_SELECTION_RESEARCH_2026-10.md) — 当前市场需求研究
3. [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) — 本轮研究证据
4. [PROJECT_STORAGE_MANIFEST.md](./PROJECT_STORAGE_MANIFEST.md) — 既有 runtime 存储基线

## 重要边界

- 旧选品结论只算历史，不是当前推荐。
- 本轮不发布商品、不下单、不改账号、不调用现有自动化 runtime。
- “想要/浏览”是需求代理，不等于真实 SKU 订单。
- “卖出 X 件宝贝”是卖家级累计值，不得冒充某个 SKU 销量。
- 高需求但依赖侵权、作弊、绕审核、未授权数据/素材的方向只记录需求，不进入可执行 shortlist。
- 既有 VPS/runtime/备份保留原样，本轮不清理。
