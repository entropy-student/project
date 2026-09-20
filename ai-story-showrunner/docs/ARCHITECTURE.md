# Architecture v0.1

## 1. System Boundary

AI Story Showrunner 是 **Control Plane**，不是 Production Worker。

```text
                    CONTROL PLANE
┌────────────────────────────────────────────────────┐
│ AI Story Showrunner                                │
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
+ Human Problem
+ AI Mechanism
+ Audience Value
+ Story Seed
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

### DirectorPackage

- semantic sections；
- Visual Beats；
- beat timing；
- shot intent；
- transition intent；
- asset requirement；
- reuse candidate；
- on-screen text；
- evidence frame requirement。

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

负责“讲什么”：

- signal intake；
- history / duplication check；
- why-now；
- audience translation；
- human tension；
- knowledge core；
- topic ranking / rejection。

### Layer B — Narrative Intelligence

负责“怎么让人看下去并理解”：

- story premise；
- McKee-style causal structure；
- script；
- humor / voice；
- SRT；
- terminology reveal。

### Layer C — Production Intelligence

负责“怎么让画面把故事演出来”：

- director；
- Visual Beat；
- asset resolution；
- image generation；
- motion；
- render；
- QA。

禁止 Production Layer 倒过来决定核心故事。

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
| 一句一图 | Director |
| 人物漂移 | Asset |
| 动效没有表达关系 | Motion |
| 音画错位 | Timeline / Render |
| 热点事实过期 | Research / Knowledge |

## 11. World / IP Memory

长期内容不能只保存“每一期稿子”。

需要三类长期记忆：

### Content Ledger
- 已讲主题；
- 已用人类问题；
- 已用比喻 / 故事母题；
- 表现数据；
- 是否允许重讲。

### World Bible
- 固定人物；
- 关系；
- 场景；
- 世界规则；
- 可复用道具。

### Asset Registry
- character pose；
- expression；
- scene；
- prop；
- callback frame；
- style lock。

目标是让内容越做资产越多，而不是每期重新生成一切。

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
