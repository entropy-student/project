# New Product Onboarding｜新产品支付接入模板

> 目标：以后任何新产品需要收款时，不再新建一套支付系统，只把它登记到现有 Unified Pay。

## 本项目第一次怎么接

GPT View+ 作为第一个正式接入产品，建议登记为：

```text
app_id: gpt-view-plus
sku_id: pro-lifetime
fulfillment: license
providers: 按统一路由策略选择 Alipay / PayPal / GMPay
price: 上线前由业务方最终确认
```

接入流程：

```text
1. Unified Pay 服务上线
2. Register App: gpt-view-plus
3. Register SKU: pro-lifetime
4. 设置服务端价格 / 币种
5. 设置 allowed origins / extension identity
6. fulfillment = license
7. GPT View+ 调用统一 Checkout / Hosted Checkout
8. 支付成功后 Unified Pay 生成 entitlement / license
9. GPT View+ 查询并激活 Pro
10. 跑一笔低金额 E2E 后上线
```

产品端不再实现 Provider Secret、Webhook 验签、支付账本、退款账本或主动对账。

## 下一个项目时怎么交代

最短指令：

> 这个新项目需要收费。请复用 `entropy-student/project/unified-pay-system`，不要新建支付系统。把它作为一个新的 App + SKU 接入 Unified Pay，并沿用统一 Hosted Checkout、支付状态、退款/对账和履约体系。

如果信息已经确定，可直接补：

```text
项目名：<name>
app_id：<slug>
sku_id：<sku>
价格：<amount + currency>
支付后得到：<权益/次数/订阅/实物订单动作>
履约方式：license / webhook / 请你判断
前端来源：<domain / extension id / app>
```

示例：

```text
这个项目要接支付，复用现有 Unified Pay，不新建新的支付服务。
项目名：Relationship Quiz
app_id：relationship-quiz
sku_id：single-report
价格：9.9 CNY
支付后得到：1 次报告生成资格
履约方式：请你判断
前端来源：https://example.com
```

## 新产品标准接入动作

```text
Register App
    +
Register SKU
    +
Configure server-owned price
    +
Configure allowed origins
    +
Select merchant profile / provider route
    +
Configure fulfillment
    +
Integrate Hosted Checkout / shared API
    +
Run one E2E
```

## 两种履约方式

### license
适合插件、桌面工具、买断 Pro、简单数字权益。

Unified Pay 直接签发/撤销 entitlement 或 license。

### webhook
适合 SaaS、报告生成、额度充值、网站账户、复杂业务状态。

Unified Pay 在标准支付状态确认后，向产品后端发送签名 fulfillment event。

## 默认原则

- 默认只部署一套 Unified Pay。
- 不因“新产品”而新建支付数据库或 Provider 集成。
- Provider Secret 只存在 Unified Pay 的 Secret Store。
- 商品价格由 Unified Pay 服务端配置，客户端不可自行决定成交金额。
- 新产品优先使用 Hosted Checkout，避免重复写支付 UI。
- 只有法律主体、数据驻留、合规边界或高风险隔离要求不同，才考虑拆第二套支付中台。
