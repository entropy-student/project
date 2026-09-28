# Reviewer Decision — K9B-R2R2A RETURN / Target Access Recovery Before Canary Containment

Date: 2026-09-29
Role: Reviewer / Architect / Gatekeeper

## Reviewed execution

Accepted:

- Evidence commit: `531fbbc099a1fe2643c5105b1174445de16e967d`
- Executor Handoff commit: `3c77363597bff96f2d3a4e5b3fce28170adf6f31`

## Formal reconciliation

```text
K9B_R2R2A_PRODUCT_1224_PUBLIC_EXPOSURE_CONTAINMENT=RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE

SSH_NETWORK_INVOCATIONS=2
SSH_NATIVE_EXIT=255_BOTH
REMOTE_OUTPUT_RECEIVED=NO
REMOTE_IDENTITY=UNPROVEN
SSH_HOST_KEY_MATCH=UNPROVEN

PRODUCT_1224_STATUS_WRITE_ATTEMPTED=NO
VPS_APPLICATION_MUTATION=0
LOCAL_FILESYSTEM_MUTATION=0
LOCAL_DOCKER_MUTATION=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
```

The RETURN is correct under Target Host Reality Contract rev2.

The production web application remains reachable, but the SSH execution boundary is not currently proven. No fallback write through an unauthenticated/public application surface is allowed.

## Current safety state

```text
PUBLIC_ORIGIN_HEALTH=PASS_HTTP_200
PUBLIC_SHOP_CONTAINS_1224=NO
UNAUTHENTICATED_STORE_API_SEARCH_RETURNS_1224=YES

PRODUCT_1224_CONTAINMENT=NOT_COMPLETE
REAL_COMMERCE_ENABLED=NO
SOFT_LAUNCH_AUTHORIZED=NO

LOCAL_K9B_CLEANUP=PAUSED
K9C_AUTHORIZED=NO
```

## Next Gate

```text
CURRENT_GATE=K9B_R2R2A_R1_TARGET_HOST_ACCESS_RECOVERY
CURRENT_GATE_STATUS=AUTHORIZED_READONLY_TRANSPORT_DIAGNOSTICS
REMOTE_APPLICATION_WRITE_AUTHORIZED=NO
LOCAL_CLEANUP_AUTHORIZED=NO
```

Goal: determine why the previously validated strict SSH path is now closing before target identity, and restore a trustworthy target-host execution boundary without changing production state.

## Diagnostic scope

Read-only diagnostics may inspect:

- local SSH client version;
- exact configured target alias/host/user/port metadata without credential values;
- local private-key public fingerprint only;
- explicit known_hosts entry metadata / fingerprint;
- DNS resolution where applicable;
- TCP reachability to the configured SSH port;
- one bounded SSH handshake diagnostic attempt after local checks;
- comparison with the last accepted strict SSH connection parameters in project Evidence.

Do not expose:
- private key contents;
- Secret values;
- passwords/tokens;
- raw verbose SSH logs containing unnecessary local/private metadata.

Evidence should record only the normalized failure class.

## Bounded retry rule

Do not loop.

Maximum new network SSH attempts in this Gate:

`2`

Suggested sequence:

1. TCP/transport reachability + local config/key/known-host metadata;
2. one strict identity-only SSH attempt;
3. only if failure class materially changes or a safe local configuration mismatch is corrected, one final strict identity-only attempt.

No remote mutation commands.

## Safe local corrections

A correction is allowed only when fresh evidence proves the problem is local and non-secret, for example:

- wrong local target alias resolution;
- wrong explicitly selected public key file path while the correct previously accepted key remains present;
- malformed command-line quoting;
- stale local non-secret SSH invocation parameters inconsistent with accepted project Evidence.

Do not:
- disable StrictHostKeyChecking;
- accept a new unknown host key automatically;
- replace/delete known_hosts entries without Reviewer/Owner checkpoint;
- change VPS SSH daemon/firewall;
- rotate keys;
- edit authorized_keys;
- use passwords from chat.

Any host-key mismatch or unknown new host key returns immediately.

## PASS condition

Only if a strict identity-only connection proves:

```text
REMOTE_IDENTITY=ops@srv1970241
STRICT_HOST_KEY_MATCH=PASS
NATIVE_EXIT=0
TARGET_HOST_EXECUTION_PROVEN=PASS
```

may this access-recovery Gate PASS.

Do not perform Product 1224 mutation inside R1. After Reviewer PASS, the original containment Gate is resumed separately.

## If SSH remains unavailable

Return one precise class:

```text
RETURN_K9B_R2R2A_R1_SSH_TRANSPORT_UNAVAILABLE
RETURN_K9B_R2R2A_R1_HOST_KEY_MISMATCH
RETURN_K9B_R2R2A_R1_LOCAL_SSH_CONFIGURATION_UNRESOLVED
```

and stop.

If transport remains unavailable, Reviewer may move to an Owner-local checkpoint using Hostinger console or an authenticated WordPress Admin session. Such a fallback must be separately authorized and must still produce bounded read-back evidence.

## WordPress Admin boundary

An unauthenticated redirect to the login page is not a usable execution boundary.

Do not:
- enter Owner credentials on the Owner's behalf;
- request credentials in chat;
- bypass authentication;
- use public Store API to mutate state.

## Evidence

Persist:

```text
GATE=K9B_R2R2A_R1_TARGET_HOST_ACCESS_RECOVERY
LOCAL_SSH_CLIENT=
LOCAL_TARGET_CONFIG_MATCHES_ACCEPTED_BASELINE=
LOCAL_KEY_PUBLIC_FINGERPRINT_MATCH=
LOCAL_KNOWN_HOST_METADATA_MATCH=
SSH_TCP_REACHABILITY=
SSH_NETWORK_ATTEMPTS=
SSH_FAILURE_CLASS=
REMOTE_IDENTITY=
STRICT_HOST_KEY_MATCH=
TARGET_HOST_EXECUTION_PROVEN=
PRODUCTION_MUTATIONS=0
LOCAL_CLEANUP_MUTATIONS=0
STOP_AT_REVIEWER=YES
```

Do not enter K9C and do not resume K9B cleanup automatically.
