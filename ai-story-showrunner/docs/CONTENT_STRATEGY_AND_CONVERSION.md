# Content Strategy & Conversion Contract v0.2

> **G3R STATUS: PROPOSED / OWNER REVIEW.** The Bilibili-first additions in this revision do not become accepted canonical policy until Owner PASS.

## 1. Purpose

本文件定义 AI Story Showrunner 的内容业务目标：

> 不只生产“能看的 AI 故事”，而是稳定生产同时具备 **Attention、Trust、Commercial Adjacency** 的内容资产。

它约束 Topic Worker、Story Engine、Writer、QA 和 Publish/Learning，但不允许商业目标越级破坏知识准确性与故事完整性。

---

## 2. Content Thesis

核心内容公式：

```text
现实变化 / AI Signal
→ 普通人处境
→ 人类冲突
→ 故事推进
→ AI机制自然显现
→ 观众获得判断 / 方法
```

不是：

```text
AI概念
→ 包装成故事
→ 结尾硬塞产品
```

### 三种价值同时存在

每个 TopicOpportunity 分别评估：

1. **Attention Value**：陌生用户为什么愿意点进来并继续看；
2. **Trust Value**：为什么看完会觉得这个账号值得继续关注；
3. **Conversion Adjacency**：这个问题未来能否自然通向工具、教程、服务或产品需求。

三者不能互相冒充。

---

## 3. Three Content Jobs

视频制作形式可以完全相同，但每一期必须先声明其主要业务任务。

### DISCOVERY

目标：扩大陌生流量池。

特征：
- 强人类处境；
- 强异常 / 好奇缺口；
- 技术术语可晚揭示；
- 更重开头与故事推进。

典型问题：
- “为什么 AI 明明知道答案，却不能直接替你把事情办了？”
- “为什么它昨天还记得你，今天突然像失忆？”

成功主要看：
- 点击 / 开头留存；
- 中段留存；
- 新观众比例；
- 有效播放。

### TRUST

目标：建立“这个账号真的理解 AI，而且能讲清楚”的认知。

特征：
- 更强调机制边界；
- 允许更完整的因果解释；
- 需要形成独立 mental model；
- 尽量让观众看完后能判断真实问题。

成功主要看：
- 完播；
- 收藏；
- 关注；
- 有质量评论；
- 概念复述 / 追问。

### SOLUTION

目标：把已经存在的问题意识，进一步推进到“我需要方法 / 工具”。

特征：
- 仍然先解决用户问题，不做硬广；
- 题目天然靠近实际行动；
- 可以出现 workflow、判断框架、工具选择或产品解决路径；
- CTA 必须和故事中的问题同源。

成功主要看：
- 主页访问；
- 资料 / 工具点击；
- 私信 / 咨询；
- 注册 / 使用；
- 付费或其他 downstream action。

### Rule

一条视频可以有 secondary role，但只能有 **一个 primary_content_job**。

---

## 4. Topic Opportunity Contract

一个 TopicOpportunity 至少包含：

```yaml
topic_id:
signal:
why_now:
human_problem:
human_stakes:
ai_mechanism:
one_mechanism_only:
story_seed:
curiosity_gap:
audience_payoff:
search_anchor:
primary_content_job:
secondary_content_job:
conversion_adjacency:
conversion_path_hypothesis:
visual_storyability:
novelty_vs_history:
repetition_risk:
source_refs:
uncertainties:
```

### conversion_adjacency

不是“这条视频要卖什么”，而是：

> 如果大量观众确实有这个问题，未来可能自然需要什么解决方案？

可选值：

```text
NONE
LOW
MEDIUM
HIGH
UNKNOWN
```

示例：

- Transformer 数学结构 → LOW；
- AI Memory / Context 管理 → HIGH；
- Agent 权限边界 → HIGH；
- 某公司单次融资新闻 → 通常 LOW，除非能映射到长期人类问题。

---

## 5. Hard Gates Before Scoring

以下任一失败，Topic 直接 RETURN，不参与“高分补偿”。

### GATE A — Human Relevance

删掉 AI 公司名 / 产品名后，普通人仍有理由关心。

### GATE B — Mechanism Integrity

至少有一个准确、值得讲的 AI 机制，而且能够成为故事因果规则。

### GATE C — Storyability

存在：
- desire；
- obstacle；
- consequence；
- gap / reversal；
- visualizable action。

### GATE D — One Mechanism

默认一条视频只承担一个核心机制。

如果必须同时解释多个机制才能成立：
`RETURN_TOPIC_TOO_DENSE`

### GATE E — Non-Trivial Payoff

观众看完不能只得到“AI 很厉害 / AI 可以做 X”。

---

## 6. Topic Evaluation Dimensions

通过 Hard Gates 后再评估：

| Dimension | Question |
|---|---|
| Human Tension | 不懂 AI 的人也会在意吗？ |
| Curiosity Gap | 第一幕是否天然制造“然后呢”？ |
| Why Now | 为什么现在值得看？ |
| Mechanism Value | 看完是否建立正确 mental model？ |
| Visual Storyability | 是否容易变成一串具体动作/画面？ |
| Search Value | 是否存在可承接搜索需求的术语/问题？ |
| Trust Value | 是否能体现账号真正理解机制？ |
| Conversion Adjacency | 是否靠近真实可解决需求？ |
| Novelty | 与近期内容是否重复？ |
| Production Fit | 是否适合当前多图静态镜头方法？ |

### Important

评分只用于：
- 比较多个已通过 Hard Gate 的候选；
- 发现某题强项和短板；
- 决定 primary_content_job。

禁止仅凭一个总分自动发布。

---

## 7. Hook Contract

第一帧 / 第一事件优先是：

> **异常事件、决定、冲突或结果。**

避免默认从以下内容开始：

- “今天给大家介绍……”
- “最近 AI 圈很火……”
- “什么是 MCP？”
- 公司历史 / 定义 / 背景介绍。

### Hook Test

第一段在不知道技术名词时仍能制造：
- unanswered question；
- expectation gap；
- immediate consequence。

---

## 8. Story-to-Mechanism Ratio

故事不是装饰，机制也不能淹没故事。

默认结构倾向：

```text
先进入事件
→ 冲突持续升级
→ 观众先形成直觉
→ 再揭示机制 / 术语
→ 最后给判断或行动
```

不强制固定百分比，但禁止：
- 前半段完全讲定义；
- 人物只是听课工具；
- 结尾突然抛一段百科解释。

---

## 9. Visual Repetition Gate

角色一致 ≠ 每一期视觉一致。

每条视频在 Final QA 前检查最近内容中的重复：

- 相同开场构图；
- 相同人物站位；
- 相同“左 A 右 B”模板；
- 相同背景；
- 相同 punchline reaction；
- 相同镜头长度节奏；
- 相同视觉隐喻；
- 同一个故事母题过度复用。

### PASS

允许固定：
- 角色长相；
- 世界美术语言；
- 常驻场景；
- 字幕系统。

必须变化：
- 事件状态；
- 表演；
- 构图；
- 场景组合；
- 冲突表达。

### Fail

`RETURN_VISUAL_REPETITION`

回到 Director / Story，而不是让 Antigravity 自己发挥。

---

## 10. Fixed Cast, Flexible World

长期推荐：

> **固定演员班底 + 半固定世界，而不是强制所有故事发生在同一个“小岛/小镇”。**

可以长期积累：
- recurring characters；
- character relationships；
- signature expressions；
- canonical locations；
- props。

但故事可以发生在：
- 家；
- 公司；
- 学校；
- 商店；
- 机场；
- 银行；
- 未来城市；
- 其他符合剧情的环境。

目标是形成辨识度，而不是形成世界观负担。

---

## 11. Platform Packaging Layer

核心视频可以共用，但平台包装允许独立。

### Short-feed platforms

优先：
- 异常事件；
- 快速进入冲突；
- 技术名词后置；
- 第一屏可理解。

### Search-heavy surfaces

标题 / 文案可以保留：
- 人类问题作为自然语言入口；
- AI 技术词作为 search anchor。

例如：

```text
AI为什么明明知道答案，却不会帮你做事？｜MCP
```

### Long-form surfaces

可基于同一 Story / Asset Set 扩展：
- 更完整机制；
- 更多证据；
- 边界与例外；
- 实践方法。

---

## 12. Metrics Ledger

禁止用“播放量”作为单一成败指标。

每条内容分别记录三层结果。

### Traffic Metrics

- impression / exposure；
- click / play start；
- early retention；
- mid retention；
- completion；
- new audience share（能获取时）。

### Trust Metrics

- saves；
- follows；
- qualified comments；
- meaningful questions；
- concept recall / user restatement（能观察时）；
- repeat viewers（能获取时）。

### Conversion Metrics

- profile visits；
- link / resource click；
- DM / inquiry；
- signup；
- tool usage；
- purchase / qualified lead；
- downstream action。

### Rule

```text
High traffic + low trust != content success
High trust + low conversion != product failure
Low traffic + high conversion != discovery success
```

必须先判断该内容的 primary_content_job。

---

## 13. Content → Product Discovery Loop

内容系统不仅为现有产品获客，也用于发现产品需求。

```text
Episodes
→ Comments / Saves / Search / DMs
→ Repeated Problem Clusters
→ Demand Hypothesis
→ Solution / Tool Opportunity
→ Validate
→ Product
→ Solution Content
```

重点记录：
- 反复出现的问题；
- 用户已有 workaround；
- 用户愿意投入的时间 / 金钱；
- 用户主动询问的工具；
- 哪种问题会产生行动。

不要因为一条高播放视频立即做产品。

---

## 14. Conversion Principle

默认禁止硬转化：

```text
有趣故事
→ 突然“点击主页购买”
```

推荐：

```text
故事暴露问题
→ 观众理解问题
→ 账号持续建立判断力
→ 观众遇到同类问题
→ 发现账号已有对应解决方案
```

CTA 必须是故事结果的自然延伸。

---

## 15. Optimization Priority

当前项目资源优先级冻结为：

```text
Topic / Opportunity System
>
Story System
>
Low-Level Director Compiler
>
Antigravity Execution Automation
```

视频执行层只需稳定、可复现、低操作。

核心竞争力优先沉淀在：
- 什么值得讲；
- 怎么翻译成人类处境；
- 怎么构成故事；
- 怎么形成高留存视觉状态序列；
- 怎么从真实反馈发现需求。


---

## 16. Bilibili-first Editorial Operating Model

Canonical channel strategy is defined in:
`docs/BILIBILI_CHANNEL_STRATEGY.md`

Primary platform: **Bilibili**  
Editorial target: **daily publishing**  
Production throughput: **UNPROVEN until G4–G7**

Business jobs remain:
`DISCOVERY / TRUST / SOLUTION`.

They are now explicitly separate from editorial format:

`STORY_MODEL / STORY_ACTION / STORY_TUTORIAL`.

### Season 0 hypothesis

First 21 published episodes are a calibration season.

Initial 7-day mix:
- 4 × STORY_MODEL
- 2 × STORY_ACTION
- 1 × STORY_TUTORIAL / real experiment

This is a test portfolio, not a permanent quota.

### Early growth priority

Per Acquisition Growth Radar, the current bottleneck is expected to be:

`Audience / Situation × Message / Creative Fit`

not offer or conversion optimization.

Therefore:
- Discovery + Trust dominate;
- actionable value is encouraged when natural;
- tutorials are used to test high-intent demand;
- early content must not be distorted around a hypothetical future product.

### Bilibili evidence fields

Prefer platform-native evidence:
- average watch duration;
- audience retention curve;
- play-to-follow rate;
- saves / coins / comments;
- audience/fan interest;
- qualified questions and repeated problem clusters.

Views remain Attention evidence only.
