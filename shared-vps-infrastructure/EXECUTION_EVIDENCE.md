# Shared VPS Infrastructure — EXECUTION EVIDENCE

## Gate

```text
GATE=M1_MINICRAFT_TUNNEL_ARCHITECTURE_READONLY_CONFIRMATION
DATE=2026-09-29
CANONICAL_PROJECT_BASELINE_COMMIT=6e1dd8e6fd9a6a6923589bc9500dd050399a47b4
RESULT=RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
STOP_AT_REVIEWER=YES
```

## Sources read from GitHub main

- Canonical VPS Project Governance: `GOVERNANCE_HANDOFF.md`, `SKILL.md`, README files, metadata, v0.1.6 core, Governance Source Policy rev1, Storage Layout Contract rev1, SSH / Delegated Secret Operations rev2, Target Host Reality Contract rev2, Production Provider Canary and Recovery Contract rev2, Project Closeout and Workstation Hygiene Contract rev1, usage scenarios, all five templates, and the retained closeout candidate proposal.
- Shared VPS: current `REVIEWER_HANDOFF.md`, `SHARED_VPS_PORTFOLIO.md`, M1 Reviewer Decision, and M1 execution packet.
- Affected project facts: Mini Craft `REVIEWER_HANDOFF.md`, `PROJECT_STORAGE_MANIFEST.md`, accepted K6/K7 decision, Dujiao-Next `REVIEWER_HANDOFF.md`, and Unified Pay `REVIEWER_HANDOFF.md`.
- `shared-vps-infrastructure/SHARED_VPS_HANDOFF.md` returned GitHub 404; no such file was available at that path.

## Phase A — target-host continuity

```text
HOSTINGER_WEB_TERMINAL_TAB_VISIBLE=YES
TARGET_HOST_COMMAND_EXECUTED=NO
TARGET_HOST_IDENTITY=UNPROVEN
TARGET_HOST_EXECUTION_PROVEN=NO
RETURN=RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
```

The authenticated Hostinger Web Terminal tab was discoverable, but the available browser-control surface exposed tab selection and page readback only; no supported terminal-input action was available. No terminal command was sent. No SSH attempt was made.

## Scope / mutation counters

```text
DNS_MUTATIONS=0
TUNNEL_MUTATIONS=0
CADDY_MUTATIONS=0
DOCKER_NETWORK_MUTATIONS=0
COMPOSE_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_CONTENT_READS=0
CLEANUP_ACTIONS=0
VPS_MUTATIONS=0
PROJECT_RUNTIME_MUTATIONS=0
```

Phases B-I were not started because Phase A target-host execution was not proven. No current runtime, ingress, network, or public-route claim is made by this Evidence.

## Result

```text
RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
STOP_AT_REVIEWER=YES
```


## Gate: M1_R1_TARGET_HOST_ACCESS_RECOVERY_AND_M1_RESUME

```text
GATE=M1_R1_TARGET_HOST_ACCESS_RECOVERY_AND_M1_RESUME
DATE=2026-09-29
GITHUB_PROJECT_BASELINE_COMMIT=0773642f5d26317f4168e81c02f46fc3af33a9fd
RESULT=RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
OWNER_LOCAL_BOOTSTRAP_HANDOFF=PRESENT
IDENTITY_FILE_REFERENCE=VERIFIED_FROM_OWNER_LOCAL_HANDOFF_NOT_PROMOTED
IDENTITY_FILE_PRESENT=YES
CLIENT_PUBLIC_KEY_FINGERPRINT_MATCH=YES
NORMAL_KNOWN_HOSTS_REFERENCE=OWNER_NORMAL_KNOWN_HOSTS
THREE_RECORDED_HOST_KEY_PINS_LOCAL_MATCH=YES
SSH_STRICT_OPTIONS_PREFLIGHT=PASS
SSH_NETWORK_INVOCATIONS=1
SSH_NATIVE_EXIT=255
SSH_FAILURE=CONNECTION_CLOSED_BY_2.24.193.133_PORT_22
REMOTE_IDENTITY_OUTPUT=NONE
TARGET_HOST_IDENTITY=UNPROVEN
TARGET_HOST_EXECUTION_PROVEN=NO
M1_PHASES_B_I=NOT_STARTED
CLOUDFLARE_READONLY_SESSION_IN_CURRENT_BROWSER=NO
TARGET_ARCHITECTURE=UNRESOLVED
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
CADDY_MUTATIONS=0
PROJECT_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
SECRET_CONTENT_READS=0
STOP_AT_REVIEWER=YES
```

### Sources and result

Read the canonical VPS Project Governance files at GitHub `main`: `GOVERNANCE_HANDOFF.md`, `SKILL.md`, `GOVERNANCE_SOURCE_POLICY.md`, `GOVERNANCE_V0_1_6.md`, `STORAGE_LAYOUT_CONTRACT.md`, `SSH_AND_DELEGATED_SECRET_OPERATIONS.md`, and `TARGET_HOST_REALITY_CONTRACT.md`.

Read the current Shared VPS `SHARED_VPS_HANDOFF.md`, `REVIEWER_HANDOFF.md`, this Gate's Reviewer Decision and R1 execution packet, the original M1 architecture packet, `SHARED_VPS_PORTFOLIO.md`, Mini Craft `REVIEWER_HANDOFF.md` / `PROJECT_STORAGE_MANIFEST.md` / accepted K6 decision, and Dujiao-Next and Unified Pay Reviewer Handoffs. Project GitHub baseline was `0773642f5d26317f4168e81c02f46fc3af33a9fd`.

The Owner-local bootstrap handoff, referenced identity file, public-key fingerprint, and all three normal known_hosts pins passed local metadata checks. One direct-native strict SSH invocation was made to `ops@2.24.193.133:22` with BatchMode, IdentitiesOnly, StrictHostKeyChecking, explicit normal UserKnownHostsFile, ConnectionAttempts=1, bounded ConnectTimeout, no agent forwarding, no proxy, and no TTY. The server closed the connection before any remote identity output. No retry or alternate access path was used. Host-key negotiation/remote command execution is not claimed as proven.

Because `whoami=ops`, `id -un=ops`, non-root UID, and `hostname=srv1970241` were not returned, target-host execution is unproven. M1 phases B-I were not started; no runtime or architecture findings are claimed. Current browser tabs included Hostinger but no Cloudflare Dashboard session. The architecture remains unresolved. This result is the precise fail-closed RETURN required by M1-R1.

## Gate: M1-R4 Cloudflare Read-only Session and Architecture Seal — 2026-09-29

```text
GATE=M1_R4_CLOUDFLARE_READONLY_SESSION_AND_ARCHITECTURE_SEAL
RESULT=PASS_CANDIDATE_M1_R4_CLOUDFLARE_READONLY_SESSION_AND_ARCHITECTURE_SEAL
CLOUDFLARE_DASHBOARD_SESSION=AUTHENTICATED
CLOUDFLARE_ZONE=spikersun.com
TUNNEL=spikersun-shared-private
TUNNEL_STATE=HEALTHY
CONNECTED_CONNECTORS=1
CLOUDFLARED_MODE=REMOTE_MANAGED_TOKEN
CLOUDFLARED_IMAGE=cloudflare/cloudflared:2026.8.3
CLOUDFLARED_NETWORK=spikersun-private
TOKEN_OR_ENV_READ=NO

SHOP_PUBLIC_HOSTNAME=shop.spikersun.com
SHOP_TUNNEL_ORIGIN_SERVICE=http://dujiao-next-app:8080
DUJIAO_TUNNEL_PATTERN=DIRECT_TO_APP_ALIAS
PAY_PUBLIC_HOSTNAME=pay.spikersun.com
PAY_TUNNEL_ORIGIN_SERVICE=http://unified-pay-app:8080
XIANYU_PUBLIC_HOSTNAME=xianyu.spikersun.com
XIANYU_TUNNEL_ORIGIN_SERVICE=http://xianyu-app:8090

MINICRAFT_CURRENT_NETWORKS=mini-craft-night-kit-database+spikersun-edge
MINICRAFT_CURRENT_ALIASES=container-name+wordpress
MINICRAFT_CURRENT_PRIVATE_ALIAS=ABSENT
MINICRAFT_ALIAS_COLLISION=GENERIC_APP_ALREADY_USED_BY_DUJIAO_AND_UNIFIED_PAY
MINICRAFT_COMPOSE_CURRENT_NETWORKS=spikersun-edge_EXTERNAL+mini-craft-night-kit-database_INTERNAL
SPIKERSUN_PRIVATE_EXTERNAL_REUSE=SUPPORTED_BY_CURRENT_COMPOSE_STRUCTURE
MINICRAFT_FUTURE_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_PRIVATE_NETWORK_ATTACHMENT=NO

TEMP_TUNNEL_CANARY_FEASIBLE=YES_CONDITIONALLY
ORIGIN_SERVICE_PATTERN=DIRECT_TUNNEL_TO_PROJECT_UNIQUE_APP_ALIAS
ORIGIN_SERVICE_CANDIDATE=http://mini-craft-night-kit-wordpress:80
ORIGIN_HOST_HEADER_REQUIREMENT=minicraft.spikersun.com; VERIFY_OR_SET_EXPLICITLY_IN_M2B
CANARY_SAFE_SCOPE=TEMPORARY_FRESH_ABSENT_HOSTNAME_ONLY; KEEP_CANONICAL_CADDY_ROUTE
COOKIE_SESSION_LIMITATION=TEMP_HOST_COOKIE_SESSION_ISOLATED; DOES_NOT_PROVE_CANONICAL_SESSION_CONTINUITY
TARGET_ARCHITECTURE=DIRECT_TUNNEL_TO_MINICRAFT_APP

M2A_PRIVATE_NETWORK_PREPARATION=ADD_EXISTING_EXTERNAL_NETWORK_TO_WORDPRESS_ONLY; UNIQUE_ALIAS; KEEP_MARIADB_ISOLATED
M2B_TEMP_TUNNEL_CANARY=FRESH_ABSENT_TEMP_HOST_TO_PRIVATE_APP_ALIAS; VERIFY_CANONICAL_HOST_HEADER_AND_PUBLIC_BEHAVIOR
M2C_PRODUCTION_HOSTNAME_CUTOVER=REVIEWER_AUTHORIZED_TUNNEL_ROUTE_AND_EXACT_DNS_CUTOVER; KEEP_CADDY_ROUTE_AS_ROLLBACK
M2D_PUBLIC_REGRESSION_AND_OBSERVATION=VERIFY_DNS_TLS_APP_ROUTES_AND_UNRELATED_CADDY_ROUTES; CADDY_ROLLBACK_REMAINS
M2E_RETIRE_OLD_MINICRAFT_CADDY_ROUTE=ONLY_AFTER_M2D_REVIEWER_ACCEPTANCE_AND_SEPARATE_EXPLICIT_GATE
ROLLBACK_BEFORE_M2E=RESTORE_MINICRAFT_DNS_TO_CADDY_ORIGIN; RESTORE_TUNNEL_ROUTE_STATE; KEEP_CADDY_ROUTE_UNCHANGED

CLOUDFLARE_MUTATIONS=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
CADDY_MUTATIONS=0
PROJECT_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

Read-only provenance: authenticated Cloudflare One Dashboard route table; accepted M1-R3 target-host output and current Mini Craft/Dujiao handoffs; Cloudflare official Tunnel origin-parameter documentation (httpHostHeader setting remains empty by default and is not changed in this Gate). No Tunnel route detail was edited or saved.


## Gate: M2A Mini Craft Private Network Preparation — 2026-09-29 prewrite RETURN

```text
GATE=M2A_MINICRAFT_PRIVATE_NETWORK_PREPARATION
RESULT=RETURN_PREFLIGHT_DRIFT
OWNER_ACTION_TIME_CONFIRMATION=CONFIRMED
TARGET_HOST=srv1970241
ACCESS_PATH=HOSTINGER_WEB_TERMINAL
TARGET_HOST_EXECUTION_PROVEN=PASS
COMPOSE_FILE=/srv/apps/mini-craft-night-kit/compose.production.yaml
PREWRITE_COMPOSE_SHA256_EXPECTED=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf31786f1dded2110e8
PREWRITE_COMPOSE_HASH_MATCH=NO
PREWRITE_COMPOSE_BACKUP_CREATED=NO
COMPOSE_FILE_MUTATION=0
WORDPRESS_RECREATE=0
MARIADB_CHANGE=0
SHARED_NETWORK_MUTATIONS=0
WORDPRESS_PREWRITE_NETWORKS=mini-craft-night-kit-database+spikersun-edge
MARIADB_PREWRITE_NETWORKS=mini-craft-night-kit-database
TARGET_ALIAS_COLLISIONS=0
WORDPRESS_PREWRITE_RUNNING=YES
MARIADB_PREWRITE_HEALTHY=YES
PUBLIC_HOME_HTTP=200
PUBLIC_SHOP_HTTP=200
PUBLIC_WP_REST_HTTP=200
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
CADDY_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

The authenticated Hostinger Web Terminal proved the target host and current runtime facts. The fresh shell comparison against the accepted Compose SHA returned PREWRITE_COMPOSE_HASH_MATCH=NO; execution stopped before backup or any write. The observed current SHA was not separately transcribed into this record, so this section makes no claim about its exact differing value. Fresh read-only HTTP checks returned 200 for Home, Shop, and /wp-json/. No M2A network preparation was performed.


## Gate: M2A-R3 Runtime Network Membership Reconciliation — 2026-09-29

```text
GATE=M2A_R3_RUNTIME_NETWORK_MEMBERSHIP_RECONCILIATION
RESULT=PASS_CANDIDATE_M2A_R3_RUNTIME_NETWORK_MEMBERSHIP_RECONCILIATION
ACCESS_PATH=HOSTINGER_WEB_TERMINAL
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
TARGET_READBACK_TIME_INITIAL=2026-09-29T12:14:03Z
CONSOLE_USER=root

WORDPRESS_CONTAINER=mini-craft-night-kit-wordpress-1
WORDPRESS_CONTAINER_ID_PREFIX=ea7cbd0f8956
WORDPRESS_CREATED=2026-09-26T05:35:54.189065444Z
WORDPRESS_STARTED_AT=2026-09-26T09:46:27.389343631Z
WORDPRESS_RESTART_COUNT=0
COMPOSE_PROJECT_LABEL=mini-craft-night-kit
COMPOSE_SERVICE_LABEL=wordpress
COMPOSE_CONFIG_SOURCE_LABEL=/srv/apps/mini-craft-night-kit/compose.production.yaml

CURRENT_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
CURRENT_COMPOSE_BYTES=4966
CURRENT_COMPOSE_OWNER_GROUP_MODE=root:root:0644
CURRENT_COMPOSE_MTIME_UTC=2026-09-26T05:32:19.703022564Z
COMPOSE_WORDPRESS_NETWORK_DECLARATIONS=edge+database
COMPOSE_EDGE_NETWORK=spikersun-edge_EXTERNAL
COMPOSE_DATABASE_NETWORK=mini-craft-night-kit-database_INTERNAL
COMPOSE_PRIVATE_NETWORK_DECLARATION=ABSENT

WORDPRESS_NETWORKS_FINAL_REPEATED_READBACK=mini-craft-night-kit-database+spikersun-edge
WORDPRESS_PRIVATE_ALIAS_PRESENT=NO
WORDPRESS_PRIVATE_ALIAS_VALUE=NONE_IN_FINAL_REPEATED_READBACK
INITIAL_INSPECT_PRIVATE_MEMBERSHIP=YES_CONTRADICTED_BY_LATER_READBACK
INITIAL_PRIVATE_ALIASES=mini-craft-night-kit-wordpress-1+wordpress
TARGET_ALIAS=mini-craft-night-kit-wordpress
TARGET_ALIAS_PRESENT=NO
TARGET_ALIAS_COLLISIONS=0_IN_INSPECTED_PRIVATE_NETWORK_ALIAS_METADATA

MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_HEALTH=HEALTHY
SPIKERSUN_PRIVATE_LATER_NETWORK_INSPECT=WORDPRESS_ENDPOINT_ABSENT
SPIKERSUN_PRIVATE_LATER_CONTAINER_LIST=dujiao-next-app-1+unified-pay-app-1+xianyu-xianyu-app-1+spikersun-private-cloudflared-1
FINAL_WORDPRESS_CONTAINER_INSPECT=PRIVATE_ENDPOINT_ABSENT
FINAL_READBACK_OBSERVATION_CONFLICT=YES

DOCKER_EVENTS_WINDOW=2026-09-29T11:00:00Z_TO_INITIAL_READBACK
DOCKER_EVENTS_MATCHING_WORDPRESS_OR_SPIKERSUN_PRIVATE=NONE_RETURNED
DOCKER_EVENTS_LAST_TWO_HOURS_MATCHING=NONE_RETURNED
DOCKER_EVENT_HISTORY_PROVES_ORIGIN=NO
RUNTIME_NETWORK_DRIFT_CLASS=UNRESOLVED
PRIVATE_ORIGIN_REACHABILITY=NOT_TESTABLE
PRIVATE_ORIGIN_PROBE_REASON=NO_SUITABLE_EXISTING_PRIVATE_NETWORK_NAMESPACE_TOOL; NO_DISPOSABLE_CONTAINER_CREATED
SOURCE_RUNTIME_RECONCILIATION_REQUIRED=YES

PUBLIC_HOME_HTTP=200
PUBLIC_SHOP_HTTP=200
PUBLIC_WP_REST_HTTP=200

M2A_COMPOSE_WRITE=0
WORDPRESS_RECREATE=0
NETWORK_CONNECT_DISCONNECT=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
CADDY_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
DATABASE_MUTATIONS=0
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
CLEANUP_ACTIONS=0
SECRET_CONTENT_READS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

### Sources and reconciliation

Read the latest canonical Governance handoff and required Governance contracts; Shared VPS Reviewer Handoff, M2A-R3 Reviewer Decision and execution packet, current Shared VPS Evidence/Handoff, and Mini Craft Reviewer Handoff and Project Storage Manifest from GitHub. Used the accepted Hostinger Web Terminal path only; no SSH was attempted.

The Compose source remains byte-identical to the corrected accepted seal. Its WordPress service declares only the external `spikersun-edge` and internal project database network; MariaDB remains on the database network only. Runtime labels identify the same project, service, and canonical Compose path.

Within the target-host read-only session, an initial `docker inspect` showed a `spikersun-private` endpoint for the WordPress container, with aliases `mini-craft-night-kit-wordpress-1` and `wordpress`; it did not show the exact target alias `mini-craft-night-kit-wordpress`. A later `docker network inspect spikersun-private` listed Dujiao, Unified Pay, Xianyu, and cloudflared, but no WordPress. The WordPress endpoint inspection and repeated final container/network readbacks also showed no private endpoint. The final stable network list matches the current Compose declarations, but the conflicting earlier observation and the accepted Reviewer Handoff's prior runtime statement remain unexplained.

Filtered Docker-event queries for the bounded current window and the last two hours returned no matching event rows. This does not establish whether a direct network attach, Compose-managed recreate, previously accepted operation, or transient/readback inconsistency caused the discrepancy. Therefore the packet classification is `UNRESOLVED`; no method or join time is asserted.

A private-origin HTTP/DNS probe was not possible using an appropriate already-running private-network namespace. The existing cloudflared container had no shell executable and the Dujiao app container had no Node executable; no disposable container was created. Public Home, Shop, and WP REST checks returned HTTP 200.

### Minimal reconciliation plan (not executed)

Keep all runtime and source state unchanged. Reviewer should reconcile the conflicting runtime observations and decide whether a fresh bounded M2A prewrite is authorized. If reauthorized, recheck the exact source/runtime state, then make only the reviewed WordPress Compose network declaration with the unique alias, validate, recreate only WordPress, verify the private endpoint and origin, confirm MariaDB remains isolated, and recheck the existing Caddy public routes. M2B remains out of scope.



## Gate: M2A-R4 Stable Baseline and Conditional Execution — 2026-09-29

```text
GATE=M2A_R4_STABLE_BASELINE_AND_CONDITIONAL_EXECUTION
RESULT=RETURN_RUNTIME_READBACK_UNSTABLE
ACCESS_PATH=HOSTINGER_WEB_TERMINAL
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
CANONICAL_PROJECT_DIR=/srv/apps/mini-craft-night-kit
PREWRITE_READ_ROUNDS=2
READ_ROUND_INTERVAL_SECONDS=3

WORDPRESS_CONTAINER=mini-craft-night-kit-wordpress-1
READ_A_WORDPRESS_CONTAINER_ID=ea7cbd0f89569f3e1083268f38374182558cf9de6c6fd038ed1684ff5557d457c
READ_B_WORDPRESS_CONTAINER_ID=ea7cbd0f89569f3e1083268f38374182558cf9de6c6fd038ed1684ff5557d457c
WORDPRESS_CONTAINER_ID_UNCHANGED=YES
READ_A_WORDPRESS_NETWORKS_RAW=+mini-craft-night-kit-database+spikersun-edge
READ_B_WORDPRESS_NETWORKS_RAW=+mini-craft-night-kit-database+spikersun-edge
READ_A_WORDPRESS_PRIVATE_ENDPOINT=NO
READ_B_WORDPRESS_PRIVATE_ENDPOINT=NO
READ_A_PRIVATE_NETWORK_WORDPRESS_ENDPOINT=NO
READ_B_PRIVATE_NETWORK_WORDPRESS_ENDPOINT=NO
READ_A_TARGET_ALIAS_COLLISIONS=0
READ_B_TARGET_ALIAS_COLLISIONS=0
TARGET_ALIAS=mini-craft-night-kit-wordpress
WORDPRESS_ALIASES_BY_NETWORK_CAPTURE=FAILED_TEMPLATE_PARSE
READ_A_MARIADB_NETWORKS_RAW=+mini-craft-night-kit-database
READ_B_MARIADB_NETWORKS_RAW=+mini-craft-night-kit-database
READ_A_MARIADB_HEALTH=healthy
READ_B_MARIADB_HEALTH=healthy

STABLE_PREWRITE_RUNTIME=NOT_PROVEN
STABILITY_PREDICATE_FAILURE=NETWORK_NAME_NORMALIZATION_INCLUDED_LEADING_EMPTY_DELIMITER; WP_ALIAS_TEMPLATE_PARSE_FAILED
RETURN_RUNTIME_READBACK_UNSTABLE=EMITTED_FAIL_CLOSED
CURRENT_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
EXISTING_BACKUP_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
COMPOSE_AND_BACKUP_SEALS=PASS
COMPOSE_FILE_META=compose.production.yaml;root:root;0644;4966_bytes;mtime_2026-09-26T05:32:19.703022564Z
BACKUP_FILE_META=/srv/backups/mini-craft-night-kit/manifests/m2a-pre-private-network-20260929T111649Z.compose.bak;root:root;0644;4966_bytes;mtime_2026-09-26T05:32:19.703022564Z
COMPOSE_PROJECT_LABEL=mini-craft-night-kit
COMPOSE_CONFIG_SOURCE_LABEL=/srv/apps/mini-craft-night-kit/compose.production.yaml

ENVIRONMENT_FILE_ENUMERATION=FAILED_SHELL_SYNTAX
ENVIRONMENT_VARIABLE_NAMES_READ=NO
ENVIRONMENT_VALUES_READ=NO
CANONICAL_UNMODIFIED_COMPOSE_VALIDATION=NOT_RUN
COMPOSE_ENV_RESOLUTION=NOT_PROVEN
HOSTINGER_TERMINAL_SESSION=ENDED_AFTER_PREFLIGHT_SCRIPT_ERROR

M2A_COMPOSE_WRITE=0
WORDPRESS_RECREATE=0
NETWORK_CONNECT_DISCONNECT=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
CADDY_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
DATABASE_MUTATIONS=0
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
CLEANUP_ACTIONS=0
SSH_NETWORK_INVOCATIONS=0
SECRET_CONTENT_READS=0
SECRET_VALUES_EMITTED=0
PUBLIC_CADDY_REGRESSION=NOT_RUN
STOP_AT_REVIEWER=YES
```

### R4 fail-closed result

The two target-host rounds used the same WordPress container ID and both reported no WordPress private endpoint from the container/network membership checks; both reported zero matches for the requested alias, and MariaDB reported healthy. The raw network-name normalization emitted a leading empty delimiter, so the exact sealed-network comparison did not pass. The per-network alias extraction returned a Go-template parse error, leaving that required evidence incomplete. The preflight therefore emitted `RETURN_RUNTIME_READBACK_UNSTABLE`; this records failure to prove the exact R4 stability predicate, not a claim that a contradictory live endpoint was observed.

Both canonical Compose and the existing backup freshly matched the accepted SHA-256. The running Compose project/config labels matched the canonical project directory and file. The environment-file enumeration then failed on a shell syntax error and the terminal session ended. Consequently the environment source/variable-name inventory and unmodified Compose validation were not completed. No source edit, backup operation, Compose validation, recreate, or other mutation occurred. Conditional M2A execution was not entered.

