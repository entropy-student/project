# Curious World Studio｜2026-10-11 已确定状态总汇 / 下一位 Reviewer 交接入口

## LATEST_AQUA_3PLUS1_ALIGNMENT_20261011｜正式视频＋1动效也对齐Research Aqua（当前最新）

> Owner 最新意见：「唯一的问题是那3➕1的动效可能也要参考这种样式，整理目前项目进展到main，继续推进吧」。本次已执行**文档级视觉一致性设计与首次Story-Fit只读预检**，没有修改锁定视频合同、Remotion源码或真正制作视频。
- **「3＋1」厘清**：3是素材来源渠道（原研究一手 / OpenMontage / yt-dlp合法已知URL），不是三种不同视觉设计；`＋1`仍仅允许 **2转场、4画面布局、6来源/信息/单行字幕**。Owner要求其**参考已原则认可的V2 Research Aqua视觉体系**，即蓝灰银色/字号/线条/节奏统一，不意味着让所有B研究画面额外套Mac Finder浮窗/Genie/HUD，不能未经授权开启禁用的类别1/3/5/7。
- **视觉文件已落地但非实现PASS**：[3＋1/Aqua 2-4-6视觉语法v0.1](P4_VISUAL_GRAMMAR_3PLUS1_RESEARCH_AQUA_246_2026-10-11.md)。A桌面已有固定鼠标与窗口视觉；B主体真素材满幅为主：2默认硬切、必要时120–200ms叠化，4轻银灰分隔的真实不同证据/必要时竖屏contain，6少量来源标签/真实数据/单行中文字幕。**规范提案STATUS=`STYLE_ALIGNMENT_PROPOSAL / VISUAL_IMPLEMENTATION_NOT_STARTED`**，不能冒称生成过有权正式片。
- **主线Story-Fit有实质只读进展**：[CW-0002“大象怎样确认同伴注意”原文/视频权利预检](P4_CW0002_STORYFIT_READONLY_PREFLIGHT_2026-10-11.md)，已从题库11个SHORTLIST选这个Owner偏好题做**试验候选**，联网核到2026 Springer原始论文的研究条件（南非野生象冲突手势、注意观察、等待/持续、41类手势/两类目标、研究有录像但公开可用视频未核）。**`STORYFIT_READONLY_PRECHECK/CONDITIONAL_SOURCE_VIDEO_GAP`**：学术原文可读，**原始行为视频`LINK_NOT_CONFIRMED` / `CONTENT_NOT_FRAME_REVIEWED` / `REUSE_RIGHTS_UNKNOWN`**，B站同题竞品未查，`STORYFIT_GO`尚未评审。原题库字段`CW-0002 status=SHORTLIST/storyfit_status=NOT_STARTED`**不改**。
- **现在的实用下一步**：A) 独立做2/4/6三张**不使用未授权科研视频**的离线 HTML 小样，Owner看过才定正式B视觉；B) 对CW-0002原文逐Beat核验+合法原始视频/许可证/内容时码调查，无法拿到真行为影像则`HOLD_ASSET_GAP`并评估CW-0005等备选；C) 生产前受控只读清理盘点与真正有权视频的音轨/字幕/资源预算。Mac第二批4项仍只有`AUTHORIZED_FOR_ISOLATED_HTML_ONLY / NOT_EXECUTED`，独立Codex可同时制作，**不阻塞主线研究**。
- **权限边界**：本次未修改 `STYLE_LOCK.md` 或 `VIDEO_ASSET_POLICY_3_PLUS_1...`；原V2、M2源码、3+1/2-4-6许可、旧视觉返工证据、G1 NOT PASS/G2 NOT AUTHORIZED、清理需精确Owner确认均不变。此新段优先于下方较早“下一步”的阶段性句子。



> **AUTHORITATIVE CURRENT SNAPSHOT** · 更新时间：2026-10-11（PR #116、#115 均已合并后的 GitHub 状态）  
> **阅读规则**：这是**状态索引**，不重写或提高历史测试的结论、不取代研究与视觉主协议。下一位 Reviewer 应先读本页，再读 `docs/CURRENT_STATE.md`、`docs/REVIEWER_HANDOFF_2026-10-11_M2.md` 及各项**原始带时间戳证据**。历史文档里“PR open / 尚未安装 / F2 未执行 / M2 源码未合并”均是**当时的记录，不再是当前执行指令**。若 main 新增提交，应再次核实实际 PR/head/merged 状态。

## LATEST_OWNER_WAVE2_AUTH_20261011｜第一批原则认可、第二批4项启动授权（**最新**）

> 2026-10-11 Owner 已对首批5项V2返工表示 **「基本达到要求了」**，并授权 **「其他模版也可以开始了」**。最新版决定：[Owner原则认可与第二批授权](MAC_WINDOW_MOTION_KIT_OWNER_DECISION_AND_WAVE2_AUTH_2026-10-11.md)。本页下方此前写的 `OWNER_VISUAL_SIGNOFF_PENDING` 与 `第二批HOLD` 属此明确反馈**之前**的真实阶段，不得作为当前禁止制作的理由。

- **第一批**：由“Reviewer视觉KEEP候选、Owner待看”升级为 `WAVE1_V2_OWNER_PROVISIONAL_VISUAL_ACCEPTANCE`。MW01/02/03 `OWNER_PROVISIONAL_KEEP`，MW04/05 `DEMO_KEEP_ONLY`；不冒认每项正式终审/1:1复刻，更不等于允许把暂停和假进度集成正式B科研视频。保留旧v1视觉退回历史。
- **低优先级的微修**：原V2桌面动态Dock图标5px变化与新版t0冻结、5段WebM短于完整演示、Windows Edge `file://` 未独立复核，作为非阻塞 backlog；此轮不重做第一批，不覆盖原ZIP和HTML。
- **第二批已解锁** `WAVE2_FOUR_ISOLATED_HTML_DEMOS_AUTHORIZED`：`MW-11 Spotlight`、`MW-12 Exposé`、`MW-07 Dock Genie`、`MW-13 Finder拖拽`。严格执行 [第二批四项离线HTML Gate](../p4-g1/MAC_WINDOW_MOTION_KIT_WAVE2_4_DEMOS_GATE_2026-10-11.md)，重用V2桌面、鼠标、窗口与Dock；4项须自然1×/0.5×、真实互动、完整录屏/关键帧、独立Owner视觉验收。**此处仅记录GitHub任务书，Owner本地Codex还未被此操作实际启动**，不得称四项已经制作完毕。
- **主线仍独立**：PR #116 M2源码已合并，两项blocker已修，但正式M2/G1没PASS、G2没授权。正式片应开始Story-Fit与逐片合法素材、配音/字幕/长片资源预算；正式落盘前项目受控清理必须先只读盘点→Owner另批具体删除清单。

## 一、最新 GitHub 事实与正式判定（不可混淆）

| 工作线 / 对象 | 2026-10-11 实时 GitHub + Review 事实 | 当前有效状态 |
|---|---|---|
| 主线 M2 源码 PR [#116](https://github.com/entropy-student/project/pull/116) | **已合并**，merge commit `43fe51a335e03b2695cd2f19f37ffecf1d6f0f3a`，合并时间 2026-10-11 08:51:58 UTC。已审 head `4684bffa899d57859faaec65b18678de94dd97c8`。仅限 `p4-g1/m1-media-adapter/` 5 个文件 | **`M2_CODE_MERGED / CODE_REVIEW_PASS`**，**不是** `M2_FORMAL_PASS` 或 `G1_PASS` |
| 两项阻塞代码问题 | (1) 组件先 `const normalizedProps={...props}`，旧 M1 fallback 默认值只写副本，不改原入参；(2) `Get-M2BlackdetectHits` / `Assert-M2NoBlackSegments` 在 QA `PASS_CANDIDATE_M2` 前对真实日志 `black_start:` 命中**fail closed**。第7个静态负例和清洁黑段正例已加入 | **`BOTH_SOURCE_BLOCKERS_FIXED`**，本地 PS7/TypeScript/静态检查结果来源为 Owner/Codex；Reviewer **独立 GitHub 源码核验**，未重新执行 Windows 测试 |
| PR #116 旧行内审查 | 旧 head `a7596ac0...` 的 `CHANGES_REQUIRED` 评论保留为历史；新的 `COMMENTED` 审查文字明确 `CODE_REVIEW_PASS / MERGE_READY`，不属于 GitHub 原生 Approve。GitHub 同账号不能自批自己 PR | 不把旧评论当当前未修复的源码缺陷；必要时读取新 head 审查和线程解决状态 |
| 复古 Mac 窗口动效提案 PR [#115](https://github.com/entropy-student/project/pull/115) | **已合并的是4个 Markdown 设计/任务/退回文件**，merge commit `667809fec3c961a834b96321a21e70b5525111f2`，2026-10-11 08:53:23 UTC。**未把失败的 HTML/ZIP 作为获验收的产品源码合入** | **`MW_V1_5_OF_5_VISUAL_REJECTED`**：交互 smoke test 5/5，不是视觉通过；严格返工中/待新 Demo 回报，非正式视频功能许可 |
| 原锁定 Research Aqua V2 | `p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html` Git blob `acb0ee80264527bd11160e0ae277ce24528c4a03`，保留原有屏幕、Dock、窗口、鼠标 `cursorAt/drawCursor/clickRing`、A→B | **视觉基准已选定，不准随支线任意换皮** |

**截至本快照**：最近确认的 GitHub main 起点 `667809fec3c961a834b96321a21e70b5525111f2`。本状态同步文档后 GitHub main 会有**新提交**；对后继 Reviewer 来说以实际 main HEAD 为准，以上两个 merge commit 为**已发生的不可变历史锚点**。

## 二、主线 M1 / M2 / G1 测试结果的准确层级

- **M1 自制测试夹具**：6秒/180帧、30fps、1920×1080、无声；9秒 Remotion 输出 MP4 H.264 1920×1080@30、270帧、无音轨，SHA256 `d1e25a34ad41ba87a8e7ee836c4f44a54d39ac52c511861f350e340da6ba2516`。Reviewer 先前读取真实 MP4 与源 poster/输入对齐证据，技术层面 `M1_TECH_PASS_ONE_FIXTURE`；Owner 完整正常速度观片签收**仍无明确证明**。
- **M2 变体媒体**：既有 `landscape_24` MP4 SHA `ee17fa80e20750fe33ef746864333519d7af4d09921893566b687e8ef361b440`、`portrait_30` SHA `2671e6959f26a86e0c4df74fa95580bc9346402339091b59b4949be82bec49da`，**两个真实文件的独立媒体 QA 已通过**；portrait 为 `contain` 兼容性试验，不取代正式片优先16:9横屏。
- **历史第一次报错**：旧 M1 runner 第184帧 Remotion/FFmpeg 视频帧获取失败（`No frame found at position 20992`）、本机 `/proxy` HTTP500；执行方当时未先 STOP 即重试，原 M2 Gate 仍记 `RETURN_UNDIAGNOSED_RENDER_FAILURE`；F1 只读检查得 `ROOT_CAUSE_UNKNOWN / RETURN_DIAGNOSTIC_INCONCLUSIVE`。原首败缺失的瞬时系统状态、argv、完整退出码不能追补。
- **F2 唯一真正渲染回归**：9秒 M1 fixture 真实产物 SHA 与上述 M1 **完全相同**、FFprobe/全片解码/blackdetect通过、旧184帧越过，renderer & runner exit **0**。观察器**后处理**脚本自身 exit1，未持久化 launcher `Start-Process.ExitCode`；这种采集缺口不否定MP4或renderer 0，但**不能声称观察器 PASS 或间歇问题已根治**。状态 `F2_PASS_CANDIDATE_ONE_OBSERVABLE_REGRESSION`。
- **资源**：F2 本机 6x 渲染并发最低可用内存 **221.86 MiB**，进程工作集峰值 **3,891.34 MiB**；低内存是未来长片风险，**没有证据确认**它导致旧 frame184 故障。后续长片须重新设并发/内存安全预算。
- **正式阶段**：`M2_CODE_MERGED` 不等于 `M2_GATE_FORMAL_PASS`；`G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH`。旧 G1-R1/R2 技术样片被 Owner **否决视觉**，不能以源码已合并代替完整正式视频技术+审美+版权+音轨验收。**不要再反复重渲旧9秒/竖屏小样以补纸面结果。**
- 原证据：[M1 QA](P4_G1VA_M1_REVIEWER_INDEPENDENT_QA_2026-10-11.md)、[M2 media QA/RETURN](P4_G1VA_M2_REVIEWER_UPLOAD_QA_AND_RETURN_2026-10-11.md)、[F1 RETURN](P4_M2_F1_REVIEWER_DIAGNOSTIC_INCONCLUSIVE_AND_STOP_2026-10-11.md)、[F2 独立媒体QA](P4_G1VA_M2_F2_REVIEWER_INDEPENDENT_MEDIA_QA_2026-10-11.md)、[原 PR-only 任务（历史）](../p4-g1/TASK_M2_SOURCE_PATCH_PR_ONLY_2026-10-11.md)。

## 三、Mac Window Motion Kit（独立视觉支线）

- 原已选 V2 核心：桌面文件双击→鼠标移动/点击反馈→打开 QuickTime 窗口→进入满幅播放器；**不作为待返工的新功能**。
- 首批 `MW-01..05`：关闭窗口、Aqua弹窗、前后台切换、暂停 UI 提示、进度 UI 示意。历史首版只有7/8/6/27/48帧的短机制，**没有完整的模拟鼠标路径/点击波纹**、窗口/图标/Dock与V2比例/位置漂移；**MW-03 只有 z-index 与5–6px的假切换**。Owner 明确否决，Reviewer 独立严格视觉复核 `RETURN_VISUAL_REJECTED_ALL_FIVE`，之前功能 5/5 PASS **不再等于视觉候选 KEEP**。
- **返工验收底线**：新独立 HTML、1920×1080 母版真实复用 V2 同源桌面/窗口/鼠标、1×/0.5×/逐帧/Reset、鼠标移动→停留→点击→窗口变化→终态，**MW-03真实可逆 A↔B 切换**，图标/Dock/字号/投影对照，五项每项完整时间轴和至少6个关键时点，正常速度真实观看；旧 ZIP/HTML 保留不覆盖。本轮只作 Demo，不能改 main 的 Remotion 视频。
- **第二批已选但暂停**：Spotlight 搜索、Exposé 总览、Dock Genie、文件拖拽，共4个。需第一批新 Demo 真正达到观看质量且 Owner 通过后再单独授权。连同原已有开窗机制构成 **1+5+4=10种优先视觉行为**；其他 Sheet/Finder info 等备用。
- 关键文件：[V1候选与两批顺序](MAC_WINDOW_MOTION_KIT_V1_2026-10-11.md)、[首版严格视觉退回](MAC_WINDOW_MOTION_KIT_V1_REVIEWER_VISUAL_RETURN_2026-10-11.md)、[首批新 HTML 返工 Gate](../p4-g1/MAC_WINDOW_MOTION_KIT_V1_VISUAL_REWORK_GATE_2026-10-11.md)。**PR#115 已合并文档，但视觉结果仍为 RETURN**。当前没有看到下一批返工完成与 Owner 接受的证据。

### MAC_MOTION_V2_CANDIDATE_2026_10_11｜最新第一批返工上传与独立Review（优先于上方原版RETURN）

- **上传新版完整 ZIP，不是仅规划**：Owner提交 `cws-mac-window-motion-kit-v2-rework-20261011(2).zip` (24,667,105B；SHA256 `8987b1a5594ecc346d463ec3c8f47239de5c50587711eb56232ed48964757b67`)，Reviewer解压后独立核 `SHA256SUMS` 72/72 PASS、HTML 32,052B、44张正式关键帧1280×720、5条WebM视频全解码PASS。
- **新技术结论** `V2_REWORK_REVIEWER_TECHNICAL_PASS`：Reviewer自己在独立Chromium中正常**1×真播放五项至终帧**，Reset/JS错误/零网络均核；实测墙钟≈3.72/5.27/6.74/5.54/5.77秒。对关键的 **MW03** 另外独立跑 `0.5×≈13.007s`，真实画布点击 B→A、A→B **均成立**，窗口几何会大幅交换，不再是旧版只调z-index；MW02手动Open选择亦获证。
- **初步视觉状态** `MW01/02/03=REVIEWER_KEEP_CANDIDATE`，`MW04/05=UI_DEMO_ONLY_HOLD`；**OWNER正式常速观看/KEEP或DROP仍 PENDING**。不能反过来覆盖旧版5/5视觉 RETURN，也**不能视作可直接进正式Remotion或G1/G2 PASS**。第二批4项仍 HOLD。
- **尚未独立解决的限制**：V2静态底座锁定 `desktop(t=0)`，原V2 Dock play图标 `t>1.75` 上移5px与波纹缓动被省略；需Owner是否接受。视频WebM 5条实际压缩时长均短于对应演示总时长，尤其MW02差约1秒；不能只用录屏冒称五项完整实时录到尾帧，Reviewer另以浏览器回放验证了操作到终帧。受限Chromium `file://` 直开仍 `NOT_VERIFIED_FILE_URL`，等待Owner Windows Edge双击检查。
- **本次审核报告**：[Mac Window Motion Kit v2 独立Reviewer QA](MAC_WINDOW_MOTION_KIT_V2_REWORK_REVIEWER_QA_2026-10-11.md)。此报告新于原 [V1严厉视觉退回](MAC_WINDOW_MOTION_KIT_V1_REVIEWER_VISUAL_RETURN_2026-10-11.md)；两个时间点结果并存，不删除旧证据。

## 四、正式节目定位与素材生产边界

- 频道：B站主阵地，抖音/小红书辅助；不露脸、观点/观察/追问驱动，研究事实与行为镜头相符，不能用格式冗长弥补故事。当前规划以 4–6 分钟作参考，**不强制凑时长**。七阶段固定：九大信息源→批量发现→评分→正式题库→Story-Fit→剧本/证据/权利→视频制作/QA/发布。
- 题库：当前 36条（SHORTLIST11/VERIFY15/HOLD9/REJECTED1），全部 `storyfit_status=NOT_STARTED`；九源采集整体 PARTIAL，不代表所有来源覆盖完整。题库业务规则以 `research/topic-bank/WORKFLOW_V1.md`，信息源以 `research/SOURCE_SYSTEM_FINAL_V1.md` 为准。
- **正式素材 3+1**：①原论文/研究者/实验视频及原图②OpenMontage已有Pexels/Pixabay渠道③yt-dlp针对已知允许使用的合法来源下载；+1 Codex仅允许 **2转场 / 4画面布局 / 6信息/单行字幕** 三类后期动作。其他1/3/5/7不自动纳入正式 B；拒绝 AI 生图/生视频、用代码画科研对象、重复/循环素材假冒新镜头。新 Mac 动效是**独立 UI Demo**，不能跳过正式视觉合同。
- **A→B 只有两个视觉状态**，V2 Research Aqua复古Mac桌面及 QuickTime 风格播放器，B 播放真正的研究相关素材且尽量占满屏；最终1920×1080、30fps，素材默认优先横屏16:9；竖屏只在关键证据需要时`contain`/分屏，不能拉伸和裁掉关键内容。
- 云配音与旁白：既定本地 OpenMontage 安装/云端 Qwen longzhe_v3.1 音色偏好属于先前方案；**当前没有正式样片的完整音轨+单行字幕对齐通过**。应明确素材权利、真实镜头→句子映射、旁白音轨锁定与word-level对齐、单行字幕切分以及最终可观察 QA。不能从M2无声样片推导正式音画已打通。
- **yt-dlp 支线**：官方程序已就位（Owner本机报告/Release SHA核对）；代理方案定位 `HTTP_PROXY` 曾指向声明HTTP却仅支持SOCKS5的10808，显式 `--proxy http://127.0.0.1:7897` 用当前Clash已确认 mixed 端口成功获取 Blender Sintel 480p MP4（4,372,373B、854×480@24fps、52.208s、H.264/AAC、SHA256 `b670602fa00934ca27c4351bb0efe7ea7a07fae57284e44226025eeed7c51254`，Reviewer独立全解码）。**只证明此直链能用；YouTube元数据遇登录挑战，未通过、不绕过**。新 `cws-ytdlp.ps1` 本机报告称已创建及语法通过，Reviewer未收到脚本内容、未做端到端 wrapper QA。不能把它作为全平台可用或商业许可证明。原则：端口变化先读取实际配置，不修改VPN/Clash/system proxy。
- 原权威：[3+1与2/4/6素材合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)、[支线 yt-dlp 独立下载复核](P4_YTDLP_EXPLICIT_PROXY_DIRECT_DOWNLOAD_PASS_REVIEW_2026-10-11.md)、[G0接口报告](P4_G0_LOCAL_CAPABILITY_READBACK_2026-10-10.md)、[锁定视觉](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)。

## 五、生产前硬条件与下一步（给下一位 Reviewer）

1. **已结束／不重复**：PR #116 代码合并与两项 blocker修复、M1/M2/F2原小样渲染、yt-dlp Blender通用直链测试。**不要将“旧 PR 未提交”当成新任务**。
2. **Mac支线**：等待/审核第一批五个 V2忠实返工 HTML 的实际新产物；Owner 亲自常速观看并裁定 KEEP/HOLD/DROP；第二批4项继续 HOLD。不能因为 #115 merge就称窗口 UI 通过。
3. **正式首片准备**：开始**只读盘点** CWS 自有Windows临时输出与旧 stage，但**不得实际删除**。必须先给 Owner 清晰精确目录/文件/引用/证据保留表、备份/迁移证明与获准删除列表，并获得单独删除确认；不碰共享 OpenMontage、VPS、VPN、其他项目。参考 [生产前清理合同](PREPRODUCTION_CLEANUP_POLICY_2026-10-11.md)。
4. **正式视频编排设计**：选择一个完成 Story-Fit 的真实选题；合法、相关的横屏研究视频 / Pexels/Pixabay 或其他已核来源；镜头→旁白句子→来源/权利→字幕时间对照；制定内存预算/并发/失败即停/回滚；然后独立授权最小真实片段测试。**不要误认为当前 M2 silent test renderer = 已完成可用的整期自动生产系统。**
5. **未解决事项**：M1 Owner常速观片明确签收、M2历史偶发第184帧根因未知、F2观察器日志缺口、正式内容Story-Fit/授权、正式中文云音色/音画对齐、长片稳定性和商业授权、G1正式接受与G2资格。没有Owner对当前最新结果的明确正式验收，不升级Gate、不公开发布。
6. **执行与交接**：主线与Mac返工在不同本地Codex/worktree/stage，必须记录真实源分支/头 SHA/文件哈希与实际用户视觉反馈。旧证据/失败记录只作历史，**不删除、不覆盖、不“反向修复”历史状态**。2026-10-11 更新后读取实际最新 GitHub main，谨防源代码PR #116以及文档PR #115都已合并却旧文件仍写“PR open/patch unmerged”。

> 最终一句话：**M2代码审查和合并已结束，原视频技术候选可用，但正式 G1/G2 没过；复古Mac五动效视觉被退回待返工；yt-dlp Blender直链已打通；正式首片尚需生产前受控清理、真正可授权且相关的视频/旁白字幕完整QA。**
