# CWS yt-dlp 本机可执行文件存在性预检｜Owner 转交的 Codex 回读

> **日期：2026-10-11** · **性质：EXECUTOR_SELF_REPORT / OWNER_FORWARDED**  
> **Gate 结果（Executor）：RETURN_TOOL_NOT_PRESENT**  
> **Reviewer 对证据的判断：已收到状态回报，实际原始 PowerShell 日志未提交，未独立在 Owner Windows 重跑；因此仅记录工具缺失的本次报告事实，不签发下载能力 PASS。**

## 请求与实测范围

本次是从 CWS 3＋1 素材合同衍生的低风险存在性预检。用户把本地 Codex 的结果逐项转交给 Reviewer；没有提供原始 PowerShell 文本附件、机器文件或持久化日志，不能将其升级为 `DIRECT_READBACK`。该结果属于 `OWNER_REPORTED` 的本地 Executor 输出。

## 报告原样事实（忠实摘录、不补全未知）

- 结果：`RETURN_TOOL_NOT_PRESENT`。
- `yt-dlp`：`Get-Command` 未找到可执行命令；未得到版本或可执行路径。本机其他不在命令查找路径内的副本未被全面排除，因此准确表述是**这次 PowerShell 可执行环境中不可调用**。
- `ffprobe / ffmpeg`：版本为 `9.0-full_build-www.gyan.dev`，两者版本命令退出码均 `0`。
- yt-dlp 网页元数据解析：**NOT_RUN**。
- yt-dlp 真正文件下载：**NOT_RUN**，无文件路径、大小或 SHA-256。
- 下载结果的 FFprobe/FFmpeg 解码：**NOT_RUN**。
- 没有安装工具、访问网络、下载文件、更改系统/VPN/代理、修改 M2，亦没有创建测试目录；不存在清理动作。
- 进程预检发现 Edge 进程，但不能据此确认是否有 Remotion/M2 渲染任务运行。
- 仅有 Codex 当前会话的 PowerShell 预检输出可供 Owner 查看；**未提供可供 Reviewer 独立读取的落盘日志**。

## Reviewer 状态与下一门禁

- `YTDLP_TOOL_IN_PATH=NOT_FOUND_OWNER_REPORTED`
- `YTDLP_METADATA=NOT_RUN`
- `YTDLP_REAL_DOWNLOAD=NOT_RUN`
- `YTDLP_MEDIA_DECODE=NOT_RUN`
- `YTDLP_GATE=RETURN_TOOL_NOT_PRESENT`
- `YTDLP_INSTALL=NOT_AUTHORIZED`
- `M2_SCOPE=UNCHANGED`
- `G1_NOT_PASS / G2_NOT_AUTHORIZED`

若 Owner 希望验证真正下载能力，则后续须**单独批准安装或提供既有工具路径**，并按独立 Gate 做合法小样本、URL提取、真实文件与解码核验。无须重验 Edge 3/3 已播放事实，也不能因这次工具缺失判定下载网络故障。不能自动安装、不能在 M2 任务里插入下载步骤。

## Evidence provenance

唯一来源：Owner 在 ChatGPT 2026-10-11 会话逐项转交的 Codex 文本结果；对应客观本机日志不可用。前置历史背景：`docs/P4_G1V_SOURCE_SCREENING_READBACK_2026-10-11.md`（G1V 时 Edge 播放3/3、yt-dlp 当时缺失）。
