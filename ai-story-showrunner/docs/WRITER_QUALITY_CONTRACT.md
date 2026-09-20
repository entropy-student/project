# Writer Quality Contract v0.4 — Bilibili-first

> **G3R STATUS: PASS.** This is the canonical Bilibili-first Writer Quality Contract for the current editorial baseline.

Canonical narrative-style layer: `docs/NARRATIVE_STYLE_CONTRACT.md`

## 1. Purpose

G3 的目标不是“把 StoryPremise 改写成顺口文案”，而是验证：

> **Writer 能否在不破坏 locked KnowledgeCore / StoryPremise 的前提下，把故事写成在 Bilibili 上本身值得看完、又能真正理解 AI 的 IP 叙事。**

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

### Layer C — Narrative Retention

负责让视频从第一段开始持续推进；不再以短视频压缩为默认前提。

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

## 3. Platform / Duration Baseline

### Historical validation note

G3 的 70–85s 三篇稿件只用于验证 Writer 是否会破坏 Story / KnowledgeCore。

它们现在统一降级为：

`SHORT_FORM_WRITER_VALIDATION_REFERENCE_ONLY`

### Bilibili-first planning bands

- HOT / timely story: **3–5 min**
- standard story episode: **3–5 min**
- exceptional deep story: >8 min only when later retention evidence supports it

Duration is decided by narrative requirements, not filled to a quota.

Editorial target is DAILY, but one-episode-per-day production throughput remains unproven until G4–G7.

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

Jingsui-derived Writer Style / Adapter baseline 只有在至少三个不同机制 episode 中：
- 不改变 KnowledgeCore；
- 不改变 StoryPremise 核心因果；
- 文案不退化成教程；
- 能稳定生成可直接口播的 Script + SRT；

才从 STRONG CANDIDATE 升为 **canonical Writer Style Source / restricted adapter baseline**。

G3R 已通过三题质量验证，因此当前：
`JINGSUI_STYLE_SOURCE = CANONICAL`.

这不等于程序化 Writer orchestration 已经跑通。

Runtime / orchestration status 仍单独保持：
`QUALITY_VALIDATED / MANUAL_ORCHESTRATION`

直到未来 Gate 有真实机器编排证据。

---

## 13. Channel IP / POV Contract

Default narrator is the recurring **first-person channel IP**.

Preferred narrative relation:

```text
I experience / choose
→ world and recurring characters react
→ viewer recognizes the same problem
```

POV routing:
- first person: default for channel identity and story experience;
- third person: real external cases / supporting characters;
- second person: sparingly for mental simulation or returning the question to the viewer.

Trust boundary:
- channel IP may be fictional/stylized;
- do not fabricate real-world personal tests, purchases, employment, losses or first-hand experience;
- fictional simulation must remain legible as the channel’s story world.

## 14. Editorial Mode Contract

Business Job and Editorial Mode are separate.

Allowed editorial modes:

- `STORY_MODEL` — story → mechanism → mental model / judgment
- `STORY_ACTION` — story → mechanism → practical decision/action

Every episode must select exactly one primary editorial mode.

### Actionability Gate

Add an action/method section only when all are true:
1. the action follows directly from the locked mechanism;
2. it is stable and evidence-based;
3. it does not require an unrelated second mechanism;
4. it naturally resolves or extends the story problem.

Otherwise end with a strong mental model.

Failure:
`RETURN_ACTION_BOLTED_ON`

## 15. Bilibili Long-form Story Gate

A standard 3–5 minute script must not be a short story padded with explanation. Longer exceptions follow the same rule.

For standard long-form stories, seek:
- clear desire;
- first action;
- escalating complications;
- false solution / misjudgment when natural;
- meaningful turning point;
- action-consequence cycles after partial insight;
- mechanism becoming visible through events;
- payoff that changes what the IP/viewer understands or does.

Forbidden:

```text
story
→ story ends
→ lecture begins
```

Explanation should remain embedded in ongoing action and consequence.


## 16. Viewpoint Gate

观点为 optional layer，不单独构成 Editorial Mode。

Writer 可以表达一个 bounded interpretation，但必须满足：
- 事实与 KnowledgeCore 已先成立；
- 观点来自故事结果，不是先有结论再挑故事；
- 只承担一个主要判断；
- 避免从单一案例泛化到“所有人 / 整个行业 / 未来一定”；
- 有重要例外时主动给边界；
- 删除观点后，故事与机制仍然有独立价值。

推荐语言：
- “我现在更愿意把它理解成……”
- “至少在这个场景里……”
- “这件事让我更在意的其实是……”

降权：
- “这证明了……”
- “所以未来一定……”
- “所有人都应该……”
- “真正的答案只有一个……”

Failure:
`RETURN_OPINION_OVERREACH`.

## 17. Scene / Beat Writing Rule

Do not write a paragraph because “the script needs another paragraph”.

Each scene or beat should answer:

1. **此刻人物想要什么？**
2. **他做了什么？**
3. **世界怎么回应？**
4. **结果和预期哪里不同？**
5. **因此什么发生了变化？**
6. **这个变化为什么逼出下一段？**

A beat should preferably change at least one of:
`knowledge / goal / strategy / stakes / relationship / behavior-relevant emotion / available options`.

### Causal Link Test

Prefer:
`因为 A，所以 B；但是 B 导致 C；因此人物只能做 D。`

Avoid:
`A 发生了。然后 B 发生了。然后 C 发生了。`

### Compression Test

If a beat can be deleted without changing:
- character decision;
- causal chain;
- audience understanding;
- tension;
- payoff;

delete or merge it.

### Concrete Test

Every abstract claim should be earned by a visible event, action, object, consequence, or character reaction whenever possible.

Definition:

> **讲得好 = 具体、因果、推进、有人物反应，而且段落结束时故事状态真的变了。**


## 18. Dialogue / Prose QA

The sentence-level rules are defined in:
`docs/NARRATIVE_STYLE_CONTRACT.md#15-dialogue--prose-layer`.

Before Script PASS_CANDIDATE, sample the important lines and check:

- ACTION: line performs an action, not only information transfer;
- SUBTEXT: narrator does not explain what the audience can infer;
- CHARACTER: line reflects recurring IP vocabulary / worldview;
- ECONOMY: no redundant emotion label, transition or summary;
- DESIGN: selected reversals/punchlines use reaction, pause or line ending effectively.

### Specific anti-patterns

Return:
- “我很开心 / 我很难过 / 我突然意识到……” when the event already communicates it;
- “后来我想了想 / 接下来 / 最后我发现……” used only as outline markers;
- generic “这说明 / 因此我们应该” podium summaries;
- abstract method lists where concrete events could carry the rule.

Failure:
`RETURN_DIALOGUE_TOO_ON_THE_NOSE`.

### Important

This gate does NOT require:
- every line to have hidden meaning;
- every line to be witty;
- every beat to pause;
- every sentence to end with a punchline.

Natural spoken flow outranks technique visibility.


## 19. Hook / Engine / Definition / Formatting QA

Canonical details:
`docs/NARRATIVE_STYLE_CONTRACT.md` sections 18–21.

### Hook
- [ ] first sentence is event/counter-intuitive OR desire already touching conflict;
- [ ] no emotional/background declaration before tension;
- [ ] zero-knowledge viewer can still understand the human problem.

### Narrative Engine
Declare internally:
- `EVENT_DRIVEN`, or
- `METAPHOR_DRIVEN`.

A metaphor-driven episode must prove that the metaphor itself carries multiple causal turns.

### Mechanism Definition
- [ ] term reveal follows intuition;
- [ ] definition remains in narrator voice;
- [ ] use contrast before paragraph explanation;
- [ ] add only accuracy-critical clarification.

### Formatting
- [ ] isolated lines / emphasis correspond to actual reversals or timing;
- [ ] repetition has semantic function;
- [ ] emphasis is sparse enough to retain force.

Failures:
- `RETURN_HOOK_TOO_PASSIVE`
- `RETURN_METAPHOR_DECORATIVE_ONLY`
- `RETURN_MECHANISM_BECAME_LECTURE`
- `RETURN_FORMATTING_INFLATION`

## 20. Three-Case G3R Narrative Validation Set

Current long-form editorial validation set:
1. Agent — event-driven / permission and action;
2. Context & Memory — metaphor-driven / cognitive distinction;
3. MCP — repeated integration friction / interoperability.

The Writer layer is not considered stable merely because one conflict archetype works.
Cross-topic stability requires:
- same KnowledgeCore discipline;
- different conflict shapes;
- consistent first-person IP;
- terminology after intuition;
- no recurring “lesson template”.
