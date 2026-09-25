# K6 C1R5 — Fresh Secret Regeneration Execution Pack

Revision: 2 — governance reconciled before execution on 2026-09-25

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- unique current Shared VPS Handoff: `SHARED_VPS_HANDOFF_CURRENT.md` from the established Owner/shared-infrastructure source;
- `mini-craft-night-kit/REVIEWER_HANDOFF.md`;
- `docs/REVIEWER_DECISION_K6_C1R4R1_PASS_C1R5_FRESH_SECRET_REGENERATION_AUTHORIZED.md`;
- `docs/REVIEWER_DECISION_K6_C1R5_PREEXECUTION_GOVERNANCE_RECONCILIATION.md`;
- `PROJECT_STORAGE_MANIFEST.md`.

Gate: `K6_PHASE_C1R5_FRESH_SECRET_REGENERATION_AND_PROVISIONING`

## Objective

Replace the abandoned requirement to reuse the old ambiguous C1 pending payload with a fresh exact ten-Secret generation/provisioning transaction under a newly sealed canonical serialization/parser.

The historical old pending artifact remains encrypted and untouched. No Mini Craft service/deployment is started in this Gate.

## Mandatory startup / source order

1. Read canonical GitHub Governance latest and active addenda.
2. Read the unique current Shared VPS Handoff. Do not use Owner memory or a stale project copy as SSH authority.
3. Read current `REVIEWER_HANDOFF.md`.
4. Read the two C1R5 Reviewer decisions above.
5. Read `PROJECT_STORAGE_MANIFEST.md`.
6. Read latest accepted `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`.
7. Confirm this Revision 2 pack is the current Gate prompt.

If a required authoritative source is unavailable or materially inconsistent, RETURN Reviewer before write.

## Mandatory execution-boundary preflight

Prove:

- real Owner Windows machine/profile for DPAPI CurrentUser;
- current PowerShell/runtime compatibility;
- recorded identity-file presence and public fingerprint without reading/emitting private-key contents;
- normal `known_hosts` pin and strict host-key match;
- strict SSH target `ops@2.24.193.133:22`;
- remote identity `ops@srv1970241`;
- `sudo -n`;
- target capacity/resource baseline;
- no Mini Craft app/data/backup path collision;
- all ten exact target Secret file paths absent;
- no Mini Craft container/network collision;
- explicit production Compose render still matches sealed candidate using non-secret placeholders only.

SSH must retain `BatchMode=yes`, `IdentitiesOnly=yes`, `StrictHostKeyChecking=yes`, explicit normal known_hosts, bounded timeouts/keepalive, and explicit native exit-code checks.

Any material drift, unavailable Owner-host boundary, SSH/trust failure, or unexpected target state → precise RETURN before Secret generation/write.

## Historical pending boundary

Historical C1 pending artifact:

- metadata-only checks allowed where needed;
- do not open/decrypt/hash/copy/rename/promote/delete/modify it;
- do not reuse or infer its serialization;
- keep it encrypted at its existing Owner-profile location.

C1R5 uses a new independently named pending/final recovery artifact.

## Phase A — synthetic canonical serialization/parser/DPAPI seal

No real Secret generation/write is permitted until Phase A passes.

Create the smallest retained non-secret helper implementing one explicit canonical payload schema:

- UTF-8 with explicit BOM policy;
- explicit LF/CRLF policy;
- exact project + host bindings;
- exact ten field names and exact order;
- explicit framing/terminal EOF contract;
- exact cardinality;
- strict rejection of unknown/missing/duplicate/extra/malformed/trailing data.

Run on the **proven real Owner Windows profile** with synthetic fixture values only:

1. canonical serialize;
2. create synthetic DPAPI CurrentUser pending artifact or equivalent Gate-local protected fixture;
3. immediate in-memory unprotect;
4. exact normalized payload comparison;
5. exact parser/binding/cardinality/format validation;
6. cleanup of synthetic fixture artifacts.

Required cases:

- canonical PASS;
- LF/CRLF cases per chosen contract;
- wrong project binding;
- wrong host binding;
- missing field;
- duplicate field;
- extra field;
- wrong order if order is canonical;
- invalid hex;
- invalid length;
- blank value;
- trailing garbage/non-record lines.

Record only:

- helper path;
- helper SHA-256;
- parser/static validation;
- redacted test matrix;
- synthetic cleanup result;
- no real Secret/content access.

If any Phase A ambiguity/failure occurs: RETURN and stop. Phase B authority automatically expires.

## Phase B — fresh exact ten-Secret transaction

Only after Phase A PASS.

### Exact target

`/srv/data/mini-craft-night-kit/secrets/`

### Exact allowlist

- `db-app-password`
- `db-root-password`
- `wordpress-auth-key`
- `wordpress-secure-auth-key`
- `wordpress-logged-in-key`
- `wordpress-nonce-key`
- `wordpress-auth-salt`
- `wordpress-secure-auth-salt`
- `wordpress-logged-in-salt`
- `wordpress-nonce-salt`

Formats:

- DB passwords: target OS CSPRNG, 32 random bytes → lowercase hex, no newline;
- WordPress keys/salts: target OS CSPRNG, 64 random bytes → lowercase hex, no newline.

Target metadata:

- secret dir: `root:root 0700`;
- `db-app-password` + eight WordPress files: `root:33 0440`;
- `db-root-password`: `root:root 0400`.

### Required ordering

1. Repeat the fresh strict read-only prewrite target/collision/resource/Compose checks immediately before the real transaction.
2. Generate exactly the ten fresh values inside the protected target-side transaction/process using the target OS CSPRNG.
3. Serialize the canonical payload in process memory only.
4. Before creating any target Secret file, stream the payload only through the reviewed in-memory/stdin channel to the proven Owner Windows process.
5. Create a **new C1R5 `*.pending.dpapi`** artifact on the proven Owner profile.
6. Immediately unprotect that new pending artifact in memory and require:
   - exact normalized payload identity;
   - parser PASS;
   - project/host binding PASS;
   - exact field cardinality/order PASS;
   - expected format/length PASS;
   - pairwise uniqueness PASS;
   - no plaintext persistence/output/hash.
7. Only after step 6 PASS may the remote transaction atomically/exclusively create the exact ten target files with fail-on-existing semantics and exact metadata.
8. Read back metadata only: exact inventory count, owner/group/mode, nonempty/format/uniqueness result without values/hashes.
9. Prove intended runtime access:
   - WordPress effective reader can read its nine allowed files including db-app;
   - MariaDB can read db-app and db-root as required;
   - WordPress cannot read/mount db-root;
   - unrelated services are not given/mounted Mini Craft Secrets.
10. Only after all target/access checks pass, atomically promote the **new C1R5 pending** artifact to the new final recovery artifact.
11. Verify final recovery artifact path/size/ACL on the real Owner Windows host.
12. Stop at Reviewer.

## Secret transport prohibitions

No real Secret value/hash may appear in:

- chat;
- GitHub;
- argv;
- environment variables;
- shell history;
- transcripts;
- ordinary temp files;
- stdout/stderr returned to the agent;
- logs;
- Handoff/Evidence;
- bundles.

Use only the reviewed bounded process-memory/stdin pipeline. If that boundary cannot be proven, RETURN before real generation/write.

## Failure / rollback

- Failure before new C1R5 pending creation → no target Secret write.
- New pending created but round-trip/parser fails → do not write target Secrets; retain/clean only according to the reviewed safe rollback without exposing content.
- New pending verified but remote write fails/ambiguous → do not promote pending; retain it encrypted; run strict read-only remote reconciliation before any retry.
- Remote write commits but permission/runtime-access validation fails → do not blindly rerun or overwrite; retain pending, classify target state, RETURN Reviewer.
- Unexpected target collision/content → no delete/overwrite/hash/value read; RETURN.
- Do not automatically delete either protected pending artifact on uncertain outcomes.
- Any RETURN/ambiguity cancels downstream conditional authority; retry requires Reviewer reconciliation and fresh Owner authorization whenever Governance requires it.

## Forbidden

No:

- historical old pending reuse/decrypt/delete/modify/promotion;
- extra Secret;
- overwrite/rotation;
- `/srv/apps/mini-craft-night-kit` creation;
- `/srv/backups/mini-craft-night-kit` creation;
- DB/wp-content restore;
- Mini Craft production container start/recreate/pull;
- Caddy/cloudflared/UFW/SSH/Docker-daemon/shared-network mutation;
- DNS/public route;
- PayPal Live;
- real payment/refund;
- launch;
- broad Docker cleanup/prune.

## Evidence

Append only redacted actual facts to:

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Evidence must include:

- Governance + Shared VPS Handoff source read;
- target-host/Owner-host execution identities;
- native exit-status checks;
- Phase A helper SHA/test matrix;
- fresh remote preflight;
- new C1R5 pending prewrite round-trip/parser PASS;
- exact created inventory count = 10;
- owner/group/mode;
- nonempty/format/uniqueness PASS without values/hashes;
- runtime-access/exclusion PASS;
- new recovery artifact final host-local verification;
- historical old pending unchanged;
- target/shared regression;
- cleanup;
- zero Secret value/hash exposure;
- `SANDBOX_ONLY_WRITE_USED_AS_HOST_EVIDENCE=NO`.

Return:

```text
PASS_CANDIDATE_K6_PHASE_C1R5_FRESH_SECRET_REGENERATION_AND_PROVISIONING
PHASE_A_CANONICAL_SERIALIZATION_SEAL=PASS
NEW_C1R5_PENDING_PREWRITE_ROUNDTRIP=PASS
PHASE_B_EXACT_TEN_FILE_PROVISIONING=PASS
RUNTIME_ACCESS_AND_EXCLUSION=PASS
NEW_RECOVERY_FINAL_VERIFIED=PASS
OLD_PENDING_UNCHANGED=PASS
SECRET_VALUES_OR_HASHES_EXPOSED=0
STOP_AT_REVIEWER=YES
```

or a precise `RETURN_*`.

Do not enter K6 deployment/start after this pack.
