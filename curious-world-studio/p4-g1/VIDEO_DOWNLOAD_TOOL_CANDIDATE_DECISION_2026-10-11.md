# P4-G1V｜视频获取工具候选决策（2026-10-11）

**状态：OWNER_ACCEPTED_AS_CANDIDATE / READONLY_SCREENING_IN_PROGRESS / TOOL_NOT_INSTALLED_OR_TESTED_BY_REVIEWER / VIDEO_DOWNLOAD_NOT_AUTHORIZED**

## 决策

Owner 同意未来优先评估 [yt-dlp](https://github.com/yt-dlp/yt-dlp) 作为 Curious World Studio 的**统一视频获取候选工具**。此决定只确认**工具选型方向**，不代表它已安装、成功获取实验视频、视频下载获准、媒体复用权利获准，或软件版本/运行环境已验证。

理由：该开源命令行工具可在 Windows PowerShell / 本地 Codex 中被调用，与已有 FFmpeg 的探测/转码流程易于集成；批量素材元数据、格式与来源核验适合后续自动化。备用工具可再评估 you-get；不新增 Web 下载服务或重装现有 OpenMontage。

## 与已下发本地 Codex 任务的关系（重要）

**保持 [G1V 视频只读看片任务书](LOCAL_CODEX_G1V_VIDEO_SCREENING_READONLY_TASK_2026-10-11.md) 原样有效。** 当前任务的第一目标依旧是：观看并核对三段官方研究视频的实际动作、上传者、具体镜头、时间点与可见许可证。**不要求当前 Agent 中断、重做或升级任务。**

如果本机 Agent 顺手能只读查询，可在最终报告附带：
- `Get-Command yt-dlp -ErrorAction SilentlyContinue` 的结果，以及**若已存在** `yt-dlp --version`。
- **仅在工具已存在且网络访问未违反当前只读约束时**，可以用 `yt-dlp --simulate --no-playlist --print "%(title)s | %(duration_string)s | %(id)s" "<video URL>"` 查元数据；失败就记录错误，不追查绕过。
- 这类结果只能证明命令可用、能够访问部分公开视频元数据。**不意味着已实际看见每个视频的动态画面、取得最高画质或拥有再剪辑/再发布授权。**

**本轮禁止**：安装/升级/下载 yt-dlp 或额外 JS 运行时、下载研究视频、录屏或批量抓取、调用 FFmpeg 获取视频流、绕过平台访问限制、修改 Windows / OpenMontage / VPN / 代理环境；当前 G1V 任务中的「禁止 yt-dlp 下载」规则**不变**。没有工具就标 `TOOL_NOT_PRESENT`，不阻塞当前视频观看与内容核验任务。

## 后续独立 Gate（须新授权）

收到只读视频核验报告以后，另行决定：
1. 是否准许在隔离目录**取得经核准的 yt-dlp Windows 独立版**，记录下载来源、版本、SHA 与回滚边界。
2. 视频逐条是否有允许保存、剪辑和目标平台发布的具体许可证/授权/适用例外；**公开视频及论文 CC BY 不自动使外站视频可转载**。
3. 只对已确认可合法获得的研究视频定向下载并存证，再调用 FFmpeg 进行可追溯剪辑与 Remotion 视觉原型。
4. 继续以 `G1_VISUAL_REJECTED / G1_NOT_PASS` 为基线；**不自动晋级 G1、G2 或 G3**。

该文档不修改选题、叙事协议、视觉锁定、本机缓存或原只读任务书。记录的是**候选工具偏好和授权边界**，不是执行成功证明。
