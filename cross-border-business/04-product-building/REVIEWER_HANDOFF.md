# 第四部分《产品搭建》｜唯一现行Reviewer交接

> **UPDATED：2026-10-19**  
> **PROJECT_STATUS：V2_1_9_48_117_FROZEN / CH1_TO_CH7_FINAL_SEALED / CH8_V1_RETURN_R2_WRITER_PENDING**  
> **CURRENT_GATE：CH8-WRITER-V1-REVIEW-RETURN-R2-REPAIR-20261019**  
> **CURRENT_STOP：CH8_V1_REVIEW_RETURN / R2_WRITER_PENDING / NO_SEALED_CH8_BODY / NO_HTML**  
> **OWNER_ACTION_REQUIRED：** 下载本轮**4.8 Writer V1独立Reviewer完整R2定向返修ZIP**，连同Writer提示词交独立Writer；待其交完整R2正文、B01–B10核验及ZIP后交Reviewer复审。当前不封板、不启动4.9。

## 一、先读权威文件（不需要旧对话）

| 文件 | 当前作用与冻题 |
|---|---|
| [V2正式冻结问题树](docs/FROZEN_FRAMEWORK_V2_20261018.md) | 唯一权威1核心/9一级/48二级/117三级，原文/编号/层级/顺序不可擅改 |
| [4.1正式全文](docs/CHAPTER1_FINAL_SEALED.md) ／ [证据](docs/CHAPTER1_SEAL_EVIDENCE_20261018.md) | 4H2/10H3，Owner封板，只读 |
| [4.2正式全文](docs/CHAPTER2_FINAL_SEALED.md) ／ [证据](docs/CHAPTER2_SEAL_EVIDENCE_20261018.md) | 4/10，只读 |
| [4.3正式全文](docs/CHAPTER3_FINAL_SEALED.md) ／ [证据](docs/CHAPTER3_SEAL_EVIDENCE_20261018.md) | 5/11，4.3.4无三级，直接成节 |
| [4.4正式全文](docs/CHAPTER4_FINAL_SEALED.md) ／ [证据](docs/CHAPTER4_SEAL_EVIDENCE_20261019.md) | 6/13，只读 |
| [4.5正式全文](docs/CHAPTER5_FINAL_SEALED.md) ／ [证据](docs/CHAPTER5_SEAL_EVIDENCE_20261019.md) | 5/12，只读 |
| [4.6正式全文](docs/CHAPTER6_FINAL_SEALED.md) ／ [证据](docs/CHAPTER6_SEAL_EVIDENCE_20261019.md) | 6/16，只读 |
| **[4.7唯一正式全文](docs/CHAPTER7_FINAL_SEALED.md)** ／ **[审计](docs/CHAPTER7_SEAL_EVIDENCE_20261019.md)** | **5/14，2026-10-19 Owner特批Reviewer直修Writer R2完成封板** |
| **[4.8当前独立Writer首稿Gate](docs/CHAPTER8_INDEPENDENT_WRITER_GATE_V1_20261019.md)** | **5/14全部原题，Writer全文待交** |
| **[4.8自包含ZIP及SHA登记](docs/CHAPTER8_WRITER_OFFLINE_PACKET_MANIFEST_V1_20261019.md)** | `第四部分_第八章_独立Writer完整离线工作包_V1_20261019.zip`；**9,849 bytes**；SHA256 `2de2d4a9d833c98f88f244012162ffebaa26d4c9ebac709b5e5a49dcace966f9`；8个UTF-8 Markdown，CRC与逐文件SHA PASS，**ZIP仅在Owner对话附件，未上传GitHub** |
| [第四部分README](README.md) ／ [五板块目录](../README.md) | 唯一项目导航 |
| [Writer→Reviewer→Owner长期制度](../02-network-environment/docs/WRITER_REVIEWER_WORKFLOW_V1_20261018.md) | 正文全稿→独立审查→Owner独立决策 |

## 当前任务：4.8章Writer V1独立Reviewer RETURN（2026-10-19）

- **Owner交付**：`第四部分_第八章_独立Writer交付_V1.zip`，26,798 bytes SHA256 `00dc4d62aa8614c047adcabe63b6e201adb58f98a8cd0169c1db56f7c52e8824`，CRC PASS，两份完整UTF-8 Markdown。正文37,974 bytes/436行 SHA256 `66dd9440e72ca8f158c4024af79cd77630cadd73406eec2899e306caf58416a0`；完整核验16,288 bytes/92行 SHA256 `7996cf59979e81b05ec574d83cb1ba4e1d1c164337c4985a0f3cfc7955fd02d7`。
- **独立结论**：`RETURN_CH8_V1_RELEASE_GATE_SECURITY_PAYMENT_AND_RECOVERY_ERRORS`。唯一冻题一级1/1、二级5/5、三级14/14原文同序PASS；知识覆盖充分，不推倒重写。阻断B01沙箱/真实支付与交付证据混用；B02异步支付事实/Committed库存混同；B03测试事件推生产Webhook/业务动作去重不足；B04 3PL受理冒充FULFILLED与No Such Order盲重试；B05文件魔数和对象存储noexec安全错误；B06普通审计日志存完整PII；B07邮箱+订单号冒充资产找回验证；B08 WCAG2.2 AA/AAA 24px与44px、EAA服务微型企业豁免混同；B09生产备份隐私风险、pg_restore归档格式、RPO/RTO与盲目一键回滚；B10 i18n输入格式解析、欧盟持久介质与自检20题误数等。
- **[当前Reviewer完整审稿及R2离线包事实登记](docs/CHAPTER8_WRITER_V1_REVIEW_RETURN_20261019.md)**。Owner本轮对话完整无损R2 ZIP：`第四部分_第八章_Writer_V1_R2完整定向返修包_20261019.zip`，**41,298 bytes，SHA256 `92a382fa5132166e487e0d27784ffcc01ce9e85e455937eea7e672569df5fc18`**，8份UTF-8 Markdown（含原Writer完整正文/原核验原字节、Reviewer全报告、正式5/14原题、R2任务及SHA256清单）。**CRC与原文件字节一致性PASS，ZIP二进制未上传GitHub**。
- 当前**Writer R2尚未交付，第4.8章没有正式封板正文**。4.1–4.7七章继续只读，4.9/HTML未启动。此前4.8首稿Gate/离线工作包仍是结构与背景参考，**当前实际返修入口是上面的R2完整无损包，不要再要求独立Writer重做V1初稿**。

## 二、Owner已确定的版本和完整4.7封板来源

- 第四部分V2正式框架1/9/48/117于2026-10-18冻结。旧框架和未经独立Writer的早期4.1草稿均非当前正式版本。
- 4.1至4.6全部已由Owner批准Reviewer在既有完整独立Writer R2候选上定向修复、正式封板，**不得声称存在Writer R3**，详细历史见各章审计。
- **4.7 Writer V1**：ZIP `第四部分_第七章_独立Writer交付_V1.zip` 28,384 bytes、SHA256 `b1294c5d82f3d7b81183a5a9eb9ffe37dd28523840666ab87aca4242c6f81d3d`。[V1 Reviewer真实RETURN（B01–B10）](docs/CHAPTER7_WRITER_V1_REVIEW_RETURN_20261019.md)。
- **4.7 Writer R2**：ZIP `第四部分_第七章_独立Writer交付_R2.zip` 37,549 bytes、SHA256 `5de2b0eeaa8e176b41240be2f5874781239777c2e360d76e735baaba79c7f326`，原完整正文44,483 bytes SHA256 `4e7767f291f6cd950c3b89250ae3ba7f87fe68498cbc0ece57f0ffd9fc1a837f`，原完整核验35,874 bytes SHA256 `5a9017ef06b400ff0847fd5f817168b4802daf526345889043fe9c86b6f806ce`，CRC PASS。[R2 Reviewer真实RETURN（C01–C07）](docs/CHAPTER7_WRITER_R2_REVIEW_RETURN_20261019.md)。
- **Owner特别授权**：“这部分内容暂时由你来修改完成之后嗯，正式冻结，然后填入我们的项目库当中。记得记录相关文档。完成之后开启下一个1级问题的部分。”因此Reviewer用完整Writer R2直接修C01–C07，**没有Writer R3交付**。原R3返修ZIP准备后未交Writer执行。
- **4.7关键定向更正**：
  1. C01 退款已确认成功与币种/订单/行项/交付单位核对，先按**(provider,refund_id)**持久去重，**必须程序检查新插入**才继续，避免重复撤权；本地事务写Outbox，外部撤权需真实结果、幂等和人工补偿；SQL属教学骨架非可直接执行生产脚本。
  2. C02 Stripe cancel API**通常立即取消**，`prorate`默认false，不自动产生余额/现金退款；期末取消是产品选择，需`cancel_at_period_end=true`，付款周期/现金退款/旧事件分开。
  3. C03 不得要求客户银行动态验证码、3DS、冲正码作为商户普遍有效核身，游客原邮箱失联走官方可核实流程或权限受控人工升级，无法验证就暂停资产转移。
  4. C04 429/502/503或超时和查询“Not Found”不能保证不可逆外部写未执行，只有下游真实支持可核对幂等/唯一键方自动重试，否则人工处理。
  5. C05 补发不强制0元子单、无条件二次扣Available或固定营业外/质保会计科目；按平台能力、占用事实、合同及承运服务判断；P.O.Box不统一禁用。
  6. C06 PCI DSS 3.3.1授权后禁存SAD、3.4.1 PAN显示掩码、3.5.1 PAN存储保护分别解释，哈希/截断/令牌/加密依适用标准，税务记录保留期按地区和用途，3–7年仅教学假设。
  7. C07 有偿非有形数字内容与数字服务/专业服务撤回权边界、持久介质不限邮件、瑕疵救济；5H2+14H3=19个子题，自检及尾表据此修正。
- 正式4.7正文原创建commit `494056aa49c6e830dfbe2a57c8d52a2f007ef1bf`，SQL代码围栏与去重分支修正commit `27c09ee4f219349aba1d58f26ea28daea30e190e`，补发Mermaid同步修正commit `cbb7fec1393583f2c36d8a1e269c1ddf69356333`，**最终正式blob SHA `986ef28cd18e422ddd324090cb4cf8b219872974`**；冻题5/14完全一致、14个Markdown代码围栏成对、七组技术检查PASS。[正式封板审计](docs/CHAPTER7_SEAL_EVIDENCE_20261019.md)。**未实际运行Stripe支付、3PL、数据库并发或法定流程实测**。
- 4.7的V1/R2 Reviewer RETURN记录在main仅为真实历史审稿，不再当前任务；完成后的4.7 Writer原Gate/离线ZIP登记退出main当前工作树，Git版本历史保留。

## 三、现在只做4.8独立Writer首稿

**一级：4.8《上线前怎么检查？》（5H2/14H3）**。二级范围：
- 4.8.1 怎么像客户一样完整试买一次？（2三级）
- 4.8.2 哪些异常情形必须提前测？（3三级）
- 4.8.3 客户账号和上传资料安全吗？（3三级）
- 4.8.4 海外客户能用吗？（4三级）
- 4.8.5 上线失败能退回正常状态吗？（2三级）

**全部三级原文**请以正式V2问题树及新Gate和ZIP内01文件为准，不可由本摘要猜测。重点是**正式上线前验收**：实物/数字/软件/定制成交到交付，未付款/通知乱序/库存并发和权限异常负例，跨客户隔离/后台/上传PII安全，跨境浏览器/币种/时区/弱网/无障碍，备份与回滚真实演练及P0阻断。不能把模拟支付当真实到账、备份文件存在当恢复成功，不能使用真实持卡敏感数据做演示。

已封板4.1–4.7只读；4.9负责上线后维护，不得提前撰写；①市场②网络③主体/支付税务⑤获客由各自板块负责。Writer自主选择深度与工具，不强制某种SaaS、数据库、队列或自动化架构，不需要GitHub权限。

## 四、治理状态与必须停止

- **PROJECT_GOAL：** 产品怎么做、怎么交付？
- **PROJECT_STAGE：** 1/9/48/117完整冻题；4.1–4.7正式正文封板；4.8 Writer V1独立审核RETURN、R2返修待交；4.9/HTML未启动。
- **SYSTEM_MAP：** GitHub main存正式冻题/封板正文及审计/当前Gate/导航和交接；Owner对话附件传离线Writer完整ZIP。无客户资产和真实金融操作。
- **CURRENT_ACCEPTED_STATE：** 七章正式教材和七份封板证据；8章已有V1候选但独立Reviewer RETURN、无正式封板正文。
- **CURRENT_GATE：** `CH8-WRITER-V1-REVIEW-RETURN-R2-REPAIR-20261019`。
- **CURRENT_ROLLBACK_STATUS：** Git有版本历史，可按已提交变更回溯；没有生产部署和银行资金更改。
- **UNRESOLVED：** 4.8 Writer V1已交但审核RETURN；R2完整返修尚未交；具体业务系统/国家法定义务须按实际环境核实。
- **NEXT_STEP / OWNER_ACTION_REQUIRED：** Owner转交本轮4.8 V1审核后的**R2完整返修ZIP＋话术**→Writer交**完整R2正文、B01–B10逐项核验/自检及ZIP**，`STOP_AT_REVIEWER`→Reviewer独立冷审（RETURN要完整返修包及Writer提示词）→Owner决定封板。
- **MANDATORY_STOP：** `CH8_R2_WRITER_PENDING`；不预写4.8正文，不启动4.9或HTML。

[返回第四部分README](README.md)