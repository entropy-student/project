# 选题库 RSS/API 采集器｜运行与验收说明

**目标**：为跨领域选题库提供有统计分母、可重复运行的 **DISCOVERY** 数据采集日志。不是自动写节目，也不会自行提升为 `SHORTLIST`。

## 1. 已编写的程序

- `collect.py`：Python 标准库，HTTP JSON/RSS/Atom 解析；无第三方包、密钥或写入外部网站。
- `test_collect.py`：离线 mock 回归，用于核对日期、RSS 无日期条目的处理、HF/PLOS 分页、异常不能误报通过、去重。
- 工作流：[GitHub Actions · cws-source-audit](../../../../.github/workflows/cws-source-audit.yml)（仓库根目录 `.github/workflows/cws-source-audit.yml`）。
- 历史来源规范：`../../SOURCE_SYSTEM_FINAL_V1.md`，正式题库 `../TOPICS_V1.json`。

## 2. 实际执行的来源范围

| 来源 | 采集方式 | 已确定的严格边界 |
|---|---|---|
| HF Daily Papers | 按日期的 `/api/daily_papers?date=&p=&limit=`，每页直到末页 | **仅**HF 日日榜的接口范围；不是当日全部 AI 论文或发表日期 |
| MIT Research | `https://news.mit.edu/rss/research` | 最新有限条目的 RSS 快照；不代表完整历史 |
| EurekAlert! | **不自动抓取** | 尚未验证官方公开 RSS/API，不突破 403 |
| JEB | Crossref 指定 ISSN 0022-0949 的 online-pub-date API | DOI 元数据代理；**不等同**官方 accepted manuscript 总清单 |
| NASA Earth Observatory | `https://science.nasa.gov/feed/earth-observatory/image-of-the-day` | Image of the Day RSS 快照，不代表 NASA 所有研究；如存在重定向失败如实记下 |
| PLOS | 官方 Solr Search API，按出版时间覆盖所有 PLOS 期刊，`numFound` + rows/start 分页 | 属于全 PLOS 发表文章列表，不是都与节目有关；分页失败/上限不得称完整 |
| Nature | `https://www.nature.com/nathumbehav.rss` | 仅 Nature Human Behaviour 的 RSS 快照，非所有 Nature Portfolio 主题 |
| OpenAlex | 一条固定 DOI 的 JSON 查验 | 接口健康测试，不冒充三天全库 DOI 校验 |
| PubMed | 一条固定 DOI 的 E-utilities 搜索 | 接口健康测试，不冒充三天全库采集 |

## 3. 怎样运行

打开 GitHub Actions 的 **Curious World Studio — read-only source audit**，选择 `Run workflow`，输入两个日期，例如 `2026-10-07` 和 `2026-10-09`。程序只读并上传 `cws-source-audit-results` artifact，里面有：

- `audit.json`：每个源的请求尝试、成功页数、原始条目数、日期窗口内去重后条目、API 自报总数、错误、原始元数据和跨源 DOI/arXiv 去重结果。
- `AUDIT.md`：便于人审阅的来源覆盖表。

Windows PowerShell 本地可选：
```powershell
cd C:\path\to\project\curious-world-studio\research\topic-bank\collector
py -m unittest -v test_collect.py
py collect.py --start 2026-10-07 --end 2026-10-09 --output .\outputs
```

**安全边界**：工作流 `contents: read`，不接触 VPS、VPN、Secrets 或其他项目；不会修改选题库或安排每日定时任务；首次提交工作流文件可能触发一次 `push` 工作流，之后手动 Run 即可。

## 4. PASS 如何判定

`FETCHED` 只是HTTP与解析成功。`covered_query_pages=true` 表示**对应的可分页日期查询**没有已知漏页或报错（主要 HF/PLOS）。RSS 返回的历史窗口不保证完整，即使拿到几十个条目也是 **PARTIAL WINDOW COVERAGE**。

不得使用“九大信息源三日全量 PASS”，除非每一条本来有归档遍历能力的源都有实际末页证据，无法自动访问的源另外得到清晰的人工覆盖分母；目前 EurekAlert!/JEB/Nature/MIT/NASA 的接口契约达不到这个标准。

**每期候选还要经过**：原论文真伪/方法审核 → 是否有具体故事 → STORY-FIT 4–6 分钟验证 → B站竞品检查 → 原视频逐片审核与商用许可确认；只有这些完成，才能宣称节目制作可行。

## 5. 2026-10-10 P0 在线验收更新（覆盖本页原先的“未获得 run”状态）

- [远端真实运行 #38021149558](https://github.com/entropy-student/project/actions/runs/38021149558) 成功：**15/15 离线测试**、三日实时采集及 `cws-source-audit-results` artifact（ID `11657992614`）均已验证。
- **PLOS 303 篇**基础论文，而不是过去的 2,533 个包含章节片段的文档（修复为 `fq=doc_type:full`，4 页 / `numFound=303`）。
- **NASA Earth Observatory 3 条**目标栏目记录：从 10 条 RSS 原始记录中排除 3 条非 EO 的 Photojournal；上游 XML 格式异常由有限兼容修复，仅记 `PARTIAL`。
- **Nature Human Behaviour 2 条**落在日期窗口内；HF 215、MIT 3、JEB/Crossref 11，最终 537 条窗口元数据，跨源 key 去重后仍为 537。此数字不是优质选题数量。
- **九源整体覆盖仍为 PARTIAL / NO-PASS**：未核实 EurekAlert 自动采集、滚动 RSS 完整归档、JEB 原刊全量；OpenAlex/PubMed 仍只做 DOI 探测。
- 权威新报告：[P0 LIVE REVIEW](../batches/2026-10-10_COLLECTOR_P0_LIVE_REVIEW.md)。正式题库、HF-FIND 与视觉规范均未更改。


## 6. P1 日期覆盖与专题审阅队列（2026-10-10 更新）

- [真实在线验收 #38022100048](https://github.com/entropy-student/project/actions/runs/38022100048)：**24/24** 离线测试通过，4 个 artifact 输出；窗口内仍 537 条元数据，不是节目选题数。
- 新文件 `PLOS_REVIEW_QUEUE.json`、`PLOS_REVIEW_QUEUE.md` 是自动生成的人工**优先审阅线索**；`audit.json` 保留全部 303 篇 PLOS 基础文章。143 条 TOPIC_REVIEW + 130 条 OPEN_DISCOVERY + 30 条 OTHER_ARTICLE_TYPE，**不是自动准入**；无人工精确率与漏检率证明。
- 每个来源现在带 `coverage_contract`：仅区分日期查询接口分页结束、RSS 滚动快照、Crossref 元数据代理、人工发现和固定 DOI 健康探测。观察到的日期区间、分日条数和缺项日期已记录。**RSS 缺某日记录不证明该日无发表**。
- JEB 的 `proxy_query_pages_complete` 与 `covered_query_pages` 分开；即使 Crossref DOI 列表翻完也不能宣布期刊 Accepted Manuscripts 全量。
- 权威 P1 审查记录：[P1 COVERAGE AND TOPICS REVIEW](../batches/2026-10-10_COLLECTOR_P1_COVERAGE_AND_TOPICS_REVIEW.md)。九源全部覆盖仍 **PARTIAL**；不自动改变正式题库。
