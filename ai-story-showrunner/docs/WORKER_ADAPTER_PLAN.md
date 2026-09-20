# Worker Adapter Plan v0.1

## 1. Principle

当前已发现的 Skill 都是**候选能力源**，不是 AI Story Showrunner 的永久 Worker 编制。

本项目不因为“已经有这个 Skill”就强制调用它。

Worker 选择遵循：

Stage Requirement → Capability Match → Adapter Feasibility → Output Contract Compliance → Quality Evidence → Route / Replace / Disable

优先使用 Adapter，而不是直接把通用 Skill 改造成项目专用 Skill。

原因：保留原 Skill 的通用价值；避免项目规则污染 canonical Skill；原 Skill 升级后仍可重新适配；Showrunner 可随时替换 Worker；每个 Worker 权限边界更清楚。

## 2. Current Scan Result

### No Canonical Topic Worker Found

在当前 `entropy-student/spike.skill` root / recursive path scan 中，没有发现独立命名的 AI topic selector、历史选题账本、daily AI topic radar 或 general content topic opportunity Skill。

当前状态：`TOPIC_WORKER = TO_DEFINE_OR_LOCATE_ELSEWHERE`。

这不证明用户其他仓库 / 历史文件中绝对不存在，只证明当前 canonical spike.skill 扫描未发现。

## 3. acquisition-growth-radar

### Current Native Role

canonical 职责是：Evidence → Bottleneck → Lever → Experiment → Decision。

它明确写明不替代产品战略 / 选品，且强调 Attention ≠ Demand、播放量 ≠ 需求、Trust 是横向变量、Winner 不应只看播放量。

### Showrunner Position

**不是上游 Topic Brain。** 推荐位置：Publish / Metrics → Growth & Learning Adapter → Content Ledger / Experiment。

可复用：evidence ladder、attention / interest / intent / transaction 分离、trust diagnosis、single-variable experiment、KEEP / ITERATE / KILL / SCALE，以及防止“爆款 = 产品需求”的误判。

### Required Adapter

输入：episode primary_content_job、Traffic / Trust / Conversion metrics、comments / questions、product context（如有）。

输出限制：只诊断内容增长与转化证据；不静默改故事原则；不根据单条播放量自动改变 Topic policy；不把商业指标包装成知识事实。

## 4. entertainment-rander

### Current Native Role

娱乐热梗识别与 S+/S/A/B 分级，核心价值是娱乐性、破圈度、二创性、脱源性、衍生能力与持续性。

### Showrunner Position

**Optional Signal Source**，不是总 Topic Worker。

适合发现当前中文互联网娱乐语法、给 AI 热点寻找文化桥接 / 梗入口、判断热点是否有二创/破圈势能。

不适合判断 AI 技术机制是否值得讲、独立决定整期选题、替代 Human Problem / KnowledgeCore，或把严肃 AI 变化硬娱乐化。

## 5. jingsui-story-video-director

### Current Native Strengths

v3.4 已具备：具体事件优先、narrator 是当事人不是导师、thesis delay、事实→反应→结果→riff→新事实→判断、具体人物承载抽象主题、1–2 个主梗母题、口语长短句、SRT 与漫画视觉节拍经验。

这些与本项目 Story-first 原则高度兼容。

### Native Assumptions That Conflict

- 默认男性原创 IP；
- 固定开场“大家好，我是 {{IP_NAME}}”；
- 默认英文尾签；
- 默认参考 150–240s 长稿结构的一部分规则；
- 自带 Visual Beat / Scene Bible / 生图 / 剪辑输出；
- 当前视觉资产策略仍强调较高复用率；
- 当前任务是“主题 → 完整视频方案”，权限过宽。

### Showrunner Position

推荐作为 `WRITER_STYLE_ENGINE`，而不是 `GLOBAL_STORY_DIRECTOR`。

### Project Adapter Must Lock

输入必须已经有 TopicOpportunity PASS、KnowledgeCore PASS、StoryPremise PASS、primary_content_job、target duration、platform packaging、voice / IP config。

允许它修改：语言、叙事语气、口语节奏、梗链、句法、title / hook candidate、Script / SRT。

禁止它修改：ai_mechanism、factual claims、StoryPremise 核心因果、primary_content_job、conversion intent、后续低层镜头时间线。

### Project Overrides

1. 不强制 IP 签名开场；
2. 不强制英文尾签；
3. 第一帧优先异常事件 / 冲突，不强制自我介绍；
4. duration 使用 episode contract，不继承 150–240s 默认；
5. 只把 Writer 输出作为 canonical，不接受其自带 Director / Image / Edit 结果覆盖后续 Stage；
6. 视觉资产不以“少生图”为优化目标；
7. 一条视频只服务一个 locked AI mechanism；
8. DISCOVERY / TRUST / SOLUTION 会改变 hook / payoff，但不改变事实。

## 6. McKee / Story Structure

当前 `spike.skill` recursive path scan 没有发现独立 McKee Skill。

`jingsui-story-video-director` 已包含 event-first、gap / reaction、thesis delay、progressive evidence、character-centered narration，但它不是完整的 McKee causal story engine，也不应该承担 KnowledgeCore → StoryPremise 的全部责任。

### Current Decision

除非后续找到更权威的已有 Skill，**McKee-style structure 暂时冻结为 Showrunner 内部 Story Engine Gate，而不是独立 Worker。**

最小结构：Desire → Inciting Incident → Action → Gap → Progressive Complications → Turning Point → Recognition / Rule → Choice / Payoff。

景岁 Writer 只能在 Story Gate PASS 后负责表达，不负责重新决定骨架。

## 7. Topic Worker Recommendation

由于当前 canonical Skill 未发现，Topic Worker 暂不直接新建完整 Skill。

先把 `docs/CONTENT_STRATEGY_AND_CONVERSION.md` 与 `schemas/topic_opportunity.schema.json` 作为 Topic Contract。

下一步 G2 MVP 时，由 Showrunner 自身按此 Contract 生成候选并验证。

只有当至少 3 个真实 episode 证明 contract 稳定、输入来源稳定、reject reasons 重复、历史账本确实需要独立运行，才考虑抽成 reusable Topic Skill。

避免“还没验证就先造 Skill”。

## 8. Current Candidate Worker Map

| Stage | Current role | Candidate capability | Status |
|---|---|---|---|
| Signal | AI/public signals | Web / future signal sources / entertainment-rander optional | OPEN |
| Topic | TopicOpportunity | Showrunner contract-first | PROVISIONAL |
| Knowledge | mechanism + evidence | Showrunner / research worker | OPEN |
| Story | causal story structure | Showrunner Story Engine Gate | PROVISIONAL |
| Writer | spoken story + SRT | jingsui via project adapter | STRONG CANDIDATE |
| Director | exact shot decomposition | project low-level compiler | TO_DEFINE |
| Character/Scene | consistency locks | project compiler + references | TO_DEFINE |
| Execution | batch image + timeline assembly | Antigravity + Nano Banana | FROZEN ROLE / INTEGRATION UNKNOWN |
| QA | Story/Knowledge/Visual/Production | Showrunner Reviewer | PROVISIONAL |
| Learning | traffic/trust/conversion diagnosis | acquisition-growth-radar adapter | STRONG CANDIDATE |

## 9. Worker Admission Rule

任何候选 Worker 进入正式 registry 前必须证明：输入 Contract 明确；输出能被下一 Stage 直接消费；不覆盖 locked upstream fields；失败状态可识别；不需要 Owner 做技术判断；至少一个真实 episode 有质量证据；可记录版本 / provenance。

未满足时只能是 `CANDIDATE`，不能写成 canonical Worker。

## 10. Next Validation

G1 剩余关键问题：

1. 冻结 Episode Package machine-readable schema；
2. 为 Jingsui Writer Adapter 建立正式字段 mapping；
3. 为 acquisition-growth-radar Learning Adapter 建立正式字段 mapping；
4. 定义 Director / Shot Compiler schema；
5. 确认 Antigravity 技术集成级别；
6. 设计 AUDIO_MODE A/B 最小 PoC。

完成后才能 Reviewer PASS G1。