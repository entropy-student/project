# G4 Director Rules Final Re-review v0.3

## Final review

The previous five-layer architecture is not sufficient as the long-term Director architecture.

Missing layer:
Episode / Sequence Visual Strategy.

Without it, every shot can be locally justified while the whole episode remains visually scattered.

## McKee correction
- use Sequence → Scene → Beat;
- Beat changes behavior/tactic, not necessarily major value;
- Scene should turn a perceptible value/state;
- Sequence carries larger cumulative change.

## Jingsui correction
- 5.92 chars/s and 2.7s are calibrated sample priors, not targets;
- timing never decides whether a shot exists;
- real channel/voice evidence may replace this timing prior without rewriting Director logic.

## Additional robustness correction
Explicitly support continuity and non-continuity image relations:
CONTINUITY / PARALLEL / MONTAGE / CONTRAST / METAPHOR / INSERT_LED / CLARIFY.

## Final recommended layers
1. Dramatic Hierarchy Map
2. Episode / Sequence Visual Strategy
3. Visual Intention Map
4. Semantic Shot Design
5. Visual Beat Compilation
6. Timing & Edit Calibration

## Why six is enough
G5 already owns Character / Scene / Style / reference-asset locking.
Adding asset compilation as another Director layer would mix shot design with downstream production.

## Known project conflicts to reconcile after approval
1. Writer Quality Contract still contains a provisional 5.0 chars/s SRT rule; current calibrated prior is ~5.9.
2. Writer/Channel duration guidance still says 3–5 min, while current G4 timed cases cluster around 2:30–2:52.
Neither should be silently changed before Owner accepts the new baseline.

## Validation requirement
Rerun the three known cases plus at least one unseen fourth case before canonical promotion.