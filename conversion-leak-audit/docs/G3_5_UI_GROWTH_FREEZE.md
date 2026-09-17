# G3.5 — UI + Growth Design Freeze

Status: `IN_PROGRESS`
Owner: Reviewer + Owner
Executor: none until PASS

## Purpose

在 Codex 开始产品实现前，把“用户为什么愿意继续、页面应该长什么样、功能应该如何反馈、什么才算高保真”冻结成可执行合同。

目标不是先写代码，而是让 Codex 后续**不需要自己发明产品决策**。

## Current progress

已完成文本合同：

```text
design/UI_GROWTH_BRIEF.md             ✅
design/DESIGN_SYSTEM.md               ✅
design/BRAND_IDENTITY.md              ✅
design/PAGE_CONTRACTS.md              ✅
design/INTERACTION_STATES.md          ✅
design/ANALYTICS_EVENT_CONTRACT.md    ✅
design/FUNCTIONAL_ACCEPTANCE.md       ✅
design/VISUAL_ACCEPTANCE.md           ✅
design/DEMO_FIXTURE_GOLDEN.md         ✅
```

视觉探索状态：

```text
V1 exploratory high-fidelity           reviewed
V2 platform-compatible direction       reviewed
V3 evidence-first direction            PASS_CANDIDATE
V4 structure direction                 OWNER_APPROVED
```

当前整体视觉方向已冻结，不再重新探索风格。

待完成：

```text
Gap Mark final geometry / favicon       ⏳
final truthful Golden Screens           ⏳
Owner final visual approval             ⏳
```

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

## Design decision

当前视觉方向：

> **Editorial Diagnostic Console / Evidence-first Diagnostic**

Owner + Reviewer decision：`VISUAL_DIRECTION = APPROVED`

保留：
- white / clean / deep-blue diagnostic direction；
- high whitespace；
- platform compatibility strip；
- URL-first hero；
- real scan stages；
- evidence-led finding cards；
- desktop/mobile consistency；
- full-report information architecture。

最后收敛只允许修：
- truthful content/data；
- final Gap Mark geometry；
- favicon/nav small-size behavior；
- Golden Screen implementation details。

不再重新发明整体视觉风格。

## Brand / logo decision

Owner + Reviewer 已选择：

```text
PRIMARY = B — Gap Mark
BACKUP  = refined A — Bar Mark
```

原因：Gap Mark 同时表达“缺口 / 漏点 / 可测结构”，比通用 analytics bar 更有品牌含义，又不会被误认为 Search/Security 产品。

最终要求：
- 16×16 仍看得到 gap；
- 32×32 / nav / mobile 清晰；
- light/dark background 均可用；
- monochrome 仍可识别；
- 不依赖 gradient 才能成立。

详见 `../design/BRAND_IDENTITY.md`。

Owner 已明确希望首页展示主要独立站平台标识：WordPress/WooCommerce、Shopify、Wix、Squarespace、BigCommerce + more。只表达兼容性，不暗示官方合作。

## Truthful demo fixture

最终 Golden Screens 禁止再手填展示数字或虚构 findings。

Canonical demo fixture：

`../design/DEMO_FIXTURE_GOLDEN.md`

固定结果：

```text
17 trusted rules checked
3 confirmed demo issues

1. CORE-007 — product price not visible near purchase action
2. PHYS-002 — shipping information hard to find
3. PHYS-001 — return information hard to find
```

Full Report shell 不能为了“看起来丰富”伪造额外 high/medium/low counts。

## Homepage / product path

当前冻结方向：

```text
Problem framing
→ URL input
→ Trust strip / platform compatibility
→ Scan progress
→ Evidence-backed Top 3
→ Issue evidence detail
→ Paid expansion preview
→ Future Direct PayPal at G9
```

Hero 承诺必须维持 Claim Boundary，不直接承诺 revenue/conversion uplift。

Supporting value：
- public pages only；
- no admin access；
- no install；
- no website changes；
- free evidence-backed Top 3。

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

首版语义已经冻结在：

`../design/ANALYTICS_EVENT_CONTRACT.md`

核心：

```text
landing_view
scan_started
scan_rejected
scan_completed
scan_incomplete
top3_viewed
issue_expanded
paid_expansion_viewed
checkout_started      [G9]
payment_completed     [G9]
full_report_viewed    [future]
```

G3.5 只冻结事件语义，不要求现在安装 analytics provider。

Preferred analytics candidate: PostHog or equivalent. Prefer project-owned integration over plugin sprawl.

## Payment Boundary

G3.5 不设计真实支付实现。

Payment Gate = G9。
Provider tentative = Direct PayPal。
Unified Pay 当前不作为本项目依赖。

## Skill Dogfood

本项目也是 `independent-store-operations` 的真实验证场。

所有重要产品/运营假设必须记录在：

`SKILL_DOGFOOD_LOG.md`

用真实行为更新为：
- SUPPORTED
- REJECTED
- INCONCLUSIVE

不能用“Skill 自己指导自己的页面”作为 Skill 正确的证据。

## PASS Criteria

只有满足以下条件才能 `PASS_G3_5_UI_GROWTH_DESIGN_FREEZE`：

- 用户路径冻结； ✅
- Core Aha 冻结； ✅ candidate frozen
- 页面与状态完整； ✅
- Trust/Proof/CTA reviewed； ✅
- Design System 可执行； ✅
- Analytics events frozen； ✅
- Visual + Functional acceptance contract ready； ✅
- overall visual direction； ✅ OWNER_APPROVED
- truthful fixed Demo Fixture； ✅
- primary logo family selected； ✅ GAP_MARK
- final logo/favicons； ⏳
- desktop/mobile final Golden Screens approved by Owner； ⏳
- Codex 不再需要做产品方向判断； ⏳

## Current next action

```text
REFINE_GAP_MARK_FOR_FAVICON
→ GENERATE_FINAL_TRUTHFUL_GOLDEN_SCREENS
→ OWNER_FINAL_VISUAL_REVIEW
→ PASS_G3_5
→ RELEASE_G4_TO_CODEX
```
