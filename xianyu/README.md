# Xianyu

## 项目目标

本项目只负责：

> **基于闲鱼真实市场需求，找出明确、可复核的商品类型 / SKU 列表。**

当最终商品类型 / SKU 目录完成并经 Reviewer 验收后，本项目即完成。

## 当前选品方法

经过 X3R2 项目级复查，当前选品方法已经从“服务需求 → 产品化”纠正为 **平台原生市场优先**：

~~~text
闲鱼官方当前类目
→ 当前直接商品 / SKU
→ 平台交易数据
→ 多卖家 / 多商品复现
→ 统一 SKU 粒度
→ 最终商品类型 / SKU 目录
→ PROJECT CLOSEOUT
~~~

服务转产品化、我们自身能力、软件/AI/Office 方向只能作为**补充发现器**，不能再主导候选母集。

## 当前状态

~~~text
X1 广泛需求发现                         PASS（service-first 历史）
X2 服务需求证据                         PASS_EVIDENCE_ONLY
X2R1 标品 / 半标品结构研究              PASS（结构历史）
X3 抽象 P1/P2/P4                        SUPERSEDED
X3R1 36 个具体 SKU 候选池               PASS → PARTIAL_SEED
X3R2 项目级方法与结论复查                PASS
X3R3 平台原生 SKU 母集重建              IN_PROGRESS
X3R4 最终 SKU 目录 Review               PENDING
PROJECT CLOSEOUT                        PENDING
~~~

### 旧 36 SKU 的当前地位

旧 36 个 SKU **不删除**，但也不再被视为完整母集或有效排名。

Reviewer 已确认其主要偏差：
- 软件 / AI / Office 候选偏多；
- 很多候选来自少数商品页的“为你推荐”模块；
- 有些 SKU 是从相邻需求推导，而非直接观察；
- 粒度不一致，从具体机型 LUT 到宽泛 Office 工具包混在同一层。

因此旧 S/A/B 排名已 supersede。

### 新的市场覆盖框架

X3R3 当前强制扫描 15 个市场面：

1. 会员 / 充值
2. 卡券 / 票务 / 代金券
3. 游戏虚拟物
4. 软件 / License / 激活码
5. 源码 / 插件 / 工具软件
6. AI 教程 / Workflow / 工具
7. Office / 经营模板
8. 教育 / 考试 / 证书资料
9. 研究数据 / 数据产品
10. 工程图纸 / 技术资料
11. 摄影预设 / LUT / 修图资产
12. 视频 / 音频 / 设计素材
13. 网站 / WordPress / Web 模板
14. 行业 / 专业知识资料
15. 旅行 / 生活 / 菜谱 / 兴趣攻略

当前已建立 **70+ platform-first seed**，还不是最终目录。

## 新证据口径

每个候选先标 provenance：

~~~text
PLATFORM_TRANSACTION
PLATFORM_CATEGORY
DIRECT_SKU
RELATED_RESULTS_CLUSTER
DERIVED_ADJACENT
~~~

需求等级改为：

~~~text
D4  平台/第一方交易级商品族证据，或可归属 SKU 成交证据
D3  多个独立当前闲鱼直接市场信号
D2  单个当前直接 SKU / 一致的当前商品簇
D1  平台类目 / 相邻需求 / 宏观代理
U   证据不足
~~~

特别注意：

- 高“想要”可以增强 D2，但**不能单凭一个商品升级成 D3/D4**；
- “为你推荐”证明商品存在和当前曝光，**不等于搜索深度、销量或市场份额**；
- 相邻需求只能生成候选，不能直接证明具体 SKU；
- 同一卖家矩阵、同一推荐簇不得重复计权；
- “卖出 X 件宝贝”仍然不能冒充单 SKU 销量。

## 项目边界

以下全部不属于本项目：

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

**货源 UNKNOWN 不淘汰需求。**

## 项目完成标准

最终目录中的每个商品类型 / SKU 至少包含：

~~~text
商品类型 / SKU
标准搜索词
所属市场面
Provenance
当前价格带
当前闲鱼需求证据
独立信号数量
可见意图指标
D4 / D3 / D2 / D1 / U
持续性 / 季节性
主要反方证据
置信度
最终状态
来源
~~~

最终状态允许：

~~~text
CONFIRMED_DEMAND
PROBABLE_DEMAND
WATCHLIST
MARKET_SIGNAL_ONLY
~~~

项目不需要唯一冠军，也不强制 Top 3 / Top 10 / Top 15。

## 阅读顺序

1. [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — 当前项目真相与 Current Gate
2. [docs/X3R2_PROJECT_REVIEW_METHOD_RESET_2026-10.md](./docs/X3R2_PROJECT_REVIEW_METHOD_RESET_2026-10.md) — 本轮项目级复查与方法修正
3. [docs/X3R3_PLATFORM_FIRST_SKU_UNIVERSE_SEED_2026-10.md](./docs/X3R3_PLATFORM_FIRST_SKU_UNIVERSE_SEED_2026-10.md) — 当前 15 市场面 / 70+ SKU seed 母集
4. [docs/X3R1_CONCRETE_SKU_DEMAND_POOL_2026-10.md](./docs/X3R1_CONCRETE_SKU_DEMAND_POOL_2026-10.md) — 旧 36 SKU 种子池，排名已 supersede
5. [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) — 各轮研究与决策记录
6. [docs/PRODUCT_SELECTION_RESEARCH_2026-10.md](./docs/PRODUCT_SELECTION_RESEARCH_2026-10.md) — X1 历史 Discovery
7. [docs/X2_DEMAND_DEPTH_SHORTLIST_2026-10.md](./docs/X2_DEMAND_DEPTH_SHORTLIST_2026-10.md) — X2 历史需求证据
8. [docs/X2R1_STANDARDIZED_PRODUCT_RESEARCH_2026-10.md](./docs/X2R1_STANDARDIZED_PRODUCT_RESEARCH_2026-10.md) — 商品结构历史
9. [docs/X3_STANDARDIZED_EVIDENCE_CARDS_TOP3_2026-10.md](./docs/X3_STANDARDIZED_EVIDENCE_CARDS_TOP3_2026-10.md) — 抽象结构分析历史

## 历史 runtime

仓库内历史 Xianyu VPS/runtime 与当前选品项目解耦：

~~~text
LEGACY_RUNTIME_CONTEXT=PRESERVED
CURRENT_PROJECT_DEPENDENCY=NO
CURRENT_PROJECT_READ_REQUIRED=NO
CURRENT_PROJECT_MUTATION_ALLOWED=NO
~~~
