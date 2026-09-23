# Reviewer Decision — K6R2R1 Fresh Codex Hostinger Tool-Surface Reload

Date: 2026-09-23
Status: AUTHORIZED
Parent: K6R2_HOSTINGER_CONTROL_PLANE_FALLBACK
Executor return: 62c31f76d3755100fc0121092bd33f38cfd5004c

## Reviewer finding

Historical Shared VPS evidence confirms the original/working access path was direct governed SSH from the Owner Windows machine:

- remote: ops@2.24.193.133:22
- identity: C:\Users\34707\.ssh\xianyu_hostinger_codex_ed25519
- known_hosts: C:\Users\34707\.ssh\known_hosts
- BatchMode=yes
- IdentitiesOnly=yes
- UserKnownHostsFile=<recorded known_hosts>
- StrictHostKeyChecking=yes
- Docker commands via sudo -n docker

The latest K6R1 probe used the same connection contract and still failed before host-key presentation. Therefore no SSH command correction is currently identified.

K6R2 then successfully registered/authenticated the official Hostinger remote MCP in local Codex configuration, but the active Executor session did not hot-refresh its callable tool inventory.

This Gate isolates the session/tool-surface issue before any Owner console work.

## Current Gate

GATE=K6R2R1_FRESH_CODEX_HOSTINGER_TOOL_SURFACE

## Required execution context

Run this Gate in a FRESH Codex execution session created after the official Hostinger MCP registration/OAuth completion.

Do not repeat installation or OAuth if the fresh session reports the official Hostinger MCP already configured/authenticated.

Do not retry SSH in this Gate.

## Phase A — tool-surface check

Read:
- canonical VPS Governance latest;
- Mini Craft REVIEWER_HANDOFF.md;
- PROJECT_RECORD.md;
- PROJECT_STORAGE_MANIFEST.md;
- docs/REVIEWER_DECISION_K6R2_HOSTINGER_CONTROL_PLANE_FALLBACK.md;
- this decision.

Then inspect the fresh session's callable MCP/tool inventory.

Required decision:

1. If official Hostinger VPS/API read tools are now exposed:
   continue the K6R2 provider-control-plane read-only inventory exactly as previously authorized.

2. If the fresh session still exposes only Hostinger AI Builder or no Hostinger VPS/API tools:
   return:
   RETURN_REVIEWER_HOSTINGER_VPS_TOOL_SURFACE_UNAVAILABLE

Do not re-register the MCP repeatedly.
Do not use an unofficial MCP.
Do not read OAuth cache/token files.
Do not build a manual REST client around cached credentials.

## Phase B — if tools are exposed

Use only read-only Hostinger VPS/API tools:
- list VPS;
- identify expected VPS;
- VM details/status;
- metrics/uptime;
- provider firewall/22 state;
- attached SSH public-key metadata;
- recent action history;
- Docker project/container readback.

No provider writes.

## Interpretation

The fresh-session test is a tooling availability check, not a VPS configuration change.

If it succeeds, it can isolate the SSH failure domain without Owner terminal work.

If it fails again, the zero-touch Hostinger control-plane route is exhausted for the current toolchain. Reviewer will then decide between:
- waiting/retrying the already-proven SSH path after a bounded interval; or
- one minimal Hostinger console check.

## Return

GATE=K6R2R1_FRESH_CODEX_HOSTINGER_TOOL_SURFACE
RESULT=<PASS_CANDIDATE_K6R2R1_FRESH_CODEX_HOSTINGER_TOOL_SURFACE | RETURN_REVIEWER_HOSTINGER_VPS_TOOL_SURFACE_UNAVAILABLE | RETURN_REVIEWER_*>
SUMMARY=
FRESH_CODEX_SESSION=YES
OFFICIAL_HOSTINGER_MCP_CONFIGURED=
OFFICIAL_HOSTINGER_MCP_AUTH=
HOSTINGER_VPS_READ_TOOLS_EXPOSED=
VPS_PROVIDER_READS=
EXPECTED_VPS_IDENTIFIED=
VPS_PROVIDER_STATE=
VPS_METRICS=
PROVIDER_TCP22_STATE=
ATTACHED_SSH_KEY_METADATA=
RECENT_VPS_ACTION_HISTORY=
HOSTINGER_DOCKER_MANAGER=
DOCKER_PROJECT_LIST=
SSH_FAILURE_DOMAIN_CLASSIFICATION=
HOSTINGER_CONTROL_PLANE_WRITES=0
VPS_POWER_ACTIONS=0
FIREWALL_WRITES=0
SSH_KEY_WRITES=0
DOCKER_PROJECT_WRITES=0
SSH_RETRIES=0
EVIDENCE=
COMMIT=
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER
