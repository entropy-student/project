# Side Task — GitHub Handoff Structured Chat Receipt

Date recorded: 2026-09-21
Status: RECORDED / DEFERRED
Priority: non-blocking side task

## Context

The Mini Craft project intentionally moved Reviewer ↔ Executor handoff into GitHub so the Owner does not need to copy long logs between agents.

That direction is retained.

A weakness was observed during K3R9: the Executor returned only a single status label such as:

`PASS_CANDIDATE_K3R9_POST_RESTORE_VERIFY`

Although the detailed evidence existed in GitHub, a one-line label alone is too weak as a handoff receipt because it does not prove, in chat, which Gate was executed, whether the expected evidence files were updated, which commit contains the evidence, whether Owner action is required, or whether the Executor stopped at Reviewer.

## Proposed project-local improvement

Keep the dual-channel design:

- GitHub = complete evidence, durable truth, handoff documents, commit history;
- Chat = compact structured receipt.

The Executor chat receipt should contain at minimum:

```text
GATE=<current gate>
RESULT=<PASS_CANDIDATE_* | RETURN_*>
SUMMARY=<one short sentence>
EVIDENCE=<updated evidence/handoff files>
COMMIT=<GitHub commit SHA>
OWNER_ACTION=<NONE | exact bounded action>
NEXT=<STOP_AT_REVIEWER | STOP_AT_OWNER_CHECKPOINT>
```

Reviewer chat replies should likewise remain concise but state:

- current Gate / checkpoint;
- formal Reviewer decision;
- what changed in project truth;
- Owner action if any;
- next bounded step.

## Boundary

This document records a side task only.

It does NOT modify the active global Governance.
It does NOT activate the earlier Handoff V2 / review-packet experiment.
It does NOT block the Mini Craft payment mainline.

## Activation plan

After the current K3 payment issue reaches a stable resolution:

1. review the existing `docs/GITHUB_HANDOFF_PROTOCOL.md`;
2. incorporate the structured chat receipt requirement at project level;
3. run at least one complete Reviewer ↔ Executor Gate using it;
4. only after successful validation consider a separate Governance Change Gate for promotion beyond Mini Craft.
