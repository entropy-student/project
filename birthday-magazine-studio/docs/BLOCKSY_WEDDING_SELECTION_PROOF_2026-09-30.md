# Blocksy Wedding Selection Proof — 2026-09-30

Status: **PASS_WITH_RUNTIME_CANARY_REQUIRED**

This document records the Reviewer pre-execution research that justified moving Blocksy Wedding into a bounded local compatibility canary.

## Proven from current official sources

### Concrete starter exists

Blocksy's current Starter Sites catalogue lists **Wedding** and identifies it as supporting:

- Gutenberg
- Elementor

The concrete Wedding page describes a gallery-first event/photo site with Gallery, Stories and About-style content suitable for a photo/memory-led Birthday Magazine shell.

Official:
- https://creativethemes.com/blocksy/starter-sites/
- https://creativethemes.com/blocksy/starter-site/wedding/

### Current Blocksy theme supports WooCommerce

As of this review, WordPress.org lists Blocksy 2.1.57 and describes it as having advanced WooCommerce support and full block-editor compatibility.

Official:
- https://wordpress.org/themes/blocksy/

### Current Companion/importer is active and maintained

As of this review, WordPress.org lists Blocksy Companion 2.1.57.

Current public plugin source confirms:

- Starter Sites are a first-class Companion feature;
- the dashboard retrieves starter-site metadata from the current remote catalogue;
- the catalogue distinguishes free/pro entries;
- WP-CLI exposes `wp blocksy demo list` and `wp blocksy demo install`, making an exact Wedding/Gutenberg availability check reproducible.

Official:
- https://wordpress.org/plugins/blocksy-companion/
- public WordPress.org plugin source mirror / SVN

### Import on fresh install

Blocksy's current documentation recommends importing a Starter Site into a fresh WordPress installation and selecting the desired builder during import.

Official:
- https://creativethemes.com/blocksy/docs/general/install-demo-contents/

## Not yet proven

Research does **not** prove all of the following in Birthday Magazine's exact runtime:

- exact Wedding Gutenberg dependency list returned by the live importer;
- successful Wedding import in the project's isolated Docker baseline;
- absence of theme-specific regression on WooCommerce product/cart/checkout/account pages;
- absence of CSS/layout interference with the accepted private workspace;
- final Birthday Magazine visual result.

Those are the purpose of G3CR2.

## Compatibility strategy

Use the accepted G3A baseline to minimize variables:

- WordPress 7.1.1
- WooCommerce 11.1.2
- MariaDB 11.4.7
- synthetic US$39.99 virtual product
- authenticated account path
- no PayPal / no real money / no production AI

Add only the theme/starter variables required by the canary:

- Blocksy official stable
- Blocksy Companion official stable
- Wedding starter
- Gutenberg builder
- only free dependencies actually required for the Gutenberg Wedding import

Do not use Elementor unless the current Wedding Gutenberg entry unexpectedly proves unavailable and Reviewer explicitly reopens that choice.

## Decision

```text
BLOCKSY_WEDDING_RESEARCH_PROOF=PASS
FULL_RUNTIME_COMPATIBILITY=UNKNOWN
NEXT_GATE=G3CR2_BLOCKSY_WEDDING_WOOCOMMERCE_CANARY
```
