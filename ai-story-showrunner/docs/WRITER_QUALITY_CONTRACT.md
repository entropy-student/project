# Writer Quality Contract v0.1

## 1. Purpose

G3 的目标不是“把 StoryPremise 改写成顺口文案”，而是验证：

> **Writer 能否在不破坏 locked KnowledgeCore / StoryPremise 的前提下，把故事写成短视频里真正值得听完的口播。**

---

## 2. Four-Layer Writing Model

### Layer A — McKee Causality

负责故事骨架，不负责文风。

必须保留：
- protagonist desire；
- inciting incident；
- action；
- expectation / result Gap；
- progressive complications；
- turning point；
- recognition；
- choice / payoff。

Writer 不得把因果骨架压成“举三个例子 + 总结定义”。

### Layer B — Narrative Transportation

负责让观众进入故事，而不是站在故事外听解释。

优先：
- 可见人物；
- 可见动作；
- 具体地点 / 物件；
- 时间压力 / 代价；
- 人物反应；
- 可想象的结果。

抽象解释必须尽量附着在已经发生的事件之后。

### Layer C — Short-form Retention

负责让短视频从第一秒持续推进。

规则：
1. 第一拍直接进入异常事件 / 冲突，不自我介绍；
2. Hook 必须来自真实故事，不允许骗点；
3. 每个 beat 至少新增一种东西：action / consequence / information / judgment / reversal；
4. 禁止同一观点换三种说法重复；
5. 最强冲突不要拖到最后才出现；
6. payoff 必须兑现开头提出的问题；
7. 不强制 CTA，没有自然下一步时干净结束。

### Layer D — Jingsui Voice

负责口语气质。

保留：
- 具体人物优先；
- narrator / character 是当事人，不是老师；
- thesis delay；
- 1–2 个梗母题；
- 事实 → 反应 → 后果 → riff → 新变化；
- 长短句混合；
- 演讲腔黑名单。

覆盖 / 禁用：
- 固定“大家好，我是……”；
- 固定英文尾签；
- 为了像景岁而硬插自我修正；
- Writer 自带 Visual Beat / image prompt / edit plan；
- 150–240s native duration assumption。

---

## 3. G3 Validation Timing

首轮验证默认：

- target duration: **70–85 seconds**；
- planning speaking rate: **5.0 spoken Chinese chars/s**；
- target spoken chars: roughly **350–425**；
- actual TTS / real voice later overrides estimate。

理由：
- 比 45–60s 留出足够因果空间，避免故事刚开始就被迫讲定义；
- 又足够短，仍能用于抖音 / 小红书 / Shorts 类短视频验证；
- 后续真实 retention 数据再校准。

这不是永久标准。

---

## 4. Story Information Ratio

每段口播必须属于以下之一：

- EVENT — 新动作 / 新事实发生；
- CONSEQUENCE — 动作产生代价；
- REACTION — 人物真实反应；
- REVERSAL — 预期被打破；
- RECOGNITION — 人物终于理解机制；
- PAYOFF — 结局兑现。

纯解释句只能作为这些事件之间的桥。

如果连续出现 3 句以上纯解释：
`RETURN_WRITER_BECAME_EXPLAINER`

---

## 5. Reveal Rule

术语默认后置。

推荐顺序：

具体事件
→ 第一次 Gap
→ complication
→ audience forms intuition
→ turning point
→ reveal technical name
→ one-sentence mechanism
→ payoff

禁止在观众尚未形成直觉前连续解释 Host / Client / Server / Tool / Context 等术语。

---

## 6. Humor Rule

幽默服务于：
- character reaction；
- situation absurdity；
- recurring metaphor。

不要求每 5 秒一个笑点。

一篇优先 1 个主梗 + 最多 1 个副梗。

笑点不得：
- 引入未经核验事实；
- 打断因果；
- 把人物变成吐槽机器；
- 为了网络感使用即将过期的梗。

---

## 7. Spoken-Language Gate

文案必须能直接说出来。

优先：
- 一个句子只承载一个主要意思；
- 代词有明确对象；
- 专有名词第一次出现顺手解释；
- 抽象名词连续不超过 2 句；
- 句子长度自然变化。

降权：
- “首先 / 其次 / 最后”；
- “本质上”；
- “归根结底”；
- “真正的问题是”；
- “很多普通人的问题是”；
- “你需要的是”；
- 大段定义式排比。

---

## 8. Writer Invariants

Writer 不得改变：
- locked AI mechanism；
- key facts；
- causal story skeleton；
- protagonist desire；
- turning point meaning；
- content job；
- conversion intent。

允许压缩：
- 重复 action；
- 次要例子；
- 非核心术语；
- 原 StoryPremise 中为审查服务的说明。

---

## 9. Script Gate

### Hook
- 第一拍是不是事件？
- 不知道技术名也能理解吗？
- 是否提出真实未解决问题？

### Story
- 主角是否在做事，而不是听课？
- 每个 complication 是否升级，而不是重复？
- Gap 是否清楚？
- 有具体代价吗？

### Knowledge
- mechanism 是否准确？
- reveal 是否只用必要术语？
- 是否新增 KnowledgeCore 外事实？

### Retention
- 是否有连续重复解释？
- 是否把最有趣内容拖太晚？
- 是否每个 beat 有推进？

### Payoff
- 是否回应 Hook？
- 结局是否来自人物选择 / 机制？
- 是否自然结束而非突然上价值？

### Voice
- 是否像人在讲经历？
- 是否出现演讲腔 / PPT腔？
- 是否为了俏皮牺牲清晰度？

---

## 10. SRT Gate

SRT 必须从 locked script 派生，不重写。

首轮无真实音频时：
- 使用 5.0 chars/s 估算；
- 按完整意群切；
- 默认单 cue 约 1.4–3.5s；
- punchline / reveal 可适当留白；
- 时间连续、不重叠。

真实 TTS/配音生成后必须重新对齐。

---

## 11. External Basis

- Robert McKee：Gap between expectation and result / progressive story causality。
- Green & Brock (2000)：narrative transportation — imagery, affect, attentional focus。
- YouTube official creator guidance：Appeal / Engagement / Satisfaction；intro promise alignment；retention-based iteration。
- Jingsui v3.4：event-first、thesis delay、specific-person-first、riff chain。
- short-form-spoken-script v0.1.3：one promise、progress not repetition、write for the ear、Script→SRT derivation。

---

## 12. Admission Rule

Jingsui Writer Adapter 只有在至少三个不同机制 episode 中：
- 不改变 KnowledgeCore；
- 不改变 StoryPremise 核心因果；
- 文案不退化成教程；
- 能稳定生成可直接口播的 Script + SRT；

才从 STRONG CANDIDATE 升为 canonical Writer Worker。