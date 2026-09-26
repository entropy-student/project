# Reviewer Decision — K6 Phase E-R1 PASS / Phase F Public Sandbox Ingress Readiness

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed result

```text
GATE=K6_PHASE_E_R1_IN_PLACE_WPCLI_PHAR_SERIALIZED_MIGRATION
EXECUTOR_RESULT=PASS_CANDIDATE_K6_PHASE_E_R1_IN_PLACE_WPCLI_PHAR_SERIALIZED_MIGRATION
EVIDENCE_COMMIT=4491c7a4de2dda38af917c778f4ca683e7090059
HANDOFF_COMMIT=53b91c6a33ce8e883ce6a6c75614714180825e13
```

Reviewer independently accepts the candidate as PASS.

## Accepted Phase E-R1 facts

```text
K6_PHASE_E_R1_IN_PLACE_WPCLI_PHAR_SERIALIZED_MIGRATION=PASS
WPCLI_IMAGE_IDENTITY=PASS_EXACT_AMD64_DIGEST
WPCLI_IMAGE_PULL=NOT_REQUIRED_CACHED
WPCLI_VERSION=2.12.0
WPCLI_EXECUTION_IDENTITY=www-data_33_33
WPCLI_PHAR_SHA512=PASS
OLD_ORIGIN_A_DRYRUN_COUNT=36
OLD_ORIGIN_B_DRYRUN_COUNT=30
OLD_ORIGIN_A_REPLACED=36
OLD_ORIGIN_B_REPLACED=30
POST_MIGRATION_OLD_ORIGIN_A=0
POST_MIGRATION_OLD_ORIGIN_B=0
PRE_MIGRATION_BACKUP=PASS_LOCAL_VPS_ONLY
PRE_MIGRATION_BACKUP_BYTES=5199823
PRE_MIGRATION_BACKUP_SHA256=3ae2ca76a81c338d44cdc82dfe1624f639ef0c4c1809ca7f1f17a87dd1cd49aa
GUID_MUTATIONS=0
MARIADB_TABLE_SET=UNCHANGED_52
HOME_SITEURL=PASS_TARGET
WORDPRESS_BOOTSTRAP=PASS
WORDPRESS_PRIVATE_ROUTES=PASS
WP_CONTENT_MEDIA_STATE=PASS
WOOCOMMERCE_CORE_STATE=PASS
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO
WORDPRESS_RECENT_FATALS=0
WORDPRESS_RESTART_COUNT=STABLE_0
WORDPRESS_HOST_PORT=NONE
DB_PUBLIC_PORT=NONE
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
TEMP_HELPERS_CLEANED=PASS
```

Dry-run counts matched actual replacement counts exactly. Both exact historical origins now return zero non-GUID replacements. The table-set digest remained unchanged and GUIDs were excluded from migration.

The fresh pre-migration backup remains on the VPS under the project backup namespace and is not committed to GitHub.

## Formal closure

```text
K6_PRIVATE_RUNTIME_RESTORE=PASS
K6_PRIVATE_APP_VALIDATION=PASS
K6_SERIALIZED_SAFE_URL_MIGRATION=PASS
PRIVATE_DATABASE_STATE_READY_FOR_PUBLIC_SANDBOX_INGRESS=YES
PUBLIC_INGRESS=NOT_YET_ENABLED
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO
REAL_PAYMENT=NO
```

## Current Gate

```text
CURRENT_GATE=K6_PHASE_F_PUBLIC_SANDBOX_INGRESS_READINESS_AND_CHANGE_PLAN
OWNER_ACTION=NONE
```

Phase F is **read-only only**. It does not authorize Caddy, cloudflared, DNS, firewall, network, Compose, or application mutation.

Its purpose is to freeze the exact minimal public-ingress change set and rollback before any Shared Infra / material production enablement.

## Phase F objectives

### A. Fresh target-host continuity

Verify:
- canonical strict SSH / `ops@srv1970241`;
- WordPress and MariaDB remain healthy;
- restart counts stable;
- no WordPress/DB host ports;
- home/siteurl remain target;
- serialized old-origin dry-runs remain zero;
- no public Mini Craft ingress exists yet.

Material drift -> RETURN.

### B. Shared ingress topology read-back

Read only the current live Shared VPS topology and authoritative config sources:

- current owner of 80/443;
- exact shared Caddy container/service and current config source/path;
- current cloudflared container/service and config source/path, if present;
- current Docker networks and Mini Craft WordPress membership;
- exact Mini Craft WordPress service/container name and network alias reachable from the shared edge;
- current Caddy-to-upstream reachability on the shared network without adding a route;
- current unrelated routes/hosts that must remain unchanged.

Do not print credentials/tokens/cert private material.

### C. DNS/TLS public-state read-back

Read-only determine current public state of:

`minicraft.spikersun.com`

Record:
- current DNS record existence/type/target if publicly observable;
- whether Cloudflare proxy/tunnel ownership can be inferred safely;
- current HTTP/HTTPS reachability status;
- current TLS state if any;
- whether public DNS/route is absent, stale, or already pointed somewhere.

No DNS mutation.

### D. Exact change plan

Produce one minimal plan for the current factual topology.

The plan must state exactly:
- whether Caddy config needs one new site/host route;
- exact non-secret upstream identity/port/network target;
- whether cloudflared config needs a route change or no change;
- whether DNS needs a record/route change or no change;
- whether any existing shared network membership already satisfies ingress;
- exact files/config objects that would be touched;
- exact validation after write;
- exact rollback for each touched shared item;
- proof that unrelated routes/containers remain unchanged.

Do not execute the plan in Phase F.

### E. Owner checkpoint classification

Because public ingress is material production enablement and may mutate Shared Infrastructure, Phase F must end with one of:

```text
PUBLIC_INGRESS_CHANGESET=READY
OWNER_CHECKPOINT_REQUIRED=YES
```

or a precise `RETURN_REVIEWER_*` if the topology/change set is unresolved.

Do not interpret prior private-deployment authorization as automatic permission to mutate Shared Infra in this read-only Gate.

## Hard boundaries

No:
- Caddy write/reload;
- cloudflared write/restart;
- DNS write;
- UFW/firewall write;
- Docker network mutation;
- Compose mutation;
- container restart/recreate;
- public route enablement;
- Provider webhook/API mutation;
- PayPal Live/payment/refund;
- Secret value/hash output;
- unrelated project mutation.

## Success contract

```text
PASS_CANDIDATE_K6_PHASE_F_PUBLIC_SANDBOX_INGRESS_READINESS_AND_CHANGE_PLAN
REMOTE_IDENTITY=ops@srv1970241
WORDPRESS_RUNTIME_CONTINUITY=PASS
MARIADB_HEALTH=PASS
HOME_SITEURL=PASS_TARGET
SERIALIZED_OLD_ORIGIN_A=0
SERIALIZED_OLD_ORIGIN_B=0
CURRENT_80_443_OWNER=
SHARED_CADDY_STATE=
SHARED_CADDY_CONFIG_SOURCE=
CLOUDFLARED_STATE=
CLOUDFLARED_CONFIG_SOURCE=
MINICRAFT_EDGE_NETWORK_MEMBERSHIP=
MINICRAFT_EDGE_UPSTREAM=
EDGE_TO_MINICRAFT_PRIVATE_REACHABILITY=
CURRENT_MINICRAFT_DNS_STATE=
CURRENT_MINICRAFT_HTTPS_STATE=
PUBLIC_INGRESS_CHANGESET=READY
CADDY_CHANGE_REQUIRED=
CLOUDFLARED_CHANGE_REQUIRED=
DNS_CHANGE_REQUIRED=
ROLLBACK_PLAN=PASS
UNRELATED_SERVICES_CHANGED=NO
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO
OWNER_CHECKPOINT_REQUIRED=YES
STOP_AT_REVIEWER=YES
```

A PASS_CANDIDATE authorizes no ingress mutation. Reviewer will inspect the plan and present the exact bounded Owner checkpoint before any public Sandbox route is enabled.
