# Reviewer Decision — K3R6 PPCP Page-Scope Mount Isolation

Date: 2026-09-21
Status: APPROVED TO EXECUTE

## Gate

`K3R6_PPCP_PAGE_SCOPE_MOUNT_ISOLATION`

## Accepted K3R5 finding

K3R5 reproduced React #299 from `ppcp-settings-js-index.js` on the healthy Docker/MariaDB runtime.

At the same time, WooCommerce Home, Payments outer UI, the direct PayPal settings section HTTP response, PPCP REST endpoints, wc-admin REST, Store API, Product/Cart/Checkout, and runtime health all remained responsive.

Therefore K3R5 confirms a PPCP admin React mount defect, but does NOT yet prove that the actual direct PayPal settings screen itself is unusable.

## External/source rationale

The current PPCP settings bundle calls React `createRoot(document.getElementById('ppcp-settings-container'))` directly. The PHP container is injected through the PayPal gateway admin-options wrapper. A page-scope mismatch can therefore produce React #299 on a page where the script loads but the container is absent.

Do not change WooCommerce or PPCP versions yet.

## Target runtime

Only:

`http://localhost:8093/`

Keep the K3R5 rollback backup intact.

## Test A — WooCommerce Payments overview

Open exactly:

`/wp-admin/admin.php?page=wc-settings&tab=checkout`

Record:

- HTTP status;
- whether native Payment providers render;
- count/presence of `#ppcp-settings-container`;
- whether `ppcp-settings-js-index.js` loads;
- exact Console errors;
- whether React #299 occurs on this overview page.

## Test B — direct PayPal settings section

Open exactly:

`/wp-admin/admin.php?page=wc-settings&tab=checkout&section=ppcp-gateway`

Use a clean hard reload/new browser context if needed to avoid carrying Console state from Test A.

Record:

- HTTP status;
- count/presence of `#ppcp-settings-container`;
- whether the PayPal React UI actually renders inside that container;
- whether `Connect to PayPal` / onboarding controls are visible and interactive;
- Console errors scoped only to this page load;
- `wc_paypal/settings` and `wc_paypal/payment` network results;
- wc-admin and Store API smoke;
- runtime CPU/latency.

## Decision matrix

### Case 1 — overview-only React #299

If Test A has React #299 with no PPCP container, but Test B has exactly one PPCP container, renders the PayPal UI correctly, has no blocking React exception on the direct section, and onboarding controls are usable:

```text
PASS_CANDIDATE_K3R6_PPCP_OVERVIEW_ONLY_UI_DEFECT
PPCP_DIRECT_SETTINGS_UI=PASS
PPCP_OVERVIEW_REACT_299=KNOWN_NONBLOCKING_ADMIN_DEFECT
```

Then continue in the SAME Gate only until the actual provider-side Owner login/consent boundary and return:

`RETURN_OWNER_PAYPAL_SANDBOX_AUTH_REQUIRED_DOCKER`

Do not click through Owner login yourself.

### Case 2 — direct PayPal section also broken

If Test B is blank, has zero mount targets, React #299 occurs on the direct PayPal section, or onboarding controls cannot be used:

```text
RETURN_K3R6_PPCP_DIRECT_SETTINGS_UI_BROKEN
```

Stop at Reviewer. Do not downgrade/upgrade plugins or WooCommerce in this Gate.

### Case 3 — inconsistent result

If the result changes between reloads or cannot be scoped confidently:

`RETURN_K3R6_PPCP_UI_SCOPE_INCONCLUSIVE`

## Safety

- no plugin version change;
- no WooCommerce/WordPress version change;
- no source patch/hotfix;
- no DOM injection workaround;
- no manual credential entry;
- no PayPal login by Executor;
- no Live;
- no real payment;
- no public tunnel/VPS;
- no Studio writes.

## Evidence

Update:

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Capture A and B separately so Console state from one page is not attributed to the other.

Stop at Reviewer on any defined RETURN.