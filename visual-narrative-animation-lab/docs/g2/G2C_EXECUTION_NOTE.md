# G2C Execution Note — Image-generation routing failure

## Event
During G2C1, attempts intended to generate individual clean production frames were repeatedly interpreted by the image-generation runtime as requests for a full storyboard/contact-sheet overview.

## Impact
- No accepted production asset was overwritten.
- Misfire outputs were treated as rejected proof material.
- The text policy remained unchanged: important readable copy must not be baked into generated images.

## Decision
Do not retry the same route blindly. Preserve the Director/asset contract and treat image generation as a bounded execution subtask. If single-shot generation continues collapsing into contact sheets, switch the implementation layer rather than redesigning the project architecture.

## Gate status
The shot-resolution plan and Art Bible remain valid. The issue belongs to the clean-frame generation subtask, not to the Director grammar.
