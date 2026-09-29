# G3CR1 — Bestselling Author Elementor Closure

> Governance: VPS Project Governance v0.1.6 + current active addenda  
> Reviewer status: **CURRENT CLOSURE GATE / PROJECT-LOCAL REVERSIBLE EXECUTION AUTHORIZED**  
> Production / Live payment authority: **NONE**

## 1. Goal

Resolve the only open template-availability question left by PR #59:

> Is the Owner-selected **Astra Bestselling Author** starter available and importable through the current **free Elementor** path?

Do not reopen product architecture, payment architecture, privacy rules or template selection unless this closure proves the selected starter unavailable across the permitted free path.

## 2. Required read order

1. `../REVIEWER_HANDOFF.md`
2. `REVIEWER_DECISION_G3C_BLOCK_EDITOR_RETURN.md`
3. `G3C_UI_UX_PRODUCTIZATION.md`
4. `G3C_EXECUTION_PACKET.md`
5. `OWNER_DECISION_G3C_ASTRA_BESTSELLING_AUTHOR.md`
6. PR #59 evidence as historical Block Editor-return evidence

## 3. Phase A — exact Elementor availability check

Reconstruct a fresh isolated G3C runtime from committed project-local source.

Use only:

- Astra free theme;
- Starter Templates free plugin;
- Elementor free plugin if required by the exact starter.

In Starter Templates:

1. choose **Build with Templates**;
2. choose **Elementor**;
3. search exact text `Bestselling Author`;
4. check both Popular and Latest if the UI exposes them;
5. capture a sanitized screenshot and catalog/network read-back.

Do not select AI Builder.

### A1 — exact starter not found

Return:

`RETURN_G3CR1_ELEMENTOR_STARTER_UNAVAILABLE`

Then stop. Do not switch template.

### A2 — exact starter found but premium/paid dependency required

Return:

`RETURN_G3CR1_STARTER_REQUIRES_PAID_COMPONENT`

Then stop. Do not purchase anything.

### A3 — exact starter found and free-importable

Import **that exact starter** and record exact dependency versions.

Then continue Phase B in the same bounded run.

## 4. Phase B — continue existing G3C productization

Only after A3 PASS, continue the already-approved G3C implementation:

- preserve Astra + Bestselling Author visual shell;
- use Elementor Free only for the imported starter;
- integrate the accepted G2A1 Good Issue browser-local preview;
- preserve G3A WooCommerce/account/private-workspace baseline;
- create the Birthday Magazine product story and USD 39.99 Woo path;
- verify desktop + 375px mobile;
- verify preview uses browser-local object URL and uploads no photo;
- verify zero model/API calls;
- verify minimum account/private-workspace regression;
- capture required synthetic screenshots.

The detailed productization requirements and forbidden actions remain exactly those in `G3C_EXECUTION_PACKET.md`.

## 5. Non-regression / forbidden actions

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
WOO_COMMERCE_CANONICAL_ORDER_SYSTEM=YES
AUTHENTICATED_ACCOUNT_MVP=YES
LIVE_PAYPAL_ACTIONS=0
SANDBOX_PAYMENT_ACTIONS=0
REAL_MONEY_ACTIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PAID_PLUGIN_PURCHASES=0
AI_BUILDER_USED=NO
```

G4 remains HOLD.

## 6. Success return

If exact free Elementor import and the full G3C productization both pass:

```text
PASS_CANDIDATE_G3CR1_G3C_UI_UX_PRODUCTIZATION
BESTSELLING_AUTHOR_ELEMENTOR_FREE_IMPORT=PASS
GOOD_ISSUE_PREVIEW_INTEGRATED=PASS
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
WOO_COMMERCE_PATH=PASS
USD_39_99=PASS
DESKTOP_UI=PASS
MOBILE_375_UI=PASS
ACCOUNT_PRIVATE_REGRESSION=PASS
PAYMENT_ACTIONS=0
PRODUCTION_AI_CALLS=0
SHARED_INFRA_MUTATIONS=0
OWNER_VISUAL_FREEZE=PENDING
STOP_AT_REVIEWER=YES
```

If Elementor availability fails, use the precise RETURN from Phase A and stop.
