# G3C Blocksy Wedding productization

This is the retained local Owner-review runtime for G3C. It uses a dedicated Compose project, loopback-only ports, project-specific volumes/network, and no payment or AI provider. Keep the runtime running through Owner visual review.

From the repository root:

```powershell
docker compose -p birthday-magazine-g3c -f birthday-magazine-studio/poc/g3c/compose.yaml up -d
node birthday-magazine-studio/poc/g3c/scripts/setup-runtime.cjs
# Import Blocksy Wedding in wp-admin with the Gutenberg variant.
$compose = 'birthday-magazine-studio/poc/g3c/compose.yaml'
docker compose -p birthday-magazine-g3c -f $compose cp birthday-magazine-studio/poc/g3c/scripts/productize-home.php wpcli:/tmp/productize-home.php
docker compose -p birthday-magazine-g3c -f $compose exec -T wpcli wp eval-file /tmp/productize-home.php
docker compose -p birthday-magazine-g3c -f $compose cp birthday-magazine-studio/poc/g3c/scripts/configure-commerce-pages.php wpcli:/tmp/configure-commerce-pages.php
docker compose -p birthday-magazine-g3c -f $compose exec -T wpcli wp eval-file /tmp/configure-commerce-pages.php
```

Local site: http://127.0.0.1:8189/
WordPress admin: http://127.0.0.1:8189/wp-admin/
Mailpit: http://127.0.0.1:8190/

The one-time setup password is generated into ignored `.tmp/local-owner-admin.json`; do not commit or share it. To set an Owner-chosen password locally, run:

```powershell
docker compose -p birthday-magazine-g3c -f birthday-magazine-studio/poc/g3c/compose.yaml exec -T wpcli wp user update bms-owner --user_pass='REPLACE_WITH_A_PASSWORD_YOU_CHOOSE'
```

There is deliberately no teardown command here because the runtime must remain available at the Owner checkpoint. Do not run global Docker cleanup.
