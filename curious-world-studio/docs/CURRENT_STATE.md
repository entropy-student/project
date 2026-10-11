# Curious World Studio｜当前唯一状态快照

> **更新时间**：2026-10-11；**性质**：项目运行状态与接手导航，**不是业务规则或研究主协议**。
> 若其他文件有相互矛盾的“目前 / 下一步 / 尚未运行”等时态表述，请以本页最新事实状态为准；**选题业务规则仍以 `research/topic-bank/WORKFLOW_V1.md` 为准**，HF-FIND 和视觉参数仍各以其锁定协议为准。历史报告的研究结论、事实来源和时间戳不得被本页覆盖。
>
> **当前 Reviewer 完整接手摘要（2026-10-11）**：[REVIEWER_HANDOFF_2026-10-11_G1VA.md](REVIEWER_HANDOFF_2026-10-11_G1VA.md)，包含所有最新 G1V-A 双版本、授权边界、交接路径、分支审计及 Codex 下一任务；[2026-10-10 P4-G0 旧交接](REVIEWER_HANDOFF_2026-10-10_P4G0.md)仅作历史资料。唯一阶段状态仍以本页为准。

## 1. 当前阶段与真正的下一步

- **项目定位**：B站主阵地、不露脸、跨领域真实现象/研究；观众在休闲探索中获得一项可核对的“原来如此”。**2026-10-10 Owner 明确：无强制时长、不能拖沓、优先兑现观众承诺与观看感受**；原常用 4–6 分钟仅供策划排期参考。抖音/小红书辅助。
- **当前阶段 `P3-R6 NARRATIVE COMPLETE + P4-G0 UPSTREAM STATIC DONE / LOCAL READBACK RECEIVED / G0_CONDITIONAL`**：2026-10-10 Windows 本地 Codex 已按既有任务书完成**只读查询与文字集成设计**，报告已交 Owner 并归档到 GitHub `main`：[本机能力回读](P4_G0_LOCAL_CAPABILITY_READBACK_2026-10-10.md)。存在 OpenMontage、Remotion 4.0.484、Node、FFmpeg、atelier 源码接口的本地证据；但安装无 `.git`，确切源码来源 UNKNOWN，中文**定稿文案强制对齐未证**、Qwen 实际配置 UNKNOWN、该 G0 只读报告阶段没有运行或渲染（但后续 G1/G1V-A 已真实渲染，见下文）。Reviewer 已给出 [四项接口纠偏与 G1 验收合同草案](P4_G0_CONTRACT_CORRECTIONS_AND_G1_ACCEPTANCE_2026-10-11.md)，包括音轨零点、权利三状态、主音轨版本锁、一行拆多字幕。**G0 仍为 CONDITIONAL，非 `G0_DESIGN_READY_NO_RENDER`、非 G1/生产 PASS**；2026-10-11 文档修订通过 [PR #93](https://github.com/entropy-student/project/pull/93) 合并至 `main`，未改变本地运行状态。
- **P4-G1-R2 真实复渲 + Owner 视觉否决（2026-10-11）**：G1-R2 的24.2秒 H.264 1920×1080/30fps/726帧样片、字幕/音频波形对齐、Fig.8防遮挡等机器QA真实完成（[本机R2报告](P4_G1_R2_EXECUTION_REPORT_2026-10-11.md)、[Reviewer独立QA](P4_G1_R2_REVIEWER_INDEPENDENT_QA_AND_OWNER_GATE_2026-10-11.md)）；**Owner 实际观看后明确拒绝其视觉质量**：A 段是静态假桌面而非桌面→打开文件→播放器→全屏动态事件；B 段把 Fig.7/8 多格拼图作为主要静态画面，没有观众愿意看的真实实验行为镜头；Windows SAPI 配音音色差，音量及字幕同步基本可接受。**唯一结果：`G1_VISUAL_REJECTED / G1_NOT_PASS`**。之前的静帧/机器 PASS 不等于视觉体验通过，不能只等最终音频听审就自动晋级；G2/G3 均未获授权。
- **P4-G1V 原视频在线只读核验已完成（2026-10-11）**：本地 Codex 基于提交 `f719224f6579d9f91c612c0b043d21ba920522e3` 在 Edge 原播放器把制作过程、Video1、Video2 **3/3 全部播放到结尾**；[执行报告](P4_G1V_SOURCE_SCREENING_READBACK_2026-10-11.md)记录上传者 NAKATA Lab UEC Tokyo、视频标记未公开、最高720p/720p60、Video2手/玩具动作、制作片配料/灌模/脱模镜头；Video1的**明显摆动周期未被核实**，Video2部分镜头玩具挡住果冻、铃声/原声无法真实听审。3/3上传许可证无可见核验资料，**使用权依然 `RIGHTS_UNKNOWN_PERMISSION_REQUIRED`**；`yt-dlp=TOOL_NOT_PRESENT`，本轮无下载、录制、安装或渲染。Reviewer [结论及后续双轨计划](P4_G1V_SOURCE_SCREENING_REVIEW_AND_NEXT_GATES_2026-10-11.md)接受在线观察证据而不提升视频发布权或视觉验收结果。**G1仍 `G1_VISUAL_REJECTED / G1_NOT_PASS`，G2/G3未启动。**
- **P4-G1V-A 视觉基准已选定（2026-10-11）**：本机 Codex 的真实7s/210帧 Remotion 原型已完成机器QA但 Owner 更偏好 Assistant **V2 Research Aqua** 9s/270帧自绘 Canvas/HTML。V2两个 MP4 的 SHA/元数据以及真实源码已独立核验；详见[正式对照评审](P4_G1VA_CODEX_VS_ASSISTANT_V2_VISUAL_REVIEW_2026-10-11.md)、[Codex原始执行回读](P4_G1VA_CODEX_LOCAL_EXECUTION_REPORT_2026-10-11.md)与[已选 V2 源码、QA和渲染参考](../p4-g1/visual-reference/README.md)。Owner 选择 **`G1VA_VISUAL_REFERENCE_SELECTED=ASSISTANT_V2_RESEARCH_AQUA`**，但 V2 **未接入可更换真实MP4输入素材**，既有程序画的果冻仅为示意。**G1/G2 均未通过/启动**，不应重做另一套 UI。
- **P4-G1V-A-M1 真实本地视频文件接入已完成单夹具技术验证（2026-10-11）**：Owner 本机 Codex 在 SHA锁定的 V2 Research Aqua HTML 上建立真实 Remotion媒体适配器，使用**自己生成**的 6秒/180帧/30fps/1920×1080 MP4（SHA `bc6f92d9ad4e422e6bbcf432dc65bcf340c6fd30998e1211b773cc5a510403b3`）作为输入，渲染9秒/270帧、H.264、无声 MP4（SHA `d1e25a34ad41ba87a8e7ee836c4f44a54d39ac52c511861f350e340da6ba2516`）。Reviewer **实际读取了 Owner 上传的完整 ZIP、真实MP4、源视频、poster、Remotion源代码和QA**，独立证明 poster 与源首帧逐像素完全一致、开窗直到播放前首帧未推进、播放后1秒画面匹配源视频第30帧，完整解码且未见黑段；同时间与选定 V2 MP4 对照，发现UI与行为链基本忠实。**结论 `M1_REVIEWER_TECH_PASS_ONE_FIXTURE / OWNER_VISUAL_REVIEW_PENDING`；并非适配任意视频、并非G1通过。** 见[正式 M1 Review](P4_G1VA_M1_REVIEWER_INDEPENDENT_QA_2026-10-11.md)、[获证源码与安全边界](../p4-g1/m1-media-adapter/README.md)。未上传二进制MP4到仓库，本机渲染器源码4件经Git blob逐字节校验并已归档。
- **下一步（M1 Owner 实际看视频 → 后续 M2 可扩展性）**：请 Owner **完整观看9秒 M1 真实媒体接入 MP4**，确认所选 Research Aqua 桌面、文件开窗、真实视频首帧、点击播放和进度条是否仍符合 V2 的观感。Reviewer可对当前**30fps、1920×1080、6秒、无音轨单夹具**下技术指标予以通过，但不可声明竖屏/24/25/60fps/带声/任意时长支持；下一门禁应先独立规划不同格式和长度的适配，避免直接生产 B 内容、修改正式视觉或进入 G2/G3。默认不使用研究原视频，素材权利和示意标签仍独立审核。当前仍 `G1_NOT_PASS / G2_NOT_AUTHORIZED`。
- 原始故事性评判「B 优于 D、D 应 HOLD」是此前**证据节点视角的编辑假设**；后续仍需从观众体验重审。研究事实保留，**未改变任何正式题目状态**。

## 2. 七阶段流程与当前完成度（简述）

Owner 批准的既定次序保持：**九大信息源 → 批量发现 → 统一筛选与评分 → 正式选题库 → STORY-FIT → 剧本/证据/权利 → 视频制作/QA/发布**。

| 模块 | 当前有效事实 / 不可误报的边界 |
|---|---|
| 来源体系 | `research/SOURCE_SYSTEM_FINAL_V1.md` 为正式九源分层规范；`research/SOURCE_REGISTRY_V1.md` 为被替代的历史候选；HF-FIND 唯一主协议不变 |
| 在线采集器 | P0/P1 的 GitHub Actions 真实运行与 24/24 回归已通过；2026-10-07～09 可观测 **537 条元数据**（并非高质量选题），总体九源**归档完整性仍 PARTIAL**，没有自动全量覆盖通过 |
| 正式选题库 | `TOPICS_V1.json` **36 条**：SHORTLIST 11 / VERIFY 15 / HOLD 9 / REJECTED 1；与 `BOARD_V1.md` 同步，全部 `storyfit_status=NOT_STARTED`；B 声音 `10.1371/journal.pbio.3004046` 与 D 认知负荷 `10.1371/journal.pone.0360059` **均未入机读库** |
| 论文/事实 | P2-A 标题摘要抽样、P2-B/C 原文/来源对账、P2-D Owner 偏好 B>D 及 P3 的研究事实**可追溯**；独立二审、真实观众实验、完整竞品与逐件媒体授权仍未通过 |
| B 补充音频 | [P2-E 文件级 QA 索引](../research/topic-bank/batches/2026-10-10_P2E_AUDIO_QA_EVIDENCE_INDEX.md)：官方 RAR5 可获取，14/14 WAV 的格式和元数据核验成功；**非真人试听、非音频生成、非播放兼容或商用授权 PASS**；原脚本/工作流留在未合并研究分支，不进入生产 |
| 视觉 | `visual/retro-mac-v1.2/docs/STYLE_LOCK.md` 为锁定的 Tiger Aqua / QuickTime 7 **A/B 两状态视觉规范**；HTML 仅外观预览；无第三个 C 状态 |
| 视频执行技术 | G1 R1/R2 MP4 机器路线成立但 Owner否决其视觉；G1V-A Owner已选 Research Aqua V2。**M1 已渲染真实9秒MP4并通过 Reviewer 针对一个6秒/30fps自制测试素材的首帧冻结/播放时钟/270帧独立 QA**；尚待 Owner观看，通用媒体/正式G1未通过 |
| 本仓生产接口 | **M1已归档准确的Remotion适配代码4件**，V2 HTML iframe + 真正 OffthreadVideo /首帧poster/按输入6秒进度驱动；尚未经过混合FPS/纵向、多轨音频、正式镜头或科研事实 QA；OpenMontage整条自动生产链仍未闭环，G2未授权 |

在线采集佐证：[P1 审计](../research/topic-bank/batches/2026-10-10_COLLECTOR_P1_COVERAGE_AND_TOPICS_REVIEW.md)、[Actions #38022638179](https://github.com/entropy-student/project/actions/runs/38022638179)；叙事校准：[P3-R1](../research/reports/2026-10-10_P3R1_NARRATIVE_MECHANISM_MARKET_RETROSPECT.md)；B/D 旧结构评审：[P3 报告](../research/topic-bank/batches/2026-10-10_P3_BD_STORYFIT_ENTRY_GATE_REVIEW.md)。

## 3. 本地 OpenMontage 来源和边界

**证据分层**：下列既包含 Owner 之前的技术交接，也包含 [2026-10-10 本地 Codex 只读回读](P4_G0_LOCAL_CAPABILITY_READBACK_2026-10-10.md)。GitHub Reviewer **未直接登录 Windows 环境独立复测**；本机报告当前结论是 `G0_CONDITIONAL`。
- Codex 回读称 `C:\Users\34707\Tools\OpenMontage` 与 `C:\Users\34707\.agents\skills\openmontage\SKILL.md` 均存在，Skill 声明支持 `$openmontage`；根目录**无 Git 元数据**，版本谱系待核。已见 Remotion 4.0.484、Node 24.19.0、FFmpeg 9.0；存在 ≠ 运行/渲染通过。
- Owner 历史记录：Pexels/Pixabay → 云端中文 TTS → FFmpeg 曾形成约12秒技术闭环；**此次未重新运行，实际 Qwen 配置依任务书未读取 `.env`、未证实可用；中文字幕定稿文本强制对齐、素材语义匹配、长片质量和商业化授权均 PENDING**。
- 不重装、不重复 API 连通/12 秒视频基线，不调用云模型生成测试 TTS；不触碰 Windows/VPS 网络或 VPN/WG/HY2/Clash。
- **2026-10-11 例外授权**：Owner 已批准 G1 的隔离私有样片及从研究信息源定向下载可用图片、做实际本地测试；不授权其他视频、付费 TTS、软件安装、未核准的外链实验视频、公开发布或正式商业生产。详见 [G1任务](../p4-g1/LOCAL_CODEX_G1_TASK.md)。

## 4. 技术 Schema 已修复；以下仍是需要 Owner 裁决的业务逻辑问题（不得自动修改）

1. **Schema 技术不一致已按 Owner 授权修复**：`TOPICS_V1.json` 扩展至 `CW-TOPIC-BANK-1.1`，保留原有 36 条内容/评分/状态；四项可空追溯字段以 `null` 表示未知；WORKFLOW **只修改第 3 节字段合同**，新增只读校验器和按文件范围触发的 GitHub Actions（[首轮通过记录](https://github.com/entropy-student/project/actions/runs/38032465320)）。见 [Schema v1.1 迁移记录](../research/topic-bank/SCHEMA_V1_1_CHANGELOG.md)。**评分和晋级业务规则仍未修改**。
2. 旧四轴 PROGRESSION 倾向按“多证据节点”评估；P3-R1 新研究倾向按“观众理解如何变化”评估。**当前正式规则不变**；P3-R2 测试后再提出修订方案。
3. B/D 的旧编辑建议仅作历史记录；不得自动为 B/D 新建 CW ID、升级 SHORTLIST、赋予 STORYFIT_GO 或把 D 正式标为 HOLD。
4. M1/M2/M3 仅待测试；真实人物选择和假设情境是两种不同来源边界，是否写入正式节目协议需 Owner 许可。
5. 5 条 VISUAL=HIGH 的 SHORTLIST 仍可能 `video_content=NOT_FRAME_REVIEWED`、`media_rights=UNKNOWN`；**视觉潜力不等于素材就绪或可商用**，本轮不改旧评分。
6. B 的原始声音 QA、真实观众兴趣、B站竞争与视频逐项版权均不能被视为已完成；不因历史实验数量或单人编辑偏好自动通过。

## 5. 权威资料阅读顺序

1. **本页**：当前状态与下一步。
2. [README](../README.md) 与 [AGENTS](../AGENTS.md)：项目范围与基本入口。
3. **业务协议**：[七阶段选题工作流](../research/topic-bank/WORKFLOW_V1.md)、[HF-FIND](../research/HF_有趣发现_唯一主协议.md)、[正式信息源](../research/SOURCE_SYSTEM_FINAL_V1.md)、[视觉锁定](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)。
4. **数据事实**：[TOPICS_V1.json](../research/topic-bank/TOPICS_V1.json)、[BOARD](../research/topic-bank/BOARD_V1.md)，以及对应批次事实审计。
5. **最新**[G1VA Reviewer接手](REVIEWER_HANDOFF_2026-10-11_G1VA.md)、[V2媒体适配任务](../p4-g1/LOCAL_CODEX_G1VA_V2_MEDIA_ADAPTER_TASK_2026-10-11.md)、[V2视觉参考](../p4-g1/visual-reference/README.md)；**历史**[P4-G0旧Reviewer交接](REVIEWER_HANDOFF_2026-10-10_P4G0.md)、[G0上游静态审计](P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md)、[G0本地Codex任务书](P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md)、[已收到的本机回读](P4_G0_LOCAL_CAPABILITY_READBACK_2026-10-10.md)和[Reviewer接口纠偏](P4_G0_CONTRACT_CORRECTIONS_AND_G1_ACCEPTANCE_2026-10-11.md)：交接/本地实际证据/最新工程设计分层使用。
6. [REVIEWER_HANDOFF](../REVIEWER_HANDOFF.md)、[STATUS_AND_DECISIONS](STATUS_AND_DECISIONS.md)、[PROJECT_HANDOFF_2026-10-10](PROJECT_HANDOFF_2026-10-10.md) 是**含时间顺序的历史交接补充**，不应反过来重置当前状态。

**治理约束**：项目方向、原始研究历史、既定评分/晋级规则、正式 36 条题库、视觉规范及技术环境均未由这份状态文档修改。