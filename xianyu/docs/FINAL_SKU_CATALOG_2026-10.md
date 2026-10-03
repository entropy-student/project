# FINAL — Xianyu Calibrated Discovery Catalog — 2026-10-03

Status: FINAL_CALIBRATED_RECORD / CANONICAL
Evidence model: v2.2 / MARKET_MAP / XIANYU

## 1. Result and interpretation

完整保留60个标准化候选，加聊天重跑新增搬运工具N61、本轮发现的两个不同Offer N62/N63，以及从旧组合拆出的教程本体N64，共64个发现候选。目录不为维持旧数量而省略新发现。本轮现有可复核当前样本没有D3/D4：**当前90天可确认D3/D4=0**。目录证据分布为1个reported D4／时期UNKNOWN（N64）、11个D2／累计时期UNKNOWN（3个本轮入口、8个继承直接观察）、52个匹配证据不足U；需求状态为1个时期未知CONFIRMED_DEMAND、63个WATCHLIST，不把时期未知确认计入当前确认数。这表示现有记录不足以确认当前付费需求，**不是市场没有需求**，也不是64个候选都重新现场验证过。

新华社2026-07-29报道需要分开解读：平台2026上半年AI教程与课程商品族订单占比8.1%，为HISTORICAL_REPORTED_D4（FAMILY）；“有人半年卖出1.7万份AI漫剧制作教程”的具体半年起止未明示，保留reported D4 / PERIOD_UNKNOWN（PRODUCT_TYPE），不能自动归属当前90天，也不能断言全部交易在90天窗外。具体教程案例不能自动支持项目文件/Workflow组合。

| Evidence ID | 具名对象 | Scope | D-Level | Period classification / evidence period | Source Nature |
|---|---|---|---|---|---|
| H-01 | AI教程与课程 | FAMILY | D4 | HISTORICAL；2026 H1，订单占比8.1% | 媒体明确转述平台数据（reported） |
| H-02 | AI漫剧制作教程 | PRODUCT_TYPE | D4 | UNKNOWN；半年起止UNKNOWN；截至2026-07-29报道 | 媒体报道平台交易案例（reported） |

旧“6 Confirmed +44 Probable”及聊天重跑“1 Confirmed +11 Probable +49 Watchlist”均为历史结果，不再作为当前标签。重跑的11个Probable声称全部降为**至多D2的弱信号复制主张**；未保留逐项ID、原始行为、期间的行不会因此成为本轮已核验D2。

本轮父Reviewer现场核验三条商品入口：迅雷会员当前页面弱信号匹配N04；摄影锚点是李大本事仿富士胶片LR/PS预设（6个xmp），作为N63保留；不能直接证明旧N46所指日系胶片人像细分。AI标书锚点是按次生成服务，作为N62保留；不能证明N23自用/可下载软件。新增两行各为D2，行为期间UNKNOWN。页面可见累计值的行为期间未知，不证明本轮90天新增需求。

## 2. Evidence contract

```text
OBSERVATION_DATE=2026-10-03
CURRENT_TARGET_WINDOW=2026-07-06 through 2026-10-03 (90 days, inclusive)
CURRENT_CONFIRMED_DEMAND=0
CURRENT_PROBABLE_DEMAND=0
CATALOG_D2_PERIOD_UNKNOWN=11
REUSED_DIRECT_INTEREST_OBSERVATIONS=8
CATALOG_U=52
CATALOG_WATCHLIST=63
CATALOG_CONFIRMED_PERIOD_UNKNOWN=1
HISTORICAL_D4_FAMILY=AI教程与课程 / H1_2026
PERIOD_UNKNOWN_D4_PRODUCT_TYPE=AI漫剧制作教程 / 半年起止UNKNOWN
COMPLETE_FRESH_VERIFICATION_OF_64=NO
MARKET_EXHAUSTIVENESS=NOT_CLAIMED
LEDGER=RESEARCH_LEDGER_2026-10-03.md
```

- D4：同Scope可归属真实交易／平台第一方交易报道；转述标reported。卖家口号、自述和卖家全店累计销量不算SKU成交证明。
- D3：多个独立且明确针对付费Offer的购买意图，例如价格/交付询问、明确求购承诺或下单动作；不强制多卖家。
- D2：单个或重复弱行为（想要/收藏/浏览等）；重复页面或更多卖家不升级D3。
- D1：仅可核验供给／类目存在；U：当前记录不足或Scope无法归属。
- D-Level与Period分开：N04/N62/N63记录可定位弱信号D2，但行为期间UNKNOWN；不称为当前90天买方事实。有具名对象、原始想要/浏览和直接商品ID的8个旧观察也保留D2／UNKNOWN，不因未刷新降成U；其余同Scope不足时为U，历史／时期未知交易或旧声称单列，不能加入当前90天确认计数。
- 风险单列：未查用UNKNOWN；需要核对规则/版权/账号路径用REVIEW_REQUIRED；明确规避导向的工具形态用HIGH_RISK。没有行被默认写成NO_FLAG_OBSERVED。

## 3. Complete candidate table

N64的Demand Status=CONFIRMED_DEMAND（时期UNKNOWN），其余63行=WATCHLIST。平台=XIANYU；N01保留旧BUNDLE，N21为具名主题BUNDLE，其余原候选多为PRODUCT_TYPE（并非逐项变体SKU已验证），N62/N63是现场具名SKU/Offer，N64是单独教程PRODUCT_TYPE；Confidence以具名Scope可复核性判断；继承直接观察标LOW/未刷新。标准搜索词沿用商品名称即可。各行来源ID链接至[轻量底稿](RESEARCH_LEDGER_2026-10-03.md)。历史数字及价格不充当当前报价，详见底稿原始事实。N21按直接证据归回通用700+主题BUNDLE，N24只记录图片采集，N40不扩展到任意城市/企业版本；原候选措辞保留在母表。

| ID | 商品类型 / 搜索词 | Market surface | Scope | Current price | D-Level / Period | Confidence | Retained historical / period-unknown claim | Risk Status | Evidence IDs / key limitation |
|---|---|---|---|---|---|---|---|---|---|
| N01 | AI 漫剧制作教程 + 项目文件 / 工作流 | AI digital products | BUNDLE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | reported D4 / 教程 PRODUCT_TYPE；半年起止 UNKNOWN；原 Bundle 不继承 | REVIEW_REQUIRED | I-N01, H-02；教程成交期间UNKNOWN，不能归属当前90天；项目文件/Workflow未验证 |
| N02 | 可复用 AI Workflow / Agent 模板 | AI digital products | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | H1 templates/workflows 商品族交易占比；本候选 U | UNKNOWN | I-N02；统计含商品族与定制服务；不能归属可复用模板 SKU |
| N03 | 优酷SVIP周卡/设备会员 | Membership | PRODUCT_TYPE | UNKNOWN | D2 / UNKNOWN；继承直接观察，未刷新 | LOW（原始定位保留；本轮未刷新） | REUSED_INTEREST / 原始想要与浏览保留 | REVIEW_REQUIRED | I-N03, S03 / item1011466117609；987想要、4079浏览；具体设备/时长变体适用性未刷新；观察日不等于行为期间 |
| N04 | 迅雷 SVIP / 网盘会员月卡周卡直充 | Membership | PRODUCT_TYPE | 7.87–166.99元（产品类型混变体） | D2 / UNKNOWN；本轮页面可见累计弱信号 | MEDIUM（可定位；行为期间未知） | D2 CLAIM / 弱信号复现 | REVIEW_REQUIRED | I-N04, C-02；想要/浏览累计期间未知；卖家累计销量不能归属 SKU |
| N05 | 其他视频会员月卡/周卡 | Membership | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D1 CLAIM / 类目供给 | REVIEW_REQUIRED | I-N05；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N06 | 音乐 / 音频 / 阅读会员 | Membership | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D1 CLAIM / 类目供给 | REVIEW_REQUIRED | I-N06；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N07 | 咖啡 / 奶茶券或自助下单（如瑞幸） | Voucher | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N07；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N08 | 快餐 / 餐饮优惠券（麦当劳 / KFC / 达美乐等） | Voucher | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N08；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N09 | 电影票优惠 / 代购票 | Ticket | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N09；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N10 | 京东卡 / 代金卡 / 加油卡 | Stored-value cards | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D1 CLAIM / 类目供给 | REVIEW_REQUIRED | I-N10；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N11 | 景点 / 演出 / 网约车券 | Ticket/voucher | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D1 CLAIM / 类目供给 | REVIEW_REQUIRED | I-N11；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N12 | 游戏账号（以 CF 等为例） | Game virtual goods | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号复现 | REVIEW_REQUIRED | I-N12；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N13 | 游戏点券 / 充值 | Game virtual goods | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D1 CLAIM / 类目供给 | REVIEW_REQUIRED | I-N13；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N14 | 游戏皮肤 / 道具 / 装备 | Game virtual goods | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D1 CLAIM / 类目供给 | REVIEW_REQUIRED | I-N14；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N15 | 游戏租号 / 代练 / 首充号 / 自抽号 | Game virtual goods | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D1 CLAIM / 类目供给 | REVIEW_REQUIRED | I-N15；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N16 | Dragonfly 25.1 软件授权码 / 激活 | Software activation | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号 | REVIEW_REQUIRED | I-N16；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N17 | ArchiCAD 29 教育订阅 / 激活 | Software activation | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N17；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N18 | 课程 / 题库激活码 | Digital activation | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N18；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N19 | 多端多商户商城系统源码 | Source code | PRODUCT_TYPE | UNKNOWN | D2 / UNKNOWN；继承直接观察，未刷新 | LOW（原始定位保留；本轮未刷新） | REUSED_INTEREST / 原始想要与浏览保留 | REVIEW_REQUIRED | I-N19, S08 / item989122652146；36想要、808浏览；旧记录同时说明后来下架，当前供给状态未刷新；观察日不等于行为期间 |
| N20 | 小程序 / 网站后台系统源码 | Source code | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | UNKNOWN | I-N20；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N21 | WordPress 700+主题模板包（外贸/企业站用途未核验） | Website templates | BUNDLE | UNKNOWN | D2 / UNKNOWN；继承直接观察，未刷新 | LOW（原始定位保留；本轮未刷新） | REUSED_INTEREST / 原始想要与浏览保留 | REVIEW_REQUIRED | I-N21, S07 / item810121295766；804想要、约1万浏览；只支持通用700+主题包，不能证明外贸/企业用途适配；观察日不等于行为期间 |
| N22 | 中小企业报价管理Windows软件 | Utility software | PRODUCT_TYPE | UNKNOWN | D2 / UNKNOWN；继承直接观察，未刷新 | LOW（原始定位保留；本轮未刷新） | REUSED_INTEREST / 原始想要与浏览保留 | UNKNOWN | I-N22, S11 / item974663190233；133想要、5008浏览；单个软件观察不代表稳定市场；观察日不等于行为期间 |
| N23 | AI 标书制作 / 标书生成软件 | Utility software | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号复现 | UNKNOWN | I-N23, C-03（按次服务；软件本体未验证）；锚点为按次标书生成服务D2；不能证明可下载/自用软件 |
| N24 | 电商商品图片采集软件（整理功能未核验） | Utility software | PRODUCT_TYPE | UNKNOWN | D2 / UNKNOWN；继承直接观察，未刷新 | LOW（原始定位保留；本轮未刷新） | REUSED_INTEREST / 原始想要与浏览保留 | REVIEW_REQUIRED | I-N24, S13 / item920219589301；722想要、5163浏览；观察支持图片采集，附加整理能力/第三方资产权利未核验；观察日不等于行为期间 |
| N25 | 闲鱼关键词监控 / 上新提醒软件 | Utility software | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号 | REVIEW_REQUIRED | I-N25；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N26 | Python Excel / Word / PDF 办公自动化脚本包 | Utility/software pack | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | UNKNOWN | I-N26；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N27 | PDF 在线 / 批处理工具 | Utility software | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号 | UNKNOWN | I-N27；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N28 | AI 漫剧一键制作工具 | AI tool | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N28；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N29 | AIGC 提示词 + 示例图 + 参数包 | AI content asset | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N29；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N30 | 院校 / 专业考研复试资料包 | Education | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号复现 | REVIEW_REQUIRED | I-N30；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N31 | 本地化初中 / 中考学科试卷复习包 | Education | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号复现 | REVIEW_REQUIRED | I-N31；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N32 | 教师教案 + PPT + 作业设计资料包 | Education | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号复现 | REVIEW_REQUIRED | I-N32；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N33 | 英语课堂互动 PPT 游戏课件包 | Education | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号 | REVIEW_REQUIRED | I-N33；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N34 | 公考 / 事业编 / 时政 / 题库资料包 | Education | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N34；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N35 | 职业资格 / 职称考试题库资料包 | Education | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号 | REVIEW_REQUIRED | I-N35；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N36 | SAT / DSE / 留学考试资料包 | Education | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N36；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N37 | 大学课程笔记 / 期末复习资料 | Education | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N37；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N38 | 上市公司高管团队稳定性面板数据 | Research data | PRODUCT_TYPE | UNKNOWN | D2 / UNKNOWN；继承直接观察，未刷新 | LOW（原始定位保留；本轮未刷新） | REUSED_INTEREST / 原始想要与浏览保留 | REVIEW_REQUIRED | I-N38, S18 / item966484455784；523想要、3591浏览；该具名数据产品，不外推其他指标数据集；观察日不等于行为期间 |
| N39 | 上市公司供应链网络地位/PageRank数据 | Research data | PRODUCT_TYPE | UNKNOWN | D2 / UNKNOWN；继承直接观察，未刷新 | LOW（原始定位保留；本轮未刷新） | REUSED_INTEREST / 原始想要与浏览保留 | REVIEW_REQUIRED | I-N39, S19 / item1061281260797；194想要、1876浏览；仅该具名数据产品；观察日不等于行为期间 |
| N40 | DID/政策事件面板数据（具体城市/企业版本未核验） | Research data | PRODUCT_TYPE | UNKNOWN | D2 / UNKNOWN；继承直接观察，未刷新 | LOW（原始定位保留；本轮未刷新） | REUSED_INTEREST / 原始想要与浏览保留 | REVIEW_REQUIRED | I-N40, S20 / item1059572721917；24想要、260浏览；支持DID/政策面板产品，不证明任意城市/企业版本；观察日不等于行为期间 |
| N41 | SolidWorks 非标自动化设备 3D 图纸库 | Engineering assets | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号 | REVIEW_REQUIRED | I-N41；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N42 | 工业机器人 PROFINET / EtherCAT 配置手册包 | Engineering materials | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N42；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N43 | 芯片 / 半导体工艺制造资料合集 | Professional materials | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N43；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N44 | IE 工业工程经验 + 工具表资料包 | Professional materials | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号 | REVIEW_REQUIRED | I-N44；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N45 | 小提琴 / 大提琴制作图纸与技术文献 | Hobby/technical | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号 | REVIEW_REQUIRED | I-N45；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N46 | 日系胶片 Lightroom / PS 人像预设 | Photography assets | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号复现 | REVIEW_REQUIRED | I-N46, C-01（新增N63具名仿富士预设）；旧N46人像细分未确认；不继承推荐全类信号 |
| N47 | 像素蛋糕漫展 / COS 修图预设口令 | Photography assets | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号复现 | REVIEW_REQUIRED | I-N47；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N48 | 手机 Log 调色 LUT（vivo X200/X300 等） | Photography assets | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N48；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N49 | 索尼 FX3 / 电影感 LUT 包 | Photography assets | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号 | REVIEW_REQUIRED | I-N49；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N50 | 婚纱 / 人像 PSD 背景前景水印素材包 | Design assets | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号复现 | REVIEW_REQUIRED | I-N50；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N51 | 剪辑音效库 / SFX 素材包 | Audio assets | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N51；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N52 | AE / PR 剪辑模板包 | Video assets | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N52；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N53 | 乐谱 + 伴奏 / 示范音频资料包 | Music assets | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N53；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N54 | 蓝桥杯 / 技能竞赛经验与资料包 | Professional/education | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N54；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N55 | 货代 / 行业专业资料包 | Professional materials | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N55；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N56 | 日本关西自由行 PDF + 地图清单 | Lifestyle guide | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N56；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N57 | 家常菜 / 空气炸锅菜谱电子书 | Lifestyle guide | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N57；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N58 | 小吃 / 餐饮制作教程资料包 | Lifestyle guide | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N58；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N59 | 编织 / 手工教程资料库 | Hobby guide | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | U / 供给或推导 | REVIEW_REQUIRED | I-N59；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N60 | 摄影课程 / 后期教程资料包 | Creative education | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号复现 | REVIEW_REQUIRED | I-N60；无本轮逐项买方证据；旧推荐入口不等于本候选商品 ID |
| N61 | 短视频搬运 / 去重 / “过原创”工具 | Video/circumvention tools | PRODUCT_TYPE | UNKNOWN | U / CURRENT_EVIDENCE_UNKNOWN | LOW（当前Scope未核验） | D2 CLAIM / 弱信号复现 | HIGH_RISK | I-N61；新增来自聊天重跑声称；无逐项 ID；规避导向需隔离 |
| N62 | AI辅助标书按次方案生成服务（标探长AI-标书技术方案） | AI-assisted bid service | SKU（服务Offer） | 19.90元/次；旗舰版一本方案；工期1–5天 | D2 / UNKNOWN；本轮页面可见累计弱信号 | MEDIUM（可定位；行为期间未知） | NEW_CURRENT_OBSERVATION / 199想要、2207浏览 | UNKNOWN | C-03；按次服务；全店累计352非SKU销量；无独立明确付费意图/交易 |
| N63 | 李大本事仿富士胶片LR/PS预设（6个xmp） | Photography presets | SKU | 0.80元 | D2 / UNKNOWN；本轮页面可见累计弱信号 | MEDIUM（可定位；行为期间未知） | NEW_CURRENT_OBSERVATION / 18想要、276浏览 | REVIEW_REQUIRED | C-01；具体6个xmp预设；版权/授权未核验；卖家累计28712非SKU销量 |
| N64 | AI漫剧制作教程（不附加未证项目文件/Workflow） | AI tutorials | PRODUCT_TYPE | UNKNOWN | D4 / UNKNOWN；报道仅称半年 | MEDIUM（reported；起止未知、无逐单记录） | 平台交易案例reported；需求存在性，不代表规模/当前转化 | UNKNOWN | H-02；CONFIRMED_DEMAND仅时期未知；不能计入当前90天确认或下传N01组合 |

## 4. Coverage, prices and refresh

母集是历史X3R3的60候选，不是平台全集；N61来自v2.1输入；N62/N63来自本轮不同Offer发现；N64从未验证Bundle拆出已报道教程本体。没有重新扫描15个市场面，也没有对64个候选完成两条入口后的发现饱和检查。具名对象与原始数值可直接定位的8条旧观察可复用为INTEREST／D2／UNKNOWN，标继承未刷新；缺推荐商品自身ID或Scope错配的旧资料仅作待核验入口。刷新只处理可能改变结论的缺口，不要求每轮重做全部观察。

现场价格：C-01具名仿富士6个xmp预设0.80元；C-02迅雷会员7.87–166.99元；C-03按次AI标书服务19.90元。N62记录按次服务报价与1–5天工期，N63记录6个xmp预设报价；它们不能成为旧细分目录N46／软件目录N23的当前报价。其他价格均为旧记录，当前价格UNKNOWN。数值可随页面变化；必须保留商品ID、观察日、Scope和累计口径。

下一次研究优先补能改变结论的独立付费Offer意图或近期交易；同时保留小型新入口扫描，避免只刷新旧目录。合法低损失需求实验可解决未知，但本项目没有发布、交易或测试执行。风险核验和实验就绪属于另行授权的执行范围。

## 5. Historical preservation and current pointers

- [Research Ledger](RESEARCH_LEDGER_2026-10-03.md)：本轮观察、历史报道、61条导入原始声称和限制。
- [Old catalog, complete original bytes](history/FINAL_SKU_CATALOG_2026-10_PRE_V2_2.md)：旧body保留，标签已superseded。
- [v2.1 chat export, complete original bytes](history/XIANYU_MARKET_MAP_RERUN_V2_1_2026-10-03.md)：REVIEW INPUT / NOT CANONICAL。
- [60-candidate historical universe](X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md)：只作历史候选来源，旧D-Level不继承。

Archive SHA256 and input SHA256 are recorded in the ledger. Historical X1–X3R4 and prior execution entries remain historical records; README and REVIEWER_HANDOFF point to this calibrated result. This project-owned path is the canonical calibrated result; archived review inputs cannot override it.
