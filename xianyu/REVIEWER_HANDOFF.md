# Xianyu — REVIEWER HANDOFF

> GOVERNANCE_BASELINE=vps-project-governance v0.2.6 / ACTIVE_PROVISIONAL  
> CANONICAL_GOVERNANCE=entropy-student/spike.skill@main:vps-project-governance/VNEXT.md

## PROJECT_GOAL

本项目只解决一个问题：

> **基于闲鱼真实市场需求，找出明确、可复核的商品类型 / 具体 SKU 列表。**

最终 SKU / 商品类型目录经 Reviewer 验收后，本项目即完成。

明确不属于本项目：
- 找货源 / 找供应商；
- 采购与授权方案落地；
- 商品制作；
- 上架 / 真实订单 / 支付退款；
- 交付与售后；
- 账号自动化；
- VPS/runtime；
- 规模化运营。

## PROJECT_STAGE

~~~text
X1_MARKET_DEMAND_DISCOVERY = PASS
X2_SERVICE_DEMAND_DEPTH = PASS_EVIDENCE_ONLY
X2R1_STANDARDIZED_PRODUCT_REFRAME = PASS
X3_ABSTRACT_TOP3 = SUPERSEDED
X3R1_CONCRETE_36_SKU_POOL = PASS_PARTIAL_SEED
X3R1R1_PROJECT_GOAL_RECONCILIATION = PASS
X3R2_PROJECT_WIDE_REVIEW_AND_METHOD_RESET = PASS
X3R3_PLATFORM_FIRST_SKU_UNIVERSE_REBUILD = PASS
X3R4_FINAL_SKU_CATALOG_REVIEW = PASS
PROJECT_CLOSEOUT = PASS
~~~

## SYSTEM_MAP

~~~text
闲鱼官方当前类目 / 平台交易数据 / 当前直接商品页
→ 平台原生市场面扫描
→ 直接 SKU / 商品类型候选
→ Provenance + Signal Lineage
→ D4 / D3 / D2 / D1 / U
→ 统一 SKU 粒度
→ Final SKU Catalog
→ PROJECT CLOSEOUT
~~~

## CURRENT_ACCEPTED_STATE

### Final project result

- 项目目标已满足。
- 早期 X1 服务优先 discovery 被确认有 **service-first bias**；其需求证据保留，但不再定义最终候选母集。
- 旧 X3 P1/P2/P4 抽象 Top 3 已 supersede。
- X3R1 的 36 SKU 已完整 reconciliation，继续作为历史种子证据，但旧 S/A/B 排名已 supersede。
- X3R2 将方法重置为 **platform-first**：
  1. 官方平台类目；
  2. 当前直接 SKU；
  3. 平台/商品族交易证据；
  4. 多卖家/多商品复现；
  5. 服务转产品化仅作补充发现。
- X3R3 覆盖 15 个市场面，建立 70+ seed，并标准化为 60 个可比较候选。
- 新 provenance：
  `PLATFORM_TRANSACTION / PLATFORM_CATEGORY / DIRECT_SKU / RELATED_RESULTS_CLUSTER / DERIVED_ADJACENT`
- 新需求等级：
  `D4 / D3 / D2 / D1 / U`
- X3R4 最终目录验收：
  - **CONFIRMED_DEMAND = 6**
  - **PROBABLE_DEMAND = 44**
  - **核心目录 = 50**
  - WATCHLIST = 19
  - MARKET_SIGNAL_ONLY = 6
- 最终目录不要求唯一冠军，也没有强制 Top N。
- “想要/浏览”仍只是意图/注意力代理；没有被写成成交。
- 卖家累计销量没有被当作 SKU 销量。
- 推荐页没有被当作搜索份额。
- 货源 UNKNOWN 没有参与需求淘汰。

### Strongest accepted market conclusions

1. **AI 漫剧教程 + 项目/工作流**：平台级交易证据最强的具体数字产品之一。
2. **会员类虚拟商品**：此前严重漏扫；当前优酷直接 SKU + 迅雷多卖家商品簇证明这是重要平台原生标品市场。
3. **考研复试 / 本地化中学资料**：当前多独立卖家/商品重复出现，教育资料不能再视为边缘尾部。
4. **摄影预设 / LUT / 修图预设**：多卖家、多具体风格/场景 SKU 共存，市场证据比许多由 Office 需求推导出的模板更直接。
5. **WordPress 模板、AI 标书工具、电商图片效率软件、研究数据、SolidWorks 图纸库**：存在明确当前 SKU 级意图证据，进入 PROBABLE 核心目录。
6. **Excel CRM / 通用 Excel 清洗 / 文件改名等旧候选**：并非证明没需求，而是现有证据主要来自相邻需求，已降为 WATCHLIST。

### Final catalog

Canonical artifact:
- `docs/FINAL_SKU_CATALOG_2026-10.md`

Supporting artifacts:
- `docs/X3R2_PROJECT_REVIEW_METHOD_RESET_2026-10.md`
- `docs/X3R3_PLATFORM_FIRST_SKU_UNIVERSE_SEED_2026-10.md`
- `docs/X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md`

## CURRENT_GATE

~~~text
GATE_ID=PROJECT_CLOSEOUT
STATUS=PASS
OBJECTIVE=确认最终 SKU / 商品类型目录已满足项目目标并完成 canonical persistence
MAX_ENDPOINT_THIS_ROUND=PROJECT_CLOSEOUT
MANDATORY_REVIEW_STOP=REACHED
TARGET_AND_SCOPE=XIANYU_MARKET_SELECTION_RESEARCH_ONLY

APPLICABLE_CRITICAL_CONSTRAINTS=
MARKET_DEMAND_FIRST;
PLATFORM_FIRST_DISCOVERY;
CONCRETE_OUTPUT;
TRANSACTION_GT_INTENT_GT_ATTENTION;
ITEM_SIGNAL_NE_SELLER_TOTAL;
RECOMMENDATION_NE_SEARCH_DEPTH;
DERIVED_ADJACENT_NE_DIRECT_DEMAND;
SIGNAL_LINEAGE_REQUIRED;
SUPPLY_UNKNOWN_NE_DEMAND_KILL;
NO_FORCED_COUNT;
NO_FORCED_WINNER;
OUT_OF_SCOPE_EXECUTION

PREFLIGHT=PASS
REQUIRED_EVIDENCE=AVAILABLE_AND_INSPECTED
ACCEPTANCE_CRITERIA=PASS
ROLLBACK_STATUS_OR_PLAN=DOCUMENTATION_ONLY_GIT_REVERT_AVAILABLE
OWNER_ONLY_ACTIONS=NONE
REVIEWER_TO_EXECUTOR_RELAY=NONE_PROJECT_CLOSED
EXECUTOR_TO_REVIEWER_RELAY=NONE_PROJECT_CLOSED
~~~

## FINAL CATALOG COMPLETION STANDARD

Required:
~~~text
具体商品类型 / SKU
标准搜索词
所属市场面
Provenance
当前价格 / 价格样本
当前需求证据
独立信号
D4 / D3 / D2 / D1 / U
持续性 / 季节性
主要反方证据
置信度
最终状态
来源
~~~

Status:
~~~text
CONFIRMED_DEMAND
PROBABLE_DEMAND
WATCHLIST
MARKET_SIGNAL_ONLY
~~~

This standard is satisfied by `docs/FINAL_SKU_CATALOG_2026-10.md`.

## CRITICAL_CONSTRAINTS

- **MARKET_DEMAND_FIRST**
- **PLATFORM_FIRST_DISCOVERY**
- **CONCRETE_OUTPUT**
- **TRANSACTION_GT_INTENT_GT_ATTENTION**
- **ITEM_SIGNAL_NE_SELLER_TOTAL**
- **RECOMMENDATION_NE_SEARCH_DEPTH**
- **DERIVED_ADJACENT_NE_DIRECT_DEMAND**
- **SIGNAL_LINEAGE_REQUIRED**
- **SUPPLY_UNKNOWN_NE_DEMAND_KILL**
- **NO_FORCED_COUNT**
- **NO_FORCED_WINNER**
- **OUT_OF_SCOPE_EXECUTION**

## DEFAULT_EXECUTION_CHANNEL

~~~text
PROJECT_STATUS=CLOSED
CANONICAL_RECORD=GITHUB
SUPPLY_SOURCING=OUT_OF_SCOPE
ACCOUNT_ACTIONS=OUT_OF_SCOPE
LISTING_ACTIONS=OUT_OF_SCOPE
PURCHASE_PAYMENT=OUT_OF_SCOPE
AUTOMATION_RUNTIME=OUT_OF_SCOPE
~~~

## CURRENT_ROLLBACK_STATUS

Research/documentation-only changes are recoverable through Git history. No account, transaction, payment, production or runtime state was changed by the completed selection project.

## UNRESOLVED

**NONE required for this project’s completion.**

Known evidence limitations remain visible in the catalog:
- public Xianyu pages do not expose complete SKU order counts;
- many candidates remain D2/D1 rather than D4/D3;
- some market surfaces are retained as WATCHLIST rather than being falsely promoted.

These are confidence labels inside the completed catalog, not unfinished project Gates.

## NEXT_STEP

**NONE. PROJECT CLOSED.**

If Owner later wants supplier/source research, sourcing feasibility, listing, or automation, start a separate project/scope using the final catalog as input.

## OWNER_ACTION_REQUIRED

NONE

## EVIDENCE_POINTERS

- docs/FINAL_SKU_CATALOG_2026-10.md
- docs/X3R2_PROJECT_REVIEW_METHOD_RESET_2026-10.md
- docs/X3R3_PLATFORM_FIRST_SKU_UNIVERSE_SEED_2026-10.md
- docs/X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md
- docs/X3R1_CONCRETE_SKU_DEMAND_POOL_2026-10.md（历史种子池）
- EXECUTION_EVIDENCE.md
