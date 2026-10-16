# Owner Authorization — G3S3R bounded start of existing G3C containers

> Date: 2026-10-16
> Provenance: `OWNER_REPORTED` direct explicit user message in the current conversation, **not** a Docker execution result
> Owner decision: "我没问题，开始吧，授权通过。"
> Parent Gate: `docs/G3S3R_EXISTING_LOCAL_RUNTIME_RECOVERY_AND_SOURCE_RECONCILIATION_2026-10-16.md`
> Prior Reviewer decision: `docs/REVIEWER_DECISION_G3S3_RETURN_PREFLIGHT_DRIFT_2026-10-16.md`
> Scope: **one** bounded local recovery attempt under this Gate only

## Exact approved action and condition

The Owner, after being told that MariaDB may perform internal crash recovery and update database state during startup, **explicitly approves** this G3S3R recovery round:

1. Phase A: inspect the actual Windows/Docker target, exact existing G3C container IDs, project-only volumes, mounts/port exposure, existing backup metadata, Docker health, source drift and existing local uncommitted modifications **read-only**.
2. **Only if** Phase A proves preflight safe and no data/source/volume/identity contradiction: start the already-existing G3C `db`, then `wordpress`, then `wpcli` **one time each by existing container ID** (not through `docker compose up`). Verify DB healthy before WordPress and WordPress healthy before WP-CLI.
3. Phase C: strictly read-only verification of current WooCommerce product #1113, official Stripe plugin activation/version and Woo payment settings (non-secret status only), current runtime source identity and localhost availability; record sanitized Evidence and **stop at Reviewer**.

```text
GATE_ID=G3S3R_EXISTING_LOCAL_RUNTIME_RECOVERY_AND_SOURCE_RECONCILIATION_20261016
OWNER_AUTHORIZATION=APPROVED
OWNER_APPROVED_ENDPOINT=ONE_CONDITIONAL_START_EXISTING_G3C_DB_WORDPRESS_WPCLI
PRECONDITION=PHASE_A_PREFLIGHT_PASS
MAILPIT_START=NOT_AUTHORIZED
COMPOSE_UP_OR_RECREATE=NOT_AUTHORIZED
OTHER_DOCKER_PROJECTS=DO_NOT_TOUCH
GIT_CLEAN_RESET_STASH_CHECKOUT_REBASE_MERGE=NOT_AUTHORIZED
LOCAL_DIRTY_SOURCE_OR_DELETED_SCREENSHOTS=PROTECT_AND_PRESERVE
DATABASE_IMPORT_RESTORE_MIGRATION=NOT_AUTHORIZED
WORDPRESS_PLUGIN_INSTALL_ACTIVATION_CONFIG=NOT_AUTHORIZED
STRIPE_PROVIDER_CONNECT_WEBHOOK_TUNNEL_CHECKOUT_PAYMENT_REFUND=NOT_AUTHORIZED
PAYPAL_OR_NETLIFY_CHANGE=NOT_AUTHORIZED
PUBLIC_DEPLOYMENT_OR_SPEND=NOT_AUTHORIZED
EVIDENCE_ONLY_COMMIT_PR64=ONLY_IF_ISOLATED_AND_ALLOWLISTED
REVIEWER_STOP=MANDATORY
EXPIRY=ONCE_THIS_G3S3R_ROUND_ONLY_OR_AFTER_RETURN_OR_PASS_CANDIDATE
```

## Safety / no implied results

This Owner approval is **authority**, not evidence of successful start or recovery. Current verified Executor evidence at PR #64 `2eb033658ad0ed04dacfe3a0f2b26101ab4697e3` reports four stopped containers, local stale/dirty checkout, previous protected backups present by metadata, and current Woo/Stripe state unknown. Cause of exit 137 remains UNKNOWN, not presumed OOM. If preflight discovers any source/mount/volume/data risk, stop before any container start and RETURN to Reviewer. If any started container fails, do not retry, recreate, overwrite data or restore backups. Owner consent covers none of those extra operations.

The Executor's **actual execution relay must explicitly quote this scoped Owner approval**; a GitHub file alone is not a substitute. Do not ask Owner to repeat the same approval for a successful routine step inside this exact Gate.
