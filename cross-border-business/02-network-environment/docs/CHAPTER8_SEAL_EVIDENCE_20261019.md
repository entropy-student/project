# 第二板块第⑧章《成本与升级》｜Owner授权 Reviewer 定向修订及正式封板证据

> **OWNER_DECISION：2026-10-19 授权 Reviewer 基于 Writer R2 完整原稿修复并正式冻结、写入 GitHub `main`。**  
> **FINAL_STATE：CHAPTER8_FINAL_SEALED / OWNER_AUTHORIZED_DIRECT_REPAIR_PASS**  
> **唯一正式正文：`CHAPTER8_FINAL_SEALED.md`；并非 Writer R3 交付。**  
> **权威冻结：`FROZEN_FRAMEWORK_V5_20261018.md`，全板块 8 一级/44 二级/93 三级，三级为 Owner 暂时冻结。**

## 1. 原稿、审核结果与最小修订原则

- Writer R2 原始交付：`第八部分_成本与升级_Writer_R2完整交付.zip`，ZIP SHA-256 `be6e252514eb0a85c2282ff1465472b980b3fe73cb37b6e5001bc48db068c710`；包含 R2 全文 85,306 字节（SHA-256 `285dcf2474114efd4626016cb091eb5489bbc8224efec3d3a51b6482be4a648e`）及完整 R2 核验记录 30,316 字节（SHA-256 `fe30d48be0a67673cc0a5fab77fc0edf14d85707d0ecd75ddf62f1ae4eab953b`），ZIP CRC 验证通过。
- 独立 Reviewer R2 结论：`RETURN_R2_RESIDUAL_COST_MIGRATION_AND_SOURCE_ERRORS`，阻断 R2-01—R2-09；Owner 在本次对话明确授权 Reviewer 最小化直修第⑧章并封板，**不把直接修订冒称独立 Writer R3**。
- 保留原文完整五大模块和内容主体、计算方法、表格与案例；仅对不准确的资格、费用、迁移操作与来源作定向修正。

## 2. R2-01—R2-09 修订证据矩阵

| 编号 | 定向修订结果 | 边界及复查标准 |
|---|---|---|
| **R2-01** 迁移双写和 Webhook | §5.2 示意改成**唯一写入方、唯一事件消费者/持久缓冲**；停写覆盖前台、API、Worker、Cron、ERP 等；Stripe `event.id` 与业务对象 ID、数据库唯一约束和原子状态更新分层防重；旧新系统对账支付、退款、库存、物流和外部副作用，回滚只有满足唯一权威与补偿验收后才能恢复写入 | 可覆盖“不同 Event ID 的同一支付对象、新旧站同时收到回调、物流已发货”的逻辑反例；并非在生产网关实际演练 |
| **R2-02** RDS 不存在的规格报价 | §1.2 删除 `db.t4g.medium Multi-AZ DB cluster` 作为可购买配置的说法；115 美元及合计 468 美元明确只是模型假设，采购时须另确定实例类别、主备/三实例架构、区域、存储、I/O、备份 | AWS Multi-AZ DB cluster 支持类见官方文档；没有实际报价或 AWS 购买 |
| **R2-03** S3 出站费用 | §4.2 拆分 Cloudflare R2 无公网 egress 政策与 AWS S3 公网出站通常收费的区别，注明请求/存储、跨区及 CDN 条件 | 不把 R2 免出站推广到 S3 |
| **R2-04** 支付资格与费率 | §1.1 加入大陆 Shopify Payments **受邀 Early Access**、WorldFirst 身份/企业验证与跨境资格；撤销 Stripe 必须有企业/对公户的统一说法；表格和费用案例标按符合条件的第三方支付作演算 | Shopify 中国区不是对所有大陆商户普遍开放；第三支付板块维持只读 |
| **R2-05** “0% SLA” | §2.2 改为“可能没有正式 SLA/不含财务抵扣”，EC2 实例/区域级 SLA 各自以资源条件和合同定义为准；风险表去除普适红灯禁用断言 | SLA 不等于用户端结账 SLA；没有 SLA ≠ 0% 可用率 |
| **R2-06** 成本与现金流模型 | §1.1/1.2 划分历史报价快照与 `MODEL_ASSUMPTION`；移除通用技术费率、Rolling Reserve 期限比例、欧盟 VAT 单一区间；保留算式，补充不等价功能和人工/灾备反例 | 不将 1,100 美元差额当作等功能 TCO 优势；所有动态价格需再核实 |
| **R2-07** 诊断与迁移断言 | §4 TTFB 不直接归因普通像素 JS；`%steal` 与 CPU 积分分开，查 `CPUCreditBalance` 等；托管 DB 备份/PITR/HA 按产品查；§5.1 密码迁移按可导出/兼容/合法授权分流 | 不能保证同一单条指标推断唯一原因；不能统一要求所有老客重置密码 |
| **R2-08** 邮件进箱保证 | §5.3 改为 SPF/DKIM 与发件域对齐，DMARC 可通过任一合格对齐通路；另看真实送达、退信、垃圾箱和信誉 | 协议校验 PASS 不保证进入收件箱 |
| **R2-09** 官方来源与自检 | 正文后附 Reviewer 定向补充来源矩阵：Stripe/AWS RDS/S3/Shopify China/SLA/CPU Credit/DMARC/密码保存等，并明确静态核验与未实测边界 | 官方文档的特定适用范围明确，不把旧 Writer “全部价格实测”声明当证据 |

## 3. 冻结标题、文件完整性和安全核验

- 修订后正式文稿：**91,799 UTF-8 字节；SHA-256：`3657823340a6dea59a7f27fd279415cb0c2ab65e40475a24a6d8d6eb75787551`**。
- 程序检查原 Writer R2 与 Reviewer 修订稿的章节标题：**第八部分 1 个 H1、5 个 H2、11 个 H3 均逐字、同层级、同顺序**。旧 Writer R2 标题已在 R2 独立审核与 GitHub 官方 V5 框架比对通过；本轮任何冻结问题原文均未修改。
- 代码围栏：20 个围栏标记（10 对），数量与原稿相同；附录新增官方来源矩阵及限制说明。
- 逻辑反例：同一个第三方支付对象不同 Event ID 及双端重复消费不再用仅 `event.id` 去重；DNS 回切前必须核对订单、退款、库存和履约外部副作用；云计费模型不再把不支持的 RDS cluster 类型当成采购依据。
- 自查范围仅限文章、官方来源、计算、演示逻辑。**没有真实云价报价单、云账单、域名 DNS 切流、订单交易、Webhook 回放、邮件真实送达、生产环境测试或生产迁移**；不能声称此类动作通过。

## 4. 官方来源抽查与限制（2026-10-19）

- [AWS RDS Multi-AZ DB cluster 支持规格](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/multi-az-db-clusters-concepts.html)：不包括 `db.t4g.medium`，支持条件受引擎与地区限制。
- [AWS S3 价格](https://aws.amazon.com/s3/pricing/)及[Cloudflare R2 价格](https://developers.cloudflare.com/r2/pricing/)：出站费用制度不同。
- [Shopify Payments 中国区 Early Access 资格](https://help.shopify.com/zh-CN/manual/payments/shopify-payments/supported-countries/china/requirements)：受邀、大陆实体、跨境销售、WorldFirst 验证。
- [Stripe Webhooks](https://docs.stripe.com/webhooks)：重复、乱序与业务层去重需要各自处理。
- [AWS Compute SLA](https://aws.amazon.com/compute/sla/)及[EC2 CPU credits](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-performance-instances-monitoring-cpu-credits.html)：实例与区域 SLA 不同，CPU credit 不由 `%steal` 直接证明。
- [Gmail 邮件发送准则](https://support.google.com/mail/answer/81126)：认证不保证收件箱投递。

## 5. 正式封板与项目管理

- Owner 已授权 Reviewer 直接完成本章剩余修订、正式冻结并写入 GitHub `main`，故本次状态为 `FINAL_SEALED`，**非 Writer R3**；不自动批准任何后续 HTML 或业务生产操作。
- 本文件记录本章最终证据、原 R2 指纹、九组定向修复及测试范围，不替代唯一正文。GitHub 当前 `main` 应只保留 `CHAPTER8_FINAL_SEALED.md`，该证据、统一框架、长期工作规范、唯一交接与导航；清除完成的第⑧章旧 Gate/离线 ZIP，Git 历史仍可追溯。
- 第二板块 **8/8 章正文已完成并正式封板**，下一阶段（如全文综合审查、HTML 排版）**需 Owner 单独授权**；第三板块正式支付文档及其它四板块全部保持不变。
