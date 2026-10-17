# Reviewer Decision — G3S4R RETURN_BROWSER_TARGET_UNVERIFIED

> Date: 2026-10-17
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7
> Reviewed Gate: `docs/G3S4R_SAFE_LOCAL_TARGET_AND_STRIPE_TEST_CONTINUATION_2026-10-17.md`
> Owner-approved Gate: `docs/OWNER_AUTHORIZATION_G3S4R_SAFE_TARGET_TEST_ONLY_2026-10-17.md`
> Directly inspected PR #64 Evidence: `docs/evidence/g3s4/G3S4R_BROWSER_TARGET_RETURN_2026-10-17.md` at exact commit `777463995a298118dae0c6763f6c668207a19350`, blob `ec5a6189c23110a6a8d9bbb0b682b037d4df8a5d`
> Provenance: GitHub Evidence and commit independently read; local Windows/Docker results are Executor-direct-host readbacks recorded in Evidence, NOT Reviewer direct access.

## Formal decision

```text
GATE_ID=G3S4R_SAFE_LOCAL_TARGET_AND_STRIPE_TEST_CONTINUATION_20261017
EXECUTOR_RETURN=RETURN_BROWSER_TARGET_UNVERIFIED
REVIEWER_DECISION=RETURN_BROWSER_TARGET_UNVERIFIED
G3S4R_FULL_TEST_PAYMENT_GATE=NOT_PASS
G3S4R_PREFLIGHT_RUNTIME_SOURCE=PASS_FOR_THIS_ROUND_EXECUTOR_EVIDENCE
G3S4R_PRIOR_SELECTED_BACKUP_PRESENT_SIZE_HASH=PASS_FOR_THIS_ROUND_EXECUTOR_EVIDENCE
G3S4R_BACKUP_NEW_EXPORT_OR_RESTORE=NOT_RUN_NO_NEED
G3S4R_COMPUTER_USE_TARGET=NOT_IDENTIFIED_REQUIRED_STOP
G3S4R_BROWSER_OBSERVED=WINDOWS_NATIVE_EDGE_NOT_PROVEN_MATCH_EMBEDDED_BROWSER
G3S4R_WP_ADMIN_LOGIN_REDIRECT=OWNER_RELAY_ONLY_NOT_RECORDED_IN_PR_EVIDENCE
WC_STRIPE_PLUGIN_VERSION=11.1.0_INSTALLED_INACTIVE
WC_STRIPE_REGISTERED_GATEWAY=NOT_READY_INACTIVE_PLUGIN
STRIPE_TEST_PROVIDER_CONNECTED=NO
STRIPE_TEST_ORDER_CALLBACK_REFUND=NOT_RUN
LOCAL_DIRTY_WORKTREE=17_DELETED_3_MODIFIED_180_UNTRACKED_PRESERVED
PR64_HEAD=777463995a298118dae0c6763f6c668207a19350
PR64_STATUS=OPEN_UNMERGED
EXACT_DIFF=ONE_ADDED_46_LINE_EVIDENCE_MD_NO_APP_SOURCE_MUTATION
OWNER_G3S4R_AUTHORIZATION=CONSUMED_AFTER_STOP_NO_AUTOMATIC_RESUME
NEXT_GATE=G3S4M_OWNER_MANUAL_AUTH_AND_VERIFIED_LOCAL_STRIPE_TEST_CHANNEL_20261017_PENDING_NEW_OWNER_PAYMENT_AUTH
```

## Review facts and boundary

1. PR #64 commit `777463995a298118dae0c6763f6c668207a19350` is one new commit after `7397dd3bb7ab5fe62bb8575185d51405391f2c63`; compare returns exactly one added `docs/evidence/g3s4/G3S4R_BROWSER_TARGET_RETURN_2026-10-17.md` (46 lines), no application changes; PR remains Open/unmerged.
2. G3S4R recorded local existing DB and WordPress runtime healthy, WP 7.1.1, Woo 11.1.2 active, official Stripe plugin 11.1.0 **inactive**, Woo virtual product #1113 USD39.99, HTTP 200 at loopback-only `127.0.0.1:8189` and 44/44 Git-clean-filter source blob matches against previous PR head.
3. Selected G3S4 backup under `%LOCALAPPDATA%\BirthdayMagazineStudio\G3S4\20261016T153123Z-90703d65` had the same three protected files' size and SHA-256 values as the earlier accepted historical report. Verified by Executor in this round without exporting/restoring. G3S4E previously documented isolated offline 58-table, 18,109 WP file, 387 upload recovery. Do not repeat it without new concrete drift; note new writes after that snapshot would require assessing rollback currency.
4. Existing local dirty status is now 200 items: 17 tracked deletions, 3 modifications, 180 untracked (one more than the prior 179, cause/path **UNKNOWN**); no changed source overwritten. If next Gate owns no source changes, this alone is not reason to reset or rebuild.
5. Computer Use enumerated native Windows Edge, had an invalidated window handle and stopped because it could not sufficiently identify the active browser URL. Evidence suggests an **embedded-browser/native-Edge surface mismatch**, but the precise root cause is not independently proven. It is NOT evidence Stripe failed.
6. The Owner relayed a **later** observation that the Woo settings URL redirected to the correct loopback WordPress login page. This is not in the exact PR Evidence. It is an account-login checkpoint report, not proof the browser-control tool can identify its target.
7. Stripe plugin being **inactive** explains the missing Stripe gateway: even if WordPress admin login completes, a separate reviewed TEST-only activation step is required. Do not claim navigating Woo Settings makes Stripe configurable before activation.
8. No Stripe account/OAuth, Woo payment settings, gateway activation, webhook, checkout or refund mutation occurred. The previous Computer Use stop must be honored. Repeatedly invoking it on the same mismatched surface will not fix the problem.

## Reviewer-approved design direction (not immediate authorization)

**Computer Use is not a Stripe integration dependency.** Future processing should **separate** (i) Owner manual navigation/login/Stripe OAuth consent in the browser from (ii) verified local WordPress runtime administration and read-only readback via already known WP-CLI/local process tooling, plus TEST-only provider events and checkout conducted within explicitly authorized boundaries.

This is a **new reviewed execution-channel design**, not permission to circumvent the stopped Computer Use call. The controlling interface for the Owner's manual actions is the Owner alone, not a tool with an unidentifiable browser URL. For programmatic host operations, source/runtime identity must be proven independently by exact container/project/loopback/option-readback/backup invariants. If an operation technically requires browser automation and the tool cannot identify its URL, STOP that operation; do not switch automation tools to evade the refusal.

Open a **single G3S4M Gate** with two ordered checkpoints: Owner manual WordPress login to the correct local host (no plugin change), then independently verified Test-only plugin activation/account connection/synthetic checkout and signed Webhook/refund only after **fresh explicit Owner approval for the new round** and all guards PASS. Prefer not to split payment testing into more unnecessary broad-research/backup Gates; stop if the verified native route is not available.

No need to repeat current local source/backup-hash verification absent new drift; next Executor should check minimal freshness before any write. Neither static Netlify nor real Stripe payouts are validated here.
