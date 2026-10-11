# Curious World Studio｜Reviewer 接手与 M2 现行 Gate（2026-10-11）

> CURRENT_REVIEWER_STATE: `M2_RETURN_UNDIAGNOSED_RENDER_FAILURE / TWO_CANDIDATE_MP4_FILE_QA_PASS / M2_F1_READONLY_DIAGNOSTIC_GATE_READY`  
> 本文替代先前 `REVIEWER_HANDOFF_2026-10-11_G1VA.md` 作为新会话默认 Reviewer 入口；历史 Handoff 和原证据仍保留。唯一实时状态 `CURRENT_STATE.md`。

## PROJECT_GOAL
不露脸、B站优先、跨领域真实有趣发现，以证据支持自然故事，不凑时长；A Research Aqua 桌面真实开窗操作→B QuickTime 满幅播放器，保持原始材料权利、语义与观看体验。

## PROJECT_STAGE / CURRENT_ACCEPTED_STATE
- P3-R6 叙事纸面研究完成；题库 36（11 SHORTLIST/15 VERIFY/9 HOLD/1 REJECTED），正式 STORYFIT_GO 仍无；线上采集 P0/P1 验证过但九源全量 PARTIAL。
- P4-G0 本机能力只读证据收到但 CONDITIONAL。
- G1R1/R2 真实24.2秒 MP4 技术能力可核，**Owner 否决旧视觉**，不得复升为 G1 PASS。
- G1V-A **V2 Research Aqua** 为 Owner 选定视觉真源。
- M1 单次 1920×1080、30fps、6秒、静音自制媒体 → 9秒 Remotion，前任 Reviewer 独立技术 QA **PASS_ONE_FIXTURE**。Owner 2026-10-11 仅说「我没啥问题，可以继续推进」：记为 `OWNER_NO_OBJECTION_TO_PROCEED`，**不能证明完整观看 MP4**；M1 视觉通过仍不可用于 G1 正式 PASS。
- **最新 M2 执行证据（2026-10-11）**：Owner 上传 M2 真实两支 MP4、源 patch/报告，Reviewer 独立重新核对 MP4 SHA、FFprobe、全片解码、黑帧及关键帧；**两支输出视频文件 QA PASS**，但**旧 M1 runner 在第184帧报错后未先诊断即重试**，违背原 Gate STOP。后续旧帧41可解码，Remotion 临时抽帧失败根因未确认。**正式 M2 Gate = RETURN_UNDIAGNOSED_RENDER_FAILURE**；M2 新代码未合并，G1/G2 状态不变。见 `docs/P4_G1VA_M2_REVIEWER_UPLOAD_QA_AND_RETURN_2026-10-11.md`。
- 当前 GitHub main 在本轮文档记录前核对为 `bb7c7f2ea3f6eb1a6136b6f6aae4c814393ae631`。M2 本地 Executor checkout 仍以 `c8cf8f90672c6428bcc553ebf951acdafc8ac45e` 作为初始源基线；之后 main 的文档决策（3＋1、2/4/6）是正式视频未来政策，**不能要求 M2 本地 checkout 自动重建或误认为 M2 patch 已合并**。

## SYSTEM_MAP
- Windows 本地现存 OpenMontage/Remotion4.0.484/FFmpeg/Node，调用已授权缓存 Chrome Headless Shell（具体实机状态以 Gate preflight 重新核对）；不触 VPS/VPN。
- Source: `p4-g1/m1-media-adapter/`；Visual truth: `p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html`；9s@30fps A/B。
- 输入输出媒体、海报、manifest/关键帧、运行日志写**项目专属隔离 stage**；二进制视频保留 Windows/审查附件，不默认进入 GitHub main。云服务/原研究外链视频/付款/自动发布不在本 Gate。

## CURRENT_GATE
M2 原 Gate `P4-G1V-A-M2_VARIANT_MEDIA_INPUT` 已收到本机执行候选并正式 **RETURN**，不能继续靠旧授权尝试重渲或自行标 PASS。
下一步是单独的 **[P4-G1V-A-M2-F1 首次失败只读诊断 Gate](../p4-g1/LOCAL_CODEX_M2_M1_RENDER_FAILURE_READONLY_GATE_2026-10-11.md)**，状态 `GATE_READY / EXECUTION_NOT_STARTED`。**只读**核对旧失败/重试 `render.log` 和现存 stage 原始证据，根因允许 UNKNOWN，但要说清证据缺口；不得渲染、安装、清理、更改代码或进入 G2。完成后等待 Reviewer 决策，原已成功 MP4 无须重跑。

## OWNER_DECISION_2026-10-11 / ACTIVE_VIDEO_ASSET_POLICY
- 未来正式视频采用 **3＋1**：研究/实验原始素材、OpenMontage 检索、yt-dlp 已知来源的合规下载路径；**Codex 动效只保留 Owner 选定的 2 转场衔接、4 画面布局、6 信息呈现三大类**，其他 1/3/5/7 不用；**不绘制果冻等实体、不生成 AI 图片/视频、禁止重复镜头/循环素材**。按需要选取，不要求三路都用。权威合同：[VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)。
- yt-dlp 既往本机实证是 `TOOL_NOT_PRESENT`；Edge 播放3/3并非 yt-dlp 下载通过。后续独立验证；**已发出的 M2 仅工程测试、不加真实素材/下载、不因新合同重跑**。

## OWNER_DECISION_2026-10-11 / MOTION_AND_SEPARATE_TOOL_TEST
- Owner 从七个动效大类选择了 **2/4/6**，正式 B 视频只准转场、真实素材布局、信息字幕/证据标签；禁止推镜/平移、动态圈注/局部放大、定格慢放和新视觉滤镜。固定 Research Aqua 桌面→播放器操作不变。以 `docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md` 为现行合同。
- Owner 已单独授权并下发 yt-dlp 官方安装 + CC0 小样本下载任务；**结果已回报并独立审核：安装校验获证，真实下载 RETURN_YTDLP_MEDIA_REQUEST_FAILED，未取得视频/未解码**。此前工具缺失回报仍为历史事实；M2 禁止挟带安装/网络/视频下载操作。

## OWNER_NEW_DECISIONS_2026-10-11 / LANDSCAPE_PREPRODUCTION_CLEANUP
- 正式视频素材默认 **16:9 横屏优先**，不排斥有必要且权利确认的竖屏内容；只允许采用「4画面布局」的 `contain` 或分屏布局，禁止拉伸/裁剪关键科学证据。输出保持 1920×1080/30fps。
- **首次正式完整视频生产前必须单独做一次项目专属清理**，但当前尚未批准任何删除。先完成本 Gate M2-F1 的失败日志取证和关键素材持久化保留，再列清单、查引用、Owner 单独确认具体删除项。详情见 `docs/PREPRODUCTION_CLEANUP_POLICY_2026-10-11.md`。
- Owner 交付的 yt-dlp 独立安装/测试 ZIP 已由 Reviewer 检查：官方程序 `2026.08.19` 的本机安装/sha/version 报告可与 GitHub 官方 Release 对账，工具已就位（按 Owner 本机报告）；Commons 真实媒体请求失败：`RemoteDisconnected` 与 PowerShell GET HTTP429，**没生成媒体/没解码**，结果 `RETURN_YTDLP_MEDIA_REQUEST_FAILED`。详情见 `docs/P4_YTDLP_INSTALL_REVIEW_AND_MEDIA_REQUEST_RETURN_2026-10-11.md`，不需要重新安装。**未对其他网站测试，不假定所有网站都失败。**
- M2 原故障 `RETURN_UNDIAGNOSED_RENDER_FAILURE` 仍独立未解除；下一步依旧是 **M2-F1 既存日志只读诊断**。不得将“清理前置要求”变成当前删除授权，也不得让 yt-dlp 失败引发 VPN 变更。

## CRITICAL_CONSTRAINTS
- 不重画 V2，不改 STYLE_LOCK、题库、正式剧本、HF-FIND；A/B无C，1920x1080@30输出，版权/研究真实事实分层。
- 不安装/下载、不花钱、不碰真正研究视频、Cloud TTS、Windows特权/VPS/WG/HY2/Clash、G2/G3、发布。
- `PASS_CANDIDATE != PASS`；未被当前 Reviewer 亲自核验的本机产物不能记为新 PASS。

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 的本地 Codex，明确 M2 Gate，项目内独立 worktree/stage；不能直接借 GitHub 文档假装读取了 Owner 硬盘。

## CURRENT_ROLLBACK_STATUS
M1 main 四份原始源码和锁定 V2 HTML 仍是已接受基线；M2 的 5 文件 patch 只留本地未经合并。Owner 报告本地 M2 隔离 stage 和证据目录已生成并保留，**Reviewer 未登录 Windows 核实现场保留情况**；不清理 M1/R1/R2/M2、失败或成功 stage，先保全失败日志。回滚细节见 Owner 上传的 `rollback_plan.md`。

## MOST_RECENT_YTDLP_OWNER_RELAY
Owner 于 2026-10-11 转交 Codex 本机存在性预检：`RETURN_TOOL_NOT_PRESENT`；`Get-Command yt-dlp` 无匹配，FFmpeg/FFprobe 9.0 版本命令成功。按 Gate 停止后**没有执行元数据提取、下载或解码，也没有安装/改网络/M2**。无可供 Reviewer 直接读取的日志，记为 `OWNER_REPORTED`，见 `docs/P4_YTDLP_LOCAL_TOOL_PREFLIGHT_OWNER_READBACK_2026-10-11.md`。**该历史预检本身不含安装授权**；随后 Owner 已另行授权并完成安装测试回报；**当前安装已获证，真实媒体下载失败**；M2 不变。

## UNRESOLVED
M1 Owner 完整常速观片证据、24fps/竖屏通用性、B正式动态故事镜头、中文配音/对齐、原视频版权、自动素材编排、G1完整视觉/音频 Gate、G2资格。

## NEXT_STEP / OWNER_ACTION_REQUIRED
下一步：按新 Gate **只读诊断既存 M1 首次失败 log**；不重渲 M2 候选、不再修改 main 源码，Reviewer 收到诊断及脱敏日志后定处置。
Owner: 将 `p4-g1/LOCAL_CODEX_M2_M1_RENDER_FAILURE_READONLY_GATE_2026-10-11.md` 转发 Windows 本地 Codex，完成后提供诊断摘要及初次失败相关原始日志的脱敏小片段即可；不需要重新上传那两支候选 MP4。

## EVIDENCE_POINTERS
- `docs/P4_YTDLP_INSTALL_REVIEW_AND_MEDIA_REQUEST_RETURN_2026-10-11.md`（工具已安装，媒体下载失败）
- `docs/PREPRODUCTION_CLEANUP_POLICY_2026-10-11.md`（正式生产前必做清理，当前不得删除）
- `docs/P4_G1VA_M2_REVIEWER_UPLOAD_QA_AND_RETURN_2026-10-11.md`（本轮独立 QA 与 Return）
- `p4-g1/LOCAL_CODEX_M2_M1_RENDER_FAILURE_READONLY_GATE_2026-10-11.md`（当前只读 Gate）
- `docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`（最新 Owner 正式素材决策）
- `docs/P4_G1V_SOURCE_SCREENING_READBACK_2026-10-11.md`（yt-dlp 缺失、Edge 3/3 验证事实）
- `docs/P4_G1VA_M1_REVIEWER_INDEPENDENT_QA_2026-10-11.md`
- `p4-g1/m1-media-adapter/README.md`
- `docs/REVIEWER_HANDOFF_2026-10-11_G1VA.md`（前一阶段历史）
- `docs/CURRENT_STATE.md`（现行）
- `p4-g1/LOCAL_CODEX_G1VA_M2_VARIANT_MEDIA_TASK_2026-10-11.md`（当前 Gate）
