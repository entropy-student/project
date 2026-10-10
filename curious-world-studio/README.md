<!-- CWS-20261010-HANDOFF-NAV -->
> **换聊天 / Agent 接手入口**：先读 [docs/CURRENT_STATE.md](docs/CURRENT_STATE.md)（唯一当前状态）和 [下一位 Reviewer 完整接手文档（P4-G0）](docs/REVIEWER_HANDOFF_2026-10-10_P4G0.md)（本次最新交接），再按需读 [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md)、[PROJECT_HANDOFF_2026-10-10.md](docs/PROJECT_HANDOFF_2026-10-10.md)（历史）。P0/P1采集器在线运行已验收；九源完整归档仍 PARTIAL。

# Curious World Studio · 世界有点意思（暂定）

> **项目性质**：不露脸的真实发现 / 跨领域探索故事频道，当前为**研究协议 + 视觉规范的文档与原型模块**，不是可自动生成完整视频的成品系统。
>
> **项目目录名**：`curious-world-studio` 是项目代号；“世界有点意思”目前只是**频道名称候选**，未正式注册或最终确定。

## 一句话定位

像一个好奇心旺盛的朋友，发现了一件不可思议但真实存在的事情，忍不住打开资料给大家看，并弄明白它为什么会这样。

**核心原则：知识小众，问题大众；现场具体，过程有趣；证据真实，承诺兑现。**

频道向观众的承诺：**每期分享一个值得好奇的真实发现，让观众看见它、弄明白它，并清楚知道研究证实了什么、没有证实什么。**

## 当前组成

| 模块 | 权威文件 | 状态 |
| --- | --- | --- |
| 当前项目状态 | [docs/CURRENT_STATE.md](docs/CURRENT_STATE.md) | **P3-R6已完成；P4-G0上游静态审查已完成，本机只读审计待提交；无配音、测试或成片** |
| 频道定位与边界 | [`docs/CHANNEL.md`](docs/CHANNEL.md) | 核心定位已确认，频道名称待定 |
| HF 选题方法 | [`research/HF_有趣发现_唯一主协议.md`](research/HF_有趣发现_唯一主协议.md) | 唯一选题主协议 v1.0 |
| 视觉风格 | [`visual/retro-mac-v1.2/docs/STYLE_LOCK.md`](visual/retro-mac-v1.2/docs/STYLE_LOCK.md) | 当前 v1.2 视觉基线，允许后续小细节修订 |
| 机读视觉参数 | [`visual/retro-mac-v1.2/config/design-tokens.json`](visual/retro-mac-v1.2/config/design-tokens.json) | 对应 v1.2 |
| 可交互预览 | [`visual/retro-mac-v1.2/preview/index.html`](visual/retro-mac-v1.2/preview/index.html) | 视觉原型，非渲染引擎 |
| 已知问题 / 决策日志 | [`docs/STATUS_AND_DECISIONS.md`](docs/STATUS_AND_DECISIONS.md) | 维护中 |
| Agent / Codex 入口 | [`AGENTS.md`](AGENTS.md) | 指向各权威文档 |

## 统一工作方式

**选题**：Hugging Face 是科技发现专用入口；跨领域正式顺序为九大信息源→批量发现→统一筛选→正式选题库→STORY-FIT。技术线 HF-FIND 仍按唯一主协议，其他专业源见跨领域 source registry。

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

## 当前阶段与后续

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
