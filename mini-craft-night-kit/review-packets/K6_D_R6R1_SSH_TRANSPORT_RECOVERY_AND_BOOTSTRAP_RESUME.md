# K6 D-R6R1 — SSH Transport Recovery + Bootstrap Resume Execution Pack

Gate:
`K6_PHASE_D_R6R1_SSH_TRANSPORT_RECOVERY_AND_BOOTSTRAP_RESUME`

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_D_R6_RETURN_D_R6R1_SSH_RECOVERY_AND_RESUME.md`;
- prior D-R6 decision/pack;
- latest `EXECUTION_EVIDENCE.md`;
- latest `EXECUTOR_HANDOFF.md`;
- unique current Shared VPS Handoff.

## Objective

Recover the already-approved canonical SSH transport with one bounded classified attempt. If recovered, immediately resume D-R6 bootstrap/private-app validation in the same Gate.

## Phase A — one strict SSH attempt

Before connecting:
- identity reference exists;
- public fingerprint matches;
- known_hosts pins match.

Use exactly:
- `ops@2.24.193.133:22`;
- recorded identity;
- explicit normal known_hosts;
- BatchMode=yes;
- IdentitiesOnly=yes;
- StrictHostKeyChecking=yes;
- bounded timeout/keepalive settings.

Exactly one attempt.

Capture stderr locally only for classification.
Do not commit raw stderr.
Evidence may contain only:
- native exit;
- redacted class;
- whether host key was presented;
- whether presented host key matched;
- whether authenticated remote identity was obtained.

No alternate account/key/client/trust policy.

### Success

If exit 0 and pinned host identity matches:
continue Phase B.

### Failure

If exit 255 or any transport failure:
- classify from stderr;
- if a presented host key mismatches: `RETURN_SSH_TRUST_DRIFT`;
- otherwise: `RETURN_OWNER_HOSTINGER_CONSOLE_CHECK_REQUIRED`;
- do not retry.

Owner checkpoint if required:
- confirm VPS Running;
- web/serial console: ssh/sshd active? port 22 listening? provider/network block?
- report status only;
- no reboot/firewall/sshd/key changes.

## Phase B — original D-R6 resume

Only after Phase A PASS.

Freshly verify:
- WordPress + MariaDB running;
- zero host ports;
- WordPress restart count stable;
- runtime core present;
- MariaDB healthy;
- root/app exact 52-table set;
- wp_options present;
- unrelated services/80-443/shared topology unchanged;
- no public Mini Craft ingress.

Then:
1. bounded WordPress bootstrap;
2. installed-state true;
3. no PHP fatal;
4. exact scalar update only:
   - home
   - siteurl
   -> `https://minicraft.spikersun.com`;
5. verify exact values;
6. private routes:
   - /
   - /shop/
   - /product/mini-craft-night-kit/
   - /cart/
   - /checkout/
   - /my-account/
   - /wp-json/
7. wp-content/media state;
8. WooCommerce core state;
9. PayPal Sandbox / Live disabled metadata state;
10. recent filtered fatal classification;
11. MariaDB health and WordPress restart count stable.

Record:
`FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`

## Forbidden

No:
- second SSH retry;
- alternate SSH identity/trust;
- SSH/UFW/server mutation;
- WordPress recreate/restart;
- DB import/reset/drop/recreate;
- wp-content restore;
- image pull/build;
- broad SQL replacement;
- serialized migration;
- public ingress;
- Secret output/hash/rotation/overwrite;
- PayPal Live/payment/refund;
- unrelated-project mutation.

## RETURN rule

Any RETURN -> stop immediately.
No remote cleanup/lifecycle action.

## Evidence markers

```text
IDENTITY_REFERENCE_CHECK=
PUBLIC_FINGERPRINT_MATCH=
KNOWN_HOSTS_PIN_CHECK=
SSH_CANONICAL_PROBE=
SSH_FAILURE_CLASS=
SSH_HOST_KEY_PRESENTED=
SSH_HOST_KEY_MATCH=
REMOTE_IDENTITY=
D_R6_READINESS=
ROOT_TABLE_COUNT=
APP_TABLE_COUNT=
WP_OPTIONS_PRESENT=
WORDPRESS_RUNTIME_CORE=
WORDPRESS_BOOTSTRAP=
WORDPRESS_INSTALLED_STATE=
HOME_SITEURL_SCALAR_UPDATE=
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_PRIVATE_PRIMARY_ROUTES=
WP_CONTENT_MEDIA_STATE=
WOOCOMMERCE_CORE_STATE=
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO
WORDPRESS_RECENT_FATALS=
WORDPRESS_RESTART_COUNT=
DB_PUBLIC_PORT=NONE
WORDPRESS_HOST_PORT=NONE
PUBLIC_INGRESS_CHANGE=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
STOP_AT_REVIEWER=YES
```

## Return

Success:
`PASS_CANDIDATE_K6_PHASE_D_R6R1_SSH_TRANSPORT_RECOVERY_AND_BOOTSTRAP_RESUME`

Failure:
`RETURN_OWNER_HOSTINGER_CONSOLE_CHECK_REQUIRED`
or precise trust/material-drift `RETURN_*`.

Do not enter serialized migration or public ingress.
