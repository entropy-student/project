# M2B-R1 — Cloudflare Browser Context Recovery + Conditional Resume

## Gate

```text
M2B_R1_CLOUDFLARE_BROWSER_CONTEXT_RECOVERY_AND_RESUME
OWNER_BROWSER_CHECKPOINT=YES
CONDITIONAL_PROVIDER_WRITE=YES
STOP_AT_REVIEWER=YES
```

## Owner action first

Owner manually opens the intended Cloudflare Dashboard browser session, signs in if needed, navigates to:

```text
Tunnel: spikersun-shared-private
View: Public Hostnames / hostname routes
```

and leaves that page open.

Do not request or expose credentials, 2FA, recovery codes, API tokens, session cookies, or sensitive screenshots.

## Executor after Owner checkpoint

Read latest canonical Governance and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2B_RETURN_R1_BROWSER_CONTEXT_RECOVERY.md
shared-vps-infrastructure/review-packets/M2B_TEMPORARY_TUNNEL_CANARY_EXECUTION.md
```

Before any write, prove from the browser control surface:

```text
CLOUDFLARE_DASHBOARD_CONTEXT=VERIFIED
AUTHENTICATED_SESSION=YES
TUNNEL_PAGE=spikersun-shared-private
PUBLIC_HOSTNAME_VIEW_AVAILABLE=YES
```

If browser page identity / URL / Tunnel context cannot be reliably established:

```text
RETURN_CLOUDFLARE_BROWSER_CONTEXT_UNVERIFIED
STOP_AT_REVIEWER=YES
```

If unauthenticated:

```text
RETURN_OWNER_CLOUDFLARE_SESSION_REQUIRED
STOP_AT_REVIEWER=YES
```

## Conditional resume of M2B

If browser context PASSes, Owner authorization remains valid. Immediately resume the existing M2B execution packet from Phase A:

```text
TEMP_HOSTNAME=minicraft-m2b-canary.spikersun.com
TUNNEL=spikersun-shared-private
ORIGIN_SERVICE=http://mini-craft-night-kit-wordpress:80
ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com
```

Do not broaden the scope.

The original mandatory cleanup and no-M2C rules remain in force.

## Result

If context recovery alone fails, return the precise browser/session RETURN above.

If context recovery succeeds and M2B completes, return the original M2B success contract.

If M2B enters provider preflight or mutation and later returns, persist canonical Evidence/Handoff before STOP_AT_REVIEWER.
