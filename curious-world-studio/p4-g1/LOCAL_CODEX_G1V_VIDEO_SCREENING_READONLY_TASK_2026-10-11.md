# P4-G1V｜给本地 Codex 的原始实验动态视频只读验证任务

**日期**：2026-10-11 · **允许范围**：浏览公开网页、观看/暂停/跳转原站视频、记录可见上传信息与证据、只读比较论文和已有项目资料、在**隔离临时目录**制作文本核对报告。**这不是视频下载、转载、剪辑、调起 Remotion 渲染或联系作者的许可。**

## 0. 先读当前 main

按顺序：
- `curious-world-studio/docs/CURRENT_STATE.md`
- `curious-world-studio/docs/P4_G1V_ORIGINAL_VIDEO_DISCOVERY_RIGHTS_AND_VISUAL_RESET_2026-10-11.md`
- `curious-world-studio/p4-g1/evidence/JB_ORIGINAL_VIDEO_SOURCE_REGISTRY_2026-10-11.json`
- `curious-world-studio/research/story-fit/prototypes/2026-10-10_P3R4_J_B_FULL_READTHROUGH_V1.md`
- `curious-world-studio/visual/retro-mac-v1.2/docs/STYLE_LOCK.md`

前轮 R2 MP4 已有，不需要再渲染它、查 WAV 或尝试修改字幕。

## 1. 三个确认的官方 URL

1. 制作：<https://youtu.be/S75xd_0SOVs>
2. Video 1（High-A/Low-E）：<https://youtu.be/0_hgrf0pi2Y>
3. Video 2（Low-A/High-E）：<https://youtu.be/0GW9b6Sk-9U>

追溯来源：<https://www.uec.ac.jp/eng/news/announcement/2026/20260624_7779.html>、<https://doi.org/10.1371/journal.pone.0350612>。论文 S3 Appendix 仅“links to videos”，未证外部视频 CC BY。不得另找画面相似的营销视频/转载剪辑替代。

## 2. 真正观看，逐视频填证据卡

每条至少收集：

- `video_id`、URL、**实际播放器标题、上传者/频道、公开视频时长、日期、分辨率选项、具体上传页 Licensing 显示值**；若只能看到普通观看页而找不到许可证，填 `UNKNOWN`，不要假设 Creative Commons。不要把 YouTube 默认标准许可证填成已经亲自看到的该视频许可证。
- 是否能完整打开和正常播放；首15秒是否只是音频检测；台词/现场原音的表现；研究行为具体发生在哪些时点。特别：Video 1 说话与静止，Video 2 挥手、膨胀玩具、铃声、告别。**每个候选剪辑的时间码须靠播放真实确认**，不能照抄论文截图 15、19、33、36、47、62、76、86 的数字就填进最终分镜。
- 候选 clip 可预设 `2–5秒` 展示一个**明确动作**，在现场确认后记录 `in/out`、场景作用（发现/对照/反应）、是否包括原作者旁白/音乐/其他第三方内容、是否含会影响B站上传的第三方素材、画质是否够 1080p `contain`。
- 自己确定是**视频画面（VIDEO_VERIFIED）**、静态拼图（FIGURE_ONLY）还是自制示意（ILLUSTRATION），并配来源证据；不能后期改标“原始实验”冒充。
- 核对上传说明或大学新闻稿**是否有允许下载、剪辑、转载、商业使用的明确授权**，保存许可证类型的链接与对应原文片段。如该视频是默认标准 YouTube License，记 `RIGHTS_UNKNOWN_PERMISSION_REQUIRED`；YouTube 的公共可观看许可不代表任意复制视频权。

录一张每视频的 `source_card` 与一个 `clip_candidates` 数组，每条有 `video_checked_at`、`screening_method` 和 `screening_confidence`，不编造播放/授权记录。播放失败就如实标 `PLAYBACK_UNAVAILABLE` 并停止该视频的镜头确认。

## 3. 不越界

- 只用现有已登录的浏览器正常**在线观看**；禁止 `yt-dlp`、浏览器抓包、下载/录屏/缓存导出/网盘镜像/绕平台限制或拿整段视频转码做素材库。确有单独合法下载途径须先报告 Owner 审批，不直接执行。
- 不改变现有 Chrome Headless Shell、Edge、代理、VPN、OpenMontage、Remotion 环境；不调用生成视频、语音模型、FFmpeg 下载/渲染、付费服务；不清理 R1/R2 视频或缓存。
- 未经 Owner 指示不向研究者自动发邮件，也不发布任何未获授权片段。
- 当前不要产生新的 `G1_TECH_PASS` 结论：Owner 已明确判定 **视觉失败**。本轮纯研究判断的完成只能叫 `G1V_SOURCE_SCREENING_READBACK`。

## 4. 输出

建议 `curious-world-studio/docs/P4_G1V_ORIGINAL_VIDEO_READONLY_SCREENING_RESULT_2026-10-11.md` 的**本地草稿**，内含：
- 3 条原始视频的可看/未看、发布者/许可证证据与具体 clip timecodes；
- 版权矩阵（`LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED` 三项完全独立）；
- 值得使用的真实动作镜头建议与来源链接；
- 如权利待作者回复：明确该镜头暂时 **NOT_AUTHORIZED_FOR_EDIT_OR_UPLOAD**；
- 可执行的下一阶段 G1V 方案仅限**获批准**的素材和独立 A/B 动画；
- 机器/人类审阅方式、阻塞点和不确定性。

本次只读任务完成可以提出 docs-only PR；**不可更改正式故事状态、设计锁、商业授权判断或覆盖 R2 历史QA**。
