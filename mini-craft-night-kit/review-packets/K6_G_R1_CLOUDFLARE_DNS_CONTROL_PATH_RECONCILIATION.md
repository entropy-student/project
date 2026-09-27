# K6 Phase G-R1 — Cloudflare DNS Control Path Reconciliation

Gate:
K6_PHASE_G_R1_CLOUDFLARE_DNS_CONTROL_PATH_RECONCILIATION

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_G_R1_CLOUDFLARE_DNS_CONTROL_PATH_RECONCILIATION.md
- latest accepted Evidence/Handoff

## Goal

Using the already logged-in official Cloudflare Dashboard session, prove read-only access and future exact create/delete capability for the Mini Craft DNS-only A record.

No mutation.

## A — zone

Open exact zone:
spikersun.com

Navigate:
DNS -> Records

Require authenticated access.

## B — exact record absence

Search exact hostname:
minicraft.spikersun.com

Require:
- A absent
- AAAA absent
- CNAME absent

Do not expose unrelated DNS inventory.

## C — create UI proof

Open Add record UI without saving.

Prove available:
- Type A
- Name field suitable for minicraft
- IPv4 address field
- Proxy status control with DNS only

Do not submit.

Cancel/close.

## D — rollback UI proof

Without deleting any record, prove record-specific edit/delete controls exist.

Future exact record selector:
ZONE=spikersun.com
TYPE=A
NAME=minicraft.spikersun.com
TARGET=2.24.193.133

Internal record ID preferred if naturally surfaced, but exact unique tuple is acceptable for browser-dashboard rollback.

## Forbidden

No DNS create/update/delete, account/zone/security changes, token pages, API key view/create, cookie/session inspection, SSH/VPS/Caddy/indexing/payment actions.

## Success

PASS_CANDIDATE_K6_PHASE_G_R1_CLOUDFLARE_DNS_CONTROL_PATH_RECONCILIATION

Return:
CLOUDFLARE_DASHBOARD_SESSION=AUTHENTICATED
CLOUDFLARE_ZONE_ACCESS=PASS
CLOUDFLARE_ZONE=spikersun.com
DNS_RECORDS_PAGE_ACCESS=PASS
AUTHENTICATED_ZONE_MINICRAFT_A=ABSENT
AUTHENTICATED_ZONE_MINICRAFT_AAAA=ABSENT
AUTHENTICATED_ZONE_MINICRAFT_CNAME=ABSENT
DNS_CREATE_UI_AVAILABLE=YES
DNS_A_RECORD_TYPE_AVAILABLE=YES
DNS_ONLY_PROXY_MODE_AVAILABLE=YES
TARGET_IPV4_FIELD_AVAILABLE=YES
DNS_EXACT_RECORD_DELETE_UI_AVAILABLE=YES
DNS_ROLLBACK_SELECTOR=EXACT_ZONE_TYPE_NAME_TARGET
DNS_ROLLBACK_DETERMINISM=PASS
DNS_EXECUTION_PATH=PASS_AUTHENTICATED_CLOUDFLARE_DASHBOARD
DNS_CREDENTIAL_EXPOSURE=0
DNS_MUTATIONS=0
SSH_NETWORK_INVOCATIONS=0
VPS_WRITES=0
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
STOP_AT_REVIEWER=YES

Otherwise precise RETURN_*.
