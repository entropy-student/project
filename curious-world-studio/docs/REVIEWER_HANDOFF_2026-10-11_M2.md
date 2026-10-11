# Curious World Studio｜Reviewer 接手与 M2 现行 Gate（2026-10-11）

> CURRENT_REVIEWER_STATE: `M2_RETURN_UNDIAGNOSED_RENDER_FAILURE / TWO_CANDIDATE_MP4_FILE_QA_PASS / M2_F1_DIAG_CLOSED_INCONCLUSIVE / M2_F2_PASS_CANDIDATE_ONE_OBSERVABLE_REGRESSION / M2_SOURCE_PATCH_PR_REVIEW_NEXT`  
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

## NEWEST_M2_F2_REVIEWER_RESULT_2026-10-11
- Owner 最新已回传主线 F2：真实 9秒 MP4、日志/QA/props 与源码补丁，Reviewer 沙盒独立验证文件 SHA、ffprobe、270帧真实解码/黑帧，并完整读入 15条资源样本。`PASS_CANDIDATE_ONE_OBSERVABLE_REGRESSION`；渲染/旧 M1 runner 退出0，历史184帧这次通过，视频 SHA=`d1e25a34ad41ba87a8e7ee836c4f44a54d39ac52c511861f350e340da6ba2516` 与早先已接受 M1 同。
- 观察器后处理自身退出1且未持久化 launcher ExitCode；不影响已经取得的实际视频和 runner/renderer 0，但不能说整个观察器 PASS。
- 可用 RAM 最低221.86MiB（6x）、进程工作集峰值3891.34MiB；正式长视频需给内存/并发设置安全余量，尚不能认定以前旧故障系内存导致。
- 正式 M2 Gate 历史仍 RETURN；F2 功能候选已验，旧源码 patch 5文件 SHA=`4c5df1ad6a5acea1f74fa26f76d9038d0d7e62b48a1b98c2bd8a678392554482` 尚未合并。**现在无需重渲或再次只读旧日志诊断。** 见 `docs/P4_G1VA_M2_F2_REVIEWER_INDEPENDENT_MEDIA_QA_2026-10-11.md`。
- 下一个主线动作：Owner 可下发 `p4-g1/TASK_M2_SOURCE_PATCH_PR_ONLY_2026-10-11.md` 让 Codex 将确切5文件 patch 从最新 main 单独提出**代码 PR 不合并**，交 Reviewer diff 审核；不得扩大到 G2 或正式视频生产。yt-dlp 支线隔离。

## SYSTEM_MAP
- Windows 本地现存 OpenMontage/Remotion4.0.484/FFmpeg/Node，调用已授权缓存 Chrome Headless Shell（具体实机状态以 Gate preflight 重新核对）；不触 VPS/VPN。
- Source: `p4-g1/m1-media-adapter/`；Visual truth: `p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html`；9s@30fps A/B。
- 输入输出媒体、海报、manifest/关键帧、运行日志写**项目专属隔离 stage**；二进制视频保留 Windows/审查附件，不默认进入 GitHub main。云服务/原研究外链视频/付款/自动发布不在本 Gate。

## LATEST_REVIEWER_M2_F1_READBACK_2026-10-11
- Owner 实际上传 `m2_f1_readonly_diagnostic.md`（SHA `d51a5e4e5bffaf68c0013adaa7047ce943430b67371e288db52eabb02ea093c0`）与 `m2_f1_failure_log_excerpt.redacted.txt`（SHA `d3a508c77d371c4f0e2f56a8629f584359f7809fab0dca871a05aa5a85da53bc`），Reviewer 在当前沙盒读内容、算 SHA 全部匹配。
- 第184输出帧，源位置20992，Remotion临时素材帧抽取失败；脱敏原始日志摘录同帧 `localhost/proxy` HTTP500、concurrency6x。此前本机检查源帧41可解码，当前保存失败副本与源哈希相同；失败瞬间临时文件与资源不明。
- 首次完整调用 argv/进程退出码、成功副本哈希和故障当时资源数据 `NOT_RECORDED`；`ROOT_CAUSE_UNKNOWN`，该旧时点事实无法安全补造。因此 F1 **`RETURN_DIAGNOSTIC_INCONCLUSIVE`**，**只读诊断已停止**，不是 M2/G1 PASS。
- 完整 Review 记录：`docs/P4_M2_F1_REVIEWER_DIAGNOSTIC_INCONCLUSIVE_AND_STOP_2026-10-11.md`。仅拟定一轮后续可观测回归 `p4-g1/PROPOSAL_M2_F2_ONE_BOUNDED_OBSERVABLE_REGRESSION_2026-10-11.md`，**PLAN_ONLY/未获 Owner 执行授权**，不许旧 F1 Gate 再跑。

## CURRENT_GATE
- 原 M2 双素材任务正式状态仍 `RETURN_UNDIAGNOSED_RENDER_FAILURE`，旧 M1 第184帧 renderer 读取失败后未诊断重试的历史偏差不可抹去。两支 MP4 QA 候选通过，不重新生成，M2 补丁**未合并**。
- F1 只读诊断已有 `RETURN_DIAGNOSTIC_INCONCLUSIVE` 并**STOP**，不再请求相同旧日志；从脱敏日志额外确认同帧 `/proxy` HTTP500，但完整首败 argv/exit 缺失、根因仍未知。
- 当前**没有已授权待执行的新渲染 Gate**。F2 只是带明确上限、用于采集下一次真实 argv/exit/资源状态的**一次可观测回归建议**，由 Owner 明确授权后才能安排。
- 本次不涉及 yt-dlp 支线或生产前清理，也不启动 G2。

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

## YTDLP_BRANCH_SECOND_TEST_REVIEW_2026-10-11
- Owner 已提交支线第二轮 Blender/YouTube 共四份证据文件，Reviewer 在此会话实读并算哈希。yt-dlp 已安装、无需重装；PowerShell 对 Blender 480p MP4 的 **HEAD HTTP200** 仅证明 HEAD 响应，yt-dlp 的下载请求 **RemoteDisconnected**，YouTube 的网页/API 提取也 RemoteDisconnected；**无实际视频、无解码，支线 RETURN_REMOTE_DISCONNECTED**。
- HEAD vs GET **请求方法不同**；不能推导 yt-dlp 故障或 VPN/代理原因。若继续，先在新授权下进行**单 URL、有限网络流量、严格 STOP 的路径对照**；不能试遍网站、修改 VPN 或侵占主线运行资源。详情：`docs/P4_YTDLP_BLENDER_FOLLOWUP_REVIEW_RETURN_2026-10-11.md`。
- Owner 说明主线 Codex F2 结果**尚未返回**，本次仅记录支线，主线 M2 仍 RETURN、M2-F1 STOP、F2 先前为提案且现据 Owner 已派给本地 Codex，但**未收到可验收的执行结果**；Reviewer 不假定已成功。

## YTDLP_BRANCH_THIRD_TEST_DIRECT_DOWNLOAD_PASS_2026-10-11
- Owner 本轮上传 Blender Sintel **真实 MP4** 和5份报告；Reviewer 沙盒独立读取、SHA、ffprobe、ffmpeg 全片解码验证：4,372,373B、854×480@24、52.208333s、H264 + AAC、MP4 SHA=`b670602fa00934ca27c4351bb0efe7ea7a07fae57284e44226025eeed7c51254`，全解码 exit0，`YTDLP_DIRECT_DOWNLOAD=PASS_ONE_SOURCE_WITH_EXPLICIT_PROXY`。
- 代理配置差异：进程 `HTTP_PROXY` 的 HTTP scheme 指向 10808 SOCKS-only；Clash 实际 7897 mixed HTTP/SOCKS；显式 `--proxy http://127.0.0.1:7897` 实际下载成功。不要修系统 VPN/环境变量来追溯，后续核对端口是否仍在监听。PowerShell Range GET HTTP206（65536B）是不同直连请求路径，不等于 yt-dlp 先前成功。
- YouTube `FAIL_SITE_SIGN_IN_CHALLENGE`，不借用 Cookie/登录、不绕过；**只确立直链 Blender 样本通过，不宣称所有站点/网页提取器成功**。
- 本机 CWS wrapper `cws-ytdlp.ps1` 报告称存在且语法通过，Reviewer 没有收到脚本字节/独立验收，也未由 wrapper 真正触发本次成功下载，故 `WRAPPER_END_TO_END_QA=NOT_PROVEN`；不能把 wrapper 当全站通用 Downloader PASS。
- 最新详见 `docs/P4_YTDLP_EXPLICIT_PROXY_DIRECT_DOWNLOAD_PASS_REVIEW_2026-10-11.md`；此前 `YTDLP_BRANCH_SECOND_TEST_REVIEW_2026-10-11` 是**历史失败**。
- **不改变主线** F2 MP4 候选通过、M2 五文件代码 PR 审查待完成；G1/G2 尚未解锁；正式素材默认16:9横屏、第一支完整视频生产前清理仍待单独授权。

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
- 主线 F2 单次回归证据 Review 已完成，**不再需要渲染新测试视频**。下一步只需把 M2 五文件原补丁提交一份代码 PR 并完成独立源码审查；任务书 `p4-g1/TASK_M2_SOURCE_PATCH_PR_ONLY_2026-10-11.md`。此任务尚未由 Owner 转发确认 GitHub 写权限；**不批准自行合并或 G2**。
- 之后安全进行正式生产前项目特定清理 Gate（单独确认精确删除项），并着手真实横屏研究素材、配音、单行字幕和正式成片编排。长片应考虑内存和并发约束。
- 支线第二轮 yt-dlp 返回 `RETURN_REMOTE_DISCONNECTED`；若需继续优先一次同 URL 请求路径对照，不因下载支线阻断其它素材路径。

## EVIDENCE_POINTERS
- `docs/P4_YTDLP_EXPLICIT_PROXY_DIRECT_DOWNLOAD_PASS_REVIEW_2026-10-11.md`（**最新支线**：Blender 真实直链/解码通过，YouTube 仍需登录验证）
- `docs/P4_G1VA_M2_F2_REVIEWER_INDEPENDENT_MEDIA_QA_2026-10-11.md`（**最新主线** F2 Reviewer 实际 MP4 QA）
- `p4-g1/TASK_M2_SOURCE_PATCH_PR_ONLY_2026-10-11.md`（**当前下一步**：五文件补丁只提交 PR、无新视频渲染）
- `docs/P4_YTDLP_BLENDER_FOLLOWUP_REVIEW_RETURN_2026-10-11.md`（支线第二轮 Blender HEAD 与下载失败，仍无视频）
- `docs/P4_M2_F1_REVIEWER_DIAGNOSTIC_INCONCLUSIVE_AND_STOP_2026-10-11.md`（最新主线 F1 Review）
- `p4-g1/PROPOSAL_M2_F2_ONE_BOUNDED_OBSERVABLE_REGRESSION_2026-10-11.md`（计划，未授权运行）
- `docs/P4_YTDLP_INSTALL_REVIEW_AND_MEDIA_REQUEST_RETURN_2026-10-11.md`（工具已安装，媒体下载失败）
- `docs/PREPRODUCTION_CLEANUP_POLICY_2026-10-11.md`（正式生产前必做清理，当前不得删除）
- `docs/P4_G1VA_M2_REVIEWER_UPLOAD_QA_AND_RETURN_2026-10-11.md`（本轮独立 QA 与 Return）
- `p4-g1/LOCAL_CODEX_M2_M1_RENDER_FAILURE_READONLY_GATE_2026-10-11.md`（历史 F1 已执行 Gate，现已停止）
- `docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`（最新 Owner 正式素材决策）
- `docs/P4_G1V_SOURCE_SCREENING_READBACK_2026-10-11.md`（yt-dlp 缺失、Edge 3/3 验证事实）
- `docs/P4_G1VA_M1_REVIEWER_INDEPENDENT_QA_2026-10-11.md`
- `p4-g1/m1-media-adapter/README.md`
- `docs/REVIEWER_HANDOFF_2026-10-11_G1VA.md`（前一阶段历史）
- `docs/CURRENT_STATE.md`（现行）
- `p4-g1/LOCAL_CODEX_G1VA_M2_VARIANT_MEDIA_TASK_2026-10-11.md`（当前 Gate）
