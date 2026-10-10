# Curious World Studio｜选题库工作流程 v1.0（Owner 确认顺序）

**日期**：2026-10-10 · **决策**：Owner 已同意按以下顺序执行，当前重心为**批量发现 + 选题库初筛与建库**，尚未进入两篇候选的剧本制作。

## 0. 不可打乱的七阶段

1. **九大信息源（SOURCE-REGISTRY）**：按 `research/SOURCE_SYSTEM_FINAL_V1.md`；每日 HF、MIT News、EurekAlert 网页；每周 JEB、NASA EO、PLOS 定制 RSS、Nature 主题；OpenAlex/PubMed 作为索引/查证，不每天漫扫。旧 registry 候选版不与最终版并列。
2. **批量发现（DISCOVERY-BATCH）**：按完整日期窗口发现信息；记录源链接、发布日期、检索日期、实际翻到的项目数、失败/不可访问部分与去重键。只找到标题是 `DISCOVERED`，不是 `VERIFIED`。
3. **统一筛选与评分（EDITORIAL GATE）**：先核证据，再定编辑等级；至少记录标题点击假设、观众原先可能的答案、实验证据新增信息、至少三个独立推进节点、潜在画面、解释复杂度、版权状态、平台竞品检查状态；不得仅按论文影响因子、资讯热度、单一神奇画面或文章篇幅打分。
4. **正式选题库（TOPIC BANK）**：所有发现保留可追溯状态；仅符合 `SHORTLIST` 的进入「可排队深审」视图；其他保留 `DISCOVERED`/`VERIFY`/`HOLD`/`REJECTED` 及理由；按研究 DOI + 项目 ID + 故事切口去重，不删除被拒的审计轨迹。
5. **STORY-FIT 深审**：只对 `SHORTLIST` 的候选检查：是否能在**不拖沓的自然时长**内兑现观众承诺、是否有真实动作或可重现过程、主问题有没有一层层获得新答案；原先 4–6 分钟可作制作与排期参考，**不是硬性时长门槛或独立否决条件**；可以判 `GO`/`CONDITIONAL`/`NO-GO`。
6. **剧本 / 证据素材（SCRIPT + RIGHTS）**：写旁白、时间轴、来源；原论文结果、作者解释、编者类比必须区别；验证链接、真实视频内容、商业复用权三个维度独立记录。
7. **视频制作 / QA / 发布（PRODUCE）**：A 简短桌面 + B QuickTime 播放器现有视觉基线；素材准确性、字幕与音频对齐、权限、成片审查通过后才能发布。发布后用数据回填选题库而不是倒推夸大。

**重要**：第二至四步形成的是「选题库」，第五步才属于「节目深审」；任何正式候选都不代表素材可商用或可直接开拍。

**Owner 2026-10-10 时长口径确认**：不强制视频时长，**不能拖沓**；以观众承诺兑现、自然叙事密度和无明显负面观看感受为判断核心。只同步第5步和 HOLD 描述中的时长含义；本协议的事实核验、四轴评级、至少三个独立证据推进节点、SHORTLIST 及其余状态准入规则均不变。修订依据见 [P3-R6 决策与审查](../reports/2026-10-10_P3R6_CONTENT_FIRST_DURATION_AND_NARRATIVE_GATE.md)。

## 1. 硬性事实门槛（优先于编辑喜好）

- 原始论文/作者项目/机构报道的链接与发布日期；新闻稿及索引只能是发现入口，绝不等于原始实验已核。
- **事实可核**：至少一个可明确定位的真实实验/现场及其研究范围，禁止把关联写因果、动物视觉注意写读心术、跨年份实验拼成同一现场。
- **标题可兑现**：原始证据不支持则改标题、等待补证或拒绝；不允许因用户喜欢而放松。
- **三种素材状态分别记**：`LINK_FOUND`、`CONTENT_VERIFIED`、`REUSE_RIGHTS_VERIFIED`，不做单个“视频素材已找到”的虚假合并。
- **点击欲望不等于节目承载力**：Owner 喜欢题目仅计入人类编辑偏好；绝不冒充已验证观众表现。
- **时间戳和覆盖**：不是穷举就标 `SAMPLED`，不拿历史题的出版日期当本轮更新日期。
- B 站竞品覆盖、保真画面、版权都没有查完的，不可标成 `PRODUCTION_READY`。

## 2. 编辑评价：独立四轴，不机械加权

每个轴赋 `HIGH` / `MED` / `LOW` / `UNKNOWN`，必须有一句证据理由，不能因来源声望假定高分：
- **HOOK**：日常人 15 秒能否理解问题并想看？
- **SURPRISE**：研究结果是否实质超出显而易见的答案？
- **PROGRESSION**：至少三个不同证据节点是否能自然推进故事，而非一个结论解释 5 次？
- **VISUAL**：是否有可看/可合法自制的真实过程，而非 PPT 堆料？

**推荐规则（非简单总分）**
- `SHORTLIST`：原始研究已识别、核心事实可定位、标题可证、HOOK/SURPRISE/PROGRESSION 中至少两项有明确高潜力，且第三项不为 LOW；VISUAL 可以暂时为 MED 或 UNKNOWN 但要说明如何补救。入 `SHORTLIST` 不代表 STORY-FIT 已通过。
- `VERIFY`：看起来有趣，但原研究/关键事实未查到；下一次优先补证据。
- `HOLD`：可证但**未能在自然篇幅里兑现承诺／缺少有效推进**、跳跃大、镜头权利困难或故事和同批重复；保留以供扩展或未来选题。**不得只因短于四分钟而 HOLD。**
- `REJECTED`：标题核心错误/无法兑现或证据不足、无合理修复路径；保留理由。
- `DISCOVERED`：仅列表标题，尚未核。
- `STORYFIT_GO` 只能通过第五阶段之后另立状态，不从首轮四轴直接推断。

## 3. 批次与文件规范

每批单独一个检索日志 `batches/YYYY-MM-DD_*.md`；统一数据文件 `TOPICS_V1.json` + 面向人的 `BOARD_V1.md`；ID 一旦发放不重用。

**机器可读字段合同（`CW-TOPIC-BANK-1.1`，与已经使用的 JSON 对齐）**：以下为**数据存储/校验规范**，不是更改本文件第 0–2 节的来源、评分、晋级或 STORY-FIT 业务规则。

- **原有必备字段**：`id, title, area, discovery_source, source_url, status, ratings, story_beats, critical_caveat, batch_id, owner_selected, evidence_state, source_originality, video_link, video_content, media_rights, bilibili_competitors, storyfit_status`。
- **已有的四轴评分**保存在 `ratings.hook / ratings.surprise / ratings.progression / ratings.visual`，仍只允许 `HIGH / MED / LOW / UNKNOWN`；原先的分数、含义与 SHORTLIST 推荐门槛均保持不变。
- **统一存在但可为 `null` 的追溯元数据**：`original_url`（候选原始资料定位 URL；并非已核实为论文原文的证明）、`discovered_on`（该次检索记录的发现日期）、`published_on`（当时登记的对应资料日期，具体是论文还是新闻须另核）、`next_action`（已明确记录的下一项审核动作）。无可核事实时必须用 JSON `null`，不能拿批次日期冒充论文发表日期，也不能以 `UNKNOWN` 文本伪装已完成。
- **旧字段对应**：历史文档的 `question → title`、`hook/surprise/progression/visual → ratings.*`、`story_angle → title + story_beats`、`caveat → critical_caveat`、`competitor_check → bilibili_competitors`、`media_state → video_link + video_content + media_rights` 仅为**兼容对照**；后两者不是单项可替代的“版权已通过”字段。`original_source`/`links` 未被 `source_url` 自动等同于已核真原文，单项事实仍以 `evidence_state` 及批次原始证据为准。
- **批次执行约束**：新旧数据必须允许未知为 `null`；信息补齐时留可追溯证据，不得因添加/留空字段自动晋级、降级、认定素材可商用或计算新分数。

**同步核验**：以 `TOPICS_V1.json` 为机读母数据，`BOARD_V1.md` 仅是同一快照的人类可读视图；新增/变更题目时同步检查 ID、数量与状态。只读校验工具：
`python curious-world-studio/research/topic-bank/validate_topic_bank.py`；
回归：
`python -m unittest discover -s curious-world-studio/research/topic-bank -p test_validate_topic_bank.py`。
该工具仅检查**数据结构与展示一致性**，不负责重新评审内容价值或判断版权。

## 4. 生效范围

本工作流只负责跨领域「发现→选题库→STORY-FIT」交接，不修改 `research/HF_有趣发现_唯一主协议.md` 的内部 HF-FIND 扫描合同。HF-FIND 仍是其中一条来源专用协议。

### 验收与下一轮
- **本轮**：登记顺序，导入之前查到的研究（标为历史回填），新增少量核实的新样本，产出真实可追溯的选题库第一版。
- **下一轮**：再做三完整自然日、按源记录实际覆盖的独立批次；只有测过之后才能谈“稳定自动选题”与来源质量。
