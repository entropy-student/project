# 第四部分《产品搭建》｜唯一当前Reviewer交接（2026-10-19）

> **PROJECT_STATUS：FRAMEWORK_V2_FROZEN / CH1_CH2_CH3_CH4_FINAL_SEALED / CH5_R2_RETURN_R3_WRITER_PENDING**  
> **正式问题树：核心1 / 一级9 / 二级48 / 三级117**（不可擅改）  
> **CURRENT_GATE：CB04-CH5-INDEPENDENT-OFFLINE-FIRST-DRAFT-20261019**  
> **CURRENT_STOP：CH5_R2_REVIEW_RETURN / R3_WRITER_PENDING / NO_SEALED_CH5_BODY / NO_HTML**  
> **OWNER_ACTION_REQUIRED：** 将4.5 Writer R2独立Reviewer完整R3返修ZIP和提示词交独立Writer；回交R3完整正文、C01–C05逐项核验与ZIP后交Reviewer。

## 一、必须先读的权威文件

1. [正式V2完整冻结框架](docs/FROZEN_FRAMEWORK_V2_20261018.md)：1/9/48/117，原标题与顺序唯一依据。
2. [4.1唯一封板正文](docs/CHAPTER1_FINAL_SEALED.md)及[审计](docs/CHAPTER1_SEAL_EVIDENCE_20261018.md)，4H2/10H3。
3. [4.2唯一封板正文](docs/CHAPTER2_FINAL_SEALED.md)及[审计](docs/CHAPTER2_SEAL_EVIDENCE_20261018.md)，4H2/10H3。
4. [4.3唯一封板正文](docs/CHAPTER3_FINAL_SEALED.md)及[审计](docs/CHAPTER3_SEAL_EVIDENCE_20261018.md)，5H2/11H3，**4.3.4直接成节**。
5. **[4.4唯一封板正文](docs/CHAPTER4_FINAL_SEALED.md)**及[本轮正式封板证据](docs/CHAPTER4_SEAL_EVIDENCE_20261019.md)，6H2/13H3；Writer R2经Owner特批Reviewer定向修C01–C04。
6. **[4.5独立Writer当前Gate](docs/CHAPTER5_INDEPENDENT_WRITER_GATE_V1_20261019.md)**，冻结5H2/12H3题目逐字列于Gate及离线ZIP。
7. [4.5完整离线8 Markdown ZIP校验登记](docs/CHAPTER5_WRITER_OFFLINE_PACKET_MANIFEST_V1_20261019.md)：文件 `第四部分_第五章_独立Writer完整离线工作包_V1_20261019.zip`，**9,806 bytes**，SHA256 `d1e3d18e9688911a0838743dba0c1b76c73b9ca31869abebe797988de9b4bd47`，本轮Owner对话下载（**二进制未上传main**）。
8. [第四部分README](README.md)、[五板块父目录](../README.md)、[第二板块长期Writer→Reviewer→Owner协作规范](../02-network-environment/docs/WRITER_REVIEWER_WORKFLOW_V1_20261018.md)。

## 二、已确定历史决策、没有进行的动作

- 2026-10-18 Owner正式冻结V2 **1/9/48/117**问题树。旧1/7/45/118结构、以及曾未经独立Writer预写的4.1草稿是历史对照，不得冒充最新权威。
- **4.1**：独立Writer V1/R2交付，R2仍有6组事实问题；Owner特批Reviewer以完整R2为底修复并封板，**没有Writer R3**。
- **4.2**：独立Writer V1/R2交付，R2有B01–B04；Owner特批Reviewer以完整R2为底修复并封板，**没有Writer R3**。
- **4.3**：独立Writer V1/R2交付并独立Review；R2 C01–C04（支付事件与业务幂等、旧版自检标题、定价/平台绝对化、支付/物流事实源），Owner特批Reviewer修复后封板；原R2旧题名自检不能当证据，已依据V2重新制作索引；**没有Writer R3**。
- **4.4**：Writer V1完整稿及核验交付，Reviewer审为`RETURN_CH4_V1_TRANSACTION_ACCESS_LEGAL_SOURCE_ERRORS`（R01–R08）；Writer R2交付，完整正文61,784 bytes，SHA256 `4935337b0e72bb976cb0b8a55c551122f142ae211da6b1d4716eaa790b138eae`，原核验26,807 bytes，SHA256 `729b36b8fcb87ccff7dc3b57f0cf633a8658ded88c6948cd33bf81ceb9024318`。Reviewer再评`RETURN_CH4_R2_RESIDUAL_AWS_PAYMENT_AND_NORMATIVE_SCOPE_ERRORS`（C01–C04），R3 ZIP曾准备好**但Writer未开始R3**。2026-10-19 Owner明确单次授权：“这部分内容暂时由你来修改完成之后嗯，正式冻结，然后填入我们的项目库当中。记得记录相关文档。完成之后开启下一个1级问题的部分。”Reviewer据此以**Writer R2完整原稿**直接定向修复并封板，**无Writer R3交付**。
  - C01：S3 POST Policy有`content-length-range`条件，预签名PUT不能直接使用该POST条件；真实订单与Bucket/Key授权、大小复核、同Key覆盖和隔离。
  - C02：限发临时链接次数≠限制S3 GET真实下载次数；严格实际下载计数必须通过受控交付逐次核验/定义重试。
  - C03：Stripe API v1幂等键同请求同参数，至少24小时后可能清理；v2行为不同，跨新PaymentIntent/支付渠道不能保证全局防双重收费。
  - C04：sessionStorage不抗XSS；姓名/住址个人数据不必然是所有法律下特殊类别；PCI v4.x 3.3.1禁止授权后SAD存储并非规定全球只许PSP iframe；WCAG 2.2 AA目标尺寸24×24 CSS有例外，技术标准不等于全球法定规则。正文、Mermaid、尾表同步修改。
  - 4.4正式正文创建commit `178125b7ed5b3371efc9131d5d6c8170f4651c78`，GitHub blob `fa9726576112915afd9ab3bffc577e80f7081aba`，6/6二级13/13三级逐字PASS。正式审计证据见上。原V1和R2审稿记录保持在main并标记历史，不作为当前R3任务；旧4.4首稿Gate/ZIP登记退出当前工作树但Git历史可查。
- **4.5**：Writer V1已真实交付并独立审核RETURN，R2完整返修工作包已提供Owner；没有封板第4.5章；**不得自行启动4.6或HTML**。第四部分以外只允许父项目README的导航更新，没有修改其已封板正文。

## 第4.5章Writer V1独立Reviewer审查（2026-10-19，历史）

- Writer V1真实交付，原ZIP 26,741bytes，SHA256 `aa08f6442d28417468c8853043fe387b15d46b658bacaf875eb52191131c5f91`，两份完整Markdown，结构5/5二级、12/12三级逐字PASS。
- **Reviewer独立结论：`RETURN_CH5_V1_PAYMENT_INVENTORY_STATE_AND_EVIDENCE_ERRORS`**，8组实质阻断：B01库存ATS漏Unavailable/数字码强制模式；B02订单单向状态无法容纳部分退款、完结后售后；B03错误Stripe事件字段`event.data.amount_captured`及支付事实；B04`event.id`直接退出导致崩溃漏交付；B05卡密/3PL伪幂等保证；B06三个渠道各展示共享450件无法防超卖；B07客户末四位伪身份核验、GDPR/PCI及审计日志保留范围；B08官方事实VERIFIED与文中实现不符/假设未就地标注。详见[当前审稿记录](docs/CHAPTER5_WRITER_V1_REVIEW_RETURN_20261019.md)。
- Owner对话离线R2完整返修ZIP `第四部分_第五章_Writer_V1_R2完整定向返修包_20261019.zip`，**42,672bytes**，SHA256 `7d1120e43c8d166c913fefd4efb4ebff6a30fee255090795cdd1ef7eedc3c4a7`；8份UTF-8 Markdown，**原Writer V1完整正文、自检原样保留**，以及Reviewer全报告、R2指令、冻结原题、官方来源与逐文件SHA。文件本体在Owner对话，**未上传GitHub二进制**。
- **这段为Writer V1审核时历史状态；现已收到R2且独立复审RETURN，仍无4.5封板正文**。Reviewer只审不改候选稿；不启动4.6或HTML。

## 第4.5章Writer R2独立Reviewer复审（2026-10-19，当前任务）

- **Writer R2完整ZIP已交并完整解压**：32,598 bytes，SHA256 `3847e571be5b0cac38c5f6b8b4a196bfb3aa5d4cb9609646ca00717101ab5950`；完整正文42,946 bytes（SHA256 `74ab7ce8b7e18535bebcb433ef5e8fd664a5cc9e3ad5c6ea0cefa423b0ada3d6`），完整核验24,879 bytes（SHA256 `3cd6ebe20b60e6f26a56525d9b44f5349f405b9ac4c857720c5e58d73a224e2d`）。**5H2/12H3题目原文、同序、同级PASS。**
- **当前Reviewer正式判定 `RETURN_CH5_R2_RESIDUAL_CONCURRENCY_PAYMENT_STATE_AND_RETENTION_ERRORS`**。已改善大部分B01–B08，但剩C01卡密SQL跨行NOT EXISTS无业务唯一约束（并发仍可能一订单分配多卡）、C02把Checkout Session的`client_reference_id`误用于PaymentIntent、C03库存临时锁与已付款双扣/状态不能全局只进不退、C04静态渠道配额被夸大为100%防超卖、C05审计例子完整门牌号与数据保留期绝对化。
- **[本轮完整独立R2审核与R3包指纹](docs/CHAPTER5_WRITER_R2_REVIEW_RETURN_20261019.md)**。Owner对话完整R3返修包 `第四部分_第五章_Writer_R2_R3完整定向返修包_20261019.zip`，**50,991 bytes**，SHA256 `34551c1755259b662e212a9ca6015c9f40f783da34cf1be1f622f67ef3f1d9cf`；9份UTF-8 Markdown，R2完整正文/核验原字节保留，CRC和逐文件SHA通过；**二进制未上传GitHub**。
- **当前R3 Writer未交稿，第4.5章没有正式封板正文。4.1–4.4封板保持不变。** 下列V1审稿内容仅供历史追溯，不应依历史R2工作包误发任务。

## 三、4.5章冻结题目与核心知识责任

**一级：4.5 商品、库存和订单怎么管清楚？**（**5二级12三级**）

- **4.5.1 商品和可卖数量怎么管？**（2三级）：SKU、预约名额、数字码、可卖数量；旧订单商品/价格快照。
- **4.5.2 订单从创建到完成该怎么记录？**（3三级）：状态与合法迁移、取消和部分履约、操作人员和审计。
- **4.5.3 怎样核对付款后再交付？**（3三级）：截图不可当付款事实、晚到重复/不匹配通知、业务动作幂等。
- **4.5.4 同时有人下单，怎样避免超卖？**（2三级）：库存预留和释放、跨渠道并发与补偿。
- **4.5.5 后台员工能访问哪些客户资料？**（2三级）：客服/仓库/外包最小权限、客户数据和留存边界。

完整**逐字三级原题**在Gate与离线ZIP中，不能按本简短摘要自行猜出冻题。跨章限制：4.5商家后台订单/库存事实；4.6实体/软件/服务实际交付；4.7售后异常与退款后的权益；4.8上线测试；4.9运营维护。其它①机会/②网络/③主体支付财税（CLOSED）/⑤获客，均只读。Writer自由决定篇幅、案例、表格和技术工具；不可强制每个商家自建数据库/消息队列，也不能虚构API核验、部署测试、真实订单付款。

## 四、治理面板与下一步

- **PROJECT_GOAL**：系统回答“产品怎么做、怎么交付？”。
- **PROJECT_STAGE**：1/9/48/117完整框架冻结；4.1–4.4正式全文已Owner封板；4.5 Writer R2已交并独立Review RETURN、R3定向返修待交；4.6–4.9无正文；HTML未启动。
- **SYSTEM_MAP**：GitHub main管理正式冻题、唯一封板正文、封板审计、当前Writer Gate与交接。离线ZIP位于Owner本轮对话，不在GitHub binary仓库。
- **CURRENT_ACCEPTED_STATE**：4篇正式正文及对应证据；5章已有Writer V1候选但独立审核RETURN，尚无封板正文。
- **CURRENT_GATE**：`CB04-CH5-INDEPENDENT-OFFLINE-FIRST-DRAFT-20261019`。
- **CURRENT_ROLLBACK_STATUS**：Git历史保留，可按提交回滚；无真实业务系统、客户文件、密钥和付款操作。
- **UNRESOLVED**：4.5 Writer R3尚未交；C01–C05仍待独立复核，真实库存/付款流程未作生产测试。
- **NEXT_STEP / OWNER_ACTION_REQUIRED**：Owner转交4.5 R3完整返修ZIP+提示词→独立Writer以R2全文修订，提交R3完整正文及事实核验Markdown+ZIP，`STOP_AT_REVIEWER`→Reviewer独立冷审，必要时同轮完整返修ZIP+可复制指令→Owner决定封板。
- **MANDATORY_STOP**：`CH5_R3_WRITER_PENDING`；不预写4.5正文、不启动4.6或HTML。

[返回第四部分目录](README.md)
