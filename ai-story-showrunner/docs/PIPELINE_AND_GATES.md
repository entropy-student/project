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

不是输出“今天讲 MCP”，而是五元组：

```text
Why Now
× Human Problem
× AI Mechanism
× Story Seed
× Audience Payoff
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

## Stage 5 — Director / Visual Beat

脚本锁定后，导演从语义和戏剧动作拆 Visual Beat。

### 禁止

```text
一句台词
= 一张图
= 一个镜头
```

### 必须回答

每个 Beat：

1. 观众这一拍必须理解什么；
2. 主体发生什么变化；
3. 为什么需要新画面；
4. 现有画面能否复用；
5. 画面最后停在什么状态；
6. 下一拍如何承接。

### Visual Gate

- 一句可多 Beat；
- 多句可同 Beat；
- punchline / reaction 可短；
- explanation 可 hold；
- reuse 优先于无意义新图；
- 画面必须参与叙事，而不是装饰字幕。

### Fail
`RETURN_TO_DIRECTOR`

---

## Stage 6 — Asset Resolution

先解析资产，再生成图片。

### Output

`AssetManifest`

每个 Beat 的视觉需求标记：

- `REUSE_EXISTING`
- `GENERATE_NEW`
- `SOURCE_REAL`
- `GRAPHIC_OVERLAY`
- `TEXT_ONLY`
- `UNRESOLVED`

### Generate Rule

只有“新的、无法由现有资产表达的视觉状态”才生成新母图。

### Consistency Gate

需要角色时必须绑定：

- Character Reference；
- Style Lock；
- continuity reference（需要时）。

### Fail
`RETURN_TO_ASSET_RESOLUTION`

---

## Stage 7 — Image Generation Adapter

当前候选执行环境：

- Antigravity；
- Nano Banana。

但核心 Contract 不写死 Provider。

### Input

`AssetRequest[]`

### Output

- asset id；
- file / URI；
- generation provider；
- prompt version；
- references；
- dimensions；
- QA status。

### Gate

- 人物身份；
- 场景连续；
- 关键动作；
- 构图；
- 画面可裁切性；
- 禁止错误文字进入最终画面。

---

## Stage 8 — Motion / Render

根据内容路由，不强制只有一个执行器。

候选：

- `visual-narrative-animation-lab`；
- `aroll-video-maker`；
- `video-talkcraft-design-orchestrator`；
- Remotion / CSS；
- `narrative-motion-semantics` 作为特定信息关系的语义库。

### Render Gate

- 音频主时间轴；
- Visual Beat 与语义同步；
- 动效表达关系，而不是统一 fade；
- 画面密度有变化；
- callback / reuse 正常；
- 字幕 / 正式文字由后期可靠渲染。

---

## Stage 9 — Final QA

分四个独立 Gate，不能互相替代。

### Story QA
故事是否真的成立。

### Knowledge QA
AI 机制是否准确，热点事实是否仍然新鲜。

### Visual QA
画面是否参与叙事，是否仍像 PPT / 图集。

### Production QA
音画、字幕、尺寸、文件、时长是否正确。

只有四个都 PASS 才进入发布。

---

## Stage 10 — Publish / Learning

发布后数据不直接“证明内容原则”。

按证据分层：

```text
Attention
→ Interest
→ Completion / Retention
→ Qualified Comments / Saves / Follows
→ downstream acquisition behavior
```

使用 `acquisition-growth-radar` 的 Evidence / Bottleneck 思路：

1. 先判断哪里掉；
2. 再找最可能 Lever；
3. 一次只改一个核心变量；
4. 不因为单条表现差就推翻全部故事方法。

### Feedback fields

- hook retention；
- mid-video drop；
- completion；
- saves；
- comments by type；
- follow conversion；
- recurring confusion；
- story / concept recall（能获取时）。

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
