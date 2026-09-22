# Current UI Snapshot Pack

This is a read-only archive captured at the `OWNER_K4_UI_EDIT_WINDOW` checkpoint. It records the live local WordPress/Kadence/WooCommerce presentation without changing pages, settings, orders, or payment state.

| # | Page / type | Current URL | Desktop | Mobile | Reusable template page | Current template-feel note |
|---:|---|---|---|---|---|---|
| 01 | Home | `http://localhost:8093/` | [01-home-desktop.png](ui-current/01-home-desktop.png) | [01-home-mobile.png](ui-current/01-home-mobile.png) | Yes | Kadence starter composition is a useful base; the current hero remains the main template-led surface. |
| 02 | Shop / Store archive | `http://localhost:8093/shop/` | [02-shop-desktop.png](ui-current/02-shop-desktop.png) | [02-shop-mobile.png](ui-current/02-shop-mobile.png) | Yes | Canonical WooCommerce/Kadence catalog baseline; presentation is intentionally default-like. |
| 03 | Product | `http://localhost:8093/product/mini-craft-night-kit/` | [03-product-desktop.png](ui-current/03-product-desktop.png) | [03-product-mobile.png](ui-current/03-product-mobile.png) | Yes | Canonical product template with current local test product data and existing approved imagery. |
| 04 | FAQ | `http://localhost:8093/faq/` | [04-faq-desktop.png](ui-current/04-faq-desktop.png) | [04-faq-mobile.png](ui-current/04-faq-mobile.png) | Yes | Text-forward FAQ page; suitable as a reusable content template. |
| 05 | Shipping & Returns | `http://localhost:8093/shipping-returns/` | [05-shipping-returns-desktop.png](ui-current/05-shipping-returns-desktop.png) | [05-shipping-returns-mobile.png](ui-current/05-shipping-returns-mobile.png) | Yes | Factual policy page; it remains intentionally conservative and editable. |
| 06 | Contact | `http://localhost:8093/contact/` | [06-contact-desktop.png](ui-current/06-contact-desktop.png) | [06-contact-mobile.png](ui-current/06-contact-mobile.png) | Yes | Native Kadence form surface; final contact routing remains an Owner-editable concern. |
| 07 | Cart | `http://localhost:8093/cart/` | [07-cart-desktop.png](ui-current/07-cart-desktop.png) | [07-cart-mobile.png](ui-current/07-cart-mobile.png) | Yes | Canonical WooCommerce cart; anonymous snapshot shows the current empty-cart baseline. |
| 08 | Checkout | `http://localhost:8093/checkout/` | [08-checkout-desktop.png](ui-current/08-checkout-desktop.png) | [08-checkout-mobile.png](ui-current/08-checkout-mobile.png) | Yes | Canonical WooCommerce checkout; anonymous empty-cart redirect/visibility is preserved. |
| 09 | Thank You / Order Received | `http://localhost:8093/checkout/order-received/1120/?key=[redacted]` | [09-thank-you-desktop.png](ui-current/09-thank-you-desktop.png) | [09-thank-you-mobile.png](ui-current/09-thank-you-mobile.png) | Yes | Existing Sandbox test-order confirmation only; no new order was created. |
| 10 | My Account / Orders | `http://localhost:8093/my-account/` | [10-account-desktop.png](ui-current/10-account-desktop.png) | [10-account-mobile.png](ui-current/10-account-mobile.png) | Yes | Canonical WooCommerce account surface; anonymous/logged-out baseline. |

## Capture metadata

- `CURRENT_GATE=OWNER_K4_UI_EDIT_WINDOW`
- `CAPTURE_MODE=read-only viewport screenshots`
- `DESKTOP_VIEWPORT=1440x900`
- `MOBILE_VIEWPORT=390x844`
- `TABLET_CAPTURE=NOT_PERFORMED`
- `SCREENSHOT_COUNT=20`
- `ANONYMOUS_CAPTURE=YES`
- `EXISTING_ORDER_REUSED=YES`
- `NEW_ORDER_ACTIONS=0`
- `PAYMENT_ACTIONS=0`
- `PAGE_OR_CONFIGURATION_CHANGES=0`
- `SECRET_EXPOSURE=NO`

The Checkout screenshot reflects the anonymous empty-cart baseline, and the Thank You screenshot reuses the already-existing local Sandbox test-order URL with its order key intentionally redacted here.
