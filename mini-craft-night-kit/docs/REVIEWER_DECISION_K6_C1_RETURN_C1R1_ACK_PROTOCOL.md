# Reviewer Decision — K6 C1 ACK Rejected Before Remote Write

Date: 2026-09-24 (Asia/Shanghai)  
Gate: `K6_PHASE_C1_SECRET_PROVISIONING_AND_RECOVERY`  
Result: **RETURN_C1_ACK_PROTOCOL_PREWRITE**  
Executor return: `RETURN_REVIEWER_C1_REMOTE_ACK_REJECTED_PREWRITE`

## Independent review

I reviewed the current GitHub C1 sections in `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md` and verified that commits `40b708175ab87d5f7fd3d9c32ff031e9e15b7cd6` and `d2b302aeae4c7537807630eee9c1f7af70f607e7` changed the respective Executor-owned files. The C1 attempt used the previously authorized exact ten-file scope. Target-side process memory generated the values; an in-memory SSH stream was encrypted into a Windows DPAPI CurrentUser `*.pending.dpapi` artifact and an immediate byte-identity round-trip passed. Windows line writing sent CRLF while the remote acknowledgement parser expected LF only. The remote process rejected ACK with exit 76 **before creating any target directory or file**. The Executor did not retry, delete, or promote the pending artifact.

I independently performed a bounded strict SSH **read-only** existence check: `/srv/data/mini-craft-night-kit` is absent, so its `secrets` child and all ten target files are absent. On the current Windows Owner profile, the pending artifact exists at `%LOCALAPPDATA%\MiniCraftNightKit\secret-recovery\k6-c1-mini-craft-night-kit-srv1970241.pending.dpapi`, size 1,686 bytes. The recovery leaf has inheritance disabled and grants only the current Owner account FullControl; the file inherits only that leaf allow rule. I did not open or decrypt it. No C1 project/VPS write is evidenced, and no Mini Craft service was started.

The root cause fits the canonical [SSH/Delegated Secret Operations addendum](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/references/SSH_AND_DELEGATED_SECRET_OPERATIONS.md), which requires explicit UTF-8 framing and a parser compatible with reviewed CRLF/LF forms. A successful DPAPI decrypt alone does not validate the transport/parser contract. This is a correct fail-closed prewrite return, not C1 PASS.

```text
K6_PHASE_C1_SECRET_PROVISIONING_AND_RECOVERY=RETURN_C1_ACK_PROTOCOL_PREWRITE
REMOTE_ACK=REJECTED_EXIT_76_BEFORE_WRITE
REMOTE_PROJECT_DATA_PATH=ABSENT_REVIEWER_READBACK
REMOTE_SECRET_FILES=0_OF_10
DPAPI_PENDING=EXISTS_ENCRYPTED_1686_BYTES_OWNER_LEAF_ACL
DPAPI_PENDING_PROMOTED=NO
DPAPI_PENDING_DELETED=NO
DPAPI_PENDING_PAYLOAD_READ_BY_REVIEWER=NO
REMOTE_WRITES=0
SECRET_VALUES_OR_HASHES_IN_REVIEW=0
RETRY=NOT_AUTHORIZED
PAYPAL_LIVE=NO
REAL_PAYMENT=NO
```

## Pending artifact disposition

**Retain exactly this encrypted pending artifact unchanged.** Do not decrypt, rename, promote, delete, copy, commit, or substitute it during the next local-only Gate. It represents target-generated values that were never installed. It is not a final recovery artifact and does not prove a usable deployed Secret set. Its eventual reuse or retirement requires a separate Reviewer decision after the protocol is verified and an explicit Owner authorization for the next production-write retry.

Canonical Governance's conditional-preauthorization rule says a RETURN cancels a pending production-write retry authorization. The original ten-file delegation remains an historical fact, but it must not be treated as permission to replay C1 after this RETURN. No blind retry is permitted.

## Next Gate — K6 C1R1 ACK protocol reconciliation

`K6_PHASE_C1R1_ACK_PROTOCOL_RECONCILIATION` is authorized as a **local-only code/transport rehearsal plus bounded remote read-only protocol probe**. External Execution Agent prompt:

> Read latest canonical VPS Governance and the SSH/Delegated Secret Operations and Target Host Reality addenda, this decision, current Reviewer Handoff, C1 redacted Evidence/Handoff, and the unique Shared VPS Handoff. Keep the exact existing DPAPI pending artifact untouched and unread. Inspect and minimally correct only the non-secret ACK framing/parser helper: define a fixed UTF-8/ASCII token and exact accepted LF or CRLF framing; reject malformed, truncated and extra-byte ACKs. Avoid OS-default `WriteLine` ambiguity by writing explicit bytes or make the remote parser accept only the two reviewed newline forms. With **synthetic non-secret fixture bytes only**, test both LF and CRLF on the real Windows PowerShell → strict SSH → target parser path, and negative cases. The target probe must exit before any directory/file creation and must not invoke the real C1 installer. Recheck the ten target paths absent and the pending artifact's path/size/leaf ACL as metadata only; do not decrypt, create, promote, remove or copy it. Record command statuses, source helper hash, exact parser behavior, cleanup and no-write read-back in redacted Executor Evidence/Handoff. Return `PASS_CANDIDATE_K6_PHASE_C1R1_ACK_PROTOCOL_RECONCILIATION` or a precise `RETURN_*`, then `STOP_AT_REVIEWER=YES`.

Allowed: local non-secret helper edit, synthetic fixture tests, strict SSH read-only protocol probe, metadata-only pending/path checks, redacted Executor docs. Prohibited: real Secret generation/decryption/transfer, DPAPI artifact mutation, target path creation, Docker pull/start, Compose/DB restore, ingress/DNS/Shared Infra change, payment/Live/launch. If the helper cannot be tested without invoking a write-capable remote branch, return to Reviewer before the probe.

After C1R1 review, the Reviewer will decide whether the same pending artifact may be reused and will present the exact bounded retry for fresh Owner authorization. No Owner action is needed for C1R1.
