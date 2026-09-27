# Reviewer Decision — K7 R1 Resend Key Owner Checkpoint / Tax Equivalence

Date: 2026-09-28
Role: Reviewer / Architect / Gatekeeper

## Executor checkpoint

Result:
RETURN_OWNER_RESEND_API_KEY_INTERACTIVE_ENTRY_REQUIRED

Reviewer accepts this as the expected Secret-entry checkpoint.

Official Resend plugin is installed and active.
No API key value has been read or entered by Executor.
No email/order/payment action occurred.

## Owner action

Owner must create one Resend API key with:
- permission: Sending access
- domain restriction: minicraft.spikersun.com

Owner must paste the key directly into the official Resend WordPress plugin UI and save it.

The key value, prefix, hash, token fragment or credential material must not enter chat, GitHub, Evidence or Executor logs.

After Owner confirms direct entry/save, continue the same Gate. No new business authorization is required.

## Canary tax-control reconciliation

Executor observed:
- WooCommerce global tax calculation is disabled;
- therefore the product editor does not expose the per-product Tax status control;
- Canary product remains draft and no global-tax setting was changed.

Reviewer decision:

CANARY_TAX_CONTROL=NOT_APPLICABLE_WHILE_GLOBAL_TAX_DISABLED
STORE_TAX_ENABLED=NO
CANARY_EXPECTED_TAX_JPY=0

The earlier desired product-level setting TAX_STATUS=none is superseded for this Gate by the effective invariant above.

Do NOT enable WooCommerce global taxes merely to expose a product-level Tax status field.

The Canary product may be published after all other exact fixture fields are verified, provided:
- global tax remains disabled;
- populated Checkout proves tax JPY 0;
- item JPY 500;
- shipping JPY 0;
- final order total JPY 500.

If any populated Checkout amount differs, RETURN before order/payment action.

## Current Gate

CURRENT_GATE=K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION
CURRENT_GATE_STATUS=AWAIT_OWNER_RESEND_API_KEY_DIRECT_ENTRY

Existing authorization remains valid:
AUTHORIZE_K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION

## Still forbidden

No:
- PayPal Live;
- PayPal login/merchant authorization;
- order creation;
- real or Sandbox buyer payment;
- auth/capture/refund;
- webhook money-flow mutation;
- Product223 mutation;
- global tax enablement;
- Soft Launch;
- Secret output.
