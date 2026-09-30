# G3CR2 Blocksy Wedding WooCommerce canary

## Current result

`RETURN_PREFLIGHT_DRIFT`: the Docker CLI is installed, but the Docker Engine named pipe is unavailable. This run stopped before Compose startup, package download, Blocksy installation, or catalog access. The official Wedding/Gutenberg availability and dependencies remain unknown.

No Docker Desktop/service start was attempted because the local Docker daemon is shared with other project resources and the Gate forbids shared-infrastructure mutation. No G3CR2 Compose resources were created. Container/volume/network counts are unobservable while the Engine is down; see `artifacts/reports/preflight.json`.

## Intended isolated runtime (not started)

The assigned canary ports are `127.0.0.1:8167` (WordPress) and `127.0.0.1:8168` (Mailpit), with a project-named MariaDB volume/network under `birthday-magazine-g3cr2`. The ports had no local listener during preflight. The runtime is not present yet.

G3A and G3B historical sources were not edited. No Blocksy/Companion/WooCommerce package was downloaded or installed, no starter import was attempted, no product/order/workspace was created, and no screenshot is claimed.

Retry requires a fresh G3CR2 execution after Docker Engine availability is established and the Reviewer reopens or continues this Gate. Do not treat this RETURN as permission to start shared Docker infrastructure or to use an alternate starter/builder.
