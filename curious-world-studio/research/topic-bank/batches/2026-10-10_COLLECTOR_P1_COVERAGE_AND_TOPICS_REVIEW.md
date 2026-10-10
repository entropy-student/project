# Curious World Studio｜Collector P1：来源日期覆盖证据 + PLOS 专题审阅队列

**日期**：2026-10-10 · **项目范围**：`curious-world-studio/`（只读 Actions 沿用根目录现有工作流）  
**窗口**：2026-10-07 至 2026-10-09 · **结论**：P1_IMPLEMENTED_AND_BRANCH_LIVE_VERIFIED / NINE_SOURCE_EXHAUSTIVE_NOT_PASSED / TOPIC_BANK_UNCHANGED

## 1. 可复验远端证据

- [P1 修复分支在线运行 #38022100048](https://github.com/entropy-student/project/actions/runs/38022100048)：SHA `8496bcbe1a9ff26faa029350c69ee901ae14cd82`，job `114125108164`，**24/24** Python 离线测试通过；真实 API/RSS 采集 step 成功，上传 artifact `11658083807`。
- Artifact 有 4 个实际文件：`audit.json`、`AUDIT.md`、`PLOS_REVIEW_QUEUE.json`、`PLOS_REVIEW_QUEUE.md`。
- 全部来源窗口内元数据计数 **537**、metadata key 去重后 **537**；未更改 P0 计数分母，更**不是**已确认的原始实验数、有效选题数或制作许可数。
- 本文是带审查边界的程序/数据验收，不代表发布日期档案全量，不用于自动修改 `TOPICS_V1.json`。

## 2. 逐源覆盖分母与观测时间

| 来源 | 观察到的最早—最晚日期（当前返回内容） | 10/7、10/8、10/9 各天落窗数 | 总落窗 | P1 覆盖等级 |
|---|---|---|---:|---|
| HF Daily Papers | 10/07–10/09 | 72 / 71 / 72 | 215 | DATED_ENDPOINT_PAGINATION_COMPLETE（各天不足 100；真实多页尚未观察） |
| MIT Research RSS | 08/24–10/08 | 2 / 1 / 0 | 3 | ROLLING_FEED_SNAPSHOT_ONLY |
| EurekAlert! | 无可验证开放自动接口 | — / — / — | 0 | MANUAL_DISCOVERY_REQUIRED |
| NASA Earth Observatory RSS | 10/01–10/09 | 1 / 1 / 1 | 3 | ROLLING_FEED_SNAPSHOT_ONLY，且上游 XML 恢复，HTTP/解析状态仍 PARTIAL |
| Nature Human Behaviour RSS | 09/30–10/08 | 0 / 2 / 0 | 2 | ROLLING_FEED_SNAPSHOT_ONLY |
| PLOS Solr | 10/07–10/09 | 94 / 99 / 110 | 303 | DATED_ENDPOINT_PAGINATION_COMPLETE，4 页，`numFound=303` |
| JEB Crossref 代理 | 10/07–10/09 | 1 / 2 / 8 | 11 | CROSSREF_INDEX_PROXY_ONLY，`total-results=11`，**仅代理接口分页结束** |
| OpenAlex + PubMed | 仅两个固定 DOI 的接口探测 | — / — / — | 0 | DOI_HEALTH_PROBES_ONLY |

- `observed_source_date_min/max` 只针对**成功解析、符合采集器栏目范围的返回记录**；并非该网站真实最老/最新公开作品日期。
- RSS 单次快照缺少某个请求日期 **绝不证明该日无发表**；例如 MIT 10/09 和 Nature 10/07、10/09 无落窗项，仍必须标记 **UNKNOWN**。
- `coverage_contract` 新增覆盖等级、API 分页结束标记、代理页码结束标记、观察到的日期跨度与每天实际条数、缺项日期列表；`full_nine_source_window_proven=false`、`absence_of_publications_proven=false` 为防误报门槛。
- Crossref `proxy_query_pages_complete=true` 表示 11/11 DOI 元数据索引分页遍历，不意味着 JEB 刊物 Accepted Manuscripts 已遍历；MIT/Nature/NASA 的滚动源不能直接给三日完整归档分母。

## 3. PLOS 专题筛选——不破坏分母

P1 在已有日期范围查询和 `fq=doc_type:full` 基础上读取 PLOS 官方 `subject` 字段。根据**文章类型标签**和**标题或 `subject` 文本词汇提示**产生 `PLOS_TOPIC_HINTS_V1` 审阅路由：

| 分类 | 真实数量 | 准确含义 |
|---|---:|---|
| TOPIC_REVIEW | **143** | `Research Article` 标签且标题/学科主题中出现预定义食品、行为、动物、感知、生活等提示词；进入**人工优先查看** |
| OPEN_DISCOVERY | **130** | `Research Article` 标签但没有词汇命中；**照样保留**，防止漏掉新奇发现 |
| OTHER_ARTICLE_TYPE | **30** | 含 `Review`、`Opinion`、`Study Protocol`、`Correction` 等其他类型；供备查、不当作实验论文 |
| **合计** | **303** | `subject` 非空记录为 **299**；标记 `Research Article` 共 **273** |

- `TOPIC_REVIEW` 只是**基于元数据的自动排序线索**，不是人工审过的主题归属、原创实验认证或 `SHORTLIST`。词汇匹配会有假阳性、假阴性；当前未标注人工精确率，不得声称“已准确筛出 143 篇”。
- `PLOS_REVIEW_QUEUE.json/md` 包含 143 项 DOI、标题、日期、元数据提示类别；其他 160 项**仍可在 audit.json 中查询**，没有被删除或改变任何状态。
- 该策略保留了高召回宽口径观察样本，没有自动把全部 PLOS 科学文章混进正式选题库；后续如要改成特定专题 API 查询/排除规则，先评估漏检率并经 Owner 同意，不擅自将本标签当权威内容过滤标准。
- PLOS 官方接口 `subject`、`article_type`、`publication_date` 文档：https://api.plos.org/solr/search-fields/；原文档规定全文文档使用 `fq=doc_type:full`：https://api.plos.org/solr/search-facets/。

## 4. 技术验收与剩余待做

- Python 测试从 P0 的 **15** 项增加到 **24** 项（+9），新增标签非批准、未命中保留、非研究类型隔离、官方 Solr subject 字段、RSS 实际日期区间与缺日不误报、Crossref 代理范围、审阅清单导出等回归。
- 新增的字段不会宣称媒体商业授权、STORY-FIT 或已经完成中文平台竞争分析。
- P1 解决的是**可审计的覆盖表达和辅助筛查接口**，并没有解决：滚动 RSS 历史档案、EurekAlert 自动公开接口、JEB 官方原刊全文覆盖、跨源实质故事角度去重、人工原创实验证据验证。
- 建议下一道门槛：对专题提示队列和开放池各抽取约 20 项做人工盲核，记录假阳性与漏检；为 MIT/Nature/NASA 寻找官方可日期查询的公开归档路径做**只读可行性验证**。不存在可信归档则坚持 PARTIAL。之后才对可能的新论文逐条做原研究核验和入库决策。

**治理边界**：没有更改 HF-FIND、`SOURCE_SYSTEM_FINAL_V1.md`、Mac v1.2、题库 36 条、其他一级项目，也没有启用自动定时执行或自动视频制作。 
