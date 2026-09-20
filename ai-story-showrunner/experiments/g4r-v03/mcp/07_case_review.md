# MCP Case — G4R v0.3 Experimental Review

## Result
`PASS_CANDIDATE`

This case supports the six-layer architecture without adding another rule layer.

## 1. Output
- Dramatic Sequences: 6
- Semantic Shots: 35
- Visual Beats: 60
- Reference duration: ~169.44s / 2:49
- Average Visual Beat: ~2.82s
- P25 / Median / P75: ~1.79 / 2.71 / 4.03s
- Locked-script coverage: 100%

Historical v0.1:
- Semantic Shots: 44
- Visual Beats: 63
- Reference duration: ~166.38s / 2:46

## 2. What improved

### A. Repeated questions are treated as one dramatic friction unit
Inventory and finance question chains are not split into one Semantic Shot per sentence.
The Director preserves each department encounter as one coherent event, then uses Visual Beats only when attention/object/reaction actually changes.

### B. Repetition and variation are now designed at episode level
The hallway stays visually coherent.
Department differences live mainly in:
- handles / entry devices;
- local identifiers;
- local rule props;
- onboarding manuals.

This prevents random scene-generation drift while still making each system feel different.

### C. MCP stays out of diagram mode
The mechanism is carried by:
`task → unfamiliar door → local training → repeat at new door → common service placard → AI self-discovers/uses capability`.

No architecture diagram is required for the core explanation.

### D. Knowledge boundaries survive visual simplification
The visual system preserves that:
- MCP does not make the model smarter;
- MCP does not erase differences between systems;
- MCP does not replace underlying APIs/auth/business rules;
- standardization is at the interaction/discovery/call layer.

### E. Anti-montage-inflation works
Department examples are often shown in paired/parallel compositions rather than one image per spoken item.
This keeps a 932-normalized-character script at 60 beats instead of exploding into a card sequence.

## 3. Timing finding

The new case lands at ~2:49, very close to historical ~2:46 despite a different decomposition logic.

Median beat duration ~2.71s happens to align with the old Jingsui sample median, but this was not used as a target.

Sequence 4 (training-all-systems montage) is intentionally faster (~1.86s average beat).
Sequence 3 and 6 hold longer because comparison/recognition/clarification need more reading time.

This is the desired behavior: timing distribution follows sequence function.

## 4. Representative decomposition

Narration:
> 它问我：“库存在哪？”……“怎么查？”

Old risk:
one question → one image → visual fragmentation.

v0.3:
Semantic Shot:
one inventory-door friction event.

Visual Beats:
1. AI reaches the inventory entrance and asks where the backend is;
2. additional local questions reveal the unfamiliar control/entry method.

The change from Beat 1 to Beat 2 is not punctuation; it is the shift from general location confusion to local-operating-method confusion.

## 5. Final payoff decomposition

Narration:
> 一个什么都会的员工，每天站在不同部门门口。等着我过去告诉它——门把手，到底在哪。

Visual logic:
1. capable employee;
2. repeated different doors;
3. IP walks over again;
4. anticipation: hand searches along the odd doorway;
5. reveal/landing: local handle/entry point is finally indicated.

This reuses the Agent-case reveal rule: setup and object-reveal may separate when the reveal itself carries the punchline.

## 6. Does the architecture survive?

Yes.

MCP required only a new episode configuration:
- REPEATED_FRICTION engine;
- hallway/department world;
- door-handle motif;
- onboarding-manual motif;
- parallel/montage routing;
- standardized placard payoff.

No change was required to the six layers.

## 7. Current recommendation

Keep v0.3 six-layer architecture.
No new structural rule is required from MCP.

Known-case revalidation status:
- Agent: PASS_CANDIDATE with schema refinements;
- Context / Memory: PASS_CANDIDATE with script-coverage + anti-montage-inflation refinements;
- MCP: PASS_CANDIDATE with no new architecture change.

Next validation should be an unseen fourth script before canonical promotion.