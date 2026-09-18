# Reviewer Decision — K0R2 WordPress Studio Consolidation

Date: 2026-09-18
Status: APPROVED TO EXECUTE

## Goal

把已经通过 K0/K0R1 的 Kadence + WooCommerce 本地 PoC 原样迁入 WordPress Studio，让后续 K1–K5 都在 Studio 中统一管理。

当前 Docker PoC 继续作为回退基线，迁移成功前不得删除。

## Current source

- Existing local site: `http://localhost:8090`
- Existing project: `mini-craft-kadence-poc`

## Target

WordPress Studio 中出现一个独立站点：`Mini Craft Night Kit`。

Owner 后续应能直接从 Studio 打开 Site 和 WP Admin，不再依赖记忆 Docker 端口和后台账号。

## Migration principle

Preferred sequence:

```text
Existing Docker WordPress
→ create project-local full-site backup
→ WordPress Studio: Import from a backup
→ validate imported site
→ keep Docker source as rollback
```

Do not use WordPress.com Sync for this migration.

## Database boundary

WordPress Studio normally manages local sites with SQLite. The preferred result is a Studio-managed local database, not a hidden dependency on the old Docker MariaDB.

If the supported import unexpectedly requires the old Docker DB or breaks WooCommerce, RETURN instead of improvising.

## Required preservation

Preserve:
- Kadence Theme
- Kadence Blocks
- Starter Templates
- WooCommerce
- imported Single Product content
- demo product
- Home / Product / Cart / Checkout
- uploads/media
- menus
- Gutenberg validity

Do not apply Mini Craft branding in this Gate.

## Owner access

After migration, Owner must be able to enter WP Admin from Studio without needing the old Docker password.

Do not put admin credentials in GitHub.

## Safety

Do not:
- delete Docker PoC or Docker volumes
- modify old `mini-craft-night-kit`
- enter K1
- change branding
- connect PayPal
- perform real payment
- deploy VPS
- use production domains
- install an extra migration plugin unless the supported Studio import path fails and Reviewer approves

## Project containment

Any migration archive, temp extraction, or helper file must live under the project directory, preferably:

`mini-craft-kadence-poc/.artifacts/studio-migration/`

No migration artifact may be left in the shared `VPS基建` root.

## Validation

After import verify in Studio:
- Home
- Product
- Cart
- Checkout
- WooCommerce Orders admin
- Gutenberg Home editor
- invalid block count = 0
- mobile 375
- tablet 768
- desktop 1440
- 1920 smoke
- no obvious horizontal overflow

## PASS candidate

```text
PASS_CANDIDATE_K0R2_WORDPRESS_STUDIO_CONSOLIDATION
STUDIO_INSTALLED_OR_AVAILABLE=PASS
STUDIO_SITE_IMPORTED=PASS
HOME_RUNTIME=PASS
PRODUCT_RUNTIME=PASS
CART_RUNTIME=PASS
CHECKOUT_RUNTIME=PASS
WOOCOMMERCE_BASELINE=PASS
GUTENBERG_EDITOR=PASS
INVALID_BLOCK_COUNT=0
OWNER_STUDIO_ADMIN_ACCESS=PASS
MOBILE_RESPONSIVE=PASS
TABLET_RESPONSIVE=PASS
DESKTOP_RESPONSIVE=PASS
DOCKER_SOURCE_RETAINED=PASS
OLD_PROJECT_UNCHANGED=PASS
SHARED_WORKSPACE_ROOT_CLEAN=PASS
EXTRA_MIGRATION_PLUGIN_INSTALLED=NO
BRAND_CUSTOMIZATION=NO
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
STOP_AT_REVIEWER=YES
```

## After PASS

Do not delete Docker yet.

The next Owner checkpoint is `OWNER_STUDIO_MIGRATION_REVIEW`.