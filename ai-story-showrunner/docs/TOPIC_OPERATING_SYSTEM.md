# Topic Operating System v0.2

## 1. Purpose

在进入 G3 Writer 之前，先解决三个基础问题：

1. 选题从哪里来；
2. 如何先从普通人已经关心的世界里找到值得追问的 WHY，而不是只从 AI 名词/新闻出发；
3. 如何避免 Topic / Angle / Story Motif 重复。

本系统的目标不是“每天随机生成一个 AI 概念”，而是：

> **持续捕获真实需求与新鲜信号，并从一个有历史、有去重、有反馈的内容资产池里选择下一期。**

### v0.2 Entry Principle — Human-world-first

v0.2 不推翻 HOT / EVERGREEN，也不推翻 Human Relevance / Mechanism / Storyability；只把 **Topic Supply 的第一入口往人类世界前移一层**。

旧的默认路径：

```text
AI Signal / AI Problem
→ Audience Translation
→ Human Problem
→ Mechanism
→ Story
```

v0.2 默认优先路径：

```text
大众兴趣 X / 现实生活现象
→ Observed Paradox（本应 A，却出现 B）
→ WHY（为什么会这样）
→ Human Tension（两种都合理的力量发生冲突）
→ AI Changed Process（AI 改变/压缩/放大了哪个人的过程）
→ AI / Domain Mechanism
→ Human Stakes
→ Story
```

内部短口令：

> **X → Paradox → WHY → Human Tension → AI Mechanism → Story**

关键约束：

- X 必须在没有 AI 术语时仍值得普通人关心；
- WHY 必须是真问题，不是知识标题换成问号；
- Human Tension 不是预设结论，而是可被故事测试的矛盾；
- AI 仍必须进入因果链，不能只是热点标签或装饰；
- 现有 `Controlling Question First → Idea vs Counter-Idea → Climax proves` 规则继续有效，不在 Topic Stage 把立意写死。

---

## 2. Core Model — Two-Lane Topic Supply

### Lane A — HOT / Event-driven

适合：
- 新模型 / 新产品 / 新能力；
- 大厂重要产品更新；
- Agent / AI 行为引发的现实事件；
- 社会广泛讨论的 AI 问题；
- 明显跨平台搜索 / 讨论增长。

规则：

> 热点不是“新闻就讲”，而是“热点能否被翻译成一个普通人的长期问题”。

Hot candidate 必须同时通过：
- freshness / evidence；
- audience fit；
- Human Relevance；
- one mechanism；
- storyability；
- production latency < topic half-life；
- duplicate gate。

只要热点失败任一 Hard Gate，就不抢占常规选题。

### Lane B — EVERGREEN / Problem-driven

当没有合格热点，或热点与账号受众不匹配时，从 Evergreen Bank 选。

来源：
- 高频 AI 使用困惑；
- AI 的反直觉行为；
- 长期稳定概念；
- 评论 / 搜索 / FAQ；
- 过去内容留下的未解决问题；
- AI 工作流中反复出现的真实摩擦；
- 技术机制导致的长期社会 / 工作变化。

Evergreen 不等于“百科概念”。

优先形式：

> **我已经遇到这个现象，但一直不知道为什么。**

例如：
- 为什么 AI 刚才记得，过几天又忘了？
- 为什么给 AI 更多资料，有时反而回答更差？
- 为什么 AI 能告诉你怎么做，却不能直接替你做？
- 为什么 AI 搜到了网页仍然会答错？

---

## 3. Signal Sources

### A. First-party AI sources — highest factual authority

- OpenAI / Anthropic / Google DeepMind / major model labs official releases；
- product docs / API changelogs；
- official research；
- major open-source project releases。

用于回答：
- 什么真的变了；
- 机制是什么；
- 时间是否新鲜。

### B. Trend aggregators — discovery layer

可参考 / 接入：
- Conradgui/AI-TREND-RADAR
- sansan0/TrendRadar

用途：
- 多源 AI 信号聚合；
- GitHub / Hacker News / arXiv / Hugging Face / Product Hunt / 国内技术媒体；
- 多平台热点；
- 历史快照；
- freshness / persistence / cross-platform signals。

**只作为 Signal Collector，不直接继承它们的 topic scoring。**

尤其 AI-TREND-RADAR 的“商业影响40 + 热度30 + 新鲜度20 + 可写性10”更偏产品/行业研究，不等于本账号的内容传播目标。

### C. Platform demand signals

- 小红书热点 / 搜索趋势；
- 抖音热点 / 相关消费反馈；
- B站搜索 / 热榜 / 相关视频；
- YouTube / Google search interest（如目标平台适用）。

### D. Owned audience signals — eventually highest-value

有真实发布数据后优先加入：
- comments；
- saves；
- search terms；
- DMs / questions；
- profile behavior；
- related videos / audience watches；
- repeated user misconceptions。

---

## 4. Topic Pipeline

RAW HUMAN / AI SIGNALS
→ NORMALIZE / CLUSTER
→ X DOMAIN / HUMAN SITUATION
→ OBSERVED PARADOX
→ WHY + HUMAN TENSION
→ AI CHANGED PROCESS / DOMAIN MECHANISM
→ CANONICAL TOPIC CANDIDATE
→ HARD GATES
→ DUPLICATE GATES
→ REACH + ASSET EVALUATION
→ HOT OVERRIDE ? EVERGREEN PICK
→ CALENDAR
→ EPISODE
→ METRICS / LEARNING
↺

---

## 5. What Is a “Good Topic”?

不要用单一总分先决定。

### v0.2 Pre-Gates — 先判断“值不值得成为故事问题”

在旧 Hard Gates 之前先检查：

1. **Native X Interest** — 暂时不谈 AI，这个生活领域/现象本身有人关心吗？
2. **WHY / Paradox** — 是否存在“本来应该 A，为什么却 B”或“解决了 A，为什么又失去 B”的认知缺口？
3. **Human Tension** — 背后是否至少有两种都说得通的力量，而不是一边天然正确、一边天然愚蠢？
4. **Changed Process** — 能否指出 AI 改变、压缩、替代或放大了哪个原本属于人的过程？

推荐先写：

```text
X:
Observed Paradox:
WHY:
Human Tension:
Controlling Question Seed:
Human Process Before AI:
AI Changed Process:
```

这些字段用于选题发现与故事潜力判断，不替代后续事实核验，也不允许提前锁死观点答案。

### Hard Gates

必须先过：
1. Evidence — 事实可核验；
2. Human Relevance — 不懂技术也会关心；
3. Mechanism Integrity — 有一个值得理解且准确的核心机制；
4. One Mechanism — 一条视频默认只解决一个核心机制；
5. Storyability — 能形成欲望、障碍、后果和转折；
6. Non-trivial Payoff — 看完不只是“AI 可以做 X”；
7. Audience Fit — 与账号目标受众相关；
8. Duplicate Gate — 不是近期同题同角度换皮。

通过后再比较两个维度。

### Reach Potential

回答“有没有机会获得陌生流量”。

观察：
- Demand evidence：搜索/热点/近期讨论是否存在；
- Salient question：标题能否激活一个清晰问题；
- Curiosity gap：知道 enough to care，但不知道答案；
- Surprise / contrast：是否违背自然预期；
- Emotional activation：惊讶、担心、兴奋、荒诞、认知冲突；
- Shareability：观众是否会想“这个你也应该知道”；
- Platform fit：是否符合平台当前用户消费方式。

### Asset Value

回答“这条内容对账号长期有没有价值”。

观察：
- Practical / mental-model value；
- Trust building；
- Search longevity；
- Evergreen lifespan；
- Differentiation；
- Conversion adjacency；
- Series potential；
- Reusability in future stories。

### Important

高 Reach ≠ 高 Trust。
高 Trust ≠ 高 Conversion。
热点 ≠ 好选题。
技术重要 ≠ 用户会看。

---

## 6. Evidence Behind the Framework

### Platform evidence

Douyin 官方“精选优质内容指南”强调：获得感、惊喜感、表达力、感染力，并强调专业、真实、有事实依据、满足好奇、解答困惑、独特角度。

Xiaohongshu 热点榜公开规则同时考察：搜索热度、传播热度、互动热度、点击率。

YouTube 官方内容策略建议：分析观众正在看什么，用 search / Trends / audience interest 找内容机会；不要长期只追热点；寻找可重复、可持续的内容模式。

### Research evidence

Loewenstein 的 Information Gap Theory：好奇来自“我意识到自己缺一块关键知识”。

Aubin Le Quéré & Matias，Scientific Reports 2025：对 8,977 个 headline experiments 的 meta-analysis 表明，太模糊和太具体都可能降低点击，中等程度的信息提供更可能形成有效 curiosity gap。

Qiu & Golman 2024：100,000+ 微信新闻研究中，salient question、importance、surprisingness 能帮助预测点击；但点击和点赞率之间出现轻微负相关，说明“让人点”不自动等于长期满意。

Berger & Milkman 2012：surprisingness、interestingness、practical utility，以及高唤醒情绪与传播相关。

---

## 7. Duplicate System — Four Levels

“没讲过这个名词”不等于不重复。

### D1 — Signal Duplicate

同一新闻 / URL / 同一事件多家媒体转载。canonicalize 后合并。

### D2 — Topic Duplicate

相同：AI mechanism + human problem + audience payoff。

例如“为什么 AI 会忘记我”和“AI 为什么记不住上次聊天”，如果同机制 + 同 human problem + 同 payoff，视为同一 canonical topic。

### D3 — Angle Duplicate

技术题不同，但实际讲的是同一个人类问题。

### D4 — Story / Visual Motif Duplicate

相同老板+秘书、老师+学生、左右对比、同一个办公室、同一种误会→解释结构等都要记录。

---

## 8. Topic Fingerprint

每个 canonical topic 建议保存：

topic_id
aliases
topic_entry_mode
x_domain
observed_paradox
why_question
human_tension
ai_changed_process
mechanism_family
mechanism
human_problem_family
human_problem
stakes
audience_payoff
search_anchor
content_job
story_motif
hook_pattern
visual_motif
source_signals
first_seen
last_considered
last_published
status
revisit_reason
performance

核心判重键：mechanism + human_problem + audience_payoff。

额外表层判重：story_motif + hook_pattern + visual_motif。

---

## 9. Revisit Rules

允许重讲：
1. Mechanism changed materially；
2. New human consequence；
3. Different audience；
4. Different content job；
5. Previous episode created unresolved demand；
6. Major new hotspot makes old mechanism newly relevant。

不允许：只是因为今天没题，所以把同一个故事换个标题再发。

---

## 10. Calendar vs Ledger

### Calendar
回答：哪天准备讲什么？
建议：topic-ledger/calendar/YYYY-MM.md

### Topic Registry
回答：这个题以前见过吗？讲过吗？从什么角度讲过？效果怎样？
这是防重复的核心。
建议：topic-ledger/topic-registry.jsonl

### Daily Radar
回答：今天出现了什么新信号？
建议：topic-ledger/daily/YYYY-MM-DD.json

> **Calendar 不能代替 Ledger。**

---

## 11. Daily Task Recommendation

推荐建立每日自动任务，但职责限定为 Daily Topic Radar：
1. 扫描新 AI signals；
2. 聚类 / 去重新闻；
3. 对照 Topic Registry；
4. 转换为 TopicOpportunity candidate；
5. 输出 Hot candidates；
6. 如果无合格 Hot，推荐 1–3 个 Evergreen candidate；
7. 记录当天 snapshot；
8. 不自动发布，不自动把候选标记为 published。

每日任务是“雷达 + 编辑助理”，不是“总编辑”。

建议另加 Weekly Review：回顾发布、更新 Topic Registry、发现表现规律、补 Evergreen Bank、检查覆盖缺口和 motif repetition。

---

## 12. Scheduling Logic

Hot candidates exist?
→ yes
Any candidate passes ALL hard gates + audience fit + duplicate gate + can publish within useful half-life?
→ yes: Choose Hot
→ no: Choose Evergreen Bank candidate

不要设“今天必须讲热点”。
正确规则：**合格热点拥有抢占权。**

---

## 13. Evergreen Topic Map

v0.1 的 AI 机制家族池继续保留，作为 **Mechanism Supply**；v0.2 在它前面增加 **Human-world Supply**。

长期选题优先通过以下组合扩展：

```text
Human Interest Domain
× Human Tension
× AI Changed Process
× Mechanism Family
```

例如：
- 美食 × 最优/探索 × 推荐筛选 × ranking/recommendation；
- 恋爱 × 正确表达/真实暴露 × 语言生成 × generative assistance；
- MBTI × 被理解/被定义 × 个性分析 × classification/inference；
- 工作 × 效率/掌控 × Agent 代办 × delegation/guardrails。

原有机制家族继续有效：
1. Context / Memory / Retrieval
2. Reasoning / Hallucination / Uncertainty
3. Tools / API / MCP / Interoperability
4. Agents / Delegation / Guardrails / Approval
5. Search / RAG / Knowledge
6. Multimodal — vision / voice / video
7. Training / Fine-tuning / Distillation / RL
8. Evaluation / Safety / Privacy / Security
9. Coding / Computer Use / Workflows
10. AI-driven social / work changes

但 Topic 不能直接从机制名生成，必须先转换为 human situation / observable puzzle。

---

## 14. Best Acquisition Topic Archetypes

### A. Felt-but-unexplained
用户已经遇到，但不知道为什么。

### B. Expectation Violation
AI 做出的结果违背用户自然预期。

### C. Delegation / Control Conflict
涉及“要不要把事情交给 AI”。

### D. Hot Event → Durable Mechanism
新闻只是入口，最后解释长期机制。

### E. Cost / Time / Risk Surprise
对现实结果有明显代价。

---

## 15. Topic Types to Deprioritize

- 纯“什么是 X”；
- benchmark 数字大战；
- 公司融资 / 人事新闻但无 human consequence；
- 模型参数更新但普通人感受不到；
- 泛泛“AI将改变未来”；
- 仅因为技术圈热、普通用户没有 stakes；
- 已讲过机制 + 同样的人类问题 + 同样故事母题。

---

## 16. Initial Portfolio Principle

早期账号以建立 audience model 为主：
- DISCOVERY：获取陌生受众；
- TRUST：解释用户已经感受到的问题；
- SOLUTION：只在真实需求与承接路径存在时使用。

不在没有数据时锁死固定百分比。

---

## 17. External Project Reuse Decision

### AI-TREND-RADAR

推荐：**借采集与历史结构，不借它的最终评分。**

可复用：15+ public sources、daily digests、topic-pool.json、historical search index、GitHub Actions daily/weekly/monthly、source degradation、evidence provenance。

我们的额外层：human problem、one mechanism、curiosity、storyability、duplicate fingerprints、content job、conversion adjacency。

### TrendRadar

推荐作为：泛平台热点、RSS、timeline、cross-platform persistence、new trend detection。

不直接作为 AI technical truth source。

---

## 18. Current Decision

在进入 G3 前，项目插入：

`G2.5 — Topic Supply / Ledger / Dedup`

Acceptance:
- Hot + Evergreen two-lane supply frozen；
- topic registry format frozen；
- daily snapshot format frozen；
- duplicate rules frozen；
- scheduling rule frozen；
- external source policy frozen；
- automation design frozen，但不要求本 Gate 就开启 scheduled execution。

完成 G2.5 后再进入 Writer。

---

## 19. v0.2 Backward Compatibility / Rollback

- 已有 `topic-ledger/topic-registry.jsonl`、Calendar、Daily snapshots 和历史 TopicOpportunity **不追溯改写**；
- 旧的 `AI Signal → Audience Translation → Human Problem` 路径仍是合法 fallback，尤其适用于强 AI 热点或 Owner 明确指定的 AI 题；
- 新字段以 backward-compatible 方式加入 Schema，历史 artifact 不因缺少 v0.2 字段而失效；
- G3+ 的 Controlling Question / Idea vs Counter-Idea / Story / Writer / Director 规则保持不变；
- 本次变更只升级 Topic Supply / Topic Opportunity 的发现入口，不修改当前 G6A 生产执行线；
- 回滚基线：GitHub branch `rollback/ai-story-showrunner-topic-os-v01-20260927`，基于变更前 main `16e2c86039a26175f99204239c19c1bdf35f4a10`。
