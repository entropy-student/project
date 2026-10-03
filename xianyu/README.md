# Xianyu

## 项目目标

本项目只负责：

> **基于闲鱼真实市场需求，找出明确、可复核的商品类型 / SKU 列表。**

当最终商品类型 / SKU 目录完成并经 Reviewer 验收后，本项目即完成。

## 项目主线

~~~text
闲鱼市场需求
→ 广泛需求信号
→ 具体商品类型 / SKU 候选
→ SKU 级需求证据补全、去重与粒度校准
→ 最终商品类型 / SKU 目录
→ PROJECT CLOSEOUT
~~~

**项目终点就是最终商品类型 / SKU 目录。**

以下事项不属于本项目：

- 找货源 / 找供应商；
- 采购；
- 版权或授权方案落地；
- 商品制作；
- 上架；
- 真实付款或订单验证；
- 售后；
- 自动发货；
- 闲鱼账号自动化；
- VPS/runtime；
- 规模化运营。

如果以后要做这些，另立项目或另开独立范围，不延长当前选品项目。

## 当前状态

~~~text
X1 广泛市场需求发现                     PASS
X2 服务需求深挖                         PASS_EVIDENCE_ONLY
X2R1 标品 / 半标品结构重构              PASS
X3 抽象商品结构 Top3                    SUPERSEDED_FOR_SELECTION_AXIS
X3R1 具体 SKU 候选池                    PASS
当前具体 SKU 候选数                     36
X3R2 最终 SKU / 商品类型目录            NEXT
PROJECT CLOSEOUT                        PENDING
~~~

X3 的 P1/P2/P4 只保留为商品结构分析，不再是选品结果。

当前主要输入是 **36 个具体商品 / SKU 候选池**。下一轮要做的是补需求证据并整理成最终目录，不是继续找货源或设计运营流程。

## 核心规则

- **市场需求优先。**
- **输出必须具体。** 需要到“AI 漫剧教程+项目文件”“SolidWorks 非标设备图纸库”“日系胶片 LUT/预设包”这一粒度，而不是“教程”“软件”“资料”这种大类。
- **标品 / 高度可标准化半标品优先。**
- **货源 UNKNOWN 不淘汰需求。** 本项目甚至不要求解决货源。
- “想要/浏览”只能作为需求代理，不等于成交。
- 卖家“卖出 X 件宝贝”是卖家级数据，不得冒充单 SKU 销量。
- 不为了凑 Top 3、Top 10 或 Top 15 强行裁剪。最终目录数量由证据决定。
- 项目不要求选唯一冠军。
- 明确违法、违规或侵权的交付方式可以作为需求观察，但不能被写成可直接执行的经营方案。

## 项目完成标准

最终目录中的每个商品类型 / SKU 至少应包含：

~~~text
商品类型 / SKU 名称
当前常见价格带
需求证据
证据强度
代表性闲鱼样本 / 来源
需求持续性 / 季节性
主要反方证据
置信度
~~~

不要求：

~~~text
货源
供应商
采购价
授权方案
交付系统
上架文案
真实订单
自动发货
自动化
~~~

## 阅读顺序

1. [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — 当前项目真相、完成标准与 Current Gate
2. [docs/X3R1_CONCRETE_SKU_DEMAND_POOL_2026-10.md](./docs/X3R1_CONCRETE_SKU_DEMAND_POOL_2026-10.md) — 当前 36 个具体 SKU 候选池
3. [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) — 各轮研究与决策记录
4. [docs/PRODUCT_SELECTION_RESEARCH_2026-10.md](./docs/PRODUCT_SELECTION_RESEARCH_2026-10.md) — X1 广泛 Discovery
5. [docs/X2_DEMAND_DEPTH_SHORTLIST_2026-10.md](./docs/X2_DEMAND_DEPTH_SHORTLIST_2026-10.md) — X2 历史需求证据
6. [docs/X2R1_STANDARDIZED_PRODUCT_RESEARCH_2026-10.md](./docs/X2R1_STANDARDIZED_PRODUCT_RESEARCH_2026-10.md) — 商品结构研究历史
7. [docs/X3_STANDARDIZED_EVIDENCE_CARDS_TOP3_2026-10.md](./docs/X3_STANDARDIZED_EVIDENCE_CARDS_TOP3_2026-10.md) — 抽象结构分析历史，已不作为 selection axis

## 历史 runtime

仓库内仍有历史 Xianyu VPS/runtime 资料，但它已经与当前项目目标解耦。

~~~text
LEGACY_RUNTIME_CONTEXT=PRESERVED
CURRENT_PROJECT_DEPENDENCY=NO
CURRENT_PROJECT_READ_REQUIRED=NO
CURRENT_PROJECT_MUTATION_ALLOWED=NO
~~~

除非以后明确另立项目，否则不要因为这些历史 runtime 资料扩展当前选品项目范围。
