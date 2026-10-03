# Research Ledger — 2026-10-03 / v2.2 calibration

Status: CALIBRATION_EVIDENCE_RECORD / CANONICAL_SUPPORT

```text
RUN_ID=XIANYU-CALIBRATION-2026-10-03
SKILL_VERSION=2.2.0
PLATFORM=XIANYU
SCOPE=60 historical normalized candidates + 1 review-input candidate + 2 newly observed offers + 1 reported tutorial separated from old bundle
MODE=MARKET_MAP
OBSERVED_AT=2026-10-03
CURRENT_TARGET_WINDOW=2026-07-06 through 2026-10-03 (90 days, inclusive)
PREVIOUS_RUN=X3R3/X3R4 historical records + v2.1 chat export
EXECUTION_CLASS=DOCUMENTATION_CALIBRATION + LIMITED_PUBLIC_PAGE_CHECKS
PUBLIC_PAGE_CHECK_BUDGET=3 distinct detail anchors + 1 report source (not HTTP request count)
TESTS_LISTINGS_PAYMENTS=0
```

## A. Evidence boundaries

本底稿记录谁观察、何时观察和事实实际支持的范围。C-记录来自本轮父 Reviewer 的公开页面现场核验，文档执行者没有独立重开页面；H-01/H-02来自同一已核验报道，分别记录平台H1商品族数据和具体教程的期间未知案例。I-N01–I-N61是继承记录，不是61次新的现场验证。其中I-N03/N19/N21/N22/N24/N38/N39/N40同时保留具名对象、原始想要/浏览和直接商品ID，复用为INTEREST/D2/UNKNOWN；未刷新只影响时效与Confidence，不抹去原始事实。其余缺推荐商品自身ID或Scope错配的概述仍需核验。

观察日不等于行为日。页面累计想要／浏览在本轮可见，可按 D2 记录当前页面弱信号，但不能推断本轮90天新增人数、当前成交或趋势。既有某条 URL 不代表其所有推荐商品均已定位。

## B. Current and historical observations

| ID | Observer / observed at | Source / item / seller | Raw fact | Signal Type / Value | Supported unit / Scope | Source Nature | Evidence Period / classification / lineage | Limitation / classification |
|---|---|---|---|---|---|---|---|---|
| C-01 | Parent Reviewer / 2026-10-03 | https://www.goofish.com/item?id=1002437237853 ; 小雪摄影室 | 页面标题“李大本事原版仿富士胶片预设 富士ps滤镜lr预设 某书39预”，内容6个xmp；页面价格0.80元，18想要、276浏览；卖家累计卖出28712；推荐卡片另见303/655/234想要 | INTEREST；想要18、浏览276 | 李大本事仿富士胶片LR/PS预设（6个xmp） SKU；Provenance=DIRECT_SKU | 直接平台记录 | 行为累计期间 UNKNOWN；lineage=item1002437237853 ; 推荐卡片ID1047142225996=303想要、910587994711=655想要、988306269888=234想要；仅当时推荐，不归属本SKU | N63为具名SKU D2；N46旧“日系胶片人像”细分未匹配，不能把推荐全类想要下传；卖家累计非SKU销量；推荐卡片只作旁证 |
| C-02 | Parent Reviewer / 2026-10-03 | https://www.goofish.com/item?id=829473725585 ; 无忧卡卷 | 价格7.87–166.99元，20万人想要、137万浏览；卖家累计卖出426581；推荐卡片1765/141/378/62003想要 | INTEREST；想要页面显示20万人、浏览页面显示137万 | 迅雷会员 PRODUCT_TYPE；Provenance=DIRECT_SKU；周卡/月卡等单一变体未逐项验证 | 直接平台记录 | 行为累计期间 UNKNOWN；lineage=item829473725585 ; 推荐卡片ID未记录 | N04最多D2；多挂单想要仍弱信号；数值为页面缩写非精确人数；累计卖出非SKU订单 |
| C-03 | Parent Reviewer / 2026-10-03 | https://www.goofish.com/item?id=968373210332 ; 标书打工人 | 标题“标探长AI-标书技术方案”，19.90元，199想要、2207浏览，预计工期1–5天，按元/次计价，规格“旗舰版一本方案19.9”；卖家累计卖出352；推荐混会员、租号、代生成、工具 | INTEREST；想要199、浏览2207 | AI辅助标书按次生成服务 SKU（服务Offer）；Provenance=DIRECT_SKU；非自用/可下载软件 | 直接平台记录 | 行为累计期间 UNKNOWN；lineage=item968373210332 | N62为具名服务SKU D2；N23软件本体仍U；服务不能证明工具SKU；卖家累计非SKU销量 |
| H-01 | Parent Reviewer source verification / 2026-10-03 | https://www.xinhuanet.com/tech/20260729/3ba4f5d1aaf044229b890f40ce52f492/c.html ; 新华社2026-07-29报道闲鱼数据 | 平台2026上半年AI服务订单中，AI教程与课程占比8.1% | TRANSACTION；订单占比8.1%（订单商品族占比，非某SKU销量） | AI教程/课程 FAMILY；Provenance=PLATFORM_TRANSACTION | 媒体明确转述平台数据（reported） | HISTORICAL；2026 H1（2026-01-01–06-30）；lineage=Xianyu20260729-report | historical reported D4；不支持本轮90天current D4，不能下传具体漫剧或Bundle |
| H-02 | Parent Reviewer source verification / 2026-10-03 | https://www.xinhuanet.com/tech/20260729/3ba4f5d1aaf044229b890f40ce52f492/c.html ; 同一报道的具体教程案例 | “有人半年卖出1.7万份AI漫剧制作教程” | TRANSACTION；约17000（个案） | AI漫剧制作教程 PRODUCT_TYPE；Provenance=PLATFORM_TRANSACTION；项目文件/Workflow Bundle未验证 | 媒体报道平台交易案例（reported） | UNKNOWN；半年，具体起止UNKNOWN；截至2026-07-29报道；lineage=Xianyu20260729-report | N64为reported D4 / PERIOD_UNKNOWN；N01旧组合仍U；不能归属当前90天，也不能断言全部交易在90天窗外；同源报道不是两份独立买方意图 |

## C. Imported observations — not fresh verification

共同metadata：导入日期2026-10-03；原观察日未逐项记录，旧报告日期为2026-10-03，本轮未刷新；行为期间UNKNOWN（H-01另列明确H1）；Confidence=LOW。Signal Type按逐条定位区别：8条具名直接观察为INTEREST，两条媒体摘录为TRANSACTION（与H-记录共用Xianyu20260729-report Lineage；仅支持其报道对象和期间），类目记录为SUPPLY（仅上位市场面，不自动证明具体SKU），缺推荐商品自身ID／Scope错配者为CLAIM待核验。来源链、支持对象和原文入口如下；没有因为“未fresh”而统一降级。直接组Lineage按表内原商品ID归并，同ID后续快照不增加独立买方事件数；缺定位组不能因不同导入ID声称独立。旧数值不覆盖C-记录。

| Observation ID | Candidate | Original raw statement | Source pointer | URL / Item ID | Named supported unit / Scope | Signal Type | Source Nature / refresh | Original record | Retained evidence |
|---|---|---|---|---|---|---|---|---|---|
| I-N01 | N01 | Xianyu-reported tutorial/course share 8.1%; one seller 17k AI-manga tutorial copies/6m | S02 | https://www.xinhuanet.com/tech/20260729/3ba4f5d1aaf044229b890f40ce52f492/c.html | AI教程课程 FAMILY / AI漫剧教程 PRODUCT_TYPE；不支持N01 BUNDLE | TRANSACTION | 旧媒体摘录；同源报道已核对，不增加独立事件 | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N01 | reported D4 / 具体教程期间UNKNOWN；平台H1只支持教程课程FAMILY；原 Bundle 不继承 |
| I-N02 | N02 | templates/workflows 6.6% of AI-service orders; exact reusable-vs-custom split unknown | S02 | https://www.xinhuanet.com/tech/20260729/3ba4f5d1aaf044229b890f40ce52f492/c.html | AI模板与工作流（含定制服务） FAMILY；不支持可复用模板SKU | TRANSACTION | 旧媒体摘录；同源报道已核对，不增加独立事件 | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N02 | H1 templates/workflows 商品族交易占比；本候选 U |
| I-N03 | N03 | current RMB1.12–3.25, 987 wants, 4,079 views | S03 | https://www.goofish.com/item?id=1011466117609 | 优酷SVIP周卡/设备会员 / PRODUCT_TYPE | INTEREST | 直接平台记录（继承原观察，未刷新）；Provenance=DIRECT_SKU | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N03；[旧canonical条目/源表](history/FINAL_SKU_CATALOG_2026-10_PRE_V2_2.md#3-probable-demand-catalog) S03 | D2 / UNKNOWN / LOW；987想要、4079浏览；具体设备/时长变体适用性未刷新 |
| I-N04 | N04 | many independent current sellers; visible wants from tens to thousands, including 4,217 / 3,313 / 2,522 and one 61,999-intent listing | S04 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N04 | D2 CLAIM / 弱信号复现 |
| I-N05 | N05 | official video-membership surface; exact platform SKUs need direct scan | S01 | https://www.goofish.com/（上位类目，非本候选SKU） | 上位平台类目 / FAMILY；具体形态待匹配 | SUPPLY | 平台类目观察（继承；只支持上位市场面） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N05 | D1 CLAIM / 类目供给 |
| I-N06 | N06 | official Xianyu category surface | S01 | https://www.goofish.com/（上位类目，非本候选SKU） | 上位平台类目 / FAMILY；具体形态待匹配 | SUPPLY | 平台类目观察（继承；只支持上位市场面） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N06 | D1 CLAIM / 类目供给 |
| I-N07 | N07 | official coffee/milk-tea voucher surface; current Luckin self-order item visible | S01,S05 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N07 | U / 供给或推导 |
| I-N08 | N08 | official restaurant-voucher surface; current related pages show multiple food-order discount offers | S01,S05 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N08 | U / 供给或推导 |
| I-N09 | N09 | official movie-ticket surface; repeated current public buyer/seller evidence exists but direct SKU depth incomplete | S01 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N09 | U / 供给或推导 |
| I-N10 | N10 | official Xianyu convenience-card surface | S01 | https://www.goofish.com/（上位类目，非本候选SKU） | 上位平台类目 / FAMILY；具体形态待匹配 | SUPPLY | 平台类目观察（继承；只支持上位市场面） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N10 | D1 CLAIM / 类目供给 |
| I-N11 | N11 | official Xianyu category surface | S01 | https://www.goofish.com/（上位类目，非本候选SKU） | 上位平台类目 / FAMILY；具体形态待匹配 | SUPPLY | 平台类目观察（继承；只支持上位市场面） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N11 | D1 CLAIM / 类目供给 |
| I-N12 | N12 | multiple current independent CF sellers/items; several visible wants in hundreds and one at 2,270 | S01（类目；旧game cluster逐项ID缺失） | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N12 | D2 CLAIM / 弱信号复现 |
| I-N13 | N13 | official Xianyu game-trade category | S01 | https://www.goofish.com/（上位类目，非本候选SKU） | 上位平台类目 / FAMILY；具体形态待匹配 | SUPPLY | 平台类目观察（继承；只支持上位市场面） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N13 | D1 CLAIM / 类目供给 |
| I-N14 | N14 | official category surface | S01 | https://www.goofish.com/（上位类目，非本候选SKU） | 上位平台类目 / FAMILY；具体形态待匹配 | SUPPLY | 平台类目观察（继承；只支持上位市场面） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N14 | D1 CLAIM / 类目供给 |
| I-N15 | N15 | official category surface; service/account-like | S01 | https://www.goofish.com/（上位类目，非本候选SKU） | 上位平台类目 / FAMILY；具体形态待匹配 | SUPPLY | 平台类目观察（继承；只支持上位市场面） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N15 | D1 CLAIM / 类目供给 |
| I-N16 | N16 | current RMB34.56, 12 wants | S01 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N16 | D2 CLAIM / 弱信号 |
| I-N17 | N17 | current RMB78.80 | S01 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N17 | U / 供给或推导 |
| I-N18 | N18 | current university English and question-bank activation products visible | S09 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N18 | U / 供给或推导 |
| I-N19 | N19 | current indexed RMB13, 36 wants, 808 views; current item state later down | S08 | https://www.goofish.com/item?id=989122652146 | 多端多商户商城系统源码 / PRODUCT_TYPE | INTEREST | 直接平台记录（继承原观察，未刷新）；Provenance=DIRECT_SKU | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N19；[旧canonical条目/源表](history/FINAL_SKU_CATALOG_2026-10_PRE_V2_2.md#3-probable-demand-catalog) S08 | D2 / UNKNOWN / LOW；36想要、808浏览；旧记录同时说明后来下架，当前供给状态未刷新 |
| I-N20 | N20 | adjacent to direct source-code market; direct replication pending | S08 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N20 | U / 供给或推导 |
| I-N21 | N21 | RMB25.90 / direct 29, 804 wants, ~10k views | S07 | https://www.goofish.com/item?id=810121295766 | WordPress 700+主题模板包（外贸/企业站用途未核验） / BUNDLE | INTEREST | 直接平台记录（继承原观察，未刷新）；Provenance=DIRECT_SKU | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N21；[旧canonical条目/源表](history/FINAL_SKU_CATALOG_2026-10_PRE_V2_2.md#3-probable-demand-catalog) S07 | D2 / UNKNOWN / LOW；804想要、约1万浏览；只支持通用700+主题包，不能证明外贸/企业用途适配 |
| I-N22 | N22 | RMB13.50/direct13.90, 133 wants, 5,008 views | S11 | https://www.goofish.com/item?id=974663190233 | 中小企业报价管理Windows软件 / PRODUCT_TYPE | INTEREST | 直接平台记录（继承原观察，未刷新）；Provenance=DIRECT_SKU | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N22；[旧canonical条目/源表](history/FINAL_SKU_CATALOG_2026-10_PRE_V2_2.md#3-probable-demand-catalog) S11 | D2 / UNKNOWN / LOW；133想要、5008浏览；单个软件观察不代表稳定市场 |
| I-N23 | N23 | specific tool RMB8.60, 110 wants; dense current neighboring bid market | S12 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N23 | D2 CLAIM / 弱信号复现 |
| I-N24 | N24 | RMB2.98–50.98, 722 wants, 5,163 views | S13 | https://www.goofish.com/item?id=920219589301 | 电商商品图片采集软件（整理功能未核验） / PRODUCT_TYPE | INTEREST | 直接平台记录（继承原观察，未刷新）；Provenance=DIRECT_SKU | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N24；[旧canonical条目/源表](history/FINAL_SKU_CATALOG_2026-10_PRE_V2_2.md#3-probable-demand-catalog) S13 | D2 / UNKNOWN / LOW；722想要、5163浏览；观察支持图片采集，附加整理能力/第三方资产权利未核验 |
| I-N25 | N25 | current RMB79.20, 147 wants | S14 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N25 | D2 CLAIM / 弱信号 |
| I-N26 | N26 | current RMB39.90 | S15 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N26 | U / 供给或推导 |
| I-N27 | N27 | current RMB20, 15 wants | S09 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N27 | D2 CLAIM / 弱信号 |
| I-N28 | N28 | current RMB2.80 in current related market | S16 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N28 | U / 供给或推导 |
| I-N29 | N29 | current RMB1.98 example | S17 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N29 | U / 供给或推导 |
| I-N30 | N30 | multiple independent current school/major packs; e.g. RMB15/109 wants and RMB49.98/45 wants | S09 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N30 | D2 CLAIM / 弱信号复现 |
| I-N31 | N31 | current physics pack RMB2.68, 161 wants plus multiple local/school test packs | S09 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N31 | D2 CLAIM / 弱信号复现 |
| I-N32 | N32 | current teacher-product cluster; one related product 97 wants | S17 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N32 | D2 CLAIM / 弱信号复现 |
| I-N33 | N33 | current example RMB2.68, 166 wants | S17 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N33 | D2 CLAIM / 弱信号 |
| I-N34 | N34 | multiple current exam/current-affairs products visible | S15 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N34 | U / 供给或推导 |
| I-N35 | N35 | current logistics-professional pack RMB7.90, 15 wants plus activation products | S09 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N35 | D2 CLAIM / 弱信号 |
| I-N36 | N36 | current SAT/DSE products visible | S09 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N36 | U / 供给或推导 |
| I-N37 | N37 | current university course/review PDFs visible | S09 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N37 | U / 供给或推导 |
| I-N38 | N38 | direct RMB1, 523 wants, 3,591 views | S18 | https://www.goofish.com/item?id=966484455784 | 上市公司高管团队稳定性面板数据 / PRODUCT_TYPE | INTEREST | 直接平台记录（继承原观察，未刷新）；Provenance=DIRECT_SKU | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N38；[旧canonical条目/源表](history/FINAL_SKU_CATALOG_2026-10_PRE_V2_2.md#3-probable-demand-catalog) S18 | D2 / UNKNOWN / LOW；523想要、3591浏览；该具名数据产品，不外推其他指标数据集 |
| I-N39 | N39 | direct RMB1, 194 wants, 1,876 views | S19 | https://www.goofish.com/item?id=1061281260797 | 上市公司供应链网络地位/PageRank数据 / PRODUCT_TYPE | INTEREST | 直接平台记录（继承原观察，未刷新）；Provenance=DIRECT_SKU | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N39；[旧canonical条目/源表](history/FINAL_SKU_CATALOG_2026-10_PRE_V2_2.md#3-probable-demand-catalog) S19 | D2 / UNKNOWN / LOW；194想要、1876浏览；仅该具名数据产品 |
| I-N40 | N40 | direct current DID dataset example RMB1, 24 wants, 260 views | S20 | https://www.goofish.com/item?id=1059572721917 | DID/政策事件面板数据（具体城市/企业版本未核验） / PRODUCT_TYPE | INTEREST | 直接平台记录（继承原观察，未刷新）；Provenance=DIRECT_SKU | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N40；[旧canonical条目/源表](history/FINAL_SKU_CATALOG_2026-10_PRE_V2_2.md#3-probable-demand-catalog) S20 | D2 / UNKNOWN / LOW；24想要、260浏览；支持DID/政策面板产品，不证明任意城市/企业版本 |
| I-N41 | N41 | current 13k-drawing product RMB1, 686 wants | S21 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N41 | D2 CLAIM / 弱信号 |
| I-N42 | N42 | current auto-delivery manual product visible | S09 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N42 | U / 供给或推导 |
| I-N43 | N43 | current RMB14 product visible | S15 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N43 | U / 供给或推导 |
| I-N44 | N44 | current RMB3, 90 wants | S15 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N44 | D2 CLAIM / 弱信号 |
| I-N45 | N45 | current RMB12, 47 wants | S15 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N45 | D2 CLAIM / 弱信号 |
| I-N46 | N46 | current RMB0.80 / 603 wants plus several independent preset/LUT items | S10 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N46 | D2 CLAIM / 弱信号复现 |
| I-N47 | N47 | multiple current preset products from different sellers; visible intent 22/12/53 etc. | S10 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N47 | D2 CLAIM / 弱信号复现 |
| I-N48 | N48 | current RMB4.93 | S10 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N48 | U / 供给或推导 |
| I-N49 | N49 | current RMB3, 12 wants plus other cinema-LUT listings | S10 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N49 | D2 CLAIM / 弱信号 |
| I-N50 | N50 | current PSD/background asset products visible | S10 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N50 | D2 CLAIM / 弱信号复现 |
| I-N51 | N51 | current 30k+ SFX-library product visible | S16 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N51 | U / 供给或推导 |
| I-N52 | N52 | current editing/template market visible, but observed cluster is contaminated by circumvention tools | S16 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N52 | U / 供给或推导 |
| I-N53 | N53 | current score/backing products visible | S15 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N53 | U / 供给或推导 |
| I-N54 | N54 | current embedded-competition material product visible | S15 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N54 | U / 供给或推导 |
| I-N55 | N55 | current freight-forwarding professional pack visible | S15 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N55 | U / 供给或推导 |
| I-N56 | N56 | current self-made RMB26 guide | S15 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N56 | U / 供给或推导 |
| I-N57 | N57 | current 360-recipe product RMB8 | S17 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N57 | U / 供给或推导 |
| I-N58 | N58 | current snack tutorial RMB6.80 | S15 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N58 | U / 供给或推导 |
| I-N59 | N59 | current craft/knitting tutorial products visible | S15 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N59 | U / 供给或推导 |
| I-N60 | N60 | current photography-course cluster includes 40/86-want examples | S10 | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [母表原文](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md#2-normalized-universe) N60 | D2 CLAIM / 弱信号复现 |
| I-N61 | N61 | 聊天重跑声称多个独立挂单出现强买方信号；未保留逐项商品 ID、原始数值、卖家和行为时间。 | REVIEW_INPUT | UNKNOWN（源表锚点不能替代推荐商品自身ID；交易报道另见H-记录） | 原文所述对象待定位/匹配；不自动下传候选 | CLAIM | 旧报告/聊天概述（继承；缺逐项ID或对象错配） | [v2.1导出第5节](history/XIANYU_MARKET_MAP_RERUN_V2_1_2026-10-03.md#5-probable_demand) | D2 CLAIM / 弱信号复现 |

## D. Coverage and stop

| Surface / task | Coverage | What was actually checked | Stop / limitation | Refresh trigger |
|---|---|---|---|---|
| 60 historical normalized candidates + review-input N61 | SCANNED (document reconciliation only) | All61 inherited names and claims reconciled; N62/N63 added from current different Offers; N64 split as the reported tutorial itself | Not a new public-market universe scan | New buyer evidence or periodic new-entry exploration |
| Membership N04 | PARTIAL | One direct item + visible recommendation numbers C-02 | Buyer intent/payment not observable in retained evidence; related IDs missing | Capture purchase-specific independent events and trade period |
| Photography N46/N63 | PARTIAL | C-01 named Fuji-style6-xmp preset added as N63 | Old N46 portrait subtype not confirmed; recommendation IDs retained but style/portrait match not established | Capture matching portrait SKU and purchase-specific events |
| AI bidding N23/N62 | PARTIAL | C-03 direct service Offer added as N62, item968373210332 | N23 service-to-software mismatch; no matching software buyer event | Locate actual software item / independent purchase-specific intent |
| Other historical market surfaces | PARTIAL / NOT REFRESHED | 8 attributable direct INTEREST observations reused; remaining imports distinguished individually | Reused records have original item IDs but no known behavior period; missing-ID recommendation claims remain limited; no saturation claim | Refresh by decision impact; do not repeat all work solely for lack of a fresh read |

Termination reason: calibration finished within the declared three-detail-anchor plus one-report sampling budget, with explicit unknowns; three direct anchors plus one historical report source were checked. Two-path discovery saturation was not performed or claimed. Fresh public evidence is not extrapolated to the other candidates.

## E. Sources and preservation

The following are inherited source pointers from the old catalog. Eight source pointers (S03/S08/S07/S11/S13/S18/S19/S20) directly locate the named observations and are reused with original raw facts. Other recommendation anchors cannot identify every recommended candidate. No source is presented as newly refreshed:

- S01 — Xianyu legacy official homepage taxonomy:
  https://www.goofish.com/
- S02 — Xinhua 2026 H1 Xianyu AI-service data:
  https://www.xinhuanet.com/tech/20260729/3ba4f5d1aaf044229b890f40ce52f492/c.html
- S03 — Youku SVIP legacy listing:
  https://www.goofish.com/item?categoryId=0&id=1011466117609
- S04 — legacy Xunlei membership related-results cluster:
  https://www.goofish.com/item?categoryId=201703201&id=829473725585
- S05 — legacy food/member/order related-results cluster:
  https://www.goofish.com/item?categoryId=0&id=692505015204
- S07 — WordPress 700+ theme bundle:
  https://www.goofish.com/item?categoryId=201454708&id=810121295766
- S08 — multi-merchant mall source code:
  https://www.goofish.com/item?categoryId=201453616&id=989122652146
- S09 — legacy education/exam related-results cluster:
  https://www.goofish.com/item?categoryId=50023914&id=1058677363846
- S10 — legacy photography preset/LUT related-results cluster:
  https://www.goofish.com/item?categoryId=50023914&id=1002437237853
- S11 — small-business quotation software:
  https://www.goofish.com/item?categoryId=0&id=974663190233
- S12 — legacy AI bid-writing market:
  https://www.goofish.com/item?categoryId=0&id=968373210332
- S13 — ecommerce image-productivity software:
  https://www.goofish.com/item?categoryId=201453616&id=920219589301
- S14 — legacy software/monitoring cluster:
  https://www.goofish.com/item?categoryId=0&id=1042808803331
- S15 — legacy digital/technical/office/lifestyle related-results cluster:
  https://www.goofish.com/item?categoryId=50023914&id=1056677193291
- S16 — legacy video/AI/software related-results cluster:
  https://www.goofish.com/item?categoryId=50023914&id=1075972228395
- S17 — legacy education/PPT/recipe/prompt related-results cluster:
  https://www.goofish.com/item?id=1037962664440
- S18 — listed-company management-team-stability dataset:
  https://www.goofish.com/item?id=966484455784
- S19 — listed-company supply-chain PageRank dataset:
  https://www.goofish.com/item?id=1061281260797
- S20 — legacy DID/policy panel dataset:
  https://www.goofish.com/item?categoryId=202036301&id=1059572721917
- S21 — legacy CAD/SolidWorks related market:
  https://www.goofish.com/item?categoryId=0&id=899758670883

Preserved input: [v2.1 chat export](history/XIANYU_MARKET_MAP_RERUN_V2_1_2026-10-03.md) — REVIEW INPUT / NOT CANONICAL, retains its original1/11/49 claims.

Preserved old catalog: [pre-v2.2 body](history/FINAL_SKU_CATALOG_2026-10_PRE_V2_2.md) — historical, superseded labels; original Git blob bytes from496f464029fad4a5747465ce441613104ed8ce06 retained.

```text
FINAL_SKU_CATALOG_2026-10_PRE_V2_2.md SHA256=c98c54789815b5ae616c6307f77f2317171ddc138907aeb4422cd3f576401187
XIANYU_MARKET_MAP_RERUN_V2_1_2026-10-03.md SHA256=4ccdff696a7b6cb7becd88f177bf869f74ec228a7060793119ef0d3ec32158e7
```
