# G3P1 — Owner-local temporary prepayment draft and Woo cart correlation (prepared, not executed)

> Date: 2026-10-16
> Governance: vps-project-governance v0.2.7
> Source audit: `docs/evidence/g3p0/G3P0_PREPAYMENT_INTAKE_SOURCE_GAP_AUDIT_2026-10-16.md`
> Source PR #64 observed head: `4cb0d527d77a6d583e123acd3f62c45408669569` (refresh before execution)
> Contract: `docs/MVP_PRODUCT_CONTRACT.md` (frozen), Owner visual freeze `docs/OWNER_DECISION_G3CR7_FRONTEND_VISUAL_ACCEPTANCE_2026-10-15.md`
> Status: **PREPARED_FOR_FUTURE_EXECUTOR_ASSIGNMENT — NOT AUTHORIZED/NOT STARTED**. Owner previously asked not to receive a Codex prompt; no prompt has been sent.

## Gate contract

```text
GATE_ID=G3P1_LOCAL_PREPAYMENT_DRAFT_AND_CART_CORRELATION
OBJECTIVE=Replace browser-only five-step input with short-lived owner-local server drafts of photos + answers, a frozen versioned snapshot and opaque native Woo cart reference; never trigger paid fulfillment.
MAX_ENDPOINT_THIS_ROUND=One minimal G3C source/runtime feature within PR #64 and verified Owner-local Docker lab, with synthetic-fixture persistence/regression, redacted Evidence and Reviewer STOP. No payment order, gateway enablement or production behavior.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Owner physical Windows Docker Desktop G3C, existing preview intake plugin and a narrowly scoped server-draft backend, project-private temporary asset storage and Woo cart/session metadata; no VPS/cloud server.
APPLICABLE_CRITICAL_CONSTRAINTS=NO_STRIPE_ACTIVATION_AUTH_LOGIN_OAUTH_CONNECT_UPGRADE; NO_PAYPAL_SETTINGS_OR_PLUGIN_CHANGE; NO_PROVIDER_PAYMENTS_REFUNDS_ORDERS_TEST_LIVE; NO_PUBLIC_TUNNEL; NO_REAL_CUSTOMER_PHOTOS_OR_PERSONAL_DATA; NO_AI_MODEL_OR_GENERATION_JOBS; NO_WP_RESET_REINSTALL_DB_OR_VOLUME_DELETE; NO_VISUAL_REDESIGN; NO_PR64_MERGE_REBASE_RESET; NO_EXECUTION_POLICY_BYPASS; NO_HARDCODED_PRIVATE_SECRETS; NO_PHOTO_ANSWER_CONTENT_IN_GITHUB_LOGS.
PREFLIGHT=Owner explicitly asks to assign/execute this prepared Gate in future; then fresh PR/main and current physical Windows source/mount identity; current approved plugin/DB baseline and fresh selected backup with tested recovery and safe rollback; check local disk/memory and protected writeable app storage; normal GitHub/Codex supported tool permissions only. Missing essential proof RETURNS before modification.
REQUIRED_EVIDENCE=VERSIONED_DRAFT_SCHEMA_AND_VALIDATION; SERVER_GENERATED_UNGUESSABLE_ID_SESSION_BOUND; 12_TO_25_REAL_FILE_FIXTURES_AND_SIX_REQUIRED_PROMPTS; UPLOAD_CONTENT_MAGIC_BYTES_AND_SIZE_CEILING; PRIVATE_NONPUBLIC_ASSETS_AND_NEGATIVE_ACCESS; AT_MOST_3_MUST_USE; EXPLICIT_TTL_AND_ABANDONED_DRAFT_CLEANUP_PROOF; FROZEN_SNAPSHOT_ID_AND_WOO_CART_CORRELATION; IDEMPOTENT_SUBMIT; INCOMPLETE_UNPAID_CANNOT_GENERATE; ORIGINAL_HOMEPAGE_AND_FIVE_STEP_VISUAL_REGRESSION; STRIPE_INACTIVE_PAYPAL_DISABLED_UNCHANGED; DB_FILES_BACKUP_ROLLBACK; GITHUB_PR_EVIDENCE_AND_NATIVE_EXIT_STATUS.
ACCEPTANCE_CRITERIA=Before checkout, synthetic complete buyer intake survives refresh/reentry, server validates and freezes exactly one immutable version, cart carries an opaque reference verified against same browser/session; incomplete/unauthorized/stale/oversize/invalid MIME/duplicate submissions fail closed, private uploads never anonymously available, and no paid order or generation can occur. Visuals, Woo gateway, original data unchanged.
ROLLBACK_STATUS_OR_PLAN=Before implementation, preserve & verify current WordPress/database, privately bound file storage and source snapshot; rollback only newly introduced draft plugin/config/data, leaving pre-existing orders/volumes untouched. Retain original inactive Stripe staging, untouched private G3S1S backup and deferred temporary Stripe ZIPs. No broad destructive cleanup.
OWNER_ONLY_ACTIONS=Explicit Owner instruction to begin local implementation/issue Codex handoff when ready; no banking/KYC, payment or merchant identity needed for this independent task.
REVIEWER_TO_EXECUTOR_RELAY=NOT_ISSUED_OWNER_REQUESTED_NO_PROMPT
EXECUTOR_TO_REVIEWER_RELAY=PASS_CANDIDATE_WITH_EXACT_PR_EVIDENCE_COMMIT_OR_RETURN_AND_SAFE_STOP
```

## Minimal implementation target (once separately authorized)

**Existing accepted and frozen:** G3C JS `poc/g3c/preview-plugin/frontend-reproduction.js` currently holds files/answers in memory, then posts only product ID and quantity to Woo cart. PHP `frontend-reproduction.php` explicitly says it is a local interface proof. Preserve the same five-step visual composition, three style presets, native Woo product/cart/checkout and private account/workspace, using existing G3C plugin conventions rather than introducing a second framework.

**New only what is missing:**
1. A server-generated draft/session token with cryptographically strong entropy, bounded to the initiating session; CSRF protection and server-side negative ownership checks. Do not treat draft ID, shortcode URL, Woo cart data or WordPress nonce by itself as proof of authentication/payment.
2. Server-bound upload and input-validation endpoint for 12–25 images with real content/type verification (JPG/PNG/WebP), fixed explicit file size caps; max 3 must-use, all 6 prompts and required factual fields. Apply bounded bytes/count/traffic; no PHP/HTML executable uploads, public attachment endpoints, ordinary Media Library browsing, plaintext logs or analytics photo leakage.
3. Private app data storage protected from anonymous/public URLs, with a short explicit buyer-facing draft TTL and verifiable deletion of expired drafts/associated files. Storage must persist expected owner-local Docker restarts, without using unsafely public WP uploads paths.
4. A server-validated **complete** snapshot version frozen at Submit, with immutable content correlation. Woo cart receives the opaque reference only for this project product; amount/title/order authenticity still derive from Woo. Revisit already frozen snapshots only by creating a new version when the buyer edits and resubmits.
5. No actual payment submission or WooCommerce order create in this Gate. The next independently accepted integration Gate should attach that exact snapshot to a canonical paid Woo order/customer and enforce exactly one generation job after real paid entitlement, separately testing idempotency/refund.
6. Offline fixture tests via protected local runtime: accepted 12 photos/25 photos/3 marked, refresh persistence, different session denial, signed-out vs same-session access; negatives for 11/26/photos >3/invalid MIME/oversize/expired/duplicate draft; Woo product/cart reference present but no order created. No real buyer images, provider API, test/live Stripe activation or generated PDF. Preserve previously accepted visual and private workspace baselines.

## Execution boundary / stop

This is the **next meaningful implementation workstream independent of Stripe merchant registration**. However, since Owner previously said *“暂时不要提示词，我有别的安排”* and has not expressly resumed Codex handoff, **do not automatically send a prompt or execute host mutations**. Mark `READY_NOT_STARTED`; on later explicit Owner assignment, issue a concise role-appropriate relay and stop for Reviewer. The current G3S2 Stripe merchant eligibility decision remains separately pending and does not need to be re-researched before this local synthetic draft task.

```text
GATE_PREPARED=YES
EXECUTOR_ASSIGNED=NO
CODEX_PROMPT_SENT=NO
IMPLEMENTATION_STARTED=NO
WORDPRESS_DB_STRIPE_PAYPAL_CHANGES=0
MERCHANT_PAYMENT_ACCOUNT_ACTIONS=0
PR64_MERGE=0
```
