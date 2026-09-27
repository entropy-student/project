# G3A Reference — Mini Craft Lessons Carried Forward

Date: 2026-09-27  
Source project: `mini-craft-night-kit`  
Purpose: prevent Birthday Magazine G3A/G3B from repeating already-observed local commerce/payment failures.

Accepted Mini Craft facts used here:

1. The local WooCommerce commerce loop itself was proven before PayPal.
2. WordPress Studio/SQLite required a local-only `woocommerce_hold_stock_minutes=0` workaround and later reproduced broader runtime instability even on a clean Studio control.
3. Moving to Docker + WordPress + MariaDB isolated the Studio runtime problem and restored a representative WooCommerce runtime.
4. WooCommerce PayPal Payments was kept as the official payment plugin rather than hand-coding PayPal or introducing a second order system.
5. PPCP 4.1.3 exposed a page-scope React mount issue; the direct PayPal settings page had to be tested separately from the Payments overview.
6. PayPal connection failure was not treated as automatically meaning “bad credentials”; runtime, network, plugin and credentials were isolated.
7. The successful Sandbox path ultimately required a valid temporary HTTPS public origin for PPCP client-token/webhook behavior.
8. Sandbox credential handling had to remain Owner-only and sanitized; diagnostic output can itself become a credential-leak risk.
9. A successful Sandbox payment was accepted only after WooCommerce order state, provider capture correlation, callback/webhook behavior and duplicate-capture absence were checked.

Birthday Magazine adaptation:

- G3A starts directly on Docker/MariaDB and does not install PPCP.
- Birthday Magazine is a virtual personalized product, so Mini Craft's stock/shipping/physical-fulfillment semantics are not copied.
- G3A adds authenticated account + private order/workspace isolation, because that is a frozen Birthday Magazine product requirement.
- G3B will reuse the successful official PPCP architecture and public-origin lesson, but only after G3A passes.
