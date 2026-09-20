# AI Story Showrunner — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance baseline: `entropy-student/spike.skill/vps-project-governance` v0.1.6 + active addenda  
> Project-specific adaptation: `docs/GOVERNANCE_ADAPTATION.md`  
> Detailed execution facts: `EXECUTION_EVIDENCE.md`

## 1. Project Goal

- Final goal: 建立一个可复用的 AI 内容总导演 / 编排系统，把 AI 热点与概念稳定转成故事、脚本、Visual Beats、图片资产、视频与发布反馈闭环。
- Current goal: 完成 G1，冻结 Worker Inventory、Canonical Contracts、Episode State 与 Worker Adapter 边界；在此之前不宣称“自动化已打通”。

## 2. Authority / Source of Truth

治理规则优先级：

1. Owner 当前最新明确指令；
2. active Reviewer 当前 bounded override / project adaptation；
3. GitHub canonical Governance latest：`entropy-student/spike.skill/vps-project-governance`；
4. 历史 Governance 副本 / 聊天。

本项目事实优先级：

1. 当前 accepted Reviewer decision / 本 `REVIEWER_HANDOFF.md`；
2. fresh authoritative GitHub read-back + accepted `EXECUTION_EVIDENCE.md`；
3. `PROJECT_RECORD.md`；
4. README / 历史聊天。

`PROJECT_RECORD.md` 保存长期项目记录；本文件保存当前 Gate 的权威状态。两者不得维护竞争状态。

## 3. Current Architecture

- Runtime/framework: 当前仍是文档化 Orchestration Architecture；尚未建立 runtime orchestrator。
- Deployment: N/A，当前无生产部署。
- Data/persistence: GitHub project docs + 后续 Episode Package / state artifacts。
- Network/exposure: N/A。
- Auth/secrets: 当前无项目 Secret；若后续接外部模型/API，按 Governance Secret Policy 单独治理。
- Shared Infra dependencies: 当前 N/A。
- External workers: `entropy-student/spike.skill` 中多个 Skill + `visual-narrative-animation-lab`。
- Execution model: **Antigravity 已冻结为当前受限 Execution Agent**；Nano Banana 为当前图片生成路径。其程序化/自动化集成方式仍为 `INTEGRATION_UNKNOWN`。
- Target-host boundary: 当前所有项目事实以 GitHub authoritative read-back 为准；未声称修改用户本地主机。

## 4. Current State

```text
P0  Project Boundary / Governance Reconciliation     ✅ PASS
G1  Worker Inventory + Canonical Contracts           ✅ PASS
G2  Topic → Human Problem → Story MVP                ✅ PASS
G2.5 Topic Supply / Ledger / Dedup                   ✅ PASS
G3  Story → Script / SRT MVP                         ✅ PASS
G4  Script/SRT → Director / Shot Compiler MVP         ⏸ PENDING
G5  Shotbook → Image Asset Package MVP               ⏳
G6  Image Assets → Video MVP                         ⏳
G7  Three-topic End-to-End Validation                ⏳
G8  Semi-automated Orchestration                     ⏳
G9  Publish / Analytics Learning Loop                ⏳
G10 Reusable Showrunner Skill / Runtime              ⏳
```

## 5. Accepted Gates

### P0 — Project Boundary / Governance Reconciliation

Reviewer decision: **PASS**

Accepted baseline:

- 新项目独立于 `visual-narrative-animation-lab`；
- Showrunner = Control Plane；现有 Skill = Worker；
- 核心内容母模型：`现实变化 → 人类冲突 → 故事 → AI规律 → 应对方式`；
- One Brain, Many Workers；
- 结构化 handoff + nearest-gate rollback；
- Provider / model / renderer 均走 Adapter；
- Governance 使用 v0.1.6 适配版，部署类条款当前 N/A；
- 已补齐唯一 Reviewer Handoff 和 Evidence 连续性。

P0 的最初仓库建档发生在正式 Governance reconciliation 之前。该历史偏差已在 `EXECUTION_EVIDENCE.md` 中记录，并通过 fresh GitHub read-back 对当前事实进行重新核验；不删除历史、不伪造 Executor 证据。

### G1 — Worker Inventory + Canonical Contracts

Reviewer decision: **PASS**

Accepted baseline:

- TopicOpportunity contract 已冻结并机器化；
- Episode State schema 已建立；
- Low-Level Shot schema 已建立；
- 景岁 Skill 定位为候选 Writer Style Engine，并通过 Adapter 限权；
- acquisition-growth-radar 定位为 Publish/Learning Adapter；
- entertainment-rander 仅作为 optional Signal Source；
- 当前扫描未发现独立 Topic Skill，采用 contract-first，不提前新造 Skill；
- 当前扫描未发现独立 McKee Skill，冻结为 Showrunner 内部 Story Engine Gate；
- Antigravity 集成级别明确为 `MANUAL_EXECUTOR / NOT_YET_POC_VALIDATED`；
- AUDIO_MODE A/B 路径与 PoC 标准已定义；
- Worker admission 必须经过真实 episode evidence。

G1 contracts:

- `docs/CONTENT_STRATEGY_AND_CONVERSION.md`
- `docs/WORKER_ADAPTER_PLAN.md`
- `docs/ADAPTER_FIELD_MAPPINGS.md`
- `docs/LOW_LEVEL_EXECUTION_PACKAGE.md`
- `docs/ANTIGRAVITY_POC.md`
- `schemas/topic_opportunity.schema.json`
- `schemas/episode.schema.json`
- `schemas/shot.schema.json`

## 6. Accepted Gate — G2

Reviewer decision: **PASS**

Validation review: `docs/G2_VALIDATION_REVIEW.md`

### Goal

验证 Story-first Topic Contract 能否把不同类型的 AI 主题稳定转成：

```text
Signal / Concept
→ Human Problem
→ one AI Mechanism
→ Storyable Situation
→ StoryPremise
```

### Validation Set

1. MCP；
2. AI Agent / Agentic Action；
3. Context / Memory。

### Allowed Scope

- fresh research / KnowledgeCore；
- TopicOpportunity；
- Human Problem / Stakes；
- StoryPremise；
- No-name / Storyability / One-Mechanism / Non-Trivial Payoff gates；
- DISCOVERY / TRUST / SOLUTION role selection。

### Forbidden Scope

- 不提前把题目写成完整景岁稿；
- 不生成正式图片或视频；
- 不为了流量改变技术事实；
- 不因为 conversion adjacency 高就强行做 SOLUTION；
- 不允许多个核心 AI mechanism 混进一条 MVP。

### Acceptance Criteria

三个题目至少都能产出：

- valid TopicOpportunity；
- one locked KnowledgeCore；
- 一个删掉术语仍成立的 StoryPremise；
- 明确 reject/return reason；
- primary_content_job 与 conversion_adjacency；
- 无关键事实错误。

### Rollback

G2 只回到 Topic / Knowledge / Story，不触碰 Production 层。

## 7. Confirmed Facts

- `entropy-student/project` 根规范要求 one project / one directory + PROJECT_RECORD。
- canonical Governance 当前为 v0.1.6 + active addenda。
- `visual-narrative-animation-lab` 是下游视觉叙事研发/生产能力，不是总控项目。
- 已确认存在：
  - `acquisition-growth-radar`
  - `jingsui-story-video-director`
  - `short-form-spoken-script`
  - `aroll-video-maker`
  - `narrative-motion-semantics`
  - `video-talkcraft-design-orchestrator`
- `narrative-motion-semantics` 当前明确标记 INCOMPLETE。
- 项目核心尚未建立程序化 orchestration runtime。

## 8. UNKNOWN / Open Risks

- 独立 Topic Skill：当前 `spike.skill` 扫描未发现，G2 采用 contract-first；是否抽成 Skill 等至少 3 个真实 episode 后决定。
- McKee：当前冻结为内部 Story Engine Gate；若未来找到更权威现有能力可重新评估。
- Antigravity：`MANUAL_EXECUTOR / NOT_YET_POC_VALIDATED`；PROGRAMMATIC 尚未证明。
- 图片到成片的主路线已冻结：Antigravity 严格执行 Low-Level Execution Package；Aroll / Visual Narrative Lab / TalkCraft 暂不作为默认执行链。
- 音频路径仍待定：上游先 TTS，或由 Antigravity 严格按 locked script/SRT 生成。
- 后续是否需要独立数据库保存 Episode / Content Ledger：G8 前暂不决定。

## 9. Owner-only Checkpoints

当前 G1：**无 Owner-only 动作**。

未来可能包括：

- 外部平台账号授权；
- API Secret 录入；
- 真实发布账号权限；
- material production auto-publish enablement；
- 不可逆删除 / 大规模批量发布。

这些不得由 Worker 默认继承。

## 10. Resource Baseline

当前为文档 / workflow 项目：

- Root disk: N/A
- Project source: GitHub `entropy-student/project/ai-story-showrunner`
- Durable runtime data: 尚未建立
- Production image: N/A
- Build cache/browser runtime: N/A

若未来引入 VPS / local runtime，本节重新进入适用范围。

## 11. Rollback / Recovery

- 当前所有变更均为 Git 可追溯文本文件；
- 历史 commit 可作为 rollback point；
- 当前不存在 DB / Secret /生产数据恢复风险。

## 6.5 Current Gate — G2.5 Topic Supply / Ledger / Dedup

Reviewer status: **PASS**

Purpose:
- 冻结 HOT + EVERGREEN 双轨选题供应；
- 建立 Topic Registry，而不是只靠日历；
- 建立四层去重：signal / topic / angle / story-visual motif；
- 建立 Daily Radar snapshot contract；
- 建立 Evergreen Bank；
- 冻结“合格热点抢占，否则走常规池”的排期逻辑；
- 每日自动任务已批准启用：只做 Radar + rolling schedule，不自动发布。

Artifacts:
- `docs/TOPIC_OPERATING_SYSTEM.md`
- `topic-ledger/README.md`
- `topic-ledger/topic-registry.jsonl`
- `topic-ledger/daily/TEMPLATE.json`
- `topic-ledger/calendar/2026-09.md`
- `topic-ledger/EVERGREEN_BANK.md`
- `schemas/topic_registry_entry.schema.json`

External evidence used:
- 抖音精选优质内容标准；
- 小红书热点榜公开排序规则；
- YouTube 官方选题/趋势/可持续内容建议；
- Information Gap / curiosity research；
- Berger & Milkman virality research；
- AI-TREND-RADAR / TrendRadar public projects。

Accepted:
- Topic Operating System accepted；
- Daily Topic Radar enabled；
- GitHub calendar is Owner-facing schedule；
- rolling horizon = 7 days；
- only `planned` slots may be hot-overridden.

## 12. Next Step

- Reviewer next action: G2.5 已 PASS；可进入 G3，验证 Jingsui Writer Adapter。
- Executor next action: G2 暂无 Antigravity 执行；只在 Production PoC 时触发。
- Owner intervention required: **NO**

## 13. Status Summary

- 整体进展：P0、G1、G2 已 PASS；上游内容模型已通过三类题型首轮验证。
- 最终目标：AI Story Showrunner 成为唯一总控层，候选 Skill 经 Adapter 接入，Antigravity 负责低层施工。
- 当前状态：G2.5 PASS / READY FOR G3。
- 本轮完成：流量/信任/转化 Contract、Topic schema、Episode schema、Shot schema、Worker Adapter 规则、字段映射、Antigravity PoC 定义。
- 下一步：进入 G3；Daily Topic Radar 独立持续维护 GitHub rolling schedule。
- 注意事项：当前绝不能把“文档架构已完成”误称为“流水线已经自动跑通”。


## Accepted Gate — G3 Story → Script / SRT MVP

Reviewer decision: **PASS**

Artifacts:
- `docs/WRITER_QUALITY_CONTRACT.md`
- `docs/G3_VALIDATION_REVIEW.md`
- each validation episode `04_script.md`
- each validation episode `04_script.srt`

Accepted writer model:
- McKee causal structure;
- narrative transportation;
- short-form retention;
- Jingsui voice as style layer only.

Project overrides:
- no forced self-introduction;
- no forced first-person;
- no forced English sign-off;
- no Writer visual/edit authority.

Three episodes passed Script↔SRT exact consistency and no tutorial-regression material issue.

Jingsui adapter status:
`QUALITY_VALIDATED / MANUAL_ORCHESTRATION`

Next:
G4 Director / Shot Compiler. Do not claim programmatic writer orchestration; that remains later automation work.


## HOLD — G3 Editorial Rebaseline for Bilibili-first Strategy

Owner clarified Bilibili is the primary platform and questioned the 70–85s short-form baseline, narrative POV, IP role, and long-term acquisition/content strategy.

Decision:
- G3 short-form samples remain valid as **writer capability evidence only**.
- They are NOT the final editorial baseline.
- 70–85s is no longer canonical.
- G4 is blocked.
- Rebaseline must decide Bilibili-first duration, IP narrator/protagonist model, story-vs-explainer balance, and early-channel content portfolio before production continues.

Current state:
`HOLD_FOR_G3_EDITORIAL_REBASELINE`


## G3R — Bilibili Editorial / Narrative Rebaseline

Reviewer status: **OWNER ALIGNED / HOLD / NOT PASS**

Artifacts:
- `docs/BILIBILI_CHANNEL_STRATEGY.md`
- `docs/G3R_EDITORIAL_REVIEW.md`
- proposed Bilibili additions in `docs/WRITER_QUALITY_CONTRACT.md`
- `docs/DAILY_TOPIC_AUTOMATION_V2_PROPOSAL.md`

Proposed decisions:
1. Primary platform = Bilibili.
2. Editorial publishing target = daily.
3. Production throughput remains UNPROVEN until G4–G7.
4. Default narrator = first-person recurring channel IP.
5. Story mechanism model follows “world rule produces consequences”, not definition-first explanation.
6. Bilibili primary duration target = 3–5 min; extend only when story requirements justify it.
7. Business Job remains DISCOVERY / TRUST / SOLUTION.
8. Editorial Mode = STORY_MODEL / STORY_ACTION only.
9. First 21 published episodes = Season 0 calibration.
10. Initial portfolio hypothesis = 5 STORY_MODEL / 2 STORY_ACTION per 7 days.
11. Tutorial channel module was removed by Owner; actionable methods only appear when they pass Actionability Gate.
12. Existing 70–85s G3 scripts remain writer capability references only.

Growth diagnosis:
Early account bottleneck is Audience / Situation × Message / Creative Fit. Do not optimize early episodes around hypothetical product sales.

Live automation safety:
The currently scheduled Daily Topic Radar remains on the accepted v0.1 behavior until Owner PASS. The proposed v0.2 planner has NOT been activated.

Next:
G4 remains BLOCKED pending resolution of two Owner questions and explicit Owner PASS / RETURN on G3R.


## G3R Refinement — Tutorial Removed / Story Craft Tightened

Owner decision:
- remove STORY_TUTORIAL as a channel module;
- retain STORY_MODEL and STORY_ACTION only.

Updated proposal:
- weekly hypothesis = 5 STORY_MODEL / 2 STORY_ACTION;
- default content length target centered on 3–5 min, with extension only when story requirements justify it;
- opinion is optional, bounded, and must not be the factual/story load-bearing wall;
- new Story Beat Gate requires immediate want → action → response/resistance → result → state change → next causal question/decision.

G4 remains BLOCKED pending Owner PASS on the rebaseline.


## Current Authoritative G3R State — Owner Aligned, Not Passed

Latest Owner instruction:
- overall direction accepted for documentation consolidation;
- explicit PASS withheld;
- two editorial issues remain to be discussed.

Current candidate baseline:
- Bilibili primary;
- daily editorial target;
- primary duration target 3–5 min, justified exceptions allowed;
- recurring first-person channel IP;
- STORY_MODEL + STORY_ACTION only;
- initial mix hypothesis 5 / 2;
- viewpoint optional and bounded;
- Story Beat Gate requires causal state change;
- live Daily Topic Radar remains on accepted v0.1 until explicit PASS.

Hard state:
`G3R = HOLD`
`OPEN_QUESTIONS = 2`
`G4 = BLOCKED`

## G3R Narrative Style Alignment + Smoke Test

Owner response to the narrative/viewpoint review: **strongly aligned**, but overall G3R remains HOLD because one additional editorial issue is still pending.

New candidate contract:
- `docs/NARRATIVE_STYLE_CONTRACT.md`

Three added safeguards:
1. Controlling Question before thesis;
2. Idea vs Counter-Idea;
3. Lightness Guard — McKee structure must remain invisible on the surface.

Narrative smoke test:
- `episodes/20260920-agent/G3R_narrative_test_v1.md`
- review: `episodes/20260920-agent/G3R_narrative_test_review_v1.md`
- status: PASS_CANDIDATE / OWNER REVIEW

No G4 work started.

Current:
`G3R HOLD / 1 OPEN OWNER QUESTION / G4 BLOCKED`.

## G3R Dialogue Promotion + Cross-topic Narrative Validation

Owner approved continuing the dialogue/prose refinement direction.

Promoted into main candidate contracts:
- `docs/NARRATIVE_STYLE_CONTRACT.md` v0.2;
- `docs/WRITER_QUALITY_CONTRACT.md` v0.3.

The temporary candidate file is retained only as superseded historical review evidence:
- `docs/DIALOGUE_PROSE_REFINEMENT_CANDIDATE.md`.

Dialogue/prose rules now include:
- verbal action;
- subtext;
- character-specific vocabulary;
- dramatic economy;
- action/reaction/silence;
- selective line design;
- concrete method before abstraction.

Cross-topic narrative tests:
1. Agent — `episodes/20260920-agent/G3R_narrative_test_v2.md` — self-review 91/100.
2. Context / Memory — `episodes/20260920-context-memory/G3R_narrative_test_v1.md` — self-review 89/100.

Cross-topic finding:
- the narrative system works for both permission/risk conflict and lower-stakes conceptual misunderstanding;
- shared structure is desire → character-caused action → mechanism pushes back → state changes → recognition;
- specific conflict shape must remain topic-dependent and must NOT become a repeated template.

Current governance state:
```text
G3R = HOLD
OPEN_QUESTIONS = 0
READY_FOR_OWNER_PASS_DECISION = YES
G4 = BLOCKED UNTIL EXPLICIT OWNER PASS
```

