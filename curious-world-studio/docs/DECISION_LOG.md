# Curious World Studio｜有效决策记录

<!-- CWS_PR155_MEDIA_VALIDATION_NEXT_GATE_OWNER_20261018 -->
## 2026-10-18｜Owner推进PR#155后最小流程修正：合并历史取证＋多来源真实Canary

Owner在PR#155被独立判定`TECHNICAL_VIDEO_PASS / RETURN_PROCESS_COMPLIANCE / VISUAL_IMPROVED_OWNER_UNVERIFIED`之后表示“请继续下一步”。Reviewer认为不应为同一素材流程再串行下发“读旧日志→设计候选表→另批检索→另批下载”四轮，依Governance §5将**小范围旧事实只读取证与新的前瞻流程真实验证合并**到[一个有界Gate](CWS_CW0005_MEDIA_PROVENANCE_AND_BOUNDED_MULTISOURCE_VALIDATION_GATE_2026-10-18.md)。限制当前爆米花S01“爆裂或起跳”镜头、最多2检索语义、现成SearXNG/4get与可用OpenMontage合法渠道、按原网站身份合并去重/实看候选、只有确认更贴合且合法未用才最多下载一条≤80MB视频并做FFprobe/FFmpeg/SHA，不强制下载、不新渲染、不再生图、不配音、不改任何正式代码/冻结文件、不改别的Docker/网络或支付、不发布。优先保存真实关键词/引擎/原始域名/失败情况及七层状态的脱敏证据，历史缺失明记`UNKNOWN`，**新Canary PASS不能倒推PR#155曾执行同样流程**。下发前GitHub`AGENTS.md`中长期堆叠的多个相互冲突“当前唯一Gate”已按最小原则删除旧banner，仅保留一份有效入口与稳定角色/技术约束；所有历史授权事实保留在Decision Log/既有Review/Git历史。旧[只读历史流程Gate](CWS_CW0005_MEDIA_SEARCH_DOWNLOAD_PROCESS_AUDIT_GATE_2026-10-18.md)未曾实际下发，现由新合并Gate覆盖为`SUPERSEDED_NOT_EXECUTED`。


<!-- CWS_PR155_INDEPENDENT_RETURN_PROCESS_COMPLIANCE_20261018 -->
## 2026-10-18｜PR#155最终交付独立Review：流程RETURN、技术PASS、视觉明显改善

Owner上传完整真实ZIP，SHA=`9d81ff112bd634f7418b5ec568a731847246a84995dfd918a62960e67e6027dd`，66成员/65 SHA全部核对，包含两版59.933秒实际MP4。最终影片SHA=`acd29f628d5fb83ac3bf817cc522b7e0ad1b5183c38ea21634ef6c887011ca24`，Reviewer独立FFprobe及FFmpeg完整解码PASS；全片采样实看已显示原Mac从桌面开窗到回桌面，T6温度17/50 vs48/50、T5三个不同AI静态淀粉脚、T6声学100ms/106ms和T2结果/假说，解决前轮“单条锅内实拍当背景”的主要视觉结构问题。当前只作`VISUAL_IMPROVED_OWNER_NOT_VERIFIED`；AI三图SHA吻合、官方output_hint/不重试/双并发有Executor记录但源真实调用未由Reviewer复现，`IMAGEGEN_PARTIAL_PASS/TOKEN_SAVING_NOT_MEASURED`。**流程RETURN**：Pexels #7677397下载素材的来源/规格/局部画面可验证，但项目已确认的多平台搜索候选、各站比对/作品级去重、查询和7层状态计数缺证据，不能把候选产出后成功下载视作整体流程已遵守，也不能谎称其它搜索引擎绝未使用。Owner此前提前锁定的`RETURN_PROCESS_COMPLIANCE`保持，不因视频质量改善改判。PR#155仅真实脱敏报告，**保持Open不合并**；[Reviewer报告](reviews/CW0005_PR155_MEDIA_PROCESS_AND_VISUAL_INDEPENDENT_REVIEW_RETURN_2026-10-18.md)已落库。原视觉返修工作完成，不准重复第三次渲染；后续流程取证Gate仍待实际派发，不得自动启动。现行`NO_PUBLISH/G1/G2/R4/RIGHTS_PARTIAL`全不变。


<!-- CWS_INFLIGHT_DELIVERY_PRIORITY_FIX_20261018 -->
## 2026-10-18｜Owner确认视觉返修已在途，Reviewer撤销错误的中途Gate抢占

本次Owner说明：前一条素材搜索下载“只读流程审计”提示词**并未发给Codex**，当时原经Owner批准的视觉返修**仍正在执行**。Agent读到Reviewer提前写入GitHub main的“流程审计为唯一Gate，视觉返修DISPATCH_HOLD”后被迫在PR/ZIP交付前停止；期间本机隔离目录里已产出概念图、Pexels素材、两次59.93秒渲染/QA（均为Agent单方汇报，正式Review待证据）。Reviewer承认混淆“提示词尚未下发”与“原已授权任务尚未启动”导致执行权限碰撞。处理：恢复原视觉Gate当前阶段为`IN_FLIGHT_DELIVERY_ONLY`，允许提交原工作结果的脱敏PR和ZIP、转交可审阅真实MP4，不追加第三次渲染或额外媒体操作；已建立的只读媒体流程审计Gate保持文件但标为`DEFERRED_NOT_DISPATCHED`，不打断本轮交付。Owner要求当前结果返回后按全项目正式素材要求独立Review，**流程`RETURN_PROCESS_COMPLIANCE`结论预锁，和画面/技术结论分开**。原版权与发布HOLD不动。这一修复只校正项目执行顺序和历史事实，不新创大范围付费、发布、媒体生产授权。


<!-- CWS_MEDIA_SEARCH_PROCESS_RETURN_20261018 -->
## 2026-10-18｜Owner将CW0005下一轮锁定为素材搜索下载流程合规RETURN

Owner发现最新样片似乎只有Pexels一个实际来源，要求Reviewer**完整读取项目管理规范与CWS项目文件，不跳读**，并明确“本轮结果提前锁定为RETURN；非画面质量而是流程合规”。Reviewer已从GitHub读取VNEXT.md v0.2.7全部609行、递归清点CWS185文件、逐份获取其中159份Markdown/配置/HTML/JSON文本Blob核指纹，另读MEDIA搜源/下载实现，并提供[覆盖清单](reviews/CWS_FULL_PROJECT_DOCUMENT_COVERAGE_MANIFEST_2026-10-18.md)与[审计结果](reviews/CW0005_MEDIA_SEARCH_DOWNLOAD_PROCESS_COMPLIANCE_RETURN_2026-10-18.md)。当前真实矛盾是：Owner确认按视觉需求**多平台并行候选发现→去重→实看→定向下载**，实际PR#153仅记录1页Pexels结果、3条Pexels详情/下载，缺其它平台候选的实际数量、失败/降级、跳过理由及搜索/下载/内容/许可分层证据；但不能凭无记录证明其Windows从未触发聚合搜索，亦不能把“3+1”误读成每期必须从三路各选一条。本次`RETURN_PROCESS_COMPLIANCE`与MP4技术PASS并行、原视觉RETURN保留。此前Reviewer制定联合Gate时没有把多来源候选比较和七层计数写成严格证据门槛，需由Reviewer补缺，不把责任全推给Codex。**尚未下发**的视觉返修Gate转`DISPATCH_HOLD`；下一轮仅凭[新的只读流程审计Gate](CWS_CW0005_MEDIA_SEARCH_DOWNLOAD_PROCESS_AUDIT_GATE_2026-10-18.md)追溯现存本机素材索引/日志并归类错误，不得为补历史重新搜片/下载/生图/渲染。后续按审计结果合并新的合规检索与真正视觉修复，仍需新的有界真实媒体动作授权。


<!-- CWS_IMAGEGEN_MANDATORY_PRIORITY_20261018 -->
## 2026-10-18｜Owner将C类AI静态图片最省调用/快速执行设为CWS项目级强制准则

Owner询问生图是否遵循项目管理规范中最快、最低Token/最少无谓调用的路径，要求如执行尚无强制约束则升为“本项目最高准则之一”，并说明上一轮Codex提示词尚未下发、需要修改。Reviewer独立核`spike.skill/vps-project-governance/VNEXT.md §11G`（最大双并发、复用/编辑优先、official`output_hint` direct SourcePath、本地复制/QA、同因2次失败停止），与`comic-narrative/tools/imagegen-fast-path/README.md`及R2R1V真实双任务成功验收，也核对CWS原[AI生图低浪费指南](AI_IMAGE_GENERATION_EFFICIENCY_REUSE_GUIDE_2026-10-16.md)。结论：规则本身已存在且别项目验证过，但CWS本轮Gate并未强制交付逐图零调用复用决策/官方hint证据；PR#153仅报告曾生1张AI图，实际执行Fast Path**无法验证**，不虚构对旧图的负面定性。现已将CWS指南与`AGENTS.md`升级为CWS项目高优先强制执行规范，补完[未下发的CW0005返修Gate](CWS_CW0005_POST_PR153_TARGETED_STORYFIT_REPAIR_GATE_2026-10-18.md)。**速度与成本优化是少走无效调用路径，双并发省时不等于单图少Token；不存在可靠的全局最低Token实测结论，禁止夸大节省。** 不修改跨项目Governance v0.2.7、不扩大计费/发布权限、不放宽科学事实与研究真实性。


<!-- CWS_PR153_TARGETED_STORYFIT_REPAIR_AUTH_20261018 -->
## 2026-10-18｜Owner批准PR#153视觉RETURN后的单轮定向返修

Owner已接受独立Reviewer提出的“保留音画基础设施、仅最小重排科学主画面、恢复真实冻结Mac、先StoryBoard关键帧预检再做一条修正版内部短片”，在2026-10-18回答“我没问题”。此为**上一条综合制片Gate失败之后的新的有界授权**，不是旧Gate失败后无限重试。Reviewer按Governance v0.2.7 §5将Storyboard实际QA→有界返修→**一次正式候选内部MP4**→技术QA→隔离PR合为[一个执行Gate](CWS_CW0005_POST_PR153_TARGETED_STORYFIT_REPAIR_GATE_2026-10-18.md)，不对每个低风险子步骤索要Owner授权。数值17/50与48/50作T6事实可视化、脚形成/接触压缩/回弹用T5三态科学准确静态图、100ms→106ms独立声学事实用T2/T6并显著标“作者假说”；以冻结Mac真源整体复用，不重画简化界面。旧R3/PR#153使用的四条视频继续项目级一次性禁复用；冻稿/WAV/SRT/技术QA保留。新片须Reviewer实际审看及Owner审美验收，不解除RIGHTS_PARTIAL/NO_PUBLISH或授权完整R4/第二选题/付费/发布。


<!-- CWS_PR153_INDEPENDENT_STORYFIT_REVIEW_RETURN_20261018 -->
## 2026-10-18｜Reviewer真实看过PR#153样片：技术PASS、视觉RETURN

Owner上传真实55.266667秒CW0005 MP4供独立Reviewer检查。实际文件SHA-256与Codex报告一致、FFmpeg全解码通过、1920×1080@30fps，完成技术可运行证明。独立按约1秒间隔取画面和关键帧发现：新Pexels #1796141连续42.966秒覆盖主体77.7%，S02样本统计、S05淀粉脚形成/压缩/回弹和S07–09声学证据主要仍是同一锅内背景+文字/小插画；S05插画有喷气/火箭意象误导风险，1.5s开头是简化标题卡而非原V5.6.2完整Mac桌面与开窗，复发了R3此前视觉RETURN核心原因。比率77.7%仅描述本片具体情况，不新增素材时长硬阈值。当前结论`TECHNICAL_VIDEO_PASS / RETURN_VISUAL_STORYFIT / NO_PUBLISH / RIGHTS_PARTIAL`，真实论文图/研究电影未核验复用，不可发布；V5.6.2冻结不动。依Owner“能合并即合并”，[PR#153](https://github.com/entropy-student/project/pull/153)**仅执行历史报告**合并main，最终合并Commit `65f079f68fac74ee2bd3abc3df58d39469eb07c5`，并不意味着⑤⑭通过。独立报告：[CW0005 PR#153 Reviewer Return](reviews/CW0005_PR153_INDEPENDENT_VISUAL_STORYFIT_REVIEW_RETURN_2026-10-18.md)。下一步只需复用现有 T6真实数字可视化、T5主体三态概念示意、T2声学事件比较与锁定Aqua原壳，保证各段画面语义递进；不可重新进行完整素材基建/重造模板。失败制片之后新候选需单独有界授权。

<!-- CWS_CW0005_OWNER_MERGED_STORYFIT_GATE_20261018 -->
## 2026-10-18｜Owner统一授权合并视觉Story-Fit执行Gate（未执行）

Owner明确：“我没问题，一律批准，尽快推进，能合并的gate一律合并。”Reviewer据项目Governance v0.2.7合并原先分开的论文图像查证、短缺实拍定向搜取、视觉编排、30–60秒Mac内测样片与技术QA为**单条**[CWS-CW0005联合Gate](CWS_CW0005_COMBINED_STORYFIT_SOURCE_TO_SAMPLE_GATE_2026-10-18.md)。理由：这些是同一CW0005局部成片、共享原始证据/本机可回滚域，能够以明确条件连续执行，免去对单个小动作反复批准；但原论文明确`All rights reserved`，不能从公开可读推定图像与补充片段已有商用许可。原R3两条视频项目级已用不可复用，旧R3失败亦不重试；优先真实论文Figure1/3a/6、官方movie S1/S2、合法的新实拍，并允许至多两张受审核/标记的静态AI概念图作辅助。素材科研真实性、客观技术与Owner视觉审美仍须分别验收。

**授权终点**：Owner本机合法合规获取/生成一条内部30–60秒连续样片和候选PR，必须停Reviewer/Owner实看；不自动批准付费服务、未知版权的发布、PR合并、4–6分钟全片、第二个题材制片、公开发表、删除或修改冻结V5.6.2。旧库存盘点[Reviewer PASS](reviews/CW0005_EXISTING_VISUAL_ASSET_AUDIT_REVIEWER_PASS_2026-10-18.md)已被正式接受，新的Gate不重新盘点历史库存，也不宣称⑤/⑭已经PASS。若本Gate顺利，下一轮应考虑**完整4–6分钟＋第二题复用合并验收**，以最少轮数Close，但长片实际行动须在后续有界Gate内执行。


<!-- CWS_V562_OWNER_FROZEN_PASS_20261018 -->
## 2026-10-18｜Owner批准V5.6.2模板技术PASS并冻结至main

Owner阅读V5.6.2独立Reviewer PASS报告和主Reviewer复核后明确要求**正式冻结PASS**。已按原字节将源码归档到`main/curious-world-studio/visual/frozen/storyboard-v5-6-2-20261018.html`，blob `33aabc3ff2e48877493277eb1a86274818e3c769`，SHA-256 `47dbe555b297153bab7520b7b1b716fa8403ed32c237b3b2603e283829c2fb84`。旧V5.2不覆盖，PR#144保持Draft/未合并。独立实测41/41边界、9/9媒体、3/3 Canvas、31.06秒1×播放PASS且无新P0/P1/P2。原因：N-01百分号语义与N-02极小值刻度缺陷均已修正；无需继续修改已冻结六模板。**仅模板技术PASS，生产/视觉Story-Fit/素材权利/发布HOLD不变**。下一步详见[冻结决议](reviews/CWS_V562_OWNER_FREEZE_TECHNICAL_PASS_2026-10-18.md)和[七轮后续规划](CWS_POST_V562_FREEZE_TO_AUTOMATED_VIDEO_ROADMAP_2026-10-18.md)，规划不自动赋权。

> 仅记录项目方向、Owner授权和独立Reviewer裁决的**原因与适用边界**；此文档不能创建第二套状态或修改[VPS Project Governance](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md)。现行状态以[CURRENT_STATE](CURRENT_STATE.md)、[当前Handoff](REVIEWER_HANDOFF_CURRENT.md)及[当前Gate](PROD_R3_CW0005_INTERNAL_AV_SAMPLE_GATE_2026-10-16.md)为准。

## 2026-10-16｜Owner：内容优先、画面相关即可

Owner取消要求每个科学事实逐帧对应原论文实录；不再因淀粉脚高速录像缺失继续扩展R6/R7、建设新模型、反复搜站点。科学事实准确、普通画面不冒充研究实验、不同证据强度需标记的规定依旧有效。

## 2026-10-16｜Reviewer：R2编辑PASS（不是正式制片PASS）

Reviewer复核修订验收ZIP，接受爆米花旁白及S01–S10内容安排，明确55秒只为估算，配音字幕和正式成片尚无证据。故继续保持CW0005_VISUAL_STORYFIT_HOLD/G1_NOT_PASS/G2_NOT_AUTHORIZED/NO_PUBLISH。

## 2026-10-16｜Owner：授权R3内部样片、免新增版权研究轮次

Owner对下一步内部30–60秒音画样片表示授权，并说明不需要再考虑版权问题。将其有界落实为**本次内部试制不再要求新版权研究轮次**：仍记录两条库存源具体权利PARTIAL、不得冒充研究实录、不推导公开发行/商用许可。新付费、远程部署、R4完整草片、外联、删除和正式发布均未包含本次授权。详细执行边界见[R3 Gate](PROD_R3_CW0005_INTERNAL_AV_SAMPLE_GATE_2026-10-16.md)。

## 2026-10-16｜Owner：完整视频及以后每期采用双轮口播润色

Owner将先前使用的两套Skill分工确定为 Curious World Studio 的长期文案方法：第一轮 [KKKKhazix/human-writing](https://github.com/KKKKhazix/human-writing/tree/v1.1.0/human-writing) 负责结构、讲述逻辑与自然中文；第二轮 [blader/humanizer v3.1.0](https://github.com/blader/humanizer/tree/v3.1.0) 负责消除模板化AI语言、冗余衔接和重复句型。Reviewer在润色后对照事实、引文、样本边界、实验与假说，并复核口播可读性，配音前冻结版本。适用于R4完整内部草片及未来所有正式完整视频；不要求重新执行已经下发的R3小修，不构成R4或发布授权。具体常设流程见 [VIDEO_SCRIPT_POLISH_WORKFLOW](VIDEO_SCRIPT_POLISH_WORKFLOW.md)。两个外部仓库和版本已核对，当前并未在Owner本机安装/运行两Skill。

## 2026-10-16｜Owner正式否决R3视频视觉呈现（本轮权威结论）

Owner实际观看返修成片，指出重复素材和长段文字介绍让它无法作为合格视频。Reviewer回看18帧实际视频并核镜头清单：55.367秒视频中Pexels #854959占20.223秒，Pixabay #2793占25.727秒，合计83.0%；另S05纯文字机制卡占5.849秒，虽没有重放相同源时间码，但视觉仍单调，科技论述没有落实为可看的视觉故事。Owner的“画面相关即可”是指不必精准实验逐帧匹配，**不等于能用两条近似素材和PPT文字撑整片**。Reviewer正式整体结论调整为`RETURN_OWNER_VISUAL_STORYFIT`；取消之前的“只待声音验收”要求，技术链路/局部可读性仍PASS，整体质量FAIL。暂停扩展R4或发布，下一步先作视觉方案再等新授权；原版权PARTIAL、CW0005正式HOLD/G1/G2/NO_PUBLISH均不变。

## 2026-10-16｜Owner：七点工作流裁决，①⑦确认，④⑥取消旧限制，②③⑤待议

①素材检索、预览、匹配及视觉兜底阶段**不得修改已固定文案**。⑦待素材和视觉方案确定后再使用 `KKKKhazix/human-writing v1.1.0 → blader/humanizer v3.1.0 → Reviewer事实复核`，才冻结TTS稿；后期措辞润色与前面的“匹配时文案锁定”属不同阶段。④**暂不设置**任何静态/动态/兜底类别的数值占比配额，先前60/40、静态20%、单类上限及同源25%等只是提案。⑥**不存在**“素材匹配失败即触发内容停机”的策略；安全/审批等真实执行边界不受影响。②首次广泛搜片方法、③多层兜底具体类型与制作、⑤13个Mac窗口模板与正式2/4/6的应用**尚未批准、继续讨论**。不因本条放行AI生图、正式R4或发布。详见[七点裁决登记](VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md)。

## 2026-10-16｜Owner确认高效素材遍历与原始视频一次性使用

此前七点中②**现已确认**：冻结文案生成视觉需求后，**多平台并行搜集**候选；合并与去重、抽帧/实际预览、依据相关性和画面差异排序；如果仍有具体画面缺口，**只针对缺口定向补搜**，不重复全来源全量遍历，也没有“一次初搜后不得再搜”的限制。

Owner新增硬规则：**同一个原始视频素材禁止二次使用**。项目级一源一用：在单一期成片中仅允许一个连续使用段，禁止剪为数段反复穿插；其他期也不得再次使用同一原视频，改名、镜像、裁切、转码、转载不算新素材。历史R3技术样片的两条已用源保持历史证据且后续禁重复投入。执行侧未来需维护来源身份/已用期数台账及同源识别；尚未授权实施搜索、安装组件或制作视频。③素材兜底、⑤13种模板与2/4/6的实际应用仍待讨论，建议共用智能视觉编排系统但独立两模块；是否启用AI生图仍待正式兜底/权利裁决。

## 2026-10-16｜Owner：仅用已有MW-01～13 × 六类素材，过滤形成有限分镜库

Owner纠正另造12种分镜母版的路线，决定以原有13种Mac Window Motion Kit动作承接A真实视频、B科研/档案图像、C真实录屏、D科学图解、E AI生图、F多素材复合六类；F是A–E复合展示而非新的真实来源。理论13×6=78格，只对格子逐项判断适用性、排除不合适项，最后留下少量能直接换素材的组合；不用另造78套动画、无需为了套模板在每一节出现Mac窗口。

**目前确认的是矩阵筛选法，不是任何具体格子的推荐结论或正式效果许可。** Reviewer的详细建议见[13×6候选适配大表](VISUAL_MW13_X_6_COMBINATION_MATRIX_DISCUSSION_2026-10-16.md)，状态仅DRAFT。独立HTML Demo未自动集成成片；正式3+1仍禁AI生图，需未来Owner明确裁决才修订，旧R3视觉RETURN/G1/G2/HOLD/NO_PUBLISH/R4未授权不变。本轮仅项目文档记录及进入讨论。

## 2026-10-16｜Owner精简为13×3，并指示复用已验收imagegen路径

A素材视频（包含真实录屏）、B现有素材图片（论文/照片/研究图表等）、C AI生成静态图片（经事实审核的示意/概念/插画）。固定13个已有MW动作，理论13×3=39组合、排除不适配项；不重新发明分镜和素材类别，旧13×6仅历史讨论。C类作为将来合法的图像解释手段，局部替代过去绝对禁止AI静态生图的方向；AI生成真实实验/视频仍禁止。C的实际执行、付费、制片和发布仍需独立Gate。

GitHub已核实`entropy-student/spike.skill/comic-narrative`的`part4_5/ASSET_REUSE_LIBRARY.md`提供优先查已验收图片→直接复用/旧图编辑/参考/再生成流程；`tools/imagegen-fast-path/README.md`与R2R1V已验收Codex内置生图并发2、output_hint结果路径直接复制、hash/尺寸/QA，不传送大图stdin/TTY/base64、native画幅像素差异不自动重生。以上并不包含可量化的“最低Token使用量”，CWS尚未移植。

## 2026-10-16｜Owner要求记录C类生图省资源技巧

不另设生图分类与分镜模板。为A视频/B素材图片/C AI生成静态图中的C类，复用`spike.skill/comic-narrative`源项目已验收的完整图素材库判断：先检查兼容成品→直接复用/单图编辑/局部参考/再重新生成；并参考已经实际验证过的Codex内置生图Fast Path，**双并发**、以返回的官方output_hint找真实文件、直接复制保存与SHA/实际像素/QA、避免stdin/TTY/base64搬运、Native像素数值不符时不自动重生。详细参考[AI生图复用与低浪费执行指南](AI_IMAGE_GENERATION_EFFICIENCY_REUSE_GUIDE_2026-10-16.md)。已明确它能降低无谓调用和返工风险，却没有Token最省百分比或CWS实际运行证据；本轮**只记录技巧**，不执行图片生成、修改正式视频或放行R4。

## 2026-10-17｜Owner确认A方案：6种内容模板共用3布局，先验证再集成

- Owner已明确同意推荐方案A，设计为**视觉编排→选择素材和模板→制作视频**三步的第二部分。内容模板是T1单素材/T2双画面对照/T3实拍+解释/T4证据档案/T5过程演变/T6数据与结论，底层可共用全幅/分栏/序列三种布局；已有Mac窗口动作MW-01～13仅作为必要交互外壳复用，不自动互相组合成39种或另外造出一套Mac系统。
- V1被Owner明确批评“静态、和原先样式不太一样”；独立Reviewer确认`RETURN_VISUAL_MOTION_AND_STYLE`，要求恢复真正的Mac开窗视觉和按时间自动演出，不以“可以上传素材”替代“可以播放成片”。
- Owner要求继续推进并同步整理文档，故V2仅在[独立Draft PR#144](https://github.com/entropy-student/project/pull/144)返修与保留证据；正式`CW0005_VISUAL_STORYFIT_HOLD/G1_NOT_PASS/G2_NOT_AUTHORIZED/NO_PUBLISH`及R4未授权、原稿锁定、素材权利审查仍有效。
- V2当前仅`REVIEW_CANDIDATE / PARTIAL_VERIFICATION`，不能因为6模板的行为测试通过就宣称整体视觉质量PASS。真实内容是否优于参考视频，需下一步用多来源实拍/论文图等真实可审核材料进行连续观片比较。

## 2026-10-17｜Owner选择固定Mac外壳、六个可复用B模块、唯一Master Clock

Owner认可V3连续播放体验但认为外观比已验收Research Aqua原版有所退化；决定**不再扩充模板数量或重造Mac系统**，而是在唯一Aqua桌面→QuickTime主体→点击关闭回桌面的外壳内任意次调用T1～T6。一个模板可在同一视频不同时间用于不同素材；每段只指定镜头表中模板、素材、时长与字幕，统一编排器自动累计镜头起止，播放器进度条/素材/旁白均绑定整片主时钟；不得六份模板各自重置时间。

V4 [Draft PR#144](https://github.com/entropy-student/project/pull/144)已按此方向提交代码候选（从仓库原Research Aqua V2源码复用绘制函数，另增关窗动作），但GitHub原Canvas复用版的一倍速浏览器连续观感未通过验收，当前仅`V4_ARCHITECTURE_CANDIDATE / PARTIAL`。旧V1/V2/V3证据保留；真实素材权利、视频制作R4和发布仍分别授权，不能借此次模板修改解除CW0005正式HOLD。

## 2026-10-17｜Reviewer纠偏：Research Aqua V2是真源，禁止双Mac/双播放器

- **Owner追问与Reviewer事实核验**：用户发现现有样片相较最初选定的Mac样式明显退化。根因不是“原版找不到”，而是开发顺序选择错误：先自绘Mac/QuickTime窗口与六布局，再尝试将原版Canvas叠加进去。GitHub原始HTML在`main:curious-world-studio/p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html`，真实blob `acb0ee80264527bd11160e0ae277ce24528c4a03`；V4仍同时存在`iframe#auth-shell`和`#qt`第二套窗口，不能把嵌入原代码等同已经完整复用原版。**此项作为现有V4视觉整合缺陷，不抹掉V3/V4已完成的可复用模板和全局时间轴局部测试。**
- **锁定方法**：以原V2 HTML为唯一A Mac+QuickTime容器，最小化替换播放器B区内容。T1–T6保持六个独立可复用展示组件，多个镜头可以重复调用同一T编号；每期一条Master Clock，从桌面点文件到内容展示再到关闭回桌面。无需另造第二套Mac视觉或六台播放器，不新增模板。优先复用V4`TEMPLATE_RENDERERS`/`EDITORIAL`/`compileTimeline`，清除双窗结构；播放器装饰/动作采用原版绘制，内容槽不应覆盖按钮、控制条和字幕安全区。
- **验收条件**：Reviewer对同一版可离线运行HTML同时确认视觉与行为：原V2桌面、菜单、Dock、鼠标、窗口几何和开窗动作对照；至少6布局/7镜头（T1用两次不同素材）；一倍速整段播放、播放/暂停/拖动/字幕编辑不中断、进度连续、结尾点关闭恢复桌面；同一个浏览器/版本测试，不能拿近似壳版结果证明原版合成通过。第三方参考素材只用于私有试看片，不上传公开Git。通过前状态`INTEGRATION_RETURN / VISUAL_UNVERIFIED`，不是模板最终PASS。
- **实施和权限边界**：未来仅允许隔离PR#144中开展有界Mac视频模板精修；本轮**只记录、没有修改代码**，不修改既有原版main真源，不合并PR，不启动正式R4、AI生图、外部搜片、付费、发布；`CW0005`正式R3视觉RETURN、HOLD/G1/G2/NO_PUBLISH不变。具体Reviewer接手看[REVIEWER_HANDOFF_CURRENT](REVIEWER_HANDOFF_CURRENT.md)顶部唯一Gate。

## 2026-10-17｜Reviewer接受V5单原版结构为候选、正式视觉PASS待验收

Owner批准继续，Reviewer按前一轮确定的原版唯一外壳规则**实际提交**PR#144 `storyboard-v5-original-shell.html`。技术决策：以原Research Aqua V2整份HTML/Canvas为基准，仅将旧果冻示意画面替换为一个B媒体内容视口；沿用源QT桌面、窗口、鼠标、标题栏/进度条及控制按钮，六T1–T6模板是内容函数，七镜头一个主时轴。V4的`#auth-shell + #qt`双外壳设计已在V5替代（旧源码留档）。

Review独立静态回读确认一个原Canvas、零第二QT元素，两段JS语法PASS；22时点受控执行器证明开场/模板切换/结尾状态机可推进，不等于真实浏览器观看。故结论仅`V5_SOURCE_ARCHITECTURE_OK / OVERALL_PARTIAL / REAL_BROWSER_VISUAL_UNVERIFIED`。下一步对V5同一原版源码整合HTML做真实1×浏览器完整视觉和媒体同步核验，不再次重绘原版Mac；PR仍Draft不合并、正式R3视觉RETURN和R4/G2/发布限制保持。

## 2026-10-17｜Owner 冻结留档 V5.2（模板基线，不是正式视频封板）

Owner对原版Research Aqua V2外壳与六种知识内容模板集成的V5.2样片表示认可其连续播放“视频感”，**同时明确样式仍可调整，但现在先冻结留档**。因此Reviewer决定停止对此版重复精修，不额外增加内容模板，并将 **V5.2 作为当前可恢复的模板技术基线**，而不是将不成熟的具体审美判断升级为最终视觉规范。

完成`main:curious-world-studio/visual/frozen/storyboard-v5-2-20261017.html`的**完全相同源码复制**，Git blob `f002fd3a3fea24352c8eddb63d8f265014a9e93b`，来源Draft PR #144 V5.2与main归档版逐字对等；不合并PR，不改原版G1VA V2。冻结版中仅一套Mac QuickTime播放器，6个T模板可重复使用、7镜头与31.06秒总时钟一致，开窗至最终关窗闭环。此版不含第三方参考视频字节，私人观看用媒体附件不进入Git。

**规则**：后续所有样式微调应新建V5.3或之后的版本，禁止覆盖/静默修改V5.2冻结文件；制作4–6分钟真实内容的法律权利、真实分镜、配音/SRT/MP4及正式Story-Fit仍是独立未完成事项。CW0005正式`R3 RETURN / G1 NOT_PASS / G2/R4 NOT_AUTHORIZED / NO_PUBLISH`不因模板冻结放行。详见[冻结与进度全记录](CWS_V52_TEMPLATE_FREEZE_2026-10-17.md)。
