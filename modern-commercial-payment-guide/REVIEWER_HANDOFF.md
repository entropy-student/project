# 现代商业支付系统｜项目交接

PROJECT_GOAL：面向中国大陆个人开发者、独立站经营者和中小商家的实操型支付指南；最终产物为 HTML 知识指南。

**正式框架：** [V6（7个一级、29个二级、42个三级问题）](docs/FROZEN_FRAMEWORK_V6_20261016.md)，不得擅自修改。

## CURRENT_ACCEPTED_STATE

- ① 收款方案选择：[正式正文](docs/CHAPTER1_FINAL_SEALED.md)，已封板。
- ② 收款开通与接入：[正式正文](docs/CHAPTER2_FINAL_SEALED.md)，已封板。
- ③ 顾客付款：[正式正文](docs/CHAPTER3_FINAL_SEALED.md)，已封板。
- ④ 支付处理：[正式正文](docs/CHAPTER4_FINAL_SEALED.md)，2026-10-17 按 Owner 指示经 Reviewer R2 修订及文稿级核验后封板；[核验记录](docs/CHAPTER4_R2_REVIEW_EVIDENCE_20261017.md)。
- ⑤ 资金结算与到账：无正式正文；已授权启动[独立完整写作 Gate](docs/CHAPTER5_INDEPENDENT_WRITER_GATE_20261017.md)，待 Writer 成果返回 Reviewer。
- ⑥ 售后与资金风险：无正式稿，未启动。
- ⑦ 财务与合规经营：未启动。
- HTML：未启动。

## CURRENT_GATE / NEXT_STEP

第五部分：`MCPG-CH5-INDEPENDENT-COMPLETE-DRAFT-20261017`。Writer 先核对本交接、V6 冻结框架与前四章正式正文，完成第五章完整候选和独立事实核验记录，打包 ZIP 后 **STOP_AT_REVIEWER**。第五章未经 Reviewer PASS 不得自行封板、修改 main、推进第六章或制作 HTML。

## CRITICAL_CONSTRAINTS / SYSTEM_MAP

项目为金融知识写作，生产运行时、数据库、端口、真实支付、退款与银行资金操作均 NOT_APPLICABLE。GitHub `main` 是正式内容权威；第四章及此前已封板正文和 V6 框架未经 Owner 新授权不修改。撤销、删除的旧第④至⑥章草稿与历史审核任务不作为当前有效材料。资金费率/准入/地区条件必须用官方当前来源核实，无法核实写 UNKNOWN。

DEFAULT_EXECUTION_CHANNEL：独立 Writer 提交 ZIP、Reviewer 审核后采纳。CURRENT_ROLLBACK_STATUS：已有 Git 版本记录及第四部分 SHA，文本可定位恢复；无真实生产数据变更。UNRESOLVED：第五部分具体服务商及跨境结算事实仍待独立写作核验。OWNER_ACTION_REQUIRED：NONE。
