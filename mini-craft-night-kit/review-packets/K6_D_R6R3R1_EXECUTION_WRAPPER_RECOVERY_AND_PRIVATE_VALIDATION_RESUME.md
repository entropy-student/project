# K6 D-R6R3R1 — Execution-Wrapper Recovery + Private Validation Resume

Gate:
`K6_PHASE_D_R6R3R1_EXECUTION_WRAPPER_RECOVERY_AND_PRIVATE_VALIDATION_RESUME`

Authority:
- canonical GitHub `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_D_R6R3_RETURN_D_R6R3R1_WRAPPER_RECOVERY_AND_RESUME.md`;
- prior D-R6R3 Decision/Pack;
- latest Evidence/Handoff;
- unique current Shared VPS Handoff.

## Objective

Seal the local PowerShell/native wrapper before it can consume another SSH attempt, then resume only the two unresolved read-only D-R6R3 checks.

## Accepted facts

Do not rerun restore/bootstrap/origin-write work. D-R6R2 accepted facts remain valid absent material drift.

## Phase 0 — local wrapper seal (no network)

Use the same PowerShell/native invocation mechanism intended for SSH.

### Test 0A

Run a local native process that intentionally emits:
- stdout marker `WRAPPER_STDOUT_OK`;
- stderr marker `WRAPPER_STDERR_OK`;
- exit code 7.

Require:
- stdout marker captured;
- stderr marker captured;
- native exit exactly 7 captured.

If any missing:
`RETURN_REVIEWER_D_R6R3R1_LOCAL_WRAPPER_UNSEALED`

No SSH afterward.

### Test 0B

Run the exact OpenSSH executable with `-V`, locally only.

Require:
- version output observable;
- native exit observable and expected-success.

If missing:
`RETURN_REVIEWER_D_R6R3R1_LOCAL_WRAPPER_UNSEALED`

No SSH afterward.

Do not use an opaque execution helper that cannot surface native exit status.

## Phase A — one network SSH invocation

Only after Phase 0 PASS.

Use exact canonical strict SSH contract.

Exactly one network SSH invocation/session.

At remote payload start, pre-sudo:
- `whoami`;
- `id -un`;
- `id -u`;
- `hostname`.

Require:
- ops;
- ops;
- UID nonzero;
- srv1970241.

Capture:
- native exit;
- bounded stdout;
- redacted stderr class.

Never commit raw stderr.
No second SSH attempt.

## Phase B — minimal continuity

Read-only only:
- WordPress running;
- MariaDB healthy;
- restart count stable;
- runtime core present;
- no WordPress/DB host ports;
- home/siteurl both target;
- no Mini Craft public ingress;
- unrelated shared baseline unchanged.

No full 52-table/bootstrap/wp-content/WooCommerce rerun absent material drift.

## Phase C — Checkout

One private anonymous request only.

No cart setup/mutation.
No order/payment.
No redirect following.
No sensitive session output.

Record:
- status;
- safe redirect target: relative path or scheme+host+path.

PASS:
- 2xx; or
- expected 3xx to Cart, relative or same canonical origin.

Otherwise:
`RETURN_REVIEWER_D_R6R3R1_CHECKOUT_REDIRECT_UNRESOLVED`.

## Phase D — PPCP state

Prefer the same accepted K3R9/K3R11 read-only state path.

If it is unavailable:
- inspect PPCP 4.1.3 source read-only;
- locate authoritative environment/merchant/onboarding state getter;
- query only needed state;
- filter in memory.

Evidence output only:
- PPCP_ACTIVE
- PPCP_MERCHANT_CONNECTED
- PPCP_SANDBOX_ENABLED
- PPCP_ONBOARDING_COMPLETED
- PPCP_LIVE_ENABLED

PASS:
YES / YES / YES / YES / NO.

No Provider call.
No reconnect.
No settings write.
No credentials/raw option dump.

## Phase E — close D-R6 private validation

If all PASS:
- WORDPRESS_PRIVATE_APP_VALIDATION=PASS
- D_R6_PRIVATE_RUNTIME_VALIDATION=PASS
- PAYPAL_SANDBOX_LOCAL_CONFIG_STATE=PASS
- FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED

Then STOP_AT_REVIEWER.

## Forbidden

No remote writes, DB writes, lifecycle actions, cart/session setup, order/payment/refund, PPCP mutation, Provider call, Secret value/hash, serialized migration, public ingress, Shared Infra or unrelated-project mutation.

## Evidence

```text
LOCAL_WRAPPER_STDOUT_CAPTURE=
LOCAL_WRAPPER_STDERR_CAPTURE=
LOCAL_WRAPPER_NATIVE_NONZERO_EXIT_CAPTURE=
LOCAL_OPENSSH_VERSION_CAPTURE=
LOCAL_OPENSSH_VERSION_NATIVE_EXIT=
SSH_NATIVE_EXIT=
SSH_HOST_KEY_MATCH=
REMOTE_IDENTITY=
WORDPRESS_RUNTIME_CONTINUITY=
WORDPRESS_RESTART_COUNT=
MARIADB_HEALTH=
HOME_SITEURL_READBACK=
WORDPRESS_HOST_PORT=NONE
DB_PUBLIC_PORT=NONE
CHECKOUT_PRIVATE_STATUS=
CHECKOUT_REDIRECT_TARGET=
CHECKOUT_EMPTY_CART_BEHAVIOR=
PPCP_STATE_READ_METHOD=
PPCP_ACTIVE=
PPCP_MERCHANT_CONNECTED=
PPCP_SANDBOX_ENABLED=
PPCP_ONBOARDING_COMPLETED=
PPCP_LIVE_ENABLED=
WORDPRESS_PRIVATE_APP_VALIDATION=
D_R6_PRIVATE_RUNTIME_VALIDATION=
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
REMOTE_WRITES=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
LOCAL_TEMP_CLEANUP=
STOP_AT_REVIEWER=YES
```

Success:
`PASS_CANDIDATE_K6_PHASE_D_R6R3R1_EXECUTION_WRAPPER_RECOVERY_AND_PRIVATE_VALIDATION_RESUME`

Otherwise precise `RETURN_*`.

Do not continue to serialized migration or public ingress.
