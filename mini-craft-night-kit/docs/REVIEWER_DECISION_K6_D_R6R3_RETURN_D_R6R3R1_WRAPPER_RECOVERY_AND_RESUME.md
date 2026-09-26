# Reviewer Decision — K6 D-R6R3 RETURN Accepted; D-R6R3R1 Execution-Wrapper Recovery + Read-only Resume

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed result

```text
GATE=K6_PHASE_D_R6R3_PRIVATE_APP_VALIDATION_RECONCILIATION
RESULT=RETURN_REVIEWER_D_R6R3_EXECUTOR_RESULT_UNAVAILABLE
EVIDENCE_COMMIT=4f5ecf700658702f397bc193f0db3783e677cf56
HANDOFF_COMMIT=a01c0197ebea8ba40f5380c480ddf54e7f3f6d3d
```

Reviewer accepts the RETURN as correct and fail-closed.

## Classification

The submitted remote payload contained only read-only operations:

- identity/runtime/container/network metadata;
- read-only WordPress option comparisons;
- one private Checkout GET with redirect following disabled;
- allowlisted PPCP state extraction.

It contained:

```text
REMOTE_WRITE_COMMANDS_IN_SUBMITTED_PAYLOAD=0
DB_WRITES=0
LIFECYCLE_ACTIONS=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
```

Therefore the unavailable execution result does not create a consequential-write ambiguity and does not require rollback or remote reconciliation before a fresh read-only attempt.

The failure is classified as:

`LOCAL_EXECUTION_WRAPPER_OBSERVABILITY_FAILURE`

It is not evidence of SSH, VPS, WordPress, MariaDB, Checkout or PPCP state drift.

## Accepted carry-forward state

All D-R6R2 facts previously accepted by Reviewer remain accepted. D-R6R3 did not supersede them because it produced no fresh remote result.

Do not repeat completed restore/bootstrap/origin-write work.

## Current Gate

```text
CURRENT_GATE=K6_PHASE_D_R6R3R1_EXECUTION_WRAPPER_RECOVERY_AND_PRIVATE_VALIDATION_RESUME
OWNER_ACTION=NONE
```

## Phase 0 — local execution-wrapper seal

Before consuming any SSH network attempt, prove that the local execution path can observe native process output and exit status.

Run two local, non-network, non-secret tests through the **same PowerShell/native execution mechanism** intended for the SSH call:

### A. stdout/stderr/nonzero canary

Use a local native process that deliberately emits:
- one known stdout marker;
- one known stderr marker;
- native exit code 7.

Require all three to be captured distinctly enough to classify the result.

### B. OpenSSH binary capture

Run local `ssh.exe -V` (or the exact canonical OpenSSH executable's version command) without contacting a host.

Require:
- OpenSSH version output is observable;
- native exit code is observable and equals the expected successful version-command exit.

Do not proceed to SSH unless both local tests PASS.

If either fails:

`RETURN_REVIEWER_D_R6R3R1_LOCAL_WRAPPER_UNSEALED`

No SSH invocation is permitted after that failure.

## Phase A — one canonical strict SSH invocation

Only after Phase 0 PASS.

Use the existing canonical SSH contract:
- `ops@2.24.193.133:22`;
- recorded identity;
- explicit normal known_hosts;
- `BatchMode=yes`;
- `IdentitiesOnly=yes`;
- `StrictHostKeyChecking=yes`;
- bounded timeout/keepalive.

Exactly one network SSH invocation/session is authorized.

The wrapper must synchronously retain:
- native exit code;
- bounded stdout;
- bounded stderr classification.

Raw stderr must not be committed. No retry inside the Gate.

At remote payload start, before sudo:
- `whoami=ops`;
- `id -un=ops`;
- UID nonzero;
- `hostname=srv1970241`.

If SSH transport fails, return a precise transport classification. Do not treat a local wrapper failure as a host failure.

## Phase B — resume D-R6R3 read-only continuity

Perform only the minimal continuity checks from D-R6R3:

- WordPress running;
- MariaDB running/healthy;
- WordPress restart count stable;
- runtime core present;
- no host-published WordPress/DB ports;
- read-only `home/siteurl` both equal `https://minicraft.spikersun.com`;
- no public Mini Craft ingress;
- no unrelated/shared material drift.

Do not repeat full 52-table inventory, bootstrap, wp-content or WooCommerce core validation absent material drift.

## Phase C — Checkout redirect reconciliation

Perform one private anonymous Checkout request:

- no add-to-cart;
- no intentional session/cart mutation;
- no order/payment action;
- no redirect following;
- no Cookie/session/order-key output.

Record only HTTP status and safe redirect scheme/host/path.

PASS:
- 2xx; or
- 3xx to relative Cart route or same canonical origin Cart route.

Historical accepted project baseline is empty-cart Checkout -> Cart.

Unresolved/unexpected redirect:
`RETURN_REVIEWER_D_R6R3R1_CHECKOUT_REDIRECT_UNRESOLVED`.

## Phase D — authoritative PPCP state read-back

Reuse the accepted K3R9/K3R11 read-only PPCP state path where practical.

If unavailable:
- inspect installed PPCP 4.1.3 source read-only;
- identify the plugin's authoritative environment/merchant/onboarding getter/service/REST state path;
- query only the required state;
- filter any returned structure in memory.

Evidence allowlist only:

```text
PPCP_ACTIVE
PPCP_MERCHANT_CONNECTED
PPCP_SANDBOX_ENABLED
PPCP_ONBOARDING_COMPLETED
PPCP_LIVE_ENABLED
```

PASS target:

```text
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_ONBOARDING_COMPLETED=YES
PPCP_LIVE_ENABLED=NO
```

No Provider call, settings write, reconnect/onboarding action, credential output/hash or raw settings dump.

Material current drift:
`RETURN_REVIEWER_D_R6R3R1_PPCP_STATE_DRIFT`.

Cannot prove state without Secret exposure/mutation:
`RETURN_REVIEWER_D_R6R3R1_PPCP_MODE_READBACK_UNAVAILABLE`.

## Phase E — closure

If all phases PASS:

```text
WORDPRESS_PRIVATE_APP_VALIDATION=PASS
D_R6_PRIVATE_RUNTIME_VALIDATION=PASS
PAYPAL_SANDBOX_LOCAL_CONFIG_STATE=PASS
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
```

Stop at Reviewer.

## Hard boundaries

No:
- remote write of any kind;
- DB write/origin rewrite;
- WordPress/MariaDB restart/recreate;
- DB restore/import/reset;
- wp-content rewrite;
- cart/session mutation for test setup;
- order/payment/capture/refund;
- PPCP connect/reconnect/settings/onboarding mutation;
- Provider API call;
- Secret content/hash output;
- serialized migration;
- Shared Infra/public ingress mutation;
- unrelated project change.

## Success contract

```text
PASS_CANDIDATE_K6_PHASE_D_R6R3R1_EXECUTION_WRAPPER_RECOVERY_AND_PRIVATE_VALIDATION_RESUME
LOCAL_WRAPPER_STDOUT_CAPTURE=PASS
LOCAL_WRAPPER_STDERR_CAPTURE=PASS
LOCAL_WRAPPER_NATIVE_NONZERO_EXIT_CAPTURE=PASS_EXPECTED_7
LOCAL_OPENSSH_VERSION_CAPTURE=PASS
LOCAL_OPENSSH_VERSION_NATIVE_EXIT=PASS
SSH_NATIVE_EXIT=0
REMOTE_IDENTITY=ops@srv1970241
WORDPRESS_RUNTIME_CONTINUITY=PASS
MARIADB_HEALTH=PASS
HOME_SITEURL_READBACK=PASS_TARGET
CHECKOUT_EMPTY_CART_BEHAVIOR=PASS
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_ONBOARDING_COMPLETED=YES
PPCP_LIVE_ENABLED=NO
WORDPRESS_PRIVATE_APP_VALIDATION=PASS
D_R6_PRIVATE_RUNTIME_VALIDATION=PASS
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
REMOTE_WRITES=0
PAYMENT_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

A PASS_CANDIDATE does not authorize serialized migration or public ingress.
