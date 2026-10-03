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
| G3CR2R3 Blocksy Wedding + WooCommerce compatibility canary | **PASS** |
| G3C Blocksy Wedding UI/UX productization + Owner visual freeze | INTERIM RETURN — PR #64 open; mobile/current screenshots pending |
| G3CR3 current visual evidence closure | SUPERSEDED BY OWNER SCREENSHOT REVIEW |
| G3CR4 G3C visual consolidation | **PASS** |
| G3CR5 visual finish + WooCommerce continuity | **PASS** |
| G3C Owner visual checkpoint | RESOLVED — Owner requested further redesign |
| G3CR6 Frontend experience + warm-gift brand redesign | RETURN — visual direction underexecuted |
| G3CR6R1 Frontend composition redesign | **PASS** |
| G3C Owner visual checkpoint R2 | RESOLVED — bounded Preview polish requested |
| G3CR6R2 Free Preview Activation polish | SUPERSEDED BEFORE EXECUTION |
| G3C Owner magazine visual checkpoint | RESOLVED — current magazine visual rejected |
| G3CR6R3A Static magazine visual redesign | **CURRENT** |
| G3CR6R3 Final product proof + website motion + Preview Activation | HOLD pending magazine visual PASS |
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

这仍然**不是 Live/真钱支付证据**。此前 Astra 路线已经淘汰。**Blocksy Wedding Gutenberg 的兼容性现已 PASS**：Starter 可导入、首页可用 Gutenberg 编辑，WooCommerce 11.1.2 的商品/购物车/结账/账户以及 Private Workspace 回归均通过。当前 G3CR4 / G3CR5 均已 PASS：首页结构、375px Preview、上传照片后的 Preview 排版，以及 Product/Cart/Checkout/My Account 的视觉连续性都已通过 Reviewer 验收。Owner 在该 checkpoint 选择了继续修改而不是视觉封板。G3CR6 已执行，但 Reviewer 对 19 张最终截图复核后判定 **RETURN**：功能/隐私/Woo 回归证据可保留，但页面组合仍明显继承 G3CR4/G3CR5 的旧骨架，主要表现为换图与换肤，没有充分执行 **Option 2 — Warm Birthday Gift**。**G3CR6R1 Frontend Composition Redesign 已 Reviewer PASS**：首页已重建为新的礼物编辑风格 composition，旧六段 / `g3cr4-*` 骨架退出渲染；Preview、375px、原生 Woo 路径、Owner 编辑能力与后台保护边界均完成回归。Owner 已对 G3CR6R1 的整体 composition 表示大致认可，但认为当前“上传照片 → 显示封面/Preview”的体验仍不理想。Owner 直接查看 G2BR3 12 页 contact sheet 后明确拒绝当前杂志视觉：它只能作为技术 Solution Proof，不能作为对外出售的最终视觉。**当前进入 G3CR6R3A Static Magazine Visual Redesign**：先把静态 12 页杂志本身重做成付费礼物级，并同时输出“人工参考文案版”和“真实 AI 文案版”两套 contact sheet，清楚展示 AI 只改变内容、模板控制视觉。G3CR6R3 网站首页动效/最终产品展示/Preview 重做继续 HOLD，等杂志视觉通过后再恢复。Woo/支付/账户/私有空间后台继续冻结。PR #64 保持 open/unmerged，Owner visual freeze 仍为 PENDING，G4 继续 HOLD。

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
- [docs/OWNER_DECISION_G3CR6_WARM_GIFT_FRONTEND_REDESIGN.md](./docs/OWNER_DECISION_G3CR6_WARM_GIFT_FRONTEND_REDESIGN.md) — **当前 Owner 视觉方向与变更边界**
- [docs/REVIEWER_DECISION_G3CR6R1_PASS.md](./docs/REVIEWER_DECISION_G3CR6R1_PASS.md) — **G3CR6R1 Reviewer PASS**
- [docs/REVIEWER_DECISION_G3CR6R2_PREVIEW_ACTIVATION_REVIEW.md](./docs/REVIEWER_DECISION_G3CR6R2_PREVIEW_ACTIVATION_REVIEW.md) — **当前产品/Activation 判断**
- [docs/OWNER_DECISION_G3CR6R3_MOTION_PRODUCT_PROOF.md](./docs/OWNER_DECISION_G3CR6R3_MOTION_PRODUCT_PROOF.md) — 当前 Owner 体验要求
- [docs/REVIEWER_DECISION_G3CR6R3_EXPERIENCE_REVIEW.md](./docs/REVIEWER_DECISION_G3CR6R3_EXPERIENCE_REVIEW.md) — 当前产品/获客判断
- [docs/G3CR6R3_PRODUCT_PROOF_MOTION_ACTIVATION.md](./docs/G3CR6R3_PRODUCT_PROOF_MOTION_ACTIVATION.md) — **当前执行 Gate**
- [docs/G3CR6R2_FREE_PREVIEW_ACTIVATION_POLISH.md](./docs/G3CR6R2_FREE_PREVIEW_ACTIVATION_POLISH.md) — superseded before execution
- [docs/GROWTH_VALIDATION_STATE_2026-10-03.md](./docs/GROWTH_VALIDATION_STATE_2026-10-03.md) — 当前 Growth Validation Spine / 瓶颈判断
- [docs/ACQUISITION_GROWTH_PLAN.md](./docs/ACQUISITION_GROWTH_PLAN.md) — 当前获客验证计划
- [docs/G3C_OWNER_VISUAL_CHECKPOINT_R2.md](./docs/G3C_OWNER_VISUAL_CHECKPOINT_R2.md) — 已解决的 Owner checkpoint
- [docs/REVIEWER_DECISION_G3CR6_RETURN.md](./docs/REVIEWER_DECISION_G3CR6_RETURN.md) — G3CR6 Reviewer RETURN
- [docs/G3CR6R1_FRONTEND_COMPOSITION_REDESIGN.md](./docs/G3CR6R1_FRONTEND_COMPOSITION_REDESIGN.md) — 已执行 / PASS contract
- [docs/G3CR6_FRONTEND_EXPERIENCE_BRAND_REDESIGN.md](./docs/G3CR6_FRONTEND_EXPERIENCE_BRAND_REDESIGN.md) — 已执行 G3CR6 合同
- [docs/REVIEWER_DECISION_G3BR1_G3B_PASS.md](./docs/REVIEWER_DECISION_G3BR1_G3B_PASS.md) — G3B Reviewer PASS 判断
- [docs/G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND.md](./docs/G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND.md) — 已完成的 Sandbox closure contract

其他研究、历史 Gate 与旧方案保留用于 provenance，但不与 Handoff 竞争当前真相。

## 治理

本项目采用 GitHub canonical **VPS Project Governance v0.2.6**；实际操作规则以 `spike.skill/vps-project-governance/VNEXT.md` 为准，当前无外部 operational addenda。

关键规则：

- `REVIEWER_HANDOFF.md` 是唯一当前项目真相；
- `PASS_CANDIDATE != PASS`；
- Reviewer 独立验收，Executor 不自行进入下一 Gate；
- UNKNOWN 明确保留，不靠猜测填补；
- Provider 已出现成功迹象后禁止盲目再支付/重放，先只读 reconciliation；
- Secret / password / token / cookie / raw payment payload 不进入普通仓库文档；
- Shared VPS 部署前必须建立 Storage Manifest，并单独经过 Shared Infra / deployment Gate。
