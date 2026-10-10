# Curious World Studio｜跨领域可信信源框架 · 筛选版 v1.0
**评估日期：2026-10-10｜状态：SOURCE_SELECTED / AUTO_HARVEST_NOT_VALIDATED**

目标：持续发现能支撑约 4–6 分钟的真实探索节目，而非最大化论文数量。保留 AI 与科技；同时扩大食物、身体、心理、服饰、交通、自然、动物行为。
已有的 `research/HF_有趣发现_唯一主协议.md` 不更改；本文件是跨领域发现源架构，而不是原协议的替换。

## 一、严格筛选标准

1. **稳定性**：官网近期仍更新；有可追溯时间戳；分清日更、周更、季更。
2. **一手性**：论文/原作者实验优先；研究机构新闻与新闻稿只能用于发现，必须回溯 DOI/正式实验。
3. **覆盖与低重复**：在 HF 科技研究以外有明确增量；专属食物刊、单个机构新闻不能代替广泛索引。
4. **采集**：官方 API/RSS/明确主题页优先；没有确认公开接口的来源不得声称具备无人值守抓取能力。
5. **节目价值**：具体行为/可拍的实验/意外过程/逐步推理优先；医学宣传、抽象指标和单一结论降权。
6. **风险**：重刊、评论综述、未审稿、会议摘要、宣传内容不能等同 peer-reviewed 原始研究；图文开放访问不能等于媒体可商业使用。

## 二、最终信息源体系

### A｜每日核心发现（3 条）

| ID | 来源 | 主作用 | 频率 | 接入可信度 | 证据与风险 |
|---|---|---|---|---|---|
| A1 | [Hugging Face Daily Papers](https://huggingface.co/papers) | AI、机器人、世界模型、视觉交互异常行为 | 每日检查 | 现有研究协议与网页可用；*已有项目方法但独立新管线未验证* | 发现聚合页，原始来源必须追到 arXiv/团队 |
| A2 | [MIT News · Research](https://news.mit.edu/topic/research) | 可视化的真实研究装置、物理、工程、生活应用 | 每日检查新增 | **官方 RSS 已确认**，如 https://news.mit.edu/topic/mitresearch-rss.xml （web 工具无法渲染 XML，RSS 的 MIME 类型获得确认） | MIT 自家科研传播文章，不等于同行评审全文；必须追原研究 |
| A3 | [EurekAlert!](https://www.eurekalert.org/) | 全领域广撒网：动物、行为、食物、自然、材料 | **每日人工/公开网页浏览** | **暂无本轮可确证的开放公共 RSS/API**，官网说明存在实时 feed，但不能假定可无授权机器批量抓取 | AAAS 运营的机构新闻稿平台；稿件可包含会议摘要、综述、商业声明，必须先筛出真实原创研究 |

### B｜专题高价值雷达（每周 2–3 次，4 条）

| ID | 来源 | 价值 | 频率及接入 | 核验事项 |
|---|---|---|---|---|
| B1 | [Journal of Experimental Biology / Inside JEB](https://journals.biologists.com/jeb) | 动物奇异行为、运动物理、自然实验；问题和实测过程丰富 | 每周 1–2 次；期刊主页/issue RSS 与期刊内部更新已核，*具体结构化 feed 未执行采集* | Inside JEB **记者写的解说、并非同行评审**，需读对应 Research Article |
| B2 | [NASA Earth Observatory](https://science.nasa.gov/earth/earth-observatory/subscribe/feeds/) | 自然、天气、地理、卫星发现，有高视觉素材潜力 | 每周 2–3 次；**官方 Image of Day / Natural Events RSS 已核** | NASA 研究/图像说明并非全部是论文；逐条区分 NASA 自有素材与第三方素材许可 |
| B3 | [PLOS 自定义专题订阅](https://journals.plos.org/plosone/s/find-and-read-articles) | 心理、感知、行为、生活/跨学科一手实验，开放论文 | 每周 2–3 次；官方支持**按检索条件生成 RSS**，与主题标签；**不**抓取 PLOS ONE 全量 | 广泛论文会淹没真正可讲故事的实验；只选原创实验与可重现过程 |
| B4 | [Nature Portfolio 主题页](https://www.nature.com/subjects/human-behaviour) / [Nature Food 原创研究](https://www.nature.com/natfood/articles?type=article&year=2026) | 人类行为、食品、农业、环境等；高质量但文章类型混杂 | 每周 2–3 次；**官方主题页展示 RSS/Atom**，本轮直接下载 Nature 子页面有登录跳转，不承诺可稳定脚本抓取 | 仅以 Article / Original Research 为主要一手线索，News & Views/Editorial/Review 需反查其原文；部分全文付费 |

### C｜核实与反向查找底座（2 条，不扫全站）

| ID | 来源 | 工作角色 | 官方接入与限制 |
|---|---|---|---|
| C1 | [OpenAlex](https://openalex.org/) | **跨学科论文索引与 DOI 去重**：根据主题追出历史与新研究 | 官方 API，可按主题/日期过滤；2026-10 价格：无 key 可试用，免费 key 每日 $1 API 使用量（典型小研究足够），高级数据日同步另计；**不是“同行评审数据库”** |
| C2 | [PubMed / NCBI](https://pubmed.ncbi.nlm.nih.gov/) | **人体、味觉、运动、心理、营养的论文检索及证据检查** | 官方 E-utilities API，支持搜索条件保存为 RSS，最多 200 RSS 项；部分论文为预印本、综述、病例报告，需要按研究类型过滤 |

### D｜备查与低频补充（不占日更席位）

- [USDA ARS](https://www.ars.usda.gov/news-events/rss-feeds/)：食品、农业、营养；**官方 RSS 有效，但 2026 新闻档案更新稀疏**，改为按需/每月，不承担每日供稿。
- [arXiv RSS](https://rss.arxiv.org/)：物理、材料、计算；科学原创预印本库，但 AI 研究重复率与 HF 高，除发现空档外不另开全站日更。
- **独立 Nature Food 全刊全量订阅**：比 Nature 相关专题更窄，且混合 News & Views / 评论等，改纳入 B4 的专题过滤，不独占一个扫描源。
- **Phys.org / ScienceDaily 等第三方资讯站**：允许为发现线索的搜索补充，禁止作最终科学证据。
- 无日期更新或已归档网站：不列正式发现源。

## 三、系统结构

```
【新增研究线索｜每日】
  HF Daily Papers  ── AI / 世界模型 / 机器人
  MIT Research RSS ── 研究装置 / 可视化实验
  EurekAlert 网页 ── 全领域研究新闻稿 [仅发现；无已证自动 API]
          │
          ▼
【专题补充｜每周】
  JEB / Inside JEB ── 动物与运动
  NASA Earth Obs.  ── 自然与视觉
  PLOS 定制 RSS   ── 生活实验与行为
  Nature 主题页   ── 行为 / 食物 / 环境
          │
          ▼
【一手核实｜按需】
  OpenAlex + PubMed + DOI + 发表期刊 / 原作者团队
  去重 / 原创实验还是综述? / 同行评审? / 研究条件和限制?
          │
          ▼
【STORY-FIT】
  普通人愿意点开?
  答案是否超出常识?
  是否有至少三步不同的真实推进?
  是否自然支撑约 4–6 分钟?
  原演示与许可是否明确?
          │
          ▼
【候选节目库 → 60–90 秒原型 → 五分钟成片】
```

**两个需要区分的验证状态**：
- **官网与内容样本已核**：2026-10-7/8/9 可检索到 MIT 10 月 7–8 的工程研究案例、EurekAlert 10 月 8 大象姿态传意与 10 月 9 医学类稿件、Nature Human Behaviour 与 Nature Food 10 月 8 新研究等；证实来源有近期内容，但只是**定点抽样**，不是全量或连续三天爬取。
- **程序化真实稳定性尚未核**：当前执行容器外网域名解析失败；通过 web 看到了官方 RSS/API 接口与页面，**没有完成 RSS/API 三日自动拉取、抓取计数、异常率、STORY-FIT 命中率和素材商用许可的实测**。禁止编造数字。

## 四、审查依据（选读）

- MIT Research latest / RSS: https://news.mit.edu/topic/research?page=0&type=1 ; https://news.mit.edu/rss
- EurekAlert eligibility / media rights / release variety: https://www.eurekalert.org/releaseguidelines ; https://www.eurekalert.org/help
- JEB live issue and article types: https://journals.biologists.com/jeb ; https://journals.biologists.com/jeb/pages/article-types
- NASA RSS: https://science.nasa.gov/earth/earth-observatory/subscribe/feeds/
- PLOS official RSS setup: https://journals.plos.org/plosone/s/find-and-read-articles
- Nature Food article types and 2026 articles: https://www.nature.com/natfood/articles?year=2026
- OpenAlex live API pricing 2026: https://help.openalex.org/access/pricing/ ; https://help.openalex.org/access/example-costs/
- PubMed saved RSS & E-utilities: https://pubmed.ncbi.nlm.nih.gov/help/ ; https://www.ncbi.nlm.nih.gov/books/NBK25499/
- USDA RSS and sparse 2026 releases: https://www.ars.usda.gov/news-events/rss-feeds/ ; https://www.ars.usda.gov/news-events/news-archive

## 五、定版范围

**框架定版，不宣称无人值守采集已完成，也不宣布内容赛道更换。**

下一次需要部署时才实测：
1. RSS 实际拉取和响应；API key 预算，HTTP 429/403；
2. 三个最近完整自然日的数据量、去重、标题/摘要保真；
3. 每源 Story-Fit GO 比例与初筛耗时；
4. EurekAlert 是否有合法可靠可自动化入口，没有则保留人工/网页发现；
5. 版权/可引用与可商用画面逐项判断，不把论文开放许可外推到视频。
