# P4-G1V-A｜Codex 实际 7 秒 vs Assistant V2 9 秒：Reviewer 比较与基线选择

**Date：2026-10-11** · **Decision：`G1VA_VISUAL_REFERENCE_SELECTED=ASSISTANT_V2_RESEARCH_AQUA`；Codex `RENDERED / MACHINE_QA_PASS / VISUAL_NOT_SELECTED`；`G1VA_MEDIA_ADAPTER_NOT_READY / G1_VISUAL_NOT_PASS / G2_NOT_AUTHORIZED`。

## 证据材料

- 用户提供的完整 Codex `cws-g1va-desktop-open-play-20261011-70c55d.zip` 经本轮 Reviewer 实际解压：包含 `G1VA_EXECUTION_REPORT_2026-10-11.md`、`src/DesktopOpenPlay.tsx`、`src/entry.tsx`、`out/interaction_timeline.json`、`qa`、关键帧及真实 MP4；即**并非仅依据口头报告**。
- Reviewer 独立执行 FFprobe：Codex MP4 SHA-256 `26b76c85dc229447b3120a6cc3e45c31e80ffaf90cdf3abcf6d84cc981cc514a`、`1920×1080`、`30fps`、`7.000s`、`210帧`，无音轨。与 Codex 报告相符。机器 QA 报告给出全片解码通过、无黑段、关键帧匹配，尚不能代替视觉感觉评价。
- Assistant 已实际生成两个 V2 MP4：Research Aqua `914a4a7b4dd5dfd542561e2a89a5d65a5c8fbf78d322b5c35afb93a2092a96d2`、Classic Aqua `ff18ac1a359b1561612a54903433846fadbb7eac963feaa60319abf0bd3cdd6f`，均 `9秒 / 1920×1080 / 30fps / 270帧 / 无音轨`，附自包含 HTML、关键帧及 QA。Owner 在观看后明确表示喜欢 Assistant 版，并表示“按你推荐的来”，故选**Research Aqua**。所采纳可编辑源码见[视觉基准](../p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html)及[实施边界](../p4-g1/visual-reference/README.md)。

## 为什么 Codex 自绘了果冻，而没有“用原始素材”？

**符合当轮任务合同，并非自己擅自遗漏**。G1V-A 正式验收定义 `G1V_A_DESKTOP_INTERACTION_PROTOTYPE_ACCEPTANCE_2026-10-11.md` 明确“**无真实获许可实验视频时采用清楚标注的自制抽象运动占位**”；过去 Owner 也已决定默认不使用研究原视频。Codex `DesktopOpenPlay.tsx` 的 `SyntheticMotion` 函数生成自绘胶状体、背景波纹，并在播放器标注 `示意画面·自制动画 / 非实验数据`。Assistant V2 的 B 场景同样是自绘临时示意而非原实验录像。

真正未解决的是**可替换视频素材接入**：当前两个原型都没有提供“文件窗口第0帧来自同一份真实被播放 MP4”的完整通用接口；V2 只是对**自制同一素材**实现了首帧冻结，不能误报任意视频接入能力。

## 关键机制的客观差异

| 检查维度 | Codex 实际 7秒版本 | Assistant V2 9秒（最终视觉基准） |
|---|---|---|
| 文件选中与双击 | 实现，有点击反馈 | 实现，有连续鼠标动作/反馈 |
| 播放器弹出及最大化 | 自动窗口扩张；**鼠标未实际到最大化按钮** | 鼠标交互轨迹包含窗口按钮，再全屏 |
| 播放开始 | `playing=frame>=138` 自动触发；**鼠标在后半段已隐藏** | 鼠标点击播放后素材与播放器进度同时前进 |
| 鼠标可见区间 | `frame>=15 && frame<61` = 0.500–2.033s | V2 覆盖后续绿色按钮与播放按钮行为 |
| 全屏动作区间 | `frame82–126` =2.733–4.200s；其间**光标已不显示** | 有显示的按钮行动与窗口平滑过渡 |
| 播放进度 | 未播放时也留 `1.5%` 轨道占比，`00:18` 素材总时长硬编码 | 从实际点击 4.76s 后 `00:00` 起，以**12s示例素材**为分母（尚非外部媒体真实长度） |
| 素材第一帧 | `SyntheticMotion` 的 `frame<138` 维持静态自绘图；不是真正视频资产的第0帧 | 自绘示意素材的 `assetTime=0` 在开窗及全屏暂停时**不变**；需再扩展为真实媒体 frame0 |
| UI 包装 | 符合初级 Aqua 配色和 B QuickTime布局 | Owner 偏好 V2 更稳定的菜单/Dock/窗口层次与研究感壁纸 |
| 工程 | Remotion/OpenMontage Composer；环境内已有实际成功渲染 | 独立 Canvas HTML + Playwright/FFmpeg；可编辑，**尚未集成 CWS Remotion 生产路径** |

源代码层观察明确：后半段自动状态变化不能以“渲染了209个不同画面”代替鼠标行为正确。评价 UI 的“更好看”是 Owner 观看偏好，绝非从 FFprobe 可以证明的客观属性。

## 后续工程决策：取长补短，而不是再次从零换皮

1. **视觉层：采用 Assistant V2** 的菜单/Dock/研究感 Aqua 壁纸、文件图标、第一帧冻结、连续鼠标/开窗/全屏/播放与进度逻辑，保留 Classic 壁纸作为可选主题。
2. **技术执行：保留 Codex Remotion 路径**。它真实产出了 1920×1080 H.264 MP4，适合作为受控本机渲染器。下一轮让Codex **移植视觉行为机制**或用可审计的渲染适配器复用 V2 HTML；避免把视觉参考误报成已转移到 Remotion 的组件。
3. **素材接口需要单独 Gate**：每期一份有权使用的本地/生成视频，读取该文件的第0帧作开窗停顿画面、从播放按钮事件后按真实帧率推进视频画面，并根据该文件真实时长计算播放器进度；不能拿一张独立“封面图”冒充第0帧。数据合同建议：`asset_id/path/sha256/duration_ms/fps/source_kind/rights_status/first_frame_sha256/start_play_video_ms`。
4. **科研语义不放松**：默认不用原研究视频，B 可用经许可替代素材或自制动画，但必须按真实对应关系标 `辅助素材`、`示意画面`，不能演成“研究者实际拍到了这些画面”。
5. **验收仍分层**：`G1V-A_OWNER_SELECTED_VISUAL_REFERENCE` 是选择视觉基准；`G1V-A_RENDERED` 是已经真实做出原型；`G1V-A_REUSABLE_MEDIA_ADAPTER_PASS` 与 `G1_FULL_VISUAL_PASS` 尚不存在。后续全片、配音、发布、G2 均不自动授权。

**本轮修改仅归档文档和选中 HTML 源码，不变更 STYLE_LOCK、正式节目脚本、题库、评分、不重渲已完成视频或更新Windows本机 Composer。**
