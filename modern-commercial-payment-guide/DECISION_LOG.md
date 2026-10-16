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
