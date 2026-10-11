# Mac Window Motion Kit｜Codex 独立预览任务书（等待 Owner 转交执行）

> `PROPOSED / NOT_EXECUTED` · 新独立支线，只做**5个 UI 预览动效**，不是主线 G1/G2 的新验收条件，也不是正式视频制作的行为授权。  
> 父协议与设计表：`docs/MAC_WINDOW_MOTION_KIT_V1_2026-10-11.md`。  
> **仅 Owner 将本文件转发到另外一个独立 Codex 才视为独立实验预览授权。**

## GATE_ID
`CWS_MAC_WINDOW_MOTION_KIT_DEMO_5_ONLY`

## OBJECTIVE
做一个外观统一的 **Research Aqua / Mac OS X Tiger** 风格的独立 **16:9 浏览器 HTML 预览**。分别展示 MW-01 关闭窗口、MW-02 系统弹窗、MW-03 前后聚焦、MW-04 播放器暂停状态标识（纯示意）、MW-05 任务进度窗口（纯示意），让 Owner 可以点击五个按钮按序播放、重置、比较，决定哪些好看且对视频有用。

## MAX_ENDPOINT_THIS_ROUND
仅在新建**孤立 demo 文件夹**生成 `index.html`（允许同目录 CSS/JS）、`README.md` 和可选预览截图。不得更改已有 Research Aqua V2 HTML、`p4-g1/m1-media-adapter` 的全部源码、已生成 MP4、GitHub main，也不得运行 Remotion、下载素材、安装依赖、开浏览器账号或网络服务。实验可以独立离线打开。

## TARGET / PREFLIGHT
先读：
1. `visual/retro-mac-v1.2/docs/STYLE_LOCK.md`；
2. `docs/MAC_WINDOW_MOTION_KIT_V1_2026-10-11.md`；
3. `p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html`（**只读提取色彩/桌面与图标参照；不能覆盖**）。

先确认独立新目录不会覆盖项目或本地旧文件、另一主线 Codex 的当前 worktree/渲染 stage 没被占用。只在新目录写静态演示代码。若发现正式视觉禁止的特效，也只是**Demo-only**，不得宣告自动用于正式视频。

## ACCEPTANCE CRITERIA / EVIDENCE
- 16:9 预览（建议设计尺寸 1280×720 或 1920×1080），可随浏览器窗口缩放；五个入口和 Reset 均真实有效。
- 每种动效均有稳定起点→触发→终态，浏览器控制台无致命报错，反复点按无卡死；按 30fps 时间基准和表格时长。
- 不用 Apple 原版权截图做宣传；可以原创 CSS/SVG 表达**操作系统式 UI chrome**，但严禁 SVG/Canvas 绘制新的研究实体、人/果冻或假实验素材。
- 对话框及进度提示明确标记 **UI DEMO**；暂停仅动画标识，不冻结真实研究素材；所有额外界面动效均**不能混进现有 B 主片**。
- 提交五段各有开始/中间/结束截图（或一份本地小屏录）用于审看；如无法截图则准确说明仅检查了 DOM/CSS/浏览器可操作性，不冒认已视觉验收。
- 输出 `README`：打开方法、演示效果/持续时间、路径、文件 SHA、没有触碰已有代码及未安装/渲染/联网的声明。
- **停止并交 Reviewer 与 Owner**：由 Owner 选择 KEEP/HOLD/DROP；即使全部演示成功也**不能自动合入正式视频或批准 G2**。

## ROLLBACK / OWNER_ONLY
原项目没有源码变更；若要放弃仅删除新 demo 目录（必须先确认没其它唯一内容及执行记录、按 Owner 确切授权）；无需触碰共享依赖。是否改变 2/4/6 动效正式限制、是否加入真正播放器暂停/模拟 loading、是否改 V2 视觉均由 Owner 在观看后**单独决定**。

## REVIEWER_TO_EXECUTOR_RELAY
> 按 `curious-world-studio/p4-g1/MAC_WINDOW_MOTION_KIT_V1_DEMO_ONLY_TASK_2026-10-11.md` 和 `docs/MAC_WINDOW_MOTION_KIT_V1_2026-10-11.md` 在**独立新目录**实现五个可点击 Research Aqua 窗口动画 HTML demo：关闭、弹窗、聚焦切换、暂停UI占位、进度UI占位。不碰 main、不更改现有 V2/M2/视频、不安装联网、不渲染正式 MP4。演示完成报告路径/截图及测试证据，等待 Reviewer 审核和 Owner 选择。

## EXECUTOR_TO_REVIEWER_RELAY
返回五个效果各自可否复现、屏幕尺寸/时长、演示文件/截图路径、未触碰原项目证明、可复用与不建议的 UI、回滚路径与唯一需要 Owner 裁决的取舍。
