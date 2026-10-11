# P4-G1V-A-M2-F1 首次渲染失败只读诊断｜Reviewer 独立复核 2026-10-11

**执行 Gate**：`P4-G1V-A-M2-F1_READONLY_RENDER_FAILURE_DIAG`，前置正式 M2 为 `RETURN_UNDIAGNOSED_RENDER_FAILURE`。  
**本次诊断结论**：`RETURN_DIAGNOSTIC_INCONCLUSIVE`；历史第 184 帧的确切原因 `ROOT_CAUSE_UNKNOWN`。**F1 的只读资料审查到此停止，不再重复旧日志检索**；M2 本身不升级，G1 NOT PASS、G2 NOT AUTHORIZED。

## 上传与 Reviewer 直接核对的证据

Owner 在本轮上传了完整文本：
- `m2_f1_readonly_diagnostic.md`，Reviewer 当前 sandbox 实际读取并计算 SHA-256：`d51a5e4e5bffaf68c0013adaa7047ce943430b67371e288db52eabb02ea093c0`。
- `m2_f1_failure_log_excerpt.redacted.txt`，Reviewer 实际读取并计算 SHA-256：`d3a508c77d371c4f0e2f56a8629f584359f7809fab0dca871a05aa5a85da53bc`。

上述两个哈希完整匹配 Owner 回报，报告与脱敏日志摘录所述关键报错相符。**Reviewer 未直接取得 Windows 原始完整 render.log、源视频、临时媒体、当时资源状态或进程调用记录**。以下必须区别 Owner 本机报告/脱敏摘录与 Reviewer Windows 实机取证。

## 事实、限制和判定

1. **失败的具体症状**：`CWSG1VAM1`、H.264、Remotion `4.0.484`，控制台显示 concurrency `6x`；渲染输出帧 **184/270** 时，`No frame found at position 20992`，同处本地 `/proxy` HTTP **500**。已独立查看的脱敏摘录证实同一组信息。HTTP500 表示本地代理/渲染环节未能响应，**不是外网/Wikimedia HTTP429 或 yt-dlp 问题**。
2. **输入证据**：此前本机诊断确认时间基准从 playStartFrame 143 计算至源帧 41；源帧41可 FFmpeg 解码。最新 Owner 只读报告称源文件、失败 stage media、失败临时副本在**检查当下** SHA一致。注意这不证明在历史失败瞬间无临时文件可见性问题。
3. **成功重试**：后续旧 M1 runner 重试在相同大类条件下做到 270/270 并产生历史相符结果（曾由 M2 执行报告上报，Reviewer 前轮对旧回归 MP4 未做文件级独立审查）。不能以“后来成功”解释第一次失败。
4. **不足的历史证据**：首次失败渲染进程的完整 `argv`、完整退出码未记入保留资料；成功重试的实际 Remotion 临时副本路径和哈希、失败时并发资源采样/浏览器 worker trace 也未保存。**这些历史事实不能通过推算或继续翻查同一个脱敏摘录补齐**。
5. **程序违规历史**：第一次报错后未经诊断即新建 stage 重试，违反原 M2 的 STOP/no-blind-retry。后来的 F1 只读检查不可以追溯消除它，原 M2 Gate 仍为 RETURN。
6. **F1 合同验收边界**：F1 Gate 要求首败的 invocation/exit 等证据，实际为 `NOT_RECORDED`；因此**不能把 F1 标为 PASS**。另一方面，本轮执行按规定无渲染/安装/清理、取得新的同帧 HTTP500 定位并清楚识别不能补齐的字段，故将**F1 只读调查工作标记 STOP_WITH_RETURN**，不再循环补材料。

## Reviewer 决议

- `M2_TWO_OUTPUT_MP4_QA=PASS_CANDIDATE_VERIFIED_PREVIOUS_ROUND`；两段可观看的候选成片保留，不做重复渲染。
- `M2_F1_READONLY_DIAG=RETURN_DIAGNOSTIC_INCONCLUSIVE / STOP_NO_MORE_SAME_EVIDENCE_REVIEW`；
- `M2_ORIGINAL_GATE=RETURN_UNDIAGNOSED_RENDER_FAILURE`；
- `ROOT_CAUSE=UNKNOWN`；未证明特定 Remotion bug、内存故障、临时资产 race 或线程故障；**不可无证归因**。
- `M2_CODE_PATCH=NOT_MERGED`；`G1=NOT_PASS`、`G2=NOT_AUTHORIZED`。
- `YTDLP_BRANCH=INDEPENDENT / INSTALLED_REPORTED_VERIFIED / MEDIA_REQUEST_FAILED`；不要把两条故障连在一起。
- `OWNER_PREPRODUCTION_CLEANUP=REQUIRED_BUT_NOT_EXECUTED`；首次失败原始记录及已有两支视频/patch 在完成恢复归档前不得删除。

## 建议的后续分叉（**计划，不是执行授权**）

选择 **一轮新的、有界、可观测的兼容性回归**，目的是确认当前候选源码的可执行性并在未来出现错误时抓到完整的 argv/退出码、临时资源和运行时症状，而不是假装可以重新创造第一次失败的历史。草案：[M2-F2 可观测的单轮回归 PLAN_ONLY](../p4-g1/PROPOSAL_M2_F2_ONE_BOUNDED_OBSERVABLE_REGRESSION_2026-10-11.md)。

是否执行须另获 Owner 明确下发授权。新测试应一次性预设停止条件、独立 stage 和最大端点；如果不能证明风险低且有望推进**第一支真实完整视频**，可改为 Reviewer 书面承认稳定性风险并限制生产内测，但仍不得宣布 M2 正式 PASS。

正式第一期素材按最新 3＋1/2、4、6、16:9 横屏优先规则准备；正式生产前必须单独完成只读盘点/核准的清理 Gate，但不能因为清理计划现在删除有审计价值的日志或媒体。
