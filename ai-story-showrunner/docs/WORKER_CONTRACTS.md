# Worker Contracts v0.2

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
signal:
why_now:
human_problem:
human_stakes:
causal_mechanism:
one_mechanism_only:
curiosity_gap:
story_seed:
audience_payoff:
search_anchor:
primary_content_job: DISCOVERY | TRUST | SOLUTION
secondary_content_job:
conversion_adjacency: NONE | LOW | MEDIUM | HIGH | UNKNOWN
conversion_path_hypothesis:
visual_storyability:
novelty_vs_history:
repetition_risk:
source_refs:
uncertainties:
risks:
```

### Required Gate Discipline
先过 Human Relevance / Mechanism Integrity / Storyability / One Mechanism / Non-Trivial Payoff，再做候选比较。高“流量分”不能补偿 Hard Gate 失败。

### Forbidden
- 只返回 `MCP`、`Agent`、`OpenAI 新功能`；
- 用“预计会爆”代替可解释维度；
- 因 conversion adjacency 高就强行进入 SOLUTION；
- 把单一公司新闻直接当完整选题。

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
- voice profile / speaking-style config；
- platform；
- IP config；
- primary_content_job；
- search_anchor（如适用）。

### Required Output

```text
title
hook
locked_spoken_script
semantic_timing_hints
claim_map
term_reveal_timestamp_or_section
```

### Allowed
语言、幽默、节奏、口语化、平台入口包装。

### Hook Requirement
优先从异常事件、决定、冲突或后果进入；默认禁止以“今天介绍 X / 最近 AI 圈很火 / 什么是 X”作为开头。

### Forbidden
- 改核心机制；
- 新增未经证实的事实；
- 把 story 重新变成 explainer；
- 改写或绕过 locked spoken script；
- 自行生成与 Timing Compiler 冲突的 production timecode。

---

## 5A. Timing Compiler

### Input
- locked spoken script；
- semantic timing hints / dramatic intent；
- canonical Voice Timing Profile；
- target duration constraints（如有）。

### Required Output
- Speech Units；
- semantic pace class；
- timing lock class；
- authored semantic pauses；
- `PRODUCTION_SUBTITLES.srt`；
- `TTS_MANIFEST.json`。

### Rule
Timing Compiler owns spoken timing. It runs before Director.

Real TTS is execution/QA. Material mismatch returns:
`RETURN_VOICE_TIMING_PROFILE_MISS`

Director and Executor may not redesign spoken timing.

---

## 6. Director / Shot Compiler

### Input
- locked script；
- locked Production SRT / TTS timing contract；
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

Canonical:
`AUDIO_MODE=EXECUTOR_LOCKED_COSYVOICE`

Upstream owns:
- locked spoken text;
- Production SRT;
- semantic pace;
- authored pauses;
- Voice Timing Profile;
- TTS Manifest.

Antigravity only executes the locked CosyVoice recipe. It may not rewrite, re-pace, redistribute semantic pauses or redesign SRT.

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
visual_repetition:
  status:
  repeated_patterns:
production:
  status:
  failures:
business_job:
  primary_content_job:
  metric_expectation:
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
- `StoryPremise.mechanism_in_story` / locked causal mechanism
- locked script text（Script Gate 后）
- Production SRT / TTS Manifest timing contract

需要改变必须显式 reopen 对应 Gate。

## Derived artifacts

- Production SRT（可由 locked script + profile 重建，但一旦下游 Gate 锁定即为时间轴父级）；
- Visual Beats；
- prompts；
- crops；
- motion parameters；

可重建，但必须指向其 canonical parent。


## 11. Metrics / Learning Worker

### Input
- episode primary_content_job；
- platform metrics；
- comments / questions / saves / follows；
- downstream actions（能获取时）；
- historical Content Ledger。

### Required Output

```yaml
traffic:
  findings:
trust:
  findings:
conversion:
  findings:
primary_job_result:
repeated_problem_clusters:
product_demand_hypotheses:
recommended_single_variable_test:
```

### Rule

不得把高播放直接解释为高信任或高转化；不得把一条爆款直接解释为产品需求成立。
