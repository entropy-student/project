# Curious World Studio｜有效决策记录

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
