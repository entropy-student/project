# G1：Mac mini 视频文案 + 声画规划首轮试验（待 Codex 执行）

> GATE_ID: `G1_VIDEO_SCRIPT_AND_VISUAL_BEATS_PILOT_20261028`
> STATUS: `AUTHORIZED_FOR_DRAFT_PREPARATION_NOT_EXECUTED`
> 研究假设：先试「问题驱动的探索式叙事」，通过样稿反馈再修订，不视为 Owner 最终选定。

## OBJECTIVE
基于现有 Mac mini 资料，产出 **1 版适合口播的实操型视频文案**，为重要语义单元规划画面和素材，最后将封面概念/文案/配图规划放到 **1 个独立 HTML** 中给 Owner 预览。HTML 只是阅读介质。

## MAX_ENDPOINT_THIS_ROUND
- 阅读指定资料、核对影响叙事的必要事实，拟定 2 个开头候选、1 版完整口播、对应 visual-beat 声画表、素材清单、1 个脱离外部文件也能打开的 HTML。
- 如果真实图像本身无法取得或权利不明确，可以用明显标识的「需要补充的画面」占位；**不必生成图片**。
- 本 Gate 到 Reviewer 收到草稿和差异/证据为止；禁止继续自动修正多轮、生成视频、发布、改服务器/网页产品。

## MANDATORY_REVIEW_STOP
一版成稿交付后 `STOP_AT_REVIEWER`。需要 Reviewer 判定结构/台词/画面组织能否继续成为可复用模板。

## TARGET_AND_SCOPE
- `entropy-student/project/macmini-practical-guide/`，先读该项目当前 `REVIEWER_HANDOFF.md`。
- 指定研究文档：`docs/RESEARCH_SCRIPT_FORMAT.md`。
- 输入：Owner 提供的《Macmini实操指南》原 ZIP / 本轮工作包内 `site/Macmini实操指南.html`、`docs/source/文案与封面打磨记录.md`（Codex 需核实实际可读位置）。
- 本地输出：`Macmini视频文案_首轮审稿.html`，一个自包含文件；GitHub 只提交允许存档且无私人/未确权素材的项目自身文字资料与 Evidence。

## APPLICABLE_CRITICAL_CONSTRAINTS
- 不把「六大操作步骤」作为已冻结的视频模板；Mac mini 只是题材样本。
- 禁止虚构第一手 Mac mini 购买、使用、测试、失败或结果；不能现场核实时写成「官方资料显示/仍待实机验证」。
- 事实引用可追溯；Apple 图片不得未经权利核验重传到公开仓库；无图可使用清晰的缺素材位置。
- Human Writing Skill / 精简语料库是**待验证的写作手段**；不存在/不可读时直接说明，不假装已使用。
- 画面要辅助理解而非装饰；封面本轮只给构图和标题方案，不强制生成。
- 无移动端专项 QA、HTML 视觉设计、网站部署、剪辑、正式配音或账户/服务器改动。
- 原 ZIP、原稿、旧封面和原打磨记录保持不变，作为可回溯输入。

## PREFLIGHT
1. 确认当前真实仓库、分支/工作树、项目路径和只属于本项目的写入边界。
2. 读取当前 Handoff、本 Gate、研究文档；验证源包实际可读，记录来源。对照已有 `SOURCE_MANIFEST` 关键文件哈希，出现不一致 RETURN。
3. 确认本轮可调用的 Human Writing Skill 路径、是否存在 Owner 提供且允许使用的精简语料；缺失时不阻碍默认稿，但不能标记已做。
4. 仅核实文案中将实际采用的关键资料（官方技术规格、接线、迁移、备份），保存所核对的来源和适用机型/版本。
5. 不声称任何需要实机的步骤已被真实测试。

## REQUIRED_EVIDENCE
- 两个不同开头的完整候选；采用哪个及原因；一版完整可朗读口播。
- 口播与视觉 beat 对应表：具体画面意图/素材分类/获取方式/缺口；至少把关键过程和结论落到可制作的画面。
- 需要来源的核心论断与官方来源对应；真实测试与资料引用明确区分。
- 对 Human Writing / 语料的实际使用记录（或 NOT_TESTED）；自然口播读稿自检。
- HTML 单文件本地打开检查结果（能看正文、图片/占位、封面概念）；无单独移动端/视觉打磨验收。
- 产生/变更文件路径与最终交付文件；保留原始文件未更改的检查、限制与风险。
- Evidence 持久化于 `EXECUTION_EVIDENCE.md`，并附精简 Executor 完成包。

## ACCEPTANCE_CRITERIA
1. Owner 能从一个 HTML 文件连续审阅「视频讲什么」「每段准备展示什么」「缺什么素材」。
2. 真实可直接朗读、基于一个中心问题推进；不是只有大纲，也不是生硬清单。
3. 不需要图片生成能力或真实 Mac mini 才能交第一版方案；缺口明示。
4. 所有重要事实能追溯来源；不宣称没完成的实测。
5. 未修改/覆盖原文件，未部署/发布，未扩大范围。
6. 全部 Evidence 可由 Reviewer 真正读到；Reviewer 作 PASS/RETURN。

## ROLLBACK_STATUS_OR_PLAN
只新建独立草稿/HTML/证据，原 ZIP 不变。回滚删除或弃用本次项目专属新产物，不动原包与其他项目。GitHub 通过隔离分支/PR 回滚；无生产回滚。

## OWNER_ONLY_ACTIONS
后续正式确定模板/栏目形态、公开发表、素材授权与账户/付费动作。当前草稿准备不构成发布授权。

## REVIEWER_TO_EXECUTOR_RELAY（给 Codex 的可直接复制提示词）
```text
你担任 Executor（Codex），当前只执行
G1_VIDEO_SCRIPT_AND_VISUAL_BEATS_PILOT_20261028。

本项目的真正目标：探索一套可复用的「实操型视频」文案与画面组织方法。
Mac mini 只是第一期试验题材，原 HTML 只是输入素材，不是视频脚本模板。
最终只需要一个本地可打开的自包含 HTML，方便 Owner 审阅口播、封面概念、
每一段的画面建议与需要补充的素材，不是要开发网站。

默认研究假设：问题驱动的探索式叙事——具体困境→核心问题→尝试/查证
→证据/选择→结论与适用边界。按内容自然变化，不要死板六段论。

仅启动读取：
- macmini-practical-guide/REVIEWER_HANDOFF.md（CURRENT_ACCEPTED_STATE/CURRENT_GATE/CRITICAL_CONSTRAINTS）
- macmini-practical-guide/docs/G1_SCRIPT_PILOT_GATE.md
- macmini-practical-guide/docs/RESEARCH_SCRIPT_FORMAT.md
- 原 ZIP 或工作包里的 Macmini实操指南.html / 文案与封面打磨记录.md，
  先证明真实路径可读，不要猜文件在你的电脑哪个位置。
不重建治理制度，不扫描或改动其他项目。

本轮任务：
A. 围绕「Mac mini 到手后，怎样少花冤枉钱，完成开机和必要设置」
   先写两个明显不同、完整可念的开头候选，选择其中一个。
B. 写一版完整中文视频口播（不要只给提纲、普通文章或分步骤说明书）。
   需要有具体情境、推动过程、可靠信息、合理收尾；适合 B 站实操内容。
C. 把口播按语义画面单元拆分，并逐项说明：
   口播原句；观众此刻要看什么；建议画面方式与重点；
   该素材现在是否有、在哪里找或怎样制作；如缺失则明确标记。
   不要采用「每句话必须 1 张插画」的机械规则。
D. 调用 Human Writing Skill 前检查真实存在与可用性。精简语料库也只在
   Owner 真正提供/可访问时使用。记录真正用过的步骤；没有就标 NOT_TESTED。
   以自然、具体、轻幽默、不过度玩梗为目标，不假造第一手实操。
E. 输出且只交付一个 Macmini视频文案_首轮审稿.html，
   内含完整口播、配画面方案、封面标题/构图概念、素材缺口和来源清单。
   HTML 保持简洁易读、独立可打开；图片暂缺就用标明的占位，不生图。
F. 将真实执行证据增补至 EXECUTION_EVIDENCE.md；
   不改源 HTML/封面/图片，不做移动端优化，不发布、不剪辑、不部署。

如果某项资料/工具无法核验，不得凭空补齐，写明未验证和可行替代即可。
完成一版即 STOP_AT_REVIEWER。不能自主进入第二轮重写。

用固定七行回复 Reviewer：
结果：PASS_CANDIDATE / RETURN_*
改动：...
验证：...
问题：...
回滚：...
请 Reviewer 检查：...
Owner 转交：NONE 或最小动作。
```

## EXECUTOR_TO_REVIEWER_RELAY
以七行完成包为准；先提交独立 HTML + Evidence，Reviewer 才会判定 PASS/RETURN 并据此调整下一轮的提示词。
