# Xianyu — REVIEWER HANDOFF

> GOVERNANCE_BASELINE=vps-project-governance v0.2.6 / ACTIVE_PROVISIONAL  
> CANONICAL_GOVERNANCE=entropy-student/spike.skill@main:vps-project-governance/VNEXT.md

## PROJECT_GOAL

以真实市场需求为最高优先级，筛选 **标品或高度可产品化的半标品** 闲鱼虚拟商品；非标服务只作为需求来源，不作为最终优先商品。随后再解决合法货源/交付、上架、自动化与规模化。

## PROJECT_STAGE

~~~text
MARKET_SELECTION_REBOOT = ACTIVE
X1_MARKET_DEMAND_DISCOVERY_AND_NORMALIZATION = PASS
X2_SERVICE_DEMAND_DEPTH = PASS_EVIDENCE_ONLY
X2R1_STANDARDIZED_PRODUCT_REFRAME = PASS
X3_STANDARDIZED_EVIDENCE_CARDS_AND_TOP3 = IN_PROGRESS

AUTOMATION_RUNTIME_TRACK = PRESERVED_ACCEPTED_BASELINE
RUNTIME_MUTATION_THIS_REBOOT = 0
~~~

## SYSTEM_MAP

~~~text
当前官方规则 / 平台交易数据 / 当前公开商品页
→ 需求证据池
→ 标准化分类 A / B / C / D
→ 只允许 A / B 进入候选
→ 标品候选池
→ E1–E10 + 标准化经济性 + 版权/交付
→ 最多 3 个 Top Candidates
→ Minimum Validation
→ Supply / Listing / Automation

既有 Shared VPS Xianyu runtime
→ 独立保留
→ 当前 Market Gate 不调用、不修改
~~~

## CURRENT_ACCEPTED_STATE

### Market selection

- 2026-10 从零重启；任何历史 shortlist、分数、赢家或“以前推荐过”均无 current authority。
- X1 的 50 raw ideas / 25 normalized candidates 继续作为广泛需求发现证据。
- 原 X2 证明了定制开发、PPT、CAD、求职、设计/视频等多个服务需求池真实存在，但其 8-item shortlist **不再作为当前选品 shortlist**；原因是它混合了标品与强非标服务。
- X2R1 新增标准化分类：A=纯标品，B=结构化输入的可产品化半标品，C=套餐化服务，D=完全定制。**只有 A/B 可以进入当前 shortlist。**
- 当前最强的“标品存在真钱需求”证据包括：闲鱼 2026 H1 AI 教程/课程占 AI 订单 8.1%，AI 模板/工作流占 6.6%，并有卖家半年卖出 1.7 万份 AI 漫剧制作教程。
- 当前公开市场也存在重复销售的软件/工具、模板、数据产品等直接样本；但第三方会员/账号/未经授权模板/搬运数据/平台规避工具只作为需求证据，不进入可执行 shortlist。
- 货源暂时 UNKNOWN 不淘汰；但最终无法建立合法、稳定、可重复交付来源时 KILL。

### Standardization classes

~~~text
A 纯标品
= 同一核心交付物重复卖；买家几乎不改变产品；可自动/一键交付

B 可产品化半标品
= 买家只提供结构化字段/文件；固定流水线生成结果；目标人工复核 <=15 分钟/单

C 套餐化服务
= 虽有固定菜单，但每单仍需理解自由文本需求、人工制作或多轮修改

D 完全非标
= 定制开发 / 设计 / 咨询 / 代做为主
~~~

Current shortlist 只允许 A/B。

### Automation runtime — prior accepted baseline, not revalidated

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

本轮不重新探测、不清理、不调用 runtime。

## CURRENT_GATE

~~~text
GATE_ID=X3_STANDARDIZED_EVIDENCE_CARDS_AND_TOP3
OBJECTIVE=对 X2R1 的 8 个 A/B 候选建立可复核 E1–E10 Evidence Cards，补齐标准化经济性、版权/货源、更新负担、自动交付与反方证据，并收敛到最多 3 个进入 Minimum Validation 的候选
MAX_ENDPOINT_THIS_ROUND=TOP3_RESEARCH_SHORTLIST_WITHOUT_REAL_LISTING_OR_FINAL_PRIORITY_TEST
MANDATORY_REVIEW_STOP=YES_BEFORE_MINIMUM_VALIDATION_OR_ANY_REAL_LISTING
TARGET_AND_SCOPE=XIANYU_STANDARDIZED_VIRTUAL_PRODUCT_RESEARCH_ONLY
APPLICABLE_CRITICAL_CONSTRAINTS=MARKET_DEMAND_FIRST;STANDARDIZED_FIRST;TRANSACTION_GT_INTENT_GT_ATTENTION;ITEM_SIGNAL_NE_SELLER_TOTAL;SUPPLY_UNKNOWN_NE_KILL;THIRD_PARTY_ACCESS_NE_PRODUCT;GRAY_DEMAND_CAN_BE_MEASURED_NOT_SELECTED;AUTOMATION_RUNTIME_ISOLATED

PREFLIGHT=
1) use current GitHub xianyu/** as project baseline;
2) use current xianyu-xiaohongshu-virtual-product-opportunity E1–E10 definitions;
3) refresh current official Xianyu rule/platform evidence before relying on policy claims;
4) distinguish transaction / purchase-intent / attention / seller-total signals;
5) preserve source lineage and do not double-count same-seller/repackaged evidence;
6) classify FACT / INFERENCE / UNKNOWN / CONFLICTED;
7) no runtime/account/listing/payment mutation.

REQUIRED_EVIDENCE=
1) one E1–E10 card per P1–P8;
2) current Xianyu-specific reachable-demand evidence for each surviving candidate;
3) payment/transaction evidence strength and limitations;
4) competition/price-compression/free-substitute counterevidence;
5) CORE_INVARIANCE / STRUCTURED_INPUT / HUMAN_MINUTES / REVISION_BOUNDARY / FULFILLMENT / SUPPORT_LOAD / RIGHTS / VERSION_BURDEN;
6) Base/Bad/Stress economics assumptions with unknowns explicit;
7) independent premortem for every Top Candidate;
8) source ledger and lineage notes;
9) no invented SKU sales from “想要” or seller-wide totals.

ACCEPTANCE_CRITERIA=
1) all P1–P8 receive E1–E10 disposition with confidence and critical unknowns;
2) only A/B shapes may survive;
3) Top Candidates count <=3;
4) each Top Candidate has credible demand/payment path, reachable Xianyu search intent, legal delivery thesis, <=15 min target human work/order, bounded support/revision model and non-trivial free-substitute gap;
5) no Top Candidate relies on unauthorized accounts/content/data, platform circumvention, gray scraping, piracy or academic cheating;
6) decisive unknowns are named and routed to Minimum Validation rather than guessed;
7) no final winner or real-market test is claimed in X3.

ROLLBACK_STATUS_OR_PLAN=DOCUMENTATION_ONLY; revert X3 branch commits; runtime/account/data/transaction state unchanged.
OWNER_ONLY_ACTIONS=NONE_IN_X3; any later real listing, real purchase, paid test, account qualification change, provider/payment activation or runtime mutation requires a separately reviewed Gate and Owner authorization where consequential.
REVIEWER_TO_EXECUTOR_RELAY=Read xianyu/REVIEWER_HANDOFF.md CURRENT_GATE; xianyu/docs/X2R1_STANDARDIZED_PRODUCT_RESEARCH_2026-10.md; xianyu/EXECUTION_EVIDENCE.md X1/X2/X2R1; and the current E1–E10/Xianyu modifier/competition-counterevidence sections of spike.skill. Research only P1–P8. Do not read or mutate the legacy runtime unless a specific contradiction makes it necessary.
EXECUTOR_TO_REVIEWER_RELAY=Return a short PASS_CANDIDATE/RETURN packet; persist detailed cards, sources, confidence, counterevidence and economics to canonical project docs before asking for PASS.
RUNTIME_MUTATION=FORBIDDEN
LISTING_PUBLISH=FORBIDDEN
REAL_PURCHASE=FORBIDDEN
PAYMENT=FORBIDDEN
ACCOUNT_MUTATION=FORBIDDEN
~~~

### X2R1 accepted standardized shortlist — not ranked

1. 单一任务型自研软件 / 小工具
2. AI 垂直教程 + 项目文件 / 素材的版本化产品
3. 特定岗位/任务的 AI Workflow / Agent 模板包
4. Excel / Office 原创自动化工具包或业务模板系统
5. 买家自有素材的电商图片 / SKU 批处理工具
6. 原创加工的公开数据集 / 指标数据产品
7. 结构化输入 → 自动生成的诊断/报告产品
8. 原创/开源许可的垂直 Starter Kit / 模板系统

这些是“值得继续验证的商品结构”，不是最终排名，也不代表每个具体题材都成立。

## STANDARDIZATION_GATE

候选进入 Top 3 前必须证明：

- CORE_INVARIANCE：核心产品至少 80% 不因买家变化；
- STRUCTURED_INPUT：若需要个性化，只接收固定字段/文件，不依赖开放式需求访谈；
- HUMAN_MINUTES：稳定后目标人工处理 <=15 分钟/单；
- REVISION_BOUNDARY：0 次或最多 1 次明确范围内修正，不接受无限改；
- FULFILLMENT：可自动发货、一键交付或固定流水线交付；
- SUPPORT_LOAD：不依赖长期人工维护/持续咨询才能获得价值；
- RIGHTS：代码、内容、模板、素材、数据拥有明确的自有/开源/授权/公开合法来源；
- VERSION_BURDEN：更新频率和维护成本不会吞掉毛利。

任一候选长期只能维持 C/D，则从当前选品主线移除，即使市场需求很大。

## CRITICAL_CONSTRAINTS

- MARKET_DEMAND_FIRST：标品化不是“为了省事选没人要的东西”；先要有需求，再看能否产品化。
- STANDARDIZED_FIRST：当前最终候选只允许 A/B。
- SERVICE_DEMAND_IS_INPUT_NOT_OUTPUT：非标服务可证明 Job 很痛，但不能直接成为当前 Priority Test。
- TRANSACTION_GT_INTENT_GT_ATTENTION：订单/付款 > 明确成交动作 > 合格询盘 > 搜索/想要 > 浏览/曝光。
- ITEM_SIGNAL_NE_SELLER_TOTAL：卖家累计卖出不得作为 SKU 销量。
- SUPPLY_UNKNOWN_NE_KILL：货源 UNKNOWN 不在 Discovery 阶段淘汰；INVALID_RIGHTS / POLICY_FAIL 仍硬 KILL。
- THIRD_PARTY_ACCESS_NE_PRODUCT：第三方会员、租号、充值、共享账号等可作为需求证据，不作为我们的候选货源。
- GRAY_DEMAND_CAN_BE_MEASURED_NOT_SELECTED：搬运、去重过审、盗版、作弊、未授权数据等不进入可执行 shortlist。
- AUTOMATION_RUNTIME_ISOLATED：本轮不得顺手修改 runtime、VPS、备份或清理项。

## DEFAULT_EXECUTION_CHANNEL

~~~text
MARKET_RESEARCH=PUBLIC_WEB + CANONICAL_GITHUB_RECORDS
PROJECT_DOCS=GITHUB_SCOPED_TO_xianyu/**
AUTOMATION_RUNTIME=UNCHANGED / NOT_USED
~~~

## CURRENT_ROLLBACK_STATUS

本轮仅研究/文档变更，可按 Git commit 回退；runtime、账号、数据和交易状态无变化。

## UNRESOLVED

- 闲鱼公开网页无法完整暴露 SKU 级真实订单、退款、询盘和 Support Minutes；最终仍需 Minimum Validation。
- AI 模板/工作流 6.6% 的平台订单口径同时包含模板与定制工作流，纯标品份额未知。
- 软件/工具类公开样本常混有第三方授权、平台自动化或数据抓取需求，需要在 X3 继续把“需求”与“合法可复制产品”分开。
- 当前账号对特色服务/虚拟商品类目的实际发布资格尚未做账号内验证。
- runtime public ingress 与 retention-review 继续保持历史 UNKNOWN，不属于当前 Gate。

## NEXT_STEP

执行 X3：只对 8 个 A/B 候选建立 E1–E10 Evidence Cards，并增加 Standardization Economics（人工分钟数、更新负担、自动交付、售后、版权来源）；收敛到最多 3 个 Top Candidates。

## OWNER_ACTION_REQUIRED

NONE

## EVIDENCE_POINTERS

- docs/PRODUCT_SELECTION_RESEARCH_2026-10.md
- docs/X2_DEMAND_DEPTH_SHORTLIST_2026-10.md（需求证据历史，不再是 current shortlist）
- docs/X2R1_STANDARDIZED_PRODUCT_RESEARCH_2026-10.md
- EXECUTION_EVIDENCE.md
- PROJECT_STORAGE_MANIFEST.md（仅 runtime 需要时读）
