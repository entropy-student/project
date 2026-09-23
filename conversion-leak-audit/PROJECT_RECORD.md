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
G3.5 UI + Growth Design Freeze               PASS
G4   WP ↔ Scanner ↔ Top 3 Local Loop          PASS
G4.5 Visual + Functional Acceptance          PASS
G4.6 Acquisition + SEO Readiness             PASS
G5   Full Fix Queue + LLM + Skill Dogfood    PASS
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

Status: **PASS**

Frozen decisions:
- Editorial Diagnostic Console / Evidence-first Diagnostic;
- Gap Mark primary logo;
- platform compatibility strip;
- URL-first Home;
- honest Scanner progress;
- evidence-backed Free Top 3;
- truthful synthetic demo fixture;
- provider-independent analytics events;
- functional + visual acceptance kept separate;
- clone-ui = reference extraction only;
- payment remains deferred.

Canonical implementation contracts:
- `design/FINAL_GOLDEN_SCREEN_SPEC.md`
- `design/DEMO_FIXTURE_GOLDEN.md`
- `design/DESIGN_SYSTEM.md`
- `design/PAGE_CONTRACTS.md`
- `design/INTERACTION_STATES.md`
- `design/ANALYTICS_EVENT_CONTRACT.md`
- `design/FUNCTIONAL_ACCEPTANCE.md`
- `design/VISUAL_ACCEPTANCE.md`

Gate result:

`PASS_G3_5_UI_GROWTH_DESIGN_FREEZE`

G4 is now released to Codex under `docs/G4_EXECUTION_CONTRACT.md`.

## 5. 运营 / 插件策略

原则：`Instrumentation > Plugin quantity`。

首发优先：
1. 行为埋点（必须）；
2. SEO/Search integration（需要时）；
3. 邮件通知（需要时）；
4. Backup / Restore（上线前必须）。

当前不安装一批 WordPress 插件。行为分析优先考虑 PostHog 或等价方案，尽量由项目 integration layer 自己完成事件埋点，减少插件耦合。

事件语义已冻结在 `design/ANALYTICS_EVENT_CONTRACT.md`。

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

```text
Codex
→ read docs/G5_EXECUTION_CONTRACT.md
→ build deterministic complete Fix Queue from existing ISSUE findings
→ add provider-neutral optional LLM explanation over structured issues only
→ preserve free Top 3 as zero-LLM path
→ update analytics contract minimally if needed
→ update SKILL_DOGFOOD_LOG hypotheses without claiming validation
→ rerun all regressions
→ PASS_CANDIDATE_G5_FULL_FIX_QUEUE_LLM_DOGFOOD
→ Reviewer PASS / RETURN
```

当前：
- G4.6 已正式 PASS，见 `docs/REVIEWER_DECISION_G4_6_PASS.md`；
- G4.6 通过 PR #6 合入 `main`，merge commit `71d810f61aa0e48b0feaf8cc9ec5deeeed128b27`；
- G5 是当前唯一执行 Gate；
- Payment / VPS / Domain / Production 继续 HOLD。

## 11. 不允许重复执行

除非 Reviewer 明确 reopen：不重建理论、不重做 77-rule catalog、不重新立项 51 fixtures、不重做 G1、不重做 G2、不单独重开旧 G3。

重大状态变化必须回写本文件与 `CURRENT_STATUS.json`。

### G4 Repository Reconciliation — 2026-09-22

G4 functional implementation has reached PASS_CANDIDATE locally, but its source/evidence is not yet persisted in a clean traceable Git commit. The shared monorepo worktree contains unrelated pending changes and is behind current GitHub main.

Required next step: create a clean sparse/project-scoped workspace from current main, migrate only G4-owned assets, preserve current Reviewer-owned documents, rerun frozen regressions and G4 integration tests, commit only `conversion-leak-audit/**` on a dedicated G4 branch, push that branch, then stop for Reviewer inspection.

Formal decision: `docs/REVIEWER_DECISION_G4_REPOSITORY_RECONCILIATION.md`.

Do not mutate sibling project worktrees. Do not merge G4 to main before Reviewer PASS.


### G4 Contract Completion Review — 2026-09-22

Repository reconciliation has passed Reviewer inspection. G4 final PASS remains withheld for a bounded contract-completion return.

Required before final G4 PASS:
- one real Scanner V0 canary through the WordPress integration;
- real PRIORITIZING state + canonical progress mapping;
- analytics contract compliance and automated assertions;
- refresh-result test;
- exact four-page Golden Demo fixture fidelity and required summary;
- complete G4 screenshot evidence;
- blue/navy frozen primary visual direction restored.

Formal decision: `docs/REVIEWER_DECISION_G4_CONTRACT_COMPLETION_RETURN.md`.

G1/G2/source recovery/repository isolation remain accepted and must not be rebuilt.


### G4 Final PASS — 2026-09-22

Reviewer final decision: `PASS_G4_WORDPRESS_SCANNER_TOP3_LOCAL_INTEGRATION`.

Accepted evidence includes Scanner `55/55`, WordPress `20/20`, real Scanner canary, real `PRIORITIZING`, analytics contract, frozen four-page Golden Demo, refresh-result coverage, complete required G4 screenshots, fail-closed states, and no payment/VPS/production-secret actions.

Implementation landed through PR #2; merge commit: `554951fc778d2b60a4a1fe655e07c37310ef76ad`.

Next Gate: `G4_5_VISUAL_FUNCTIONAL_ACCEPTANCE`, released under `docs/G4_5_ACCEPTANCE_CONTRACT.md`.

The prior G4 repository-reconciliation and contract-completion return sections are historical and superseded by this PASS.


### G4.5 Final PASS — 2026-09-23

Reviewer decision: `PASS_G4_5_VISUAL_FUNCTIONAL_ACCEPTANCE`.

Accepted:
- Owner-editable WordPress static content/layout;
- authenticated Site Editor;
- final Home/mobile/Top3/Evidence/Progress visual acceptance;
- pretty routes;
- internal/unfrozen Pricing copy removed;
- Scanner 55/55 and WordPress 20/20 preserved.

PR #3 merged to main at `40a1657ddd785069851ada7078acc1acae18f4d0`.

Next: `G4.6 Acquisition + SEO Readiness`, governed by `docs/G4_6_ACQUISITION_SEO_READINESS_CONTRACT.md`.

G4.6 exists to prevent acquisition/SEO concerns from endlessly reopening G4.5 visual work.


### G4.6 Final PASS — 2026-09-23

Reviewer decision: `PASS_G4_6_ACQUISITION_SEO_READINESS`.

Accepted:
- acquisition message/proof path;
- truthful synthetic Demo;
- Blog/Pricing hidden from primary acquisition surfaces and noindexed;
- page-specific metadata;
- Home no-signup metadata contract;
- canonical / scan-result noindex;
- WordPress native sitemap / robots readiness;
- SEO readiness `44/44 PASS`;
- Scanner `55/55 PASS`;
- WordPress `20/20 PASS`;
- no payment/VPS/production-secret expansion.

PR #6 merged to main at `71d810f61aa0e48b0feaf8cc9ec5deeeed128b27`.

Next Gate: `G5_FULL_FIX_QUEUE_LLM_DOGFOOD`, governed by `docs/G5_EXECUTION_CONTRACT.md`.


### G5 Final PASS — 2026-09-23

Reviewer decision: `PASS_G5_FULL_FIX_QUEUE_LLM_DOGFOOD`.

Accepted:
- complete deterministic Fix Queue from evidence-backed ISSUE findings;
- no invented impact score;
- provider-neutral structured explanation layer;
- Free Top 3 remains zero-LLM;
- fallback / hallucination / claim guards;
- D001–D006 remain INCONCLUSIVE;
- technical and seven-image visual acceptance;
- Scanner 55/55, WordPress 20/20, SEO 44/44 preserved.

PR #11 merged to main at `75c789cd4612790414bc1dc05d829e6945c539f8`.

Next roadmap gate: `G6_VPS_ONBOARDING_STORAGE`. It remains HOLD until Reviewer releases a dedicated execution contract.


### Post-G5 Gate Reorder — 2026-09-23

Owner approved a revised post-G5 sequence:

```text
G6 read-only VPS preflight / onboarding
→ G6.5 local Payment + Entitlement
→ G7 private VPS deployment
→ G8 Domain + HTTPS
→ G9 real payment-provider validation
→ G9.5 real LLM-provider canary
→ G10 production acceptance
→ G11 acquisition/business validation
```

Key rule: payment success unlocks the correct report entitlement; it does not automatically trigger LLM usage. A real LLM provider/key has not yet been configured. Free Top 3 remains zero-LLM and the complete deterministic Fix Queue remains available without a live LLM provider.

Before any VPS write or formal deployment, Owner approval is mandatory.

Formal decision: `docs/REVIEWER_DECISION_POST_G5_GATE_REORDER.md`.


### Project Pause — 2026-09-23

Owner paused the project without archival/sealing.

State:

`PAUSED_BY_OWNER`

G6 read-only VPS preflight evidence and deployment/storage design were checkpointed into `main` via PR #12. No VPS write or deployment was executed.

Canonical restart document:

`docs/PROJECT_PAUSE_HANDOFF.md`

On resume:
- restart from G6;
- re-check VPS read-only state because shared-host conditions may change;
- obtain explicit Owner approval before any VPS write.

No Executor work is authorized while paused.
