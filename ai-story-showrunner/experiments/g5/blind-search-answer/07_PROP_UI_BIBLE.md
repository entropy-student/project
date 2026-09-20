# Blind Search Answer — Prop / UI Bible v0.1

## UI_AI_ANSWER_001

Status:
`SPEC_LOCKED / CANONICAL_MASTER_TO_GENERATE`

Fictional non-branded AI answer pane.

Stable layout:
- concise answer region;
- source region directly below;
- no real company logo;
- enough surrounding UI to read as an answer interface, but no dense chat history.

Required states:
1. ANSWER_YES_WITH_SOURCE
2. ANSWER_RECHECKED_CHANGED

Critical exact text:
- “会”
- official-source cue

Text render:
`POST_OVERLAY` for exact wording.

---

## UI_POLICY_PAGE_001

Status:
`SPEC_LOCKED / CANONICAL_MASTER_TO_GENERATE`

This is ONE stable fictional official refund-policy page reused across the episode.

Stable layout:
- policy title at top;
- policy sentence A above policy sentence B;
- margins / type blocks remain constant;
- same page geometry in every beat.

Required content:
A. “退款完成后，订单款项将退回原支付方式。”
B. “平台服务费不予退还。”

Required states:
1. PAGE_FULL
2. LINE_A_FOCUS
3. MOVE_TO_LINE_B_SETUP
4. LINE_B_FOCUS
5. QUESTION_VS_EVIDENCE_MATCH
6. EVIDENCE_RECHECK

Exact text render:
`POST_OVERLAY`

Important:
do not generate a new random webpage for each state.

---

## PROP_COST_SHEET_001

Status:
`SPEC_LOCKED / CANONICAL_MASTER_TO_GENERATE`

One simple cost-sheet document on IP desk.

Critical state:
- “服务费：可退”

Exact text render:
`POST_OVERLAY`

It appears to prove that the wrong answer changed a real decision.

---

## PROP_CONTACT_BOOK_001

Status:
`SPEC_LOCKED / CANONICAL_MASTER_TO_GENERATE`

Fictional contact book / contact record.

Required:
- boss contact record clearly identified;
- fictional placeholder phone number beginning “138…”;
- no real personal data.

Story function:
correct record found, wrong facet answered.

Text render:
`POST_OVERLAY`
