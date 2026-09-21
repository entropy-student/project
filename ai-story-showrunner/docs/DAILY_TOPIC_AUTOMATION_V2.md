# Daily Topic / Publishing Planner v0.2 — ACTIVE

> Activated after explicit G3R PASS on 2026-09-20.
>
> This planner is editorial only. It does not publish content, enter G4+, or prove production throughput.

## 1. Cadence

- Daily Topic Radar: enabled
- Timezone: Asia/Shanghai
- Preferred run: morning around 08:00
- Editorial cadence target: DAILY
- Rolling horizon: 7 calendar days

## 2. Canonical Inputs

- `docs/TOPIC_OPERATING_SYSTEM.md`
- `docs/BILIBILI_CHANNEL_STRATEGY.md`
- `docs/NARRATIVE_STYLE_CONTRACT.md`
- `topic-ledger/topic-registry.jsonl`
- `topic-ledger/EVERGREEN_BANK.md`
- `topic-ledger/calendar/YYYY-MM.md`
- `topic-ledger/daily/YYYY-MM-DD.json`

## 2.5 Independent Axes

The planner must keep these separate:

- `Lane = HOT / EVERGREEN`
- `Business Job = DISCOVERY / TRUST / SOLUTION`
- `Editorial Mode = STORY_MODEL / STORY_ACTION`

HOT is a supply source, not an editorial format.

## 3. Daily Selection

1. Fetch and verify current public AI signals.
2. Cluster duplicate coverage of the same event.
3. Run Human Relevance / Mechanism Integrity / One Mechanism / Storyability / Non-trivial Payoff / Audience Fit gates. For HOT candidates, also run Remove-the-brand / Durable mechanism / Human consequence / Half-life fit.
4. Run semantic duplicate gates against Topic Registry and recent story/visual motifs.
5. If a qualified HOT candidate exists, it may override the nearest unlocked `planned` slot.
6. Otherwise select a non-duplicate Evergreen candidate.
7. Maintain today + next 6 days.

### HOT candidate rule

A HOT candidate should preferably satisfy:

```text
current event
→ concrete human consequence
→ durable AI mechanism
→ story-worthy conflict
```

Reject / deprioritize:
- financing / personnel / benchmark news with no human consequence;
- model-number updates whose effect cannot be felt by the target audience;
- events that only work while company/product names remain in the title;
- topics whose useful half-life is shorter than current production latency.

During Season 0 Week 1, keep the baseline mostly Evergreen but allow 1–2 qualified HOT episodes if available. This is a test allowance, not a quota.

## 4. Editorial Mode

Every planned slot must have exactly one:

- `STORY_MODEL`
- `STORY_ACTION`

Initial seven-day portfolio hypothesis:
- 5 × STORY_MODEL
- 2 × STORY_ACTION

Quality gates outrank quota.

## 5. Duration

Suggested target:
- HOT: 3–5 min
- STORY_MODEL: 3–5 min
- STORY_ACTION: normally 3–5 min
- longer only when narrative genuinely requires it

## 6. Calendar Fields

| Date | Topic | Lane | Business Job | Editorial Mode | Target Duration | Status | Notes |

Statuses:
- planned
- locked
- published
- skipped
- validation

Only `planned` may be auto-overridden.

## 7. Governance

The Daily Radar must NOT:
- publish;
- mark content published without evidence;
- modify locked/published slots;
- enter G4 or later production gates;
- claim DAILY_PRODUCTION_CAPABILITY;
- relax KnowledgeCore or duplicate gates for a hot topic;
- force a HOT slot merely to satisfy a percentage target.

Production throughput remains:
`UNPROVEN until G4–G7 evidence`.

## 8. Automation State

`DAILY_TOPIC_PLANNER_V0_2 = ACTIVE`

The existing scheduled task is updated in place; do not create a duplicate daily planner task.
