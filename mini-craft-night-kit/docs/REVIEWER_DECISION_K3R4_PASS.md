# Reviewer Decision — K3R4 PASS

Date: 2026-09-21

## Decision

```text
REVIEW_DECISION=PASS_K3R4_DOCKER_MARIADB_LOCAL_RECOVERY
K3R4_LOCAL_RUNTIME_ESCAPE_DOCKER_MARIADB=PASS
ACTIVE_LOCAL_RUNTIME=DOCKER_MARIADB
ACTIVE_LOCAL_URL=http://localhost:8093/
WORDPRESS_STUDIO_RUNTIME=RETAINED_READ_ONLY_NOT_ACTIVE
```

## Accepted evidence

- D0 clean Docker WordPress control passed with repeated low-latency responses and no one-hot worker.
- D1 official WooCommerce 10.0.4 on Docker/MariaDB passed WooCommerce Home, Payments, wc-admin API, Store API, Product, Cart and Checkout.
- D2 recovered the accepted pre-K3 Mini Craft state into an isolated Docker/MariaDB runtime.
- K1B UI/content remained intact.
- K2 commerce surfaces remained intact.
- MariaDB normal stock reservation was revalidated with a pending test order and `wc_reserved_stock` entry.
- Studio `hold_stock_minutes=0` workaround was not carried forward as the local runtime policy.
- PPCP is absent from the recovered runtime.
- no PayPal authorization, real payment, VPS, production domain, or secret exposure occurred.

## Runtime truth change

The active local development/test runtime is now:

```text
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery
http://localhost:8093/
Docker Compose + WordPress + MariaDB
```

WordPress Studio A/B/C0 are retained only for evidence/rollback and must not be treated as the active execution environment.

## Carry-forward

- PPCP 4.1.3 had a separate confirmed Payments-page React mount failure on the Studio path.
- That defect must be re-tested from a clean install on the Docker/MariaDB runtime before PayPal authorization resumes.
- K3 PayPal Sandbox itself is still incomplete.

## Next Gate

`K3R5_PAYPAL_SANDBOX_DOCKER`

Do not enter K4 until K3 PayPal Sandbox is either passed or explicitly waived by a later Reviewer decision.