# G3C — Blocksy Wedding UI/UX Productization + Owner Visual Freeze

> Governance: VPS Project Governance v0.1.6 + current active addenda  
> Reviewer status: **CURRENT / PROJECT-LOCAL REVERSIBLE IMPLEMENTATION AUTHORIZED**  
> Production / Live payment authority: **NONE**

## 1. Goal

Turn the accepted Birthday Magazine MVP into a local WordPress product experience using the now-proven frontend foundation:

- **Blocksy 2.1.57**
- **Blocksy Companion 2.1.57**
- **Wedding Gutenberg starter**
- **Good Issue browser-local Free Preview**
- **WooCommerce 11.1.2**
- accepted authenticated-account/private-workspace boundaries.

G3CR2R3 has already proven the Wedding Gutenberg shell is importable, Gutenberg-editable and compatible with Product / Cart / Checkout / My Account / private workspace.

This Gate is now about productization and Owner visual editing, not template compatibility research.

## 2. Exact execution package

Executor must use:

`G3C_BLOCKSY_WEDDING_EXECUTION_PACKET.md`

The old Astra-specific `G3C_EXECUTION_PACKET.md` is historical only.

## 3. Required outcome

Produce a local G3C runtime that demonstrates:

1. Birthday Magazine visual/content adaptation using the Wedding shell with minimal structural modification;
2. real Good Issue browser-local preview embedded as the central pre-payment activation experience;
3. native US$39.99 WooCommerce path;
4. desktop + 375px mobile usability;
5. authenticated private-workspace regression;
6. zero pre-payment photo upload and zero model calls;
7. removal/replacement of the two stale imported logo references observed in G3CR2R3;
8. direct Owner Administrator access to edit the main page through WordPress/Gutenberg.

Technical success is only `PASS_CANDIDATE`. Final visual freeze requires explicit Owner review.

## 4. Minimal-modification principle

Prefer adapting the existing Wedding Gutenberg blocks over rebuilding the site.

Reuse:

- photo-led hero;
- memories/story rhythm;
- image galleries;
- event/milestone emotional framing;
- responsive structure.

Replace wedding semantics with Birthday Magazine semantics only where needed.

The site should feel like a personalized photo/story gift, not a generic store.

## 5. Frozen invariants

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
WOO_COMMERCE_CANONICAL_ORDER_SYSTEM=YES
USD_39_99_PRODUCT_PATH=YES
AUTHENTICATED_ACCOUNT_MVP=YES
GUEST_BEARER_PRIVATE_DELIVERY=NO
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
```

## 6. Owner editing requirement

G3C must leave the primary page editable in WordPress/Gutenberg.

At the Owner checkpoint:

- Owner role = Administrator;
- main page opens in Gutenberg;
- Owner can edit text;
- Owner can replace images;
- Owner can reorder blocks;
- Owner can adjust Blocksy global styling;
- local site and wp-admin URLs are reported;
- no persistent password is stored in GitHub/evidence/chat;
- a local-only password set/reset command is supplied if required.

WordPress Studio is not required for this Gate.

## 7. Owner visual checkpoint

After technical PASS_CANDIDATE:

- keep the project-scoped G3C runtime available for Owner review;
- present actual page/screenshots and local edit URL;
- Owner may directly edit the page or request Agent changes;
- visual/copy iterations do not reopen G1–G3B unless they alter frozen product/security/payment boundaries.

Only explicit Owner acceptance freezes G3C.

## 8. Forbidden scope

No:

- PayPal Sandbox/Live action;
- real money;
- production AI/model call;
- production deployment;
- Shared VPS/Caddy/Cloudflare mutation;
- paid plugin/theme purchase;
- Elementor / HT Slider;
- G4/G5/G6;
- broad Docker/system prune.

## 9. Success return

```text
PASS_CANDIDATE_G3C_BLOCKSY_WEDDING_PRODUCTIZATION
OWNER_VISUAL_FREEZE=PENDING
G3C_RUNTIME_RETAINED_FOR_OWNER_REVIEW=YES
STOP_AT_REVIEWER=YES
```

Do not enter G4 after success.
