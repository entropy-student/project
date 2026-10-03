# X3R3 — Normalized Platform-first SKU Universe R1 — 2026-10-03

Status: PASS_CANDIDATE
Scope: normalized candidate universe before final-catalog review
Source model: platform-first
Sourcing / fulfillment / listing: OUT OF SCOPE

## 1. Normalization rules

Every row is a searchable product type or concrete SKU family.

Evidence level:
- D4 = first-party/platform transaction evidence specifically names the product family, or attributable SKU transaction proof.
- D3 = replicated current Xianyu market evidence from multiple independent listings/sellers/signals.
- D2 = one current direct SKU or one coherent current related-results cluster.
- D1 = official platform category / macro / adjacent-derived evidence.
- U = insufficient.

Status:
- STRONG_SEED = should definitely proceed to X3R4 final-catalog review.
- PROBABLE_SEED = credible current market candidate, but evidence is weaker than STRONG.
- WATCHLIST = keep visible; current direct evidence is limited or derived.
- MARKET_SIGNAL_ONLY = demand is clearly present, but the observed form should not be described as a clean executable business recommendation.

Important:
- this is still a demand catalog project, not a compliance/supply project;
- “想要” is never treated as sales;
- recommendation clusters are not treated as search share;
- no candidate is downgraded merely because sourcing is unknown.

## 2. Normalized universe

| ID | Product type / normalized search phrase | Market surface | Provenance | Level | Current evidence summary | Status |
|---|---|---|---|---|---|---|
| N01 | AI 漫剧制作教程 + 项目文件 / 工作流 | AI digital products | PLATFORM_TRANSACTION | D4 | Xianyu-reported tutorial/course share 8.1%; one seller 17k AI-manga tutorial copies/6m | STRONG_SEED |
| N02 | 可复用 AI Workflow / Agent 模板 | AI digital products | PLATFORM_TRANSACTION | D4 family | templates/workflows 6.6% of AI-service orders; exact reusable-vs-custom split unknown | STRONG_SEED family |
| N03 | 优酷 SVIP 周卡 / 设备会员 | Membership | DIRECT_SKU + PLATFORM_CATEGORY | D2 | current RMB1.12–3.25, 987 wants, 4,079 views | STRONG_SEED |
| N04 | 迅雷 SVIP / 网盘会员月卡周卡直充 | Membership | RELATED_RESULTS_CLUSTER + PLATFORM_CATEGORY | D3 family | many independent current sellers; visible wants from tens to thousands, including 4,217 / 3,313 / 2,522 and one 61,999-intent listing | STRONG_SEED |
| N05 | 其他视频会员月卡/周卡 | Membership | PLATFORM_CATEGORY | D1 | official video-membership surface; exact platform SKUs need direct scan | WATCHLIST |
| N06 | 音乐 / 音频 / 阅读会员 | Membership | PLATFORM_CATEGORY | D1 | official Xianyu category surface | WATCHLIST |
| N07 | 咖啡 / 奶茶券或自助下单（如瑞幸） | Voucher | PLATFORM_CATEGORY + RELATED_RESULTS_CLUSTER | D2 | official coffee/milk-tea voucher surface; current Luckin self-order item visible | PROBABLE_SEED |
| N08 | 快餐 / 餐饮优惠券（麦当劳 / KFC / 达美乐等） | Voucher | PLATFORM_CATEGORY + RELATED_RESULTS_CLUSTER | D2 | official restaurant-voucher surface; current related pages show multiple food-order discount offers | PROBABLE_SEED |
| N09 | 电影票优惠 / 代购票 | Ticket | PLATFORM_CATEGORY | D1/D2 | official movie-ticket surface; repeated current public buyer/seller evidence exists but direct SKU depth incomplete | PROBABLE_SEED |
| N10 | 京东卡 / 代金卡 / 加油卡 | Stored-value cards | PLATFORM_CATEGORY | D1 | official Xianyu convenience-card surface | WATCHLIST |
| N11 | 景点 / 演出 / 网约车券 | Ticket/voucher | PLATFORM_CATEGORY | D1 | official Xianyu category surface | WATCHLIST |
| N12 | 游戏账号（以 CF 等为例） | Game virtual goods | RELATED_RESULTS_CLUSTER + PLATFORM_CATEGORY | D3 family | multiple current independent CF sellers/items; several visible wants in hundreds and one at 2,270 | MARKET_SIGNAL_ONLY |
| N13 | 游戏点券 / 充值 | Game virtual goods | PLATFORM_CATEGORY | D1 | official Xianyu game-trade category | WATCHLIST |
| N14 | 游戏皮肤 / 道具 / 装备 | Game virtual goods | PLATFORM_CATEGORY | D1 | official category surface | WATCHLIST |
| N15 | 游戏租号 / 代练 / 首充号 / 自抽号 | Game virtual goods | PLATFORM_CATEGORY | D1 | official category surface; service/account-like | MARKET_SIGNAL_ONLY |
| N16 | Dragonfly 25.1 软件授权码 / 激活 | Software activation | RELATED_RESULTS_CLUSTER | D2 | current RMB34.56, 12 wants | PROBABLE_SEED |
| N17 | ArchiCAD 29 教育订阅 / 激活 | Software activation | RELATED_RESULTS_CLUSTER | D2 | current RMB78.80 | PROBABLE_SEED |
| N18 | 课程 / 题库激活码 | Digital activation | RELATED_RESULTS_CLUSTER | D2 | current university English and question-bank activation products visible | PROBABLE_SEED |
| N19 | 多端多商户商城系统源码 | Source code | DIRECT_SKU | D2 | current indexed RMB13, 36 wants, 808 views; current item state later down | PROBABLE_SEED |
| N20 | 小程序 / 网站后台系统源码 | Source code | DERIVED_ADJACENT | D1 | adjacent to direct source-code market; direct replication pending | WATCHLIST |
| N21 | WordPress 外贸站 / 企业站主题模板包 | Website templates | DIRECT_SKU | D2 | RMB25.90 / direct 29, 804 wants, ~10k views | STRONG_SEED |
| N22 | 中小企业报价管理 Windows 软件 | Utility software | DIRECT_SKU | D2 | RMB13.50/direct13.90, 133 wants, 5,008 views | STRONG_SEED |
| N23 | AI 标书制作 / 标书生成软件 | Utility software | RELATED_RESULTS_CLUSTER | D2 | specific tool RMB8.60, 110 wants; dense current neighboring bid market | STRONG_SEED |
| N24 | 电商商品图片采集 / 整理效率软件 | Utility software | DIRECT_SKU | D2 | RMB2.98–50.98, 722 wants, 5,163 views | STRONG_SEED |
| N25 | 闲鱼关键词监控 / 上新提醒软件 | Utility software | RELATED_RESULTS_CLUSTER | D2 | current RMB79.20, 147 wants | PROBABLE_SEED |
| N26 | Python Excel / Word / PDF 办公自动化脚本包 | Utility/software pack | RELATED_RESULTS_CLUSTER | D2 | current RMB39.90 | PROBABLE_SEED |
| N27 | PDF 在线 / 批处理工具 | Utility software | RELATED_RESULTS_CLUSTER | D2 | current RMB20, 15 wants | PROBABLE_SEED |
| N28 | AI 漫剧一键制作工具 | AI tool | RELATED_RESULTS_CLUSTER | D2 | current RMB2.80 in current related market | PROBABLE_SEED |
| N29 | AIGC 提示词 + 示例图 + 参数包 | AI content asset | RELATED_RESULTS_CLUSTER | D2 | current RMB1.98 example | PROBABLE_SEED |
| N30 | 院校 / 专业考研复试资料包 | Education | RELATED_RESULTS_CLUSTER | D3 candidate | multiple independent current school/major packs; e.g. RMB15/109 wants and RMB49.98/45 wants | STRONG_SEED |
| N31 | 本地化初中 / 中考学科试卷复习包 | Education | RELATED_RESULTS_CLUSTER | D3 candidate | current physics pack RMB2.68, 161 wants plus multiple local/school test packs | STRONG_SEED |
| N32 | 教师教案 + PPT + 作业设计资料包 | Education | RELATED_RESULTS_CLUSTER | D2 | current teacher-product cluster; one related product 97 wants | PROBABLE_SEED |
| N33 | 英语课堂互动 PPT 游戏课件包 | Education | RELATED_RESULTS_CLUSTER | D2 | current example RMB2.68, 166 wants | STRONG_SEED |
| N34 | 公考 / 事业编 / 时政 / 题库资料包 | Education | RELATED_RESULTS_CLUSTER | D2 | multiple current exam/current-affairs products visible | PROBABLE_SEED |
| N35 | 职业资格 / 职称考试题库资料包 | Education | RELATED_RESULTS_CLUSTER | D2 | current logistics-professional pack RMB7.90, 15 wants plus activation products | PROBABLE_SEED |
| N36 | SAT / DSE / 留学考试资料包 | Education | RELATED_RESULTS_CLUSTER | D2 | current SAT/DSE products visible | PROBABLE_SEED |
| N37 | 大学课程笔记 / 期末复习资料 | Education | RELATED_RESULTS_CLUSTER | D2 | current university course/review PDFs visible | PROBABLE_SEED |
| N38 | 上市公司高管团队稳定性面板数据 | Research data | DIRECT_SKU | D2 | direct RMB1, 523 wants, 3,591 views | STRONG_SEED |
| N39 | 上市公司供应链网络地位 / PageRank 数据 | Research data | DIRECT_SKU | D2 | direct RMB1, 194 wants, 1,876 views | STRONG_SEED |
| N40 | DID / 政策事件 / 城市企业面板数据 | Research data | DIRECT_SKU | D2 | direct current DID dataset example RMB1, 24 wants, 260 views | PROBABLE_SEED |
| N41 | SolidWorks 非标自动化设备 3D 图纸库 | Engineering assets | RELATED_RESULTS_CLUSTER | D2 | current 13k-drawing product RMB1, 686 wants | STRONG_SEED |
| N42 | 工业机器人 PROFINET / EtherCAT 配置手册包 | Engineering materials | RELATED_RESULTS_CLUSTER | D2 | current auto-delivery manual product visible | PROBABLE_SEED |
| N43 | 芯片 / 半导体工艺制造资料合集 | Professional materials | RELATED_RESULTS_CLUSTER | D2 | current RMB14 product visible | PROBABLE_SEED |
| N44 | IE 工业工程经验 + 工具表资料包 | Professional materials | RELATED_RESULTS_CLUSTER | D2 | current RMB3, 90 wants | STRONG_SEED |
| N45 | 小提琴 / 大提琴制作图纸与技术文献 | Hobby/technical | RELATED_RESULTS_CLUSTER | D2 | current RMB12, 47 wants | PROBABLE_SEED |
| N46 | 日系胶片 Lightroom / PS 人像预设 | Photography assets | RELATED_RESULTS_CLUSTER | D3 candidate | current RMB0.80 / 603 wants plus several independent preset/LUT items | STRONG_SEED |
| N47 | 像素蛋糕漫展 / COS 修图预设口令 | Photography assets | RELATED_RESULTS_CLUSTER | D3 candidate | multiple current preset products from different sellers; visible intent 22/12/53 etc. | STRONG_SEED |
| N48 | 手机 Log 调色 LUT（vivo X200/X300 等） | Photography assets | RELATED_RESULTS_CLUSTER | D2 | current RMB4.93 | PROBABLE_SEED |
| N49 | 索尼 FX3 / 电影感 LUT 包 | Photography assets | RELATED_RESULTS_CLUSTER | D2 | current RMB3, 12 wants plus other cinema-LUT listings | PROBABLE_SEED |
| N50 | 婚纱 / 人像 PSD 背景前景水印素材包 | Design assets | RELATED_RESULTS_CLUSTER | D2 | current PSD/background asset products visible | PROBABLE_SEED |
| N51 | 剪辑音效库 / SFX 素材包 | Audio assets | RELATED_RESULTS_CLUSTER | D2 | current 30k+ SFX-library product visible | PROBABLE_SEED |
| N52 | AE / PR 剪辑模板包 | Video assets | RELATED_RESULTS_CLUSTER | D1/D2 | current editing/template market visible, but observed cluster is contaminated by circumvention tools | WATCHLIST |
| N53 | 乐谱 + 伴奏 / 示范音频资料包 | Music assets | RELATED_RESULTS_CLUSTER | D2 | current score/backing products visible | PROBABLE_SEED |
| N54 | 蓝桥杯 / 技能竞赛经验与资料包 | Professional/education | RELATED_RESULTS_CLUSTER | D2 | current embedded-competition material product visible | PROBABLE_SEED |
| N55 | 货代 / 行业专业资料包 | Professional materials | RELATED_RESULTS_CLUSTER | D2 | current freight-forwarding professional pack visible | PROBABLE_SEED |
| N56 | 日本关西自由行 PDF + 地图清单 | Lifestyle guide | RELATED_RESULTS_CLUSTER | D2 | current self-made RMB26 guide | PROBABLE_SEED |
| N57 | 家常菜 / 空气炸锅菜谱电子书 | Lifestyle guide | RELATED_RESULTS_CLUSTER | D2 | current 360-recipe product RMB8 | PROBABLE_SEED |
| N58 | 小吃 / 餐饮制作教程资料包 | Lifestyle guide | RELATED_RESULTS_CLUSTER | D2 | current snack tutorial RMB6.80 | PROBABLE_SEED |
| N59 | 编织 / 手工教程资料库 | Hobby guide | RELATED_RESULTS_CLUSTER | D2 | current craft/knitting tutorial products visible | PROBABLE_SEED |
| N60 | 摄影课程 / 后期教程资料包 | Creative education | RELATED_RESULTS_CLUSTER | D2 | current photography-course cluster includes 40/86-want examples | PROBABLE_SEED |

## 3. Old 36 reconciliation

| Old SKU | Action | New mapping / reason |
|---|---|---|
| 01 AI 漫剧教程 | RETAIN | N01 |
| 02 AI 标书教程 | DOWNGRADE_DERIVED | not retained as direct universe entry until direct tutorial SKU evidence |
| 03 WordPress themes | RETAIN | N21 |
| 04 SolidWorks drawings | RETAIN | N41 |
| 05 Japanese-film preset | RETAIN | N46 |
| 06 management-stability data | RETAIN | N38 |
| 07 ecommerce image collection tool | RETAIN | N24 |
| 08 AI retouch preset | MERGE | N47 / photography preset family |
| 09 AI bid software | RETAIN | N23 |
| 10 quotation software | RETAIN | N22 |
| 11 PageRank dataset | RETAIN | N39 |
| 12 English PPT games | RETAIN | N33 |
| 13 Xianyu monitor | RETAIN | N25 |
| 14 Python Office pack | RETAIN | N26 |
| 15 Excel cleanup tool | DOWNGRADE_DERIVED | direct SKU evidence insufficient |
| 16 Excel inventory/profit/order | DOWNGRADE_DERIVED | direct SKU evidence insufficient |
| 17 Excel CRM | DOWNGRADE_DERIVED | direct SKU evidence insufficient |
| 18 Excel quote/order/invoice | DOWNGRADE_DERIVED | adjacent to quotation software only |
| 19 PDF batch tool | RETAIN_NORMALIZED | N27 |
| 20 file rename/archive | DOWNGRADE_DERIVED | no direct current SKU evidence retained |
| 21 ecommerce resize/rename | SPLIT_FROM_OBSERVED | not same evidence as N24 |
| 22 vivo Log LUT | RETAIN | N48 |
| 23 FX3 LUT | RETAIN | N49 |
| 24 short-drama teardown guide | WATCHLIST | related current SKU exists but weak intent |
| 25 AIGC prompt pack | RETAIN | N29 |
| 26 IE material | RETAIN | N44 |
| 27 semiconductor materials | RETAIN | N43 |
| 28 robot manuals | RETAIN | N42 |
| 29 instrument drawings/docs | RETAIN_NORMALIZED | N45 |
| 30 recipe ebook | RETAIN | N57 |
| 31 Kansai guide | RETAIN | N56 |
| 32 postgraduate retest pack | RETAIN_EXPAND | N30 |
| 33 local middle-school pack | RETAIN_EXPAND | N31 |
| 34 teacher lesson/PPT | RETAIN | N32 |
| 35 AI manga one-click tool | RETAIN | N28 |
| 36 price/stock monitor | PARTIAL_RETAIN | monitoring-software family N25; multi-platform comparison exact SKU needs stronger direct evidence |

## 4. Major additions not present in old 36

The review adds entire market surfaces that were previously missing:

- N03–N06 membership;
- N07–N11 cards/tickets/vouchers;
- N12–N15 game virtual goods;
- N16–N18 software/course activation products;
- N19–N20 source-code market;
- expanded N30–N37 education/exam market;
- N50–N53 creative asset market.

This is why simply rescoring the old 36 would have produced a biased final catalog.

## 5. X3R3 status

~~~text
PLATFORM_FIRST_MARKET_SURFACES_COVERED=15/15
NORMALIZED_UNIVERSE_ENTRIES=60
OLD_36_RECONCILED=36/36
PROVENANCE_MODEL=APPLIED
D4_D3_D2_D1_MODEL=APPLIED
FINAL_WINNER=NOT_REQUIRED
FINAL_CATALOG=NOT_YET_ACCEPTED
NEXT=X3R4_FINAL_SKU_CATALOG_REVIEW
~~~

X3R4 should decide which of these 60 belong in the final catalog as:
- CONFIRMED_DEMAND
- PROBABLE_DEMAND
- WATCHLIST
- MARKET_SIGNAL_ONLY

No sourcing or execution work is needed.
