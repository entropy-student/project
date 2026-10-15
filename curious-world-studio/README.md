# Curious World Studio · 世界有点意思（名称暂定）

> **项目状态（2026-10-15）**：CWS是一套不露脸、跨领域真实知识视频的研究与制作项目；**媒体素材的Windows本机Docker技术闭环已通过G2–G4验收，但正式镜头动作匹配、版权与整片制作仍未通过**。唯一现行状态见[CURRENT_STATE](docs/CURRENT_STATE.md)，不要使用历史“待执行G2-G4”的说明作为当前指令。

频道编辑原则：**知识小众，问题大众；行为具体，过程有趣；证据真实，承诺兑现**。频道名/Logo未最终确定；B站主阵地，不强制把每期凑到固定分钟数。

## 权威入口（按顺序）

- **[当前整体项目进展与下一步](docs/CURRENT_STATE.md)** — 唯一事实源
- **[最新Reviewer交接](docs/REVIEWER_HANDOFF_CURRENT.md)** — 实验证据/责任与保护边界
- [MEDIA架构与阶段映射](docs/MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md)
- [AGENTS / Codex入口](AGENTS.md)
- [研究与选题库36条](research/topic-bank/BOARD_V1.md) · [工作流](research/topic-bank/WORKFLOW_V1.md)
- [视觉 STYLE_LOCK v1.2](visual/retro-mac-v1.2/docs/STYLE_LOCK.md)
- [3+1正式素材及动效来源合同](docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)
- [MEDIA G2–G4原执行合同（**已完成**；保留安全规则）](docs/MEDIA_G2_G3_G4_DOCKER_LOCAL_EXECUTION_GATE.md)
- [PROD四轮制片泳道（目标流程，非制作授权）](docs/P4_MAINLINE_COLLAB_SWIMLANE_4_ROUNDS_2026-10-11.md)

## 核心模块

| 模块 | 实际状况 |
|---|---|
| 频道研究与选题库 | 36条：SHORTLIST11、VERIFY15、HOLD9、REJECTED1；并非九源全量 |
| 叙事研究 | 三机制、多个纸面/试讲稿；尚未完成真实受众/正式口播 |
| 视觉 A→B | Tiger Aqua桌面→QuickTime满幅播放器；HTML原型与有限9s渲染技术证据，非成片引擎 |
| MEDIA搜索 | **Docker按需SearXNG+4get**，G3四组API非空，316原始记录→77视频/135图片去重 |
| MEDIA获取与QA | [media-pipeline](media-pipeline/README.md)代码已并入main（PR#129），按ID下载、过滤、FFmpeg完整解码、HTML页技术可用 |
| MEDIA本机整体G2–G4 | Ubuntu-24.04安全备份注销，Windows Docker后端仍在；真实下载/Edge播放/停止服务技术验收通过 |
| 运行产品化 | G3/G4的Compose与启停脚本**目前仍为本机独立执行工件，未通过PR纳入正式main** |
| MEDIA-R6/R7 | 动作精准匹配、时间码、分镜素材包尚未开始 |
| PROD制片 | `CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`，无成片/发布授权 |

## 当前工作边界

**已经能验证的是**：关键词→搜索候选→索引/过滤→人工选定ID→下载→FFprobe/FFmpeg质量检查→本地浏览器播放→本Compose服务停止。该闭环样本来自两个不同PeerTube实例（**同一平台家族**）和一张图片，**不代表爆米花目标动作吻合或可商用**。

**建议但未授权的下一件事**：将现有Windows本机成功运行的Docker Compose、按需启动/停止与自动浏览器技术QA整理成可维护工具，在隔离分支提交PR；其后再推进MEDIA-R6精准镜头与MEDIA-R7分镜素材包。正式制作轨道保持HOLD。涉及付费/版权/清理/上线必须Owner单独决定。

## 历史报告与许可证

旧[REVIEWER_HANDOFF](REVIEWER_HANDOFF.md)、[STATUS_AND_DECISIONS](docs/STATUS_AND_DECISIONS.md)、[2026-10-12正式节目交接](docs/REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)用于历史溯源，不能覆盖[CURRENT_STATE](docs/CURRENT_STATE.md)。OpenMontage、Remotion、Research Aqua、3+1合同、源论文/权利均仍独立；外部素材许可和NovusGFX设计系统MIT声明须保留。项目目录暂无单独确定的统一对外开源发布许可证，未经确认不公开发布第三方素材。
