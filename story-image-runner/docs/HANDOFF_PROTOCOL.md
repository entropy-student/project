# Story Image Runner — GitHub Handoff Protocol

This project follows the canonical project/governance model already used in `entropy-student/project`.

## Source of truth order

```text
1. Owner latest explicit instruction
2. PROJECT_RECORD.md
3. CURRENT_STATUS.json
4. REVIEWER_HANDOFF.md
5. accepted EXECUTION_EVIDENCE.md
6. EXECUTOR_HANDOFF.md
7. docs/ROADMAP.md
8. historical chat / external references
```

Governance rules default to:

```text
entropy-student/spike.skill/vps-project-governance
```

## Reviewer owns

- `PROJECT_RECORD.md`
- `CURRENT_STATUS.json`
- `REVIEWER_HANDOFF.md`
- `docs/*DECISION*.md`
- Gate contracts and acceptance truth

## Executor owns

- implementation code;
- tests;
- `EXECUTION_EVIDENCE.md`;
- `EXECUTOR_HANDOFF.md`;
- bounded runtime manifests/evidence indexes.

## PASS boundary

Executor:

`PASS_CANDIDATE_<GATE>`

Reviewer:

`PASS_<GATE>`

## Required structured receipt

```text
GATE=<gate>
RESULT=<PASS_CANDIDATE... | RETURN_...>
SUMMARY=<one short factual summary>
EVIDENCE=<paths>
COMMIT=<sha>
OWNER_ACTION=<NONE | exact bounded action>
NEXT=STOP_AT_REVIEWER
```

## Secret boundary

Never commit or paste:

- cookies;
- ChatGPT session tokens;
- account passwords;
- browser profile databases;
- access tokens;
- API secrets;
- raw sensitive user data.

## State drift

Before a consequential next Gate, Reviewer reconciles project truth with accepted evidence.

Do not delete historical evidence to manufacture consistency.
