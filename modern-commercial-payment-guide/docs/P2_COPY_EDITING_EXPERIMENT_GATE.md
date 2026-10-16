# P2 阅读表达实验 Gate 2｜copy-editing 定向编辑

**GATE_ID：** `MCPG-P2-COPY-EDITING-READABILITY-PILOT-20261016`

**OBJECTIVE：** 承接 [human-writing 实验 Reviewer 结论](https://github.com/entropy-student/project/pull/132#issuecomment-6208144581)，以 **coreyhaines31/marketingskills 的 `copy-editing`** 对已经通过上一 Gate 的独立样稿**定向编辑一次**，检验删减重复、调整信息出场时机和结尾能否进一步提升自媒体科普长文的阅读意愿；不改变已经确认的金融知识和事实适用边界。

**MAX_ENDPOINT_THIS_ROUND：** 只新增 `modern-commercial-payment-guide/docs/P2_COPY_EDITING_SAMPLE.md` 这一独立第二版样稿，追加本 Gate 执行证据并提交 PR #132，随后立即停在 Reviewer；**不覆盖 human-writing 样稿、P2 正文、已确认 Gate、P1/7/29/42，不做第三个 Skill、全章批量改写、P3/P4/P5、HTML，不自动合并。**

**MANDATORY_REVIEW_STOP：** `YES; STOP_AT_REVIEWER`。Executor 报告 `PASS_CANDIDATE` 或精准 `RETURN_*`，Reviewer 决定可读性结果，Owner 最终决定表达风格。

## TARGET_AND_SCOPE / ACCEPTED FACTS

- 原 P1 冻结7/29/42结构审查 PASS；最初废弃的 P2 不得读取/复用。
- PR #132 第二轮知识正文 **Reviewer PASS**；已审源文件 `modern-commercial-payment-guide/docs/P2_REWRITE_CANDIDATE.md` Blob `f8bb110f07ef654df2f5b4b9285540e89261b1f7`，不可改。
- human-writing 实验已被 Reviewer 接受为合规的单技能实验（但阅读持续吸引力 `PARTIAL`）。主源为 `modern-commercial-payment-guide/docs/P2_HUMAN_WRITING_SAMPLE.md`，Blob `b05dfdc45e03649927a25be0db0380f40a681ba6`，PR head `d0f000e95554e530d3d52ce49acb85a0d1b4825e`。先实际完整阅读该样稿。
- Reviewer精确问题：① **第7行前置长段合同/资格限定打断开头**；② 13/17/19/27/29行反复的到款及审核免责声明降低连续性；③ 5单145美元本就低于150美元，不是强悬念，更可让6单付款174美元、两层扣费后预计129.52美元承担阅读反差；④ 中后段十单/百单重复计算有压缩空间；⑤ 结尾不必重念流程式核查清单。
- **第二 Skill原文：** [coreyhaines31/marketingskills/skills/copy-editing/SKILL.md](https://github.com/coreyhaines31/marketingskills/blob/main/skills/copy-editing/SKILL.md)，Reviewer 读取 Blob `e5fdc0e70e0a2b3d17c1f7761b00b6c51e1e0ac0`（版本 2.2.0）。Executor应真实读取官方 Skill 与其 **`references/checklist.md`**，只选与已存在中文科普非营销稿匹配的清晰度、语气一致、读者关心点、证据、具体性与流畅性检查；不使用其中促销/承诺/FOMO/销售 CTA/伪人物证言等不匹配的策略。Skill 如有显著更新，先返回 Reviewer 而不静默换版本。

## APPLICABLE_CRITICAL_CONSTRAINTS

1. **这是编辑，不是改写全篇/重做选题。** 阅读线从具体订单和商家用钱问题进入，不将文章变成推广 PayPal/Stripe 或付费工具的广告。
2. 坚持官方事实与可比假设：**符合特定 PayPal CN 双协议、已获相应收款及提现权限的大陆企业账户**；国际 USD 商业付款 US$29，费率4.40%＋US$0.30，每单示例费后US$27.42；大陆银行美元电汇最低US$150；**特定企业账户**电汇收费每笔US$35；5单余额US$137.10、6单US$164.52、其减35＝US$129.52、10单减35＝US$239.20、100单减35＝US$2707（均为银行额外费用/汇兑前的示例）。不得将这些表达成真实银行实收或适用于所有大陆个人。
3. 不能为提高戏剧性编造亲身经历、对话、商户投诉、审批成功、到账承诺、新价格或转换率。所有改变结论的条款与不确定性要在读者容易发现的地方保留，可用分层说明减少重复；来源结尾映射仍完整。
4. 本轮 **只用 `copy-editing`**，不复用 human-writing 作为新的执行 Skill（基线文字当然可以延续），不调用第三个写作 Skill。
5. 不触碰任何支付账户、真实订单、Secret或生产系统，无真实交易授权。

## PREFLIGHT

- 读取当前 Gate及项目 Reviewer Handoff 的当前字段；PR #132 必须仍 Open/Draft/未合并，head 与上述基线一致；若材料漂移则先 `RETURN_PREFLIGHT_DRIFT`。
- 阅读上述已审 human-writing 独立样稿和本轮 Reviewer 评论；读取 copy-editing 正式 SKILL 及 checklist，核对版本；仅在本项目 PR 分支创建新文稿及 append-only Evidence。
- 复核样稿原有 PayPal 官方费用/提现来源的主要条款与具体计算。无依据时不得额外编造。

## REVIEWER_TO_EXECUTOR_RELAY

> 你是独立 Executor。先读本 Gate、当前 Reviewer Handoff 的现状、`docs/P2_HUMAN_WRITING_SAMPLE.md` 和 [Reviewer 对 human-writing 的意见](https://github.com/entropy-student/project/pull/132#issuecomment-6208144581)。实际阅读并应用 `coreyhaines31/marketingskills` 的 `skills/copy-editing/SKILL.md` 及 `references/checklist.md`。仅针对**过早出现的长免责声明、数字推进单调、重复提醒、结尾弱**做一次定向编辑，另写 `docs/P2_COPY_EDITING_SAMPLE.md`。保留 human-writing 样稿全文和 P2 知识正文不变，保障费用/账户/适用协议/未知项准确；在 Evidence 末尾追加本轮验证后停止在 Reviewer。禁止第二次循环、使用其他 Skill、自动进下一 Gate。

## REQUIRED_EVIDENCE / ACCEPTANCE_CRITERIA

- `docs/P2_COPY_EDITING_SAMPLE.md` 是独立的完整约1200–1800汉字的第二版，非空壳、非只做语法微调；主要改变信息出场顺序、同质数字段落的密度、过多重复和结尾，而不牺牲真实判断依据。
- **并排对比证明**至少四项有根据的具体改变（旧段落→新位置/处理→为什么更清楚）；没有新增服务商费率或不可靠事实。可在 `EXECUTION_EVIDENCE.md` 做对照，读者主正文不堆内部工作注释。
- 文末保留官方 [PayPal CN商家费用](https://www.paypal.com/c2/business/paypal-business-fees?locale.x=zh_C2)、[中国区提现帮助](https://www.paypal.com/c2/cshelp/article/how-do-i-withdraw-funds-from-my-paypal-account-help394) 的精准适用信息。
- `EXECUTION_EVIDENCE.md` **append-only** 记录 Gate、Skill SHA和适用检查、原稿 SHA/基线 Commit、编辑变化、旧新事实逐项核对、数值复算、样稿文件回读 SHA、未修改的源文件SHA、异常和回滚。
- 不编造真实完读率或评分；样稿只能由 Reviewer 主观冷读比较，最终是否采用由 Owner 确认。
- 仅在 PR #132 上完成，提交后给具体 GitHub 链接、Commit SHA、回读结果与 `PASS_CANDIDATE`；不得合并。

## ROLLBACK_STATUS_OR_PLAN

本轮仅新增独立第二版、向 Evidence 追加：可移除第二版或以 Git 历史复原，原已审文章及第一实验样稿均保留。无真实资金/账户操作。

## OWNER_ONLY_ACTIONS

Owner 已授权依 Reviewer 对第一 Skill 的评审决定是否试第二 Skill；本 Gate **仅授权第二 Skill 的独立单稿比较**，不能视为 Owner 已接受第一/第二表达风格，也不授权批量化应用与合并。当前需要 Owner 将 Gate 链接转交独立 Executor 的最小动作。

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：新增 copy-editing 独立样稿 + Evidence 追加。
验证：四项以上编辑对照、合同/企业费率保留、所有关键金额回读核算、原文和第一样稿未变。
问题：NONE 或具体阻塞。
回滚：本轮第二版可独立撤回。
请 Reviewer 检查：是否真的比 human-writing 第一版更愿意读、结论更清楚、是否丢失金融边界。
Owner 转交：样稿、PR 和 commit 链接。
```
