# Mac mini Video Pipeline Pilot — REVIEWER HANDOFF

> **唯一当前项目状态** / 2026-10-28 G1 研究已审核  
> 治理：[VPS Project Governance v0.2.7](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md) 通用部分。  
> GitHub 仓库：`entropy-student/project`；当前工作分支：`project/macmini-video-pipeline-pilot-20261028`；[Draft PR #176](https://github.com/entropy-student/project/pull/176) 未合并。  
> 详细研究、历史执行/证据各归其档；**此文件是唯一当前真相**，不得并行建第二份状态。

## PROJECT_GOAL
1. 一期可发布的 B站 16:9 Mac mini 消费决策视频：真实资料、有独立发现、图文动态表达；不假装购买或实测设备。
2. 验证 AI 主导「选题→研究→文案/叙事→双栏分镜→补真实素材→成片QA」的低成本、可复用方法；方法是否可推广需到 G6 才判断。
3. 外部发布、购买设备、付费或替换全局 Skill 各需独立 Owner 决定。

## PROJECT_STAGE / CURRENT_ACCEPTED_STATE
- `G0_PROJECT_INIT = PASS`：目录、唯一 Handoff、v0.2 参考草案、Evidence、项目索引与 Draft PR #176 已回读。
- `G1_CONTENT_DISCOVERY = PASS`：2026-10-28 已完成 Apple 官方型号/价格/功耗、行业涨价、独立媒体评测、B站六条同类作品与若干社区问题的**限定范围**研究。完整证据及边界见 [G1 报告](./docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md)。
- `PROJECT_STAGE = RESEARCH_ACCEPTED / WRITING_PENDING`
- `CURRENT_GATE = G2_NARRATIVE_AND_SCRIPT`
- `NEXT_STEP = G2`：据 G1 的 F2 核心发现，建立故事推进与可朗读中文完整口播。尚无接受的完整新稿、分镜、实拍或 MP4。
- `OWNER_ACTION_REQUIRED = NONE`：G2 不需要购买机器/提前出镜。
- `DEFAULT_EXECUTION_CHANNEL = ChatGPT Reviewer + GitHub 项目分支（内容研究与文档）；本地实拍/剪辑后续待核对`。
- `CURRENT_ROLLBACK_STATUS = 文档仅在未合并 Draft PR 分支上；可关闭 PR/删除分支，不涉及运行时或用户本机`。

### 目前接受的内容判断（可被新证据推翻）
- **选题不变**：《一个普通人，真的需要花 7000 块买 Mac mini 吗？》；正式数据用 6999 元起，发布日期/购买页面需在发布时再核。
- **主类型**：研究型消费者决策调查，观点为结论形式；不是本机长期评测。
- **主发现 F2**：「Mac mini 作为桌面工作站 / 本地 AI/Agent 运行机 / 公网服务器」三类需求的成本、约束与替代方案不同，不能笼统用「Mac mini 能当服务器」做购买理由。
- **辅助发现 F1**：同为官方基础价，2024 M4 ¥4499 → 2026 M6 ¥6999，差 ¥2500 / +约55.6%；两代性能不同，不归因全部是内存。
- **辅助发现 F3**：Apple M6 闲置功耗 4W，不代表有了省电 Mac 就能替代稳定的公网服务；云端静态网站又不能代表本地 AI 算力。
- **题材边界**：同类视频不少，B站样本只证明竞争存在；中文评论区量级与内容空白没有全站统计，不宣称流量一定高。
- **叙事建议**：价格引发心动→为何想买→拆开三类任务→低耗电/长期在线的转折→具体的条件决策→真实个人收束；「AI帮我问问题」不必硬上屏。
- **反方**：需要 macOS/Xcode/专属软件、本地模型或常开私有计算的用户确有理由买 Mac mini；不能写成所有普通人都不需要。

## 当前进度
| Gate | 目标 | 状态 |
|---|---|---|
| G0 | 独立立项/治理/唯一交接 | PASS |
| G1 | 内容发现与证据查核 | PASS |
| G2 | 叙事主线 + 完整口播 | NEXT |
| G3 | 双栏视听分镜和素材任务 | PENDING |
| G4 | 素材补全/视觉小样 | PENDING |
| G5 | 16:9 MP4、封面、声画/事实 QA | PENDING |
| G6 | Owner 验收 + 复用流程复盘 | PENDING |

## SYSTEM_MAP / 依赖
```
Topic/Owner intent
→ G1 evidence + editorial decision [PASS]
→ G2 narrative/complete narration [NEXT]
→ G3 AV beats / visual evidence / needed footage
→ G4 owner-supplied real materials + reused/generated assets
→ G5 rendering + source/rights QA
→ G6 Owner acceptance and process retrospective
```
- 唯一 Handoff：`REVIEWER_HANDOFF.md`。
- 证据留痕：`EXECUTION_EVIDENCE.md`（仅记事实，不作第二份状态）。
- 研究：`docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md`。
- 候选写作：`docs/WRITING_STANDARD_DRAFT_v0.2.md`，不是已验证 Skill。
- 相邻项目：`ai-story-showrunner/`、`visual-narrative-animation-lab/`、历史 Mac mini 写作 PR #174，均只参考，不改状态。
- 实机/本地剪辑运行环境：`UNKNOWN`；无服务器部署、真实付费、外部发布、Secret 变更。

## CRITICAL_CONSTRAINTS
1. 用户给的是目标，不自动批准新方向；改变冻结判断必须有新证据/核心约束变化。
2. 不虚构作者买了 Mac、亲自测过、发生故障，AI 视觉不伪装证据。
3. 每个主结论可追溯 Apple/独立/作者实测等不同等级来源；旧价为上市价不是实时成交价。
4. 内容先于包装；画面/真实素材可以反向要求改稿，不做一句话配一张图。
5. AI/Reviewer 要主动做调查、判断和计划，不要求 Owner 逐步设计；缺关键实拍时产出一次性明确任务。
6. 低成本，禁止为此次内容实验默认购买设备；复用解说小人/模板须先验证资产可访问。
7. 不更改 Governance、其他项目/PR，不合并、不发布、不调用付费外部模型，除非 Owner 新授权。
8. 同一项目 Gate 完成要经过真实 Evidence → Reviewer审阅 → 更新此 Handoff → GitHub 回读；没有通过的环节不能标为 PASS。

## CURRENT_GATE — G2_NARRATIVE_AND_SCRIPT
- `GATE_ID`：G2_NARRATIVE_AND_SCRIPT。
- `OBJECTIVE`：基于 G1 已核实的 F1/F2/F3，写一部自然、可信、看得下去的完整中文口播及叙事结构，不使逻辑被产品参数接管。
- `MAX_ENDPOINT_THIS_ROUND`：在 `docs/G2_NARRATIVE_AND_SCRIPT.md` 交付主线、完整口播和每段的主要证据/画面职责（不是精确镜头表）；更新 Evidence + Handoff。
- `MANDATORY_REVIEW_STOP`：G2 Reviewer 审阅完成就 STOP，不进入 G3 实拍任务、动画制作或渲染。
- `TARGET_AND_SCOPE`：仅本项目 `docs/G2_NARRATIVE_AND_SCRIPT.md`、本 Handoff 与 Evidence。
- `APPLICABLE_CRITICAL_CONSTRAINTS`：真实材料边界、条件判断、自然中文、观众可理解、不过早锁死时长；作者真实经历需 Owner 提供或回避。
- `PREFLIGHT`：读取本 Handoff + G1 报告 + v0.2 候选规范；针对影响主结论的未验证数字执行定点补证或删去数字。
- `REQUIRED_EVIDENCE`：完整文本、段落目标、关键陈述证据/链接、至少一个反方场景、需要在 G3 补的真实素材/有条件验证清单。
- `ACCEPTANCE_CRITERIA`：开头提问明确；中段有真实发现/转折而非资料堆砌；每一幕增加信息；结尾按使用场景给出有边界的回答；全文没有虚假亲历、主张不大于证据。
- `ROLLBACK_STATUS_OR_PLAN`：分支新文档，可 Git 回滚；不触动其他项目或生产资源。
- `OWNER_ONLY_ACTIONS`：需要本人真实经历才能支撑主叙述时请 Owner 一次性核对；当前无需本人行动。
- `REVIEWER_TO_EXECUTOR_RELAY`：从 `docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md` 的第 1、3、4、5、6、7 节及 `docs/WRITING_STANDARD_DRAFT_v0.2.md` 的内容/语言与证据约束起步；不扫描整个仓库；写作先选择一个具体观众情境，保留 F2 主线。
- `EXECUTOR_TO_REVIEWER_RELAY`：输出一个完整可读脚本及支持证据和待补素材，并在 Evidence 记录完成范围；只可声明 PASS_CANDIDATE，最终由 Reviewer 审核。
- `MAX_AUTHORITY`：不买设备、不正式发布、不动生产代码。

## UNRESOLVED
- 中文 B站评论区问题出现频率：UNKNOWN；六个样本不足以证明全平台竞争空白。
- 中国 M4 二手/小主机当前可比价、VPS 统一档位与三年 TCO：G2 若要给具体数值，必须补证；否则条件性对比。
- 观众更愿意看「公网网站」还是「AI Agent 工作流」的细分主角：G2 要找一个能引发具体困惑的单人任务，避免三件事平铺。
- 个人真实桌面与工具录屏、音乐/产品素材授权、成片质量：G3–G5 处理。
- 真实长期使用、月耗电/家庭服务稳定性：未测，不可声称为第一手。
- 文案与视听生产系统能否复用到测评/实操：只有 G6 之后实验才能回答。

## NEXT_STEP
**G2**：把三种任务讲成一个有转折的故事；先提供可朗读完整正文 + 段落证据链接与关键视听职责，避免开始就做海报和 52 镜头。由 Reviewer 审查后决定是否进入 G3。

## EVIDENCE_POINTERS
- [G1 完整研究 / 一手来源 / 竞争样本 / 决策与反证](./docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md)
- [执行证据与审查](./EXECUTION_EVIDENCE.md)
- [候选写作规范 v0.2](./docs/WRITING_STANDARD_DRAFT_v0.2.md)
- [Draft PR #176](https://github.com/entropy-student/project/pull/176)

## DECISION_LOG (精简)
- 2026-10-28 / G0：Owner 授权独立立项；v0.2 仅作待验证材料，Governance 不改。
- 2026-10-28 / G1：独立核对 2026 M6 上市价与 2024 M4 历史价；「涨价」不是足够差异化的整集主线；首选 F2 「三类需求分流」，保留宏观消费问题，并明确仅取样的局限。
