# Curious World Studio｜唯一当前状态（更新至2026-10-18）

<!-- CWS_V561_R01_R05_TARGETED_REPAIR_CANDIDATE_20261018 -->
> **2026-10-18｜最新 V5.6.1 五项局部返修候选，等待独立 Reviewer 验收**：Owner明确授权修复外部三版本联合Review的R-01～R-05，不扩业务范围。本轮新HTML在Draft [PR#144](https://github.com/entropy-student/project/pull/144)的[storyboard-v5-6-1-targeted-review-fixes.html](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/visual/content-template-lab/storyboard-v5-6-1-targeted-review-fixes.html)，Git blob `3cd8b040a9f106ca7d0876b55b34ab71088af175`，SHA256 `44319df40d2b6e14400f720b97d4a34161ae0cef89c9d9e3a7b5c54e5b8fa213`，精确从V5.6 `a0213f7991968fabd3f36be99363310d27324422`增量生成。R-01 `%`前后空格单位规范化及“百分点”、R-02批量素材严格MIME+手动异型替换确认、R-03微小非零变化率避免显示+0%、R-04极小值自动比例尺与全零回退、R-05 V5.6.1标签与V2 JSON下载名已补。**真实Chromium 40/40专项（含10/10原Mac Canvas像素一致）+7/7合成MP4/WAV回归+最终HTML 0→31.06秒1×实速播放关窗PASS，JS异常0。** [V5.6.1审核及复现](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/docs/CWS_V561_REVIEW_TARGETED_FIXES_2026-10-18.md)、[PR验真评论](https://github.com/entropy-student/project/pull/144#issuecomment-6244623248)。**该结果仅为`V561_PASS_CANDIDATE / INDEPENDENT_REVIEW_PENDING`，未覆盖已归档main V5.2（blob `f002fd3a3fea24352c8eddb63d8f265014a9e93b`），PR仍Draft未合并；前轮联合Review PARTIAL是“返修前”事实，不能历史改写。真实4–6分钟音画MP4、素材授权、CW0005 R3/G1/G2/R4正式权限仍HOLD/NO_PUBLISH，暂停等待Reviewer或Owner后续决定。

<!-- CWS_V54_V56_JOINT_INDEPENDENT_REVIEW_VERDICT_20261018 -->
> **2026-10-18｜最新外部联合审核及主Reviewer独立裁决：`V5.4=PARTIAL / V5.5=PASS / V5.6=PARTIAL / 跨版本继承=PASS / OVERALL=PARTIAL`。** 外部Reviewer已用最终V5.6 SHA-256 `aec92e0dda0cb3de3236b200189dcfaf797e9a27827536865efcefeb0d31ee83`完整实速播放31.06秒、停在原桌面且JS异常0，**覆盖此前“最终字节播放未验证”的旧时态**；但这**不代表**4–6分钟有声MP4已通过。主Reviewer对五项问题作出了独立判定并实际复现R-01百分点单位空格错误、R-02媒体MIME具体格式静默改写、R-03微小非零变化率显示+0%、R-04极小柱值默认尺度失真；R-05页面V5.5标签与导出V1文件名已从源码核实。**建议R-01/R-03必修，R-02/R-04推荐，R-05顺手修**；保持Mac外壳/六模板/统一时钟/旧JSON-Cue兼容。主裁决与后续Gate边界：[Main Reviewer裁决](reviews/CWS_V54_V56_MAIN_REVIEW_VERDICT_2026-10-18.md)；[外部报告完整原文及本轮独立复现JSON](reviews/CWS_V54_V56_EXTERNAL_REPORT_AND_RECHECK_2026-10-18.md)。**本轮只读Review和文档写回：V5.6源码blob `a0213f7991968fabd3f36be99363310d27324422`未修改、PR#144仍Open/Draft未合并、main冻结V5.2 blob `f002fd3a3fea24352c8eddb63d8f265014a9e93b`未变。** 当前 `WAIT_OWNER_DECISION`，下一轮小修不可自启；CW0005视觉R3 RETURN/G1 HOLD/G2/R4未授权/NO_PUBLISH、素材权利PARTIAL持续。

<!-- CWS_V56_ISSUE09_COMPLETED_OWNER_STOP_20261018 -->
> **2026-10-18｜⑨ T6数据泛化V5.6候选完成，遵循Owner指令在此停下**：已在Draft [PR#144](https://github.com/entropy-student/project/pull/144)新增[单文件V5.6](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/visual/content-template-lab/storyboard-v5-6-t6-generic-data.html)，Git blob `a0213f7991968fabd3f36be99363310d27324422`。仅针对原问题⑨，T6增加bars/delta/ratio/change四种类型、2~8个同单位指标、负数零轴、金额/人数/时间/比例显示、数据来源和单位/刻度校验，百分比绝对差值明确“百分点”，旧`CWS_STORYBOARD_V2`无需迁移；Mac及T1–T5/V5.5字幕和全局时钟不变。Chromium46/46专项和8/8原生Mac Canvas像素对照PASS；最终代码文字微补后再次完整31s实时回归遇运行器超时，**不夸大为最终字节全程1×通过**。正式4–6分钟音画/MP4/素材权利仍UNVERIFIED。Review及证据：[V5.6技术说明](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/docs/CWS_V56_T6_GENERIC_DATA_REVIEW_2026-10-18.md) · [PR审核说明](https://github.com/entropy-student/project/pull/144#issuecomment-6236833726)。main冻结V5.2未修改，PR仍Draft/未合并；CW0005 R3_RETURN / G1_NOT_PASS / G2_R4_UNAUTHORIZED / NO_PUBLISH不变。**Owner指令完成⑨后停下等待决定；本轮没有启动⑤⑪⑭或正式制片。**


<!-- CWS_V55_ISSUE10_CUE_NARRATION_TECH_CANDIDATE_20261018 -->
> **2026-10-18｜⑩多字幕Cue/旁白同步技术候选V5.5**：Owner仅授权完成原14项表⑩。Draft [PR#144 V5.5](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/visual/content-template-lab/storyboard-v5-5-cues-narration.html)，Git blob `bbc6f40c1dd6bf1cc4b1c8ab4f55f49e0a13881f`。在V5.4上新增同镜头多条相对起止的字幕Cue、可见编辑/越界重叠超宽拦截、单份本地旁白音频素材ID和Master Clock同步；升级为`CWS_STORYBOARD_V2`且能导入旧V1配置转Cue，媒体字节始终不入JSON/Git。真实Chromium新34/34、原V5.4回归43/43、MP4媒体回归6/6、Mac Canvas与V5.4 9/9逐帧一致；31.06s实速全片结束回桌面，JS异常0。**仅技术候选，不证明真实4–6分钟配音/逐字自动对齐/SRT/MP4/权利PASS**。详见[Review合同](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/docs/CWS_V55_CUE_NARRATION_REVIEW_2026-10-18.md)、[PR证据](https://github.com/entropy-student/project/pull/144#issuecomment-6236496020)。main正式冻结V5.2仍不改、PR仍Draft，`CW0005_R3_RETURN / G1_HOLD / G2_R4_UNAUTHORIZED / NO_PUBLISH`不变。下个单独工作项：⑨T6更灵活的数据图表；⑤/⑭真实素材与叙事留后续，⑪低优先级。


<!-- CWS_V54_ISSUE13_TECH_CANDIDATE_20261017 -->
> **2026-10-17｜⑬ JSON与素材映射 V5.4 最新结果**：已在Draft [PR#144](https://github.com/entropy-student/project/pull/144)新增[单文件V5.4候选](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/visual/content-template-lab/storyboard-v5-4-import-asset-map.html)，blob `b7b880db77d42a9e35dcf3a833a68924cd4ef4df`。实现可完整往返的`CWS_STORYBOARD_V1`分镜JSON（ID、模板、时长、T5/T6现有数据、素材注册表、类型及权利注记）与**唯一文件名批量素材关联**；非法JSON整单拒绝并保留旧配置，缺失本地媒体显式提示且不会自动访问磁盘/联网。Chromium 数据/UI/异常43/43、真实MP4安全补测6/6、Mac Canvas 与V5.3.1 8时码逐像素一致。Runner的`file://`导航被安全策略禁止，故使用`page.set_content`；**不宣称Owner Windows Edge文件打开、真实4–6分钟成片/TTS/音画PASS**。详见[⑬接口与证据](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/docs/CWS_V54_STORYBOARD_JSON_ASSET_MAP_REVIEW_2026-10-17.md)和[PR Reviewer证据](https://github.com/entropy-student/project/pull/144#issuecomment-6236127083)。`CURRENT_ACCEPTED_STATE`仍main冻结V5.2，PR仍Draft未合并；正式R3视觉RETURN/G1 HOLD/G2/R4未授权/NO_PUBLISH不变。**下阶段建议⑩多字幕Cue/配音接口，然后⑨T6多数据形式，须独立Gate。**



<!-- CWS_V531_CAPTION_REFRESH_TESTED_20261017 -->
> **2026-10-17 V5.3.1最新技术修复**：上一轮外部Reviewer `V5.3 = 7 PASS / 1 PARTIAL` 的唯一遗漏——编辑器选择S01但播放器正在S02时，编辑超长S01字幕没有立即警告——已在Draft [PR#144 V5.3.1](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/visual/content-template-lab/storyboard-v5-3-1-caption-alert.html)实施单行补丁（blob `c74567d1c399d58ab96fb81303cf381250ab2ee2`）。真实Chromium复测当前/异镜头警告、改短清除、导出拦截/恢复全部PASS，原19项回归19/19、JS错误0。**本轮八项技术缺陷自验均PASS**；下一阶段仍须独立审核数据导入⑬、字幕/配音cue⑩、T6泛化⑨；⑤真实资料、⑭故事素材匹配留待制片；⑪显示语义低优先级。**main唯一冻结V5.2仍不变**，不将本次技术自验视为正式4–6分钟MP4、知识/权利或R3/G1/G2/R4/发布通过。证据见[PR评审评论](https://github.com/entropy-student/project/pull/144#issuecomment-6235860650)。



<!-- CWS_V53_EIGHT_FIXES_EXTERNAL_REVIEW_PENDING_20261017 -->
> **2026-10-17 最新候选（尚未被外部Reviewer接受）**：Owner仅授权八项有界修复①长片时间边界②T5局部入点③短视频停末帧④T5/T6参数化⑥T2/T3证据contain⑦字幕超长告警⑧T5自定义阶段时长⑫文件名与来源标签。Draft [PR#144 V5.3](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/visual/content-template-lab/storyboard-v5-3-eight-fixes.html)已提交，Git blob `8c3dd9f26dae8f1104082d670a7310dbe9033e47`，**不覆盖当前main V5.2冻结原件**（blob `f002fd3a3fea24352c8eddb63d8f265014a9e93b`）。浏览器本轮本地技术自测19/19+4/4，31.06秒全程1×私有样片PASS；隔离5分钟时长扩展第40秒显示正确、短MP4/T5入点复测正确，仍**待原独立Reviewer复核与采纳，不算新正式基线**。私人带参考媒体HTML只在用户会话ZIP中，未入Git；正式节目制片R3视觉RETURN/G1 HOLD/G2和R4未授权/NO_PUBLISH不变。证据见[PR复核邀请](https://github.com/entropy-student/project/pull/144#issuecomment-6235329867)。


<!-- CWS_V52_FROZEN_20261017_OWNER_DECISION -->
> **2026-10-17｜最新Owner裁决：`V5.2_TEMPLATE_BASELINE_FROZEN / MAIN_ARCHIVED`（覆盖下方一切V5.2“继续返修”的旧建议）**。Owner确认现版本已有连贯的视频感，**虽仍可继续调整样式，但本轮先冻结留档、暂停样式返工**。无媒体精修版已按**原字节**归档到[main固定 HTML](../visual/frozen/storyboard-v5-2-20261017.html)，Git blob `f002fd3a3fea24352c8eddb63d8f265014a9e93b`，与Draft PR#144里的V5.2原文件完全一致；不合并PR，不改Mac原版V2或V1–V5历史候选。唯一原版Research Aqua外壳、六可复用内容模块、七镜头/31.06秒统一时轴、桌面开窗与结束关闭回桌面作为当前可复用模板技术基线。浏览器技术子项已通过已列局部验证，但**不代表正式4–6分钟影片、素材权利、音画、MP4输出或最终完整Story-Fit通过**。后续视觉细节请另建V5.3+而不覆盖冻结版；如无新视觉问题，则下个阶段以冻结基线进行真实分镜/合法素材映射/音画自动生产能力验证。完整范围/证据/恢复见[冻结记录](CWS_V52_TEMPLATE_FREEZE_2026-10-17.md)。**CW0005正式`R3=RETURN_OWNER_VISUAL_STORYFIT / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH`不变**。

<!-- CWS_V52_BROWSER_QA_20261017 -->
> **2026-10-17 V5.2最新进展**：已在Draft [PR#144](https://github.com/entropy-student/project/pull/144)提交[原版Research Aqua V5.2精修源码](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/visual/content-template-lab/storyboard-v5-2-reviewed.html)（blob `f002fd3a3fea24352c8eddb63d8f265014a9e93b`），仍仅一个原版Canvas，不存在第二Mac播放器。修复1440分辨率下媒体视口缩放不正确致字幕裁切、真假播放器状态不匹配、T4虚构文献大卡过度遮挡、重复大标题遮挡；六模板7镜头及全局31.06秒时轴不变。**真实Chromium**已通过T1/T4/T6截图、关键帧/关窗、27秒起1×播至31.06秒自动结束、MP4时间进展与暂停、本地PNG槽导入，JS异常0。*仅模板技术集成PASS；Owner视觉满意度、正式4–6分钟节目、合法媒体、配音/SRT/MP4导出未验证*。公开Git仅有无媒体源码；含参考视频的1.3MB私有HTML仅交付本轮会话。详情见[PR Reviewer备注](https://github.com/entropy-student/project/pull/144#issuecomment-6234099065)。CW0005 R3视觉RETURN、G1/HOLD、G2/R4未授权、NO_PUBLISH不变。



<!-- CWS_V5_ORIGINAL_SHELL_EXECUTION_20261017 -->
> **2026-10-17 V5执行进度（覆盖下方V4状态）**：Owner要求直接执行原版唯一Mac外壳整合。现Draft [PR#144](https://github.com/entropy-student/project/pull/144)新增[V5单外壳HTML](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/visual/content-template-lab/storyboard-v5-original-shell.html)：以原始V2 Canvas blob `acb0ee80264527bd11160e0ae277ce24528c4a03`直接修订，仅原播放器内部媒体视口承载既有六布局、七镜头与全局时钟，结尾同源鼠标点红灯回原桌面；**不再有V4的双QT窗口**。PR新V5源blob `752f713eb20975a68431559618d2a3acf84b8225`；2个script语法PASS、单canvas/无`#qt`、22个受控时点的时轴状态/六模板/关窗逻辑部分PASS。**同一V5 HTML真实浏览器完整1×视觉播放尚未验收，整体只可判`V5_PARTIAL / REAL_BROWSER_VISUAL_UNVERIFIED`，不能封板。** [Reviewer完整记录](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/docs/CWS_TEMPLATE_LAB_V5_ORIGINAL_SHELL_REVIEW_2026-10-17.md)。正式CW0005 R3视觉RETURN、G1/HOLD、G2/R4未授权、NO_PUBLISH、素材权利PARTIAL不变。

<!-- CWS_CURRENT_VISUAL_TEMPLATE_DIRECTION_20261017 -->
> **2026-10-17｜最新Owner确认：原版优先、只修整合，不再重绘（覆盖此前V4精修建议）。** 经GitHub直接回读，唯一视觉真源为 [Research Aqua V2原版HTML](../p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html)，Git blob **`acb0ee80264527bd11160e0ae277ce24528c4a03`**；[Retro Mac v1.2](../visual/retro-mac-v1.2/preview/index.html)仅为补充布局参考，[STYLE_LOCK v1.2](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)为正式规则。Owner已确认V3/V4样片**连续播放有视频感，方向保留**，但Mac样式偏离已选原版；原因是此前先自绘播放器再嵌原Canvas，V4 [`storyboard-v4-master.html`](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/visual/content-template-lab/storyboard-v4-master.html)实际仍存在`#auth-shell`和另一套`#qt`窗口；**源码存在≠已替换旧外壳，V4不是原版视觉PASS**。下一Gate唯一方向：**从原版V2外壳出发，原版桌面→双击研究视频文件→QuickTime全幅播放→完成后鼠标点击关闭→原桌面；仅将六种可复用T1–T6内容组件插入原播放器B内容视口，保留一条全局Master Clock（开场/内容/字幕/媒体/进度/收尾），不再绘制第二套Mac/播放器，也不增加模板。** 复用历史V3/V4模块代码而非从零重建。先验证同一确切HTML的原版开窗视觉与31秒左右完整1×播放，若不符则仅修整合。当前 **`VISUAL_REFERENCE_LOCKED / INTEGRATION_RETURN / NEXT_ORIGINAL_SHELL_ONLY`**；PR [#144](https://github.com/entropy-student/project/pull/144)仍Draft、未合并；正式`R3=RETURN_OWNER_VISUAL_STORYFIT / CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH`及权利PARTIAL完全不变。

> **2026-10-17 V4最新支线（覆盖V3/V2历史时态）**：Owner明确选择“唯一Research Aqua Mac开窗/QuickTime外壳 → 六种可多次调用的B内容模板 → 视频结束点击关闭回桌面”；所有镜头由**唯一Master Clock**统一控制，模板不再拥有单独计时器。Draft [PR#144](https://github.com/entropy-student/project/pull/144)新增[真正内嵌已选V2 Canvas源码的V4母版](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/visual/content-template-lab/storyboard-v4-master.html)：7镜头/6模板（T1重复两次，素材独立），31.06秒A→B→A，详细合同与Reviewer证据见[本轮V4记录](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/docs/CWS_TEMPLATE_LAB_V4_MODULAR_TIMELINE_REVIEW_2026-10-17.md)。**状态`V4_ARCHITECTURE_CANDIDATE / PARTIAL`**：本机隔离HTML（近似Mac壳）的时间轴与模块行为局部PASS，但GitHub原版绘制组合版尚未独立实际浏览器观看，完整31秒1×自动化回归超时；两者不可冒充等价。第三方参考镜头只存在私有会话附件、未入Git。正式CW0005 R3视觉RETURN、G1/HOLD、G2/R4未授权、NO_PUBLISH不变，PR仍Draft未合并。

> **2026-10-17 V3进展（替代下方V2候选时态，不放行正式制片）**：Owner批准继续做可播放的约30秒Mac视频样片，现已在对话交付**单文件私有HTML**，六模板按时间轴播放、T5自动三阶段、T6数据比较、支持本地换素材/字幕/JSON。第三方参考视频素材仅存在于私有附件，未进入Git。Draft [PR#144](https://github.com/entropy-student/project/pull/144)现有[无媒体V3源码](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/visual/content-template-lab/storyboard-v3-source.html)及[详细Reviewer意见](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/docs/CWS_TEMPLATE_LAB_V3_REVIEW_2026-10-17.md)。**状态为`V3_VISUAL_DEMO_TECH_PARTIAL / REVIEWER_RETURN_EXACT_STYLE_AND_RIGHTS`**：原创Mac Canvas源码尚未在V3逐帧复用；完整自动测试退出超时，正式素材权利与多来源叙事、MP4/配音均未验证。R3 Owner视觉RETURN、G1/HOLD、G2/R4未授权、NO_PUBLISH不变。


> **2026-10-17 新进展（知识内容模板支线，非正式制片）**：Owner同意按方案A开展六种知识内容模板（T1–T6）/三类底层布局，并在指出V1静态、与原Mac外观不一致后授权继续有界返修。现有[Draft PR #144](https://github.com/entropy-student/project/pull/144)提交了V2候选：复用G1V-A V2 Aqua原始开窗源码、约28.76秒统一时间轴、T5/T6自动状态切换、本地素材插槽及JSON配置。**V1=RETURN，V2=REVIEW_CANDIDATE / PARTIAL_VERIFICATION**：本地隔离浏览器验证了六模板动态逻辑/字幕改动不重置视频，但最终嵌入的原Mac外壳尚未实际完整视觉验收；所有示例内容非真实科研证据。正式CW0005仍为R3视觉RETURN、G1/HOLD、G2/R4未授权、NO_PUBLISH。下一个Reviewer先审PR#144和[该分支Gate](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/docs/CWS_TEMPLATE_LAB_V2_GATE_2026-10-17.md)，勿将模板Demo当成正式成片PASS。

 > **2026-10-16 最新Owner工作流裁决（覆盖冲突的旧建议）**：①**素材搜索、匹配、兜底阶段文案锁定，不得修改**；⑦**素材与视觉方案确定后**，再使用 `human-writing v1.1.0 → humanizer v3.1.0 → Reviewer事实复核`，然后TTS。④**目前不设置素材类型占比硬限制**；⑥**没有素材缺口导致的内容自动停机机制**（但不放宽安全、权限和正式制作Gate）。②首次广泛检索方法、③分层兜底种类及制作办法、⑤既有13种窗口模板与2/4/6的正式应用仍然**待讨论、未授权**。详见[七点裁决登记](VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md)。R3视觉RETURN、R4未授权、正式HOLD/NO_PUBLISH均不变。

> **2026-10-16最新Owner分类覆盖旧13×6**：只分A素材视频（含录屏）、B素材图片（现有图）、C AI生成静态图片。沿用现有13个MW模板、理论最多13×3=39个组合，筛去不适配项，不自造新分镜。C是未来可使用的概念/科学示意/插画路线，必须经事实审核并标AI示意，不得假冒原实验；实际生图、付费及R4仍未授权，AI视频继续禁止。生图可参考另一个已验收的`spike.skill/comic-narrative/tools/imagegen-fast-path`和Part4.5图片复用流程，**未验证在CWS中的兼容性，也无最低Token测量**。现行[决策登记](VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md)覆盖旧六类讨论。

> **2026-10-16 Owner最新确认的分镜构造方法**：**不再新造分镜母版**，直接使用既有13个MW窗口动作 × 六类素材/呈现（A实拍、B科研图、C真实录屏、D图解、E AI图片、F多素材复合；F非独立来源），得到理论最多78个格子，**排除不适配组合后形成有限可替换素材的分镜库**。Owner批准的是构造法，具体格子尚待讨论；已新增[13×6组合大表讨论稿](VISUAL_MW13_X_6_COMBINATION_MATRIX_DISCUSSION_2026-10-16.md)并明确非正式许可。旧AI禁令、MW HTML演示与正式视频的权限差异、R3视觉RETURN/R4未授权不变。

> **2026-10-16 Owner最新确认（覆盖下文七点旧“②未决”时态）**：②素材检索效率采用**多来源并行 → 统一去重与抽帧预览 → 相关度/差异排序 → 仅对剩余画面缺口定向补搜**，不重复全量遍历，也不规定只许一次初搜。**同一原始视频素材项目内禁止二次使用**：在一条成片里只允许一个连续使用段，不拆段复用；跨期不能再使用同一原视频，改名/镜像/裁切/重下载无效。此决定向后应用，历史R3样片保留为不合格技术证据且其中两源在新片选材中视为已经使用。③视觉兜底与⑤13个MW模板使用仍在讨论，建议同一视觉编排系统的两个模块，但**没有正式授权新AI生图、模板集成或R4执行**。详见[决策登记](VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md)。

> **2026-10-16 最新Owner视觉否决，覆盖所有下方旧R3状态**：**`PROD-R3=RETURN_OWNER_VISUAL_STORYFIT`**。Owner实际观看55.367秒返修MP4，认为库存爆米花素材重复、夹杂纯文字讲解，整条视频不合格；不需进一步请Owner试听以关闭R3。Reviewer重新抽取全片约每3秒代表帧，并独立读取实际镜头时码，确认仅两条实拍源分别占20.223秒、25.727秒（合计45.95秒，约83%），12条剪辑记录并不代表12种不同画面；S05整张纯文字机制卡占5.849秒。原先`PASS`或`PARTIAL_AUDIO_LISTEN_UNVERIFIED`只可用于媒体解码/局部字幕等**技术子项**，不代表视频内容、视觉吸引力、故事表达通过。完整R3**RETURN**，不可自动晋级R4或申请发布。
> **新的内容边界**：Owner此前“画面相关即可”仅降低科研原片/逐帧精确匹配要求，绝不放宽重复镜头、视觉贫乏和PPT式纯文字主体。后续先通过视觉故事板评审，镜头须有**有意义的视觉差异**（主体/动作/景别/证据用途），不能把一段视频切成多行镜头就算多样化；核心科学机制不能仅用大块文字替代画面。可保留必要的字幕和短出处文字，但文字服务于画面而非反客为主。执行标准见[STYLE_LOCK](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)。
> **当前停止边界**：此刻没有获批的下一次制作/大规模搜片/R4 Gate。先停在视觉方案重新设计的决定点：复用已验证媒体工具与科研资料，但必须先提出不同画面如何承担各叙事节拍、可用资产分布/缺口，Owner或Reviewer认可后再由Owner明确批准下一次有界制片。素材权利 `PARTIAL`、正式`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH`不变。

> **Owner最终明确：画面相关就可以，不追求逐句精准或逐帧对应。** 前任Reviewer将爆米花“淀粉脚受压反弹”的高速实验影像升级成持续制作的必需条件，并据此增加素材轮次，**这是过严的编辑判断，已纠正**。科学事实、诚实标注“辅助素材”、素材使用权不放宽；但普通相关实拍配准确旁白及简洁出处文字即可用于内容方案。不再因缺某段原研究实录自动搜更多站点、重做R6/R7或延期全部创作。历史`PARTIAL_ASSET_GAP`只保留原试验结果。

> **2026-10-16 C类图片制作技巧已落档**：C类AI静态图片后续拟参考[低浪费生图执行指南](AI_IMAGE_GENERATION_EFFICIENCY_REUSE_GUIDE_2026-10-16.md)的「先复用已有验收图→兼容时编辑→必要时新生成」，以及源项目已验收双并发、返回路径直存、自动哈希/尺寸/QA。CWS没有实际移植或Token节省量化证据；新Gate授权、R3视觉RETURN/R4未授权与素材真伪原则保持。

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
| 正式制片 | R2编辑PASS；R3真实55.367秒MP4技术解码/哈希PASS | **Owner视觉否决：R3整体RETURN_OWNER_VISUAL_STORYFIT**。两条库存源约占83%且主机制为近6秒纯文字卡，内容表达不合格；不再要求Owner听感确认；不能自动进R4，正式HOLD/G1/G2/NO_PUBLISH不变 |

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

新增长期表达流程：[中文科普口播双轮润色工作流](VIDEO_SCRIPT_POLISH_WORKFLOW.md)。R2/后续每期的完整旁白**先锁定为视觉匹配输入，在素材匹配阶段不修改**；素材与视觉方案确定后，录音前才按**human-writing（v1.1.0，结构与表达）→ humanizer（用户指定v3.1.0，去模板化）→ Reviewer事实/口播回归检查**处理；R4未来若获授权，亦先完成视觉方案，再制作正式配音和字幕。保留科研事实、出处和假说边界，不为“去AI味”删知识；这是R4和未来视频的**流程要求而非R4执行授权**。已经下发的R3同Gate小修仅处理字幕与证据问题，**不因本新规范返工重配音**。

## 4. 执行与交接边界

- **3+1素材合同**保留：论文/研究机构一手、OpenMontage、合法yt-dlp；后期仅2转场/4布局/6信息。新视频默认非大陆平台、横屏≥4:3、优先1080p。禁AI伪造研究实拍、代码绘制实体、循环重复凑时长；`LINK_FOUND`、`CONTENT_VERIFIED`、`REUSE_RIGHTS_VERIFIED`各自独立。精确匹配要求降低不等于素材权利放宽。
- Windows 11 + Docker Desktop/WSL2，搜索容器只绑定回环、按需启停；不部署VPS、不改代理/VPN/Clash或其他项目Docker、不清除旧缓存/媒体/备份。保留曾报告的3项未提交tracked改动、2项缓存及Ubuntu tar，不能`reset --hard`、`git clean`、`docker system prune`、`down -v`。真实运行资源状态按每次现场测量。
- **新Reviewer首读**：[本轮完整交接](REVIEWER_HANDOFF_CURRENT.md)→[CWS AGENTS](../AGENTS.md)→[3+1合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)→[视觉锁](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)→[工具手册](../media-pipeline/README.md)。旧[2026-10-12科学/素材交接](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)保留历史证据，但其“必须有高速原片才能继续”的编辑Gate已经被Owner降低精度的决定修订。

**本期结论：技术链路验证成立，但Owner已否决R3的视觉叙事成片质量。停止围绕字幕和配音进行无意义微调；重新设计镜头变化和科学解释的视觉表达，须获新授权后才执行。**
