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

## 5. 本轮状态（2026-10-10）

- 当前 ChatGPT 容器中的对外 DNS 请求均失败，因此**无法在容器执行真实下载**。
- 官方公开接口、RSS 入口和部分原始页面已通过网页检索核对；GitHub 的工作流文件写入已成功。
- 目前**没有可从本会话直接核实的 GitHub Actions run ID 或运行结果**，故不能报告实际拉取条目数/耗时/全源成功率。
- 本文件是运行合同与边界，真正数量必须来自工作流上传的 `audit.json`；不得凭历史 36 个候选推导此轮抓取成功率。
