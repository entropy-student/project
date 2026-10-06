# G4-B R22 Exact Recovery Pending Cleanup — R6R2L-R22R5

Status: OWNER_BOUNDED_RECOVERY_CLEANUP_REQUIRED / REVIEWER_STOP

## GATE_ID
`G4B_R22_EXACT_RECOVERY_PENDING_CLEANUP_R6R2L_R22R5`

## PREVIOUS_RESULT
`PASS_R22R4_TRANSACTION_RESIDUE_CLEAN`

## OBJECTIVE
Remove only the exact R22 recovery pending set after proving local ownership and remote ciphertext identity.

## REQUIRED PRE-MUTATION PROOF
- unique retained R22 rollback journal in the bounded R22 execution window;
- journal status `IN_PROGRESS`, run-id matches filename, no profile created;
- local DPAPI pending exists, owner-only ACL, expected exact path;
- local portable pending exists, owner-only ACL, exact run-id filename and bounded timestamp;
- local recovery final absent;
- Baidu remote pending exact filename exists and remote final absent;
- download the exact remote pending into an owner-only temporary directory;
- SHA-256 of downloaded ciphertext exactly matches local portable pending;
- Owner locally confirms current Baidu account in UI; account identifier must not be emitted or persisted.

## ALLOWED MUTATION
1. delete exact R22 Baidu remote pending object;
2. verify remote pending and remote final both absent;
3. delete exact local portable pending;
4. delete exact local DPAPI pending;
5. remove temporary diagnostic runtime.

## FORBIDDEN
No recovery decrypt; no recovery final create/delete; no rollback journal deletion; no SSH/VPS/service/firewall/route action; no Clash/profile/network mutation; no mutation of any other Baidu object.

## ACCEPTANCE
Exact R22 remote pending absent, exact local pending pair absent, finals absent, temporary runtime removed, and rollback journal retained.

Any failure after a consequential delete begins => no blind retry; return to Reviewer for read-only reconciliation.

`STOP_AT_REVIEWER=YES`
