# Birthday Magazine Studio — G3S4L 728609 Reviewer PASS / official Stripe TEST authorization next

Date: 2026-10-17
PR #64 current reviewed head: `728609c54b68ae955150fd4957af93cac2f4d815` (OPEN, UNMERGED).
Source: existing PR64 `birthday-magazine-studio/docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md` latest append `2026-10-17 G3S4L targeted loopback navigation repair`. No application Git code changed in this commit.
Authority: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7 §11B/C/D/E, existing G3S4L Gate and latest Handoff.

## Formal result

```text
RESULT=PASS_BOUNDED_NAVIGATION_LINK_REPAIR;NEXT_OWNER_OFFICIAL_STRIPE_TEST_AUTH
SCOPE=WP_PERSISTED_MENU_PAGE_REUSABLE_BLOCK_AND_BLOCKSY_HEADER_CTA
PR64_HEAD=728609c54b68ae955150fd4957af93cac2f4d815
EVIDENCE_DELTA=ONE_APPEND_ONLY_FILE
CHECKOUT_BEFORE_LOOPBACK_A_HREFS=12
CHECKOUT_AFTER_LOOPBACK_A_HREFS=0
HOME_PREVIEW_PRODUCT_MYACCOUNT_AFTER_LOOPBACK_A_HREFS=0
MENU_POST_IDS=1094,1095,1096,1097,1098,1099,1100,1101,1103,1104,1105
EXTRA_SOURCES=HOME_PAGE_858_1_LINK;REUSABLE_BLOCK_1143_3_LINKS;BLOCKSY_HEADER_THEME_MOD_1_LINK
API=GUARDED_UPDATE_POST_META_WP_UPDATE_POST_SET_THEME_MOD
FRAGMENTS=HOW_IT_WORKS_FAQ_PREVIEW_SAMPLES_WHAT_YOU_GET_PRESENT
PUBLIC_PAGES_HTTPS_200=HOME_PREVIEW_PRODUCT_MYACCOUNT_AND_NONEMPTY_CHECKOUT
EPHEMERAL_CART=CLEANED_ZERO_ITEMS
NO_ORDER_OR_PAYMENT=YES
UNRENDERED_WIDGET_TEXT_3=OLD_LOOPBACK_HREFS_PERSIST;NO_RENDER_ON_SAMPLED_PAGES;NOT_EDITED
VISUAL_RENDERING=NOT_YET_SIGHTED
SPECIFIC_PRIVATE_WOO_FILE_NEGATIVE=NOT_TESTED_NO_SAFE_FIXTURE
STRIPE_PLUGIN=WOOCOMMERCE_STRIPE_11.1.0_ACTIVE
STRIPE_GATEWAY=DISABLED
STRIPE_TEST_SELECTOR=ON_BUT_NO_CONNECTED_ACCOUNT
STRIPE_TEST_AND_LIVE_ACCOUNT_SECRETS=NOT_CONNECTED
STRIPE_SIGNED_WEBHOOK_POST=NOT_VERIFIED;GET200_ONLY
PUBLIC_HOST=magazine.spikersun.com
NEXT_OWNER_ONLY_PROVIDER_STEP=OFFICIAL_WOO_STRIPE_TEST_ACCOUNT_OAUTH_OR_SIGNUP
REAL_LIVE_MONEY_AND_GATEWAY=NOT_AUTHORIZED
PR64_MERGE=NOT_AUTHORIZED
```

## Evidence analysis and acceptance

1. This was not a blanket old-domain replacement. Eleven explicitly enumerated `_menu_item_url` record IDs received exact-origin updates while retaining suffixes/fragment identifiers. One anchored product link on Home page 858, three links in reusable published footer block 1143 and one Blocksy header button theme mod were updated with verified old values through native WP APIs. IDs, original/new values, guard conditions and reverse operations are recorded. The **12 checkout link occurrences are not 12 different WP source objects**, and the repair rightfully inspected the persisted origins.
2. Executor-reported independent readback of 11 menu records, Home/footer/header link values and real public HTML across homepage, `/make-your-magazine/`, product, My Account and a temporary **nonempty** checkout showed **zero** loopback anchor hrefs. Relevant home fragments exist. HTTPS returned 200 and temporary cart returned zero items after cleanup. No real order/charge, no cloud/Stripe/theme-file/global DB rewrite.
3. One **`widget_text-3` assigned to `ct-footer-sidebar-3` still stores old loopback URLs**. On the observed 5 public pages it was **not rendered** and was *not proven to produce active broken links*. Preserve it as a specifically scoped dormant/conditionally-rendered **deferred URL debt**; no need for another remediation round before TEST account authorization. If this widget or footer region is reactivated on any other page, fix its known URLs through its own exact, guarded WordPress API update **before promoting that page/public navigation**, and verify the output. Do not describe the widget as deleted, inactive globally or zero remaining loopback values across the entire WordPress database.
4. Visual rendering was not captured. The current PASS addresses URLs/HTML and HTTP routes, **not** pixel layout or full finished storefront acceptance. Do not bypass the previous Cloudflare manager Computer Use tab safety check; if one Owner browser screenshot or approved public-site visual can be obtained later alongside provider setup, attach it opportunistically, **not** another redundant G3S4L gate.
5. The prior external anonymous Woo orders API 401, protected-upload dir 403 and admin redirect are accepted as bounded safety checks; individual protected file remains unavailable for safe synthetic selector, not evidence of disclosure. No live payment authorization implied by public HTTPS page or checkout form.
6. Official Woo Stripe plugin 11.1.0 installed/active; gateway OFF and TEST selected, but **NO Stripe TEST account connection, credentials or webhook secret**. No-body GET 200 to `https://magazine.spikersun.com/?wc-api=wc_stripe` does **not** certify signed POST, anti-replay, payment idempotency or payouts. No payment attempted.

## Next phase: account-only Owner authorization, no new infrastructure

**Owner, once, in the existing REAL WordPress public administrator UI**:

- Visit `https://magazine.spikersun.com/wp-admin/`, navigate `WooCommerce → Settings → Payments → Stripe` (or Stripe Manage/Complete setup). Open the official `Configure connection → Test` controls and select **Create or connect a test account**, not Live. If a currently unconnected plugin shows a test-only account option at Complete setup, use that official option. WooCommerce's own documentation says Live and Test connections are separate and shows a test-only account path. Do **not** assume a usable Stripe account already exists; if signup requires a supported business country and genuine company/identity details, do not invent or falsify data. If it tries to authorize Live and offers no TEST-only flow, stop at the account UI and ask Reviewer with an **unredacted token-free** UI description/screenshot rather than consenting to Live.
- Owner completes Stripe official login/signup/consent privately; **never copy any secret, password, token or `whsec_` key into Codex/ChatGPT/PR**. Do not enable Live, process a live payment or paste manual credentials. Existing original Woo Stripe gateway should stay disabled until TEST connection, webhook and checkout ready.
- Official guides: `https://woocommerce.com/document/stripe/setup-and-configuration/connecting-to-stripe/` and `https://woocommerce.com/document/stripe/customer-experience/testing/`.

**After Owner test connection, Codex/Executor** (same existing project/PR Gate, read-only first): verify actual connected Stripe account identity, **Test** tab status, no Live account binding/keys, plugin gateway disabled or test-only, webhook configured status and external signed **POST** behavior; inspect protected private-route safety and checkout stability without re-running the prior media/nav/CSS site survey. Record a sanitized G3S4L Evidence appendix. If gateway activation or test purchase is authorized after connection, allow **ONE** bounded USD 39.99 synthetic test purchase followed by valid signed webhook first/duplicate/invalid and one matching test refund/revocation; preserve idempotency and original non-test orders. Do not claim real payment closed loop until those are actually evidenced. Formal Reviewer may split only at a genuine provider/risk boundary; no generic RETURN.

No new Tunnel, DNS, WordPress install, backups, AppData, test-token capture or repeated visual gate. PR64 OPEN/UNMERGED. Reviewer did not directly operate the Owner WP/Stripe provider accounts.
