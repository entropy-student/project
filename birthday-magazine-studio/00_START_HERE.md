# Birthday Magazine Studio — START HERE

This file is navigation only. It is **not** a second project truth source.

## Read order

1. [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — the only current Reviewer/project truth.
2. [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md) — document roles and authority.
3. [EXECUTOR_HANDOFF.md](./EXECUTOR_HANDOFF.md) — latest Executor execution facts.
4. [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) — detailed sanitized evidence.
5. Current/next Gate material referenced by the Handoff.
6. Historical research/prototype documents only when needed.

## Current snapshot

- P0 / G1 / G2A1 / G2A2 / G2B / G3A: accepted PASS at their defined scope.
- **G3B / G3BR1: PASS** — PayPal Sandbox capture correlation, paid-entitlement 0→1 behavior, one Owner-authorized full Sandbox refund, entitlement revocation, and scoped cleanup are closed.
- **G3CR2R3 compatibility canary: PASS** — Blocksy Wedding Gutenberg imported successfully; WooCommerce product/cart/checkout/account/private-workspace compatibility and Gutenberg editability passed.
- **G3C implementation is on PR #64.** Reviewer created the PR and closed the GitHub-auth blocker. Final technical PASS is pending only the current corrected screenshot set and independent 375px verification.
- **Owner visual review: RETURN** — current 17-screenshot package shows fragmented hierarchy, duplicate content, excessive mobile length, and a real 375px Preview clipping defect.
- **G3CR4 visual consolidation: PASS** — homepage is now six primary editable sections; sample density/duplicate content/large spacer issues are corrected; 375px Preview is single-column without detected clipping.
- **G3CR5 visual finish + Woo continuity: PASS** — selected-photo Preview no longer overlaps copy; Woo Product/Cart/Checkout/My Account now share the homepage editorial styling on desktop and 375px.
- **G3C Owner Visual Checkpoint: RESOLVED / OPTION B** — Owner did not accept the G3CR5 visual state as final freeze and requested a stronger redesign.
- **G3CR6 Frontend Experience + Brand Redesign: RETURN** — privacy/Woo/375px regression evidence is accepted as baseline, but the submitted frontend remained too close to the prior template composition and did not sufficiently realize the selected Warm Birthday Gift direction.
- **G3CR6R1 Frontend Composition Redesign: PASS** — the homepage/Woo frontend composition is materially rebuilt into the Warm Birthday Gift direction; Preview/privacy/native Woo/mobile/editability regressions passed.
- **G3C Owner Visual Checkpoint R2: RESOLVED / BOUNDED CHANGE** — Owner broadly accepts the composition but requests a correction to the photo-upload Preview experience.
- **G3CR6R2 Free Preview Activation Polish: CURRENT** — keep the browser-local personalized preview capability, but stop framing the product as “photo → cover”; value must be understandable before upload and the personalized state must read as a magazine experience. PR #64 remains open/unmerged.
- **G4 Live PayPal Canary: HOLD / NOT AUTHORIZED**.
- PayPal Live, real-money payment, production AI provider, production private delivery and production deployment remain unproven.

## Source-of-truth rule

Do not infer current status from old research, prototype copy, README snapshots or chat history. If anything conflicts with `REVIEWER_HANDOFF.md`, the Handoff wins unless the Owner gives a newer explicit instruction.

Historical Evidence is preserved rather than rewritten; stronger later read-back supersedes earlier diagnosis through Reviewer decisions and the current Handoff.
