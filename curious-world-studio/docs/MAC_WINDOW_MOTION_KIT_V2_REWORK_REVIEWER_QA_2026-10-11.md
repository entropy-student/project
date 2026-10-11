# Mac Window Motion Kit v2 返工独立 Reviewer QA（2026-10-11）

> **CURRENT STATUS:** `V2_REWORK_REVIEWER_TECHNICAL_PASS` / `MW03_FOREGROUND_AND_REVERSE_INDEPENDENT_PASS` / `VISUAL_KEEP_CANDIDATE_01_02_03` / `DEMO_ONLY_HOLD_04_05` / **`OWNER_NORMAL_SPEED_VISUAL_ACCEPTANCE_PENDING`**。本结果覆盖旧 HTML 的首批五项视觉 RETURN 对于**新产物的技术层级**，不反写旧版失败记录；旧版仍为 `RETURN_VISUAL_REJECTED_ALL_FIVE`。**绝不升级 G1/G2 或正式视频动效授权**。

## 1. 实收证据与 SHA（Reviewer 沙盒实际读取）

- Owner 上传 v2 新包 `cws-mac-window-motion-kit-v2-rework-20261011(2).zip` 24,667,105 B；SHA256 **`8987b1a5594ecc346d463ec3c8f47239de5c50587711eb56232ed48964757b67`**。
- 解压后独立检查 `SHA256SUMS.txt`，**72/72 条 SHA 对照全部匹配**，无缺失；内含单文件 `index.html` **32,052 B**、SHA256 `dadae6300f6159681650fc4b63d801c4fe8285991a997c00dadcd4d24f3529fb`，README/Handoff、44张 `screenshots/MW-xx_Fxxx.png`、额外对照截图、5条浏览器 WebM QA 录屏、JSON运行记录与分离源 JS。
- Reviewer 独立核查全部 **44 张**正式关键帧截图为**1280×720**；额外 `qa/mw03_*.png` QA截图（不是44张关键帧）仍有 **1280×721**，是 QA辅助截图的 Playwright元素盒小数像素 rounding，不能说包内*所有 PNG*严格1280×720。
- 旧版ZIP `cws-mac-window-motion-kit-demo-20261011(1).zip` 在Reviewer现有沙盒仍存在，SHA `544ccb428de03978d12f7710dc426e57414f9af4e8824b83e2a4603296a8478f`；新版另有独立 SHA，**Reviewer 沙盒未覆盖旧 ZIP**。Owner Windows 自己的归档持久性仍以其本机确认/保存为准。
- 五条 `qa/browser-1x-recordings/MW-xx_1x_canvas_QA.webm` 均真实存在，独立 FFprobe显示 **VP8 1920×1080**，完整 FFmpeg解码exit0；可视化抽样各片的真实录屏帧，窗口变化连续、鼠标交互可辨，MW-03 尤其不再是假叠窗。

## 2. 逐项独立 QA 与视觉候选

| Demo | 档案标称1×全长 | Reviewer **自身浏览器真实1×完成** | Reviewer视觉建议（待Owner看） | 关键发现 |
|---|---:|---:|---|---|
| MW-01 红点关闭 | 3.50s/105f | **3.717s / 最终帧105** | **KEEP 候选** | 鼠标移向红灯/hover/clickRing/按压，关窗退出后保留完整研究桌面；旧版缺失动作链已补 |
| MW-02 Aqua提醒 | 5.033s/151f | **5.266s / 最终帧151** | **KEEP 候选** | 鼠标点 Open-next→弹窗→阅读→Cancel→退出，已独立验证手动选择 Open 真正变更 `manualChoice`；提示不代表实际打开文件 |
| MW-03 双窗A↔B切换 | 6.467s/194f | **6.739s / 最终帧194** | **KEEP 候选（核心行为已修）** | 真实位置与尺寸过渡 A-front=(380,165,960,635) / B-rear=(1190,252,545,488) → B-front=(657,173,1013,627) / A-rear=(220,300,660,474)，600ms切换；独立浏览器实际点击 A露出区域→前景A、点击B露出区域→前景B；且0.5×独立完整跑通**13.007s** |
| MW-04 播放器暂停标识 | 5.333s/160f | **5.542s / 最终帧160** | **HOLD，仅UI Demo** | 全幅B占位播放器与点击/恢复流程比旧版完整；没有冻结真实视频也不允许在正式视频中添加第5类时间控制 |
| MW-05 文件进度框 | 5.733s/172f | **5.773s / 最终帧172** | **HOLD，仅UI Demo** | 明确UI DEMO，鼠标触发、进度条0/50/100与Done保留/离场；没有实际文件复制或研究运算，不得包装成真的下载/分析过程 |

Reviewer **独立** Chromium/Playwright 用实际 `index.html` 内容运行（非脚本模拟时长），逐项真实 1× Play→终帧和Reset；**5/5 到终帧、5/5 Reset**。实际墙钟是受限容器的本机结果，不等同 Windows浏览器、视频导出真实每帧恒时。MW-03另有 0.5×实测、画布A→B/B→A鼠标事件、MW02手动Open，**没有JS错误和对外HTTP请求**。0.5×其余四项已完成属于 **Codex 提供的本机JSON证据**，Reviewer本轮没有再独立实跑所有4项。
- 最初整套Reviewer完整自动重播流程在当前受控容器出现一次脚本/浏览器超时，随后 Reviewer 独立将每项1×、MW03 0.5×分开重跑全部结束，不能用那次超时直接推导 Owner Windows性能有故障。

## 3. 视觉与V2母版关系

- 返工源码 `source/v2-desktop.js` 并入单文件HTML，显式移植 V2 同源 `drawWallpaper`、`drawMenu`、`drawDock`、`desktop`、`folder`、`movieIcon`、`drawCursor`、`clickRing`；使用原 V2 **1920×1080**母版；对照原锁定HTML blob `acb0ee80264527bd11160e0ae277ce24528c4a03`，主屏几何 menu43、Dock(560,951,800,111)、Research folder(220,270)、movie icon(1487,278)、disk(1664,71)与 V2 参数一致。与旧CSS另造壁纸/Dock和文字图标相比属真实改进。
- **明确未通过所有动态时点逐像素等价证明**：新版所有 A 桌面背景调用 `desktop(0,false)`，将原V2壁纸波纹与Dock图标暂定冻结在 `t=0`；原V2 `t>1.75s` 的 Dock 播放图标上移 **5px** 被有意省略。这是超出原返工 Gate 的默认≤3px动态锚点差异，**需要Owner在正常观片后明确接受“独立UI演示冻结底座”还是要求复用 V2 实时时轴**。不能写“100%像素等价PASS”。
- 新增 Finder资料窗和额外UI chrome是模拟系统界面，不存在原 V2 每项一一对应的真实窗口布局基线，不能以仅色彩相近替代Owner审美判断。若未来进入正式A段，要检查文字大小、对比度、图标被窗口部分遮挡等在手机尺寸下的阅读效果。
- 桌面复用和模拟鼠标主要针对独立 Demo 的 A 阶段；MW04虽然模拟 B 全幅播放器，但它仍只是UI占位，**不意味着正式研究素材暂停、可商用源视频下载、配音字幕、G1视觉通过**。

## 4. 当前证据限制与Owner验收前置条件

1. **5条 WebM 并非完整墙钟时长的高保真实时屏录**：独立 FFprobe 报告时长约 **3.396 / 3.998 / 6.088 / 4.563 / 5.312 s**，短于1×标称 **3.500 / 5.033 / 6.467 / 5.333 / 5.733 s**，尤其 MW02 缺末尾约1.035s，MW04短约0.770s。录屏压帧/启动停止时间差均可能影响证据，**不能拿这些WebM单独证明五项完整流程全部实时录到了结尾**；独立浏览器完成到终帧的技术证据与关键帧弥补了可执行性，但不能替代Owner完整观看感受。
2. `file://` 直接导航：当前受限Chromium阻挡 `ERR_BLOCKED_BY_ADMINISTRATOR`，所以Reviewer使用 `page.set_content` 运行实际HTML，零网络请求。Owner须在 **Windows Edge 双击下载的index.html** 做一次独立真正的file://导航/播放/Reset验证，不能冒认 file_url PASS。
3. 正常速度视觉观感：Reviewer看了五条WebM实录的分时截图/主要动作关键帧，能判定操作链成立、MW03切换看得出，但没有真实Owner的持续审美签收。**所有KEEP仅Reviewer候选，不是Owner KEEP/PASS**。
4. MW-04“暂停”和MW-05“进度”的 UI Demo 可以作为积木保留，但正式B仅批准2转场、4布局、6信息呈现，新的“时间控制/额外界面动效”绝非默认获准。需要Owner另决定它们是否有观看价值或DROP。
5. 旧版 `RETURN_VISUAL_REJECTED_ALL_FIVE` 不删除/改写；新V2结果记录为新一期的候选复核。**第二批Spotlight/Exposé/DockGenie/拖拽仍暂缓**，直到Owner实看完成并选择下一步。

## 5. 下一步与 Owner 实看问题（仅三个动作）

1. 下载并双击新版 `index.html`，**先在1×播放完五项**，对比旧版流畅度/布局；再看 MW-03 在前景 B时点击露出的 A，并切回 B，查看自然转换是否满意。
2. 是否接受“新独立演示的桌面动画静态冻结在V2第一帧（Dock 播放图标5px例外）”，或要求完全随时间复用 V2 动画。
3. 对 **MW01、MW02、MW03** 给 `KEEP/HOLD/DROP`，对 **MW04、MW05** 决定继续仅作离线 UI Demo还是 `DROP`。此选择仅是独立动效库收敛，不自动授权正式视频集成或升级 G1/G2。

**总结：`EXECUTOR_DEMO_READY` → `REVIEWER_REALTIME_TECH_PASS` / `MW03_REAL_SWITCH_PASS` → `OWNER_VISUAL_SIGNOFF_PENDING`。正式视频 / M2 / G1/G2 当前状态不变。**
