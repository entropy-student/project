# G3.5 — UI + Growth Design Freeze

Status: `NEXT`
Owner: Reviewer + Owner
Executor: none until PASS

## Purpose

在 Codex 开始产品实现前，把“用户为什么愿意继续、页面应该长什么样、功能应该如何反馈、什么才算高保真”冻结成可执行合同。

目标不是先写代码，而是让 Codex 后续**不需要自己发明产品决策**。

## Required Outputs

G3.5 PASS 前至少产出：

```text
design/
├── UI_GROWTH_BRIEF.md
├── DESIGN_SYSTEM.md
├── PAGE_CONTRACTS.md
├── INTERACTION_STATES.md
├── ANALYTICS_EVENT_CONTRACT.md
├── FUNCTIONAL_ACCEPTANCE.md
├── VISUAL_ACCEPTANCE.md
└── references/
    ├── home-desktop.png
    ├── home-mobile.png
    ├── scan-progress.png
    ├── free-top3.png
    └── full-report.png
```

实际文件名可微调，但信息不可缺失。

## Growth / Activation Hypothesis

核心免费价值体验：

```text
landing_view
→ scan_started
→ scan_completed
→ top3_viewed
→ 用户看到与自己网站直接相关、带证据的具体问题
= Activation / Aha candidate
```

免费结果必须提供一个完整但有限的胜利，而不是故意残缺。

Paid Expansion 后续主要增加：
- Depth
- Scope
- Prioritization
- Personalization
- Continuity
- More certainty

## Pages to Freeze

至少冻结：
1. Home / Landing
2. Scan input
3. Scan progress
4. Scan incomplete / blocked / error
5. Free Top 3
6. Issue detail / evidence view
7. Pricing / paid expansion explanation
8. Full report shell
9. Mobile variants

## Trust / Proof Questions

每个页面都必须回答：
- 用户此刻最担心什么？
- 我们能证明什么？
- 什么不能承诺？
- CTA 为什么值得点？
- 是否正在要求用户承担不必要风险？

Claim Boundary：

> 发现可观察到的站内因素，这些因素可能增加购买犹豫、不信任或操作阻力。

不得声称：root cause / exact revenue loss / guaranteed uplift。

## clone-ui Policy

`clone-ui` 仅允许：
- 提取布局模式；
- spacing / typography；
- component visual language；
- motion / interaction reference；
- design token inspiration。

禁止：
- 直接用 clone 结果覆盖现有产品源码；
- 为了像参考站而改变产品架构；
- 重写无关功能；
- 引入无法解释的 dependency / style cascade。

正确路径：

```text
Reference
→ clone-ui / manual analysis
→ visual principles
→ project Design System
→ page contracts / golden screenshots
→ Codex implementation
```

## High-fidelity Acceptance

高保真必须同时具备：

### Human reference
- desktop golden screenshots；
- mobile golden screenshots；
- key state screenshots。

### Machine contract
- design tokens；
- component/page states；
- viewport；
- spacing/size rules；
- Playwright screenshot generation；
- visual regression threshold；
- functional tests separated from visual tests。

Visual PASS 不能替代 Functional PASS，反之亦然。

## Analytics Event Contract

首版至少规划：

```text
landing_view
scan_started
scan_completed
scan_incomplete
top3_viewed
issue_expanded
pricing_viewed
checkout_started
payment_completed
full_report_viewed
```

G3.5 只冻结事件语义，不要求现在安装 analytics provider。

Preferred analytics candidate: PostHog or equivalent. Prefer project-owned integration over plugin sprawl.

## Plugin Policy

不提前堆插件。

首发优先顺序：
1. analytics / instrumentation；
2. SEO/Search integration when needed；
3. transactional email when needed；
4. backup/restore before production。

每个插件必须回答：
- 为什么需要？
- 能否由已有项目代码更简单实现？
- 是否增加安全/性能/维护风险？

## Payment Boundary

G3.5 不设计真实支付实现。

只允许在 UI 中定义未来 paid expansion 的位置和 entitlement semantics。

当前 Payment Gate = G9；Provider tentative = Direct PayPal。

## PASS Criteria

只有满足以下条件才能 `PASS_G3_5_UI_GROWTH_DESIGN_FREEZE`：

- 用户路径冻结；
- Core Aha 冻结；
- 页面与状态完整；
- desktop/mobile high-fidelity approved by Owner；
- Trust/Proof/CTA reviewed；
- Design System 可执行；
- Analytics events frozen；
- Visual + Functional acceptance contract ready；
- Codex 不再需要做产品方向判断。
