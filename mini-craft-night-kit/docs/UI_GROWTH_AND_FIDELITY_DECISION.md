# Mini Craft Night Kit — UI / Growth / Fidelity Decision

Last reviewed: 2026-09-18  
Status: **OWNER_APPROVED**

## 1. Decision

在任何正式 UI 改造交给 Executor / Codex 前，必须先完成：

```text
Owner
+ Reviewer
+ Growth / Acquisition Framework
        ↓
UI_DECISION
        ↓
Executor Implementation
```

Executor 不自行决定营销信息架构、Offer 顺序或页面转化逻辑。

## 2. K0 / K1 Boundary

### K0 — 原版模板验证

只导入 Kadence Single Product Starter Template。

K0 不做：
- Mini Craft 品牌替换；
- 页面结构重做；
- clone-ui 高保真；
- 自定义 Cart / Checkout；
- 支付；
- VPS。

K0 结束时 Owner 必须先看到真实模板，再决定是否采用。

### K1 — UI + Growth 决策后再改

进入 K1 前，Reviewer + Growth / Acquisition Framework 必须形成一份可执行 UI Decision，至少包含：

- 页面目标；
- 首屏核心承诺；
- Offer hierarchy；
- CTA；
- Trust / Risk reversal；
- What’s Inside；
- Shipping / Returns 信息；
- 哪些模板区块 KEEP / ADAPT / DROP；
- 哪些图片必须替换；
- 哪些文案需要真实证据后才能写。

## 3. Source of Truth

优先级：

```text
Business truth / conversion goal
        >
Approved UI Decision
        >
Kadence Starter Template structure
        >
Brand tokens / visual adaptation
        >
clone-ui visual parity
```

Kadence Starter Template 是结构 Source of Truth。

默认禁止为了“更像参考图”重建成熟模板的布局系统。

## 4. clone-ui Usage Boundary

clone-ui 可用于：

- 已确认页面的局部视觉复刻；
- Hero / Product section / CTA / Trust block 的视觉收敛；
- computed-style / geometry / visual diff；
- 回归前后视觉比较。

clone-ui 不允许作为：

- WordPress 架构控制器；
- WooCommerce 业务逻辑实现器；
- Gutenberg block validity 的替代检查；
- 响应式 correctness 的唯一证据。

## 5. UI Acceptance Contract

任何页面不能仅凭视觉像素相似就 PASS。

最终 UI Gate 至少同时满足：

```text
VISUAL_FIDELITY=PASS
GUTENBERG_VALIDITY=PASS
RESPONSIVE=PASS
WOOCOMMERCE_BEHAVIOR=PASS
OWNER_EDITABILITY=PASS
BUSINESS_TRUTH=PASS
```

### Visual Fidelity

验证：
- 页面结构；
- hierarchy；
- spacing；
- typography；
- image crop；
- button / card / control geometry；
- approved brand tokens。

### Gutenberg Validity

要求：
- 编辑器无 Invalid Block；
- Owner 能正常打开并编辑；
- 不用 Custom HTML 把主要内容锁死。

### Responsive

最低覆盖：

```text
Mobile: 320 / 375 / 390 / 430
Tablet: 768 / 820 / 1024 + landscape
Desktop: 1280 / 1366 / 1440 / 1920 / 2048
Stress: 2560 / zoom-out smoke test
```

### WooCommerce Behavior

任何视觉修改不得破坏：

- Add to Cart；
- Cart；
- Checkout；
- Order；
- form validation；
- payment gateway hooks；
- WooCommerce Blocks。

## 6. Anti-overengineering Rule

默认只做影响下面三件事的 UI 修改：

1. 用户是否理解产品；
2. 用户是否信任；
3. 用户是否愿意下单。

不为最后 3–5% 的视觉 parity 重做成熟结构。
