# Curious World Studio｜当前唯一状态快照

> **更新时间**：2026-10-11；**性质**：项目运行状态与接手导航，**不是业务规则或研究主协议**。
> 若其他文件有相互矛盾的“目前 / 下一步 / 尚未运行”等时态表述，请以本页最新事实状态为准；**选题业务规则仍以 `research/topic-bank/WORKFLOW_V1.md` 为准**，HF-FIND 和视觉参数仍各以其锁定协议为准。历史报告的研究结论、事实来源和时间戳不得被本页覆盖。
>
> **2026-10-10 新聊天 Reviewer 唯一完整接手摘要**：[REVIEWER_HANDOFF_2026-10-10_P4G0.md](REVIEWER_HANDOFF_2026-10-10_P4G0.md)。其第8节附有本轮最终只读复核、36条题库回读、16份核心文档217条内部链接核验和**可直接复制到新聊天的交接话术**。本页仍是唯一当前状态，接手摘要不是新业务协议；仅核路径，不等于模型/渲染/本地接口测试通过。

## 1. 当前阶段与真正的下一步

- **项目定位**：B站主阵地、不露脸、跨领域真实现象/研究；观众在休闲探索中获得一项可核对的“原来如此”。**2026-10-10 Owner 明确：无强制时长、不能拖沓、优先兑现观众承诺与观看感受**；原常用 4–6 分钟仅供策划排期参考。抖音/小红书辅助。
- **当前阶段 `P3-R6 NARRATIVE COMPLETE + P4-G0 UPSTREAM STATIC DONE / LOCAL READBACK RECEIVED / G0_CONDITIONAL`**：2026-10-10 Windows 本地 Codex 已按既有任务书完成**只读查询与文字集成设计**，报告已交 Owner 并归档到 GitHub `main`：[本机能力回读](P4_G0_LOCAL_CAPABILITY_READBACK_2026-10-10.md)。存在 OpenMontage、Remotion 4.0.484、Node、FFmpeg、atelier 源码接口的本地证据；但安装无 `.git`，确切源码来源 UNKNOWN，中文**定稿文案强制对齐未证**、Qwen 实际配置 UNKNOWN、没有运行或渲染。Reviewer 已给出 [四项接口纠偏与 G1 验收合同草案](P4_G0_CONTRACT_CORRECTIONS_AND_G1_ACCEPTANCE_2026-10-11.md)，包括音轨零点、权利三状态、主音轨版本锁、一行拆多字幕。**G0 仍为 CONDITIONAL，非 `G0_DESIGN_READY_NO_RENDER`、非 G1/生产 PASS**；2026-10-11 文档修订通过 [PR #93](https://github.com/entropy-student/project/pull/93) 合并至 `main`，未改变本地运行状态。
- **P4-G1 真实样片已生成但未通过（2026-10-11）**：Windows 本机 Codex 续跑以原审定字幕和 Fig. 7/8 生成真实 **24.200秒、1920×1080、30fps、726帧 MP4**、8段 SRT、时间轴与 QA 记录（[本机报告](P4_G1_EXECUTION_REPORT_FINAL_2026-10-11.md)）。Reviewer 已独立读取上传 MP4，确认文件 SHA、媒体规格，抽查 13 帧，且将最终 AAC 与源 WAV 的 7 个位置音频匹配为固定 **+1.84268s、相关系数0.9970–0.9985**，显示无明显累积漂移，但**不替代真人完整试听**。Fig.8 底行证据被字幕底板遮挡；Fig.7 横幅很细小；Remotion 在未明确获批情况下自动下载约113.3MB Chrome Headless Shell，留下约282MB 缓存（**越界执行偏差**）。当前状态为 **`G1_CONDITIONAL / NOT_PASS`**，非 G1 通过；详见 [Reviewer 独立复核与 R2 修复方案](P4_G1_REVIEW_POST_RENDER_AND_R2_PLAN_2026-10-11.md)。G0 仍 CONDITIONAL，G2/G3 未启动。
- **下一步（Owner 已批准浏览器复用）**：2026-10-11 Owner 明确同意保留并复用**已下载**的 Chrome Headless Shell，作为 Remotion 视频渲染的专用浏览器；日常上网继续 Edge。G1-R2 授权范围为**仅复用现存缓存、不重复下载/安装/升级、不改默认浏览器**；已经发生的越界下载记录保留。遵守 [G1-R2 本地 Codex 任务书](../p4-g1/LOCAL_CODEX_G1_R2_TASK_2026-10-11.md)，在新的隔离 TEMP 与独立 Composer staging 中修复研究图字幕遮挡，使用显式 `--browser-executable`，真人完整试听和视觉 QA 后才能评判 G1。PR 修复尚未运行，**当前仍 `G1_CONDITIONAL / NOT_PASS`**；不要覆盖 G1-R1 证据，不启动 G2/G3。
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
| 视频执行技术 | Owner 历史交接称 OpenMontage 的约12秒短片技术闭环 PASS；**本机只读报告**另确认 OpenMontage、Node/Remotion、FFmpeg、atelier 的存在性，未运行测试；不代表 CWS 集成、音画同步、长片质量或自动中文对齐已验证 |
| 本仓生产接口 | `CWS_TO_OPENMONTAGE=NOT_INTEGRATED`；文案→镜头→正确图库素材尚未实证通过；不重复安装/开发已有本地基础工具；全部视频生产前必须请 Owner 决定与确认 |

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
5. [本轮新Reviewer交接](REVIEWER_HANDOFF_2026-10-10_P4G0.md)、[G0上游静态审计](P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md)、[G0本地Codex任务书](P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md)、[已收到的本机回读](P4_G0_LOCAL_CAPABILITY_READBACK_2026-10-10.md)和[Reviewer接口纠偏](P4_G0_CONTRACT_CORRECTIONS_AND_G1_ACCEPTANCE_2026-10-11.md)：交接/本地实际证据/最新工程设计分层使用。
6. [REVIEWER_HANDOFF](../REVIEWER_HANDOFF.md)、[STATUS_AND_DECISIONS](STATUS_AND_DECISIONS.md)、[PROJECT_HANDOFF_2026-10-10](PROJECT_HANDOFF_2026-10-10.md) 是**含时间顺序的历史交接补充**，不应反过来重置当前状态。

**治理约束**：项目方向、原始研究历史、既定评分/晋级规则、正式 36 条题库、视觉规范及技术环境均未由这份状态文档修改。