# G4R v0.3 — Blind Case 04 Protocol

## Topic
AI 明明搜到了正确网页，为什么最后还是会答错？

## Blind-test purpose
Test whether the frozen six-layer Director architecture can handle an unseen INVESTIGATION_DISCOVERY story without structural modification.

## Frozen rules
- source: docs/G4_DIRECTOR_LANGUAGE_RULES_CANDIDATE_V03.md
- blob SHA: fccc6a6bad667d6a013183f8d0a9f998d448b5d4

## Hard constraints
1. Do not modify v0.3 rules during this blind run.
2. Do not use Agent / Context-Memory / MCP Shotbooks as design sources.
3. If the new case exposes a missing rule, record it as blind-test evidence first.
4. Script coverage must be 100%.
5. Director must not turn the explanation into a RAG architecture diagram unless story-world action cannot preserve accuracy.
6. G5 remains out of scope.

## Pass criterion
The case can be fully compiled through all six layers using episode-specific configuration only.

## Failure criterion
The case requires a seventh architectural layer or a material rewrite of an existing layer.