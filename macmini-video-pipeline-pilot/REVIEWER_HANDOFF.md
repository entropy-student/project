# Mac mini Video Pipeline Pilot — REVIEWER HANDOFF

> **唯一当前项目状态** · 2026-10-28 · G2 文本审查接受  
> 治理：[VPS Project Governance v0.2.7](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md) 通用 Gate / Evidence / Reviewer 机制，VPS 运维部分不适用。  
> 工作区：`entropy-student/project` · 分支 `project/macmini-video-pipeline-pilot-20261028` · [Draft PR #176](https://github.com/entropy-student/project/pull/176)（**尚未合并**）。  
> 历史执行记录见 `EXECUTION_EVIDENCE.md`；研究和稿件细节各见 `docs/`，本文件不复制长篇全文。

## PROJECT_GOAL
- **第一目标**：做出一部有真实研究、有视听设计、16:9、可供 B 站发布的 Mac mini 消费决策视频。
- **第二目标**：用该作品验证低成本、AI 主导「选题→研究→文案→导演→补真实素材→成片→验收」的可复用流程。
- 发布/购买设备/付费/安装新系统由 Owner 另行决定；本项目的文本 PASS 不是作品 PASS。

## PROJECT_STAGE / CURRENT_ACCEPTED_STATE
- `G0_PROJECT_INIT = PASS`：独立目录、唯一交接、PR #176 与治理适配回读已通过。
- `G1_CONTENT_DISCOVERY = PASS`：限定资料范围内研究与「三种需求分流」主发现已接受；详情 [G1 报告](./docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md)。
- `G2_NARRATIVE_AND_SCRIPT = PASS`：完整口播 V1 + 七段叙事功能 + 文案事实来源 + 视听职责 + 反方与待验证素材已保存/Reviewer 文字审查。详见 [G2 全文](./docs/G2_NARRATIVE_AND_SCRIPT.md)。
- **PASS 范围**：正文有连贯叙事，官方价格、闲置功耗、静态网站托管等关键主张有已核对公开资料支撑；没有明显虚构购买/测试经历。
- **未通过范围**：还没有真人试听、真实镜头、美术、素材许可、国产二手/小主机与 VPS 同工况价格、实机跑分或最终成片；G2 PASS 不代表这些已完成。
- `PROJECT_STAGE = SCRIPT_ACCEPTED / DIRECTOR_READY`
- `CURRENT_GATE = G3_AV_DIRECTOR_AND_ASSET_TASKS`
- `NEXT_STEP = G3`：围绕 V1 做视听双栏分镜（语义镜头而非逐句配图）、优先级明确的素材任务书和 1–2 段低成本动效验证方案；G3 自己停止，不越权制作整片。
- `OWNER_ACTION_REQUIRED = NONE`（目前）；G3 可列出需要的本人桌面拍摄任务，尚不要求立即拍。
- `DEFAULT_EXECUTION_CHANNEL = ChatGPT Reviewer + GitHub 项目分支`（文本/研究）；本地媒体执行渠道 `UNKNOWN`，后续 G4 查明。
- `CURRENT_ROLLBACK_STATUS = 文档仅在未合并 Draft PR，Git 可回退；无真实服务/用户数据/商业变更`。

### 项目进度

| Gate | 目标 | 状态 |
|---|---|---|
| G0 | 立项、唯一交接与治理适配 | PASS |
| G1 | 研究、反证、受众问题与内容决定 | PASS |
| G2 | 叙事设计、完整中文口播与事实自审 | PASS |
| G3 | 视听双栏导演、反向补素材任务、视觉验证计划 | NEXT |
| G4 | 素材补全、动效/镜头小样验证 | PENDING |
| G5 | MP4/音频/字幕/封面、事实与视听 QA | PENDING |
| G6 | Owner 验收、项目复盘与流程复用判断 | PENDING |

## CURRENT EDITORIAL DECISIONS / 现行内容判断

1. **候选标题**：《一个普通人，真的需要花 7000 块买 Mac mini 吗？》，正式价格画面写“¥6,999 起”；发布前复核。备用：《Mac mini 能当服务器，所以我就该买一台？》。
2. **承诺**：帮普通人分清「需要 Mac 工作站」「需要本地 AI/自动化运行环境」「需要稳定公网网站」三种采购目标。
3. **主发现 F2**：这三件事不是同一张账单，价格和硬件参数不能直接跨用途比较；F1（2024 M4 ¥4499 → 2026 M6 ¥6999）仅开场冲突；F3（闲置 4 W ≠ 服务稳定）为关键转折。
4. **完整文本**：[G2 口播全文 V1](./docs/G2_NARRATIVE_AND_SCRIPT.md)。结构 A心动/价格→B「都能做」陷阱→C日常工作站→D本地AI与云端调用→E公网服务反转→F有条件购买标准→G个人收束。
5. **风格**：普通消费者第一人称，具体工作需求驱动，少量自然轻松口吻；不能假装买了机器/做过长期测试。
6. **创作方法**：声画共同叙事；AI 协助研究不等于要在镜头里展示对话；画面必须承担证据/解释/情境/节奏职责。
7. **反方保留**：macOS 特定软件、本地模型与本地数据需求，可能构成购买 Mac mini 的正当理由；不做「任何人都不该买」结论。
8. **条件**：Mac mini 不是唯一可行硬件；Cloudflare Pages 的静态托管也不等于后台数据库/任务的通用免费替代。

## SYSTEM_MAP / 项目资产

```text
Owner goal + topic
→ G1 Evidence / editorial decision           PASS
→ G2 narrative + complete narration          PASS
→ G3 AV Director / evidence-backed beats      NEXT
→ G4 Owner material tasks + visual prototype PENDING
→ G5 Voice + edit + render + QA               PENDING
→ G6 Owner acceptance + workflow reflection   PENDING
```

- 唯一当前状态：`REVIEWER_HANDOFF.md`，不得新建并行 state 文件。
- 验证事实：`EXECUTION_EVIDENCE.md` 追加记录，不能覆盖既有 G0/G1。
- [G1 研究资料](./docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md)；[G2 脚本 V1](./docs/G2_NARRATIVE_AND_SCRIPT.md)。
- [写作规范 v0.2 候选](./docs/WRITING_STANDARD_DRAFT_v0.2.md) 未正式安装 Skill。
- 邻近 `ai-story-showrunner/`、`visual-narrative-animation-lab/`、旧 Mac mini 文章 PR #174 是只读参考；不改其主状态。
- 当前用户本地媒体工作路径、可用角色/循环小人及渲染软件：`UNKNOWN`；G4 必须确认，不凭聊天推断文件可访问。
- 无部署、付款、Secret、用户真实数据处理或公开发布。

## CRITICAL_CONSTRAINTS

- 研究型消费决策而非已有设备亲测；任何本人口述经历需真实，未知为 UNKNOWN。
- 实操/观点/测评是**观众承诺**，不是互斥镜头语法；不要每轮重新投票。
- 每个会改变购买判断的事实要有证据；原厂营销不能代替独立实测；旧发布价不能算现在二手价。
- 画面不可只装饰文字：应优先使用来源可查的产品截图、真实录屏、逻辑图和可审查的计算；AI 情境图不能冒充实机/界面证据。
- 缺关键画面主动反向规划补素材任务，不因 Owner 未给素材而自动阉割表达；缺真实证据不编造效果。
- 控制预算：复用已有视频模板/解说小人，确认资源后才调用；不默认购买硬件、高价生成或变更本机设置。
- 不改 Governance、不合并 PR、不动其他项目、不公开发布；实际素材权益在 G3/G4 核查。
- 任何 Gate 验收必须 Evidence 可查 + Reviewer 检查 + Handoff 持久化 + GitHub 回读；不能用本轮口头陈述代替。

## CURRENT_GATE / G3_AV_DIRECTOR_AND_ASSET_TASKS

- `GATE_ID`：G3_AV_DIRECTOR_AND_ASSET_TASKS。
- `OBJECTIVE`：把 G2 通过的脚本变成可拍/可做的视听创作包，允许声画之间的局部必要修改，但不重新发明选题或未证实的购买结论。
- `MAX_ENDPOINT_THIS_ROUND`：`docs/G3_AV_DIRECTOR_AND_ASSET_TASKS.md`（双栏视听节拍、媒体表达选择、需要补的素材任务与验收要求、少量动效小样计划），必要时对 G2 草稿做有证据的局部修订，更新本 Handoff 与 Evidence。
- `MANDATORY_REVIEW_STOP`：完成 G3 设计/QA 即 STOP；不在 G3 自动启动视频生成/大批量生图或发布。
- `TARGET_AND_SCOPE`：仅本项目 G3 文档、必要的 G2 局部修订、Handoff、Evidence。
- `APPLICABLE_CRITICAL_CONSTRAINTS`：证据分层、不给业余消费者臆造真实经历；画面有证据/解释职责；低成本；Owner 实拍任务合并。
- `PREFLIGHT`：读取当前 Handoff/G2/G1 指向的证据、v0.2 视听规范；视听类型选择必须有表达理由。
- `REQUIRED_EVIDENCE`：覆盖全段的 AV 双栏节拍、与 G2 对照、主要来源/使用权待核项、素材缺口的精确需求（谁拍、拍什么、拍到何种状态）、至少一个关键转折动效的可实现方式及首个小样验收方法。
- `ACCEPTANCE_CRITERIA`：画面承担实质任务；不做逐句配图；关键数字能追溯；必须补拍的实拍/录屏与替代策略明确；没有过度复杂的动画；G4 可直接接着做低成本小样。
- `ROLLBACK_STATUS_OR_PLAN`：文档隔离未合并分支，Git 回退无媒体/本机影响。
- `OWNER_ONLY_ACTIONS`：本轮仍不需购买/拍摄/发布；如遇真实个人身份关键主张才集中询问。
- `REVIEWER_TO_EXECUTOR_RELAY`：只读取本 Handoff、G2 文档第 2/3/4/6 节、G1 第 1/3/4/7 节及 v0.2 的「声音与画面共同设计」「主动补素材任务书」；不用广泛检索历史；输出双栏视听脚本与素材任务，不生成批量媒体。
- `EXECUTOR_TO_REVIEWER_RELAY`：G3 设计稿 + 文件回读 + 未解决素材/权益/媒体环境问题；Executor 仅报 PASS_CANDIDATE，Reviewer 决定正式结果。

## UNRESOLVED
- V1 是否朗读自然、每部分所需时长与听感；实际语音输出/试听尚未发生（G4/G5）。
- 本人是否认可最终口播中的第一人称态度，真实工作站画面与素材仍需核对（G3/G4）。
- 当前中国二手 M4 与 x86 主机同工况可比报价、具体 VPS 生命周期总成本：UNKNOWN（不要写精确省钱数）。
- 当前本地视频模板、解说小人、渲染器/剪辑环境、素材原始授权及可用性：UNKNOWN（G3/G4）。
- 公网服务、本地 AI、月电量/可靠性没有实机实验，不能写成亲测。
- B 站评论需求频率与视频流量因果仍 UNKNOWN，不影响以候选叙事做下一 Gate，但不能宣称已被市场验证。
- 此流程能否对实操/测评不同主题复用：只有真正成片和后续复测才能回答。

## NEXT_STEP
**G3**：将 G2 脚本转换为视听双栏导演稿；反向明确哪些素材必须由 Owner 实拍、哪些可以现有录屏/公开资料/信息图完成，设计一个关键转折（闲置 4 W ≠ 互联网可靠访问）的低成本视觉呈现。**不立即要求 Owner 自己规划镜头。**

## OWNER_ACTION_REQUIRED
`NONE`

## EVIDENCE_POINTERS
- [G1 研究与编辑决策](./docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md)
- [G2 完整口播与自审](./docs/G2_NARRATIVE_AND_SCRIPT.md)
- [执行证据（G0/G1/G2）](./EXECUTION_EVIDENCE.md)
- [v0.2 写作/视听草案](./docs/WRITING_STANDARD_DRAFT_v0.2.md)
- [项目 Draft PR](https://github.com/entropy-student/project/pull/176)

## DECISION_LOG / 新变更
- 2026-10-28 G2：确认一篇以「我为什么动心 → 我把三种需求混在一起 → 发现省电不等于公网可用 → 分条件做决定」为主线的完整 V1 文本；没有新实机测试，也没有自动升级写作 Skill；下一 Gate 是导演/素材规划。
