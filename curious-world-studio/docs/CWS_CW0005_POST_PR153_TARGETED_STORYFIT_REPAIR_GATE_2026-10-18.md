# CWS｜CW0005 PR#153之后：定向视觉Story-Fit修复及一次内部样片Gate（2026-10-18）

> **状态：OWNER_AUTHORIZED / EXECUTOR_NOT_STARTED / ONE_BOUNDED_REPAIR / REVIEW_REQUIRED**。Owner于2026-10-18在收到[独立Reviewer PR#153视觉RETURN](reviews/CW0005_PR153_INDEPENDENT_VISUAL_STORYFIT_REVIEW_RETURN_2026-10-18.md)和“只做一轮定向视觉返修”的建议后回答**“我没问题”**；这是**失败后新的实质制作授权**，不是旧联合Gate的无限重试。
>
> **规范**：[VPS Project Governance v0.2.7](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md)，Reviewer已核验权威版本与适用§11B/11C/11D/11G（Windows本机状态、隔离浏览器/资源、可选静态AI图）及共享资源保护。本Gate依§5将 storyboard可见性检查→小范围纠偏→单条真实MP4→技术QA**合并**，不逐阶段再次征求Owner同意。
>
> **已验收可继承**：V5.6.2 6内容模板/唯一Research Aqua原Mac外壳，main冻结HTML git blob `33aabc3ff2e48877493277eb1a86274818e3c769`，旧V5.2保留；CW0005 R2十句旁白、现有WAV/SRT和视频生产/FFmpeg解码技术；前轮55.266667秒MP4 `be48565792f94fccdebb95229d8744d044b1edf47a1cdbfa9015dc37e0ebda6c`只作失败视觉基线，不再提交为合格内容；PR#153执行证据已合并main。**⑤真实证据呈现和⑭视觉故事仍RETURN；G1/G2/R4/NO_PUBLISH/RIGHTS_PARTIAL不变。**

## 1. Gate合同

- **GATE_ID**：`CWS-CW0005-POST-PR153-TARGETED-VISUAL-STORYFIT-REPAIR-20261018`
- **OBJECTIVE**：最小改动重排CW0005 S01–S10的真实视觉内容：展示**170°C 17/50 vs 180°C 48/50样本比较**、淀粉脚**形成→受压→回弹**、声学**第二次破裂约100ms→声音约106ms（独立实验）**，并以唯一冻结Research Aqua桌面双击文件→全幅QuickTime→关窗回桌面完成**一条**30–60秒真实内部连续音画样片。
- **MAX_ENDPOINT_THIS_ROUND**：一份真实可读Storyboard/关键帧预检及最多**一条最终修正版连续MP4**；如发生明确局部渲染/字幕技术错误，可在当前Gate内至多**一次有证据的同一原因修复并重渲**，累计不超过两次实际完整渲染。若科学真实性、来源权限、原Mac组件集成或核心分镜结构失败，立即**RETURN并停止新渲染**，不得再无证推测第三版。
- **MANDATORY_REVIEW_STOP**：Codex只给`PASS_CANDIDATE`或精确`RETURN_*`。最终MP4真实文件必须供Reviewer独立观看/核字节；只有Reviewer独立通过并由Owner观看认可后才可解除⑤⑭。不得自行推进完整4–6分钟、第二选题、正式R4、PR合并或发布。
- **TARGET/SCOPE**：Owner真实Windows 11本机 `curious-world-studio/`；冻结HTML只读；已冻结正文不改；只在**干净CWS隔离工作树/分支PR**新增最少编排、渲染适配源码（如必要）、局部测试、脱敏Evidence。媒体/音频/抽帧/完整MP4只留Owner本机项目专属忽略目录，不进Git。
- **OWNER_ONLY_ACTIONS**：Owner此次已批准一轮定向内部样片、免费合法的新素材定向搜取和必要时非新增付费的静态AI概念图；**不授权**额外收费服务或未知预算支出、账户权限重置、版权条款突破、正式公开/商用、完整R4及第二题生产、不可逆删除/共享资源变更。普通前置质量步骤按Gate可连续进行，无须让Owner逐项批复。

## 2. 严格复用与视觉返修目标

### A. 唯一Mac外壳，而非近似重画

1. 从main的`visual/frozen/storyboard-v5-6-2-20261018.html`原字节及其**`TEMPLATE_RENDERERS/TEMPLATES/compileTimeline`**等现有接口做最小适配；在非冻结新编排层注入本期`EDITORIAL`或兼容数据、真实媒体槽和Cue/SRT，**保留一套原Canvas/Mac/Aqua/QuickTime及单Master Clock**；严禁沿用PR#153中简化蓝底标题卡、手写伪QuickTime重做外壳或做第二播放器。
2. 视觉必须可认：Tiger桌面菜单栏、Dock/文件、真实双击开窗A→B、全幅QuickTime主体、片尾点红灯回桌面；不能拿静态标题帧冒充这些交互。若现有冻结实现不支持本机视频/音画输出，允许**仅在隔离派生版本**写最小适配器并附源码diff/对照关键帧，绝不覆盖冻结原字节。
3. 媒体内容实际切到T1/T2/T4/T5/T6，使用原模板已有的三种布局/数据、序列能力；**T6是真数值可读比较，不是画面顶部文字**，T5三态为真实不同科学状态，T2声学的两个时点必须视觉有别。尊重`STYLE_LOCK`的1920×1080/30fps、单行中文字幕与安全区、B全幅。

### B. 精确镜头表（执行前先形成可见Storyboard）

| 镜头 | 视觉功能 | 已有模板与必须看到的变化 | 最低事实边界 |
|---|---|---|---|
| S01 | 先引发“为什么会跳？” | T1，新的一段相关动作实拍，不能用死锅画面凑开头 | 辅助实拍≠原研究高速录像 |
| S02–S03 | 统计与单粒阈值的区别 | **T6主体数据**：170°C:17/50、180°C:48/50；用适当比例/对照显示，S03转为样本局限 | 论文数值，非原Figure1像素；不能称每粒180°C必爆 |
| S04–S06 | 论证“脚”而非蒸汽火箭 | **T5主体3个不同科学静态状态**：壳裂/淀粉脚出现→接触热板受压→脚回弹使颗粒离开热板；S06对照论文结论 | 正确说明原论文观察时间6.9/13.8/20.7ms是**研究帧时刻**，非动画物理时间；“未观察到火箭效应”，非蒸汽绝对无影响 |
| S07–S08 | 另一组声学实验，延迟约6ms | **T2或T6可见双事件**：约100ms二次破裂、约106ms声响开始，关系清楚、来源标注可读 | 不画假研究声波/伪音轨；不称来自当前库存实拍 |
| S09–S10 | 区分结果与假说，收束 | T2/T6：已观察脚回弹 vs 作者推测水汽压降激励空腔振动 | “假说”标记明显且收尾不回纯文字/PPT |

- S01–S10的**R2原定十句语义与字词锁定**，可沿用PR#153中已有53.760秒配音WAV、已有字幕/时间Cue（不改变正文、不因找不到图而偷删句）；只校时验证对应，无须再执行两轮润色或重新收费配音。
- S05旧小窗AI图片`1F27E804...`**禁止继续作为机制证明**：有向上橙色射流/箭头易被读成喷汽推动；可以作为失败对照留档。优先已批准来源的可靠静态图，如原研究Figure3a许可不确定，则本轮允许最多**三张**科学准确的AI静态概念图（分别对应三态），以“AI概念示意·非研究录像”标识；不能照抄原研究帧、画火箭喷焰、模拟真实科研原片或用程序代码绘制物理对象。先核实图像中的**接触、压缩、回弹**确实独立可辨；Governance 11G并发最多2，先库内可复用，明确必要才生新图，保留尺寸/hash/QA。若无安全低成本生成路径，标记缺口、改用足够准确的其他静态材料，禁止暗用付费API。
- R3旧Pexels **#854959**、Pixabay **#2793**和PR#153已使用的Pexels **#1796141/#35876717**要在原始作品级台账继续标记“已用于历史样片”；**新返修成片不得以同一来源素材再次出现或换URL/裁切/镜像规避**，除非以后由Owner显式变更一次性规则。本轮允许仅为真正缺口定向找新的可合规使用横屏实拍，或使用上一轮只预览但**未进入样片且适配**的源；不重做80站点搜索、不把旧媒体重复算新作品。静态图片的项目级一次性禁令未获设立，不要错误推广。
- 未获具体再利用权的官方研究图片/补充电影不能从“文章可看”推导为能直接用于新成片；默认**仅依据论文公开数据作事实可视化**，研究原媒体除明确许可外不嵌入可共享MP4。私人内部样片不等于发布许可，所有候选标注`LINK_FOUND/CONTENT_VERIFIED/REUSE_RIGHTS_VERIFIED`和用途限制；`RIGHTS_PARTIAL/UNKNOWN`不自动升级。

## 3. 执行序列与必要停线（同一个Gate连续完成）

**PREFLIGHT**：核实Owner Windows本机的repo remote、branch/head、已验收PR#153音画/WAV/SRT、真实冻结HTML blob、旧工作树与隔离工作树、资源/可用工具和目标输出目录；写入前证明备份/回滚边界。不要重跑已PASS的工具安装、多站爬虫或模板技术全量测试。若局部工具在本机确实不可用，针对其单点最小修复；不修改全局Clash/VPN/代理、Docker系统资源、用户私人Edge或其他项目。

**STEP 1 / 故事板与关键帧预检（必须实际检查，不可仅输出文字表）**：先构造足以覆盖4类科学视觉状态的可看屏幕关键帧：①原Mac桌面及点击、开窗；②T6温度数值比较；③T5的3个不同科学状态；④T2/T6声学两个事件；⑤结束回桌面。记录截图/预览和对应的镜头ID、可读性、证据出处、长短及字幕避让，不上传受限媒体到Git。关键帧QA**PASS_CANDIDATE**后才进入下一步，不需回Owner批示；若只是相同锅片叠文字、三态画面不可区分、原Mac外壳没有复用，**在此止步修正Storyboard而不启动MP4渲染**。若核心图像科学语义有误无法最小修正，精准`RETURN_STORYBOARD_SCIENCE_OR_VISUAL`并停止。

**STEP 2 / 单条内部成片**：据已有真实WAV/Cue/SRT生成**一条**30–60秒、1920×1080@30fps连续MP4；一条Master Clock，实际按语音时间进行同步，开场与片尾均完整。不得在S02–S09用冗长库存背景遮掉T6/T5/T2主体；不得压缩/删除冻结旁白以凑60秒。若短片超过60秒，先检查节目时轴与开关窗预算，在不变更实际口播的情况下收紧非叙事空白，不机械快放音频。
  
**STEP 3 / 本机QA**：FFprobe文件/音画时长、FFmpeg全解码，独立隔离浏览器从头到尾1×播放（含实际窗口/Canvas）、画面至少8个指定关键时点截图、字幕逐时码对齐、科学画面三态辨认及同源去重、冻结HTML Git SHA回读。音频还须至少一段人工或可靠可重现的听审证据，无权限时标`VOICE_BY_EAR_UNVERIFIED`，不可假PASS。内部HTTP/浏览器停后确认仅本轮进程退出、监听清零，不触碰Owner已有Edge。
  
**STEP 4 / 证据PR停Reviewer**：在CWS隔离分支新PR提交脱敏`EXECUTION_EVIDENCE`、差异说明及必需的最小新编排源码/回归脚本，不上传视频/原图库/可能侵权的第三方内容/私人绝对路径/Token/Cookie。报告能从`sceneJSON`关联S01–S10→模板→真实来源→WAV/SRT；MP4只能存本机忽略目录，注明SHA、绝对路径由Owner本机持有；本轮**推荐Owner直接通过对话上传MP4给Reviewer**以免再次出现不可实看阻断。此轮交付后停止，Reviewer另判PASS/PARTIAL/RETURN，Owner另判审美PASS。

## 4. 必需证据、验收和回滚

**REQUIRED_EVIDENCE**：
1. 真实源清单/权利与**历史四条视频作品级占用记录**（旧R3两条＋PR#153两条）及新候选合法来源/片段，静态概念图尺寸/SHA/标识；
2. 视觉Storyboard关键帧按组的直接预检截图与科学核对结论（A完整Mac、T6温度、T5三态、T2/T6声学、结尾桌面），不是一句“布局通过”；
3. 精确S01–S10 `source_identity, first_use, shot, template, visual_purpose, video_in/out, asset_in/out, narration/cue, subtitle`、原始字词未改证明及模板复用代码diff；
4. 最终MP4/WAV/SRT/sceneJSON的SHA、规格、FFmpeg全解码、浏览器1×连续播放、关键帧、音频/字幕检查、范围清洁与监听回收证据；
5. 新PR/Commit SHA、执行异常及尝试次数、明确`ROLLBACK`，数据/媒体保留本机的安全访问办法；未达到某一条件则精确PARTIAL/RETURN，不虚称PASS。

**ACCEPTANCE**：Reviewer能实际看新视频、验正确原Mac交互、T6数值、T5脚形成/压缩/回弹、T2/6声学事件及作者假说、不同实际叙事画面、画面不遮字幕、S01–S10自然顺序、同源唯一性、编码解码和权利声明。脚/声源假说真实边界正确、不产生火箭效应误导。**不能用0次技术报错代替视觉PASS；Owner实看才给最后内容/审美PASS。**

**ROLLBACK**：旧Mac冻结HTML、R2稿、PR#153失败样片及SHA、所有旧本地包和缓存永久保留本轮可恢复证据；新工作在独立Git分支/本轮唯一新忽略目录，可回退本次PR/适配源码，但无单独清理授权不得删旧片/媒体或改原工作树。任何非目标路径被碰/已有原片覆写/出现真实账号费账→停止并返回Reviewer。

## REVIEWER_TO_EXECUTOR_RELAY（Codex从这里启动）

**仓库**：`https://github.com/entropy-student/project`，目录`curious-world-studio/`；Codex拥有独立读取和隔离分支写入GitHub权限，无需Owner传ZIP。**新且唯一授权Gate**就是此文件，旧2026-10-18联合Gate已执行并被正式视觉RETURN，严禁重复执行。

**只读优先材料**：本Gate；`docs/reviews/CW0005_PR153_INDEPENDENT_VISUAL_STORYFIT_REVIEW_RETURN_2026-10-18.md`（失败事实）；`docs/CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md`；`docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`；`visual/retro-mac-v1.2/docs/STYLE_LOCK.md`；`visual/frozen/storyboard-v5-6-2-20261018.html`（唯一冻结真源）。只为确认现有WAV/SRT/旧编排及新图像调用接口时阅读前次PR#153的`docs/reviews/CW0005_COMBINED_STORYFIT_EXECUTOR_2026-10-18.md`与本机已知输出；无需重读Governance或全仓历史。

**按STEP 1→2→3→4连续执行，确保第1步QA达标才花一次完整渲染成本；不能因为某一个素材缺口重复请求Owner为每个子操作批准，也不能无条件跳过前置质量检查。**

**EXECUTOR_TO_REVIEWER_RELAY**：按Governance七行（结果/改动/验证/问题/回滚/请Reviewer检查/Owner转交），附PR、Commit、真实新MP4 SHA与本机安全审看说明；在Reviewer处停止、不得自行合并、不得发布、不得宣布⑤⑭正式通过。
