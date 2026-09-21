# Reviewer Decision — K3R3 Studio / WooCommerce Runtime Isolation

Date: 2026-09-21
Status: APPROVED TO EXECUTE

## Gate

`K3R3_STUDIO_WOOCOMMERCE_RUNTIME_ISOLATION`

## Accepted K3R2 result

K3R2 returned:

`RETURN_K3R2_STUDIO_OR_WOOCOMMERCE_RUNTIME_SYSTEMIC`

Current site A and the separate pre-K3 clone B both reproduce the same request-hang pattern. B has no PPCP installed, so the broader runtime failure is not a K3/PPCP-only regression.

Observed common symptom:

- front-end/admin/WooCommerce/Store API requests time out;
- one native Studio PHP worker consumes approximately one full core;
- both sites are listening normally on their local ports.

## Goal

Separate three possibilities:

1. WordPress Studio native runtime / host problem;
2. WooCommerce 10.0.4 + Studio SQLite/native-PHP compatibility problem;
3. Mini Craft imported database/configuration problem.

## Protect current site A

Current site A is READ-ONLY for this Gate.

- keep PPCP deactivated;
- do not restore or overwrite A;
- do not change plugins/theme/database/configuration on A;
- no PayPal activity.

## Diagnostic control C — fresh Studio

Create one temporary fresh WordPress Studio site C using the same Studio version/runtime family as A/B.

Prefer the same WordPress and PHP versions as A/B where Studio allows it.

Use a separate site name, directory and port.

### C0 — clean WordPress control

Before installing WooCommerce, verify:

- front page;
- wp-admin;
- core REST `/wp-json/`;
- repeated simple requests;
- PHP worker CPU / hang behavior.

Interpretation:

- if C0 already hangs, return `RETURN_K3R3_STUDIO_RUNTIME_SYSTEMIC`;
- do not continue installing WooCommerce.

### C1 — WooCommerce-only control

If C0 is healthy, install ONLY official WooCommerce `10.0.4`.

Do not install Kadence, Starter Templates, PPCP or other project plugins.

Do not run payment onboarding.

Verify:

- front page / wp-admin;
- WooCommerce Home;
- WooCommerce Settings → Payments;
- `/wc-admin/features`;
- `/wc-admin/options`;
- Store API products/cart;
- PHP worker CPU / timeout behavior.

Interpretation:

- C0 healthy + C1 hangs => `RETURN_K3R3_WOOCOMMERCE_STUDIO_COMPATIBILITY`;
- C0 healthy + C1 healthy => continue with B isolation below.

## Diagnostic clone B — imported-data isolation

B is the retained pre-K3 clone on its separate port.

Changes are allowed ONLY on B.

1. Record B active plugins/theme and current failure state.
2. Temporarily deactivate WooCommerce on B.
3. Restart only B once if required.
4. Test front page, wp-admin, core REST, and PHP worker behavior.

If B recovers with WooCommerce off while C1 is healthy, the failure is project/imported-data/configuration specific. Return:

`PASS_CANDIDATE_K3R3_IMPORTED_WOOCOMMERCE_STATE_ISOLATED`

If B still hangs even with WooCommerce off while C0/C1 are healthy, return:

`RETURN_K3R3_IMPORTED_WORDPRESS_STATE_OR_PLUGIN_STACK`

Do not broaden plugin/theme changes beyond this Gate.

## Explicitly forbidden

- modifying current site A;
- reactivating PPCP;
- PayPal login/authorization;
- plugin upgrades/downgrades on A or B;
- WooCommerce version other than 10.0.4 on control C;
- database migration;
- VPS/Cloudflare/public tunnel;
- real payment;
- production changes.

## Evidence

Update:

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Record the C0/C1/B matrix, exact runtime versions, HTTP results, timeouts, and CPU-worker observations.

Keep B and C until Reviewer decides cleanup/recovery.

Stop at Reviewer.