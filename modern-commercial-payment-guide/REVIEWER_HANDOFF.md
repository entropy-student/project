# 现代商业支付系统｜唯一项目交接

> **PROJECT_STATUS：CLOSED**（2026-10-17，Owner 授权定向修正、自检通过后正式关闭）  
> **CURRENT_GATE：NONE**｜**OWNER_ACTION_REQUIRED：NONE**｜**HTML：NOT_STARTED / DEFERRED**

## 项目定位与最终成果

面向中国大陆个人开发者、独立站经营者及小微跨境商家的《现代商业支付系统｜如何收钱更快、更省、更安全？》实操知识指南。已完成 **7 章 Markdown 正式正文**，以 [V6 冻结框架](docs/FROZEN_FRAMEWORK_V6_20261016.md) 的 **7 个一级、29 个二级、42 个三级问题**为正式结构。

**最终 HTML 未启动且不在本次交付与 CLOSE 范围内**；不得把项目关闭等同于 HTML 已交付或生产支付系统已验证。项目以后可由 Owner 明确重开新增/拆分知识模块，不得自动恢复 HTML 或旧 Writer 任务。

## 唯一有效文件（本项目 main 共 9 份）

| 序号 | 正式文件 | 内容 |
|---|---|---|
| 0 | [FROZEN_FRAMEWORK_V6_20261016.md](docs/FROZEN_FRAMEWORK_V6_20261016.md) | 七章 7/29/42 冻结结构 |
| 1 | [CHAPTER1_FINAL_SEALED.md](docs/CHAPTER1_FINAL_SEALED.md) | 收款方案选择；包括已审批任务 B 的经营主体专项、本轮争议时限/责任纠偏与按场景阅读导航 |
| 2 | [CHAPTER2_FINAL_SEALED.md](docs/CHAPTER2_FINAL_SEALED.md) | 收款开通与接入 |
| 3 | [CHAPTER3_FINAL_SEALED.md](docs/CHAPTER3_FINAL_SEALED.md) | 顾客付款；新增订阅续费失败恢复与令牌类型辨析 |
| 4 | [CHAPTER4_FINAL_SEALED.md](docs/CHAPTER4_FINAL_SEALED.md) | 支付处理 |
| 5 | [CHAPTER5_FINAL_SEALED.md](docs/CHAPTER5_FINAL_SEALED.md) | 资金结算与到账；新增 B2B 合同/发票银行收款六步操作表 |
| 6 | [CHAPTER6_FINAL_SEALED.md](docs/CHAPTER6_FINAL_SEALED.md) | 售后与资金风险 |
| 7 | [CHAPTER7_FINAL_SEALED.md](docs/CHAPTER7_FINAL_SEALED.md) | 财务与合规；纠正欧盟 VAT 适用边界及 Mastercard ECP 跨月计算示例 |

另加**本文件**，项目正式目录总共 **9 份文件**。旧评审、旧 Writer Gate 和旧文件索引已依 Owner 要求从项目当前目录精简，不重复建立归档目录。需要时可从 [精简前 Git 快照](https://github.com/entropy-student/project/tree/7c20dd8e988a1b760e9609a201f5445a3a36b44f/modern-commercial-payment-guide) 追溯。

**七章最新正式 Markdown ZIP：** [GitHub 独立导出包](https://github.com/entropy-student/project/archive/refs/heads/payment-guide-seven-sealed-chapters-20261017.zip)。此分支只是七章下载出口，不是独立编写源。

## 最近一轮最小修订（2026-10-17）

**Owner 授权：** “最小化原则进行修正吧。完成之后进行自检。没问题就正式close掉。”

- 第一部分 2.2：将争议“统一 120 天、无条件扣款、股东无限兜底”改为区分渠道时限、暂扣与最终判定、商户合同义务和股东有限责任；补三类商家阅读导航。
- 第三部分 4.1：补上订阅续费失败 → 受控重试/换卡 → 客户通知 → 宽限期/取消与权益同步；区分 PSP Token、Network Token 与跨 PSP 迁移。
- 第五部分 3.1：补上 B2B 银行/持牌服务商合同发票收款的六步核验及可用余额/银行实际到账判定。
- 第七部分 2.1、3.1：澄清目的地 VAT 不等于统一标准税率或卖方统一自报；明确 Mastercard **11 月 20 ÷ 10 月 1,000 = 2.0%**、**12 月 5 ÷ 11 月 100 = 5.0%**，但两次示例均未达到当月争议件数门槛。

**正文写回 Commit：** [`5515dd4b52f04cb832c9d5974a2e5dc1f5a7d87e`](https://github.com/entropy-student/project/commit/5515dd4b52f04cb832c9d5974a2e5dc1f5a7d87e)。仅修改第一、三、五、七部分；第二、四、六部分保持原 Git Blob。  
**七章 ZIP 归档 Commit：** [`0c7970c10c5814515c96f7f135f98214d5d31769`](https://github.com/entropy-student/project/commit/0c7970c10c5814515c96f7f135f98214d5d31769)（导出分支，七个文件与 main 的正式正文逐一对应）。

**官方核验入口（按问题）**：
- [PayPal 争议时限](https://www.paypal.com/us/cshelp/article/dispute-filing-timeframes-help1173)（部分买家保护争议 180 天）。
- [欧盟 VAT 税率规则](https://europa.eu/youreurope/business/finance-and-tax/vat/vat-rules-rates/indexamp_en.htm) 与 [OSS/IOSS 责任边界](https://vat-one-stop-shop.ec.europa.eu/one-stop-shop_en)。
- [Braintree / Mastercard ECP 计算和双门槛](https://developer.paypal.com/braintree/articles/risk-and-security/card-brand-monitoring-programs/mastercard-programs/excessive-chargeback-program)。
- [Stripe Billing 自动重试](https://docs.stripe.com/billing/revenue-recovery/smart-retries)、[订阅事件](https://docs.stripe.com/billing/subscriptions/webhooks)、[Adyen Tokenization](https://docs.adyen.com/online-payments/tokenization/)。
- [万里汇 B2B 官方快速指南](https://www.worldfirst.com.cn/content/articles/b2b_gbl/quick_guide) 与 [订单关联](https://www.worldfirst.com.cn/content/articles/b2b_gbl_portal/submit_trade_order)。

## 最终自检及关闭依据

- **PASS｜范围**：只有第一、三、五、七章发生定向正文变化；第二、四、六章未修改；整个 GitHub 仓库其他项目路径未被本轮内容修订改变。
- **PASS｜冻结结构**：四章修订前后现有编号问题标题逐项一致；全部七章仍保有 42 个三级问题，V6 框架 Git Blob 未修改；未新建第八章。
- **PASS｜格式与引用**：既有 Markdown 代码围栏数量与结构保持一致；原正式参考来源仍在原章附录。第一章取消不恰当的争议费率 [S02] 引用、第七章替换原一刀切 VAT [S07] 引用位置，均补以针对性官方直链；其余旧引用标号保持。
- **PASS｜计算**：Mastercard 例题 20/1000 = 2.0%、5/100 = 5.0%，并写明低于最低笔数门槛，不能被误解为已触发罚款。
- **PASS｜GitHub 回读**：七章提交后逐份回读确认 Git Blob；七章独立 ZIP 归档树精确为七份正文，与 main 所有七章 Blob 匹配。
- **PASS｜项目清理**：只保留唯一交接、V6 框架、七章正文，共 9 个项目文件；不额外保留审核工作包或 HTML。
- **NOT_APPLICABLE｜生产验收**：本项目是知识文档，无部署实例、数据库、真实支付、退款、Secret 或生产资金操作；本轮未执行任何真实经营业务。

**审阅边界**：以上 PASS 是本轮指定问题的定向材料核验、自检和文稿封板，不是对七章每一项金融法规在未来时点的法律审计。费率、准入、卡组织规则、海外税法、跨境结汇要求应在实际使用时按当期官方资料复核，未证实的信息记 `UNKNOWN`。

## 冻结决定及恢复方式

- **任务 A：FROZEN_NOT_MERGED**。此前语言编辑候选未整体替换七章，后续不能当作新正式稿。
- **任务 B：PASS_OWNER_APPROVED_MERGED**。第一章 3.1 主体设立专项由 Owner 批准封板。
- **项目阶段：CLOSED**。目前没有活动 Gate、不安排 Writer、Review、HTML 制作或新的内容扩充。
- **恢复入口**：Owner 明确要求重开并指出具体模块或交付目标 → 读取本交接与 V6 框架 → 只读确认实际 GitHub 七章 → 界定本轮可改章节及回滚范围 → 新 Gate。**不得自动解除 CLOSE 或变更冻结原文**。
- **恢复手段**：已封板文件 Git 历史及导出 ZIP 可用于版本比对与重新生成；旧审核内容如必需，可通过精简前快照查找。

**OWNER_ACTION_REQUIRED：NONE**。
