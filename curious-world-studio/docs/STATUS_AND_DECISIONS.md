<!-- CWS-20261010-HANDOFF-NAV -->
> 2026-10-10 完整最新交接：[PROJECT_HANDOFF_2026-10-10.md](PROJECT_HANDOFF_2026-10-10.md)；采集器 P0 已有成功的真实 Actions run/artifact 验收；但九源全量覆盖仍 PARTIAL，下一步只处理专题范围与覆盖策略，之前的历史「下一步」不应覆盖它。

# 当前决策与待办

> **P3 已完成 B/D 故事证据与资格审查（2026-10-10），但未授予正式 STORY-FIT**：B/D 均不在正式 36 条题库中，按唯一 WORKFLOW 只有先通过 SHORTLIST 编辑准入才能启动正式 GO/CONDITIONAL/NO-GO；本轮完成四轴、5 分钟各节点增量核验、PLOS 原文查证及 B站相邻内容搜索样本。**B 倾向申请正式 SHORTLIST 准入，D 倾向研究 HOLD**，等待 Owner 质量关，不以个人选择代替观众反馈。报告 [P3](../research/topic-bank/batches/2026-10-10_P3_BD_STORYFIT_ENTRY_GATE_REVIEW.md)，[Owner 审查卡](../research/topic-bank/batches/2026-10-10_P3_BD_OWNER_EDITORIAL_DECISION_CARD.md)。当前无新增 CW ID、无剧本/视频、无 OpenMontage 操作；**视频生产之前主动请 Owner 接入其现成 `$openmontage` 流程**。


> **最新 P2-D Owner 点击偏好已确定：B > D**（前者毫秒级声音差异，后者认知负荷风险决策）；Owner 认为「近、但自己没有深入观察/思考过」的问题更有吸引力，但**仅个人判断，尚不代表 B 站实际观众**。A/C 并未被拒绝。优先核查 B 原论文 S1 Audio 的真实播放效果/复用权、D 认知负荷与 tDCS 的分离解释，随后组织独立目标观众小样本盲选；**不修改四轴、分类器、36 条题库或脚本**。详见 [P2-D Owner 反馈与继续核验](../research/topic-bank/batches/2026-10-10_P2D_OWNER_BD_PREFERENCE_AND_EVIDENCE.md)。

> **最新 P2-B/C 审查进展**：5 篇高故事线索 PLOS 原论文经同一助手原始全文复核，已准备 [Owner 质量把关卡](../research/topic-bank/batches/2026-10-10_P2_OWNER_TOPIC_QUALITY_GATE.md)；推荐首先比较巨噬细胞与毫秒点击声题。另完成同窗**可见官网子集**对账：MIT 3/3、NASA EO 3/3、Nature 两篇日期与来源核对 2/2、JEB 接受稿可见 7/7 在 Crossref 11 条内；不冒充自动历史全量。报告 [P2-B/C](../research/topic-bank/batches/2026-10-10_P2B_PRIMARY_REVIEW_AND_P2C_CROSSWALK.md)。**仍缺真正独立第二审、Owner 点击意愿和可重复归档遍历验收；九源完整性仍 PARTIAL，正式选题 36 条不变。**


> **2026-10-10 最新 P2-A：第一轮样本审查完成；完整性仍未通过**。P1 已由 PR #74 合并 main，主分支 [Actions #38022638179](https://github.com/entropy-student/project/actions/runs/38022638179) 24/24 测试、线上审计成功。P2 预先固定 40 篇样本（TOPIC 20、OPEN 20），隐藏队列标签进行单模型标题/摘要初审：明确题材吻合 12 vs 5，较强故事线索 4 vs 2；**此数据不能外推为全库准确率或正式 Story-Fit**，开放池两条强线索证明不应硬淘汰。MIT/NASA/Nature/JEB 的官方历史网页入口已核，但自动档案穷尽未验证。下一步 P2-B 双审与全文复核，P2-C 官方目录与 RSS 日期窗口差异核查；正式选题仍 36 条。详见 [P2 报告](../research/topic-bank/batches/2026-10-10_P2_CALIBRATION_AND_ARCHIVE_FEASIBILITY.md)。


> **2026-10-10 P1 实际验收（最新）**：成功运行 [Actions #38022100048](https://github.com/entropy-student/project/actions/runs/38022100048)，24/24 离线回归测试、4 个 artifact；新增分源可审计观测日期/每日条数/严格覆盖等级，PLOS 303 篇中将 143 条元数据专题线索放入人工审阅队列，130 条开放池/30 条其他类型保留；总体窗口元数据 537。**九源全量仍 PARTIAL，不写剧本，不变更正式 36 条选题。** [P1 审计](../research/topic-bank/batches/2026-10-10_COLLECTOR_P1_COVERAGE_AND_TOPICS_REVIEW.md)。


> **2026-10-10 后续 P0 在线验收更新**：成功运行 [Actions #38021149558](https://github.com/entropy-student/project/actions/runs/38021149558)，15/15 测试、artifact `11657992614`；PLOS 重复章节索引问题修复为 303 篇，Nature 入窗 2 条，NASA EO 3 条（上游 XML 修复但来源保持 PARTIAL），HF 215、MIT 3、JEB 11；合计 537 条。九源覆盖 **PARTIAL**，不可称生产级全量；TOPICS 36 条保持不变。审计：[COLLECTOR_P0_LIVE_REVIEW](../research/topic-bank/batches/2026-10-10_COLLECTOR_P0_LIVE_REVIEW.md)。


**更新日期：2026-10-10**。本文件只描述 Curious World Studio，位于 `entropy-student/project/curious-world-studio/`。

## 已确认
1. Hugging Face Daily Papers 是长期主要选题信息源。唯一研究主协议：`research/HF_有趣发现_唯一主协议.md`；调用：`HF-FIND`。
2. 内容承诺：知识小众、问题大众、现场具体、过程有趣、证据真实、承诺兑现。
3. 固定视觉：A（短暂 Tiger Aqua 桌面）→ B（占满 1920×1080 画布的 QuickTime 7 风格银灰播放器）；B 内部轮播视频、图片、论文证据、字幕，没有单独 C 模式。
4. 单行中文字幕，约 56px，音频对齐；默认硬切，必要时 120–200ms 轻微淡入淡出；素材证据用统一类别标签。
5. 现有 HTML 为离线可操作的**视觉原型**，并非完成的视频自动渲染器。开源 Aqua 样式参考需保留 MIT 许可。

## 待决定 / 待验证
- 中文频道正式名称、Logo、音乐和口播。
- 视觉原型个别 UI 小问题的修正；只局部修复，不随意重新设计。
- 研究视频/图片的实际复用许可、素材搜集流水线、旁白与 SRT 声学对齐、自动视频渲染及成片 QA。
- 发布后观看和评论反馈对承诺机制的验证。

## 仓库治理
- 本项目在既有公共项目库 `entropy-student/project` 的一级目录下，不是单独新仓库；涉及未公开信息时不可直接提交。
- 更新主协议须 Owner 明确确认；历史试跑报告不与主协议竞争。
- 所有截图如未纳入仓库，以 HTML 原型为可预览基线。原始文件压缩包在本轮会话中另有备份。
- 不修改项目库其他一级项目的文件。


## 2026-10-10 STORY-FIT 双路线初试
- 研究报告：[`research/reports/2026-10-10_STORY_FIT_双路线试验.md`](../research/reports/2026-10-10_STORY_FIT_双路线试验.md)。若当前文件在 `docs/` 中，应由项目根目录访问该路径。
- **路线 A**：Strike a Chord 字母运动 + Heider/Simmel 抽象运动知觉相关研究；节目承载力 CONDITIONAL GO，需对跨研究关联与“无字词提示”互动谨慎求证。
- **路线 B**：4DCodeBench、AgentGarten 原研究具备连续案例；可进入 4–6 分钟内容原型，但原素材逐片 QA 和商业授权尚未完成。
- **决策**：暂优先 B，保留 A；不修改 HF-FIND 唯一主协议；未开展完整视频制作。


## 2026-10-10 Owner 确认的正式选题库顺序（已完成第一批初选）

**九大信息源 → 批量发现 → 统一筛选与评分 → 正式选题库 → STORY-FIT 深审 → 剧本/素材核验 → 视频制作/QA/发布。**

- 工作流唯一入口：[`research/topic-bank/WORKFLOW_V1.md`](../research/topic-bank/WORKFLOW_V1.md)
- 选题库展示：[`research/topic-bank/BOARD_V1.md`](../research/topic-bank/BOARD_V1.md)；机读母表：[`research/topic-bank/TOPICS_V1.json`](../research/topic-bank/TOPICS_V1.json)
- 第一批审计：[`research/topic-bank/batches/2026-10-10_SEED_IMPORT_AND_SPOTCHECK.md`](../research/topic-bank/batches/2026-10-10_SEED_IMPORT_AND_SPOTCHECK.md)
- 21 条（SHORTLIST 9 / VERIFY 7 / HOLD 4 / REJECTED 1）。来自历史研究回填 + 少量定向抽查，**并非九源三日完整扫描或自动化生产系统**；尚无 STORY-FIT 正式通关、竞争分析或素材复用许可。
- HF-FIND 唯一主协议及 QuickTime v1.2 视觉规范保持不变；本选题库框架在跨领域层面调度，不是第二份 HF-FIND 主协议。


## 2026-10-10 选题库首次跨领域来源取样
- 工作顺序和准入标准已记录于 `../research/topic-bank/WORKFLOW_V1.md`。
- 10/7–9 三日 **PARTIAL** 扫描更新 `../research/topic-bank/TOPICS_V1.json`、`BOARD_V1.md`，现 36 条（11 SHORTLIST、15 VERIFY、9 HOLD、1 REJECTED）；真实新增 15 条（2 / 8 / 5）。详细覆盖与失败列表位于 `../research/topic-bank/batches/2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN.md`。
- 原始项目代码未部署持续拉取；EurekAlert 403，部分 Nature 付费/登录，OpenAlex/API 和 RSS 三日稳定性尚未实测。不可宣布“完整三日扫描通过”。
- 下一步：修通合法稳定可抓取的官方接口，重跑可计数批次；随后才进入候选 STORY-FIT，不要现在擅自开新剧本或更改 HF-FIND 主协议。


## 2026-10-10 官方 API/RSS 可审计采集器
- 已提交 Python 标准库采集程序 `../research/topic-bank/collector/collect.py`、测试 `test_collect.py`、操作说明 `README.md`，以及根目录 `.github/workflows/cws-source-audit.yml`（只读、workflow_dispatch、一次性 push 测试）。
- 代码为按来源逐项记可见总量、请求、分页、日期、重复和失败的真实采集准备；HF/PLOS 有分页，MIT/NASA/Nature 是 RSS 快照，JEB 为 Crossref 代理，EurekAlert 无确认公共 API。
- ChatGPT 容器 DNS 失败，单源请求失败，本地整批执行超时；Actions 真实运行结果尚不能经当前工具查询、**未拿到可核的 artifact**，故目前验收结论为 `IMPLEMENTED / LIVE_RUN_UNVERIFIED`，不能宣称“九源三日扫描 PASS”。
- 审计依据：`../research/topic-bank/batches/2026-10-10_COLLECTOR_IMPLEMENTATION_AUDIT.md`；题库 36 条保持不变，等待有证据的实际源内容再评选。
