# Pipeline & Gates v0.1

## Stage 0 — Signal Intake

### Input
- AI 新闻 / 产品变化；
- 技术概念；
- 用户评论 / 问题；
- 平台趋势；
- 历史选题缺口。

### Output
`SignalPackage`

### Gate
事实来源和时间范围可追踪；纯猜测不得直接进入热点内容。

---

## Stage 1 — Topic Opportunity

不是输出“今天讲 MCP”，而是结构化 TopicOpportunity：

```text
Why Now
× Human Problem / Stakes
× AI Mechanism
× Curiosity Gap
× Story Seed
× Audience Payoff
× Search Anchor
× Primary Content Job
× Conversion Adjacency
× Visual Storyability
× Novelty / Repetition Risk
```

### Required Tests

#### No-name Test
删掉 OpenAI / Anthropic / MCP / Agent 等专有名词，故事仍值得看。

#### Not-trivial Test
不能退化成“AI 可以帮你做 X”。

#### Why-now Test
能说明为什么现在值得讲。

#### Human-stakes Test
必须有人想得到某样东西，并承担错误选择的代价。

#### Mechanism Test
背后有一个值得理解、且能准确解释的 AI 机制。

#### One-Mechanism Test
默认一条视频只承担一个核心机制；如果必须同时塞多个机制才能成立，`RETURN_TOPIC_TOO_DENSE`。

#### Storyability Test
必须能形成欲望、阻碍、后果、Gap/转折和可视化动作。

#### Commercial Adjacency Test
记录未来是否自然靠近真实需求，但该字段**不得作为硬广授权**。

### Content Job
每期先声明一个 primary role：`DISCOVERY` / `TRUST` / `SOLUTION`。允许 secondary role，但不得多主任务。

### Fail
`RETURN_TO_TOPIC_TRANSLATION`

---

## Stage 2 — Knowledge Core

先冻结“到底要讲懂什么”，再写故事。

### Output

- one concept；
- one mechanism；
- misconception；
- what changes for ordinary people；
- what does not follow；
- source refs；
- uncertainty；
- intended takeaway。

### Rule

一条视频默认只承担一个核心机制。

### Fail
事实不清楚、概念混杂、因果证据不足 → `RETURN_TO_RESEARCH`

---

## Stage 3 — Story Premise

把 AI 机制转成**故事里的因果规则**。

### McKee-style Minimum Structure

```text
Protagonist wants something
→ Inciting incident
→ first action
→ reality does not match expectation (Gap)
→ progressive complications
→ meaningful turning point
→ protagonist understands the rule
→ choice / payoff
```

### Story Gate

必须同时满足：

1. 主角有欲望，不只是“负责听讲”；
2. AI 机制会改变事件结果；
3. 至少一次预期与现实出现 Gap；
4. 冲突会升级，而不是平铺三个例子；
5. 术语删掉以后，因果仍然成立；
6. 结局来自人物选择 / 机制，而不是 narrator 突然总结。

### Fail
`RETURN_TO_STORY`

---

## Stage 4 — Script / SRT

Story Structure PASS 后才允许风格化。

可路由到：

- `jingsui-story-video-director`；
- `short-form-spoken-script`；
- 后续其他 Writer Worker。

### Locked Inputs

- KnowledgeCore；
- StoryPremise；
- Target audience；
- target duration；
- voice / IP config。

### Script Gate

检查：

- 开头是否进入具体处境；
- 是否过早解释概念；
- 是否把故事重新写成教程；
- 每段是否推进事件 / 判断；
- reveal point 是否自然；
- payoff 是否兑现开头；
- 事实 / 数字是否与 KnowledgeCore 一致；
- SRT 是否来自 locked script。

### Rule

Writer 可以改变表达，不得静默改变 KnowledgeCore。

---

## Stage 5 — Director / Shot Decomposition

脚本锁定后，导演把故事拆成**可直接施工的小镜头**。

### Current Rule

> **One small shot ≈ one image.**

动作、反应、姿态变化优先拆成多个小镜头和多张静态图，而不是依赖复杂运镜或视频生成。

### Director Output Must Lock

G4 uses two nested units:

1. SemanticShot — visual/story event;
2. VisualBeat — image-level shotbook row.

VisualBeat must lock:
- visual_beat_id;
- semantic_shot_id;
- start / end / duration from accepted timing source;
- narration fragment;
- character IDs;
- scene ID;
- action / expression hint;
- visual state / visual delta;
- composition / camera hint;
- transition intent;
- forbidden visuals;
- acceptance criteria.

G4 does NOT lock final generation Prompt / canonical reference asset paths.
Those are compiled after Character / Scene / Style locks.

### Canonical Schemas

- `schemas/semantic_shot.schema.json`
- `schemas/visual_beat.schema.json`

### Gate

- 不允许 Antigravity 自行拆镜；
- 不允许它自行合并镜头；
- 不允许它改时间；
- 镜头数量以表达清楚和施工简单为优先，不以少生图为目标。

### Fail
`RETURN_TO_DIRECTOR`

---

## Stage 6 — Character / Scene / Style Lock

在批量生图前冻结：

- Character Bible + canonical references；
- Scene Bible + canonical references；
- Style Bible；
- continuity strategy。

人物出现的每张图必须携带相同 Character ID 与 canonical reference；连续镜头可追加上一张通过图。

人物漂移：
`RETURN_CHARACTER_DRIFT`

场景关键结构漂移：
`RETURN_SCENE_DRIFT`

---

## Stage 7 — Low-Level Execution Package

把前面所有导演决定编译成 Antigravity 可直接执行的施工包。

Canonical contract：

`docs/LOW_LEVEL_EXECUTION_PACKAGE.md`

核心文件：

- `07_SHOT_TIMELINE.csv`
- `08_IMAGE_GENERATION.csv`
- `09_EDIT_INSTRUCTIONS.md`
- Character / Scene / Style references。

### Execution Philosophy

> 上游思考尽可能充分，下游执行尽可能愚蠢。

没有写的效果默认 `DO_NOT_ADD`。

---

## Stage 8 — Antigravity Execution

Antigravity 当前冻结为**执行 Agent**，不是导演。

执行顺序：

1. 按 Image Generation Sheet 批量调用 Nano Banana 生图；
2. 每张图先做 identity / scene / composition QA；
3. 合格图片按 Shot Timeline 放入对应时间段；
4. 只执行明确指定的简单 cut / transition / subtitle / audio；
5. 导出视频初稿；
6. 返回 execution_result。

### Forbidden

Antigravity 不得自行：

- 改故事 / 文案 / SRT；
- 改镜头数量或时长；
- 改角色 / 场景；
- 改 Prompt；
- 加运镜 / 转场 / BGM / SFX；
- 删除它认为“多余”的图片。

无法执行时：
`RETURN_EXECUTION_CONTRACT_UNRESOLVED`

### Audio Branch — TBD

当前保留两个候选：

- **AUDIO_MODE=A**：上游先完成 TTS/配音，Antigravity 以现成音频为唯一主时间轴；
- **AUDIO_MODE=B**：Antigravity 按锁定 script/SRT + voice config 生成 TTS，再锁音频时间轴。

在真实 PoC 前保持 `TBD`。

---

## Stage 9 — Final QA

分四个独立 Gate，不能互相替代。

### Story QA
故事是否真的成立。

### Knowledge QA
AI 机制是否准确，热点事实是否仍然新鲜。

### Visual QA
画面是否参与叙事，是否仍像 PPT / 图集。

额外执行 **Visual Repetition Gate**：与近期内容相比，是否重复开场构图、人物站位、视觉隐喻、反应镜头、背景和节奏模板。角色一致性允许稳定，事件状态与画面表达不能模板化。

失败：`RETURN_VISUAL_REPETITION`。

### Production QA
音画、字幕、尺寸、文件、时长是否正确。

只有四个都 PASS 才进入发布。

---

## Stage 10 — Publish / Learning

发布后数据不直接“证明内容原则”。

按业务任务分三层：

```text
Traffic
→ Trust
→ Conversion
```

并且先读取本期 `primary_content_job`，禁止所有视频都用播放量判断。

使用 `acquisition-growth-radar` 的 Evidence / Bottleneck 思路：

1. 先判断哪里掉；
2. 再找最可能 Lever；
3. 一次只改一个核心变量；
4. 不因为单条表现差就推翻全部故事方法。

### Traffic fields
- exposure / play start；
- hook retention；
- mid-video drop；
- completion；
- new audience share（能获取时）。

### Trust fields
- saves；
- follows；
- qualified comments；
- meaningful questions；
- story / concept recall（能观察时）；
- repeat viewers（能获取时）。

### Conversion fields
- profile visits；
- resource / link click；
- DM / inquiry；
- signup / tool usage；
- purchase / qualified lead（如适用）。

重复出现的问题另写入 demand cluster，用于后续产品机会判断。

完整策略见 `docs/CONTENT_STRATEGY_AND_CONVERSION.md`。

结果写回 Content Ledger。

---

# Gate Discipline

## PASS
输入已达到下一阶段最低可信标准。

## RETURN
明确指出：
- 返回哪个 Stage；
- 哪个字段失败；
- 允许改什么；
- 不允许改什么。

## HOLD
缺少依赖，但不是失败。

## BLOCKED_BY_REAL_INPUT
必须由真实世界输入完成，例如：
- 用户素材；
- 真实发布数据；
- 外部账号权限；
- 不可由模型伪造的结果。

禁止用“看起来合理”代替真实输入。
