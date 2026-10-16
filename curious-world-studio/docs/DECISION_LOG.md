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
