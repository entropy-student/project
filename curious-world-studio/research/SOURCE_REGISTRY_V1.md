# Curious World Studio｜跨领域选题信源登记册 v1
> 研究日：2026-10-10 · 状态：**PROPOSED / SOURCE LINKS VERIFIED / AUTOMATED HARVEST NOT YET TESTED**
> 此清单仅锁定**候选信息源体系**和角色分工，下一轮才做 3 天采样与自动抓取连通性测试。用户尚未批准改写研究主协议。
> 频道目标：找出能把普通观众带入约 4–6 分钟真实探索的研究或实验故事。不能以 AI 为必须领域。

## 0. 特别区分

- **原始研究**：论文作者发表的一手方法、实验、数据和局限（预印本必须标注未审稿）。
- **论文索引**：聚合各机构论文元数据 / 研究入口（如 OpenAlex、PubMed），不是直接审稿。
- **研究新闻稿**：大学、研究机构或传播团队写的研究概述（如 EurekAlert、MIT News、USDA ARS），不是原始证据。
- **视频素材**：论文、网站上的图表/视频的商业权利另查；期刊 OA/机构官网不代表视频一律可商用。
- **Hugging Face Daily Papers**：保留为 AI 技术发现入口，本身也是论文展示/聚合，不等于最终原始发表方。

## 1. 建议固定核心 6 项

| ID | 信息源 | 固定入口 | 类型 / 原始性 | 内容范围 | 更新和抓取现状 | 角色与注意事项 |
|---|---|---|---|---|---|---|
| D1 | **EurekAlert! / AAAS** | https://www.eurekalert.org/ | 新闻稿分发（**非原始论文**） | 科学、食物、心理、农业、生活现象广覆盖 | 持续发布；官网新闻列表可读；**公开 RSS/API 未在本轮确认，不能预设接口** | 首要跨领域发现源；新闻稿包含非同行评审结果和机构宣传，必须反查论文 DOI / 实验 |
| D2 | **OpenAlex** | https://openalex.org/ ; https://help.openalex.org/api/ | 全学科**论文索引** | 生活、设计、人文、物理、交通、社会等 | 官方 API 可搜索、领域过滤、按发表日期查询；现行官方说明基础免费、免费 key 增额；created/updated sync 过滤属付费，不作为免费方案 | 系统级检索和 DOI 去重；索引日期/发表日期不等价；其“作品”可能含评论、综述、预印本 |
| P1 | **PubMed / NCBI** | https://pubmed.ncbi.nlm.nih.gov/ ; https://pubmed.ncbi.nlm.nih.gov/help/ | 生物医学论文索引（下钻原论文） | 感官、味觉、心理、人体行为、营养、食品与健康 | 官方可保存检索 RSS、E-utilities API；自定义关键词 | 核对人体/生活实验，审稿状态、临床/动物/关联需区别；全文可接 Europe PMC / PMC |
| P2 | **PLOS（尤其 PLOS ONE）** | https://journals.plos.org/plosone/ ; https://api.plos.org/ | **一手期刊论文发表方**（另有文章类别） | 跨学科具体实验，开放获取 | 官方期刊 RSS 与 Solr Search API | 偏好有实际实验图、方法和可复现示范；论文多，需深入过滤而不能盲读 |
| P3 | **Nature Portfolio 主题列表** | https://www.nature.com/subjects/nutrition ; https://www.nature.com/subjects/agriculture ; https://www.nature.com/natfood/research-articles | 出版平台：有一手研究，也有综述/新闻/观点 | 食物、行为、心理、材料、自然 | 主题页 Atom/RSS；Nature Food 持续研究文章列表 | 需要筛“Research Article”，不能将 News & Views 当新实验；部分全文有付费墙 |
| D3 | **MIT Research News** | https://news.mit.edu/topic/research ; https://news.mit.edu/rss | 校内研究新闻（机构第一方说明，**非论文原文**） | 有演示、装置、实验过程的科学/工程/生活研究 | 官网“Research News” RSS 和多主题 RSS | 寻找能被拍出来的实际操作；只覆盖 MIT 和研究合作，必须继续核原文 |

> 这 6 项是最小的 **发现 + 证据回溯** 体系；不代表每天必须全站读完。围绕发现扫描摘要、关键词、图表与原始来源，进入 STORY-FIT 再做深入阅读。

## 2. 主题增强 4 项（有用时启用，不必全部每日扫描）

| 信息源 | 链接 | 类型 | 什么时候使用 |
|---|---|---|---|
| **Journal of Experimental Biology / Inside JEB** | https://journals.biologists.com/jeb | JEB 原论文 + 期刊内部的二次解说 | 动物行为、身体运动、奇妙实验；Inside JEB 编辑解说为发现线索，点回 Research Article 才算一手 |
| **USDA ARS** | https://www.ars.usda.gov/news-events/rss-feeds/ | 美国农业部研究机构官方新闻（不是论文） | 食物、营养、作物、风味、材料加工；官方提供 RSS |
| **NASA Earth Observatory** | https://science.nasa.gov/earth/earth-observatory/subscribe/feeds/ | NASA 自己的观测、自然事件图像和解释 | 天气、地球、城市、自然奇观；官方 RSS / 相关 NASA 图像许可需按具体页面核 |
| **arXiv RSS & HF Daily Papers** | https://rss.arxiv.org/ ; https://huggingface.co/papers | 预印本/论文聚合 | 保留科技和行为型 AI 题；arXiv 分类 RSS 日更新，预印本不等于同行评审通过 |

另可使用 **Europe PMC** https://europepmc.org/developers 取得某些生物医学论文全文，**Crossref** https://www.crossref.org/documentation/retrieve-metadata/rest-api/rest-api-filters/ 辅助 DOI 查验/去重；这两者是工具，不单独算内容频道。

## 3. 不建议当成主要事实来源

- Phys.org、ScienceDaily 或网络搬运号：可以提供线索，但不能只从其转述下结论。
- EurekAlert 新闻稿／MIT News／USDA ARS 的配图和视频：仅能判断资源存在，**不可默认商业授权**。
- 旧 NOAA Climate.gov feed 镜像：明确标记 2025-06-25 起归档不维护。参见 https://prod-01-asg-www-climate.woc.noaa.gov/feeds ，不可当作 2026 活跃信息源。
- 只看期刊的影响因子或社交热度：不能代替真实性、视觉实验和持续叙事能力。

## 4. 每日发现工作流（**方案，未执行自动任务**）

1. **宽发现（每日 1 次即可）**：D1 新增稿件；D3 RSS 新文章；P2、P3 指定 RSS。扫描英文标题 + 原始摘要，排除医学建议/争议未经证实的夸大标题。
2. **主题反查**：对候选用 D2 OpenAlex / P1 PubMed 检 DOI、研究类型、对应的论文及图表；必要时 Europe PMC/期刊阅读正文。
3. **两轴筛选**：A「点击 + 答案增量」、B「自带多步研究过程 + 画面 + 5 分钟必要性」。若素材来自新闻稿，则一律标“需一手复核”。
4. **来源和授权**：分别记录 DOI/原文链接、作者机构新闻、原项目视频地址、实际播放内容验证、复用许可；四项不互相代替。
5. **统一去重**：优先 DOI，其次 arXiv ID，最后题名归一 + 作者 + 日期；同一研究被 EurekAlert、PubMed、OpenAlex 重复发现，只算一个候选。
6. **每期样本配额**：并行保留科技与生活题，不先规定固定比例；公开发表的文章可回溯追溯经典论文，**新鲜程度不是所有题的硬门槛**。
7. **先试 3 个连续自然日**：统计各源实际数量、质量、重合率、原创实验比例、具有视频/可合法自制画面的比例、平均筛选耗时、STORY-FIT 通过率，之后删低收益信息源。

## 5. 官方功能核实资料

- EurekAlert 关于页 https://www.eurekalert.org/about-us 及投稿准入 https://www.eurekalert.org/releaseguidelines
- OpenAlex API https://help.openalex.org/api/ 与 filter 文档 https://help.openalex.org/api/filtering/ （2026 年版本）
- PubMed RSS 帮助 https://pubmed.ncbi.nlm.nih.gov/help/
- PLOS RSS 说明 https://journals.plos.org/PLOSone/s/help-using-this-site 和 PLOS API https://api.plos.org/
- Nature Food 最新研究 https://www.nature.com/natfood/research-articles 和 Nature Portfolio 主题 RSS 页 https://www.nature.com/subjects/nutrition
- MIT News 官网 RSS https://news.mit.edu/rss
- USDA ARS 官网 RSS https://www.ars.usda.gov/news-events/rss-feeds/
- NASA Earth Observatory RSS https://science.nasa.gov/earth/earth-observatory/subscribe/feeds/
- arXiv RSS 使用文档 https://info.arxiv.org/help/rss.html （若该地址迁移，以 arXiv 官方文档 / RSS 域名 https://rss.arxiv.org/ 为准）

## 6. 状态和下一步

**已经确认网站存在、持续有近期期刊文章，以及多数官方 RSS/API 说明**；**未实际运行三日抓取**，未证明完整历史覆盖/更新延迟、EurekAlert 自动接口、复用许可或各源出题效率。

建议由 Owner 确认这六个核心 + 四个可选的结构后，再做独立采集试跑；不要把“信息源已定”误称为“管线已部署”。
