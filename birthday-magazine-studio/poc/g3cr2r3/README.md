# G3CR2R3 Blocksy Wedding import and WooCommerce canary

This isolated local proof uses its own Compose project, port, volumes, and network. It mounts the already accepted G3A private-workspace plugin read-only and does not edit earlier gate evidence.

Run only this runtime from the repository root:

```powershell
docker compose -p birthday-magazine-g3cr2r3 -f birthday-magazine-studio/poc/g3cr2r3/compose.yaml up -d
node birthday-magazine-studio/poc/g3cr2r3/scripts/setup-runtime.cjs
npm install --prefix birthday-magazine-studio/poc/g3cr2r3/.tmp/test-runner playwright-core
# In wp-admin > Blocksy > Starter Sites, choose Wedding > Import > Gutenberg > Next > Next > Install.
node birthday-magazine-studio/poc/g3cr2r3/scripts/configure-woocommerce.cjs
node birthday-magazine-studio/poc/g3cr2r3/scripts/verify-canary.cjs
docker compose -p birthday-magazine-g3cr2r3 -f birthday-magazine-studio/poc/g3cr2r3/compose.yaml down --volumes --remove-orphans
```

WordPress is published on loopback at `http://127.0.0.1:8187`. Synthetic accounts only; do not add credentials to evidence.

`setup-runtime.cjs` generates one disposable local Administrator credential in the ignored `.tmp/local-admin.json`; use it only for the local importer, never copy it into Git or evidence. The importer was run through Blocksy's dashboard wizard with Gutenberg selected and only the three accepted Gutenberg dependencies. The verification script uses the host's installed Chrome through a temporary `playwright-core` test dependency. Remove the exact G3CR2R3 `.tmp/` directory after verification; retain only the sanitized reports and synthetic screenshots under `artifacts/`.
