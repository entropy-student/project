# Reviewer Decision — K3R8E PASS / K3R9 Minimal Environment Isolation

Date: 2026-09-21
Status: K3R8E PASS; K3R9 APPROVED TO EXECUTE

## K3R8E Owner result

Owner executed the approved local-only K3R8E parity helper and returned only the required redacted result fields.

Accepted result:

```text
OAUTH_HTTP=200
ORDER_CREATE_HTTP=201
ORDER_GET_HTTP=200
PAYEE_OBJECT_PRESENT=YES
PAYEE_MERCHANT_ID_PRESENT=YES
PAYEE_EMAIL_PRESENT=YES
ERROR_CLASS=NONE
```

No credential values, access token, order ID, payee values, response body, headers, or debug ID are recorded in this repository.

## Reviewer conclusion

K3R8E is PASS.

The exact provider-side sequence required by the PPCP manual-connect payee probe succeeds outside PPCP on the same active Docker/MariaDB WordPress runtime:

1. Sandbox OAuth succeeds;
2. the minimal USD 1.00 Sandbox order is created successfully;
3. the order can be retrieved successfully;
4. the returned order contains the payee object, merchant ID, and email fields expected by PPCP.

Therefore the active PayPal Sandbox app/account and the tested provider request semantics are not the current isolated failure boundary.

The remaining failure boundary is the WooCommerce PayPal Payments 4.1.3 manual-connect client path, or an interaction affecting that path inside the WordPress/plugin environment.

This does not yet prove a core PPCP source-code defect because another active plugin, filter, cache layer, or local WordPress interaction could still alter PPCP behavior.

## Current external state

As reviewed on 2026-09-21, WooCommerce PayPal Payments 4.1.3 is the current official release. There is no newer official version available for a bounded upgrade test.

A recent public support report shows a materially similar symptom: direct Sandbox API authentication succeeds while PPCP 4.1.3 Manual Connect fails. Official support guidance there is to isolate the WordPress environment by temporarily deactivating all plugins except WooCommerce and WooCommerce PayPal Payments, clearing caches, and retrying Sandbox Manual Connect before escalating to support.

## K3R9 goal

Determine whether the PPCP 4.1.3 manual-connect failure is caused by another WordPress plugin/cache interaction or persists in a minimal supported plugin environment.

## K3R9 authorized scope

Executor may:

1. create/verify a rollback point for the active Docker/MariaDB runtime;
2. inventory active plugins and record only non-secret plugin/version data;
3. temporarily deactivate all nonessential plugins so only:
   - WooCommerce;
   - WooCommerce PayPal Payments;
   remain active;
4. clear only reversible WordPress/WooCommerce/PPCP caches/transients required for this test;
5. verify the direct PayPal settings page still renders;
6. stop at an Owner checkpoint for one Sandbox Manual Connect retry using Owner-entered credentials;
7. after the result, restore the prior plugin activation state exactly.

## Not authorized

- no plugin or WordPress version change;
- no PPCP source patch;
- no theme replacement in K3R9 Phase A;
- no Live mode;
- no real payment/capture;
- no public tunnel;
- no VPS deployment/write;
- no production credential;
- no credential persistence in GitHub/logs;
- no repeated blind reconnect attempts.

## Interpretation

- Manual Connect succeeds in the minimal plugin environment:
  - classify as WordPress/plugin interaction;
  - restore prior state;
  - isolate the conflicting plugin/filter in a separate Reviewer-authorized Gate.

- Manual Connect fails identically in the minimal plugin environment:
  - classify the failure boundary as PPCP 4.1.3/core-environment path rather than an unrelated active-plugin conflict;
  - restore prior state;
  - return to Reviewer for upstream escalation and/or a separately authorized source-level diagnostic.

## Current checkpoint

`K3R9_EXECUTOR_MINIMAL_ENV_PREP`

Executor must stop before Owner credential entry and provide rollback/readiness evidence.
