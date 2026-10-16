# Curious World Studio｜唯一当前状态（2026-10-16）

> **Owner最终明确：画面相关就可以，不追求逐句精准或逐帧对应。** 前任Reviewer将爆米花“淀粉脚受压反弹”的高速实验影像升级成持续制作的必需条件，并据此增加素材轮次，**这是过严的编辑判断，已纠正**。科学事实、诚实标注“辅助素材”、素材使用权不放宽；但普通相关实拍配准确旁白及简洁出处文字即可用于内容方案。不再因缺某段原研究实录自动搜更多站点、重做R6/R7或延期全部创作。历史`PARTIAL_ASSET_GAP`只保留原试验结果。

## 1. 项目整体状况

**定位**：不露脸、跨领域“为什么”知识视频，B站主阵地，抖音/小红书辅助；“知识小众，问题大众；证据真实，承诺兑现”。“世界有点意思”为候选频道名，并未定稿；内容按自然长度讲清问题，不要为了时长或技术炫技注水。

| 轨道 | 已验证/完成 | 未完成或禁止夸大 |
|---|---|---|
| 选题与研究 | 36题（SHORTLIST 11 / VERIFY 15 / HOLD 9 / REJECTED 1），九源定向发现、Story-Fit流程 | 九源未稳定全量抓取；入SHORTLIST≠可开拍 |
| 叙事与脚本 | 三机制：解释、追具体答案、重建选择；多个纸面原型；CW-0005 50–60秒修订稿、S01–S10镜头表 | 尚非正式获批完整剧本，无受众测试 |
| 视觉 | Mac Tiger Aqua短桌面A→全幅QuickTime 7银灰播放器B，1920×1080@30fps、单行字幕，HTML原型及9秒技术样片 | 非完整5分钟音画成片；渲染长片稳定性、声音字幕对齐未通过 |
| 音频与制片基础 | Remotion/FFmpeg媒体适配器PR#116已合并；OpenMontage的Pexels/Pixabay与Qwen TTS已有技术方案 | 正式旁白、字幕时间对齐、成片未验收 |
| 素材R1–R5 | R2历史获取22视频/31图片；R3盘点300域/197站测试；R4+R5 10个非PeerTube技术来源 | 151/153成功站是PeerTube实例；候选不是已获权利素材；R4+R5仍PARTIAL_ACCEPT |
| G2–G4 | Windows本机Docker SearXNG+4get按需启动；真实搜→指定ID下载→FFprobe/FFmpeg解码→Owner Edge预览→安全停止，TECHNICAL_ACCEPT | 浏览器Owner实测不等于独立Reviewer现场观看；素材内容/许可另查 |
| 统一素材CLI | PR#129与PR#131均已合并main。`media-pipeline/cws_media.py`提供`doctor/discover/catalog/fetch/gallery`、Compose生命周期及Ctrl+C清理 | 外部搜索源部分降级，默认`PARTIAL_SEARCH/ok:false/exit1`；接受结果须主动`--allow-partial`，非公网工具 |
| R6L/R7L快配试验 | 2026-10-16已结束，历史Reviewer`PARTIAL_ASSET_GAP`。复用Pexels 854959/Pixabay 2793普通锅内及氛围镜头，95搜索结果→90去重 | 5新研究链接未播放，仅LINK_FOUND；精确高速科研片未证实；**不再把这个缺口当作必须补齐才能继续编辑的规定** |
| 正式制片 | 制片R1–R4流程规范已写 | **`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH`仍为正式Gate**；不能未经Owner授权制作/发布 |

## 2. 爆米花现有内容和可复用候选

- 2015论文`The physics of popcorn`（https://pmc.ncbi.nlm.nih.gov/articles/PMC4345489/）。爆裂温度、跳跃机制、响声实验事实已历史核证；不是所有事实均须以实验影像逐帧重演。
- **Pexels 854959**（20.223秒、1920×1080）及**Pixabay 2793**（25.7267秒、1920×1080）：Codex曾在Windows获取并整片解码，本轮验证历史SHA并抽6张JPEG；可作为**普通相关实拍候选**，不是论文实验原片。声音未听、未用；权利`PARTIAL`，使用前仍核具体许可。原MP4位于Owner本机忽略路径`.local/R2-M1/provider-output/`，没有上传Git。
- 一轮95搜索结果→90去重，5个链接仅标题相关，未实看/未验许可。`S04–S06`研究“淀粉脚受压反弹”的**精确真实录像缺失是历史素材事实，不是新拍摄任务**。不要拿库存片标“研究高速实录”；优先把原稿这段的画面承诺改为相关实拍+准确旁白+来源文字，避免观众误认。
- R6L原始ZIP `CWS_MEDIA_R6L_R7L_FAST_MATCH_PILOT_20261016.zip` SHA256 `81591798ede2c838bbc8cc31c8b5fb22edbd5f497d90e7142cfcae141e78c4f8`。独立Reviewer确认CRC、20 SHA、19 manifest、6图片/HTML嵌入一致；**没有独立读取完整原MP4**。搜索+清理28.2秒、QA抽帧3.8秒只属机器日志，整体人工看片时间未记录。

## 3. 新路线：进入内容而不是再造素材工具

1. **不再开新“精确匹配轮次”**：不建逐帧模型、不要求所有镜头精确毫秒时码、不重复站点枚举、不因5个LINK_FOUND扩大调查。
2. **建议的下一件事是编辑而不是搜索**：复用既有50–60秒文本/S01–S10，整理成一份**简洁的旁白↔相关真实镜头↔必要来源文字**蓝图。普通实拍可支持科普讲述，关键科学事实准确而不假装有对应实录；不合适就调整镜头承诺/删短文案。**此建议尚未下发Codex执行**。
3. Owner若确认该内容方向及具体素材许可，再授权制作30–60秒**仅内部观看**的声音/字幕/画面小样；小样QA后才考虑完整自然时长草片。发布需再获明确批准。历史Gate暂维持，不由Reviewer直接解锁。
4. 因某一证据画面无法取得时，先决定如何诚实表达，**不是默认追加一次研究素材搜查**。尽量减少用户的技术审批和重复看片负担。

## 4. 执行与交接边界

- **3+1素材合同**保留：论文/研究机构一手、OpenMontage、合法yt-dlp；后期仅2转场/4布局/6信息。新视频默认非大陆平台、横屏≥4:3、优先1080p。禁AI伪造研究实拍、代码绘制实体、循环重复凑时长；`LINK_FOUND`、`CONTENT_VERIFIED`、`REUSE_RIGHTS_VERIFIED`各自独立。精确匹配要求降低不等于素材权利放宽。
- Windows 11 + Docker Desktop/WSL2，搜索容器只绑定回环、按需启停；不部署VPS、不改代理/VPN/Clash或其他项目Docker、不清除旧缓存/媒体/备份。保留曾报告的3项未提交tracked改动、2项缓存及Ubuntu tar，不能`reset --hard`、`git clean`、`docker system prune`、`down -v`。真实运行资源状态按每次现场测量。
- **新Reviewer首读**：[本轮完整交接](REVIEWER_HANDOFF_CURRENT.md)→[CWS AGENTS](../AGENTS.md)→[3+1合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)→[视觉锁](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)→[工具手册](../media-pipeline/README.md)。旧[2026-10-12科学/素材交接](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)保留历史证据，但其“必须有高速原片才能继续”的编辑Gate已经被Owner降低精度的决定修订。

**本期结论：基础设施够用。下一位Reviewer要帮助完成内容与可看片段，而不是继续寻找完美素材。**
