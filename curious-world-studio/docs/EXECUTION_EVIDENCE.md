# Curious World Studio｜有效执行证据索引（APPEND-ONLY）

> 此处保留审过的**事实与证据指针**，不存原MP4、完整日志、凭据或大型ZIP。区分DIRECT_READBACK / OWNER_REPORTED / BEHAVIORALLY_VERIFIED / INFERRED；Codex的PASS_CANDIDATE不是Reviewer PASS。旧的正式历史细节参见[Reviewer Handoff](REVIEWER_HANDOFF_CURRENT.md)。

## EVIDENCE 2026-10-15｜MEDIA基础技术成果（历史）

- AUTHORIZED_GATE：MEDIA-R1～R5、G2–G4及MEDIA统一CLI，按对应旧Gate执行；本次仅引用已接受历史证据。
- PREFLIGHT_FACTS：旧Owner本机Windows、Docker按需SearXNG+4get、yt-dlp/FFmpeg及OpenMontage。
- ACTUAL_CHANGES：MEDIA统一CLI和隔离Compose已分别通过PR#129（merge 10b369ee5558ed9a0ac2f738aea978623f62ba0f）、PR#131（merge 201c39a2b61eae7189cc624d5cb2c18dd671de38）合并main。
- OBJECTIVE_READBACK：GitHub PR合并状态DIRECT_READBACK；本机搜索/下载/解码/Owner Edge播放依据历史本机包，Reviewer复验范围详见[历史交接](REVIEWER_HANDOFF_CURRENT.md)。
- VALIDATION：MEDIA G2_G3_G4_TECHNICAL_ACCEPT；R6L/R7L已结束、历史PARTIAL_ASSET_GAP不再触发新的研究素材轮次。
- ANOMALIES：多PeerTube实例非多独立平台种类；真实库存权利不因技术验收改变，仍PARTIAL。
- EVIDENCE_ARTIFACTS_AND_PURPOSE：G2–G4 ZIP CWS_MEDIA_G2_G3_G4_DOCKER_LOCAL_20261015.zip SHA256 651651f7e21cba1428c0cfac30b09fdc814cc31586b63d278eee9d14a551d875；R6L/R7L ZIP CWS_MEDIA_R6L_R7L_FAST_MATCH_PILOT_20261016.zip SHA256 81591798ede2c838bbc8cc31c8b5fb22edbd5f497d90e7142cfcae141e78c4f8。原始ZIP/媒体在Owner本机，当前未重新回放。
- ROLLBACK_EFFECT：旧流程清理/退出结果参见历史交接；本轮不触及旧环境。
- RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT：本次文档回溯无实际媒体运行。
- EXECUTOR_RESULT：上述历史技术结果已在旧轮次被接受；不构成视频制作或发布许可。

## EVIDENCE 2026-10-16｜PROD-R2修订稿（Reviewer PASS）

- AUTHORIZED_GATE：PROD-R2-CW0005-EDITORIAL（含一次有界返修）。
- PREFLIGHT_FACTS：Codex称原稿与台账SHA不变、旧工作树未触碰（OWNER_REPORTED/EXECUTOR_REPORTED，非Reviewer本机直接回读）。
- ACTUAL_CHANGES：更正S05约6.9ms画格为“已裂且淀粉膨胀”非精确裂开时刻；更正S07声学实验内部影像/录音同步；论文正式标题修正，精简口播数字并突出淀粉脚机制。
- OBJECTIVE_READBACK：Reviewer直接读取 CWS_PROD_R2_CW0005_EDITORIAL_REVISION_20261016.zip；外层SHA256 e547e48cd107b7a05e47aae466fc9efbd84f8a381f9065a0bb8213cd0dc5c6dc；CRC与SHA清单6/6通过，旁白10句、镜头10行存在，审阅论文事实与助画面标识（DIRECT_READBACK）。
- VALIDATION：PASS_R2_EDITORIAL_REVIEW。仅内容与镜头表，不是实际录音/字幕同步、科研录像或正式Story-Fit。
- ANOMALIES：55秒为粗估；Pexels854959/Pixabay2793具体复用权PARTIAL；精确入出点/原音轨尚待选择，S05在配音前可最小口语化。
- EVIDENCE_ARTIFACTS_AND_PURPOSE：修订ZIP及上述SHA；前版 CWS_PROD_R2_CW0005_EDITORIAL_20261016.zip SHA256 8f00177daaea657540db7952d5c1200d39bcd90c23ae75ffe46423623409098b；当前正文详见[R2生效稿](CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md)。
- ROLLBACK_EFFECT：本次R2修订为本地文本；执行端报告旧原稿/媒体保留，Reviewer未直读本机旧树。
- RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT：无音画合成、发布/购买。
- EXECUTOR_RESULT：PASS_CANDIDATE；REVIEWER_RESULT：PASS（仅编辑）。

## EVIDENCE 2026-10-16｜PROD-R3授权，执行未开始

- AUTHORIZED_GATE：[PROD-R3-CW0005-INTERNAL-AV-SAMPLE](PROD_R3_CW0005_INTERNAL_AV_SAMPLE_GATE_2026-10-16.md)。Owner明确同意R3本机内部样片且不再增加本轮版权调查。
- PREFLIGHT_FACTS：尚未从Owner本机返回R3实时预检数据（UNKNOWN）。
- ACTUAL_CHANGES：NONE；授权不代表调用配音或制作视频。
- OBJECTIVE_READBACK：本轮交谈中Owner授权及已接受R2文案可核；没有R3 MP4/WAV/SRT/QA。
- VALIDATION：AUTHORIZED_NOT_EXECUTED，不是PASS_CANDIDATE。
- ANOMALIES：原正式HOLD/G1_NOT_PASS/G2_NOT_AUTHORIZED/NO_PUBLISH及素材权利PARTIAL保持。
- EVIDENCE_ARTIFACTS_AND_PURPOSE：当前R3 Gate；本地R3验收ZIP尚不存在。
- ROLLBACK_EFFECT：NOT_APPLICABLE。
- RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT：NONE。
- EXECUTOR_RESULT：NOT_STARTED。

## EVIDENCE 2026-10-16｜PROD-R3内部音画初版（Reviewer局部PASS / 总评RETURN）

- AUTHORIZED_GATE：PROD-R3-CW0005-INTERNAL-AV-SAMPLE，Owner仅内部样片授权。
- PREFLIGHT_FACTS：Codex在本机执行、使用既有音视频和Qwen TTS；本机目标、仓库工作区未变及零充值为执行端记录（OWNER/EXECUTOR_REPORTED），Reviewer未接管Windows直接读回。
- ACTUAL_CHANGES：本机独立目录产生55.366667秒1920×1080@30fps H.264/AAC MP4、WAV旁白、ASS/SRT、逐镜头清单及QA证据；失败/修复轮次为原任务内一次TTS取回代理重试、FFmpeg SAR调整、版式返修，无正式Git改动的本机直接证据。
- OBJECTIVE_READBACK：Reviewer实际取得 CWS_PROD_R3_CW0005_INTERNAL_AV_SAMPLE_20261016.zip，SHA256 d06a5cc1c34fb171cbf593f056670773f999a02c151465d84344c0ff1d5dba0d；ZIP CRC无错，SHA清单42/42匹配；直接FFprobe读取视频55.366667秒1661帧1920x1080/30fps、AAC24kHz单声道并FFmpeg独立全片音视频解码exit0；直接查看最终真实抽帧，见S05字幕和卡片。音轨存在且音频信号非静音；音色实际主观试听未由Reviewer工具独立完成。
- VALIDATION：独立技术解码/实际画面与字幕抽检PASS；执行端的隔离浏览器readyState=4/videoWidth=1920/currentTime推进/ended=true源于ZIP日志，非Reviewer亲控Windows。**本轮最终裁决 RETURN_R3_VISUAL_AND_EVIDENCE_MICROFIX**，原因如下。
- ANOMALIES：① S05约21.4–27.3秒浅灰纯文字卡上白字中文字幕缺乏足够对比，违背清晰可读验收；②“脚受压→脚回弹”卡片的先后显示滞后于对应旁白，容易混淆最核心解释，属于局部时间轴问题，不要求科研原片；③ SOURCE_RIGHTS.md 对“Pixabay #2793”错误列出以37441结尾的另一素材URL，应改用历史已接受的id-2793页面，不做新版权搜查；④ tables/shot_timeline.json 与 evidence/render_commands.jsonl含Owner本机完整绝对路径，未完全达到脱敏ZIP要求（不存储具体本机路径到Git）；⑤未做真人主观声音试听，不可把有AAC音轨当作音色审美通过。
- REQUIRED_NEXT_ACTION：继续**同一个R3 Gate**，保留原音轨/源素材/脚本，重渲染S05字幕确保暗底高对比并使三步说明与旁白事件顺序大致一致；仅纠正Pixabay来源URL及ZIP元数据本机路径脱敏；更新QA关键帧及清单，交一个新ZIP与SHA。不得新素材搜索、新TTS、推翻视觉/模型、额外轮次或R4。
- EVIDENCE_ARTIFACTS_AND_PURPOSE：上述ZIP、SOURCE_RIGHTS.md、QA_RESULTS.md、captions/narration.srt、overlay.ass、shot_timeline_final.csv、qa2_22/24/26关键帧、MP4（均存Owner本地/聊天上传；不推原媒体入Git）。
- ROLLBACK_EFFECT：本次Review仅读取上传ZIP，无Windows变更；旧MP4/源文件保留属于执行端报告。
- RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT：Reviewer无新增费用/本机运行；执行端声称使用既有免费TTS额度。
- EXECUTOR_RESULT：PASS_CANDIDATE；REVIEWER_RESULT：RETURN_R3_VISUAL_AND_EVIDENCE_MICROFIX（技术部分PASS，总体未PASS）。

## EVIDENCE 2026-10-16｜PROD-R3修订返修版独立Review（覆盖旧退回项，不覆盖旧证据）

- AUTHORIZED_GATE：原 `PROD-R3-CW0005-INTERNAL-AV-SAMPLE` 同一Gate的上轮Reviewer授权最小修复；没有新制作/搜索授权。
- PREFLIGHT_FACTS：本次从用户上传的修订ZIP直接执行本sandbox只读验收；Owner Windows本机执行/保全/没有重配音等事项仍属 `EXECUTOR_REPORTED`，非Reviewer宿主机直接证明。
- ACTUAL_CHANGES：按照Codex文本记录，S05深色不透明字幕底框，三步说明在成片21.411–27.260秒依次出现；Pixabay #2793 链接指向包含2793的来源页；JSON/JSONL中的本机绝对路径经脱敏。本次Reviewer没有向原视频或Windows写入。
- OBJECTIVE_READBACK：ZIP `CWS_PROD_R3_CW0005_INTERNAL_AV_SAMPLE_REVISION_20261016.zip` 直接SHA256=`84ddaac6b21279a1a77a46a5a85f71e5528b7d5f0a21274918aeb9bf07c919e0`，CRC PASS、内部`SHA256SUMS.txt` 57/57匹配。最终MP4 `video/CW0005_internal_av_sample.mp4` SHA256=`7b913ef24888257e3e341a690758286af7361b0d1d4db0d719315623bcdac4a5`、40,530,055字节；FFprobe: 55.366667秒、1920x1080、1661帧、30fps H264+AAC24kHz单声道；Reviewer分别完整解码视频和音频零错误。原始WAV 53.76秒、RMS约0.1035（波形非静音），AAC主观发音和自然度**未被独立聆听**。从最终MP4重抽21.55、23.35、24.75秒及12段全片代表帧，S05显示“热板压住脚→淀粉脚弹回→整粒爆米花跳起”，白字具有深色实底，其他镜头仍为相关库存画面并标注辅助/非实验。
- VALIDATION：**PASS** 视频完整性、画面主题/字幕可读、有限三步骤顺序、来源权利PARTIAL保持。**UNVERIFIED** 真人听感中文发音/语调/整体听声质量；返修版没有浏览器重新播放，旧版隔离浏览器记录仅作为旧版证据。R3整体标`PARTIAL_AUDIO_LISTEN_UNVERIFIED`，不能在没听审情况下自称完整R3正式PASS。
- ANOMALIES：`evidence/revision_media_qa.json`中旧中间视频SHA=`0736b1b48df21e50bc0e4ae577544801e0354971c42231a260fa44935823302a`、大小40,526,595字节，与当前最终版不同；`manifest.json`、`SHA256SUMS.txt`、`QA_RESULTS.md`、`ffprobe_revised_final.json`和Reviewer直接SHA一致。该不一致记录为**非阻塞陈旧QA元数据**，不为修正元数据再次渲染；若后续需正式封版，可顺手更正来源对齐。Pixabay页面所含id=2793，未由网页访问工具确认页面在线可访问；不宣称实际版权已核实。文本记录与Json/JSONL检查没有发现常见本地绝对用户目录或关键字明文。
- EVIDENCE_ARTIFACTS_AND_PURPOSE：上传返修ZIP（原件在Owner本地，当前sandbox做只读核验）；关键帧 `evidence/s05_review_frames/`，审阅者直接从MP4重抽帧；浏览器记录绑定旧视频，不挪用。
- ROLLBACK_EFFECT：Reviewer无真实Windows写操作；修订时没有覆盖原媒体/旧ZIP为执行端报告。
- RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT：Reviewer仅本sandbox媒体解码；Windows费用/内存、旧配置实际状态未由Reviewer实测。
- EXECUTOR_RESULT：`PASS_CANDIDATE`；REVIEWER_RESULT：`PARTIAL_AUDIO_LISTEN_UNVERIFIED`（其他R3返修项PASS）。
- NEXT：Owner可一次性确认音色、清楚度、自然语速和整体审美；不再开Codex返修任务，除非发现实质问题。批准完整草片R4为另一个Owner Gate。

## EVIDENCE 2026-10-16｜Owner观看否决R3整体视觉内容（高优先级新事实，保留旧技术验收）

- AUTHORIZED_GATE：原PROD-R3内部55.367秒样片Reviewer/Owner复核；无新制作权限。
- PREFLIGHT_FACTS：Reviewer只读核对本聊天已上传的最终MP4和返修ZIP，不登录或改变Owner电脑。本条不重放Codex任务。
- ACTUAL_CHANGES：只有Reviewer裁决/长期视觉要求变化及项目文档更新，无新音视频或运行配置变更。
- OBJECTIVE_READBACK：Reviewer对 `/mnt/data/r3_revision_review/video/CW0005_internal_av_sample.mp4` 实际按3秒间隔抽取18帧，并直接读取上传ZIP `tables/shot_timeline_final.csv`，总12行剪辑记录：Pexels #854959视频占20.223秒（36.5%）、Pixabay #2793占25.726667秒（46.5%）、单张纯文字机制说明卡占5.849秒（10.6%）、片尾文字1.961秒；另外片头约1.5秒。两条独立库存源合计45.949667/55.366667秒（83.0%）；各文件内部时码虽不重复，但同锅/同题材画面持续占据绝大多数时长。原版及返修版均未解决整体视觉多样性问题。
- VALIDATION：用户实际观看并明确表示“素材都是重复的”“还有那种文字的介绍”“作为视频肯定是不合格的”；此为Owner对作品质量的**直接审美否决**，Reviewer依据抽帧、镜头台账独立支持其事实基础。正式R3裁决 `RETURN_OWNER_VISUAL_STORYFIT`，取代先前“仅待真人试听”的整体状态；ZIP校验、H264/AAC全片解码、局部S05字幕可读性等子项仍技术PASS，不等于内容PASS。
- ANOMALIES：过去将**可播放/分镜行数/字幕可读**错误提升为“视频观感通过”，忽略项目 `STYLE_LOCK v1.2` 明确的“研究内容优先、不使用PPT主体”和Owner不露脸但拒绝PPT的设计边界。原镜头表实际来源两条不足以承担全片视觉叙事；不应再通过更换字幕样式或重切同一素材修补。
- EVIDENCE_ARTIFACTS_AND_PURPOSE：已有最终R3修订ZIP SHA `84ddaac6b21279a1a77a46a5a85f71e5528b7d5f0a21274918aeb9bf07c919e0`、其 `tables/shot_timeline_final.csv`、最终MP4和本轮抽帧总览（当前聊天工作区）；没有重新产生需Owner转交的媒体包。
- ROLLBACK_EFFECT：无本机Codex/素材更动；Git文档范围内作权威现状更新并回读。历史失败及技术PASS事实保持在Evidence，不篡改。
- RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT：无新增TTS/素材检索、购买、部署、发布或视频渲染。
- EXECUTOR_RESULT：历史PASS_CANDIDATE；REVIEWER_RESULT：`RETURN_OWNER_VISUAL_STORYFIT`（Owner质量否决，优先于此前`PARTIAL_AUDIO_LISTEN_UNVERIFIED`）。
- NEXT：先形成有目的的镜头变化/视觉解释方案，在不同场景、动作、可引用研究图像和现有视频之间自然切换；禁止以重复素材和大段文字卡凑时长。质量方案审核后由Owner决定是否授权同一主线新制作Gate，R4和发布没有放行。

## EVIDENCE 2026-10-16｜仅文档的Owner素材匹配/后置润色裁决

- AUTHORIZED_SCOPE：Owner通过本轮聊天要求按Governance整理七点决策并将**已确定部分**同步GitHub main；没有授权搜索、Codex、音视频合成或正式R4。
- OWNER_DIRECT_IN_CHAT：①匹配阶段文案锁定；⑦方案确定后执行human-writing/humanizer与事实复核；④目前不限制素材类型时长占比；⑥不采取因素材缺口或数值预算自动停止制作的内容机制。②广泛搜索如何实施、③兜底类型/制作、⑤既有13个窗口模板与正式2/4/6如何应用仍待讨论。
- ACTUAL_CHANGES：同步[裁决登记](VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md)与现行状态、交接、配音文案润色工作流，以及修正旧3+1合同与STYLE_LOCK中可擅自改变文案或自动停止的冲突建议；不修改源码、历史视频/媒体、正式R3结论或Governance。
- VALIDATION_REQUIREMENT：确保不把此前60/40等数字、固定五类兜底、单次搜索上限、AI生图和Mac 13模板集成当成生效规则。R3整体仍`RETURN_OWNER_VISUAL_STORYFIT`；G1/G2/HOLD/NO_PUBLISH与R4未授权持续有效；GitHub合并后需回读文件。

## EVIDENCE 2026-10-16｜Owner确认②高效遍历及原始视频素材不可二次使用（仅文档）

- AUTHORIZATION：Owner聊天直接提出“问题1确定请记录，同时同一个视频素材禁止二次使用”；并请求讨论③分层兜底和⑤模板是否合并解决。本轮只有GitHub项目文档记录许可，无素材下载、API付费、Windows Codex、视频合成、R4或发布授权。
- OWNER_DIRECT_IN_CHAT：高效检索原则继承刚确认的上一轮方案：多来源并行搜集、抽帧预览与去重、相关性排序、只对未解决视觉缺口定向补搜；明确不反复全量遍历。新增原始视频源“一次性使用”：一源单期单连续区间，全项目不得跨期重复；衍生版本、不同URL不绕过同源判定。
- EXPECTED_FUTURE_VALIDATION：执行前通过项目级源身份+视频感知相似判定+使用台账查重；本轮**没有验证任何已用台账自动化系统已经实现**。原R3的Pexels #854959/Pixabay #2793作为历史已使用记录保留，不能将旧失败镜头重新塞入新片。
- OPEN_ITEMS：③视觉兜底与AI图片、⑤13个MW候选及正式2/4/6如何合并编排，仍只是设计建议；旧AI禁令未被本次确认检索策略而解除。R3整体RETURN/G1/G2/HOLD/NO_PUBLISH及R4未授权不变。

## EVIDENCE 2026-10-16｜13×6分镜组合方法确认（仅文档）

- AUTHORIZED_SCOPE：Owner在当前聊天明确要求按GitHub Governance记录13个既有MW模板×六类素材的有限选择方法，并进入大表讨论。仅文档写入许可，非素材下载、AI图片生成、MW源码改造、视频渲染或发布授权。
- OWNER_REPORTED_DIRECT_IN_CHAT：Owner不希望重新发明12种分镜母版，要求直接对已有13个窗口模板与6种素材/呈现类型做理论13×6适配矩阵，排除不适合的组合，让最终有限模板能替换素材。
- REVIEWER_PROPOSAL：新增[13×6讨论矩阵](VISUAL_MW13_X_6_COMBINATION_MATRIX_DISCUSSION_2026-10-16.md)为DRAFT_FOR_OWNER_DISCUSSION，仅列出暂时建议的优先、条件与排除；全部格子未获得Owner逐格认可。
- VERIFIED_REPO_FACTS：13个MW存在于现有Kit清单；MW06/MW08/MW09是储备设计，MW04仅UI Demo，MW11/MW12/MW13有独立HTML QA KEEP候选，MW07后续局部优化为技术KEEP候选；这些不等于所有动作已接入正式Remotion渲染。
- PRESERVATION：R3视觉RETURN、R4未授权、G1/G2/HOLD/NO_PUBLISH继续；旧AI生成禁令未改；不修改既有证据、历史媒体、来源库或本机。
- ACCEPTANCE：仅CWS文档及讨论稿进入GitHub main；回读决策、矩阵DRAFT与当前Handoff指针，避免误认格子已批准。

## EVIDENCE 2026-10-16｜A/B/C决策与漫画叙事生图复用（纯文档）

- OWNER_REPORTED：Owner明确仅三类A视频/B已有图片/C AI生图，并要求查阅旧AI寓言故事项目或相关Skill的高效率低Token路线。
- DIRECT_READBACK：`entropy-student/spike.skill/main`的`comic-narrative/REVIEWER_HANDOFF.md`明确生图executor reliability PASS/CLOSED且并发2；`tools/imagegen-fast-path/README.md`规定output_hint直接结果路径→拷贝→SHA/尺寸/QA、不经TTY/base64搬运图、Native像素不匹配不单独重生；`part4_5/ASSET_REUSE_LIBRARY.md`规定直接复用/基于旧图修改/仅作参考/新生图四分支。
- LIMITATIONS：工具链在源项目已验收，不代表CWS已集成；没有逐图Token用量或费用最小化实测。本轮没有任何生图调用、付费、代码执行、视频合成、R4/公开发布授权。
- PRESERVATION：旧13×6提案降为历史；正式R3视觉RETURN、R4未授权、G1/G2/HOLD/NO_PUBLISH不变，视频同源全项目只用一次的规则不变。
