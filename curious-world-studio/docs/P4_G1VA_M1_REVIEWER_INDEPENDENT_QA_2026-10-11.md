# P4-G1VA-M1｜真实测试 MP4 媒体适配：Reviewer 独立验收（2026-10-11）

**决议：`M1_REVIEWER_TECH_PASS_ONE_FIXTURE / OWNER_VISUAL_REVIEW_PENDING / G1_NOT_PASS / G2_NOT_AUTHORIZED`。** 这不是 M1 对任何尺寸/帧率的通用适配承诺，也不是 B 的科研内容制作及 G1 整片视觉通过。

## 1. 本次证据和真实性

本机 Codex 的隔离运行目录：`C:\Users\34707\AppData\Local\Temp\cws-g1va-v2-media-m1-run-20261011-y4k2m8`。未通过 GitHub 提交，Owner 将 **54个 ZIP entry**（其中多个目录项）打包上传到 Reviewer 当前会话。Reviewer 实际解压检查完整 ZIP，**独立读取真实 MP4、输入夹具、字幕与原型对照不涉及**。

| 核对项 | 独立证据 |
|---|---|
| 最终 MP4 | `out/cws-g1va-v2-media-m1.mp4`，`SHA-256 d1e25a34ad41ba87a8e7ee836c4f44a54d39ac52c511861f350e340da6ba2516`，497,395 bytes |
| 视频探测 | H.264，1920×1080，30/1fps，9.000s，270帧，无音轨 |
| 机器解码 | Reviewer 本容器 FFmpeg 从头解码到尾 exit 0；`blackdetect=d=0.05:pix_th=0.10` 无黑段日志 |
| 逐帧唯一性 | Reviewer 用 OpenCV 抽出 270/270 帧、按像素计算 MD5，270个不同帧 |
| 实际输入 MP4 | `assets/local-demo.mp4`，SHA-256 `bc6f92d9ad4e422e6bbcf432dc65bcf340c6fd30998e1211b773cc5a510403b3`；H.264、1920×1080、30fps、6.000s、180帧、无音轨。系本地自己生成的移动几何色块，并非原研究录像 |
| poster | `assets/source-frame-000.png`，SHA-256 `1889c527f22723313cfd90fac2079db75dc97f84abe7614a735b16e54a746aa7`；Reviewer 独立解码源视频第0帧与 PNG **逐像素完全相同**，最大像素差0，非近似绘制的海报 |
| 冻结验证 | Reviewer从最终 MP4 4.400s与4.733s取出内容区比较，灰度 SSIM约`0.999978`；两点与源第0帧的灰度SSIM`0.99747–0.99748`（编码/缩放导致非100%像素相同），未发现素材提前播放 |
| 真播放验证 | 最终 MP4 5.767s 对应源视频第30帧/1秒，灰度 SSIM约`0.99736`；对播放前静止内容 SSIM约`0.9338`，确认出现真实帧变化 |
| 素材时间与进度 | `episode_timeline.json`：第143帧/4.7667s开始素材播放，原视频6s进度在第173帧/5.7667s≈1/6；不错误地按9秒整片总时长计算 |

说明：上面使用的是 Reviewer 重新生成的**灰度SSIM**和 OpenCV FFmpeg 提取，算法与 Codex 原报告里的 FFmpeg YUV `All` SSIM 略有差异（原报告首帧0.987784、播放1s 0.978587、暂停稳定0.999622）。不能把两种度量直接当成“一次运行的完全同值”。两组各自都支持相同的“真的加载了源视频”的判断。FFmpeg 检测无黑段不意味着电影化视觉品质已通过。

## 2. 视觉对照：并非重新设计 UI

Reviewer 与历史 [已选 V2 真实 MP4](../p4-g1/visual-reference/README.md) 相同时间点（0.3、1.5、2.2、3.25、3.5、4.4、4.73、4.77、5.77秒）进行逐帧并排观察：
- 保留 Research Aqua 蓝色桌面、文件图标与 Dock/菜单栏位置；文件被选中、双击反馈、播放器从文件点弹出、绿色窗口全屏、鼠标到播放控件。
- 最终 B 区替换为**真实 MP4 文件**播放；有 `LOCAL TEST MEDIA` 与 `示意画面` 标签，未用论文 Fig.7/8 拼图，不冒充原科研录像。
- 开窗暂停先显示从 `local-demo.mp4` 提取的原始首帧，而不是另一张自行绘制的类似海报。播放按钮之后才推进。
- **Reviewer 对代码行为与观测画面作了独立对照，但 Owner 尚未对这条新的 M1 实际 MP4 常速完整观看**。不能从此文自动推定“Owner 最终满意”。

尤其检查 `src/ResearchAquaMediaAdapter.tsx` 使用归档的**相同 V2 HTML**：固定已知 Git blob `acb0ee80264527bd11160e0ae277ce24528c4a03`，通过 iframe `srcDoc`、`renderAt` 和单独 `OffthreadVideo` 层结合。Codex 没有凭截图另画 UI；小范围 HTML patch 仅修改素材时钟、内容槽位和占位标签。Runner 保护已用 stage/out，明确指定审批缓存中的 Chrome Headless Shell，记录版本与 SHA。可复核代码详见 [M1 稳定代码目录](../p4-g1/m1-media-adapter/README.md)。

## 3. 仍然存在的工程缺口，不可隐瞒

1. **单输入适配不是“多素材量产”**。只实际跑过 `1920×1080/30fps/H.264/6秒/静音` 的本地测试视频；没有验证竖屏、4:3、24/25/60fps、可变帧率、其它编码、任意时长或带声音 MP4。当前 Remotion `Sequence durationInFrames` 与 `OffthreadVideo endAt` 直接使用素材帧数，遇到素材 FPS 与输出30不同需要另做具体时长转换和测试。
2. **定值耦合**：原型外壳固定9秒/270帧、文件名替换为 `LOCAL-DEMO.mp4`、默认 Test Fixture 命名与硬编码测试进度锚点；下一轮应以配置参数代替，无需改动 V2 UI 外观。
3. **第一帧防错需要持续**：该次源视频首帧与海报经独立逐像素验证；但 Runner 仅通过外部事后 SSIM 检查，不是一个支持任意新输入时都预先保证 poster 来自该文件的不可绕过门禁。应保留 poster/media 双重SHA和一致性预检。
4. **B 的叙事效果尚未设计**：移动几何色块只属于测试片。它不能证明替代素材选取、镜头感、研究事实表达、剪辑节奏、合法重用或正式频道风格达标。
5. **静音**：输出没音轨，M1 QA 不涉及真人配音、音画/字幕对齐；G1R2已证明过基本音频合成，但质量较差不等于本次有新音色结果。
6. **UI未做新一轮 Owner 审看**：Reviewer 可确认与选定 V2 相似，不自动替 Owner 签发最终主观视觉 PASS。
7. 本轮 CI、Windows 实机 Remotion 重渲 Reviewer 本人**未执行**。浏览器版本/哈希、无下载等安装边界按 Codex 实际日志/本地报告采信；Reviewer独立验证的是用户上传的输出字节和实现代码。

## 4. Scope / 权限 / 数据整理

- 本次仅审查一个 G1V-A 的**真实文件输入技术 Gate**，不用研究原视频。Owner 之前已决定默认改用可合法使用的替代素材或标 `示意画面` 的自制视频；既有论文仍支持科学事实，不能把自制示意冒充原始研究录像。
- 代码有 GitHub 记录，包含 `ResearchAquaMediaAdapter.tsx`、`entry.tsx`、`render_m1_windows.ps1`、`generate_test_fixture.ps1`，与上传 ZIP 对应文件已用 Git blob SHA **逐字节核对**。源码不能和压缩包内二进制占位 MP4 混淆；视频原始 SHA 在本报告中存证。
- **不提交本机浏览器可执行文件、项目 staging、Windows TEMP MP4、私人工作目录下的缓存、外部 YouTube 内容到 GitHub**。有需要时 Owner 可重新提交 ZIP；当前会话内已提供 MP4 链接供播放。
- R1/R2/旧 Codex 7秒/选定 Assistant V2 原视频历史产物不覆盖。`G1_NOT_PASS` / `G2_NOT_AUTHORIZED`。
- 交接 Gate：`M1_REVIEWER_TECH_PASS_ONE_FIXTURE / OWNER_VISUAL_REVIEW_PENDING`。下一步建议先请 Owner常速完整观看此 M1；通过后对**非研究来源、权利可核验**的第二种素材尺寸/FPS做受控适配测试，或进入单独的 B 动态素材表达原型评估。不是自动进入 G2。
