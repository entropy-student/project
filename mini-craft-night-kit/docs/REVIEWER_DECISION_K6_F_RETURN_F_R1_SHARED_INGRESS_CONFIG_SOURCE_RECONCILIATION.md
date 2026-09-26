# Reviewer Decision — K6 Phase F RETURN Accepted / F-R1 Shared Ingress Config Source Reconciliation

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Reviewed result

GATE=K6_PHASE_F_PUBLIC_SANDBOX_INGRESS_READINESS_AND_CHANGE_PLAN
RESULT=RETURN_REVIEWER_SHARED_INGRESS_CONFIG_DRIFT
EVIDENCE_COMMIT=fc323085f134fee4263c1edf4261ea9ffb91bcea
HANDOFF_COMMIT=ba7c845b2bd7c4527e45e48e5e950ba2d73e9eb0

Reviewer accepts the RETURN as correct and fail-closed.

## Accepted Phase F facts

REMOTE_IDENTITY=ops@srv1970241
WORDPRESS_RUNTIME_CONTINUITY=PASS
MARIADB_HEALTH=PASS
HOME_SITEURL=PASS_TARGET
SERIALIZED_OLD_ORIGIN_A=0
SERIALIZED_OLD_ORIGIN_B=0
WORDPRESS_HOST_PORT=NONE
DB_PUBLIC_PORT=NONE
CURRENT_MINICRAFT_PUBLIC_INGRESS=NONE
CURRENT_80_443_OWNER=spikersun-edge-caddy-1
SHARED_CADDY_VERSION=v2.11.4
SHARED_CADDY_CONFIG_SOURCE=/srv/infra/edge/Caddyfile
ACTIVE_CADDY_HOST_ROUTES=edge-test.spikersun.com;localhost
CADDYFILE_HOST_ROUTES=localhost
CLOUDFLARED=RUNNING_REMOTE_MANAGED_NO_LOCAL_CONFIG
MINICRAFT_EDGE_NETWORK_MEMBERSHIP=YES
MINICRAFT_EDGE_UPSTREAM=wordpress:80
EDGE_TO_MINICRAFT_PRIVATE_REACHABILITY=PASS_HTTP_200
CURRENT_MINICRAFT_DNS=NXDOMAIN
DOCKER_NETWORK_CHANGE_REQUIRED=NO
COMPOSE_CHANGE_REQUIRED=NO
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO

Active Caddy has an unrelated edge-test.spikersun.com route that is absent from the startup Caddyfile. Reloading the current Caddyfile could remove accepted unrelated behavior.

## Reviewer interpretation

Caddy's Admin API persists the latest active configuration to disk by default unless persistence is disabled, while run --resume explicitly resumes the autosaved config. F-R1 must therefore reconcile the startup source, active Admin API config, and autosaved config before any Shared Infra mutation.

## Product 223 classification

Product 223 is published, catalog-visible and purchasable test/canary data.
It does not block the bounded Sandbox Canary by itself because PayPal remains Sandbox, Live is disabled, real payment is forbidden, and K6 defines first exposure as an infrastructure canary rather than commercial launch.
It continues to block Soft Launch / real public sales until product truth is replaced or explicitly approved.
F-R1 must read current search-indexing/noindex state. If broad indexing is enabled, the later ingress-write Gate must apply launch-safe noindex before DNS/public exposure.

## Initial Sandbox DNS policy

DNS_RECORD_TYPE=A
DNS_NAME=minicraft
DNS_TARGET=2.24.193.133
CLOUDFLARE_PROXY=DNS_ONLY_INITIAL_CANARY

This policy minimizes moving parts for the initial Caddy/TLS canary. Proxy enablement can be reviewed after the Sandbox canary passes.
No DNS write is authorized in F-R1.

## Current Gate

CURRENT_GATE=K6_PHASE_F_R1_SHARED_INGRESS_CONFIG_SOURCE_RECONCILIATION
OWNER_ACTION=NONE

F-R1 is read-only only.

## Phase A — continuity

Verify strict SSH / ops@srv1970241, Caddy/WordPress/MariaDB continuity, no current Mini Craft public ingress, edge-to-wordpress:80 reachability, and current Mini Craft DNS still absent.
Material drift -> RETURN.

## Phase B — identify Caddy persistence model

Read-only determine:
1. exact Caddy Entrypoint/Cmd and whether startup uses --config, --resume, or another mode;
2. non-secret HOME / XDG_CONFIG_HOME facts relevant to config directory;
3. whether persist_config off is present;
4. actual autosave.json path;
5. autosave exists/bytes/mtime/SHA-256;
6. normalized current Admin API config SHA-256.

Do not output TLS private keys, credentials, certificate material or unrelated Secret values.

## Phase C — active vs autosave reconciliation

Read active Admin API config and autosave JSON in memory. Filter to non-secret HTTP routing semantics.
Prove whether autosave represents the current active HTTP routes.

Freeze existing-route semantics for localhost and edge-test.spikersun.com.
For edge-test record host matcher, handler type, status, response headers if any, body length and body SHA-256. Exact body may be retained only in process memory for candidate reconstruction and must not be committed if unnecessary.

If active behavior cannot be reconstructed safely, return RETURN_REVIEWER_F_R1_CADDY_ACTIVE_CONFIG_NOT_RECOVERABLE.

## Phase D — candidate durable Caddyfile, in memory only

Construct one candidate preserving current localhost behavior and edge-test behavior exactly, then add:
minicraft.spikersun.com { reverse_proxy wordpress:80 }

Do not write /srv/infra/edge/Caddyfile and do not reload Caddy.
Use caddy adapt or POST /adapt as a no-load/no-write parser.
Require native success, existing-route semantic parity, Mini Craft upstream exactly wordpress:80, and no unrelated route loss.
Record candidate bytes + SHA-256.

## Phase E — freeze future mutation / rollback

Plan only:
1. re-read active config immediately before mutation and prove edge-test fingerprint unchanged;
2. preserve the current shared Caddyfile under the shared-infra backup convention;
3. atomically install only the validated candidate;
4. adapt/validate before reload;
5. use zero-downtime caddy reload, never restart;
6. verify localhost and edge-test unchanged;
7. verify Host-header Mini Craft route to wordpress:80;
8. only after Caddy PASS, create DNS-only A minicraft.spikersun.com -> 2.24.193.133;
9. validate DNS/TLS/public routes;
10. rollback DNS then Mini Craft Caddy addition on failure while preserving edge-test.

F-R1 does not execute this plan.

## Phase F — indexing / canary exposure state

Read WordPress search-engine visibility / blog_public and any current noindex behavior.
Return LAUNCH_SAFE_NOINDEX or INDEXABLE_REQUIRES_PRE_INGRESS_NOINDEX_WRITE.
No product or indexing mutation in F-R1.

## Hard boundaries

No Caddyfile write/reload/restart, autosave modification, cloudflared modification, DNS write, Docker network/Compose write, product/indexing mutation, firewall change, public ingress, provider webhook/API action, PayPal Live/payment/refund, Secret value/hash output, or unrelated project mutation.

## Success contract

PASS_CANDIDATE_K6_PHASE_F_R1_SHARED_INGRESS_CONFIG_SOURCE_RECONCILIATION
CADDY_START_MODE=
CADDY_PERSIST_CONFIG=
CADDY_AUTOSAVE_PATH=
CADDY_AUTOSAVE_EXISTS=
CADDY_AUTOSAVE_SHA256=
CADDY_ACTIVE_CONFIG_SHA256=
AUTOSAVE_MATCHES_ACTIVE_HTTP_ROUTES=
LOCALHOST_ROUTE_PRESERVED=PASS
EDGE_TEST_ROUTE_RECOVERABLE=PASS
EDGE_TEST_ROUTE_FINGERPRINT=
MINICRAFT_EDGE_UPSTREAM=wordpress:80
EDGE_TO_MINICRAFT_PRIVATE_REACHABILITY=PASS
CANDIDATE_CADDYFILE_ADAPT=PASS
CANDIDATE_CADDYFILE_SHA256=
CANDIDATE_EXISTING_ROUTE_PARITY=PASS
CANDIDATE_MINICRAFT_ROUTE=PASS
DNS_CANARY_POLICY=A_DNS_ONLY_TO_2.24.193.133
CURRENT_MINICRAFT_DNS=NXDOMAIN
CANARY_INDEXING_STATE=
PRODUCT_223_CLASSIFICATION=SANDBOX_CANARY_ONLY_BLOCKS_SOFT_LAUNCH
PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
OWNER_CHECKPOINT_REQUIRED=YES
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO
STOP_AT_REVIEWER=YES

A PASS_CANDIDATE authorizes no Shared Infra or DNS mutation.