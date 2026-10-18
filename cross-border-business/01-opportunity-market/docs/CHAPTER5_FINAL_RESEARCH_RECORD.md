# 第一部分第⑤章｜最终事实核验及定向修订记录

> **FINAL_SEALED / OWNER_AUTHORIZED_DIRECT_REPAIR** · 2026-10-19
> Writer仅提交R1、R2；2026-10-19 Owner授权Reviewer针对R2审核中6组阻断直接修正并封板。**无Writer R3交付。** R2原始研究/算式代码已被Reviewer证明部分不可靠，不得与本最终版本混用。

## 一、六组Reviewer R2遗留问题逐项修正

| 问题 | Reviewer定向修复 | 验收 |
|---|---|---|
| R2-01 库存及现金流 | 首批500件第3月入库，第3/4/5月销量100/250/150，总计500；第4月订第二批500，第5月付尾款且尚在途，第6月才入库。每笔100美元收款对应3.20支付费＋9.50派送＋3.00平台插件费＋3.80退款/争议预算，每单简化可用现金流80.50；广告、固定费与采购支出按月另列；六个月期末余额24500、18700、8750、9100、14175、10750美元；最低8750。不同于旧版90/件、700件与26100余额。 | PASS |
| R2-02 退货重复成本 | 原手续费已对所有初始单记账，不能在退款增量中再次扣2.04。收入冲回0.08×60=4.80；新增逆向操作0.08×(7＋0.6×3＋0.4×1)=0.736；总增量5.536≈5.54/初始单。保留可售存货及残值真实核算的限制，勿与5%示例拨备叠加。 | PASS |
| R2-03 Stripe争议收费 | 官方区分收到争议fee与人工抗辩fee；满足条件胜诉返还的是countered fee，不保证收到争议fee返还。0.375/单仅为0.5%争议、全败诉、不抗辩、其他已计费用另处理的窄模型。 | PASS |
| R2-04 SaaS回收 | 16/33.42≈0.48是稳定续费假定下的“月度贡献等值回收期”，不是半个月就收到实际现金；须按Shopify账单和银行打款核查。 | PASS |
| R2-05 CCC | DIO＋DSO－DPO是基于财务平均余额的指标；Day0→127仅为本假设现金收付跨度127自然日，不能以这段日历直接称报表CCC=127。 | PASS |
| R2-06 销售税 | 取消“多数州统一10万/200笔”旧规则，区别分州经济联结、加州>50万美元示例、州内存货等实物联结及市场平台代征。 | PASS |

## 二、独立官方核验与来源支持范围（2026-10-19）

- Stripe dispute received/countered收费条件与返费机制：https://stripe.com/pricing 、https://support.stripe.com/questions/dispute-fees-faq 。美国标准示例费率不能套给全球及其他合同。
- Shopify周期性App计费与收益显示（可能多至37天）：https://shopify.dev/docs/apps/launch/distribution/track-app-usage 。Dashboard出现收益不代表银行已入账。
- 加州CDTFA远程销售、实物存在与Marketplace Facilitator边界：https://www.cdtfa.ca.gov/industry/MPFAct.htm 、https://www.cdtfa.ca.gov/industry/local-and-district-retailer-taxes/online-retailers-registration-and-local-tax.htm 。其他州需逐州查。
- Visa VAMP于2026年4月对指定区域修改过量比率的事实：https://corporate.visa.com/content/dam/VCOM/corporate/visa-perspectives/security-and-trust/documents/visa-acquirer-monitoring-program-fact-sheet-2025.pdf ，不应声称所有市场统一使用一个触发值。
- USPTO境外住所申请人代理：https://www.uspto.gov/trademarks/basics/why-hire-private-trademark-attorney 。区分国籍和domicile。
- 本文出厂价、运价、广告CAC、售价、库存时间、收费周期均为**MODEL_ASSUMPTION**；真实政策只经本表所列范围核实，不代表可保证盈利或实际现金入账。

## 三、可独立运行的模型回归测试

```python
from decimal import Decimal as D
# preserved 4-business archetypes
assert D('60')-D('48.24')==D('11.76')
assert D('49')-D('24.67')==D('24.33')
assert D('39')-D('21.58')==D('17.42')
assert D('350')-D('170.45')==D('179.55')
# return: original payment fee is booked before return branch
rev=D('60')*D('0.08')
extra=D('0.08')*(D('7')+D('0.6')*D('3')+D('0.4')*D('1'))
assert rev==D('4.80') and extra==D('0.736') and rev+extra==D('5.536')
# subscription contribution-equivalent, not bank receipt timing
assert (D('16')/D('33.42')).quantize(D('0.01'))==D('0.48')
unit=D('100')-D('3.20')-D('9.50')-D('3.00')-D('3.80')
assert unit==D('80.50')
sales=[0,0,0,100,250,150]
stock=0
cash=D('30000')
expenses=[5500,5800,9950,7700,15050,15500]
expected=[24500,18700,8750,9100,14175,10750]
for m in range(6):
    if m==3:stock+=500
    assert stock>=sales[m],(m,stock,sales[m])
    stock-=sales[m]
    cash+=unit*sales[m]-D(expenses[m])
    assert cash==D(expected[m]),(m,cash,expected[m])
assert sum(sales)==500 and stock==0 and min(expected)==8750
# batch 2 is in transit at end of month 5, available in month 6 only
assert 127-0==127  # elapsed real days, NOT a financial CCC
assert 471*100==47100
print('PASS: finance, return-loss, inventory availability, 6-month cash and threshold checks')
```

## 四、版本指纹及编辑责任

Writer R2正文SHA256：`ba04743df1bb641032b56cbf8090393bf6942f595d01012ee3fe5f1a8b610de3`；Writer R2资料记录SHA256：`8b405b1fe1625c334e8c20936d6405a1b3c0cf2743b9f10c8c6dfb03ab37f6f5`。
Reviewer封板正文SHA256：`10a726501e026f88468fcf9ec695fb7b6f624c5e573dfdaadf9e38c6beece9b2`。
正式记录不重新复制已过时的R2财务脚本，避免一份文档同时宣称错误的90/件或26100期末余额依然有效；历史R2研究仍保存在Owner交付ZIP与Reviewer返修ZIP中，按上述指纹可追溯。
