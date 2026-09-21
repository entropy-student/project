# Reviewer Decision — K3R2 Pre-K3 Parallel Baseline Comparison

Date: 2026-09-21
Status: APPROVED TO EXECUTE

## Gate

`K3R2_PRE_K3_PARALLEL_BASELINE_COMPARISON`

## Why this Gate

K3R1 established two separate facts:

1. Active WooCommerce PayPal Payments 4.1.3 directly causes the blank Payments-page failure; deactivation restores the native Payments UI.
2. WooCommerce Home, wc-admin REST, and Store API timeouts remain after PPCP is deactivated.

Therefore the broader runtime failure is not yet isolated to PPCP.

The next step must determine whether the broader failure:

- already exists in the accepted pre-K3/K2 baseline, or
- was introduced during K3 execution/runtime changes.

## Authorized approach

Do NOT overwrite the current Studio site.

Create a separate temporary diagnostic WordPress Studio site from the retained pre-K3 backup:

`pre-k3-backup.zip`

Use a separate site name, path, and local port.

The current Mini Craft Studio site must remain unchanged with PPCP still deactivated.

## A/B comparison

Compare:

### A — Current site
- current K3/K3R1 state;
- PPCP inactive;
- existing WooCommerce Home/API timeout symptoms.

### B — Parallel pre-K3 clone
- restored from the pre-K3 backup created before WooCommerce PayPal Payments installation/configuration;
- no K3 payment mutation;
- do not install/activate PPCP in the clone.

## Required checks on BOTH A and B

- WordPress Home/front-end HTTP;
- wp-admin basic page;
- WooCommerce Home / `page=wc-admin`;
- WooCommerce Settings → Payments;
- `/wc-admin/features`;
- `/wc-admin/options`;
- Store API products;
- Store API cart;
- Product page;
- Cart;
- Checkout baseline;
- PHP worker CPU / hang behavior;
- elapsed response time / timeout behavior.

## Interpretation

If B is healthy while A remains unhealthy:

```text
PASS_CANDIDATE_K3R2_K3_REGRESSION_CONFIRMED
PRE_K3_BASELINE_HEALTHY=YES
CURRENT_SITE_RUNTIME_REGRESSION=YES
```

Return to Reviewer. Do not restore A yet.

If both A and B fail similarly:

```text
RETURN_K3R2_STUDIO_OR_WOOCOMMERCE_RUNTIME_SYSTEMIC
```

This indicates the broader issue is not a K3-only mutation and requires a different runtime/database diagnostic.

If B cannot be created/imported without changing A:

```text
RETURN_K3R2_PARALLEL_CLONE_NOT_SAFE
```

Do not overwrite A.

## Explicitly forbidden

- restoring the pre-K3 backup over the current site;
- deleting current site data;
- reactivating PPCP;
- plugin/version upgrades or downgrades;
- database migration;
- PayPal re-authorization;
- public tunnel;
- VPS/Cloudflare/prod changes;
- real payment.

## Evidence

Update:

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Record exact A/B results and local-only clone path/port. Clean up temporary diagnostic helpers, but keep the parallel clone until Reviewer decides whether it is needed for recovery.

Stop at Reviewer.