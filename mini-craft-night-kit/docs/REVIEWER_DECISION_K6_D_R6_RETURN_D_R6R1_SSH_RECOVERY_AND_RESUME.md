# Reviewer Decision — K6 D-R6 RETURN Accepted; D-R6R1 SSH Recovery + Conditional Resume

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed result

```text
GATE=K6_PHASE_D_R6_BOOTSTRAP_RECONCILIATION_AND_PRIVATE_APP_VALIDATION
RESULT=RETURN_SSH_CONNECTION_REQUIRED
EVIDENCE_COMMIT=39a3027ad1959412c211eec23a1c5d58f341050f
HANDOFF_COMMIT=3d79f81519fe4a134bb39d513c393bfa2cfed075
REMOTE_WRITES=0
```

Reviewer accepts the RETURN as correct and fail-closed.

Local SSH contract checks passed:

```text
IDENTITY_REFERENCE_CHECK=PASS
PUBLIC_FINGERPRINT_MATCH=PASS
KNOWN_HOSTS_PIN_CHECK=PASS
```

The canonical strict SSH invocation exited 255, but stderr was not retained, so the failure class is unknown and remote Phase A cannot be claimed.

No application/database/Secret/Shared Infra mutation occurred.

## Classification

This is currently:

`SSH_CONNECTION_REQUIRED / UNCLASSIFIED_TRANSPORT_FAILURE`

It is not evidence of:
- host-key drift;
- identity/key drift;
- application failure;
- database failure;
- Shared VPS topology drift.

The same governed SSH path has repeatedly succeeded in earlier accepted Gates.

## Current Gate

```text
CURRENT_GATE=K6_PHASE_D_R6R1_SSH_TRANSPORT_RECOVERY_AND_BOOTSTRAP_RESUME
OWNER_ACTION=NONE
```

## Phase A — one canonical strict SSH recovery attempt

Do not redesign the connection layer.

1. Re-read current Shared VPS Handoff and canonical SSH Governance.
2. Reverify locally:
   - identity reference exists;
   - public fingerprint matches;
   - known_hosts pins match.
3. Run exactly one canonical strict SSH attempt using:
   - ops@2.24.193.133:22;
   - recorded identity;
   - explicit normal known_hosts;
   - BatchMode=yes;
   - IdentitiesOnly=yes;
   - StrictHostKeyChecking=yes;
   - bounded ConnectTimeout/ServerAlive settings.
4. Capture stderr only to a local non-secret temporary diagnostic sink.
5. Retain in Evidence only a redacted failure classification and native exit code; do not publish verbose paths, private-key data, tokens, credentials or unrelated environment data.
6. Do not use another account/key/client/trust policy.
7. Do not relax host-key verification.

### If SSH succeeds

Require:
- host key matches recorded pin;
- remote identity = `ops@srv1970241`.

Then continue Phase B in the same Gate.

### If SSH exits 255 again

Classify from filtered stderr:

- actual presented host-key mismatch -> `RETURN_SSH_TRUST_DRIFT`;
- TCP/connect timeout/refused/no route/pre-hostkey close/auth transport failure -> `RETURN_OWNER_HOSTINGER_CONSOLE_CHECK_REQUIRED`;
- otherwise `RETURN_OWNER_HOSTINGER_CONSOLE_CHECK_REQUIRED`.

Do not perform a second retry.

Owner action, only if returned:
- confirm VPS is Running in Hostinger;
- via provider web/serial console report only:
  - ssh/sshd active/inactive;
  - port 22 listening/not listening;
  - immediately visible provider/network block if any.
- no reboot/firewall/sshd/key change unless later authorized.

## Phase B — resume D-R6 only after SSH recovery

If and only if strict SSH succeeds:

1. run the original D-R6 fresh no-write readiness checks;
2. verify:
   - WordPress + MariaDB running;
   - zero host ports;
   - WordPress restart count stable;
   - runtime core present;
   - MariaDB healthy;
   - root/app each see exact expected 52 tables;
   - `wp_options` exists;
   - no public ingress/unrelated-service drift;
3. run bounded WordPress bootstrap + installed-state checks;
4. only after bootstrap PASS, update exactly scalar `home` and `siteurl`;
5. validate private primary routes, wp-content/media, WooCommerce core state and PayPal Sandbox state;
6. retain:
   `FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`.

All original D-R6 prohibitions remain in force.

## Hard boundaries

No:
- alternate SSH trust/key/account;
- SSH/UFW/server mutation;
- WordPress recreate/restart;
- MariaDB import/retry/reset;
- wp-content restore;
- image pull/build;
- broad SQL replacement;
- serialized migration;
- public ingress;
- Secret content/hash/rotation/overwrite;
- PayPal Live/payment/refund;
- unrelated project changes.

## RETURN semantics

Any RETURN -> stop immediately. No post-return remote cleanup/lifecycle action.

## Success contract

```text
PASS_CANDIDATE_K6_PHASE_D_R6R1_SSH_TRANSPORT_RECOVERY_AND_BOOTSTRAP_RESUME
SSH_CANONICAL_PROBE=PASS
SSH_HOST_KEY_MATCH=PASS
REMOTE_IDENTITY=ops@srv1970241
D_R6_READINESS=PASS
WORDPRESS_BOOTSTRAP=PASS
WORDPRESS_INSTALLED_STATE=PASS
HOME_SITEURL_SCALAR_UPDATE=PASS
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_PRIVATE_PRIMARY_ROUTES=PASS
WP_CONTENT_MEDIA_STATE=PASS
WOOCOMMERCE_CORE_STATE=PASS
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO
DB_PUBLIC_PORT=NONE
WORDPRESS_HOST_PORT=NONE
PUBLIC_INGRESS_CHANGE=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

This Gate does not authorize serialized migration or public ingress.
