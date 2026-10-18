# Curious World Studio（CWS）｜仅已确认事实的完整接手（2026-10-18）

> **文件用途：** 本文件只总结到2026-10-18已经由Owner决定、GitHub读回或独立Reviewer验收支持的事实，并给出证据入口。**不是新的Gate、方案批准、生产授权或讨论稿**。下面“未完成/未授权”只记录客观缺口，不擅自确定实现方案。历史旧文档保留，但其旧状态被本文件和 `CURRENT_STATE.md` 顶部的最新Owner决定覆盖。

## 1. 权威仓库、源代码与项目定位

- 仓库：`https://github.com/entropy-student/project`，项目目录：`curious-world-studio/`。
- **项目目标已确认**：不露脸、跨领域知识型视频，重点解释大众会问的“为什么”；以B站为主要平台、抖音/小红书为辅助。目标是用可重复流程产出围绕真实证据与故事组织的Mac复古桌面风格视频（目标时长约4–6分钟）。不是PPT拼接，更不以技术演示代表可发布内容。
- **视觉基准**：原版Research Aqua Mac开窗→唯一QuickTime播放器→内容模板T1–T6；**一个Mac外壳、一个Master Clock、一个结束回桌面流程**。旧参考Retro Mac仅辅助，不替换原Research Aqua源码；不新造第二个Mac或第七模板。
- **当前Owner冻结技术源码**：`visual/frozen/storyboard-v5-6-2-20261018.html`，Git blob `33aabc3ff2e48877493277eb1a86274818e3c769`，SHA-256 `47dbe555b297153bab7520b7b1b716fa8403ed32c237b3b2603e283829c2fb84`，75,461 UTF-8字节；2026-10-18由Owner正式接受技术PASS、按原字节归档main。冻结提交 `9179fdf003aa96f8f641743de70e5668192e1c9e`。
- **历史V5.2冻结件保留不变**：`visual/frozen/storyboard-v5-2-20261017.html`，Git blob `f002fd3a3fea24352c8eddb63d8f265014a9e93b`。**PR #144**：`https://github.com/entropy-student/project/pull/144`，目前Open/Draft/未合并；Head `33d5357c0c09931ba5e7d9070ca92cf1b2adb35f`。不能直接整PR合并覆盖历史冻结文件。

## 2. V5.6.2技术冻结PASS：证据、能力、明确边界

- [Owner正式冻结决议](reviews/CWS_V562_OWNER_FREEZE_TECHNICAL_PASS_2026-10-18.md)；[独立Reviewer原文报告](reviews/CWS_V562_INDEPENDENT_REVIEW_PASS_2026-10-18.md)（main原字节Git blob `cc5aaa5a35bc452e7ca86dfbb8c8e6124020a88b`）。
- 独立Reviewer实测：**41/41** 边界/反例/基础回归；**9/9** 真实浏览器媒体/旁白/长时轴回归；**3/3** 原生Mac Canvas像素对照；最终HTML **31.06秒不快进1×实速播放PASS**；无新P0/P1/P2。Reviewer也在父版V5.6.1重现了N-01全角百分号导致“百分点”误标、N-02极小数字显式比例尺错误，再确认V5.6.2修复。主Reviewer复核后Owner正式批准技术冻结。
- V5.3/V5.3.1：8项基础缺陷处理；V5.4：镜头/素材ID JSON导入与批量关联；V5.5：多Cue/单旁白Master Clock控制；V5.6：T6数据形式；V5.6.1：五项R-01～R-05有界返修；V5.6.2：N-01/N-02边界补修。**这些是版本演进事实，不要用旧版PARTIAL覆盖新版PASS**。
- **技术冻结覆盖的11项原问题**：①长片时间边界、②T5阶段素材入点、③短素材停末帧、④T5/T6配置、⑥T2/T3证据contain、⑦字幕超长告警、⑧T5非平均阶段时长、⑨T6比较/刻度/百分点、⑩多Cue和旁白时间线接口、⑫文件名/来源标签、⑬JSON导入导出与素材ID关联。
- **没有技术/正式内容关闭的3项**：⑤T4真实档案/论文等资料的实际呈现与真伪审查；⑪QuickTime展示时码含义（低优先级、保留唯一Master Clock，暂无新方案决议）；⑭真实故事的画面连贯性与知识解释的视觉表现。⑤/⑭不可从占位素材HTML技术PASS推断通过。
- **明确不在本轮PASS范围**：真实4–6分钟配音+精确对齐+SRT+MP4端到端自动输出；Owner Windows Edge `file://`直接打开验收；所有真实科研画面和复用权许可；视频叙事和发布。Chromium `page.set_content` 与合成MP4/WAV测试应如实表述。
- 用户上传的独立Reviewer原始ZIP及二进制截图/合成媒体**未整体写入GitHub**；main已有审核报告、源码指纹及测试目录。不能假称原ZIP全部在仓库。

## 3. 内容、媒体与正式成片的已证事实

- **内容**：已有36个选题初筛、三个叙事机制；CW0005爆米花R2研究、旁白与S01–S10分镜通过编辑/事实检查（[R2定稿](CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md)），不是视频制作PASS。
- **工具**：Remotion/FFmpeg适配器PR #116已合并；素材CLI及媒体工具PR #129、#131均已合并main。已有`media-pipeline/cws_media.py`的doctor/discover/catalog/fetch/gallery，SearXNG/4get/Docker按需启停、Pexels/Pixabay、合法yt-dlp等技术路线，历史落地22视频、31图片。部分外部搜源仍有限制；搜索命中不等于实际可用或已获权利。
- **正式影像试验**：已生成CW0005 **55.367秒内部MP4**、曾独立核验技术解码，但Owner实际观看后明确**R3整片视觉RETURN**；两条相关库存视频各约20.223秒与25.727秒，占约83%，另S05近5.849秒纯文字机制卡，未形成合格视觉叙事。此历史R3不是“待执行”，旧R3 Gate上的`OWNER_AUTHORIZED_NOT_EXECUTED`仅代表当时状态，不得据此重新执行。
- **素材判断已决定**：相关真实实拍配准确旁白和恰当出处可用于内部内容方案；不需要逐帧找到论文对应高速原片，不因“淀粉脚精确录像缺失”无限扩大检索。但不得把一般库存素材冒充实验原片，也不得放宽事实/版权约束。
- **素材复用约束**：同一原始视频在同一期只能一个连续使用段，跨期不能当作新素材再次复用；改名、剪裁、镜像等不改变作品同一性。素材类型Owner定为A视频（含录屏）、B已有图片、C AI静态图片概念类别；**具体新AI生图执行和发布并未授权**，请先读[Owner匹配决策记录](VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md)及[3+1素材合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)。历史13×6是讨论矩阵，已由更晚的13×3分类覆盖，不能作为已冻结落地组件。
- **文案工作流已决定**：搜索/素材匹配期间以锁定的文案为基准，视觉素材确定后、最终配音前依次使用`human-writing v1.1.0`、`humanizer v3.1.0`、Reviewer事实与口播核对，详见[已确认流程](VIDEO_SCRIPT_POLISH_WORKFLOW.md)。技能版本与流程决定不意味着已在本机运行。

## 4. 当前Gate和权限（不得推导放行）

- **唯一现行正式制片状态**：`CW0005_R3_RETURN_OWNER_VISUAL_STORYFIT / CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH`；素材权利`PARTIAL`。
- 冻结V5.6.2 **只代表模板技术PASS**；不能自动开始R4完整试片、真实长片制作、第三方素材下载/付费、AI新生图、对外传播或公开视频。
- 原项目环境为Owner Windows11本机+Docker/WSL；已有代理/VPN、Docker容器、下载缓存与未提交工作，不得跨项目操作、删除数据、`reset --hard`、`git clean`、`docker system prune`、`down -v`。本轮没有访问/更改Owner本地环境。
- 后续任何Executor、Codex执行、PR集成、正式制片必须先读当前有效Gate并取得本轮Owner明确的范围授权。Review任务默认仅只读。

## 5. 已确认的当前停点与接手动作

- **当前已经完成**：V5.6.2 技术PASS、独立Reviewer报告、Owner冻结、main原字节源码与状态/决策归档。无需再重复N-01/N-02或八项旧模板缺陷修复。
- **仍未完成**：⑤真实研究/档案画面呈现、⑭视觉Story-Fit、⑪时间显示语义裁决，以及完整自动音画MP4/SRT/长片复用闭环。现实瓶颈是“真实视频的视觉表达”和“自动化生产集成”，非HTML控件数量不足。
- **关于后续轮次**：[旧七轮路线图](CWS_POST_V562_FREEZE_TO_AUTOMATED_VIDEO_ROADMAP_2026-10-18.md)是Owner要求过的**工作量规划参考**，**没有逐轮冻结、没有确定轮数、没有签发R1～R7 Gate**。新Reviewer可在Owner授权后再评估实施顺序；不要把该提案写为已批准、不得擅自开始制作。
- **交接时建议的第一项只读工作**：核对①最新main/技术指纹、②原R3视频视觉RETURN证据、③已有可用科研资料/素材能力与缺口；据此给出⑤/⑭的**最小独立验证目标和所需Owner决策**，而不是先行下载媒体、另起Mac重构或生成正式样片。**是否以及如何执行后续验证尚需Owner确认**。

## 6. 新Reviewer按序首读（以下链接属于当前main）

1. [CURRENT_STATE.md](CURRENT_STATE.md) 和 [REVIEWER_HANDOFF_CURRENT.md](REVIEWER_HANDOFF_CURRENT.md) —— 最新Owner状态覆盖旧日历史。
2. 本 `CWS_CONFIRMED_STATE_REVIEWER_HANDOFF_2026-10-18.md` —— 仅确证事实。
3. [Owner技术PASS冻结决议](reviews/CWS_V562_OWNER_FREEZE_TECHNICAL_PASS_2026-10-18.md)、[独立Reviewer原文](reviews/CWS_V562_INDEPENDENT_REVIEW_PASS_2026-10-18.md)、[main V5.6.2 HTML](../visual/frozen/storyboard-v5-6-2-20261018.html)。
4. [AGENTS.md](../AGENTS.md)、[有效决策日志](DECISION_LOG.md)、[3+1素材合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)、[视觉Source/Style Lock](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)。
5. [CW0005 R2已验收旁白/分镜](CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md)、[历史R3 Gate](PROD_R3_CW0005_INTERNAL_AV_SAMPLE_GATE_2026-10-16.md)、[素材匹配已决事项](VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md)、[双轮文案流程](VIDEO_SCRIPT_POLISH_WORKFLOW.md)、[media-pipeline README](../media-pipeline/README.md)。
6. 仅在溯源时回看V5.2～V5.6.1历版Reviewer文档及PR #144；它们的当时PARTIAL/WAIT/RETURN不得覆盖现在的V5.6.2技术PASS。

**本文件只归档事实；没有修改冻结HTML、没有合并PR、没有增加未来生产授权。**
