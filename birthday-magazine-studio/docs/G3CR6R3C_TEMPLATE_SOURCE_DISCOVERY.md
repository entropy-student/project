# G3CR6R3C — Template + Motion Source Discovery

## Gate

```text
GATE_ID=G3CR6R3C_TEMPLATE_SOURCE_DISCOVERY
OBJECTIVE=Find the strongest reusable source/template candidates for 12 magazine pages + 1 homepage + 1 core interaction before implementation
MAX_ENDPOINT_THIS_ROUND=Reviewer research package + Owner shortlist
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Read-only web/source research and local documentation only
OWNER_ONLY_ACTIONS=NONE
```

Governance: **vps-project-governance v0.2.6**.

## Goal

Produce a high-quality shortlist for:

- 12 magazine page/layout patterns; static vs dynamic web presentation is not yet frozen;
- 1 homepage structure;
- 1 high-impact core homepage interaction/motion pattern.

Prefer one coherent family/system over 14 unrelated styles.

## Source priority

1. Open-source / permissive-license source with reusable code.
2. Commercial template/component with clearly compatible license.
3. High-quality public interaction/design references to reimplement.

For each candidate record:
- source URL/repository;
- visual role;
- code availability;
- license/reuse status;
- dependencies;
- implementation complexity;
- fit with current WordPress/Woo shell or deterministic HTML/CSS magazine renderer.

## Important constraint

“Copy source directly” is allowed only when the code/license actually permits reuse.

If license is absent, unclear, restrictive, or assets are copyrighted:
- do not copy;
- treat it as visual/interaction reference only;
- reimplement the pattern independently.

## Output

Owner-ready shortlist should include:

- homepage: 3 strongest candidates;
- core interaction/motion: 3 strongest candidates;
- magazine pages: enough source/layout candidates to cover the 12-page page map, preferably from a small number of coherent families;
- recommended combination into one design system;
- exact items that can be legally/source-wise vendored or copied;
- exact items that must be recreated rather than copied.

No implementation in this Gate.

## Scope not included

Do not:
- change WordPress/runtime;
- build the 12 pages;
- implement motion;
- mutate Woo/payment/account/private workspace;
- call production AI;
- deploy to VPS;
- merge PR #64.

## ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:

1. Strong reusable candidates exist for homepage, core interaction and 12-page magazine coverage.
2. License/source status is explicit for every candidate.
3. Recommended combination is visually coherent.
4. The recommended implementation can share one design-token/component system.
5. No protected runtime/backend scope is touched.

## REVIEWER_TO_EXECUTOR_RELAY

Research only:
1. this Gate;
2. Owner decision `OWNER_DECISION_G3CR6R3C_TEMPLATE_FIRST_VISUAL_SOURCING.md`;
3. MVP page map from `MVP_PRODUCT_CONTRACT.md` sections 5–7;
4. current rejected magazine contact sheet only as negative baseline.

Do not pre-filter the 12 magazine-page candidates by static/dynamic behavior. Record whether each candidate is static, lightly animated, or interaction-driven and what would remain compatible with the current PDF deliverable.

Search broadly beyond ecommerce templates:
- editorial/magazine templates;
- award-style interactive sites;
- open-source frontend components;
- Codrops/GSAP/open-source motion examples;
- web-to-print/editorial layouts.

Do not implement yet.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：只新增研究/候选资料，不改运行态。
验证：说明候选来源、license/source status 和 12+1+1 覆盖度。
问题：NONE，或具体许可/适配阻塞。
回滚：研究型 Gate，无运行态回滚需求。
请 Reviewer 检查：哪些可以直接合法复用、哪些只能参考重写，以及组合后是否统一。
Owner 转交：NONE
```

Stop at Reviewer.
