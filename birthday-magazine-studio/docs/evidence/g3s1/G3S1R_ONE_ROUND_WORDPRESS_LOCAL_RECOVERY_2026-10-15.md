# G3S1R — One-round local WordPress recovery

Date: 2026-10-15  
Result: `PASS_CANDIDATE_G3S1R_LOCAL_RUNTIME_RESTORED`  
PR: #64, branch `codex/birthday-magazine-g3c-blocksy-wedding-productization`  
Pre-evidence PR head: `5903726a68160624c52e871f2dde9d36123a9aa3` (Open, unmerged)  
Current Gate on main: `G3S1R_ONE_ROUND_WORDPRESS_LOCAL_RECOVERY`  
Reviewer Handoff blob: `80a874bb451ff147bf4ca7ab1ad0bf1d2fec22d6`  
Gate blob: `e6f7cb51b27461aa8641f89dec67c72c687fd26b`

## Startup and resource identity

Windows Codex PowerShell executor, Docker context `desktop-linux`, Engine 29.7.2, Compose 5.4.0. The original stopped WordPress container received exactly one ordinary start command:

```
docker start 21892d72baebe6157fbeab15ad6a1e3949cf4663ca55b45360c3f4eb1f052f00
```

It returned exit 0 and the same container ID. No retry.

All four original G3C containers were present under Compose project `birthday-magazine-g3c` and their IDs/images matched the accepted baseline:

| Service | ID prefix | Image | Before | Final |
|---|---|---|---|---|
| db | `361d58eb5454` | MariaDB 11.4.7 | running, healthy | running, healthy |
| wordpress | `21892d72baeb` | WordPress 7.1.1 / PHP 8.3 Apache | stopped | running |
| mailpit | `35d286e7af50` | Mailpit 1.31.2 | stopped | stopped (not needed for GET smoke) |
| wpcli | `de9742647e06` | WordPress CLI / PHP 8.3 | stopped | running for read-only inventory |

Both existing volumes remained present and attached: `birthday-magazine-g3c_database` → `/var/lib/mysql`, `birthday-magazine-g3c_wordpress` → `/var/www/html`. The existing private network `birthday-magazine-g3c_private` remained. The WordPress container kept its existing loopback-only port mapping `127.0.0.1:8189:80` and read-only binds for `.htaccess`, Preview, commerce/workspace, and Mailpit plugins. Compose source blob: `d174843bb0a510003c04c8ce327852860f886f31`.

No volume content was enumerated or copied. The database container stayed healthy and the same named volumes/attachments were retained. A read-only post-start count found one HPOS order row and zero legacy `shop_order` posts; no before-start order count was captured, so no count delta is claimed. No order, account, payment, or provider mutation was issued.

## Local WordPress / WooCommerce readback

Direct loopback GETs used `curl.exe` without cookies or authentication. Status and downloaded-byte counts:

| Route | Result |
|---|---|
| `/` | 200, 99,898 bytes; rendered `bms-preview` marker present |
| `/make-your-magazine/` | 200, 76,324 bytes; photo-flow content present |
| `/product/birthday-magazine/` | 200, 79,742 bytes |
| `/cart/` | 200, 131,963 bytes |
| `/checkout/` | 302 for the empty cart; no checkout submission or populated-checkout claim |
| `/my-account/` | 200 |
| `/wp-login.php` | 200 |
| unauthenticated private workspace route | 403 |

WooCommerce Store API GET for product 1113 returned `The Birthday Magazine`, simple, purchasable, USD 3999 minor units. Read-only WordPress metadata confirmed `virtual=yes`, price/regular price 39.99, currency USD. Both WordPress `home` and `siteurl` resolve to HTTP loopback port 8189.

The PowerShell .NET `Invoke-WebRequest` client reported `The response ended prematurely` even while direct loopback `curl.exe` requests returned the page. In-container Apache returned HTTP 200 when sent the configured `Host: 127.0.0.1:8189`; the bare host correctly redirected to that loopback origin. This was not evidence of WordPress corruption. Apache configuration check exited 0; only a non-fatal server-name notice appeared. Safe log classification found no PHP fatal, database-connect, permission, or setup-wizard errors.

## Versions and sanitized plugin/gateway inventory

WordPress 7.1.1; WooCommerce 11.1.2 active; USD. Active plugins: `bms-g3a-commerce-loop 0.1.0`, `bms-g3c-preview 0.3.0`, Blocksy Companion 2.1.57, Simply Gallery Block 3.4.3, Stackable 3.20.2, WooCommerce 11.1.2, WPForms Lite 2.0.2.1. Local Mailpit MU plugin 0.1.0. Akismet 5.7.2 and Hello 1.7.2 were inactive.

The complete WP-CLI plugin inventory did not list official WooCommerce PayPal Payments/PPCP or a Stripe plugin. A sanitized read-only projection found the legacy core `woocommerce_paypal_settings` option with `enabled=no`; no PPCP settings or Stripe option names were present. This reports local plugin/options state only; no provider account, credential, or connection was queried. PayPal configuration was not changed and Stripe was not installed.

## Repair decision and boundaries

No WordPress core/container defect was found after the single start: the existing site and WooCommerce paths responded normally. Therefore the conditional repair branch was skipped; no database/file backup or restore was needed, and no reinstall/repair was performed.

```text
WORDPRESS_START_ATTEMPTS=1
WORDPRESS_START_RESULT=SUCCESS
WORDPRESS_REPAIR=NONE
BACKUP=NOT_REQUIRED_NO_REPAIR
DATABASE_OR_WORDPRESS_VOLUME_DELETE_RECREATE=0
COMPOSE_UP_BUILD_PULL_RECREATE=0
STRIPE_INSTALL_OR_ACTIONS=0
PAYPAL_CONFIGURATION_OR_PROVIDER_ACTIONS=0
PAYMENT_CHECKOUT_SUBMISSION_REFUND_WEBHOOK=0
PUBLIC_TUNNEL_OR_SHARED_INFRA=0
FRONTEND_OR_WORDPRESS_CONTENT_EDIT=0
SECRET_OR_CUSTOMER_PII_OUTPUT=0
STOP_AT_REVIEWER=YES
```

The original WordPress, database, volume, bind-mount, and network identities were retained. WP-CLI remains running as the already-existing private helper used for inventory; Mailpit remains stopped. The site is available on loopback at `http://127.0.0.1:8189/`. G3S1 Stripe staging remains on hold pending Reviewer acceptance; no later Gate was started.
