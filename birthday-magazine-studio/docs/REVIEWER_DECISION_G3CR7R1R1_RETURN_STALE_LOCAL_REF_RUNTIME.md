# Reviewer Decision — G3CR7R1R1 RETURN: Executor Local Ref Stale + Local Runtime Unavailable

> Date: 2026-10-05
> Governance: vps-project-governance v0.2.7
> Executor return: `RETURN_G3CR7R1R1_CANDIDATE_DRIFT`
> Authoritative PR: #64
> Fresh Reviewer PR head: `c01843de4fb8bc139030930ad12caeb9ebbcd2b3`
> Accepted independent source anchor: `88f45f5d712e3c1fe26f4386628703716b8eca3e`

## Decision

```text
FORMAL_DECISION=RETURN_EXECUTOR_STALE_LOCAL_REF_AND_RUNTIME_UNAVAILABLE
AUTHORITATIVE_PR_DRIFT=NO
EXECUTOR_LOCAL_REF_STALE=YES
EXECUTOR_REPORTED_PR_HEAD=97aceb4a1a9990f2e203e90de8bd5965202d63b8
FRESH_GITHUB_PR_HEAD=c01843de4fb8bc139030930ad12caeb9ebbcd2b3
INDEPENDENT_SOURCE_ANCHOR=88f45f5d712e3c1fe26f4386628703716b8eca3e
CURRENT_PR_DESCENDS_FROM_88F45=YES
CURRENT_PLUGIN_SOURCE_MATCHES_88F45=YES
FRONTEND_REPRODUCTION_PRESENT=YES
BIRTHDAY_MAGAZINE_POC_USES_FRONTEND_REPRODUCTION=YES
STALE_REFERENCE_FILES_STILL_PRESENT=YES
LOCAL_WEB_RUNTIME=UNAVAILABLE_EXECUTOR_REPORTED
PR64_MERGE=0
```

## Reconciliation

Fresh GitHub read-back disproves authoritative candidate drift.

PR #64 currently points to `c01843de...`. Comparing `88f45f5d...` -> `c01843de...` shows only Reviewer documentation/Handoff commits; the G3CR7R1 implementation source is unchanged.

At both `88f45f5d...` and current PR head `c01843de...`:
- `birthday-magazine-poc.php` blob is `0aa39e131b7958652bc0cfbd4ada7a4621fb3caf`;
- `frontend-reproduction.php` blob is `db3af21e56fe2683b20020ae25cda0fbf6a8f5a1`;
- `frontend-reproduction.css` blob is `25290020736b4a523aa7233d2baa5d63004b83fa`;
- `frontend-reproduction.js` blob is `cbd67a7dc0897e87e4c7bc4edb017a1e138d2e6a`;
- `preview.js` remains accepted baseline blob `bf60295a2236eb96e0c358158653b05b95b1f390`.

The Executor-reported `97aceb4a...` is the **pre-G3CR7R1 execution head**. At that old commit `birthday-magazine-poc.php` did still reference `frontend-flow.php`; therefore the Executor correctly stopped given its local view, but that local view was stale relative to canonical GitHub.

The six Reviewer-reference files remain present in current PR history/tree, but current authoritative runtime source no longer references them. They remain eligible for the previously requested exact cleanup after fresh remote synchronization.

## Runtime classification

Executor reports:
- G3C containers appear running;
- host request to `http://127.0.0.1:8189/` is connection-refused.

This is **not source drift**. Under Governance 11C, container state and web health are separate layers. Do not assume a restart fixes it and do not replay frontend tests.

The next Gate must first diagnose:
1. exact G3C container state;
2. published port binding;
3. web process health inside the WordPress container;
4. container-local HTTP reachability;
5. host-side `127.0.0.1:8189` reachability;
6. DB health only as needed to explain web failure.

A single exact WordPress-container start/restart may be used only if diagnosis identifies a stopped/unhealthy web process and no broader recreate/pull/build/storage action is required.

## Preserved accepted evidence

Do not invalidate or replay the already reviewed G3CR7R1 evidence for:
- independent reproduction from `e71f943...`;
- homepage entry;
- five-step intake desktop/mobile;
- 12–25 photos / <=3 must-use;
- six prompts + review;
- Free Preview `blob:` / no-photo-POST boundary;
- native Woo checkout handoff;
- forged-query payment negative;
- PHP/JS validation.

Only clean-source boundary + actual Woo order-received positive integration remain open.

## Next authority

Current Gate:
- `docs/G3CR7R1R2_REMOTE_REF_AND_RUNTIME_RECONCILIATION.md`
