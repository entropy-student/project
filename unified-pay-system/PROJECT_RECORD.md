# Unified Pay System — Project Record

> 这是本项目的长期项目记录。继续开发前优先查看本文件与 README。

## 项目定位

Unified Pay System 被正式定义为**共享支付中台 / 内部 Payment-as-a-Service**，而不是 GPT View+ 的专属支付代码。

最终目标：

```text
任意产品
  ↓
统一 Checkout
  ↓
统一 Provider Routing
  ↓
统一支付状态账本
  ↓
统一 License / Entitlement / Fulfillment
```

## 2026-09-08 关键决策

### 决策 1：Project 大仓库边界

`entropy-student/project` 是项目资料与多个项目的总仓库。

规则：

- 根目录只做项目导航与仓库级配置。
- Unified Pay 不得占用根目录。
- Unified Pay 的 Dockerfile、bundle、config、Railway 文档与部署材料全部归入 `unified-pay-system/`。
- 历史部署中间文件统一放到 `unified-pay-system/_archive/`。
- 大仓库首页展示风格参考 `entropy-student/spike.skill`：居中标题、状态 Badge、项目索引表、基本结构、命名规范、使用方式与设计原则。

### 决策 2：支付能力只建设一次

以后新增网站、插件、App 或其他数字产品时，默认**不重新搭建一套支付系统**。

新增产品的标准动作：

```text
Register App
  + Register SKU
  + Configure allowed origins
  + Configure fulfillment
  = 接入完成
```

支付 Provider、Webhook 验签、数据库、退款、争议、对账、重试与 License 由 Unified Pay 共享。

### 决策 3：共享 Hosted Checkout

长期建议提供统一支付页面，例如：

```text
https://pay.<domain>/checkout/<token>
```

产品只负责向 Unified Pay 请求 checkout token，然后跳转到统一收银台。这样产品端甚至不需要分别实现 PayPal / GMPay / Alipay UI。

### 决策 4：两类履约模式

1. `license`
   - 插件、桌面工具、买断型数字产品。
   - Unified Pay 直接发 License / Entitlement。

2. `webhook`
   - SaaS、网站账户、复杂业务。
   - Unified Pay 向产品后端发送签名履约事件。

### 决策 5：固定“新产品支付接入协议”

未来新项目需要收费时，默认指令为：

> 复用 `entropy-student/project/unified-pay-system`，不要新建支付系统。把当前产品作为新的 App + SKU 接入 Unified Pay，并沿用统一 Hosted Checkout、支付状态、退款/对账和履约体系。

详细模板保存在：

`docs/NEW_PRODUCT_ONBOARDING.md`

GPT View+ 作为第一个正式接入产品，当前约定：

```text
app_id: gpt-view-plus
sku_id: pro-lifetime
fulfillment: license
price: 上线前最终确认
```

## 当前生产状态

| 环节 | 状态 |
|---|---|
| Unified Pay V0.18 | ✅ |
| Syntax | ✅ 48 / 48 |
| Tests | ✅ 97 / 97 |
| GMPay Edge | ✅ |
| TRON / USDT Receiving | ✅ |
| GMPay API credential | ✅ |
| Supabase migrations | ✅ |
| Supabase RLS hardening | ✅ |
| Project 仓库整理 | ✅ |
| Railway project/service | ✅ |
| Railway build | ⏳ Docker context 排错 |
| Public API domain | ⏳ |
| GMPay webhook | ⏳ |
| Real low-value E2E | ⏳ |
| GPT View+ automatic entitlement | ⏳ |

## 当前 Railway 资源

```text
Project: unified-pay
Service: unified-pay-api
Environment: production
Repository: entropy-student/project
Project root: unified-pay-system/
```

## 当前 Provider 策略

- China: Alipay（审批 / 正式产品接入中）
- Overseas: PayPal
- Crypto: GMPay / USDT
- WorldFirst: settlement / FX，除非 Global Checkout 获批
- WeChat: deferred

## 安全边界

不得进入 GitHub 或聊天记录的秘密：

- GMPAY_SECRET_KEY
- PayPal Client Secret
- Alipay private key
- wallet private key / mnemonic
- database password / password-bearing DATABASE_URL
- ADMIN_TOKEN
- CHECKOUT_TOKEN_SECRET
- LICENSE_ENCRYPTION_KEY

## 下一步

1. 让 Railway 以 `unified-pay-system/` 为完整构建上下文重新部署。
2. 配置运行时 Secret。
3. 验证 `/health` 与 `/ready`。
4. 创建公网域名。
5. 配置 GMPay webhook。
6. 完成小额真实 USDT E2E。
7. 把 GPT View+ 作为第一个正式 `app_id` 接入。
8. 后续产品统一走 App + SKU 注册流程，不再新建支付项目。
