# P2 结构保留型重跑 Gate｜撤销两份短文实验稿 → human-writing 全章改稿

**GATE_ID：** `MCPG-P2-ROLLBACK-AND-HUMAN-WRITING-STRUCTURED-RERUN-20261016`

**OBJECTIVE：** 根据 Owner 最新明确决定，先撤回 PR #132 中两份因丢失原分层框架而未获 Owner 接受的**孤立短篇实验文件**，恢复以原先已审核 P2 完整章为编辑基线；然后**只使用 `KKKKhazix/human-writing`** 对第①板块的**所有现有小节**逐节改进阅读吸引力，保持全部层级、商业知识、案例、计算及来源。禁止再次把整章压扁为一篇文章。

**MAX_ENDPOINT_THIS_ROUND：** 一个受限的两阶段 GitHub 文稿 Gate：阶段 A 移除两份失败表达短篇文件并回读有效内容基线；**只有阶段 A 完全验证通过**，阶段 B 才新建一份**结构完整的 P2 全章 human-writing 改写候选**、在执行证据末尾追加事实与验证，再停止 Reviewer。无第三个 Skill/复写旧 P2/P3/P4/P5/HTML/合并/生产或真实支付操作。

**MANDATORY_REVIEW_STOP：** `YES; STOP_AT_REVIEWER`。仅允许 Executor 返回 `PASS_CANDIDATE` 或精确 `RETURN_*`，不自行宣布 PASS、代替 Owner 确认风格或跨越后续阶段。

## TARGET_AND_SCOPE｜原始版本和唯一写作依据

- PR：[entropy-student/project #132](https://github.com/entropy-student/project/pull/132)，目标分支 `mcp-p2-independent-rewrite-20261016`；Reviewer 只读基线 head `c3341053cdd3f67cb78a2e8d8ad1dba9b3e8b15c`（若现值不符，先 RETURN_PREFLIGHT_DRIFT，不要自行丢弃他人新提交）。
- **原先通过的原始版本：** `modern-commercial-payment-guide/docs/P2_REWRITE_CANDIDATE.md`，以 commit `17ea75adec7448a8bbe6387788b5bfe321ff68f6` 的 Blob SHA `f8bb110f07ef654df2f5b4b9285540e89261b1f7` 为**唯一文章写作基线**。截至本 Gate 创建时，当前 PR head 的此文件 Blob 仍完全一致，**实际上不需要重置此文件，也不得覆盖它**。
- **阶段 A 仅撤回：** `modern-commercial-payment-guide/docs/P2_HUMAN_WRITING_SAMPLE.md` Blob `b05dfdc45e03649927a25be0db0380f40a681ba6`、`modern-commercial-payment-guide/docs/P2_COPY_EDITING_SAMPLE.md` Blob `9a4bdd2971ac1a4307e82582a3ae1d9ab413d3e5`，二者仅是过往未被 Owner 接受的短篇实验产物；其历史 Commit 在 GitHub 可重建，删除仅针对当前 PR 文件树，**不得 force push / reset / 历史改写**。
- **证据保留：** `modern-commercial-payment-guide/EXECUTION_EVIDENCE.md` 旧两轮事实记录保留 append-only，不为获得表面纯净状态而删除审计历史。阶段 A 与 B 分别**追加**说明旧稿失效/可从历史重建/恢复的具体检查和新稿交付事实。原版 Evidence Blob `df6c55648c6cb52c7d2f391989f1aa6b1563d8c0` 仍可从 commit `17ea75...` 取得，但当前 Evidence 不回退覆盖。
- **额外项目事实：** P1 已通过的是冻结 7/29/42 的结构覆盖审查；第①板块本身有**5 个二级、9 个三级节点**。最早被 Owner 废弃的原旧 P2 不可读取或复用；本 Gate 仅允许使用上述已审核的新 P2。已有两份短篇只作为待撤销目标的路径/Blob，不应当作为新稿文字输入。
- **唯一 Skill：** `KKKKhazix/human-writing` v1.1.0，主 `human-writing/SKILL.md` Blob `76bbf86ef49504628e356555f4da7cc6cbac3b7c`；完整读取主 Skill 和 `references/forum-prose.md`、`references/reality.md`；**初稿完成后**再读取 `references/revision.md` 改稿，不使用 `copy-editing` 或任何其它写作 Skill。若上游明显版本漂移，先记录并 RETURN 给 Reviewer。

## 结构保留硬约束｜必须逐字保留以下已经审过的标题

输出 `docs/P2_HUMAN_WRITING_STRUCTURED_CANDIDATE.md` 内的所有下列 H1/H2/H3 应与已审核原稿 **原文、编号、级别、顺序逐字一致**；**不能删、重命名、合并、升降级或移到附录**，正文必须分别完整呈现在它们之下：

```markdown
# ① 收款方案选择：我的生意应该选择哪种收款方案？
## 1. 我的生意需要满足哪些收款需求？
### 1.1 把生意写成一张“交易画像”，否则任何推荐都没有对象
### 1.2 分两类门槛：不合格的路线不进入价格排名
## 2. 国内外有哪些主要收款模式与方案？
### 2.1 核心分类依据不是“国内/海外”，而是“谁承担销售、谁完成收款”
### 2.2 读懂两条相互独立但必须接通的链
## 3. 哪些方案符合我的经营条件？
### 3.1 用“实际主体 × 交易商品 × 销售地区 × 销售角色”排除路线
### 3.2 合规收款的终点不是“支付成功”，而是“可以用于经营的钱”
## 4. 如何比较不同方案的费用、效率和风险？
### 4.1 先把“净收款”和“现金到账”定义清楚，再做同条件比较
### 4.2 交易费接近时，比较“能赚到”而不只是“扣得少”
## 5. 如何确定最适合自己的收款方案？
### 5.1 四轮决定主方案和真正的备用方案
## 官方来源、适用范围与事实边界
```

**冻结问题覆盖：** 在这些标题对应的正文中还必须逐一实际回答现行 P1 已冻结的每个问题，不允许只靠标题文字匹配就 PASS。参照原先 [P2_REWRITE_GATE.md](./P2_REWRITE_GATE.md) 的 5×9 问题映射，但不能凭此改掉上面已审 P2 标题或冻结 P1 原文。

**可保留和鼓励的格式：** 章节、编号、表格、分情景比较、实际费用计算、核验清单、适用说明、案例分支、官方来源。Skill 的散文默认不能禁止必要的 Markdown 标题、冒号、费用公式或机构专名；本 Gate 的读者任务、事实安全和章节结构的优先级更高。

## APPLICABLE_CRITICAL_CONSTRAINTS

1. **编辑边界：** 本轮是**完整原第①板块每个小节内部的表达重写**，不是写一篇新的独立小故事、抽取单一 PayPal 案例、从原稿删除分类/比较表、替换整个知识体系或把各节合并。每节原有方法、核心结论、角色分类、费用分析、操作判断与适用条件都应保留，并通过自然语言改善阅读。
2. **文本质量：** 对每个小节分别优先给商家可执行的判断或真实问题；再用原有事实/可验证案例解释“为什么”和“接下来怎么判断”。缩短没有新信息的重复措辞，减少无谓风险警告，但**不能删掉任何会改变决策的合规条件**；无虚构个人亲历、假商家、杜撰对话、过度营销腔或 FOMO。原有对照表可与上下文配合，而非一律转换成长段文字。
3. **全部业务覆盖：** 保留真实经营主体、顾客/商品/市场/平台/付款责任/资金终点七维画像；平台交易、直接商户收单、软件 MoR、B2B 合同银行路线；境内自营、跨境平台、跨境实物独立站、软件订阅、B2B 大额交易五类；付款/合同链和资金/责任链的不同角色，以及风险责任与独立备用方案。
4. **两个具体选型案例必须完整：** 大陆**自然人**海外数字模板 $29，以及大陆**企业**海外实体商品 $29/单、月100单，均必须有合法性与销售角色判断、主/备方案及必要条件、为什么选择/不能选、现金到银行环节的已知与未知项。不能用企业 PayPal US$35 提现费证明大陆自然人必然适用。
5. **金融及合同事实要保住：** PayPal 中国大陆价目表仅对应指定协议账户；例示国际 USD 每单 $29、4.40%+$0.30，示例按美分1.58、单余$27.42；最低美元电汇 $150；**特定企业账户**向大陆银行美元电汇每笔 $35；5单$137.10、6单$164.52→已知费后$129.52、10单$239.20、100单$2707；银行入账、中转、FX、税费、可能退款等未知，不能冒称实收。Stripe HK 定价不得套大陆主体；Shopify第三方收单可能额外收 Shopify 交易费，而中国版 Shopify Payments 受邀且 WorldFirst 条件性；Paddle MoR 商品范围及定价不得与自营商户直接作为同法律身份排名。
6. **事实与来源：** 原稿来源[S01]–[S15]及最新可靠官方资料对应维持。凡关键费用/产品适用条件重新核验当日官方资料；如新旧冲突，保留来源和 `UNKNOWN`，不要虚构新费率或跳过一个事实点。不能“篇幅缩短”作为牺牲覆盖的理由；没有必须达到的总字数上限。
7. **范围防护：** 不修改 `docs/P2_REWRITE_CANDIDATE.md` 已审核正文、P1、7/29/42冻结问题源、任何其他业务项目、现行 Gate 或 main；不触碰真实支付账户或环境变量、部署、退款、支付、提现；不做 HTML；不启动 P3 或第三 Skill。
8. **交付主旨：** 读者可**按原小节逐项查阅**，也能顺序读懂；每个小节有一项明确读者收获，不能让文章“文风好看但不知道怎么收钱”。

## PREFLIGHT / PHASE A｜先安全回滚旧表达实验

1. 对 PR #132 当前 head、Branch、Draft、未合并、受影响三个正文文件 Blob、Evidence Blob 及同项目 path 变更范围作**直接读回**；确认原完整 P2 原文 Blob **仍是** `f8bb110f07ef654df2f5b4b9285540e89261b1f7`。任何 drift/权限缺失/无法证明可恢复旧实验内容立即 `RETURN_PREFLIGHT_DRIFT` 或对应精确 RETURN，不进行删除、更不可用重置代替。
2. 两个要撤销的短篇只能**精确删除上述两条完整路径**，必须逐个证明其文件 SHA 与 Git 历史可读且并非其他分支依赖的独特资料。不得清理别的工作、证据、Gate、主稿或共享 Git 拓扑。不得 force push。必要时以 GitHub 自身的 delete-file 提交两个顺序 commit。
3. 删除后**直接回读两个路径得到 NOT_FOUND**，再回读原 P2 Blob 未变；确认 PR 仍 Open/Draft/未合并；当前 Evidence 原有旧记录完好（包括前两轮失败稿件历史事实）。在 Evidence **追加**一条 `ROLLBACK_COMPLETED` 及来源/删除提交 SHA，明确旧短文已从当前树撤下，但历史可通过 Git commit 重建。
4. 未达到以上全部条件，**本 Gate 停在回滚失败的精确 RETURN**，不要提前生成新稿。实际删除是对这两份**已拒绝当前用途的短篇文件**的 Owner 明确授权，不等同删除项目已通过的知识正文。

## PHASE B｜只以原P2完整章节为底稿重跑

1. 精确读取固定原稿**全文**以及唯一 Skill 主文件与指定参考；不得以旧短篇为写作输入。写稿时逐节改写和检查；完成初稿后再读取 `revision` 规则。
2. 只**新增** `modern-commercial-payment-guide/docs/P2_HUMAN_WRITING_STRUCTURED_CANDIDATE.md`，输出完整第①板块，5个二级、9个三级和文末官方来源；保持原标题和编号字面顺序。
3. 按每个节点出具**逐节保留矩阵**（对应原稿核心知识/方法、改稿说明、新稿所在位置），不能只列标题；输出**关键事实矩阵**（PayPal协议和费用、Shopify、Stripe、Paddle、自然人/企业两个案例、银行实际到账边界）并抽查所有数值。
4. 在 `EXECUTION_EVIDENCE.md` **继续追加** Skill 版本/参考、回滚证明、新稿提交 SHA/Blob、原始全文SHA、章节文本与级别逐字比较结果、每节新的读者问题/结论、关键金融事实检查、最终缺口与回滚位置，正式自评仅 `PASS_CANDIDATE`。
5. 严格只读回读确认新稿、证据、主原稿SHA、PR Open/Draft/未合并；提交时给出三个指针：旧基线完整原稿、新完整候选、Evidence，以及最终 commit SHA。

## ACCEPTANCE CRITERIA｜有一项不达标即不能 PASS_CANDIDATE

- **结构形式：** 标题顺序/文本/层级和上述清单**完全相同**（可额外保留原来的`####`细分标题，但不得新建替代层级）；5/5二级、9/9三级皆有非空、有深度的实质内容且逐节能回答原本问题。凡压扁成单篇故事、缺一编号小节或把全章压缩成单案例，**直接 `RETURN_STRUCTURE_NOT_PRESERVED`**。
- **覆盖实质：** 每节原有核心判断与应用不丢，原两类决策案例、五类业务类型、支付角色模型、同口径现金计算、银行提现金额边界、S01–S15官方来源映射仍可核对；整体深度不得以“自然表达”为由降成入门短答。
- **体验改进：** 每节有独特信息和可执行判断，开头不被概念/免责声明淹没，段落顺着问题展开，适度穿插真实金额与对照，但不创造虚假细节；变成自媒体文章并非宣传文。
- **回滚可审计：** 两份不被 Owner 接受的旧短篇已从**PR 当前文件树**撤掉，旧 Git commit 和 Evidence 事实都可读，原已审核P2正文完全不变；当前证据只追加，不伪称 PR 指针回到了17ea原commit。
- **Reviewer/Owner 分权：** Executor 完成本 Gate 立即停止 Reviewer；只有 Reviewer 能判整章结构/事实/读感 PASS，Owner 最终决定是否接受表达成稿。不得合并/进P3。

## ROLLBACK_STATUS_OR_PLAN

**TARGET：** 仅项目文稿 PR 分支。**RECOVERY_ARTIFACTS：** 原审核提交 `17ea75...` + 它的原文 Blob `f8bb110...`；两份旧短文分别在 `d0f000...` / `c334105...` 可恢复；新稿可通过新文件删除恢复到原已审 P2。**METHOD：** 非破坏性顺序删除两旧短篇、新增独立结构化全章候选，所有提交可查，不重置共用提交、不删除历史 Evidence。**STOP：** 任何路径/SHA漂移、缺少恢复能力、风险越界、章节丢失，立即停止并报告 Reviewer。

## OWNER_ONLY_ACTIONS

Owner 已在当前对话明确要求“先回滚原先版本，再按第一个Skill并保留现有完整章节框架重跑”。这**授权当前 Gate 里精确的两个短篇文件撤销和一份新结构化候选创作**，不授权强推重写历史、删已审核正文或修改其他文件。若实际执行方式无法安全删除两个短篇，Executor 必须 RETURN，不自行开权限或改变角色。

## REVIEWER_TO_EXECUTOR_RELAY

> 你是独立 Executor。当前目标不是写一篇新的 1500字短文，而是完成《现代商业支付系统》PR #132 第①板块**保留原样标题的完整长文改稿**。请仅从本 Gate 启动，阶段 A 先核对当前 PR head `c3341053...`、已审原 P2 Blob `f8bb110...`、两份短篇 Blob 与历史后精确撤销两个短篇文件，并追加回滚事实；**只有回滚后 readback PASS，阶段 B 才继续**。然后以 `docs/P2_REWRITE_CANDIDATE.md` 全文为唯一写作底稿，只用 `KKKKhazix/human-writing` 主 Skill + 指定三份 references，对其**5个二级、9个三级所有小节分别优化表达**；保留本 Gate 列出的每个标题、原有知识深度、真实案例、表格与金融边界。新建 `docs/P2_HUMAN_WRITING_STRUCTURED_CANDIDATE.md`，追加 Evidence，回读并 STOP_AT_REVIEWER。不得使用旧短篇、copy-editing、其他技能、覆盖原已审正文、合并或推进P3。任何一个小节缺失直接 RETURN_STRUCTURE_NOT_PRESERVED。

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
回滚：两份短篇是否从当前树撤销；各删除提交、旧Blob及路径读回是否符合要求。
改动：完整保结构候选文稿链接、未变的原稿 Blob 与证据追加。
验证：5/5二级 + 9/9三级原文标题字面/层级/顺序对比、每节覆盖、关键金融事实和两类完整案例、Skill严格应用、独立回读。
问题：NONE 或精准阻塞及原因。
恢复：旧短文 Git 历史、原P2已审基线和新候选可独立撤回路径。
请 Reviewer 检查：结构逐级不丢、每节读感和知识质量均得到改善、未弱化商家决策、财务/合同准确。
Owner 转交：PR 链接、新稿、最终 Commit SHA。
```
