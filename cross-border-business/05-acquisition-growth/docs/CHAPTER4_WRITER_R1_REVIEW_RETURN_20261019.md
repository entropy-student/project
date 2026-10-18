# 第五部分·第四章《找客户到底划不划算？》｜Writer R1独立审核与R2返修停点（2026-10-19）

> **REVIEW_RESULT：RETURN_CH4_R1_UNIT_ECONOMICS_ATTRIBUTION_AND_PLATFORM_SCOPE**  
> **CHAPTER4：WRITER_R1_DELIVERED / STRUCTURE_PASS_6_12 / CONTENT_RETURN / NOT_SEALED**  
> **CURRENT_GATE：CB05-CH4-WRITER-R2-DIRECTED-REPAIR-20261019**  
> **FRAMEWORK：OWNER_FROZEN_V2_1_6_35_78（不变）**  
> **CHAPTER1–3：FINAL_SEALED（保持不变）**  
> **OWNER_ACTION_REQUIRED：转交本轮完整R2返修ZIP及提示词给独立Writer，回收R2完整正文和核验记录。**

## 1. 输入与客观验收

- Owner上传`第五部分_第四章_独立Writer交付.zip`：**32,662字节**、SHA256 `309ce4295e3be051ca7233abb2327d47b13e96ba0292661282f698f54eb29df4`、ZIP `testzip()==None`。
- 独立Writer R1**完整正文**：`第五部分_第四章_找客户到底划不划算_Writer完整候选稿.md`，**42,221字节/451行**，SHA256 `02544d1f97806d9458269da462c48d032e1d8b925ec9c8afec8ddc6d942f16ed`。
- 原独立**事实核验及自检**：`第五部分_第四章_事实核验与自检.md`，**25,825字节/226行**，SHA256 `abf0b85ebb8de3deef10f79fa0f6e28c78412776c3ae3d4ea2c6c555c0447643`。
- 与[正式冻结V2](FROZEN_FRAMEWORK_V2_20261018.md)、[第四章Writer首稿Gate](CHAPTER4_INDEPENDENT_WRITER_GATE_V1_20261018.md)核对：**6个二级＋12个三级题目逐字、同序、同层级、同父题PASS**。正文六节齐备、表格/图/案例和相应计算均有实质教学价值。
- 复算正确部分：$480/12=$40与首单$28.50的对比（需满足客户/订单与成本周期对应条件）、$90–26–17.50–4.26–4.50–1=$36.74、$36.74–42=−$5.26、$110/22=5个月；在$n=100,p=.02$时0/1/2/≥3单概率13.26196%/27.06522%/27.34139%/32.33144%；10%每月流失下第7个月累计**期望**贡献跨$110（约6.59个月插值）。数学基本正确，**不得要求推倒重写**。

## 2. R1八项必须修复与三项顺手调整

| 编号 | 定位（原文行号） | 原错误/为何重要 | R2最小验收条件 |
|---|---|---|---|
| **B01 BLOCKER** | §4.3.1 L197–227、§4.4.1 L270–295、§4.5.1 L326–338 | **首单折扣在实收收入与获客CAC中可能重复扣除；“扣CAC后边际贡献”又进入LTV可能造成第二次扣CAC。** | 统一折扣/收入/获客前贡献/扣CAC后贡献的互斥口径；算式与客户LTV可比较，保留$100订单原示例。 |
| **B02 HIGH** | §4.1.2 L73–105、§4.3.1 L197–201 | 当周费用÷当周成交客户未必属于同一获客cohort；将每订单贡献与每新客户成本直接相减没有说明一客一首单假设；可用余额存量≠周现金流流量。 | 明确cohort与观察期、订单/客户区别、可用现金存量及runway所需净现金流。 |
| **B03 BLOCKER** | §4.2.2 L178–187 | 无对照组或混杂控制，把砍半预算后两周自然观察写成“统计显著”和真实增量因果结论。 | 改为仅方向性观察，解释对照/地区测试/其它变量与转化延迟、统计功效，不能凭前后波动宣布渠道无用。 |
| **B04 BLOCKER** | §4.4.2 L307–318、核验§2 L66–67 | PayPal准备金10–20%/90–180天、固定0.9%–1%拒付率全球红线与必然永久冻结半年均是错误泛化；不同于Visa VAMP及收单风控。 | 账户个别条款、支付服务商/卡组织/收单行分别说明；数字标明确实是示例或删去必然结论。 |
| **B05 HIGH** | §4.4.1 L280–289、核验§2 L65 | 4.4%+$0.30是Stripe美国标准条件下国内卡基础费+国际卡附加的一种模拟，非所有国家/商户；汇兑和不同条款有区别。 | 限定US商户和交易场景，1%模拟平台费不作为普遍费用；保留条件计算。 |
| **B06 HIGH** | §4.2 L117–147、L167–176、核验§2 L59–63 | RFC3986不制定UTM，中文可合规percent-encode；GA4首次点击/线性/时间衰减已于**2023-11停用**；优惠码可被分享，事后自述非精确“暗社交”测量。 | 纠正来源映射、标历史归因模型，说明优惠码/自填表局限。 |
| **B07 HIGH** | §4.5 L326–378 | 订阅稳定流失下**cohort期望**回本≠每个客户实际回款；30–50% LTV折扣、6–12个月固定SaaS红线、所有实物必须首单回本均非通用规则。 | 同一贡献口径/稳态假设/现金跑道、客户流失与实际回款区分，删固定普适阈值。 |
| **B08 HIGH** | §4.6.2 L409–438、§4.1.2 L98–105 | 硬推2–3×目标CAC必停、滚动60%/停留2分钟必有意向，90%5秒必无效等；实际投放预算不等同账户自动总封顶。 | 仅作可调整试验假设；纳入产品周期、点击成本、转化延迟、埋点不全、支付/平台日预算超耗，勿当行业统一纪律。 |

**顺手修正：** N01 §4.1的漏斗信号不是唯一因果解释；N02 §4.3.2自有工时替代价是机会成本模型并非现金；N03 §4.4.2海运/客服/拒付固定时限与“永久封号”恐吓用语。

## 3. 已独立查证的官方来源（2026-10-19）

- [Stripe收费](https://stripe.com/pricing)：美国标准卡费及国际卡、货币换算附加规则；不代表每个国家的费率及资格。
- [PayPal账户准备金](https://www.paypal.com/us/brc/article/account-reserves)：10%/90天只是示例，具体按个别账户风险。
- [Visa VAMP正式概览](https://corporate.visa.com/content/dam/VCOM/corporate/visa-perspectives/security-and-trust/documents/visa-acquirer-monitoring-program-fact-sheet-2025.pdf)：卡组织监控不等于任何商家的必然冻结。
- [GA4官方归因说明](https://support.google.com/analytics/answer/10596866)：首次点击、线性、时间衰减已在2023-11停用。
- [GA4活动参数](https://support.google.com/analytics/answer/10917952)、[RFC3986](https://www.rfc-editor.org/info/rfc3986/)：UTM来源标记/URI编码要分开。
- [Google Ads实验结果与统计限制](https://support.google.com/google-ads/answer/6318747)：无明确统计检验不能宣称显著或真实增量。
- 以上核验为公开知识/数学，**未操作真实商户Stripe、PayPal、广告、银行账户，也未全覆盖所有国家费率或全部Visa监管细节**。

## 4. 同轮已经完成的R2完整返修ZIP

- Owner可下载本轮离线包：`第五部分_第四章_R1独立审核与R2完整返修包_20261019.zip`，**43,359字节**、SHA256 `b84e797a4e9b44a73b7588d00e8f1ff1a54b9ddc2dcfedbac8613f223164d81f`、**7份Markdown**；ZIP通过CRC及逐文件与本地源一致性验证。
- 包含**完整451行R1正文、226行原核验**、完整Reviewer审稿报告（SHA256 `fcf74930e520e42047e9f615ac5e874b756eaf8463c39fbeabaa32ff276d93e5`）、R2定向指令、官方出处、Writer可直接转发话术、文件SHA256 Manifest。离线Writer无需GitHub。
- **ZIP二进制只在本次对话附件交Owner，未作为GitHub仓库文件提交**。正式仓库存此R1审核结论与当前执行Gate。若报告留有本地完整版本，请以Owner下载的ZIP中`01_独立Reviewer_R1完整审核报告.md`为更详尽的逐行评价。
- Writer R2必须交**完整R2中文正文Markdown + 完整事实/逐项返修记录Markdown + ZIP**，冻结题目6/12不变，`STOP_AT_REVIEWER`；Reviewer复查，Owner决定是否封板。**本轮未改Writer正文、未创建CHAPTER4_FINAL_SEALED.md、未启动第五章；前三章正式正文与其他四大板块保持不变。**
