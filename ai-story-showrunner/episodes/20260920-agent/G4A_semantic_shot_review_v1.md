# G4A Agent Semantic Director Review v1

## Result

`PASS_CANDIDATE`

## Scope

This review validates semantic shot decomposition only.
No exact timestamps are accepted because no final audio master exists yet.

## Counts

- semantic shots: 36
- expected images if one-shot/one-image remains: ~36
- recurring characters: 2
- recurring scenes: 2 primary scene IDs

## PASS Findings

1. Shot boundaries follow visual-state changes rather than punctuation.
2. Dialogue/reaction beats remain character-led.
3. Mechanism reveal does not switch to an architecture diagram.
4. UI is used only when the UI state itself is a story event.
5. Concrete method examples stay inside actions instead of becoming a checklist slide.
6. The final viewpoint is expressed by a threshold/knock action rather than a quote card.
7. More images are used where they simplify execution; no attempt is made to compress the episode into a few reusable slides.

## Risks

### R1 — Visual metaphor over-literalization
`确认按钮 / 审批插件 / 敲门` are useful motifs, but production must keep the IP human rather than turning every phrase into a literal gag.

### R2 — Same-desk fatigue
Most of the episode occurs at one shop desk. G5/G6 should preserve spatial continuity while varying composition, foreground object, insert/reaction framing, and character blocking.

### R3 — UI text density
Refund details must remain visually concise. Long readable UI text would become PPT/explainer content.

### R4 — Audio timing unresolved
Final shot duration cannot be accepted until audio is locked.

## G4A Gate

`AGENT_G4A = PASS_CANDIDATE`

Next within G4:
- validate semantic-shot schema mechanically;
- compare against a second topic before promoting G4A compiler rules;
- choose audio path before G4B exact timeline compilation.

G4 overall remains IN_PROGRESS.