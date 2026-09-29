# Reviewer Decision — G3C Block Editor Import Return

Date: 2026-09-30  
PR: #59  
Executor result: `RETURN_STARTER_IMPORT_FAILED`

## Reviewer decision

**ACCEPTED AS A NARROW RETURN, NOT AS PROOF THAT THE SELECTED TEMPLATE IS GENERALLY UNAVAILABLE.**

Accepted from PR #59:

- Astra 4.13.11 and Starter Templates 4.7.7 were installed in an isolated local runtime.
- Under **Build with Templates → Block Editor**, exact search `Bestselling Author` returned no result in Popular or Latest.
- The catalog endpoint responded successfully; this was not a generic network outage.
- No substitute template or hand-built lookalike was used.
- G3C product-page integration, preview regression, Woo path and mobile checks correctly did not claim PASS.
- Project-scoped cleanup passed.
- PayPal/payment, real-money, production AI, production deployment and Shared Infrastructure mutations remained zero.

## Scope correction

PR #59 proves:

```text
BESTSELLING_AUTHOR_BLOCK_EDITOR_CATALOG=NOT_FOUND
```

It does **not** yet prove:

```text
BESTSELLING_AUTHOR_ALL_FREE_BUILDERS=UNAVAILABLE
```

Current Astra public material still lists **Bestselling Author** as a free template, and Astra's current Elementor template catalogue specifically lists **Bestselling Author — Type: Free**. Therefore the selected template remains the Owner-preferred design until the free Elementor path is checked.

## Current state

```text
G3C_BLOCK_EDITOR_PATH=RETURN
G3CR1_ELEMENTOR_CLOSURE=CURRENT
OWNER_SELECTED_TEMPLATE=ASTRA_BESTSELLING_AUTHOR
TEMPLATE_RESELECTION_REQUIRED=NO_NOT_YET
G4=HOLD_NOT_AUTHORIZED
```

## Next step

Execute `G3CR1_BESTSELLING_AUTHOR_ELEMENTOR_CLOSURE.md`.

If the exact Bestselling Author starter is available through the free Elementor path, continue G3C productization using **Elementor Free** only.

If it is absent there as well, or requires a paid component, return to Reviewer and reopen template selection for Owner choice. Do not silently substitute another starter.

## PR #59 handling

PR #59 remains valid durable RETURN evidence. It is not a PASS candidate and should not be merged as though G3C completed. A fresh bounded closure run should carry forward only the accepted G3C scaffold/evidence needed for G3CR1.
