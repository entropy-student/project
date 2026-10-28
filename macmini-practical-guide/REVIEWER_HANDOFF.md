# 自媒体文案创作系统｜REVIEWER HANDOFF
记录日期：2026-10-28｜治理：VPS Project Governance v0.2.7 / ACTIVE_PROVISIONAL（本轮核对其 GitHub 主分支 VNEXT，blob 3917c88a7f36df7a53758b3879a92703d659ef9d）

## PROJECT_GOAL
交付一套可复用的**自媒体文案写作方法与统一提示词**：每次输入「三类之一 + 具体选题 + 可选资料/作者观点」，由 AI 完成必要研究、信息筛选、叙事组织、事实核查与自然中文成文，以**一个独立 HTML** 供 Owner 阅读。写作仅限 **实操、测评、观点** 三类。输出质量优先，不牺牲信息与事实准确性来追求操作最少。

## PROJECT_STAGE
`WRITING_STANDARD_V0.1_CANDIDATE / OWNER_REVIEW`：规范 v0.1、统一提示词 v0.1 与 Skill 推荐清单已在 Draft PR 形成；**没有启动 Codex 首稿**，没有证明提示词能稳定达到三类质量要求。

## SYSTEM_MAP
| 层 | 当前状态 |
|---|---|
| 主题类型 | 实操（研究/验证/创造/教程均可）、测评（比较与证据）、观点（有依据的判断），用户已明确限定 |
| 工作流 | Owner 输入题材 → 模型内部研究/构思/核对 → 完整可口播中文文案 → 单 HTML 阅读 → Reviewer 反馈 → 定向修订 |
| 第一篇候选 | Mac mini 实操；现有 `Macmini实操指南.zip` 只是历史输入资料，不是冻结模板 |
| 写作规范 | `docs/WRITING_STANDARD_V0.1.md`，CANDIDATE |
| 统一 Prompt | `docs/UNIFIED_PROMPT_V0.1.md`，CANDIDATE；不启动创作 |
| Skills | `docs/SKILL_SELECTION_V0.1.md`；建议最多「1 主类型 Skill + 1 中文表达 Skill」，事实重要时核查；并未证明 Codex 已安装 |
| 语料 | 用户可选提供的个人表达材料；可用性 UNKNOWN，不擅自构建 persona |
| 成品边界 | 单文件 HTML，完整连续文案为主体；图像非强制，不做分镜、配图矩阵、移动端、网页产品、视频、配音或发布 |
| 运行/数据/网络 | 当前只是 GitHub 文档 + Owner 保留的 ZIP；无后端、数据库、Docker、VPS、生产域名；内容研究会引用公开资料但不保存密钥 |
| 共享基础设施 | 不涉及，不做其他项目更改 |

## CURRENT_ACCEPTED_STATE
- `OWNER_EXPLICIT`：文章仅三类「实操、测评、观点」；以一段提示词生成完整文案、单 HTML 自己看；先把方法想清楚、少量试错再正式定稿。
- `OWNER_EXPLICIT`：希望参考优秀创作者的叙事规律，不是照抄；允许参考相关写作 Skill，但明确列名。
- `REVIEWER_RESEARCH`：已核读多个开源写作 Skill 的 SKILL.md；适配/不适配见 `SKILL_SELECTION_V0.1.md`。Skill 不等于效果验证。
- `REVIEWER_DRAFT`：`WRITING_STANDARD_V0.1.md` 和 `UNIFIED_PROMPT_V0.1.md` 已作为 CANDIDATE 交付，格式不冻结。
- `HISTORICAL_SOURCE`：原 ZIP 4 件 CRC/哈希由 G0 核验（详 `SOURCE_MANIFEST.md`），但不应以原 HTML 六章当新的自媒体文案结构。
- `NOT_TESTED`：Mac mini 新稿、三个类型样稿效果、Human Writing + 语料的作用、独立 HTML 实际生成与浏览器可读性。

## CURRENT_GATE
`STANDARD_V0.1_OWNER_REVIEW_STOP`：当前完成研究与候选规范/提示词文档，等待 Owner 评审范围和质量要求；**不授权 Codex 起草正文**。旧 `G1_SCRIPT_PILOT_GATE.md`（要求配画面/封面、2 个开头）已被 Owner 后续决策覆盖，标记 `SUPERSEDED / DO_NOT_EXECUTE`。

## CRITICAL_CONSTRAINTS
- 三类为唯一范围；任何固定六段式、三秒钩子、强制对立冲突或结尾 CTA 都不作为硬性要求。
- 内容策划、信息核验与叙事先于口语润色；重要事实可查，不能编造本人经历/实测/私有观点。
- 统一 prompt 操作简单；模型内部可做充分研究，给 Owner 只交完整稿而非中间大纲。
- Human Writing 和自有语料只用真实可读版本；引用 Skill 的原则不能覆盖 Owner 的风格和事实要求。
- HTML 只作读稿载体，无移动端与设计专项；不要求强制配图、分镜表、视频或发布。
- 原 ZIP 不修改；GitHub 本轮只修改治理文档及根 README 入口；不做生产/共享服务改动。

## DEFAULT_EXECUTION_CHANNEL
Reviewer 使用 GitHub connector 更新 `entropy-student/project` 的隔离 Draft PR；后续若 Owner 授权，Codex 在可读的本地输入工作区按新 Gate 执行；实际 Codex 本地路径 UNKNOWN。

## CURRENT_ROLLBACK_STATUS
仅 GitHub 文档候选修改，可通过 Draft PR 分支撤销；原 ZIP 不变。无生产数据和上线状态。

## UNRESOLVED
- 写作规范与 prompt 的叙事适配仍未从真实作品验证。
- 三类型各至少一次合格代表样稿后方能说已覆盖三类型；单篇 Mac mini 不证明全部。
- Skill 可用性、个人语料入口、HTML 阅读体验待后续试验；如发生事实不足，允许缩题，不编造。
- 参考作者文章中有一篇仅核验到开头，不能宣称三篇全文均已分析。

## NEXT_STEP
Owner 审阅 `docs/WRITING_STANDARD_V0.1.md`、`docs/SKILL_SELECTION_V0.1.md`、`docs/UNIFIED_PROMPT_V0.1.md`；确认后 Reviewer 规划一个有界 Codex 首稿 Gate，先用 Mac mini 试实操；根据一次真实成稿发现关键偏差，再最小幅度修订。之后以测评/观点代表稿验证可迁移性。

## OWNER_ACTION_REQUIRED
当前仅需审阅候选规范与提示词；无需部署、安装全部 Skill、启动 Codex 或提供额外素材。

## EVIDENCE_POINTERS
- `docs/WRITING_STANDARD_V0.1.md` / `docs/UNIFIED_PROMPT_V0.1.md` / `docs/SKILL_SELECTION_V0.1.md`
- `DECISION_LOG.md`：三类范围与旧 Gate 被覆盖的原因。
- `EXECUTION_EVIDENCE.md`：本轮调研与 GitHub 回读。
- `docs/RESEARCH_SCRIPT_FORMAT.md`：上一轮研究背景，只作非规范参考。
