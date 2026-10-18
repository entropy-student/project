# CWS｜CW0005 联合视觉Story-Fit Gate：原始证据→定向素材→连续短片（2026-10-18）

> **STATUS：OWNER_AUTHORIZED_COMBINED_GATE / EXECUTOR_NOT_STARTED / FINAL_REVIEW_PENDING**。Owner在2026-10-18明确：“一律批准，尽快推进，能合并的gate一律合并”。本Gate将**论文原图/补充影片研究、定向素材筛选/合规获取、分镜绑定、30–60秒单段内部样片、自动化QA和脱敏证据PR**合并为**一个有条件执行边界**。各阶段无需再次等Owner批准；必要安全/实证条件不满足时仅停住受影响分支，不改历史事实、不能伪PASS。正式长片、外部发布与有独立后果的支付/不可逆删除不由本Gate自动开放。
>
> **Reviewer规范来源：** `entropy-student/spike.skill/main:vps-project-governance/VNEXT.md` v0.2.7。Reviewer已核§0–10、§11触发矩阵、§12–13，本轮相关11A（共享资源隔离）、11B（Owner Windows写回与环境）、11C（资源/本机启动）、11D（隔离测试浏览器）、11G（可选静态AI图）；11E付款和11F关站/删除无计划触发。Gate采用一条综合合同，非四轮小Gate。
>
> **上一阶段：** [盘点独立Reviewer PASS（仅素材库存分类）](reviews/CW0005_EXISTING_VISUAL_ASSET_AUDIT_REVIEWER_PASS_2026-10-18.md)，Executor证据在[PR #152](https://github.com/entropy-student/project/pull/152)（未合并）；V5.6.2 [冻结原HTML](../visual/frozen/storyboard-v5-6-2-20261018.html) Git blob `33aabc3ff2e48877493277eb1a86274818e3c769`。旧R3 55.367s样片已获Owner `RETURN_OWNER_VISUAL_STORYFIT`，且旧Pexels #854959/Pixabay #2793两个视频按项目级已用素材封锁。下轮不能伪装成旧R3重试或重跑冻结模板技术验收。

## Gate合同

- **GATE_ID**：`CWS-CW0005-COMBINED-STORYFIT-SOURCE-TO-SAMPLE-20261018`。
- **OBJECTIVE**：完成S01–S10中足以构成独立、清晰、真实的叙事视觉设计，以论文 Figure 1、Figure 3a、Figure 6 与补充视频S1/S2为科研来源线索（按权利处理），补足尚未使用过的现实画面；输出**一条真正连续的30–60秒1920×1080/30fps有声/字幕Mac→QuickTime内部短片**，供Reviewer和Owner实看⑤/⑭，而非仅单张截图/模板demo。
- **MAX_ENDPOINT_THIS_ROUND**：仅CW0005**一条**内部样片，最多1条可供最终Review的完整成片候选及必要的同Gate局部修复（最多2次有根据的重试），本地媒体存项目独立忽略目录；证据与可复现清单由隔离CWS分支PR提交。若证据充分且能完成，则无需中途停下来索要素材搜索、文档研究、下载、分镜或样片的重复批准；但不能越过正式4–6分钟长片、第二题、开公网/发布和批量制片边界。
- **MANDATORY_REVIEW_STOP**：独立Reviewer必须**实看或直接可复核**内部样片和相应素材/脚本证据后决定`PASS / PARTIAL / RETURN`。执行者最多`PASS_CANDIDATE`；不自行改变`G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH`、不合并PR或写main业务源码。若媒体字节不可供Reviewer访问，`VIDEO_VISUAL_REVIEW_NOT_VERIFIED`，工程测试可候选通过，但视觉Story-Fit不得PASS。

### 目标与输入

- 仓库`entropy-student/project`，仅`curious-world-studio/`；Owner真实Windows 11本机、现有media-pipeline和隔离测试浏览器；不得以沙盒/WSL当Owner原生Windows的文件完成证据。
- 审核锁定的唯一旁白内容：`docs/CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md` S01–S10。**媒体选用与视觉布局阶段逐句文字不改；**若用现成R3配音必须确认字词完全对应；否则用已获准的TTS接口生成同文新旁白，并记录音色、时间、成本与状态（若需真实另行付费授权则保留非付费替代，禁止未设上限的收费调用）。润色流程属于后续**完整成片前**阶段，不在本测试偷偷改文案。
- 视觉契约：`docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`、`visual/retro-mac-v1.2/docs/STYLE_LOCK.md`、`docs/VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md`；Research Aqua单一Mac→QuickTime主体、T1–T6直接复用，1920×1080@30fps，单行字幕，Master Clock；不新增第七模板、第二Mac、任意代码绘制科研实体、AI伪实验视频。
- 源研究：Virot & Ponomarenko (2015), `Popcorn: critical temperature, jump and sound`, DOI `10.1098/rsif.2014.1247`，官方PMC https://pmc.ncbi.nlm.nih.gov/articles/PMC4345489/ ，Royal Society研究说明 https://royalsociety.org/blog/2015/02/the-science-of-popcorn/ 。**Reviewer已查原文**：Figure 1=温度与爆开样本比例；Figure 3**仅(a)**=淀粉脚与跳跃高速静帧，（b）（c）是来自其他研究/摄影的改编素材、必须单独处理；Figure 6=高速画面与录音波形同步。该论文标注“© 2015 The Author(s) Published by the Royal Society. All rights reserved”，**不可当CC BY素材库**。正文另提示电子补充movie S1（跳跃）/S2（声学），须核实确切视频、实际下载许可与再利用权；不能当作已许可视频。
- 可参考前轮PR#152的已有本机目录盘点结论，但不能把作者报告的抽帧观看冒充独立Reviewer已见过源视频。

### 有条件连续执行步骤（同一Gate，不拆成审批轮）

**A. 原始证据与权限/画面可读性**：
1. 通过论文/出版方/PMC的真实页面检索Figure 1/3a/6及官方补充movie S1/S2，核对准确图号、图中时点、来源归属、原图像素/标注和作者/出版社/单图许可或使用条件；论文可读≠图/电影可再次发布。按`LINK_FOUND | CONTENT_VERIFIED | REUSE_RIGHTS_VERIFIED`分别判。网页受反机器人/限制时停止该站下载，不绕DRM、Cookie、认证、限流。
2. 对**仅内部研究与测试**，可从可正常访问且条款准许获取的页面下载/缓存少量研究材料；记录URL、下载时的授权依据/限制、SHA、宽高、来源时间、第三方credit。若权利仅不明确，允许**阅读、比对及记录事实**但**不能未经正当依据将其复制进可分享/发布的成片**；可在隔离环境中对原图做非对外的受限评审草案，但应标记`INTERNAL_REVIEW_ONLY / RIGHTS_UNKNOWN`，不得上传原图或成片Git。无法确认合法获取时用屏幕只读观察/来源链接，不违规抓取。Figure 3b/c等第三方元素默认不使用；若图像整体受限，可仅提取事实并用合规来源或后续明确标记的AI静态概念示意替代，而不是伪造实验影像。
3. 记录T4/T5在真正画面中的清晰度、视口裁切、数轴/毫秒标签/来源可读性；若缺项，描述最小局部排版调整方案，**冻结HTML本体永不修改**；需适配可在当前隔离分支的非冻结编排/样片代码里做最小兼容变更并测试。

**B. 定向匹配未用新实拍**：
1. 先用论文实际图像/合法第一手影像满足研究主要论点；再仅对S01等仍缺的**真正动作画面**用现有`media-pipeline/cws_media.py`、已有Pexels/Pixabay/OpenMontage和官方开放媒体做有限搜索/预览/候选过滤（不升级工具、不另起巨大爬取基础设施）；下载精确候选，保留元数据、哈希、关键帧、链接、权利或限制。默认排除国内平台/竖屏/方形；尽量横屏≥1080p。**不要强求精确真实科研高速录像**，相关且无误导的独立实拍足够；片头需要真正相关动作，不能用煮锅无变化的长背景。
2. 全项目`source_identity`去重：Pexels #854959及Pixabay #2793标`BLOCKED_ALREADY_USED`；禁止以其同源转载、转码、镜像、拆片、R3合成成品规避；其他原始视频仅能在该条样片中一个连续播放段使用一次。静态论文图片不是视频，按作者内容/权利规则处理，不引入项目级静态图一次性禁令。
3. 所有候选区分`原始实验 / 论文证据 / 独立复现 / 辅助素材 / 示意画面`。若图/视频缺口仍无法找到，不将“已发现URL”当“下载成功或许可成功”，也不因此改旁白/无限搜片；可进入受限备选策略，但必须保证中心机制不是连续PPT文字卡。
4. 可选C类AI图像仅限**最多2张经证据核查的静态概念插画**，不足则0张；优先复用已合适的现有图像。图像任务仅允许：C-01「爆米花壳裂后淀粉膨胀形成弹性接触点的**概念示意**（不声称实拍、不重现论文帧）」；C-02「声学空腔产生声音的**作者假说情境示意**（显著标注假说）」。若做，每张附准确学术依据与“AI示意”醒目标识，不生成真实科研录像/假图表/伪传感器曲线；遵守Governance §11G最多并发2、existing→edit→new、output_hint直存+hash/尺寸/QA、两次同因失败RETURN。不得调用需临时额外付费/令牌的新服务；若只有付费服务，标为缺口并使用非付费替代。

**C. 视觉Story-Fit编排**：
1. 显式分配 S01–S10每段的信息增量与视觉动作；建议短片约0–4s疑问真实动作→4–12s温度样本Figure1/T4→12–26sFigure3a机制/T5三拍（材料能合法用于内部受限评审才用）→26–32s否定火箭效应/T3→32–50s声学Figure6/T4/T2及作者假说→50–60s对照收束。**这只是候选节拍，不是固定时码**，以真实旁白Cue对齐。若样片实际超过60s，优先选完整叙事起承转合的连续30–60秒作为视觉样本，而不是变速剪短或删改锁定文案；说明覆盖S范围。不能用老R3的“20秒+26秒库存视频+5.85秒纯文字解释”模式。
2. 复用已冻结模板/现有 Remotion/FFmpeg/TTS/Cue/SRT管道，修改只在隔离分支的项目专属编排适配范围内；如果现有技术接口不能直接接成片，先给出最小兼容方案及回归测试（不扩大成重写整套架构）。没有第五类时间控制、持续的UI点击特效、炫技转场/动态推拉/合成假科学实体。
3. 不为每一幕强制素材配额；判断标准是观众能看到研究**何处得出什么结果**、画面随科学线索变化且真实性/证据等级清楚；特别是S05出现真实科学细节或合法清晰的概念图，而非纯文字解释。论文Figure1的170°C 17/50、180°C 48/50只按R2原文和原图作样本统计，不编造单颗触发阈值；Figure6声学结论与作者假说分离。

**D. 本机样片、QA与候选交接（一次性）**：
1. 允许在现有Owner Windows项目局部生成**最多1条**内部审阅的1920×1080@30fps、30–60秒连续MP4、相应WAV/SRT/Cue/sceneJSON、1张非敏感故事板索引图以及所需QA报告；支持最小局部调整（最多2轮有依据重试）。未经证实许可的论文原图/视频及生成样片**不得发布、不得合并到GitHub、不得外传第三方**；需要Reviewer实际观看时提供经Owner允许的、不会把未许可材料公开化的安全本机访问/受限传递方式，若无法访问则保持视觉`UNVERIFIED`。
2. 独立隔离测试浏览器实际播放全段1×不跳播，记录`readyState/videoWidth/videoHeight/play()/currentTime`和可复核截图/时间点；以ffprobe/ffmpeg完整解码、关键帧、声画时长、字幕不遮挡、单Master Clock、片段原视频不重复、来源标签正确、字幕真实语音对齐为验收要点。自动技术QA不等于Owner视觉审美PASS。
3. 非付费/低资源优先，严格限制一次场景测试环境：不高负载与其他项目并跑；不得更改全局代理/VPN/Clash、共享Docker/VPS、系统Python/Node包、其他项目目录或Owner Edge私人会话；既有工具复用，若需额外安装/升级或网络私密授权则精准RETURN。重要外部资源受限时宁可标为`PARTIAL`，不伪造内容。
4. 只在**新CWS隔离分支+PR**提交脱敏证据/必要源码最小修复和再现步骤；所有媒体原件、论文图、AI输出、原声/样片、私人/用户名路径、Token、Cookie及潜在版权受限字节留在Owner本机忽略目录，**禁止传Git**。本Gate只读报告/截图证明（不带未授权原图）与SHA/媒体探测结果可进Git。
5. 结束于Reviewer，不自动合并PR、重写`CURRENT_STATE`或`REVIEWER_HANDOFF_CURRENT`，不得启动正式全片、第二题、公开发布或下一个Gate。

### Preflight / Evidence / Acceptance / Rollback

**PREFLIGHT**：
- 核对Owner原生Windows、实际Shell/路径/用户、最新main及本轮完整Gate；识别旧工作区2 tracked/5 untracked等变更，隔离新的干净CWS工作树/分支。对旧变化只读，不`git reset --hard`/`git clean`，不清理任何媒体或备份，不触碰PR#144/PR#152分支。若环境明显漂移，先限定只读诊断。
- 核实本机实际FFmpeg/Remotion/TTS接口/测试浏览器状况，以最小现有路径为准。官方来源/许可风险在下载、制作前判别并留证；联网行为仅限本Gate相关论文/素材站点。
- 预先记录恢复点：Git隔离分支起始main SHA、旧工作区状态、本机媒体生成目录唯一性/可删除性；超范围后果停机并交Reviewer。

**REQUIRED_EVIDENCE**：
1. 真实来源/许可/图面判定：Figure1/3a/6逐图证据URL、署名、可用范围、宽高、Figure3(a)第三方排除、S1/S2来源/访问/许可状态；对审阅引用/使用的法律依据明确为`VERIFIED/UNKNOWN/NOT_PERMITTED`。
2. 新增视频候选的来源/有效动作预览/单位作品去重/横屏属性/权利；无合规新源则如实列缺口，不冒用旧两条。
3. S01–S10（或选定连续样片范围）的真实素材→T1–T6→Cue/SRT→分镜片段表，有视觉目的、资产source_identity和使用时段。
4. 真实MP4/WAV/SRT/scene JSON以及运行日志、尺寸/帧率/全解码验证、播放证据、字幕视觉与同源一次性检查；若未产片，精确`RETURN`和可执行下一步，不能填虚构PASS。
5. PR URL/commit SHA、全部更改文件列表及diff，脱敏原始证据仓库外保留/Reviewer可审阅路径或说明为何不可共享；技术失败/重试/无污染的read-back。

**ACCEPTANCE_CRITERIA**：
- 素材级：合法边界清楚、论文事实准确、只有真确来源才以论文证据标注；没有把已用视频当独立新素材或重复时段。
- 视觉级：至少30–60秒可从头到尾连续审看，中心视觉事实有真实画面/明确概念示意而非占时长的文字卡、真实研究与辅助画面分清、声源假说标注可信。
- 技术级：1080p、30fps、FFmpeg完整解码、TTS与字幕对齐、浏览器1×播放可复核、冻结V5.6.2字节不变、其他项目资源没动。
- Reviewer能取得实际可审阅Evidence才可给`PASS`；Owner实际看过短片之后才能给**Story-Fit主观内容PASS**。若仅完成来源/片段映射则`PARTIAL_SOURCE_ACCEPTED / VISUAL_NOT_VERIFIED`，保留已完成阶段成果、不返工全部。

**ROLLBACK_OR_RECOVERY**：只新增CWS隔离工作树/PR/被允许的本地新输出；可放弃新候选PR或有界撤销本轮源码/编排改动，旧冻结HTML、R3产物、旁路项目、Windows工作树与其他服务都不被覆盖。媒体生成需保存副本/路径与SHA用于回查，**不能为了回滚擅自删除Owner已有本地文件**。任何未确认的Git/本机覆盖状态先只读核实。

**OWNER_ONLY_ACTIONS**：本轮常规纸面研究、合法合规免费素材下载、新录制/本机内部制片和限定的**非额外付费**静态AI示意已获Owner概括批准；新付费服务或未设预算的支出、取得需法律授权的许可例外、账户登入/购买、公开上传发布、真实4–6分钟完整制片、新题正式生产、PR合并及不可逆删除不在此单条Gate授权之内。上述不阻碍同Gate的安全步骤连续执行。

## REVIEWER_TO_EXECUTOR_RELAY（唯一Codex入口）

**从本文开始，不必回溯Governance或全仓历史。** Codex已具有仓库独立读写权限，Owner**不需发送ZIP**。

在确认真实本机目标及main基线后，只读取：
- 本文；`docs/CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md`；`docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`；`visual/retro-mac-v1.2/docs/STYLE_LOCK.md`；`docs/VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md`；
- [上一轮Reviewer受理](reviews/CW0005_EXISTING_VISUAL_ASSET_AUDIT_REVIEWER_PASS_2026-10-18.md)及[PR#152审计报告](https://github.com/entropy-student/project/blob/codex/cw0005-storyfit-asset-audit-20261018/curious-world-studio/docs/reviews/CW0005_EXISTING_VISUAL_ASSET_AUDIT_EXECUTOR_2026-10-18.md)，不必导入历史所有R3/R6 ZIP；仅具体出现素材冲突时做最小核实；
- 按需只读`visual/frozen/storyboard-v5-6-2-20261018.html`的接口段、`media-pipeline/cws_media.py`和现有Remotion/FFmpeg/TTS/Cue组件；不得修改冻结源码。

**同Gate授权可连续完成 A→B→C→D，不需额外审批，直到本轮最大终点或精确安全Return。** 若来源权利不明，不虚报发布许可，也不能把论文“all rights reserved”改记为CC BY。其他无关项目禁止触碰。

执行结束，在GitHub新CWS隔离分支创建PR，只附脱敏报告、可审的最小源码变更和指针；不要合并。以Governance七行`结果 / 改动 / 验证 / 问题 / 回滚 / 请Reviewer检查 / Owner转交`汇报，附PR与commit SHA、供Reviewer实际观看的受控本机MP4交接办法，**停止在独立Reviewer**。
