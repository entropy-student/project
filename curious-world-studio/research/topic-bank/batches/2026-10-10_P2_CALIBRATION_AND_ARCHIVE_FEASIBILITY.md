# Curious World Studio｜P2-A：40 篇抽样初审 + 官方来源历史核查入口

**日期：2026-10-10**  
**阶段性结果：P2_ABSTRACT_ONLY_CALIBRATION_DONE / ARCHIVE_BROWSER_ROUTES_VERIFIED / AUTOMATED_ARCHIVE_COMPLETENESS_NOT_PROVEN / TOPIC_BANK_UNCHANGED**

## 0. 本轮基线与来源

- P1 [PR #74](https://github.com/entropy-student/project/pull/74) 已合并入 `main`，merge `bf16fd985c4281da34ff75f1a299b284da39279a`。
- P1 的 `main` 运行 [#38022638179](https://github.com/entropy-student/project/actions/runs/38022638179) **24/24 测试通过**，live fetch 通过，artifact `11657994563` 上传成功。
- 同日期窗口（2026-10-07 至 09）PLOS `303` 篇父文档，`143 TOPIC_REVIEW + 130 OPEN_DISCOVERY + 30 OTHER_ARTICLE_TYPE`。节目题材和许可状态均未自动改变。
- 本轮不重新命名或重写九源方案，不改 `SOURCE_SYSTEM_FINAL_V1.md`、HF-FIND、`TOPICS_V1.json`、Mac v1.2、SRT/剧本，不触碰其他项目。

## 1. 抽样、评审口径及边界

- 抽样母体是 P1 Actions [#38022100048](https://github.com/entropy-student/project/actions/runs/38022100048) 中 artifact `11658083807`，PLOS `audit.json` 的 **143 条 TOPIC_REVIEW**、**130 条 OPEN_DISCOVERY**。
- 可复现抽样：分别按 `sha256("CWS-P2-20261010-v1-fixed-before-rating|" + DOI)` 升序取各 20 篇，再按 `sha256("blind-order|CWS-P2-20261010-v1-fixed-before-rating|" + DOI)` 重新打乱共同顺序。队列标签在评分结束后揭盲；40 个具体 DOI、逐篇理由见 [40 篇初审明细](2026-10-10_P2_PLOS_40_ABSTRACT_REVIEW.md)。
- 评审者为**一个模型**（并非独立人类双评审），只读 `title` + 被 collector 截断为 1000 字符的摘要；未读 40 篇全文、未核原始实验图片/原始数据、未复查学术诚信或版权。此处的“隐藏队列标签”只降低评分时对分类器的直接预期偏见，**不构成独立金标准**。
- 题材 `Y` = 当前跨领域频道可面向大众提出具体困惑，`M` = 可能相关但较边缘，`N` = 在此频道当前定位下主要属专业临床/技术/方法学。故事线索 `2` = 摘要显示可对照过程/具体行为/可视化实验，`1` = 可能切入但需全文支撑，`0` = 摘要缺可讲推进。**2 不是 STORY-FIT GO**。

| 仅此次抽样的评分 | 143 专题池中抽 20 | 130 开放池中抽 20 |
|---|---:|---:|
| 大众题材明确相关 Y | 12 | 5 |
| 题材边界 M | 6 | 3 |
| 本频道暂不匹配 N | 2 | 12 |
| 初步较强叙事线索 2 | 4 | 2 |
| 可能有线索 1 | 11 | 5 |
| 暂无足够线索 0 | 5 | 13 |

**解释**：在这 40 篇样本中，P1 主题提示确实更集中；但 `OPEN_DISCOVERY` 仍有 2 篇评分为故事线索 2 —— `10.1371/journal.pone.0356679`（巨噬细胞清除双重目标）与 `10.1371/journal.pone.0359341`（血流限制束带实验）。若硬过滤开放池，本次就会漏掉它们。专题池也有 `10.1371/journal.pone.0358891`（HPLC 药物定量）及 `10.1371/journal.pone.0359881`（健康素养量表验证）这类主题关键词误报。

**不能将 12/20 直接叫“精准率 60%”或把 5/20 叫“全库漏检率 25%”**：单人主观评审、小样本、按队列分层抽样、真实节目主观门槛与期刊分布都限制了外推。该结果只能支持**暂保留双通道，优先审阅专题池，不删除开放池**。

## 2. 归档核查：只读、官方可见入口

### MIT Research

- 官方目录：https://news.mit.edu/topic/research
- 页面明确 `Displaying 1-15 of 6699 news articles related to this topic`，另有 `?page=1` 的下一页（可返回更早文章）。
- 页面 2026-10-08 一篇 `Shape-sensing sheet ...`，10-07 两篇 `Turning the tide ...`、`Planning system ensures ...`，**与本窗 MIT RSS 的 3 条标题对应**。当前只是页面可见性与已知 3 条的对照，尚未遍历当日所有非 Research 主题页面。
- 后续建议以官方 topic 页有界翻页回查 RSS 日期窗：每页记录 HTML 条目日期、文章唯一 URL、终止原因和页面快照摘要。**尚未验证网页可供稳定无人值守抓取**。

### NASA Earth Observatory

- 官方 Image of the Day：https://science.nasa.gov/earth/earth-observatory/image-of-the-day/
- 页面有 **Start / End Date** 和 **Topic** 筛选 UI；当前可见 10-09 `Floodwaters Overwhelm Thailand`、10-08 `Fighting Drought in Texas Cotton Country`、10-07 `Arctic Sea Ice Shrinks to Its 2026 Minimum`，与 P1 RSS 的 3 条相符。
- 日期筛选为**网页 UI**，本轮没有证明可以用公共 JSON API 或稳定 URL 参数自动枚举，更没有修复上游 RSS 的原生无效 XML。NASA feed 原状态依然 `PARTIAL`。图片/卫星数据逐件查媒体署名和授权。

### Nature Human Behaviour

- 官方原始研究目录：https://www.nature.com/nathumbehav/research-articles ，2026 / article 类型目录：https://www.nature.com/nathumbehav/articles?type=article&year=2026
- 原始研究目录可见 2026-10-08 `Recreational screen use ...` 与 `Microdelays disrupt online learning`，与 RSS 2 条对应。
- 部分直接访问发生 Nature 账号 IdP 跳转，**本轮只证实浏览可见目录**，未验证公开稳定的程序化分页/日期过滤或全集；且本频道 B4 原先还包括 Food、环境等 Nature 主题，当前 collector 的 `nathumbehav.rss` 只是子集。

### Journal of Experimental Biology

- 官方 Accepted manuscripts：https://journals.biologists.com/jeb/accepted-manuscripts
- 官方 Issues / archive：https://journals.biologists.com/jeb/issue
- 官方接受稿页面可列 2026-10-09/08 的研究条目、论文类型和 `jeb.XXXXXX` 编号；该出版社说明接受稿是**经过同行评审但尚未排版成正式期刊版**的稿件（进入排版/issue 的日期可能不同）。
- 当前 collector 的 `JEB_CROSSREF_PROXY` 有 11 条通过 online-pub-date 条件从 Crossref 检索出的 DOI；**Crossref 索引日期 ≠ Accepted manuscripts 上线日期 ≠ 最终 issue 发表日期**。应分别记录三者，靠 DOI 合并，不拿 11 与接受稿数量直接算召回率。
- 后续建议以 official accepted list + issue archive 做差异核查。不得绕过登录与版权门槛；当前尚未验证允许稳定抓取的官方结构化接口。

### EurekAlert / OpenAlex / PubMed

- EurekAlert 仍未核实适合无人值守且开放许可的公共采集 API/RSS，维持人工公开发现，不使用需要绕过访问控制的方案。
- OpenAlex / PubMed 保持**按 DOI 或主题定向核验**，不扩展成每日全站扫描以凑“九源覆盖”。

## 3. 阶段结论与可执行后续

1. **P2-A 通过（样本和数据留痕）**：抽样种子、40 条 DOI、评分与不确定性、官方来源入口已入仓。P1 的元数据专题标签作为**优先审阅**而非硬性淘汰，决策保持不变。
2. **P2-B 尚未通过**：要真正提高排序质量，应由第二位独立审阅者（建议 Owner 或 Reviewer）在不见 P1 分类的情况下复核这 40 篇，解决分歧并对样本中的强/疑似漏检条目查看原论文方法和结果；之后才考虑改关键词。
3. **P2-C 尚未通过**：对 MIT/NASA/Nature/JEB 逐一验证官方 archive 的可重复、允许的、分页穷尽/日期边界，并列出同日 RSS 与官方目录的 DOI/URL 级差异；没有稳定证据就保留 `PARTIAL`，不因本轮网页对上几篇而宣称完整。
4. **正式选题仍为 36 条**；没有自动加入任何样本，更没有自动触发剧本、素材、渲染和发布。

**真实外部依据（官方，2026-10-10 复核）**：MIT https://news.mit.edu/topic/research ; NASA https://science.nasa.gov/earth/earth-observatory/image-of-the-day/ ; Nature https://www.nature.com/nathumbehav/research-articles ; JEB https://journals.biologists.com/jeb/accepted-manuscripts 与 https://journals.biologists.com/jeb/pages/editorial-process 。
