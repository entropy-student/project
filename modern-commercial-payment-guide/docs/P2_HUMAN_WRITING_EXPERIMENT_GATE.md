# P2 阅读表达实验 Gate｜human-writing 单技能 A/B 对照

**GATE_ID：** `MCPG-P2-HUMAN-WRITING-READABILITY-PILOT-20261016`

**OBJECTIVE：** 按 Owner 2026-10-16 的新指示，使用 `KKKKhazix/human-writing` 对已通过 Reviewer 技术/知识内容审查、尚待 Owner 体验确认的 P2 第一板块开展**一轮独立表达实验**。要提高中文自媒体科普长文的阅读驱动力、读者获得感和自然程度，同时保持支付事实、适用条件和决策方法不退化。

**MAX_ENDPOINT_THIS_ROUND：** **只做一篇约1500字的独立阅读样稿**，主题为“29美元商品的付款如何成为商家可用的现金”，并给出对照来源及自查证据；**不覆盖现有 PR #132 候选全文**，不修改冻结7/29/42、不启动 `copy-editing`、P3/P4/P5、不做 HTML。待 Reviewer 对照后决定是否扩大范围或动用第二 Skill。

**MANDATORY_REVIEW_STOP：** `YES; STOP_AT_REVIEWER`。Executor 只能提交 `PASS_CANDIDATE` / `RETURN_*`，不得自行判实验成功、合并 PR 或推进下一阶段。

## TARGET_AND_SCOPE｜已接受事实及来源

- P1：7/29/42 的**结构审查 PASS**；原首稿 P2 整体废弃，不得作为创作依据。
- PR #132 第二轮内容候选已在 head `17ea75adec7448a8bbe6387788b5bfe321ff68f6` 获 **Reviewer 内容 PASS**，Owner 反映“内容丰富但没有看下去的欲望”，**并没有接受整体表达风格或批准合并**。
- 阅读样稿只以该已审核版本下列片段为知识基线：`modern-commercial-payment-guide/docs/P2_REWRITE_CANDIDATE.md` **§4.1 第130–172行**以及 **§5.1 演练A第228–245行**；其末尾的官方来源 `S02/S05`。若必须补上下文，仅按缺口定向阅读 §1、§2，不用其他已废弃稿件。
- **Skill 原文：** https://github.com/KKKKhazix/human-writing/blob/main/human-writing/SKILL.md （Reviewer 2026-10-16 读取 Blob `76bbf86ef49504628e356555f4da7cc6cbac3b7c`）；需按其指定读取 `references/forum-prose.md` 和 `references/reality.md`，完成初稿后才读取 `references/revision.md`。不要只根据 Skill 名字凭空推断行为。源文件变动需说明、审查差异后应用。Skill 安装不是必须前提，读取官方源码并严格应用即可。
- **Skill冲突优先级：** Owner 的真实金融科普目标、冻结结构、可核验事实和披露限制优先于 Skill 的文风禁令。例如必要的金融比例/公式、官方产品名、来源网址与核验附注，不得为了禁止冒号、排比或“闭环”等修辞项而抹去关键结论；仍应避免商业黑话与虚构细节。

## APPLICABLE_CRITICAL_CONSTRAINTS

1. 金融案例是**明确的假设演算**，不写“我开过账户”“我的买家付款”或虚构企业/人物/心理对白。不制造没有证据的亲历、支付成功或服务商承诺。
2. 选用**已获准对应产品、符合指定 PayPal CN 协议的大陆企业账户**作本例，清楚明示假设，不能将特定企业账户每批 **US$35** 美元电汇费用直接推广至自然人/所有 PayPal 中国账户。
3. 保留关键前提和数值：US$29 每单；在给定协议与交易条件下 4.40% + US$0.30，逐单演算约剩 US$27.42；该美元电汇路线最低 US$150；5单余额约US$137.10尚不到门槛，6单约US$164.52达到，扣除一次已知 US$35 后约 US$129.52（银行费用与换汇前的假设估值）；100单前述净额约US$2,707.00。这些仅是**公开规则下的算例**，银行实收/实际账户审核/税费/汇兑仍 `UNKNOWN`。
4. 除具体示例外，可以延伸“为什么低单量和高单量可能选不同路线”的判断，但**不得新增未经来源支持的真实费率/可用性/案例事实**。
5. P2 冻结知识架构、旧 P2 经验、PR #132 候选与执行证据既有段落不得覆盖。现有 Shopify/Stripe/Paddle 等其他段落不要求本轮改写。若文字示范必须提到，应维持原事实适用边界。
6. 不使用第二个 Skill（`copy-editing`）或其他改写代理叠加，以便识别 `human-writing` 本身的影响。

## PREFLIGHT

- 只读确认 GitHub main 的 REVIEWER_HANDOFF 和当前 Gate；PR #132 仍 Open/Draft/未合并；当前候选 head 为上面限定提交（若漂移则 RETURN 给 Reviewer，不静默改写错版）。
- 确认仅往项目自有路径创建独立新文件，未授权账户/生产/真实支付/Secret 操作。
- 从已审 P2 官方引用[S02]/[S05]核对事实来源、合同适用范围及金额；在事实不够时缩短而不虚构。

## REVIEWER_TO_EXECUTOR_RELAY

> 你是**独立 Executor**，不是 Reviewer。只读取本 Gate、项目 REVIEWER_HANDOFF 的当前状态、上述已审核 P2 的精确源段以及 human-writing 主 Skill 和指定参考。按 Skill 完成一次**独立约1500字的真实金融科普阅读样稿**，主题是“29美元卖出后，钱怎么才能真正到手”。确保它呈现读者疑问→意外费用/门槛→真实计算→行动结论的自然推进，不编故事；不要把原先 Markdown 表格照抄成长段机构腔。保留所有会改变结论的金融前提，尤须分清企业 PayPal 电汇示范与大陆自然人。只新建样稿、在 EXECUTION_EVIDENCE 追加本 Gate 证据，提交同一 PR 分支并回读，随后停在 Reviewer。不要覆盖已通过内容或启动第二 Skill。

## REQUIRED_EVIDENCE / ACCEPTANCE_CRITERIA

- 新文件：`modern-commercial-payment-guide/docs/P2_HUMAN_WRITING_SAMPLE.md`，约 1200–2000 中文字，语言自然，开头从**具体真实算例**进入，不以抽象五步法或“本文将”起篇，不强制与现有章节标题同步。
- 文字中至少有 **5 个能对回原稿或官方来源的独立具体事实/数值/流程**；每段推动新信息、问题、后果或决定，而非只换表达重复解释。保留明确条件，不将数字报成已到账。
- 附录或尾注提供最小必要的来源映射（旧稿具体段落与官方链接），不将工作流程、审稿规则、Skill 名字写入给读者看的文章主正文。
- `modern-commercial-payment-guide/EXECUTION_EVIDENCE.md` **append-only** 本轮记录：Skill真实版本/参考、源文固定 hash/commit、5+个事实对应、实际新增文件/字数/变更范围、阅读质量自查、事实保留、自检结果及 `PASS_CANDIDATE` 或明确 RETURN。
- 本轮不要求重写完整 P2；不要求下载第三方私人素材库；不得收取真实支付/部署。
- 完成后提供 PR 链接、文件链接、最新 commit、只读回读，确认原 P2 文件 blob 仍为 `f8bb110f07ef654df2f5b4b9285540e89261b1f7` 或经 Reviewer确认未变。

## ROLLBACK_STATUS_OR_PLAN

仅在现有 PR 的编辑分支新增独立样稿、向执行证据追加记录；删除实验文件/撤回 commit 可回到审核过的正文。不得改 main 业务正文或冻结框架。

## OWNER_ONLY_ACTIONS

Owner 已明确授权本**单技能表达实验**与随后的 Reviewer 复核，不授权自动全面重写、改变金融核心内容、合并 PR 或推进 P3。默认不需另行决策；若无可用独立 Executor 通道，需最小化转交本 Gate，不得由 Reviewer 冒充已经执行。

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：仅新增独立表达样稿，执行证据追加。
验证：事实保留、5个具体材料、Skill应用与只读回读结果。
问题：NONE 或明确阻塞。
回滚：原P2不变，候选独立可撤回。
请 Reviewer 检查：是否比基线更想读下去；读者是否获得知识、能否执行判断；是否仍有无谓长句/AI腔；金融限定、算术是否完好；是否需要 copy-editing。
Owner 转交：具体链接与Commit SHA，若无需转交为NONE。
```

**Reviewer后续判断：** 人工对照旧稿与此独立样稿，分别评价开头驱动力、段间推进、新信息密度、金融事实严谨度和选择结论是否更清楚。仅当“吸引力仍有明显结构性问题、且第一技能的表达已基本实现”时才考虑 `copy-editing`。第二技能必须另有新的审核边界，不能自动叠加。