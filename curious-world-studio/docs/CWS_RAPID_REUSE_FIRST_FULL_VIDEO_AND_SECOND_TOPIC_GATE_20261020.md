# CWS｜快速收尾：复用现有流水线→CW0005完整内部片→第二题材复用（2026-10-20）

> **STATUS: OWNER_AUTHORIZED / EXECUTOR_NOT_DISPATCHED / CURRENT_GATE**。Owner 2026-10-20明确同意“按照项目管理规范去推进”，并要求压缩不合理时间；本Gate仅将已通过组件的端到端验真及**最多两条内部候选成片**合并执行。**不代表现在已经CLOSE、Owner视觉PASS、商业版权PASS或允许发布。**
>
> 规范：`entropy-student/spike.skill/main:vps-project-governance/VNEXT.md` v0.2.7；本Gate由Reviewer定义、Executor执行、Reviewer独立验收。**目标是最小复用/有限拼接，绝非重新开发Mac、模板、字幕、TTS或素材系统。**

## 1. 固定授权边界

| 字段 | 合同 |
|---|---|
| `GATE_ID` | `CWS-RAPID-REUSE-FIRST-FULL-AND-SECOND-20261020` |
| `OBJECTIVE` | 用当前已验收的V5.6.2/真实59.933秒成片生产链作为输入基线：**先核真实可复现性**，再条件式生成CW0005内部完整片及第二个不同选题内部完整片；证明不是只能制作一次的手工工程 |
| `TARGET_AND_SCOPE` | Owner Windows11本机/Codex；`entropy-student/project`中`curious-world-studio/`；唯一受控隔离worktree/分支、`curious-world-studio/.local/`下**新建**两个独立episode运行目录；只限CWS相关资产/脚本/测试，Git只传非版权、非Secret、非个人敏感的源代码、规范和脱敏报告 |
| `SOURCE_PIN` | Gate建立时main=`204bda74d382ab29aae04736d7706281b2e21b1a`；执行前需只读重新核main、V5.6.2冻结Git blob `33aabc3ff2e48877493277eb1a86274818e3c769`、Owner现有59.933s媒体与脚本工作树真实状态；`PR#144/#155/#157/#158/#159`全未授权自动合并 |
| `MAX_ENDPOINT_THIS_ROUND` | **最多两条新增内部完整1080p横屏MP4**：CW0005一条＋第二不同选题一条（各以自然叙事为准，目标4–6分钟，不为凑时长重复画面），最多一次针对现有59.933秒制作链的**只读源/命令/配置可复现盘点**。不得盲目重渲59秒，也不允许为了“快速”绕过先决条件。允许同Gate内只修真实阻塞的CWS小型编排/输入适配代码，不重建播放器/素材平台 |
| `MANDATORY_REVIEW_STOP` | 第一条若技术、科学事实或权限预检失败，**不启动第二条**；任一后果性成片写入失败后停止后续生产，交Reviewer判新授权；成功交出一份隔离PR（仅必要代码/配置/测试）＋一份脱敏证据包及**两条本机私有MP4**供Reviewer/Owner，不合并PR、不发布 |
| `APPLICABLE_CRITICAL_CONSTRAINTS` | `V562_TEMPLATE_TECH_PASS / CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / RIGHTS_PARTIAL / NO_PUBLISH / VOICE_BY_EAR_UNVERIFIED`；素材须可追溯、不冒充论文实验；同原视频在一条成片只用一个连续片段且不能跨期重复利用；文案匹配期不改稿，最终配音前遵循已决定的两轮润色/事实检查 |
| `OWNER_ONLY_ACTIONS` | 改系统代理/Clash/TUN/DNS或全局Docker/其它项目、付费/API充值或未证实免费的计费调用、登录/授权第三方账户、下载许可未知的新作品、覆盖旧媒体/旧工作树、删除/清理、整PR合并、对外发布、上传含版权原片至公开仓库，均不授权 |

## 2. 唯一连续执行路线（成功才继续；不是四个新Gate）

**A. 只读核现成生产链（必须先做，不做重复生产）**
- 列出59.933秒真实样片在Owner本机对应的：完整实际命令、源码/版本及依赖、输入分镜V2 JSON/镜头表、素材与rights台账、三幅已验收AI示意图、WAV、SRT/ASS、渲染入口和QA；每项实际路径/哈希，缺失标`UNKNOWN`。既有ZIP能证明视频存在，不自动证明能从新输入一键重建。
- 对照 `visual/frozen/storyboard-v5-6-2-20261018.html`与本次真实MP4生成源码的关系：`HTML_INTERACTIVE_ONLY`、`OFFLINE_RENDER_REPRODUCIBLE`或`NEEDS_MINIMAL_BRIDGE`，必须有对应源码/调用证据。只在有明确输入/输出契约时补最小桥接，绝不声称历史Remotion旧9秒/图卡模板已能自动渲完整V5.6.2。
- 如关键旧资产/命令不可取得，先只读查既有本机`.local`/原执行记录一次；仍缺则`RETURN_REPRODUCTION_INPUT_UNAVAILABLE`，不得自行编造素材或重新造链。

**B. CW0005完整内部片（最多一次正式新增渲染）**
- 复用CW0005 R2通过的10句事实骨架、既有已验收Mac+T1–T6、真实相关素材、生成过的三态图、已有旁白和字幕方法；为**自然4–6分钟**扩充内容之前先验证一手事实与新的素材需求；不能靠重复素材、PPT文字卡或虚构论文结果凑时长。
- 视觉素材方案定后再执行已确认`human-writing v1.1.0 → humanizer v3.1.0 → Reviewer事实边界自检`的输入契约；如Skill真实不可用，记录精确阻塞，不伪称已运行。TTS需要新额度/实际收费时停Owner授权；原有可复用的音轨不得因工期焦虑无谓重生成。
- 素材只从已掌握、可用于内部验证的有效源读取；不把历史失败版用过的同一原视频变成“新作品”；所有来源、实际预览、权利与作品级去重必须记录。若版权/出处只是PARTIAL，可做本机内部技术候选并明示，不得升级为公开使用许可。
- 新片输出实际`1080p MP4 + WAV或其源音轨 + SRT + V2 JSON + 源资产/权利台账 + 可重跑命令/锁定版本 + SHA + ffprobe/ffmpeg全片解码及时间轴/内容抽检`。不覆盖历史成果。

**C. 第二不同选题验证（第一片先全部技术自测且未出现实质RETURN才执行）**
- 从既有36题库中选择具有已确认研究出处、可合法用于内部演示的非CW0005主题，不强制复刻已否决的旧J-B实验，不重新漫搜九源/80站点。只有现成素材不足时，在当前允许渠道做**针对具体镜头缺口的最小搜索**；权利未明则不下载、不发布。
- **必须调用同一个制作入口、同一JSON/素材/Cue/SRT/渲染约定**，只能换配置、来源、文案、图片/视频及参数，不得为第二题另建特殊引擎。目标第二条完整1080p内部片；新增一次必要的本题配音须确认免费额度、否则准确停线。
- 如第一片技术测试未过，或者第二题因研究/素材/费用前置不满足，返回对应精确PARTIAL/RETURN，保留已经成功的独立子项，不抹掉通过证据。

## 3. PREFLIGHT / REQUIRED_EVIDENCE / ACCEPTANCE / ROLLBACK

- **PREFLIGHT**：Owner本机机器/user/Windows shell/Python/Node/FFmpeg/Remotion版本，CWS实际Git根、最新main/分支/工作区脏状态（不得覆盖）、V5.6.2源Git blob、59秒实际路径+SHA、`.local`剩余磁盘/内存、素材许可与使用台账、可用TTS/两Skill及计费状态；有风险不打开共享Docker/系统代理。独立新目录、退出时仅回收本Gate证明创建的子进程/临时文件。
- **REQUIRED_EVIDENCE**：A阶段输入/命令可复现矩阵（DIRECT vs EXECUTOR_REPORTED分开）；最小源码diff、干净隔离PR HEAD和测试正反例；B/C每条完整输入/输出身份、视频完整解码/ffprobe、声画字幕采样、无黑场/错误时码、事实对照、原媒体身份/rights，执行耗时实测分解（盘点/脚本/素材/音频/渲染/QA），不编造耗时；匿名化证据ZIP+每个文件SHA；原MP4只通过Owner私有附件或本机保全交Reviewer。
- **ACCEPTANCE_CRITERIA**：①能从归档的真实输入和固定一条入口可靠重建（不是“看过某个视频”的口头证明）；②第一条4–6分钟左右完整MP4技术可用且每段视觉有作用、无旧“重复锅片＋纯文字主体”回归；③第二题同入口产出并证明确实换题材；④日志/哈希/素材/版权状态完整；⑤独立Reviewer直接检MP4/QA后给PASS/PARTIAL/RETURN，最终视觉与发布仍Owner判断。前述任何未验项不得由执行者自称PASS。
- **ROLLBACK_STATUS_OR_PLAN**：`NO_PRODUCTION_DEPLOYMENT`。原main、V5.6.2、59秒原片、旧`.local`、五个旧PR、用户VPN/Docker均不动；隔离分支可丢弃，两个新运行目录可保留供核验；禁止清理任何不属于本Gate的文件。
- **SCOPE-EXCLUDED FOLLOW-UP**：PR#159 F159-03清理/合并是不同源码与回滚域，应在独立最小PR159 Gate处理，**不阻塞本Gate既有素材/TTS/MP4链**；没有本轮合并权限。通用yt-dlp/manifest SSRF、商业版权清权与真正发布另行授权。

## 4. REVIEWER_TO_EXECUTOR_RELAY（Owner直接转给本地Codex）

> 请执行GitHub `entropy-student/project` 最新 `main` 中的 **`curious-world-studio/docs/CWS_RAPID_REUSE_FIRST_FULL_VIDEO_AND_SECOND_TOPIC_GATE_20261020.md`**；这是当前Owner授权的唯一集中内部制片Gate。**只读本Gate及其精准指向的源代码/已验收事实**，不要遍历历史Gate，不要重复搭Mac、素材下载器、TTS、字幕或Remotion。严格按A→B→C条件式连续执行：先在Owner本机只读验证现有59.933秒成片的实际输入、命令、素材与版本；满足真实可复现条件，才以最小拼接复用V5.6.2与现有链制作**最多一条CW0005完整内部片和一条不同题材完整内部片**。所有生成物放新的隔离`.local`目录，代码必要修改只推一条隔离PR，原始版权媒体不推Git；停在独立Reviewer，不合并、不支付、不发布、不改Clash/TUN/其它项目。若缺关键输入、脚本、许可或需实际付费，请按Gate精确RETURN，**不要为赶工期重建旧系统或假报PASS**。交付一份脱敏ZIP及SHA、实际媒体私有交付指针、两片真实ffprobe/FFmpeg/字幕/事实证据和各阶段**实际耗时**。正常Gate内有界自查/最小修复无需向Owner逐项重复申请。

### 本Gate精准文件阅读入口
1. `curious-world-studio/AGENTS.md` 顶部现行Gate；`docs/CWS_CONFIRMED_STATE_REVIEWER_HANDOFF_2026-10-18.md` §1–4；`docs/reviews/CWS_V562_OWNER_FREEZE_TECHNICAL_PASS_2026-10-18.md`。
2. `visual/frozen/storyboard-v5-6-2-20261018.html`；`p4-g1/remotion/ResearchEpisode.tsx`、`p4-g1/m1-media-adapter/ResearchAquaMediaAdapter.tsx`、`p4-g1/scripts/build_g1.py`（**它们有早期专用适配边界，不可假定已经相互集成**）；只有必要时读`media-pipeline/cws_media.py`和`media_pipeline.py`。
3. `docs/CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md`；`docs/reviews/CW0005_PR155_MEDIA_PROCESS_AND_VISUAL_INDEPENDENT_REVIEW_RETURN_2026-10-18.md` §1、2、4（重点59秒交付与旧流程证据缺口）。
4. `docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`、`docs/VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md`、`docs/VIDEO_SCRIPT_POLISH_WORKFLOW.md`、`research/topic-bank/TOPICS_V1.json`，并只读本机本Gate所需`.local`现有运行材料。

## 5. EXECUTOR_TO_REVIEWER_RELAY（强制7行）

```text
结果：PASS_CANDIDATE / RETURN_<准确阻塞>
改动：实际最小改变与原main/冻结件隔离情况。
验证：两条输出的技术与证据层级、实测工作时段。
问题：NONE或最早失败阶段/缺失项。
回滚：旧源/资产原样；新候选清晰隔离。
请 Reviewer 检查：PR HEAD、脱敏ZIP SHA、真实MP4与字幕/来源/事实。
Owner 转交：NONE；如必须从Windows转交，列出**仅1份**压缩包/两个私有MP4的准确名称，禁止包含Secrets和敏感本机路径。
```
