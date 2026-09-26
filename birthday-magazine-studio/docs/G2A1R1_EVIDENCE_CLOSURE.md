# G2A1R1 — Evidence Closure Execution Contract

> Reviewer execution contract  
> Status: READY_FOR_EXECUTOR  
> Parent decision: [REVIEWER_DECISION_G2A1_RETURN.md](./REVIEWER_DECISION_G2A1_RETURN.md)  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)

## Goal

Close only the unresolved G2A1 evidence gaps. Do not rerun already accepted frontend/Storelly findings unless material drift appears.

## Accepted facts — do not rerun

- Good Issue-style preview inside WordPress + WooCommerce is the preferred technical feasibility route.
- The current free preview can keep the optional cover image browser-local with zero model Token.
- Storelly is rejected for the current free-preview path.
- Vanquish Upload Files registered-account order binding/direct-file protection passed partial checks.
- Vanquish Attach Me registered-account authorization/direct-file protection passed partial checks.

## Required work

### 1. Local mail capture
Add a **local-only** mail-capture service to the disposable G2A1 stack so WooCommerce guest email verification can be completed without external email delivery.

Requirements:
- no real SMTP provider;
- no production email account;
- no Secret;
- local-only network exposure.

### 2. Guest upload verification
Using synthetic data and a guest dummy WooCommerce order:

- complete WooCommerce guest email verification through the local mail-capture path;
- reach the intended order details/upload surface;
- upload one synthetic image;
- prove the file binds to the intended guest order;
- prove an unrelated/incorrect guest context cannot access that order/file;
- prove raw direct file URL still fails closed.

### 3. Guest private-delivery verification
Using the synthetic proof fixture:

- attach the fixture to the intended guest order;
- complete the guest access flow;
- prove the intended guest order can access the attachment;
- prove an unrelated/incorrect guest context cannot access it;
- prove raw storage URL remains denied.

### 4. Byte-level download proof
Perform one actual authorized attachment download and verify:

- HTTP/result is successful;
- downloaded file size is non-zero;
- downloaded SHA-256 matches the committed synthetic fixture.

Do not expose signed/bearer URLs or sensitive order identifiers in ordinary evidence.

### 5. Durable visual evidence
Persist project-local screenshots for:

- Good Issue-in-WordPress desktop preview;
- Good Issue-in-WordPress 375px preview;
- guest upload surface/result;
- guest private-delivery surface/result.

Use synthetic data only.

Store under a project-local evidence path such as:

`birthday-magazine-studio/docs/evidence/g2a1r1/`

Do not include credentials, tokens, private email addresses or real customer data in screenshots.

### 6. Cleanup + read-back
Cleanup is part of this Gate.

After all evidence is captured:

- remove the exact disposable Compose stack and project-scoped volumes;
- remove temporary plugin/theme ZIPs/download fragments that are not deliberate tracked artifacts;
- do not run global Docker prune;
- verify/read back that the project-scoped containers/volumes are gone;
- verify unrelated projects were not changed.

Record actual cleanup evidence, not future-tense instructions.

### 7. Final evidence reconciliation
Update:

- `birthday-magazine-studio/EXECUTION_EVIDENCE.md`
- `birthday-magazine-studio/EXECUTOR_HANDOFF.md`

They must reflect the **actual final repository/runtime state**.

Remove stale claims such as “no commit” if commits exist.

## GitHub submission contract — mandatory

Before returning to Reviewer, Executor MUST:

1. work on a dedicated branch, preferably:
   `codex/birthday-magazine-g2a1r1-evidence-closure`
2. commit all intended project-local code/evidence/document changes;
3. push the branch to GitHub;
4. open a Pull Request targeting `main`;
5. **do not merge the PR**;
6. return:
   - branch name;
   - final commit SHA;
   - PR number / URL;
   - changed-file summary.

An uncommitted local result, local-only branch, or “files ready but not pushed” is not acceptable evidence closure.

If GitHub push/PR creation is technically unavailable, STOP and return:

`RETURN_GITHUB_SUBMISSION_UNAVAILABLE`

Do not substitute chat attachments for the GitHub handoff.

## Allowed

- local/disposable WordPress/WooCommerce test runtime;
- local mail catcher;
- synthetic orders/files/accounts;
- project-local screenshot/evidence files;
- small test harness/helper code;
- Git commit/push/PR for this project branch.

## Forbidden

- Storelly rerun without material drift;
- rebuilding all three frontend routes;
- G2A2 decisions;
- AI/LLM/vision/image API;
- PayPal or any payment gateway;
- real payment;
- real customer data;
- production email provider;
- Secret entry;
- paid plugin purchase;
- VPS/public deployment;
- Shared Infra changes.

## PASS_CANDIDATE requirements

Return PASS_CANDIDATE only when all are true:

- guest upload positive path = PASS;
- guest upload negative/direct-file checks = PASS;
- guest private-delivery positive path = PASS;
- guest private-delivery negative/direct-file checks = PASS;
- actual authorized downloaded bytes/hash = PASS;
- required screenshot artifacts are committed;
- project-scoped cleanup/read-back = PASS;
- Executor Handoff/Evidence matches final state;
- branch/commit/PR exist on GitHub;
- no forbidden action occurred.

## Final return format

```text
GATE=G2A1R1_EVIDENCE_CLOSURE
RESULT=PASS_CANDIDATE_G2A1R1_EVIDENCE_CLOSURE

GUEST_UPLOAD=PASS
GUEST_PRIVATE_DELIVERY=PASS
BYTE_DOWNLOAD_HASH=PASS
DURABLE_SCREENSHOTS=PASS
CLEANUP_READBACK=PASS
HANDOFF_RECONCILED=PASS

GIT_BRANCH=<branch>
GIT_COMMIT=<sha>
GITHUB_PR=<number/url>
STOP_AT_REVIEWER=YES
```

If any prerequisite fails, return a precise `RETURN_*` and still commit/push the safe evidence gathered so far where possible.

Do not enter G2A2.
