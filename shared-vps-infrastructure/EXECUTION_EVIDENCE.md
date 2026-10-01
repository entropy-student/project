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


## Gate: M2E Retire Legacy Mini Craft Caddy Route — 2026-09-30

```text
GATE=M2E_RETIRE_LEGACY_MINICRAFT_CADDY_ROUTE
RESULT=PASS_CANDIDATE_M2E_RETIRE_LEGACY_MINICRAFT_CADDY_ROUTE
ACCESS_PATH=HOSTINGER_WEB_TERMINAL
TARGET_HOST=srv1970241
DIRECT_SSH=NOT_USED

PREWRITE_CADDYFILE=/srv/infra/edge/Caddyfile
PREWRITE_CADDYFILE_BYTES=199
PREWRITE_CADDYFILE_MODE_OWNER_GROUP=0644 root:root
PREWRITE_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
MINICRAFT_BLOCK_COUNT=1
MINICRAFT_BLOCK_HOST=minicraft.spikersun.com
MINICRAFT_BLOCK_UPSTREAM=wordpress:80
MINICRAFT_BLOCK_SHARED_WITH_OTHER_HOSTS=NO

ROLLBACK_COPY=/srv/infra/edge/Caddyfile.m2e-prewrite-20260930T091701Z.bak
ROLLBACK_COPY_BYTES=199
ROLLBACK_COPY_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
ROLLBACK_COPY_COUNT=1

CADDYFILE_WRITE_MODE=IN_PLACE_SAME_INODE
CADDYFILE_POST_BYTES=143
CADDYFILE_POST_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
HOST_CADDYFILE_INODE_UNCHANGED=PASS
CANDIDATE_VALIDATION_FROM_STDIN=PASS
CONTAINER_MOUNTED_PATH_POST_BYTES=199
CONTAINER_MOUNTED_PATH_POST_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
CONTAINER_MOUNTED_PATH_DIVERGENCE=KNOWN_STALE_SINGLE_FILE_MOUNT
RELOAD_SOURCE=HOST_CADDYFILE_VIA_STDIN
CADDY_RELOAD_COUNT=1
CADDY_RELOAD_EXIT=0
CADDY_RESTART_COUNT=0
CADDY_RECREATE_COUNT=0
CADDY_CONTAINER_ID_UNCHANGED=YES
CADDY_SERVICE_HEALTH=PASS
LEGACY_MINICRAFT_CADDY_ROUTE=ABSENT_FROM_ACTIVE_ADMIN_CONFIG_AND_HOST_SOURCE

OTHER_CADDY_SITES_REGRESSION=PASS
EDGE_TEST_HTTP=200
EDGE_TEST_TLS_VERIFY_RESULT=0
EDGE_TEST_BODY_BYTES=30
EDGE_TEST_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
LOCALHOST_ROUTE=PASS

MINICRAFT_TUNNEL=spikersun-shared-private
MINICRAFT_TUNNEL_ORIGIN=http://mini-craft-night-kit-wordpress:80
MINICRAFT_HTTP_HOST_HEADER=minicraft.spikersun.com
CANONICAL_DNS=CNAME_TO_EXISTING_TUNNEL
CANONICAL_OLD_A_RECORD=ABSENT
M2B_TEMP_DNS=ABSENT
XIANYU_TUNNEL_ORIGIN=http://xianyu-app:8090_UNCHANGED
PAY_TUNNEL_ORIGIN=http://unified-pay-app:8080_UNCHANGED
SHOP_TUNNEL_ORIGIN=http://dujiao-next-app:8080_UNCHANGED
EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS

PUBLIC_HOME_HTTP=200
PUBLIC_HOME_TLS_VERIFY_RESULT=0
PUBLIC_SHOP_HTTP=200
PUBLIC_SHOP_TLS_VERIFY_RESULT=0
PUBLIC_WP_REST_HTTP=200
PUBLIC_WP_REST_TLS_VERIFY_RESULT=0
MINICRAFT_TUNNEL_PRODUCTION_REGRESSION=PASS
PRODUCTION_INGRESS=CLOUDFLARE_TUNNEL_DIRECT_TO_MINICRAFT_APP
CADDY_ROLLBACK_COPY=RETAINED

UNPLANNED_DIAGNOSTIC_SCRATCH=/tmp/m2e-edge-body
UNPLANNED_DIAGNOSTIC_SCRATCH_BYTES=30
UNPLANNED_DIAGNOSTIC_SCRATCH_REMOVED=YES

CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
CADDYFILE_WRITE_ACTIONS=1
CADDY_RELOAD_ACTIONS=1
CADDY_RESTART_ACTIONS=0
CADDY_RECREATE_ACTIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
WORDPRESS_MUTATIONS=0
MARIADB_MUTATIONS=0
PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
SECRET_VALUES_EMITTED=0
M2D_ENTERED=NO
M2E_ENTERED=YES
STOP_AT_REVIEWER=YES
```

### M2E notes

Fresh-read the M2E Reviewer Decision/Execution Packet and current Shared VPS handoff/evidence before acting. Used the already accepted Hostinger Web Terminal path on srv1970241; no SSH was attempted. Prewrite host Caddyfile and the single rollback copy matched the exact accepted baseline hash. The isolated Mini Craft block was removed from the existing host file using an O_WRONLY, non-creating, non-truncating same-inode write; the candidate was validated through the established stdin path and Caddy was reloaded exactly once from stdin. No restart or recreate occurred.

Post-reload Caddy Admin readback showed only the preserved localhost and edge-test response routes; the Mini Craft matcher was absent. Public Home, Shop, and WP REST were HTTP 200 with normal TLS verification; edge-test retained its exact 30-byte fingerprint. Authenticated Cloudflare readback showed the canonical Tunnel CNAME/route unchanged, all xianyu/pay/shop routes unchanged, and no M2B temporary DNS record.

Important residual: the container's mounted `/etc/caddy/Caddyfile` still reads the prewrite 199-byte baseline hash, while the host source and active Admin configuration contain the 143-byte candidate. The Caddyfile bind mount is therefore stale. The requested stdin reload correctly changed the active configuration without reopening that pathname, but a future Caddy process restart from the stale mounted path could restore the retired matcher. No restart/recreate was attempted because it is explicitly forbidden in this Gate. Reviewer should decide whether a separately authorized mount reconciliation/recreate is required.

A 30-byte edge-test body was briefly written to the exact diagnostic path shown above, then content/size-checked and removed; the path was confirmed absent afterward. No other temporary path was touched.


## Gate: S1 Restore Canonical Shared VPS SSH Connection Contract — 2026-09-30

```text
GATE=S1_RESTORE_CANONICAL_SSH_CONNECTION_CONTRACT
RESULT=PASS_CANDIDATE_S1_RESTORE_CANONICAL_SSH_CONNECTION_CONTRACT

SSH_NORMAL_PATH=RESTORED
IDENTITY_FILE_REFERENCE=C:\Users\34707\.ssh\xianyu_hostinger_codex_ed25519
IDENTITY_FILE_EXISTS=YES
IDENTITY_ACL_METADATA=PASS
CLIENT_PUBLIC_KEY_FINGERPRINT=SHA256:qFlRXelvzDEFpatrcX7T4dUBKPAC7YqFqNkyFZh5rYw
CLIENT_PUBLIC_KEY_FINGERPRINT_MATCH=YES
EXPECTED_HOST_KEY_FINGERPRINTS=SHA256:yr2b1z2fZmMU+8IwnTB8M94H1VlO+U3CIZk1S3FOa+o;SHA256:L7lXm/ssbbeeHG6OlRis2dreMW+SGzeJoMeGu6xzngw;SHA256:QS8B89XaTDpt3s+74W55W4jQzrjwfrEc/Q0FfWp8uZc
KNOWN_HOSTS_REFERENCE=C:\Users\34707\.ssh\known_hosts
KNOWN_HOSTS_EXPECTED_PINS_MATCH=YES
STRICT_OPTIONS=BatchMode=yes;IdentitiesOnly=yes;StrictHostKeyChecking=yes;UserKnownHostsFile=C:\Users\34707\.ssh\known_hosts;ConnectionAttempts=1;ConnectTimeout=10;ForwardAgent=no

SSH_NATIVE_EXIT=0
REMOTE_HOSTNAME=srv1970241
REMOTE_USER=ops
REMOTE_OS=Ubuntu 24.04.5 LTS (VERSION_ID=24.04)
TARGET_HOST_EXECUTION_PROVEN=PASS
SUDO_NONINTERACTIVE_AVAILABLE=YES
DOCKER_READONLY_ACCESS=NO_DIRECT
SSH_NETWORK_INVOCATIONS=1
HOSTINGER_WEB_TERMINAL_USED=NO

VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
CADDY_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

### S1 notes

Local trust preflight passed before network access. The existing Owner-workstation identity reference was verified without reading or emitting private-key contents; the derived client public-key fingerprint and recorded known_hosts pins matched the accepted trust metadata. Exactly one strict non-interactive SSH invocation was made to ops@2.24.193.133:22 and exited 0. Remote readback proved hostname srv1970241 and user ops on Ubuntu 24.04.5 LTS.

Direct unprivileged Docker read-only access is not available to ops, while non-interactive sudo is available. This does not block the SSH connection contract: future reviewed Docker operations should use bounded `sudo docker ...` commands rather than assuming direct docker-socket membership. No SSH repair or runtime mutation occurred.


## Gate: M2E-R1 SSH Persistence Reconciliation Completion — 2026-10-01

```text
GATE=M2E_R1_SSH_PERSISTENCE_RECONCILIATION_COMPLETION
RESULT=PASS_CANDIDATE_M2E_R1_SSH_PERSISTENCE_RECONCILIATION_COMPLETION
ACCESS_PATH=CANONICAL_STRICT_SSH
TARGET_HOST=srv1970241
REMOTE_USER=ops
SSH_NATIVE_EXIT=0
SSH_NETWORK_INVOCATIONS=1
HOSTINGER_WEB_TERMINAL_USED=NO

CADDY_CONTAINER_ID=793a5c8fbcd86d3c2b6dc0ba5a47e51de9d372957210efa0912523b8c1e7b9a2
CADDY_CONTAINER_NAME=/spikersun-edge-caddy-1
CADDY_STATE=running
CADDY_RESTART_COUNT=0

MOUNT_TYPE=bind
MOUNT_SOURCE=/srv/infra/edge/Caddyfile
MOUNT_DESTINATION=/etc/caddy/Caddyfile
MOUNT_RW=false
MOUNT_PROPAGATION=rprivate

HOST_CADDYFILE_BYTES=143
HOST_CADDYFILE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
HOST_SOURCE_MINICRAFT_MATCHER=ABSENT

CONTAINER_CADDYFILE_BYTES=199
CONTAINER_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
CONTAINER_MOUNTED_FILE_MINICRAFT_MATCHER=PRESENT

ACTIVE_ADMIN_CONFIG_MINICRAFT_MATCHER=ABSENT
CADDY_STARTUP_CONFIG_SOURCE=/etc/caddy/Caddyfile

MINICRAFT_HOME_HTTP=200
MINICRAFT_HOME_TLS_VERIFY=0
MINICRAFT_SHOP_HTTP=200
MINICRAFT_SHOP_TLS_VERIFY=0
MINICRAFT_WP_REST_HTTP=200
MINICRAFT_WP_REST_TLS_VERIFY=0

CADDY_MOUNT_DIVERGENCE_CLASS=SINGLE_FILE_BIND_MOUNT_STALE_REFERENCE
RESTART_REINTRODUCTION_RISK=YES
PLAIN_RESTART_SUFFICIENT=NO
RECREATE_REQUIRED=YES
MINIMAL_RECONCILIATION_PLAN=RECREATE_ONLY_EXISTING_SHARED_CADDY_CONTAINER_OR_SERVICE_FROM_CANONICAL_DEPLOYMENT_DEFINITION_TO_REBIND_CURRENT_HOST_CADDYFILE_THEN_REGRESSION_VERIFY

CADDYFILE_WRITES=0
CADDY_RELOADS=0
CADDY_RESTARTS=0
CADDY_RECREATES=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
PAYMENT_ACTIONS=0
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

### M2E-R1 SSH reconciliation notes

Fresh readback through the restored canonical SSH path reproduced the previously suspected persistence divergence. The host Caddyfile is the 143-byte post-retirement source with no Mini Craft matcher, while the running container's read-only single-file bind destination still exposes the 199-byte pre-retirement baseline containing the matcher. The active Caddy Admin config remains on the correct post-retirement state.

Because Caddy startup reads `/etc/caddy/Caddyfile`, a plain process/container restart can reintroduce the legacy matcher. A plain restart therefore does not reconcile the stale bind reference. The bounded next-step proposal is to recreate only the existing shared Caddy service/container from its canonical deployment definition so the bind mount is re-established against the current host source, then perform full regression verification. No write action was executed in this Gate.


## Gate: M2E-R2 Caddy Recreate Preflight — 2026-10-01

```text
GATE=M2E_R2_CADDY_RECREATE_PREFLIGHT
RESULT=PASS_CANDIDATE_M2E_R2_CADDY_RECREATE_PREFLIGHT
ACCESS_PATH=CANONICAL_STRICT_SSH
TARGET_HOST=srv1970241
REMOTE_USER=ops
SSH_LOCAL_TRUST_PREFLIGHT=PASS
SSH_NETWORK_INVOCATIONS=4
SSH_NATIVE_REMOTE_COMMAND_RESULTS=72,0,1,0

CADDY_CONTAINER_ID=793a5c8fbcd86d3c2b6dc0ba5a47e51de9d372957210efa0912523b8c1e7b9a2
CADDY_CONTAINER_NAME=/spikersun-edge-caddy-1
CADDY_STATE=running
CADDY_RESTART_COUNT=0
CADDY_DOCKER_HEALTHCHECK=NONE

CADDY_COMPOSE_PROJECT=spikersun-edge
CADDY_COMPOSE_SERVICE=caddy
CADDY_COMPOSE_WORKING_DIR=/srv/infra/edge
CADDY_CANONICAL_COMPOSE_PATH=/srv/infra/edge/compose.yaml
CADDY_COMPOSE_FILE_EXISTS=YES
DOCKER_SERVER_VERSION=29.8.0
DOCKER_COMPOSE_VERSION=5.5.1
CANONICAL_COMPOSE_QUIET_VALIDATION=PASS
CANONICAL_COMPOSE_SERVICES=caddy
CADDY_IMAGE_REFERENCE=caddy:2-alpine
CADDY_IMAGE_ID=sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648
LOCAL_IMAGE_TAG_ID_MATCH=PASS
CADDY_RESTART_POLICY=unless-stopped
CADDY_COMPOSE_RUNTIME_SEMANTICS=PASS
CADDY_PUBLISHED_PORTS=80/tcp,443/tcp
CADDY_NETWORKS=spikersun-edge
CADDY_MOUNTS=
bind:/srv/infra/edge/Caddyfile->/etc/caddy/Caddyfile:RO
bind:/srv/infra/edge/data->/data:RW
bind:/srv/infra/edge/config->/config:RW
CADDY_DATA_BIND_PATH_PRESENT=YES
CADDY_CONFIG_BIND_PATH_PRESENT=YES
CADDY_CERT_STATE_PERSISTENCE=PASS
CADDY_CONFIG_STATE_PERSISTENCE=PASS

HOST_CADDYFILE_BYTES=143
HOST_CADDYFILE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
HOST_CADDYFILE_MINICRAFT_MATCHER=ABSENT
PRE_RECREATE_CADDY_CONFIG_VALID=PASS
CADDY_HOST_CONFIG_ROUTE_SEMANTICS=edge-test.spikersun.com:static_response:200:30 bytes:SHA256 2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824;localhost:static_response:200:24 bytes:SHA256 cdb5952b737f70a8b3138bebd1aa34dc4d9fb99e759155745e1df01689897107
CADDY_ACTIVE_ADMIN_CONFIG_FRESH_READ=NOT_PERFORMED
CADDY_SERVICE_HEALTH=PASS_BY_RUNNING_STATE_AND_ORIGIN_REGRESSION

MINICRAFT_HOME_HTTP=200
MINICRAFT_HOME_TLS_VERIFY_RESULT=0
MINICRAFT_SHOP_HTTP=200
MINICRAFT_SHOP_TLS_VERIFY_RESULT=0
MINICRAFT_WP_REST_HTTP=200
MINICRAFT_WP_REST_TLS_VERIFY_RESULT=0
EDGE_TEST_PUBLIC_DNS=ABSENT_OR_UNRESOLVED
EDGE_TEST_DIRECT_ORIGIN_HTTP=200
EDGE_TEST_DIRECT_ORIGIN_TLS_VERIFY_RESULT=0
EDGE_TEST_DIRECT_ORIGIN_BODY_BYTES=30
EDGE_TEST_DIRECT_ORIGIN_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824

CADDY_RECREATE_COMMAND_PROPOSAL=sudo -n docker compose --project-name spikersun-edge --project-directory /srv/infra/edge -f /srv/infra/edge/compose.yaml up -d --no-deps --force-recreate --pull never --no-build caddy
RECREATE_SCOPE=CADDY_ONLY
PULL=NO
BUILD=NO
DEPENDENCY_RECREATE=NO
OTHER_SERVICE_RECREATE=NO
CADDY_RECREATE_AUTHORIZED=NO
CADDY_RECREATE_EXECUTED=NO

CADDY_RECREATE_FAILURE_RECOVERY_PLAN=Fresh-read container/service state first; no blind repeated recreate. In a separately authorized recovery Gate, use the same canonical Compose source to reconcile only caddy, preserve the 143-byte host Caddyfile and current image ID, then rerun Caddy/Tunnel/public regression; do not restore the stale 199-byte Mini Craft matcher or change Cloudflare/DNS/Tunnel.

PROBE_NOTES=Attempt 1 exited 72 because Docker inspect Go template requested absent optional State.Health; attempt 2 completed the full bounded collection. Attempt 3 exited 1 after directory metadata and quiet Compose validation because a supplemental parser invocation omitted its service argument; no Caddy Admin API facts are claimed. Attempt 4 confirmed local image tag ID equals running immutable image ID. All four SSH invocations used canonical strict options; failures were read-only command-construction errors.

CADDYFILE_WRITES=0
CADDY_RELOADS=0
CADDY_RESTARTS=0
CADDY_RECREATES=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
VPS_MUTATIONS=0
PAYMENT_ACTIONS=0
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

The current host Caddyfile validated successfully by streaming the host source read-only to the installed Caddy binary. Compose service semantics matched the running container for image reference/immutable image, TCP 80/443, `spikersun-edge`, all three bind mounts, and restart policy. `/srv/infra/edge/data` and `/srv/infra/edge/config` exist on the host root ext4 filesystem; the mounts therefore survive recreation of the Caddy container. Compose declares only the `caddy` service and no dependencies.

The public Mini Craft Tunnel checks passed with normal TLS verification. The Caddy `edge-test` hostname did not resolve in the current public DNS readback, so it was checked against the current public origin IP using a per-request `--resolve` override without disabling TLS verification; it returned the accepted 30-byte fingerprint. The `localhost` route was confirmed in the validated host Caddyfile semantic adaptation; no fresh Admin API read is claimed.

The recreate command above is a proposal only. It was not executed and remains unauthorized pending the Reviewer/Owner checkpoint.

## Gate: M2E-R3 Shared Caddy Recreate — 2026-10-01

```text
GATE=M2E_R3_SHARED_CADDY_RECREATE
RESULT=PASS_CANDIDATE_M2E_R3_SHARED_CADDY_RECREATE
OWNER_AUTHORIZATION=YES_ONE_BOUNDED_TRANSACTION
ACCESS_PATH=CANONICAL_STRICT_SSH
SSH_LOCAL_TRUST_PREFLIGHT=PASS
SSH_NETWORK_INVOCATIONS=4
PREFLIGHT_ASSERTION_ATTEMPT_1=READ_ONLY_EXIT_42_PORT_SORT_ORDER_ASSERTION_ONLY_NO_MUTATION
FRESH_PREWRITE_PREFLIGHT=PASS
TARGET_HOST=srv1970241
REMOTE_USER=ops
RECREATE_NATIVE_EXIT=0
CADDY_RECREATE_COUNT=1
CADDY_RECREATE_COMMAND=sudo -n docker compose --project-name spikersun-edge --project-directory /srv/infra/edge -f /srv/infra/edge/compose.yaml up -d --no-deps --force-recreate --pull never --no-build caddy

CADDY_OLD_CONTAINER_ID=793a5c8fbcd86d3c2b6dc0ba5a47e51de9d372957210efa0912523b8c1e7b9a2
CADDY_NEW_CONTAINER_ID=82749fff0bcea4538748dbb96d0d616b88617e3b4cc505a9fd70b61b6a789bb1
CADDY_CONTAINER_NAME=/spikersun-edge-caddy-1
POST_CADDY_STATE=running
POST_CADDY_RESTART_COUNT=0
POST_CADDY_IMAGE_ID=sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648
POST_CADDY_RESTART_POLICY=unless-stopped
POST_CADDY_PUBLISHED_PORTS=80/tcp,443/tcp
POST_CADDY_NETWORKS=spikersun-edge
POST_CADDY_MOUNTS=bind:/srv/infra/edge/Caddyfile->/etc/caddy/Caddyfile:RO;bind:/srv/infra/edge/data->/data:RW;bind:/srv/infra/edge/config->/config:RW

CANONICAL_COMPOSE_QUIET_VALIDATION=PASS
CANONICAL_COMPOSE_SERVICES=caddy
LOCAL_IMAGE_TAG_ID_MATCH=PASS
HOST_CADDYFILE_BYTES=143
HOST_CADDYFILE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
HOST_CADDYFILE_MINICRAFT_MATCHER=ABSENT
PRE_RECREATE_MOUNTED_CADDYFILE_BYTES=199
PRE_RECREATE_MOUNTED_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
PRE_RECREATE_MOUNTED_MINICRAFT_MATCHER=PRESENT
PRE_RECREATE_CADDY_CONFIG_VALID=PASS
POST_CONTAINER_CADDYFILE_BYTES=143
POST_CONTAINER_CADDYFILE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
POST_CONTAINER_MINICRAFT_MATCHER=ABSENT
POST_CADDY_CONFIG_VALID=PASS
CADDY_DATA_BIND_PRESENT=YES
CADDY_CONFIG_BIND_PRESENT=YES
CADDY_DATA_CONFIG_PERSISTENCE=PASS

OTHER_CONTAINER_COUNT_BEFORE=9
OTHER_CONTAINER_INVENTORY_SHA256_BEFORE=fedd477a7cc014763b0bc6dfa2af610b98f71ff802caf866dd136076ef0bf411
OTHER_CONTAINER_COUNT_AFTER=9
OTHER_CONTAINER_INVENTORY_SHA256_AFTER=fedd477a7cc014763b0bc6dfa2af610b98f71ff802caf866dd136076ef0bf411
OTHER_SERVICE_RECREATES=0
UNRELATED_CONTAINER_STATE_INVENTORY_UNCHANGED=YES

MINICRAFT_HOME_HTTP=200
MINICRAFT_HOME_TLS_VERIFY_RESULT=0
MINICRAFT_SHOP_HTTP=200
MINICRAFT_SHOP_TLS_VERIFY_RESULT=0
MINICRAFT_WP_REST_HTTP=200
MINICRAFT_WP_REST_TLS_VERIFY_RESULT=0
EDGE_TEST_DIRECT_ORIGIN_HTTP=200
EDGE_TEST_DIRECT_ORIGIN_TLS_VERIFY_RESULT=0
EDGE_TEST_DIRECT_ORIGIN_BODY_BYTES=30
EDGE_TEST_DIRECT_ORIGIN_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824

M2E_RESTART_PERSISTENCE=PASS
LEGACY_MINICRAFT_CADDY_ROUTE_REINTRODUCTION_RISK=RESOLVED
CADDYFILE_WRITES=0
CADDY_RELOADS=0
CADDY_RESTARTS=0
CADDY_RECREATES=1
OTHER_SERVICE_RECREATES=0
PULLS=0
BUILDS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
APPLICATION_MUTATIONS=0
DATABASE_MUTATIONS=0
PAYMENT_ACTIONS=0
BROAD_PRUNE=NO
SECRET_VALUES_EMITTED=0
M2E_FORMAL_PASS=PENDING_REVIEWER
STOP_AT_REVIEWER=YES
```

The first read-only preflight invocation stopped at a local assertion that compared port summaries in the wrong lexical order; no runtime write occurred. A complete fresh prewrite pass then matched the sealed baseline. The one authorized recreate returned native SSH exit 0. Fresh post-readback confirmed the container identity changed, while its immutable image ID and all sealed runtime semantics remained unchanged; the mounted startup Caddyfile now matches the host source byte-for-byte and validates without the retired Mini Craft matcher. Public Mini Craft and direct-origin edge-test checks passed with normal TLS verification. The bounded non-Caddy container inventory was identical before and after. No Cloudflare, DNS, Tunnel, application, database, payment, pull, build, or cleanup action occurred.


## M3A Caddy + Unified Pay Decommission Assessment — 2026-10-01

```text
GATE=M3A_CADDY_UNIFIED_PAY_DECOMMISSION_ASSESSMENT
RESULT=PASS_CANDIDATE_M3A_CADDY_UNIFIED_PAY_DECOMMISSION_ASSESSMENT
CURRENT_GATE_STATUS=AUTHORIZED_READONLY_ONLY
TARGET_HOST=srv1970241
REMOTE_USER=ops
REMOTE_UID=1000
STRICT_SSH_TARGET_IDENTITY=PASS
SSH_NATIVE_EXIT_ZERO_CALLS=3
SSH_NATIVE_EXIT_TWO_READONLY_COMMAND_SYNTAX_ERRORS=2
TARGET_HOST_EXECUTION_PROVEN=PASS
SUDO_NONINTERACTIVE=YES
DOCKER_READONLY_ACCESS=YES
```

### Authoritative sources read

- Canonical VPS Project Governance latest: Governance Handoff, Source Policy, v0.1.6, Storage Layout Contract, SSH / Delegated Secret Operations, Target Host Reality Contract, and Production Provider Canary and Recovery Contract.
- Shared VPS: `SHARED_VPS_HANDOFF.md`, current `REVIEWER_HANDOFF.md`, `SHARED_VPS_PORTFOLIO.md`, M3A Reviewer Decision, M3A Execution Packet, current `EXECUTION_EVIDENCE.md`, and `EXECUTOR_HANDOFF.md`.
- Unified Pay: current `REVIEWER_HANDOFF.md`, `PROJECT_STORAGE_MANIFEST.md`, `PROJECT_RECORD.md`, GitHub source-bundle directory listing, README, Dockerfile/bundle manifest metadata.
- Dujiao-Next, Xianyu, and Mini Craft current Reviewer Handoffs.

### Caddy dependency and retirement assessment

- Runtime: `/spikersun-edge-caddy-1`, container ID `82749fff0bcea4538748dbb96d0d616b88617e3b4cc505a9fd70b61b6a789bb1`, `running`, restart count 0; Compose project/service `spikersun-edge/caddy`, canonical file `/srv/infra/edge/compose.yaml`, image `caddy:2-alpine`.
- Caddy is the current host listener owner for 80/443. It is attached to `spikersun-edge`; the network currently has two endpoints (Caddy and Mini Craft WordPress). Current mounted host source is `/srv/infra/edge/Caddyfile`, 143 bytes, SHA-256 `f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358`.
- Caddy mounts `/srv/infra/edge/data -> /data` and `/srv/infra/edge/config -> /config` as persistent writable binds; Caddyfile is a read-only bind. Their contents, including certificate material, were not read.
- Caddy Compose quiet validation passed. Both adapted source config and active Admin config contain only two static-response routes: `edge-test.spikersun.com` (HTTP 200, 30-byte body) and `localhost` (HTTP 200, 24-byte body); no reverse-proxy upstream and no Mini Craft matcher. `edge-test.spikersun.com` did not resolve in the host-side public DNS check. Public Mini Craft is on its accepted direct Tunnel path, not Caddy.
- Existing M2E prewrite rollback Caddyfile remains present (199 bytes); no Caddy config or runtime change was made.
- No production application route was found in the current Caddy route set. However, the active diagnostic/test and localhost routes have no independently verified owner/consumer inventory. Therefore `CADDY_RETIREMENT_SAFE=UNRESOLVED`, not YES.

### Unified Pay, Dujiao, ingress and callers

- Unified Pay app and PostgreSQL are both running/healthy, restart count 0, with no host-published ports. Compose project/service source is `/srv/apps/unified-pay/docker-compose.prod.yml`. App is attached to `spikersun-private` (`unified-pay-app` alias) and `unified-pay-internal`; PostgreSQL is only on `unified-pay-internal`. Durable DB path is `/srv/data/unified-pay/db` (about 64 MiB); secret files remain under `/srv/data/unified-pay/secrets` and are mounted read-only. No secret contents or values were read.
- Public `pay.spikersun.com/health` and `/ready` both returned HTTP 200 with TLS verify result 0. Cloudflared is running on `spikersun-private` in remote-managed `tunnel run --token-file` mode. The exact Cloudflare public-hostname origin target was not available from the VPS-local metadata; no Cloudflare control-plane session/API read was performed. Therefore `UNIFIED_PAY_INGRESS_OWNER=CLOUDFLARE_REMOTE_MANAGED_TUNNEL; ORIGIN_TARGET=UNRESOLVED`.
- Unified Pay DB safe aggregates only: 2 active client records; 2 active, unrevoked client credentials; 1 production Alipay provider-account row (`active=true`, `enabled=false`, `activation_reviewed=true`); 1 payment intent in `created`; 1 provider-create attempt in `ambiguous` at 2026-09-14 16:45 UTC; 1 idempotency record. Provider events, provider payment facts, refunds, provider refund attempts, and outbox events each count 0. No IDs, payloads, URLs, amounts, or record contents were read.
- The two active client/credential pairs are registered caller principals; current simultaneous/live traffic was not measured. Thus `UNIFIED_PAY_ACTIVE_CALLERS=2_REGISTERED_ACTIVE_CLIENTS;LIVE_TRAFFIC=UNMEASURED`.
- Dujiao app/PostgreSQL/Redis are running/healthy with restart count 0. Dujiao app can reach the shared private network, but its current three payment channels are all inactive; `channel_clients=0`, `downstream_order_refs=0`. Safe aggregate historical DB counts: 34 orders (30 canceled, 2 completed, 2 fulfilling) and 20 payments (7 expired, 11 failed, 2 success). No Dujiao Compose/deployed-source reference to Unified Pay was found. The mounted `/srv/data/dujiao-next/secrets/config.yml` was intentionally not read, so the conclusion is no direct dependency evidence found, but absence is not fully proven: `DUJIAO_UNIFIED_PAY_DEPENDENCY=UNRESOLVED`.
- Xianyu is attached to `spikersun-private`; current Caddy config has no Xianyu matcher. Mini Craft M1–M2E migration is accepted complete, with production ingress direct through `spikersun-shared-private -> http://mini-craft-night-kit-wordpress:80`.

### Data, backup, Secret recovery and reconstruction

- `/srv/backups/unified-pay` contains 33 files: 13 database dumps (469,699 bytes total; newest file metadata 2026-09-14 17:45:28 UTC), 15 Compose snapshots (73,764 bytes total), and 5 other metadata files. The newest dump timestamp is later than the one current created/ambiguous intent-attempt timestamp, but backup contents were not read, hashes were not calculated, and no restore test was performed.
- GitHub canonical `unified-pay-system/` contains the Dockerfile, bundle manifest and 16 source-bundle fragments; the declared source archive SHA-256 is `653b511bd98595d0ad21fbb5729e1a41055a41c59f7b9c4c8b7ca21a791104a8`. The README describes these as reconstructible source material and states Provider Secrets are not in the source bundle. No bundle was downloaded or decoded.
- Current VPS secret source directory is present, but no separate protected Secret recovery artifact was found under the Unified Pay backup namespace. Owner-local protected recovery metadata was not independently verified. Database-backup existence and source reconstructibility do not establish a tested end-to-end recovery path.
- `UNIFIED_PAY_RUNTIME_RETIREMENT_SAFE=NO`: public ingress and two active registered caller principals remain; one payment intent/provider-create attempt is unresolved; exact Tunnel origin and Dujiao's secret-mounted runtime configuration are unproven.
- `UNIFIED_PAY_DATA_DELETION_SAFE=NO`: durable business/audit/client/provider state exists, including the unresolved intent; preserve DB, secrets and all backups.
- `UNIFIED_PAY_RECOVERY_BARRIER=UNRESOLVED`: DB dump and reconstructible code exist, but no restore test or independent protected Secret recovery proof is available.

### Minimum-risk phased retirement proposal (not executed)

1. Keep Caddy and Unified Pay running. Reviewer first resolves Caddy test-route ownership and the exact remote-managed `pay` Tunnel target.
2. In a separate read-only, metadata-only checkpoint, prove or disprove the two registered external client dependencies and Dujiao configuration without exposing secret values. Reconcile the single ambiguous provider-create/payment-intent state through an explicitly authorized read-only provider/local correlation; no replay.
3. Before any future runtime retirement, obtain a separately authorized and verified DB recovery artifact, preserve the exact source bundle/image/Compose and a protected Secret recovery path, and prove restore/restart recovery. Keep all existing backups.
4. If callers are proven absent and the ambiguous state is reconciled, use a new Owner-authorized Gate for a reversible app-runtime stop/observation while preserving PostgreSQL, DB, secrets, image, Compose and Tunnel rollback material. A separate Gate is required before any data/Secret/backup deletion.
5. Assess Caddy in its own bounded Gate after an explicit decision on `edge-test` and localhost consumers; preserve its current config and `/data`/`/config` state, then verify all non-Caddy ingress before any separately authorized stop.

### Mutation counters

```text
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
CADDY_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
DATABASE_WRITES=0
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_CONTENT_READS=0
BACKUP_DELETIONS=0
CLEANUP_OR_PRUNE_ACTIONS=0
MUTATIONS=0
STOP_AT_REVIEWER=YES
```


## M3B Caddy + Unified Pay Dependency Reconciliation — 2026-10-01

```text
GATE=M3B_CADDY_UNIFIED_PAY_DEPENDENCY_RECONCILIATION
RESULT=PASS_CANDIDATE_M3B_CADDY_UNIFIED_PAY_DEPENDENCY_RECONCILIATION
ACCESS_PATH=CANONICAL_STRICT_SSH
TARGET_HOST=srv1970241
REMOTE_USER=ops
CLOUDFLARE_DASHBOARD_CONTEXT=AUTHENTICATED_READONLY
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
CADDY_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
DATABASE_WRITES=0
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_OUTPUT=0
BACKUP_MUTATIONS=0
FILE_DELETIONS=0
NETWORK_MUTATIONS=0
BROAD_PRUNE=NO
```

### Unified Pay caller evidence

Fresh read-only PostgreSQL aggregates: 2 active registered clients and 2 active/unrevoked credentials. In the last 30 days, the audit table contained 2 payment-related events associated with 1 distinct client reference; latest event time was 2026-09-14T16:45:03Z. No request/client identity values were emitted. The app's available Docker log window contained one line, with no structured request records or caller fields; logs supplied no additional request counter.

```text
UNIFIED_PAY_REGISTERED_ACTIVE_CLIENTS=2
UNIFIED_PAY_LIVE_CALLERS=1
LIVE_CALLER_EVIDENCE=2 recent payment-related durable audit events; 1 distinct client reference; latest 2026-09-14T16:45:03Z
```

### Dujiao dependency

Fresh DB aggregates: 3 non-deleted payment channels, 0 active; 0 non-deleted channel_clients; 0 non-deleted downstream_order_refs. The current deployed Compose and non-secret active source search contained no Unified Pay/pay.spikersun.com reference. The mounted config at /srv/data/dujiao-next/secrets/config.yml was parsed in memory with a key/reference-only classifier; no Unified Pay reference was found and no values were emitted. The config file itself was not printed or persisted.

```text
DUJIAO_UNIFIED_PAY_DEPENDENCY=NO
DUJIAO_PAYMENT_CHANNELS_TOTAL=3
DUJIAO_PAYMENT_CHANNELS_ACTIVE=0
DUJIAO_CHANNEL_CLIENTS=0
DUJIAO_DOWNSTREAM_ORDER_REFS=0
DUJIAO_SECRET_CONFIG_REFERENCE=ABSENT
VALUE_OUTPUT=NO
```

### Cloudflare Tunnel pay route

Read from the authenticated Cloudflare dashboard's spikersun-shared-private route table and pay route details; no edits were made. The HTTP Host Header field was blank/default (no override). The same route table showed xianyu, pay, shop and canonical Mini Craft routes pointing directly to their app aliases.

```text
PAY_PUBLIC_HOST=pay.spikersun.com
PAY_TUNNEL=spikersun-shared-private
PAY_TUNNEL_ORIGIN=http://unified-pay-app:8080
PAY_TUNNEL_HTTP_HOST_HEADER=NONE
```

### Ambiguous provider-create state

Fresh local durable aggregate readback found one created payment intent and one provider-create attempt in ambiguous state (nonterminal); terminal create attempts=0. Provider events=0, provider payment facts=0, refunds=0 and outbox events=0. No already-established safe read-only provider query path was available, so no provider was contacted and the attempt remains unresolved.

```text
AMBIGUOUS_PAYMENT_STATE=UNRESOLVED
PAYMENT_INTENTS_CREATED=1
PROVIDER_CREATE_ATTEMPTS_AMBIGUOUS=1
PROVIDER_CREATE_ATTEMPTS_TERMINAL=0
PROVIDER_CREATE_ATTEMPTS_NONTERMINAL=1
PROVIDER_EVENTS=0
PROVIDER_PAYMENT_FACTS=0
REFUNDS=0
OUTBOX_EVENTS=0
```

### Caddy active-consumer reconciliation

Fresh runtime/config readback: Caddy is the only container publishing host ports 80/443; its host Caddyfile remains 143 bytes with SHA-256 f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358, contains the static edge-test.spikersun.com and localhost routes, and has no production reverse proxy. edge-test.spikersun.com currently has no public IPv4 DNS answer. No active Compose consumer, Caddy Admin healthcheck, or matching running-container healthcheck was found. Cloudflare Tunnel routes for production apps go directly to app aliases; Mini Craft's membership in spikersun-edge is network membership only.

One active consumer was found: enabled/active spikersun-infra-health.timer schedules spikersun-infra-health.service, whose current monitoring script probes https://localhost (default port 443). The one-shot service was inactive between runs at readback. An unscheduled Xianyu deploy helper also contains loopback default-port probes, but no active scheduler reference was found; it is not counted as a current active consumer.

```text
CADDY_ACTIVE_ROUTE_CONSUMERS=1
CADDY_PORT_80_443_ACTIVE_DEPENDENCIES=1
CADDY_ACTIVE_CONSUMER=spikersun-infra-health.timer -> check-shared-infra.sh -> HTTPS localhost:443
CADDY_RETIREMENT_SAFE=NO
CADDY_RETIREMENT_BLOCKER=active scheduled localhost HTTPS health probe
```

### Execution notes

Cloudflare was read-only; pay origin and route metadata were read back from the authenticated dashboard. Strict SSH local trust preflight matched the recorded client fingerprint and expected host-key pins; successful remote probes proved ops@srv1970241. Several initial read-only command attempts had shell/template parsing errors; no mutation occurred, and the facts above came from subsequent successful bounded read-only queries. No provider query was attempted. No source values, client IDs, names, credentials, request bodies or business identifiers were emitted.

## M3C Caddy + Unified Pay Retirement Blocker Closure — 2026-10-01

```text
GATE=M3C_CADDY_UNIFIED_PAY_RETIREMENT_BLOCKER_CLOSURE
RESULT=PASS_CANDIDATE_M3C_CADDY_UNIFIED_PAY_RETIREMENT_BLOCKER_CLOSURE
ACCESS_PATH=CANONICAL_STRICT_SSH
TARGET_HOST=srv1970241
REMOTE_USER=ops
SSH_NATIVE_EXIT=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
CADDY_MUTATIONS=0
MONITOR_CONFIG_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
DATABASE_WRITES=0
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_OUTPUT=0
BACKUP_MUTATIONS=0
FILE_DELETIONS=0
NETWORK_MUTATIONS=0
BROAD_PRUNE=NO
```

### Recent Unified Pay caller and ambiguous intent

Read-only aggregate SQL was executed through the running PostgreSQL container using its configured runtime DB role. No IDs, client names, transaction identifiers, amounts, payloads, credentials, or customer data were emitted.

```text
UNIFIED_PAY_REGISTERED_ACTIVE_CLIENTS=2 (accepted M3B baseline)
UNIFIED_PAY_LIVE_CALLERS=1
RECENT_PAYMENT_AUDIT_EVENTS=2
RECENT_DISTINCT_CLIENT_REFERENCES=1
LIVE_CALLER_CLASS=EXTERNAL_OR_UNKNOWN
LIVE_CALLER_LAST_ACTIVITY=2026-09-14T16:45:03Z
LIVE_CALLER_ACTIVITY_AFTER_AMBIGUOUS_WINDOW=NO
LIVE_CALLER_RETIREMENT_BLOCKER=YES
PAYMENT_INTENTS_CREATED=1
PAYMENT_INTENT_STATUS_COUNTS=created:1
PROVIDER_CREATE_ATTEMPTS_AMBIGUOUS=1
PROVIDER_CREATE_ATTEMPTS_TERMINAL=0
PROVIDER_EVENTS=0
PROVIDER_PAYMENT_FACTS=0
REFUNDS=0
OUTBOX_EVENTS=0
```

The two recent payment audit events were internally checked against the single ambiguous attempt's intent reference; both correlate to that same intent. Their precise event times straddle the attempt timestamp by milliseconds, but there is no independent/unlinked subsequent business event. Registration metadata did not safely map the caller to a known internal project or test/canary purpose, so it remains `EXTERNAL_OR_UNKNOWN`; the caller remains a retirement blocker. No raw registration identity was persisted.

### Provider inquiry decision

The deployed adapter/code safety screen found no proven isolated Alipay order/status inquiry path, no safe invocation boundary, and no demonstrated protected-credential reuse for such a query. Therefore the optional Provider inquiry was not called.

```text
PROVIDER_QUERY_PATH_PROVEN_READONLY=NO
PROVIDER_QUERY_PERFORMED=NO
PROVIDER_QUERY_COUNT=0
AMBIGUOUS_PAYMENT_STATE=UNRESOLVED
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
DATABASE_WRITES=0
```

The ambiguous provider-create remains unresolved; no create/retry/cancel/refund/replay was attempted.

### Caddy monitoring replacement design

Fresh read-only host metadata confirmed the enabled/active `spikersun-infra-health.timer` invokes the oneshot `spikersun-infra-health.service` on a 2-minute boot delay and 5-minute interval. The service is inactive between runs and its last result was successful. The root-owned mode-0750, 3330-byte script is `/srv/infra/monitoring/check-shared-infra.sh`; it uses fail-fast `set -e`, includes host/Docker/cloudflared/private-network checks, and has one Caddy-dependent `https://localhost:443` probe. It does not currently probe Mini Craft, Shop, or Pay public endpoints.

```text
CADDY_MONITOR_REPLACEMENT_PLAN=SEALED
CURRENT_CADDY_DEPENDENT_PROBE=https://localhost:443
REPLACEMENT_PROBES=target host/basic health; Docker daemon availability; cloudflared running/restart state; spikersun-private presence; Mini Craft public Home/Shop/wp-json over verified TLS; Shop public endpoint; Pay endpoint only while Unified Pay remains intentionally active
CADDY_DEPENDENT_PROBE_REMOVABLE=YES
MONITOR_ROLLBACK_METHOD=In a separately authorized monitor Gate, preserve exact pre-change allowlisted monitor files in the existing scoped recovery area, verify their hashes, restore those exact files on regression, and daemon-reload only if unit definitions changed; do not restart Caddy.
```

No timer, service, script, or Caddy configuration was changed.

### Unified Pay reversible stop/observe recovery barrier

Fresh read-only runtime/metadata readback confirmed:

- app: container `unified-pay-app-1`, Compose project `unified-pay`, service `app`, running/healthy, restart count 0, container ID `0a197a4aef43cea853da0501b3bb370910d60ab8fb6a164dac327ac6f435150e`;
- PostgreSQL: `unified-pay-db-1`, service `db`, running/healthy, restart count 0, container ID `eeb800570fd41e117a3cb788ef27977749de7f637f86e7379db4cf686547a120`;
- canonical Compose source `/srv/apps/unified-pay/docker-compose.prod.yml` exists (5271 bytes, mode 0644) and matches the runtime Compose labels;
- the current app image remains local: `sha256:78029ea23abde4a44ff4c51a176c549b1be81746e73f9cfe08dbda0550c901cc`;
- durable PostgreSQL bind data remains at `/srv/data/unified-pay/db`; project data, backup namespace, and secret-source mounts are present. Secret content was not read; mount metadata only showed 7 regular sources at mode 0640 and 2 directories at mode 0750, with no world access;
- the exact pay Tunnel route is carried forward from accepted M3B readback: `pay.spikersun.com -> spikersun-shared-private -> http://unified-pay-app:8080`, Host Header default/none. No Cloudflare change was made.

```text
UNIFIED_PAY_STOP_OBSERVE_ROLLBACK_READY=YES
ROLLBACK_RESTART_SOURCE=Compose=/srv/apps/unified-pay/docker-compose.prod.yml; project=unified-pay; service=app only; current app image locally present; PostgreSQL service/data retained
DATA_PRESERVATION_PLAN=SEALED
```

The future reversible observation boundary is app-only stop; preserve PostgreSQL, `/srv/data/unified-pay`, `/srv/backups/unified-pay`, mounted Secret sources, app image, Compose source, and Tunnel route. This Gate did not stop or restart any service and authorizes no later stop by itself.

```text
MUTATIONS=0
STOP_AT_REVIEWER=YES
```


## M3D Caddy Monitor Migration + Stop Observation — bounded preflight return — 2026-10-01

```text
GATE=M3D_CADDY_MONITOR_MIGRATION_AND_STOP_OBSERVATION
RESULT=RETURN_M3D_MONITOR_SIDE_EFFECTS_UNRESOLVED
ACCESS_PATH=CANONICAL_STRICT_SSH
TARGET_HOST=srv1970241
SSH_PRINCIPAL=ops@2.24.193.133:22
PRIVILEGED_READ_CONTEXT=sudo root
SSH_NATIVE_EXIT=0

MONITOR_TIMER_PATH=/etc/systemd/system/spikersun-infra-health.timer
MONITOR_TIMER_SHA256=e2ccc93decf36b667454f497b91be4e74fc83fce13ee18eb142f3495c6618164
MONITOR_TIMER_BYTES=206
MONITOR_TIMER_OWNER_MODE=root:root 0644
MONITOR_TIMER_STATE=active/enabled

MONITOR_SERVICE_PATH=/etc/systemd/system/spikersun-infra-health.service
MONITOR_SERVICE_SHA256=c2052ff5f6d24a53b22b94a82d5a3a74762079977c41adda80d4f106dc8900bd
MONITOR_SERVICE_BYTES=233
MONITOR_SERVICE_OWNER_MODE=root:root 0644
MONITOR_SERVICE_STATE=inactive/dead between runs; last result=success; last exit=0

MONITOR_SCRIPT=/srv/infra/monitoring/check-shared-infra.sh
MONITOR_SCRIPT_SHA256=cc466266a0f7de19badf7cbe6601a4cb01fc8b1ae661e1e68d6346e7ce29daf1
MONITOR_SCRIPT_BYTES=3330
MONITOR_SCRIPT_OWNER_MODE=root:root 0750

MONITOR_EXTERNAL_NOTIFICATION=NO
MONITOR_AUTO_REMEDIATION=NO
MONITOR_HTTP_POST_OR_PROVIDER_WRITE=NO
MONITOR_NONLOG_STATE_WRITES=YES
MONITOR_NONLOG_STATE_WRITE_DETAIL=script creates a temporary response-body file with mktemp under /tmp, directs the existing HTTPS probe body into it, and removes it with an EXIT trap; this is outside normal service logging
MONITOR_SIDE_EFFECT_SCREEN=BLOCKED

CADDY_STATE=running
CADDY_CONTAINER_ID=82749fff0bcea4538748dbb96d0d616b88617e3b4cc505a9fd70b61b6a789bb1
CADDY_CONTAINER_NAME=/spikersun-edge-caddy-1
CADDY_RESTART_COUNT=0
CADDY_IMAGE_ID=sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648
CADDYFILE_BYTES=143
CADDYFILE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358

CLOUDFLARED_RUNNING_COUNT=1
SPIKERSUN_PRIVATE_PRESENT=YES

PREFLIGHT_MINICRAFT_HOME=HTTP_200_TLS_VERIFY_0
PREFLIGHT_MINICRAFT_SHOP=HTTP_200_TLS_VERIFY_0
PREFLIGHT_MINICRAFT_WP_REST=HTTP_200_TLS_VERIFY_0
PREFLIGHT_SHOP_HOME=HTTP_200_TLS_VERIFY_0

ROLLBACK_COPY_CREATED=NO
MONITOR_SCRIPT_MUTATION=0
MANUAL_MONITOR_RUN=NOT_STARTED
SCHEDULED_MONITOR_RUNS=0
CADDY_STOP_ACTIONS=0
CADDY_DELETIONS=0
UNIFIED_PAY_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
DATABASE_WRITES=0
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
DOCKER_MUTATIONS=0
VPS_RUNTIME_MUTATIONS=0
SECRET_VALUES_OUTPUT=0
BROAD_PRUNE=NO
STOP_AT_REVIEWER=YES
```

The bounded side-effect review found no mail/chat/webhook notification, HTTP POST/provider write, or service/container remediation command. It did find the temporary-file create/write/remove lifecycle above. Because the Gate requires a clean pre-write side-effect screen and calls out non-logging state writes, execution stopped before creating a rollback copy or changing the monitor. Caddy remains running; no timer, service, monitoring file, Unified Pay, or production endpoint was changed. Initial public baseline was healthy with normal TLS verification.

## Gate: M3D_R1_ALLOW_EPHEMERAL_TMP_AND_RESUME — 2026-10-01

```text
GATE=M3D_R1_ALLOW_EPHEMERAL_TMP_AND_RESUME
RESULT=PASS_CANDIDATE_M3D_R1_CADDY_MONITOR_MIGRATION_AND_STOP_OBSERVATION
TARGET_HOST=srv1970241
MONITOR_EXTERNAL_NOTIFICATION=NO
MONITOR_AUTO_REMEDIATION=NO
MONITOR_HTTP_POST_OR_PROVIDER_WRITE=NO
MONITOR_EPHEMERAL_TMPFILE_LIFECYCLE=ALLOWED
PERSISTENT_STATE_SIDE_EFFECT=NO

MONITOR_SOURCE_PATH=/srv/infra/monitoring/check-shared-infra.sh
MONITOR_SOURCE_SHA256_BEFORE=cc466266a0f7de19badf7cbe6601a4cb01fc8b1ae661e1e68d6346e7ce29daf1
MONITOR_ROLLBACK_PATH=/srv/backups/shared-infra/m3d-r1-monitor-prechange-20261001T091248Z.sh
MONITOR_ROLLBACK_SHA256=cc466266a0f7de19badf7cbe6601a4cb01fc8b1ae661e1e68d6346e7ce29daf1
MONITOR_SOURCE_BYTES_BEFORE=3330
MONITOR_ROLLBACK_BYTES=3330
MONITOR_SOURCE_OWNER_MODE=root:root:0750
MONITOR_ROLLBACK_OWNER_MODE=root:root:0750
MONITOR_ROLLBACK_COPY_VERIFIED=YES

MONITOR_SOURCE_SHA256_AFTER=2e28085921c3a5c930dc40144db3e6717438e10696af7f6b3f63f2ccec31a7cf
MONITOR_SOURCE_BYTES_AFTER=3872
MONITOR_SOURCE_OWNER_MODE_AFTER=root:root:0750
MONITOR_SYNTAX_VALIDATION=PASS
CADDY_DEPENDENT_CHECKS_REMOVED=2
PUBLIC_TLS_PROBES_ADDED=4
MONITOR_CLOUDFLARED_RESTART_STATE_CHECK=ADDED
MONITOR_PRIVATE_NETWORK_CHECK=ADDED
MONITOR_MANUAL_RUN_BEFORE_STOP=PASS
MONITOR_MANUAL_RUN_CADDY_STOPPED=PASS
MONITOR_SCHEDULED_RUNS_PASS_BEFORE_STOP=2
MONITOR_SCHEDULED_RUN_TIMES_BEFORE_STOP=2026-10-01T09:21:45Z,2026-10-01T09:26:55Z
MONITOR_SCHEDULED_RUNS_PASS_CADDY_STOPPED=1
MONITOR_SCHEDULED_RUN_TIME_CADDY_STOPPED=2026-10-01T09:31:59Z
MONITOR_SCHEDULED_RUNS_PASS=3
MONITOR_TIMER_STATE=active
MONITOR_SERVICE_LAST_RESULT=success
MONITOR_SERVICE_LAST_EXIT=0

CADDY_CONTAINER_ID=82749fff0bcea4538748dbb96d0d616b88617e3b4cc505a9fd70b61b6a789bb1
CADDY_CONTAINER_NAME=/spikersun-edge-caddy-1
CADDY_IMAGE_ID=sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648
CADDY_STATE=stopped
CADDY_CONTAINER_PRESENT=YES
CADDY_IMAGE_PRESENT=YES
CADDY_RESTART_COUNT=0
CADDY_STOPPED_AT=2026-10-01T09:28:10Z
CADDY_DELETIONS=0
PUBLIC_MINICRAFT_HOME=HTTP_200_TLS_VERIFY_0
PUBLIC_MINICRAFT_SHOP=HTTP_200_TLS_VERIFY_0
PUBLIC_MINICRAFT_WP_REST=HTTP_200_TLS_VERIFY_0
PUBLIC_SHOP_ENDPOINT=HTTP_200_TLS_VERIFY_0
PUBLIC_TUNNEL_REGRESSION=PASS
CLOUDFLARED_STATE=running
CLOUDFLARED_RESTART_COUNT=0
SPIKERSUN_PRIVATE=PRESENT

UNIFIED_PAY_MUTATIONS=0
PAYMENT_ACTIONS=0
DATABASE_WRITES=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
TIMER_UNIT_MUTATIONS=0
SERVICE_UNIT_MUTATIONS=0
DOCKER_MUTATIONS=1
VPS_MUTATIONS=3
SECRET_VALUES_OUTPUT=0
BROAD_PRUNE=NO
STOP_AT_REVIEWER=YES
```

Only the authorized health-check script was changed; one pre-change rollback copy was created in the existing Shared Infrastructure backup scope. The shared Caddy container was stopped once and retained with its image and all configuration/data. No Cloudflare, DNS, Tunnel, Unified Pay, provider, database, payment, timer/service-unit, or unrelated service changes were made. The monitor's existing mktemp/EXIT-trap response-body lifecycle remains unchanged and is accepted as ephemeral-only.

## Gate: M3E_CADDY_RUNTIME_DECOMMISSION — 2026-10-01

```text
GATE=M3E_CADDY_RUNTIME_DECOMMISSION
RESULT=PASS_CANDIDATE_M3E_CADDY_RUNTIME_DECOMMISSION
OWNER_AUTHORIZES_M3E=YES
TARGET_HOST=srv1970241
SSH_USER=ops
SSH_CANONICAL_TRUST_PREFLIGHT=PASS
SSH_NATIVE_EXIT=0
TARGET_HOST_EXECUTION_PROVEN=PASS
READ_ONLY_PREFLIGHT_ATTEMPT_1=ABORTED_PRIVILEGED_CONTEXT_CHECK_ERROR
READ_ONLY_PREFLIGHT_ATTEMPT_1_MUTATIONS=0
READ_ONLY_PREFLIGHT_CONTEXT_CORRECTION=SSH_USER_VERIFIED_BEFORE_SUDO
PREDELETE_FRESH_PREFLIGHT=PASS

CADDY_CONTAINER_ID=82749fff0bcea4538748dbb96d0d616b88617e3b4cc505a9fd70b61b6a789bb1
CADDY_CONTAINER_NAME=/spikersun-edge-caddy-1
CADDY_STATE_BEFORE=stopped
CADDY_CONTAINER_PRESENT_BEFORE=YES
CADDY_IMAGE_ID=sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648
CADDY_IMAGE_PRESENT_BEFORE=YES
CADDY_COMPOSE_SOURCE_PRESENT_BEFORE=YES
CADDYFILE_PRESENT_BEFORE=YES
CADDY_DATA_PRESENT_BEFORE=YES
CADDY_CONFIG_PRESENT_BEFORE=YES
SPIKERSUN_EDGE_PRESENT_BEFORE=YES
MONITOR_ROLLBACK_COPY=/srv/backups/shared-infra/m3d-r1-monitor-prechange-20261001T091248Z.sh
MONITOR_ROLLBACK_COPY_PRESENT_BEFORE=YES
MONITOR_ROLLBACK_SHA256=cc466266a0f7de19badf7cbe6601a4cb01fc8b1ae661e1e68d6346e7ce29daf1
CLOUDFLARED_STATE_BEFORE=running
SPIKERSUN_PRIVATE_BEFORE=PRESENT
MONITOR_LAST_RESULT_BEFORE=success

CADDY_CONTAINER_REMOVE_AUTHORIZED=YES_EXACTLY_ONE
CADDY_CONTAINER_REMOVE_ACTIONS=1
CADDY_CONTAINER_REMOVE_METHOD=EXACT_VERIFIED_CONTAINER_ID
CADDY_CONTAINER_REMOVE_NATIVE_EXIT=0
CADDY_CONTAINER_PRESENT=NO
CADDY_IMAGE_PRESENT=YES
CADDY_COMPOSE_SOURCE_PRESENT=YES
CADDYFILE_PRESENT=YES
CADDY_DATA_PRESENT=YES
CADDY_CONFIG_PRESENT=YES
SPIKERSUN_EDGE_PRESENT=YES
MONITOR_ROLLBACK_COPY_AFTER=PRESENT
CADDY_RECREATE_PATH_PRESERVED=YES

PUBLIC_MINICRAFT_HOME=HTTP_200_TLS_VERIFY_0
PUBLIC_MINICRAFT_SHOP=HTTP_200_TLS_VERIFY_0
PUBLIC_MINICRAFT_WP_REST=HTTP_200_TLS_VERIFY_0
PUBLIC_SHOP_ENDPOINT=HTTP_200_TLS_VERIFY_0
PUBLIC_TUNNEL_REGRESSION=PASS
MONITOR_MANUAL_RUN=PASS
CLOUDFLARED_STATE_AFTER=running
CLOUDFLARED_RESTART_COUNT_AFTER=0
SPIKERSUN_PRIVATE_AFTER=PRESENT

CADDY_IMAGE_DELETE_ACTIONS=0
CADDY_CONFIG_DELETE_ACTIONS=0
CADDY_DATA_DELETE_ACTIONS=0
CADDYFILE_DELETE_ACTIONS=0
COMPOSE_DELETE_ACTIONS=0
SPIKERSUN_EDGE_DELETE_ACTIONS=0
UNIFIED_PAY_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
DATABASE_WRITES=0
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_OUTPUT=0
BACKUP_MUTATIONS=0
BROAD_PRUNE=NO
DOCKER_MUTATIONS=1
VPS_MUTATIONS=1
STOP_AT_REVIEWER=YES
```

The only consequential action was removal of the already-stopped, freshly identified Caddy container by its exact ID. It was absent on read-back. Its image, canonical Compose source, Caddyfile, data/config directories, shared edge network and the verified monitor rollback copy remain present. Public Tunnel routes and the migrated monitor both passed after removal. No Caddy recreate/rollback was needed; Unified Pay and all other services were untouched.