# Xianyu MARKET_MAP Re-run — Skill v2.1.0

Date: 2026-10-03  
Status: REVIEW INPUT / NOT CANONICAL  
Skill: `xianyu-xiaohongshu-virtual-product-demand-research` v2.1.0  
Mode: `MARKET_MAP`  
Platform: Xianyu  
Scope: virtual / digital products and adjacent standardized offers

> Important: This file records the latest re-run result produced in chat after the Skill was revised to v2.1.0.  
> It has **not** yet been written back to the `entropy-student/project` canonical Xianyu project files.  
> It is provided as Reviewer input, not as an already-approved final catalog.

---

## 1. Re-run purpose

The old Xianyu catalog was produced under the pre-v2.1 evidence model and reported:

- `CONFIRMED_DEMAND = 6`
- `PROBABLE_DEMAND = 44`
- `CORE CATALOG = 50`

After the independent Reviewer identified evidence-boundary problems, Skill v2.1.0 changed the rules materially:

- supply repetition no longer upgrades demand by itself;
- D3 requires replicated independent buyer-side evidence;
- D4 requires attributable transaction / payment evidence at the same Evidence Scope;
- family-level evidence cannot be inherited downward to a narrower SKU / Bundle;
- Demand Status and Risk Status are separate dimensions;
- a single high-"want" listing is D2 at most unless independent buyer evidence replicates.

This re-run therefore **does not inherit the old 6 + 44 labels**.

---

## 2. v2.1 interpretation used

### Demand Level

- **D4** = attributable transaction / payment evidence at the same Evidence Scope, or first-party platform transaction data directly supporting that Scope.
- **D3** = multiple independent buyer-side intent signals replicated at the same Scope.
- **D2** = one attributable buyer-side intent / attention signal.
- **D1** = supply / category / listing existence only, without buyer-side evidence.
- **U** = insufficient or unassignable evidence.

### Demand Status

- `CONFIRMED_DEMAND` = D4 only
- `PROBABLE_DEMAND` = D3
- `WATCHLIST` = D2 / D1 / U

### Risk Status

Recorded independently from demand:

- `NO_FLAG_OBSERVED`
- `REVIEW_REQUIRED`
- `HIGH_RISK`
- `UNKNOWN`

---

## 3. Latest re-run counts

The old 60 normalized candidates were used as the primary working universe and reinterpreted under v2.1. One additional clearly visible high-risk market candidate was retained during the re-run.

### Current re-run summary

- **CONFIRMED_DEMAND = 1**
- **PROBABLE_DEMAND = 11**
- **WATCHLIST = 49**
- **TOTAL = 61**

The major change is therefore:

```text
Old pre-v2.1:
6 Confirmed + 44 Probable

Latest v2.1 chat re-run:
1 Confirmed + 11 Probable + 49 Watchlist
```

---

## 4. CONFIRMED_DEMAND

### 4.1 AI 漫剧制作教程

- Scope: `PRODUCT_TYPE`
- D-Level: `D4`
- Demand Status: `CONFIRMED_DEMAND`
- Risk Status: `UNKNOWN`

Evidence interpretation used in the re-run:

A first-party / media-reported Xianyu market data point supports transaction activity for AI tutorial/course products, and a reported seller sold approximately 17,000 copies of an AI manga/drama tutorial in six months.

Important v2.1 scope correction:

This supports:

```text
AI 漫剧制作教程
```

It does **not** automatically support the narrower / richer Bundle:

```text
AI 漫剧制作教程 + 项目文件 + Workflow
```

The additional project-files / workflow components require their own direct evidence.

---

## 5. PROBABLE_DEMAND

The following were retained as D3 because the re-run found multiple independent buyer-side signals at a reasonably matched product-type Scope.

| Product type | D-Level | Demand Status | Main reason | Risk Status |
|---|---:|---|---|---|
| 迅雷 SVIP / 月卡周卡直充 | D3 | PROBABLE_DEMAND | Multiple independent listings with separate visible buyer-intent signals | REVIEW_REQUIRED |
| AI 标书生成工具 / 软件 | D3 | PROBABLE_DEMAND | Multiple independent tool listings with separate buyer-intent signals | NO_FLAG_OBSERVED |
| 院校 / 专业考研复试资料包 | D3 | PROBABLE_DEMAND | Multiple school/major-specific listings with independent buyer intent | REVIEW_REQUIRED |
| 本地化初中 / 中考试卷复习资料包 | D3 | PROBABLE_DEMAND | Multiple local/subject-specific listings with independent buyer intent | REVIEW_REQUIRED |
| 教师备课资料包：教案 / 课件 / 逐字稿等 | D3 | PROBABLE_DEMAND | Multiple teaching-material offers with buyer-side signals | REVIEW_REQUIRED |
| 日系 / 胶片人像调色预设 | D3 | PROBABLE_DEMAND | Multiple independent preset listings with buyer-side intent | REVIEW_REQUIRED |
| 像素蛋糕漫展 / COS 修图预设口令 | D3 | PROBABLE_DEMAND | Multiple independent preset products with separate buyer intent | REVIEW_REQUIRED |
| 婚纱 / 人像 PSD 背景素材包 | D3 | PROBABLE_DEMAND | Independent asset listings with separate buyer intent | REVIEW_REQUIRED |
| 摄影课程 / 后期教程资料包 | D3 | PROBABLE_DEMAND | Multiple independent photography-course listings with buyer intent | REVIEW_REQUIRED |
| 游戏账号（CF 等） | D3 | PROBABLE_DEMAND | Many independent account listings with separate buyer-intent signals | REVIEW_REQUIRED |
| 短视频搬运 / 去重 / “过原创”工具 | D3 | PROBABLE_DEMAND | Multiple independent listings with strong visible buyer intent | HIGH_RISK |

### Important interpretation

These are **not automatically recommended products**.

For example:

```text
Demand Status = PROBABLE_DEMAND
Risk Status = HIGH_RISK
```

can both be true at the same time.

That is especially relevant to circumvention-oriented tools and account-transfer markets.

---

## 6. WATCHLIST

The remaining 49 candidates were kept as Watchlist because the evidence did not satisfy v2.1 D3/D4 thresholds.

### 6.1 Typical D2 examples

These have a visible buyer-side signal, but only one sufficiently attributable independent evidence source was retained.

Examples:

- 优酷 SVIP 周卡 / 设备会员
- WordPress 外贸 / 企业站主题模板包
- 中小企业报价管理 Windows 软件
- 电商商品图片采集 / 整理效率软件
- 闲鱼关键词监控 / 上新提醒软件
- PDF 在线 / 批处理工具
- 英语课堂互动 PPT 游戏课件包
- 职业资格 / 职称考试资料包
- 上市公司高管团队稳定性面板数据
- 上市公司供应链网络地位 / PageRank 数据
- DID / 政策事件 / 企业面板数据
- SolidWorks 非标自动化设备 3D 图纸库
- IE 工业工程经验 + 工具表资料包
- 小提琴 / 大提琴制作图纸与技术文献
- 索尼 FX3 / 电影感 LUT 包
- 乐谱 + 伴奏 / 示范音频资料包
- 短剧扒剧 / 竞品复盘模板

Under v2.1, even a single listing with hundreds of visible "想要" does not become D3 unless independent buyer-side replication is shown.

For example:

```text
one listing
804 wants
no second independent buyer signal

=> D2
=> WATCHLIST
```

### 6.2 Typical D1 / U examples

These currently have mainly category, supply, listing-existence, adjacent, or insufficiently attributable evidence.

Examples:

- 其他视频会员月卡 / 周卡
- 音乐 / 音频 / 阅读会员
- 咖啡 / 奶茶券
- 快餐 / 餐饮优惠券
- 电影票优惠 / 代购票
- 京东卡 / 通用代金卡 / 加油卡
- 景点 / 演出 / 网约车券
- 游戏点券 / 充值
- 游戏皮肤 / 道具 / 装备
- 游戏租号 / 代练 / 首充号 / 自抽号
- Dragonfly / ArchiCAD 等软件授权或激活
- 课程 / 题库激活码
- 多端多商户商城系统源码
- 小程序 / 网站后台系统源码
- Python Excel / Word / PDF 自动化脚本包
- AI 漫剧一键制作工具
- AIGC 提示词 + 示例图 + 参数包
- 公考 / 事业编 / 时政题库资料
- SAT / DSE / 留学考试资料
- 大学课程笔记 / 期末复习资料
- 工业机器人配置手册
- 芯片 / 半导体工艺资料
- 手机 Log LUT
- 剪辑音效库 / SFX 素材包
- AE / PR 剪辑模板包
- 蓝桥杯 / 技能竞赛资料
- 货代 / 行业专业资料包
- 日本关西自由行 PDF + 地图清单
- 家常菜 / 空气炸锅菜谱电子书
- 小吃 / 餐饮制作教程资料包
- 编织 / 手工教程资料库

These may have real demand. The v2.1 result simply says the retained evidence is not yet enough to call them `PROBABLE_DEMAND`.

---

## 7. Main differences from the old catalog

### Difference A — supply is no longer treated as demand

Old logic could effectively promote:

```text
many independent sellers
=> D3
```

v2.1 requires:

```text
many independent sellers
+ independent buyer-side evidence
=> possible D3
```

Without buyer-side evidence, repeated supply remains D1.

### Difference B — single high-intent listings are downgraded

Examples such as:

- 987 wants
- 804 wants
- 722 wants
- 523 wants

may be commercially interesting, but one listing alone is still D2.

### Difference C — Scope is enforced

Evidence for a product family does not automatically confirm:

- a narrower SKU;
- a richer Bundle;
- attached templates / files / workflow components.

### Difference D — risk no longer replaces demand

High-risk products can still have strong market demand.

Demand and executability are separate questions.

---

## 8. Strongest current market conclusions from this re-run

Under the stricter v2.1 interpretation, the clearest retained areas are:

1. **AI 漫剧教程** — strongest transaction-level evidence.
2. **迅雷类会员产品** — replicated buyer intent across multiple independent listings.
3. **AI 标书生成工具** — replicated buyer intent across multiple independent tools.
4. **考研复试 / 本地化中学资料** — replicated educational buyer intent.
5. **教师备课资料** — replicated educational buyer intent.
6. **摄影预设 / COS 修图预设 / PSD 素材 / 摄影课程** — one of the clearest digital-asset clusters with repeated buyer-side signals.
7. **游戏账号** — strong demand signal, but separate risk review required.
8. **搬运 / 去重 / 过原创工具** — strong buyer demand signal, but `HIGH_RISK`.

---

## 9. Reviewer notes

This re-run should be treated as a **review input**, not as a canonical final answer.

Recommended Reviewer checks:

- independently verify whether every D3 row truly has multiple independent buyer-side signals at the same Evidence Scope;
- verify whether any rows should be split or merged because the current product type remains too broad;
- verify whether Risk Status is appropriately assigned;
- verify whether some Watchlist rows deserve promotion after fresh buyer-side evidence;
- verify whether the 61-candidate universe remains appropriate or whether additional current market surfaces should be added;
- decide whether this re-run should replace the old project catalog, and if so, write the final approved result to the project repository canonical path.

---

## 10. Current status

```text
SKILL_VERSION = 2.1.0
RESULT_LOCATION = CHAT_EXPORT
CANONICAL_PROJECT_WRITEBACK = NO
REVIEW_STATUS = PENDING_FINAL_REVIEWER
OLD_6_PLUS_44_LABELS = SUPERSEDED_AS_CALIBRATION_TRUTH
```

The final canonical result should be created or updated by the final Reviewer after independent verification.
