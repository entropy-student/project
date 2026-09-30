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



## Gate: M2A-R5 Parser-independent Stable Baseline and Conditional Execution — 2026-09-30

```text
GATE=M2A_R5_PARSER_INDEPENDENT_STABLE_BASELINE_AND_CONDITIONAL_EXECUTION
RESULT=RETURN_PREFLIGHT_DRIFT
ACCESS_PATH=HOSTINGER_WEB_TERMINAL
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
CONSOLE_USER=root
CANONICAL_PROJECT_DIR=/srv/apps/mini-craft-night-kit

PREWRITE_READ_ROUNDS=2
READ_ROUND_INTERVAL_SECONDS=3
READ_ROUNDS_SEMANTICALLY_EQUAL=YES
WORDPRESS_CONTAINER_ID_UNCHANGED=YES
WORDPRESS_CONTAINER_ID=ea7cbd0f89569f3e1083268f38374182558cf9de6c6fd038ed1684ff5557d457c
WORDPRESS_RESTART_COUNT_A_B=0
WORDPRESS_NETWORKS_A_B=mini-craft-night-kit-database+spikersun-edge
WORDPRESS_ALIASES_BY_NETWORK_A_B=mini-craft-night-kit-database:[mini-craft-night-kit-wordpress-1,wordpress];spikersun-edge:[mini-craft-night-kit-wordpress-1,wordpress]
WORDPRESS_PRIVATE_ENDPOINT_A_B=ABSENT
SPIKERSUN_PRIVATE_WORDPRESS_ENDPOINT_A_B=ABSENT
SPIKERSUN_PRIVATE_TARGET_ALIAS_COLLISIONS_A_B=0
SPIKERSUN_PRIVATE_ENDPOINTS_A_B=dujiao-next-app-1;spikersun-private-cloudflared-1;unified-pay-app-1;xianyu-xianyu-app-1
MARIADB_NETWORKS_A_B=mini-craft-night-kit-database
MARIADB_HEALTH_A_B=healthy

SEALED_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
OBSERVED_COMPOSE_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
OBSERVED_EXISTING_BACKUP_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
COMPOSE_EQUALS_EXISTING_BACKUP=YES
COMPOSE_AND_BACKUP_SEALS=FAIL
UNMODIFIED_COMPOSE_VALIDATION=NOT_RUN_PREWRITE_HASH_MISMATCH
COMPOSE_ENV_RESOLUTION=NOT_TESTED
CADDY_PUBLIC_REGRESSION=NOT_RUN

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
STOP_AT_REVIEWER=YES
```

### R5 fail-closed result

Hostinger Web Terminal confirmed the target host. Two independent reads parsed raw `docker inspect` and `docker network inspect` JSON with Python; both rounds agreed on the WordPress container ID, DB+edge networks, per-network aliases, absence from `spikersun-private`, zero target-alias collisions, and healthy MariaDB isolated to the project database network.

The canonical Compose file and the existing pre-M2A backup were each freshly hashed. They match each other, but both produce `85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c`, not the R5 sealed digest `85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8`. Therefore execution stopped before unmodified Compose validation, backup use, source edit, or any runtime operation. No environment values or Secret values were read or emitted. No M2A mutation occurred.


## Gate: M2A-R6 Canonical Hash Correction and Conditional Execution — 2026-09-30

```text
GATE=M2A_R6_CANONICAL_HASH_CORRECTION_AND_CONDITIONAL_EXECUTION
RESULT=RETURN_COMPOSE_ENV_RESOLUTION_UNAVAILABLE
ACCESS_PATH=HOSTINGER_WEB_TERMINAL
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
CONSOLE_USER=root

OBSERVED_COMPOSE_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
OBSERVED_BACKUP_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
COMPOSE_EQUALS_BACKUP=YES

WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
WORDPRESS_PRIVATE_ENDPOINT=ABSENT
TARGET_ALIAS_COLLISIONS=0
MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_HEALTH=healthy

COMPOSE_ENV_RESOLUTION=FAIL
UNMODIFIED_COMPOSE_VALIDATION=FAIL
FAILURE_CLASS=ENV_RESOLUTION_UNAVAILABLE
M2A_WRITE_ENTERED=NO
CADDY_PUBLIC_REGRESSION=NOT_RUN

COMPOSE_WRITE=0
BACKUP_CREATION=0
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
ENVIRONMENT_VALUES_EMITTED=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

The compact fresh prewrite matched the corrected R6 source/backup seal and accepted runtime baseline. The unmodified canonical Compose validation was attempted from `/srv/apps/mini-craft-night-kit` using `docker compose -p mini-craft-night-kit -f /srv/apps/mini-craft-night-kit/compose.production.yaml config --quiet`; its bounded non-sensitive result classified environment resolution as unavailable. Per the Gate, execution stopped before using the backup, editing Compose, or recreating WordPress. No raw validation output or environment/Secret value was emitted.


## Gate: M2A-R7 Explicit Non-secret Compose Environment and Conditional Execution — 2026-09-30

```text
GATE=M2A_R7_EXPLICIT_NONSECRET_COMPOSE_ENV_AND_CONDITIONAL_EXECUTION
RESULT=PASS_CANDIDATE_M2A_R7_EXPLICIT_NONSECRET_COMPOSE_ENV_AND_CONDITIONAL_EXECUTION
ACCESS_PATH=HOSTINGER_WEB_TERMINAL
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS

PREWRITE_CANONICAL_COMPOSE_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
PREWRITE_EXISTING_BACKUP_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
EXISTING_BACKUP_REUSED=/srv/backups/mini-craft-night-kit/manifests/m2a-pre-private-network-20260929T111649Z.compose.bak
NEW_BACKUP_CREATED=NO

PREWRITE_WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
PREWRITE_WORDPRESS_PRIVATE_ENDPOINT=ABSENT
PREWRITE_TARGET_ALIAS_COLLISIONS=0
PREWRITE_MARIADB_NETWORKS=mini-craft-night-kit-database
PREWRITE_MARIADB_HEALTH=healthy

INTERPOLATION_INPUT_COUNT=2
INTERPOLATION_VARIABLES=MARIADB_DATABASE+MARIADB_USER
DATABASE_NAME_VARIABLE=MARIADB_DATABASE
DATABASE_NAME_VALUE=wordpress
APP_DATABASE_USER_VARIABLE=MARIADB_USER
APP_DATABASE_USER_VALUE=mini_craft_app
ENV_FILE_READ=NO
OTHER_ENVIRONMENT_VALUES_READ_OR_EMITTED=0
UNMODIFIED_COMPOSE_VALIDATION=PASS
COMPOSE_VALIDATION_MODE=EXPLICIT_TWO_NONSECRET_VALUES; ENV_FILE=/dev/null; QUIET

COMPOSE_CANDIDATE_BYTES=5122
COMPOSE_CANDIDATE_SHA256=25931b1de6ee1814e012a246355c315b20f242649e2f658b3322b956f215e869
COMPOSE_EDIT_SCOPE=WORDPRESS_PRIVATE_NETWORK_MEMBERSHIP_AND_ALIAS_ONLY; EXTERNAL_NETWORK_DECLARATION_ONLY
COMPOSE_FILE_METADATA_PRESERVED=YES
COMPOSE_EDIT_WRITE=PASS
EDITED_COMPOSE_VALIDATION=PASS
POSTWRITE_COMPOSE_SHA256=25931b1de6ee1814e012a246355c315b20f242649e2f658b3322b956f215e869

WORDPRESS_ONLY_RECREATE=PASS
WORDPRESS_RESTART_COUNT=0
WORDPRESS_STATE=RUNNING
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge+spikersun-private
WORDPRESS_TARGET_ALIAS=mini-craft-night-kit-wordpress
TARGET_ALIAS_MATCHING_ENDPOINT_COUNT=1
TARGET_ALIAS_OWNED_BY_WORDPRESS=YES
WORDPRESS_PUBLISHED_PORTS=NONE

MARIADB_STATE=RUNNING_HEALTHY
MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_PRIVATE_ENDPOINT=ABSENT
MARIADB_PUBLISHED_PORTS=NONE
PRIVATE_ORIGIN_HTTP=200
PUBLIC_HOME_HTTP=200
PUBLIC_SHOP_HTTP=200
PUBLIC_WP_JSON_HTTP=200
EXISTING_CADDY_PUBLIC_PATH=PASS

M2B_ENTERED=NO
SHARED_NETWORK_DEFINITION_MUTATION=0
MARIADB_MUTATIONS=0
CADDY_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_READ_OR_EMITTED=0
STOP_AT_REVIEWER=YES
```

### R7 execution record

Read the current Shared VPS Reviewer Handoff, R6 Reviewer Decision, R7 execution packet, original M2A execution packet, latest Shared VPS Evidence/Handoff, and current canonical VPS Project Governance. Used the already authenticated Hostinger Web Terminal only; no SSH retry was made.

The fresh compact prewrite matched the corrected Compose and existing-backup digest and the accepted runtime predicates. A source-only scan of the canonical Compose found exactly two interpolation names: `MARIADB_DATABASE` (the database name) and `MARIADB_USER` (the application database user). Only the Reviewer-accepted non-secret values `wordpress` and `mini_craft_app` were passed to the Compose process. The historical `.env` file was neither read nor changed; the unmodified Compose passed quiet validation with an empty env-file plus those explicit process values.

Reused the exact existing rollback backup; created no new backup. Updated only `/srv/apps/mini-craft-night-kit/compose.production.yaml`: WordPress now uses the existing `spikersun-private` external network with the unique requested alias while retaining its DB and edge networks; MariaDB remains on the project database network only. The edited Compose passed quiet validation. The one requested WordPress-only recreate completed successfully, with no dependency recreate, pull, or build. Fresh runtime readback showed WordPress running with restart count 0, the target alias matching exactly one private-network endpoint owned by WordPress, and MariaDB healthy and absent from the shared private network. A bounded private-origin GET returned HTTP 200. Existing public Caddy Home, Shop, and REST paths each returned HTTP 200 with normal TLS verification. No M2B action was started.

No payment/provider, DNS, Cloudflare, Caddy, database-content, Secret, or cleanup action occurred. No Reviewer-owned file was changed.

## Gate: M2B Temporary Tunnel Canary — 2026-09-30

```text
GATE=M2B_TEMPORARY_TUNNEL_CANARY
RESULT=PASS_CANDIDATE_M2B_TEMPORARY_TUNNEL_CANARY
M2B_R1_BROWSER_CONTEXT_RECOVERY=PASS
CLOUDFLARE_DASHBOARD_CONTEXT=VERIFIED
AUTHENTICATED_SESSION=YES
TUNNEL=spikersun-shared-private
TUNNEL_HEALTH=HEALTHY

PREFLIGHT_TEMP_PUBLIC_HOSTNAME=ABSENT
PREFLIGHT_TEMP_DNS=ABSENT
PRODUCTION_MINICRAFT_DNS=A_2.24.193.133_DNS_ONLY
EXISTING_TUNNEL_ROUTES_PREWRITE=PASS

TEMP_HOSTNAME=minicraft-m2b-canary.spikersun.com
TEMP_PUBLIC_HOSTNAME_TUNNEL=spikersun-shared-private
TEMP_ORIGIN_SERVICE=http://mini-craft-night-kit-wordpress:80
TEMP_ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com
TEMP_DNS_TYPE=CNAME
TEMP_DNS_TARGET=ed47dfe3-e529-46be-a4de-f14ddc05136e.cfargotunnel.com
TEMP_ROUTE_CONFIG_READBACK=PASS

TEMP_HOME_HTTP=200
TEMP_SHOP_HTTP=200
TEMP_WP_REST_HTTP=200
TEMP_TLS_VALID=YES
TEMP_TLS_VERIFY_RESULT=0

PRODUCTION_HOME_HTTP=200
PRODUCTION_SHOP_HTTP=200
PRODUCTION_WP_REST_HTTP=200
PRODUCTION_DNS_A_TO_CADDY_UNCHANGED=YES

TEMP_ROUTE_CLEANUP=PASS
TEMP_PUBLIC_HOSTNAME_PRESENT=NO
TEMP_DNS_PRESENT=NO
PRODUCTION_MINICRAFT_DNS_POST_CLEANUP=A_2.24.193.133_DNS_ONLY
EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS

CLOUDFLARE_MUTATIONS=TEMP_ROUTE_CREATE_AND_DELETE_ONLY
DNS_MUTATIONS=TEMP_CNAME_CREATE_AND_DELETE_ONLY
CADDY_MUTATIONS=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
WORDPRESS_MUTATIONS=0
MARIADB_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
M2C_ENTERED=NO
STOP_AT_REVIEWER=YES
```

### Execution notes

The current GitHub M2B-R1 recovery decision and execution packet were read before resuming. The authenticated Cloudflare Tunnel page showed the expected tunnel and the original three routes. Before the write, the exact temporary route and DNS hostname were absent; the production Mini Craft DNS record remained DNS-only A `2.24.193.133`.

Created only the authorized temporary published-application route. The creation receipt showed the required Tunnel CNAME was auto-created. Fresh route edit readback confirmed the exact origin service and HTTP Host Header. The three pre-existing route mappings remained unchanged.

Normal-TLS HTTPS checks (no cookies or credentials) returned HTTP 200 for temporary Home, Shop, and `/wp-json/`; TLS verification succeeded. Production Home, Shop, and REST also returned HTTP 200. The production DNS record remained unchanged.

Mandatory cleanup removed the temporary route and its associated CNAME. After page refresh, the Tunnel route list contained only the three original routes. Fresh exact DNS-zone readback found zero records for the temporary hostname and confirmed the production Mini Craft A record remained `2.24.193.133`, DNS-only. No M2C action followed.


## Gate: M2C Production Hostname Tunnel Cutover — 2026-09-30

GATE=M2C_PRODUCTION_HOSTNAME_TUNNEL_CUTOVER
RESULT=PASS_CANDIDATE_M2C_PRODUCTION_HOSTNAME_TUNNEL_CUTOVER
OWNER_AUTHORIZATION=EXPLICIT_M2C_PRODUCTION_CUTOVER_CONFIRMED

PRODUCTION_HOST=minicraft.spikersun.com
ROLLBACK_DNS_TYPE=A
ROLLBACK_DNS_CONTENT=2.24.193.133
ROLLBACK_DNS_PROXY=DNS_ONLY
ROLLBACK_DNS_TTL=AUTO

PREFLIGHT_CLOUDFLARE_SESSION=AUTHENTICATED
PREFLIGHT_TUNNEL=spikersun-shared-private_HEALTHY
PREFLIGHT_CANONICAL_TUNNEL_ROUTE=ABSENT
PREFLIGHT_M2B_TEMP_ROUTE=ABSENT
PREFLIGHT_M2B_TEMP_DNS=ABSENT
PREFLIGHT_PRODUCTION_HOME_HTTP=200
PREFLIGHT_PRODUCTION_SHOP_HTTP=200
PREFLIGHT_PRODUCTION_WP_REST_HTTP=200
PREFLIGHT_EXISTING_ROUTES=PASS

OLD_CANONICAL_A_DELETE_ACTIONS=1
CANONICAL_TUNNEL_ROUTE_CREATE_ACTIONS=1
TUNNEL_REQUIRED_DNS_CREATE_ACTIONS=1
CANONICAL_TUNNEL_DNS_TYPE=CNAME
CANONICAL_TUNNEL_DNS_TARGET=ed47dfe3-e529-46be-a4de-f14ddc05136e.cfargotunnel.com
CANONICAL_TUNNEL_DNS_PROXY=PROXIED
CANONICAL_TUNNEL_DNS_TTL=AUTO

PRODUCTION_TUNNEL=spikersun-shared-private
PRODUCTION_ORIGIN=http://mini-craft-night-kit-wordpress:80
PRODUCTION_ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com
PRODUCTION_ROUTE_READBACK=PASS
PRODUCTION_OLD_A_RECORD=ABSENT

PUBLIC_HOME_HTTP=200
PUBLIC_HOME_TLS_VERIFY_RESULT=0
PUBLIC_SHOP_HTTP=200
PUBLIC_SHOP_TLS_VERIFY_RESULT=0
PUBLIC_WP_REST_HTTP=200
PUBLIC_WP_REST_TLS_VERIFY_RESULT=0

EXISTING_XIANYU_ROUTE=http://xianyu-app:8090_UNCHANGED
EXISTING_PAY_ROUTE=http://unified-pay-app:8080_UNCHANGED
EXISTING_SHOP_ROUTE=http://dujiao-next-app:8080_UNCHANGED
EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS

PRODUCTION_INGRESS=CLOUDFLARE_TUNNEL_DIRECT_TO_MINICRAFT_APP
CADDY_ROUTE_RETAINED_AS_ROLLBACK=YES
ROLLBACK_PERFORMED=NO
M2D_ENTERED=NO
M2E_ENTERED=NO

DNS_MUTATIONS=2
TUNNEL_ROUTE_MUTATIONS=1
CADDY_MUTATIONS=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
WORDPRESS_MUTATIONS=0
MARIADB_MUTATIONS=0
PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES

### Execution notes

Using the authenticated Cloudflare Dashboard and the exact rollback tuple confirmed in the Owner checkpoint, removed only the canonical DNS-only A record (minicraft.spikersun.com -> 2.24.193.133, TTL Auto). Created one published-application route on spikersun-shared-private for minicraft.spikersun.com, with origin http://mini-craft-night-kit-wordpress:80 and HTTP Host Header minicraft.spikersun.com. Cloudflare's success receipt reported creation of the required proxied Tunnel CNAME to the existing tunnel target. Fresh DNS readback showed that CNAME and no old A; route detail readback confirmed the exact origin and Host Header. Fresh route-table readback retained the xianyu, pay, and shop mappings unchanged.

Anonymous requests with normal TLS verification returned HTTP 200 for Home, Shop, and /wp-json/; curl exit was 0 and TLS verification result was 0 for all three. No rollback was needed. Caddy remains untouched as rollback infrastructure. No M2D/E action was entered. No payment/provider, VPS, Docker, Compose, WordPress, MariaDB, or Secret action occurred.


## Gate: M2D-R1 Hostinger Terminal Context Recovery and Public Regression Observation — 2026-09-30

```text
GATE=M2D_R1_HOSTINGER_TERMINAL_CONTEXT_RECOVERY_AND_OBSERVATION_RESTART
RESULT=PASS_CANDIDATE_M2D_PUBLIC_REGRESSION_AND_OBSERVATION
HOSTINGER_TERMINAL_CONTEXT=VERIFIED
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
CONSOLE_USER=root
DIRECT_SSH=NOT_USED
OBSERVATION_CHECKPOINTS=3
T0_RUNTIME_READBACK_UTC=2026-09-30T07:55:27Z
T0_CHECKPOINT_COMPLETED_UTC=2026-09-30T07:57:29Z
T_PLUS_5_RUNTIME_READBACK_UTC=2026-09-30T08:06:35Z
T_PLUS_10_RUNTIME_READBACK_UTC=2026-09-30T08:15:53Z
OBSERVATION_WINDOW=REAL_SPACED_READONLY_CHECKPOINTS_OVER_20_MINUTES

PRODUCTION_TUNNEL=spikersun-shared-private
PRODUCTION_ROUTE_ORIGIN=http://mini-craft-night-kit-wordpress:80
PRODUCTION_HTTP_HOST_HEADER=minicraft.spikersun.com
CANONICAL_DNS=CNAME_TO_EXISTING_TUNNEL
OLD_CANONICAL_A_RECORD=ABSENT
M2B_TEMP_ROUTE=ABSENT
M2B_TEMP_DNS=ABSENT
EXISTING_XIANYU_ROUTE=http://xianyu-app:8090_UNCHANGED
EXISTING_PAY_ROUTE=http://unified-pay-app:8080_UNCHANGED
EXISTING_SHOP_ROUTE=http://dujiao-next-app:8080_UNCHANGED
EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS

PUBLIC_HOME_HTTP=200
PUBLIC_HOME_TLS_VERIFY_RESULT=0
PUBLIC_SHOP_HTTP=200
PUBLIC_SHOP_TLS_VERIFY_RESULT=0
PUBLIC_WP_REST_HTTP=200
PUBLIC_WP_REST_TLS_VERIFY_RESULT=0

WORDPRESS_STATE=RUNNING
WORDPRESS_RESTART_COUNT=0
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge+spikersun-private
WORDPRESS_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_STATE=RUNNING_HEALTHY
MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_ON_SPIKERSUN_PRIVATE=NO

CADDY_MINICRAFT_ROLLBACK_MATCHER=PRESENT
CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
PRODUCTION_INGRESS_STABLE=PASS
TLS_STABLE=PASS

CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
CADDY_MUTATIONS=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
WORDPRESS_MUTATIONS=0
MARIADB_MUTATIONS=0
PAYMENT_ACTIONS=0
M2E_ENTERED=NO
STOP_AT_REVIEWER=YES
```

### Observation notes

Rebound the already-open authenticated Hostinger Web Terminal in the in-app browser and verified its own identity output (hostname=srv1970241, id -un=root, UID 0). No direct SSH was used. The three observation checkpoints were performed as separate fresh readbacks; T0 runtime readback was at 07:55:27 UTC, T+5 at 08:06:35 UTC, and T+10 at 08:15:53 UTC, spanning over 20 minutes from first to final runtime timestamp. No prior interrupted checkpoint was counted.

At each checkpoint, the authenticated Cloudflare Tunnel route remained on spikersun-shared-private with origin http://mini-craft-night-kit-wordpress:80 and HTTP Host Header minicraft.spikersun.com; the old canonical A record remained absent and the canonical hostname remained on the Tunnel CNAME. The xianyu, pay, and shop routes were unchanged. The M2B temporary hostname was absent from Tunnel routes and DNS. Anonymous normal-TLS Home, Shop, and /wp-json/ checks each returned HTTP 200 with TLS verify result 0.

Fresh target-host readbacks at all checkpoints showed WordPress running with restart count 0, on the database, edge, and private networks with the required private alias. MariaDB remained healthy on the project database network only and absent from spikersun-private. The Mini Craft Caddy rollback matcher remained present and the Caddyfile SHA-256 stayed at the accepted value above. No M2E action followed.
