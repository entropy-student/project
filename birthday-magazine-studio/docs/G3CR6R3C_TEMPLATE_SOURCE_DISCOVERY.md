# G3CR6R3C — Template + Motion Source Discovery

## Gate

```text
GATE_ID=G3CR6R3C_TEMPLATE_SOURCE_DISCOVERY
OBJECTIVE=Under Owner reset, re-research the unresolved core Aha interaction and P1-P12 magazine visual/page system; preserve magazine-web-viewer as reader direction and Focusly only as homepage reference
MAX_ENDPOINT_THIS_ROUND=Reopened research package for core interaction + P1-P12, then Owner shortlist; no implementation
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Read-only web/source research and project-scoped research documentation only
APPLICABLE_CRITICAL_CONSTRAINTS=REAL_MONEY_ACTIONS_0; PAYPAL_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; RUNTIME_MUTATION_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0
PREFLIGHT=PR64 head must descend from the accepted reconciliation anchor; current Gate/research-contract/Owner-quality-bar must be readable in the execution workspace; only current-main changes affecting birthday-magazine-studio/** or an explicitly named shared Gate dependency constitute source drift
REQUIRED_EVIDENCE=Research Ledger; Source Coverage Map; S/A Shortlist; Reject Summary; 12+1+1 Coverage Map; Reuse Map; Saturation Evidence; Owner Gallery
ACCEPTANCE_CRITERIA=See ACCEPTANCE_CRITERIA section and mandatory Research Contract
ROLLBACK_STATUS_OR_PLAN=No runtime mutation; documentation/source research is Git-revertible; preserve PR64 branch-only accepted evidence during source-baseline repair
OWNER_ONLY_ACTIONS=NONE
REVIEWER_TO_EXECUTOR_RELAY=SEE_SECTION_BELOW
EXECUTOR_TO_REVIEWER_RELAY=SEE_SECTION_BELOW
```

Governance: **vps-project-governance v0.2.6**.

`RESEARCH_CONTRACT=MANDATORY`

Mandatory research contract:
- `docs/G3CR6R3C_TEMPLATE_DISCOVERY_RESEARCH_CONTRACT.md`
- `docs/OWNER_DECISION_G3CR6R3C_TEMPLATE_RESEARCH_QUALITY_BAR.md`

The Gate cannot PASS on a convenience shortlist that does not satisfy the research floor, evidence requirements, and saturation stop.

## Source-baseline preflight

Fresh Reviewer reconciliation on 2026-10-04 found:

- canonical `main` contains this Gate, the mandatory research contract and the current v0.2.6 Reviewer Handoff;
- existing PR #64 head `15ff73f6232e0ef94f04f313f74372e52389d1e2` does not contain this Gate/contract/quality-bar and still carries the older 2026-09-30 Handoff;
- PR #64 also contains 7 branch-only G3C/G3CR6R1 implementation/evidence commits that must be preserved.

That earlier preflight RETURN is now closed.

Fresh read-back after the bounded reconciliation:

```text
SOURCE_BASELINE_PREFLIGHT=PASS
RECONCILIATION_ANCHOR=83a8ad33ed70e2a391e4a4dacd71e0b812b15ef6
PR64_CURRENT_HEAD_REQUIREMENT=DESCENDANT_OF_RECONCILIATION_ANCHOR_AND_PROJECT_SCOPED_MAIN_BASELINE
WHOLE_REPOSITORY_MAIN_TIP_ANCESTRY_REQUIRED=NO
UNRELATED_MONOREPO_MAIN_COMMITS_BLOCK=NO
BASELINE_READBACK_AT_ANCHOR=AHEAD_8_BEHIND_0
PR64_MERGEABLE=YES
NON_PROJECT_DIFF_FILES=0
CURRENT_GATE_AND_CONTRACT_READBACK=PASS
BRANCH_ONLY_EVIDENCE_PRESERVATION=PASS
G3CR6R3C_RESEARCH_AUTHORIZED=YES
G3CR6R3C_RESEARCH_STARTED=YES
OWNER_RESEARCH_RESET_2026_10_04=ACTIVE
MAGAZINE_WEB_VIEWER=CONFIRMED_OK
HOMEPAGE_FOCUSLY=REFERENCE_ONLY_NOT_SELECTED
CORE_AHA_INTERACTION=UNRESOLVED_RESEARCH_AGAIN
MAGAZINE_P1_P12_VISUAL_SYSTEM=UNRESOLVED_RESEARCH_AGAIN
PRIOR_SATURATION=SUPERSEDED_FOR_CORE_INTERACTION_AND_P1_P12
```

Current Reviewer decision:
- `docs/REVIEWER_DECISION_G3CR6R3C_SOURCE_BASELINE_PASS.md`

The earlier `REVIEWER_DECISION_G3CR6R3C_TAKEOVER_SOURCE_BASELINE.md` remains historical RETURN provenance.

A subsequent Executor preflight correctly returned under the old whole-repository-main ancestry rule after `main` advanced only in `vpn-network-optimization/**`. Reviewer verified no Birthday Magazine path changed and replaced that overbroad rule with project-scoped freshness. See `docs/REVIEWER_DECISION_G3CR6R3C_PROJECT_SCOPED_PREFLIGHT_FIX.md`.

Executor preflight should now use a path-scoped comparison equivalent to `PR_HEAD..origin/main -- birthday-magazine-studio` (plus any extra Gate-declared shared paths). Empty scoped output means unrelated monorepo movement does not block research.

## Goal

Produce a high-quality reopened shortlist for:

- the complete P1-P12 magazine visual/page system; static vs dynamic web presentation is not yet frozen;
- 1 high-impact core homepage interaction/motion pattern whose described behavior is directly verified against the live work.

Preserved Owner direction:
- `magazine-web-viewer` is the accepted reader/viewer direction;
- Focusly is homepage reference only, not a selected homepage implementation;
- prior preferences for Wide, Stack-to-Content, Marginalia or other candidates are not selections.

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

Owner-ready reopened shortlist should include:

- core interaction/motion: 3 strongest **directly verified** candidates;
- magazine pages: enough complete source/layout families to cover the 12-page page map coherently, preferably from a small number of systems;
- homepage treatment only where needed to explain how the interaction fits the current site; Focusly remains reference-only;
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

Before PASS_CANDIDATE, the mandatory Research Contract must be satisfied in full.

PASS_CANDIDATE requires:

1. Strong reusable candidates exist for homepage, core interaction and 12-page magazine coverage.
2. License/source status is explicit for every candidate.
3. Recommended combination is visually coherent.
4. The recommended implementation can share one design-token/component system.
5. No protected runtime/backend scope is touched.
6. At least 60 distinct real candidates were directly inspected across at least 8 source ecosystems.
7. Every S/A candidate has reviewable visual/interaction evidence and explicit source/license status.
8. Reject ledger and 12+1+1 coverage map exist.
9. Saturation stop is proven by two consecutive >=10-candidate batches with no new first-order pattern and no material shortlist improvement.
10. If no S-grade candidate exists, the Gate returns `RETURN_RESEARCH_NOT_SATURATED` or `NO_QUALIFYING_CANDIDATE_YET` instead of lowering the bar.

## REVIEWER_TO_EXECUTOR_RELAY

Research only:
1. this Gate;
2. mandatory `G3CR6R3C_TEMPLATE_DISCOVERY_RESEARCH_CONTRACT.md`;
3. Owner quality-bar decision `OWNER_DECISION_G3CR6R3C_TEMPLATE_RESEARCH_QUALITY_BAR.md`;
4. Owner decision `OWNER_DECISION_G3CR6R3C_TEMPLATE_FIRST_VISUAL_SOURCING.md`;
5. MVP page map from `MVP_PRODUCT_CONTRACT.md` sections 5–7;
6. current rejected magazine contact sheet only as negative baseline.

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


## Owner research reset — 2026-10-04

See `docs/OWNER_DECISION_G3CR6R3C_RESEARCH_RESET_2026-10-04.md`.

The prior 91-candidate research package remains evidence/history, but its shortlist and saturation conclusion are not accepted as closure for CORE_AHA_INTERACTION or MAGAZINE_P1_P12_VISUAL_SYSTEM. Both surfaces must be researched again from an open candidate field. Do not treat prior Reviewer/Executor preference as selection.
