# Reviewer Decision — K3R11 Owner Sandbox Reconnect

Date: 2026-09-21
Status: OWNER CHECKPOINT AUTHORIZED

## Independent review

Reviewer independently inspected Executor commit:

`ac80184082607502e2d547e8ec7646c8db58465a`

Accepted facts:

- Owner already rotated the affected Sandbox Secret;
- Executor created and verified the required rollback point;
- WordPress home/site URL remain `http://localhost:8093/`;
- WordPress and MariaDB runtime remain healthy;
- PPCP Sandbox mode remains enabled;
- onboarding state remains completed;
- PPCP merchant connection is now invalid/disconnected after Secret rotation;
- no public HTTPS origin or tunnel was created;
- no WordPress URL, plugin, version, source, Live, payment, VPS, or production-domain mutation occurred;
- Executor did not request/read/output the replacement Sandbox Secret.

Reviewer accepts:

`RETURN_OWNER_K3R11_SANDBOX_RECONNECT_REQUIRED`

## Owner action

Owner is authorized to perform exactly one local Sandbox Manual Connect using the already-rotated Sandbox credentials at:

`http://localhost:8093/wp-admin/admin.php?page=wc-settings&tab=checkout&section=ppcp-gateway`

The replacement Secret must be entered only in the local WooCommerce PayPal Settings UI.

Do not paste Client ID, Secret, token, cookie, response body, merchant ID, or headers into chat/GitHub.

Return only:

```text
MANUAL_CONNECT_RESULT=SUCCESS|FAIL
VISIBLE_MESSAGE=<sanitized short UI message or NONE>
```

If the UI reports success, stop. Do not create a public origin manually and do not attempt checkout/capture.

## Resume condition

After Owner reports the local reconnect result:

- Reviewer records the result;
- if success, Executor resumes K3R11 public-origin preparation;
- if failure, no repeated blind reconnect is authorized and Reviewer will re-open the connection diagnostic path.

## Current checkpoint

`OWNER_K3R11_SANDBOX_RECONNECT_REQUIRED`
