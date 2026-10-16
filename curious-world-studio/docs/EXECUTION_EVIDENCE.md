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
