# 2026-10-10｜三日来源采集管线建设与验收状态

## 目标
补齐上轮 `2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN.md` 里“无明确可复查分母、网页采样不完整、不能重复采集”的缺口。追求的是**可审计的原始数据和 API 页数**，不是立即增加节目候选数。

## 本轮实现（代码已写入 main）
- [正式采集程序](../collector/collect.py)；仅 Python 标准库，受限请求上限、HTTP 错误/超时有限重试，每条记录日期和链接。
- [离线回归脚本](../collector/test_collect.py)；日期判定、RSS 缺失日期不可入窗、HF/PLOS 分页结束、HTTP 失败不可误报成功、跨源 DOI key 和重复记录。
- [工作流](../../../../../.github/workflows/cws-source-audit.yml)：`workflow_dispatch` + 提交工作流文件时触发 `push`（仅匹配自身），只读 `contents: read`，结果放于 GitHub Actions artifact，不更改现有选题库。
- [执行与审核说明](../collector/README.md)：列明九来源分别使用什么接口，哪些属于官方 RSS、哪些为跨源 DOI 索引代查以及未覆盖范围。

## 能证明什么
- *代码与合同*：源级请求次数、成功页数、日期内条数、分页边界、出错内容；有 DOI/arXiv/题名 fallback 的跨源去重及摘要导出。
- *可重复运行能力的设计*：窗口参数 `--start 2026-10-07 --end 2026-10-09`；HF 日期分页 `p`，PLOS `rows,start,numFound`；MIT/NASA/Nature 读取 Feed 实际响应；JEB 使用 Crossref 日期索引 proxy；OpenAlex/PubMed 用单一已知 DOI 测可达。
- *诚实的边界*：RSS 有保留期，**哪怕取数成功也不能据此推断三日归档全量**；EurekAlert 未获合法官方公共接口，不绕过 403；JEB proxy 不等于接收稿全文；Nature Human Behaviour feed 不等于 Nature 所有主题。

## 验收状况
- 2026-10-10 当前 ChatGPT 代码执行容器的 HTTP 域名解析**全部失败**（试了 Google、OpenAlex、Europe PMC、MIT RSS），无法在本地获得真实数量。
- 本轮已在隔离测试模型中验证相同处理原则的 Python 解析器 **8 个离线回归用例通过**；GitHub 仓库内的正式 `collect.py` 与 `test_collect.py` 已提交，但**GitHub Actions 真实运行结果不可通过现有插件查询**。
- `workflow_dispatch` 与一次性 `push` 测试已配置，**尚未从远端获取可靠运行 ID、完整日志或有效数据 artifact**。不能声称采集生产化 PASS、完成九源三日全量统计，不能发明各来源候选命中率。
- 若 GitHub Actions 页面出现运行结果，必须读取 `AUDIT.md` / `audit.json`（不是凭状态 success 猜数据）：脚本可正常退出而单源仍 403/429/无数据。

## 下一道真正的 PASS Gate
1. 在 GitHub Actions 确认真实 run、离线单测全部通过、artifact 存在。
2. 检查 HF 3 日期是否三次 API 分页读尽及 PLOS 是否达到 Solr `numFound`。
3. 每个 RSS 源报告“单次快照覆盖的日期区间”，不足者为 `PARTIAL`；EurekAlert/JEB/全部 Nature 专题按需补人工或第二接口，**不冒充九源全量**。
4. 从真实 `audit.json` 内选候选并查回原论文和项目示范，才人工更新 `TOPICS_V1.json` / `BOARD_V1.md`。
5. 所有媒体版权、B 站供给与 5 分钟 STORY-FIT 仍为独立后续环节。

## 当前取舍
**保留现有 36 条正式候选库原样**，直至有可核的真实下载报告；先完成采集验收再继续做规模化新增。
