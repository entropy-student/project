# P2① V6全文新手理解门槛 / 教学路径 / 外部写作Skill 整体诊断

**日期：** 2026-10-16  
**性质：** Reviewer READ-ONLY editorial and instructional-design diagnosis; **不是新重写Gate、不代表Owner已授权改正文**。  
**对象：** PR #132 head `dd40ca89ecdffff195f43e3d00c84fa3dee2ada8`，`docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md` Blob `777c5ab45e4f2d748c45a1e524bf172fca467967`，321行/22,702字符。现行V6已由Owner正式冻结7/29/42问题标题。  
**原验收：** `MCPG-P2-V6-READER-FRIENDLY-FULL-RERUN-20261016=REVIEWER_PASS` 对标题/旧稿知识保真/金额/来源/章节直接答题依然有效，**它并不证明零基础读者可理解，内容也没有被Owner最终接受或冻结**。  
**本轮Owner反馈：** “目前基本只是换了标题，内部堆很多专业术语，小白肯定看不懂，希望小白能看懂、老手也有收获；先调研Skill和整体Review。”

## 结论：真实缺口不是AI写作风格，而是解释的知识依赖与读者学习路径

- **诊断：`PEDAGOGICAL_ACCESSIBILITY_GAP_CONFIRMED_BY_TEXT_REVIEW`**（文本中有可定位的未解释术语提前出现、同时介绍过多概念、抽象表格早于完整示范、决策方法与案例迟到）。
- **未通过的不是上轮Gate，而是项目更高层的读者价值目标仍`UNVERIFIED`**：文章能保留所有事实，但读者未必能按顺序吸收；不能把“九个H3首段回答问题”误认为“9节读者真正学会”。
- **比起再次使用Humanizer**，更应采用先具体交易→明白关键概念→再给行业名称→作判断→看对比/例外的教学路径；优先给新手一个**无先修术语的主线**，同时保留专家需要的完整数据/监管条件/出处作为同节次级层或独立附录，不删除事实。
- **现行V6目录不必改**；需要改变的是段落的先后依赖、表格出现之前的解释、实例跨节贯穿、风险条件的“初读翻译”，以及后续HTML的分层显隐，而不只是词语替换。

## 第一部分逐组可定位问题（Reviewer文本证据；行号固定到上列Blob）

| 小节 | 具体阻力/证据 | 为什么阻挡新手 | 修订机制而非删知识 | 优先级 |
|---|---|---|---|---|
| 开篇/§1.1 | L3–7虽用29美元吸引，但L15–23马上要求读懂7维矩阵；**MoR首次出现L17、B2B首次L20、SaaS和收单首次L19，而MoR直到L43才正式解释** | 关键定义出现前已经当作填表前提，读者无法独立填写“销售责任人” | 先用同一个29美元设计模板订单演示3个肉眼能见的条件：卖给谁、在哪里成交、钱要到哪；逐步引入是否有权开商户、谁当卖方。完整7维表完整留存，移到“自己核对/完整清单”次级层或先示范一行再给全表 | P0 |
| §1.2 | L31–35一次性罗列主体、商品、买家方式、账户、退款、YES/NO/UNKNOWN | 判断标准是对的，但初读尚不知什么叫商户资格、什么是受款账户 | 用一个“香港银行账户≠香港商户资格”的反例带出硬门槛；然后讲“可以／明确不行／尚未知道”，再附专业标记YES/NO/UNKNOWN | P1 |
| §2.1 | L43一段同时介绍平台、独立站、软件MoR、B2B合同，L45–50立即四列商业模式大表，L54–58又五类生意 | 读者分不清“卖东西的是谁”和“替谁代收钱”，在尚未建立最简单的顾客→商家模型时出现四种制度 | 先对比两笔直观交易：“自有站卖模板”和“在Amazon卖货”，明确谁卖、谁结账、谁退款；再介绍MoR/B2B两种扩展，完整四模式/五场景表保留为查阅层 | P0 |
| §2.2 | L64单段同时讲Visa/Mastercard/银联、PayPal钱包与商户产品、Stripe/PSP、银行、支付宝/微信、平台、MoR、WorldFirst/Wise；L66–76紧接两条抽象链 | 新手第一次接触十余种身份/名词，即使每个单独释义也无法组装全局 | 固定同一29美元订单，一步只问一个人/机构“谁在干什么”；钱包/支付网络、收款服务商、结算银行分三段解释，之后才列专业名和双链对照；重点纠正银行账户≠商户开通 | P0 |
| §3.1/3.2 | L95–110六主体矩阵含香港Stripe、大陆PayPal双协议、Shopify受邀、WorldFirst；L114–132直接六节点闭环 | 术语/经营主体例外太快，抽象判断缺可演示的最低流程 | 先做“同一个卖家为何不能用A却可能查B”的一轮三条件淘汰，再给主体矩阵；资金链以顾客付款→平台显示余额→符合条件提出→银行到账的有序故事呈现，退款反向回扣作为反例；资格仍UNKNOWN | P0 |
| §4.1 | L138–140围绕29美元和G/T/A/B重复，L142–207有四段费用演算、多个不同地区/产品角色，PayPal特定企业$35与自然人案例互相穿插 | 初学者原本只想知道“29美元我能拿多少”，却要同时理解企业协议、汇兑、换主体、MoR法律责任、提现门槛等多个变量 | 先做**一个**可算清的例子：顾客付29→支付费→余额，再说明“余额还不是银行现金”；逐个新增提现门槛/企业电汇/其他费用变量；香港Stripe与Paddle只用于第二层“为什么不能横比”防误判，表格和全部数据原文保留可查 | P0 |
| §4.2/§5.1 | L211–220已直答四项标准；L226–236直到近末尾才给四轮方法，两个完整案例L238–282出现，专家才容易整合此前知识 | 缺早期路线图/贯穿场景；读者不确定为什么先学这么多概念 | 在开篇提前给一句四步决策路线和**一个简短示范**，§1–4沿同一订单每节补全一步，§5再按两完整案例做深入推演。专家保留多主体对比、主备独立性与边界，不让全部复杂性挤在第一屏 | P0 |

**定量定位（只表示阅读密度，不等于阅读测试）：** 原始术语查找：`MoR`全稿约37次、第一次L17、正式定义L43；`B2B`第一次L20，`收单`第一次L19；`结算`与`提现`从开篇L3使用，全文分别约63/56次；数字是简单子串计数，包含表格/重复出处，不作为AI味“越少越好”的验收指标。知识可保留而推迟细节进入主线。

## 外部Skill与可靠方法调研（2026-10-16现场读取）

| 候选 | 官方/源码指针与读取时指纹 | 最适合 | 限制/不推荐用法 | Reviewer建议 |
|---|---|---|---|---|
| **plain-language** | [arjunprabhulal/agent-skills：skills/docs/plain-language/SKILL.md](https://github.com/arjunprabhulal/agent-skills/blob/main/skills/docs/plain-language/SKILL.md)，MIT，Git Blob `a80064b322df5dd720788fd601ef30e45c1d91fb` | **第一推荐**：按读者已有知识确定起点，找核心概念，术语按替换/先教再用/当前不必讲分类；同时保留适用条件、数字、UNKNOWN；每种类比交代局限 | 来源是社区技能而非被验证的教学产品；指南英文示例，需要本项目中文适配；其中“cut”只能剪去冗余措辞、不能删金融事实/必要知识/原7/29/42和表格 | **建议小样本试用，先锁Blob，只读SKILL.md，不执行未知安装脚本** |
| **feynman-explainer** | [mohitagw15856/pm-claude-skills：skills/feynman-explainer/SKILL.md](https://github.com/mohitagw15856/pm-claude-skills/blob/main/skills/feynman-explainer/SKILL.md)，Git Blob `4b311705a5fe1f6d71c30ec6513b15409291f05c` | 质检：要求读者用自己的话复述，定位哪个知识点看似熟悉实则解释不清 | 是多轮学习/检测Skill，不是专门可直接全章替人改写的编辑Skill；真实读者数据仍需真读者 | **仅借用其“脱稿复述+追问反例”检测原则；本轮不安装** |
| **plain-writing** | [docwriter-org/plain-writing-skill：skills/plain-writing/SKILL.md](https://github.com/docwriter-org/plain-writing-skill/blob/main/skills/plain-writing/SKILL.md)，MIT，Git Blob `5022d203e35d9bdd4f2ded74c874ed4c66ba9bd0` | 去冗余措辞/技术文字的逐句改写 | 其强调过度“boring”与少用类比，可能丢失这份教学指南的吸引力；和现有human-writing/humanizer重叠 | **不作为新主Skill** |
| **concept-scaffolding** | [aiskillstore/marketplace：skills/92bilal26/concept-scaffolding/SKILL.md](https://github.com/aiskillstore/marketplace/blob/main/skills/92bilal26/concept-scaffolding/SKILL.md)，Git Blob `c7b059a627f7fcee18c1a53b2b7e6c2174a91619` | 识别概念先后依赖，按示范/练习/检查逐步增加复杂度 | 聚合站来源、证据强弱不明，文中固定“新手每段2-4概念”等数字不宜当已证实科学标准 | **仅借鉴概念依赖图，勿拿任意数字当硬指标** |
| **html-explainer** | [ds-vibe/html-explainer：SKILL.md](https://github.com/ds-vibe/html-explainer/blob/main/SKILL.md)，Git Blob `24fc2b2b339b1ab93c2a5f17e4ac2b9307ffa42a` | **未来HTML阶段**：同一事实分为初学者主线→详细解释→来源/完整对照表；用小互动展示步骤 | 工具以HTML制作为目标，含要求七问访谈、可自由改变章节顺序等指令，**与冻结V6问题/Owner无需反复确认冲突**；当前不能整体调用 | **未来阶段可摘取经本项目Gate批准的展示原则，不提前生成HTML** |

**核心可靠框架（不需要安装第三方Skill）：**
- 美国政府 [Digital.gov Plain Language｜Organize](https://digital.gov/guides/plain-language/principles/organize) 倡导按受众已有知识、问题和过程顺序组织，重要结论先给，并将背景信息后移；[Write for the Reader](https://digital.gov/guides/plain-language/principles/write-for-reader)强调听真实读者问题，面向不同知识起点区别表达。
- [Diátaxis官方](https://diataxis.fr/)区分**入门示范（tutorial）、完成事情（how-to）、原理解释（explanation）、查阅资料（reference）**，不同用途不必一次放进同一段落。本项目可保留V6目录，在每节内部明确角色/层次而非硬改冻结标题。
- [Nielsen Norman Group：Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/)支持初始仅展示对主要任务重要的信息，让需要的人展开高级内容；这是**未来HTML展示架构原则**，不是把现有93行表格删除。
- [EEF：Worked examples / Mistakes and explanations](https://educationendowmentfoundation.org.uk/news/eef-blog-mistakes-and-explanations)讨论例题演示和错误解释作为学习支架，可作为第4章从单笔示例逐步引入多变量对照的参考，不等于它验证了本指南的真实阅读效果。

## 推荐教学框架：同一知识保留，三层阅读

**第一层（新手主线，不需先知道PSP/MoR）：** “我卖29美元设计模板给美国顾客，怎样让他付款、我合法拿钱？”一条贯穿全篇的订单，先给**四步答案**：明确卖什么/卖给谁→排除无法开户/不接受商品/不能到账→比较扣完费和到账时间→准备真正独立备用。每一步只教当前马上能用于判断的概念，读者看完此层能讲出方法。

**第二层（深入但不卖弄）：** 解释第一层每一步为什么成立/不成立；卡网络vs支付商vs受款账户、直接收单vs平台vs软件MoR、退款/拒付反向责任、同主体报价与不同合同职责为什么不能只横比，专家能学到真实选型中的例外与陷阱。

**第三层（可查证）：** 保留全部原93行表格、两个完整案例、15官方来源、费用数字和所有地区/商品/主体风险边界；在Markdown新稿里可通过**“主文首轮答案→下方完整表格及延伸解读”**分层，未来HTML才通过折叠/局部展开增强选择性阅读。**并非删减内容或隐藏误导性的必要法律限制**；改变决策的资格警告仍在主文清晰表述。

**样式演示（仅编辑原则，不是新稿或金融建议）：**
- 原§1.1开始：七维表中第一列问“谁在合同/发票中向顾客销售、商户自己还是MoR？”
- 建议先写：“假设你在自己的网站卖一份29美元设计模板给美国顾客。先别急着选择Stripe或PayPal：顾客能用什么付款？你是否有资格申请商家收款？钱最后能否按合法的路线进你有权使用的账户？这三件事回答不出来，比手续费先便宜几毛更重要。接下来再展开完整检查表。”然后再解释**“谁真正向顾客销售”**，到该用MoR时再正式引入术语，且明确它不是普通代收。
- **边界：** 此演示不意味着该自然人真的可使用任何PayPal账户或取得跨境提现资格；所有主文情景仍为教学假设。

## 可验证的下一轮方案（**未授权，不能自动下发**）

1. **不要再上第三轮humanizer、plain-writing或改动V6正式题头**。若Owner认可诊断，用一个受限教学重构Gate：先在同一轮内部试改**1.1 + 2.2 + 4.1**三处高风险问题，依据以下检查及时修正方法，再一次完成全章，不做无限Gate链。
2. **第一阶段同轮校准：** 钉住只读`plain-language` Skill Blob；先列“术语第一次出现行号→应该先教什么→可保留专业术语的位置”和“九个H3读者首次回答能做什么”；别只统计词频或字数。允许重排**V6 H3小节内部的非权威段落和表格前引导**，但明确保留已审表格**全文与相对顺序**、原7H4及两案例/S01–S15；如果必须改变表格所在位置，需要在新Gate列出该修改范围并获Owner批准（不能在旧Gate下偷换）。
3. **对照验收：** 三种读者视角测试：①真正零基础能否复述“卖家主体/顾客支付/银行到账三个不同问题”；②一般小商家能否按四步对真实条件作YES/NO/不知道；③熟手能否从同主体费率/企业35电汇/软件MoR商户责任获得实质新认识。**Reviewer代理只能报告`TEXT_PROXY`，任何真实愿读/理解的`PASS`需要真正试读**。
4. **不得假装技能自动产生教学质量**；建议先由Reviewer做一次简短差异阅读，然后交Owner看1.1及2.2示范是否符合期待。下一轮可不引入外部Skill，直接用上述明确写作验收条件；如确要一个新Skill，优先只读引用`plain-language`，禁止执行未知代码或全章一次性无监督重写。
5. **权限/阶段：** V6正式7/29/42标题已冻结，P2已有V6候选此前Reviewer PASS仍成立，**Owner已经明确提出新的教学质量疑虑，故Owner最终冻结P2正文继续HOLD**。本报告只完成调研及Reviewer诊断，PR主稿没有任何修改、不再授权P3–P5/合并。

## 项目管理状态

- **DIAGNOSTIC_RESULT**：`PEDAGOGICAL_ACCESSIBILITY_GAP_CONFIRMED_BY_TEXT_REVIEW`
- **P2_ARTICLE_FREEZE**：`HOLD_FOR_OWNER_PEDAGOGY_DECISION`
- **CURRENT_EXECUTOR_GATE**：`NONE`（旧V6 Gate Reviewer PASS并关闭）
- **REAL_READER_VALUE**：`UNVERIFIED`
- **RECOVERY**：PR head `dd40ca89ecdffff195f43e3d00c84fa3dee2ada8`，全部原稿与金额/出处保留；本轮仅独立main诊断，不触碰PR。
