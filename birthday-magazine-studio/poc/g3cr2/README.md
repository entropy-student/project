# G3CR2 Blocksy Wedding WooCommerce canary

## Current result

`RETURN_G3CR2_GUTENBERG_DEPENDENCY_AMBIGUOUS`

The Owner retry found Docker Engine available and started only the isolated `birthday-magazine-g3cr2` Compose project. WordPress 7.1.1, MariaDB 11.4.7, Blocksy 2.1.57, and Blocksy Companion 2.1.57 ran locally. The installed theme was active. Exact versions, official package URLs, licenses, SHA-256 hashes, and resource read-back are in `artifacts/reports/`.

The supported read-only importer query was `wp blocksy demo list --format=json`. Its Wedding entry lists builders `gutenberg, elementor` and one undifferentiated plugin list:

`simply-gallery-block, stackable-ultimate-gutenberg-blocks, wpforms-lite, elementor, ht-slider-for-elementor`

The importer does not map these plugins to a builder variant. Since the Gutenberg path cannot be separated from the Elementor/HT Slider entries from this catalog, execution stopped before any Starter import. Elementor was not installed. All listed slugs had a free WordPress.org directory package available at read-back time, but the exact required dependency set for Wedding/Gutenberg remains unresolved.

No WooCommerce compatibility canary, product/page/order/account/workspace was created. The Wedding screenshots and WooCommerce screenshots are not applicable because Phase A returned before import. No PayPal/payment, real-money, model/AI, paid purchase, public deployment, or shared-infrastructure action occurred.

## Isolated runtime

`compose.yaml` uses the independent Compose project `birthday-magazine-g3cr2`, localhost ports `127.0.0.1:8167` and `127.0.0.1:8168`, unique named volumes and a unique network. The only mounted project plugin sources were the accepted G3A commerce workspace plugin and Mailpit local capture helper, both read-only. The historical `poc/g3a/` and `poc/g3b/` sources were not edited.

`capture-catalog.ps1` saves the exact current importer catalog and a structured read-back. It is read-only and does not import a Starter Site.

## Cleanup

The G3CR2 containers, named volumes, and network were removed with project-scoped Compose teardown. Temporary packages and credentials were removed from the exact ignored `poc/g3cr2/.tmp/` directory. See `artifacts/reports/resource-readback.json` for the before/after result.
