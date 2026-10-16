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
