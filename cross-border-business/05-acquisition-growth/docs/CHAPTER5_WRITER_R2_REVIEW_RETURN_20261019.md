# 第五部分第五章《怎么让老客户再买、带来新客？》｜独立Writer R2审核（2026-10-19）

> **后续Owner授权的历史状态更新（2026-10-19）：** 本报告中的`RETURN / NOT_SEALED / 等待Writer R3`仅代表当时Writer R2候选的审核结论。Owner随后明确授权Reviewer直接修订并正式封板第⑤章；现行唯一权威正文：[CHAPTER5_FINAL_SEALED.md](CHAPTER5_FINAL_SEALED.md)，修订证据：[CHAPTER5_SEAL_EVIDENCE_20261019.md](CHAPTER5_SEAL_EVIDENCE_20261019.md)。**不存在独立Writer R3交付，也不应再要求R3**；当前唯一下一步是[第六章独立Writer Gate](CHAPTER6_INDEPENDENT_WRITER_GATE_V1_20261019.md)。原审稿正文留存供审计。

> **REVIEW_RESULT：RETURN_CH5_R2_REVIEW_SOLICITATION_REFERRAL_ECONOMICS_AND_PROJECT_BOUNDARIES**  
> **CHAPTER5：WRITER_R2_DELIVERED / FROZEN_5_11_QUESTIONS_PRESENT / EXTRA_H2 / CONTENT_RETURN / NOT_SEALED**  
> **CURRENT_GATE：CB05-CH5-WRITER-R3-MINIMAL_REPAIR-20261019**  
> **FRAMEWORK：OWNER_FROZEN_V2_CORE1_L1_6_L2_35_L3_78（未更改）**  
> **CHAPTER1–4：FINAL_SEALED（保持原样）**  
> **OWNER_ACTION_REQUIRED：转发本轮R3完整离线返修ZIP及提示词；回收R3完整正文/核验ZIP供Reviewer独立复核。**

## 一、交付、结构、值得保留的内容

- Owner上传 `第五部分_第五章_Writer_R2完整交付.zip`，**39,985字节**，SHA256 `fe244e4a1a2d6d4f29225050ca21b8fe3eb1e91c8fcca6e2f8f1428f837b81b7`，ZIP CRC `testzip()==None`。
- Writer R2完整正文**45,154字节/423行**，SHA256 `218517e2912b21b2d290425d3643448c0ee78f72b3430c604c432c02685c8b29`。完整事实核验**40,703字节/210行**，SHA256 `59686ff4c66219651069f1bbe8741fafda0a32abd19432d83688b01282dfbf6c`。
- 核对[正式冻结V2框架](FROZEN_FRAMEWORK_V2_20261018.md)：**5个二级/11个三级原题逐字、顺序、归属均存在**；原R1的`## 引言`已降为正文导语。但R2结尾`## 本章自检与落地行动清单`为**新增额外H2**，所以实际6个H2/11个H3，严格层级未通过；建议改为普通加粗文本并保留清单内容。
- 正文12个Markdown代码围栏成对。已有效解决R1的大部分问题：FTC 2024 Click-to-Cancel修订规则2025年法院撤销的现行状态；英国ICO soft opt-in五项条件；FTC评价压制条款的适用范围；转介绍金额统一为原价$120、新客优惠$18、储值金$20；服务与营销通知区别。**全部已正确章节、例子、图示和算术应保留，不推倒重写**。

## 二、R2剩余六组必修（原稿行号及最小验收）

| ID | 严重程度 | R2原文定位及事实问题 | 最小修订验收 |
|---|---|---|---|
| **B01** | BLOCKER | 正文**§5.3.1 L228–230**再次声称`0.9%–1%`统一争议率会导致Stripe/PayPal永久冻结。Visa VAMP使用欺诈＋争议计数比率，按地区、最低笔数和时点判断；支付服务商自身风控亦不等同VAMP。 | 删除固定红线与必然封禁；用Visa官方2026适用条件或直接引用已封板第四章知识边界，正文/核验同步。 |
| **B02** | HIGH | 正文**§5.4.1 L262–280（含Mermaid）**只捕捉满意“高光客户”来邀请公开评价。FTC索评指引反对仅邀请预计会给好评者；Trustpilot 2026-09与Google平台明确禁止正向偏选/只邀请满意者。 | 区分对符合条件的客户公平征集**公开评价**与经当事人许可后使用的**个别正面证言**；改图/示例/核验，征评时点不按正向情绪筛选。 |
| **B03** | HIGH | **§5.4.2 L289–300、核验§4/8**：`$102−$60−$20=$22`数学正确，但把潜在未来兑换的$20券面值当已确认法定负债，且把$22说成已实现正向现金毛利/全部扣费后健康利润、保证后续复购。 | 把`$42`定位为当前订单在本例已列成本后的贡献空间，`$22`定位为**额外为$20奖励预留保守预算后的剩余空间**；与法定会计收入/负债和实际现金流分开，提醒未计支付费/退款/其它营销成本，兑现奖励不得重复扣除。 |
| **B04** | HIGH | **核验§6 L124–132、正文L5**：将Owner正式五板块误写为“经营准备、海外工作环境、域名与邮箱、网站与程序运行”，并把SMTP错误归入主体支付税务。 | 使用正式五板块：①机会挖掘与市场判断、②网络环境搭建、③支付税务与经营主体、④产品搭建、⑤获客与用户增长；纠正文中技术边界，已封板章节保持不变。 |
| **B05** | MEDIUM-HIGH | 正文**L414**仍有未经冻结的`## 本章自检与落地行动清单`，事实核验却声称“只有5个H2”。 | 保留6条清单，将清单标题改为普通加粗段落；严格核验全篇**恰好5个H2、11个H3，正式题原文、顺序、层级不变**。 |
| **B06** | HIGH | **§5.5.2 L392–403**及核验将“立即取消订阅/关闭账号/彻底删除所有个人数据”视为同一无条件义务，称GDPR删除权均须无条件履行。欧盟委员会明确**删除权非绝对**，可能有法定保留义务和法律争议例外。 | 区分取消订阅、关闭服务和个人数据删除请求；依法受理/验证、在期限内回应，承认法定保留和法律争议等例外，不能建议销毁税务/合同证据。 |

## 三、三组顺手修正

- **N01** 正文§5.4.2 L303–307、核验L66/L89：区分**公开评价的奖励禁令**和**销售转介/联盟返佣计划**，不能用Amazon评论规则推出所有平台“任何站外利益引流一律禁止”，也不能把Google Reviews当作购物平台；依商家真实所在平台与渠道核查。
- **N02** 正文§5.3.1 L211–217：第43天补货提醒的数学正确，若含促销/复购广告，应另具实际电子营销许可并遵守退订；`MODEL_ASSUMPTION`不表示邮件合法发送资格。
- **N03** §5.5.1 L355–361 35/25/25/15饼图需就地标`MODEL_ASSUMPTION`，不暗示有实际跨境流失分布；“推荐一定胜过广告、老客成本趋近0、未来回流概率极高”等结论改为可能性/需证据。

## 四、R1修复继承核验

- **R1 B01 (FTC Click-to-Cancel失效)**：PASS；**B02 (FTC §465.7适用)**：PASS_WITH_NOTE，新B02公共评价选择性索评；**B03 (UK soft opt-in)**：PASS；**B04 (奖励数字)**：PARTIAL，算术一致但现金会计混用；**B05 (营销退订)**：PASS_WITH_NOTE，续订邮件需许可；**B06 (提醒时间)**：PASS，60−12−5=43且为模型；**B07 (推荐及评价绝对结论)**：PARTIAL，公评偏选未纠；**B08 (退出权)**：PARTIAL，数据删除非绝对。
- **旧N01额外引言H2**改了，但产生章末H2；**旧N02登录**已处理；**旧N03券成本**仍混淆现金/负债；**旧N04自检**仍每项自称“完全合格”未识别以上风险。

## 五、一手来源及适用边界

- [Visa VAMP Fact Sheet（2026-04-01适用变化脚注）](https://corporate.visa.com/content/dam/VCOM/corporate/visa-perspectives/security-and-trust/documents/visa-acquirer-monitoring-program-fact-sheet-2025.pdf)。
- [FTC索评/付费评价官方指导](https://www.ftc.gov/business-guidance/resources/soliciting-paying-online-reviews-guide-marketers)、[FTC消费者评价规则FAQ](https://www.ftc.gov/business-guidance/resources/consumer-reviews-testimonials-rule-questions-answers)：具体Rule范围与FTC Act一般规则需分开。
- [Trustpilot 2026年9月商家指引](https://corporate.trustpilot.com/legal/for-businesses/guidelines-for-businesses/sep-2026)；[Google Business Profile禁止选择性索评](https://support.google.com/business/answer/7400114)。
- [欧盟委员会删除请求及例外](https://commission.europa.eu/law/law-topic/data-protection/information-business-and-organisations/dealing-requests-individuals_en)；[UK ICO soft opt-in五条件](https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/guidance-on-direct-marketing-using-electronic-mail/how-do-we-comply-with-the-pecr-electronic-mail-marketing-rules/)。
- [FTC Click-to-Cancel规则被撤销的2026公报](https://www.govinfo.gov/content/pkg/FR-2026-03-13/html/2026-04952.htm)、[加州司法部2025自动续费提醒](https://oag.ca.gov/node/608083)。R2上述两个动态事实基本正确，R3不得倒退。

## 六、完整R3最小离线返修包与现行停点

- ZIP：`第五部分_第五章_R2独立审核与R3最小返修包_20261019.zip`，**52,253字节**，SHA256 `85bca6b385635d022f253fa645038555393d3f9e0ae220f35e9c3757388e7815`，7份Markdown，ZIP `testzip()==None`，各文件逐字节一致。
- 包内**原封不动的R2正文423行与完整核验210行**、本Review详细内容、R3精确任务、官方依据、可直接复制提示词与逐文件SHA256清单。Writer离线无需GitHub；**ZIP二进制只在当前对话交Owner，不声称上传GitHub**。
- Owner转交ZIP及提示词 → Writer仅据**B01–B06/N01–N03**最小修订，提交完整R3正文/核验及ZIP，`STOP_AT_REVIEWER` → Reviewer复核 → Owner决定是否封板。**本轮不修改Writer正文、不创建第五章正式封板文件、不启动第六章；V2冻结题树与第①—④章正式正文均不变。**
