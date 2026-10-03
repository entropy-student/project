# X3R1 — Concrete SKU Demand Pool — 2026-10-03

Status: PASS_CANDIDATE pending Reviewer read-back
Scope: Xianyu virtual/digital products
Decision correction: concrete SKU demand first; sourcing is a later independent axis

## 1. Owner correction accepted

The previous X3 over-compressed the selection into abstract product structures (P1/P2/P4).

That is no longer the selection endpoint.

Current rule:

~~~text
MARKET DEMAND
→ CONCRETE PRODUCT TYPE / SKU
→ DEMAND PRIORITY
→ SOURCE / RIGHTS / DELIVERY RESEARCH
→ MINIMUM VALIDATION
~~~

SUPPLY_UNKNOWN does not reduce or remove a SKU from the demand pool.

Only a clearly prohibited/illegal model is excluded from the executable pool. Rights/source uncertainty is recorded separately so the demand signal is not lost.

The old P1/P2/P4 result is retained as product-form analysis only and is SUPERSEDED_FOR_SELECTION_AXIS.

## 2. Demand evidence classes

- S = very strong current demand evidence: platform transaction evidence and/or current direct listings with unusually strong intent.
- A = strong current direct intent/payment structure.
- B = current live/recommendation supply with credible buyer job, but transaction depth is incomplete.
- C = adjacent/derived demand hypothesis; keep for later verification.
- “想要” is intent, not an order.
- seller-wide sold totals are never treated as SKU sales.

Sourcing status is intentionally separate:

~~~text
SUPPLY_STATUS = DEFERRED / UNKNOWN
RIGHTS_STATUS = UNKNOWN / NEEDS_PROOF / LOW_RISK_IF_ORIGINAL
~~~

Neither field changes the demand class in this Gate.

## 3. Concrete SKU demand pool — ranked by demand evidence, not sourcing ease

| Rank | SKU ID | Concrete product / SKU | Form | Demand class | Current demand evidence | Supply / rights note — NOT used to rank |
|---:|---|---|---|---|---|---|
| 1 | SKU-01 | **AI 漫剧制作全流程教程 + 可编辑项目文件 + 工作流文件** | 教程/项目包 | S | Xianyu 2026 H1 reports tutorials/courses = 8.1% of AI orders; one AI-manga tutorial seller reportedly sold 17k copies in six months | SUPPLY_UNKNOWN; source can be original or licensed |
| 2 | SKU-02 | **AI 标书写作实操教程 + 技术标模板 + 评分检查表** | 教程/模板 | S | current recommendation market shows many AI bid products; examples include 110, 186, 220, 2,195, 2,717 “想要” across tool/access/service offers | SUPPLY_UNKNOWN; do not rely on shared third-party accounts |
| 3 | SKU-03 | **WordPress 外贸独立站主题/模板套装** | 模板包 | S | current listing ¥25.90 / direct buy ¥29, 804 “想要”, ~10k views | RIGHTS_UNKNOWN; licensing/source to research later |
| 4 | SKU-04 | **SolidWorks 非标自动化设备 3D 图纸库** | 图纸库 | S | current recommendation: “1.3万套 SolidWorks 非标自动化设备3D图纸” ¥1, 686 “想要” | RIGHTS_UNKNOWN; demand retained regardless |
| 5 | SKU-05 | **Lightroom / PS 日系胶片人像调色预设包** | 预设 | S | current recommendation: Japanese-film portrait preset ¥0.80, 603 “想要” | RIGHTS_UNKNOWN; original preset route possible |
| 6 | SKU-06 | **上市公司高管团队稳定性面板数据集（1999–2024 类）** | 数据集 | S | current listing direct buy ¥1, 523 “想要”, 3,591 views | source/redistribution rights NEEDS_PROOF |
| 7 | SKU-07 | **电商商品图片批量采集/整理工具** | 软件 | S | current listing ¥2.98–50.98, 722 “想要”, 5,163 views | policy/rights vary by data source; demand retained, executable feature set later |
| 8 | SKU-08 | **摄影 AI 修图预设/口令包（漫展/COS/人像）** | 预设/参数包 | A/S | current photography recommendation pages show multiple presets; some individual offers 22–59+ “想要”; adjacent AI editing access offers exceed 500 | original preset sourcing preferred later |
| 9 | SKU-09 | **AI 标书制作软件 / 标书生成工具** | 软件 | A/S | current listing market includes “标书制作工具” ¥8.60, 110 “想要”; multiple AI bid-tool offers show much larger intent | exact software source UNKNOWN |
| 10 | SKU-10 | **中小企业报价管理软件 Windows 永久版** | 软件 | A | current live self-developed listing ¥13.50 / direct buy ¥13.90, 133 “想要”, 5,008 views | self-build/licensed source later |
| 11 | SKU-11 | **上市公司供应链网络地位 / PageRank 指数数据集** | 数据集 | A | current live data product direct buy ¥1, 194 “想要”, 1,876 views | source methodology/rights NEEDS_PROOF |
| 12 | SKU-12 | **英文课堂 PPT 互动游戏课件包（如 1,400 个）** | 教学课件包 | A | current recommendation: ¥2.68, 166 “想要” | rights/source UNKNOWN |
| 13 | SKU-13 | **闲鱼关键词监控 / 上新秒提醒工具** | 软件 | A | current recommendation: monitor/reminder tool ¥79.20, 147 “想要”; other monitoring offers also present | platform-policy compatibility to review later |
| 14 | SKU-14 | **Python 办公自动化脚本包：Excel / Word / PDF** | 脚本包 | A/B | current recommendation: ¥39.90 | exact SKU payment count not public; source can be self-built |
| 15 | SKU-15 | **Excel 多表合并 / 去重 / 清洗工具** | 软件/Excel工具 | A/B | direct data/automation demand plus strong office-category growth; job is concrete and repeatedly visible | SUPPLY_UNKNOWN |
| 16 | SKU-16 | **Excel 库存 + 利润 + 订单经营模板系统** | Excel模板 | A/B | office demand + current paid reusable spreadsheet/template market | SUPPLY_UNKNOWN; can be original |
| 17 | SKU-17 | **Excel 客户 CRM / 跟进管理模板** | Excel模板 | B | same vertical office-system demand cluster | SUPPLY_UNKNOWN |
| 18 | SKU-18 | **Excel 报价单 + 订单 + 发票跟踪模板** | Excel模板 | B | quotation-management demand is directly visible; lower-complexity file SKU derived from same buyer job | SUPPLY_UNKNOWN |
| 19 | SKU-19 | **PDF 批量合并 / 拆分 / 转换 / 压缩工具** | 软件 | B | current recommendation market includes an online PDF tool at ¥20 and Office script packs | SUPPLY_UNKNOWN |
| 20 | SKU-20 | **文件批量重命名 / 归档工具** | 软件 | B | adjacent automation/file-processing demand; standard repeatable SKU | SUPPLY_UNKNOWN |
| 21 | SKU-21 | **电商 SKU 图片批量改尺寸 / 压缩 / 重命名工具** | 软件 | B | derived from current ecommerce-image product with 722 “想要”; executable version avoids third-party downloading | SUPPLY_UNKNOWN |
| 22 | SKU-22 | **手机 Log 调色 LUT 包（vivo X200/X300 等机型）** | LUT/预设 | B | current photography recommendation: phone Log color-grading product ¥4.93 | source can be original; model-specific demand to deepen |
| 23 | SKU-23 | **索尼 FX3 / 电影感 LUT 调色包** | LUT/预设 | B | current recommendation: FX3 style LUT product ¥3, 12 “想要”; broader preset market strong | SUPPLY_UNKNOWN |
| 24 | SKU-24 | **短剧扒剧实战指南 + 竞品复盘模板 + 爆款分析表** | 教程/模板 | B | current recommendation: ¥9.99, 12 “想要”; adjacent short-drama/AI-manga market is active | source can be original |
| 25 | SKU-25 | **AIGC 东方美学电影级提示词 + 示例图 + 参数包** | 提示词/案例包 | B | current recommendation: ¥1.98; prompt products are visibly supplied | strong free-substitute pressure; demand not removed |
| 26 | SKU-26 | **IE 工业工程工作经验 / 工具表 / 方法资料包** | 专业资料包 | B | current recommendation: ¥3, 90 “想要” | rights/source UNKNOWN |
| 27 | SKU-27 | **芯片 / 半导体工艺制造资料合集** | 专业资料包 | B | current recommendation: ¥14, positioned as auto-delivery | rights/source UNKNOWN |
| 28 | SKU-28 | **工业机器人配置手册 / PROFINET / EtherCAT 手册包** | 技术手册包 | B | current recommendation examples exist at low prices | manufacturer-document redistribution rights UNKNOWN |
| 29 | SKU-29 | **小提琴 / 大提琴制作图纸与文献资料包** | 图纸/文献包 | B | current recommendation: cello drawing/document pack ¥12, 47 “想要” | rights/source UNKNOWN |
| 30 | SKU-30 | **原创家常菜 + 空气炸锅菜谱电子书** | PDF/电子书 | B | current recommendation: 360 recipes + air-fryer guide ¥8 | source can be original |
| 31 | SKU-31 | **日本关西自由行保姆级攻略 PDF + 地图清单** | 攻略 | B | current recommendation: self-made Kansai guide ¥26 | accuracy/update burden later; supply can be original |
| 32 | SKU-32 | **地方/院校考研复试经验 + 真题回忆 + 面试清单（原创型）** | 经验资料 | B | many current school-specific listings, some ¥25–180; demand repeatedly visible | must distinguish original recollection from copyrighted material |
| 33 | SKU-33 | **本地化中考专题复习/真题整理包** | 教育资料 | B | current recommendation examples at ¥6.99–8.88; some similar exam packs show >100 “想要” | copyright/source UNKNOWN; demand retained |
| 34 | SKU-34 | **教师用原创教案 + PPT + 作业设计套装** | 教学资料 | B | current recommendation contains teacher lesson/worksheet products; one related teacher material listing shows 97 “想要” | source can be original; rights later |
| 35 | SKU-35 | **AI 漫剧一键制作工具 / 工程生成器** | 软件 | B | current recommendations include “AI漫剧一键制作” and AI engineering/person generation tools | avoid “过审/搬运” functions; exact source later |
| 36 | SKU-36 | **多平台商品搜索 / 比价 / 库存监控软件** | 软件 | B | current recommendations include comparison/monitoring tools and JD price-stock monitor ¥58 with 26 “想要” | platform/API policy later; source UNKNOWN |

## 4. Demand-only control signals — recorded but not executable as-is

These prove buyers spend attention/money, but the exact observed offer is not a clean executable supply model:

- third-party account/member/credit rental or recharge;
- pirated courses/books/template collections;
- “过原创 / 去重 / 搬运 / 过审” circumvention tools;
- academic ghostwriting/代做;
- cracked software/license resale.

They are retained as demand observations, not removed from market understanding. We simply do not copy the prohibited delivery model.

## 5. What this changes from X3

The previous abstract Top 3:

~~~text
P1 single-purpose utility
P2 AI tutorial + files
P4 vertical Excel/Office system
~~~

is no longer a selection result.

It now acts only as a product-form lens that contains many concrete SKUs.

For example:

~~~text
P1
→ SKU-09 AI bid software
→ SKU-10 quotation software
→ SKU-15 Excel cleanup tool
→ SKU-19 PDF batch tool
→ SKU-20 batch rename tool
→ SKU-21 ecommerce image batch tool
→ SKU-36 price/stock monitor

P2
→ SKU-01 AI manga tutorial
→ SKU-02 AI bid-writing tutorial
→ SKU-24 short-drama analysis guide
→ SKU-25 AIGC prompt/case pack

P4
→ SKU-16 inventory/profit/order workbook
→ SKU-17 CRM workbook
→ SKU-18 quotation/order/invoice workbook
~~~

The market decision will henceforth be made at SKU level.

## 6. Next research round

Do not jump to sourcing yet for all 36.

First perform SKU-level demand depth to reduce the pool:

~~~text
36 concrete SKUs
→ current Xianyu search/recommendation evidence
→ price bands
→ intent strength
→ independent seller/signal density
→ buyer-job clarity
→ seasonality
→ free substitute
→ Top 10–15 demand SKUs
~~~

Only after that:

~~~text
Top demand SKUs
→ source search
→ rights/license
→ fulfillment route
→ margin/support
→ Minimum Validation
~~~

This preserves the Owner rule:

> No source found yet ≠ no demand.

## 7. Current primary evidence ledger

- Xianyu 2026 H1 AI service transaction data:
  https://www.xinhuanet.com/tech/20260729/3ba4f5d1aaf044229b890f40ce52f492/c.html
- quotation software:
  https://www.goofish.com/item?categoryId=0&id=974663190233
- ecommerce image productivity:
  https://www.goofish.com/item?categoryId=201453616&id=920219589301
- listed-company management-team stability dataset:
  https://www.goofish.com/item?id=966484455784
- supply-chain PageRank dataset:
  https://www.goofish.com/item?id=1061281260797
- WordPress template bundle:
  https://www.goofish.com/item?categoryId=201454708&id=810121295766
- AI bid-writing recommendation market:
  https://www.goofish.com/item?categoryId=0&id=968373210332
- photography preset recommendation market:
  https://www.goofish.com/item?categoryId=50023914&id=1002437237853
- SolidWorks/CAD recommendation market:
  https://www.goofish.com/item?categoryId=0&id=899758670883
- digital-product / office / travel / technical-material recommendations:
  https://www.goofish.com/item?categoryId=50023914&id=1056677193291
- software/monitoring recommendation market:
  https://www.goofish.com/item?categoryId=0&id=1042808803331
- education/PPT/recipe/prompt recommendation market:
  https://www.goofish.com/item?id=1037962664440

## 8. X3R1 result

~~~text
X3R1_CONCRETE_SKU_REFRAME=PASS_CANDIDATE
CONCRETE_SKU_POOL=36
ABSTRACT_TOP3_SELECTION=SUPERSEDED
ABSTRACT_PRODUCT_FORM_ANALYSIS=RETAINED
SUPPLY_UNKNOWN_IS_DEMAND_KILL=NO
RIGHTS_AND_SOURCE_RESEARCH=DEFERRED_SEPARATE_AXIS
REAL_LISTING=0
REAL_PURCHASE=0
PAYMENT=0
ACCOUNT_MUTATION=0
RUNTIME_MUTATION=0
NEXT=SKU_LEVEL_DEMAND_DEPTH_36_TO_10_15
~~~
