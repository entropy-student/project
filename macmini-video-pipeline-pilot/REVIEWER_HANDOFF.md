# Mac mini Video Pipeline Pilot — REVIEWER HANDOFF

> **唯一当前项目状态** · 2026-10-28 · G4A 真实小样已验证，**G4 整体进行中**  
> 管理依据：[VPS Project Governance v0.2.7](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md) 通用部分。  
> 仓库：`entropy-student/project` · 工作分支：`project/macmini-video-pipeline-pilot-20261028` · [Draft PR #176](https://github.com/entropy-student/project/pull/176)（**尚未合并 main**）。  
> **唯一当前真相只在此文件**；其他报告、脚本、Evidence 不与之竞争。

## PROJECT_GOAL
1. 完成一期有真实研究、有说服力视听表达、16:9、可供 B 站发布的 Mac mini 消费决策视频（有发布价值不等于现已发布）。
2. 验证 AI 从选题→调查→脚本→自主导演→反向补素材→真正视频→复盘的低成本生产系统。
3. 公网发布、购买设备、付费或安装/修改本地软件，均需 Owner 另行决策；文本/小样 PASS 不能当 VIDEO_PASS。

## PROJECT_STAGE / CURRENT_ACCEPTED_STATE

| Gate | 目标 | 当前状态 |
|---|---|---|
| G0 | 独立项目与治理 | PASS |
| G1 | 研究、反证与选题判断 | PASS |
| G2 | 叙事与完整中文口播 | PASS（文本范围） |
| G3 | 声画导演、素材逆向规划 | PASS（设计范围） |
| G4 | 实际素材、关键视觉小样 | **IN_PROGRESS：G4A P2 PASS / P1 & 媒体资产待办** |
| G5 | 整期 MP4/配音/字幕/封面/观看 QA | PENDING |
| G6 | Owner 验收、复用流程复盘 | PENDING |

- `G4A_P2_AV10_AV12_PROTOTYPE = PASS`：真实制作/运行了 **五阶段 19.5 秒 HTML 动画**（无声音）；实拍了 Chromium 1600×900 截图（S0–S4）并从真实浏览器帧导出 **20.0 秒 1600×900 H.264 MP4**。内容是“官方 4W 闲置 → 访问链 → **假设**网络断开 → 静态托管替代 → 设备开机≠网站可用”。
- `G4_OVERALL = PARTIAL / IN_PROGRESS`：尚缺 AV04–AV05 三需求分流第二个视觉小样、全片真实素材（R01–R04）、角色/字幕/配音、持久化 GitHub 二进制媒体、真人静音/视听 QA，**不宣布 G4 整体 PASS**。
- `PROJECT_STAGE = VISUAL_PROTOTYPE_P2_VERIFIED / G4B_PENDING`
- `CURRENT_GATE = G4B_THREE_TASK_VISUAL_PROTOTYPE`
- `NEXT_STEP = G4B`：制作 G3 AV04–AV05/P1 的「一台设备 → 桌面电脑 / 本地 AI / 公网服务三种不同任务」实际可打开动画与静态画面；与 P2 原型共享视觉系统，确认整体风格可复用、非逐句PPT。
- `OWNER_ACTION_REQUIRED = NONE`：G4B 可完全基于自绘图形，不要用户出镜、购买 Mac mini 或安装软件。
- `DEFAULT_EXECUTION_CHANNEL = ChatGPT Reviewer + GitHub 项目分支文档/HTML；真实 Chromium/FFmpeg 于当前沙箱完成媒体验证`。用户 Windows 环境尚未实测。
- `CURRENT_ROLLBACK_STATUS = 仅 GitHub Draft PR 中项目代码和文档，以及当前会话沙箱媒体；Git 可回退，不影响 main/其他项目/生产服务`。

## CURRENT EDITORIAL & DIRECTOR TRUTH
- **选题不变**：《一个普通人，真的需要花 7000 块买 Mac mini 吗？》；发布时价格用实际复核的精确值。2024 M4 ¥4499 与 2026 M6 ¥6999 是两代历史官方发布基础价；不能推断差额仅因内存涨价。
- **观众承诺**：普通人的消费决策调查，不装作买过或亲测 Mac mini。
- **主发现**：工作站（交互/macOS）/本地 AI（本地计算与数据）/公网网站（可达性与服务可靠性）是三种不同采购目标。
- **已接受的 G2 口播 V1**：仍未改动；个人第一人称经历与听感只有文本审查，未获真实性/配音体验最终确认。
- **G3 已接受导演**：14 个语义 AV 节拍，两个重点视觉 P1 三任务分流与 P2 访问链因果；允许根据实际画面局部改文案，不提前重新设计整篇。
- **本轮落地的 P2 原型**：自绘图形、无外部视频/第三方图；`Apple M6 16/256 闲置 4W` 仅指官方注明的闲置功耗；`断网` 明示“假设／非真实故障”；Cloudflare Pages 只作静态网站托管示例，不保证所有后台场景免费或永远在线。
- **视觉包装**：16:9 主信息区优先、少量字幕/角标，右下解说小人可选并允许证据特写时隐藏；真实角色源文件可用性仍 UNKNOWN。
- **事实来源**：[Apple 支持功耗](https://support.apple.com/zh-cn/103253)；[Cloudflare Pages 限制](https://developers.cloudflare.com/pages/platform/limits/)（两者 2026-10-28 本轮再次核对）。

## SYSTEM_MAP / 文档与可复现产物
```
Topic → G1 evidence PASS → G2 voiceover PASS (text only)
→ G3 AV script PASS (design only)
→ G4A P2 network causality HTML/MP4 PASS (prototype only)
→ G4B P1 three-task splitter NEXT
→ G5 whole video/voice/subtitles QA
→ G6 Owner acceptance + workflow learnings
```
- 唯一 Handoff：`REVIEWER_HANDOFF.md`。
- 追加 Evidence：`EXECUTION_EVIDENCE.md`。
- 资料与脚本：[G1 研究](./docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md) / [G2 完整口播](./docs/G2_NARRATIVE_AND_SCRIPT.md) / [G3 AV 导演](./docs/G3_AV_DIRECTOR_AND_ASSET_TASKS.md)。
- **真实媒体源码**：[G4A HTML](./prototype/g4_network_availability.html)；[HTML 运行说明](./prototype/README.md)；[G4A 实际 QA](./docs/G4A_PROTOTYPE_QA.md)。
- 二进制 MP4/PNG/ZIP 已在 **2026-10-28 当前聊天沙箱交付**；`GITHUB_BINARY_MEDIA_PERSISTED = NO`。后续会话以仓库 HTML 复建，不得假设之前沙箱仍可获取或截图已进入 PR。
- 候选写作规范：[v0.2](./docs/WRITING_STANDARD_DRAFT_v0.2.md) 仍不是经过跨题型验证的 Skill。
- `ai-story-showrunner/`、`visual-narrative-animation-lab/`、PR #174 均只读参考，未改动。

## CRITICAL_CONSTRAINTS
1. 不虚构作者购买/实测、不把“假设网络故障”当真实录屏；所有演示示意需标明。
2. Apple 4W **仅为官方特定配置闲置**，不得替换为日常运行平均功耗、电费或服务器实际可靠性结论。
3. 画面必须解释/证明，不把口播逐句转换 PPT；如果原画面无法支撑，主动补证或修文案。
4. 引用公开数据不代表原始宣传图/视频已授权自由复用；所有第三方媒体来源与权限待逐项登记。当前 P2 图形自绘。
5. 不因 Owner 未提供桌面/循环小人而伪造个人实拍；首轮相关媒体可先做无人物解释动画。
6. 不默认买设备、付费 AI 视频生成或为简单动画安装 AE/复杂系统。
7. 不修改其他项目、Governance、main 或 PR #174，不发布完整视频；PR #176 保持 Draft。
8. Gate PASS 需要真实运行、Evidence、Reviewer 审查、唯一 Handoff 更新并 GitHub 读回；没有真人音画 QA 不得记 VIDEO_PASS。

## CURRENT_GATE / G4B_THREE_TASK_VISUAL_PROTOTYPE
- `GATE_ID`：G4B_THREE_TASK_VISUAL_PROTOTYPE（**仍属于 G4**）。
- `OBJECTIVE`：实际做出 G3 的 AV04–AV05 任务分流视觉；测试与已完成 P2 是否能构成同一套可复用视觉语言。
- `MAX_ENDPOINT_THIS_ROUND`：仅制作 1 个可打开的 16:9 HTML 片段（P1 三任务分流），至少 3 张稳定截图、必要时可导出短 MP4，与 P2 进行无声可懂性/视觉一致性审查，更新 G4 Evidence/Handoff。
- `MANDATORY_REVIEW_STOP`：完成 G4B 视觉验证就 STOP；不越权做 G5 整期视频或用户本机安装/发布。
- `TARGET_AND_SCOPE`：仅本项目 `prototype/`、`docs/`、Handoff、Evidence；不得改 G2 已接受全文除非发现影响正确性且留有局部修订证据。
- `PREFLIGHT`：从本 Handoff、G3 第 4 节 P1、G2 B–D 段、现有 G4A HTML/QA 起步；确认当前媒体执行环境。
- `REQUIRED_EVIDENCE`：实际 HTML 及截图、真实浏览器脚本运行结果/异常、解说小人可选性及素材自绘/版权说明、P1 与 P2 视觉一致性与静态替代测试。
- `ACCEPTANCE_CRITERIA`：不听声音也能分清「本地工作」「本地 AI」「公众访问网站」三类目标；**不是同一张总成本表**；无伪实测数据；文字/字幕安全区不互相遮挡；源文件可重建。
- `ROLLBACK_STATUS_OR_PLAN`：GitHub 独立分支和沙箱新媒体可回滚/丢弃，不涉及运行数据。
- `OWNER_ONLY_ACTIONS`：NONE；不需要采购或出镜。
- `REVIEWER_TO_EXECUTOR_RELAY`：从 G3 [方案 P1](./docs/G3_AV_DIRECTOR_AND_ASSET_TASKS.md) 的“设备→3 条路径”建立小样；使用 G4A 已验证的 HTML/CSS 和 SVG 样式及运行工具，不搜索无关项目，不虚构时间轴/渲染结果。
- `EXECUTOR_TO_REVIEWER_RELAY`：交付实际文件/截图/检查证据，Executor 标 PASS_CANDIDATE；Reviewer 决定下一 Gate。

## UNRESOLVED / 未证实
- Windows 本机双击 `file://` 未测试（容器浏览器有路径限制，使用 `set_content` 通过）；云端浏览器运行不等于 Owner 本机验证。
- MP4 可播放技术小样是**无声、无字幕实测对齐、无讲解小人**；观众静音盲测和实际讲稿节奏尚未验证。
- 三任务分流（P1）未动效验证，G4 资产收集/版权审核还需推进。
- 用户现有视频模板/人物循环视频真实文件、本人实拍、用量或可用权利 UNKNOWN。
- Mac mini 本机、真实网络失效率和最新二手市场价没有第一手测试；不得声称已核。
- 正式成片效果、受众理解、跨题复用均未通过。
- GitHub 二进制媒体尚未归档，现已持久化 **HTML 源码 + 验收/复现步骤**。

## NEXT_STEP
下一轮先做 G4B：用相同视觉系统真实完成「Mac mini 能做三件事，但三件事各需要不同购买条件」的短动效，然后评估能否进入整片生产。不要再围绕三种文案类型反复投票，也不要让 Owner 逐帧告诉 AI 该怎么制作。

## OWNER_ACTION_REQUIRED
`NONE`。真实设备、用户电脑、配音或露脸都不是 G4B 的前置条件。

## EVIDENCE_POINTERS
- [G4A 实际验证报告](./docs/G4A_PROTOTYPE_QA.md)
- [G4A 源码](./prototype/g4_network_availability.html)
- [G4A 复现说明](./prototype/README.md)
- [G3 导演](./docs/G3_AV_DIRECTOR_AND_ASSET_TASKS.md)
- [G2 文案](./docs/G2_NARRATIVE_AND_SCRIPT.md)
- [G1 研究](./docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md)
- [执行证据](./EXECUTION_EVIDENCE.md)
- [Draft PR #176](https://github.com/entropy-student/project/pull/176)

## DECISION_LOG（精简）
- 2026-10-28 G2：口播 V1 文本审查通过，未视为实际成片。
- 2026-10-28 G3：14 个语义节拍与两段重点解释动画设计通过；先验证 P2 网络因果。
- **2026-10-28 G4A**：P2 **真实 HTML 运行/截图/无声 MP4 导出通过**；曾发现 S3 布局重叠并修复；音画完整体验未证实，故 **G4 仍 PARTIAL**，下一小 Gate 为 G4B 三任务分流。
