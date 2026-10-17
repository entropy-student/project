# Reviewer decision — G3S4H read-only discovery PASS; Business HTTPS staging candidate, no purchase

> Date: 2026-10-17
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7
> PR #64 HEAD: `b0a2e7cd0d2488fde87eb9f0db4f3b20738394bf`, OPEN / UNMERGED
> Evidence: `docs/evidence/g3s4/G3S4H_HTTPS_STAGE_DISCOVERY_2026-10-17.md` (on PR branch)
> Parent: `docs/G3S4H_ISOLATED_HTTPS_STRIPE_TEST_STAGE_DISCOVERY_GATE_2026-10-17.md`
> Reviewer action: read only GitHub evidence and external official product documentation; write GitHub Reviewer docs only. No deployment/hosting purchase/account or WordPress action.

## Decision

```text
G3S4H_READ_ONLY_DISCOVERY=REVIEWER_PASS
PR64_BASE_3D460_TO_B0A2=2_COMMITS_ONE_ADDED_G3S4H_EVIDENCE_FILE_ONLY
RECOMMENDED_TECHNICAL_CANDIDATE=FRESH_WORDPRESS_COM_BUSINESS_MONTHLY_STANDALONE_TEST_SITE
BUSINESS_PRICE_VERIFIED=US$40_MONTHLY_EX_TAX_PUBLISHED_US_PRICING;OWNER_CHECKOUT_FINAL
PUBLISHED_BUSINESS_CAPABILITY=WP_PLUGIN_WOO;AUTOMATIC_HTTPS;BACKUPS;RESTORE;STAGING
CANDIDATE_SITE_ID_URL_TLS=NOT_YET_EXISTING_OR_VERIFIED
OWNER_WORDPRESS_COM_ACCOUNT_ACCESS=NOT_VERIFIED
DEPLOYMENT_PURCHASE_OR_PUBLICATION_AUTHORITY=NO
OWNER_PAYMENT_APPROVAL_FOR_NEW_HOST=NO
STRIPE_OAUTH_WEBHOOK_PAYMENT_REFUND=NOT_STARTED
ORIGINAL_LOCAL_WOO_STRIPE=PLUGIN_ACTIVE;GATEWAY_DISABLED;SETTINGS_UNCONFIGURED
LOCAL_PASSWORD_ROTATION=UNVERIFIED
ALTERNATE_COST=WORDPRESS_COM_PERSONAL_MONTHLY_US$9_EX_TAX_WITH_PLUGINS_AND_WOO
ALTERNATE_LIMITATION=NO_BUILT_IN_BUSINESS_BACKUP_STAGING_SSH_DB_RECOVERY;NOT_PASSED_FULL_RECOVERY_GATE
NEXT_GATE=G3S4I_CONDITIONAL_HOSTED_HTTPS_STRIPE_TEST_STAGE
G3S4I_WRITES=HOLD_PENDING_OWNER_EXPLICIT_BUDGET_AND_PUBLIC_HOST_AUTHORITY
OLD_REPLACEMENT_VPS=NO
PR64_MERGE=NO
```

**PASS is for the G3S4H read-only planning Gate, not for deployed HTTPS staging or Stripe TEST payment.** Evidence has the required discovery fields, explicit unknown target/credentials and no external writes. GitHub commit compare `3d460070f8eb61f4e47118e41a398fa14cc5b53f...b0a2e7cd0d2488fde87eb9f0db4f3b20738394bf` shows two commits and exactly one added Evidence Markdown file, no application/code delta; the latest commit edits that same file. PR #64 remains open/unmerged.

## Official verification and corrections to carry into deployment

- **Price**: the US WordPress.com pricing page lists Business `US$40` month-to-month before tax and Personal `US$9` month-to-month before tax (display includes annual-billing alternatives); verify local actual checkout amount and automatic renewal/termination details before any payment. https://wordpress.com/pricing/
- **Woo plugins**: WooCommerce and plugins are available on all *paid* WordPress.com plans, not exclusively Business. https://wordpress.com/support/introduction-to-woocommerce/ ; https://wordpress.com/support/plugins/install-a-plugin/
- **Business rationale**: automatic backups/one-click restore, staging, SSH/DB access materially assist the required protected pre-change restore/rollback proof. The cheaper Personal plan does not provide the same managed recovery contract and is not interchangeable without a new scoped synthetic-only recoverability decision. https://wordpress.com/support/plan-features/business-plan/
- **Important staging distinction**: the recommended target is a **fresh standalone, synthetic-only WordPress.com Business site used for testing**, NOT a clone of the real site and NOT necessarily a WordPress.com managed staging subsite. A WordPress.com staging subsite clones database/content/users/keys of its parent and has different URL/lifecycle semantics; never clone any real project/customer/Provider data into it. If the optional staging feature is exercised, verify public Stripe callback behavior, account isolation and setup anew. https://wordpress.com/support/how-to-create-a-staging-site/
- **Site public access**: WordPress.com Coming Soon/Private modes hide the site from anonymous users; do not assert that a Stripe Webhook POST or anonymous checkout will work in those modes. Before Stripe OAuth or TEST payments, independently validate public HTTPS endpoint identity, guest access to synthetic checkout, and unauthenticated provider signed callback reachability while admin/private URLs and logs remain protected. When a temporary site must be Public, it may expose **all published content**, not just the checkout/webhook; publish synthetic/non-sensitive fixtures only, disallow indexing where supported and return to non-public after the test. https://wordpress.com/support/privacy-settings/
- **Owner Stripe TEST OAuth** is conducted in Owner's own browser; the official Woo extension can auto-configure the Stripe-side `https://<stage-host>/?wc-api=wc_stripe` webhook. Validate actual account/app/mode/site association without accidentally cloning or connecting a different merchant/account. https://woocommerce.com/document/stripe/setup-and-configuration/connecting-to-stripe/ ; https://woocommerce.com/document/stripe/setup-and-configuration/stripe-webhooks/
- **Stage fixture**: fresh WordPress/Woo/official Stripe compatibility-proven environment; equivalent USD39.99 virtual product + smallest entitlement/revocation proof adapter; generation disabled. Explicit fresh unique admin login, no migration of user data or prior passwords and no automatic syncing to the original localhost. Do not claim identical numeric product #1113 on the new site; use verified fixture ID and mapping.
- **Fallback**: WordPress.com Personal at `US$9` month-to-month can host Woo/Stripe plugins but lacks Business managed rollback/staging. Reviewer keeps it as *cost alternative only*, not prequalified under the current restore and payment Gate. Official 14-day Commerce free trial is also unsuitable as a presumed full substitute: it has restricted plugin installation, SSH and public/Coming Soon behavior; do not invent a free working callback path without verification. https://wordpress.com/support/plan-features/ecommerce-plan/
- **Stop conditions**: if provisioned host lacks expected plugin compatibility, backup proof, TLS/guest Webhook reachability, bounded TEST-only OAuth, or account separation, stop without test charge/refund. Previous WordPress admin password exposed through chat has not been confirmed rotated; do not carry or reuse it at the stage. No real/Live payment or customer data.

## Authority and next Gate

- Current approval: **READ-ONLY G3S4H discovery complete.** This Reviewer report **does not** authorize new hosting costs, subscription, site creation, public launch/DNS, Stripe account linking or a TEST payment on a remote host. Owner's prior G3S4M payment consent covered localhost only.
- Next prepared conditional Gate: `docs/G3S4I_CONDITIONAL_HOSTED_HTTPS_STRIPE_TEST_STAGE_2026-10-17.md`. Its public hosting/provider writes remain **HOLD** until Owner gives an explicit **named target/budget/public exposure** approval; no repeated preliminary infrastructure research is required.
- Once approved, Owner sets up the fresh WordPress.com site using their own account/checkout and controls any Stripe TEST OAuth. Executor must not purchase as Owner without authorization or collect account login, sensitive material or card details in chat/PR. Narrow setup and post-write readback precede a single bounded $39.99 TEST payment/webhook/replay/invalid/refund/entitlement proof.
- PR #64 remains open and not mergeable; no blind merge with main, no rerun of old local WordPress password or CLI workflow. Preserve local plugin active/gateway disabled and protected backup evidence.

## Reviewer relay

`NEXT_OWNER_CHECKPOINT`: one explicit decision whether to approve a fresh WordPress.com Business month-to-month `US$40` ex-tax subscription and temporary public HTTPS synthetic test site, or ask to optimize further via a lower-cost host. No provider/hosting writes until decided. If Owner approves Business, the next Executor starts from G3S4I; do not reperform G3S4H.
