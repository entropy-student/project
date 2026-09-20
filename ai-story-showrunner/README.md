# AI Story Showrunner（AI故事总导演系统）

把 AI 常见概念、AI 时事与普通人的现实处境，转译成**故事驱动、可持续生产、可编排执行**的视频内容系统。

它不是新的“万能视频 Skill”，而是一个 **Showrunner / Orchestrator Control Plane**：负责决定谁在什么时候工作、输入输出必须长什么样、什么条件才能进入下一阶段，以及整期内容最终是否合格。

## 一句话定位

```text
现实变化 / 热点信号
→ 普通人会遇到什么冲突
→ 背后的 AI 机制是什么
→ 把机制变成故事里的世界规则
→ 结构化故事
→ 口播 / SRT
→ Visual Beats / Shotbook
→ 图片资产
→ 图片序列视频
→ 发布与反馈
```

核心不是“给 AI 概念套故事”，而是：

> **现实变化 → 人类冲突 → 故事 → AI 规律 → 观众知道该怎么看 / 怎么做。**

## 为什么需要这个项目

现有工具已经覆盖了不少单点能力：

- 获客 / 增长诊断；
- 故事型漫画口播；
- 短视频口播；
- Visual Beat / A-roll；
- 叙事动效语义；
- TalkCraft / Remotion 编排；
- 画面叙事动画实验；
- 外部生图执行器。

真正缺失的是**统一上游大脑**：

1. 谁先执行；
2. 谁后执行；
3. 上一步必须交出什么；
4. 什么情况下退回重做；
5. 哪个文件是本期唯一真相；
6. 更换模型 / Skill / 渲染器时如何不推倒全流程。

本项目只解决这一层。

## 核心设计

```text
                    Owner
                      ↓
               AI Story Showrunner
             ┌────────┼────────┐
             ↓        ↓        ↓
        Editorial   Story    Production
          Workers   Workers     Workers
             ↓        ↓        ↓
          Topic    Script     Director
        Research   / SRT      / Assets
             └────────┼────────┘
                      ↓
             Render / Publish / Data
                      ↓
                 Learning Loop
```

### Showrunner 的权力

Showrunner 只拥有四类权力：

- **Routing**：决定调用哪个 Worker；
- **Contract**：规定输入输出格式；
- **Gate**：决定 PASS / RETURN / HOLD；
- **State**：维护 episode 的唯一权威状态。

Worker 不应该互相自由调用，也不应该各自维护一份“当前真相”。

## 内容中间态

为了避免两种极端：

- 太专业：直接从 OpenAI / MCP / Agent 等名词进入；
- 太低级：停留在“GPT 可以帮你写作业”。

每期必须经过一层 Audience Translation：

```text
Company / Model / Protocol / Feature
                ↓
        AI capability change
                ↓
      Human consequence / tension
                ↓
             Story
```

默认采用：

> **第三层进入（人的处境） → 第二层展开（社会/能力变化） → 第一层解释（技术机制）。**

## 与现有项目的关系

### Visual Narrative Animation Lab

`visual-narrative-animation-lab` 是本项目的**下游视觉叙事研发 / 生产能力**，不是本项目本身。

```text
AI Story Showrunner
        ↓
Story / Script / Shotbook contract
        ↓
Visual Narrative Animation Lab
        ↓
Visual Beat / Asset / Animatic / Render
```

### spike.skill

现有 Skill 作为可替换 Worker 接入，而不是复制进本项目。当前已确认的相关能力见：

- `docs/TOOL_INVENTORY.md`
- `docs/WORKER_CONTRACTS.md`

## Governance

本项目遵循 `entropy-student/spike.skill/vps-project-governance` **v0.1.6 + active addenda** 的内容项目适配版。

当前项目事实以 `REVIEWER_HANDOFF.md` 为 Reviewer 唯一当前真相；`PROJECT_RECORD.md` 保存长期历史与决策；`EXECUTION_EVIDENCE.md` 保存可复核证据；`CURRENT_STATUS.json` 只是机器可读镜像。

详见 `docs/GOVERNANCE_ADAPTATION.md`。

## 当前 Gate

```text
P0  Project Boundary / Governance Reconciliation ✅ PASS
G1  Worker Inventory + Canonical Contracts     ← HERE
G2  Topic → Human Problem → Story MVP          ⏳
G3  Story → Script / SRT MVP                   ⏳
G4  Script → Director Shotbook MVP             ⏳
G5  Shotbook → Image Asset Package MVP         ⏳
G6  Image Assets → Video MVP                   ⏳
G7  Three-topic End-to-End Validation          ⏳
G8  Semi-automated Orchestration               ⏳
G9  Publish / Analytics Learning Loop           ⏳
G10 Reusable Showrunner Skill / Runtime         ⏳
```

## P0 已锁定原则

1. **Story-first，不是 concept-first。**
2. 热点负责“为什么现在看”，人类问题负责“为什么值得看”，AI 机制负责“看完得到什么”。
3. AI 概念可以晚出现；故事不能依赖观众先知道专有名词。
4. 麦基式结构属于**故事骨架阶段**，不是成稿后的润色补丁。
5. 景岁类 Skill 属于**表达 / 叙事执行层**，不是全局大脑。
6. Visual Beat 不是“一句一图”；画面由语义变化驱动。
7. 生图模型是 Adapter；Nano Banana 是当前候选执行器，不进入核心架构锁定。
8. 所有阶段必须有结构化 Handoff；禁止只靠聊天上下文传递。
9. 自动化不得降低人工验证基线。
10. 失败必须在最近的 Gate 被拦截，禁止垃圾输入一路传到成片。

## 阅读顺序

```text
README.md
  ↓
REVIEWER_HANDOFF.md
  ↓
CURRENT_STATUS.json
  ↓
PROJECT_RECORD.md
  ↓
docs/ARCHITECTURE.md
  ↓
docs/PIPELINE_AND_GATES.md
  ↓
docs/WORKER_CONTRACTS.md
  ↓
docs/TOOL_INVENTORY.md
  ↓
EXECUTION_EVIDENCE.md（需要审计执行事实时）
```
