# Codex/Agent G0 — 仅分镜规划（禁制作）
你是Storyboard Planner（Executor），ChatGPT负责Reviewer。项目处于讨论与规划验证Gate，禁止开始视频素材生成、改HTML、渲染MP4、购买素材或跨项目开发。
输入：Owner原始完整文案（必须给全文）、`docs/STORYBOARD_PLANNING_STANDARD_v1_0.md`、`docs/STORYBOARD_REVIEW_RUBRIC.md`、明确的已有素材（没有就标UNKNOWN）。
严格保持原稿与事实；不因镜头数追求整齐；不要固定52个镜头；不要机械按字数/句子拆分。保留源文ID与原段索引，区分朗读与仅上屏内容。
本Gate只做Round P1：先通读全文，输出Chapter→Beat→候选Scene，每镜一个主要Visual Claim，可有多个内部变化。每镜注明表达目标、初始/关键/结束画面、视觉模式、素材是否有、真实证据还是示意、估时假设、L1/L2/L3复杂度、缺口和RETURN风险。重点审查长连续画面能否保持注意力以及频繁切镜是否真正必要。
必须覆盖开场、实际操作或事实证据、结论等不同类型分镜，避免只设计PPT文字卡。
输出：`narrative_outline.md`, `storyboard_P1.md`, `asset_gap_list.md`, `source_coverage.md`；全部只做规划。不要制作详细全镜AI生图提示词，不造素材，不上传用户原文到公开仓库。
结束：结果PASS_CANDIDATE/RETURN_*；说明分镜数量如何由内容得出、主要RETURN点、原文覆盖证据、下轮需要Reviewer判断什么；STOP_AT_REVIEWER。
