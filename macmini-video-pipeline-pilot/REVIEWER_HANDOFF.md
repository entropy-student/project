# Mac mini Video Pipeline Pilot — REVIEWER HANDOFF

> 唯一当前项目状态 / Single Current Truth  
> 建立日期：2026-10-28  
> 本文档不承载完整文案、素材或历史流水账；事实变化由 Reviewer 审查后更新。  
> 治理规范：[VPS Project Governance v0.2.7 — VNEXT.md](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md)（当前 ACTIVE_PROVISIONAL；以 GitHub 上最新有效规范为准）

## 1. PROJECT_GOAL / 项目目标

**本期作品**：围绕「一个普通人，真的需要花 7000 块买 Mac mini 吗？」制作一部有证据、图文并茂、可正式发布的 B 站 16:9 视频。题目和「7000 元」是**待研究的暂定创作假说**，不是已核实的售价或购买结论；研究可以推翻选题角度，但需说明依据。

**项目实验**：用这部作品跑通「选题 → 资料与需求研究 → 内容发现 → 叙事与口播 → 视听双栏脚本 → 反向补素材 → 制作 → 完片 QA → 复盘」的完整流程，评估 AI 是否能独立规划并具体指导 Owner 补充实拍、录屏和证据。

**长线产出**：经过真实作品验证后，沉淀可复用的生产方法；不预设必须开发新工具或立即封装 Skill。

**验收区分**：
- CONTENT_PASS：研究可信、叙事有效、文字与画面共同完成表达。
- VIDEO_PASS：实际交付可播放的 16:9 视频文件、素材来源记录、声音/画面 QA，获得 Owner 审阅接受。
- WORKFLOW_PASS：每阶段成果可复用、缺口/返工被记录、有明确人工补料任务且可由下一位 Agent 承接。
- RELEASE：公开发布是独立的 Owner 决策；VIDEO_PASS 不自动代表已发布或取得流量。

## 2. PROJECT_STAGE / 当前阶段

- `G0_PROJECT_INIT = PASS_CANDIDATE`（本次建档，需 Reviewer 核对 GitHub 回读后正式 PASS）。
- `CURRENT_GATE = G0_PROJECT_INIT`；`NEXT_GATE = G1_CONTENT_DISCOVERY`，**尚未授权进入 G1 的实际研究/创作**。
- `PROJECT_STAGE = INIT_AND_GOVERNANCE_ADAPTATION`
- `CURRENT_ACCEPTED_STATE`：Owner 已同意独立立项、唯一交接、复用 VPS 项目管理规范；首期方向是研究型消费决策调查。现有五分钟样稿仅作叙事示例，非已审稿、实测或冻结成片。
- `OWNER_ACTION_REQUIRED = NONE`（当前建档轮）；对外发布/付费采购/借测等后续单独确认。

### 里程碑总览

| Gate | 任务 | 验收边界 | 初始状态 |
|---|---|---|---|
| G0 | 独立立项、治理适配、唯一交接建立 | GitHub 项目目录/导航/基线材料可回读，未改其他项目与 Governance | PASS_CANDIDATE |
| G1 | 内容发现与证据核验 | 有价值的核心发现、反证、来源清单与精确的主要观众问题 | NEXT |
| G2 | 叙事与完整文案 | 有证据支持的可朗读中文口播，结构推进和结论不过界 | PENDING |
| G3 | 视听导演与素材任务书 | 双栏 AV 脚本，明确实拍/录屏/图表/动效及责任、证据缺口 | PENDING |
| G4 | 素材补全与小样验证 | 关键素材真实、来源可查，关键视觉单元可实现 | PENDING |
| G5 | 完整视频生产及 QA | 可播放 MP4、声画同步、字幕、封面、来源与体验审核 | PENDING |
| G6 | Owner 验收与流程复盘 | Owner 验收、提炼失败/成功规则；是否发布另行决策 | PENDING |

> Gate 不是固定对话轮数；范围相容时 Reviewer 可合并执行步骤，不能把未经验证的下游工作标为 PASS。

## 3. SYSTEM_MAP / 生产与存储地图

```text
User topic/goal
→ Reviewer: audit problem + research design
→ Evidence/Research: claims, sources, counterexamples, audience demand
→ Reviewer: editorial decision and narrative
→ Writer: complete spoken draft
→ Director: AV double-column script + must-have footage plan
→ Owner: own-device scenes / screenshots / fact checks where required
→ Executor: assets, edit, captions, motion, render
→ Reviewer: factual + visual + experiential QA
→ Owner: acceptance / optional publication
```

- 仓库：`entropy-student/project`；独立目录：`macmini-video-pipeline-pilot/`。
- 唯一当前项目真相：本 `REVIEWER_HANDOFF.md`；README 仅入口，`EXECUTION_EVIDENCE.md` 记录可核验事实，`docs/` 承载内容成果。
- 参考写作方法：`docs/WRITING_STANDARD_DRAFT_v0.2.md`（PROVISIONAL，非自动验收条款、非正式 Skill）。
- 旧案例可参考但不得改其项目真相：`ai-story-showrunner/`、`visual-narrative-animation-lab/`；独立的 Mac mini 文章候选 PR #174 属其他工作边界，不作为本项目成片证据。
- 审阅/管理运行在 ChatGPT + GitHub；实际素材工作站、剪辑器、渲染器、媒体存储路径：`UNKNOWN`（待生产 Gate 查实，不以 VPS/SSH/Docker 作为本项目依赖）。
- 现有 Mac mini 实机或实机测试结果：`NOT_VERIFIED`；不得写成已购、开箱、亲测。
- 官网价格、机型、发布日期、内存行情、国内平台竞品热度：`G1_TO_VERIFY`；不沿用聊天中未经本 Gate 回读的数值。
- 当前没有新部署、数据库、账户授权、Secret、付费服务、客户数据、上线入口；`NOT_APPLICABLE`。发布和媒体授权将单独 Gate 管理。

## 4. CRITICAL_CONSTRAINTS / 冻结边界

1. **内容先于包装**：不要先把封面或精美模板做完，再倒填故事。开头不虚构购买经历。
2. **AI 负责做策划而不仅扩写**：主动寻找值得讲的发现、反证，并要求补拍关键真实素材；不能因为没有现成画面就删掉核心内容。
3. **视听共同创作**：画面可承担证明/解释，也可以反过来修改文案；不做机械「一句话一张图」。
4. **叙事角度由证据决定**：实操/观点/测评是观众承诺，不是互斥媒体格式；「AI 调查过程」不是必须展示的剧情。
5. **不造假**：真实价格、统计、录屏、硬件测评不能由 AI 情境图冒充；所有来源记录日期/机型/使用条件和权利状态。
6. **低成本、本地优先**：复用现有解说小人/模板/软件等已有资产，但须核实当前可用性；不为了实验购买高价硬件或调用高成本视频生成。
7. **Owner 最小介入**：Reviewer/Executor 负责研究、规划、任务拆解和 QA，Owner 只提供确实需要的人类真实素材或审批。
8. **项目隔离**：不修改 `vps-project-governance`、其他视频项目或 PR #174；不得发布/采购/登录第三方付费账户/修改用户本机系统，除非另有明确授权。
9. **证据等级**：官方、独立测试、复现计算、本人实测分开；推测和事实分开。
10. **单一有效状态**：新意见视为待评估输入；结论变化需要证据或目标/约束改变，Reviewer 写入此 Handoff。

## 5. CURRENT_GATE / G0 项目建档

- `GATE_ID`：G0_PROJECT_INIT。
- `OBJECTIVE`：创建独立试点项目、唯一交接状态和写作基线参考；建立可审查的完整路线。
- `MAX_ENDPOINT_THIS_ROUND`：GitHub 新分支 + Draft PR 中的新目录、项目 README、Handoff、Evidence、v0.2 写作材料；仓库根 README 只新增导航。
- `MANDATORY_REVIEW_STOP`：建档回读并核对后 STOP；不开始 G1 调研、写正式文案、生成视频或公开发布。
- `TARGET_AND_SCOPE`：仅 `macmini-video-pipeline-pilot/**` 与根 `README.md` 的单条导航。
- `PREFLIGHT`：核对仓库权限、默认分支、目标路径不存在、现行 Governance、相邻项目边界。
- `REQUIRED_EVIDENCE`：分支、文件路径、回读内容、PR 链接、根导航 diff，其他路径未改。
- `ACCEPTANCE_CRITERIA`：新目录可读取；Handoff 单一；写作参考完整；根导航能找到项目；无凭据/部署/发布/采购。
- `CURRENT_ROLLBACK_STATUS`：文件只在未合并分支和 Draft PR，尚未触及主分支；可关闭 PR/删除分支恢复，不涉及运行数据。
- `OWNER_ONLY_ACTIONS`：合并与外部正式发布单独确定；当前不需要。
- `REVIEWER_TO_EXECUTOR_RELAY`：本轮由 Reviewer 直接使用 GitHub 创建文档，无独立 Executor。
- `EXECUTOR_TO_REVIEWER_RELAY`：见本项目 `EXECUTION_EVIDENCE.md`。

## 6. NEXT_STEP / 下一 Gate 计划（本轮不执行）

G1_CONTENT_DISCOVERY：
- **目标**：判断这个选题到底有哪些值得讲、且能证明的发现；不以「7000 元是否值得」为预设答案。
- **研究任务**：① 核对 Apple 具体机型、日期、官方价格、配置；② 比较实际使用需求与现有电脑/二手小主机/VPS 等替代路线；③ 在 B 站同类视频与评论中寻找真实需求和内容空白；④ 找到最有力反证、测算口径及借测/补证要求。
- **成果**：`docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md`（观众问题、最多三个核心发现候选、权威出处与时间、反证、数字口径、内容角度和需要的真实素材）；佐证与查询可记 `EXECUTION_EVIDENCE.md`。
- **验收**：重要事实有可查一手/独立材料；明确研究型观点能否成立、应否改变标题、哪些主张需要实机；不能用未经核验的播放量判断流量必然性。
- **边界**：本 Gate 停止在研究与选题判断，不产出正式长口播、完整分镜、视频或发布。
- **阻断条件**：核心机型/价格无法核实、关键购买场景不可比较、无法形成一条有足够证据的主要发现，标为 RETURN/UNKNOWN 并提出最低成本验证方法。
- **Owner 介入**：默认 NONE；只有真实性命题必须使用本人经历且无法由资料判断时才集中提问。

## 7. UNRESOLVED / 尚未验证

- 首期面向哪个细分观众群体最具独特价值、到底选择哪项主发现；G1 调查后确定。
- 具体 Mac mini 年代/型号、现价、使用环境与假定购买案例；G1 验证。
- 观众关注度、选题竞争密度、数据可得性与版权复用条件；G1/G3。
- 现场素材能否取得、是否需要借测设备；G3/G4。
- 解说小人、模板的可用原始文件和现有剪辑/渲染环境；G3/G4。
- 流程跨三种内容类型是否仍有效；单期通过后才允许推广结论。

## 8. EVIDENCE_POINTERS / 文件索引

- `README.md`：简明导航（不是第二份状态）。
- `REVIEWER_HANDOFF.md`：本文件，唯一当前项目状态。
- `EXECUTION_EVIDENCE.md`：仅记录真实执行、回读、审查和异常。
- `docs/WRITING_STANDARD_DRAFT_v0.2.md`：用户前一轮讨论中的候选写作方法，未验证、未安装为 Skill。
- `docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md`：未来 G1 实际交付，**尚不存在**。

## 9. DECISION_LOG / 本次关键决定摘要

- 2026-10-28：用户同意独立立项、唯一交接、验证从选题到成片的流程；治理借用 v0.2.7 的通用机制，而非移植 VPS 运行条款。
- 2026-10-28：第一期研究型消费决策调查；「7000元」为暂定叙事锚点，价格和购买价值不能当既定事实。
- 2026-10-28：将 v0.2 写作规范作为候选输入；不提前封装成 Skill；先用真实作品验证。
- 2026-10-28：与 PR #174 现有文章候选试验隔离，保留其为历史参考，不混合交接状态。
