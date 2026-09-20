# Blind Search Answer — G5A Asset Inventory

> Status: G5A asset extraction complete. No image generation has started.

## Assets

| Asset ID | Type | Scope | Reference status | Purpose |
|---|---|---|---|---|
| CHAR_IP_001 | CHARACTER | GLOBAL | MISSING_REAL_ASSET | Recurring first-person channel IP. Must match the user's existing canonical three-view reference when provided/mounted. |
| SCENE_WORKDESK_001 | SCENE | EPISODE | TO_GENERATE_CANONICAL | Stable IP work desk used for query, cost-sheet decision, evidence checking, and closing callback. |
| UI_AI_ANSWER_001 | UI_DOCUMENT | EPISODE | TO_GENERATE_CANONICAL | Fictional AI answer pane with concise answer, source cue, and matched before/after states. |
| UI_POLICY_PAGE_001 | UI_DOCUMENT | EPISODE | TO_GENERATE_CANONICAL | Single fictional official refund-policy master page reused throughout the investigation. |
| PROP_COST_SHEET_001 | PROP | EPISODE | TO_GENERATE_CANONICAL | Cost sheet where the wrong operational assumption 服务费：可退 is recorded. |
| SCENE_PHONEBOOK_ANALOGY_001 | SCENE | SEQUENCE | TO_GENERATE_CANONICAL | Minimal temporary analogy scene for boss-attendance vs boss-phone-number mismatch. |
| PROP_CONTACT_BOOK_001 | PROP | SEQUENCE | TO_GENERATE_CANONICAL | Fictional contact-book page for the boss analogy. |
| STYLE_CHANNEL_001 | STYLE | GLOBAL | TO_GENERATE_CANONICAL | Channel visual style lock: story-first limited-animation still illustration; character-led, clean readable staging, non-PPT, non-infographic. |

## Blocking finding

`CHAR_IP_001 = MISSING_REAL_ASSET`.

The repository does not currently contain the user's canonical IP three-view reference.
Therefore any beat requiring the recurring IP can be fully specified but cannot be honestly marked generation-ready until that real reference is mounted/provided.

All episode-specific scene/UI/prop masters are `TO_GENERATE_CANONICAL` and can be produced inside G5B before per-beat generation.

## Reuse strategy

- one stable work-desk master;
- one stable fictional AI-answer UI master;
- one stable fictional official-policy-page master;
- one cost-sheet prop;
- one minimal phonebook analogy scene + contact-book prop;
- one global channel style lock;
- one global recurring IP identity.

## Next phase

`G5B Canonical Reference Lock`:
1. define Character Bible around existing IP reference requirement;
2. define work-desk Scene Bible;
3. define official-policy-page/UI master states;
4. define Style Bible;
5. generate/select canonical non-character refs;
6. then compile per-beat final image rows.