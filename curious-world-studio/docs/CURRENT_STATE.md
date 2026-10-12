# Curious World Studio｜当前状态、执行入口与交接规则

> **唯一当前状态入口** · 2026-10-12 交接与重大阶段状态修正。本文替代此前不断叠加在`CURRENT_STATE.md`顶部的阶段状态。**旧的22KB阶段时间线已保存在本次Git历史中**，并保留 [完整2026-10-11事实总汇](PROJECT_HANDOFF_2026-10-11_POST_MERGE_CANONICAL.md)及所有原始Review/返工报告；不重写过去的PASS/RETURN。以后**不为每轮测试新建GitHub文档或自动提交PR**，按本文ZIP交接。

> **2026-10-12 最新 Owner 决定（覆盖此前待 R1 结果等过时时态）**：**先不换题，暂停继续推进。** 最新 [Reviewer完整交接](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md) 汇总五个R1/R2包、媒体核验与历史失败证据。最后验收：**CW-0005爆米花两条库存视频获取和解码已在本机完成，但淀粉脚核心录像不可见，`CW0005_VISUAL_STORYFIT_HOLD`，不进R3。** 此前建议CW-0004/CW-0008备选预检**没有被Owner授权执行**；新Reviewer不得依历史建议自动切题。\n\n## 0. 一眼看懂目前到哪里了

| 模块 | 已确认 | 还没有完成 / 下一步 |
|---|---|---|
| 频道内容 | B站为主，不露脸；跨领域「近且未深思」真实问题；九源体系和36条选题库（SHORTLIST 11／VERIFY 15／HOLD 9／REJECTED 1） | **零个正式STORYFIT_GO**；先选一个有真实画面和合法权利的题，原题库不自动升级 |
| 首期实际内容 | 已完成CW-0002/CW-0005两题R1、三题素材预检及CW-0005 R2设计/R2-M1媒体实测；**Pexels 854959与Pixabay 2793均通过本机获取/解码，六张抽帧已独立Review** | **`CW0005_VISUAL_STORYFIT_HOLD`**：淀粉脚真实压缩/反弹机制镜头缺失，研究Movie S1/S2权利未知；**Owner决定先不换题、暂停后续执行**，R3不授权 |
| 视觉基准 | Research Aqua V2：A复古Mac开文件→B QuickTime满幅播放器；1920×1080、30fps；单行中文字幕 | **3+1的「＋1」仅2转场、4布局、6来源/信息字幕**需做Aqua样式小样与Owner检查；视觉语法目前是**设计提案** |
| Mac动效库 | 原有开窗+第一批5种（Owner原则认可）+第二批4种；第二批MW11/12/13为Reviewer KEEP候选，MW07精修经Reviewer独立技术和视觉改善复核为KEEP候选 | **停止新增功能/无限精修**；MW07及第二批Owner最终常速审美签收、Windows Edge`file://`仍待确认。正式B并未授权额外Mac UI动效 |
| 媒体与生成 | M2代码PR#116已合并，M1/M2样片媒体QA及单次F2回归留有技术证据；OpenMontage渠道及yt-dlp单一Blender合法测试直链已验证部分能力 | **正式G1未PASS、G2未授权**；旧第184帧故障根因未知，6x渲染最低可用内存221.86MiB；没有正式研究视频/配音/声学单行字幕/整片稳定性闭环 |
| 本地空间 | CWS只读审计与248项分类纠错**均已通过Reviewer验收**：723项、71.93MiB逻辑量；174项保持保护、74项保持HOLD；无已证明安全删除项 | **本轮清理正式收尾，安全可删0B，实际删除0项**；停止扩大扫描，不因暂停项目而删除本地证据 |

> **注意**：本文以明确得到的GitHub与当前用户反馈为准；状态不代表已进入正式制作或获得版权许可。历史PR #115/116/117/118/119/120/121/122/123/124 已在各自阶段记录，**无需反复复核旧PR或重跑9秒小样**。

## 1. 以后正式固定的分工和最短轮次

**我（主编/独立Reviewer）定大多数编辑和技术验收方案**；**本地Codex执行**；**Owner负责转交提示词与ZIP、在必要时审美复核和单独授予敏感动作许可**。按 [4轮主线3泳道图](P4_MAINLINE_COLLAB_SWIMLANE_4_ROUNDS_2026-10-11.md)：

| 轮次 | 执行和验收 | Owner参与 |
|---|---|---|
| **R1 选题／真实素材／rights** | 我下任务→Codex实地核原文和录像→我定优先题/缺口/需换题 | 转交ZIP；普通编辑取舍不必Owner先选 |
| **R2 剧本／镜头／Aqua2-4-6** | Codex按我的叙事任务写稿和逐句证据/镜头表、做三个独立预览→我初审 | **关键复核①**：故事与视觉方向 |
| **R3 30–60秒音画字幕联调** | Codex用真正允许复用的素材、经批准音色与单行字幕做小样→我做独立QA | 只涉及需要额外授权的费用/权限时介入；**生产管线首次完整做一遍，日后模板稳定可跳过完整R3、但保留受影响组件回归** |
| **R4 第一版完整内部草片** | Codex制作自然时长全片、素材权利/声音/字幕/渲染QA→我初审 | **关键复核②**：完整正常速度看整片，决定修改/继续 |

**理想最少4轮到第一版内部完整可看草片，不保证4轮上线；R5公开发布、正式Gate、版权风险、付费、联系作者、实际删文件必须另获Owner明确批准。** 素材关键权利缺失就原轮HOLD/切题，不假造研究场景。长期稳定后各期通常R1→R2→R4，R3只在生产管线/模板/格式/配音等出现改变或失败时局部回归；**R4每期QA不能省略**。

## 2. 改成ZIP交接，不再每轮修改GitHub

**每一轮固定流程（默认只传提示词，不传双向附件）**：
`我给精确Codex提示词→Owner粘给本地Codex→Codex在新隔离目录执行→一次性输出ZIP及SHA256→Owner上传ZIP→我独立核验/决定GO、HOLD、RETURN→发下一轮提示词`。

- **取消默认“Reviewer发ZIP→Owner下载→再传给Codex”的反向中转。** Reviewer有问题时直接在下一条提示词里给出可复现的验证条件/冲突行计数/本地来源位置；Codex本地已经有源数据，不必再上传一份Reviewer报告包。
- **仅当Codex确实缺少不可由原材料重建的具体输入**（例如人工逐项标注、修改后的源文件、专用图片）时，才请Owner额外传那个必要附件。**反方向从Codex→Owner→Reviewer的ZIP仍是强制交付**。
- **清理纠错ZIP已经收到并通过Reviewer复核**；248条分类问题解决，零条安全删除；没有获准删除的路径。以后不为这几十MiB重复清理。

### 本地常用文档：固定保留、不重复下载（2026-10-11 Owner新规则）

**分两层，不重复维护两份“真相”：**

- **仓库正式规范（Git跟踪）**：`docs/CURRENT_STATE.md`、`AGENTS.md`、`STYLE_LOCK.md`、正式素材3+1合同、主题库及已通过的生产源码/模板。Owner机器如果已有该仓库的本地checkout，Codex**先读本地文件**并确认Git commit/工作树状态；只有明显落后且已允许时才按正常Git同步，不必反复从网页下载同一文档。不要因本条擅自pull覆盖未提交修改。
- **机器本地工作区（不进Git）**：统一在**实际核实存在的** `curious-world-studio/.local/` 下保留常用工作材料：`notes/PROJECT_BRIEF.md`（当前轮次与阻塞的一页摘要）、`notes/RUN_INDEX.md`（每轮RUN_ID、ZIP路径、SHA、Reviewer状态）、`notes/SOURCE_RIGHTS_LEDGER.md`（逐个素材的来源/画面/权利三状态）、必要的`templates/`及`handoff-zips/`。首次使用时才建立这些路径；本仓的项目级`.gitignore`会忽略整个`.local/`。不需要每轮新增十份散落的`docs/REPORT_*.md`。
- **只有用户明确需要的常用文档才在`.local/notes/`持续更新**；这些只是方便执行的工作索引，**不能取代Git正式规范，也不能把未知授权写成PASS**。每轮原始报告/截图/录屏仍打包成一个ZIP，由Codex交Owner→Reviewer；本地保留ZIP并合理备份，绝不自动删除历史重要证据。
- **写入权限注意**：本地 `.local/` 约定已在R2/R2-M1实践；以后继续遵守每轮权限边界。**当前Owner暂停后续任务，不能因为本地已有材料便自动重启执行**。不应再让Owner为普通Review反馈反向传ZIP给Codex。

**每个ZIP至少包含**（按实际任务删去不适用项）：
- `README.md`：`RUN_ID`、任务目标/执行范围、本机环境/源Commit、真实执行时间、退出码、每项`PASS/FAIL/NOT_RUN`、未做事项、阻塞、下一步；
- `manifest.json`：相对路径、文件大小、SHA256、产生/来源说明，ZIP本身另给SHA256；用相对路径，**不把整机用户目录/密钥拷进包**；
- `evidence/`：必要原始日志/核实的截图/正常速度可审视频/小而可读的对照表；**没有真实测试就标NOT_RUN**；
- `handoff.md`：一句话结果、给Reviewer检查的具体问题、环境限制、可回滚边界；**Reviewer不能只信Executor自报PASS**；
- 若涉及正式代码：`patch.diff`或独立源文件及测试回归；**已获准的稳定代码仍必须走Git分支/PR/Review合并，不能让ZIP成为唯一源码版本**。

**GitHub只在这些时刻再改**：锁定/更改长期规范、正式选题库结构与数据、已Reviewer通过且需要复用的生产源代码或模板、影响后续执行的重大Owner决定与里程碑状态。**普通每轮报告、录屏、截图、故障日志留ZIP本地归档，不再一轮一份`docs/*_REVIEWER*.md`。** 需要跨新聊天交接时，Owner带最近一次ZIP或`handoff.md`；不要假设ChatGPT新对话自动拥有本地证据。Owner需本地备份这些ZIP，保存必要历史失败证据和最少两个可靠副本（如现有工作盘+已有安全备份），不要把它们当垃圾删除。

## 3. 本轮本地清理已结束：无安全删除项

读取[正式生产前受控清理合同](PREPRODUCTION_CLEANUP_POLICY_2026-10-11.md)。**本轮只读盘点可删候选/潜在节省，不做任何删除、移动、压缩原始证据或Git GC**；允许仅在**新的独立审计输出目录**写审计报告和交接ZIP。不全盘清系统、不碰VPS/VPN/Clash/OpenMontage共享安装/其他项目。**清理必须两步授权**：

1. `CLEANUP_AUDIT_ONLY` 及 `CLEANUP_AUDIT_CORRECTION_ONLY` **均已交ZIP并通过Reviewer**：174个同哈希保护冲突已移出候选，旧Temp 74项维持HOLD；实际SAFE项0、实际删除0。纠错中仅凭文件名命中不足以证明可删，本轮不继续扩大审计。
2. `OWNER_EXPLICIT_DELETE_LIST`：如Owner另批准明确的绝对路径与逐项操作，再发第二段删除/移动任务；默认未授权。**当前不存在获准删除的路径**。

**主线R1、R2和R2-M1 的ZIP均已交付并经过Reviewer审核**。目前 `CW0005_VISUAL_STORYFIT_HOLD`，Owner于2026-10-12明确先不换题并暂停；**没有自动待执行的下一条Codex提示词**。原 [R1两题证据与权利任务](../p4-g1/P4_MAIN_R1_EDITORIAL_STORYFIT_RIGHTS_GATE_2026-10-11.md) 的“NOT_EXECUTED”是编写时历史状态，不可覆盖本段。R4长片前若涉及大容量处理，仍必须按当前受控权限做磁盘预算，不准未经授权清理。

## 4. 仓库导览：以后只读这些，历史证据不乱删

| 使用场景 | 主文件 |
|---|---|
| 现在进度与ZIP协作 | **本页`docs/CURRENT_STATE.md`**（唯一活状态） |
| Codex的项目边界 | [`AGENTS.md`](../AGENTS.md)（正式规则优先于其中历史时态） |
| 频道定位 | [`docs/CHANNEL.md`](CHANNEL.md) |
| 七阶段研究/题库 | [`research/topic-bank/WORKFLOW_V1.md`](../research/topic-bank/WORKFLOW_V1.md)、[`TOPICS_V1.json`](../research/topic-bank/TOPICS_V1.json)、[`BOARD_V1.md`](../research/topic-bank/BOARD_V1.md)、[`SOURCE_SYSTEM_FINAL_V1.md`](../research/SOURCE_SYSTEM_FINAL_V1.md) |
| 正式视频合同 | [`STYLE_LOCK.md`](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)、[`3+1合同`](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)、[`2/4/6统一视觉提案`](P4_VISUAL_GRAMMAR_3PLUS1_RESEARCH_AQUA_246_2026-10-11.md) |
| 媒体源代码与V2参考 | [`p4-g1/m1-media-adapter`](../p4-g1/m1-media-adapter/)、[`V2 HTML`](../p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html) |
| 当前交接及R1→R2-M1实际证据 | **[2026-10-12新Reviewer完整交接](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)**；[原R1任务书](../p4-g1/P4_MAIN_R1_EDITORIAL_STORYFIT_RIGHTS_GATE_2026-10-11.md)仅作历史 |
| 历史具体事故/证明 | [`2026-10-11原完整项目交接`](PROJECT_HANDOFF_2026-10-11_POST_MERGE_CANONICAL.md)、`docs/P4_*.md`、`docs/MAC_WINDOW*.md`、旧`REVIEWER_HANDOFF*.md`与Git历史 |

**仓库当前阶段快照（2026-10-12）：** `R1_RESEARCH_REVIEWED / R2_DESIGN_DRAFT_KEEP / R2M1_MEDIA_ACQUISITION_DECODE_PASS_BY_LOCAL_EVIDENCE / CW0005_VISUAL_STORYFIT_HOLD / OWNER_PAUSE_NO_TOPIC_SWITCH / CLEANUP_CLOSED_NO_DELETIONS / MAC_MOTION_STOPPED_OWNER_VISUAL_PENDING / G1_NOT_PASS / G2_NOT_AUTHORIZED`。本节是事实状态，不代表正式素材使用权完整通过或自动批准下一轮。

**仓库治理（2026-10-11 二次收敛）**：原 `docs/` 46份包含大量历史有效证据，未为腾几KB空间而批量删除。已将**6份明确过期的一次性Codex执行Gate/未授权旧回归提案**从Git当前文件树移除，原内容仍由父提交 `f6095a5993531dbf412ba11082b7d022c38bff2e` 的Git历史可恢复；正式工程源码、3+1/STYLE_LOCK、选题库和原始独立QA不删。项目今后按“只更新持久代码/协议/经审批的里程碑”提交，而非每轮建报告。共享OpenMontage位于Owner Windows另一安装目录，不归本轮GitHub或本地清理。
