# 第四部分《产品搭建》｜唯一现行Reviewer交接（2026-10-18）

> **PROJECT_STATUS：V2_FRAMEWORK_FROZEN / CH1_CH2_CH3_FINAL_SEALED / CH4_V1_RETURN_R2_WRITER_PENDING**  
> **FRAMEWORK：核心1、一级9、二级48、三级117；唯一核心：产品怎么做、怎么交付？**  
> **CURRENT_GATE：CB04-CH4-INDEPENDENT-OFFLINE-FIRST-DRAFT-20261018**  
> **CURRENT_STOP：CH4_V1_CONTENT_RETURN / R2_WRITER_PENDING / NO_SEALED_CH4_BODY / NO_HTML**  
> **OWNER_ACTION_REQUIRED：** 将第4.4章Writer V1独立Review的完整R2返修ZIP及提示词发外部Writer；交回R2完整正文、逐项核验记录和ZIP后再交Reviewer。

## 1. 新Reviewer接手必须依序阅读的权威材料

| 内容 | 唯一路径与作用 |
|---|---|
| 完整冻结原题 | [V2正式框架1/9/48/117](docs/FROZEN_FRAMEWORK_V2_20261018.md)，原文/编号/层级/顺序不能改 |
| 4.1唯一正式正文与审计 | [CHAPTER1_FINAL_SEALED.md](docs/CHAPTER1_FINAL_SEALED.md)、[CHAPTER1_SEAL_EVIDENCE](docs/CHAPTER1_SEAL_EVIDENCE_20261018.md)，4H2/10H3 |
| 4.2唯一正式正文与审计 | [CHAPTER2_FINAL_SEALED.md](docs/CHAPTER2_FINAL_SEALED.md)、[CHAPTER2_SEAL_EVIDENCE](docs/CHAPTER2_SEAL_EVIDENCE_20261018.md)，4H2/10H3 |
| 4.3唯一正式正文与审计 | **[CHAPTER3_FINAL_SEALED.md](docs/CHAPTER3_FINAL_SEALED.md)**、[CHAPTER3_SEAL_EVIDENCE](docs/CHAPTER3_SEAL_EVIDENCE_20261018.md)，5H2/11H3，4.3.4直接成节 |
| 4.4新独立Writer首稿Gate | **[CHAPTER4_INDEPENDENT_WRITER_GATE_V1_20261018.md](docs/CHAPTER4_INDEPENDENT_WRITER_GATE_V1_20261018.md)**，6H2/13H3完整冻题 |
| 第4.4章离线ZIP与SHA | [CHAPTER4_WRITER_OFFLINE_PACKET_MANIFEST_V1_20261018.md](docs/CHAPTER4_WRITER_OFFLINE_PACKET_MANIFEST_V1_20261018.md)，ZIP `第四部分_第四章_独立Writer完整离线工作包_V1_20261018.zip`，12,075bytes，SHA256 `c2285555fdec6dcc6342e07ebf91bd272e8c2b1c68436d29110d0abab5eb81ed`；8份Markdown，Owner对话下载，二进制未上传main |
| 长期角色制度 | [第二部分Writer→Reviewer→Owner协作规范](../02-network-environment/docs/WRITER_REVIEWER_WORKFLOW_V1_20261018.md) |
| 项目总目录 | [第四部分README](README.md)、[五板块父项目README](../README.md) |

## 2. 决策和真实执行历史（按时间顺序）

1. 2026-10-18：Owner批准将本板块唯一框架冻结为**核心1、一级9、二级48、三级117**，此前1/7/45/118等不同版本为历史比较，不作为写作合同。Reviewer先前未经独立Writer代写4.1初稿，Owner要求从main删除；已执行，历史只保留普通Git记录。
2. 第4.1章：独立Writer V1、R2交付后Reviewer独立审查，R2有B01–B06残留。Owner特别授权Reviewer直接在**完整R2**上修订、QA后正式封板，**4二级10三级**未变，**不存在Writer R3**。唯一正文及审计见上。
3. 第4.2章：Writer V1及R2各自独立审查，R2仍有B01–B04（预算、PCI、首次必要性、异步付款）。Owner同样授权Reviewer在完整R2上定向修补，形成**4二级10三级正式封板正文**，**没有Writer R3**。
4. 第4.3章：独立Writer V1、R2交付；V1审查为`RETURN_CH3_V1_LICENSE_INTEGRATION_AND_DECISION_ACCURACY`（B01–B08），R2为`RETURN_CH3_R2_RESIDUAL_INTEGRATION_AND_EVIDENCE_ERRORS`（C01–C04）。Owner后明确特别授权：“这部分内容暂时由你来修改完成之后嗯，正式冻结，然后填入我们的项目库当中。记得记录相关文档。完成之后开启下一个1级问题的部分。” Reviewer基于Writer R2全文，定向修C01–C04：
   - C01付款Webhooks验签/类型→订单/金额币种/风险与履约资格→可靠记录待办→动作级幂等、失败重试与人工接管，不把事件去重写成“保证不会被重复扣款”；不强制自建队列。
   - C02 Writer R2自检混入旧版4.3.1/4.3.2题目：该旧自检**不可继承**，Reviewer按正式V2逐题重建5二级/11三级索引，记录在[封板证据](docs/CHAPTER3_SEAL_EVIDENCE_20261018.md)；4.3.4直接成节。
   - C03套餐/自托管费用、SaaS合规结算、10%/90%分配、自研“必须”的绝对化表述改为依据真实资格、许可、TCO、技术能力、替代性等分流。
   - C04支付成功和订单可履约、资金结算及银行到账、承运扫描与签收证据、会员权益的独立责任源区分。
   - 顺手修正币种单位、无代码退出验收、经营者资格/第三方账号权限，不改已经正确的GPL/AGPL、Apache/OFL及外包知识主体。
   - 正文创建Commit `779dcffeb95d8a462fb0008abe5109a255774d4f`，正式正文blob SHA `0b78c9eb48634fa3481055dc752cb9c9ee7075f0`；Owner批准封板。**本章从未收到Writer R3交稿**，R3返修ZIP曾备好但未执行。旧审稿[Writer V1 RETURN](docs/CHAPTER3_WRITER_V1_REVIEW_RETURN_20261018.md)和[Writer R2 RETURN](docs/CHAPTER3_WRITER_R2_REVIEW_RETURN_20261018.md)均为封板前历史，不再是当期Gate。
5. 本轮已按Owner要求开启下一一级**4.4《怎么让客户顺利购买和使用？》**，冻结**6二级/13三级**；Reviewer只发布完整独立Writer Gate及8文件离线包，**没有4.4正文，不自行代写**。旧第4.3章Writer Gate与其ZIP登记已退出main当前目录，正常Git历史仍可查。

## 3. 第4.4章冻结任务纲要
**CURRENT_REVIEW（2026-10-19）**：Writer V1原ZIP已交并CRC PASS、正文6/6二级13/13三级严格通过；独立Reviewer结论`RETURN_CH4_V1_TRANSACTION_ACCESS_LEGAL_SOURCE_ERRORS`，8组实质问题：欧盟数字内容撤回权、订单号+邮箱伪双因素、Client Secret与API幂等混同/前台成功即交付、S3预签名URL被误称天然限次、防上传恶意文件绝对化、个人信息缓存和全强制账户/邮件服务、移动Web触控标准及夏令时、核验来源VERIFIED错配。详见[Writer V1独立审核历史和当前R2工作包](docs/CHAPTER4_WRITER_V1_REVIEW_RETURN_20261019.md)。Owner附件R2 ZIP SHA256 `03219cf282793a77b48953563cf762518529a60badcab6d25ed625b1ed05191f`，49,656 bytes，8文件（含原V1全文/原自检）；**4.4当前没有正式封板正文，不启动4.5或HTML**。



- **4.4.1 购买前哪些商品信息必须说清楚？**（1个三级：买前明确内容/时间/限制）
- **4.4.2 规格、套餐和定制选项怎么让客户选对？**（2个三级：价格/库存/交付关联、非法组合纠正）
- **4.4.3 下单时该让客户填写哪些资料？**（3个三级：游客购买、国际地址/电话/日期、错误恢复）
- **4.4.4 上传照片、文件或定制需求，怎么避免出错？**（2个三级：何时收资料、类型/大小/安全/预览更正）
- **4.4.5 客户买完后从哪里查看订单和产品？**（2个三级：正确订单状态和下一步、安全找回）
- **4.4.6 海外不同设备的客户能否用得顺？**（3个三级：手机完整操作、语言/币种/时区、弱网与辅助技术）
- 全部13道三级**逐字原文**在V2正式框架、当前Gate和离线ZIP中；Writer无仓库权限也能完整读到，不从本摘要自行还原冻题。

## 4. 五板块职责和写作质量底线

受众是中国大陆个人开发者、跨境独立站/平台经营者、中小企业。第四板块负责从产品载体、首版范围、技术复用、客户购买使用、商品订单、实际交付、异常到在营维护。①机会市场、②网络/域名服务器、③支付资金财税主体（CLOSED/FROZEN）、⑤获客增长保持各自板块只读；本轮不得修改其正文或状态（父项目仅更新第四板块导航）。

Writer有完整的内容创作自由，须逐字保留冻题，全面回答，区分真实官方规则与教学假设/UNKNOWN，不编造交易/部署/账户状态；不擅自拿真实客户信息或明文卡敏感数据。Reviewer对深广度、正确性、可用性及证据独立冷审，不能仅凭Writer自检FIXED/PASS。若RETURN，必须在同轮交**完整返修ZIP（含上一版Writer全文+核验记录+审核报告+返修指令）及Owner可直接复制提示词**；未经Owner明确批准不封板也不启动4.5或HTML。

## 5. 当前治理面板

- **PROJECT_GOAL：** 产品怎么做、怎么交付？
- **PROJECT_STAGE：** 1/9/48/117框架FROZEN，4.1/4.2/4.3三章已FINAL_SEALED，4.4 Writer V1已交并Review RETURN、R2返修待交，4.5–4.9未启动正文，HTML未启动。
- **SYSTEM_MAP：** GitHub main存冻题、唯一封板正文、封板证据、Gate和交接；Owner本轮对话给离线Writer ZIP，不需要平台授权。
- **CURRENT_ACCEPTED_STATE：** 3个已封板完整章节；4.4无正文，4.5–4.9无正文。
- **CURRENT_GATE：** `CB04-CH4-INDEPENDENT-OFFLINE-FIRST-DRAFT-20261018`。
- **CURRENT_ROLLBACK_STATUS：** Git提交可回滚，历史R1/R2 RETURN和旧Gate不丢失；无源码/付款/真实资源改动。
- **UNRESOLVED：** 4.4 Writer R2完整返修尚未返回，所有需实测的商城流程、支付和客户上传权限均不得凭教材自动视为验收通过。
- **NEXT_STEP / OWNER_ACTION_REQUIRED：** Owner下载第四章R2完整返修ZIP+提示词发独立Writer→Writer在V1基础上完成全章R2正文/逐项核验及ZIP，停在`STOP_AT_REVIEWER`→Reviewer独立审核→Owner决定是否封板。
- **MANDATORY_STOP：** `CH4_R2_WRITER_PENDING`；不提前写4.4、不写4.5、不制作HTML。

[返回第四部分README](README.md)
