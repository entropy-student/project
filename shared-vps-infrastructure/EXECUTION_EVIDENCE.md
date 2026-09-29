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
