# K6 D-R6 — Bootstrap Reconciliation + Private App Validation Execution Pack

Gate:
`K6_PHASE_D_R6_BOOTSTRAP_RECONCILIATION_AND_PRIVATE_APP_VALIDATION`

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_D_R5_RETURN_D_R6_BOOTSTRAP_RECONCILIATION.md`;
- latest `EXECUTION_EVIDENCE.md`;
- latest `EXECUTOR_HANDOFF.md`;
- unique current Shared VPS Handoff;
- accepted digest-pinned private runtime and restored DB/wp-content state.

## Objective

Validate the already-running private WordPress runtime now that its core files are present. Do not recreate/restart/reimport. Prove bootstrap + installed state, update only scalar home/siteurl, then validate private application/WooCommerce/Sandbox state.

## Accepted baseline

- MariaDB restore accepted: exact 52-table root/app sets; wp_options present.
- WordPress image digest/platform/entrypoint/command accepted.
- /var/www/html tmpfs 512 MiB accepted.
- wp-content bind accepted.
- nine WordPress Secret mounts read-only; db-root absent.
- source/runtime WordPress core present.
- WordPress running, restart count 0, no host ports.
- MariaDB running healthy, no host ports.
- no public ingress.

## Phase A — fresh no-write readiness

Verify:
1. strict SSH identity/pin and target;
2. WordPress + MariaDB running;
3. zero host ports;
4. WordPress restart count stable;
5. runtime core still present;
6. MariaDB healthy;
7. root + app each see exact expected 52 tables;
8. wp_options exists;
9. unrelated containers/services/network/80-443 ownership unchanged;
10. no public Mini Craft route introduced.

Any material drift -> RETURN.

## Phase B — bootstrap

Run a bounded in-container WordPress/PHP bootstrap check.

Requirements:
- load current WordPress runtime against existing DB;
- output only boolean/status metadata;
- no wp-config/Secret/database-row/business-content output;
- prove WordPress core bootstrap completes without fatal;
- prove installed-state true using a WordPress-native check.

Expected:
`WORDPRESS_BOOTSTRAP=PASS`
`WORDPRESS_INSTALLED_STATE=PASS`

If bootstrap fails with core present:
`RETURN_REVIEWER_D_R6_BOOTSTRAP_FAILED_WITH_CORE_PRESENT`

Do not recreate or restart.

## Phase C — exact scalar origin update

Only if Phase B passes.

Update exactly:
- wp_options.option_name='home'
- wp_options.option_name='siteurl'

to:
`https://minicraft.spikersun.com`

Use exact row-scoped DB updates.

Verify:
- both rows exist;
- both exact values equal target;
- no other option row was intentionally changed.

Do not print unrelated option values.

Record:
`FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`

## Phase D — private application validation

Use only private/in-container/Docker-network access. No host port.

Validate:
- no installer state/redirect;
- home;
- /shop/;
- /product/mini-craft-night-kit/;
- /cart/;
- /checkout/;
- /my-account/;
- /wp-json/;
- restored wp-content/media presence;
- WooCommerce active/core state;
- expected product/order schema;
- PayPal remains Sandbox / Live disabled using metadata/config-state only;
- recent filtered startup/application logs have no PHP fatal/bootstrap error;
- MariaDB stays healthy;
- WordPress restart count stable;
- unrelated services unchanged.

Because full serialized migration is deferred, do not fail solely because some legacy content fields still contain localhost:8093. Record those only as next-Gate work if observed.

## Forbidden

No:
- WordPress recreate/restart;
- MariaDB import/retry/drop/recreate;
- wp-content re-restore;
- image pull/build;
- broad SQL replacement;
- serialized URL migration;
- Caddy/cloudflared/DNS/UFW/SSH/Docker-daemon/shared-network mutation;
- host port/public ingress;
- Secret output/hash/rotation/overwrite;
- PayPal Live/payment/refund;
- unrelated project changes.

## Return semantics

Any RETURN -> stop immediately. No post-return cleanup or lifecycle action.

## Evidence markers

```text
WORDPRESS_RUNTIME_CORE=
MARIADB_RESTORE_STATE=
ROOT_TABLE_COUNT=
APP_TABLE_COUNT=
WP_OPTIONS_PRESENT=
WORDPRESS_BOOTSTRAP=
WORDPRESS_INSTALLED_STATE=
HOME_SITEURL_SCALAR_UPDATE=
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_PRIVATE_PRIMARY_ROUTES=
WP_CONTENT_MEDIA_STATE=
WOOCOMMERCE_CORE_STATE=
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO
WORDPRESS_RECENT_FATALS=
WORDPRESS_RESTART_COUNT=
DB_PUBLIC_PORT=NONE
WORDPRESS_HOST_PORT=NONE
PUBLIC_INGRESS_CHANGE=0
UNRELATED_SERVICES_CHANGED=
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

## Return

Success:
`PASS_CANDIDATE_K6_PHASE_D_R6_BOOTSTRAP_RECONCILIATION_AND_PRIVATE_APP_VALIDATION`

Otherwise precise `RETURN_*`.

Do not enter serialized migration or public ingress after this Gate.
