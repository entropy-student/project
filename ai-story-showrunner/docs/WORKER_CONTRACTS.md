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

## 6. Director / Shot Compiler

### Input
- locked script；
- SRT / audio timing；
- Character / Scene / Style context。

### Required Output

每个 Shot：

```yaml
shot_id:
start:
end:
duration:
narration:
subtitle:
character_ids:
scene_id:
action:
expression:
composition:
camera_angle:
image_id:
transition_in:
transition_out:
notes:
```

### Rule

默认 **one small shot ≈ one image**。动作变化优先拆多个 Shot，而不是把复杂运动交给 Executor。

---

## 7. Character / Scene / Style Compiler

### Output

- Character Bible；
- canonical front / 3/4 / side references；
- immutable identity traits；
- Scene Bible；
- canonical scene references；
- Style Bible；
- continuity reference policy。

### Rule

任何包含角色的新图必须带同一 Character ID + canonical reference；连续镜头可追加上一镜通过图。

---

## 8. Low-Level Execution Package Compiler

### Canonical Contract

`docs/LOW_LEVEL_EXECUTION_PACKAGE.md`

### Required Output

- exact Shot Timeline；
- one-row-per-image Image Generation Sheet；
- final executable prompts；
- negative constraints；
- character / scene / continuity refs；
- edit instructions；
- output spec；
- audio mode。

它的职责是把导演决策**编译到底层**，不是让 Antigravity 再做导演推理。

---

## 9. Antigravity Execution Agent

### Input

完整 Low-Level Execution Package。

### Execution

1. 按表批量调用 Nano Banana 生图；
2. 只接受通过 identity / scene / composition QA 的图片；
3. 按 exact timeline 放图；
4. 按明确指令添加简单 cut / transition / subtitle / audio；
5. 导出成片与 execution result。

### Freedom

接近零。只允许不改变结果的工具操作细节和等价技术重试。

### Forbidden

不得改故事、文案、SRT、镜头数量、时间、角色、场景、Prompt、构图、转场、BGM/SFX 或视频比例。

无法执行：
`RETURN_EXECUTION_CONTRACT_UNRESOLVED`

### Audio

当前 `AUDIO_MODE=TBD`：

- A：上游提供最终音频；
- B：Antigravity 严格按锁定 script/SRT + voice config 生成 TTS。

真实 PoC 后再冻结。

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
