# G2 · Mac mini 实操文案完整试稿（首轮）
GATE_ID: `G2_MACMINI_SCRIPT_FIRST_DRAFT_20261028`
STATUS: `EXECUTED_ARTIFACT_READY / OWNER_REVIEW_PENDING`
2026-10-28

## OBJECTIVE
Owner 同意开始首轮正式试稿：从文案规范 v0.1/统一提示词 v0.1 出发，以 2024 款 M4/M4 Pro Mac mini 为题材，直接写一篇自然、事实可信、可口播的实操视频稿，交付**单个独立 HTML**。

## MAX_ENDPOINT_THIS_ROUND
本轮完成 Apple 官方事实核对、非虚构全文写作、精简排版、HTML 静态完整性检查和 Reviewer 初步审核；最多生成首稿 1 份。不做配图、分镜、封面、视频、网站/移动端专项、生产部署或公开发布。

## MANDATORY_REVIEW_STOP
生成首稿并记录 hash / 来源与限制后，停在 Owner 内容审稿；**未经过 Owner 认可不得宣称文案质量 PASS 或冻结通用 Prompt。**

## TARGET_AND_SCOPE
- 用户给出的原始 `Macmini实操指南.zip`、前几轮反馈；
- `docs/WRITING_STANDARD_V0.1.md` 与 `docs/UNIFIED_PROMPT_V0.1.md`；
- 事实核对：Mac mini（2024）技术规格、识别端口、Mac mini 初次设置、Windows 迁移助理、键盘快捷键、声音输出、Time Machine；
- 产物：用户会话中的本地 `Macmini_实操文案_首轮审稿.html`（未提交 GitHub 公共仓库）。

## APPLICABLE_CRITICAL_CONSTRAINTS
只允许实操/测评/观点三类；本期为实操。没有真实实机测试时不能冒充亲测。文案按主题自适应自然叙事，不用固定段落模板。HTML 只做阅读载体，不存第三方图片、不发布。

## PREFLIGHT
原 ZIP 由 Owner 上传且可解包；源 HTML 及历史反馈可读；规范 v0.1 和 Prompt v0.1 可读；Apple 官方来源联网可核。独立 Codex 执行工具在当前聊天不可用：**本轮由当前会话直接完成草稿，不声称已在 Codex 内执行**。

## REQUIRED_EVIDENCE
HTML 存在及 SHA256、标题/文案字数与段落数、自包含检查、重要事实所对应的官方链接、未实机试验声明、局部阅读与事实审稿意见、原稿未修改证据。

## ACCEPTANCE_CRITERIA
1. 文件包含可直接朗读的完整中文稿（非大纲）；
2. 目标机型和主张有官方依据，自己没做的事不伪造；
3. HTML 自包含、不依赖外部素材运行，附关键来源；
4. 文件能够由 Owner 打开并进入反馈；
5. Owner 内容质量验收保留 `REVIEW_PENDING`，不因文件存在而宣布作品满意。

## ROLLBACK_STATUS_OR_PLAN
原 ZIP 未修改。本地新生成 HTML 可直接弃用；GitHub 本轮只加治理记录，可通过 Draft PR 回退。无线上回滚需求。

## OWNER_ONLY_ACTIONS
后续确认稿件质量、选择是否继续改写、公开发表。当前不需要账户/发布授权。

## REVIEWER_TO_EXECUTOR_RELAY
NOT_APPLICABLE：此轮聊天没有 Codex Executor 工具，已由会话自身完成首稿；后续如切入 Codex 需要单独建立新的 relay，不重放首稿。

## EXECUTOR_TO_REVIEWER_RELAY
NOT_APPLICABLE。
