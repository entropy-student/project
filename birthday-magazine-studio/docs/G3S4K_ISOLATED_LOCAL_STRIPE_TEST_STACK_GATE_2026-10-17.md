# G3S4K — isolated project-local synthetic WooCommerce/Stripe TEST stack

Date: 2026-10-17
Status: `PREPARED_OWNER_NEW_LOCAL_STACK_WRITE_SCOPE_PENDING`; read-only design authorized, **new Docker/DB/plugin write not yet authorized**.
Reviewer authority: `docs/REVIEWER_DECISION_G3S4J_ACCEPT_ISOLATED_LOCAL_WOO_ROUTE_2026-10-17.md`
PR64 baseline: `9461d5c5f8fa3c7b1bb570dc8f2f810e9bf67956` G3S4J Evidence.
Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7, §§5–9, 11B/11C/11D/11E.

## Gate contract

```text
GATE_ID=G3S4K_ISOLATED_LOCAL_STRIPE_TEST_STACK_20261017
OBJECTIVE=Prepare an isolated locally running synthetic WordPress/WooCommerce Stripe TEST origin, leaving original 8189 untouched and postponing Cloudflare UI dependency.
MAX_ENDPOINT_THIS_ROUND=AFTER_EXPLICIT_OWNER_NEW_STACK_AUTH -> PROJECT_ISOLATED_COMPOSE_AND_LOCAL_SYNTHETIC_WP_WOO_39_99_PRODUCT -> PRIVATE_BOUND_LOCAL_READBACK_ONLY -> PR64_EVIDENCE -> REVIEWER_STOP
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=OWNER_WINDOWS11_DOCKER_SEPARATE_BIRTHDAY_TEST_COMPOSE;WP_7_1_1_WOO_11_1_2_WOO_STRIPE_11_1_0_IF_COMPATIBLE;DEDICATED_LOCALHOST_PORT_CHOSEN_AFTER_CHECK
APPLICABLE_CRITICAL_CONSTRAINTS=NO_ORIGINAL_8189_MUTATION;NO_SHARED_WP_DB_USERS_CREDENTIALS_MEDIA_ORDERS_OR_KEYS;NO_PUBLIC_TUNNEL_DNS;NO_REAL_LIVE_STRIPE;NO_VPS;NO_PAID_HOST;NO_PR_MERGE
PREFLIGHT=OWNER_EXPLICIT_NEW_LOOPBACK_STACK_AUTH_AND_PRIVACY_BOUNDARY;VERIFY_EXACT_REAL_WINDOWS_DOCKER_AND_PROJECT_NETWORK_PORT_FREE;PRESERVE_ORIGINAL_WP_COMPOSE_VOLUME_AND_BACKUPS;CHECK_NEW_PORT_RUNTIME_NOT_ASSUMED_8190;FREE_SPACE_MINIMAL
REQUIRED_EVIDENCE=OWNER_SCOPE;REAL_HOST_ID;SOURCE_COMPOSE_PROVENANCE;SELECTED_PORT_AND_EXACT_BIND;DEDICATED_DB_VOLUME;NEW_PRIVATE_ADMIN_ACCOUNT_NO_VALUE_LEAK;WP_WOO_STRIPE_VERSIONS;TEST_ONLY_GATEWAY_DISABLED;ONE_VIRTUAL_USD39_99_PRODUCT;ZERO_REAL_USERS_ORDERS_PHOTOS;AUTO_GENERATION_DISABLED;ORIGINAL_8189_NEGATIVE_DELTA;EXACT_ROLLBACK
ACCEPTANCE_CRITERIA=SEPARATE_SYNTHETIC_SITE_RETURNS_LOCAL_200;UNIQUE_COMPOSE_DB_VOLUMES;ORIGINAL_SITE_8189_UNCHANGED;NO_PUBLIC_ROUTE_OR_STRIPE_OAUTH_CHARGE;PAYMENT_DISABLED;OWNER_NEW_PRIVATE_ADMIN_LOGIN_VERIFIED_IF_POSSIBLE;NO_SECRET_EVIDENCE
ROLLBACK_STATUS_OR_PLAN=OWN_ONLY_NEW_SYNTHETIC_STACK;EXACT_COMPOSE_DOWN_PRESERVE_VOLUMES_BY_DEFAULT;NO_DOCKER_PRUNE;NO_ORIGINAL_SITE_MODIFICATION;RECREATE_ONLY_NEW_SITE_IF_NEEDED_AFTER_INVENTORY
OWNER_ONLY_ACTIONS=ONE_EXPLICIT_LOCAL_NEW_STACK_AUTH_AND_PRIVATE_INITIAL_UNIQUE_ADMIN_PASSWORD_CREATION;LATER_NAMED_CLOUDFLARE_ZONE_PERMISSION_AND_STRIPE_TEST_OAUTH_ARE_SEPARATE
REVIEWER_TO_EXECUTOR_RELAY=READ_MAIN_HANDOFF_TOP_AND_THIS_GATE_PLUS_G3S4J_EVIDENCE_9461D5;ON_NEW_OWNER_AUTH_BUILD_ONLY_NEW_LOOPBACK_SYNTHETIC_SITE;NO_BROWSING_CLOUDFLARE_OR_REPEATING_OLD_CHECKS;COMMIT_ONE_SANITIZED_G3S4K_EVIDENCE_TO_OPEN_PR64_AND_STOP
EXECUTOR_TO_REVIEWER_RELAY=GATE_ID;AUTHORIZED_OWNER_SCOPE;ACTUAL_COMPOSE_PROJECT_PORT_VOLUME;TEST_PRODUCT_PRICE;PROVIDER_AND_PUBLICATION_ZERO;ORIGINAL_NON_TARGET_DELTA;FAILURES;COMMIT_SHA;STOP_AT_REVIEWER
```

## Execution after Owner's specific permission

1. Reuse accepted original 8189 environment/version/backup and G3S4J STOP evidence; no full preflight replay. Inspect only project-specific Docker Compose, image/cache, port binding and conflicts. `8190` is **not assumed available**: prior services may use adjacent localhost ports. Select a confirmed available fixed port (e.g. 8191 only if verified free) and record it before creating any host service. Never bind TCP on `0.0.0.0` or publish MariaDB.
2. Assemble a fresh, isolated, project-unique Compose file/volumes/network inside an allowlisted project-owned workspace/worktree. Existing 8189 project, net/DB and media are never renamed, reconfigured, mounted or stopped. Image pinning must use verified official/present images, no arbitrary broad pull/recreate.
3. Fresh WordPress from empty DB, Woo and the reviewed official Stripe gateway if compatible; Stripe remains **disconnected and disabled**, safe/test mode only. No production/live account, PayPal Business, Stripe CLI secret, Webhook/Provider action. Synthetic virtual product one `USD 39.99`; do not assume numeric product ID `1113` on the new DB. No real pictures/customer/order/plugin secrets, no generation/fulfillment worker, no recurring payment.
4. New site admin is a unique Owner-private credential. The previously exposed original WP admin password must never be reused or copied; if an isolated private credential cannot be created securely without exposing it in agent logs/transcripts/argv, stop just that private checkpoint and ask Owner to enter it through their own real local admin UI. Never claim prior compromised credential rotated. A truly isolated new stack must not share original users/DB/keys, so original password rotation is **not a new-site blocker**.
5. Only localhost health and privacy checks, absence of other host/port publication, payment disabled, exact container/project/volume isolation and original 8189 unchanged. No new tunnel/DNS/reverse proxy, no public domain canonical URL, no Stripe checkout or refund. Keep the new site's localhost `home/siteurl` correct for current local test; future HTTPS host migration happens in a later Gate.
6. Capture one bounded sanitized Evidence `birthday-magazine-studio/docs/evidence/g3s4/G3S4K_ISOLATED_LOCAL_TEST_STACK_2026-10-17.md` in PR #64 after verifying its HEAD/changed path. Save minimal local recovery plan with exact new project identifier; do not reset dirty original Git checkout or merge PR. Mandatory Reviewer stop.

## Separate later Cloudflare/public phase — design only, no execution authority here

**Deferred, NOT A REASON TO RETURN G3S4K:** Codex's Computer Use URL-confidence stop prevented read of Cloudflare Dashboard; do not retry that same browser call or use a different browser API to bypass the stop. The Owner's screenshot lists `spikersun.com` as a domain but actual zone Active/write control/DNS slot are UNKNOWN.

Future public route after local synthetic stack is accepted: single exact `stripe-test.spikersun.com` **candidate** (if Owner confirms eligible unused name) -> official named Cloudflare Tunnel outbound `cloudflared` -> verified new localhost port. Owner manually confirms Cloudflare zone/hostname eligibility in their own dashboard if browser tooling remains unavailable; no Cloudflare API key/tunnel token leakage. Configure isolated WordPress `home/siteurl` and forwarded HTTPS trust in a reversible reviewed step, verify login/cookies/OAuth return/guest checkout and signed `https://stripe-test.spikersun.com/?wc-api=wc_stripe` POST. Cloudflare Access/full-site bot challenge must not block Stripe webhook. Then and **only under separate authorized TEST-only provider Gate**, Owner privately performs official Woo Stripe TEST OAuth, one $39.99 synthetic checkout, signed first/negative/replay and one TEST refund/revoke. The laptop must stay awake while provider callbacks/retries are tested; no production readiness claim.

The user may grant a **single consolidated Owner permission message** that names both safe new local-stack creation and the future temporary exact Cloudflare hostname TEST-only publication, but the later public operation still requires verified zone/URL and an explicitly reviewed phase boundary. Do not infer external DNS/publication consent from mere technical feasibility questions.

## Return policy

Return precisely only on material target/port conflict, lack of an authorized new-stack write, source/secret provenance problem or proven inability to isolate new volumes. Browser/Cloudflare zone UNKNOWN does **not** invalidate approved loopback-only G3S4K. No old admin password reset, no Windows host rebuild, no shared Docker cleanup.
