# K6 C1R5 — Fresh Secret Regeneration Execution Pack

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- `mini-craft-night-kit/REVIEWER_HANDOFF.md`;
- `docs/REVIEWER_DECISION_K6_C1R4R1_PASS_C1R5_FRESH_SECRET_REGENERATION_AUTHORIZED.md`;
- `PROJECT_STORAGE_MANIFEST.md`.

Gate: `K6_PHASE_C1R5_FRESH_SECRET_REGENERATION_AND_PROVISIONING`

## Objective

Replace the abandoned requirement to reuse the old ambiguous C1 pending payload with a fresh exact ten-Secret generation/provisioning transaction under a newly sealed canonical serialization/parser.

The old pending artifact is retained encrypted and untouched. No Mini Craft service/deployment is started in this Gate.

## Mandatory preflight

1. Re-read the authoritative Governance and all Secret/SSH/Target Host/Storage addenda.
2. Re-read current Reviewer Handoff, Storage Manifest and C1R5 Reviewer Decision.
3. Prove execution boundary:
   - Owner Windows host/profile for DPAPI;
   - recorded strict SSH identity + pinned host;
   - remote identity `ops@srv1970241`.
4. Confirm old pending artifact metadata only and do not open/decrypt/modify/delete it.
5. Confirm no Mini Craft production namespace/file/container/network collision.
6. Confirm target capacity and `sudo -n`.
7. Re-render explicit production Compose using non-secret validation placeholders only.

Any material drift → precise RETURN before Secret generation.

## Phase A — synthetic canonical serialization seal

No real Secret generation/write is permitted until Phase A passes.

Create the smallest retained non-secret helper implementing one explicit canonical payload schema:

- UTF-8, explicit BOM policy;
- explicit LF/CRLF policy;
- explicit project/host binding;
- exact ten field names and exact order;
- explicit framing/terminal EOF contract;
- strict parser/cardinality rules;
- reject extra/missing/duplicate/malformed/trailing data.

Run synthetic fixture cases:
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

Run synthetic Owner-host DPAPI pending → unprotect → exact parser validation with no plaintext persistence.

Record:
- helper path;
- helper SHA-256;
- parse/static validation;
- test matrix results;
- no real Secret/content access.

If any Phase A ambiguity/failure: RETURN and stop. Do not enter Phase B.

## Phase B — exact fresh ten-file provisioning

Only after Phase A PASS.

Exact target:
`/srv/data/mini-craft-night-kit/secrets/`

Exact allowlist:
- db-app-password
- db-root-password
- wordpress-auth-key
- wordpress-secure-auth-key
- wordpress-logged-in-key
- wordpress-nonce-key
- wordpress-auth-salt
- wordpress-secure-auth-salt
- wordpress-logged-in-salt
- wordpress-nonce-salt

Formats:
- DB passwords: 32 random bytes → lowercase hex;
- WordPress keys/salts: 64 random bytes → lowercase hex.

Metadata:
- secret dir `root:root 0700`;
- db-app + eight WordPress files `root:33 0440`;
- db-root `root:root 0400`.

Requirements:
- target OS CSPRNG;
- atomic exclusive creation;
- fail-on-existing;
- no overwrite/rotation;
- no value/hash output anywhere;
- no Secret in argv/env/history/transcript/temp/log/GitHub/chat;
- reviewed memory/stdin transport only;
- fresh new C1R5 DPAPI recovery artifact using the Phase-A sealed serialization;
- immediate in-memory unprotect + exact parser validation;
- final promotion only after remote inventory/access checks pass;
- host-local final path/size/ACL read-back;
- old C1 pending remains unchanged.

Runtime-access verification:
- WordPress effective reader can read its nine allowed files, including db-app;
- MariaDB can read db-app and db-root as required;
- WordPress cannot read/mount db-root;
- unrelated services are not given/mounted Mini Craft Secrets.

No service start is allowed; use only bounded no-value verification mechanics reviewed by the decision.

## Forbidden

No:
- old pending reuse/decrypt/delete/modify/promotion;
- /srv/apps or /srv/backups creation;
- DB/wp-content restore;
- production Compose start/recreate/pull;
- shared Caddy/cloudflared/UFW/SSH/Docker daemon/shared-network mutation;
- DNS/public route;
- PayPal Live/real payment/refund/launch;
- broad cleanup/prune.

## Evidence

Append only redacted actual facts to:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Evidence must include:
- execution boundary identity;
- Phase A helper SHA/test matrix;
- fresh remote preflight;
- exact created inventory count = 10;
- owner/group/mode;
- nonempty/format/uniqueness PASS without values/hashes;
- runtime-access/exclusion PASS;
- new recovery artifact created/finalized/host-local verified;
- old pending unchanged;
- target/shared regression;
- cleanup;
- zero Secret value/hash exposure.

Return:

```text
PASS_CANDIDATE_K6_PHASE_C1R5_FRESH_SECRET_REGENERATION_AND_PROVISIONING
STOP_AT_REVIEWER=YES
```

or a precise `RETURN_*`.

Do not enter K6 deployment/start after this pack.
