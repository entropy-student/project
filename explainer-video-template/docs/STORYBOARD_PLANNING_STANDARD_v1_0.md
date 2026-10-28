# STORYBOARD_PLANNING_STANDARD v1.0
STATUS: REVIEW_CANDIDATE (not production-approved)
SCOPE: 文案 → Chapter/Beat/Scene → 可独立制作的分镜任务。仅适用于实操、测评、观点解说视频，文案字数、Scene数量、成片时长均不设上限。
AUTHORITY: Owner decisions > canonical Governance; 本文为项目规范，不修改治理规则。

## 0. 最终目标与边界
- 输入：完整原文、选题目标、已有素材和实证状态；保留原文，不默认重写。
- 输出：叙事结构、可追溯的逐镜方案、素材/证据缺口、制作复杂度和验收条件。
- 不执行：生图、视频生成、素材抓取、音频、成片导出；这些属于后续制作Gate。
- 保持V6固定外壳：黑底银绿框、SCENE/REC、16:9内容区、底部安全字幕、透明解说人物；内壳Scene不重复包含外壳。
- Scene独立交付和验收；正式生产时Scene间0帧硬切、Scene内独立动效。规划阶段不强制每镜导出MP4。

## 1. 三层结构
- Chapter：一段完整叙事任务（问题/验证/发现/论证等），不规定固定模板顺序。
- Beat：一个认知变化（主张、证据、例子、对比、操作结果、解释、反驳）；不是机械按句断开。
- Scene：具有**一个主要视觉表达目标**、可独立修改/制作/验收的画面单元；一个Scene可承载几个连续Beat、多个内部动作。
- 新Scene触发：主要观察对象变化、表达任务/证据类型变化、需要独立制作的媒体变化、信息密度过高、验收边界发生变化。
- 不触发：简单元素亮起、箭头出现、局部放大、划线、字幕更新；优先作为Scene内部阶段。
- 无字数阈值、秒数阈值、镜头总数硬指标；节奏需全片再审查。

## 2. 先叙事、后画面
按顺序完成：理解全文→Chapter→Beat和源文位置映射→分镜边界→每镜Visual Claim→画面/关键状态→必要素材→估时→质量审核。
每个Scene第一问：**观众看完这一镜应理解/发现/确认什么？** 再回答画什么、什么动。
- Visual role：HOOK / QUESTION / EXPLAIN / DEMONSTRATE / EVIDENCE / COMPARE / REFUTE / SYNTHESIZE / TRANSITION。
- Visual mode：SCREEN / EVIDENCE / EXPLAIN / COMPARE / FOOTAGE / TYPOGRAPHY / HYBRID。
- 不能拿通用PPT卡片、重复标题卡或AI乱动替代真实解释/实证。
- 真相分类：REAL_VERIFIED（已核实）、REAL_PENDING（真实素材/事实待核）、ILLUSTRATIVE（示意）、SIMULATED（模拟）、OPINION（主观判断）。模拟不得充当实测或历史证据。

## 3. 原文与时间
- 原文输入锁定为source_revision与全文散列；source_span引用可追溯段落/行位，语义覆盖率100%。
- 默认VERBATIM：不擅改原文、重排、删除论证或改变数字。若确需重写，单独列出rewrite_proposal经Owner批准，之后生成新source_revision。
- 区分朗读文字、视频标题、操作命令、表格与不朗读注释；不要把命令和Markdown全部交TTS。
- 每镜给duration_estimate与假设，非正式配音不得标真实秒点；实际timecode由后续旁白/录音对齐确定。
- 一段配音可跨多个Scene；一个Scene可逐步呈现多个Beat。Scene数由内容和制作边界决定，不从字数硬算。

## 4. 素材与证据状态
每项素材至少记录：用途、来源/出处、许可/发布限制、AVAILABLE|NEEDED|GENERATABLE|BLOCKED、是否需要验证。URL/路径/截图不能凭空捏造。
- 原文中的技术命令、真实费用、硬件指标、操作界面版本：未核实前标FACT_CHECK_REQUIRED / BLOCKED_FOR_DEMONSTRATION，不许当可安全照做步骤渲染。
- 需要真实操作的镜头必须列录屏任务和验证方法；拿不到材料时允许计划示意，但需标记、不能伪装已验证。
- 对复杂度标L1(简单图文动效)/L2(多元素/录屏)/L3(复杂生成)，复杂度不是镜头价值评分。

## 5. Scene最小生产契约
字段：
scene_id（稳定；勿因重新排序改变唯一ID）
chapter_id / beat_ids / source_span_ids / source_revision
narration_excerpt（精确）与 speech_mode（VOICE/ON_SCREEN_ONLY/PAUSE）
visual_claim（一个主目标） / visual_role / visual_mode
shot_start_state / visual_action_sequence / shot_end_state
asset_requirements[{id,purpose,media_type,status,evidence_kind,license_or_unknown,verification}]
duration_estimate_s / timing_basis / complexity / risks[]
acceptance_criteria[] / status（DRAFT/REVIEW/READY/BLOCKED/RETURN）
所有关键约束需在人的分镜表和机器JSON中一致。外壳小人不应作为每个内壳镜头所需额外素材。

## 6. 两轮规划
Round P1（低成本）：只出Chapter、Beat、候选Scene、视觉主张、主要制作缺口和疑问；在Review中调整粒度。
Round P2（详细）：通过后再写全镜头动作、素材、验收、JSON和制作任务。不提前为全部镜头生成昂贵素材或长提示词。

## 7. Reviewer验收
硬门槛（有任一不合格不得READY）：
1. source_span可追溯，全文覆盖、没有不明原因删除或改写。
2. 每镜可说清visual_claim与画面为什么有助于观众理解。
3. 证据/模拟/观点有明确区分；未经确认的操作不得标示为安全实操。
4. 每镜所需素材及缺口明确，且可独立制作和验收。
5. 与V6外壳无重复、Scene间硬切、内部动作有清楚时序。
人工审阅维度（仅辅助排序，不可伪装观看实测分数）：内容与叙事25、准确与证据25、画面解释力20、生产可行性20、变化与节奏10；总100。硬门槛优先于分数。
Reviewer结果：PASS_FOR_PLANNING / RETURN_STORYBOARD / BLOCKED_EVIDENCE；只有正式生产证据出现后才可称PRODUCTION_PASS。

## 8. 正式交付
- narrative_outline.md：章节、Beat及信息主张。
- storyboard.md + storyboard.json：同一份Scene事实的人读/机读视图。
- asset_manifest.md：素材准备任务、版权/事实检查和阻塞列表。
- review_report.md：源文映射、拆镜边界、连续观看检查、缺口和Reviewer决定。
注：本文件为Candidate，需要独立Agent双方案对照与Owner确认后再标记FROZEN。
