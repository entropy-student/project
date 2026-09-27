# G3A local commerce and account-loop proof

This runtime is isolated under the Compose project `birthday-magazine-g3a`. It uses WordPress, MariaDB, Mailpit, and the WooCommerce core Check payments gateway. It has no payment provider or generation integration.

The existing Good Issue-style G2A1 preview plugin is mounted read-only from `../g2a1/preview-plugin`. The local-only workspace plugin stores the WooCommerce order ID and authenticated customer ID on the order and denies guests or other users. It does not implement photo intake, file delivery, a generation queue, or model calls.

`wordpress/.htaccess` supplies the standard WordPress rewrite block because the local WP-CLI deliberately does not rewrite Apache configuration files. It is mounted read-only into both WordPress containers.

Start from the repository root:

```powershell
docker compose -p birthday-magazine-g3a -f birthday-magazine-studio/poc/g3a/compose.yaml up -d
```

WordPress is published only at `http://127.0.0.1:8127`; Mailpit is published only at `http://127.0.0.1:8128`. The database and SMTP ports are not published to the host. The Compose volumes and network have fixed G3A-specific names.

## Local setup and verification

After starting Compose, run `node birthday-magazine-studio/poc/g3a/scripts/bootstrap-g3a.cjs`; it completes the local WordPress installer if needed. Download the official WooCommerce 11.1.2 ZIP temporarily to `birthday-magazine-studio/poc/g3a/.tmp/woocommerce.11.1.2.zip`:

```powershell
New-Item -ItemType Directory -Force birthday-magazine-studio/poc/g3a/.tmp | Out-Null
Invoke-WebRequest -Uri https://downloads.wordpress.org/plugin/woocommerce.11.1.2.zip -OutFile birthday-magazine-studio/poc/g3a/.tmp/woocommerce.11.1.2.zip
```

Then run:

```powershell
node birthday-magazine-studio/poc/g3a/scripts/configure-g3a.cjs
node birthday-magazine-studio/poc/g3a/scripts/verify-g3a.cjs
```

The configure step sets the store to local live visibility, disables avatars that would request Gravatar, writes `BMS_G3A_LOCAL_ONLY=true` and `BMS_G3A_GENERATION_ENABLED=false`, installs WooCommerce, and creates the synthetic product. It removes the temporary ZIP after installation. The browser verification reuses the single existing synthetic order on reruns.

Clean up only this project after the proof:

```powershell
docker compose -p birthday-magazine-g3a -f birthday-magazine-studio/poc/g3a/compose.yaml down --volumes --remove-orphans
```

Do not run a global Docker prune command.
