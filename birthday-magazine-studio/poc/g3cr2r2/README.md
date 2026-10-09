# G3CR2R2 — Blocksy Wedding v2 catalogue closure

This isolated, local-only run queried the same v2 catalogue used by Blocksy Companion 2.1.57. It stopped in Phase A because the response had two `Wedding` records, with `builder` values `""` and `"elementor"`, and no record whose builder was exactly `"gutenberg"`.

The empty-builder record lists `simply-gallery-block`, `stackable-ultimate-gutenberg-blocks`, and `wpforms-lite`. It was preserved as its own record and was **not** inferred to be the exact Gutenberg record. The Elementor record was kept separate. No plugin from either record was installed, no Starter Site was imported, and WooCommerce was not installed.

## Runtime

- Compose project: `birthday-magazine-g3cr2r2`
- Local-only WordPress: `127.0.0.1:8177`
- Local-only Mailpit UI: `127.0.0.1:8178`
- WordPress 7.1.1 / PHP 8.3.33 / MariaDB 11.4.7
- Blocksy 2.1.57 / Blocksy Companion 2.1.57 from official WordPress.org packages
- G3A commerce workspace and Mailpit helper sources are mounted read-only

The WordPress-side read-only query is `scripts/query-v2-catalog.php`. The sanitized response and separate Wedding variants are retained under `artifacts/reports/`. No license/install identifiers or authorization headers were sent.

## Cleanup

The runtime and temporary package directory were removed after the Phase A result. The read-back is in `artifacts/reports/cleanup-readback.json`. The cleanup script is scoped to this Compose project and this directory's own ignored `.tmp/` package folder.
