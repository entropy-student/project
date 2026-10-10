# Curious World Studio｜正式选题库 BOARD V1

**更新日期：2026-10-10** · **总数 36**；最近一批：2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN

母数据：[TOPICS_V1.json](TOPICS_V1.json) · 工作流：[WORKFLOW_V1.md](WORKFLOW_V1.md) · 批次日志：[2026-10-07–09 部分扫描](batches/2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN.md)

> **范围声明**：历史回填 21 条 + 2026-10-07 至 09 日窗口内定向复查得到 15 条候选。**已打开三天 HF 日榜、MIT 日期列表、JEB 预录用列表、NASA 每日影像页及 Nature/PLOS 搜索样本，但没有实现九源全量抓取，也没完成三天自动 RSS/API 稳定性测试。** EurekAlert 的文章正文 403，OpenAlex API 无法直接查询，Nature 个别正文登录阻断。**21+15 不等于同一时间窗口的论文总量，更不能计算选题产出率。**

| 审核状态 | 条目数 | 说明 |
|---|---:|---|
| SHORTLIST | 11 | 已识别原研究与可定位事实，允许进入后续 STORY-FIT 深审（不是五分钟已过） |
| VERIFY | 15 | 值得关注，但关键事实、原研究、例子或承诺仍待复核 |
| HOLD | 9 | 事实可追溯，但此角度缺少足够推进、画面或必要性 |
| REJECTED | 1 | 标题与回答之间有明确不匹配或存在难修复缺陷 |

## 2026-10-07～09 新入库题（按类型分组）

### SHORTLIST

| ID | 选题 | 实际日期（发现/论文） | 一手证据状态 | 核心风险 |
|---|---|---|---|---|
| CW-0022 | [夜鹰飞得慢才能捕虫，为什么却要迁徙几千公里？](https://www.lunduniversity.lu.se/article/nightjar-wings-reveal-trade-between-hunting-slowly-and-travelling-far) | 2026-10-09 / 2026-09-30 | PAPER_ABSTRACT_AND_UNIVERSITY_RELEASE_CHECKED | 风洞测到的翼流机制不能直接推算它日常迁徙的全部能量成本；原论文发表于9月30日，10月9日才由机构发布新闻 |
| CW-0023 | [城市里还很多鱼，为什么研究者却说它们很有压力？](https://www.oist.jp/news-center/news/2026/10/9/fish-may-look-fine-urban-waters-their-genes-tell-different-story) | 2026-10-09 / 2026-10-09 | INSTITUTION_RELEASE_WITH_ORIGINAL_DOI_VERIFIED | 基因指标不是鱼主观情绪；研究对象/海域有边界；原 Nature 全文访问有障碍，已核 DOI 和团队数据解说 |

### VERIFY

| ID | 选题 | 实际日期（发现/论文） | 一手证据状态 | 核心风险 |
|---|---|---|---|---|
| CW-0026 | [如果把消失的老香港放进VR，老人会有什么反应？](https://www.nature.com/articles/s44284-026-00523-y) | 2026-10-09 / 2026-10-09 | PUBLISHER_TOPIC_AND_ABSTRACT_ONLY | Nature 原文发生登录跳转，只找到主题说明/摘要；效应大小与对照组未验；不得扩展为 VR 能治疗老年抑郁症 |
| CW-0027 | [AI玩一个从没见过规则的游戏，为什么记流水账可能比总结经验更管用？](https://huggingface.co/papers/2610.08215) | 2026-10-09 / 2026-10-08 | HF_ABSTRACT_CHECKED | 实验仅在基准游戏与受测代理上；必须查官方项目真实游戏案例是否可让观众代入 |
| CW-0028 | [一个3D世界原本完全静止，AI怎么让它从每个角度不断循环运动？](https://huggingface.co/papers/2610.12461) | 2026-10-09 / 2026-10-08 | HF_ABSTRACT_CHECKED | 论文里39个样本不等于任意3D世界完全正确；画面与商用授权需逐片验证 |
| CW-0029 | [机器人叠杯子之前，为什么要记得前十几秒？](https://huggingface.co/papers/2610.10528) | 2026-10-08 / 2026-10-07 | HF_ABSTRACT_CHECKED | 类似EyeRobot：标题强，潜在答案也可能是直观常识；不同系统对照不可只看单一成功率 |
| CW-0030 | [从卫星看棉田变成棕色，农民为什么说这次不一样？](https://science.nasa.gov/earth/earth-observatory/fighting-drought-in-texas-cotton-country/) | 2026-10-08 / 2026-10-08 | NASA_ORIGINAL_ARTICLE_CHECKED | NASA报告及访谈≠新的因果科研实验；需找独立水文/农业研究与数据避免单独解读一张卫星图 |
| CW-0034 | [科学家删掉牛胚胎被认为必需的一种信号，小牛为什么还能出生？](https://www.eurekalert.org/news-releases/1147041) | 2026-10-08 / 2026-10-08 | INSTITUTION_RELEASE_AND_PUBLISHER_LISTING | 研究限定特定牛实验；不意味着信号在所有条件都无作用；原文章DOI和全文需精确核 |
| CW-0035 | [为什么很古老的软体动物能变成化石，后来的反而更难留下？](https://www.eurekalert.org/news-releases/1146471) | 2026-10-08 / 2026-10-08 | PRESS_RELEASE_SEARCH_EXCERPT_ONLY | 新闻稿解释还需核论文原文，不能把微生物说成所有化石缺口的唯一原因 |
| CW-0036 | [为什么群居黄蜂的工蜂无法繁殖，是谁让它们的卵巢停下？](https://journals.biologists.com/jeb/accepted-manuscripts) | 2026-10-09 / 2026-10-09 | JEB_DATED_TITLE_ONLY | 尚未读取完整正文实验；不可写成黄蜂社会故意让工蜂失去繁殖能力 |

### HOLD

| ID | 选题 | 实际日期（发现/论文） | 一手证据状态 | 核心风险 |
|---|---|---|---|---|
| CW-0024 | [蛇不会眨眼，透明眼罩真的能自己把脏东西冲走吗？](https://doi.org/10.1242/jeb.252668) | 2026-10-08 / 2026-10-08 | ORIGINAL_ABSTRACT_CHECKED | 论文是消极结果；不能改成“已经证明蛇眼罩自动清洁”，目前单篇不足五分钟 |
| CW-0025 | [青蛙听见陌生物种的叫声，脑内网络为何变化更明显？](https://doi.org/10.1242/jeb.253376) | 2026-10-08 / 2026-10-08 | ORIGINAL_ABSTRACT_CHECKED | 只研究脑网络指标不能说青蛙听懂别人讲话或受到惊吓；观众能看的行为过程不足 |
| CW-0031 | [泰国洪水怎么在一张卫星照片里扩散成大片水面？](https://science.nasa.gov/earth/earth-observatory/floodwaters-overwhelm-thailand/) | 2026-10-09 / 2026-10-09 | NASA_ORIGINAL_ARTICLE_CHECKED | 真实事件不是5分钟科学解谜；不要拿灾害夸张化做悬念 |
| CW-0032 | [北极海冰又到了年度最低点，数据里究竟能看出什么？](https://science.nasa.gov/earth/earth-observatory/arctic-sea-ice-shrinks-to-its-2026-minimum/) | 2026-10-07 / 2026-10-07 | NASA_ORIGINAL_ARTICLE_CHECKED | 2026最小值约并列第十低，不能说当年破纪录；画面强但故事推进不足 |
| CW-0033 | [大学生拖延那么普遍，真正让他们痛苦的是什么？](https://doi.org/10.1371/journal.pone.0357714) | 2026-10-07 / 2026-10-07 | PLOS_ORIGINAL_ABSTRACT_CHECKED | 横断面自述无法解释拖延为何发生；单篇没有明显实验过程；作者与商业出版有利益声明 |

## 全量选题库（含历史）

四轴 = **点击 / 答案增量 / 故事推进 / 画面**；HIGH、MED、LOW、UNKNOWN 仅是编辑主观假设，不是用户或平台实测。

### SHORTLIST（11）

| ID | 标题 / 原文 | 发现来源 | 四轴 | 批次 |
|---|---|---|---|---|
| CW-0001 | [如果果冻会说话，你还舍得吃吗？](https://doi.org/10.1371/journal.pone.0350612) ★ Owner 点选 | PLOS ONE | HIGH/HIGH/HIGH/HIGH | PRIOR_REPORT |
| CW-0002 | [大象想赶走同伴，会先确认对方注意了吗？](https://doi.org/10.1007/s10071-026-02108-7) ★ Owner 点选 | EurekAlert!/Animal Cognition | HIGH/HIGH/HIGH/MED | PRIOR_REPORT |
| CW-0003 | [学习网页只卡两秒，真的会影响学习吗？](https://doi.org/10.1038/s41562-026-02598-y) ★ Owner 点选 | Nature Human Behaviour | HIGH/HIGH/MED/MED | PRIOR_REPORT |
| CW-0005 | [爆米花为什么既会跳又会响？](https://pmc.ncbi.nlm.nih.gov/articles/PMC4345489/) | Journal Royal Society Interface | HIGH/HIGH/HIGH/HIGH | PRIOR_REPORT |
| CW-0006 | [为什么蚊子偏爱某些人？](https://www.sciencedirect.com/science/article/pii/S0092867422012533) | Rockefeller/Cell | HIGH/HIGH/HIGH/MED | PRIOR_REPORT |
| CW-0008 | [手指泡水后起皱，抓湿物体会更牢吗？](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0253185) | PubMed/PLOS | HIGH/HIGH/HIGH/MED | PRIOR_REPORT |
| CW-0015 | [AI玩捉迷藏，为什么会搬斜坡翻墙？](https://mirros-lab.github.io/agent-garten/) | HF/AgentGarten | HIGH/HIGH/HIGH/HIGH | PRIOR_REPORT |
| CW-0016 | [AI复刻沙子为什么堆得像面团？](https://4dcodebench.com/) | HF/4DCodeBench | HIGH/HIGH/HIGH/HIGH | PRIOR_REPORT |
| CW-0021 | [主人与狗同睡，到底谁先影响谁？](https://doi.org/10.1371/journal.pone.0358453) | PLOS ONE | HIGH/HIGH/MED/MED | NEW_SPOT_CHECK |
| CW-0022 | [夜鹰飞得慢才能捕虫，为什么却要迁徙几千公里？](https://doi.org/10.1371/journal.pbio.3004023) | EurekAlert → Lund → PLOS Biology | HIGH/HIGH/HIGH/HIGH | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |
| CW-0023 | [城市里还很多鱼，为什么研究者却说它们很有压力？](https://doi.org/10.1038/s41467-026-77751-2) | EurekAlert → OIST → Nature Communications | HIGH/HIGH/HIGH/MED | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |

### VERIFY（15）

| ID | 标题 / 原文 | 发现来源 | 四轴 | 批次 |
|---|---|---|---|---|
| CW-0004 | [为什么一根意大利面总断成不止两截？](https://news.mit.edu/2018/mit-mathematicians-solve-age-old-spaghetti-mystery-0813) | MIT News | HIGH/HIGH/HIGH/HIGH | PRIOR_REPORT |
| CW-0007 | [为什么没出事故的路也能突然堵车？](https://ir.library.osaka-u.ac.jp/repo/ouka/all/93262/) | New Journal of Physics | HIGH/HIGH/HIGH/HIGH | PRIOR_REPORT |
| CW-0012 | [雨后泥土香从哪里来？雨滴里为什么冒气泡？](https://www.nature.com/articles/ncomms7083) | MIT/Nature Communications | HIGH/HIGH/MED/HIGH | PRIOR_REPORT |
| CW-0013 | [同样的25度为什么有的房间更冷？](https://www.sciencedirect.com/science/article/abs/pii/S0360132306002253) | 热舒适学术摘要 | HIGH/UNKNOWN/LOW/LOW | PRIOR_REPORT |
| CW-0014 | [露营爱好者怎么在地图上找到古老撞击坑？](https://earthobservatory.nasa.gov/) | NASA Earth Observatory | HIGH/HIGH/HIGH/HIGH | PRIOR_REPORT |
| CW-0019 | [软片折弯时为何知道自己变成了什么形状？](https://news.mit.edu/2026/shape-sensing-sheet-digitally-tracks-movement-bends-twists-1008) | MIT News | MED/MED/MED/HIGH | NEW_SPOT_CHECK |
| CW-0020 | [活肌肉机器人为什么能跟着光转弯？](https://news.mit.edu/2026/powered-by-muscle-cells-paper-thin-robot-swims-through-watery-maze-0929) | MIT News | HIGH/HIGH/HIGH/HIGH | NEW_SPOT_CHECK |
| CW-0026 | [如果把消失的老香港放进VR，老人会有什么反应？](https://doi.org/10.1038/s44284-026-00523-y) | Nature Cities human behaviour topic | HIGH/HIGH/MED/HIGH | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |
| CW-0027 | [AI玩一个从没见过规则的游戏，为什么记流水账可能比总结经验更管用？](https://arxiv.org/abs/2610.08215) | HF Daily Papers 2026-10-09 | HIGH/HIGH/MED/MED | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |
| CW-0028 | [一个3D世界原本完全静止，AI怎么让它从每个角度不断循环运动？](https://arxiv.org/abs/2610.12461) | HF Daily Papers 2026-10-09 | HIGH/HIGH/MED/HIGH | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |
| CW-0029 | [机器人叠杯子之前，为什么要记得前十几秒？](https://arxiv.org/abs/2610.10528) | HF Daily Papers 2026-10-08 | HIGH/MED/MED/HIGH | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |
| CW-0030 | [从卫星看棉田变成棕色，农民为什么说这次不一样？](https://science.nasa.gov/earth/earth-observatory/fighting-drought-in-texas-cotton-country/) | NASA Earth Observatory 2026-10-08 | HIGH/MED/HIGH/HIGH | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |
| CW-0034 | [科学家删掉牛胚胎被认为必需的一种信号，小牛为什么还能出生？](https://www.nature.com/ncomms/articles?page=2) | EurekAlert → Nature Communications | HIGH/HIGH/MED/LOW | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |
| CW-0035 | [为什么很古老的软体动物能变成化石，后来的反而更难留下？](https://www.eurekalert.org/news-releases/1146471) | EurekAlert → Cambridge | HIGH/HIGH/MED/MED | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |
| CW-0036 | [为什么群居黄蜂的工蜂无法繁殖，是谁让它们的卵巢停下？](https://doi.org/10.1242/jeb.253019) | JEB Accepted Manuscripts | MED/HIGH/MED/LOW | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |

### HOLD（9）

| ID | 标题 / 原文 | 发现来源 | 四轴 | 批次 |
|---|---|---|---|---|
| CW-0009 | [为什么听起来更响的薯片更脆？](https://doi.org/10.1111/j.1745-459x.2004.080403.x) | Oxford Archive | HIGH/MED/LOW/MED | PRIOR_REPORT |
| CW-0010 | [为什么有些运动服更容易有汗味？](https://pmc.ncbi.nlm.nih.gov/articles/PMC4249026/) | Applied Environmental Microbiology | HIGH/MED/MED/LOW | PRIOR_REPORT |
| CW-0011 | [为什么有些番茄漂亮却没有番茄味？](https://pubmed.ncbi.nlm.nih.gov/28126817/) | Science/PubMed | HIGH/MED/MED/MED | PRIOR_REPORT |
| CW-0017 | [为什么让字母动起来会觉得它活了？](https://strikeachordkt.github.io/strikeachord/) | HF/Strike a Chord | HIGH/MED/LOW/HIGH | PRIOR_REPORT |
| CW-0024 | [蛇不会眨眼，透明眼罩真的能自己把脏东西冲走吗？](https://doi.org/10.1242/jeb.252668) | JEB Accepted Manuscripts | HIGH/HIGH/LOW/MED | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |
| CW-0025 | [青蛙听见陌生物种的叫声，脑内网络为何变化更明显？](https://doi.org/10.1242/jeb.253376) | JEB Accepted Manuscripts | MED/MED/LOW/LOW | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |
| CW-0031 | [泰国洪水怎么在一张卫星照片里扩散成大片水面？](https://science.nasa.gov/earth/earth-observatory/floodwaters-overwhelm-thailand/) | NASA Earth Observatory 2026-10-09 | MED/MED/LOW/HIGH | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |
| CW-0032 | [北极海冰又到了年度最低点，数据里究竟能看出什么？](https://science.nasa.gov/earth/earth-observatory/arctic-sea-ice-shrinks-to-its-2026-minimum/) | NASA Earth Observatory 2026-10-07 | MED/MED/LOW/HIGH | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |
| CW-0033 | [大学生拖延那么普遍，真正让他们痛苦的是什么？](https://doi.org/10.1371/journal.pone.0357714) | PLOS ONE 2026-10-07 | HIGH/MED/LOW/LOW | 2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN |

### REJECTED（1）

| ID | 标题 / 原文 | 发现来源 | 四轴 | 批次 |
|---|---|---|---|---|
| CW-0018 | [为什么插吸管前先看杯子？](https://eyerobot2.github.io/) | HF/EyeRobot | HIGH/LOW/LOW/MED | PRIOR_REPORT |

## 强制待办与禁止误报

- 没有一条完成独立五分钟 STORY-FIT 验收；没有平台流量、真实点击或观众留存数据。
- 所有来源媒体商业许可均 UNKNOWN，访问链接 ≠ 已播放确认 ≠ 可用授权。
- B 站竞品覆盖均 NOT_CHECKED；不存在“内容空白已证”结论。
- HF 历史论文发稿日、HF 日榜展示日、作者新闻稿日期必须分列，不能把三者混作“刚发表”。
- 资料来源无法逐篇访问时，应标记精确限制；本轮尚不能比较九源真实入选率。
