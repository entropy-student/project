# 项目决策记录｜现代商业支付系统

> 该文件记录当前有效决策及历史恢复指针；历史项目活动保留在Git已有提交与PR审计中，不在main重复堆叠全文。

## 2026-10-16｜Owner最终通过第一部分并清理写作流程

- **来源：OWNER_REPORTED（本会话）**。Owner明确要求：「我没问题了，正式通过，无效或历史文档删除即可，三个skill也不需要了，写文章的时候你叫我，把压缩包和提示词发我就行。开始按照项目管理规范继续推进。」
- **最终正文：** [docs/P2_CHAPTER1_OWNER_ADOPTED_REWRITE_20261016.md](docs/P2_CHAPTER1_OWNER_ADOPTED_REWRITE_20261016.md)，接受为第一部分正式内容基线。Git Blob `a56bca37079972cede6d7201dea3e9fbcb19b39f`（审批时）。此为Owner编辑接受，不能虚构独立审稿员已经对修订稿执行PASS或完成真人试读。
- **冻结结构：** V6完整7/29/42问题框架不变，结构基线在[docs/FROZEN_FRAMEWORK_V6_20261016.md](docs/FROZEN_FRAMEWORK_V6_20261016.md)；第一部分内容的叙事标题可不同于知识框架，知识覆盖映射与正文审核分开。
- **写作生产决策：** 取消默认的三个旧写作润色Skill流水线：`human-writing`、`copy-editing`、`humanizer`。此前`plain-language`仅备选只读参考，亦不再作为必经步骤。后续文章由Owner选择的**外部写作Agent独立编写**；每进入具体文章写作节点，Reviewer先告知Owner并提供**真实全文离线资源ZIP + 可直接复制的一份提示词**，无需Owner授予Github仓库权限，不默认把新稿提交Github；收到候选后审核再决定如何归档。
- **事实审核保留：** 取消写作Skill不取消逐项来源核验、财务演算检查、适用地区/经营主体/品类的限定、反向风险/真实到账UNKNOWN与独立Review。
- **历史清理：** Owner允许删除过时/失效的主线文档；保留主线唯一Handoff、有效V6完整框架、已通过的P1结构审计记录、已正式通过的P2正文、新阶段Gate/Index与必要审计记录。曾冻结的旧V6全文仅作为历史Git版本可还原，不在main继续制造双正文。
- **PR #132** 旧流程已被Owner新稿替代，应仅**关闭而不合并**，历史执行Evidence保留在Git分支/固定提交记录中，不做history rewrite。

## 历史文档恢复锚点

- **清理前main快照Commit：** `f6d3aa43785e1c0671bef4fce2807aa739f0689e`。旧稿、无效Gate和诊断的完整内容均可用GitHub固定Commit及路径恢复：`https://github.com/entropy-student/project/blob/f6d3aa43785e1c0671bef4fce2807aa739f0689e/modern-commercial-payment-guide/docs/<旧文件名>`。
- **旧V6第一部分冻结正文Blob：** `777c5ab45e4f2d748c45a1e524bf172fca467967`，原路径 `docs/P2_V6_OWNER_FROZEN_REFERENCE_20261016.md`。
- **V6问题框架Blob：** `8c7e1d20c4c423cb07a26fca1868b3f3821c3c62`，原文仍保留在main。
- **历史PR #132 HEAD（清理前）：** `b3da525ae6187acea7e2ec8336474f337b0dc999`；原执行Evidence与旧候选可从该提交/PR评论检索。
- **恢复方式：** 如须恢复某个已删文档，从上述固定Commit路径只读核验全文，再通过新的受限Gate恢复目标文件；不reset、不force、不无授权覆盖现行Owner正文。


## 2026-10-16｜Owner授权按知识深度与广度持续增补

- **Owner最新指令（OWNER_REPORTED）：** “我没问题，如果深度和广度不够你也可以继续补充拓展。包括刚才冻结的第一部分。提示词我已经下发。”
- **约束解释：** 本授权针对**知识内容的深度与广度**，包含已Owner正式通过的①《收款方案选择》；不把“正式通过”误解为永远不可补充。**通过状态保留，原已接受全文保持回滚基线**；任何实质补充采用按缺口定向新增/修订候选→事实及覆盖核验→再纳入正式全文的受限修订流程，不因一次补充推翻整章、反复润色或调用旧Skill。
- **正式V6 7/29/42框架依旧冻结**；允许在已冻结问题之下增添真实必要的例子、解释、比较、图表、风险与来源，不预先限定篇幅或知识颗粒度，也不凭空创造新的正式一级/二级/三级问题。
- **质量优先于凑篇幅：** 不满足“让商家做出更准确的判断 / 理解为何如此 / 知道下一步验证什么”的补充不加入；历史或未确认政策必须标注适用条件，不能将推演、报价、到账和主体准入说成已证实。
- **②章交接新状态：** Owner明确**已向外部写作Agent下发提示词**；根据Owner报告，本轮写作交接已完成，外部Agent是否实际开始/结束执行未知，状态 `OWNER_RELAY_SENT / EXTERNAL_MD_RESULT_PENDING`。不重新发送现有ZIP和提示词，也不在其执行期间擅自改写已发的版本；待收到候选后优先审核其深度与广度，不足则提出可定位的补充，而不是再次重做整个流程。
- **①候选扩充审视（初步冷读，不等于新增事实）：** ①已包含$29订单、两类完整案例、四类快速场景、收费敏感性和决策画布；如后续审核证实确有读者决策缺口，优先考虑：不同**客单价/交易频次**导致固定笔费与提现成本选择变化；**订阅/软件/一次性数字资料**在合同责任、付款与风险结构的对比；**国内自营 vs 跨境平台 vs 海外自营**的可比较决策路径；以及当**全部候选UNKNOWN/NO**时该如何继续核验或调整经营方案。以上仅为可验证的增补候选，非断言正文现有不合格。


## 2026-10-16 - Chapter 1 expansion merged by Owner direction

The Owner instructed direct merge of the complete expansion into the existing approved Chapter 1 source file. Main source `docs/P2_CHAPTER1_OWNER_ADOPTED_REWRITE_20261016.md` now has Git blob `2411eea0f8cbdab0d30ecfa4ac7ee1d93f608cf8` (41,922 characters). Earlier approved blob: `a56bca37079972cede6d7201dea3e9fbcb19b39f` (34,340 characters). All earlier content retained. Redundant expansion candidate removed from main after identical-content read-back and remains accessible in Git history. The chapter 2 external writing task remains unchanged. Financial-review status is not reclassified by this merge.


## 2026-10-16 | Restore two Owner-uploaded original manuscripts

Owner expressly chose the readability of the two independently written Markdown files over subsequent assistant edits. The published editorial source of truth is now the verbatim original text, not an amended article.

- Chapter 1: originally uploaded `现代商业支付系统_第一部分_独立重写稿.md`, SHA256 `4214427fc05cfdf16f1a95fc8df435bb5fcd9ea6d85b553fa39d9b569153aece`. Restore original bytes in `docs/P2_CHAPTER1_OWNER_ADOPTED_REWRITE_20261016.md`. Expected Git blob `260e7ecad19ee198e4a9fb12c9e37e6e482cc227`.
- Chapter 2: uploaded `现代商业支付系统_第二部分_独立重写稿(1).md`, SHA256 `9cecc986bf9ca7bc0c9e4c873b6140aeda1234cd94b2c9ddf909ff2dbaf8d651`. Canonical file is now `docs/P4_CHAPTER2_OWNER_UPLOADED_ORIGINAL_20261016.md`, Git blob `0c8c7fc9390fbe3751c0208f0c2b6eb3863d2a37`.
- No original article paragraph or citation has been rewritten or removed in this restoration. Earlier assistant versions and their reviewer notes are historical only, recoverable via previous Git commits and archived library documents, not the current editorial baseline.
- The original Chapter 2 had previously received factual and technical review objections. Owner restoration is an editorial fidelity choice and does not certify those claims as technically safe or verified. Keep factual review concerns separate from the original article text.
- The V6 question framework is unchanged. Future editing is not authorized merely because a prior reviewer suggested it; changes to these two articles should be explicitly requested by Owner.


## 2026-10-16｜Owner冻结两篇原稿与仅候选增补

- **Owner指令（OWNER_REPORTED）**：“其余无效文档请删除，两篇文档先冻结不许修改。完成之后开始review两篇文档，只许纠正明显的错误，扩充知识内容深度和广度，并将两部分的修改建议写成提示词发我，我转给另一个agent进行修改；提示词里要求agent确认修改建议是否有误，单独记录执行文档，同时交两篇修改后的文档，三篇打包ZIP”。
- **有效正文永久基线（除非Owner另行解冻）**：① `docs/P2_CHAPTER1_OWNER_ADOPTED_REWRITE_20261016.md` Blob `260e7ecad19ee198e4a9fb12c9e37e6e482cc227`；② `docs/P4_CHAPTER2_OWNER_UPLOADED_ORIGINAL_20261016.md` Blob `0c8c7fc9390fbe3751c0208f0c2b6eb3863d2a37`。本轮任何人不得对这两个文件内容执行写入；外部Agent只能另存候选，且不能提交GitHub。两篇内容冻结不等于事实正确的审计PASS。
- **清理结果**：从main现行docs移除历史P1覆盖审查Blob `619d443c5dc3cc3e37f7ab274134474c2235f749`、旧P3知识归属计划Blob `62783db8fee2f18e84dd264db974b2e55faf8d95`；历史Git可重建。文件库中的旧修订/纠错/Reviewer/提示词五文件先独立制作SHA校验 ZIP 再移至回收区，留存完整恢复备份 `/项目历史归档/现代商业支付系统_历史修订文档恢复备份_20261016.zip`，SHA256 `93fee77cf398ef32ea606075cab83140960e13bd805e020508b2328b80099b90`。
- **审稿方式**：只记录来源充分的明显错误与真正影响商家判断的知识深广度缺口；不重写原稿以牺牲可读性。审核提示词 `现代商业支付系统_前两部分_外部Agent独立核验修订提示词.md` 本轮独立生成，SHA256 `9a91f1886d3c07137f79e592303733863494c5cdaaa95d4a6a54549d6df32f77`，由Owner交外部Agent。Agent必须逐条独立核实建议，可驳回，输出两个完整修订Markdown与一份独立执行记录，ZIP三文件，不得直接覆盖冻结正文或自动通过。


## 2026-10-17｜Owner正式解冻并要求替换①②

- **授权来源（OWNER_REPORTED）：** 本轮Owner明确指示“这些小问题请你直接修改然后替换现有的第一部分第二部分吧”。这仅解除此前①②正文的写入冻结，授权以上一轮外部Agent第二轮候选稿为底本，定向修复Reviewer列出的细节，正式替换GitHub和Library的两个唯一正文；不扩大为其他章节、支付/退款、HTML或项目部署授权。
- **上一正式原稿恢复点：** ①原始Blob `260e7ecad19ee198e4a9fb12c9e37e6e482cc227`；②原始Blob `0c8c7fc9390fbe3751c0208f0c2b6eb3863d2a37`，仍可从Git提交历史恢复。
- **待写入的两篇精修全文：** ① SHA256 `c476f1eb15adc58c98a047334daa13542521758de8bcf56b560524650fa9a6db`，Git Blob `bf6b310f5bba3c6fd9aed5a70d74e441bb681505`；② SHA256 `c9c14717104e9d5666b8007c82ffca4448c2598f2d59eed1c9ab3ce1505993f9`，Git Blob `51dab57d0ed5d5458b14422040297ebfbcebe676`。
- **编辑范围：** PayPal中国大陆小额付款6%+$0.05并用$4算例核实；Stripe Testing改[S11]；插件/Elements的SAQ需条件核定；自研API不保证最高转化；PCI 1092/1588/1604名称链接一致；案例不再误用L3/L4；15分钟对账不保证15分钟履约；补齐简短接入选型和上线验收案例。正式V6 7/29/42问题文本保持原文不变；外部Agent旧执行记录错误以本轮独立修订证据取代，不将其旧逐字对照表视为有效验证。
- **状态约束：** 仅Owner授权的①②正式文稿变更为当前有效；本次修改属于自执行+验证，不冒充另一轮外部独立Reviewer再次PASS。余下③–⑦与HTML依然未授权执行。


## 2026-10-17 | 正式封板①②并启动③外部独立写作

- **Owner决定**：“我没什么问题了，第一第二部分正式封板吧。无效文档删除就好~记得同步相关文档，完事之后我们进行下一部分。依旧依据现在的流程进行。”这是对①②现行正式稿的**最终内容封板指令**，不应再触发纠错或增补。任何下一次正文变更都需Owner另行明确授权。
- **封板版本精确指纹**：① `docs/P2_CHAPTER1_OWNER_ADOPTED_REWRITE_20261016.md` Git blob `bf6b310f5bba3c6fd9aed5a70d74e441bb681505`，SHA256 `c476f1eb15adc58c98a047334daa13542521758de8bcf56b560524650fa9a6db`；② `docs/P4_CHAPTER2_OWNER_UPLOADED_ORIGINAL_20261016.md` Git blob `51dab57d0ed5d5458b14422040297ebfbcebe676`，SHA256 `c9c14717104e9d5666b8007c82ffca4448c2598f2d59eed1c9ab3ce1505993f9`。两个Git路径沿用历史命名，但最新内容就是封板版。V6全书7/29/42框架继续冻结blob `8c7e1d20c4c423cb07a26fca1868b3f3821c3c62`。
- **清理判断**：main/docs只有正式①②、V6快照、现行索引；根目录只有Handoff/Decision/Evidence及docs。Library原来只含两份正式全文，没有无效候选可删。Library历史ZIP是经过核验的恢复资产，按治理保留，**不为表面清爽而删除**。
- **下一Gate**：③《顾客付款》，核心问题“如何让顾客更方便、更顺利地完成付款？”，正式4H2/5H3均从冻结V6逐字摘录。按旧流程由外部独立Agent先输出**第三部分完整UTF-8 Markdown与单独事实/执行核验记录**（两份MD、一个ZIP），交独立Reviewer审阅，Owner通过后才正式采纳/封板。不得修改已封板①②/全书框架，不进入④–⑦及HTML。
- **单一写作资料包**：`/现代商业支付系统/现代商业支付系统_第三部分_独立写作资料包_20261017.zip`，SHA256 `8d721011f1d0a4c8b5faa8ba252d63308213b9bda8598d326d831372882c8ede`；内含独立提示词、③冻结标题、①②封板只读全稿、PayPal/Stripe等官方来源索引和校验说明。ZIP通过CRC并核实两篇参考正文与封板SHA256一致。写作作者无GitHub写入权限需求。
- **实际执行状态**：封板、资料包制作及归档已完成；本轮**尚未委托外部写作Agent、尚未收到③候选稿**，第三章状态保持 `WRITER_PACKET_READY / OWNER_RELAY_PENDING`。其他历史事实仍留在append-only Evidence。


## 2026-10-17｜③④联合写作替代③单独写作Gate

- **OWNER_REPORTED / AUTHORIZATION：** Owner接前一轮“第三部分独立写作ZIP待转发”明确提出“把第四部分的也写了吧，一块搞。同时记录一下交接文档等信息，避免后续新的reviewer接受不到完整的信息。”结合当前已经确立的外部Agent独立写作→独立Reviewer→Owner决定采纳流程，正式将③《顾客付款》和④《支付处理》**合并为一个写作委托**；不要求本轮Assistant取代外部Agent直接将④写入正式GitHub。后续各章是否正式采纳仍留给Owner。
- **已封板不变：** ①Git Blob `bf6b310f5bba3c6fd9aed5a70d74e441bb681505`、SHA256 `c476f1eb15adc58c98a047334daa13542521758de8bcf56b560524650fa9a6db`；②Git Blob `51dab57d0ed5d5458b14422040297ebfbcebe676`、SHA256 `c9c14717104e9d5666b8007c82ffca4448c2598f2d59eed1c9ab3ce1505993f9`；V6结构Blob `8c7e1d20c4c423cb07a26fca1868b3f3821c3c62`。所有已封板正文与框架在本轮只读。
- **输入升级：** 文件库活动任务唯一ZIP `/现代商业支付系统/现代商业支付系统_第三四部分_联合独立写作资料包_20261017.zip`，Library `libfile_5b2fbf5640d881919cb2e02a6cb15f90`；SHA256 `88ae6de6b80417ef95b7ab33bc73040ce064c1bf1703d9a99f37eaeef7800158`，74,112字节。内含联合提示词、③④4H2/5H3原文、两篇①②封板全文只读、官方资料、面向新Reviewer的完整交接快照和文件SHA256清单。已校验解压/CRC和封板稿SHA。
- **旧任务归档而非并存：** `/现代商业支付系统/现代商业支付系统_第三部分_独立写作资料包_20261017.zip` 移至 `/项目历史归档/现代商业支付系统_第三部分_独立写作资料包_20261017.zip`，原ZIP SHA256 `8d721011f1d0a4c8b5faa8ba252d63308213b9bda8598d326d831372882c8ede`。旧的“③单章、交付两份MD”被新联合任务“③+④、交付三份MD”替代，不构成已完成新章，也不丢失旧包。
- **唯一交付：** 外部作者须交完整③候选Markdown+完整④候选Markdown+③④共享独立核验/执行记录Markdown，ZIP中恰好三文件；作者自检非Reviewer PASS。文章均不得自动入main，必须Owner确认。
- **Reviewer完整续接：** 已把当前唯一Gate、历史决策、①②正文Blob/SHA、③④严格V6题文数量及边界、Writer成果文件名、付款状态/验签/幂等审查要点、GitHub/Library位置、未知项、Owner-only动作及下一审查步骤写入 `REVIEWER_HANDOFF.md` §五–七并同步 `docs/CURRENT_DOCUMENT_INDEX.md`。联合ZIP自身亦含离线新Reviewer快照以避免新会话无上下文。
- **不作推断：** 当前第三、四部分完整候选稿`NOT_RECEIVED`，外部Agent是否已开始`UNKNOWN`；第五至七部分及HTML未启动，也无任何支付服务商或资金交易动作授权。


## 2026-10-17｜③④最小修正正式入库并启动⑤⑥

- **OWNER授权原文**：“如有问题请你自行修正并最小化解决。完成后落到GitHub仓库里并记录，然后启动第五和第六部分。”随附第二轮外部Agent返修ZIP；解释为允许Reviewer审核、完成最小事实修正、将③④正式正文纳入GitHub main，并按前序联合写作流程启动⑤⑥联合外部写作输入；**未要求③④本轮另外正式封板**。
- **正式正文新版本**：③ `docs/CHAPTER3_OWNER_ADOPTED_20261017.md`，Git Blob `7dc4b456c368ae3974ccaf86b4596c3f125033ef`、SHA256 `52092ab1b9bd9b29013ebff9e67d6ef9885e2cf20dd2d09402f797a597805040`，提交 `ee56c0c1a38b3488b77f5639bb3186cd698fb28b`；④ `docs/CHAPTER4_OWNER_ADOPTED_20261017.md`，Git Blob `3ff19d7188b7d61d47d83c0daed67681e1ba88f0`、SHA256 `5e567a4de0818165ce3c2093c1b8ea0aa3c4dc92f573f2e5f1d39ad5701c7759`，提交 `a8e42ed68a4b3843d3ff8da9c9033299125dfcf6`。与Owner原封板①②不同，③④状态为`OWNER ADOPTED / NOT YET FORMALLY SEALED`。
- **原始与整改资产**：本轮新上传的外部返修候选ZIP `现代商业支付系统_第三四部分_联合独立写作成果(1).zip` SHA256 `8cba1846047269cb480d23bfec8846b80f7f7b3ab4bbaec4102617c78ca6d1e4`，归档Library `/项目历史归档/现代商业支付系统_第三四部分_外部返修候选第二轮_20261017.zip`。Reviewer独立最小修正执行记录位于 `docs/CH3_CH4_OWNER_ADOPTION_EXECUTION_20261017.md`，Git Blob `8a920ee7aae180d622516fc9d5521b2331d4834f`；三文件正式版ZIP SHA256 `c09b8bc9452c87f3f27c22b9db7b04b95eaee8049d6f6eb721d73153e97ff039`，存历史以避免复制出多份当前正文。
- **不可改动边界**：①Git Blob `bf6b310f5bba3c6fd9aed5a70d74e441bb681505`、②`51dab57d0ed5d5458b14422040297ebfbcebe676`、正式V6 7/29/42问题 `8c7e1d20c4c423cb07a26fca1868b3f3821c3c62`，全部本轮没有更动。正式③④各4H2/5H3问题原文及顺序未改。
- **本轮纠错范围**：修正 Apple Pay 非Safari的条件与中国大陆跨浏览器例外、FTC 2024 Click-to-Cancel修订被2025-07-08撤销、过时的独立SOFORT支付方式、3DS挑战/责任边界、支付完成与清算余额区别、Stripe幂等键重试同键与未开始执行不缓存、支付对象失败态不能单凭单笔就重新扣款、PayPal capture多笔与部分金额、PCI SAQ A不一律逐年提交、Webhook延迟及有关无依据固定数字；最小修正，不重新组织两篇叙事。执行记录留有官方参考与剩余条件。
- **第五、第六部分任务**：新的联合外部写作资料包 `/现代商业支付系统/现代商业支付系统_第五六部分_联合独立写作资料包_20261017.zip`，SHA256 `a125b87a69935034d073cdcb712558bd1713eb277c63f866d4c82b9e9a335201`，共9份Markdown（提示词、⑤⑥V6、①–④正式只读全文、官方来源、Reviewer快照和README）。⑤4H2/5H3、⑥4H2/6H3，要求外部Writer交两个完整新章+一份核验/执行记录组成的三MD ZIP，先Reviewer后Owner决定是否采纳。
- **阶段边界**：第五第六部分正式正文`NOT_RECEIVED`、已准备写作资料但尚不声称Writer已运行；第⑦部分与最终HTML仍PENDING。本轮没有实际经营支付、提款、退款、商户设置或服务器部署。
