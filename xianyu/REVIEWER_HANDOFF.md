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
X3R2_FINAL_SKU_CATALOG_RESEARCH = NEXT
PROJECT_CLOSEOUT = PENDING_AFTER_FINAL_SKU_CATALOG
~~~

## SYSTEM_MAP

~~~text
当前闲鱼市场 / 平台数据 / 当前公开商品与搜索结果
→ 广泛需求信号
→ 具体商品类型 / SKU 候选
→ SKU 级需求证据补全与去重
→ 最终商品类型 / SKU 目录
→ Reviewer 验收
→ PROJECT CLOSEOUT
~~~

**终点就是“最终商品类型 / SKU 目录”。**

不存在本项目内的：

~~~text
Supply
→ Listing
→ Minimum Validation
→ Automation
~~~

以上均已从项目主线删除。

## CURRENT_ACCEPTED_STATE

### Current selection truth

- 2026-10 选品从零重启，旧 shortlist / 旧赢家不具 current authority。
- X1 建立了广泛需求池；X2 的服务类需求只作为需求证据。
- X2R1 确立“标品 / 可高度标准化商品优先”的筛选原则。
- X3 的 P1/P2/P4 只保留为商品结构分析，不再是选品结果。
- X3R1 已建立 **36 个具体商品 / SKU 候选**；这份 36 SKU 池是当前主要研究输入，不是最终目录。
- Owner 最新明确：**项目目标到“找到商品类型 / SKU”即结束。**
- 因此，货源是否已找到、授权方式是否明确、能否自动交付、能否上架，均不得作为本项目“需求存在与否”或“是否完成”的判断条件。
- 货源 UNKNOWN 不淘汰一个有市场需求的 SKU。
- 明确违法/违规/侵权的具体交付模式可作为市场需求观察，但不得在最终目录中被表述为可直接执行的经营方案。

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
GATE_ID=X3R2_FINAL_SKU_CATALOG_RESEARCH
STATUS=NEXT_NOT_STARTED
OBJECTIVE=把现有 36 个具体 SKU 候选补齐需求证据、去重和粒度校准，产出本项目最终的商品类型 / SKU 目录
MAX_ENDPOINT_THIS_ROUND=FINAL_SKU_CATALOG + PROJECT_CLOSEOUT_CANDIDATE
MANDATORY_REVIEW_STOP=YES_BEFORE_PROJECT_CLOSEOUT
TARGET_AND_SCOPE=XIANYU_MARKET_DEMAND_RESEARCH_ONLY

APPLICABLE_CRITICAL_CONSTRAINTS=
MARKET_DEMAND_FIRST;
CONCRETE_SKU_OR_PRODUCT_TYPE_OUTPUT;
TRANSACTION_GT_INTENT_GT_ATTENTION;
ITEM_SIGNAL_NE_SELLER_TOTAL;
SUPPLY_UNKNOWN_NE_DEMAND_KILL;
NO_FORCED_WINNER;
NO_RUNTIME_ACCOUNT_LISTING_TRANSACTION_ACTIONS

PREFLIGHT=
1) read current REVIEWER_HANDOFF and X3R1 concrete SKU pool;
2) use current public Xianyu market evidence;
3) preserve evidence lineage and avoid double-counting same seller/matrix;
4) distinguish payment/transaction, purchase intent, 想要, views and generic supply;
5) normalize candidate granularity so every output is a searchable product type or SKU rather than an abstract business model;
6) do not research sourcing as an exclusion criterion;
7) do not touch account, listing, payment, purchase, automation or runtime.

REQUIRED_EVIDENCE=
1) every final catalog entry has a concrete product/SKU name;
2) each entry has at least one current demand evidence path or is explicitly marked lower-confidence;
3) price/intent/transaction evidence is labeled by strength and provenance;
4) duplicated seller/matrix signals are identified where visible;
5) derived SKUs are distinguished from directly observed SKUs;
6) evidence gaps remain UNKNOWN rather than guessed;
7) excluded observations and their exclusion reason are retained separately when useful.

ACCEPTANCE_CRITERIA=
1) final output is a concrete SKU / product-type list, not P1/P2/P4-style abstract structures;
2) each retained entry is specific enough that a human could immediately search for that exact type of product;
3) demand evidence is sufficient to explain why it is in the list;
4) rankings/tiers, if used, reflect demand evidence only and do not penalize missing supply;
5) no requirement exists to find a supplier, prove fulfillment, publish a listing or run a real purchase;
6) final catalog may contain more or fewer than 10–15 entries; no arbitrary count is required;
7) after Reviewer accepts the catalog, this project is eligible for CLOSEOUT.

ROLLBACK_STATUS_OR_PLAN=DOCUMENTATION_AND_RESEARCH_ONLY; revert Git commits if necessary; no runtime/account/transaction state changes.
OWNER_ONLY_ACTIONS=NONE_IN_CURRENT_RESEARCH_GATE.
REVIEWER_TO_EXECUTOR_RELAY=Read REVIEWER_HANDOFF.md, docs/X3R1_CONCRETE_SKU_DEMAND_POOL_2026-10.md and relevant accepted market evidence. Research only market demand and concrete SKU/product-type granularity. Do not perform sourcing, listing, account, payment, purchase, automation or runtime work.
EXECUTOR_TO_REVIEWER_RELAY=Return PASS_CANDIDATE/RETURN plus final catalog artifact, evidence lineage, confidence labels, exclusions and unresolved evidence gaps. Persist artifacts before requesting PASS.
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

- **MARKET_DEMAND_FIRST**：先证明闲鱼市场存在真实需求。
- **CONCRETE_OUTPUT**：输出必须是具体商品类型或 SKU，不允许只输出“软件”“教程”“模板”等宽泛结构。
- **STANDARDIZED_FIRST**：优先标品 / 高度标准化半标品。
- **TRANSACTION_GT_INTENT_GT_ATTENTION**：真实成交证据 > 明确购买动作 > 合格询盘 > 想要/搜索 > 浏览。
- **ITEM_SIGNAL_NE_SELLER_TOTAL**：卖家累计销量不得冒充单 SKU 销量。
- **SUPPLY_UNKNOWN_NE_DEMAND_KILL**：没有货源信息不能成为删除需求候选的原因。
- **NO_FORCED_COUNT**：不为了凑 Top 10 / Top 15 人为删除或保留商品。
- **NO_FORCED_WINNER**：项目目标是输出可靠目录，不需要选唯一冠军。
- **OUT_OF_SCOPE_EXECUTION**：货源、授权落地、上架、交易、账号操作、自动化、VPS 均不属于本项目。

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

- 当前 36 SKU 候选的证据强度不均，有些是直接商品样本，有些是由相邻需求推导。
- 闲鱼公开页面通常不能提供完整 SKU 成交量，因此需要用多源证据、独立卖家密度和当前市场结构增强判断。
- “想要/浏览”只能作为需求代理，不能写成成交。
- 候选之间仍存在粒度不一致，例如“某一具体机型 LUT”与“某类 Excel 工具”需要在 X3R2 统一到可检索、可比较的合理商品粒度。
- 这些是本项目真正剩余的问题；货源、授权、账号资格、售后分钟数、runtime 状态不再属于本项目 unresolved。

## NEXT_STEP

执行 X3R2：把现有 36 SKU 池整理成**最终、明确、证据可复核的闲鱼商品类型 / SKU 目录**。数量由证据决定，不预设必须是 10、15 或 3 个。

完成并经 Reviewer PASS 后，直接进入 PROJECT CLOSEOUT。

## OWNER_ACTION_REQUIRED

NONE

## EVIDENCE_POINTERS

- docs/PRODUCT_SELECTION_RESEARCH_2026-10.md
- docs/X2_DEMAND_DEPTH_SHORTLIST_2026-10.md（需求证据历史）
- docs/X2R1_STANDARDIZED_PRODUCT_RESEARCH_2026-10.md（商品结构历史）
- docs/X3_STANDARDIZED_EVIDENCE_CARDS_TOP3_2026-10.md（结构分析历史，selection axis 已 supersede）
- docs/X3R1_CONCRETE_SKU_DEMAND_POOL_2026-10.md（当前主要候选池）
- EXECUTION_EVIDENCE.md
