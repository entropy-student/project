# Conversion Leak Audit — PROJECT RECORD

> 这是该项目的长期单一真相。任何 Reviewer / Codex / Executor 接手时，优先读取本文件。

## 1. 最终目标

建立一个可复用的“诊断型数字产品母版”，首个产品为独立站转化漏损诊断。

最终闭环：

```text
Public Store URL
→ Safe Scan
→ Free Top 3
→ Complete Fix Queue / Paid Expansion
→ Shared VPS
→ Domain / HTTPS
→ Payment
→ Production Acceptance
→ Acquisition / Business Validation
```

V1 只做站内 observable conversion leaks；Shopify / GA4 full-funnel diagnosis 延后到 V2。

## 2. 当前权威状态

```text
P0   Product / Governance                    PASS
P0A  WordPress-first                         PASS
P0B  Shared VPS final target                 PASS
PF   Theory / Rules / Pre-development        PASS

G1   WordPress Local Baseline                PASS
G2   Safe Scanner V0                         PASS
G3   Rule Engine V0                          MERGED / CLOSED
G3.5 UI + Growth Design Freeze               NEXT
G4   WP ↔ Scanner ↔ Top 3 Local Loop          PENDING
G4.5 Visual + Functional Acceptance          PENDING
G5   Full Fix Queue + LLM + Skill Dogfood    PENDING
G6   VPS Onboarding / Storage                HOLD
G7   VPS Private Deployment                  HOLD
G8   Domain / HTTPS / Shared Ingress          HOLD
G9   Payment / Controlled Go-live            HOLD
G10  Production Acceptance                   HOLD
G11  Acquisition / Business Validation       HOLD
```

## 3. 当前已完成资产

### 理论
Canonical Skill：`entropy-student/spike.skill/independent-store-operations`，版本 `v0.6.0`。

已完成：8-stage chain、L0–L3、H1/C1/E1、店型、P0–P4、交易拓扑、Trust/Proof、经济护栏、Scanner 边界、77 条知识规则、17 条 Scanner V0 可信规则。

### 规则 / 校准
- 51 / 51 synthetic fixtures PASS
- 9 / 9 normal real targets auditable
- 26 / 26 real fact assertions
- 28 / 28 real rule assertions
- unexpected ISSUE = 0
- geo context misuse = 0

### Scanner V0
Python；public URL safety、DNS/IP pinning、Scrapy static-first、bounded browser fallback、SQLite、`/healthz`、job/report API、evidence-required ISSUE。Recovery review：`55 / 55 PASS`。

### WordPress G1
WordPress 7.1 + MariaDB 11.4 + SaasLauncher 2.0.18 + child theme；6 个基础页面全部 200；Scanner / payment 尚未接入。G1 GitHub Actions run `35237395508`: success。

## 4. G3.5 — UI + Growth Design Freeze

在把产品交给 Codex 实现 G4 前，先冻结产品体验与增长设计。

G3.5 必须确定：
- 用户路径与核心 Aha；
- 首页 / Scan / Progress / Free Top 3 / Full Report / Pricing 的信息架构；
- Trust / Proof / CTA / Offer；
- Desktop + Mobile high-fidelity reference；
- Design System；
- interaction / loading / error / incomplete states；
- Analytics Event Contract；
- Visual Acceptance / Golden Screenshot；
- Functional Acceptance；
- Free → Paid 边界。

核心 Activation 假设：

```text
输入 URL
→ 完成扫描
→ 看见有证据的 Top 3
→ “这里真的可能在漏单”
```

### clone-ui 使用边界
`clone-ui` 只能用于提取视觉参考（layout / spacing / typography / component / motion language），不得直接大面积重写现有 WordPress 产品源码。视觉参考必须先转成项目自己的 Design Spec，再由 Codex 在既有架构内实现。

### 高保真验收
高保真不能只靠截图口头要求。Codex 后续必须同时满足：
- design spec；
- golden screenshots（至少 desktop + mobile）；
- Playwright screenshot / visual regression；
- functional acceptance tests。

G3.5 是 Owner + Reviewer Gate；未 PASS 前 Codex 不开始 G4 产品实现。

## 5. 运营 / 插件策略

原则：`Instrumentation > Plugin quantity`。

首发优先：
1. 行为埋点（必须）；
2. SEO/Search integration（需要时）；
3. 邮件通知（需要时）；
4. Backup / Restore（上线前必须）。

当前不安装一批 WordPress 插件。行为分析优先考虑 PostHog 或等价方案，尽量由项目 integration layer 自己完成事件埋点，减少插件耦合。

核心事件候选：
`landing_view → scan_started → scan_completed → top3_viewed → issue_expanded → pricing_viewed → checkout_started → payment_completed → full_report_viewed`。

## 6. Skill Dogfood

本项目同时是 `independent-store-operations` 的真实纵向验证场。

每个由 Skill 导出的设计/运营假设都进入 `docs/SKILL_DOGFOOD_LOG.md`：
`Hypothesis → Evidence level → Implementation → Expected behavior → Actual behavior → SUPPORTED / REJECTED / INCONCLUSIVE → 是否回写 Skill`。

禁止循环论证：Skill 的建议不能因为“我们采用了”就被视为正确，必须等真实行为数据。

## 7. Token / Network Policy

Free Scan 的核心流程原则上零 LLM Token：Scrapy、browser extraction、Rule Engine、WordPress、deterministic Top 3 都是代码执行。

真实扫描公开网站需要网络。LLM 仅用于结构化 Issue 之后的解释、归纳和修复建议；不得把整页 HTML 直接交给模型自由诊断。API Key 只放运行环境 Secret Store / 环境变量，不进聊天或 GitHub。

## 8. Payment Decision

支付整体后移到 G9。

当前决策：
- **暂定 Direct PayPal**；
- **Unified Pay 当前未跑通且需要修改，不作为本项目当前依赖**；
- G3.5 / G4 / G4.5 / G5 / G6–G8 均不得因为支付阻塞；
- 到 G9 再进行一次 Payment Architecture Review；除非 Owner 明确改判，否则以 PayPal 为默认实现候选。

本项目是“scan_id → entitlement/full report”型产品，不按普通卡密发货思路设计。

## 9. 当前架构

```text
WordPress
  Landing / SEO / Blog / Pricing / Scan / Results UI
        ↓
Project-owned integration layer
        ↓
Python Scanner
        ↓
URL / DNS / SSRF Safety Gate
        ↓
Scrapy static-first → limited browser fallback
        ↓
Normalized Facts → Applicability
        ↓
17 frozen rules
        ↓
Evidence-backed Issues → deterministic Top 3
        ↓
optional LLM explanation (later)
```

## 10. 当前下一动作

不是 Codex G4。

```text
Reviewer + Growth Skill
→ G3.5 UI / Growth design
→ Owner visual/product approval
→ freeze design + analytics + acceptance contracts
→ PASS_G3_5
→ then hand to Codex for G4
```

## 11. 不允许重复执行

除非 Reviewer 明确 reopen：不重建理论、不重做 77-rule catalog、不重新立项 51 fixtures、不重做 G1、不重做 G2、不单独重开旧 G3。

重大状态变化必须回写本文件与 `CURRENT_STATUS.json`。