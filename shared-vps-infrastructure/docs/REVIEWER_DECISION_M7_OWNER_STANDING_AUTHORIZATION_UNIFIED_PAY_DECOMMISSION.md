# Reviewer Decision — M7 Owner Standing Authorization for Unified Pay Decommission

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Owner authorization

Owner approved M7 and explicitly delegated subsequent Unified Pay decommission steps without repeated approval, provided they do not affect other projects.

```text
OWNER_AUTHORIZES_M7=YES
OWNER_STANDING_AUTHORIZATION_FOR_UNIFIED_PAY_DECOMMISSION=YES
REPEATED_OWNER_APPROVAL_REQUIRED_FOR_IN_SCOPE_REVERSIBLE_PROJECT_ONLY_STEPS=NO
```

## Standing authorization scope

Reviewer may authorize and Executor may perform later bounded Unified Pay-only decommission steps without another Owner checkpoint when ALL are true:

- action is scoped only to Unified Pay;
- Dujiao, Mini Craft, Xianyu and Shared Infrastructure remain unaffected;
- no real payment/refund/provider action occurs;
- no Secret value is exposed;
- no Cloudflare/DNS/shared-network/shared-monitor mutation occurs;
- rollback/recovery material remains adequate for the specific step;
- fresh preflight shows no new dependency or material drift;
- Executor stops at Reviewer after each Gate and Reviewer independently verifies evidence.

Examples that may proceed under this standing authorization after Reviewer PASS:

- stop Unified Pay PostgreSQL;
- remove an already-stopped Unified Pay PostgreSQL container;
- remove a retired Unified Pay app image after a verified reconstructibility/recovery barrier;
- remove project-local non-durable runtime residue proven unused.

## Hard boundaries still requiring Owner checkpoint

The standing authorization does NOT cover:

- permanent deletion of Unified Pay database files;
- permanent deletion of Unified Pay backups/recovery material;
- deletion or rotation of Secret sources;
- Cloudflare Tunnel or DNS deletion/mutation;
- shared network deletion/mutation;
- Shared Infrastructure changes;
- any real payment/refund/provider mutation;
- any action with plausible impact on another project;
- any action where rollback/recovery is not proven.

These must stop at Reviewer/Owner.

## M7 authorization

```text
CURRENT_GATE=M7_UNIFIED_PAY_POSTGRES_STOP_OBSERVATION
CURRENT_GATE_STATUS=AUTHORIZED_BOUNDED_PROJECT_RUNTIME_WRITE

UNIFIED_PAY_POSTGRES_STOP_AUTHORIZED=YES
UNIFIED_PAY_POSTGRES_START_AUTHORIZED=YES_ROLLBACK_ONLY
UNIFIED_PAY_POSTGRES_CONTAINER_REMOVE_AUTHORIZED=NO_IN_M7
UNIFIED_PAY_DATA_DELETE_AUTHORIZED=NO
UNIFIED_PAY_BACKUP_DELETE_AUTHORIZED=NO
UNIFIED_PAY_SECRET_DELETE_AUTHORIZED=NO
UNIFIED_PAY_TUNNEL_MUTATION_AUTHORIZED=NO
```

## M7 goal

Stop only the remaining Unified Pay PostgreSQL service/container and observe. Preserve container, data, backups, Secrets, image, Compose and Tunnel/DNS.

If any known project regresses, immediately restart only Unified Pay PostgreSQL and return to Reviewer.
