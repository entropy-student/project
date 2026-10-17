# Birthday Magazine Studio — G3S4L d2b91 Reviewer: guest checkout accepted, 12 loopback anchors require bounded repair before Stripe TEST

Date: 2026-10-17
PR #64 head reviewed: `d2b91e13072fcfd046ef904b0caf5ed73a6f739f` (OPEN, UNMERGED).
Source: only prior G3S4L Evidence file appended, `birthday-magazine-studio/docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md`, section `2026-10-17 G3S4L synthetic guest checkout and Stripe TEST readiness`.
Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7 §§5–9/11B/11C/11D/11E; latest canonical handoff and G3S4L Gate.

## Reviewer result

```text
RESULT=PARTIAL_PASS_GUEST_CART_CHECKOUT_AND_PROVIDER_READINESS
PR64_HEAD=d2b91e13072fcfd046ef904b0caf5ed73a6f739f
PR_DELTA=ONLY_EXISTING_G3S4L_EVIDENCE
PUBLIC_HOST=magazine.spikersun.com
GUEST_PRODUCT_PAGE=HTTPS_200
ADD_TO_CART=HTTPS_200
CART=HTTPS_200_ONE_EXISTING_PRODUCT_QTY_1
CHECKOUT_NONEMPTY=HTTPS_200_21_FORM_CONTROLS
COOKIE=SECURE_HTTPONLY_EXECUTOR_REPORTED
CHECKOUT_RESOURCES=9_OF_9_CSS_200;15_OF_15_JS_200_CORRECT_MIME
FORM_ACTION_HOST=PUBLIC_HTTPS
EXERCISED_LOOPBACK_REDIRECT=NONE
CHECKOUT_ANCHOR_HREF_LOOPBACK=12;TEN_ROOT_ONE_PRODUCT_ONE_OTHER
ORDER_PAYMENT_REFUND=NOT_SUBMITTED
SYNTHETIC_CART_CLEANUP=PASS_ZERO_ITEMS
STRIPE_PLUGIN=OFFICIAL_WOOCOMMERCE_STRIPE_11_1_0_ACTIVE
STRIPE_GATEWAY=DISABLED
STRIPE_MODE_SELECTED=TEST
STRIPE_TEST_LIVE_CREDENTIALS=ABSENT
STRIPE_OAUTH_CONNECTION=ABSENT
STRIPE_WEBHOOK_SIGNING_SECRET=ABSENT
PUBLIC_WEBHOOK_GET=HTTPS_200_BUT_NOT_SIGNED_POST_PROOF
VISUAL_POST_FIX=NOT_CAPTURED
EXACT_SINGLE_PROTECTED_FILE_DENIAL=STILL_UNTESTED_NO_APPROVED_FIXTURE
NEXT_SUBPHASE=TARGETED_PERSISTED_LOOPBACK_ANCHORS_REPAIR_THEN_OWNER_OFFICIAL_TEST_OAUTH
WHOLE_PAYMENT_GATE=NOT_PASS
```

## Acceptance / limits

The Executor evidence supports the **bounded functional guest storefront smoke**: existing public product added in a fresh ephemeral anonymous session; one Woo Store API item at qty 1; non-empty checkout served as HTTPS 200 with 21 form input/select/textarea elements; the customer-facing checkout form targets stay HTTPS; secure/HttpOnly session cookie; all 9 first-party stylesheets and 15 JS returned 200 correct MIME; no actual order/payment/refund; cart cleared and confirmed empty. This resolves the earlier `empty-cart /checkout redirects to /cart` gap. No repetition of add-to-cart/cart/cookie/CSS MIME/media/Tunnel needed.

**Remaining real defect:** 12 `href` attributes in populated checkout HTML point at a `127.0.0.1:8189` loopback host (10 home, 1 product, 1 other page), despite WP `home/siteurl=https://magazine.spikersun.com` and public HTTPS form assets/actions. No click happened; do not assert actual navigation already failed, but visitors clicking will target **their own** machine's loopback origin and break site navigation. The link count is **12 occurrences, not necessarily 12 distinct persisted source records**. Do not infer root cause from URL count: inspect actual rendered HTML element context and the WordPress **persisted link source(s)** such as nav menu item URLs, block/page content, logo/customizer, widgets, Woo templates/theme options, only as implicated by read-only evidence. Search only exact affected public paths, not global blind DB replacement. This is a repair item **before activating Stripe gateway or running TEST charge**; it does not invalidate prior functional guest checkout PASS.

**Other accepted limits:** no screenshot available due to Codex browser management-tab URL-confidence guard, respected; HTTP resource responses do not certify rendered appearance. Specific protected Woo file anonymous denial remains untested for lack of an accepted synthetic safe file selector; prior directory 403 and orders API 401 accepted, and no reason to probe real customer objects. Webhook `GET ?wc-api=wc_stripe` HTTPS 200 proves only public route, NOT Stripe-signed POST acknowledgment/signature/replay logic. The official Woo Stripe payment gateway is **DISABLED** and TEST OAuth/key/webhook signing secret ABSENT. No connection or payment occurred; do not equate saved TEST selector with TEST-connected merchant.

## Next bounded action (no Owner now)

**Codex in one task, still existing G3S4L, and STOP Reviewer after:**

1. Use prior results; read-only enumerate **affected checkout 12 actual `a[href]` contexts and destination patterns**, compare link origin in public home/preview/product/cart and resulting data store. Determine exactly which single/few persisted WP sources own these hrefs (nav menus, widget, block content, etc.), and note whether other hardcoded links remain in representative site-wide navigation; sanitize source output, no customer/session/Secret. Do not run a global SQL `REPLACE`, rewrite every page, re-run complete media/site crawler, or modify Cloudflare/DNS/Tunnel.
2. Make the **smallest guarded reversible update** to the source records actually proven to generate bad links, via WordPress-native menu/post/setting/customizer APIs where possible, with exact before/after record IDs or symbolic selectors and rollback in a private sanitized Evidence. Preserve unrelated navigation, theme, SEO, Woo settings and existing real orders/uploads/backups; no plugin installation or open-ended design changes.
3. Verify checkout `a[href]` **zero loopback after change**, plus one sample home/preview/product/cart or global nav link scan to ensure common header/footer consistently resolve to `https://magazine.spikersun.com` (allow intended external sources), check navigation clicks or HTTP resolution for **one** representative repaired home, product, other link and ensure no external non-HTTPS downgrade. Avoid re-running already accepted cart/order/css bulk tests; use one ephemeral guest cart only if the checkout DOM is required to re-check anchors and clear it again.
4. **Visual if easy, without browser safety bypass:** one real browser screenshot of public site and checkout to close previously unverified appearance, using only legitimately available browser inspection; otherwise `VISUAL_PENDING` with no extra blocked approval. Owner may voluntarily send one screenshot later; don't force a new round.
5. **Payment boundary:** keep official Stripe gateway OFF and TEST/Live account unconnected. Once link defect fixed and verified, next Owner action is **normal official Woo Stripe TEST account signup/login/OAuth** in WordPress dashboard, not keys/token pasted into chat or PR. After Owner consent, Executor checks actual account identity, TEST activation, signed POST Webhook and only then one bounded synthetic USD39.99 TEST charge/replay/invalid/refund/entitlement revoke per existing payment Gate. Do not make TEST purchase or enable Live in this link-repair round.
6. Append concise evidence to **same PR64 G3S4L Evidence** and stop at Reviewer for a short acceptance, then Owner Stripe OAuth. If legitimate small source cannot be identified safely, report precise anchor source/classification and STOP that mutation; no automatic wide rewrites.

**No Owner action required now.** Keep original Windows Docker/Cloudflare connector available. No PR merge or new WordPress/VPS/paid hosting.
