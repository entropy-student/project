# Curious World Studio｜唯一当前状态（2026-10-16）

> **最新R3修订样片复核（覆盖下文旧待返修时态）**：**R3返修已获Reviewer独立技术与画面核验通过**：同一Gate返修ZIP外层SHA `84ddaac6b21279a1a77a46a5a85f71e5528b7d5f0a21274918aeb9bf07c919e0`，CRC通过，内部SHA57/57，最终MP4 `7b913ef24888257e3e341a690758286af7361b0d1d4db0d719315623bcdac4a5`，55.366667秒，1920×1080/30fps H.264与AAC全片独立解码通过；S05三步卡、字幕深色底框、Pixabay编号链接和路径脱敏都已核验。**正式完整R3尚为 `PARTIAL_AUDIO_LISTEN_UNVERIFIED`**：已有实际音轨和非静音信号，但Reviewer无法通过当前工具进行真人听感/发音及主观自然度试听；Owner只需对提供的MP4进行一次声音与审美确认，不需再次执行Codex或重渲染。旧`RETURN_R3_VISUAL_AND_EVIDENCE_MICROFIX`已在返修中实质修复。唯一已知非阻塞证据瑕疵：`evidence/revision_media_qa.json`仍保存先前渲染候选SHA/文件大小，与最终MP4不符；当前manifest、SHA256SUMS和FFprobe均与实际MP4一致，详情见[执行证据](EXECUTION_EVIDENCE.md)。素材权利`PARTIAL`、正式`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH`不变；R4未授权。


> **2026-10-16 最新R3验收增量**：PROD-R3样片已制作，Reviewer技术完整性PASS、正式总评 RETURN_R3_VISUAL_AND_EVIDENCE_MICROFIX：S05浅色卡上的白字字幕对比不足，三步卡与实际旁白的受压/回弹顺序有错位；Pixabay #2793台账链接误写为#37441；脱敏包有本机绝对路径。保持同一个R3 Gate，仅作已发现问题的有界修正；不重配音、不搜新素材、不增基础设施。正式CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH不变。 [执行证据](EXECUTION_EVIDENCE.md)。

> **2026-10-16 R2完成与R3授权历史记录**：PROD-R2 旁白与S01–S10编辑经Reviewer独立验收PASS；Owner已授权PROD-R3 仅本机内部30–60秒有声样片，但**尚未执行**。正式CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH 保持。当前任务请见 [R3 Gate](PROD_R3_CW0005_INTERNAL_AV_SAMPLE_GATE_2026-10-16.md)，生效旁白见 [R2定稿](CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md)。


> **Owner最终明确：画面相关就可以，不追求逐句精准或逐帧对应。** 前任Reviewer将爆米花“淀粉脚受压反弹”的高速实验影像升级成持续制作的必需条件，并据此增加素材轮次，**这是过严的编辑判断，已纠正**。科学事实、诚实标注“辅助素材”、素材使用权不放宽；但普通相关实拍配准确旁白及简洁出处文字即可用于内容方案。不再因缺某段原研究实录自动搜更多站点、重做R6/R7或延期全部创作。历史`PARTIAL_ASSET_GAP`只保留原试验结果。

## 1. 项目整体状况

**定位**：不露脸、跨领域“为什么”知识视频，B站主阵地，抖音/小红书辅助；“知识小众，问题大众；证据真实，承诺兑现”。“世界有点意思”为候选频道名，并未定稿；内容按自然长度讲清问题，不要为了时长或技术炫技注水。

| 轨道 | 已验证/完成 | 未完成或禁止夸大 |
|---|---|---|
| 选题与研究 | 36题（SHORTLIST 11 / VERIFY 15 / HOLD 9 / REJECTED 1），九源定向发现、Story-Fit流程 | 九源未稳定全量抓取；入SHORTLIST≠可开拍 |
| 叙事与脚本 | 三机制：解释、追具体答案、重建选择；多个纸面原型；CW-0005 R2修订旁白和S01–S10编辑审核PASS | 尚无录音/真实字幕同步/正式Story-Fit放行及受众测试 |
| 视觉 | Mac Tiger Aqua短桌面A→全幅QuickTime 7银灰播放器B，1920×1080@30fps、单行字幕，HTML原型及9秒技术样片 | 非完整5分钟音画成片；渲染长片稳定性、声音字幕对齐未通过 |
| 音频与制片基础 | Remotion/FFmpeg媒体适配器PR#116已合并；OpenMontage的Pexels/Pixabay与Qwen TTS已有技术方案 | 正式旁白、字幕时间对齐、成片未验收 |
| 素材R1–R5 | R2历史获取22视频/31图片；R3盘点300域/197站测试；R4+R5 10个非PeerTube技术来源 | 151/153成功站是PeerTube实例；候选不是已获权利素材；R4+R5仍PARTIAL_ACCEPT |
| G2–G4 | Windows本机Docker SearXNG+4get按需启动；真实搜→指定ID下载→FFprobe/FFmpeg解码→Owner Edge预览→安全停止，TECHNICAL_ACCEPT | 浏览器Owner实测不等于独立Reviewer现场观看；素材内容/许可另查 |
| 统一素材CLI | PR#129与PR#131均已合并main。`media-pipeline/cws_media.py`提供`doctor/discover/catalog/fetch/gallery`、Compose生命周期及Ctrl+C清理 | 外部搜索源部分降级，默认`PARTIAL_SEARCH/ok:false/exit1`；接受结果须主动`--allow-partial`，非公网工具 |
| R6L/R7L快配试验 | 2026-10-16已结束，历史Reviewer`PARTIAL_ASSET_GAP`。复用Pexels 854959/Pixabay 2793普通锅内及氛围镜头，95搜索结果→90去重 | 5新研究链接未播放，仅LINK_FOUND；精确高速科研片未证实；**不再把这个缺口当作必须补齐才能继续编辑的规定** |
| 正式制片 | R2编辑PASS；R3返修实际55.367秒音画MP4与画面技术验收PASS（修订ZIP内SHA57/57、全片独立解码） | 需Owner进行一次音色/发音听感审美确认，Reviewer当前无法独立听声；R3总结果PARTIAL_AUDIO_LISTEN_UNVERIFIED；素材权利PARTIAL、正式HOLD/G1/G2/NO_PUBLISH继续；R4未授权 |

## 2. 爆米花现有内容和可复用候选

- 2015论文`The physics of popcorn`（https://pmc.ncbi.nlm.nih.gov/articles/PMC4345489/）。爆裂温度、跳跃机制、响声实验事实已历史核证；不是所有事实均须以实验影像逐帧重演。
- **Pexels 854959**（20.223秒、1920×1080）及**Pixabay 2793**（25.7267秒、1920×1080）：Codex曾在Windows获取并整片解码，本轮验证历史SHA并抽6张JPEG；可作为**普通相关实拍候选**，不是论文实验原片。声音未听、未用；权利`PARTIAL`，使用前仍核具体许可。原MP4位于Owner本机忽略路径`.local/R2-M1/provider-output/`，没有上传Git。
- 一轮95搜索结果→90去重，5个链接仅标题相关，未实看/未验许可。`S04–S06`研究“淀粉脚受压反弹”的**精确真实录像缺失是历史素材事实，不是新拍摄任务**。不要拿库存片标“研究高速实录”；优先把原稿这段的画面承诺改为相关实拍+准确旁白+来源文字，避免观众误认。
- R6L原始ZIP `CWS_MEDIA_R6L_R7L_FAST_MATCH_PILOT_20261016.zip` SHA256 `81591798ede2c838bbc8cc31c8b5fb22edbd5f497d90e7142cfcae141e78c4f8`。独立Reviewer确认CRC、20 SHA、19 manifest、6图片/HTML嵌入一致；**没有独立读取完整原MP4**。搜索+清理28.2秒、QA抽帧3.8秒只属机器日志，整体人工看片时间未记录。

## 3. 当前执行路径（2026-10-16生效）

1. **PROD-R2内容编辑PASS**：修订包 CWS_PROD_R2_CW0005_EDITORIAL_REVISION_20261016.zip，外层SHA-256 e547e48cd107b7a05e47aae466fc9efbd84f8a381f9065a0bb8213cd0dc5c6dc；Reviewer独立校验ZIP CRC、包内6/6 SHA及S01–S10，核对S05/S07与论文标题。已接受的文本与镜头设计见 [R2定稿](CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md)。约55秒仅为估算，没有配音、字幕对齐、成片。
2. **PROD-R3内部样片已实际执行，Reviewer要求原轮次小修**：仅使用既有脚本、Aqua→QuickTime、Qwen TTS、Remotion/FFmpeg、两条相关真实库存片，在Owner Windows本机已产出55.367秒内部MP4，独立Reviewer已校ZIP与解码；S05字幕对比/步骤时序和台账脱敏需原轮次小修；任务、验收与回滚见 [R3 Gate](PROD_R3_CW0005_INTERNAL_AV_SAMPLE_GATE_2026-10-16.md)。
3. Owner不希望再因版权调查拖延**内部测试**；Pexels 854959及Pixabay 2793复用权仍PARTIAL、不被冒充原科研实录，也不视为已获公开发布/商业许可。正式G1/G2/HOLD/NO_PUBLISH继续不变。
4. 不重跑MEDIA G2–G4、PR129/131、R6L/R7L，不新建逐帧识别模型或80站点搜片轮次。若内部小样检查通过，R4须另获Owner批准；发布仍需独立授权。
5. 已生效决策见 [DECISION_LOG](DECISION_LOG.md)，关键执行证据见 [EXECUTION_EVIDENCE](EXECUTION_EVIDENCE.md)。

## 3A. 完整视频与后续每期的双轮文案润色（Owner已决定）

新增长期表达流程：[中文科普口播双轮润色工作流](VIDEO_SCRIPT_POLISH_WORKFLOW.md)。R2/后续每期的完整旁白在录音前按**human-writing（v1.1.0，结构与表达）→ humanizer（用户指定v3.1.0，去模板化）→ Reviewer事实/口播回归检查**处理；R4全片新增/重写部分须先完成该流程再制作正式配音和字幕。保留科研事实、出处和假说边界，不为“去AI味”删知识；这是R4和未来视频的**流程要求而非R4执行授权**。已经下发的R3同Gate小修仅处理字幕与证据问题，**不因本新规范返工重配音**。

## 4. 执行与交接边界

- **3+1素材合同**保留：论文/研究机构一手、OpenMontage、合法yt-dlp；后期仅2转场/4布局/6信息。新视频默认非大陆平台、横屏≥4:3、优先1080p。禁AI伪造研究实拍、代码绘制实体、循环重复凑时长；`LINK_FOUND`、`CONTENT_VERIFIED`、`REUSE_RIGHTS_VERIFIED`各自独立。精确匹配要求降低不等于素材权利放宽。
- Windows 11 + Docker Desktop/WSL2，搜索容器只绑定回环、按需启停；不部署VPS、不改代理/VPN/Clash或其他项目Docker、不清除旧缓存/媒体/备份。保留曾报告的3项未提交tracked改动、2项缓存及Ubuntu tar，不能`reset --hard`、`git clean`、`docker system prune`、`down -v`。真实运行资源状态按每次现场测量。
- **新Reviewer首读**：[本轮完整交接](REVIEWER_HANDOFF_CURRENT.md)→[CWS AGENTS](../AGENTS.md)→[3+1合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)→[视觉锁](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)→[工具手册](../media-pipeline/README.md)。旧[2026-10-12科学/素材交接](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)保留历史证据，但其“必须有高速原片才能继续”的编辑Gate已经被Owner降低精度的决定修订。

**本期结论：R2编辑PASS；R3返修已独立通过视频技术与S05画面检查；只待Owner确认一次声音/整体审美（非技术QA），无需再向Codex下发修复任务。正式Gate与R4权限不变。**
