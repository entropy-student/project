# Reviewer Decision — K6 D-R6R1 RETURN Accepted; D-R6R2 Remote Identity Reconciliation + D-R6 Resume

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed result

```text
GATE=K6_PHASE_D_R6R1_SSH_TRANSPORT_RECOVERY_AND_BOOTSTRAP_RESUME
RESULT=RETURN_REVIEWER_D_R6R1_REMOTE_IDENTITY_PROBE_INVALID
EVIDENCE_COMMIT=9e2e0f2169e203e60c680e9d3a9e6ec64668c511
HANDOFF_COMMIT=a2200a26506ca7ee67f501afab1c8ce9902d0df6
```

Reviewer accepts the RETURN as correct and fail-closed.

## Accepted SSH facts

D-R6R1 proved:

```text
LOCAL_IDENTITY_REFERENCE_CHECK=PASS
LOCAL_PUBLIC_FINGERPRINT_MATCH=PASS
LOCAL_KNOWN_HOSTS_PIN_CHECK=PASS
SSH_NATIVE_EXIT=0
SSH_FAILURE_CLASS=NONE
SSH_HOST_KEY_PRESENTED=YES
SSH_HOST_KEY_MATCH=YES
SSH_AUTHENTICATED_TARGET=ops@2.24.193.133
REMOTE_HOSTNAME=srv1970241
REMOTE_WRITES=0
```

Therefore the earlier SSH transport failure is recovered.

The only failed assertion was the remote-identity helper implementation: it explicitly looked up UID 0 and therefore reported root instead of checking the effective unprivileged SSH session user.

This is an Executor probe defect, not evidence of SSH account drift.

Formal disposition:

```text
SSH_TRANSPORT_RECOVERED=YES
SSH_TRUST=PASS
REMOTE_HOSTNAME=PASS_srv1970241
REMOTE_LOGIN_IDENTITY=REQUIRES_CORRECT_PRE_SUDO_PROBE
HOSTINGER_OWNER_ACTION=NONE
```

## Current Gate

```text
CURRENT_GATE=K6_PHASE_D_R6R2_REMOTE_IDENTITY_RECONCILIATION_AND_BOOTSTRAP_RESUME
OWNER_ACTION=NONE
```

## Phase A — correct remote identity proof

Use the same canonical strict SSH contract:

- ops@2.24.193.133:22
- recorded identity
- explicit normal known_hosts
- BatchMode=yes
- IdentitiesOnly=yes
- StrictHostKeyChecking=yes
- bounded timeout

At the very beginning of the remote payload, **before any sudo and before entering any sudo-owned wrapper/subshell/helper**:

1. run `whoami`;
2. run `id -un`;
3. run `id -u`;
4. run `hostname`.

These four commands must execute as the authenticated SSH session itself. Do not prefix them with `sudo`, do not evaluate them inside a root shell, and do not derive the login identity from UID 0 metadata. Emit only the bounded identity markers needed for Evidence.

Require:

```text
whoami=ops
id -un=ops
id -u != 0
hostname=srv1970241
```

Only after this exact identity proof passes may the payload use `sudo -n` for the already-authorized read-only/container/DB checks.

If the pre-sudo identity is not `ops`, RETURN immediately:

`RETURN_REVIEWER_D_R6R2_REMOTE_IDENTITY_MISMATCH`

No alternate identity/trust/account.

## Conditional D-R6 resume

If Phase A passes, continue the already-authorized D-R6 workflow in the same Gate without another Reviewer round-trip:

1. fresh readiness:
   - WordPress + MariaDB running;
   - zero host ports;
   - WordPress restart count stable;
   - runtime core present;
   - MariaDB healthy;
   - root/app exact 52-table set;
   - `wp_options` exists;
   - no unrelated/shared-infra drift;
2. bounded WordPress bootstrap;
3. WordPress installed-state true;
4. no PHP fatal;
5. before any scalar DB write, use the existing application DB credential through the already-reviewed tmpfs-only client-option pattern; Secret values must not enter argv/env/logs;
6. lock/read exactly the two `wp_options` rows `home` and `siteurl` and require exact cardinality=2;
7. accepted pre-state is either:
   - both values = `http://localhost:8093`; or
   - both values already = `https://minicraft.spikersun.com`.
   A mixed or unexpected pre-state -> `RETURN_REVIEWER_D_R6R2_ORIGIN_STATE_DRIFT` before write;
8. if both are already target, perform no write and record `HOME_SITEURL_SCALAR_UPDATE=ALREADY_TARGET_NO_WRITE`;
9. otherwise update exactly those two rows inside one DB transaction, verify both exact target values before commit, then commit. Any pre-commit mismatch/nonzero -> rollback and RETURN;
10. no broad search/replace and no serialized-field mutation;
11. private/internal route validation:
   - /
   - /shop/
   - /product/mini-craft-night-kit/
   - /cart/
   - /checkout/
   - /my-account/
   - /wp-json/
12. verify wp-content/media state;
13. verify WooCommerce core state;
14. verify PayPal remains Sandbox and Live disabled using boolean/state metadata only; do not emit provider credentials/options;
15. verify WordPress restart count stable and recent fatal classification clean;
16. retain:
   `FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`.

## SSH invocation scope

The new Gate authorizes one fresh canonical strict SSH session/invocation for identity proof plus the conditional D-R6 resume payload.

The SSH wrapper must retain only a local temporary stderr diagnostic long enough to classify failure, then remove it within the same bounded wrapper; raw stderr is not committed.

If transport fails before any DB write:
- record redacted classification;
- RETURN;
- do not use alternate key/account/trust;
- do not retry inside this Gate.

If transport becomes ambiguous after the scalar DB transaction may have begun or committed, return:
`RETURN_REVIEWER_D_R6R2_REMOTE_WRITE_OUTCOME_AMBIGUOUS`

Do not retry or attempt a compensating write. The next Reviewer Gate must first perform read-only reconciliation.

## Hard boundaries

No:
- alternate SSH identity/account/trust;
- SSH/UFW/server mutation;
- WordPress recreate/restart;
- MariaDB import/retry/drop/recreate;
- wp-content restore;
- image pull/build;
- broad SQL replacement;
- full serialized URL migration;
- Caddy/cloudflared/DNS/UFW/Docker-daemon/shared-network mutation;
- host port/public ingress;
- following redirects out to the public Internet during private-route validation;
- Secret content/hash/rotation/overwrite;
- PayPal Live/payment/refund;
- unrelated project changes.

## RETURN semantics

Any RETURN -> stop immediately. No post-return remote cleanup/lifecycle action.

## Success contract

```text
PASS_CANDIDATE_K6_PHASE_D_R6R2_REMOTE_IDENTITY_RECONCILIATION_AND_BOOTSTRAP_RESUME
SSH_NATIVE_EXIT=0
SSH_HOST_KEY_MATCH=PASS
REMOTE_PRE_SUDO_WHOAMI=ops
REMOTE_PRE_SUDO_ID_UN=ops
REMOTE_PRE_SUDO_UID_NONZERO=PASS
REMOTE_HOSTNAME=srv1970241
D_R6_READINESS=PASS
WORDPRESS_BOOTSTRAP=PASS
WORDPRESS_INSTALLED_STATE=PASS
HOME_SITEURL_ROW_CARDINALITY=2
HOME_SITEURL_PRESTATE=LOCAL_OR_ALREADY_TARGET
HOME_SITEURL_SCALAR_UPDATE=PASS_OR_ALREADY_TARGET_NO_WRITE
HOME_SITEURL_TRANSACTION=PASS
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_PRIVATE_PRIMARY_ROUTES=PASS_PRIVATE_NO_PUBLIC_FOLLOW
WP_CONTENT_MEDIA_STATE=PASS
WOOCOMMERCE_CORE_STATE=PASS
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO
DB_PUBLIC_PORT=NONE
WORDPRESS_HOST_PORT=NONE
PUBLIC_INGRESS_CHANGE=0
UNRELATED_SERVICES_CHANGED=NO
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

This Gate does not authorize full serialized migration or public ingress.
