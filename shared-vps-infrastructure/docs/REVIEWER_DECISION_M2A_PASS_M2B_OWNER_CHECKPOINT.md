# Reviewer Decision — M2A Formal PASS / M2B Temporary Tunnel Canary Owner Checkpoint

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewed:

- Evidence commit `ba9a601a440554a334d94b4e27e0c99d1dbd5b63`
- Executor Handoff commit `a7e8de2e38ed51f9aa6a022bc31a4b3296684a7d`

The R7 PASS_CANDIDATE is accepted.

## Formal M2A result

```text
M2A_MINICRAFT_PRIVATE_NETWORK_PREPARATION=PASS
EXECUTION_GATE=M2A_R7_EXPLICIT_NONSECRET_COMPOSE_ENV_AND_CONDITIONAL_EXECUTION
TARGET_HOST=srv1970241

PREWRITE_COMPOSE_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
POSTWRITE_COMPOSE_SHA256=25931b1de6ee1814e012a246355c315b20f242649e2f658b3322b956f215e869
ROLLBACK_BACKUP=/srv/backups/mini-craft-night-kit/manifests/m2a-pre-private-network-20260929T111649Z.compose.bak

WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge+spikersun-private
WORDPRESS_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
TARGET_ALIAS_MATCHING_ENDPOINT_COUNT=1
WORDPRESS_RESTART_COUNT=0
PRIVATE_ORIGIN_HTTP=200

MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_HEALTH=healthy
MARIADB_PRIVATE_ENDPOINT=ABSENT

PUBLIC_HOME_HTTP=200
PUBLIC_SHOP_HTTP=200
PUBLIC_WP_REST_HTTP=200
CURRENT_PUBLIC_INGRESS=DNS_A_TO_CADDY
```

Mutation review:

```text
CANONICAL_COMPOSE_WRITE=1
WORDPRESS_ONLY_RECREATE=1
NEW_BACKUP_CREATED=0
SHARED_NETWORK_DEFINITION_MUTATION=0
MARIADB_MUTATIONS=0
CADDY_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_READ_OR_EMITTED=0
M2B_ENTERED=NO
```

M2A is formally closed.

## Architecture after M2A

```text
Internet
  -> current production path: Cloudflare DNS A -> VPS 80/443 -> shared Caddy -> WordPress

Future tested path:
Cloudflare Tunnel spikersun-shared-private
  -> spikersun-private
  -> http://mini-craft-night-kit-wordpress:80
  -> WordPress
```

The existing Mini Craft Caddy route remains the production and rollback path.

## Next Gate — M2B Owner checkpoint

The next bounded step is a temporary-host Tunnel canary. It requires Cloudflare control-plane mutation and therefore is not authorized by this PASS alone.

```text
CURRENT_GATE=M2B_TEMPORARY_TUNNEL_CANARY_OWNER_CHECKPOINT
CURRENT_GATE_STATUS=OWNER_CONFIRMATION_REQUIRED
CLOUDFLARE_MUTATION_AUTHORIZED=NO
DNS_MUTATION_AUTHORIZED=NO
TUNNEL_PUBLIC_HOSTNAME_MUTATION_AUTHORIZED=NO
```

Intended M2B shape after explicit Owner authorization:

- use a fresh, currently absent temporary hostname only;
- keep `minicraft.spikersun.com` production DNS/Caddy path untouched;
- route the temporary hostname through existing Tunnel `spikersun-shared-private`;
- origin service: `http://mini-craft-night-kit-wordpress:80`;
- explicitly set/verify origin HTTP Host header as `minicraft.spikersun.com`;
- validate TLS/public HTTP/application behavior through the temporary hostname;
- do not treat temporary-host cookie/session behavior as proof of canonical-host session continuity;
- on canary failure, remove only the temporary hostname/Tunnel route created by M2B;
- do not start M2C production hostname cutover.

No M2B mutation may occur until the Owner explicitly confirms the checkpoint.
