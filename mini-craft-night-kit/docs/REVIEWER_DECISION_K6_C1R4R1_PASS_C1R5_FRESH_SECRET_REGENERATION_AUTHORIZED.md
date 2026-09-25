# Reviewer Decision — K6 C1R4R1 PASS; C1R5 Fresh Secret Regeneration AUTHORIZED

Date: 2026-09-25  
Role: Reviewer / Gatekeeper  
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Owner decision

The Owner explicitly selected:

```text
OPTION_A=AUTHORIZE_FRESH_REGENERATION_PATH
```

after being told that Option A means:

- retain the old DPAPI pending artifact encrypted and undeleted;
- do not require reuse of the old ten Secret values;
- define and prove a new canonical serialization/parser with synthetic fixture data first;
- generate a fresh exact ten-value allowlist;
- install only those ten files on the already verified Mini Craft target;
- verify target permissions/runtime-access boundaries;
- create and verify a final encrypted off-host recovery artifact;
- do not deploy/start Mini Craft services or enable payment/production in this Secret Gate.

This is accepted as the fresh explicit Owner Secret authorization required after the C1R4 RETURN.

## C1R4R1 decision

```text
GATE=K6_PHASE_C1R4R1_PENDING_DISPOSITION_OWNER_CHECKPOINT
RESULT=PASS_OWNER_SELECTED_FRESH_REGENERATION
OLD_PENDING=RETAIN_ENCRYPTED_UNPROMOTED_UNDELETED
OLD_VALUES_REQUIRED=NO
```

The old pending artifact remains historical protected material. It must not be deleted, promoted, reused, decrypted again, or overwritten in C1R5.

## C1R5 Gate

```text
CURRENT_GATE=K6_PHASE_C1R5_FRESH_SECRET_REGENERATION_AND_PROVISIONING
AUTHORIZATION=OWNER_EXPLICIT_BOUNDED
REAL_WRITE_CONDITION=PHASE_A_SYNTHETIC_SERIALIZATION_SEAL_PASS
STOP_AT_REVIEWER=YES
```

### Exact target

- Host/account: existing verified `ops@srv1970241` using the recorded strict SSH identity/host pin.
- Project data root: `/srv/data/mini-craft-night-kit`.
- Secret directory: `/srv/data/mini-craft-night-kit/secrets/`.
- Secret directory target metadata: `root:root 0700`.
- No substitute host, account, directory or credential namespace is authorized.

### Exact ten-file allowlist

| File basename | Fresh value format | Target metadata | Runtime consumer |
|---|---|---|---|
| `db-app-password` | target OS CSPRNG, 32 random bytes → lowercase hex, no newline | `root:33 0440` | MariaDB + WordPress |
| `db-root-password` | target OS CSPRNG, 32 random bytes → lowercase hex, no newline | `root:root 0400` | MariaDB only |
| `wordpress-auth-key` | target OS CSPRNG, 64 random bytes → lowercase hex, no newline | `root:33 0440` | WordPress |
| `wordpress-secure-auth-key` | same | `root:33 0440` | WordPress |
| `wordpress-logged-in-key` | same | `root:33 0440` | WordPress |
| `wordpress-nonce-key` | same | `root:33 0440` | WordPress |
| `wordpress-auth-salt` | same | `root:33 0440` | WordPress |
| `wordpress-secure-auth-salt` | same | `root:33 0440` | WordPress |
| `wordpress-logged-in-salt` | same | `root:33 0440` | WordPress |
| `wordpress-nonce-salt` | same | `root:33 0440` | WordPress |

No other Secret, file or credential may be created or changed. Existing target collision means fail closed; no overwrite or rotation.

## Two-phase conditional authorization

### Phase A — canonical serialization/parser seal — no real Secret write

Before generating any real Secret:

1. Read canonical Governance + SSH/Delegated Secret Operations + Target Host Reality + Storage Layout + current Reviewer Handoff/Storage Manifest.
2. Prove the real Owner Windows host/profile boundary needed for DPAPI recovery and the recorded strict SSH target identity.
3. Define one new canonical payload format in retained non-secret helper source. It must explicitly define:
   - UTF-8 encoding and BOM policy;
   - line/framing format;
   - project and host binding records;
   - exact field order/names;
   - terminator/EOF contract;
   - parser rejection rules;
   - LF/CRLF policy.
4. Exercise the production-intended serializer + parser + pending→decrypt→parse workflow with synthetic fixture values only.
5. Exercise accepted and rejected cases, including malformed framing, extra fields/lines, missing fields, duplicate fields, wrong binding, wrong length/format and trailing garbage.
6. No real pending artifact content may be used, transferred, normalized or inferred.
7. Phase A must produce a reviewable helper SHA-256 and redacted test matrix.

Any ambiguity/failure returns immediately. Phase B authorization then automatically expires.

### Phase B — fresh generation + exact provisioning

Only if Phase A passes in the same bounded execution package:

1. Run a fresh strict read-only prewrite check:
   - target identity + host pin;
   - `sudo -n`;
   - disk/RAM;
   - all Mini Craft app/data/backup namespace collision state;
   - all ten target Secret file paths absent;
   - no Mini Craft container/network currently exists;
   - explicit production Compose render still matches the sealed candidate.
2. Generate the fresh ten values with the target OS CSPRNG and exact formats.
3. Transport values only through a reviewed in-memory/stdin path. Secret values/hashes must never appear in chat, GitHub, command arguments, environment, shell history, transcripts, ordinary temp files, stdout/stderr or Evidence.
4. Create the project data/secrets namespace and exact ten files using atomic exclusive/fail-on-existing semantics and exact metadata.
5. Read back only inventory/owner/group/mode/nonempty/format/uniqueness metadata.
6. Prove intended runtime read access and DB-root exclusion using a bounded no-value mechanism; unrelated services must not receive/mount these files.
7. Create a **new** Owner-profile DPAPI CurrentUser pending recovery artifact using the newly sealed canonical serialization, perform immediate in-memory decrypt + exact parser validation, then promote that new artifact to final only after target checks pass.
8. Verify final recovery artifact path/size/ACL on the real Owner host. Do not include Secret content or content hash in Evidence.
9. Preserve the old C1 pending artifact unchanged. It is not deleted in C1R5.
10. Stop at Reviewer. No service start/deployment follows automatically.

## Allowed writes

Only:

- `/srv/data/mini-craft-night-kit/` as needed;
- `/srv/data/mini-craft-night-kit/secrets/`;
- the exact ten files above;
- exact owner/group/mode metadata;
- one new protected Owner-profile C1R5 recovery pending/final artifact;
- project-local non-secret helper/evidence artifacts;
- redacted GitHub `EXECUTION_EVIDENCE.md` / `EXECUTOR_HANDOFF.md`.

## Forbidden

- reuse/modify/delete/promote the old C1 pending artifact;
- overwrite any existing Secret file;
- create `/srv/apps/mini-craft-night-kit` or `/srv/backups/mini-craft-night-kit`;
- restore DB/wp-content;
- start/recreate/pull Mini Craft production containers;
- modify Caddy, cloudflared, UFW, SSH, Docker daemon, shared networks or host 80/443;
- DNS/public-route changes;
- PayPal Live, real payment, refund, commercial launch;
- any other Secret/account/provider action.

## Result contract

Success candidate:

```text
PASS_CANDIDATE_K6_PHASE_C1R5_FRESH_SECRET_REGENERATION_AND_PROVISIONING
PHASE_A_CANONICAL_SERIALIZATION_SEAL=PASS
PHASE_B_EXACT_TEN_FILE_PROVISIONING=PASS
OLD_PENDING_UNCHANGED=PASS
NEW_RECOVERY_FINAL_VERIFIED=PASS
SECRET_VALUES_OR_HASHES_EXPOSED=0
STOP_AT_REVIEWER=YES
```

Otherwise return a precise `RETURN_*` and stop without self-advancing.

A C1R5 PASS_CANDIDATE does **not** authorize K6 deployment/start. Reviewer must independently review evidence and open the next Gate.
