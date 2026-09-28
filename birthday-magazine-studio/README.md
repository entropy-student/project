# Birthday Magazine Studio（生日纪念杂志）

> **Current project truth:** [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md)  
> **Start here:** [00_START_HERE.md](./00_START_HERE.md)  
> **Document authority:** [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md)

## 产品目标

让送礼者上传照片并回答结构化问题，获得一份完整、可送出的个性化生日纪念杂志 PDF，而不需要自己完成写作和排版。

已冻结的 MVP 方向：

- 美国优先、英语首发；
- 数字 PDF；
- 测试价 **US$39.99**；
- 付款前浏览器本地确定性预览，**0 模型调用**；
- WordPress + WooCommerce 为 canonical commerce/order system；
- 官方 WooCommerce PayPal Payments 为首个支付路径；
- authenticated customer account 为 MVP 私有访问模型；
- 服务端确认 paid + intake complete 后，才允许创建唯一 generation-ready job；
- AI 负责基于用户资料生成结构化文案；确定性模板负责 12 页排版/PDF；
- 实体印刷后置；
- 生产 AI API/provider 由 Owner 后续提供接口后单独接入。

## 当前进展

| Gate | 状态 |
|---|---|
| P0 Governance / Truth Reconciliation | PASS |
| G1 Product / Offer Baseline | PASS |
| G2A1 Frontend / component feasibility | PASS |
| G2A2 MVP Product Contract | PASS |
| G2B Real-AI content → 12-page PDF Solution Proof | PASS |
| G3A WooCommerce commerce/account/private-workspace loop | PASS |
| G3B PayPal Sandbox + paid entitlement + refund | **PASS** |
| G3BR1 Payment reconciliation + entitlement/refund closure | **PASS** |
| G4 Live PayPal Canary | HOLD |
| G5 Acquisition / economics | HOLD |
| G6 Production hardening / scale | HOLD |

G3B Sandbox 闭环已经通过：

```text
1 completed USD 39.99 Sandbox capture
→ Woo/provider correlation PASS
→ paid + intake incomplete => 0 job
→ intake complete => exactly 1 deferred job
→ repeated evaluation => still 1
→ one Owner-authorized full Sandbox refund
→ provider/Woo refund correlation PASS
→ entitlement revoked / canonical job cancelled
→ scoped cleanup PASS
```

这仍然**不是 Live/真钱支付证据**。G4 Live PayPal Canary 目前保持 HOLD。

## 已证明的技术能力

- Good Issue-style free preview 可在 WordPress/WooCommerce 中复用；
- WooCommerce USD 39.99 virtual product/cart/checkout/account loop；
- checkout-created/attached customer account；
- order-bound private workspace：owner 可访问，unrelated account / guest 直链拒绝；
- 真实交互式 AI 内容可通过 schema + grounding，进入确定性 12 页 US Letter PDF pipeline；
- PayPal Sandbox merchant connection、HTTPS test origin 和 Sandbox checkout path 已进入实际测试；
- 未付款状态不会创建 generation job；
- 当前测试流程的产品模型调用数保持 0。

## 尚未证明 / 后置

- PayPal Live / real-money transaction Canary；
- production concurrent/atomic job idempotency；
- unattended production AI provider 与 provider-spend idempotency；
- 生产对象存储、最终私有 proof/final PDF delivery；
- 生产部署与恢复；
- 真实获客转化与单位经济性。

## 当前工作文档

- [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — **唯一当前项目真相**
- [EXECUTOR_HANDOFF.md](./EXECUTOR_HANDOFF.md) — Executor 实际执行事实
- [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) — 详细脱敏证据
- [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md) — 所有文档角色与状态
- [docs/MVP_PRODUCT_CONTRACT.md](./docs/MVP_PRODUCT_CONTRACT.md) — 冻结 MVP 产品合同
- [docs/TECHNICAL_ROUTE.md](./docs/TECHNICAL_ROUTE.md) — 支持性技术路线
- [docs/REVIEWER_DECISION_G3BR1_G3B_PASS.md](./docs/REVIEWER_DECISION_G3BR1_G3B_PASS.md) — **当前 G3B Reviewer PASS 判断**
- [docs/G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND.md](./docs/G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND.md) — 已完成的 Sandbox closure contract

其他研究、历史 Gate 与旧方案保留用于 provenance，但不与 Handoff 竞争当前真相。

## 治理

本项目采用 GitHub canonical [VPS Project Governance v0.1.6](https://github.com/entropy-student/spike.skill/tree/main/vps-project-governance) 及当前 active addenda。

关键规则：

- `REVIEWER_HANDOFF.md` 是唯一当前项目真相；
- `PASS_CANDIDATE != PASS`；
- Reviewer 独立验收，Executor 不自行进入下一 Gate；
- UNKNOWN 明确保留，不靠猜测填补；
- Provider 已出现成功迹象后禁止盲目再支付/重放，先只读 reconciliation；
- Secret / password / token / cookie / raw payment payload 不进入普通仓库文档；
- Shared VPS 部署前必须建立 Storage Manifest，并单独经过 Shared Infra / deployment Gate。
