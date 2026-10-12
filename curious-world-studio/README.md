# Curious World Studio · 世界有点意思（暂定）

> **项目性质**：不露脸的真实发现 / 跨领域探索故事频道，当前为**研究协议 + 视觉规范的文档与原型模块**，不是可自动生成完整视频的成品系统。
>
> **项目目录名**：`curious-world-studio` 是项目代号；“世界有点意思”目前只是**频道名称候选**，未正式注册或最终确定。

## 一句话定位

像一个好奇心旺盛的朋友，发现了一件不可思议但真实存在的事情，忍不住打开资料给大家看，并弄明白它为什么会这样。

**核心原则：知识小众，问题大众；现场具体，过程有趣；证据真实，承诺兑现。**

频道向观众的承诺：**每期分享一个值得好奇的真实发现，让观众看见它、弄明白它，并清楚知道研究证实了什么、没有证实什么。**

> **当前执行顺序**：先读 [唯一活状态 / ZIP交接](docs/CURRENT_STATE.md)；项目旧Review、M1/M2测试、G0报告只作历史证据。**清理审计和纠错已Reviewer通过：安全删除0B，已结束；主线R1多轮、R2、R2-M1已审，爆米花核心视觉`CW0005_VISUAL_STORYFIT_HOLD`，Owner明确先不换题并暂停推进**。今后普通轮次只交ZIP和SHA，不再每天更新仓库文档。只有正式代码/模板/长期规范/重大决定才更新GitHub。 **Codex可在本地Git checkout读正式规范，不需每轮下载；后续获准执行任务可把简短工作笔记、权利台账和ZIP存到项目忽略的 `.local/`，不上传Git。**

**新 Reviewer 唯一详细交接**：[2026-10-12 交接｜暂停不换题](docs/REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)。该文档包含 R1→R2-M1 五轮ZIP哈希、素材/版权细节及当前STOP决定，取代旧阶段的待执行提示词。\n\n## 当前组成

| 模块 | 权威文件 | 状态 |
| --- | --- | --- |
| **当前项目状态与任务交接** | **[docs/CURRENT_STATE.md](docs/CURRENT_STATE.md)** | **唯一活状态：R2-M1已独立Review，CW0005视觉HOLD且Owner暂停、不换题；清理零删除、Mac支线停新增、G1未正式PASS**。以下其他行保留为对应历史版本的技术记录 |
| 频道定位与边界 | [`docs/CHANNEL.md`](docs/CHANNEL.md) | 核心定位已确认，频道名称待定 |
| HF 选题方法 | [`research/HF_有趣发现_唯一主协议.md`](research/HF_有趣发现_唯一主协议.md) | 唯一选题主协议 v1.0 |
| 视觉风格 | [`visual/retro-mac-v1.2/docs/STYLE_LOCK.md`](visual/retro-mac-v1.2/docs/STYLE_LOCK.md) | 当前 v1.2 视觉基线，允许后续小细节修订 |
| 机读视觉参数 | [`visual/retro-mac-v1.2/config/design-tokens.json`](visual/retro-mac-v1.2/config/design-tokens.json) | 对应 v1.2 |
| 可交互预览 | [`visual/retro-mac-v1.2/preview/index.html`](visual/retro-mac-v1.2/preview/index.html) | 视觉原型，非渲染引擎 |
| **最新视觉实现真源** | [V2 Research Aqua自包含HTML](p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html) | Owner已选定的 A→B 桌面行为视觉参考，**非生产级任意MP4素材适配** |
| **已执行的M1合同（历史）** | [G1VA V2本地媒体适配合同](p4-g1/LOCAL_CODEX_G1VA_V2_MEDIA_ADAPTER_TASK_2026-10-11.md) | 已使用本地自制 MP4 跑通单输入测试，不需重做 |
| **最新媒体接入代码** | [M1 Remotion 适配与渲染脚本](p4-g1/m1-media-adapter/README.md) | 实测运行源码经上传 ZIP Git blob 精确核对，通用性仍未证 |
| **最新独立Reviewer QA** | [M1真实MP4验收](docs/P4_G1VA_M1_REVIEWER_INDEPENDENT_QA_2026-10-11.md) | 技术单夹具通过，Owner实际成片观看待确认 |
| 已知问题 / 决策日志 | [`docs/STATUS_AND_DECISIONS.md`](docs/STATUS_AND_DECISIONS.md) | 维护中 |
| Agent / Codex 入口 | [`AGENTS.md`](AGENTS.md) | 指向各权威文档 |

## 统一工作方式

**选题**：Hugging Face 是科技发现专用入口；跨领域正式顺序为九大信息源→批量发现→统一筛选→正式选题库→STORY-FIT。技术线 HF-FIND 仍按唯一主协议，其他专业源见跨领域 source registry。

**正式素材来源**：见 [3＋1 视频素材合同](docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)，仅上述3路真实素材+Codex轻动效，禁止AI/代码画实体与重复使用镜头。

**视频视觉**：A — Mac OS X Tiger 时代 Aqua 桌面简短开场；B — 接近 QuickTime 7 的银灰播放器占满正文 16:9 画布，**B 内部**按旁白展示视频 / 图片 / 论文图表 / 证据；无第三个 C 状态。字幕单行，证据标注来源。

**边界**：未经 Owner 另行要求，不自动编写剧本、找商用素材或实现生产渲染；不把网页可观看的研究演示当作获准商用；不把作者的文字描述伪装成真实录像。

## 如何调用 Codex / Muse

把本项目目录设为 Agent 工作目录；输入：

```text
运行【HF-FIND】；模式=日常发现；范围=最近3个已完整发布的 HF Daily Papers 日榜。
按仓库唯一主协议执行；仅输出发现价值榜、制作优先榜、证据与素材状态、覆盖日志；不要写剧本或制作视频。
```

详见 [`AGENTS.md`](AGENTS.md) 与 [唯一主协议](research/HF_有趣发现_唯一主协议.md) 中的正式调用合同。

**只看样式**：直接在浏览器打开 `visual/retro-mac-v1.2/preview/index.html`。可在 B 模式中导入本地视频观察画框；这不代表版权、字幕声学对齐、渲染已通过。

**视频生成整体规划（2026-10-10）**： [P4-P0 OpenMontage + Remotion/FFmpeg 架构与视觉模板审查](docs/VIDEO_PRODUCTION_ARCHITECTURE_PLAN_2026-10-10.md)。

**G0 执行快照（2026-10-10）**：已完成[上游源码静态核查与接入蓝图](docs/P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md)，准备了[本地Codex一次性只读审计+设计任务](docs/P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md)。当前状态 **G0_PARTIAL_UPSTREAM_STATIC_DONE_LOCAL_EVIDENCE_PENDING**，未执行本地检查、模型、安装或视频测试；实时状态始终以[CURRENT_STATE](docs/CURRENT_STATE.md)为准。已说明现有 v1.2 HTML 64秒占位轮播与真实生成的差距、统一音轨驱动字幕/镜头、研究/图库/自制素材的证据与版权分流。**仅上游只读审查和架构规划，未安装/生成/测试/发布**；本地 G0 完成及新 G1 实测均须后续按权限决策。

## 历史阶段记录与后续（以顶部 M2 更新为准）

研究系统和视觉基线已经建立；**P3-R6 已完成叙事纸面复核与自然时长原则。P4-G0 联合审计已完成上游静态部分，但本地 Codex 实机只读回报仍待完成，故不标 G0_PASS。**P0/P1 在线采集回归通过，九源完整性仍 PARTIAL；正式题库 36 条，尚无正式 STORYFIT_GO。Owner 交接称本地 OpenMontage 已完成短片技术闭环，但本仓未接入，约 5 分钟叙事和素材语义匹配质量未验。商业素材授权、声学时间对齐、发布自动化仍待验证；生产前须 Owner 明确确认。详见 [CURRENT_STATE](docs/CURRENT_STATE.md)。

## 许可与权利

- `visual/retro-mac-v1.2/vendor/` 保存外部 **NovusGFX Retro Design System** MIT 许可声明和来源记录；请保留原版权声明。
- Mac OS X / QuickTime 是**时代视觉参考**，本项目目录不是 Apple 官方软件；不要混淆商标、截图及第三方媒体的许可。
- 项目生成的示例画面不是论文实验事实；任何论文视频/图片复用都需逐项核验权利。
- **本项目目录尚未选择统一的开源发布许可证**；所在项目库已有自己的可见性与治理规则，公开发布第三方素材需另行评估。

## 2026-10-10 Owner 确认的正式选题库顺序（已执行第一批）

**九大信息源 → 批量发现 → 统一筛选与评分 → 正式选题库 → STORY-FIT 深审 → 剧本/素材核验 → 视频制作/QA/发布。**

- 工作流唯一入口：[`research/topic-bank/WORKFLOW_V1.md`](research/topic-bank/WORKFLOW_V1.md)
- 选题库展示：[`research/topic-bank/BOARD_V1.md`](research/topic-bank/BOARD_V1.md)；机读母表：[`research/topic-bank/TOPICS_V1.json`](research/topic-bank/TOPICS_V1.json)（Schema v1.1：旧题保持、未知日期留 null；[字段变更说明](research/topic-bank/SCHEMA_V1_1_CHANGELOG.md)）。只读结构检查：`python curious-world-studio/research/topic-bank/validate_topic_bank.py`
- 第一批审计：[`research/topic-bank/batches/2026-10-10_SEED_IMPORT_AND_SPOTCHECK.md`](research/topic-bank/batches/2026-10-10_SEED_IMPORT_AND_SPOTCHECK.md)
- **当前母库 36 条（SHORTLIST 11 / VERIFY 15 / HOLD 9 / REJECTED 1）**。最初 **21 条（SHORTLIST 9 / VERIFY 7 / HOLD 4 / REJECTED 1）属于历史首批快照**，之后又定向新增 15 条；不是九源三日全量扫描，未有正式 STORYFIT_GO 或媒体商业复用许可通关。
- HF-FIND 唯一主协议及 QuickTime v1.2 视觉规范保持不变；本选题库框架在跨领域层面调度，不是第二份 HF-FIND 主协议。
