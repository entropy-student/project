# Architecture v0.2

## 1. System Boundary

`ai-story-showrunner` 当前是 **validation workspace**。长期产品边界是可复用的 `story-showrunner` Skill；Showrunner 本身是 **Control Plane**，不是 Production Worker。

```text
                    CONTROL PLANE
┌────────────────────────────────────────────────────┐
│ Story Showrunner Skill / current validation shell  │
│ - Episode State                                    │
│ - Routing                                          │
│ - Contracts                                        │
│ - Gates                                            │
│ - Rollback                                         │
│ - Provenance                                       │
└───────────────────────┬────────────────────────────┘
                        ↓
                     WORKER PLANE
┌──────────────┬──────────────┬──────────────┬──────────────┐
│ Research     │ Story/Script │ Director     │ Production   │
│ / Topic      │ Workers      │ Workers      │ Workers      │
└──────────────┴──────────────┴──────────────┴──────────────┘
                        ↓
                  Publish / Feedback
```

## 2. Core Rule — One Brain, Many Workers

Worker 不互相自由编排。

错误模式：

```text
Topic Skill
  ↓
Jingsui Skill 自己改选题
  ↓
Director 又改脚本
  ↓
Renderer 为了方便再改镜头
```

目标模式：

```text
Showrunner freezes Stage N
  ↓
Worker receives explicit contract
  ↓
Worker returns Stage N+1 artifact
  ↓
Showrunner validates
  ↓
PASS / RETURN
```

## 2A. Default Topic Resolution

Normal invocation does not require the owner to manually choose a topic.

Priority:

```text
explicit user topic
> explicit user override/constraint
> today's Topic Calendar
> Topic Radar
> Evergreen Bank
```

If the user simply asks to run today's production, the Showrunner should automatically resolve today's Calendar item first.

## 2B. Domain-Neutral Core

The reusable core is not AI-specific.

Generic core:
`Topic Provider → Research Adapter → Knowledge/Causal Core → Story → Writer → Timing → Director → Assets → Production → Executor → QA`

AI / technology is the first Domain Adapter, not the permanent system boundary.

Canonical productization target:
`docs/STORY_SHOWRUNNER_SKILL_TARGET.md`

## 3. Canonical Episode State

每一期都必须有唯一 `episode_id`。

推荐工作集：

```text
episodes/<episode_id>/
├── episode.json
├── 01_signal_and_topic.md
├── 02_story_package.md
├── 03_script.md
├── 03_script.srt
├── 04_shotbook.md
├── 05_asset_manifest.json
├── 06_render_manifest.json
├── 07_qa.md
└── 08_metrics.md
```

二进制图片 / 音频 / 视频可位于外部工作目录或对象存储，但必须由 manifest 持有稳定引用。

### episode.json 最低字段

```json
{
  "episode_id": "YYYYMMDD-slug",
  "status": "Gx",
  "topic": {},
  "story": {},
  "script": {},
  "director": {},
  "assets": {},
  "render": {},
  "qa": {},
  "metrics": {},
  "provenance": {}
}
```

原则：`episode.json` 记录状态和 canonical references，不把所有长文本强塞进一个 JSON。

## 4. Domain Objects

### Signal

现实变化、新闻、趋势、用户问题、评论、概念机会。

### TopicOpportunity

不是一个名词，而是：

```text
Signal
+ Why Now
+ Human Problem / Stakes
+ AI Mechanism
+ Curiosity Gap
+ Story Seed
+ Audience Payoff
+ Search Anchor
+ Primary Content Job
+ Conversion Adjacency
+ Visual Storyability
+ Novelty / Repetition Risk
```

### StoryPremise

必须包含：

- protagonist / point of view；
- desire；
- obstacle；
- stakes；
- AI mechanism as causal rule；
- turning point；
- payoff。

### KnowledgeCore

必须单独保存：

- concept；
- factual claims；
- source / evidence；
- uncertainty；
- misconceptions；
- one-sentence mechanism；
- actionable implication。

Story Writer 不能悄悄改变 KnowledgeCore。

### ScriptPackage

- locked spoken text；
- hook；
- body；
- payoff；
- terminology reveal point；
- SRT；
- claim refs。

### DirectorPackage / Low-Level Execution Package

最终不是高层视觉意图，而是可直接施工的低层包：

- exact shot list；
- start / end / duration；
- one shot ≈ one image；
- narration / subtitle mapping；
- character / scene IDs；
- action / expression / composition / camera angle；
- final image prompt；
- reference images；
- transition / edit instruction；
- output spec。

Canonical contract: `docs/LOW_LEVEL_EXECUTION_PACKAGE.md`。

### AssetManifest

每个资产必须标记：

```text
REUSE_EXISTING
GENERATE_NEW
SOURCE_REAL
GRAPHIC_OVERLAY
TEXT_ONLY
UNRESOLVED
```

### ReviewResult

```text
PASS
RETURN_TO_<STAGE>
HOLD
BLOCKED_BY_REAL_INPUT
```

## 5. Three-Layer Architecture

### Layer A — Editorial Intelligence

负责“讲什么”。默认先读取当日 Topic Calendar；只有用户显式覆盖时才跳过日历：

- signal intake；
- history / duplication check；
- why-now；
- audience translation；
- human tension；
- knowledge core；
- topic hard-gate / ranking / rejection；
- DISCOVERY / TRUST / SOLUTION content job；
- conversion adjacency；
- search anchor；
- history / visual repetition risk。

### Layer B — Narrative Intelligence

负责“怎么让人看下去并理解”：

- story premise；
- McKee-style causal structure；
- script；
- humor / voice；
- terminology reveal；
- semantic timing classification；
- Voice Timing Profile driven production-SRT compilation。

正常流程中，最终文案与 SRT 不要求 Owner 人工 PASS。只有 Worker 自身 RETURN/BLOCKED 且无法自动修复时才升级给 Owner。

### Layer C — Production Compilation + Execution

负责把已经锁定的故事/脚本编译成**逐镜头低层施工指令**，再交给 Antigravity 执行：

- shot decomposition；
- exact timeline；
- character / scene / style bible；
- one-shot-one-image plan；
- final image prompts + references；
- simple edit instructions；
- output spec；
- QA。

当前默认：**一个小镜头一张图；动作拆成多张静态图。** Nano Banana 生图成本低，因此不以“少生成图片”为优化目标。

Antigravity 是受限 Executor，不得倒过来决定故事、镜头、角色、Prompt、时间或剪辑风格。

## 6. The Middle-Layer Translator

这是本项目最关键的独有模块之一。

输入：

```text
OpenAI 发布 X
MCP
Agent
Context Window
AI Memory
```

输出不是“科普标题”，而是：

```text
Capability Change
→ Human Consequence
→ Conflict
→ Storyable Situation
→ AI Mechanism
```

示例结构：

```text
Agent can act
→ AI starts executing instead of only suggesting
→ convenience vs control
→ a secretary that never asks for confirmation
→ agent/tool/permission/human-in-the-loop
```

## 7. Story Engine Position

McKee-style structure 在 Story Engine 内部优先于文案风格化。

```text
TopicOpportunity
  ↓
KnowledgeCore
  ↓
Story Premise
  ↓
Desire / Inciting Incident / Gap
  ↓
Progressive Complications
  ↓
Turning Point
  ↓
Payoff
  ↓
Writer / Voice Style
```

禁止：

```text
先写一篇科普
→ 再“加点冲突”
→ 再“改得像故事”
```

## 8. Worker Adapter

每个 Worker 通过 Adapter 接入。

Adapter 必须回答：

1. Worker 名称 / 版本；
2. 能处理哪个 Stage；
3. 需要哪些输入；
4. 产出哪些字段；
5. 哪些字段它无权修改；
6. 哪些失败状态可识别；
7. 是否需要联网 / 文件 / 用户真实输入；
8. 是否能程序化调用，还是目前只能生成 handoff package。

这使得模型 / Skill 替换不会改变核心状态机。

## 9. Provenance

每个 Stage 记录：

- worker_id；
- worker_version / commit（能获得时）；
- executed_at；
- source refs；
- parent artifact；
- changed fields；
- gate result。

对热点 / 时事类内容，事实来源必须随 KnowledgeCore 保存，不能只留在聊天历史。

## 10. Rollback

只回到最小修复点。

| Failure | Return |
|---|---|
| 选题没人关心 | Topic |
| 太技术 / 太低级 | Middle-Layer Translator |
| AI 机制错误 | KnowledgeCore |
| 故事只是伪包装 | Story |
| 口播像教程 / 演讲 | Script |
| 镜头没有状态变化 / 仍像 PPT | Director |
| 视觉模板与近期内容过度重复 | Director / Story |
| 人物漂移 | Character / Scene Lock |
| 动效没有表达关系 | Motion |
| 音画错位 | Timeline / Render |
| 热点事实过期 | Research / Knowledge |

## 11. World / IP Memory

长期内容不能只保存“每一期稿子”。

需要三类长期记忆：

### Content Ledger
- 已讲主题；
- primary content job（DISCOVERY / TRUST / SOLUTION）；
- 已用人类问题；
- 已用比喻 / 故事母题；
- 已用 hook / visual motif；
- traffic / trust / conversion 分层数据；
- conversion adjacency hypothesis；
- repeated problem clusters；
- 是否允许重讲。

### World Bible
- 固定人物；
- 关系；
- 场景；
- 世界规则；
- 可复用道具。

### Asset Registry
- canonical character references；
- expression / pose references；
- canonical scene references；
- prop references；
- style lock；
- continuity references。

目标首先是**身份与场景稳定**，不是节省生成次数。需要新状态时直接生成新图。

## 11A. Human Intervention Policy

正常每期不设置“文案确认 Gate”或“关键画面人工抽检 Gate”。

默认 Owner 路径：

```text
optional topic/style override
→ autonomous pipeline
→ final video review
```

关键帧人工生成/审核仅是系统校准手段，用于新角色、新风格、新图片模型、新 Executor 或新失败类型，不属于常规生产。

## 12. Automation Levels

### L0 — Manual Orchestration
Showrunner 生成明确 handoff，人工触发 Worker。

### L1 — Structured Semi-Auto
artifact 机器可读，下一 Worker 可直接消费，但仍可能需要人工触发。

### L2 — Runtime Orchestration
Showrunner 可程序化调用 Worker Adapter，并自动维护 episode state。

### L3 — Conditional Auto-Run
只有 Gate PASS 才自动进入下一 Stage；失败自动 RETURN / HOLD。

G8 前禁止把 L0/L1 宣称成“全自动”。


## 13. Content Business Contract

流量、信任与转化的正式策略见 `docs/CONTENT_STRATEGY_AND_CONVERSION.md`。

核心约束：

- Topic 先过 Hard Gates，再比较机会强弱；
- 每期只有一个 `primary_content_job`：DISCOVERY / TRUST / SOLUTION；
- 一条视频默认一个核心 AI mechanism；
- `conversion_adjacency` 只描述未来需求邻近度，不允许倒逼硬广；
- Final QA 增加 Visual Repetition Gate；
- Metrics 必须拆分 Traffic / Trust / Conversion，禁止只看播放量；
- 内容反馈可反向形成 product-demand hypothesis，但单条爆款不能直接证明产品需求。
