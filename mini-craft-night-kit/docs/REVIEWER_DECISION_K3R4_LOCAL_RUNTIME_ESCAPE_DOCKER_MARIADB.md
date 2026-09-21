# Reviewer Decision — K3R4 Local Runtime Escape to Docker/MariaDB

Date: 2026-09-21
Status: APPROVED TO EXECUTE

## Gate

`K3R4_LOCAL_RUNTIME_ESCAPE_DOCKER_MARIADB`

## Accepted finding

K3R3 proved that a completely fresh WordPress Studio site C0, with no WooCommerce, Kadence, PPCP, project database, or payment configuration, reproduces the same request timeout / one-hot PHP worker behavior.

Therefore:

```text
STUDIO_RUNTIME_SYSTEMIC_FAILURE=CONFIRMED
PPCP_IS_NOT_THE_ROOT_CAUSE_OF_THE_BROADER_TIMEOUT=CONFIRMED
WOO_COMMERCE_IS_NOT_REQUIRED_TO_TRIGGER_THE_BROADER_TIMEOUT=CONFIRMED
```

PPCP 4.1.3 still has a separate confirmed Payments-page React mount defect in the affected Studio path, but that is not the broader runtime root cause.

## Objective

Move local execution away from WordPress Studio without touching production.

Target local runtime:

```text
Docker Compose
→ WordPress
→ MariaDB
```

Use a NEW isolated Docker project. Do not overwrite the retained K0 Docker PoC or any Studio site.

## Protection

Keep read-only / retained:

- A: current Studio site on 8881, PPCP inactive;
- B: pre-K3 Studio clone on 8882;
- C0: clean Studio control on 8883;
- retained pre-K3 backup;
- retained K0 Docker PoC on 8090;
- old project on 8088.

## Phase D0 — Docker engine and clean WordPress control

1. Verify Docker Engine is available.
2. Create a new project-local Docker Compose stack on a new unused port.
3. Use separate WordPress and MariaDB containers/volumes.
4. Do not import Mini Craft data yet.
5. Verify clean WordPress:
   - front page;
   - wp-admin;
   - `/wp-json/`;
   - repeated requests;
   - container CPU / request latency.

If Docker Engine is unavailable:

`RETURN_K3R4_DOCKER_ENGINE_UNAVAILABLE`

If clean Docker WordPress also hangs:

`RETURN_K3R4_HOST_RUNTIME_SYSTEMIC`

## Phase D1 — WooCommerce control

If D0 is healthy:

- install only official WooCommerce 10.0.4;
- no Kadence/PPCP/payment onboarding yet;
- test WooCommerce Home, Payments, wc-admin API, Store API, Product/Cart/Checkout baseline;
- verify MariaDB-backed stock/session/runtime behavior.

If D0 healthy but D1 fails:

`RETURN_K3R4_WOOCOMMERCE_DOCKER_COMPATIBILITY`

## Phase D2 — Recover the accepted pre-K3 Mini Craft state

If D1 is healthy, create/restore a separate Mini Craft Docker runtime from the retained pre-K3 state (K1B + K2 accepted state).

Requirements:

- preserve current Studio A/B/C0 untouched;
- preserve K1B UI/content and K2 commerce configuration;
- production/test-only distinctions remain documented;
- use MariaDB as the local database;
- normal WooCommerce stock reservation must be restored/retested instead of carrying forward Studio's `hold_stock_minutes=0` workaround.

Use the safest supported migration path available from the retained pre-K3 artifact/site.

If the retained Studio backup is not directly portable to MariaDB without an ad-hoc/custom database conversion, STOP and return:

`RETURN_K3R4_MIGRATION_PATH_REVIEW_REQUIRED`

Do not invent a custom SQLite→MariaDB converter inside this Gate.

## D2 required smoke

After migration/recovery, verify:

- Home;
- Product;
- Cart;
- Checkout;
- Orders admin;
- Gutenberg validity/editability;
- 375px responsive smoke;
- WooCommerce Home;
- wc-admin API;
- Store API;
- normal stock-hold semantics on MariaDB;
- no Studio-style one-hot worker hang.

## PayPal boundary

Do NOT resume PayPal Sandbox in K3R4.

PPCP remains out of the recovered runtime until Reviewer reviews D2 health.

No PayPal authorization, credentials, callback, webhook, capture, refund, Live, or real payment.

## Evidence

Update:

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

PASS candidate:

```text
PASS_CANDIDATE_K3R4_DOCKER_MARIADB_LOCAL_RECOVERY
DOCKER_CLEAN_WORDPRESS=PASS
DOCKER_WOOCOMMERCE_CONTROL=PASS
PRE_K3_MINI_CRAFT_STATE_RECOVERED=PASS
MARIADB_RUNTIME=PASS
STUDIO_RUNTIME_BYPASSED=YES
K1B_UI_REGRESSION=PASS
K2_COMMERCE_BASELINE=PASS
NORMAL_STOCK_HOLD_REVALIDATED=PASS
PPCP_INSTALLED_OR_ACTIVE=NO
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
STOP_AT_REVIEWER=YES
```

Stop at Reviewer.