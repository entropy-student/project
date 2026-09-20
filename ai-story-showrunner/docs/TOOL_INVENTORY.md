# Tool / Skill Inventory — 2026-09-20

本清单记录已实际检查到的相关能力。用途是**发现候选能力并决定复用边界**，不是最终 Worker 编制。正式 Worker admission 以 `WORKER_ADAPTER_PLAN.md` 为准。

## A. `entropy-student/spike.skill`

### 1. acquisition-growth-radar

**状态：已存在 / 可复用**

定位：
- Evidence → Bottleneck → Lever → Experiment → Decision；
- 更适合发布后的验证、增长复盘和内容获客反馈；
- 不应被误用成 Story Engine。

Showrunner 位置：
`Publish / Analytics → Learning Loop`

---

### 2. jingsui-story-video-director

**状态：已存在 / STRONG CANDIDATE Writer capability**

已包含：
- 主题 → 切口 → 口播 → SRT；
- 故事型漫画叙事；
- 视觉语义拍；
- Scene / IP Bible；
- 生图计划；
- 剪辑方案；
- QA。

关键优点：
- 已明确不是“先讲道理再找例子”；
- 观点后置；
- Visual Beat 由语义变化驱动；
- 已有角色 / 风格 / 叙事校准。

Showrunner 位置：
`WRITER_STYLE_ENGINE via project Adapter`

其自带 Director / Image / Edit 输出在当前主路线中不具 canonical authority。

注意：
它当前能从“主题”一路做到剪辑计划，因此接入 Showrunner 后必须限制权限，避免它覆盖已经锁定的 Topic / Knowledge / Story Contract。

---

### 3. short-form-spoken-script

**状态：已存在 / 候选 Writer Worker**

强项：
- One video, one promise；
- Hook / retention；
- spoken rewrite；
- Claim / Evidence；
- Script Lock；
- SRT derivation。

Showrunner 位置：
`Writer Worker`

可能用途：
- 与 Jingsui Writer 做路由；
- 或只复用其 Hook / Oral QA / Claim Gate，而不重复整篇改写。

---

### 4. aroll-video-maker

**状态：已存在 / reference or alternative route**

强项：
- voiceover master timeline；
- Semantic Director；
- Visual Beat；
- Character Lock / Style Lock；
- 一张母图衍生多个 Shot；
- Remotion / CSS；
- 已明确取消 sentence = image。

Showrunner 位置：
`Director-method reference / future alternative route`

当前默认成片执行路线已冻结为 Antigravity。

---

### 5. narrative-motion-semantics

**状态：INCOMPLETE**

当前覆盖：
- Process；
- Time；
- Comparison；
- Causal。

未完成：
- 跨语义稳定路由；
- 路径 / 数据 / 分类等其他语义；
- 更完整的混合语义策略。

Showrunner 位置：
`Optional Motion Semantic Worker`

规则：
不得把四类现有模板误称为完整叙事动效系统。

---

### 6. video-talkcraft-design-orchestrator

**状态：已存在 / Alternative Production Route**

定位：
- 上层包装当前 video-talkcraft；
- 不复制其内部 Recipe；
- 主要增加视觉风格选择与 SHOTBOOK 确认。

Showrunner 位置：
`Alternative downstream production adapter`

不作为 AI Story Showrunner 的主控大脑。

---

## B. `entropy-student/project`

### visual-narrative-animation-lab

**状态：Prototype / 直接相关**

已验证方向：
- Visual Beat Grammar；
- many-to-many 台词 / 画面关系；
- hard cut / pose / visual metaphor / callback；
- Asset Resolution；
- Animatic 基线；
- 不以持续运镜作为主要生命力。

Showrunner 位置：
`Visual narrative R&D + downstream execution reference`

边界：
AI Story Showrunner 负责“整期内容生产的上游大脑”；Visual Narrative Animation Lab 负责“画面叙事如何成立”。

---

## C. 当前未确认 canonical 位置

### Topic / Trend Selection Skill

已完成 `spike.skill` root + recursive path scan，当前未发现名称/路径明确对应“历史选题账本 + 每日 AI 选题”的 canonical Skill。

状态：
`NO_CANONICAL_FOUND_IN_CURRENT_SCAN / CONTRACT_FIRST`

当前先使用 `schemas/topic_opportunity.schema.json` + `CONTENT_STRATEGY_AND_CONVERSION.md`，由 Showrunner 在 G2 验证；至少 3 个真实 episode 后再决定是否抽成 reusable Skill。

### McKee Story Structure Worker

当前没有确认独立 canonical Skill。

状态：
`INTERNAL_STORY_ENGINE_GATE / PROVISIONAL`

当前扫描未发现独立 McKee Skill。除非后续找到更权威现有能力，否则优先作为 Story Engine 结构 Gate，而不是成稿后润色 Worker。

### Antigravity / Nano Banana

当前是明确的目标生图执行路径，但尚未确认：

- 是否可稳定程序化调用；
- 如何传 reference image；
- job / asset id；
- 批量调用；
- 错误与重试；
- 文件落盘协议。

状态：
`EXTERNAL_ADAPTER / INTEGRATION_UNKNOWN`

G1 必须把“能在 UI 里用”与“可被 Showrunner 自动调用”分开。

---

# Inventory Conclusion

当前系统的真实问题不是工具不足，而是：

```text
有很多强 Worker
+ 各自有完整流程倾向
+ 缺统一 contracts
+ 缺 canonical episode state
+ 缺权限边界
+ 缺 rollback
= 无法可靠整体运转
```

AI Story Showrunner 的第一价值不是再创造一个 Skill，而是把这些 Worker 从“各自为政”改造成**同一个 Production System 的可替换部门**。


## D. New Project Contracts

- `docs/CONTENT_STRATEGY_AND_CONVERSION.md`：流量 / 信任 / 转化、内容任务、Visual Repetition Gate。
- `schemas/topic_opportunity.schema.json`：TopicOpportunity 机器可读 contract。
- `docs/WORKER_ADAPTER_PLAN.md`：候选 Skill 的限权、适配、admission 规则。
- `docs/LOW_LEVEL_EXECUTION_PACKAGE.md`：Antigravity 低层施工合同。
