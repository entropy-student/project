# Curious World Studio｜P2-B 原文核实（子样本）与 P2-C 官方目录对账

**日期**：2026-10-10；**结论**：P2B_PRIMARY_TEXT_SUBSET_REVIEWED / OWNER_INDEPENDENT_GATE_PENDING / P2C_VISIBLE_DATE_CROSSWALK_DONE / ARCHIVE_EXHAUSTIVENESS_NOT_PROVEN。  
**正式题库状态**：`TOPICS_V1.json` 36 项完全不动；没有授予 STORYFIT_GO、商业视频授权或自动制作资格。

## 1. 核验边界和证据来源

- P1 基线：PR #74 已合 main，`bf16fd985c4281da34ff75f1a299b284da39279a`；主分支 [Actions #38022638179](https://github.com/entropy-student/project/actions/runs/38022638179) 24/24 测试通过、真实采集成功，artifact #11657994563。
- P1 [artifact #11658083807](https://github.com/entropy-student/project/actions/runs/38022100048) 的 `audit.json`：HF 215、MIT 3、NASA EO 3、Nature NHB 2、PLOS 303、JEB/Crossref 11；合计 537 条元数据。PLOS 二次筛选 143 TOPIC + 130 OPEN + 30 其他类型。这是数据层范围，非频道内容保证。
- P2-A 40 篇固定 DOI 样本详见 [40-item review](2026-10-10_P2_PLOS_40_ABSTRACT_REVIEW.md)；本轮从标为故事线索 2 的 6 篇抽出 **5 篇能回到 PLOS 官方原文、查看方法/结果/局限的主核验子集**，第 6 篇 `10.1371/journal.pone.0343857` 的官方全文本轮未稳定定位，**不算完成全文审阅**。
- 本轮属于**同一助手更深入查证**，不冒充第二位独立盲审者。用户 Owner 需作第二视角判断；不能说 P2-B 的双审门槛已经 PASS。
- 原论文 OA 或 CC BY 不等于每一张嵌入图片、音频、补充视频都可以无条件商用；素材复用权仍逐件检查。

## 2. 五篇原始研究：事件—过程—结论复核

### A. 巨噬细胞如何处理“细菌黏在死亡细胞上”？

- DOI：https://doi.org/10.1371/journal.pone.0356679；原文：https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0356679；原队列 **OPEN_DISCOVERY**。
- 原始实验：研究者让吞噬细胞分别处理仅凋亡细胞、细菌及细菌黏附凋亡细胞的复合对象，用定量共聚焦与活细胞显微技术观察吞入过程；含补充 S1–S9 Video，S8/S9 为膜和肌动蛋白重塑。
- 真实推进：单目标整块吞噬 → 遇到带细菌的复合目标时伸出突起 → 逐个提取细菌，凋亡材料碎片化摄取 → 早期吞噬体的内容多半分别装载而非混杂；另有三次独立实验的定量对照。
- **不可夸大**：“细胞拥有意图/判断力”“知道哪个是敌人”只是拟人类比，论文只能说明差异性摄取与货物分选；是体外细胞实验，不能泛化为人全身免疫反应。
- 编辑暂判：**OWNER_REVIEW_PRIORITY**。优势是自带动作序列 + 可观察原研究视频；限制是微观尺度、讲解门槛、原视频商用/第三方素材许可尚未逐片核。

### B. 平均频率一样的两段“嗒嗒声”，听起来会不同吗？

- DOI：https://doi.org/10.1371/journal.pbio.3004046；原文：https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.3004046；原队列 **TOPIC_REVIEW**。
- 原始实验：10 套每组 51 个短脉冲、平均脉冲间隔 4 毫秒的点击声；对比恒定、逐渐增加/减少、随机扰动等不同毫秒级排列；人类听辨 + EEG 与大鼠 ECoG + 中脑—丘脑—听皮层多级神经记录 + 皮层可逆性干预。
- 真实推进：先问“平均速度相同能否区分” → 人类行为有区分 → 脑电响应因情境而变 → 老鼠神经网络也有类似敏感性 → 层级记录和反馈干预定位参与结构。
- **不可夸大**：同平均 ICI 不代表所有听觉参数完全相同；不同排列可能改变声学包络/可感音高。不能将“老鼠与人有完全一样的主观听感”当实证。原文当前标为 **uncorrected proof**，须核其最终版本。
- 编辑暂判：**OWNER_REVIEW_PRIORITY**。适合开场互动/声学演示；需先验证演示声音实际可听、耳机/手机外放差异和素材原创制作，不直接复制外部演示。

### C. 棒球防守站位会泄露投手下一球吗？

- DOI：https://doi.org/10.1371/journal.pone.0341045；原文：https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0341045；原队列 TOPIC_REVIEW。
- 原始研究：用打者—投手匹配、球种引发的落点分布和博弈模型，比较固定按打者站位、按照球种站位、混入虚晃的完整防守策略；包含 Nick Anderson / Mookie Betts 的示例。
- 真实推进：根据球种摆防守更准确 → 打者可能从站位猜球 → 让投手偶尔反向虚晃 → 模型减少暴露，但**作者的实际总结是复杂策略相对更简单的打者特定站位获益不显著，实施成本高**。
- **不可夸大**：是预测模型/数值例子，未证明 MLB 团队按此执行即可多赢比赛；不能只讲“找到超强防守秘籍”而省略负面结论。
- 编辑暂判：**CONDITIONAL_OWNER_REVIEW**：反直觉尾声不错，但跨文化棒球知识门槛高，可做一则模型反证而非大话题。

### D. 束带勒多紧，对腿部动脉血流有什么变化？

- DOI：https://doi.org/10.1371/journal.pone.0359341；原文：https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0359341；原队列 **OPEN_DISCOVERY**。
- 方法：42 名 18–37 岁健康活跃成年人，单次以弹性束带设置无压/轻/中/高主观压力；用多普勒超声测腘动脉血流，**静息状态**重复条件比较；未观察完全动脉阻断。
- 结果：平均流量由无压力下 58.55 mL/min，降到轻 44.98 / 中 32.79 / 高 17.21 mL/min，显示递减趋势。
- **不可夸大**：只证明本实验条件下急性静息血流下降，**不证明训练有效、不提供安全穿戴压力，也不是可在家跟做的实验**；不要指导观众尝试限制血流。
- 编辑暂判：**HOLD（人体安全风险/三段故事推进不足）**。对开放池保留价值，但暂不选为正式视频。

### E. 边做脑力题，边在不确定奖励之间下注，人会怎么选？

- DOI：https://doi.org/10.1371/journal.pone.0360059；原文：https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0360059；原队列 TOPIC_REVIEW。
- 方法：60 名健康成年受试者，2×2 设计比较是否插入问答认知负荷、阳极经颅直流刺激 tDCS 与假刺激；共做 50 轮安全奖励、概率大奖、付费看概率三种选择。
- 结果：加问答的组在反应时间上更慢、风险选项比率更低；刺激的效应在风险选择、付费信息寻求、切换率各指标并不相同，后两者有交互作用；较难题目影响反应速度但并未一致改变选择分布。
- **不可夸大**：不能称为“电一下脑子就会变勇敢”、临床治疗效果或揭示具体神经机制；仅 60 人、单次测试，受试者/实验人员盲法有局限。
- 编辑暂判：**CONDITIONAL / LOW PRIORITY**。选择博弈可自己画示意（不应复现神经刺激）；但是结果复杂、误导风险较大。

### F. 人与 AI 编码研究摘要比较（核验未完成）

- DOI：https://doi.org/10.1371/journal.pone.0343857；原队列 TOPIC_REVIEW，P2-A 故事线索 2。
- 本轮搜索未可靠提取官方文章全文和结果数据，**不得据先前摘要注释推断其胜负、评分偏差或真实故事结尾**。保持 `PRIMARY_FULLTEXT_NOT_VERIFIED`，不加入 Owner 高优先级展示或正式题库。

## 3. P2-C：官方可见日期窗与 RSS/代理记录的精确对账

**同窗 2026-10-07～09；数据来自 P1 artifact 的真实 `source.items[].date/title/url/id`，对照 2026-10-10 能访问的官方目录/单页。**

| 来源 | P1 中记录 | 本次官网看见的相应条目 | 证据与严格界限 |
|---|---:|---|---|
| MIT Research | **3**（10/07 两项，10/08 一项） | 官方 [Research topic](https://news.mit.edu/topic/research?page=0&type=1) 第 1 页在这三日的 Research 条目为 **3**，标题对上 **3/3** | 本次窗口处于第一页，页面下一条为 10/06；这是**第一页可见目录局部对账**，不保证未来 RSS 不遗漏/全站其他主题 |
| NASA EO Image of Day | **3**（三日各 1） | NASA 官方 10/07 Arctic Sea Ice、10/08 Texas Cotton、10/09 Thailand Flood 页面 **3/3 标题与日期对应** | 官方 [Earth Observatory 日图](https://science.nasa.gov/earth/earth-observatory/image-of-the-day/)；网站某些 date archive 是 NASA Science **全站混合内容**，不能直接当 EO 分母；RSS 原始 XML 兼容修复仍须标 PARTIAL |
| Nature Human Behaviour | **2**（10/08 两项） | 官方 [Microdelays](https://www.nature.com/articles/s41562-026-02598-y)、[Twin cohort screen use](https://www.nature.com/articles/s41562-026-02607-0) 原文均标记 10/08，已对上 **2/2** | 单项原文日期复核，不是 `nathumbehav` 期刊目录所有类型/整个 Nature Portfolio 的三日完整性 |
| JEB Crossref | **11**（10/07:1，10/08:2，10/09:8） | [Accepted manuscripts](https://journals.biologists.com/jeb/accepted-manuscripts) 当前可见 10/08 **2** 条、10/09 **5** 条的 DOI/文章号，都存在 Crossref 11 条中：**7/7 当前可见样本匹配** | Crossref 另有 4 条不在当前接受稿列表；不能据此认为是错误或漏源，因为 online-pub-date、accepted-manuscript date、Inside JEB 讲解稿、正式卷期发表不同。**绝非 11/7 的召回率。** |

官网“可见子集”对上不意味着全量通过。此处没有机器端 HTML 自动翻页穷尽、跨页停止条件与每条 DOI 级历史快照；EurekAlert 的合法自动入口仍未核，OpenAlex/PubMed 仍只做 DOI 核验。

**新增实际发现**：JEB 的 Accepted Manuscripts 属于更贴近动物行为的一手来源；在 P1 Crossref 11 条中有 10/08 蛇眼表面透光/自清洁、音乐蛙声信号，10/09 月亮水母幼体饥饿应对、洞穴鱼小胶质细胞等，可**另开后续原文核验清单**。本轮没有擅自创建新正式选题 ID。

## 4. Owner 的质量把关是必经独立门槛

- 已拟出单页 [Owner Review Card](2026-10-10_P2_OWNER_TOPIC_QUALITY_GATE.md)。只需按实际点击意愿和是否愿意追看分别判定；**不要求 Owner 直接验证论文技术细节**。
- 推荐优先给 Owner 看 A 巨噬细胞、B 毫秒级点击声；C 棒球与 E 风险决策为对照组；D 束带作为研究细节安全边界的负面标杆。
- 用户点选的 **WANT_TO_WATCH**、**PASS**、**UNCERTAIN** 只是点击与叙事兴趣验证；仍需独立第二审、STORY-FIT、视频素材逐片商用许可和 B 站竞品检查才能进入制作。
- 下一步：Owner 判定 + 第二位真正独立的 Reviewer 复审这批候选的事实/故事推进 + 针对原研究完整方法/结果/附件做专项合规检查；另对 JEB 官方 Accepted Manuscripts 与 Crossref 做跨日期窗口 DOI 增量对账。

**本阶段不修改** `TOPICS_V1.json`、`BOARD_V1.md`、`HF_有趣发现_唯一主协议.md`、`SOURCE_SYSTEM_FINAL_V1.md` 或 Mac v1.2。
