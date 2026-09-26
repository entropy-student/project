# Reviewer Decision — K6 D-R6R3R1 PASS / Phase E Serialized-Safe URL Migration

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed result

```text
GATE=K6_PHASE_D_R6R3R1_EXECUTION_WRAPPER_RECOVERY_AND_PRIVATE_VALIDATION_RESUME
EXECUTOR_RESULT=RETURN_REVIEWER_D_R6R3R1_PPCP_MODE_READBACK_UNAVAILABLE
EVIDENCE_COMMIT=7c839fe616c4ab8adee4ad11a5a8dc324d731001
HANDOFF_COMMIT=90204c35c7bcdf34cbc0745ac13e02c20f657c94
```

Reviewer independently accepts the underlying private-runtime validation as PASS.

## PPCP reconciliation

Fresh D-R6R3R1 evidence proves:

```text
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO
```

The bounded onboarding endpoint did not yield a confirmable `completed` boolean in this run. That is not evidence that onboarding is incomplete.

Accepted historical project evidence remains authoritative absent material drift:

- K3R9: merchant connected YES, Sandbox YES, onboarding completed YES;
- K3R11: the accepted PPCP onboarding response explicitly reported `data.completed=YES`;
- K3 Payment PASS: one Sandbox payment/capture/webhook flow PASS, Live disabled;
- K5 Release Candidate PASS: PPCP active/connected in Sandbox, Live off;
- no accepted later Gate authorized PPCP reconnect, environment switch, onboarding reset, or Live enablement.

Current fresh state corroborates the critical environment invariants rather than contradicting them. Therefore:

```text
PPCP_ONBOARDING_COMPLETED=PASS_BY_ACCEPTED_HISTORICAL_EVIDENCE_NO_MATERIAL_DRIFT
PAYPAL_SANDBOX_LOCAL_CONFIG_STATE=PASS
```

The Executor's fail-closed RETURN was correct for its Gate contract, but the Reviewer does not require another probe.

## D-R6 private runtime closure

Accepted:

```text
LOCAL_EXECUTION_WRAPPER=PASS
SSH_TRUST=PASS
REMOTE_IDENTITY=ops@srv1970241
WORDPRESS_RUNTIME_CONTINUITY=PASS
WORDPRESS_RESTART_COUNT=0_STABLE
MARIADB_HEALTH=PASS
HOME_SITEURL_READBACK=PASS_TARGET
CHECKOUT_PRIVATE_STATUS=302
CHECKOUT_REDIRECT_TARGET=https://minicraft.spikersun.com/cart/
CHECKOUT_EMPTY_CART_BEHAVIOR=PASS_EXPECTED_CART_REDIRECT
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_ONBOARDING_COMPLETED=PASS_HISTORICAL_NO_DRIFT
PPCP_LIVE_ENABLED=NO
WORDPRESS_PRIVATE_APP_VALIDATION=PASS
D_R6_PRIVATE_RUNTIME_VALIDATION=PASS
PUBLIC_INGRESS=NONE
PAYMENT_ACTIONS=0
REAL_PAYMENT=NO
```

Formal result:

`K6_PHASE_D_PRIVATE_RUNTIME_RESTORE_AND_VALIDATION=PASS`

## Current Gate

```text
CURRENT_GATE=K6_PHASE_E_SERIALIZED_SAFE_URL_MIGRATION
OWNER_ACTION=NONE
```

## External technical basis frozen for this Gate

Current official documentation reviewed on 2026-09-26:

- WP-CLI `wp search-replace` handles PHP serialized data, supports `--dry-run`, `--all-tables-with-prefix`, and `--skip-columns`.
- WordPress migration guidance says the `guid` column must not be changed when moving domains.
- Docker Official WordPress currently publishes WP-CLI 2.12.0 PHP 8.3.
- Current official linux/amd64 WP-CLI child manifest:
  `sha256:aa31002b5ae67cfff25817c8f4379b0e84aa4f8cc9637c83e16757d435adaf49`
  under OCI index:
  `sha256:4ba861e5417383ce67f5095921c21d55e32e507677853c1d045f73bb0d3f52dc`.
- Docker tmpfs mounts cannot be shared between containers. Therefore do not assume `--volumes-from` can expose the running WordPress container's tmpfs-backed `/var/www/html` to a CLI container.

## Migration source strings

Known accepted historical site origins:

```text
OLD_ORIGIN_A=http://localhost:8093
OLD_ORIGIN_B=https://email-rich-barbie-merchants.trycloudflare.com
TARGET_ORIGIN=https://minicraft.spikersun.com
```

The Quick Tunnel origin was historical Sandbox infrastructure and is no longer active/authorized.

Only these exact known origins are eligible for automatic serialized-safe replacement in this Gate.

## Phase A — fresh preflight + tool seal

1. canonical strict SSH / target identity;
2. current D-R6 accepted private runtime continuity;
3. root disk/RAM headroom;
4. DB healthy;
5. `home/siteurl` remain target;
6. no public ingress;
7. verify accepted WordPress application image remains the pinned linux/amd64 child:
   `sha256:f5413918c7858c97bb7d2b65f68d3ed38a97472deba9eb58eb3e1ab1eb2c4beb`;
8. resolve/check the exact WP-CLI image metadata above;
9. if the exact WP-CLI child digest is not cached, authorize one pull of exactly:
   `docker.io/library/wordpress@sha256:aa31002b5ae67cfff25817c8f4379b0e84aa4f8cc9637c83e16757d435adaf49`;
10. no tag-only pull, no build, no other image.

If image identity differs from the frozen digest before pull:
`RETURN_REVIEWER_E_WPCLI_IMAGE_IDENTITY_DRIFT`.

## Disposable migration helper design

Do not mutate the running WordPress container to install tooling.

Because the live WordPress docroot is tmpfs and Docker tmpfs cannot be shared across containers, build the migration execution boundary from disposable containers only:

1. extract only `/usr/local/bin/wp` from the exact pinned WP-CLI image into a project-scoped reconstructible temporary tool path under `/srv/apps/mini-craft-night-kit/.tmp/`;
2. create a disposable helper from the **already accepted pinned WordPress application image**, not a new WordPress version;
3. helper requirements:
   - no host ports;
   - DB-private network only; do not join `spikersun-edge`;
   - own 512MiB `/var/www/html` tmpfs;
   - same current wp-content bind, preferably read-only for migration tooling;
   - only the nine intended WordPress Secret mounts read-only; no db-root Secret;
   - same non-secret DB configuration needed by official `wp-config-docker.php`;
   - WP-CLI binary bind-mounted read-only;
4. allow the official WordPress entrypoint to populate the helper's own runtime core/config;
5. verify helper WordPress core version = accepted 7.1.1 and WP-CLI = 2.12.0;
6. no request/public traffic to the helper.

Any helper/runtime mismatch -> RETURN before DB migration.

## Phase B — serialized-safe dry run

Run WP-CLI as the non-root WordPress runtime identity where practical.

Use:
- `--skip-plugins`;
- `--skip-themes`;
- `--all-tables-with-prefix`;
- `--skip-columns=guid`;
- `--dry-run`;
- report changed table/column/count metadata only; never values.

Dry-run exact pairs separately:

1. `http://localhost:8093`
   -> `https://minicraft.spikersun.com`
2. `https://email-rich-barbie-merchants.trycloudflare.com`
   -> `https://minicraft.spikersun.com`

Record exact replacement counts per old origin.

Do not replace GUIDs.

If dry-run cannot bootstrap safely or reveals unexpected table-prefix/schema drift:
RETURN.

If both replacement counts are zero:
- record `SERIALIZED_URL_MIGRATION=NOOP_ALREADY_CLEAN`;
- skip DB backup/write;
- continue post-validation.

## Phase C — fresh pre-migration recovery point

Only if at least one dry-run count > 0.

Before mutation:

1. recheck DB healthy and 52-table set;
2. create one logical MariaDB backup of the **current post-home/siteurl state** under:
   `/srv/backups/mini-craft-night-kit/`
   using a Gate-specific pre-serialized-migration filename;
3. use protected tmpfs-only DB authentication;
4. backup must be mode-restricted and never committed;
5. record bytes + whole-artifact SHA-256 metadata;
6. verify dump readability/table cardinality without exposing row contents.

No migration write unless recovery point PASS.

## Phase D — exact serialized-safe migration

Only after Phase B and, where required, Phase C PASS.

Run the same exact WP-CLI command shapes without `--dry-run`, one known origin at a time.

Rules:
- `--all-tables-with-prefix`;
- `--skip-columns=guid`;
- `--skip-plugins`;
- `--skip-themes`;
- exact old/new strings only;
- no regex;
- no broad host/domain fragment replacement;
- no Provider call;
- no GUID mutation.

Expected real replacement count for each origin must equal its immediate dry-run count because the site has no public ingress. Count mismatch -> fail closed.

If a migration command returns a confirmed nonzero while the SSH/session remains clearly alive:
- do not run a second migration attempt;
- restore the exact fresh pre-migration logical backup within the same authorized rollback boundary;
- verify restored D-R6 baseline;
- return `RETURN_REVIEWER_E_MIGRATION_FAILED_ROLLED_BACK`.

If connection/process outcome is ambiguous after migration may have started:
- no retry;
- no blind rollback;
- return `RETURN_REVIEWER_E_MIGRATION_OUTCOME_AMBIGUOUS`;
- next Gate must reconcile read-only first.

## Phase E — post-migration validation

Require:

1. repeat both WP-CLI dry-runs -> zero non-GUID replacements;
2. safe dry-run scan for residual non-GUID `localhost:8093` -> zero actionable replacements;
3. safe dry-run scan for residual non-GUID exact historical Quick Tunnel origin -> zero actionable replacements;
4. GUID column unchanged by this Gate;
5. exact 52-table set unchanged;
6. home/siteurl remain exact target;
7. WordPress bootstrap/installed-state PASS;
8. primary private routes PASS, with expected empty-cart Checkout redirect accepted;
9. wp-content/media PASS;
10. WooCommerce core PASS;
11. PPCP remains active/connected/Sandbox YES/Live NO;
12. no PHP fatal/restart drift;
13. no host ports/public ingress;
14. unrelated services unchanged.

Provider-side webhook registration is **not** changed in this Gate. Any provider-side historical callback URL is handled only after reviewed public ingress/payment readiness.

## Cleanup

Remove:
- disposable helper container;
- any source/extraction helper container;
- project-scoped temporary extracted WP-CLI file/path.

Do not broad-prune.
Do not remove shared/cached images merely for cleanup.

## Hard boundaries

No:
- running WordPress/MariaDB recreate/restart;
- image build;
- tag-only image pull;
- public ingress;
- Shared Infra changes;
- GUID replacement;
- regex/broad replacement;
- unknown-origin automatic replacement;
- Provider webhook mutation/API call;
- PayPal Live/payment/refund;
- Secret content/hash output;
- unrelated project changes.

## Success contract

```text
PASS_CANDIDATE_K6_PHASE_E_SERIALIZED_SAFE_URL_MIGRATION
WPCLI_IMAGE_IDENTITY=PASS_EXACT_AMD64_DIGEST
WPCLI_VERSION=2.12.0
MIGRATION_HELPER=PASS_DISPOSABLE_PRIVATE
OLD_ORIGIN_A_DRYRUN_COUNT=
OLD_ORIGIN_B_DRYRUN_COUNT=
PRE_MIGRATION_BACKUP=<PASS_OR_NOT_REQUIRED_NOOP>
OLD_ORIGIN_A_REPLACED=
OLD_ORIGIN_B_REPLACED=
POST_MIGRATION_OLD_ORIGIN_A=0
POST_MIGRATION_OLD_ORIGIN_B=0
GUID_MUTATIONS=0
MARIADB_TABLE_SET=UNCHANGED_52
HOME_SITEURL=PASS_TARGET
WORDPRESS_BOOTSTRAP=PASS
WORDPRESS_PRIVATE_ROUTES=PASS
WOOCOMMERCE_CORE_STATE=PASS
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
TEMP_HELPERS_CLEANED=PASS
STOP_AT_REVIEWER=YES
```

A PASS_CANDIDATE does not authorize public ingress, Provider webhook reconfiguration, PayPal Live, real payment, or launch.
