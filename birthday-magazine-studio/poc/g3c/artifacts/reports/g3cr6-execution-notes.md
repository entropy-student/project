# G3CR6 execution / rollback notes

Gate authority: latest main becb2ab9c644649a07327664cfdb5ae975964ba9, docs/G3CR6_FRONTEND_EXPERIENCE_BRAND_REDESIGN.md plus latest Owner request and provided reference ZIP. The Handoff's older Owner-only checkpoint restriction is superseded by this specific Gate authorization; no Reviewer decision was edited.

## Writes

- Home 858 remains six nested Gutenberg groups: Hero, samples, local Preview, What, How, Offer/FAQ. Text, images, FAQ and groups remain editable.
- Imported three curated fictional marketing images as WordPress attachments 1137–1139.
- Product 1113 retains ID, price 39.99 USD, virtual property and all commerce behavior. Only title/description and featured marketing image changed.
- Preview shortcode markup, browser-only state handling and frontend CSS changed. Native Woo gallery uses the standard full-image-size filter, preserving gallery controls/actions.
- No changes to compose.yaml, workspace plugin, checkout/payment/account/entitlement logic, schema or renderer.

## Rollback

Artifacts/backups/g3cr6/home-and-blocksy-before.json uses the existing compatible g3cr4-pre-edit-backup-v1 format. Captured before frontend mutation and extended with original product thumbnail. Blocksy theme mods were not changed.

Artifacts/backups/g3cr6/product-copy-before.json captures original product copy before its change.

Artifacts/backups/g3cr6/preview-plugin-before/ contains the previous plugin implementation. Restore these exact files and remove the new g3cr6-brand.css (or revert this Gate's Git changes). Copy both JSON backups into the local WordPress container and execute scripts/restore-g3cr6.php with their container paths as two arguments. It restores Home, product copy and thumbnail. New marketing attachments remain harmless unused media after rollback; no automatic broad deletion is performed.

Do not rerun the Home installer on the current modified page: its backup/content hash guard intentionally fails. The initial installation saved the new Home successfully, then failed in final reporting because of an undefined theme variable; reporting was repaired in the durable installer and saved state was verified directly without a second import.

## Regression reproduction

Node scripts/capture-g3cr6.cjs uses existing ignored Playwright Core 1.62.1 and local Edge. It uses fresh temporary browser sessions, local fictional images, native Add to Cart and cart-only mutations; it never submits Checkout or logs into a payment provider. Browser closes after capture. Restore scripts require the existing local project runtime, not production.

scripts/readback-g3cr6.php records non-sensitive versions/capabilities/product/blocks and order count. scripts/workspace-regression-g3cr6.php exercises the unchanged PHP permission handler under in-memory synthetic identities, without producing credentials. This is handler regression, not new HTTP login/session evidence; guest HTTP denial is also independently tested in the browser.

No WP-admin screenshot: fresh headless context has no authorized administrator login; no credential was read/generated. Owner edit access evidence is role/capabilities + core block structure read-back.

## Retention / cleanup

Keep birthday-magazine-g3c runtime for Owner review, localhost 8189; no teardown, restart, tunnel, prune or infrastructure mutation. Ignored project-only browser tooling and rollback resources retained. Owner ZIPs and pre-existing deleted historical screenshots are excluded from this Gate's commit.
