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
G3  Story → Script / SRT MVP                         ⏸ PENDING
G4  Script → Director Shotbook MVP                   ⏳
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

## 12. Next Step

- Reviewer next action: G2 已完成；下一步进入 G3，用 Jingsui Writer Adapter 把 locked StoryPremise 转成 Script / SRT，但不得改变 KnowledgeCore。
- Executor next action: G2 暂无 Antigravity 执行；只在 Production PoC 时触发。
- Owner intervention required: **NO**

## 13. Status Summary

- 整体进展：P0、G1、G2 已 PASS；上游内容模型已通过三类题型首轮验证。
- 最终目标：AI Story Showrunner 成为唯一总控层，候选 Skill 经 Adapter 接入，Antigravity 负责低层施工。
- 当前状态：G2 PASS / READY FOR G3。
- 本轮完成：流量/信任/转化 Contract、Topic schema、Episode schema、Shot schema、Worker Adapter 规则、字段映射、Antigravity PoC 定义。
- 下一步：G3 验证 Jingsui Writer Adapter 是否能在不破坏故事与事实的前提下生成高质量口播稿与 SRT。
- 注意事项：当前绝不能把“文档架构已完成”误称为“流水线已经自动跑通”。
