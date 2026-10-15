# G3S1SVE — Retained Executor Evidence Recovery

> Date: 2026-10-15  
> Result: PASS_CANDIDATE_G3S1SVE_EVIDENCE_PERSISTED; core G3S1SV acceptance remains for Reviewer  
> Provenance: summarized from native results already retained in the existing Codex conversation; no local host command was run for this evidence-only Gate.  
> Scope: Owner-local Windows 11 / Docker Desktop context `desktop-linux`, Compose project `birthday-magazine-g3c`. No VPS or SSH.

## Database backup and isolated restore

- Source was the existing `wordpress-db-consistent.sql` at `%LOCALAPPDATA%\BirthdayMagazineStudio\G3S1S\20261015T213127-f1ccf9a1\wordpress-db-consistent.sql`, 9,802,953 bytes. The private manifest comparison reported matching artifact sizes and SHA-256 values for the SQL, WordPress archive, and mounted-source archive. No private digest or SQL content is published. The comparison's native process exit code was not retained.
- The backup directory ACL was reported protected. Existing G3S1S evidence records successful isolated extraction of the WordPress and mounted-source archives.
- The scratch database used image `mariadb:11.4.7`, Docker network `none`, and a temporary `/var/lib/mysql` tmpfs. Its creation did not specify bind mounts, named volumes, or published ports. The backup copy into the scratch container exited 0 and matched the source byte length.
- The retained native import exit code was **0**. The server reported `11.4.7-MariaDB-ubu2404`; the table inventory query exited 0 and found **58 expected / 58 actual**, with no missing or extra tables. A non-secret server-side version and information_schema read succeeded; no row values were emitted.
- The scratch container was removed with `docker rm --force` (exit 0) and was absent after cleanup. Its generated container name and container ID were not retained: **UNKNOWN_NOT_RETAINED**. The creation/import/query/removal operations used the same generated container-name variable, but the identifier cannot be correlated from the retained output.
- The live database and WordPress container identities matched the prior G3S1S baseline. The original database volume remained `birthday-magazine-g3c_database -> /var/lib/mysql`; the WordPress volume remained `birthday-magazine-g3c_wordpress -> /var/www/html`.

## Pre-install recovery point and freshness

- The protected G3S1S backup and manifest remained present before staging. Its recorded SQL timestamp was 2026-10-15 21:31:28 +08:00; installation occurred later that evening (exact installation time not retained).
- Immediately before and after plugin installation, read-only checks returned 58 database tables and 1,311 aggregate rows. WooCommerce order count stayed 1. Product 1113 remained virtual, USD 39.99. These checks support unchanged aggregate state, but a record-level or per-table comparison between the snapshot and live database was not retained: **UNKNOWN_NOT_RETAINED**.
- Therefore a protected rollback point exists and the aggregate readbacks were stable; record-level backup freshness is left for Reviewer assessment.

## Official Stripe package and inactive installation

- Package source was the official WordPress.org download URL: `https://downloads.wordpress.org/plugin/woocommerce-gateway-stripe.11.1.0.zip`. The native download exited 0 and produced 1,568,686 bytes.
- The archive header identified **WooCommerce Stripe Gateway 11.1.0**, authored by Stripe; it requires WordPress 6.9+, WooCommerce 11.0+, and the WooCommerce plugin, and reports testing through WordPress 7.1 / WooCommerce 11.2. The readme states PHP 7.4+. The local versions were WordPress 7.1.1, WooCommerce 11.1.2, and PHP 8.3.33.
- A SHA-256 was computed for the downloaded archive; the copy in the WP-CLI container matched it (copy exit 0; container `sha256sum` exit 0). The digest is intentionally omitted. An independent WordPress.org checksum value was not retained: **UNKNOWN_NOT_RETAINED**.
- WP-CLI installed the local archive with native exit code **0** and without an activation flag. Post-install inventory exited 0 and reported version 11.1.0, status **inactive**. The Stripe gateway ID list and Stripe option-name query were both empty.
- Post-install checks exited 0: site GET returned HTTP 200; database aggregate remained 58 tables / 1,311 rows; order count remained 1; product 1113 remained virtual at USD 39.99; legacy PayPal `enabled=no`. Original database and WordPress container IDs still matched the baseline. No account connection, provider call, checkout, payment, refund, or PayPal mutation was performed.

## Temporary package files and denied cleanup

- The verified host package was staged at `%TEMP%\bms-wc-stripe-11.1.0-package.zip` and copied to `birthday-magazine-g3c-wpcli-1:/tmp/bms-wc-stripe-11.1.0-package.zip`. Both locations remain uncleaned.
- A prior incomplete download remained at `%TEMP%\bms-wc-stripe-11.1.0-4aa2efb3e8644bd785e47b73f9b49f5a.zip`; its last observed size was 1,566,008 bytes. Its current state was not re-read in this Gate.
- The cleanup request for those exact temporary files was rejected before PowerShell process startup with `CreateProcess ... Rejected(... blocked by policy)`. No cleanup process started, so there is no native exit code. No alternate shell, API, GUI, or execution route was tried. This evidence-only Gate performed no local mutation and did not retry cleanup.

## Reviewer handoff

- PR #64 was open and unmerged on branch `codex/birthday-magazine-g3c-blocksy-wedding-productization` before this evidence commit. Its pre-write head was `d13b27fd8290d0575bd3ac7733f3f3039b415a21`; main readback was `a132d41f14af9ddb947a39a3ec9e5352ddde9928`.
- This document records available executor observations only. The scratch container identifier, record-level backup freshness comparison, independent official package checksum, and private manifest check process exit remain explicitly unknown.
- `TEMP_PACKAGES_UNCLEANED=YES`; `LOCAL_HOST_MUTATIONS_THIS_GATE=0`; `STOP_AT_REVIEWER=YES`. Inactive plugin staging is not payment readiness and is not a formal G3S1SV Reviewer PASS.
