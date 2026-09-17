# Conversion Leak Audit — PROJECT RECORD

> 这是该项目的长期单一真相。任何 Reviewer / Codex / Executor 接手时，优先读取本文件。

## 1. 最终目标

建立一个可复用的“诊断型数字产品母版”，首个产品为独立站转化漏损诊断。

最终闭环：

```text
Public Store URL
→ Safe Scan
→ Free Top 3
→ Paid Unlock
→ Complete Fix Queue
→ Shared VPS
→ Domain / HTTPS
→ Controlled Production Payment
→ Production Acceptance
→ Acquisition / Business Validation
```

V1 只做站内 observable conversion leaks；Shopify/GA4 full-funnel diagnosis 延后到 V2。

## 2. 当前权威状态

```text
P0   Product / Governance                   PASS
P0A  WordPress-first                        PASS
P0B  Shared VPS final target                PASS
PF   Theory / Rules / Pre-development       PASS

G1   WordPress Local Baseline               PASS
G2   Safe Scanner V0                        PASS
G3   Rule Engine V0                         MERGED / CLOSED
G4   WP ↔ Scanner ↔ Top 3 Local Loop         NEXT

G5   Complete Fix Queue + Model Explanation PENDING
G6   VPS Onboarding / Storage               HOLD
G7   VPS Private Deployment                 HOLD
G8   Domain / HTTPS / Shared Ingress         HOLD
G9   Production Payment / Controlled Go-live HOLD
G10  Production Acceptance                  HOLD
G11  Acquisition / Business Validation      HOLD
```

## 3. 当前已完成资产

### 理论

Canonical Skill：`entropy-student/spike.skill/independent-store-operations`

当前版本：`v0.6.0`

已完成：
- 8-stage operating chain；
- L0–L3 evidence system；
- H1 / C1 / E1 rules；
- store archetypes；
- information proximity P0–P4；
- transaction topology；
- trust / proof；
- economics guardrails；
- scanner boundary；
- 77-rule knowledge base；
- 17-rule Scanner V0 trusted set。

### 规则 / 校准

- 51 / 51 synthetic fixtures PASS
- 9 / 9 normal real targets auditable
- 26 / 26 real fact assertions
- 28 / 28 real rule assertions
- unexpected ISSUE = 0
- geo context misuse = 0

### Scanner V0

当前实现：Python。

关键能力：
- public URL safety gate；
- localhost / private / metadata blocking；
- redirect revalidation；
- connection-time DNS/IP pinning；
- same-origin bounded crawl；
- Scrapy static-first；
- bounded browser fallback；
- SQLite persistence；
- `/healthz`；
- job / report API；
- no raw HTML persistence；
- ISSUE requires evidence reference；
- 403 / 429 / robots 不通过浏览器绕过。

Recovery review：`55 / 55 PASS`。

### WordPress G1

- WordPress 7.1
- MariaDB 11.4
- SaasLauncher 2.0.18
- project child theme
- block theme = YES
- Home / How it works / Demo / Pricing / FAQ / Blog
- 6 / 6 HTTP 200
- default Sample Page / Hello world removed
- scan input placeholder visible
- scanner integration = NO
- payment = NO
- VPS writes = 0

GitHub Actions G1 run `35237395508` conclusion: `success`。

## 4. 当前架构

```text
WordPress
  Landing / SEO / Blog / Pricing / FAQ / Results UI
        ↓
Project-owned integration layer
        ↓
Python Scanner
        ↓
URL / DNS / SSRF Safety Gate
        ↓
Scrapy static-first
        ↓
limited browser fallback
        ↓
Normalized Facts
        ↓
Applicability / Store Type / Transaction Topology
        ↓
17 frozen rules
        ↓
Evidence-backed Issues
        ↓
Top 3 / Full Fix Queue
        ↓
LLM explanation only after deterministic evidence
```

## 5. Token / Network Policy

Free scan 的核心流程原则上不需要 LLM Token：
- Scrapy: no LLM token
- browser extraction: no LLM token
- Rule Engine: no LLM token
- WordPress: no LLM token

真实扫描公开网站需要网络。

LLM 主要保留给付费报告中的解释、归纳与修复建议，且输入应是结构化 Issue，而不是整页 HTML。

## 6. 当前下一 Gate — G4

### 目标

跑通本地：

```text
WordPress URL input
→ POST scan job
→ status/progress
→ Scanner
→ evidence-backed Issues
→ Top 3 ranking
→ WordPress free result page
```

### Allowed
- local Windows / Docker development
- WordPress plugin / integration layer
- Scanner local API
- local SQLite
- local browser runtime
- error/status UX
- deterministic Top 3

### Forbidden
- production payment
- VPS writes
- public production scanner
- production Secret
- Shared Infra modification
- new uncalibrated automated rules

## 7. 后续路线

### G5
完整 Fix Queue + LLM explanation。

### G6–G8
Shared VPS storage/onboarding → private deploy → domain/HTTPS。

### G9
受控真实支付；支付 Provider 由 Unified Pay / 当时真实可用渠道决定。

### G10
生产验收，包括 persistence / security / rollback / backup / restore。

### G11
真实获客与商业验证：Solution Proof → Activation → Intent → Transaction。

## 8. 不允许重复执行

除非 Reviewer 明确 reopen：

- 不重新建设理论；
- 不重新做 77-rule catalog；
- 不重新跑 51 fixtures 作为“重新立项”；
- 不重做 G1 WordPress baseline；
- 不重做 G2 Scanner；
- 不单独重开旧 G3。

## 9. 当前暂停 / 恢复说明

项目当前可安全暂停。

恢复时直接：

```text
Read README.md
→ Read PROJECT_RECORD.md
→ Read docs/REVIEWER_HANDOFF.md
→ Start G4
```

重大状态变化必须回写本文件。
