# Adapter Field Mappings v0.1

## 1. Purpose

本文件把通用 Skill 的 native 输入/输出映射为 AI Story Showrunner 的 canonical Stage Contract。

原则：**Adapter 负责限权、补字段、丢弃越权输出；原 Skill 不直接拥有 canonical state。**

---

## 2. Jingsui Writer Adapter

### Native source

- repo: `entropy-student/spike.skill`
- skill: `jingsui-story-video-director`
- observed version: 3.4.0

### Canonical Input Mapping

| Showrunner field | Jingsui use | Lock |
|---|---|---|
| TopicOpportunity.human_problem | 具体处境/切口 | READ ONLY |
| TopicOpportunity.primary_content_job | 控制 hook / payoff 强弱 | READ ONLY |
| KnowledgeCore.key_claims | 事实与机制边界 | READ ONLY |
| KnowledgeCore.mechanism_one_liner | 术语揭示核心 | READ ONLY |
| StoryPremise | 事件骨架 | READ ONLY |
| target_duration | 覆盖 native 长稿默认 | READ ONLY |
| platform | 包装语气 | READ ONLY |
| voice_ip_config | 人称/角色/语气 | READ ONLY |

### Canonical Output Accepted

- title candidates
- hook
- locked_spoken_script
- SRT
- claim_map
- term_reveal_section
- optional humor / riff annotations

### Native Outputs Explicitly Ignored

即使 native Skill 生成以下内容，也**不得自动进入 canonical state**：

- Visual Beat
- Scene Bible
- image prompt plan
- edit plan
- final production QA

这些必须由后续 Showrunner Stage 重新编译。

### Project Overrides

- 不强制 `大家好，我是{{IP_NAME}}`；
- 不强制英文尾签；
- 不继承 150–240s 默认长度；
- 第一帧优先异常事件/冲突；
- 一条视频只能解释 locked one mechanism；
- 不得重新选择主题或改变 primary_content_job；
- 不得为了更好写而新增未经 KnowledgeCore 通过的事实。

### Failure Codes

- `RETURN_WRITER_CHANGED_MECHANISM`
- `RETURN_WRITER_BECAME_EXPLAINER`
- `RETURN_SCRIPT_STORY_DRIFT`
- `RETURN_SCRIPT_TOO_DENSE`
- `RETURN_SRT_MISMATCH`

---

## 3. Acquisition Growth Learning Adapter

### Native source

- repo: `entropy-student/spike.skill`
- skill: `acquisition-growth-radar`
- observed version: v0.2

### Canonical Position

`Stage 10 Publish / Learning` only.

### Input Mapping

| Showrunner field | Growth Radar use |
|---|---|
| primary_content_job | 判断主要成功口径 |
| metrics.traffic | Attention / retention evidence |
| metrics.trust | Interest / trust evidence |
| metrics.conversion | Intent / transaction evidence |
| comments/questions | Problem evidence / objections |
| Content Ledger history | Repeatability / comparison |
| product context | conversion hypothesis（如存在） |

### Canonical Output Accepted

- current bottleneck
- strongest evidence
- unproven assumptions
- likely lever
- one-variable experiment
- KEEP / ITERATE / KILL / SCALE for the **tested content hypothesis**
- repeated problem clusters
- product-demand hypothesis with evidence level

### Forbidden

- 用播放量证明需求；
- 用点赞证明购买意愿；
- 一条爆款直接触发 SCALE；
- 自动修改 Story-first 原则；
- 把某次商业表现写成 AI KnowledgeCore；
- 因产品需要转化而要求 Writer 硬塞 CTA。

### Failure Codes

- `RETURN_METRIC_SCOPE_MISMATCH`
- `RETURN_INSUFFICIENT_REAL_DATA`
- `RETURN_CAUSAL_ATTRIBUTION_UNSUPPORTED`

---

## 4. Entertainment Signal Adapter

### Native source

- skill: `entertainment-rander`

### Position

`Stage 0 Signal Intake` optional source.

### Accepted Output

- cultural meme / entertainment signal
- lifecycle status
- cross-platform evidence
- derivative/creative potential
- possible story-language bridge

### Forbidden

- 直接输出 canonical TopicOpportunity PASS；
- 直接决定 AI mechanism；
- 因娱乐性高就覆盖 Human Relevance / Knowledge Gate；
- 对严肃议题强制梗化。

---

## 5. Story Engine

当前不是外部 Skill Adapter。

Canonical ownership 暂属于 Showrunner internal Story Engine Gate：

TopicOpportunity + KnowledgeCore → StoryPremise

最低字段：protagonist、desire、inciting_incident、action、gap、progressive_complications、turning_point、recognition、choice/payoff、mechanism_in_story、story_summary_without_jargon。

景岁 Writer 在此 Gate PASS 后才可调用。

---

## 6. Director / Shot Compiler

当前不是 Jingsui Visual Beat 的直接透传。

Canonical input：locked Script/SRT + audio timing + Character/Scene/Style context。

Canonical output 必须符合：

- `schemas/shot.schema.json`
- `docs/LOW_LEVEL_EXECUTION_PACKAGE.md`

默认 one-small-shot ≈ one-image，但 shot boundary 由**视觉状态变化**决定，而不是机械按字幕 cue/标点拆。

---

## 7. Admission Status

| Adapter | Status |
|---|---|
| Jingsui Writer | CONTRACT DEFINED / NOT YET EPISODE-VALIDATED |
| Acquisition Learning | CONTRACT DEFINED / NOT YET EPISODE-VALIDATED |
| Entertainment Signal | OPTIONAL / NOT YET EPISODE-VALIDATED |
| Story Engine | INTERNAL PROVISIONAL |
| Director Compiler | SCHEMA DEFINED / IMPLEMENTATION PENDING |
| Antigravity Executor | ROLE FROZEN / INTEGRATION UNKNOWN |

只有真实 episode Evidence 后，才能从 candidate 升为 canonical Worker。