# 《产品搭建》4.7章｜Owner特许Reviewer定向修订与正式封板证据

> **DATE：2026-10-19**  
> **VERDICT：CHAPTER7_FINAL_SEALED / OWNER_APPROVED / FROZEN_QA_PASS**  
> **唯一正文：** [CHAPTER7_FINAL_SEALED.md](CHAPTER7_FINAL_SEALED.md)；**唯一冻结题目：** [V2 1/9/48/117](FROZEN_FRAMEWORK_V2_20261018.md)。  
> **特别注意：没有Writer R3交付。** 本次由Owner明确批准Reviewer在Writer R2原完整正文上直接定向修复，不代表后续新章可由Reviewer跳过独立Writer代写首稿。

## 1. 确凿来源与Owner批准链

- Writer V1原文与核验已交，Reviewer [V1独立RETURN](CHAPTER7_WRITER_V1_REVIEW_RETURN_20261019.md)指出B01–B10。
- Writer R2交付ZIP `第四部分_第七章_独立Writer交付_R2.zip`：**37,549 bytes**，SHA256 `5de2b0eeaa8e176b41240be2f5874781239777c2e360d76e735baaba79c7f326`，CRC PASS。独立Writer完整R2正文44,483 bytes、SHA256 `4e7767f291f6cd950c3b89250ae3ba7f87fe68498cbc0ece57f0ffd9fc1a837f`；独立Writer完整R2自检35,874 bytes、SHA256 `5a9017ef06b400ff0847fd5f817168b4802daf526345889043fe9c86b6f806ce`。
- [R2独立Reviewer RETURN](CHAPTER7_WRITER_R2_REVIEW_RETURN_20261019.md)仍有C01–C07。Owner明示：“这部分内容暂时由你来修改完成之后嗯，正式冻结，然后填入我们的项目库当中。记得记录相关文档。完成之后开启下一个1级问题的部分。”
- Reviewer直接在完整Writer R2正文上修订C01–C07并跨核SQL/流程图/结尾表，正式文件创建commit `494056aa49c6e830dfbe2a57c8d52a2f007ef1bf`；补充修正代码围栏和数据库业务去重条件的更新commit `27c09ee4f219349aba1d58f26ea28daea30e190e`；同步更正补发Mermaid与库存/会计正文一致性的更新commit `cbb7fec1393583f2c36d8a1e269c1ddf69356333`；**最终GitHub blob SHA `986ef28cd18e422ddd324090cb4cf8b219872974`**。全部5/14冻结题目原文逐字、层级、排序通过。
- **不存在独立Writer R3版本**，此前准备的R3离线返修ZIP作为未执行的历史审稿资料，不能冒充Writer成果。本轮封板决定覆写“等待R3”的当前Gate，不修改真实Git历史。

## 2. C01–C07逐项修复及事实边界

| 原阻断 | Reviewer直接修订与验收 | 官方依据 |
|---|---|---|
| **C01退款先撤权/重复事件** | 重构4.7.3.3 SQL和配套矩阵：可信Refund状态、商户、币种、金额核验；**先对(provider,refund_id)持久去重，程序必须确认新插入后才继续**；重新核算累计退款，按订单项和**交付单位**独立判断撤权；本地事务仅建Outbox意图，外部撤权须实际核对和补偿。SQL明确**教学骨架非可直接上线**。 | [Stripe Refund对象](https://docs.stripe.com/api/refunds/object)、[Events Types](https://docs.stripe.com/api/events/types) |
| **C02取消订阅API默认错误** | 正文明确Stripe cancel API通常**立即取消，prorate默认false**；期末取消需实际更新`cancel_at_period_end=true`，有无账单信用余额或现金退款是另一个需验证的事实；合法已付权益、取消续费与旧事件不能混同。 | [Stripe取消API](https://docs.stripe.com/api/subscriptions/cancel)、[取消指南](https://docs.stripe.com/billing/subscriptions/cancel) |
| **C03身份恢复收集银行动态凭据** | 禁止把银行卡末4、交易单号、App“授权冲正代码”、3DS和短信OTP作为统一核身凭据；正式可验证的服务商认证、风险分级人工升级、暂停未经核实的改绑与授权转移。24小时冷静期标为模型假设，不能替代真实身份验证。 | [OWASP Forgot Password](https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html) |
| **C04外部3PL写操作可能已经执行** | 对429/502/503、504及查询Not Found增加**副作用未知**分流；任意等待窗口不能证明未执行，必须有服务商官方确认的幂等/唯一行为和真实查询支持，否则暂停重发并人工核对；Mermaid/自检同步修复。 | [AWS SQS at-least-once](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/standard-queues-at-least-once-delivery.html)、具体服务商API合同需另核验 |
| **C05补发库存/会计/收件地硬规则** | 不再一律要求0元子单、每次Available再扣或归营业外支出；按平台原生换货/售后子单/仓储工单区分，防库存重复占用；P.O.Box按承运商和国家确认，不能统一断言所有快递不送。 | [Shopify换货](https://help.shopify.com/en/manual/orders/refunds-returns/exchanges)；会计科目须按实际主体核实 |
| **C06 PCI和留存** | PCI 3.3.1 SAD授权后禁存、3.4.1 PAN显示掩码、3.5.1 PAN存储保护分别处理；截断/令牌/符合条件哈希/加密均需满足实际标准，8位BIN与keyed哈希规则有版本条件；3–7年仅教学假设，实际留存按地区/目的和义务判断。 | [PCI SSC FAQ1492](https://www.pcisecuritystandards.org/faqs/1492/)、[FAQ1146](https://www.pcisecuritystandards.org/faqs/1146/) |
| **C07 EU数字内容/服务和自检来源** | EU CRD第16(m)/8(7)适用有偿非有形数字内容的条件；**持久介质不只邮箱**，不同数字服务/完全履行服务另行分析；瑕疵救济不丧失。纠正与正式冻结题数一致性，结尾清单同步修正。 | [Directive 2011/83/EU](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02011L0083-20260927) |

**QA边界：** 对冻题、书面技术逻辑、SQL事务意图、图表与清单一致性做文本复核。未实际执行Stripe退款、3PL发货、数据库并发、账户核身或法律实务验证；不得把文稿封板解释为实际软件上线/合法合规保证。前六章正式正文无修改。

## 3. 正式冻结5H2/14H3索引（由最新V2和GitHub正文逐字复核）

| 编号 | 正式题目原文 | 层级 |
|---|---|---|
| 4.7.1 | 漏发、错发或物流异常怎么处理？ | 二级 |
| 4.7.1.1 | 怎样分清物流没有更新、丢件还是错发？ | 三级 |
| 4.7.1.2 | 补发要如何关联原单、避免重复扣款或错库存？ | 三级 |
| 4.7.1.3 | 客户什么时候需要重新确认交付地址或方案？ | 三级 |
| 4.7.2 | 客户找不到订单或下载失败怎么办？ | 二级 |
| 4.7.2.1 | 找订单与证明本人有权访问，是一回事吗？ | 三级 |
| 4.7.2.2 | 无法收邮件或换了设备，如何安全恢复？ | 三级 |
| 4.7.2.3 | 如何防止被猜测订单信息的人批量找回？ | 三级 |
| 4.7.3 | 取消、退款或退货后，产品权益怎么调整？ | 二级 |
| 4.7.3.1 | 已发货、未使用与已消费服务应如何分流？ | 三级 |
| 4.7.3.2 | 全额与部分退款，哪些权限需要调整？ | 三级 |
| 4.7.3.3 | 如何核对撤权、库存和订单都变成正确状态？ | 三级 |
| 4.7.3.4 | 取消订阅后，剩余使用期和已交付内容怎么算？ | 三级 |
| 4.7.4 | 自动交付失败或重复执行怎么办？ | 二级 |
| 4.7.4.1 | 任务失败后，怎样决定重试还是暂停？ | 三级 |
| 4.7.4.2 | 怎么确认补交没有重复发货或开通两份？ | 三级 |
| 4.7.5 | 有人说没收到货，怎样保存交付证据？ | 二级 |
| 4.7.5.1 | 哪些订单/物流/使用事实值得保留？ | 三级 |
| 4.7.5.2 | 怎样导出可理解的事实记录而不泄露不必要的个人资料？ | 三级 |

**最终标题一致性：5/5二级，14/14三级，19/19子题逐字同序同层级PASS。**

## 4. 封板后下一阶段

- 当前4.7 **CHAPTER7_FINAL_SEALED**；此前V1/R2 RETURN仍在GitHub，明确标记历史、不再提供R3执行入口。
- 下一级 **4.8《上线前怎么检查？》**，正式**5二级/14三级**。仅发布独立Writer首稿Gate＋全套离线ZIP＋可复制话术；不代写第4.8章正文，不启动4.9或HTML。
