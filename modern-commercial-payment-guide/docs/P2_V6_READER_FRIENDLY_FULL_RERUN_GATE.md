# P2第①板块 V6新手友好问题｜完整正文受限重跑 Gate

**GATE_ID：** `MCPG-P2-V6-READER-FRIENDLY-FULL-RERUN-20261016`

**OBJECTIVE：** Owner 2026-10-16已**正式冻结V6全7一级/29二级/42三级问题**，并要求保持所有既定知识/方法论/文风/数据要求，**重跑第一部分完整正文**。本轮须让第①板块的5个二级+9个三级标题**与V6新冻结问题原文、编号、层级、顺序逐字一致**，且全文真正从新手卖家的问题出发讲清商业支付收款选型：**怎么做→为什么→何时不适用**。不能只把旧标题做机械替换而保留与新问题不相称的开头/转场，也不能为白话削弱知识深度。

**MAX_ENDPOINT_THIS_ROUND：** 在PR #132 独立Executor分支，仅**新增** `modern-commercial-payment-guide/docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md` 作为**完整**第①板块知识稿，并在已有 `modern-commercial-payment-guide/EXECUTION_EVIDENCE.md` **append-only** 追加本轮事实与核对矩阵。**不覆盖、重命名或删除原V5及其余任何已审稿件，不改main冻结框架、诊断、试读工具、不部署、不合并PR、不做支付实测、不进入P3–P5**。独立Executor提交后**STOP_AT_REVIEWER**；Reviewer独立审校后才由Owner决定正式冻结第①板块正文。

**MANDATORY_REVIEW_STOP：** `YES / STOP_AT_REVIEWER`。执行结果最多 `PASS_CANDIDATE`，不得称Owner正式冻结。

## TARGET_AND_SCOPE / 唯一基线

- **PR #132：** 当前head `78d8ff48ec019bc051e59eb768f175f384a60a43`，Open/Draft/未合并；若发生新提交/合并或权限漂移，`RETURN_PREFLIGHT_DRIFT`，不可冒险覆盖。
- **唯一权威的新框架：** GitHub main `modern-commercial-payment-guide/REVIEWER_HANDOFF.md` **第二至第四节**（V6正式冻结；基线Blob `17c59ea2e97fe8ff0ce379909cd7c8349e084d37`）；同版只读快照 [FROZEN_FRAMEWORK_V6_20261016.md](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/docs/FROZEN_FRAMEWORK_V6_20261016.md)，Blob `8c7e1d20c4c423cb07a26fca1868b3f3821c3c62`。只需关注**第①板块**的下列H1、5H2、9H3；其余六板块标题暂不可施工。
- **唯一完整写作底稿：** `docs/P2_V5_STRUCTURED_HUMANIZER_CANDIDATE.md`（PR固定Blob `76c0ba0e50adc5377d60f003b479a8b6f7b56c10`，约22,035字符/320行）。它已通过独立Reviewer的知识深度、金融边界、Humanizer中文语言审核，但旧的5H2/9H3已被正式V6取代，不能再作为正式问题权威。
- **只读事实对照：** `docs/P2_REWRITE_CANDIDATE.md` Blob `f8bb110f07ef654df2f5b4b9285540e89261b1f7`，`docs/P2_HUMAN_WRITING_STRUCTURED_CANDIDATE.md` Blob `7924e80634f1f09a5628a78458c43a90d5019fd1`；仅必要时作事实/知识定位，禁止从旧废弃短稿回退，也不让旧稿的叙事标题覆盖V6。
- **证据目录：** `EXECUTION_EVIDENCE.md` 仅阅读**最后一次被Reviewer接受的关键段落与末尾**，避免重读整套历史；续写append-only，本轮只记录真实执行事实。
- **持续约束：** 项目对象为中国大陆个人开发者、独立站、小白卖家、中小商家；不是为某个真人诊断专属收款账户；文章面向大众传授知识体系、识别选择条件、决策方法及有边界的参考案例。

## 第①板块 V6正式冻结文章标题（逐字强制）

```markdown
# ① 收款方案选择：我的生意应该选择哪种收款方案？
## 1. 我的生意收钱时，首先要考虑什么？
### 1.1 卖什么、卖给谁、在哪里卖，会影响怎么收钱吗？
### 1.2 哪些条件必须满足，哪些可以按费用和方便程度来选择？
## 2. 商家常见的收款模式有哪些？
### 2.1 自己收款、在平台卖货、让第三方作为卖方，收钱有什么不同？
### 2.2 Visa、PayPal、Stripe和银行账户分别是做什么的？
## 3. 我这样的卖家能用哪些收款方案？
### 3.1 我是个人还是公司、卖什么、卖到哪里，会限制能用的方案吗？
### 3.2 怎么确认顾客付的钱能合法到账，退款时也有人负责？
## 4. 不同方案的手续费、到账速度和风险怎么比？
### 4.1 一笔订单扣完手续费和提现等费用，到手还能剩多少？
### 4.2 除了手续费，还要比较哪些会影响成交和到账的因素？
## 5. 到底该怎样选定主用的收款方案？
### 5.1 怎么从真正能用的方案里选主用和备用？
## 官方来源、适用范围与事实边界
```

- 解析得到**1个H1、5个知识H2、9个H3及1个来源H2**，所有标点、次序、层级必须逐字一致。不得再使用V5旧正式H3作文章标题，V6原题既通俗又保留原有每章知识覆盖；不可自创第10个H3或跨章迁移。
- 原来的**7个H4示范/案例标题**逐字保持、顺序不变。原商业收款案例A和B保持完整。可以在相应H3首段作最小解释/过渡，以回答新手卖家的V6问法。
- 对照V6第①问题还须保留跨知识点：①1.1 **七维交易画像**；1.2真实资格硬/软条件；2.1平台收款/直接商户收单/软件MoR作为销售方/B2B合同行款四种模式和五类经营业务；2.2 Visa/Mastercard/银联、支付宝/微信/PayPal、Stripe/商户PSP、销售平台、软件MoR、WorldFirst/Wise/银行资金出口的**不同角色与两链**；3.1经营主体/地区/商品/合同/受款资格；3.2顾客付款到合法银行可用及退款/拒付反向责任；4.1同口径费用、支付费/平台费/提现/汇兑/真实到账；4.2支付覆盖/到账效率/预留争议/业务中断；5.1按资格→同条件比较→主备决策，且备用渠道须独立可用。

## APPLICABLE_CRITICAL_CONSTRAINTS / 文风和金融保真

1. **不是重新发明整章。** 旧V5稿已经受审；以其为唯一全文底稿。把正式H2/H3替换成V6，再逐节审视“新标题提出什么新手疑问，第一段是否先直接回答”，必要时最小修改过渡句、术语首次释义、表前解释与章节衔接。**禁止为了自然语言删掉系统性知识**或再压缩为一篇案例故事。
2. **深入浅出与阅读动力：** 新手不知道“需求画像”“闭环”“MoR”时，先用普通卖家会遇到的交易问题解释；随后展示选择方法与概念原理。重点避免 AI套话、过度加粗、反复“不是A而是B”、可见的内部项目执行提示、“本版已……”式行话。方法论优先，但不得承诺个性化推荐。
3. **保留已通过的资产：** 至少原有7个H4标题、**93行Markdown表格正文逐行完全相同且同序**、完整两案例（大陆自然人对美卖29美元原创设计模板、月5至100单；大陆企业Amazon/Shopify向美销售29美元实物，月100单、14天周转）、全部15个 `S01–S15` 来源与25个外部URL（包括链接及次序）、四层金额G/T/A/B、四轮主备、五类小商家场景、YES/NO/UNKNOWN和必要规则条款。
4. **关键金融适用性：** PayPal中国国际商业收款4.40%+$0.30仅适用指定CN双协议、29美元逐单扣约1.58→27.42、5单约137.10<150、6单164.52，**仅特定企业**每批电汇35美元→6单估129.52、10单239.20、100单2707；个人不能照搬企业费。香港银行卡≠香港Stripe商户资格；Shopify中国版Payments仍以真实商户资格/受邀和WorldFirst验证为条件；Paddle软件MoR可能不接受普通设计模板/实体货；退款/拒付、消费者税、银行费、FX及具体账户开户准入不做伪确定性。对任何条款缺新证据，写明来源日期和UNKNOWN，不以润色增加未经证实的数字。
5. **标题白话≠删知识：** 比如新V6 H3 `2.2 Visa、PayPal、Stripe和银行账户分别是做什么的？` 是吸引读者的问题，不表示只需讲这四种产品；还要说明银联、支付方式vs商户产品、平台、MoR、WorldFirst及反向责任。V6 H3 `3.2 怎么确认顾客付的钱能合法到账，退款时也有人负责？` 不能只讲到银行、不讲拒付和退款链。保持A/B案例的真实资格/提现UNKNOWN，而不是替每位读者挑支付商。
6. **有限编辑而非Skill重复试验：** 复用已审Humanizer自然表达风格，本Gate**不要求也不授权安装/调用新的写作Skill**，不重新读额外Skill仓库或下载代码，允许直接基于旧稿调整中文叙述以对齐V6。
7. **外部核验的边界：** 历史资料是当时已审知识底稿，若本轮出现会改变支付事实/费率的时间敏感冲突，不可擅改表格或构造报价；给Reviewer `RETURN_FINANCIAL_FACT_CONFLICT` 指针。普通标题调整不强制额外访问真人商户或进行真实交易。
8. **角色权限：** Executor在独立Codex只追加新候选+Evidence；不能改变main Handoff/正式V6、旧稿、任何其他项目，不能合并PR，不能自宣正式冻结、真人已愿意读。

## PREFLIGHT

1. 读本Gate和main正式V6**只读**第①板块(含权威Blob)、PR head、原稿Blob、Evidence末尾；新目标稿必须不存在；若PR head或任一基线不符 `RETURN_PREFLIGHT_DRIFT`。
2. 从V6权威按Markdown级别构建1H1/5知识H2/9H3/1来源H2逐字匹配数组；从旧完整稿提取7H4/93表格行/S01–S15/25 URL/全部支付金额及主体资格条件作为保真对照。**先列清单再改稿**。
3. 在PR分支另存新候选而不动旧稿，确保可恢复；Evidence先前历史不得覆盖，新增文件不可与已有路径冲突。

## REQUIRED_EVIDENCE_AND_ACCEPTANCE

1. **完整文稿保真**：新 `docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md` 可直接从首段到官方资料读完；禁缩略、占位符、提纲替代；1H1/5H2/9H3/来源H2正式文字逐字同新V6且层级/编号/次序一致，7H4原样/同序。
2. **数学与文字权利一致**：原93表格行逐行完全一致，15条S01–S15及25外部URL原文全量保留且顺序一致；对所有重要数字与费率复算。保留两个完整案例、经营主体/产品/地区/税务责任/资金到账/退款拒付的条件与 UNKNOWN；若无法满足，`RETURN_CONTENT_LOSS` 或 `RETURN_FINANCIAL_FACT_DRIFT`。
3. **知识覆盖检查**：**每个9 H3**做“V6通俗问句→该节第一段简洁回答→后文完整方法/机制→适用限制/官方来源/案例位置”的可核验证据矩阵。第2.1四种模式、第2.2全部角色、第3.2退款拒付反向链、§4.1完整费率、§5.1四轮+两案例必须着重独立定位。**不要为每位个人另做8项输入/6项个性化答案**。
4. **可读性有真实变化**：列**至少5处**现有V5文稿提法与新V6标题直接产生衔接错位的地方，出具真正调整前后精简引文+为什么解决初学者疑惑。不得只替换所有标题便自评“新手友好PASS”；也不得只看形式词频宣称真人阅读已更喜欢。
5. **GitHub只读回验**：最终compare必须仅新建上面的V6全文候选+Evidence append-only，无任何旧稿、V6框架、试读包或源码变动；PR仍Open/Draft/未合并。记录新稿Blob/Commit SHA、反向恢复策略、问题（若有），`PASS_CANDIDATE / STOP_AT_REVIEWER`。不得生成HTML或合并PR。
6. **终极目标真实状态**：本Gate只能证明完整稿内在文本支持，不能把编辑代理/Skill/表格保真误报成读者真实完读/掌握度；真实读者反馈仍 `UNVERIFIED`，且Owner正式冻结P2仍 `PENDING`。

## ROLLBACK_STATUS_OR_PLAN

**TARGET：** PR #132中仅增加独立候选稿和Evidence续写；**RECOVERY_ARTIFACTS：** 已接受PR基线head `78d8ff48ec019bc051e59eb768f175f384a60a43`、V5+Humanizer旧完整正文Blob `76c0ba0e50adc5377d60f003b479a8b6f7b56c10`，main正式V6 Handoff及快照；**METHOD：** 若返工候选失效，仅撤下新增V6文件，Evidence另追加更正，不reset、force push、截断旧证据或修改正式V6；**PROOF/STOP：** Git compare和Blob读回足以验证本文档级回退边界，任何标题/关键金融边界/PR漂移立即STOP后交Reviewer。

## OWNER_ONLY_ACTIONS

Owner已批准V6全框架正式修改及第一部分完整重跑。**尚未批准**P2新稿正式冻结、PR合并/进入P3–P5、真人招募、真实支付或开户。Owner本轮只需按项目治理将此Gate交独立Codex；交回结果后由Reviewer独立判断。

## REVIEWER_TO_EXECUTOR_RELAY

> 你是独立Codex Executor。请只按本[现行V6重跑Gate](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/docs/P2_V6_READER_FRIENDLY_FULL_RERUN_GATE.md)推进 PR #132：固定head `78d8ff48ec019bc051e59eb768f175f384a60a43`。权威是GitHub main `REVIEWER_HANDOFF.md` 第2–4节的**正式V6**（快照Blob `8c7e1d20c4c423cb07a26fca1868b3f3821c3c62`），原文唯一底稿是已审 `P2_V5_STRUCTURED_HUMANIZER_CANDIDATE.md` Blob `76c0ba0e50adc5377d60f003b479a8b6f7b56c10`。**新建**完整 `P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md`：1H1/5H2/9H3全按V6逐字恢复（不能再用V5冻结问句）；正文每组对新手卖家的问法有直接回答，再保留完整通用方法论、93行表格、7H4、两完整案例、15来源、25URL和全部法律/财务边界；不得只有换标题。保留所有旧已审全文，不调用额外Skill、不编造任何现实资质。Evidence仅追加，提供逐节问句→回答→方法的证据与5处改进对照；PR新Commit及Blob回读后 `PASS_CANDIDATE / STOP_AT_REVIEWER`，不合并、不进入P3–P5、不声称Owner已正式冻结。

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：仅新增V6完整第①板块候选、Evidence append-only。
验证：V6 1H1/5H2/9H3/旧7H4/93表格行/两案例/S01–S15及全部关键金额逐项复核、GitHub Blob/HEAD回读。
问题：NONE或具体知识/事实/标题冲突点。
回滚：保留旧V5稿与PR基线，新文件可单独撤销，证据不截断。
请 Reviewer 检查：是否真的回答V6新手提问且方法、知识与金融事实没有丢失。
Owner 转交：新稿链接、Commit SHA与Evidence指针，停在独立Reviewer。
```
