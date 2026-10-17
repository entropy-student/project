# 现代商业支付系统｜项目交接

PROJECT_GOAL：面向中国大陆个人开发者、独立站经营者和中小商家的实操型支付指南；最终产物为 HTML 知识指南。

**正式框架：** [V6（7个一级、29个二级、42个三级问题）](docs/FROZEN_FRAMEWORK_V6_20261016.md)，不得擅自修改。

## CURRENT_ACCEPTED_STATE

- ① 收款方案选择：[正式正文](docs/CHAPTER1_FINAL_SEALED.md)，已封板。
- ② 收款开通与接入：[正式正文](docs/CHAPTER2_FINAL_SEALED.md)，已封板。
- ③ 顾客付款：[正式正文](docs/CHAPTER3_FINAL_SEALED.md)，已封板。
- ④ 支付处理：[正式正文](docs/CHAPTER4_FINAL_SEALED.md)，2026-10-17 按 Owner 指示经 Reviewer R2 修订及文稿级核验后封板；[核验记录](docs/CHAPTER4_R2_REVIEW_EVIDENCE_20261017.md)。
- ⑤ 资金结算与到账：[正式正文](docs/CHAPTER5_FINAL_SEALED.md)，2026-10-17 按 Owner 指示经 Reviewer R2 最小定向修订、独立文稿级复核并封板；[核验记录](docs/CHAPTER5_R2_REVIEW_EVIDENCE_20261017.md)。
- ⑥ 售后与资金风险：[正式正文](docs/CHAPTER6_FINAL_SEALED.md)，2026-10-17 按 Owner 指示经 Reviewer R2 定向修订并完成文稿级封板；[核验记录](docs/CHAPTER6_R2_REVIEW_EVIDENCE_20261017.md)。
- ⑦ 财务与合规经营：[正式正文](docs/CHAPTER7_FINAL_SEALED.md)，2026-10-17 经 Owner 授权由 Reviewer 完成 R2 定向修订及文稿级封板；[审核记录](docs/CHAPTER7_R2_REVIEW_EVIDENCE_20261017.md)。
- HTML：未启动。

## CURRENT_GATE / NEXT_STEP

V6 全七部分已完成文稿级封板（非金融生产验收）。**当前没有获批 HTML 制作 Gate**；最终 HTML 待 Owner 单独授权。已封板正文的唯一权威仍为 GitHub main 中 `docs/CHAPTER1_FINAL_SEALED.md` 至 `docs/CHAPTER7_FINAL_SEALED.md`。七章正式正文合集 ZIP 位于 [七章独立 ZIP（GitHub Archive）](https://github.com/entropy-student/project/archive/refs/heads/payment-guide-seven-sealed-chapters-20261017.zip)（仅包含七章，不含旧候选和审核资料）。

## CRITICAL_CONSTRAINTS / SYSTEM_MAP

项目为金融知识写作，生产运行时、数据库、端口、真实支付、退款与银行资金操作均 NOT_APPLICABLE。GitHub `main` 是正式内容权威；第一至第七章的封板正文与 V6 框架未经 Owner 新授权不修改。撤销、删除的旧第④至⑥章草稿与历史审核任务不作为当前有效材料。资金费率/准入/地区条件必须用官方当前来源核实，无法核实写 UNKNOWN。

DEFAULT_EXECUTION_CHANNEL：章节已完成；下一 Gate 须由 Owner 授权。CURRENT_ROLLBACK_STATUS：已有 Git 版本历史，封板正文按文件 SHA 与 Commit 定位恢复；无真实生产数据变更。UNRESOLVED：跨境税务、服务商准入及费用始终受主体、法域和合同影响；正式文稿以注明适用条件和 UNKNOWN 为准；HTML 尚未启动。OWNER_ACTION_REQUIRED：NONE。
