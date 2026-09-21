# AI Story Showrunner — PROJECT RECORD

> 本文件保存项目的长期目标、决策、里程碑与历史记录。**当前 Gate 的唯一 Reviewer 真相以 `REVIEWER_HANDOFF.md` 为准。** 重新接手时按 README 指定顺序恢复上下文。

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
P0  Project Boundary / Governance Reconciliation PASS
G1  Worker Inventory + Canonical Contracts     PASS
G2  Topic → Human Problem → Story MVP          PASS
G2.5 Topic Supply / Ledger / Dedup             PASS_CANDIDATE / OWNER REVIEW
G3  Story → Script / SRT MVP                   PASS
G4  Script → Director Shotbook MVP             PENDING
G5  Shotbook → Image Asset Package MVP         PENDING
G6  Image Assets → Video MVP                   PENDING
G7  Three-topic End-to-End Validation          PENDING
G8  Semi-automated Orchestration               PENDING
G9  Publish / Analytics Learning Loop           PENDING
G10 Reusable Showrunner Skill / Runtime         PENDING
```

## 7. P0 Completed

- 对齐 canonical `vps-project-governance` v0.1.6 + active addenda；
- 建立唯一 `REVIEWER_HANDOFF.md`、`EXECUTION_EVIDENCE.md`、`CURRENT_STATUS.json` 与 `docs/GOVERNANCE_ADAPTATION.md`；
- 对早期先建文档、后补 Handoff 的 bootstrap 历史做 fresh GitHub read-back，对账后重新确认 P0；
- 深度检查 `entropy-student/project` 的项目库规范；
- 对比 `visual-narrative-animation-lab`，确认新项目必须独立立项；
- 遍历 `entropy-student/spike.skill` 当前相关能力；
- 确认现有系统不缺单点 Tool，主要缺 Orchestration Contract；
- 冻结 Story-first 内容母模型；
- 冻结 Showrunner / Worker 分层；
- 冻结 Gate-first 错误拦截机制；
- 建立首版架构、流水线、Worker 契约和工具清单。

## 8. Candidate Workers / Dependencies

**以下只是已发现能力源，不代表最终 Worker 编制。** Worker 必须通过 Adapter / Contract / Episode evidence 后才能进入 canonical registry。

已确认可复用能力：

- `acquisition-growth-radar`：发布后的增长 / 验证反馈层；
- `jingsui-story-video-director`：强候选 Writer Style Engine；其自带 Director/生图/剪辑权限在本项目中默认关闭；
- `short-form-spoken-script`：短视频 Promise / Hook / 口播 / SRT 的候选脚本 Worker；
- `aroll-video-maker`：保留为导演/视觉方法参考或未来替代路径，当前不是默认成片执行 Worker；
- `narrative-motion-semantics`：流程 / 时间 / 对比 / 因果动效语义库，目前明确 INCOMPLETE；
- `video-talkcraft-design-orchestrator`：保留为视觉编排参考/未来替代路径，当前不是默认成片执行 Worker；
- `visual-narrative-animation-lab`：画面叙事语法、Asset Resolution、Animatic 的研发/参考能力；默认生产执行已改为 Antigravity。

当前 `spike.skill` root + recursive path scan 结果：

- 未发现独立“选题 Skill / 历史选题账本”；当前采用 contract-first，先不新造 Skill；
- 未发现独立“麦基结构 Skill”；当前冻结为 Showrunner 内部 Story Engine Gate；
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

### D5. Antigravity as Restricted Executor

当前图片到成片的默认执行路线正式冻结为：

```text
Low-Level Execution Package
→ Antigravity
→ Nano Banana batch image generation
→ exact timeline placement
→ simple edit
→ video draft
```

原则：

- Antigravity 不做导演推理；
- 一个小镜头默认一张图；
- 动作优先拆成多张静态图；
- 不以节省生图次数为优化目标；
- 角色/场景一致性由 canonical references + per-shot contract 保证；
- 未明确指定的效果默认不添加；
- 音频模式暂为 TBD：上游 TTS vs Antigravity 严格 TTS。

Canonical contract: `docs/LOW_LEVEL_EXECUTION_PACKAGE.md`

### D6. Content Jobs + Conversion Adjacency

每一期必须声明一个 `primary_content_job`：`DISCOVERY / TRUST / SOLUTION`。

TopicOpportunity 增加 `conversion_adjacency`、`search_anchor`、`visual_storyability`、`repetition_risk`。商业邻近度用于判断长期需求路径，不构成硬广授权。

Metrics 拆分为 Traffic / Trust / Conversion；禁止播放量单指标决策。

Canonical strategy: `docs/CONTENT_STRATEGY_AND_CONVERSION.md`

### D7. Worker Adapter Before Skill Mutation

优先通过 Showrunner Adapter 限权/补输入，而不是直接把通用 canonical Skill 改成项目专用版。

Canonical plan: `docs/WORKER_ADAPTER_PLAN.md`

### D8. Nearest-Gate Rollback

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

### R8. Visual Template Fatigue

角色稳定但构图、反应镜头、故事母题、节奏模板长期重复，导致 AI 批量感。

**Control**：Visual Repetition Gate + Content Ledger 记录 hook / motif / scene usage。

### R9. Metrics Corruption

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
- Story → Script → Low-Level Execution Package 的信息没有静默漂移；
- 每个小镜头都有明确状态变化与施工理由；允许 one-small-shot ≈ one-image，但禁止“台词机械切句=镜头”；
- Character / Scene references 能控制身份与环境连续性；
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

G1 已 PASS。**按 Owner 指令暂停，G2 暂不推进。** 待 Owner 审阅整体方向后，再执行：

1. 用 MCP 生成并验证 TopicOpportunity / KnowledgeCore / StoryPremise；
2. 用 Agent / Agentic Action 复跑同一 Contract；
3. 用 Context / Memory 复跑同一 Contract；
4. 比较三种题型的 reject reason / storyability / conversion adjacency；
5. 三题通过后 Reviewer 决定 G2 PASS，再进入 G3 Writer Adapter 验证。

Production side note：Antigravity 当前归类为 `MANUAL_EXECUTOR / NOT_YET_POC_VALIDATED`；AUDIO_MODE 保持 TBD，不阻塞 G2。

## 14. Resume Rule

下一次继续时：

```text
README.md
→ REVIEWER_HANDOFF.md
→ CURRENT_STATUS.json
→ PROJECT_RECORD.md
→ docs/ARCHITECTURE.md
→ docs/PIPELINE_AND_GATES.md
→ docs/CONTENT_STRATEGY_AND_CONVERSION.md
→ docs/WORKER_ADAPTER_PLAN.md
→ docs/WORKER_CONTRACTS.md
→ docs/TOOL_INVENTORY.md
→ EXECUTION_EVIDENCE.md（需要审计时）
→ 当前 Gate
```

已经 PASS 的 Gate 默认不重做，除非新证据推翻原结论。


## 15. G2 Validation Result — 2026-09-20

Reviewer decision: **PASS**

验证题：
- MCP — abstract protocol / interoperability
- Agent — delegated workflow execution
- Context / Memory — working context vs persistent memory

主要结论：
- L3 Human Situation → L2 Capability Change → L1 Technical Mechanism 在三种题型上均可工作；
- One Mechanism Gate 必须保留；
- Story-first 可行，但 story motif 也需要去重，不能只去重 topic；
- conversion adjacency 必须按 audience 判断，不能按技术热度判断；
- G3 的关键风险从“故事能否成立”转变为“Writer 是否会把故事重新写成科普”。

Detailed review: `docs/G2_VALIDATION_REVIEW.md`


## 16. G2.5 Topic Operating System — 2026-09-20

Owner raised two pre-G3 requirements:
1. stable topic supply;
2. duplicate prevention.

Design created:
- HOT + EVERGREEN two-lane supply;
- Daily Radar only discovers/shortlists, it does not publish;
- Topic Registry is the semantic memory;
- Calendar is scheduling only;
- four-level dedup: Signal / Topic / Angle / Story-Visual motif;
- candidate quality separates Reach Potential from long-term Asset Value;
- 40 evergreen human-problem seeds added to validate long-term supply.

External project decision:
- borrow ingestion/history patterns from AI-TREND-RADAR / TrendRadar;
- do not inherit their scoring as canonical content judgment.

Automation:
- recommended, but intentionally NOT enabled before Owner accepts the contract.

Current state:
`G2.5 PASS_CANDIDATE / HOLD BEFORE G3`.


## 17. G3 Writer Validation — 2026-09-20

Reviewer decision: **PASS**

Writing model:
`McKee causality + Narrative Transportation + Short-form Retention + Jingsui Voice`

Validation set:
- MCP ~74s
- Agent ~75s
- Context / Memory ~78s

Key findings:
- term reveal should follow story intuition;
- state/progression density matters more than “golden sentence” density;
- 70–85s is a useful first calibration range, not a permanent rule;
- Jingsui is valuable as voice/style layer but its first-person/signature/English-tail/visual-authority defaults are overridden;
- Script and estimated SRT matched exactly across all three samples.

Next: G4 Director / Shot Compiler.

## 18. G3R Bilibili Editorial Rebaseline — 2026-09-20

Trigger:
Owner clarified:
- Bilibili is primary platform;
- daily publishing is desired;
- fixed IP will exist;
- pure concept explanation may be insufficient;
- stories should remain intrinsically watchable;
- future growth/monetization matters.

Reviewer finding:
The architecture remains valid, but the editorial baseline drifted toward short-form.

PASS_CANDIDATE proposes:
- daily Bilibili story-driven AI knowledge channel;
- first-person recurring channel IP;
- 3–8min duration routing, standard 4–6min;
- mechanism as story-world causal rule;
- separate Business Job and Editorial Mode;
- STORY_MODEL / STORY_ACTION / STORY_TUTORIAL;
- action/tutorial only when naturally implied;
- Season 0 = first 21 published episodes;
- initial 7-day mix 4 / 2 / 1;
- daily editorial target locked, production throughput not yet proven.

Live Daily Radar is intentionally NOT switched to the proposed v0.2 planner until Owner PASS.

Current:
`G3R PASS_CANDIDATE / G4 BLOCKED`.

## 19. G3R Owner Alignment Without PASS — 2026-09-20

Owner accepts the overall direction and authorizes document consolidation, but explicitly withholds PASS because two issues remain for discussion.

Current candidate baseline:
- Bilibili primary;
- daily editorial target;
- 3–5min primary duration target, exceptions by narrative need;
- first-person recurring IP;
- STORY_MODEL / STORY_ACTION only;
- tutorial module removed;
- initial mix hypothesis 5 / 2;
- optional bounded viewpoint;
- causal Story Beat Gate.

Governance:
- historical G3R proposals remain historical evidence only;
- live Daily Topic Radar v0.1 is unchanged;
- G4 remains blocked;
- two open questions are not guessed or auto-resolved.

State:
`OWNER_ALIGNED / HOLD / NOT PASS`.

## 20. Narrative Style Consolidation + Agent Test — 2026-09-20

Narrative style candidate is now explicitly defined as:
`Jingsui lightness × McKee causality/meaning × AI mechanism as world rule × first-person recurring IP`.

New contract:
`docs/NARRATIVE_STYLE_CONTRACT.md`.

New safeguards:
1. Controlling Question before viewpoint;
2. Idea vs Counter-Idea;
3. Lightness Guard so structure remains invisible.

McKee principles retained:
- desire;
- expectation/result gap;
- progressive complications;
- beat/scene state change;
- character-driven action;
- controlling idea / counter-idea;
- climax expressing meaning.

Jingsui principles retained:
- concrete person/event first;
- first-person participant;
- self-deprecation/light reaction;
- event-driven spoken flow;
- thesis delay;
- natural long/short spoken phrasing;
- no sudden lecturer mode.

Removed/overridden:
- forced self-intro;
- forced English signoff;
- joke quota;
- formulaic dramatic timing;
- viewpoint-first writing.

Agent 3–5 minute narrative smoke test created and reviewed as PASS_CANDIDATE. It does not advance G4.

Current state:
`G3R HOLD / 1 OWNER QUESTION REMAINS`.

## 21. Dialogue Layer Promoted + Cross-topic Portability — 2026-09-20

Confirmed sentence-level layer:
- dialogue = verbal action;
- preserve subtext;
- recurring IP vocabulary/worldview;
- dramatic economy;
- reaction/silence can replace explanation;
- selective line-ending design;
- concrete cases before abstract methods.

These rules were promoted into:
- `docs/NARRATIVE_STYLE_CONTRACT.md` v0.2;
- `docs/WRITER_QUALITY_CONTRACT.md` v0.3.

Validation:
- Agent v2: 91/100 self-review;
- Context/Memory v1: 89/100 self-review.

Important anti-template finding:
The portable unit is NOT:
`mistake → disaster → overcorrect → compromise`.

The portable unit is:
`character desire → character action → mechanism response → meaningful state change → next choice → recognition/payoff`.

Conflict shape, humor, metaphor and climax must remain topic-dependent.

Current:
`G3R HOLD / READY FOR OWNER PASS DECISION / G4 BLOCKED`.

## 22. Final Copywriting Patch Integration + Three-Case Test — 2026-09-20

Owner approved formal project-space integration of the latest writing patch.

Narrative Style Contract advanced to v0.3.
Writer Quality Contract advanced to v0.4.

New rules:
- Hook strength classification;
- event-driven vs metaphor-driven narrative engines;
- technical definition compression;
- semantic formatting / rhythm.

Three-case editorial validation:
- Agent: 91/100;
- Context / Memory: 92/100;
- MCP: 90/100.

Key conclusion:
The framework is not tied to one plot template. The stable unit is causal character movement under an AI mechanism; the surface engine can vary by topic.

No open editorial questions remain.

Governance remains intentionally unchanged until explicit Owner gate decision:
`G3R HOLD / READY FOR OWNER PASS / G4 BLOCKED`.

## 23. G3R Final PASS + Consistency Closeout — 2026-09-20

Owner explicitly PASSed G3R.

Final Reviewer review found the narrative system itself sound, but identified stale current-state conflicts in:
- old HOLD / NOT PASS labels;
- old 4–6 / 3–8 duration proposal;
- historical STORY_TUTORIAL;
- old viewpoint phrase “观点是余味，不是承重墙”;
- stale Reviewer Handoff current-goal sections;
- Daily Planner proposal state.

All were reconciled.

Canonical state now:
- Bilibili;
- DAILY editorial target;
- 3–5 min default;
- first-person recurring IP;
- STORY_MODEL / STORY_ACTION;
- viewpoint can carry story meaning but must be proven through story;
- Narrative Style Contract v0.3;
- Writer Quality Contract v0.4;
- Daily Topic Planner v0.2 active;
- Season 0 approved but not started.

Accepted validation:
- Agent 91;
- Context/Memory 92;
- MCP 90.

G4 is READY but Owner explicitly requested no next-round execution yet.

State:
`G3R PASS / G4 READY_NOT_STARTED / OWNER HOLD`.

## 24. G4 Started — Director Compiler Split + Agent Semantic Shot Plan — 2026-09-20

Owner authorized G4.

Key architecture decision:
Do not mix visual-semantic shot decisions with fake estimated final timecodes.

G4 now has two internal phases:

```text
G4A Semantic Director
→ locks visual-state shot plan

final audio / SRT lock

G4B Exact Timeline Compiler
→ produces exact shot.schema rows
```

New artifacts:
- `docs/G4_DIRECTOR_COMPILER_CONTRACT.md`
- `schemas/semantic_shot.schema.json`

First G4A validation:
- Agent;
- 36 semantic shots;
- result PASS_CANDIDATE.

Important visual finding:
The main risk is not image count. It is repeated-scene fatigue and explainer regression. More still images are acceptable; composition/action/state must change meaningfully.

Current:
`G4 IN_PROGRESS / G4A AGENT PASS_CANDIDATE / G4B BLOCKED_BY_AUDIO_MASTER / G5 BLOCKED`.



## 2026-09-21 — VB009 execution compatibility patch

- Re-reviewed G5 state after the canonical POV patch.
- Found VB009 execution conflict: target `IP_POV_HANDS` could not deterministically derive from observer-view VB008 while also preserving source camera/crop.
- Reclassified VB009 from `DERIVE_EDIT` to `GENERATE`.
- Added G5 `DERIVE_EDIT` compatibility boundary.
- Added partial-visibility identity QA rule for hands/cuff POV frames.
- Synced Blueprint, Execution Rows, Pilot Batch, CURRENT_STATUS, README, REVIEWER_HANDOFF and evidence.
- New execution counts: `GENERATE 15 / DERIVE_EDIT 25 / COMPOSITE_CROP 4`.
- Current next action: generate + QA VB009; PASS then continue VB012.


## 2026-09-21 — VB012 Pilot pass

- VB012 accepted as `PASS_WITH_MINOR`.
- Core purpose succeeded: confirm the refund-policy page is the correct source without exposing the later service-fee reversal.
- Minor issues logged only: outer laptop/desk framing and invented generic brand cue.
- No rework authorized during Pilot; continue to VB015.


## 2026-09-21 — VB015 Pilot pass

- Owner/reviewer selected image 1.
- `SRCH_VB015 = PASS_WITH_MINOR`.
- Accepted as the matched-setup master for VB016.
- Minor early exposure of the “服务费” label is logged, but the reversal sentence remains withheld.
- Next: reveal only `平台服务费不予退还` with identical crop/page geometry.


## 2026-09-21 — VB016 Pilot pass

- `SRCH_VB016 = PASS_WITH_MINOR`.
- Matched setup/reveal pair VB015→VB016 is validated.
- Minor UI/browser framing polish deferred.
- Next high-risk Pilot: VB022 source-crop compare.


## 2026-09-21 — VB022 first attempt returned

- `SRCH_VB022 = RETURN_SEMANTIC_EXECUTION_DRIFT`.
- Generated frame compared the wrong pair of concepts and therefore lost the “服务费 vs 订单款项” object mismatch.
- It also violated the no-character constraint and reintroduced a drifting/juvenile character.
- Decision: remove character entirely; retry as pure two-source crop comparison.


## 2026-09-21 — VB022 semantic compare pass

- `SRCH_VB022 = PASS_WITH_MINOR_SEMANTIC_COMPARE`.
- Core object mismatch `服务费` vs `订单款项` is visually legible.
- Minor brand exposure / crop density deferred.
- Deterministic source-crop execution remains pending asset persistence.
- Next: VB025 analogy payoff.


## 2026-09-21 — VB025 first attempt returned

- `SRCH_VB025 = RETURN_EXECUTION`.
- Prop-only / giant-phone output failed the required two-person analogy payoff.
- Style also drifted into realistic/3D product-demo rendering.
- Retry locked to a simplified-flat two-shot: IP puzzled + supporting actor confidently showing paper contact book.


## 2026-09-21 — VB025 attempt 2 character drift

- Story composition/payoff now works.
- `SRCH_VB025 = RETURN_CHARACTER_DRIFT`.
- Recurring IP again drifted juvenile/chibi and hoodie-like.
- Next retry preserves composition/contact-book action and corrects identity/style only.


## 2026-09-21 — VB025 Pilot pass with character risk

- `SRCH_VB025 = PASS_WITH_MINOR_CHARACTER_RISK`.
- Story payoff and two-person blocking are validated.
- Residual recurring-IP drift remains and is explicitly deferred.
- Canonical IP image-reference persistence promoted to a hard prerequisite before G6.
- Next: final high-risk Pilot beat VB044.


## 2026-09-21 — VB044 first attempt returned

- `SRCH_VB044 = RETURN_EXECUTION`.
- Generated output over-explained the callback as a summary poster.
- Retry locked to one IP + same opening spatial relationship + deliberate source verification only.


## 2026-09-21 — VB044 attempt 2 returned

- Callback composition and character improved.
- `SRCH_VB044 = RETURN_EXECUTION_ATTEMPT2`.
- Remaining issues are execution-only: wrong branded webpage + checklist lesson-card regression.
- Next edit preserves composition/action and changes only screen + notebook semantics.


## 2026-09-21 — G5 high-risk Pilot closure

- 8/8 high-risk Pilot beats reached accepted states.
- G5 compiler/frame architecture promoted to PASS_CANDIDATE.
- Repeated failures clustered around executor over-explanation, incompatible derive sources, brand/UI expansion, and recurring-character drift.
- No new Topic/hotspot/IP narrative-policy changes were introduced during this closure.
- Final G5 blocker: persist and bind real canonical character/scene/UI reference binaries.
- G6 remains blocked until reference-path validation passes.
