# Reviewer Decision — K6R2 Hostinger Control-Plane Fallback

Date: 2026-09-23
Status: AUTHORIZED
Parent:
- K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY
- Executor commit fe0c5910bbce8d8858ef5273b0d808d2dfa2cac3

Supersedes for current execution:
- docs/REVIEWER_DECISION_K6R2_OWNER_HOSTINGER_CONSOLE_CHECK.md

## Reviewer correction

The previous Owner Web/Serial Console checkpoint was safe but not owner-minimal.

Canonical Governance requires minimizing Owner technical operation. Historical Shared VPS work normally required no Owner terminal operation because the governed SSH transport remained available.

Current Hostinger capabilities provide a better intermediate recovery path:

- official Hostinger Connector / MCP supports OpenAI Codex;
- it can authenticate through a browser OAuth flow without asking the Owner to paste API keys into chat;
- its VPS tools expose provider control-plane facts including VM state/details, metrics, firewall, SSH public-key metadata, action history, Docker Compose projects/containers and related VPS state.

Therefore, before asking the Owner to use a terminal, attempt a provider-control-plane read-only fallback through the official Hostinger Connector/MCP.

This does NOT replace the governed SSH transport for secret-safe shell deployment. It is only a read-only recovery/diagnostic path unless a later Reviewer Gate explicitly authorizes a Hostinger control-plane write.

## Current Gate

GATE=K6R2_HOSTINGER_CONTROL_PLANE_FALLBACK

## A. Governance / safety

Read canonical:
- entropy-student/spike.skill/vps-project-governance/SKILL.md
- GOVERNANCE_HANDOFF.md
- references/SSH_AND_DELEGATED_SECRET_OPERATIONS.md
- references/TARGET_HOST_REALITY_CONTRACT.md
- references/STORAGE_LAYOUT_CONTRACT.md

Read current Mini Craft:
- REVIEWER_HANDOFF.md
- PROJECT_RECORD.md
- PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY.md
- this Decision

Do not replay the failed SSH probe in this Gate.

## B. Official Hostinger Connector/MCP bootstrap

First inspect whether the official Hostinger Connector/MCP is already available/authenticated in the local Codex environment.

Preferred official control plane:
Hostinger Connector / Hostinger API MCP.

Do not use an unofficial third-party Hostinger MCP.

If already connected:
- reuse the existing authenticated session;
- do not request a new token.

If not connected:
1. verify Node >= 20;
2. install/configure only the official Hostinger Connector/MCP following Hostinger's current official instructions;
3. prefer OAuth/browser sign-in;
4. never ask Owner to paste API token into chat/GitHub;
5. never print cached OAuth credentials/tokens.

If browser authorization is required:
RETURN_OWNER_HOSTINGER_CONNECTOR_LOGIN_REQUIRED

Owner action must be only:
complete the Hostinger browser sign-in/consent opened by the official Connector on the same machine.

No terminal commands are required from Owner.

After Owner confirms login, resume the same Gate; do not restart earlier SSH Gates.

If connector bootstrap cannot be established without unsafe credential handling:
RETURN_REVIEWER_HOSTINGER_CONNECTOR_UNAVAILABLE

## C. Provider-control-plane read-only inventory

Once authenticated, use read-only Hostinger VPS tools only.

Required control-plane facts:

1. List VPS instances and identify the expected Shared VPS without guessing.
2. Read VM details:
   - power/status;
   - hostname/IP metadata as available;
   - OS/template metadata as available;
   - provider-side status.
3. Read recent metrics:
   - CPU;
   - memory;
   - disk;
   - network;
   - uptime.
4. Read provider firewall state/rules relevant to the VM and especially TCP/22.
5. Read attached SSH public-key metadata and compare the expected public identity metadata where possible.
6. Read recent VPS action history for provider-side restart/recovery/firewall/key events.
7. Read Hostinger Docker Manager project list.
8. Read known project/container state for existing Shared VPS projects, sufficient to establish whether Docker/control-plane guest integration is alive.

Prefer tools equivalent to:
- VPS_getVirtualMachinesV1
- VPS_getVirtualMachineDetailsV1
- VPS_getMetricsV1
- VPS_getFirewallListV1 / VPS_getFirewallDetailsV1
- VPS_getAttachedPublicKeysV1
- VPS_getActionsV1
- VPS_getProjectListV1
- VPS_getProjectContainersV1 / VPS_getProjectContentsV1 where read-only and useful

Discover exact installed tool names rather than inventing calls.

## D. Prohibited Hostinger actions

This Gate is READ-ONLY.

Do NOT call:
- start/stop/restart VM;
- recovery mode start/stop;
- recreate VM;
- root-password reset;
- hostname change/reset;
- firewall activate/deactivate/create/update/delete/sync;
- SSH key create/attach/delete;
- Docker project create/update/delete;
- backup restore;
- snapshot restore/delete;
- DNS mutation;
- any billing/purchase action.

HOSTINGER_CONTROL_PLANE_WRITES=0

## E. Classification

Return one of:

### 1. CONTROL_PLANE_HEALTHY_SSH_PATH_ISOLATED

Use when:
- expected VPS is Running;
- metrics/uptime show current guest activity;
- provider firewall allows TCP/22 or does not show a provider-side 22 block;
- expected attached SSH key metadata is intact where observable;
- Docker Manager can read current existing projects/containers;
- no recent provider action explains a host replacement/recreate;
- SSH remains separately known to close pre-host-key from K6R1.

Then:
- do not ask Owner to use terminal yet;
- return to Reviewer for a bounded Shared Infra SSH-service repair decision.

### 2. PROVIDER_FIREWALL_OR_CONTROL_PLANE_BLOCK_PROVEN

Use only when Hostinger read-back directly proves a provider-side block relevant to SSH.

Return to Reviewer. Do not fix it in this Gate.

### 3. VPS_NOT_RUNNING_OR_PROVIDER_STATE_ABNORMAL

Use if provider control plane proves the VM is stopped, failed, in recovery, provisioning, or another abnormal state.

Return to Reviewer. Do not start/restart automatically.

### 4. HOST_RECREATE_OR_IDENTITY_EVENT_DETECTED

Use if provider history indicates recreate/reinstall/identity-changing event since the last accepted host truth.

Return to Reviewer. Do not trust old host-key pins or attach keys automatically.

### 5. CONTROL_PLANE_INSUFFICIENT_FOR_GUEST_SSH_SERVICE

Use if provider state is healthy but API/Connector cannot determine the guest ssh/sshd state and Docker Manager does not provide enough evidence.

Return to Reviewer. Only then may a one-click Hostinger Web Console/Agent checkpoint be considered.

### 6. CONNECTOR_UNAVAILABLE

Return if the official connector cannot be safely authenticated/used.

## F. Important interpretation

Provider-control-plane evidence is not the same as guest-shell evidence.

Do not claim:
SSH_SERVICE=ACTIVE
or
PORT_22_OS_LISTENING=YES

unless a tool directly proves that guest fact.

It is valid to prove:
- VPS Running;
- provider firewall;
- uptime/metrics;
- Hostinger Docker Manager responsiveness;
- current Compose projects;
- attached public-key metadata;
- provider action history.

These facts may be enough to isolate the fault domain without Owner terminal work.

## G. Future deployment note

Do not change the K6 deployment architecture in this Gate.

Hostinger Docker Manager can be considered as a future auxiliary read/control plane, but it must not silently replace the governed SSH deployment path because:
- K6 has secret-bearing WordPress/MariaDB restore requirements;
- ordinary tool arguments/evidence must not expose DB/PayPal/application Secrets;
- any alternative deployment transport requires a separate Reviewer architecture/security decision.

## Return

GATE=K6R2_HOSTINGER_CONTROL_PLANE_FALLBACK
RESULT=<PASS_CANDIDATE_K6R2_HOSTINGER_CONTROL_PLANE_FALLBACK | RETURN_OWNER_HOSTINGER_CONNECTOR_LOGIN_REQUIRED | RETURN_REVIEWER_HOSTINGER_CONNECTOR_UNAVAILABLE | RETURN_REVIEWER_PROVIDER_FIREWALL_OR_CONTROL_PLANE_BLOCK | RETURN_REVIEWER_VPS_PROVIDER_STATE_ABNORMAL | RETURN_REVIEWER_HOST_RECREATE_OR_IDENTITY_EVENT | RETURN_REVIEWER_CONTROL_PLANE_INSUFFICIENT_FOR_GUEST_SSH_SERVICE | RETURN_REVIEWER_*>
SUMMARY=
HOSTINGER_OFFICIAL_CONNECTOR=
CONNECTOR_ALREADY_AVAILABLE=
CONNECTOR_AUTH_STATE=
OWNER_BROWSER_LOGIN_REQUIRED=
EXPECTED_VPS_IDENTIFIED=
VPS_PROVIDER_STATE=
VPS_DETAILS=
VPS_METRICS=
VPS_UPTIME=
PROVIDER_FIREWALL_STATE=
PROVIDER_TCP22_STATE=
ATTACHED_SSH_KEY_METADATA=
RECENT_VPS_ACTION_HISTORY=
HOSTINGER_DOCKER_MANAGER=
DOCKER_PROJECT_LIST=
EXISTING_PROJECTS_PROVIDER_READBACK=
SSH_FAILURE_DOMAIN_CLASSIFICATION=
HOSTINGER_CONTROL_PLANE_WRITES=0
VPS_POWER_ACTIONS=0
FIREWALL_WRITES=0
SSH_KEY_WRITES=0
DOCKER_PROJECT_WRITES=0
RECOVERY_MODE_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
EVIDENCE=
COMMIT=
OWNER_ACTION=<NONE | COMPLETE_HOSTINGER_CONNECTOR_BROWSER_LOGIN>
NEXT=STOP_AT_REVIEWER

Do not retry SSH in this Gate.
Do not ask Owner to use a terminal in this Gate.
