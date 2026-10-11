# P4-G1V-A｜桌面交互动效原型执行报告（本机 Codex 原始证据归档）

**状态：原型已渲染；机器 QA 通过；Owner 常速真人审看待确认。** 本报告不宣称 G1V-A 全验收通过，也不表示 G1/G2 通过。

## 范围与来源

- 按 GitHub main 的 G1V-A 验收定义执行：commit c365a892626414022d8fe6e32f61eb4d8ce5fa5f；[验收定义](https://github.com/entropy-student/project/blob/c365a892626414022d8fe6e32f61eb4d8ce5fa5f/curious-world-studio/p4-g1/G1V_A_DESKTOP_INTERACTION_PROTOTYPE_ACCEPTANCE_2026-10-11.md)。Retro Mac Tiger Aqua / QuickTime 7 视觉边界按 STYLE_LOCK v1.2。
- 新隔离目录：C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d；唯一 stage slug：cws-g1va-desktop-open-play-20261011-70c55d。
- 仅新增该 slug 的 OpenMontage Composer projects/ 与 public/ staging。没有编辑正式仓库源、剧本、题库、评分、R1/R2 输出；旧 R1/R2 MP4 的 SHA 均与旧报告记录相同。
- 未下载视频/图像/字体/模型，没有安装或升级工具，没有调用云模型，没有启动 G2。没有生成音频或字幕。

## 成片

- MP4：[cws-g1va-desktop-open-play-20261011-70c55d.mp4](<C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/out/cws-g1va-desktop-open-play-20261011-70c55d.mp4>)
- SHA-256：26b76c85dc229447b3120a6cc3e45c31e80ffaf90cdf3abcf6d84cc981cc514a
- 7.000 秒、1920×1080、30 fps、H.264、210 帧；最终文件不含音轨。
- 交互事件时间轴：[interaction_timeline.json](<C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/out/interaction_timeline.json>)。关键帧在 C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/out/keyframes/。
- 源码副本：C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/src/entry.tsx、C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/src/DesktopOpenPlay.tsx；Composer stage 中保留对应副本。
- 执行日志：C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/qa/render.log。

## 画面材料与行为

- 100% 程序绘制：Aqua 风格桌面、研究相关电影文件图标、指针、点击波纹、银灰播放器控件、抽象发光胶状体与波纹运动。画面没有引入外部素材。
- **完全未使用研究原视频：是。**
- **完全未使用 Fig. 7 / Fig. 8 作主画面：是。**
- B 内容固定标为“示意画面 · 自制动画 / 非实验数据”；是 2D 矢量示意，不是论文结果、科学数据或真实实验影像。
- 动作链：0.0–0.5s 桌面静止；0.5–1.4s 光标连续移动；1.4s 文件选中；1.5s 与 1.7s 双击反馈；1.833s 从文件位置出现播放器并连续长成窗口；2.733–4.2s 窗口铺满画布；4.2s 暂停态，4.6s 播放按钮变暂停、进度前进，示意体开始动态变形/波纹运动。没有独立 C 状态。

## QA 与验收状态

| 项目 | 结果 | 证据 |
|---|---|---|
| 视频规格 | PASS | qa/ffprobe-final.json：1920×1080，30/1 fps，7.000s，210 帧 |
| 全片解码 | PASS | qa/full_decode_final.log，exit 0 |
| 黑帧 | PASS | blackdetect=d:0.03:pix_th=0.10 无命中；qa/blackdetect_final.log 为空 |
| 动态/事件证据 | PASS（静帧与帧差） | 210 帧中 209 个唯一帧哈希；8 个关键帧均从最终 MP4 重抽并逐像素相同 |
| 纯视觉 | PASS | 最终 MP4 仅含视频流，无音轨。Remotion 初始编码曾附带 -91 dB AAC；原始渲染保存在 qa/remotion-render-original-with-silent-aac.mp4，交付文件从其 H.264 流无损 remux 去音轨得到 |
| 文件链、窗口展开、B 示意状态 | 静帧检查通过 | 8 张关键帧分别展示桌面、移动、选中、双击、窗口出现、扩展、满屏暂停、播放运动 |
| Owner 真人普通速度完整观看 | **待确认** | 尝试在 Edge 用 file:// 播放被浏览器安全策略拒绝；遵守拒绝，没有尝试替代浏览器/绕过方式。静帧检查不能代替真人完整观看。 |

## 关键帧索引

- 0.300s 桌面初始：[01-desktop-initial.png](<C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/out/keyframes/01-desktop-initial.png>)
- 0.933s 光标移动：[02-cursor-movement.png](<C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/out/keyframes/02-cursor-movement.png>)
- 1.467s 文件选中：[03-file-selected.png](<C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/out/keyframes/03-file-selected.png>)
- 1.767s 双击反馈：[04-double-click-feedback.png](<C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/out/keyframes/04-double-click-feedback.png>)
- 2.200s 播放器出现：[05-player-appears.png](<C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/out/keyframes/05-player-appears.png>)
- 3.467s 全屏扩展中：[06-player-expanding.png](<C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/out/keyframes/06-player-expanding.png>)
- 4.400s 满屏暂停：[07-fullscreen-paused.png](<C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/out/keyframes/07-fullscreen-paused.png>)
- 5.867s B 播放中：[08-b-playing.png](<C:/Users/34707/AppData/Local/Temp/cws-g1va-desktop-open-play-20261011-70c55d/out/keyframes/08-b-playing.png>)

## 未解决项

1. 仍需 Owner 常速完整观看 MP4，并回答是否像真实地操作电脑打开并播放视频；在收到这项真人意见前，G1V-A 视觉验收保持待确认。
2. B 是用于验证开场行为链的自制矢量占位，运动没有科学含义；若进入后续内容制作，必须替换为另行审核/获权的内容，并再次检视全屏尺度与真实播放质感。
3. Remotion CLI 探测/渲染期间报告了自动 “Webpack config change detected. Clearing cache...” 。没有手工清理任何缓存；这是 Composer 自身编译缓存自动刷新，具体被重建的缓存项目无法量化。

**结论：交付 G1V-A 桌面交互动效原型，状态 RENDERED / MACHINE_QA_PASS / OWNER_REVIEW_PENDING。不宣称 G1V-A PASS，不进入 G2。**
