# Skill Dogfood Log

Purpose: 用本项目真实行为数据反向验证 `independent-store-operations`，而不是把采用建议本身当成正确性证明。

Canonical theory source:
`entropy-student/spike.skill/independent-store-operations`

## Rules

1. 假设必须在看到结果前记录。
2. 区分 L0/L1 页面事实与 L2 行为数据、L3 因果证据。
3. 实现一个建议 ≠ 证明建议正确。
4. 结果只能标记：`SUPPORTED / REJECTED / INCONCLUSIVE`。
5. 只有重复真实反例或足够强证据才触发 Skill 修改。
6. Skill 修改需要 Reviewer 单独 Gate，不在产品代码里悄悄改规则。

## Record Template

```text
ID:
Date:
Skill concept / rule:
Product hypothesis:
Evidence level before test:
Why we believe it:
Implementation / experiment:
Primary behavior metric:
Success criteria:
Kill / counterevidence criteria:
Observed result:
Decision: SUPPORTED / REJECTED / INCONCLUSIVE
What we learned:
Should theory/Skill change: YES / NO / REVIEW
Related commit / experiment / dashboard:
```

---

## D001 — Free Top 3 as Activation

Status: `INCONCLUSIVE`

Skill concept:
`Activation = 用户第一次亲自体验到核心价值的事件`

Hypothesis:
用户完成扫描并看到与自己网站直接相关、带证据的 Top 3 时，会首次体验到产品核心价值。

Expected journey:

```text
landing_view
→ scan_started
→ scan_completed
→ top3_viewed
→ issue_expanded / pricing_viewed
```

Primary evidence needed:
- scan_started → scan_completed completion;
- top3_viewed rate;
- issue_expanded rate;
- top3_viewed → pricing_viewed / later checkout_started movement;
- qualitative user feedback on whether findings feel concrete and credible.

Current decision:
`INCONCLUSIVE — no real user behavior yet`

---

## D002 — Free Value → Paid Expansion

Status: `INCONCLUSIVE`

Hypothesis:
Free Top 3 should be a complete but bounded win; paid product should expand depth/scope/prioritization/personalization rather than intentionally hide basic evidence.

Primary evidence needed:
- free result usefulness feedback;
- pricing_viewed after Top 3;
- checkout_started later at Payment Gate;
- complaints that free layer is too weak vs evidence that free layer removes need to pay.

Current decision:
`INCONCLUSIVE — no real user behavior yet`

---

## D003 — Trust through evidence, not generic badges

Status: `INCONCLUSIVE`

Hypothesis:
Showing source evidence for each issue will increase perceived credibility more than generic trust decoration alone.

Primary evidence needed:
- evidence expand/click behavior;
- qualitative trust feedback;
- later experiment if needed.

Current decision:
`INCONCLUSIVE — no real user behavior yet`

---

## D004 — Users need actionable depth beyond Top 3

Status: `INCONCLUSIVE`

Skill concept:
`A bounded free result can lead into a deeper, evidence-linked action queue.`

Hypothesis:
Some store operators will find additional evidence-backed issues beyond the first three useful enough to inspect; a longer queue will not automatically be more useful for every user.

Evidence level before test:
`L0 — product structure only; no external user behavior`

Why we believe it:
The Scanner can return more eligible findings than the free Top 3, but scan output alone does not establish user need or willingness to review more items.

Implementation / experiment:
G5 local full-queue preview, with position following existing Top 3 order and Scanner report order; no impact score.

Primary behavior metric:
`full_report_viewed`, queue count, and `full_issue_expanded` by queue position.

Success criteria:
To be defined before a real external-user observation; local automated fixtures only validate implementation.

Kill / counterevidence criteria:
External users consistently stop at the Top 3, report the longer queue as confusing, or do not value the additional evidence.

Observed result:
`None — deterministic fixtures only.`

Decision: `INCONCLUSIVE`

What we learned:
The feature exists and emits testable local events; this is not evidence of demand.

Should theory/Skill change: `NO`

Related commit / experiment / dashboard:
`G5 local dogfood acceptance; no external-user cohort.`

---

## D005 — Structured explanation improves comprehension without replacing evidence

Status: `INCONCLUSIVE`

Skill concept:
`AI should explain an existing evidence-backed issue, not substitute for proof.`

Hypothesis:
A concise explanation of a structured finding and its deterministic first move may help users understand it, while visible source evidence remains necessary for trust.

Evidence level before test:
`L0 — product structure only; no external user behavior`

Why we believe it:
Issue IDs and evidence references preserve provenance, but no user comprehension or trust has been measured.

Implementation / experiment:
On-demand G5 explanation over a versioned structured issue schema; deterministic fake provider in automated acceptance; no raw HTML input.

Primary behavior metric:
`llm_explanation_requested`, `llm_explanation_viewed`, fallback rate, and evidence-detail expansion; later pair with qualitative comprehension/trust feedback.

Success criteria:
To be defined before a real external-user observation; fake-provider success is a technical check only.

Kill / counterevidence criteria:
Users mistake explanations for proof, find the output less useful than the original evidence, or unsupported claims are observed.

Observed result:
`None — deterministic fake-provider tests only.`

Decision: `INCONCLUSIVE`

What we learned:
The adapter can be tested without an API key; no claim about comprehension or trust is supported yet.

Should theory/Skill change: `NO`

Related commit / experiment / dashboard:
`G5 local dogfood acceptance; no real provider or external-user cohort.`

---

## D006 — Evidence remains more important than generic AI prose

Status: `INCONCLUSIVE`

Skill concept:
`Traceable observations and explicit limitations should remain primary; generated prose is supplementary.`

Hypothesis:
Users will value source and evidence references even when an explanation is available, and may distrust explanations that obscure those references or limitations.

Evidence level before test:
`L0 — product structure only; no external user behavior`

Why we believe it:
The claim boundary requires each queue entry to map to a Scanner issue and evidence references, but this constraint is not user-behavior evidence.

Implementation / experiment:
Evidence and limitation remain visible in progressive disclosure; the optional explanation is a separate on-demand section.

Primary behavior metric:
`full_issue_expanded` alongside `llm_explanation_viewed`, followed by qualitative feedback in a later approved study.

Success criteria:
To be defined before a real external-user observation; no inference will be made from synthetic fixtures.

Kill / counterevidence criteria:
Users treat generated explanation as a replacement for source, or the additional prose reduces understanding of the Scanner decision.

Observed result:
`None — deterministic fixtures only.`

Decision: `INCONCLUSIVE`

What we learned:
The UI preserves evidence and limitations structurally; whether users prefer them remains unknown.

Should theory/Skill change: `NO`

Related commit / experiment / dashboard:
`G5 local dogfood acceptance; no external-user cohort.`
