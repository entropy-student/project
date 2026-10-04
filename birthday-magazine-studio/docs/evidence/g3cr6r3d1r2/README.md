# D1R2 evidence index

Fresh readback only. See [closure report](../../G3CR6R3D1R2_LOCAL_HOMEPAGE_READBACK_REPORT.md). Accepted Focusly evidence is reused in sibling `../g3cr6r3d1/`; not recaptured.

- `containers-before.json`, `containers-after.json`: sanitized identities/state/image/mounts/ports only; unrelated mount source/destination paths replaced with SHA256. No environment/auth/log payloads.
- `volumes-before.txt`, `volumes-after.txt`; `networks-before.txt`, `networks-after.txt`: name/ID inventory, no inspection of unrelated volumes/data.
- `wordpress-before.json`, `wordpress-after.json`: current Home/groups/template/menu/product/capability/protected-hash projection, identical.
- `browser-readback.json`: fresh1440/375 render/anchors/CTA/Preview presence and GET-only routes. Checkout captures are the resulting empty Cart, not a checkout-form claim.
- `checkout-redirect.json`: separate GET without redirect-following confirms native302 to Cart.
- `source-correlation.json`: unchanged accepted D1 source/asset inventory.
- `screenshot-manifest.json`:14 fresh PNGs, dimensions/size/SHA256.
- `closure-status.json`: machine acceptance checks and exact limitations.
- `submission-preflight.json`: approved head, synchronized project main and final fetched main; no new Birthday Magazine main-only commits. Final push/PR head read-back is returned after commit.
- `readback.php`: read-only WordPress projection, piped to existing container PHP stdin.
- `capture-readonly.cjs`: isolated Edge contexts; no input/click/cart/order actions, non-GET/PayPal guard.
- `verify-readback.cjs`: projection comparison and screenshot/readback checks; normalizes mount ordering only.

Screenshots in `screenshots/`: desktop/mobile `home-full`, `home-hero`, `preview-presence`, `product`, `cart`, `checkout`, `account` (14 files). Default synthetic Taylor preview only; no photo selected. No credentials, cookies or form nonces captured as structured data.

No application/WordPress/source mutation. Three retained existing project containers started; WP-CLI remains stopped. No rebuild/recreate/pull/reset/migration/global configuration/prune. No payment/provider/checkout submission/model/deployment/shared-infra action. Owner Preview hold unchanged. Stop at Reviewer; no implementation.
