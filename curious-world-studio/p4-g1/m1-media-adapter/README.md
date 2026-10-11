# G1V-A-M1｜已实测的 Research Aqua 单视频文件适配器

## 证据与状态

**唯一状态**：`M1_REVIEWER_TECH_PASS_ONE_FIXTURE / OWNER_VISUAL_REVIEW_PENDING / G1_NOT_PASS / G2_NOT_AUTHORIZED`。

本目录来自 Windows Codex 已真实执行的隔离 M1 试验：把已锁定的 [Assistant V2 Research Aqua HTML](../visual-reference/g1va_v2_research_aqua_prototype.html) 作为视觉真源，通过 Remotion iframe + `OffthreadVideo` 载入一份**真实本地自制测试 MP4**。并非重新绘制 UI，也非原论文视频/合法商业素材自动获取器。Reviewer 读取最终真实输出并独立验证首帧和播放时序，详见 [独立 QA 报告](../../docs/P4_G1VA_M1_REVIEWER_INDEPENDENT_QA_2026-10-11.md)。

| 已验证的媒体数据 | 结果 |
|---|---|
| 真实测试资产 `local-demo.mp4` | 自制移动色块 H.264, 1920×1080, 30fps, 6.000s/180帧，无音轨，SHA `bc6f92d9ad4e422e6bbcf432dc65bcf340c6fd30998e1211b773cc5a510403b3` |
| poster `source-frame-000.png` | 通过 FFmpeg 从同一原视频第0帧获得，SHA `1889c527f22723313cfd90fac2079db75dc97f84abe7614a735b16e54a746aa7`；Reviewer已逐像素比对原视频首帧 PASS |
| 最终演示 MP4 | 9s, 1920×1080, 30fps, 270帧无音轨，SHA `d1e25a34ad41ba87a8e7ee836c4f44a54d39ac52c511861f350e340da6ba2516` |
| 首帧冻结 | 播放前第132、142帧画面基本一致；素材仍为第0帧 |
| 播放起点 | 第143帧 = 4.7667s；播放后30帧/1s对应源视频第30帧，内进度用实际6s素材时长 |
| 渲染环境 | OpenMontage Remotion 4.0.484 + 显式指定已批准 Chrome Headless Shell 149.0.7790.0（本机自报 SHA检查） |

## GitHub 中保留的真实源码

- `ResearchAquaMediaAdapter.tsx`（原代码 blob `bc20a83cbbf84a697dcf19679343b3a15d3bce9a`）
- `entry.tsx`（`e79a58f37b4d62ee03b372fc379b880edb0bd00e`）
- `render_m1_windows.ps1`（`bb4284c43f7a374ba6e8071166286d7e159c58b2`）
- `generate_test_fixture.ps1`（`ffb01ec91f05a3389c7e47d750c86252685a95ff`）

以上四个 Blob SHA 与 Owner 本轮上传的工程 ZIP 源文件完全一致。选择 `srcDoc` 载入 V2 原版视觉 HTML，然后最小修改动态时间和内容槽：真正的源 MP4 先以视频自身第0帧当暂停图，再通过独立 Remotion `Sequence` 触发播放。没有为本轮臆造新的高级苹果系统 UI。

## 对未来复用的重要限定

- 目前 PowerShell runner 期望一个固定文件名 `assets/local-demo.mp4`，并明确要求单视频轨/无音轨、已认证浏览器缓存和完全新的输出/staging 路径。**不允许用这份脚本原样跑任意外部视频并声称多格式都支持。**
- 源视频帧数 `assetFrameCount` 被用于 `Sequence durationInFrames` / `OffthreadVideo endAt`。对和输出30fps不相同的源视频、时长大于这段9秒外壳、不同画面比例、音轨、变帧率、循环/截断等，**都需要在独立新 Gate 做正确的时间单位转换和真实抽帧 QA**。
- Runner 的 `git hash-object` 检验锁定当前 V2 HTML blob；视觉源变更需审核，不能静默追最新文件再导致样式漂移。
- 正式每一期还需 **媒体权利、素材时间与旁白/SRT对齐、镜头含义、画面标识、素材选择** 的独立合同。默认不用研究原视频、Fig.7/8拼图不能作为主画面，自制示意不得标为原始科研证据。
- Chrome 运行时下载或升级、改动 Windows/已有 OpenMontage 工程、启动付费服务、覆盖旧 Gate 成品及 G2/G3 都没有获当前阶段授权。

## 再现这次测试（仅在明确批准且环境已具备时）

1. 在**新的隔离工作目录**预先检查生成 `assets/local-demo.mp4` 的唯一性；可用已存在的 FFmpeg 运行 `generate_test_fixture.ps1` 得到视频与第0帧海报。
2. 从 main 取得已选 V2 HTML，不修改其源，准备已核准的 Chrome Headless Shell EXE 绝对路径和未用过的 `cws-g1va-v2-media-m1-*` stage slug。
3. 运行 `render_m1_windows.ps1`；禁止 NPM安装、npx联网、自动下载 Chrome 或覆盖现有 `out`。
4. 记录 `input_manifest.json / episode_timeline.json / machine_qa.json / ffprobe.json`、源文件和产物哈希，并提交独立 MP4 供 Owner 常速观看验收。

注意：此次代码已在 Owner 电脑运行过，但在本次 Reviewer 环境中**只做了上传 MP4/源码的独立读验，未重跑 Windows PowerShell/Remotion 渲染**。
