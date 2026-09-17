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

Status: `PLANNED`

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

Status: `PLANNED`

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

Status: `PLANNED`

Hypothesis:
Showing source evidence for each issue will increase perceived credibility more than generic trust decoration alone.

Primary evidence needed:
- evidence expand/click behavior;
- qualitative trust feedback;
- later experiment if needed.

Current decision:
`INCONCLUSIVE — no real user behavior yet`
