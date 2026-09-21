# Pipeline & Gates v0.5

## Stage 0 — Topic Resolution / Signal Intake

### Default routing

```text
explicit user topic
> explicit user override
> today's Topic Calendar
> Topic Radar
> Evergreen Bank
```

If no topic is specified, load today's Calendar item automatically.

### Input
- domain news / product changes；
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
背后有一个值得理解、且能准确解释的领域机制 / causal rule。AI Adapter 下表现为 AI mechanism。

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

## Stage 4 — Script + Production SRT Timing

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

### Timing Compiler

After locked script:

```text
Speech Unit segmentation
→ semantic timing kind / pace intent
→ reusable Voice Timing Profile
→ predicted production timestamps
→ structurally valid Production SRT
```

The SRT should already be close enough to production that normal TTS does not require a second creative retiming pass.

Real TTS later verifies prediction. A material mismatch returns to the Timing Compiler / Voice Timing Profile instead of becoming routine manual calibration.

Canonical timing contract:
`docs/SRT_AUDIO_TIMING_STANDARD.md`

### Owner Gate

No normal Owner approval is required for final script or SRT.

### Rule

Writer 可以改变表达，不得静默改变 KnowledgeCore。

---

## Stage 5 — G4 Director / Shot Compiler

Canonical contract:
- `docs/G4_DIRECTOR_LANGUAGE_RULES.md`
- `docs/G4_DIRECTOR_COMPILER_CONTRACT.md`

Status:
`G4 = PASS`

Canonical six-layer pipeline:

```text
Locked Script + KnowledgeCore
→ Dramatic Hierarchy
→ Episode / Sequence Visual Strategy
→ Visual Intention
→ Semantic Shot
→ Visual Beat
→ Timing & Edit Calibration
→ Director Shotboard
```

G4 locks:
- why each image exists;
- narration binding;
- local visual intention;
- shot function;
- actual shot size / POV at Visual Beat level;
- image-level state;
- image relation;
- reference timing.

G4 requires 100% locked-script coverage.

G4 does NOT lock final generation prompts or canonical binary reference paths.

Fail:
`RETURN_TO_DIRECTOR`

---

## Stage 6 — G5 Image Asset Package

Canonical contract:
- `docs/G5_IMAGE_ASSET_PACKAGE_CONTRACT.md`
- `docs/PRODUCTION_VISUAL_STYLE.md`
- `docs/CHARACTER_IDENTITY_LOCK.md`

Internal phases:

```text
G5A Asset Requirement Extraction
→ G5B Canonical Reference Lock
→ G5B.5 Visual Acquisition Review
→ G5C1 Frame Blueprint Compilation
→ G5C2 Beat Asset Binding
→ G5C3 Execution Mode Selection
→ G5C4 Prompt / Edit Compiler
```

Canonical frame rules:
- `docs/VISUAL_FRAME_BLUEPRINT_RULES.md`
- `schemas/frame_blueprint.schema.json`
- `schemas/frame_execution_row.schema.json`

### G5A
Extract:
- Character;
- Scene;
- Style;
- Prop / UI;
- Beat → Asset dependencies.

### G5B
Lock:
- Character Bible;
- Scene Bible;
- Style Bible;
- Prop/UI Bible;
- Reference Manifest.

Current production style:
`SIMPLIFIED_FLAT_NARRATIVE_COMIC`

### G5B.5
Review the proposed visual style through:
- acquisition-growth Evidence → Bottleneck → Lever → Experiment → Decision;
- external platform/research evidence;
- Control vs Challenger hypothesis.

Canonical:
`docs/VISUAL_ACQUISITION_REVIEW_GATE.md`

Current decision:
`KEEP + ITERATE` — simplified flat narrative comic remains Control; lower-complexity line-cartoon remains Challenger.

### G5C1 — Frame Blueprint
Compile one Frame Blueprint per accepted Visual Beat.

Locks:
- dramatic job;
- P1/P2;
- focus mode;
- attention path;
- composition;
- density;
- text/brand/UI policy;
- continuity preserve;
- one main delta;
- withheld information.

### G5C2 — Beat Asset Binding
Bind only assets that are actually visible or causally required by the Blueprint.

Any recurring-character Beat must also bind the canonical identity source and obey `docs/CHARACTER_IDENTITY_LOCK.md`.
Previous generated frames are continuity refs only and may not replace canonical identity.

Do not bind an asset merely because narration mentions it.

### G5C3 — Execution Mode
Choose exactly one:
- `GENERATE`
- `DERIVE_EDIT`
- `COMPOSITE_CROP`

Current Owner policy:
UI / table / evidence visual assets remain image-generation/image-edit assets.
`COMPOSITE_CROP` may crop/compose already approved images, but is not a code-drawn UI/table production path.

Prefer deterministic derive/composite when it preserves continuity better than regeneration.

### G5C4 — Prompt / Edit Compiler
Compile executor instructions from G4 + Blueprint + bound assets + execution mode.

Exact text defaults to `POST_OVERLAY`.
Brand defaults to `NONE`.

G5 must not change story, Beat count, timing or Director intent.

Fail examples:
- `RETURN_CHARACTER_DRIFT`
- `RETURN_SCENE_DRIFT`
- `RETURN_STYLE_DRIFT`
- `RETURN_IMAGE_MISSED_BEAT`
- `RETURN_UI_TEXT_FAILURE`
- `RETURN_REFERENCE_UNRESOLVED`

---

## Stage 7 — G6 Low-Level Execution Package

Canonical contract:
`docs/LOW_LEVEL_EXECUTION_PACKAGE.md`

G6 packages accepted G4/G5 outputs for Antigravity.

Core files:
- `07_SHOT_TIMELINE.csv`
- `08_IMAGE_GENERATION.csv`
- `09_EDIT_INSTRUCTIONS.md`
- Character / Scene / Style / Prop / UI references.

Execution philosophy:

> **上游思考尽可能充分，下游执行尽可能愚蠢。**

Missing creative decisions are not delegated downstream.
Unspecified effects default to `DO_NOT_ADD`.

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

### Audio Mode — RESOLVED

`AUDIO_MODE=A_UPSTREAM_COSYVOICE`

The Production Package specifies the voice/timing contract. Antigravity executes the locked CosyVoice recipe and must not creatively retime or rewrite speech.

A future executor may change, but timing remains upstream-controlled.

---

## Stage 8A — Image Calibration Exception

Manual critical-frame sampling is not a normal episode stage.

Use it only for:
- new recurring character;
- new visual style;
- new image model/provider;
- new executor;
- materially changed Prompt Compiler;
- a newly observed automated-QA failure class.

Otherwise G5 execution rows go directly to Antigravity + machine QA.

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


## Default Owner Interaction

Normal run:

```text
invoke Story Showrunner
→ auto-resolve today's topic
→ autonomous G2–G6
→ Antigravity execution
→ final video
→ Owner review
```

Owner does not normally approve script, SRT, Director plan or first-batch key frames.

Canonical long-term product boundary:
`docs/STORY_SHOWRUNNER_SKILL_TARGET.md`
