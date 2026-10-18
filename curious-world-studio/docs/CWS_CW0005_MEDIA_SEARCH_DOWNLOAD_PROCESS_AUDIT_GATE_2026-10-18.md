# CWS｜CW0005素材搜索与下载流程合规审计Gate（2026-10-18）

<!-- CWS_SUPERSEDED_BY_COMBINED_MEDIA_VALIDATION_20261018 -->
> **【2026-10-18最新补充：`SUPERSEDED_NOT_DISPATCHED`】** 此只读历史取证Gate此前始终未派发；Owner在PR#155成果独立Review后指示继续推进，Reviewer已将它与有界实际多来源Canary合为[新的当前唯一执行Gate](CWS_CW0005_MEDIA_PROVENANCE_AND_BOUNDED_MULTISOURCE_VALIDATION_GATE_2026-10-18.md)。**不得再单独执行本历史Gate或与新Gate并行**。本文件保留只为记录曾设计过的谨慎取证边界及后来排除的执行冲突；现行任务请读`AGENTS.md`顶部及新Gate。


<!-- CWS_AUDIT_GATE_DEFERRED_FOR_INFLIGHT_DELIVERY_20261018 -->
> **【最新纠偏：`DEFERRED_NOT_DISPATCHED`，不可打断正在交付的视觉返修】** Owner已经澄清“本轮Codex还在执行；本只读流程审计提示词没有下发”。在Owner发出这条消息时，原已获授权的[定向视觉返修Gate](CWS_CW0005_POST_PR153_TARGETED_STORYFIT_REPAIR_GATE_2026-10-18.md)正在Owner Windows本机实际运行，并已生成两次59.93秒MP4、图片和素材，只有**PR/ZIP证据交付**尚未完成。Reviewer在执行途中把本文写成当前唯一Gate属于错误的中途切换，不构成对已执行行动的追溯撤销。**因此本审计Gate只保留为以后Owner需要额外本机取证时的备选任务，不能要求当前Codex停止交付或另起流程审计PR。**当前正确顺序：原视觉Gate仅限完成现有结果的PR/ZIP/安全MP4交接（不再第三次渲染/额外搜片/生图）→Reviewer依据Owner已要求的**流程合规预设RETURN**与现有结果进行独立审查→若客观证据确实缺失，才考虑是否下发本Gate的独立只读取证任务。本文下方“唯一新Gate/立即取证”均为误置到执行途中的旧表述，受此条覆盖，未经另行下发不得执行。


> **OWNER_DECISION: PRELOCKED_RETURN_PROCESS_COMPLIANCE**。本轮流程审计结论已由Owner明确提前锁定为`RETURN`，原因是**流程合规**而非质量审美。Reviewer已全文读取GitHub权威Governance v0.2.7及CWS项目159/159份文本/文档类文件，项目文档覆盖证明见[159文件/指纹全量清单](reviews/CWS_FULL_PROJECT_DOCUMENT_COVERAGE_MANIFEST_2026-10-18.md)，并记录[独立流程审计与缺口](reviews/CW0005_MEDIA_SEARCH_DOWNLOAD_PROCESS_COMPLIANCE_RETURN_2026-10-18.md)。此前的视觉返修Gate**尚未向Codex下发**，现改为等待本轮流程审计结果，严禁先渲染新片。
>
> **唯一上位规范**：`entropy-student/spike.skill/main:vps-project-governance/VNEXT.md` v0.2.7；已核§0–13与触发矩阵，当前涉及Owner Windows、项目内既有搜索索引与历史可复核日志，不触发新的外部公开部署/付费/关闭项目。**本次由Reviewer完成全量文档解释；Codex不得为了执行再通读所有历史文件。**

## Gate合同

**GATE_ID**：`CWS-CW0005-MEDIA-SEARCH-DOWNLOAD-PROCESS-AUDIT-20261018`。

**OBJECTIVE**：在Owner Windows真实本机，**只读复核PR#153那一轮素材到底怎样被搜到、排除、选择、实际下载、探测、存档与用于镜头**；对照既已生效的跨平台候选发现策略和正式3+1媒体来源合同，确定事实/不明/缺失的证据层级。输出最小流程修正合同，让下一轮制作能走既有可复用工具且不进行无意义的全网重新搜索。

**MAX_ENDPOINT_THIS_ROUND**：只读检查已存在的`.local/`素材索引、搜索调用/浏览器痕迹的**非敏感审计摘要**、运行日志、已有下载文件/manifest/QA、PR#153对应旧工作区及历史SHA；可以在**新隔离分支PR**提交脱敏的过程审计报告/事件摘要，不能直接写main。禁止新`discover`远程搜索、`fetch`实际下载、抽帧落盘、生图、新MP4渲染、启动Docker搜索容器、启动任何临时公网/本机Web媒体服务来“重现历史”；只读`doctor/catalog`亦不得在不确认默认目录/读写副作用的情况下随意调用（可改用读取已存JSON）。不新装软件、不清缓存、不修改旧文件与工作树。

**MANDATORY_REVIEW_STOP**：`RETURN_PROCESS_COMPLIANCE`**提前锁定，不允许Executor报告新的视频/内容PASS来覆盖本轮流程退回**。若历史证据完整，Executor最多提交`RETURN_PROCESS_COMPLIANCE_WITH_RECONCILED_FACTS`及清晰的最小修正建议；若日志缺失则`RETURN_PROCESS_COMPLIANCE_HISTORICAL_EVIDENCE_GAP`，不虚构数据。Reviewer独立Review后决定如何在新的执行Gate里证明真正遵循素材流程；本轮不能自行启动后续视频/新媒体工作。

**TARGET_AND_SCOPE**：`entropy-student/project:curious-world-studio/`，真实Owner Windows 11本机已有`media-pipeline/`和`.local/`；GitHub核对最新`main`和前轮已合并的[PR#153](https://github.com/entropy-student/project/pull/153)报告；只在隔离分支提交报告。不要修改`AGENTS.md/CURRENT_STATE.md/REVIEWER_HANDOFF_CURRENT.md`，它们由Reviewer维护；不得改冻结V5.6.2 HTML、既有Media CLI、其它项目/共享Docker/代理/VPN、信用或账号配置。

**APPLICABLE_CRITICAL_CONSTRAINTS**：
- Owner已确认素材搜索策略：根据锁定镜头需求**多平台候选发现**→合并去重→真正预览与动作匹配→选择最合适的一条→只对尚缺具体镜头做**定向补搜**。**不要把“三条来源路径必须每期各用一次”或“要搜满80个站点”擅自变成硬门槛**。多平台候选流程应有证据；平台只有Pexels时须说明其他来源未被搜索或为何足够/为何跳过。
- 来源工作路径①原论文/作者/研究机构②已有OpenMontage（Pexels/Pixabay等）③针对已知合法URL的yt-dlp；本项目MEDIA技术工具实现`cws_media.py`支持本机按需SearXNG+4get搜索、去重、显式ID探测下载、FFmpeg QA，但**是可选CLI，并不自动等于每次都调用**。未使用要写`NOT_USED + 证据/原因`，不得把搜索命中、视频下载、权利许可三者混同。
- 七层真实统计必须区分：`SEARCH_URL_FOUND / URL_DEDUPED / VIDEO_PROBE_OK / DOWNLOADED / FULL_DECODE_PASS / ACTION_CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED`；无历史数据用`UNKNOWN`，不编造。SearXNG/4get是两个搜索引擎，不必等于两个不同的**媒体来源平台家族**；PeerTube实例也不算独立技术家族。
- 来源安全：默认排除大陆视频平台、非横屏/方形（显示SAR+rotation之后≥4:3），优先1080p，720p须说明其在现实备选中的理由而非假称1080p下载成功；下载需显式ID和预算/源URL/实际格式/有效授权与SHA；项目内任何原始视频只用一次、同源转载禁止伪装新素材。学术论文图片和补充视频权利仍UNKNOWN/不可直接宣称商用。
- PR#153已知：Executor报告**一页Pexels候选结果+三条Pexels详情/实看/下载**，其中#1796141 720p和#35876717 1080p用于真实样片、#3752542 1080p不相关而排除；旧R3#854959/Pixabay#2793与本期两个新视频在下一次成片继续计已用。**这证明3个直接Pexels页面曾被看过，不证明不存在其它未记入日志的检索调用。**
- 前次MP4编码及56秒内样片解码已独立确认技术PASS，视觉曾RETURN；**都不是本轮审查范围，不得重复测试或因素材流程RETURN抹掉既有技术PASS**。

**PREFLIGHT**：
1. 证明真实Windows身份、Git repo root/main基线与目标本机`.local/`范围，只读记录已修改、未跟踪、忽略历史媒体；不对原工作区`reset/clean`、删除、解压覆盖、重启服务。
2. 仅查此前两个相关run目录（PR#153 `.local/cw0005-combined-storyfit-20261018/run-20261018-181354/`以及先前`.local/media-operations/`和PR#152报告所列精确已有目录），谨慎枚举目录内旧manifest、索引、脱敏媒体元数据与历史QA；文件实际不存在应标`MISSING`，不要猜Windows路径。
3. 若需要把旧执行日志作为证据，只在本机本地受限读入，防泄露用户绝对路径、Cookie、Token和未授权原片；提交Git仅归一化的非敏感结构化记录及可复现结论。

**REQUIRED_EVIDENCE**：
- **逐镜过程追溯**：对于S01–S10给`visual_need, candidate_query, engine/provider/platform_family, actual_result_count, previewed_candidates, source_identity, dedup_check, selected_or_rejected_reason, source_rights, original_resolution, source_url, download_method, file_hash, relevant_action_evidence, first_use`；原先未记录列`UNKNOWN`而非强制补造。
- **按搜索来源的失败/降级矩阵**：原论文、OpenMontage/Pexels/Pixabay、SearXNG、4get、yt-dlp已知URL分别写`USED / NOT_USED / UNKNOWN`、实际运行证据（如已有JSON查询事件/CLI日志、Browser history仅允许小范围脱敏聚合且需注意隐私）、已知失败原因、可否复用上次候选。**不要对Owner私人浏览器历史做全局扫取**。
- **七层完整证据对照**：如`Found=N`, `Deduped=M`, `Probe=X`, `Downloaded=3`, `Decoded=3`, `Viewed=3`, `RightsPartial=...`；每项须带实际统计的来源级别。未知就是UNKNOWN，不允许以“下载3条”反推仅搜3条。
- **明确历史事实与未来执行设计**：现有CLI依次调用两聚合搜索引擎；如果实际没用，分析是**未执行、Gate遗漏、环境故障、合理免调用**哪一种，保留证据；比较浏览器手动路径和`cws_media.py`可用能力，提出最低改动的下一次执行协议，不强制立刻改CLI架构。
- **外部素材合法/格式与去重**：#1796141 720p为何选用（缺可用1080p或未比较？）、两条历史旧素材及两条已用新素材的去重与下一次不复用、#3752542的排除证据、版权仍PARTIAL。
- 新隔离PR地址/commit/变更范围、停止/回滚事实；找不到的文件与不可独立证明之处必须明说。

**ACCEPTANCE_CRITERIA**：本Gate的唯一成功是**把流程RETURN的真实缺口、原因、责任边界和可核验下一执行合同说清楚**，并由Reviewer确认；不是让本Gate改判成PASS，也不是立刻收集新媒体。完整流程证据已存在则逐项引用，缺失则精准`UNKNOWN`。Reviewer不以单一Pexels站点自动判违背“三路必须全部使用”，但可认定不符合Owner已批准的多平台候选策略/缺少证据而维持`RETURN_PROCESS_COMPLIANCE`。

**ROLLBACK_STATUS_OR_PLAN**：本机旧下载索引、失败样片、冻结视频原字节、历史媒体和Git旧分支全保留。只有新隔离PR文字证据可撤销；任何已有文件意外改动立即止步，并先只读核实损害，不擅自覆盖原资源或触碰共享系统。

**OWNER_ONLY_ACTIONS**：本次Owner仅授权流程审计和RETURN判定；新的媒体搜索/下载/生图、媒体架构变动、再次渲染实质新MP4、合并PR及发布均不是本Gate自动开放的授权，需后续明确执行边界。原先返修目标保留但**当前执行顺序暂停**。

## REVIEWER_TO_EXECUTOR_RELAY（Codex唯一直接入口）

**当前结论`RETURN_PROCESS_COMPLIANCE`已由Owner提前固定；不开展新素材制作，也不用Owner传ZIP。**

Codex只需读取：
1. 本Gate及[Reviewer流程RETURN报告](reviews/CW0005_MEDIA_SEARCH_DOWNLOAD_PROCESS_COMPLIANCE_RETURN_2026-10-18.md)；
2. `docs/VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md` §Owner已确认决策，`docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`相关素材来源/作品唯一性，`docs/MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md`架构/七指标；
3. `media-pipeline/README.md`、`docs/MEDIA_PIPELINE_WINDOWS_USAGE.md`，必要时仅阅读`media-pipeline/cws_media.py`及`media_pipeline.py`搜索/下载入口；
4. 已合并的`docs/reviews/CW0005_COMBINED_STORYFIT_EXECUTOR_2026-10-18.md`及Owner本机对应旧run已有日志/索引；不要重读其它150份历史项目文档，**Reviewer已经作过全量规范解释与摘要**。

**本轮不需任何真实新的联网搜片/下载/变更，仅恢复历史真实流程证据。** 在新隔离分支PR提交脱敏`PROCESS_AUDIT_EVIDENCE`及7项/逐来源/逐镜矩阵，返回七行`结果/改动/验证/问题/回滚/请Reviewer检查/Owner转交`，按当前真实证据标示`RETURN_PROCESS_COMPLIANCE[_HISTORICAL_EVIDENCE_GAP]`并停止，交独立Reviewer。
