# Xianyu

Xianyu 现在按两个互不混淆的轨道管理：

~~~text
MARKET_SELECTION_TRACK
→ 闲鱼虚拟商品 / 数字服务 / 工具选品
→ 当前主线：X3 PASS，X4 NEXT

AUTOMATION_RUNTIME_TRACK
→ 已存在的 Shared VPS 自动化运行时
→ 保留 accepted baseline，本轮不修改
~~~

## 当前目标

从零重新研究闲鱼市场，不继承任何旧 shortlist、评分或推荐结论。

~~~text
市场需求充分调研
> 标品 / 可产品化半标品优先
> 真实付款 / 成交结构
> 搜索意图与可触达性
> 低沟通 / 低售后 / 可自动交付
> 竞争与价格压缩
> 合法货源 / 版权 / 更新负担
~~~

货源暂时未知不会在 Discovery 阶段淘汰高需求候选；版权、平台规则和合法交付能力仍是后续硬 Gate。

X3 已完成 8 个 A/B 候选的 E1–E10 深研。当前进入下一阶段的 3 个研究候选为：

~~~text
P1 单一任务型自研软件 / 小工具
P2 AI 垂直教程 + 原创项目文件
P4 垂直 Excel / Office 业务系统
~~~

三者 **不排名，也不等于最终赢家**。下一阶段必须通过账号政策/类目核验和 Minimum Validation，才能形成 Priority Test。

## 阅读顺序

1. [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — 当前项目真相、已接受状态与下一 Gate
2. [docs/X3_STANDARDIZED_EVIDENCE_CARDS_TOP3_2026-10.md](./docs/X3_STANDARDIZED_EVIDENCE_CARDS_TOP3_2026-10.md) — 当前 X3 E1–E10 / Top 3 研究结论
3. [docs/X2R1_STANDARDIZED_PRODUCT_RESEARCH_2026-10.md](./docs/X2R1_STANDARDIZED_PRODUCT_RESEARCH_2026-10.md) — 8 个标品/半标品候选来源
4. [docs/PRODUCT_SELECTION_RESEARCH_2026-10.md](./docs/PRODUCT_SELECTION_RESEARCH_2026-10.md) — X1 广泛 Discovery / 50→25 候选池
5. [docs/X2_DEMAND_DEPTH_SHORTLIST_2026-10.md](./docs/X2_DEMAND_DEPTH_SHORTLIST_2026-10.md) — X2 服务需求证据（已被标品筛选轴取代）
6. [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) — 各轮执行与证据记录
7. [PROJECT_STORAGE_MANIFEST.md](./PROJECT_STORAGE_MANIFEST.md) — 既有 runtime 存储基线，仅 runtime Gate 需要时读取

## 重要边界

- 旧选品结论只算历史，不是当前推荐。
- X3 没有发布商品、下单、付款、修改账号或调用现有自动化 runtime。
- “想要/浏览”是需求代理，不等于真实 SKU 订单。
- “卖出 X 件宝贝”是卖家级累计值，不得冒充某个 SKU 销量。
- 高需求但依赖侵权、作弊、绕审核、未授权数据/素材的方向只记录需求，不进入可执行 shortlist。
- 当前账号的相关虚拟商品/服务类目发布资格仍为 UNKNOWN，必须在后续 Gate 内做账号级 read-back。
- 既有 VPS/runtime/备份保留原样，本轮不清理。

## 当前产品形态原则

当前选品不再把“固定报价的接单服务”自动视为产品。

~~~text
A 纯标品
B 结构化输入的半标品
→ 当前主线

C 套餐化人工服务
D 完全定制
→ 只作为需求证据，不进入当前最终候选
~~~
