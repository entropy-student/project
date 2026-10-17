# 第三部分｜新Agent返修成果独立Reviewer审核、最小修复与跨章质量评估（2026-10-17）

- **Gate**：`MCPG-CH3-20261017-REVISION-INDEPENDENT-REVIEW-OWNER-AUTHORIZED-MINIMAL-ADOPTION`
- **Owner明确授权**：本轮返修成果到达后可最小修复，通过独立审核则将第三部分正式正文和证据提交 GitHub `main`，不再重复询问采纳许可；①②、④、V6 均保持原状；⑤⑥不写正式正文。
- **初次新稿**：用户上传 `现代商业支付系统_第三部分_全新独立重写成果(1).zip`，43,754 bytes，ZIP SHA256 `93b190b35b95002e41b6499ba0966ed3c631b1023c1bde6ebbcf2381d402c4c9`，CRC PASS，根目录两份 UTF-8 Markdown。
- **作者返修正文**：85,718 bytes，720 行，SHA256 `6b72831180ee1bc247b5152ad550e663e9aee68c9234c62b6e4d22b01605f10c`。
- **作者 QA**：27,041 bytes，161 行，SHA256 `f1893beb1ed06487605918f8b3d8e510f94f8255ee6fc0e33d8a549d43a1b2c7`。
- **Reviewer 修订后正文**：89,749 bytes，732 行，SHA256 `39e05e7238ed543d4ecb9411066235444ca11f598c2892f87d8f3ed50ee70740`。
- **正式审核结论**：`PACKAGE_PASS / FROZEN_4H2_5H3_PASS / ORIGINAL_REVISION_NOT_READY / REVIEWER_TARGETED_FIX_PASS / CH3_OWNER_ADOPTION_AUTHORIZED`。作者原稿**不能无改动通过**；修改后的正文在本文所述事实和业务示例边界下达到正式采纳标准，采纳不等于自动封板。

## 一、V6、资料包与作者 QA 核验

1. V6 第三部分四个二级标题及五个三级标题与冻结框架逐字一致、顺序一致；新增的工具章、附录不修改冻结题文。
2. ZIP CRC、成员名、两份 Markdown 的真实字节/SHA 均已独立核验。作者执行记录内部第7节把其自身 SHA256 错填成**正文的** SHA256，且声称自身为“动态生成”；原始 QA 不可直接作为最终执行证明。本Reviewer报告给出实际 SHA，原始 QA 仍由用户上传 ZIP 保留可追溯，不作为正式正文。
3. 引文从 [S01]–[S13] 扩至 [S01]–[S16]，程序检查正文使用的编号集合与附录编号集合完全相同；这是编号/链接对应检查，**不**代表外部服务商对个别商户准入做了担保。
4. 本轮直接检查第一部分封板 SHA256 `c476f1eb15adc58c98a047334daa13542521758de8bcf56b560524650fa9a6db`、第二部分 `c9c14717104e9d5666b8007c82ffca4448c2598f2d59eed1c9ab3ce1505993f9`、第四部分已采纳 SHA256 `5e567a4de0818165ce3c2093c1b8ea0aa3c4dc92f573f2e5f1d39ad5701c7759`，作为跨章比较基准；不修改这些正文。

## 二、原有七组 P0 的逐项结论

| 原问题 | 作者返修稿是否解决 | Reviewer 本次最小修复与结论 |
|---|---|---|
| P0-01 大陆主体商户资格与支付方式已上线 | **未解决**：两个案例还把 Visa/Mastercard、PayPal 标为“YES已核验”，却没有实际 PSP/商户号 | 改成 `UNKNOWN（待商户核验）`，补四项核验门槛与无 YES 不上线说明。`PASS_AFTER_FIX` |
| P0-02 PCI SAQ A 与卡数据处理边界 | **部分**：作者将 FAQ 1588 写成所有嵌入式 SAQ A 商户自己必须做 6.4.3+11.6.1，且把 SAQ A-EP/D 当成唯一结果 | 补充第三方合规 PSP 证明保护技术的替代方式、重申最终由合规接受方确认；保留授权后不得存 CVV 及托管控件建议。`PASS_AFTER_FIX` |
| P0-03 Apple Pay 域名验证和可用性 | **部分**：架构区分改善，但宣称托管 Checkout 必定自动完成；并把 `canMakePayments()` 误当钱包有卡检测 | 区分托管域名／自定义域名，改写 Apple 设备支持与钱包凭据核验。`PASS_AFTER_FIX` |
| P0-04 iDEAL | Wero 币种与订阅 | **部分**：更新名称、SEPA 订阅，但混同 EUR presentment 与 EUR 结算入账 | 明确 EUR 是 Stripe 上 iDEAL | Wero 的交易呈现/扣款币种，而非唯一商户入账币种。`PASS_AFTER_FIX` |
| P0-05 德美税费/法律前提 | **未解决完全**：欧盟把未登记 OSS/未到“门槛”当作无 VAT 义务；加州 50万美元门槛叙述易掩盖实体关联与邮编税率的假设性 | 解释 Non-Union OSS 是申报机制且非欧盟主体不能直接援用 EU €10k 简化阈值；加州经济或实体关联分开核查，示例税率和运费税基明示是假设。€27含税=€22.69+€4.31、$134.49=$110+$15+$9.49 保留。`PASS_AFTER_FIX` |
| P0-06 状态未知仍承诺服务/重试 | **部分**：删除数分钟必确认等，但示例还填了虚构邮箱和营业时间，且把通信超时当软拒绝 | 改成按真实公示渠道核验、超时不等于失败、先查旧支付意图、避免盲目二次提交。`PASS_AFTER_FIX` |
| P0-07 引用编号事实对应 | **结构解决**，但原13个引文对 FTC 裁决、欧盟 OSS、3DS 争议与 CAN-SPAM 不够直接 | 加入 3 个对应官方来源 [S14]–[S16]，FTC 官方诉讼记录链接，双向编号核验通过。`PASS_AFTER_FIX` |

## 三、八组 P1 的逐项结论

| 原问题 | Reviewer 结论 | 处理摘要 |
|---|---|---|
| P1-01 不受支持的支付比例、费率和绝对断言 | `PASS_AFTER_FIX` | 移除 FTF 1–3%、DCC 3–5%、PayPal 固定$35提现费的普遍暗示；保留买家持卡协议与PSP合同核实。 |
| P1-02 价格/币种及跨国税制逻辑 | `PASS_AFTER_FIX` | 重定义显示币种、呈现/扣款币种、结算币种；区别欧盟 B2C 数字服务与美国按地址税费，价格样例为条件示例。 |
| P1-03 订阅与撤回权法域 | `PASS_AFTER_FIX` | FTC 2025撤销事实有官方诉讼状态证明；州 ARL 改为逐条件核对；欧盟耐用介质/数字撤回权例子作为规则提示而非争议结果担保。 |
| P1-04 3DS、SCA及欺诈责任转移 | `PASS_AFTER_FIX` | 修正 PSD2/PSD3 混写、责任转移必然成立及 ECI 算法式保证；身份验证与真实付款确认分章。 |
| P1-05 表单字段/钱包授权/徽章与 A/B | `PASS_AFTER_FIX` | 保留授权、统计功效、真实品牌；托管卡字段勿自行设 iframe 内输入属性或自建敏感格式化。 |
| P1-06 弃单邮件时间、GDPR 与 CAN-SPAM | `PASS_AFTER_FIX` | 时间作为实验假设；区分 GDPR 及电子直销邮件规则，修正 CAN-SPAM 不强制“统一一键”措辞。 |
| P1-07 冗余、术语与四章重合 | `PASS_WITH_NOTE` | 已去掉不必要的后端技术重复，保留双案例、筛选表、结账明细和失败工具。篇幅仍接近第一部分，高密度可作未来 HTML 呈现层优化；不以“必须再缩短”阻止合格正文。 |
| P1-08 作者 QA 自证 | `PASS_AFTER_FIX` | 以本独立Reviewer证据替代不正确的作者自报哈希，所有 `UNKNOWN` 均不伪装已开通，读者据实际PSP验证。 |

## 四、与①②④的教学与范围对比

| 维度 | ①已封板 | ②已封板 | ③最终修订 | ④已采纳 | 判定 |
|---|---|---|---|---|---|
| 内容深度 | 主体、MoR、自营收单、费率与实际到账判断 | 开户权限、集成选型、上线测试 | 目标顾客×商户资格筛选，钱包/本地方式，税费账单，3DS/PCI/失败分流 | 资金状态、服务端确认和履约状态 | **③达到同类问题应有的深度，无明显下降** |
| 内容广度 | 个人/企业/跨境模式 | 链接/插件/API | 数字SaaS+实物DTC、欧美及选择性本地方式、两种结账价税情境 | 多状态异常 | **③广度持平或更强** |
| 决策价值 | 提供可筛选的可用收款路径 | 给出接入方法和可否上线条件 | 两次独立的保留/排除/待验过程，以及上线资格四项证明 | 给出何时可信履约和追查方法 | **③达到标准；必须强调未选PSP时不产出真实YES** |
| 零基础可读性 | 文字丰富且案例说明 | 步骤导向 | 先直接回答、再讲两个具体生意、辅以图表；仍有若干术语偏密 | 偏工程后台 | **③合格，有可选压缩余地** |
| 衔接与重复 | 选择谁来收款 | 使收款可用 | **只讲顾客实际怎么付、为何弃单、买家端异常指引** | **服务端判断、幂等、Webhook、履约** | **衔接合格，实质重复已控制在必要指引程度** |

- **最重要的事实边界**：没有真实主体获批、签约账户和账单税务注册资料，两个商业案例必须被当作推演，而不是已实现的系统；这一点通过 `UNKNOWN` 和“核验四要素”明确。
- **仍待实际经营验证（非正文缺陷）**：具体大陆主体签约 PSP、收单账户对本地钱包和 BNPL 的授权、落地国家税务登记、实际邮编税率与商品税基、买家银行 FTF、弃单挽回有效性。正文不得被当作律师/税务师的个体法律结论。
- **是否有整体明显质量下降**：**否**。与①②相比，③原返修稿最大的缺陷是过度确认外部资格和个别技术/金融事实；经过本轮定向修复，结构、商业案例、实操工具和教学覆盖足以支撑第三部分被正式采纳。③使用更长的顾客体验解释和工具矩阵，属于主题差异，而不是知识深度劣化。

## 五、核验的官方依据（本轮重点）

- Stripe iDEAL | Wero：<https://docs.stripe.com/payments/ideal>（EUR presentment；SEPA 借记可支持订阅；支持地区不含大陆本地 Stripe 账户）
- PCI SSC FAQ 1588：<https://www.pcisecuritystandards.org/faqs/1588/>（SAQ A 嵌入式脚本安全，PSP 保护技术确认作为可选路径）
- Apple `canMakePayments`：<https://developer.apple.com/documentation/ApplePayontheWeb/ApplePaySession/canMakePayments>（设备支持检查不代表 Wallet 已有可用卡）
- Stripe Payment Method Domains：<https://docs.stripe.com/api/payment_method_domains>（Elements / Embedded Checkout 域名启用）
- Stripe 币种：<https://docs.stripe.com/currencies>（presentment=charge currency，settlement 另论）
- 欧盟 OSS：<https://vat-one-stop-shop.ec.europa.eu/one-stop-shop_en>（非EU供应商及€10k阈值条件）
- 加州 CDTFA：<https://cdtfa.ca.gov/industry/out-of-state-retailers/registration.htm>（$500k关联 + 仓储、代表等实体条件）
- Stripe 3DS 责任例外：<https://support.stripe.com/questions/liability-shift-with-frictionless-flow-for-3d-secure-v2-%283ds2%29>
- FTC 诉讼状态：<https://www.ftc.gov/system/files/ftc_gov/pdf/2025-12-Final-Public.pdf>（2025-07-08规则撤销）
- FTC CAN-SPAM：<https://www.ftc.gov/business-guidance/resources/can-spam-act-compliance-guide-business>（营销邮件退订标准）

## 六、变更边界和接手停点

- 原上传 ZIP 和原 QA 由会话上传文件保留，正文修订以单独 GitHub 正式文件管理；不删改历史归档。
- 只允许新增正式第三正文和此次Reviewer报告、以最小追加方式更新 Handoff、索引、决策与执行证据。
- ①②和V6冻结内容保持 Git SHA 不变；④不改；⑤⑥候选不得作为正式正文提交；不执行支付、退款、真实开户或部署。
- **采纳与封板分离**：本次依据 Owner 当前授权正式采纳正文，但**未获得第三部分封板授权**，状态为 `OWNER_ADOPTED / NOT_SEALED`。若以后有新证据反驳某项支付产品或法规说明，按最小修正流程处理。
