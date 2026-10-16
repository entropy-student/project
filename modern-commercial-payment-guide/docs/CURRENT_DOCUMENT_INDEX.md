# 《现代商业支付系统》当前有效文档索引（2026-10-16）

> **本文件只做目录与冲突消除，不另建第二份项目状态权威。** 唯一权威仍是GitHub main [REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)（最高准则、冻结7/29/42问题及CURRENT_GATE）；治理权威仍是 [spike.skill / vps-project-governance/VNEXT.md](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md)。这里的文件状态随Handoff更新，如有差异，以Handoff为准。
>
> Owner决策：保留并冻结**原V6第一部分全文**为正式对照；Reviewer不得撰写候选。此前Reviewer越权撰写的R1新文已从当前PR树删除；独立Executor有单独的最新Gate，尚未执行。**没有批准以任何新稿替换原V6，也没有批准合并PR或开始其他章节。**

## A. 有效、必须保留或使用的main文档

| 文档 | 性质 | 对应已核验Git Blob |
|---|---|---|
| [REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md) | **唯一有效项目权威**，历史决策、V6全标题、当前阶段、下一Gate和回滚 | 以main实时SHA为准 |
| [FROZEN_FRAMEWORK_V6_20261016.md](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/docs/FROZEN_FRAMEWORK_V6_20261016.md) | Owner已正式冻结的**7一级29二级42三级全文快照**，参考权威仍是Handoff第2–4节 | `8c7e1d20c4c423cb07a26fca1868b3f3821c3c62` |
| [P2_V6_OWNER_FROZEN_REFERENCE_20261016.md](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/docs/P2_V6_OWNER_FROZEN_REFERENCE_20261016.md) | Owner已冻结的**第一部分V6完整保留稿**，不可被新候选改写或覆盖，历史编辑Reviewer通过内容/财务审查，真人可读性仍未验证 | `777c5ab45e4f2d748c45a1e524bf172fca467967` |
| [P1_STRUCTURE_COVERAGE_ACCEPTED_ARCHIVE.md](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/docs/P1_STRUCTURE_COVERAGE_ACCEPTED_ARCHIVE.md) | **P1结构覆盖审查已通过的完整记录**，从旧工作文档提取，属历史证据；问题用语以V6为准 | `619d443c5dc3cc3e37f7ab274134474c2235f749` |
| [P2_V6_BEGINNER_COMPREHENSION_DIAGNOSTIC_20261016.md](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/docs/P2_V6_BEGINNER_COMPREHENSION_DIAGNOSTIC_20261016.md) | **当前教学障碍诊断**：术语先于定义、表格先于示范、跨主体比较过密、方法出现晚；下一稿的事实性问题输入 | `971212deb1c2589e73642d5cdcc9d593760e8164` |
| [P2_V6_REVIEWER_ASSESSMENT_20261016.md](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/docs/P2_V6_REVIEWER_ASSESSMENT_20261016.md) | 对**旧V6稿**的知识/事实/结构独立审核结果，不能据此宣布新稿/真人测试通过 | `489eabba5a210235f2ef57d91f3aaaa6b19f7b88` |
| [P2_V6_PEDAGOGICAL_EXECUTOR_ONLY_GATE.md](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/docs/P2_V6_PEDAGOGICAL_EXECUTOR_ONLY_GATE.md) | **唯一当前有效的待执行 Gate**：交独立Codex重构第①章，不允许Reviewer执笔，不复用撤回的R1 | `3256b2598ae255b31fdaf483e103b3d49a6ea1f8` |

## B. 历史档案：只供追溯，不可当执行指令

| 文档 | 限制 |
|---|---|
| [FRAMEWORK_V4_V5_ARCHIVE_BEFORE_V6_20261016.md](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/docs/FRAMEWORK_V4_V5_ARCHIVE_BEFORE_V6_20261016.md) | 旧V4/V5冻结问句已被Owner正式V6替代 |
| [FULL_FRAMEWORK_READER_FRIENDLY_TITLE_PROPOSAL_20261016.md](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/docs/FULL_FRAMEWORK_READER_FRIENDLY_TITLE_PROPOSAL_20261016.md) | V6修订前后对照，**已被Owner正式采纳**；本文件原候选字样仅保留其当时状态 |
| [P2_V6_PEDAGOGICAL_R1_REWRITE_GATE.md](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/docs/P2_V6_PEDAGOGICAL_R1_REWRITE_GATE.md) | **VOID / SUPERSEDED**，错误允许Reviewer直接写稿，只留事故审计，不得执行 |
| 原项目文件库 `现代商业支付系统_实施与内容工作文档.md` | 其中P1结构审核已归档上表main；其**早期P2正文曾被明确废弃**，不能用作新稿底本 |
| PR #132 Git历史旧R1提交 | 仅为不可抹除审计历史，**不在当前PR树**，不可用于下一稿和新候选对照 |

## C. 正在PR中审计，但不得私自合并到main的内容

- PR [#132](https://github.com/entropy-student/project/pull/132) **Open/Draft/未合并**；最后已确认的head `2321737cd65aca50a80c68bca1dc34784e8de9a6`，后续使用前须重新查询。
- `modern-commercial-payment-guide/EXECUTION_EVIDENCE.md` **只在PR工作分支**，当前Blob `f91872fd8b47cded080fdaf48b456ea14145b555`；含append-only纠错与越权撤销记录。**不是main已有文件**，不能声称全部审计证据已合并main。其关键状态摘要已纳入唯一Handoff。
- PR中原 `docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md` Git Blob `777c5ab45e4f2d748c45a1e524bf172fca467967`；main独立冻结稿与它逐字相同，**正文有效基线已在main**，无需复制不明PR其它草稿。
- 原Reviewer自行创建的 `docs/P2_V6_PEDAGOGICAL_R1_CANDIDATE.md` **已从PR当前树删除**，撤销提交 `70fa71556099c260c139717fc4a06f5aeeb58dff`；旧历史提交可能仍可访问，不能声称Git历史物理销毁。
- **尚不存在**有效的独立Executor新稿 `docs/P2_V6_PEDAGOGICAL_EXECUTOR_CANDIDATE.md`；下一份候选完成后先独立Reviewer，后Owner决定是否替代冻结稿。

## D. 当前整体进度

```text
项目最高准则、V6 7/29/42问题框架          PASS｜Owner冻结
P1 七章结构覆盖审查                        PASS｜仅结构
P2 第①章完整V6内容和事实                  PASS｜Owner冻结作保留版
P2 新手理解障碍调研                        PASS｜诊断已在main
Reviewer越权R1清理、审计纠正               PASS｜当前PR树无R1
独立Executor教学重构Gate                  NEXT｜已发布、尚未执行
独立Reviewer审核新候选                     PENDING
Owner比较并决定是否替代原冻稿              PENDING
其余六章、最终桌面单文件HTML               PENDING
```

## E. 最小接手规则与数据保护

- **Reviewer只有读、审核、发布Gate、写项目管理记录权限；不能自行生成/修改P2正文。** 独立Codex Executor方可按当前Gate写一个完整候选并append-only更新Evidence，停在Reviewer。
- 不能为了“全部在main”而直接合并未审PR；先把**真正当前有效**且Owner已接受的文档放在main，PR审计记录通过固定提交和GitHub引用可追溯。所有后续写入必须按 `Current State → Gate → Preflight → Execute → Evidence → Review → New State`。
- 向下一位Reviewer转达只用项目结构、GitHub路径、文件哈希、公开金融教学假设和权限状态；不要附带真实个人银行卡、账号、护照、身份证、密钥、Cookie、API Token、家庭住址或支付后台截屏。任何敏感信息应留在授权执行环境，不贴到PR/Handoff；**本项目文档索引不包含个人账户标识或凭据**。
- R1内容旧Git提交可追溯，公共仓库是否可见取决于仓库访问控制；删除当前文件不等于清除Git历史或第三方副本。未经额外审计不承诺彻底消除任何历史信息。
