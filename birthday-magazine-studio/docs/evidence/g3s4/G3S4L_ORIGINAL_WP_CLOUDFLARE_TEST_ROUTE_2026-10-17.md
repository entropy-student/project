# G3S4L — original WordPress Cloudflare TEST route preflight evidence

Date: 2026-10-17  
Gate: [G3S4L original WordPress Cloudflare TEST route](https://github.com/entropy-student/project/blob/main/birthday-magazine-studio/docs/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_GATE_2026-10-17.md)  
Reviewer decision: [G3S4L owner-authorized original-site route](https://github.com/entropy-student/project/blob/main/birthday-magazine-studio/docs/REVIEWER_DECISION_G3S4L_OWNER_AUTH_ORIGINAL_WP_CLOUDFLARE_RESCOPING_2026-10-17.md)  
PR #64 branch: `codex/birthday-magazine-g3c-blocksy-wedding-productization`  
Pre-update PR head: `9461d5c5f8fa3c7b1bb570dc8f2f810e9bf67956`

## Result

~~~text
GATE=G3S4L_ORIGINAL_LOCAL_WP_CLOUDFLARE_TEST_20261017
EXECUTOR_RESULT=RETURN_CLOUDFLARE_EXACT_ZONE_UNVERIFIED
OWNER_REPORTED_PASSWORD_ROTATION=YES
LOCAL_PUBLICATION_AUDIT=PARTIAL_NO_WRITE
PUBLICATION_SAFETY=NOT_CERTIFIED
MEDIA_CONTENT_SENSITIVITY=UNKNOWN
CLOUDFLARE_ZONE_ACTIVE_OR_PERMISSION=UNKNOWN_OWNER_MANUAL_CHECK_REQUIRED
stripe-test.spikersun.com=PROPOSED_ONLY
DNS_OR_TUNNEL_WRITE=NO
PUBLIC_TUNNEL=NO
WORDPRESS_URL_OR_DATABASE_WRITE=NO
STRIPE_OAUTH_WEBHOOK_PAYMENT_OR_REFUND=NOT_STARTED
PR64_MERGE=NO
STOP_AT_REVIEWER=YES
~~~

Owner reported the previously exposed WordPress password was privately rotated. No password or credential was requested, read, or recorded.

## Narrow local anonymous-access checks

The accepted G3S4J runtime/backup evidence was reused for the existing site, Stripe configuration, and prior backup state. No backup, restore, deployment, database write, plugin change, source change, or full host survey was performed. The current original site remains the existing loopback target; the local home page returned HTTP 200.

Status-only unauthenticated requests used no browser session, cookies, WooCommerce keys, or request body:

| Surface | Read-only result |
|---|---|
| Existing WooCommerce orders | One order exists. Store API order route returned 404; WooCommerce REST order route returned 401. |
| My Account order detail route | HTTP 200 login page; login marker present and Woo order-detail markup absent. The order identifier was not emitted. |
| WordPress admin | `/wp-admin/` returned 302 to login; login page returned 200. |
| WooCommerce private uploads | Directory listing returned 403. Both files found in the private Woo uploads directory returned 403 on anonymous HEAD. |
| Debug/config paths | `debug.log`, `.env`, and `.git/config` returned 404. |
| Stripe legacy GET | `/?wc-api=wc_stripe` returned 200 to HEAD. No POST, event, or signature test was sent. |
| Public WordPress media | REST listed 63 attachments; five sampled image URLs returned HTTP 200 to anonymous HEAD. Attachments were unattached or linked to posts/pages; none were linked to the existing order. Media contents were not opened or copied. |
| WordPress user REST | One limited public profile was enumerated; the administrator username slug was not returned. The public profile’s display name/URL content was not copied into this evidence. |

A metadata-only filesystem count found 389 upload files, including two in WooCommerce’s protected upload directory. The earlier accepted backup inventory recorded 387; the two-file difference was not investigated further. No names, paths, customer values, order ID, response body, password, or secret are included here.

The public attachment endpoint is expected to serve site media, but this bounded check did not inspect the media contents. It therefore does **not** prove every publicly reachable image is non-personal. The anonymous users endpoint also returns a limited profile. Publication safety is consequently **not certified**; this evidence does not claim a private-data leak was proven.

Previously accepted G3S4M evidence remains the source for Stripe’s current state: official WooCommerce Stripe 11.1.0 is installed/active while the payment gateway is disabled; no connected Stripe account, saved payment configuration, webhook, payment, or refund was recorded. No Live or PayPal change was made in this round.

## Cloudflare confirmation and boundary

The required manual Owner values were not received: zone `spikersun.com` Active/account permission, whether the exact `stripe-test` DNS label is unused, and whether a matching Tunnel hostname route exists. The proposed hostname remains unverified. The prior Computer Use failure happened before reading a Cloudflare page; its root cause remains UNKNOWN. No automated browser retry or alternate automation was used.

No DNS record or Tunnel was created. WordPress `home/siteurl`, plugin state, database, existing orders/uploads, and backups were not changed. No Stripe login, OAuth, payment, webhook, refund, public exposure, or VPS action occurred.

**Reviewer checkpoint:** confirm the remaining publication-safety treatment for public media/profile data and the exact Cloudflare zone/hostname before any public write. Until then, leave the original site local-only.

STOP_AT_REVIEWER=YES
