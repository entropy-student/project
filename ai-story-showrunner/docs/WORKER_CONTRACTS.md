# Worker Contracts v0.1

## 1. Contract Philosophy

Showrunner 与 Worker 之间禁止使用“你参考上文自己理解一下”作为正式接口。

每次调用至少包含：

```text
worker_id
worker_version_or_ref
episode_id
stage
input_artifacts
locked_fields
allowed_changes
required_outputs
failure_codes
```

Worker 输出必须可被 Showrunner 验证。

---

## 2. Topic Worker

### Input
- signal set；
- content history；
- audience scope；
- freshness window。

### Required Output

```yaml
topic_id:
why_now:
human_problem:
ai_mechanism:
story_seed:
audience_payoff:
novelty_vs_history:
source_refs:
risks:
```

### Forbidden
只返回：
`MCP`、`Agent`、`OpenAI 新功能`。

---

## 3. Knowledge Worker

### Input
`TopicOpportunity`

### Required Output

```yaml
concept:
mechanism_one_liner:
key_claims:
misconceptions:
boundaries:
uncertainties:
ordinary_person_implication:
source_refs:
```

### Locked Later
一旦 Knowledge Gate PASS，Writer 不得修改关键 Claim，只能请求 RETURN。

---

## 4. Story Engine

### Input
- TopicOpportunity；
- KnowledgeCore；
- IP / world context。

### Required Output

```yaml
premise:
protagonist:
desire:
inciting_incident:
gap:
complications:
turning_point:
mechanism_in_story:
payoff:
term_reveal_strategy:
story_summary_without_jargon:
```

### PASS Test
`story_summary_without_jargon` 本身必须像一个故事，而不是课程大纲。

---

## 5. Writer Worker

候选：
- `jingsui-story-video-director`
- `short-form-spoken-script`

### Input
- locked KnowledgeCore；
- locked StoryPremise；
- duration；
- speaking rate / voice；
- platform；
- IP config。

### Required Output

```text
title
hook
locked_spoken_script
srt
claim_map
term_reveal_timestamp_or_section
```

### Allowed
语言、幽默、节奏、口语化。

### Forbidden
- 改核心机制；
- 新增未经证实的事实；
- 把 story 重新变成 explainer；
- SRT 与 locked script 不一致。

---

## 6. Director Worker

候选：
- Jingsui Visual Beat layer；
- Aroll Semantic Director；
- Visual Narrative Animation Lab 的 SHOTBOOK 方法。

### Input
- locked script；
- aligned / provisional timeline；
- World Bible；
- Asset Registry。

### Required Output

每个 Visual Beat：

```yaml
beat_id:
time_range:
narration_ref:
focus:
dramatic_action:
visual_state_start:
visual_change:
visual_state_end:
shot_design:
transition:
asset_need:
reuse_candidate:
on_screen_text:
evidence_requirement:
```

### Forbidden
按标点机械一行一镜。

---

## 7. Asset Resolver

### Input
- Shotbook；
- Asset Registry；
- Character / Style / Scene Bible。

### Output

```yaml
asset_request_id:
beat_ids:
mode: REUSE_EXISTING | GENERATE_NEW | SOURCE_REAL | GRAPHIC_OVERLAY | TEXT_ONLY | UNRESOLVED
canonical_subject:
required_action:
required_expression:
scene:
props:
composition:
continuity_refs:
provider_constraints:
```

### Rule
Prompt 是 AssetRequest 的编译结果，不是最上游真相。

---

## 8. Image Generation Adapter

### Input
`AssetRequest`

### Output

```yaml
asset_id:
provider:
provider_job_ref:
file_ref:
width:
height:
prompt_hash:
reference_assets:
qa:
```

Provider 可替换。

当前 Antigravity / Nano Banana 只能在确认稳定调用方式后标记为 `PROGRAMMATIC`；否则是 `MANUAL_EXECUTOR`。

---

## 9. Motion / Render Worker

### Input
- audio master；
- Shotbook；
- AssetManifest；
- subtitles；
- style / motion config。

### Output

```yaml
render_id:
timeline_ref:
render_ref:
duration:
resolution:
fps:
audio_ref:
subtitle_ref:
qa:
```

### Rule
如果使用 Narrative Motion Semantics，必须遵守其当前 INCOMPLETE 边界；unsupported semantic 不硬套模板。

---

## 10. QA Worker

### Required Output

```yaml
story:
  status:
  failures:
knowledge:
  status:
  failures:
visual:
  status:
  failures:
production:
  status:
  failures:
decision:
return_stage:
```

QA 不直接修复全部问题，只负责定位。

---

# Versioning

任何 Worker 的行为依赖外部 Skill 时，应尽量记录：

- repo；
- path；
- version；
- commit / blob sha（能获得时）。

目的不是锁死版本，而是能够解释：

> “为什么同一个 episode 两次执行结果发生了系统性变化？”

---

# Mutation Rules

## Immutable after Gate PASS

- `KnowledgeCore.key_claims`
- `StoryPremise.mechanism_in_story`
- locked script text（Script Gate 后）
- timeline source（真实配音存在时）

需要改变必须显式 reopen 对应 Gate。

## Derived artifacts

- SRT；
- Visual Beats；
- prompts；
- crops；
- motion parameters；

可重建，但必须指向其 canonical parent。
