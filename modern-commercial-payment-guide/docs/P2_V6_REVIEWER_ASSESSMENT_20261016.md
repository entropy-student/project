# P2① V6完整稿｜独立Reviewer逐项验收与目标差距（2026-10-16）

> **ROLE：** Independent Reviewer，非Executor；不代表真实读者。  
> **FORMAL OUTCOME：`REVIEWER_PASS`**，仅指 Gate `MCPG-P2-V6-READER-FRIENDLY-FULL-RERUN-20261016` 的**V6框架/旧稿内容保真/内容与编辑质量/证据范围**。  
> **P2①正式冻结：`OWNER_FINAL_REVIEW_PENDING`**；真人愿意读及读后掌握知识方法两项目标 `UNVERIFIED`。  
> **PR：** [#132](https://github.com/entropy-student/project/pull/132) Open/Draft/未合并，head `dd40ca89ecdffff195f43e3d00c84fa3dee2ada8`。  
> **主稿：** [P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md](https://github.com/entropy-student/project/blob/dd40ca89ecdffff195f43e3d00c84fa3dee2ada8/modern-commercial-payment-guide/docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md) Blob `777c5ab45e4f2d748c45a1e524bf172fca467967`，22,702字符、321行。

## 1. 权威版本与预检SHA偏差——RECONCILED / PASS

- GitHub main 现行 `REVIEWER_HANDOFF.md`整文件 Blob `2c8daae15e1efb456d72ddb854e31b02878a118b`；Gate当时记录的旧整文件Blob `17c59ea2e97fe8ff0ce379909cd7c8349e084d37`，并非字面相同。
- **经独立抽取：** GitHub main Handoff **第二至四节V6正式冻结的全部7一级/29二级/42三级内容**与独立 `docs/FROZEN_FRAMEWORK_V6_20261016.md` Blob `8c7e1d20c4c423cb07a26fca1868b3f3821c3c62` 相等；此版本差异源于Gate发布/交接状态写入Handoff其余段落，并**没有影响Executor需要依据的正式冻结问句**。因此是 `MANAGEMENT_METADATA_DRIFT_RECONCILED`，而不是失去受审核内容基线的 `RETURN_PREFLIGHT_DRIFT`。这不是对未来所有整文件SHA变化的通用豁免。
- PR的指定执行前基线 `78d8ff48ec019bc051e59eb768f175f384a60a43` 与两份旧稿SHA已核验，最终head仍Open/Draft，未合并。

## 2. Gate范围、证据、原稿保真——PASS

GitHub compare `78d8ff48ec019bc051e59eb768f175f384a60a43`→`dd40ca89ecdffff195f43e3d00c84fa3dee2ada8` 共2个提交、仅2个文件：
- **新增** `docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md`：+320行/-0，Blob `777c5ab45e4f2d748c45a1e524bf172fca467967`。
- **追加** `EXECUTION_EVIDENCE.md`：+51行/-0，旧Blob `15064d3d0ce2f56d85c040e0a72854070ad1bcea` → 新Blob `05a463ae551e18e08f3d1d03b3eac12e6ebc88cc`，Reviewer读出旧内容是新内容的完整前缀，未删改审计历史。
- 旧V5+Humanizer整稿 `76c0ba0e50adc5377d60f003b479a8b6f7b56c10`、旧系统性知识稿 `f8bb110f07ef654df2f5b4b9285540e89261b1f7`及human-writing整稿 `7924e80634f1f09a5628a78458c43a90d5019fd1` 均保留在PR树；旧诊断与试读工具未变。本轮不改生产/银行/商户账户、不执行P3–P5。

独立从V6快照抽取第①板块正式标题并解析新稿：**1H1、5知识H2、9H3、1来源H2全部16条原文字面/层级/顺序匹配**；七个原H4逐字同序；原93行Markdown表格逐行原文同序；原25个外部URL按顺序全等；全部S01–S15来源原样存在。两完整案例以及额外三个典型业务方向仍在。

## 3. 九项V6新手问句：正文自测及认知阻力

**性质：** Reviewer已从头至尾阅读现稿并逐节寻找“直接回答—判断方法—适用边界”。它证明的是文本内证据充分，不是真实新手脱稿试读。

| V6小节 | 读者第一段是否直接回答 | 方法/重要边界仍在何处 | Reviewer文本判断 |
|---|---|---|---|
| 1.1 卖什么、卖给谁、在哪里卖？ | **是**；L13给“会影响”并举国内现货/海外订阅/平台 | L15–27 七维交易画像、29美元实物及5000美元B2B的适用差异 | `SUPPORTED`，表格密度偏高 |
| 1.2 哪些条件必须、哪些可按费用比较？ | **是**；L31列主体/商品/客户付款/合法收款/退款责任 | L33–37硬/软条件与YES/NO/UNKNOWN判断 | `SUPPORTED` |
| 2.1 自收、平台、第三方作为卖方的区别？ | **是**；L43明确销售方、收银台及责任 | L45–60四模式与五类业务，平台并不自动是MoR | `SUPPORTED` |
| 2.2 Visa/PayPal/Stripe/银行角色？ | **是**；L64逐一解释 | L66–89两方向链、退款反向链、角色表、Shopify与WorldFirst | `SUPPORTED`，术语仍多 |
| 3.1 经营主体、商品、地区会限制吗？ | **是**；L95强调真实资格和HK账户≠HK Stripe主体 | L97–110身份/品类/地区矩阵、PayPal协议、Shopify中国受邀 | `SUPPORTED` |
| 3.2 怎样确认合法到款及退款责任？ | **是**；L114给六节点原则与反向退款路径 | L116–132完整到银行与争议回流、YES/NO/UNKNOWN | `SUPPORTED` |
| 4.1 扣完支付费及提现到手多少？ | **是**；L138给G/T/A/B及同主体对照条件 | L142–207费用多组演算、最低门槛、企业35美元限制与MoR角色 | `SUPPORTED`，L138与L140有少量重复 |
| 4.2 除手续费还要比较什么？ | **是**；L211覆盖客群、到账、退拒付和中断 | L213–220四类风险、3单87美元纯销售额情景 | `SUPPORTED` |
| 5.1 怎样选主用和备用？ | **是**；L226直接限定主/备合格与独立结算 | L228–292四轮方法及两完整独立案例；UNKNOWN不被写成已获准 | `SUPPORTED`，完整案例位于第5节较晚 |

整体**不是只改14个H2/H3标题**：与旧V5直接逐行对照，新稿开篇、九个首段及§3.2/§4.1/§5.1若干过渡句确有内容适配。保留了原来的实操方法，不为不同真实自然人提供私人开户保证。

## 4. 财务/现实资格再核验——PASS（针对既有规则和条件示例）

Reviewer额外从正文验证 **17个**算术中间量与结果，无数字不一致：
- `29×4.4%+0.30=1.576`，按分例示1.58，费后27.42；5单137.10<150；6单164.52，**合适企业账户**扣35得129.52；10单274.20-35=239.20；100单2742-35=2707；企业每批35摊6/10/100单分别5.83/3.50/0.35。
- PayPal先进卡 `29×4.1%+0.30≈1.49`；仅符合资格的HK Stripe国际卡 `29×(3.4%+0.5%)+0.30≈1.43`；Paddle软件MoR `29×5%+0.50=1.95`、10单初步270.50；Shopify**假设**2%对应0.58；多3单29美元增加87**销售额而非利润**。
- **PayPal公开源** https://www.paypal.com/c2/business/paypal-business-fees?locale.x=zh_C2 仍说明2025-06-18修订、只适用特定CN协议账户（非其他支付服务协议账户）、国际交易4.40%+对应USD$0.30、高级版4.10%另需申请、企业账户大陆美元电汇35美元/笔，不能将其套给自然人。
- **Shopify官方** https://help.shopify.com/en/manual/payments/shopify-payments/supported-countries/china 及 `/requirements` 显示中国版Payments仍为受邀early-access、大陆企业跨境销售、接入WorldFirst并验证；非通用Stripe商户资格。
- **Paddle公开价** https://www.paddle.com/pricing 仍显示标准5% + US$0.50/checkout，作为软件MoR合同而非自收单。所有商家审批、真实提现、银行和汇兑报价、退款频率未知项仍应保持 `UNKNOWN`。

以上是对文章既有的公开条款/条件数学审查，**不是对任意具体账户的收款有效性验证**。尚无真实交易、银行卡到账或真人试读证据。

## 5. 已知欠缺、是否需要再次改稿

**正式非阻断编辑意见：**
1. L13后立刻进入7维表，普通初学者第一章认知负担大；真实愿读尚未验证。
2. §4.1有四段长费用对照与多表，L138及L140围绕“29美元≠到账金额、G/T/A/B”解释略显重复；适合以后有真实阅读反馈再作轻量合并。
3. 两完整案例集中于§5.1，虽开篇L7已预告，但是否足以吸引新手读到末尾 `UNVERIFIED`。
4. 实际读者愿读/理解无法由文本内部9项`SUPPORTED`推导出 `PASS`。若Owner以后要真实试读，旧无提示试读工具可用作基础，但要检查题目引用的冻结旧标题与当前V6是否有关。

**决定：** 以上没有推翻Gate要求的知识/结构/参考来源与方法论，也不构成另一次全章Humanizer/重复改写的充分依据。**不派新Executor，不更改原稿。** 把最新V6稿交Owner阅读全文作最终接受/冻结决定；如Owner反馈精确小节问题，再单独设小修Gate。

## 6. 当前项目状态、回滚、权限

- `MCPG-P2-V6-READER-FRIENDLY-FULL-RERUN-20261016 = REVIEWER_PASS`；
- `PROJECT_STAGE = P2_V6_FULL_CANDIDATE_OWNER_FINAL_REVIEW_PENDING`；
- Owner**正式冻结的是V6 7/29/42目录**；第①板块V6正文仍待Owner亲自批准，不能混同。
- **回滚：** 新稿独立新增，可只撤下新路径并保持所有旧稿；Evidence仅追加更正，不reset、不force。PR #132继续Open/Draft/未合并。
- **下一步：** Owner阅读 [V6完整正文](https://github.com/entropy-student/project/blob/dd40ca89ecdffff195f43e3d00c84fa3dee2ada8/modern-commercial-payment-guide/docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md)，给出正式冻结或具体修改意见；**无需**继续下发Codex。Owner不做明确后续授权前，不合并PR、不进入其余板块/P3–P5。
