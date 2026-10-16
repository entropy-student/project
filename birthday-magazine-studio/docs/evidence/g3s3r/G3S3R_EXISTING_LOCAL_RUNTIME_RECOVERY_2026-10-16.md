# G3S3R — Existing Local Runtime Recovery and Source Reconciliation

Date: 2026-10-16  
Gate: `G3S3R_EXISTING_LOCAL_RUNTIME_RECOVERY_20261016`  
Decision: `PASS_CANDIDATE_G3S3R`; **STOP_AT_REVIEWER=YES**.  
PR: #64, branch `codex/birthday-magazine-g3c-blocksy-wedding-productization`; remains Open and unmerged. This is the single consolidated evidence submission for this Gate.

## Authorization and scope

Owner authorization is recorded in `docs/OWNER_AUTHORIZATION_G3S3R_EXISTING_G3C_CONTAINER_START_2026-10-16.md` (blob `0b562071dd309c5427320b42244fe396e85aabb3`). It authorized one conditional start of only the existing G3C MariaDB, WordPress and WP-CLI containers after a safe read-only preflight.

Execution used the actual Windows 11 local Docker Desktop host and Docker context `desktop-linux`; no SSH, VPS, remote server or browser was used. No Compose up/down/recreate, new container, image pull/build, database import/restore, source edit, WordPress migration, plugin install/activation/configuration, checkout, payment, refund, Stripe account change, PayPal change or PR merge occurred.

## Preflight and protected state

- Host snapshot: Windows 11 build 26300; PowerShell 7.6.5; Docker Engine/client 29.7.2. Free host memory was approximately 3.2 GiB and C: had approximately 186.7 GiB free.
- Compose project: `birthday-magazine-g3c`; existing bridge network: `birthday-magazine-g3c_private`. Only WordPress publishes a port, loopback-only at `127.0.0.1:8189->80`; MariaDB and WP-CLI publish none.
- Existing containers and mounts:

| Service | Existing container ID | Image | Existing volume/mount | Result |
|---|---|---|---|---|
| MariaDB | `361d58eb545432b915badbab118aaeb8bf2d4b591d1b5bd753fb7393383579aa` | `mariadb:11.4.7` | `birthday-magazine-g3c_database:/var/lib/mysql` | Started once; native exit 0; `running/healthy` |
| WordPress | `21892d72baebe6157fbeab15ad6a1e3949cf4663ca55b45360c3f4eb1f052f00` | `wordpress:7.1.1-php8.3-apache` | `birthday-magazine-g3c_wordpress:/var/www/html` | Started once; native exit 0; running; loopback port unchanged |
| WP-CLI | `de9742647e062fddd40b9d7e310be52db57281e89cbba3fd6f39530a28759873` | `wordpress:cli-php8.3` | Existing WordPress volume and source mounts | Started once after local HTTP 200; native exit 0; running; no published port |
| Mailpit | `35d286e7af500c5282a6ad6b8007a23ea177ff57f3a965effe39f2b63c0a0438` | Existing project image | Existing configuration | Left stopped |

DB and WP-CLI had prior exit code 137 with `OOMKilled=false`; the historical cause remains UNKNOWN. MariaDB startup reported one ready marker, two internal crash-recovery markers, zero InnoDB error markers and zero fatal markers. Automatic recovery may alter internal DB state and is not bytewise reversible; no restore/import or SQL command was run.

Backup metadata only was checked; private contents were not opened. `wordpress-db-consistent.sql` exists (9,802,953 bytes; 2026-10-15 13:31:28 UTC), as do `wordpress-root.tar.gz` (126,003,006 bytes), `mounted-source-bindings.tar.gz` (23,740,653 bytes) and `private-backup-manifest.json` (2,269 bytes). Two temporary ZIPs (1,568,686 and 1,566,008 bytes) were left untouched. The backup predates this runtime start and is not claimed as a fresh Test-write rollback.

## Source reconciliation

- Existing checkout branch: `codex/birthday-magazine-g3c-blocksy-wedding-productization`; local HEAD recorded as `f50cc974ead65c9811f952cdf0a327c548f14efc`. At preflight the PR source baseline was `2eb033658ad0ed04dacfe3a0f2b26101ab4697e3`; the local checkout was 46 commits behind.
- Existing dirty state was preserved: three modified source files, 17 deleted historical screenshots and 13 untracked items. No reset, clean, stash, checkout, rebase or local file restoration occurred.
- Compose configuration and the runtime-relevant preview PHP/CSS, commerce-loop PHP and local support asset hashes were compared with PR #64 and matched. The screenshot deletions are non-runtime. G3S3R made no source or local worktree changes.
- The private workspace source binds order and owner metadata and requires the signed-in user to match the order customer; an order/owner mismatch returns HTTP 403. Runtime source remained on the existing mounts.

## Runtime diagnosis and read-only results

The first default host-side curl probe returned exit 1 / HTTP 000. Diagnosis found `HTTP_PROXY` in the PowerShell process environment and no loopback entry in `NO_PROXY`. Using the same loopback URL with `curl.exe --noproxy 127.0.0.1` returned exit 0 / HTTP 200. Apache syntax was `Syntax OK`; the existing container and loopback binding were healthy. This confirms the empty response was caused by the local proxy route, not a WordPress/Apache failure. Proxy values were not inspected or recorded, and no global proxy setting was changed.

Fresh WP-CLI reads completed without printing secrets or customer identifiers:

- WordPress **7.1.1**; home and site URL are both `http://127.0.0.1:8189`.
- WooCommerce **11.1.2 active**; official WooCommerce Stripe **11.1.0 inactive**. Stripe was not registered as an available gateway. Gateway flags: `bacs=no`, `cheque=yes`, `cod=no`.
- Product **#1113**: published, virtual, **USD 39.99**.
- Woo order count: **1**. The sampled existing order had a positive customer ID; its workspace order and owner metadata matched the order and customer. Identifiers, emails and other customer data were not output.

No checkout, order mutation, webhook, payment, refund, Stripe activation or PayPal operation occurred.

## Final Reviewer packet

- **Result:** `PASS_CANDIDATE_G3S3R`; runtime is locally reachable when loopback bypasses the HTTP proxy. Stripe remains inactive; no payment was tested.
- **Change:** only this single consolidated Evidence file is submitted for G3S3R. Existing application files, local dirty worktree, original volumes and backup were not edited or removed.
- **Limit:** this Gate does not authorize a Stripe Test-mode integration or claim payment readiness. The prior exit-137 cause remains UNKNOWN; DB startup recovery is recorded above.
- **Reviewer action:** accept or return this candidate. `STOP_AT_REVIEWER=YES`; PR #64 stays open/unmerged. No next Gate was started.
- No secrets, environment proxy values, DB rows, backup contents, customer data or unredacted local profile path are included.
