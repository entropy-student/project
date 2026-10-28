# Mac mini Video Pipeline Pilot — REVIEWER HANDOFF

> **唯一当前项目状态** · 2026-10-28 · **G3 设计审查 PASS / G4 小样 NEXT**  
> 治理：[VPS Project Governance v0.2.7](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md) 通用部分；VPS 运维条款不适用。  
> GitHub：`entropy-student/project` · 分支 `project/macmini-video-pipeline-pilot-20261028` · [Draft PR #176](https://github.com/entropy-student/project/pull/176)（未合并）。  
> **动态状态只写这里**；执行事实去 Evidence，研究/文案/分镜正文去 docs。

## PROJECT_GOAL
- **第一目标**：完成一期有真实研究、有视听设计、16:9、可供 B 站发布的 Mac mini 消费决策视频。
- **第二目标**：验证 AI 主动策划「选题→研究→文案→视觉导演→素材补全→成片→验收」的低成本可复用方法。
- 发布/购买设备/付费/安装系统由 Owner 另行决定。各 Gate 的设计/文本 PASS 不代表 VIDEO_PASS。

## PROJECT_STAGE / CURRENT_ACCEPTED_STATE
- `G0_PROJECT_INIT = PASS`：独立立项与治理/唯一 Handoff。
- `G1_CONTENT_DISCOVERY = PASS`：有限范围内的选题研究；主发现三种需求对应不同价值标准。详见 [G1](./docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md)。
- `G2_NARRATIVE_AND_SCRIPT = PASS`：完整中文口播 V1（七段）与文本层面事实审查。详见 [G2](./docs/G2_NARRATIVE_AND_SCRIPT.md)。
- `G3_AV_DIRECTOR_AND_ASSET_TASKS = PASS`：14 个**语义视听节拍**、证据与自制图形的角色分配、素材任务/替代方案、两种最小动效小样计划。详见 [G3](./docs/G3_AV_DIRECTOR_AND_ASSET_TASKS.md)。
- **当前 G3 通过范围**：设计覆盖全文、与 G2 声音锚点对应、关键来源/展示目标/责任和失效替代明确；允许进入 G4 实物小样制作。
- **未验证范围**：尚无真正动效/HTML/MP4、未试听配音、未拿到可用的解说小人/桌面素材、素材权利仍待审核。不能把“已规划”写成“画面已能运行”。
- `PROJECT_STAGE = AV_DESIGN_ACCEPTED / PROTOTYPE_PENDING`
- `CURRENT_GATE = G4_ASSET_AND_VISUAL_PROTOTYPE`
- `NEXT_STEP = G4`：真实生成并审看 **AV10→AV11→AV12** 的低成本**可打开小样**；有条件再测 AV04→AV05 三任务分流，带截图/可检验媒体文件及事实/视觉 QA，不批量生产整片。
- `OWNER_ACTION_REQUIRED = NONE`：首个小样只用可自行制作的图形/资料，不必 Owner 买机或拍摄。
- `DEFAULT_EXECUTION_CHANNEL = ChatGPT Reviewer + GitHub 项目分支（研究/设计文档）`；可用媒体执行通道需要 G4 在实际工具环境读回核实。
- `CURRENT_ROLLBACK_STATUS = 未合并 Draft PR 仅文档，Git 可回退，无外部业务、服务或媒体发布变更`。

### 项目进度
| Gate | 目标 | 当前状态 |
|---|---|---|
| G0 | 立项、隔离、唯一交接 | PASS |
| G1 | 研究、反证与选题判断 | PASS |
| G2 | 叙事与完整中文口播 | PASS |
| G3 | 视听导演、反向素材任务、动效方案 | PASS |
| G4 | 真正素材补全与关键视觉小样 | NEXT |
| G5 | MP4 / 配音 / 字幕 / 封面与作品 QA | PENDING |
| G6 | Owner 验收及可复用流程复盘 | PENDING |

## CURRENT EDITORIAL / DIRECTOR DECISIONS
- **选题**：《一个普通人，真的需要花 7000 块买 Mac mini 吗？》。严谨的价格画面用「¥6,999 起」，两代官方历史发布价格别当现有成交价格，发布前再核价。
- **观众承诺**：帮已有电脑、对 Mac mini/AI/个人网站动心的普通人辨认自己究竟需要什么，而非给无实机根据的性能测评。
- **核心发现 F2**：Mac 主力工作站、本地 AI/常开任务、公网网站的采购目标不同。F1：2024 M4 4499 → 2026 M6 6999 仅做跨代历史价开场。F3：Apple M6 官方 **4W 闲置** ≠ 本机实际负载耗电 ≠ 网站公网可用。
- **脚本冻结基线**：[G2 口播 V1](./docs/G2_NARRATIVE_AND_SCRIPT.md)；导演在 G3 未重写已接受的全文。G4 允许仅因实际试听/画面证据对冗余第一人称语句做最小局部修订并留痕。
- **画面主方法**：证据（真实官网资料）、解释（自制图形与路径）、情境（本人已有电脑，仅在拥有真实画面时）、节奏（文字与切换）四种职责分开；不从“一句对应一张图”推导制作。
- **两次关键视觉**：AV05 中心小电脑分成三类具体任务；AV11 以访问链显示“设备开机但假设网络断开”，不伪装实测故障。
- **形式**：16:9 主画面 + 清楚底部字幕 + 可隐藏的角落解说小人 + 可选左上角镜头计数；保持证据区可读优先。实际风格模板/角色循环视频仍待 G4 找到真实文件；不把无文件阻断为期望。
- **不强制展示 AI 聊天**；AI 是幕后调查、导演与素材计划工具。
- **Owner 一次性材料**：若后续需要个人感，由 G4/G5 精确提出「已有桌面 8–15 秒 + 脱敏网站画面」可选合并任务；拿不到可用不冒充实拍的自制情境。

## SYSTEM_MAP / 文件与依赖
```
Owner topic → G1 sources/editorial PASS → G2 spoken script PASS
→ G3 14 semantic AV beats/asset planning PASS
→ G4 working visual demo(s) NEXT → G5 finished video QA
→ G6 Owner acceptance / workflow retrospective
```
- 唯一状态 `REVIEWER_HANDOFF.md`；执行证据 `EXECUTION_EVIDENCE.md`。
- [G1 研究](./docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md)；[G2 脚本](./docs/G2_NARRATIVE_AND_SCRIPT.md)；[G3 视听导演](./docs/G3_AV_DIRECTOR_AND_ASSET_TASKS.md)；[v0.2 写作候选](./docs/WRITING_STANDARD_DRAFT_v0.2.md)。
- `ai-story-showrunner/` / `visual-narrative-animation-lab/` / PR #174 是**只读参考**，不修改其状态或共享资产。
- 真实媒体执行环境、角色视频文件、素材授权：`UNKNOWN`；没有真实视频生成、外部登录/付费、发布、Mac 实机验证。

## CRITICAL_CONSTRAINTS
1. 不制造作者已买设备/实测/已开通服务/经历宕机的画面或语句。
2. 每个核心主张有明确证据级别；截图/价格/功耗标注机型/日期；4W 只指官方闲置状态。
3. 重要画面表达因果/证据，禁止整片退化成逐句PPT；视觉演示优先于对模板软件的无止境搜索。
4. 所有未经授权的产品照片/官网截图/音视频的公开复用状态标为 UNKNOWN；与阅读事实来源不同，发布前清理或替代。
5. 没有用户实拍时不删核心推理；自制结构示意可不使用虚假体验画面。
6. 不为视频实验默认买 Mac mini、调用昂贵视频生成或安装一套新复杂系统。
7. 本项目隔离：不改 Governance、邻近项目、main、PR #174；不合并 PR，不自动发布。
8. 每 Gate 要 Evidence → Reviewer 复核 → 唯一 Handoff 更新 → GitHub 回读，未取得实际样例不得标媒体 PASS。

## CURRENT_GATE / G4_ASSET_AND_VISUAL_PROTOTYPE
- `GATE_ID`：G4_ASSET_AND_VISUAL_PROTOTYPE。
- `OBJECTIVE`：把 G3 的关键视觉概念做成**真实可视化/可播放的最低成本小样**，用实际画面而非描述验证是否理解、是否好看、是否容易实现。
- `MAX_ENDPOINT_THIS_ROUND`：**优先完成 AV10–AV12 结构动效**，含可打开本地 HTML/等效可播放样例、2–3 张 16:9 截图、静态替代状态及可复现启动说明；首个小样确实合格时，可补 AV04–AV05 视觉分流小样，但不制作整期。
- `MANDATORY_REVIEW_STOP`：审查首轮小样的真实性、可读性、可实现性并更新 Handoff/Evidence 后停止；禁止越到 G5 的配音/全片渲染/发布。
- `TARGET_AND_SCOPE`：仅 `macmini-video-pipeline-pilot/` 的 G4 原型、相应文档/Evidence/Handoff；外部原始素材需有来源和权限记录。
- `APPLICABLE_CRITICAL_CONSTRAINTS`：不虚构故障、不冒充 Apple 画面、版权审查、低成本、以真实文件可读回为准。
- `PREFLIGHT`：确认实际执行环境/可用浏览器与文件来源；从 [G3 第 4 节](./docs/G3_AV_DIRECTOR_AND_ASSET_TASKS.md) 的 S0–S4 工作；验明可截图/渲染、不能仅凭描述 PASS。
- `REQUIRED_EVIDENCE`：真实 HTML/等价媒体及生成过程、截图文件/预览确认、无声可读性检查、证据标注/素材授权字段、与静态替代对照、缺口/返工和所用工具清单。
- `ACCEPTANCE_CRITERIA`：AV10-12 的「4W 闲置 ≠ 公网稳定在线」通过静音画面能懂；节点/条件顺序真实，不暗示真实网络故障、数字出处可查；不溢出字幕/主画面；源码与实际截图对应；低成本可复用。
- `ROLLBACK_STATUS_OR_PLAN`：原型仅在项目分支/工作目录，回滚删除新增原型资产，不触及其他项目/运行服务；任何本地全局安装需另行评估，不自动进行。
- `OWNER_ONLY_ACTIONS`：不买机器、不需要个人实拍；若后续只能使用无法自动获取的本机循环解说小人，先使用不带角色的临时样例。
- `REVIEWER_TO_EXECUTOR_RELAY`：首先读取本 Handoff 的 G4 定义及 G3 文档第 4/5/7 节与 G2 的 E 段，依据 Apple 官方功耗行和 Cloudflare Pages 限制生成 16:9 的 S0–S4 小样；先验证真实可打开、截图正确；只做一个实质小样，不搜索全仓库/不安装 AE/不调用视频生成。
- `EXECUTOR_TO_REVIEWER_RELAY`：提供原型文件/截图/复现说明、直观可理解性和错误/来源审查，输出 PASS_CANDIDATE/RETURN；由 Reviewer 决定正式 PASS。

## UNRESOLVED
- 实际渲染环境/浏览器与用户本地解说小人、现有模板文件是否可用：UNKNOWN。
- G3 为设计 PASS，未有动画、截图、配音/MP4/实际字幕/声音节奏 QA：G4/G5 才测。
- Apple/Cloudflare 相关截图在最终 B 站视频中可用的版权与归属边界：未审计；可用自绘来源卡替代。
- 无 Mac mini 实机/长期 AI 或网站稳定性验证；不能宣称亲测。
- B站评论真实受众频次、竞争热度因果、统一报价/TCO：UNKNOWN；不追加无数据的量化结论。
- G2 一些感受/第一人称表达的 Owner 真实性认定仍待需要时核对；不因用户此轮未表态就默认同意亲历细节。
- 是否有吸引观众的真实视觉节奏、跨类型流程复用能力：真实小样和作品完成后验证。

## NEXT_STEP
执行 **G4 首个可运行视觉小样**：围绕 G3 的 AV10→AV11→AV12，制作“4W 闲置”和访问路径分离的 16:9 HTML 动效，导出截图/静态备选与复现说明，**先证明画面能解释信息**，再决定是否制作整期，避免反复陷入更多文字方案。

## OWNER_ACTION_REQUIRED
`NONE`。首轮 G4 不要求任何用户出镜、购买或安装工具。

## EVIDENCE_POINTERS
- [G1 内容研究](./docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md)
- [G2 连续口播](./docs/G2_NARRATIVE_AND_SCRIPT.md)
- [G3 双栏导演与素材任务](./docs/G3_AV_DIRECTOR_AND_ASSET_TASKS.md)
- [执行证据 G0–G3](./EXECUTION_EVIDENCE.md)
- [写作/视听规范候选 v0.2](./docs/WRITING_STANDARD_DRAFT_v0.2.md)
- [Draft PR #176](https://github.com/entropy-student/project/pull/176)

## DECISION_LOG（最小化）
- 2026-10-28 G2：研究型消费决策文字 V1 通过，未试听也未证实可拍。
- 2026-10-28 G3：保留 G2 口播基线，确立两次重点视觉表达；`AV05` 三需求分流、`AV11` 访问链因果；Owner 实拍/角落角色可选不阻断 G4 首测；下一轮先做真正可打开的 P2 小样。 
