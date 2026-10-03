# Xianyu — REVIEWER HANDOFF

> GOVERNANCE_BASELINE=vps-project-governance v0.2.6 / ACTIVE_PROVISIONAL  
> CANONICAL_GOVERNANCE=entropy-student/spike.skill@main:vps-project-governance/VNEXT.md

## PROJECT_GOAL

本项目只解决一个问题：

> **基于闲鱼真实市场需求，找出明确、可复核的商品类型 / 具体 SKU 列表。**

项目在形成满足证据标准的最终 SKU / 商品类型目录后即完成。

**不属于本项目目标：**
- 找货源；
- 判断或落实采购渠道；
- 版权/授权方案落地；
- 制作商品；
- 上架；
- 真实交易验证；
- 支付/退款；
- 自动发货；
- 闲鱼账号自动化；
- VPS/runtime 部署或维护；
- 规模化运营。

这些事项如后续需要，应另立项目或另开独立 Gate，不得作为当前 Xianyu 选品项目的后续必经阶段。

## PROJECT_STAGE

~~~text
MARKET_SELECTION_REBOOT = ACTIVE
X1_MARKET_DEMAND_DISCOVERY_AND_NORMALIZATION = PASS
X2_SERVICE_DEMAND_DEPTH = PASS_EVIDENCE_ONLY
X2R1_STANDARDIZED_PRODUCT_REFRAME = PASS
X3_STANDARDIZED_EVIDENCE_CARDS_AND_TOP3 = PASS_SUPERSEDED_FOR_SELECTION_AXIS
X3R1_CONCRETE_SKU_REFRAME = PASS
X3R1R1_PROJECT_GOAL_RECONCILIATION = PASS
X3R2_PROJECT_WIDE_REVIEW_AND_METHOD_RESET = PASS
X3R3_PLATFORM_FIRST_SKU_UNIVERSE_REBUILD = IN_PROGRESS
X3R4_FINAL_SKU_CATALOG_REVIEW = PENDING
PROJECT_CLOSEOUT = PENDING_AFTER_FINAL_SKU_CATALOG
~~~

## SYSTEM_MAP

~~~text
闲鱼官方当前类目 / 平台交易数据 / 当前直接商品页
→ 平台原生市场面扫描
→ 直接 SKU / 商品类型候选
→ Provenance 标记 + Signal Lineage 去重
→ D4 / D3 / D2 / D1 / U 需求证据等级
→ 统一 SKU 粒度
→ 最终商品类型 / SKU 目录
→ Reviewer 验收
→ PROJECT CLOSEOUT
~~~

**终点仍然只是“最终商品类型 / SKU 目录”。**

货源、供应商、授权落地、上架、真实交易、自动化和 runtime 仍然全部在本项目范围之外。

## CURRENT_ACCEPTED_STATE

### Current selection truth

- 项目目标已经稳定：**基于闲鱼真实市场需求，输出明确、可复核的商品类型 / SKU 目录；目录经 Reviewer PASS 后项目结束。**
- X1 的 50 个 raw ideas 和 25 个 normalized candidates 主要从服务 Job 出发，适合作为需求发现历史，但存在明显 **service-first bias**，不能继续充当最终 SKU 母集。
- X2 / X2R1 对服务需求和标品化结构的判断保留为历史证据；它们不再决定最终商品目录。
- X3 的 P1/P2/P4 抽象 Top 3 已被 supersede，只保留商品结构分析价值。
- X3R1 的 **36 个 SKU** 继续保留，但 Reviewer 本轮判定它们只是 **PARTIAL_SEED**，不是完整市场母集；旧 S/A/B 排名一并 supersede。
- 旧 36 池存在四类结构性问题：
  1. 服务转产品化候选过多，软件/AI/Office 偏重；
  2. 若干 SKU 主要来自少数商品页的“为你推荐”，不能视为独立搜索市场；
  3. 存在相邻需求外推，例如“报价软件需求”被转成“Excel 报价模板需求”；
  4. SKU 粒度不一致，从具体机型 LUT 到宽泛 Office 工具包混在同一层比较。
- 当前安装的 `xianyu-xiaohongshu-virtual-product-opportunity` Skill 仍可用于 **证据纪律、Signal Lineage、Discovery 引擎**，但它原本以“1 个 Priority Test + Minimum Validation”为终点，与本项目“SKU 目录即终点”不一致，因此 **不得直接采用其终局评分/测试逻辑**。
- X3R2 已重新定义项目本地选品法：**官方平台类目 → 当前直接 SKU → 平台交易数据 → 多卖家/多商品复现 → 服务转产品化只作补充发现器。**
- 新证据等级改为：
  - D4 = 平台/第一方交易级商品族证据或可归属 SKU 交易证据；
  - D3 = 多个独立当前闲鱼直接市场信号；
  - D2 = 单个当前直接 SKU 或一致的相关商品簇；
  - D1 = 相邻需求 / 宏观 / 平台类目存在；
  - U = 不足。
- 新候选 provenance：`DIRECT_SKU / PLATFORM_CATEGORY / PLATFORM_TRANSACTION / RELATED_RESULTS_CLUSTER / DERIVED_ADJACENT`。
- 当前必须覆盖的市场面已扩成 15 类：会员充值、卡券票务、游戏虚拟物、软件授权、源码/插件/工具、AI 教程/Workflow/工具、Office 模板、教育考试、研究数据、工程图纸、摄影预设、视频音频设计资产、网站模板、行业资料、生活攻略。
- 已建立新的 **70+ platform-first seed universe**；它仍不是最终目录，下一步是补独立直接证据和统一粒度。
- 货源是否已找到、授权方案、能否上架、能否自动交付均不属于本项目需求结论，也不参与本项目完成标准。

### Product-shape preference

~~~text
A 纯标品
B 高度可产品化半标品
→ 优先纳入最终 SKU / 商品类型目录

C 套餐化人工服务
D 完全定制服务
→ 可作为需求来源，但不作为本项目主要输出
~~~

这里的 A/B 是为了保证“输出的是商品”，不是为了继续推导交付、售后或自动化项目。

### Legacy runtime context

仓库中存在历史 Xianyu Shared VPS/runtime 资料，但它与当前选品项目目标无关：

~~~text
LEGACY_RUNTIME_CONTEXT=PRESERVED
CURRENT_PROJECT_DEPENDENCY=NO
RUNTIME_READ_REQUIRED=NO
RUNTIME_MUTATION_ALLOWED=NO
~~~

除非 Owner 后续明确另立 runtime 项目，否则 Reviewer/Executor 不应读取、探测或修改该 runtime。

## CURRENT_GATE

~~~text
GATE_ID=X3R3_PLATFORM_FIRST_SKU_UNIVERSE_REBUILD
STATUS=IN_PROGRESS
OBJECTIVE=按平台原生市场面重新构建完整 SKU 候选母集，融合旧 36 种子，补独立直接证据、Signal Lineage 与统一粒度，为最终目录 Review 做准备
MAX_ENDPOINT_THIS_ROUND=NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE + MANDATORY_REVIEW_STOP
MANDATORY_REVIEW_STOP=YES_BEFORE_X3R4_FINAL_CATALOG_REVIEW
TARGET_AND_SCOPE=XIANYU_MARKET_DEMAND_RESEARCH_ONLY

APPLICABLE_CRITICAL_CONSTRAINTS=
MARKET_DEMAND_FIRST;
PLATFORM_FIRST_DISCOVERY;
CONCRETE_SKU_OR_PRODUCT_TYPE_OUTPUT;
TRANSACTION_GT_INTENT_GT_ATTENTION;
ITEM_SIGNAL_NE_SELLER_TOTAL;
RECOMMENDATION_NE_SEARCH_DEPTH;
DERIVED_ADJACENT_NE_DIRECT_DEMAND;
SIGNAL_LINEAGE_REQUIRED;
SUPPLY_UNKNOWN_NE_DEMAND_KILL;
NO_FORCED_WINNER;
NO_RUNTIME_ACCOUNT_LISTING_TRANSACTION_ACTIONS

PREFLIGHT=
1) read docs/X3R2_PROJECT_REVIEW_METHOD_RESET_2026-10.md and docs/X3R3_PLATFORM_FIRST_SKU_UNIVERSE_SEED_2026-10.md;
2) use current official Xianyu taxonomy and current direct public item evidence;
3) scan all 15 market surfaces rather than extending only the old 36;
4) label every candidate with one primary provenance class;
5) do not elevate recommendation-only or adjacent-derived candidates to direct replicated demand;
6) de-duplicate same seller/matrix/recommendation lineage where visible;
7) normalize candidate grain to a concrete searchable product type/SKU;
8) do not research sourcing as an exclusion criterion;
9) do not touch account, listing, payment, purchase, automation or runtime.

REQUIRED_EVIDENCE=
1) all 15 platform-first market surfaces are covered or have an explicit no-evidence note;
2) old 36 candidates are reconciled into retain/merge/downgrade/supersede outcomes;
3) every retained universe entry has provenance and D4/D3/D2/D1/U evidence level;
4) D3 requires independent replicated current market evidence rather than one high “想要” listing;
5) recommendation modules are labeled RELATED_RESULTS_CLUSTER;
6) derived candidates are labeled DERIVED_ADJACENT and cannot be CONFIRMED without direct evidence;
7) SKU granularity is normalized before X3R4;
8) all evidence gaps remain UNKNOWN rather than guessed.

ACCEPTANCE_CRITERIA=
1) the resulting universe is platform-first, not service-first;
2) no major official virtual/digital market surface is silently omitted;
3) existing 36 are treated as seeds, not the authority boundary;
4) final-universe entries are specific enough for direct Xianyu search;
5) provenance/evidence strength can be audited from source pointers;
6) no supplier, rights implementation, fulfillment, listing or operator-fit requirement is introduced;
7) X3R3 stops before final catalog selection/closeout.

ROLLBACK_STATUS_OR_PLAN=DOCUMENTATION_AND_RESEARCH_ONLY; revert Git commits if necessary; no runtime/account/transaction state changes.
OWNER_ONLY_ACTIONS=NONE_IN_CURRENT_RESEARCH_GATE.
REVIEWER_TO_EXECUTOR_RELAY=Read docs/X3R2_PROJECT_REVIEW_METHOD_RESET_2026-10.md, docs/X3R3_PLATFORM_FIRST_SKU_UNIVERSE_SEED_2026-10.md, docs/X3R1_CONCRETE_SKU_DEMAND_POOL_2026-10.md and accepted market evidence in EXECUTION_EVIDENCE.md. Cover the 15 defined market surfaces, add current direct Xianyu evidence, reconcile old 36, normalize SKU grain and provenance. Do not perform sourcing, listing, account, payment, purchase, automation or runtime work.
EXECUTOR_TO_REVIEWER_RELAY=Return PASS_CANDIDATE/RETURN plus normalized universe artifact, provenance/evidence levels, old-36 reconciliation, lineage notes and unresolved evidence gaps. Persist all artifacts before requesting PASS.
~~~

## FINAL CATALOG COMPLETION STANDARD

本项目最终交付应让 Owner 能直接拿到类似下面这种结果：

~~~text
商品类型 / SKU
当前常见价格带
需求证据
证据强度
代表性闲鱼样本 / 来源
需求持续性或季节性
主要反方证据
置信度
~~~

不要求包含：

~~~text
货源
供应商
采购价
授权方式
交付系统
上架文案
真实订单
自动发货
自动化
~~~

## CRITICAL_CONSTRAINTS

- **MARKET_DEMAND_FIRST**：市场需求决定目录，不从“我们会什么/能做什么”反推需求。
- **PLATFORM_FIRST_DISCOVERY**：先扫闲鱼平台原生类目和直接 SKU，再用服务转产品化补充。
- **CONCRETE_OUTPUT**：输出必须是能直接拿去搜索的商品类型或 SKU。
- **STANDARDIZED_FIRST**：标品 / 高度标准化半标品优先作为最终目录主体。
- **TRANSACTION_GT_INTENT_GT_ATTENTION**：成交/交易级 > 明确购买动作 > 合格意图 > 想要/搜索 > 浏览。
- **ITEM_SIGNAL_NE_SELLER_TOTAL**：卖家累计销量不得冒充单 SKU 销量。
- **RECOMMENDATION_NE_SEARCH_DEPTH**：推荐页只证明当前存在/曝光，不证明搜索深度或市场份额。
- **DERIVED_ADJACENT_NE_DIRECT_DEMAND**：相邻需求只能生成候选，不能直接证明该 SKU 有需求。
- **SIGNAL_LINEAGE_REQUIRED**：同卖家矩阵、同推荐簇、同转载链不得重复计权。
- **SUPPLY_UNKNOWN_NE_DEMAND_KILL**：货源缺失不参与需求筛除。
- **NO_FORCED_COUNT / NO_FORCED_WINNER**：最终目录数量由证据决定，不强制 Top N，也不需要唯一冠军。
- **OUT_OF_SCOPE_EXECUTION**：货源、授权落地、上架、交易、账号操作、自动化、VPS 全部不属于本项目。

## DEFAULT_EXECUTION_CHANNEL

~~~text
MARKET_RESEARCH=PUBLIC_WEB + CANONICAL_GITHUB_RECORDS
PROJECT_DOCS=GITHUB_SCOPED_TO_xianyu/**
ACCOUNT_ACTIONS=OUT_OF_SCOPE
LISTING_ACTIONS=OUT_OF_SCOPE
PURCHASE_PAYMENT=OUT_OF_SCOPE
SUPPLY_SOURCING=OUT_OF_SCOPE
AUTOMATION_RUNTIME=OUT_OF_SCOPE
~~~

## CURRENT_ROLLBACK_STATUS

当前与下一 Gate 都仅涉及研究和 GitHub 文档，可按 Git commit 回退。无账号、交易、支付、runtime 或真实商品状态变化。

## UNRESOLVED

- 新 platform-first 母集已扩展到 15 个市场面、70+ seed，但大量条目仍只有 PLATFORM_CATEGORY / RELATED_RESULTS_CLUSTER 级证据，需要补独立直接 SKU 证据。
- 会员/卡券/游戏虚拟物是旧研究严重漏扫的市场面，目前只证明平台存在和少量直接样本，尚未完成多 SKU 复现。
- 软件授权、源码、教育资料、创意资产等市场面已出现当前样本，但仍需统一到可比较的 SKU 粒度。
- 旧 36 的 S/A/B 排名已失效；最终目录必须按新的 provenance + D4/D3/D2/D1/U 重新判断。
- “想要/浏览”仍只能作为意图/注意力代理，不能写成成交。
- 闲鱼公开页索引不完整，因此部分市场面最终可能保持 D1/D2 或 UNKNOWN；不得用猜测填补。

## NEXT_STEP

继续执行 **X3R3**：围绕 15 个平台原生市场面，为 70+ seed 补当前闲鱼直接证据、独立复现、Signal Lineage 与统一 SKU 粒度，同时把旧 36 逐项归并/降级/保留。

X3R3 PASS 后才进入 X3R4 最终目录 Review；X3R4 PASS 后项目 CLOSEOUT。

## OWNER_ACTION_REQUIRED

NONE

## EVIDENCE_POINTERS

- docs/PRODUCT_SELECTION_RESEARCH_2026-10.md
- docs/X2_DEMAND_DEPTH_SHORTLIST_2026-10.md（需求证据历史）
- docs/X2R1_STANDARDIZED_PRODUCT_RESEARCH_2026-10.md（商品结构历史）
- docs/X3_STANDARDIZED_EVIDENCE_CARDS_TOP3_2026-10.md（结构分析历史，selection axis 已 supersede）
- docs/X3R1_CONCRETE_SKU_DEMAND_POOL_2026-10.md（历史 36 SKU 种子池，旧排名已 supersede）
- docs/X3R2_PROJECT_REVIEW_METHOD_RESET_2026-10.md（当前方法复查结论）
- docs/X3R3_PLATFORM_FIRST_SKU_UNIVERSE_SEED_2026-10.md（当前 platform-first 70+ seed 母集）
- EXECUTION_EVIDENCE.md
