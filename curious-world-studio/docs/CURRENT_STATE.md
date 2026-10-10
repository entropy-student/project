# Curious World Studio｜当前唯一状态快照

> **更新时间**：2026-10-10；**性质**：项目运行状态与接手导航，**不是业务规则或研究主协议**。
> 若其他文件有相互矛盾的“目前 / 下一步 / 尚未运行”等时态表述，请以本页最新事实状态为准；**选题业务规则仍以 `research/topic-bank/WORKFLOW_V1.md` 为准**，HF-FIND 和视觉参数仍各以其锁定协议为准。历史报告的研究结论、事实来源和时间戳不得被本页覆盖。
>
> **2026-10-10 新聊天 Reviewer 唯一完整接手摘要**：[REVIEWER_HANDOFF_2026-10-10_P4G0.md](REVIEWER_HANDOFF_2026-10-10_P4G0.md)。其第8节附有本轮最终只读复核、36条题库回读、16份核心文档217条内部链接核验和**可直接复制到新聊天的交接话术**。本页仍是唯一当前状态，接手摘要不是新业务协议；仅核路径，不等于模型/渲染/本地接口测试通过。

## 1. 当前阶段与真正的下一步

- **项目定位**：B站主阵地、不露脸、跨领域真实现象/研究；观众在休闲探索中获得一项可核对的“原来如此”。**2026-10-10 Owner 明确：无强制时长、不能拖沓、优先兑现观众承诺与观看感受**；原常用 4–6 分钟仅供策划排期参考。抖音/小红书辅助。
- **当前阶段 `P3-R6 NARRATIVE COMPLETE + P4-G0 UPSTREAM STATIC DONE / LOCAL READBACK PENDING`**：Owner 已批准开始联合G0（本机能力审计＋制作集成蓝图），但 ChatGPT 当前工具仅能访问 GitHub，不能直接读取 Owner Windows 环境。[G0上游源码核查与预设蓝图](P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md)已完成：确认 OpenMontage 主仓 AGPL-3.0、Remotion composer/asset schema、默认 Explainer 高亮字幕及 documentary-montage 不适合直接作为本频道旁白主线；建议 explainer 工作流＋CWS专用 QuickTime 组件/独立权利账本。**本机实际 git版本、node_modules、TTS、中文对齐仍UNKNOWN；G0不能标PASS。** P3-R6不凑时长和两篇故事原型继续有效，仍无实际配音/观众或视频生产。
- **下一步**：用 [本地 Codex G0 只读任务书](P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md) 在 Owner Windows 上完成**一轮本机证据与对应接口设计**；仅允许只读查询和文字报告，不下载、不安装、不渲染、不测试、不调用付费模型。收到本机报告后才正式判定 G0，并提出新G1 20–30秒短样片方案供 Owner 另行批准；G1/G2/G3不自动启动。规划总档见[视频生产架构](VIDEO_PRODUCTION_ARCHITECTURE_PLAN_2026-10-10.md)。
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
| 视频执行技术 | **Owner 提供的本地 OpenMontage 技术交接称 READY**：Pexels/Pixabay、Qwen 中文云 TTS、FFmpeg 与 12 秒 MP4 技术闭环成功；不代表本仓已集成或完成约 5 分钟叙事质量验证 |
| 本仓生产接口 | `CWS_TO_OPENMONTAGE=NOT_INTEGRATED`；文案→镜头→正确图库素材尚未实证通过；不重复安装/开发已有本地基础工具；全部视频生产前必须请 Owner 决定与确认 |

在线采集佐证：[P1 审计](../research/topic-bank/batches/2026-10-10_COLLECTOR_P1_COVERAGE_AND_TOPICS_REVIEW.md)、[Actions #38022638179](https://github.com/entropy-student/project/actions/runs/38022638179)；叙事校准：[P3-R1](../research/reports/2026-10-10_P3R1_NARRATIVE_MECHANISM_MARKET_RETROSPECT.md)；B/D 旧结构评审：[P3 报告](../research/topic-bank/batches/2026-10-10_P3_BD_STORYFIT_ENTRY_GATE_REVIEW.md)。

## 3. 本地 OpenMontage 来源和边界

**仅依据 Owner 的 2026-10-10 技术交接报告**，仓库没有对其 Windows 环境做第二次远端审计：
- 长期安装 `C:\Users\34707\Tools\OpenMontage`；Codex 全局 Skill `C:\Users\34707\.agents\skills\openmontage\SKILL.md`；调用 `$openmontage`。
- 技术链：Pexels/Pixabay → 云端中文 TTS（已配置默认音色）→ FFmpeg 合成，短视频技术闭环 PASS；**素材语义匹配、长片质量和商业化授权均 PENDING**。
- 不重装、不重复 API 连通/12 秒视频基线，不调用云模型生成测试 TTS；不触碰 Windows/VPS 网络或 VPN/WG/HY2/Clash。
- 未进入生产：**这不是授权启动任何视频、素材下载或付费推理的指令**。进入真正生产前，向 Owner 提供完整方案并征得明确批准。

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
5. [本轮新Reviewer交接](REVIEWER_HANDOFF_2026-10-10_P4G0.md)（权威导航/完整进度整理）、[G0上游静态审计](P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md)、[G0本地Codex只读任务书](P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md)：接手本轮 P4 必读。
6. [REVIEWER_HANDOFF](../REVIEWER_HANDOFF.md)、[STATUS_AND_DECISIONS](STATUS_AND_DECISIONS.md)、[PROJECT_HANDOFF_2026-10-10](PROJECT_HANDOFF_2026-10-10.md) 是**含时间顺序的历史交接补充**，不应反过来重置当前状态。

**治理约束**：项目方向、原始研究历史、既定评分/晋级规则、正式 36 条题库、视觉规范及技术环境均未由这份状态文档修改。