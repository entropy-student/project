# Reviewer Decision — K3R6 PASS / Owner Sandbox Auth Checkpoint

Date: 2026-09-21

## Decision

```text
K3R6_PPCP_PAGE_SCOPE_MOUNT_ISOLATION=PASS
PPCP_DIRECT_SETTINGS_UI=PASS
PPCP_OVERVIEW_REACT_299=KNOWN_NONBLOCKING_ADMIN_DEFECT
CURRENT_CHECKPOINT=OWNER_K3_PAYPAL_SANDBOX_AUTH_DOCKER
```

## Accepted result

K3R6 established that the PPCP React #299 is scoped to the generic WooCommerce Payments overview and does not block the direct PayPal settings section.

The direct `section=ppcp-gateway` page is accepted as usable for the K3 Sandbox onboarding flow.

## Current Owner action

On the active Docker/MariaDB runtime at `http://localhost:8093/`, complete only the provider-side PayPal Sandbox login/account authorization from the direct PayPal settings UI.

Do not share passwords, client secrets, OAuth codes, tokens, cookies, or webhook secrets in chat/GitHub.

Do not enable Live.

After Owner confirms Sandbox authorization, resume the SAME K3 Gate for checkout approval/capture, WooCommerce order correlation/state, callback/webhook validation, and bounded Sandbox refund.

## Known defect carry-forward

`PPCP_OVERVIEW_REACT_299=KNOWN_NONBLOCKING_ADMIN_DEFECT`

Do not use the generic Payments overview as the authoritative PPCP settings health signal; use the direct PayPal section.