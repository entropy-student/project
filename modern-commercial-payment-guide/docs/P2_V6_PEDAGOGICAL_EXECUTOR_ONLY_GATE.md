# P2 V6 教学重构｜独立 Executor 专属执行 Gate（替代已撤销的 R1）

**GATE_ID：** `MCPG-P2-V6-PEDAGOGICAL-INDEPENDENT-EXECUTOR-20261016`  
**AUTHORIZATION：** Owner已明确授权“现V6正文冻结保留、下一版独立改写后比较”，又指出Reviewer不得执行改稿，要求删除其自行写作的R1，并严格按项目管理规范继续。  
**STATUS：** `GATE_RELEASED / INDEPENDENT_EXECUTOR_PENDING`。  
**VOID_PREVIOUS_GATE：** 原 `MCPG-P2-V6-PEDAGOGICAL-R1-20261016` 因允许Reviewer越权写稿而撤销为历史文件。**不得沿用历史R1草稿、任何固定旧Commit内容或此前“编辑自检PASS”。**  
**OBJECTIVE：** 让《现代商业支付系统》第一部分达到“零基础小白沿一笔交易理解、熟手得到有深度的判断”的教学目标；不是换标题或再做Humanizer。  
**MAX_ENDPOINT_THIS_ROUND：** **由独立Codex Executor**从已冻结V6完整文稿独立重写并在PR #132只**新增** `modern-commercial-payment-guide/docs/P2_V6_PEDAGOGICAL_EXECUTOR_CANDIDATE.md`，向 `EXECUTION_EVIDENCE.md` append-only 增加这轮记录。新稿完整可读，完成自检与提交后 `STOP_AT_REVIEWER`；**不改变已冻现稿、正式V6目录和前版已审核文件**。  
**MANDATORY_REVIEW_STOP：** `YES`。Executor结果最多 `PASS_CANDIDATE`，仅独立Reviewer可判PASS，Owner最终决定是否替代冻结正文；不合并PR、不写P3–P5、不制作HTML。

## TARGET_AND_SCOPE / 固定预检
- **项目与PR：** `entropy-student/project` PR #132，当前Open/Draft/未合并；预检head必须为 `2321737cd65aca50a80c68bca1dc34784e8de9a6`，工作分支 `mcp-p2-independent-rewrite-20261016`。PR head或待新增目标路径发生变化→ `RETURN_PREFLIGHT_DRIFT`，不要覆盖或接管不明提交。
- **唯一完整内容底本：** main `modern-commercial-payment-guide/docs/P2_V6_OWNER_FROZEN_REFERENCE_20261016.md`，Blob **`777c5ab45e4f2d748c45a1e524bf172fca467967`**；与PR旧 `docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md` Blob完全一致。Owner已明确冻结此版**作为保留基线**，不能修改、删除、覆盖。其后两案例、7H4、93行原表、S01–S15及25URL都是需保留的知识资产。
- **标题权威：** main `REVIEWER_HANDOFF.md` 第2至4节（V6 7一级/29二级/42三级已正式冻结），同版快照 `docs/FROZEN_FRAMEWORK_V6_20261016.md` Blob **`8c7e1d20c4c423cb07a26fca1868b3f3821c3c62`**。只需重写第①板块现有1H1/5知识H2/9H3/来源H2共16标题，不得改变任何标题或编号。
- **已通过的诊断而非写作来源：** main `docs/P2_V6_BEGINNER_COMPREHENSION_DIAGNOSTIC_20261016.md` Blob **`971212deb1c2589e73642d5cdcc9d593760e8164`**。包含§1.1名词先于定义、§2.2角色同时涌入、§4.1多种费用制度混讲、四轮选型晚出现。诊断是问题输入，不是可直接照抄的新正文。
- **唯一新增可选Skill：** GitHub `arjunprabhulal/agent-skills/skills/docs/plain-language/SKILL.md` MIT，Blob `a80064b322df5dd720788fd601ef30e45c1d91fb`，**只读文字指南**；禁止安装/执行外部脚本和叠加新的Humanizer或其他写作Skill。
- **越权事故隔离：** Reviewer曾擅自在本PR创建 `docs/P2_V6_PEDAGOGICAL_R1_CANDIDATE.md`，经Owner纠正已于Commit `70fa71556099c260c139717fc4a06f5aeeb58dff`从当前树删除。**禁止把它、早期Commit历史内容及其编辑证据作为写作输入或复用句子来源**。原有事故/撤销记录留在旧Evidence；只需读 `EXECUTION_EVIDENCE.md` 末尾纠正记录确认边界。

## APPLICABLE_CRITICAL_CONSTRAINTS
1. **目标：新手看得懂、熟手有收获。** 用一笔符合明确假设的29美元模板订单演示“卖什么/卖给谁→筛掉不适合的主体及商品路线→顾客如何付/钱如何到账→算费用和退款风险→选主用与真正可运行的备用”。首屏给一个无需懂术语的四步方向；每节先回答新手问题，再以具体例子引入必要术语，给出通用方法与适用边界。深入内容保留在同节后续段落，老手仍能学到主体资格、销售责任、定价、结算和风险判断。
2. **先解释再首次使用。** 对 MoR / SaaS / B2B / 收单 / PSP / 结算 / 提现 / 拒付、销售责任人与四金额层等，首次真正用于判断前要有生活化而准确的解释；不是机械增加释义词典。§1.1的完整七维表可**在同一H3内**置于示例/必要名词解释之后，表格行内容与相对顺序必须字面不变。
3. **事实绝对保真，写作可以重组。** 原1H1/5H2/9H3/来源H2共16条正式标题逐字/级别/顺序不变；原7个H4标题不改；原Markdown表格 **93行全部逐字且全局同序一致**；15条S01–S15官方来源、25 URL 全部原文及顺序保留；自然人29美元数字模板和企业29美元跨境实物/14天周转两个完整案例不能缩减/遗漏，仍需顾客/商家资格与真实最终款限制。
4. **深度与方法论不降级。** 四收款模式和五类经营业务、Visa/万事达/银联/PayPal/Stripe/银行及软件MoR职责、支付与资金正反两条链、六节点合法到账/退款拒付、四金额G/T/A/B、四轮主备、实际账户独立性、PayPal/Shopify/Paddle合同地区/主体/商品边界不消失。专业条款可后移至“深入解释”，但直接影响可用/退款/到账的警告不可隐藏到看不见的角落。
5. **财务准确性：** 仅沿用已有审核的条件与公开事实；示例29×4.40%+$0.30≈1.58→每单27.42，5单137.10<150、6单164.52；特定**大陆企业**$35美元电汇不能套到大陆自然人；香港银行账户≠香港Stripe商户资格；Shopify中国Payments是受邀/需WorldFirst验证；Paddle软件MoR标准收费与其按月结算/最低门槛/对应收费均按旧稿适用条件。汇兑/银行实际费/税务/拒付真实结果未知保持 UNKNOWN；任何新费率/保证必须有官方证据，否则不得添加。
6. **不针对单个人给收款方案。** 案例是假设经营者，展示选择方法和为什么；不得保证真实卖家可开户、可提现、可规避法规。既有“深入浅出、实操、通用方法论、先说怎么做再说为什么、自然中文、不堆AI模板词”的Owner历史准则继续冻结。
7. **职责隔离。** 本 Gate **只允许不同于Reviewer的独立Codex Executor修改正文**。Reviewer仅定义Gate、检查证据、作PASS/RETURN和维护main Handoff；不写候选正文。Owner单独决定R2是否替代当前冻结版。

## PREFLIGHT
1. 读本Gate、固定版V6全文、V6标题权威§①、诊断、可选plain-language技能文字与Evidence最近的纠正记录；不要遍历历史Gate/旧违规R1正文。
2. PR head必须匹配上述固定SHA，且目标新路径不存在；确认冻结基线同Blob、项目目录未漂移、原稿/诊断可完整读取。
3. 抽取并固定旧全文的16正式标题、7H4、93表格行、两完整案例、15来源+25URL、全部关键金额/主体资格/风险限制，作为新稿保真对照。不具备证据则 `RETURN_PREFLIGHT_DRIFT`。

## REQUIRED_EVIDENCE / ACCEPTANCE_CRITERIA
- **全章新候选**必须完整，不接受只给提纲/小样；不是仅替换标题和几个字。优先在同一轮内部校准§1.1、§2.2、§4.1三大难点，再整体完成。
- 机械结构检查：16标题逐字同V6、7H4同序、93表格行逐字同序、S01–S15与25URL同序、两个完整案例/所有既有财务合同条件完整；全部旧稿Blob不变。
- **实际教学改善**：每个9H3给出“读者目前知道什么、现在要回答什么、首个例子、首次术语释义、升级到复杂比较”的简洁证据矩阵；提供至少8处真实旧稿↔新稿的原句对照，重点解释为什么降低了理解门槛。检查首次出现术语位置和解释位置，避免§1.1依赖倒置再次发生。
- **反向误解测试**：初学者应能复述四步选择、区分卡组织/支付服务商/银行、分清平台余额/银行实际到账；熟手要能从公司个人资质、MoR销售责任、结算提现、争议、费率可比条件获得价值。任何编辑模型代理测试只可标记 `TEXT_PROXY`，真实人类理解仍 `UNVERIFIED`。
- **变更范围**：仅新增 `docs/P2_V6_PEDAGOGICAL_EXECUTOR_CANDIDATE.md` 与 `EXECUTION_EVIDENCE.md` append-only；必须保持旧 V6 Owner冻结全文和旧PR基线不动。读回固定Blob与GitHub compare，PR仍Open/Draft/未合并。
- **结束：** Executor `PASS_CANDIDATE / STOP_AT_REVIEWER`，新稿URL+Commit SHA+Evidence指针；不自己给Reviewer PASS、不向Owner宣布R2已替代、不合并、不进入P3–P5。

## ROLLBACK_STATUS_OR_PLAN
- **TARGET** 仅PR新增独立Executor稿+Evidence追加；**RECOVERY** main冻结V6 Blob `777c5ab45e4f2d748c45a1e524bf172fca467967`及GitHub当前PR基线Commit `2321737cd65aca50a80c68bca1dc34784e8de9a6`；**METHOD** 如不合格，仅撤回新候选、Evidence仅追加更正、不force/reset；**TRIGGER** PR、正式V6标题或真实财务合同资格发生影响执行的漂移即停。

## OWNER_ONLY_ACTIONS
Owner授权独立Executor根据本Gate重新撰写对照稿；已冻结版继续有效。只有看到独立Executor新稿和独立Reviewer的结论后，Owner才决定是否接受新版替代旧冻结全文。未授权正式合并/发布/新章节或真实资金操作。

## REVIEWER_TO_EXECUTOR_RELAY
> 请在 PR #132 按本唯一新Gate `docs/P2_V6_PEDAGOGICAL_EXECUTOR_ONLY_GATE.md` 工作。**你是独立Codex Executor，Reviewer不得写正文。** 预检PR head `2321737cd65aca50a80c68bca1dc34784e8de9a6`，源文只用main已冻结的 `docs/P2_V6_OWNER_FROZEN_REFERENCE_20261016.md`（Blob `777c5ab45e4f2d748c45a1e524bf172fca467967`），另只读正式V6标题与新手理解诊断，按需参考 `plain-language` 文字指南。**不要读取/复用已撤销的Reviewer自写R1历史稿**。新建完整 `docs/P2_V6_PEDAGOGICAL_EXECUTOR_CANDIDATE.md`：优先解决术语倒置和§1.1/2.2/4.1/5.1教学路径，保持16标题/7H4/93表格行/两案例/15来源/25URL与金融事实条件。Evidence仅追加、提交新Commit SHA，停独立Reviewer。不要改冻结稿、合并PR、进入P3–P5。

## EXECUTOR_TO_REVIEWER_RELAY
```text
结果：PASS_CANDIDATE / RETURN_*
改动：独立Executor新建V6教学版完整全文，纠正Reviewer越权任务交接。
验证：V6 16正式标题、7H4、93表格行、两案例、15来源及25URL、关键费用与主体条件均读回；至少8处有效教学改写对照。
问题：NONE 或准确错误/缺失/无法执行原因。
回滚：main冻结V6仍完整，新候选可单独撤销，Evidence不截断。
请Reviewer检查：不是只换标题，能否先解释后给表格且不失深度/金融边界。
Owner转交：新稿固定链接、Commit SHA；等待Reviewer和Owner分别确认。
```
