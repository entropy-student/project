# Mini Craft Night Kit — REVIEWER HANDOFF

Last reviewed: 2026-09-18  
Maintainer: Reviewer

## Current Reviewer Truth

```text
K0_FUNCTIONAL_RESULT=PASS
K0R1_PROJECT_HYGIENE=PASS
K0R2_WORDPRESS_STUDIO_CONSOLIDATION=PASS
CURRENT_GATE=K3R5_PAYPAL_SANDBOX_DOCKER
K1_STATUS=SPLIT_K1A_K1B
DOCKER_SOURCE_MUST_BE_RETAINED=YES
K0_MOBILE_375_VISUAL_BASELINE=KNOWN_DEFECT
K1_MUST_FIX_MOBILE_375=YES
VPS=DEFERRED
PRODUCTION_PAYMENT=DEFERRED
GITHUB_HANDOFF_TRIAL_SUCCESS_COUNT=4
```

Formal decisions:

- `docs/REVIEWER_DECISION_K0_PASS.md`
- `docs/REVIEWER_DECISION_K0R1_PASS.md`

## K0R1 Review Summary

Reviewer accepted the cleanup evidence for:

- five K0-generated WooCommerce download/extraction artifacts removed from the shared workspace root;
- no retained artifact required a project-local archive;
- Home / Product / Cart / Checkout still healthy;
- WordPress remains on port 8090;
- MariaDB remains healthy;
- old project on 8088 still healthy;
- unrelated projects/shared files untouched;
- no Docker volume deletion;
- no real payment;
- no VPS;
- no Secret exposure.

K0R1 is formally closed.

## Current Owner checkpoint

Open:

`http://localhost:8090`

Review:
- Home
- Product
- Cart
- Checkout

Return one decision:

```text
OWNER_TEMPLATE_DECISION=USE
```

or

```text
OWNER_TEMPLATE_DECISION=RETURN
```

No K1 implementation is authorized before this decision.

## If Owner chooses USE

Reviewer will run the pre-K1 UI/Growth decision process:

```text
Owner
+ Reviewer
+ Growth / Acquisition Framework
        ↓
K1_UI_DECISION
        ↓
Executor
```

The K1 scope must define:
- KEEP / ADAPT / DROP;
- Offer hierarchy;
- Hero;
- CTA;
- Trust;
- product facts;
- visual adaptation boundary.

clone-ui may only be used after that target is approved.

## Payment Truth

```text
CANONICAL_COMMERCE_SYSTEM=WOOCOMMERCE
MVP_PAYMENT=WOOCOMMERCE_PAYPAL_PAYMENTS
DUJIAO_SECOND_CANONICAL_ORDER_SYSTEM=NO
```

Payment is not part of the current checkpoint.

## GitHub Handoff Trial

```text
SUCCESSFUL_GATES=2
TARGET_FOR_GLOBAL_GOVERNANCE=3
```

Candidate governance lesson validated:
project-generated downloads, extraction folders, caches, helper files and temporary artifacts must be contained under the project directory or removed before PASS_CANDIDATE.

No global Governance update yet.


## Current K0R2 Override

Formal decision: `docs/REVIEWER_DECISION_K0R2_STUDIO_CONSOLIDATION.md`

Current action: migrate the accepted Docker PoC into WordPress Studio using the supported import path. Keep Docker as rollback. Do not enter K1, payment, or VPS work. Executor must update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md` and stop at Reviewer.


## K0R2 Reviewer Reconciliation

Formal decision: `docs/REVIEWER_DECISION_K0R2_RECONCILED_PASS.md`

The Studio migration is accepted because the 375px clipping reproduces on the retained Docker source and therefore is not a Studio migration regression. The earlier K0 mobile-375 PASS subclaim is superseded. K1 must fix the inherited 375px clipping before K1 can PASS.

Current checkpoint: `OWNER_STUDIO_MIGRATION_REVIEW`.

GitHub handoff stability counter remains at 2 because this Gate exposed a truth conflict.


## K1 Authorization

Owner confirmed the Studio-managed `Mini Craft Night Kit` opens normally and is accepted as the active local development base.

Formal decision: `docs/REVIEWER_DECISION_K1_UI_GROWTH_BRAND_ADAPTATION.md`

Current Gate: `K1_UI_GROWTH_DECISION_AND_BRAND_ADAPTATION`.

Executor must follow the approved Growth/UI hierarchy, use the minimum-change strategy, avoid unverified product claims or fake proof, fix the inherited 375px clipping, preserve Gutenberg/WooCommerce behavior, update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`, then stop at Reviewer.


## K1A Override

K1 implementation is paused. Reviewer must first produce the concrete visual direction and growth-to-UI mapping. Owner approval is required before Codex starts K1B implementation.

Formal decision: `docs/REVIEWER_DECISION_K1A_VISUAL_DIRECTION.md`.


## K1A Deliverable Ready

Reviewer completed `docs/K1A_VISUAL_DIRECTION_AND_GROWTH_MAP.md`.

Do not start K1B until Owner explicitly approves the K1A visual direction.


## K1B Authorization

Owner approved K1A visual/growth direction.

Current Gate: `K1B_WORDPRESS_IMPLEMENTATION`.

Codex must implement using Kadence layout lock, must not generate final images, must use existing approved assets or editable placeholders, must fix inherited 375px clipping, preserve Gutenberg/WooCommerce, update Executor evidence, and stop at Reviewer.

Formal decision: `docs/REVIEWER_DECISION_K1B_WORDPRESS_IMPLEMENTATION.md`.


## K1B Technical Review

Formal decision: `docs/REVIEWER_DECISION_K1B_TECHNICAL_PASS_OWNER_VISUAL_PENDING.md`.

Reviewer accepts the technical evidence. K1B final closure is pending Owner visual review of the Studio-managed site. K2 remains unauthorized.

Owner marker: `OWNER_K1B_VISUAL=PASS` or `OWNER_K1B_VISUAL=RETURN` with specific issues.


## K1B Final PASS

Owner confirmed the initial visual implementation.

Formal decision: `docs/REVIEWER_DECISION_K1B_PASS.md`.

Current Gate: `K2_WOOCOMMERCE_COMMERCE_LOOP`.

K2 should verify the local Product → Add to Cart → Cart → Checkout → Order → Confirmation loop. Do not enter PayPal, production payment, VPS, or production deployment.


## K2 Authorization

Formal decision: `docs/REVIEWER_DECISION_K2_WOOCOMMERCE_COMMERCE_LOOP.md`.

Executor should verify the local WooCommerce commerce loop and stop at Reviewer. Do not enter PayPal, real payment, VPS, or production deployment.


## K2 Final PASS

Formal decision: `docs/REVIEWER_DECISION_K2_PASS.md`.

Reviewer accepts the local Product → Add to Cart → Cart → Checkout → Order → Confirmation → Orders admin loop.

Carry-forward: Studio SQLite required a local-only `hold_stock_minutes=0` workaround. It must not become production policy; normal stock reservation must be revalidated on the production database stack.

Current Gate: `K3_PAYPAL_SANDBOX`.

PayPal login/account authorization/KYC/Secrets/production enablement remain Owner checkpoints.

GitHub handoff stable-Gate count is now 4; a separate Governance Change Gate is eligible but has not been opened or promoted automatically.


## K3 Authorization

Formal decision: `docs/REVIEWER_DECISION_K3_PAYPAL_SANDBOX.md`.

Executor should proceed autonomously through official WooCommerce PayPal Payments Sandbox setup and testing until an actual Owner-only PayPal authorization step is required. Never request Secrets in GitHub/chat. If provider callback cannot reach localhost, return `RETURN_K3_PUBLIC_CALLBACK_REQUIRED` rather than creating an unauthorized public endpoint.


## K3 Owner Authorization Checkpoint

Executor correctly returned at `RETURN_OWNER_PAYPAL_SANDBOX_AUTH_REQUIRED`.

Current checkpoint: `OWNER_K3_PAYPAL_SANDBOX_AUTH`.

Owner action: complete PayPal Sandbox login/account authorization in the official WooCommerce PayPal Payments flow. Do not share password, Secret, token, OAuth code, cookie, or webhook secret. After Owner confirmation, resume K3 from the existing checkpoint; do not restart K3 from scratch.


## K3R1 Authorization

Formal decision: `docs/REVIEWER_DECISION_K3R1_PPCP_CONFLICT_ISOLATION.md`.

Temporarily deactivate only WooCommerce PayPal Payments, retest WooCommerce Home/Payments/admin REST/Store API/worker behavior, and stop at Reviewer. Do not uninstall, version-change, restore backup, retry PayPal authorization, expose Secrets, create a public route, or enable Live.


## K3R1 Result / K3R2 Authorization

K3R1 did not isolate the broader WooCommerce runtime/API failure. PPCP remains deactivated.

Formal decision: `docs/REVIEWER_DECISION_K3R2_PRE_K3_PARALLEL_BASELINE_COMPARISON.md`.

Create a separate temporary Studio site from the retained pre-K3 backup and compare current vs pre-K3 baseline. Do not overwrite the current site, reactivate PPCP, change versions, retry PayPal authorization, or touch production/VPS.


## K3R2 Result / K3R3 Authorization

A and B both reproduce the same timeout/one-hot-PHP-worker failure; B has no PPCP. Broader failure is therefore not isolated to the PayPal plugin or K3 mutation.

Formal decision: `docs/REVIEWER_DECISION_K3R3_STUDIO_WOOCOMMERCE_RUNTIME_ISOLATION.md`.

Keep A read-only with PPCP inactive. Create fresh Studio control C, test clean WordPress (C0), then official WooCommerce 10.0.4 only (C1) if C0 is healthy. Use clone B only for the bounded WooCommerce-deactivation comparison described in the decision. Stop at Reviewer.


## K3R3 Result / K3R4 Authorization

Fresh clean WordPress in Studio reproduced the timeout before WooCommerce existed. Treat the current Studio runtime as unreliable for continued Mini Craft execution.

Formal decision: `docs/REVIEWER_DECISION_K3R4_LOCAL_RUNTIME_ESCAPE_DOCKER_MARIADB.md`.

Create a new isolated Docker + MariaDB local control/recovery stack. Keep A/B/C0, the pre-K3 backup, K0 Docker PoC, and old project untouched. Do not resume PayPal in this Gate. If the Studio backup cannot be moved to MariaDB through a supported/safe path, return to Reviewer rather than writing a custom converter.


## K3R4 Final PASS / K3R5 Authorization

Formal pass: `docs/REVIEWER_DECISION_K3R4_PASS.md`.

Active local runtime is now Docker/MariaDB at `http://localhost:8093/`. Studio A/B/C0 remain retained read-only and are no longer the active execution environment.

Current Gate: `K3R5_PAYPAL_SANDBOX_DOCKER`.

Formal decision: `docs/REVIEWER_DECISION_K3R5_PAYPAL_SANDBOX_DOCKER.md`.

First re-test official PPCP 4.1.3 admin/UI health on Docker before any Owner authorization. If healthy, stop only at the actual Owner Sandbox login/consent checkpoint. If localhost later blocks callback/webhook, return to Reviewer instead of creating a public route.
