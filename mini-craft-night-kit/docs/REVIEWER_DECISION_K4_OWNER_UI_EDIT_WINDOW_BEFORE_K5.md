# Reviewer Decision — K4 Owner UI Edit Window Before K5

Date: 2026-09-22
Status: OWNER UI EDIT WINDOW REQUIRED BEFORE FORMAL K4 CLOSE

## Context

Owner clarified that the previously planned Owner UI modification has not yet been performed.

The Executor already received the current `K4_UI_CONVERSION_TRUST_FINALIZE` instruction and may be modifying Product / FAQ / Shipping & Returns / Contact.

To avoid edit collisions, Owner should not edit those pages while the current Executor run is in progress.

## Required sequence

1. Executor completes the already-issued K4 finalize run and stops at Reviewer.
2. Reviewer does not formally close K4 yet.
3. Open one Owner UI edit window.
4. Owner may edit:
   - Home
   - Product
   - FAQ
   - Shipping & Returns
   - Contact
5. After Owner declares UI editing complete, Executor re-reads the latest WordPress/page state and performs only a bounded delta verification.
6. If the delta verification passes, K4 may formally PASS and K5 RC QA may begin.

## Collision rule

Do not allow Owner and Executor to modify the same page concurrently.

The latest Owner-approved page state becomes the baseline for the final K4 delta verification.

## Protected areas

The Owner UI edit window does not authorize changes to:
- Cart core flow;
- Checkout core flow;
- Account core flow;
- PayPal configuration;
- WooCommerce payment/order-state logic.

## Current state

The already-issued Executor run remains valid.

Formal K4 closure is deferred until the Owner UI edit window has occurred.

Pending checkpoint after Executor returns:

`OWNER_K4_UI_EDIT_WINDOW`
