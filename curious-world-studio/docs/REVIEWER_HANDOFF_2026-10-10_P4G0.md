# Curious World Studio｜下一位 Reviewer 完整交接（2026-10-10 / P4-G0）

> **性质**：只读回顾现有工作、落实新聊天接手顺序；**不是第二份业务协议、也不是重启或批准视频生产**。本交接依据 `main` 截至 `747b77834b5d76a2375141ceaf1a1324c869eb0a` 的文件核对形成，后续合并的交接 commit 可更新但历史证据不改写。遇到变化，先以 [CURRENT_STATE](CURRENT_STATE.md) 和实际最新 GitHub `main` 为准。工作目录始终为 `project/curious-world-studio/`，不能修改其他一级项目。

## 0. 三句话给新 Reviewer

1. **我们在做的是什么**：B站为主、不露脸、跨领域的真实有趣发现/探索型知识叙事频道。像好奇的朋友逐步追问事情为何发生。核心承诺“**知识小众，问题大众；行为具体，过程有趣；证据真实，承诺兑现**”。不把它做成读论文摘要、PPT罗列或固定教程；不强求五分钟，观众承诺优先、不得拖沓。
2. **现在到哪一步**：选题采集体系及36条题库已经建立，叙事纸面 P3-R6 完成，视觉 `retro-mac-v1.2` 已锁；**P4 联合 G0 的公开上游源码审查与静态集成蓝图已完成，但 Owner Windows 本地证据仍没有收到：`G0_PARTIAL_UPSTREAM_STATIC_DONE_LOCAL_EVIDENCE_PENDING`，绝非 G0_PASS。** 真实音频试读、观众盲听、CWS与OpenMontage整合、视频样片或正式作品均尚未运行。
3. **下一步实际做什么**：将 [P4-G0 本地 Codex 只读审计+一次性接入设计任务书](P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md)交给 Owner 本机 Codex，**仅审查本地安装、源码与接口并产出文字报告**；再由 Reviewer 对照 [上游静态蓝图](P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md) 做 G0 评判。**不要直接生成/测试20–30秒样片**；那是下一关新 G1，需另行批准。

## 1. 现在的权威资料顺序（先读，切勿重复开启历史任务）

| 优先级 | 文件 | 要点 / 决策权 |
|---|---|---|
| ① 当前状态 | [CURRENT_STATE.md](CURRENT_STATE.md) | 当轮唯一有效状态与下一步；其他文档的旧“最新”只是历史 |
| ② 此接手快照 | [REVIEWER_HANDOFF_2026-10-10_P4G0.md](REVIEWER_HANDOFF_2026-10-10_P4G0.md) | 新聊天交接、已完成/未完成边界及路线图 |
| ③ 频道承诺 | [CHANNEL.md](CHANNEL.md) | 长期定位、内容气质、自然时长；频道名仍候选 |
| ④ 选题业务合同 | [WORKFLOW_V1.md](../research/topic-bank/WORKFLOW_V1.md) | 七阶段、四轴评分、晋级条件唯一正式合同 |
| ⑤ 来源协议 | [SOURCE_SYSTEM_FINAL_V1.md](../research/SOURCE_SYSTEM_FINAL_V1.md) 和 [HF-FIND 唯一主协议](../research/HF_有趣发现_唯一主协议.md) | 九源3+4+2及HF专用调研边界 |
| ⑥ 视觉合同 | [STYLE_LOCK v1.2](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)、[tokens](../visual/retro-mac-v1.2/config/design-tokens.json)、[HTML 预览](../visual/retro-mac-v1.2/preview/index.html) | A Tiger Aqua 桌面 / B QuickTime7边到边播放器，**无C** |
| ⑦ P4 规划 | [视频生成总规划](VIDEO_PRODUCTION_ARCHITECTURE_PLAN_2026-10-10.md) | OpenMontage/Remotion/FFmpeg、时间线、研究/图库/自制素材、字幕及许可 |
| ⑧ P4 静态研究 | [G0 上游静态审计](P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md) | 上游真实能力、方案冲突、尚未知的本机问题 |
| ⑨ P4 当下行动 | [G0 本地 Codex 只读任务书](P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md) | 下一位本地执行 Agent 的唯一现成执行交接，**未实际完成** |
| 历史 / 累积 | [REVIEWER_HANDOFF](../REVIEWER_HANDOFF.md)、[STATUS_AND_DECISIONS](STATUS_AND_DECISIONS.md)、[PROJECT_HANDOFF_2026-10-10](PROJECT_HANDOFF_2026-10-10.md) | 历史事实和决定不可删，但旧的“下一步”不优先 |

## 2. 各模块完成度与事实边界

| 模块 | 现在有的真实证据 | 不能误报 |
|---|---|---|
| 频道方向 | B站优先，小红书/抖音辅助，不露脸；跨科技、生活、心理、动物等领域，非限定AI | 中文名“世界有点意思”、Logo、音色、音乐和固定开场**未锁** |
| 九源与采集 | 九源职责分层已确认；P0/P1 Github Actions 及 24/24 回归已有记录；2026-10-07~09观察到 **537 条元数据** | 九源完整历史归档仍 **PARTIAL**，537不是537个高质量选题 |
| 正式题库 | [TOPICS_V1.json](../research/topic-bank/TOPICS_V1.json) 与 [BOARD_V1.md](../research/topic-bank/BOARD_V1.md) 同步，**36条：SHORTLIST 11、VERIFY 15、HOLD 9、REJECTED 1**；schema v1.1、验证器已存在 | 全部 `storyfit_status=NOT_STARTED`；SHORTLIST不是STORYFIT_GO，稿件研究也不自动晋级；**B声音和D决策未加入机器题库**，J果冻是已有候选CW-0001 |
| 叙事原型 | P3-R2 六个短原型+六套长纲；P3-R3 连续性改写；P3-R4 两篇连续 V1；P3-R5 字数/时长敏感性；P3-R6 纸面审查与不凑时长决定 | “区分的发现+锚点回环”是**试用编辑技巧**，不是唯一频道机制或正式评分新轴；没有真实听众或平台数据 |
| 旁白稿 | [D-B 决策 974 汉字](../research/story-fit/prototypes/2026-10-10_P3R4_D_B_FULL_READTHROUGH_V1.md)、[J-B 果冻 941 汉字](../research/story-fit/prototypes/2026-10-10_P3R4_J_B_FULL_READTHROUGH_V1.md)；论文来源/真实性限制已写入 | **非正式获批成片脚本**；3.5字/秒粗估并非真实音轨长度，4–6分钟仅策划参考 |
| B声音候选 | 原声附件 14/14 WAV **文件格式/元数据**曾完成QA | 没有真实人耳可辨性、发布/播放兼容性或商用许可 PASS；不要因书面评审永久淘汰 |
| 视觉 | [Retro Mac v1.2](../visual/retro-mac-v1.2/README.md) 风格与tokens定稿，1920×1080/30fps，严格单行中文，无逐字高亮；A约1.5–3s，B全幅，保留MIT来源声明 | HTML是**固定64秒四段轮播/占位字幕演示**，本地视频静音循环；**不是Remotion渲染系统**，不直接具备SRT声学校时 |
| 本地OpenMontage | Owner较早交接称在 Windows 上有约12秒短片技术闭环：Pexels/Pixabay、Qwen云TTS、FFmpeg | 当前会话**未直接读取Windows安装**；不等于Remotion/中文对齐/长片/研究媒资许可已通过 |
| P4-G0 | [OpenMontage 上游代码审查](P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md) 和 [本地任务书](P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md)已落地，PR #90 | **仅 upstream static done，本地审计未执行或没有结果回传**；G0不得通过，G1视频测试未获执行批准 |
| 素材使用 | 已明确 [论文原图的开放许可与外链视频区别](VIDEO_PRODUCTION_ARCHITECTURE_PLAN_2026-10-10.md)、三重资产状态 `LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED` | PLOS论文本身常有CC BY；外链视频、第三方片段、肖像/商标、Remotion/OpenMontage软件许可不能自动沿用论文许可 |

## 3. P3 叙事决定：下一位不得推倒重来

- **节目观众承诺**：每期找到一个日常人想追问的具体问题，让观众逐步看见真实现象、理解已知和未知；观察者/作者声音真实自然，不假造本人经历，也不硬设“所有观众都以为X”。
- **“区分的发现 + 锚点回环”** 是本轮最有希望的叙事方法：具体处境/选择→观众形成自己判断→证据在需要时进入→重回原锚点形成新理解→兑现问题；不意味着每期强制三次回环、不允许其他机制。
- **D-B 决策**：三按钮→加知识题→时间和风险选择比例的区别→题更难时的表现→信息查询/脑刺激条件。原研究为60人50轮；风险比例是**所有选择的比例，不是人格标签**。脑刺激转场需真人试听。
- **J-B 果冻**：勺子+两个能互动的果冻→agency/experience区分→“不想吃”与“内疚”区分。**2026研究仅视频评价，1,094名参与者并未实际食用**；成人式果冻的预计抗拒稍高、内疚差异未达显著不等于完全相同；情境勺子不能冒充实验录像。研究画面及外链演示权利待逐条核对。
- **外部评审**：建议吸收记录 [P3-R4 已采纳](../research/reports/2026-10-10_P3R4_ADOPTED_REVIEW_FINDINGS_AND_TEST_PLAN.md)，反对/待议项独立保留 [P3-R4 未采纳](../research/reports/2026-10-10_P3R4_NOT_ADOPTED_AND_PENDING_LOG.md)。不要强行锁D首发、淘汰B或采用虚构的B站留存阈值。
- **P3-R6 自然时长**：只看观众承诺兑现、真实推进、不拖沓也不赶；不足4分钟不是HOLD原因；不强制4–6分钟或口播4.5字/秒。详见 [P3-R6](../research/reports/2026-10-10_P3R6_CONTENT_FIRST_DURATION_AND_NARRATIVE_GATE.md)。真实声音与实际观众试听仍待执行；不能以继续“理论研究”替代实际观看证据。

## 4. P4 真正的制作规划（用户已讨论并同意合并Gate，尚未产出成片）

**已认同的方向，但非工程PASS**：
```text
审定故事与逐行文字（line_id/beat_id）+论文证据
      ↓
OpenMontage尽量复用其音频/图库检索/素材编排工具
      ↓
最终主音轨 master_audio（所有时间的唯一主钟）
      ↓
中文强制对齐 → SingleLineCaption/SRT（由同一时间轴导出）
      ↓
素材清单 & 权利账本（论文图/原实验/Stock/自制/生成，五类来源标注）
      ↓
CWS episode_timeline.json（line_id/beat_id/shot_id/asset_id；时间基/帧连续性）
      ↓
Remotion CWS 专用 A/B Chrome + 研究证据画面（非OpenMontage默认字幕风格）
      ↓
FFmpeg 视频封装 & 技术QA → 人审核片 → 决定是否公开发布
```

**上游静态审查发现的4个实际设计问题**：
1. `calesthio/OpenMontage` 上游主仓是 **AGPL-3.0**；同名 `Open-Montage-app/OpenMontage` 为另一仓，不得混认MIT或在未核本地来源前假定许可已解决。视频模板复用的 NovusGFX CSS 自身保留 MIT 来源；Remotion另需按实际使用核许可。
2. 上游 `animated-explainer` 工作流较适合旁白+证据主线；默认 `documentary-montage` 更偏音乐驱动镜头合集，**不能当默认频道生产总流程**；但可借多源素材发现子模块。
3. 默认 `Explainer` 逐词高亮字幕、固定卡片式视觉与锁定A/B不符，需自建CWS Remotion组件与单行字幕。
4. 上游 `asset_manifest` / `edit_decisions` schema 禁止任意增加未知字段（`additionalProperties:false`）；建议独立的 `episode_timeline.json`、`rights_ledger.json`，由适配器转换标准上游工件；`atelier` bespoke接口是候选但**本机是否可用未查**。

**Gates 最新编号**（旧 G0+G1 合并后）：`新G0 本机只读审计+一次性集成设计 → 新G1 20–30秒样片验证 → 新G2 第一条完整视频 → 新G3 固化可重复生产`。新G1须Owner再次批准。

## 5. 下一轮可执行的唯一动作：完成联合 G0

- **执行地点**：用户 Windows 本地 Codex，不是 ChatGPT 网页端远程控制用户电脑。ChatGPT/新 Reviewer 可读 GitHub，但不能臆测本机 npm、Node、FFmpeg、Remotion、Qwen配置和实际插件能力。
- **任务书**：直接使用 [P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md](P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md)，**不要重写一套不兼容的新任务书**。
- **输出**：`P4_G0_LOCAL_CAPABILITY_READBACK_2026-10-10.md` 文字报告，包含版本/路径/能力状态 `PRESENT/MISSING/UNKNOWN`、所见上游偏差、CWS音轨/时间轴/schema/Remotion端的可实施蓝图、缺口和新G1短样片提案。若本地可以安全提交，文字分支 PR；否则将报告回传聊天，由 Reviewer 协助落库。
- **禁止**：任何安装、测试、下载/模型、云TTS、视频渲染、改动用户 Windows/VPS/网络/VPN，或读取/输出密钥、cookies、整个环境变量。历史12秒成功记录不用再跑。
- **验收**：Reviewer对照上游静态报告与真实本机信息作 `G0_DESIGN_READY_NO_RENDER` / `G0_CONDITIONAL` / `G0_BLOCKED_MISSING_LOCAL_EVIDENCE` 明确判断并写回 `CURRENT_STATE`；**绝不可写PRODUCTION_READY或G1_PASS**。本机证据不足就列出UNKNOWN，不强行通过。

## 6. 文件落库和防回退约束

- [README](../README.md)、[AGENTS](../AGENTS.md)、[REVIEWER_HANDOFF](../REVIEWER_HANDOFF.md) 是**接手导航**，不能成为独立业务规则；[STATUS_AND_DECISIONS](STATUS_AND_DECISIONS.md) 中较早的“当前待办”有时态问题，除非标注历史，不可覆盖 `CURRENT_STATE`。
- 不改变 [WORKFLOW](../research/topic-bank/WORKFLOW_V1.md) 原四轴/三节点、任何题目分数、题库36条、HF主协议、视觉 `STYLE_LOCK`、两篇历史旁白V1及独立保存的未采纳建议。
- 原论文/原始视频的**内容真实性、可取得、合法重用**三种状态独立；生成的解说示意不能披着“原始实验”的标签。
- 当前没有“固定五分钟”业务要求；不因时长做无意义内容补写。
- **所有敏感路径/环境/源码信息的输出仅限非密钥内容**；Reviewer新聊天首先从 GitHub `main` readback，不要从上一轮 assistant 的推测恢复环境。

## 7. 接手 Reviewer 的最小回报合同

首次回报按此顺序：**①当前 G0 状态→②只读核过的文件与关键证据→③仍UNKNOWN的本机项目→④需要 Owner 本地Codex做什么→⑤是否触发新的批准门槛**。若 Owner 提供了本地 G0 报告，先读报告并比较，不再要求重新完整审计。没有报告就说明“**上游审计完成，本地审计尚待**”。

**这份文件是一次换聊天交接，不代表任务全部完成；清晰分辨“做过什么/打算做什么/什么必须获得下一次授权”比任何进度百分比更重要。**


## 8. 换聊天前的最终 Reviewer 复核（2026-10-10；只读事实核验）

**来源**：2026-10-10 在 GitHub `main`（本轮检查起点 `f87477a27fcd96b3c95f1d203516e8990cf8f2f5`）重读正式状态、P4-G0上游静态研究、本地Codex任务、P3叙事决策、正式题库、A/B锁定视觉、README和历史交接。逐项核对16份核心文档的**217个仓库内部相对链接，全部可定位**；这只验证仓库路径，**不等于公网链接可打开、许可实查、视频渲染或者音频测试通过**。

### A. 已确认的基线（继续有效，不能因新聊天重置）

- **业务规则与题库**：`TOPICS_V1.json` 机读回读确认为36条（SHORTLIST 11 / VERIFY 15 / HOLD 9 / REJECTED 1），全部 STORY-FIT = `NOT_STARTED`；J果冻是 CW-0001 SHORTLIST，D认知负荷与B点击声音**不在正式机读题库**。正式四轴 HOOK/SURPRISE/PROGRESSION/VISUAL、来源规范/Schema v1.1、三节点推进及状态规则未修改。
- **节目内容**：P3-R2～R6所有有效叙事原型、独立评审采纳/未采纳日志均已在main；当前用于试读的是 D-B、J-B两篇完整 V1，不是正式获批发布文案。Owner认可“区分的发现＋锚点回环”作为**试用方法**，同时要求没有固定分钟门槛、不能拖沓、兑现观众承诺。
- **画面**：`retro-mac-v1.2` 锁定 A简短Mac Tiger桌面＋B边到边QuickTime风格播放器、1920×1080/30fps、严格中文单行字幕、五类真实性标签、无C状态；HTML预览固定64秒四段占位轮播，**不是导出真实视频的引擎**。
- **技术架构**：OpenMontage→自有CWS Remotion A/B组件→FFmpeg、主音频驱动的中文对齐/字幕/镜头、论文/图库/自制素材权利账本；这些仍是方案，未集成/渲染。上游静态 G0 已核对 `calesthio/OpenMontage` 的 AGPL-3.0、默认 Explainer 高亮字幕与 documentary-montage 音乐驱动限制、严格资产 schema及候选 bespoke atelier 入口。**Owner Windows的本地代码/依赖/音频对齐能力仍未被这个会话读取，G0 不通过。**
- **此轮接手边界**：没有在电脑运行命令、安装软件、下载素材、调用TTS/视频模型、生成 MP4、对外联络作者、授权购买或公开视频；不能从文档存在推出功能PASS。

### B. 最新实施状态和下一步

`P3_R6_DONE / P4_G0_UPSTREAM_STATIC_DONE / P4_G0_LOCAL_EVIDENCE_PENDING / G1_NOT_AUTHORIZED / NO_AUDIO_OR_VIDEO_PRODUCED`。

真正下一步只有一个：如果 Owner 尚未把本地 G0 报告带回，交给他 **[现成的G0本地Codex只读任务书](P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md)**（不要再让新Reviewer重新设计另一份）。本地Codex完成后回传 `P4_G0_LOCAL_CAPABILITY_READBACK_2026-10-10.md`，由Reviewer对照 [G0上游静态蓝图](P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md) 形成一个有实际本机路径、版本、模块状态和接口证据的结论。只有 G0 通过后才提出**新G1 20–30秒样片**供Owner**另行批准**；新G2首条成片，新G3规模化复用。

### C. 可以直接复制到新聊天的 Reviewer 开场请求

```text
请接手我在私有 GitHub 仓库 entropy-student/project 的 curious-world-studio 项目，担任新的 Reviewer。上一段 ChatGPT 聊天已结束，所有有效交接已汇总在 main，请以实际 GitHub 最新 main 为唯一事实起点，不要凭旧聊天猜测进度。

第一步请依次阅读：
1. curious-world-studio/docs/CURRENT_STATE.md（当前唯一状态）
2. curious-world-studio/docs/REVIEWER_HANDOFF_2026-10-10_P4G0.md（完整接手）
3. curious-world-studio/docs/P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md（已完成的上游源码静态审查）
4. curious-world-studio/docs/P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md（下一步本地 Codex 只读任务）
5. curious-world-studio/docs/VIDEO_PRODUCTION_ARCHITECTURE_PLAN_2026-10-10.md（视频生产规划）
并按交接文件中的链接检查正式选题 WORKFLOW、36条题库、P3-R6及以前的有效叙事决策、D-B/J-B旁白和 Retro Mac v1.2 视觉规范。

当前已经完成 P3-R6 内容叙事纸面阶段和 P4 联合 G0 的公开上游静态核查；Owner Windows 上的 OpenMontage/Remotion/FFmpeg/中文强制对齐等本机只读证据还未回传，不能把 G0 标 PASS。此前已确定不凑视频时长、研究事实与素材权利分开核查、A短桌面+B QuickTime满幅播放器、中文单行字幕，务必保留。不要重做已经完成的上游调研、重建题库或擅自晋级话题。

请先输出：①截至 main 最新提交的项目状态；②已完成/未完成及来源依据；③本机 G0 缺哪些证据；④如何直接使用仓库已有的本地 Codex 任务书完成剩余 G0；⑤下一个必须由我另外批准的关口是什么。

当前仅授权审阅与交接建议：不要安装、升级、下载素材、调用付费模型、修改 Windows/VPS/网络、配音、渲染、生成短样片或发布。若后续我提交本地 G0 报告，请优先验收它而不要重复扫描。除非发现真实文档错误，否则先不要动正式评分、题库、视觉锁定、原剧本或业务协议。
```

**阅读注意**：上面是一条给新 Reviewer 的用户交接话术，不是任何 Agent 的自动执行指令；是否真的派发本地Codex任务，由Owner控制。
