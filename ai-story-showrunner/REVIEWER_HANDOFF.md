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
- External adapters: Antigravity / Nano Banana 等目前仅标记为 `EXTERNAL_ADAPTER / INTEGRATION_UNKNOWN`。
- Target-host boundary: 当前所有项目事实以 GitHub authoritative read-back 为准；未声称修改用户本地主机。

## 4. Current State

```text
P0  Project Boundary / Governance Reconciliation     ✅ PASS
G1  Worker Inventory + Canonical Contracts           ← CURRENT
G2  Topic → Human Problem → Story MVP                ⏳
G3  Story → Script / SRT MVP                         ⏳
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

## 6. Current Gate — G1

### Goal

把“有很多 Skill”变成可执行的系统接口，而不是人工凭记忆串联。

### Allowed Scope

- 继续遍历并定位已有选题 / 研究 /故事 / 导演 / 生图 / 渲染能力；
- 冻结每个 Stage 的 canonical input/output；
- 建立 Episode Package 和 machine-readable status；
- 建立 Worker Adapter 映射；
- 标记 UNKNOWN / TO_LOCATE / EXTERNAL_ADAPTER；
- 必要时新增纯文档 / schema / contract 文件。

### Forbidden Scope

- 不提前生产正式视频；
- 不把“UI 中能用的工具”宣称成“可程序化调用”；
- 不新造已有 Skill 的重复版本；
- 不为了跑通流程静默修改上游 Skill；
- 不跳过 G1 直接宣称半自动；
- 不把 MCP / Agent / Memory 的故事测试结果提前写成 G2 PASS。

### Acceptance Criteria

G1 PASS 必须同时满足：

1. 每个 Stage 有明确 owner / worker role；
2. 每个 Stage 有 canonical input/output；
3. Episode state 能唯一定位当前 Gate；
4. 现有 Worker 与 Stage 的 Adapter 映射清晰；
5. 所有未知能力显式标记，不猜；
6. 选题 Skill canonical 位置已找到，或明确证据证明需要新建；
7. McKee 结构层位置已冻结；
8. Nano Banana / Antigravity 的集成级别已明确：PROGRAMMATIC / MANUAL_EXECUTOR / UNKNOWN；
9. G2 的唯一执行合同可直接下发，不需要 Owner 补充技术判断。

### Evidence Required

- GitHub file/path read-back；
- Worker source / version / blob SHA（能获取时）；
- contracts/schema 文件存在且相互一致；
- CURRENT_STATUS / Reviewer Handoff 与 Project Record 状态一致；
- UNKNOWN 清单没有被计划文字冒充事实。

### Rollback

G1 只涉及项目本地可逆文档 / schema 变更。若 contract 设计错误，回退对应文件即可；不影响外部 Worker、生产系统或用户资产。

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

- 独立“选题 Skill / 历史选题账本”的 canonical 位置：**TO_LOCATE**。
- McKee 结构是否已有独立 canonical Skill：**TO_LOCATE / likely Story Engine Gate**。
- Antigravity / Nano Banana 是否可稳定程序化调用：**INTEGRATION_UNKNOWN**。
- 最终实际渲染主路线在 Aroll / Visual Narrative Lab / TalkCraft 中如何选择：G1 需形成 routing rule。
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

- Reviewer next action: 完成 G1 的剩余定位与 contract freeze。
- Executor next action: 暂未下发独立 Executor Gate；G1 合同冻结后再决定是否需要 Executor。
- Owner intervention required: **NO**

## 13. Status Summary

- 整体进展：项目已立项，治理已对齐，进入“把工具收编成系统”的 G1。
- 最终目标：AI Story Showrunner 成为唯一总控层，现有 Skill 作为可替换 Worker 运转。
- 当前 Gate：G1 Worker Inventory + Canonical Contracts。
- 本轮完成：治理规范核对、缺口识别、唯一 Reviewer Handoff 建立、P0 重新对账。
- 下一步：完成 G1 剩余 UNKNOWN 与机器可读 contract。
- 注意事项：当前绝不能把“文档架构已完成”误称为“流水线已经自动跑通”。
