# AI Story Showrunner — PROJECT RECORD

> 本文件是项目长期单一真相。重新接手本项目时，先读本文件，再读 `docs/`。

## 1. Final Goal

建立一个可复用的 AI 内容总导演系统，把：

```text
热点 / AI 变化 / 常见概念
```

稳定转成：

```text
普通人愿意看的故事
+ 看完真正理解的 AI 机制
+ 可执行的导演分镜
+ 可批量生产的图片资产
+ 图片序列视频
+ 发布后的反馈学习
```

最终目标不是“一条视频自动生成”，而是形成一个**可持续的 Content Operating System**：

```text
Signal
→ Topic Opportunity
→ Human Problem
→ AI Mechanism
→ Story Premise
→ Story Structure
→ Script / SRT
→ Director Shotbook
→ Asset Manifest
→ Render
→ QA
→ Publish
→ Feedback
→ Next Episode
```

## 2. Why This Project Exists

当前已经存在大量单点工具，但没有统一编排层。

如果继续让每个 Skill 自己决定下一步，会出现：

- 多个 Skill 都认为自己是“大脑”；
- 同一内容被重复改写；
- 上游结构被下游风格化破坏；
- SRT / 分镜 / Prompt 各自维护不同版本；
- 出错后不知道应该退回哪一步；
- 换生图模型或渲染器时整条链重做；
- 历史选题、角色、世界观和资产无法稳定复用。

因此本项目的主要产物不是某个模型 Prompt，而是：

> **State Machine + Contracts + Gates + Episode Truth + Worker Routing**

## 3. Product Thesis

本项目的内容母模型正式定义为：

> **现实变化 → 人类冲突 → 故事 → AI 规律 → 应对方式。**

不是：

> AI 概念 → 故事包装。

目标参考不是传统“什么是 X”型科普，而是类似“小岛经济学”的机制：

- 世界先运转；
- 人物先遇到问题；
- 冲突推动因果；
- 概念从事件中自然出现；
- 观众先理解，再知道术语。

## 4. Audience Middle Layer

每个题目必须跨过三层：

```text
L1 Technical Entity
OpenAI / Anthropic / MCP / Agent / Context Window
        ↓
L2 Capability / Social Change
AI 能调用工具 / 替人执行 / 记住上下文 / 做决策
        ↓
L3 Human Situation
我想让它替我做事，但不想把决定权完全交出去
```

默认入口：

> **L3 → L2 → L1**

### Middle-Layer Gate

一个题目若无法同时通过以下测试，不进入写稿：

1. **No-name Test**：删掉公司名 / 产品名 / 协议名后，故事仍然值得看；
2. **Not-trivial Test**：不是“AI 能做什么”的初级功能罗列；
3. **Why-now Test**：能解释为什么这个问题现在值得谈；
4. **Human-stakes Test**：存在人的欲望、代价、选择、误判或冲突；
5. **Mechanism Test**：背后确实存在值得理解的 AI 机制。

## 5. Showrunner Role

Owner 负责方向、偏好和最终否决。

AI Story Showrunner 负责：

- 维护 episode state；
- 调度 Worker；
- 冻结每个 Gate 的输入；
- 识别失败发生在哪一层；
- 决定 RETURN 到哪个最近上游；
- 保护已经验证过的结构不被后续 Skill 静默破坏；
- 最终做 Story / Knowledge / Visual / Production QA。

Showrunner 不重复实现 Worker 的专业能力。

## 6. Current Authoritative Status

```text
P0  Project Boundary / Architecture            PASS
G1  Worker Inventory + Canonical Contracts     CURRENT
G2  Topic → Human Problem → Story MVP          PENDING
G3  Story → Script / SRT MVP                   PENDING
G4  Script → Director Shotbook MVP             PENDING
G5  Shotbook → Image Asset Package MVP         PENDING
G6  Image Assets → Video MVP                   PENDING
G7  Three-topic End-to-End Validation          PENDING
G8  Semi-automated Orchestration               PENDING
G9  Publish / Analytics Learning Loop           PENDING
G10 Reusable Showrunner Skill / Runtime         PENDING
```

## 7. P0 Completed

- 深度检查 `entropy-student/project` 的项目库规范；
- 对比 `visual-narrative-animation-lab`，确认新项目必须独立立项；
- 遍历 `entropy-student/spike.skill` 当前相关能力；
- 确认现有系统不缺单点 Tool，主要缺 Orchestration Contract；
- 冻结 Story-first 内容母模型；
- 冻结 Showrunner / Worker 分层；
- 冻结 Gate-first 错误拦截机制；
- 建立首版架构、流水线、Worker 契约和工具清单。

## 8. Existing Workers / Dependencies

已确认可复用：

- `acquisition-growth-radar`：发布后的增长 / 验证反馈层；
- `jingsui-story-video-director`：故事型口播、SRT、Visual Beat、分镜与生图计划的重要 Worker；
- `short-form-spoken-script`：短视频 Promise / Hook / 口播 / SRT 的候选脚本 Worker；
- `aroll-video-maker`：配音主时间轴 + Semantic Director + Visual Beat + Remotion 路径；
- `narrative-motion-semantics`：流程 / 时间 / 对比 / 因果动效语义库，目前明确 INCOMPLETE；
- `video-talkcraft-design-orchestrator`：TalkCraft 的上层视觉编排入口；
- `visual-narrative-animation-lab`：画面叙事语法、Asset Resolution、Animatic 的项目级下游能力。

尚未在当前 Skill 仓库中确认到 canonical 位置：

- 独立“选题 Skill / 历史选题账本”；
- 独立“麦基结构 Skill”；
- Antigravity / Nano Banana 的稳定程序化调用接口。

这些必须标记为 `TO_LOCATE / TO_DEFINE / EXTERNAL_ADAPTER`，不得假装已经自动打通。

## 9. Locked Architectural Decisions

### D1. One Brain, Many Workers

只有 Showrunner 维护全局 episode 状态。

Worker：

- 只读取指定输入；
- 只输出自己的 Contract；
- 不擅自改上游已锁定字段；
- 不决定跨阶段路线。

### D2. Structured Handoff First

所有核心阶段必须输出结构化 artifact。

禁止：

```text
“上一段聊天里大概已经说过”
→ 下一 Skill 自己猜
```

### D3. Separate Truth From Presentation

故事事实、AI 机制、来源证据、角色设定、脚本文字、SRT、镜头和图像资产必须分别有 canonical field / artifact。

### D4. Provider Adapter

Nano Banana、其他图片模型、Remotion、其他渲染器都属于 Adapter。

核心 Pipeline 不以单一 Provider 名称设计。

### D5. Nearest-Gate Rollback

失败只回退到能够修复问题的最近上游。

例如：

- AI 机制错误 → 回到 Research / Knowledge Gate；
- 故事无冲突 → 回到 Story Gate；
- 文案太像教程 → 回到 Script / Story，不重做图片；
- 人物漂移 → 回到 Asset / Character Lock，不重写故事。

## 10. Primary Risks

### R1. Story Washing

表面有人物、有情节，本质仍是“什么是 MCP”。

**Control**：No-name Test + Story Causality Gate。

### R2. Hotspot Drift

为了蹭热点，把公司新闻直接当选题。

**Control**：必须先翻译成人类问题和长期机制。

### R3. Oversimplification

为了普通人可懂，退化成低价值功能介绍。

**Control**：Mechanism Test + 非初级 takeaway。

### R4. Worker Collision

多个脚本 / 导演 Skill 重复改写同一层。

**Control**：单一 stage owner + immutable upstream fields。

### R5. Fake Automation

看起来“有很多 Skill”，实际仍靠人工复制粘贴和上下文记忆。

**Control**：G1 先定义机器可读 Handoff；G8 才允许宣称半自动编排。

### R6. Provider Lock-in

流程过度绑定 Nano Banana / 某个视频模型。

**Control**：Adapter Contract。

### R7. Visual Drift

角色、场景、道具每期重造，无法形成 IP 世界。

**Control**：World / Character / Scene Bible + Asset Resolver。

### R8. Metrics Corruption

为了播放量逐渐牺牲故事完整性和知识准确性。

**Control**：Growth 数据只优化可验证环节，不越级重写内容原则。

## 11. MVP Validation Set

G2–G7 首轮不做大量选题，固定使用三类难度不同的题目验证：

1. **MCP**：抽象协议类；
2. **AI Agent / Agentic Action**：现实行为与控制权类；
3. **Context / Memory**：用户已经有直觉、但机制容易混淆的概念类。

目的不是选“最容易爆”的三个，而是验证系统能不能跨不同概念类型稳定工作。

## 12. Success Criteria

### G7 才允许宣称“流程跑通”

至少满足：

- 三个题目都能通过 Middle-Layer Gate；
- 三个故事删掉术语后仍成立；
- AI 机制表述无关键事实错误；
- Story → Script → Shotbook 的信息没有静默漂移；
- Shotbook 不是一句一图；
- Image Manifest 能区分 reuse / generate；
- 至少一条完成到可审看的视频 / animatic；
- 失败点能定位并回滚，不需要整条重跑。

### G8 才允许宣称“半自动”

还必须满足：

- episode state 能被机器读取；
- Worker 输出可被下一步消费；
- 不依赖人工复制整段聊天；
- Worker 版本 / 来源可追踪；
- 任一 Stage 可单独重跑；
- 上游锁定字段不会被下游静默覆盖。

## 13. Next Actions

当前只推进 G1：

1. 为每个 Stage 冻结 canonical input / output；
2. 建立 `episode_id` 与 Episode Package；
3. 给现有 Skill 做 Worker Adapter 映射；
4. 明确“选题 Skill”现有位置或新建必要性；
5. 明确麦基结构规则是独立 Worker 还是 Story Engine 内部 Gate；
6. 定义 Nano Banana / Antigravity 为何种 Adapter；
7. 完成后进入 G2，仅验证 Topic → Story，不提前生图。

## 14. Resume Rule

下一次继续时：

```text
README.md
→ PROJECT_RECORD.md
→ docs/ARCHITECTURE.md
→ docs/PIPELINE_AND_GATES.md
→ docs/WORKER_CONTRACTS.md
→ docs/TOOL_INVENTORY.md
→ 当前 Gate
```

已经 PASS 的 Gate 默认不重做，除非新证据推翻原结论。
