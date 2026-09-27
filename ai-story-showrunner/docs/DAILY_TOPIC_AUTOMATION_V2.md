# Daily Topic / Publishing Planner v0.2.1 — ACTIVE

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

## 3. Daily Selection

1. Fetch and verify current public **human-interest + AI/domain signals**. Human-interest discovery may include food, relationships, work, consumption, entertainment, personality/identity labels, learning, games, travel and other audience-relevant X domains; do not require every candidate to originate from AI news.
2. Cluster duplicate coverage of the same event / human phenomenon.
3. For each candidate, first attempt `X → Observed Paradox → WHY → Human Tension → AI Changed Process`. Strong AI-first signals may use the compatibility route `AI Signal → Audience Translation → Human Problem`.
4. Run Native X Interest / WHY-Paradox / Human Tension / Changed Process pre-gates, then Human Relevance / Mechanism Integrity / One Mechanism / Storyability / Non-trivial Payoff / Audience Fit gates.
5. Run semantic duplicate gates against Topic Registry and recent story/visual motifs.
6. If a qualified HOT candidate exists, it may override the nearest unlocked `planned` slot.
7. Otherwise select a non-duplicate Evergreen candidate.
8. Maintain today + next 6 days.

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
- relax KnowledgeCore or duplicate gates for a hot topic.

Production throughput remains:
`UNPROVEN until G4–G7 evidence`.

## 8. Automation State

`DAILY_TOPIC_PLANNER_V0_2 = ACTIVE`

The existing scheduled task is updated in place; do not create a duplicate daily planner task.


## 9. v0.2.1 Compatibility

- Do not retroactively rewrite existing Calendar / Registry / Daily snapshots.
- Existing AI-first candidates remain valid if they pass the full gates.
- The new human-world-first entry is the default discovery preference, not a ban on AI-first topics.
- Current scheduled execution outside GitHub is not modified by this document write alone; runtime automation should consume this contract on its next maintained update.
