# M2 视频与执行证据 Reviewer 复核（2026-10-11）

**Gate**: `P4-G1V-A-M2_VARIANT_MEDIA_INPUT`  
**本轮判断**: `RETURN_UNDIAGNOSED_RENDER_FAILURE`，保留已有两支视频的**候选文件 QA PASS**。**G1_NOT_PASS / G2_NOT_AUTHORIZED**。  
**Evidence provenance**: Reviewer 在当前沙盒**直接读取** Owner 实际上传的 2 个 MP4、`g1va_m2_source_diff.patch`、`execution_report.md`、`final_artifact_manifest.json`、`m1_render_failure_diagnostic.json`、`reviewer_round2_return.md`、`rollback_plan.md`。其余 Windows 本地 `source.mp4/poster.png`、stage 输入和 render logs 没有随附件提供；对它们仅能引用 Owner/Codex 上报，不冒充独立核验。GitHub 实机也并非用户 Windows 机器。

## 独立直接检查（2026-10-11）

| 检查 | landscape_24 | portrait_30 |
|---|---|---|
| 上传文件 SHA-256 | `ee17fa80e20750fe33ef746864333519d7af4d09921893566b687e8ef361b440` | `2671e6959f26a86e0c4df74fa95580bc9346402339091b59b4949be82bec49da` |
| 完整哈希与清单 | 匹配 | 匹配 |
| ffprobe | H.264 1920×1080, 30/1 fps, 9.000s, 270 frames, 1 video/0 audio | 同左 |
| 文件大小 | 668,797 B | 594,510 B |
| FFmpeg 全片解码 | 成功 | 成功 |
| `blackdetect=d=0.05:pix_th=0.10` | 无命中 | 无命中 |
| 抽查 0/1.2/2.2/3.0/4.4/4.8/5.8/7.8 秒 | 可见桌面→小播放器→放大→B 全屏→彩色运动测试内容推进 | 同序列，B 内竖屏素材居中 contain，未见拉伸或明显裁切 |

以上只证明所上传**输出文件**的真实媒体属性与可见动作。因**原始输入 source.mp4、poster.png、逐帧源对照日志及实际 remotion render.log 未作为附件上传**，无法在 Reviewer 当前环境独立重算 frame0 poster 的像素一致性、输入原始 FPS/时长、源画面帧差，或审计 Windows 进程/缓存。所报告的逐时刻 SSIM、source frame ±1、poster 源首帧像素 PASS 是本机执行报告事实，**不是本轮 Reviewer 独立检查事实**。

源码补丁 SHA-256 `4c5df1ad6a5acea1f74fa26f76d9038d0d7e62b48a1b98c2bd8a678392554482` 与 manifest 匹配。独立 `git apply --stat` 识别**恰好五份** `curious-world-studio/p4-g1/m1-media-adapter/` 内文件（1 个现有 React TSX 修改、4 个新增 PowerShell 工具）；已检查关键兼容逻辑与 FPS 输出帧换算。没有据此宣称 Windows TypeScript 构建或端到端源帧对照在 Reviewer 本机重新通过。

## 关键 Return 原因（不能自动抹去）

Owner 转交的原本地报告与事后 `reviewer_round2_return.md` 记录：旧 M1 runner 的**首次回归**在输出第184帧因 `No frame found at position 20992` 失败；Executor **未先定位故障就新建 stage 再渲染**，违反 Gate 原文 `STOP/no blind retry`。后一次回归生成的输出 SHA 完全匹配历史 M1 `d1e25a34ad41ba87a8e7ee836c4f44a54d39ac52c511861f350e340da6ba2516`（本轮未上传这份回归 MP4，属于报告结果），无法追溯消除第一次操作偏差。

后续只读排查报告：源视频与两次 stage 相同 SHA，源 frame41 在本机独立 FFmpeg 解码成功，排除源帧本身丢失/损坏的假说；但 Remotion 临时媒体拷贝或帧抽取路径的实际失败原因仍**UNKNOWN**。Reviewer 当前尚未拿到首次失败 `render.log` 与 `remotion-assets-dir` 的可审原始片段，不妄下结论说是缓存、线程、网络或源视频问题。

**决定**：两支输出视频保留为可复用/可观看的 `PASS_CANDIDATE` 证据；**正式 M2 Gate 为 RETURN，不合并 M2 源码补丁进 main，不重测 M1/G1，G2 尚不得启动**。原始本地工作树、两个候选 MP4、失败/成功 stage 和报告按回滚计划先保留，不清理；新 `yt-dlp` 独立安装测试的授权与结果状态不因此改变。

## 最小下一步

执行新 [M2 首次渲染失败只读诊断 Gate](../p4-g1/LOCAL_CODEX_M2_M1_RENDER_FAILURE_READONLY_GATE_2026-10-11.md)（只读，**不渲染、不重试、不安装、不改码、不清理**）。至少需要保留并抽查初次失败的原始 render.log、临时媒体 URL/path 与重试成功日志对应位置；如果仍无根因，保留 UNKNOWN 和具体证据缺口，交 Reviewer 决定是否另批**一次**受控排障，或显式关闭本失败门禁并对生产稳定性单独留风险，不能无限追加验证。历史 Gate 失败重试已发生，不能改写为符合原 STOP。
