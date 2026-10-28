# G4A｜视觉小样实际执行与审核记录（2026-10-28）

> 本报告为可复核执行记录，不是并行项目状态。当前状态参见 [唯一 Handoff](../REVIEWER_HANDOFF.md)。
> 本次仅对应 G3 的 AV10→AV11→AV12 / P2 动效；三用途拆分 P1 尚未执行；非全片生产。

## 实际产物

- **正式可重建源码**：[五阶段动效 g4_network_availability.html](../prototype/g4_network_availability.html)，单一 HTML 文件，离线无外链字体、无在线图片/音频/第三方 JS；屏幕内自带播放、暂停、重播、进度控制；完整画布 1920×1080 并按浏览器窗口缩放。
- **使用说明**：[prototype/README.md](../prototype/README.md)。
- **实际执行沙箱文件**：`/mnt/data/macmini_g4/index.html`；实际真实 Chromium 画面截图 `screenshots/S0.png` 至 `S4.png`；`g4_static_fallback.png`；导出 `macmini_g4_visual_prototype.mp4`；交付 ZIP `/mnt/data/macmini_g4_deliverables.zip`。**本轮 GitHub 持久化的是 HTML 源码和本文档/README；二进制 MP4/PNG/ZIP 通过当前会话沙箱交付，尚未归档为 GitHub 二进制文件**。勿在未来会话中假设沙箱路径仍存在，必要时从 GitHub HTML 重建。
- 代码复现：Chromium 离线渲染单页；Playwright `page.set_content` 测试（沙箱拒绝 `file://` 导航）；打开页面后默认自动播放，`window.seekDemo(seconds)` 可测试状态。
- 无需设备、不依赖用户私有文件或账号；不调用收费生图/视频生成。

## 实测环境与验证

| 检查项目 | 执行方法与结果 | 范围判定 |
|---|---|---|
| 源码实际执行 | 系统 Chromium + Python Playwright `set_content` 加载 HTML；JS `pageerror = []` | PASS（此容器执行环境） |
| 状态 | 逐一 `seekDemo(1.2/5.4/9.7/13.8/17.5)` 获取 `s0/s1/s2/s3/s4` | PASS |
| 可视截图 | Chromium 导出 S0–S4 各 1600×900 PNG；复查 S2/S3/S4 的“假设”文字、网络节点、结论与字界 | PASS（机器/视觉审查；非真人盲测） |
| 宽高与缩放 | 1600×900 截图；改视口 1280×720 后舞台缩放为 1280×720 | PASS |
| 视频导出 | 由真实浏览器动画在实际墙钟时间采集 240 JPEG 帧，12fps，FFmpeg H.264 MP4 30fps（重复帧升帧） | PASS |
| MP4 元数据 | `ffprobe`：1600×900，H.264，30/1fps，20.000s，约 711008 bytes | PASS |
| 文案/画面真假 | “Mac mini 运行”明确是示意；断网标“假设”；4W 明示“闲置”，未写真实电费或故障频率 | PASS_WITH_SCOPE |
| 官方事实 | Apple [功耗技术支持](https://support.apple.com/zh-cn/103253) 指定 M6 16GB / 256GB 闲置 4W；Cloudflare [Pages 限制](https://developers.cloudflare.com/pages/platform/limits/) 限定静态托管，不代表任意后端免费 | PASS_WITH_SCOPE |
| 外部视觉授权 | 所有形状、图标、流程图为自制，不嵌 Apple/Cloudflare 他人截图/商标或第三方视频；品牌名与数据以来源事实引用 | PASS_WITH_SCOPE；未来公开发布仍需逐项复核 |

### 五阶段结构核对

| 状态 | 逻辑 | QA |
|---|---|---|
| S0 | 用官方功耗数据引出“4W 闲置”与负载功耗的区别 | 确认注明机型、配置与闲置限定 |
| S1 | 访客→互联网→家庭网络→Mac mini→网站，访问依赖链建立 | 解释性示意，无虚假实测 |
| S2 | 仅假设家庭网络断开、Mac mini 仍运行、访客不可经该路径访问 | 是“假设”，没有虚假故障记录 |
| S3 | 对照独立静态站托管链，Cloudflare Pages 只是示例 | “静态站 ≠ 任意后台服务” |
| S4 | 开机时间 ≠ 网站可用时间 | 核心观点可在无旁白的静态画面读懂 |

## 对照与返工

- **第一版视觉 QA 发现**：S3 静态托管替代路径与底部核心数字存在排版重叠；已隐藏 S3 原核心数字区域，改为左侧“换一种目标”解释 + 右侧托管路径，并以视频关键帧验证修复。
- **无声音静态退化**：S2 截图即独立可用的单图解释；动态演示增加“访问链先正常、再假设故障”的前后对照，但“动画更易懂”仍是创作假说，未通过真实观众盲测。
- **缺少 HTML file:// 本地双击实测**：执行沙箱的 Playwright 对 file:// 导航会返回 `ERR_BLOCKED_BY_ADMINISTRATOR`；随后使用 `set_content` 完整执行 HTML。用户 Windows 本机双击路径未验证，不可宣称已通过。
- **缺少真人观众/配音 QA**：没有配音、声画同步或真实使用体验调查；视频仅是 20 秒无声视觉技术小样。

## 明确未完成项

1. `P1 / AV04-AV05` “一台设备→三种需求”视觉小样尚未落地。
2. G3 要求的真正素材搜集（Apple 2024/2026 价格卡等）尚未形成具体媒体资料库，仅保留官网出处文本。
3. 用户解说小人、字幕、实际声音、整片镜头/音效仍待 G5，不得因本轮 MP4 就宣称完成整期视频。
4. 影像文字、最终版权与发布时最新事实，仍待制作后最后检查。

## Reviewer 范围判断

`G4A_P2_AV10_AV12_PROTOTYPE = PASS`：已执行且实际检查可播放五状态动画、可见关键假设、可导出视频，并提供静态方案；**并不意味着整个 G4 完成**。项目 Gate 保持 G4，下一步先解决 AV04/AV05 P1 核心三用途解释画面及素材可持续归档，再决定是否跨到 G5。

### 证据标识与可复核性

- `HTML_SHA256 = c98bcce8678fe17f...`（实际容器计算，须重跑 SHA256 取得完整值）。
- `MP4_SHA256 = bb98b7c355014057...`（同上）。
- `STATIC_SHA256 = 01c464861fed1863...`（同上）。
- `FORMAL_MEDIA_ARCHIVE_IN_GITHUB = NO`。
- 实际源码 GitHub 的精确内容已通过 fetch_file 回读一致。Reviewer 应检查文档状态与证据是否一致，不得用报告冒充媒体真实性。
