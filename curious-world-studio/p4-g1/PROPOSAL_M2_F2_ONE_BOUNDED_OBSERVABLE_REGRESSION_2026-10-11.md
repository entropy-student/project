# M2-F2｜一次有界、带故障采样的 M1 兼容回归（PLAN_ONLY，未获执行授权）

> STATUS: `PROPOSED_NOT_AUTHORIZED` · 2026-10-11  
> 对象：`P4-G1V-A-M2` 中旧 M1 runner 在 frame184、`/proxy` HTTP500 的未知间歇性媒体取帧问题。  
> **用途**：防止对旧日志无限追加任务，争取用一次可审查的新执行机会验证现有 M2 源码兼容性，并使下一次若失败时有完整新证据。**目前只是 Reviewer 提案，不应被 Codex 自动执行。**

## 目标、上下限

- 只针对旧 M1 兼容回归；**不重做**已经通过文件级 QA 的 landscape_24、portrait_30 两支候选视频；不尝试把这次测试当真实视频生产。
- 使用原 Owner Windows 上隔离 CWS worktree 的**现存未合并 M2 patch**与过去接受的 M1 测试源/真源 HTML，不更改被接受的 main 源代码/视觉设计。
- **最多发起一轮受控 renderer 调用**。如果失败立即停止、保留现场；不得创建新 stage 再次重试，不更换代理/VPN、FFmpeg、browser、Remotion 或安装软件。
- 只有 Owner 另行同意，Reviewer 才可把这份 `PLAN_ONLY` 变成具有唯一 stage、定值、责任与执行期限的 Gate；当前无任何授权进行新渲染。

## 先证明可运行及现存素材（只读）

1. 确认当前 Windows 用户、绝对根路径、当前 worktree commit/diff、与 `g1va_m2_source_diff.patch` 的相容性。源 patch 仍未经合并，不能把 GitHub main 新文档版本误当做 Windows 工作树源码版本。
2. 核实前次失败和成功日志、M1 fixture 原始哈希 `bc6f92d9ad4e422e6bbcf432dc65bcf340c6fd30998e1211b773cc5a510403b3`、既有相同场景 V2 HTML SHA 和存在的证据目录；确认无正在执行的其它 render/下载任务，不覆盖已有输出。
3. 冻结预期源输入、脚本/程序版本、Render Composition `CWSG1VAM1`、最终 `1920×1080@30,9秒,270帧,无声` 和 `6x` 原始并发参数。**没有经过证据支持不得擅自用“降线程/换缓存”等方案宣称修复**。

## 唯一运行之前先具备新的留痕

1. 在**新隔离 stage** 留存启动前 `argv`/已脱敏命令行、PowerShell/Remotion 各级真实退出码、开始结束时间、stage 名、源/临时 media 哈希、版本/哈希及不含秘密的渲染参数。若旧 wrapper 不能精确采集，设计**最小外层观察封装**，不修改现有已接受 M1 runner 或系统环境；必须先检查其调用/转义语义与返回状态是否可靠。
2. 录制有限的进程 RAM/CPU、磁盘可用量快照及错误上下文。**采集方案本身不能引入大幅并发、修改资源或主动清理临时资产**。
3. 保留失败/成功本轮原始 `render.log`，若出现临时媒体错误，则在**停止后**仅 read-back 保留的临时文件哈希/存在性、实际失败帧和本地 `/proxy` 响应片段，注意 Secret/URL 脱敏。

## 验收边界

- 本轮若**失败**：`RETURN_RENDER_FAILURE_WITH_CAPTURED_EVIDENCE`；立即停止，**不允许重试**。若能归因，另行提出最小修正而不是未授权大改。
- 本轮若**成功**：验证真实输出哈希/FFprobe/全片解码、首帧/源时钟、旧 M1 runner 兼容字段，以及与已接受 M1 视频的相容性；若全部符合仅记 `PASS_CANDIDATE_ONE_OBSERVABLE_REGRESSION`。一次成功**无法统计性证明间歇性问题永不再出现**；Reviewer 可据新质量证据与已知历史风险，决定下一步是**批准最小 M2 patch 合并候审**还是另做受限实验。
- 不接受以缺历史 argv/exit 为由重复本次 F1 只读诊断；也不因此修改 `RETURN_UNDIAGNOSED_RENDER_FAILURE` 的历史记载。
- 任何正式代码合并、批量真实素材落盘、第一支整片渲染、yt-dlp URL 测试、正式清理或 G2 另行经 Owner/Reviewer 对应阶段授权。

## Owner 意义

这不是要求“从头再做一轮 M2”，而是针对原 M1 回归唯一阻断点的一次可观测复核。若单次也失败，保留足够证据以便定点修复；若成功，仍记录历史偶发风险，但不无限重做两支已经通过 QA 的测试片。正式首期视频的选题/旁白/合法真实素材**规划**可并行，不因为缺一个历史时刻日志而完全停摆。
