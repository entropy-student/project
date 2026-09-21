# AI Story Showrunner（当前验证工作区）

当前仓库用于验证一个可复用的 **Story Showrunner**：把选题/知识转译成故事驱动、可持续生产、可编排执行的视频。AI 是第一个 Domain Adapter，不是长期唯一边界。

它不是新的“万能视频 Skill”，而是一个 **Showrunner / Orchestrator Control Plane**：负责决定谁在什么时候工作、输入输出必须长什么样、什么条件才能进入下一阶段，以及整期内容最终是否合格。

## 当前 Gate 状态

```text
P0 / G1 / G2 / G2.5 / G3 / G3R / G4 / G5 = PASS
G6 = IN_PROGRESS — Production SRT + TTS Manifest + Antigravity Production Package
G7 = BLOCKED_BY_G6
```

当前 canonical editorial baseline：
- Bilibili；
- DAILY editorial target；
- 3–5 分钟标准目标；
- 第一人称固定 IP；
- STORY_MODEL / STORY_ACTION；
- Daily Topic Planner v0.2 已启用；
- Production throughput 仍为 UNPROVEN。

Owner 当前执行线：**`story-showrunner` Candidate 已迁入 `entropy-student/spike.skill/story-showrunner`；现在回到 G6，用 Candidate Timing Compiler + Voice Timing Profile v2.1 编译 Production SRT / TTS Manifest，再生成完整 Antigravity Production Package。**

## 一句话定位

```text
现实变化 / 热点信号
→ 普通人会遇到什么冲突
→ 背后的 AI 机制是什么
→ 把机制变成故事里的世界规则
→ 结构化故事
→ 口播 / Production SRT（Voice Timing Profile）
→ 逐镜头低层施工包
→ Antigravity 执行 CosyVoice 配音 + 批量生图
→ Antigravity 按锁定时间线拼接
→ 视频初稿
→ QA / 发布与反馈
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

`visual-narrative-animation-lab` 现在定位为本项目的**视觉叙事研发 / 导演语法参考库**，不是默认生产执行链。

```text
Visual Narrative Animation Lab
        ↓
提供 Visual Beat / Shot Grammar / Consistency 经验
        ↓
AI Story Showrunner 编译低层施工包
        ↓
Antigravity 执行
```

默认成片施工路线已冻结为 Antigravity。

### spike.skill

现有 Skill 作为可替换 Worker 接入，而不是复制进本项目。当前已确认的相关能力见：

- `docs/CONTENT_STRATEGY_AND_CONVERSION.md`
- `docs/WORKER_ADAPTER_PLAN.md`
- `docs/WORKER_CONTRACTS.md`
- `docs/LOW_LEVEL_EXECUTION_PACKAGE.md`
- `docs/TOOL_INVENTORY.md`

## Governance

本项目遵循 `entropy-student/spike.skill/vps-project-governance` **v0.1.6 + active addenda** 的内容项目适配版。

当前项目事实以 `REVIEWER_HANDOFF.md` 为 Reviewer 唯一当前真相；`PROJECT_RECORD.md` 保存长期历史与决策；`EXECUTION_EVIDENCE.md` 保存可复核证据；`CURRENT_STATUS.json` 只是机器可读镜像。

详见 `docs/GOVERNANCE_ADAPTATION.md`。

## 当前 Gate

```text
P0  Project Boundary / Governance Reconciliation ✅ PASS
G1  Worker Inventory + Canonical Contracts     ✅ PASS
G2  Topic → Human Problem → Story MVP          ✅ PASS
G2.5 Topic Supply / Ledger / Dedup             ✅ PASS
G3  Story → Script / SRT MVP                   ✅ PASS
G3R Bilibili Editorial / Narrative Rebaseline ✅ PASS
G4  Script/SRT → Director / Shot Compiler MVP  ✅ PASS
G5  Shotbook → Image Asset Package MVP         ✅ PASS
G6  Voice Timing / Production Package PoC      ▶ IN_PROGRESS
G7  Three-topic End-to-End Validation          ⛔ BLOCKED_BY_G6
G8  Semi-automated Orchestration               ⏳
G9  Publish / Analytics Learning Loop           ⏳
G10 Canonical Skill Promotion / Runtime         ⏳  (Candidate 已存在)
```

## P0 已锁定原则

1. **Story-first，不是 concept-first。**
2. 热点负责“为什么现在看”，人类问题负责“为什么值得看”，AI 机制负责“看完得到什么”。
3. AI 概念可以晚出现；故事不能依赖观众先知道专有名词。
4. 麦基式结构属于**故事骨架阶段**，不是成稿后的润色补丁。
5. 景岁类 Skill 当前定位为**候选 Writer Style Engine**，必须通过项目 Adapter 限权，不是全局大脑。
6. Visual Beat 不是“一句一图”；画面由语义变化驱动。
7. **Antigravity 冻结为当前执行 Agent**：不承担导演决策，只执行低层施工指令；Nano Banana 是当前批量生图执行路径。
8. 默认一个小镜头一张图；动作优先拆成多张静态图，不为了省图增加复杂运动。
9. 所有阶段必须有结构化 Handoff；禁止只靠聊天上下文传递。
10. 自动化不得降低人工验证基线。
11. 失败必须在最近的 Gate 被拦截，禁止垃圾输入一路传到成片。

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
docs/CONTENT_STRATEGY_AND_CONVERSION.md
  ↓
docs/WORKER_ADAPTER_PLAN.md
  ↓
docs/WORKER_CONTRACTS.md
  ↓
docs/TOOL_INVENTORY.md
  ↓
EXECUTION_EVIDENCE.md（需要审计执行事实时）
```


## 每日选题排期

Owner 日常查看：`topic-ledger/calendar/YYYY-MM.md`。

Daily Topic Radar 每日维护未来 7 天滚动排期；合格热点只可抢占 `planned` 槽位，`locked` / `published` 不得自动改写。执行合同见 `docs/DAILY_TOPIC_AUTOMATION_V2.md`。


## G3 Writer baseline

Writer quality 采用 McKee 因果骨架 + narrative transportation + short-form retention + Jingsui voice 四层模型。首轮 3 个 validation episode 已通过 Script/SRT QA；详见 `docs/WRITER_QUALITY_CONTRACT.md` 与 `docs/G3_VALIDATION_REVIEW.md`。


## Current execution focus

G5 is now PASS. The high-risk Pilot and reference-path validation both passed.

Current main-line gate: **G6 Low-Level Execution Package / Antigravity PoC**.

Current G6 task:
- use frozen Voice Timing Profile v2.1;
- compile Production SRT + TTS Manifest before normal TTS execution;
- compile the full Antigravity Production Package;
- let Antigravity execute locked CosyVoice TTS + images + edit + export.

Long-term target:
- `story-showrunner` Candidate 已完成抽取；完整 E2E PASS 后再从 CANDIDATE 升级为 CANONICAL;
- default topic source is today's Calendar unless the user explicitly overrides it;
- normal production does not require Owner approval of script/SRT/key frames; key-frame sampling is calibration-only.

See also:
- `docs/STORY_SHOWRUNNER_SKILL_TARGET.md`
- `docs/VOICE_TIMING_PROFILE_SPEC.md`

See:
- `docs/G5_GATE_REVIEW.md`
- `experiments/g5/blind-search-answer/18_REFERENCE_PATH_VALIDATION.md`
- `docs/LOW_LEVEL_EXECUTION_PACKAGE.md`
