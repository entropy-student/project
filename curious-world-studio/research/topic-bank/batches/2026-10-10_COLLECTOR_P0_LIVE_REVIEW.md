# Curious World Studio｜Collector P0 真实在线修复与严格验收

**审查日期：2026-10-10**  
**范围：仅 curious-world-studio/ 及已有只读工作流 .github/workflows/cws-source-audit.yml**  
**结论：COLLECTOR_P0_FIX_LIVE_VERIFIED / NINE_SOURCE_COVERAGE_PARTIAL / NO_TOPIC_BANK_UPDATE**

## 1. 远端运行与不可混淆的三种状态

- 代码提交与 GitHub Actions 工作流已存在；不是“已经完成九源自动扫描”。
- 原始成功运行：[38019541170](https://github.com/entropy-student/project/actions/runs/38019541170)，commit `c92f24d31435e677ab8ac739e74ec65dcca1851a`，artifact `11657223423`，8/8 离线测试；原始计数存在重复索引文档及遗漏。
- 修复后的最终成功运行：[38021149558](https://github.com/entropy-student/project/actions/runs/38021149558)，commit `0a333c493330648ce66bc911bcf4a58cabdd2796`，job `114122202774`，artifact `11657992614`，15/15 离线测试、真实日期窗口采集、结果压缩包上传均成功。
- 两次对比使用同一日期窗口 **2026-10-07 至 2026-10-09**（各来源自己的公开日期字段）。
- 最终 artifact 含 `audit.json` 与 `AUDIT.md`；本报告数字来自**读取实际 artifact 内容**，不依赖 workflow success 文案。
- 最终程序自身标记 `all_nine_source_complete=false`、`production_ready=false`。此处不能改写为全来源通过。

## 2. 同窗源级实测

| 来源 | 原始运行窗口内 | 修复运行窗口内 | 修复运行原始返回/请求页 | 最终覆盖边界 |
|---|---:|---:|---|---|
| HF Daily Papers | 215 | **215** | 215 / 3 页，2026-10-07:72、08:71、09:72 | 日期 API 各天一页均正常终止；仅 HF 日榜，不等于当天所有论文；跨页 >100 条仅有 mock 回归，未在本窗口真实触发 |
| MIT Research | 3 | **3** | RSS 50 条 / 1 页 | 滚动快照，旧日期是否全部仍无法保证 |
| EurekAlert! | 0 | **0** | 0 / 0 | 无本轮核实的开放公共 RSS/API，保持人工发现，不绕过 403 |
| NASA Earth Observatory | 0 | **3** | RSS 实际读取 10 条 / 1 页；过滤后目标栏目 7 条，其中窗口内 3 条 | 上游 XML 缺少命名空间属性空格；**仅针对此已观察格式**作有记录的解析恢复，仍为 PARTIAL。3 条非 EO Photojournal 已排除 |
| Nature Human Behaviour | 0 | **2** | RSS 8 条 / 1 页 | 修复 `date`、`publicationDate` 等日期字段；仍为滚动 RSS 快照，非全部 Nature 主题 |
| PLOS | 2,533 | **303** | Solr `numFound=303`、4 页均完成 | 官方 `fq=doc_type:full` 排除 `/body`、`/abstract` 等章节索引。303 篇中 `Research Article` 为 273；**尚属全 PLOS 期刊宽口径，未按专题/原始实验进一步筛选** |
| JEB / Crossref | 11 | **11** | Crossref DOI 代理 11 条 / 1 页 | 非 JEB 官方已接收稿件清单；不是原刊历史全量 |
| OpenAlex / PubMed | 0 | **0** | 固定 DOI 两次探测成功 | 仅接口健康，不是日期窗里的研究扫描或实际全库交叉去重 |
| **合计** | **2,762** | **537** | — | 只是本次各端点日期窗内的元数据记录，非合格选题数量 |

最终 `date_window_items_across_sources=537`，`unique_keys_across_sources=537`，`cross_source_duplicate_keys=[]`。这里的 0 重复只表示按现有 DOI/arXiv/标题 key 没有检测到重复，**不等于不同研究不存在相似的故事切口**。

## 3. 根因、修复与回归

1. **PLOS 论文计数放大**：旧请求未加 `fq=doc_type:full`，把章节片段当成独立论文；增加官方父文档过滤和意外片段守卫。独立测试证明部分文档不能通过；真实源由 2,533 归一为 303（与 API `numFound` 一致）。PLOS 官方说明：https://api.plos.org/solr/search-facets/
2. **Nature 论文日期丢失**：原解析只读 RSS `pubDate` / Atom `published` / `updated`；补 `dc:date`、`prism:publicationDate`（按本地 tag 名）、`issued`，真实源窗口内由 0 恢复到 2。
3. **NASA 上游无效 XML**：真实 HTTP 返回 612,908 字节，在第 8 行存在 `xmlns:apod=".../"xmlns:media="..."`，属性间没有空格。仅 NASA 且确切 token 匹配时插入缺失空格，审计记录原始错误、截断片段和 `NASA_NAMESPACE_WHITESPACE_ONLY` 恢复状态；来源仍保留 PARTIAL。
4. **NASA RSS 混入其他栏目**：记录 `feed_entries_seen=10`、`out_of_scope_count=3`，只接收 `/earth/earth-observatory/` 或官方 Earth Observatory `/images/` 的链接；3 条同窗 Photojournal 不再冒充 EO。
5. **测试**：由 8 项扩到 **15 项**，覆盖 PLOS 全文过滤/异常章节、Nature RDF 日期、HF 模拟跨页、NASA 无效 XML 诊断、有限恢复与栏目过滤；GitHub Actions 最终真实运行 15/15 通过。
6. **CI 触发**：`push` 路径增加本项目 `collect.py` / `test_collect.py`；保留 `workflow_dispatch`、`contents: read`、无自动题库写入。

## 4. 审查限制与剩余风险（不能报 PASS）

- **九源总体仍为 PARTIAL**：MIT/Nature/NASA RSS 是滚动窗口，JEB 仅 Crossref 索引，EurekAlert 不能自动采；OpenAlex/PubMed 只是健康探针；没有全量覆盖分母。
- **HF 真正多页的在线样本未出现**：原端点 3 个日期各返回不足 100 条；多页代码通过 mock，不等于在外部环境观察过第二页。
- **PLOS 仅修复了按“文章”计数**：303 是宽泛发表文章，273 个 Research Article 也尚不能代表 273 个可讲的原创实验。专题过滤、论文事实审查与候选角度去重仍是下一道编辑 Gate。
- `attempts` 是每个逻辑 URL 调用次数；`get()` 内部可能自动重试，因此不是严格的底层网络尝试总数。
- 每条媒体复用权、B站竞品、4–6 分钟 STORY-FIT 仍未知；本次未修改 `TOPICS_V1.json`、`BOARD_V1.md`、HF-FIND 主协议及 Mac v1.2 规范。

## 5. 下一轮建议（P1，独立于本轮通过项）

- 将 PLOS 的**专题与原创实验**过滤做成显式可审计的编辑范围；保留宽口径原始发现统计作为参考，不能用 `Research Article` 标签直接宣布可制作。
- 补各滚动 RSS 的来源日期边界、快照保留期及可靠的定期窗口策略；若需要历史完整三天，必须使用正式归档/期刊查询做交叉覆盖核查。
- 让 NASA 的解析恢复仅作为临时兼容，并优先确认官方是否已修复 XML；上游仍无效时保留 PARTIAL。
- 核实原始论文后再人工入库；36 条母表及其既有状态原样保留，不启动剧本或视频生产。
