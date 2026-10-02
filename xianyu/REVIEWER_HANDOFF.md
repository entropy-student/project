# Xianyu — REVIEWER HANDOFF

## PROJECT_GOAL

以真实市场需求为最高优先级，建立闲鱼虚拟商品 / 数字服务 / 工具的发现、验证和优先级体系；先证明什么值得卖，再解决合法货源/交付、上架、自动化与规模化。

## PROJECT_STAGE

~~~text
MARKET_SELECTION_REBOOT = ACTIVE
X1_MARKET_DEMAND_DISCOVERY_AND_NORMALIZATION = PASS
X2_DEMAND_DEPTH_AND_SHORTLIST_EVIDENCE = PASS
X3_EVIDENCE_CARDS_COUNTEREVIDENCE_AND_SUPPLY_PATH = NEXT

AUTOMATION_RUNTIME_TRACK = PRESERVED_ACCEPTED_BASELINE
RUNTIME_MUTATION_THIS_REBOOT = 0
~~~

## SYSTEM_MAP

~~~text
官方规则 / 平台交易数据 / 当前公开商品页
→ Market Evidence
→ Raw Candidate Universe
→ Normalized Candidate Pool
→ Demand-depth sampling
→ Policy / Competition / Economics
→ Shortlist
→ Minimum real-market validation
→ Supply / Listing / Automation

既有 Shared VPS Xianyu runtime
→ 独立保留
→ 当前 Market Gate 不调用、不修改
~~~

## CURRENT_ACCEPTED_STATE

### Market selection

- 2026-10 从零重启；历史 shortlist、分数、赢家或“以前推荐过”均无 current authority。
- X1 已完成当前平台规则快照、市场规模基线、8 个 Discovery Engine 覆盖、50 个 raw ideas 和 25 个 normalized candidates。
- X2 对 10 个高信息价值需求簇进行了当前规则、平台级交易数据、公开闲鱼商品页、历史真实卖家案例和反方证据的交叉研究，收敛为 8 个 shortlist；没有继承旧赢家。
- 当前证据足以证明服务/技能市场，以及 AI 编程建站、AI 办公、工作流/智能体、PPT、数据自动化、CAD/建模、求职服务、设计/视频等需求池值得进入下一层深研；仍不足以选最终 Priority Test。
- 公开网页无法系统提供所有 SKU 的精确订单数；想要、浏览、卖家累计卖出必须分层使用。
- Supply/Sourcing 在 X1 记为 DEFERRED_CONSTRAINT：未知不淘汰；若只能依靠侵权、盗版、违规数据、不可授权资产或不稳定第三方交付，则后续 KILL。

### Automation runtime — prior accepted baseline, not revalidated in X1

以下只保留 2026-09-29 已接受基线，本轮没有重新探测 VPS：

~~~text
PROJECT_ROLE=ACTIVE_RUNTIME
CONTAINER=xianyu-xianyu-app-1
APPS_PATH=/srv/apps/xianyu
DATA_PATH=/srv/data/xianyu
BACKUPS_PATH=/srv/backups/xianyu
SHARED_NETWORK=spikersun-private
PUBLIC_INGRESS=UNKNOWN
RETENTION_REVIEW=OPEN
CLEANUP_AUTHORIZED=NO
~~~

旧 source/build paths、slider_debug、8 代 backups 和旧 network 的 retention 问题保持原状态。

## CURRENT_GATE

~~~text
GATE_ID=X3_EVIDENCE_CARDS_COUNTEREVIDENCE_AND_SUPPLY_PATH
OBJECTIVE=对 X2 的 8 个 shortlist 补齐 E1–E10、反方证据、合法交付/货源路径、价格与 Support Minutes 假设，收敛到最多 3 个 Top Candidates
MAX_ENDPOINT_THIS_ROUND=TOP3_WITHOUT_FINAL_PRIORITY_TEST
MANDATORY_REVIEW_STOP=YES_BEFORE_REAL_LISTING_OR_FINAL_PRIORITY_TEST
TARGET_AND_SCOPE=XIANYU_MARKET_RESEARCH_ONLY
RUNTIME_MUTATION=FORBIDDEN
LISTING_PUBLISH=FORBIDDEN
REAL_PURCHASE=FORBIDDEN
ACCOUNT_MUTATION=FORBIDDEN
~~~

### X2 accepted shortlist — not ranked

1. Excel / CSV 数据清洗 + 办公自动化
2. 固定范围的 AI 编程 / 轻量建站 / 微型工具
3. PPT 结构重构 + 视觉美化
4. AI Workflow / Agent / 小业务流程自动化
5. CAD / SolidWorks 合法商业制图与建模
6. JD 定向简历诊断 + 面试反馈
7. 电商图片 / SKU 素材标准化
8. 视频剪辑 / 字幕 / 结构化转写

X2 淘汰/降级：通用旅游攻略、Generic PDF/模板资料包、泛 SOP/表格包、纯 OCR/纯转写低差异化版本，以及任何搬运、去重过审、盗版、账号共享、作弊、未授权数据方向。

## CRITICAL_CONSTRAINTS

- MARKET_DEMAND_FIRST：不能因为“好做/我会做/货源好找”抬高弱需求候选。
- NO_HISTORICAL_WINNER_INHERITANCE：旧结论不参与当前排序。
- TRANSACTION_GT_INTENT_GT_ATTENTION：订单/付款 > 明确成交动作 > 合格询盘 > 搜索/想要 > 浏览/曝光。
- ITEM_SIGNAL_NE_SELLER_TOTAL：卖家累计卖出不得作为 SKU 销量。
- SUPPLY_UNKNOWN_NE_KILL：X1/X2 不因货源 UNKNOWN 淘汰；违法/侵权/不可授权交付仍硬 KILL。
- POLICY_CURRENT_ONLY：“别人正在卖”不是 Policy PASS。
- GRAY_DEMAND_CAN_BE_MEASURED_NOT_SELECTED：搬运、去重过审、盗版、账号共享、作弊、未授权数据可以记录需求，不得进入可执行 shortlist。
- AUTOMATION_RUNTIME_ISOLATED：选品研究不得顺手修改 runtime、VPS、备份或清理项。

## DEFAULT_EXECUTION_CHANNEL

~~~text
MARKET_RESEARCH=PUBLIC_WEB + CANONICAL_GITHUB_RECORDS
PROJECT_DOCS=GITHUB_SCOPED_TO_xianyu/**
AUTOMATION_RUNTIME=UNCHANGED / NOT_USED
~~~

## CURRENT_ROLLBACK_STATUS

X1 仅研究/文档变更，可按 Git commit 回退；runtime、数据、账号和交易状态无变化。

## UNRESOLVED

- 公开网页无法系统访问闲鱼搜索结果全集，SKU 级成交、询盘、退款和 Support Minutes 仍需账号内样本或 Minimum Validation；因此 X2 shortlist 是需求研究结论，不是最终销量排名。
- 当前账号对特色服务类目的实际发布资格尚未做账号内验证。
- shortlist 的货源/交付、版权、人工支持成本尚未逐项证明。
- runtime 的 public ingress 与 retention-review 继续保持历史 UNKNOWN，不属于当前 Market Gate。

## NEXT_STEP

执行 X3：对 8 个 shortlist 建 E1–E10 Evidence Cards，重点验证真实付款结构、价格带、免费 AI 替代、售前/售后分钟数、合法交付来源与退款争议；收敛到最多 3 个 Top Candidates，仍不实际发布或付款。

## OWNER_ACTION_REQUIRED

NONE

## EVIDENCE_POINTERS

- docs/PRODUCT_SELECTION_RESEARCH_2026-10.md
- docs/X2_DEMAND_DEPTH_SHORTLIST_2026-10.md
- EXECUTION_EVIDENCE.md
- PROJECT_STORAGE_MANIFEST.md（仅 runtime 需要时读）
