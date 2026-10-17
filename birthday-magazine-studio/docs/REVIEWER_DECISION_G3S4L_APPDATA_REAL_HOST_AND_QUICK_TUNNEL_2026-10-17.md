# Reviewer decision — AppData path proof gap; Quick Tunnel as lower-friction temporary HTTPS option

Date: 2026-10-17
Status: `RECONCILE_HOST_STORAGE_BEFORE_NEW_LOCAL_SECRET_OR_PUBLICATION_WRITE`
Canonical Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7, **read in full 609 lines**; especially §1, §3, §4 storage, §§5–10, triggered 11A/11B/11C/11D/11E and 11F if cleanup is proposed; §§12–13.
Proven recurring issue: `entropy-student/spike.skill/main/vps-project-governance/history/incidents/2026-09-29_PACKAGED_APP_APPDATA_PATH_VIRTUALIZATION.md`.
Latest actual PR #64 Executor Evidence: `bb04c27ba0dca4dd3ea081f265bdedf852090106`, G3S4L file only, branch open/unmerged.
Owner's latest instruction: files under AppData are problematic; Codex has previously claimed a file exists that Owner could not find; asks exact full Governance read, checks old simpler public URL method.

## Reviewer classification

```text
CURRENT_DECISION=G3S4L_LOCAL_PREP_PARTIAL;HOST_LOCAL_TARGET_PATH_PROOF_UNVERIFIED
APPDATA_CREATION_CLAIM=EXECUTOR_READBACK_INSIDE_ITS_WINDOWS_CONTEXT
HOST_NATIVE_ORDINARY_APPDATA_READBACK=NOT_YET_PROVEN
PACKAGED_APP_LOCALCACHE_REDIRECTION=KNOWN_HISTORICAL_CAUSE;CURRENT_FILE_LOCATION_NOT_YET_PROVEN
NEW_PROJECT_APPDATA_WRITES=HOLD_UNTIL_EXACT_HOST_PATH_RECONCILED
LATEST_EXECUTOR_COMMIT=bb04c27ba0dca4dd3ea081f265bdedf852090106
EXISTING_PATH_CLAIM=%LOCALAPPDATA%/BirthdayMagazineStudio/G3S4L/remote-managed-tunnel-20261017
CLAIMED_TOKEN_FILE=EMPTY_ZERO_BYTES_NO_ACTUAL_TOKEN
CLAIMED_HELPER=Set-StripeTestTunnelToken.ps1_NOT_RUN
CLOUDFLARED=SIGNED_2026_10_1_EXECUTOR_REPORTED_EXISTENCE;REAL_NATIVE_HOST_PATH_UNVERIFIED
QUICK_TUNNEL_OFFICIAL=cloudflared tunnel --url http://127.0.0.1:8189
QUICK_TUNNEL_ACCOUNT_AUTH_DNS_OR_SCOPED_TOKEN=NOT_REQUIRED
QUICK_TUNNEL_PUBLIC_HOST=EPHEMERAL_RANDOM_TRYCLOUDFLARE_URL
QUICK_TUNNEL=NOT_RUN
QUICK_TUNNEL_FOR_STRIPE_TEST_OAUTH=NOT_VERIFIED
NAMED_STABLE_TUNNEL=OPTIONAL_FUTURE_FALLBACK_FOR_PERSISTENT_HOSTNAME
WORDPRESS_PUBLICATION=ORIGINAL_LOCAL_8189_OWNER_INTENT_BUT_SECURITY_PREREQUISITES_APPLY
ORIGINAL_WP_HOME_SITEURL=http://127.0.0.1:8189_UNCHANGED
STRIPE_ACCOUNT_PAYMENT_WEBHOOK=UNCONFIGURED_NOT_TESTED
NEW_TOKEN_CREDENTIAL_STORAGE=NOT_REQUIRED_FOR_QUICK_TUNNEL
DELETION_CLEANUP_OR_MIGRATION=NOT_AUTHORIZED_UNVERIFIED_OWNERSHIP
CANONICAL_GOVERNANCE_WRITE=NONE
OWNER_ACTION_REQUEST_THIS_REVIEW=NONE
```

## Findings

1. **Host-local write cannot PASS on packaged execution alone.** Codex's new G3S4L PR Evidence reports that it created `%LOCALAPPDATA%\BirthdayMagazineStudio\G3S4L\remote-managed-tunnel-20261017`, an **empty** `stripe-test.spikersun.com.connector-token`, and `Set-StripeTestTunnelToken.ps1`; claims PowerShell 5.1 successful ACL readbacks. This proves at most its reported execution **context**, not that an independent normal Owner Windows PowerShell can see the *same physical bytes* at the ordinary `%LOCALAPPDATA%` path. Governance §11B explicitly says Windows packaged-app file-system virtualization must be ruled out before declaring missing or successful host-local write. Do not promote these AppData artifacts to verified real-owner-host storage or start an actual token input.
2. **Historical direct corroboration:** 2026-09-29 Mini Craft Night Kit and 2026-10-02 VPN had artifacts physically redirected to `%LOCALAPPDATA%\Packages\OpenAI.Codex_*\LocalCache\Local\...`, while Owner-normal `%LOCALAPPDATA%` appeared empty. An earlier Birthday Magazine G3S4A Owner PowerShell launcher was likewise absent at expected ordinary path despite Codex file reports; Handoff details this separate current-project mismatch. Current exact G3S4L physical location is **UNKNOWN until checked**, not automatically assumed inside LocalCache.
3. **Simpler supported public-URL path exists.** Cloudflare official [Quick Tunnels](https://developers.cloudflare.com/tunnel/get-started/quick-tunnels/) generate random public `https://*.trycloudflare.com` URL from **one `cloudflared tunnel --url http://127.0.0.1:8189`**. No Cloudflare account/domain/DNS/cert/token-file/browser OAuth required. URL changes each run, only lives while process runs, has no uptime guarantee and grants public access to anyone with URL; **not production**. This is ideal for short **HTTPS/anonymous-private-route/checkout technical canary**, not a guaranteed stable provider checkout/Webhook solution. Official Woo Stripe OAuth and signed provider callbacks can be attempted only with a valid currently live HTTPS WordPress canonical URL, reversible settings, no private guest leak, an actual Owner TEST account and a bounded non-Live session; Quick Tunnel compatibility is not yet proven.
4. **Previously achieved public HTTPS path was different again:** Netlify `https://birthday-magazine-original.netlify.app/` via exporter ZIP upload is a static frontend publication, already in project Handoff; does **not** execute WordPress/PHP/WooCommerce DB/order/Stripe webhook. This explains how a public-looking page could previously require few steps, but not solve payment.
5. **Storage policy:** No obligation to put ordinary project-managed binary, launch manifest or reconstructible config in `AppData`. Prefer a **verified ordinary Owner-visible project-owned tools/config path** under the existing project workspace, avoiding duplicate runtime caches and untracked durable files. Any future named Tunnel connector token, if required, lives in an exact deliberately verified protected secret location under Owner custody with recoverability metadata, not blindly in arbitrary AppData or repo. Quick Tunnel needs no persistent Tunnel credential. Do not migrate or delete already-created unknown AppData artifacts before exact ownership, actual path and contents (only non-secret metadata) are reconciled; never expose/overwrite unknown Secret paths. No claimed token present in PR Evidence.
6. **No side-effect permission from technical research:** Owner expressly authorized public original WP in earlier turns, but public ingress still requires accepted pre-publication privacy checks and negative readbacks under §11C. Latest local media review 43 rasters + 20 SVG is accepted, Owner-reported private password rotated; no need to repeat. Actual post-public HTTP/private routes and correct HTTPS forwarded protocol/canonical site URL are separate. A temporary `trycloudflare.com` hostname must never be silently relabeled as `stripe-test.spikersun.com`; it does not establish domain/DNS ownership.
7. **Governance edits:** no change to `spike.skill` canonical rule; §11B already contains the correct path virtualization guard. If filing an incident in the governance package later, use the Owner-authorized governance-change rule; this project decision merely cites prior verified incident.

## Narrow next action (existing G3S4L gate; no new multi-round bootstrap)

**First READ-ONLY host-path reconciliation; no local files created/deleted and no Tunnel started:**
- On actual Owner Windows determine executing `cloudflared`/PowerShell process' machine, SID/user, effective package identity, known-folder `LocalApplicationData`/expanded path, executable and actual process parent, and whether storage is redirected. **Do not assume child PowerShell 5.1 eliminates packaged-app redirect.**
- Check *only exact allowlisted target paths*: the ordinary `%LOCALAPPDATA%\BirthdayMagazineStudio\G3S4L\remote-managed-tunnel-20261017` and its corresponding packaged Codex `%LOCALAPPDATA%\Packages\OpenAI.Codex_*\LocalCache\Local\BirthdayMagazineStudio\G3S4L\remote-managed-tunnel-20261017`, plus previously staged `cloudflared-20261017` binary folder. No broad drive/repo search. Capture only safe `PRESENT/ABSENT`, length, signature on non-secret exe, ACL principal categories, and `REPARSE/REDIRECTED` status; **no token bytes, hash or script secret dump**.
- Prove same-target **Owner-normal, independently launched Windows PowerShell** readback of path if automatic reliable host identity permits; otherwise make **one tiny read-only Owner-native checkpoint** the last resort, designed as a single copy-paste with short boolean output, no repeated debugging. Absence from ordinary path alone does not mean file deleted; packaged LocalCache is a known exact alternative.
- Classify `ORDINARY_VISIBLE | PACKAGED_REDIRECT_ONLY | BOTH_DIFFER | MISSING_BOTH | UNVERIFIED_CONTEXT`. In case of packaged-only, mark that actual location in sanitized Evidence and plan safe later user-visible relocation of **non-secret tool/script only**, after Owner's preferences; no blind copy/delete or creation of another token file. Do not create new project `AppData` artifacts or start SSL/Provider flow during diagnosis.

**Only then choose the fastest route:** If real-host `cloudflared` executable is verified runnable and Owner's approved existing-site security preflight still valid, propose a **single bounded Quick Tunnel public HTTPS canary** using a supervised foreground process, no persistent token, no DNS or Cloudflare login, on original `127.0.0.1:8189`. This is a separate public network phase inside the existing Gate and must freeze rollback, WordPress test-only gateway state, URL origin and anonymous exposure checks. Stop connector immediately if any private content leaks; preserve original orders/media/PayPal and prior accepted backup. Do not claim Stripe TEST PASS merely by a public URL. Escalate stable named domain only if an authentic Woo Stripe TEST OAuth/Webhook test actually needs enduring hostname.

**Evidence:** update existing PR64 `docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md` with path-provenance proof, current Quick Tunnel decision and exact non-secret result; leave original frontend/backend/runtime unmutated in the path-inspection step. Then Reviewer decides minimum safe public canary. No more duplicate AppData credential scaffolding, backend clone, paid hosting, Cloudflare dashboard automation bypass or unrelated VPS.
