# yt-dlp 第二轮：Blender 直链与 YouTube 元数据请求失败｜Reviewer 独立材料复核（2026-10-11）

**本轮支线执行结果**：`RETURN_REMOTE_DISCONNECTED`。  
**已验证边界**：现有 yt-dlp 安装证据继续成立；**直接视频下载未通过、网页解析未通过、无视频文件、FFprobe/FFmpeg 解码未运行**。不能把“Blender HEAD HTTP200”当成“视频可以实际下载”。  
**与主线隔离**：主线正在执行 Owner 已另行发出的 M2-F2 测试，据 Owner 本轮消息**结果尚未返回**；本轮支线没有改变 M2/G1/G2 的正式状态，也没有进行生产前清理。

## Reviewer 直接读取的 Owner 上传文件

| 文件 | 沙盒独立算得 SHA-256 |
|---|---|
| `report.txt` | `04b4c82d1d7f522aa0957caea3c1165a11a60e15503e6539ed6a9d3cbbbc8c83` |
| `direct-download.stdout.txt` | `6ce33e86e1c7e95ce27db8ea557554f25bc162e2c127d5d6e523f7d85111b103` |
| `page-extraction-result.json` | `efa66664e8af5122ad36ce8da9e6aec3c954493f63f296e9000a7d60d4f8cbea` |
| `environment.json` | `5a18fec976a34aaa1b71f140b7cf955a77bf25952d218a5fb5d8f053a0269048` |

Reviewer 直接读取以上四个附件并算 SHA；**未取得原 Windows 测试目录里提到但未上传的 `direct-head.json`、`direct-download.stderr.txt`、`direct-download-command.json`、`page-extraction-command.json`、页面完整 sanitized 输出、final-inventory**。因此 HEAD HTTP200、直接下载错误 stderr 和实际完整命令及输入标志属于本机报告事实；YouTube `RemoteDisconnected` 的若干错误行则确实包含在上传的 `page-extraction-result.json`。Reviewer 未连接 Owner Windows 进程或网络出口。

## 本轮具体结果

- 使用旧已安装的 `yt-dlp.exe 2026.08.19`，本机 Codex 报告 `--version exit 0`、预期 SHA 匹配；Reviewer 本轮**未直接重新读取 Windows EXE**。无需重装。
- 测试源一：`https://download.blender.org/durian/trailer/sintel_trailer-480p.mp4`。Owner 报告 PowerShell **HEAD** 响应 HTTP200、`video/mp4`、`4,372,373` B，能说明该 URL 对 HEAD 的响应状态；**不能证明 GET 成功、正文能下载、yt-dlp 使用同一网络/代理路径**。上传的 stdout 仅显示 `[generic] Extracting URL` 与 `Downloading webpage`，报告称下一步 `RemoteDisconnected`，exit 1；媒体落盘数为零。
- 测试源二：Blender 官方 YouTube 预告片 `https://www.youtube.com/watch?v=HOfdboHvshg`。上传的 extraction-result JSON 显示 `exit_code=1`、`json_received=false`；网页请求及 API 页均 `RemoteDisconnected`，一次重试后停止。**未取得视频元数据，更谈不上下载媒体**。
- FFprobe、FFmpeg 全片解码及三帧抽取均 `NOT_RUN_NO_FILE`，没有可提交的媒体文件 SHA256。
- Blender 官方 Sintel 使用 CC BY 3.0、适用署名及不同用途条件由 Owner 报告并指向 `https://durian.blender.org/download/` 与 `https://durian.blender.org/sharing/`；此次**未重新独立查验外部许可网页，也没有媒体文件作许可适用的最终审核**。
- Owner 报告未更改 VPN、系统代理、DNS、防火墙、PATH、FFmpeg、M2 源码、安装目录和旧测试证据；前后无匹配 M2 渲染进程仅限检查时点。

## Reviewer 判断

1. **不是安装问题**：安装/二进制完整性已有充分本机自检与此前官方 digest 比对。
2. **失败现象跨多个网站**：Wikimedia、Blender 及 YouTube 的某些 yt-dlp 请求出现过连接中断，但不能因同形错误直接确诊为 VPN/代理或 yt-dlp 程序错误。
3. **需要同请求方法对照**：HEAD 请求成功与 GET 下载失败不是等价试验。缺少 PowerShell 对**同一 Blender URL 小体积 GET** 的成功/失败状态，以及 yt-dlp 实际调用参数与脱敏 stderr，尚不能判断应用 HTTP 栈差异、系统代理继承还是服务器不同请求处理。
4. **停止盲目扩网站**：不再更换更多第三方视频源进行泛化尝试。后续如需诊断，优先采用一轮**相同 URL、同一请求方法、严格小流量、原始记录可审**的路径对照；不要默认更改 VPN、Clash、WireGuard、系统代理或 Cookie。
5. **当前结果保持 RETURN**：`YTDLP_DIRECT_DOWNLOAD=FAIL_REMOTE_DISCONNECTED`、`YTDLP_VIDEO_PAGE_EXTRACT=FAIL_REMOTE_DISCONNECTED`、`YTDLP_MEDIA_DECODE=NOT_RUN`；**不影响主线已通过候选 MP4 的文件 QA，也不影响研究/剧本及 OpenMontage/研究一手素材准备**。

## 最小后续选项（未授权新执行）

先等主线结果；支线如继续，需 Owner 新授权单独诊断**同一 Blender URL 的 HEAD 与小体积 GET 请求差异**，仅在合法、低流量且未经明确限流情况下发起一次限定范围 GET（可用 Range 0–1023，拒绝 Range 则不得整段意外下载），比较 Windows PowerShell 与 yt-dlp 的请求路径、错误级别和代理**配置存在性/类型**（不披露值或更改设置）；保留脱敏的真实命令与 stdout/stderr/退出码。若出现 429/403、远端拒绝或超出请求配额，立即 STOP。此选项是下一步**计划，不是现有授权下自动开跑**。

先前选择的正式素材默认 **16:9 横屏**，正式生产前受控清理仍只是计划/未执行，3+1 多渠道不因下载工具暂时失败而废止。
