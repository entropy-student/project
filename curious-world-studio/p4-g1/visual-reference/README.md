# G1V-A｜视觉基准：Assistant V2 Research Aqua（Owner 选择）

**决策日期**：2026-10-11 · **状态**：`G1VA_VISUAL_REFERENCE_SELECTED / VISUAL_EXPERIENCE_FAVORED_BY_OWNER / G1VA_TECH_INTEGRATION_PENDING / G1_NOT_PASS / G2_NOT_AUTHORIZED`

本目录保存 Owner 比较过实际样片后选择的 **ChatGPT 制作版 V2** 自包含 Canvas/HTML 源码；它是**视觉实现基准**，不是 Remotion 合成模块、正式镜头/声音/整片，也不是官方 macOS / QuickTime。原版 Codex 7秒 Remotion 模块保留作为工程成果，不强制沿用它的视觉结构。

- `g1va_v2_research_aqua_prototype.html`：实际选定的 **Research Aqua** 壁纸 + Tiger 风格系统框架，支持 `W` 键切换 Classic Aqua。双击 HTML 可以在浏览器循环播放；`window.renderAt(t)` 与 `window.prototypeState(t)` 可以由自动化程序控制帧和观察内部状态。
- 视频版源于同一 HTML：研究感壁纸 9秒，1920×1080，30fps，270帧，H.264、无音频；SHA-256 `914a4a7b4dd5dfd542561e2a89a5d65a5c8fbf78d322b5c35afb93a2092a96d2`。**MP4、Classic Aqua 对照版、可编辑源码与QA完整包作为会话内下载产物交付，未提交二进制素材进仓库。**
- 当前画中 B 果冻是原创 **示意画面**，并非论文作者真实录像、真实研究数据或已经接入的本地 MP4。Owner 的默认方向是不使用研究原视频，后续以经过权利审核的替代视频素材／自制动画表达，但继续以论文作科学事实依据。
- `PLAY_START=4.76`，示意素材逻辑时长 `ASSET_DURATION=12`：窗口打开显示同一份示意画面的 `assetTime=0` 首帧；直到点击播放才推进。进度条按素材时间，而非按本外壳 9秒 MP4 总时长；两者不能混淆。

## 复现与下一步（2026-10-11 Reviewer 保全）

- [V2原生成参考脚本](render_reference.py) 与 [两版真实 MP4 QA 清单](V2_QA_manifest_2026-10-11.json) 已补入 GitHub main 预定文档。脚本原设计依赖本机已有 Python Playwright、FFmpeg 和 **Linux `/usr/bin/chromium`**；它的存在不表示在 Owner Windows / Remotion 环境已运行。由 Reviewer 通过容器读取真实 Research/Classic 两条 MP4，核对各自 SHA 和 Research 270帧/1920×1080/30fps。
- [2026-10-11 唯一完整接手文档](../../docs/REVIEWER_HANDOFF_2026-10-11_G1VA.md) 记录双版对比、权限、历史证据与下一步；[M1媒体适配任务书](../LOCAL_CODEX_G1VA_V2_MEDIA_ADAPTER_TASK_2026-10-11.md) 负责实际输入 MP4 的第0帧读取、暂停/播放一致性和素材真实时长。
- `V2_QA_manifest_2026-10-11.json` 的 `humanVisualApproval=PENDING_OWNER_REVIEW` 是**当时测试输出的历史状态**；Owner 后续已明确采用 Research Aqua 作为**视觉参考**，但从未据此批准G1完整视频制作。这两个事实不矛盾。
- 二进制 MP4 和壁纸/关键帧 PNG 保留为会话内原型产物和 Owner 本地参考，**未提交仓库**；以后接手者能够从 main 获取所有重要文本/源码，但不能仅凭 main 直接打开已有 MP4。

## 为什么不沿用 Codex 的那份 UI

Codex 的 `DesktopOpenPlay.tsx` 是合法的独立技术原型（7s、30fps、210帧、H.264、无音轨；报告 SHA `26b76c85dc229447b3120a6cc3e45c31e80ffaf90cdf3abcf6d84cc981cc514a`），机器QA不能直接等同视觉通过。**原始 G1V-A 任务书要求不用原始实验视频和 Fig.7/8，且使用标明的自绘占位，所以两版都画了果冻，这是按原范围执行，不是 Codex 无理由漏掉可直接用的视频。**

源代码层面可复核的不足：
- Codex 鼠标可见条件 `frame>=15 && frame<61`，30fps 即只在 `0.5–2.033s` 可见；播放器开始扩大 `2.733s`，播放自动转为 true 在 `4.6s`；**屏幕上没有鼠标执行后两次操作**。
- Codex 播放状态和内部素材时长由 `frame>=138` / `00:18` 常量决定，暂停时内进度条也保持至少1.5%；缺真实媒体统一时间轴和进度初值。
- 机测 `209/210` 独立画面、无黑帧只证明非纯静态和规格，不证明桌面行为达到 Owner 期望。UI 层次、鼠标因果、首帧观感由 Owner 比较选定 V2。

**不能因此宣布 G1V-A 整体 PASS**：两版都尚未替换真正授权的外部/自制视频文件，V2 是独立 HTML/Canvas + FFmpeg 工程，Codex 版属于 Remotion。要采用 V2 的视觉结构接入现有生产链，需后续确认具体 Remotion 适配器和可重用媒体时间轴，通过独立复渲和 Owner 常速观看。

## 下一次建议做的最小工程合并（不在本PR执行）

1. 把 V2 的视觉参数/图标/菜单栏/Dock/玻璃质感、桌面坐标系、文件选中、双击、绿色按钮和播放按钮事件 **以可参数化组件**移植至既有 CWS Remotion，保留可用的本机 Remotion 与 FFmpeg 工具链。
2. 设计媒体输入接口：`asset_path`（已确认可用/有权使用的真实本地视频或 CWS 自制动画）、`duration_ms`、`fps`、`poster_source="asset_frame_0"`、`play_start_video_ms`、`video_dimensions`。打开窗口显示**该同一素材的真实第0帧**，在点击播放之前不推进；播放后基于 `assetTime=max(0,videoTime-playStart)` 驱动内容、UI进度和字幕音频偏移；不得以一张自行绘制的相似“海报”代替内容首帧。
3. A→B 行为为视觉模板，不要把整片固定在9秒；原型可以慢一点证明因果，实际各集可按观众节奏缩短；播放器内容、字幕与镜头仍以 `STYLE_LOCK v1.2` 为准。
4. 新的本地工作目录/stage slug、浏览器路径显式传入、保留现有 R1/R2/VA 原输出；做画面/时间/媒体 SHA QA。未经另行审批不安装新工具、下载素材或进入 G2。
