# Curious World Studio · 世界有点意思（名称暂定）

> **项目状态（2026-10-16）**：选题、叙事、Mac Aqua→QuickTime视觉规范与本机素材获取能力已经建立，PR#129/#131已合并main，PROD-R2编辑审核PASS，PROD-R3已产出55.367秒返修内部样片且技术可用，但Owner实看后否决其重复库存画面和PPT式机制文字卡；R3整体RETURN_OWNER_VISUAL_STORYFIT，R4完整草片尚未授权。Owner最新要求**画面相关即可，不需逐帧精准或每句配研究实录**；科学表述和素材许可仍须单独核验。R6L/R7L历史`PARTIAL_ASSET_GAP`不触发新搜片。最新事实看[CURRENT_STATE](docs/CURRENT_STATE.md)，接手看[完整Reviewer交接](docs/REVIEWER_HANDOFF_CURRENT.md)。

频道编辑原则：**知识小众，问题大众；行为具体，过程有趣；证据真实，承诺兑现**。频道名/Logo未最终确定；B站主阵地，不强制把每期凑到固定分钟数。

## 权威入口（按顺序）

- **[当前整体项目进展与下一步](docs/CURRENT_STATE.md)** — 唯一事实源
- **[最新Reviewer交接](docs/REVIEWER_HANDOFF_CURRENT.md)** — 实验证据/责任与保护边界
- **[R2已验收稿](docs/CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md)**、**[唯一R3 Gate](docs/PROD_R3_CW0005_INTERNAL_AV_SAMPLE_GATE_2026-10-16.md)**、[关键执行证据](docs/EXECUTION_EVIDENCE.md)、[决策记录](docs/DECISION_LOG.md)
- **[长期中文科普口播双轮润色工作流](docs/VIDEO_SCRIPT_POLISH_WORKFLOW.md)** — `human-writing`首轮整体表达、`humanizer v3.1.0`次轮去模板化，事实审核后再配音；适用于R4完整片和以后每期，不改变已下发R3小修。
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
| 运行工具化 | [PR #131](https://github.com/entropy-student/project/pull/131)已合并：统一Codex JSON CLI `discover/fetch/catalog/gallery/doctor`、Compose搜索服务按需启动/关闭、Ctrl+C清理 |
| MEDIA-R6L/R7L | **已完成试跑**：两条现有爆米花影片可提供相关辅助画面；精确研究原片缺口保留为历史，不再自动要求增加搜片轮次 |
| PROD制片 | R2编辑PASS、R3媒体技术PASS，但Owner视觉质量审核RETURN_OWNER_VISUAL_STORYFIT（两条相似素材占83%，纯文字卡近6秒）；不需听感确认，R4未授权；正式HOLD/G1/G2/NO_PUBLISH维持 |

## 当前工作边界

**已经能验证的是**：关键词→搜索候选→索引/过滤→人工选定ID→下载→FFprobe/FFmpeg质量检查→本地浏览器播放→本Compose服务停止。该闭环样本来自两个不同PeerTube实例（**同一平台家族**）和一张图片，**不代表爆米花目标动作吻合或可商用**。

**当前停止点**：Owner已经否决现有视频的视觉叙事，不要再次要求试听或让Codex改字幕；先重新规划有真实视觉差异、能够推进解释的镜头，再由Owner决定是否重新授权制作。R4须另行授权并遵循[双轮润色工作流](docs/VIDEO_SCRIPT_POLISH_WORKFLOW.md)。素材权利仍PARTIAL，不发布。

## 历史报告与许可证

旧[REVIEWER_HANDOFF](REVIEWER_HANDOFF.md)、[STATUS_AND_DECISIONS](docs/STATUS_AND_DECISIONS.md)、[2026-10-12正式节目交接](docs/REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)用于历史溯源，不能覆盖[CURRENT_STATE](docs/CURRENT_STATE.md)。OpenMontage、Remotion、Research Aqua、3+1合同、源论文/权利均仍独立；外部素材许可和NovusGFX设计系统MIT声明须保留。项目目录暂无单独确定的统一对外开源发布许可证，未经确认不公开发布第三方素材。
