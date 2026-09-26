# K6 Phase F — Public Sandbox Ingress Readiness + Change Plan

Gate:
`K6_PHASE_F_PUBLIC_SANDBOX_INGRESS_READINESS_AND_CHANGE_PLAN`

Authority:
- canonical GitHub `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_E_R1_PASS_F_PUBLIC_SANDBOX_INGRESS_READINESS.md`;
- latest accepted Evidence/Handoff;
- unique current Shared VPS Handoff.

## Goal

Freeze the exact minimal public-ingress changes needed for `https://minicraft.spikersun.com` without making any change yet.

This Gate is read-only only.

## Accepted carry-forward state

Do not rerun completed restore/migration work absent material drift:

- D-R6 private runtime/app validation PASS;
- Phase E-R1 serialized-safe URL migration PASS;
- exact old-origin residual counts = 0;
- MariaDB exact 52-table set;
- home/siteurl target;
- WordPress/WooCommerce/PPCP private runtime healthy;
- PayPal Sandbox YES / Live NO;
- no public ingress.

## Phase A — minimal fresh continuity

Verify:
- strict SSH and `ops@srv1970241`;
- WordPress running/restart stable;
- MariaDB healthy/restart stable;
- no host ports;
- home/siteurl exact target;
- both old-origin dry-run counts remain 0;
- no Mini Craft public ingress.

No write.

## Phase B — shared edge topology read-back

Identify current factual ingress:

- exact 80/443 owner;
- Caddy service/container name;
- current Caddy config source and bind/mount path;
- current Caddy network memberships;
- cloudflared service/container state and config source/path, if used;
- current shared Docker networks;
- Mini Craft WordPress network memberships;
- Mini Craft WordPress exact service/container name and usable network alias;
- whether shared edge can resolve/connect to Mini Craft privately;
- current unrelated public hosts/routes that must remain unchanged.

For private reachability, use only a bounded read-only request/probe from an already-running shared-edge context if possible. Do not add a route and do not mutate network membership.

If edge cannot currently reach the Mini Craft upstream without a network change:
record the required change but do not perform it.

## Phase C — current DNS/TLS state

Read-only inspect `minicraft.spikersun.com`.

Record:
- record exists YES/NO;
- record type;
- redacted/non-secret target;
- publicly resolvable YES/NO;
- HTTP reachability;
- HTTPS reachability;
- certificate/TLS state if reachable;
- whether current target matches expected shared ingress.

No DNS mutation.
No control-plane credential output.

## Phase D — exact minimal change set

Return a concrete plan, not generic options.

For each component:

### Caddy
- change required YES/NO;
- exact config object/file;
- exact hostname;
- exact upstream identity/port/network;
- syntax shape sufficient for Reviewer review, excluding secrets;
- validation after write;
- exact rollback.

### cloudflared
- change required YES/NO;
- exact config object/path if any;
- whether existing ingress already covers the hostname;
- validation;
- rollback.

### DNS
- change required YES/NO;
- exact record type/name/target/proxy state needed;
- validation;
- rollback.

### Docker network / Compose
- change required YES/NO;
- exact membership change if unavoidable;
- why current membership is insufficient;
- validation;
- rollback.

Prefer zero new network/Compose mutation if current accepted WordPress membership already enables shared-edge upstream access.

## Phase E — safety review

Prove:
- no unrelated route needs editing;
- no 80/443 ownership change;
- no firewall broadening;
- no second ingress stack;
- no public DB port;
- PayPal remains Sandbox;
- test product is not being enabled for commercial sale merely by ingress;
- rollback removes only Mini Craft ingress changes.

## Output

Success:
`PASS_CANDIDATE_K6_PHASE_F_PUBLIC_SANDBOX_INGRESS_READINESS_AND_CHANGE_PLAN`

Required markers:

```text
REMOTE_IDENTITY=
WORDPRESS_RUNTIME_CONTINUITY=
MARIADB_HEALTH=
HOME_SITEURL=
SERIALIZED_OLD_ORIGIN_A=
SERIALIZED_OLD_ORIGIN_B=
CURRENT_80_443_OWNER=
SHARED_CADDY_STATE=
SHARED_CADDY_CONFIG_SOURCE=
SHARED_CADDY_NETWORKS=
CLOUDFLARED_STATE=
CLOUDFLARED_CONFIG_SOURCE=
MINICRAFT_WORDPRESS_CONTAINER=
MINICRAFT_EDGE_NETWORK_MEMBERSHIP=
MINICRAFT_EDGE_UPSTREAM=
EDGE_TO_MINICRAFT_PRIVATE_REACHABILITY=
CURRENT_MINICRAFT_DNS_EXISTS=
CURRENT_MINICRAFT_DNS_TYPE=
CURRENT_MINICRAFT_DNS_TARGET=
CURRENT_MINICRAFT_HTTP_STATE=
CURRENT_MINICRAFT_HTTPS_STATE=
CADDY_CHANGE_REQUIRED=
CADDY_CHANGE_OBJECT=
CLOUDFLARED_CHANGE_REQUIRED=
CLOUDFLARED_CHANGE_OBJECT=
DNS_CHANGE_REQUIRED=
DNS_CHANGE_OBJECT=
DOCKER_NETWORK_CHANGE_REQUIRED=
COMPOSE_CHANGE_REQUIRED=
PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
UNRELATED_SERVICES_CHANGED=NO
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO
OWNER_CHECKPOINT_REQUIRED=YES
STOP_AT_REVIEWER=YES
```

## Forbidden

No:
- Caddy/cloudflared/DNS/UFW/firewall write;
- Docker network mutation;
- Compose mutation;
- container restart/recreate;
- public ingress;
- Provider webhook/API;
- PayPal Live/payment/refund;
- Secret value/hash output;
- unrelated project change.

Do not continue into the mutation Gate.
