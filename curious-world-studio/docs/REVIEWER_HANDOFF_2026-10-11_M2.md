# Curious World Studio｜Reviewer 接手与 M2 现行 Gate（2026-10-11）

> CURRENT_REVIEWER_STATE: `M2_GATE_READY / EXECUTION_NOT_STARTED`  
> 本文替代先前 `REVIEWER_HANDOFF_2026-10-11_G1VA.md` 作为新会话默认 Reviewer 入口；历史 Handoff 和原证据仍保留。唯一实时状态 `CURRENT_STATE.md`。

## PROJECT_GOAL
不露脸、B站优先、跨领域真实有趣发现，以证据支持自然故事，不凑时长；A Research Aqua 桌面真实开窗操作→B QuickTime 满幅播放器，保持原始材料权利、语义与观看体验。

## PROJECT_STAGE / CURRENT_ACCEPTED_STATE
- P3-R6 叙事纸面研究完成；题库 36（11 SHORTLIST/15 VERIFY/9 HOLD/1 REJECTED），正式 STORYFIT_GO 仍无；线上采集 P0/P1 验证过但九源全量 PARTIAL。
- P4-G0 本机能力只读证据收到但 CONDITIONAL。
- G1R1/R2 真实24.2秒 MP4 技术能力可核，**Owner 否决旧视觉**，不得复升为 G1 PASS。
- G1V-A **V2 Research Aqua** 为 Owner 选定视觉真源。
- M1 单次 1920×1080、30fps、6秒、静音自制媒体 → 9秒 Remotion，前任 Reviewer 独立技术 QA **PASS_ONE_FIXTURE**。Owner 2026-10-11 仅说「我没啥问题，可以继续推进」：记为 `OWNER_NO_OBJECTION_TO_PROCEED`，**不能证明完整观看 MP4**；M1 视觉通过仍不可用于 G1 正式 PASS。
- Github main 接手基线 `d8b63657a4c61d70d41e20098a3e9049c1c303a2`（合并 #104）。

## SYSTEM_MAP
- Windows 本地现存 OpenMontage/Remotion4.0.484/FFmpeg/Node，调用已授权缓存 Chrome Headless Shell（具体实机状态以 Gate preflight 重新核对）；不触 VPS/VPN。
- Source: `p4-g1/m1-media-adapter/`；Visual truth: `p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html`；9s@30fps A/B。
- 输入输出媒体、海报、manifest/关键帧、运行日志写**项目专属隔离 stage**；二进制视频保留 Windows/审查附件，不默认进入 GitHub main。云服务/原研究外链视频/付款/自动发布不在本 Gate。

## CURRENT_GATE
`p4-g1/LOCAL_CODEX_G1VA_M2_VARIANT_MEDIA_TASK_2026-10-11.md`：**M2 单轮双夹具本机受控技术验证**。24fps 横屏与30fps 竖屏，source时钟/首帧/contain/进度、M1受影响代码回归。已获 Owner 继续推进方向授权，Reviewer 明确有界测试边界；**当前仅 TASK_READY，未实际运行**。必须在 Reviewer 接收/验收前停止。

## CRITICAL_CONSTRAINTS
- 不重画 V2，不改 STYLE_LOCK、题库、正式剧本、HF-FIND；A/B无C，1920x1080@30输出，版权/研究真实事实分层。
- 不安装/下载、不花钱、不碰真正研究视频、Cloud TTS、Windows特权/VPS/WG/HY2/Clash、G2/G3、发布。
- `PASS_CANDIDATE != PASS`；未被当前 Reviewer 亲自核验的本机产物不能记为新 PASS。

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 的本地 Codex，明确 M2 Gate，项目内独立 worktree/stage；不能直接借 GitHub 文档假装读取了 Owner 硬盘。

## CURRENT_ROLLBACK_STATUS
M1 main 四份源码与锁定的 V2 HTML 是可确定的代码回滚基线；本机 M2 stage 尚未创建，新的真实持久化恢复状态 UNKNOWN，Preflight须确认。勿删除 M1/R1/R2/历史测试目录。

## UNRESOLVED
M1 Owner 完整常速观片证据、24fps/竖屏通用性、B正式动态故事镜头、中文配音/对齐、原视频版权、自动素材编排、G1完整视觉/音频 Gate、G2资格。

## NEXT_STEP / OWNER_ACTION_REQUIRED
下一步：**执行有界 M2 后由 Reviewer 独立复核**；Executor不能自行进入 G2。
Owner: **NONE 当前**（除需本人启动本地 Codex 并提交真实证据时按最小转交执行；无账号/付款/系统修改请求）。

## EVIDENCE_POINTERS
- `docs/P4_G1VA_M1_REVIEWER_INDEPENDENT_QA_2026-10-11.md`
- `p4-g1/m1-media-adapter/README.md`
- `docs/REVIEWER_HANDOFF_2026-10-11_G1VA.md`（前一阶段历史）
- `docs/CURRENT_STATE.md`（现行）
- `p4-g1/LOCAL_CODEX_G1VA_M2_VARIANT_MEDIA_TASK_2026-10-11.md`（当前 Gate）
