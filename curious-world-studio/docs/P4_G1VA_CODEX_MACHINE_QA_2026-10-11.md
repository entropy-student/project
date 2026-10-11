# 机器 QA 摘要（Codex 原始附件）

- 产物：7.000 秒；1920×1080；H.264；30/1 fps；210/210 帧；最终 MP4 只有 1 个视频流、无音轨。
- FFprobe：见原附件 `qa/ffprobe-final.json`。
- 全片 FFmpeg 解码：exit 0；日志无解码错误。
- `blackdetect=d=0.03:pix_th=0.10`：无黑段/黑帧命中。
- FFmpeg framemd5：210 帧，209 个唯一帧哈希（含桌面停留中的一组重复帧，符合设计）。
- 8 个事件关键帧从最终 MP4 重抽后，与保留 PNG 的 SHA-256 均一致。
- 浏览器 Headless Shell：渲染前/后 SHA-256 相同；Remotion 编码出的 AAC 经 `volumedetect` 为 -91 dB，已留存原始渲染文件，并对 H.264 视频流无损 remux 去掉音轨。
- 旧 R1、R2 MP4 SHA-256 与先前报告值相同；旧 OpenMontage staging 均仍在。
- 本机 Edge 拒绝 `file://` 浏览，未尝试其他方式；全片常速真人审看尚待 Owner 完成。
