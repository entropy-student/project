# G3S1 — Owner-relayed Codex transport interruption (preflight only)

> Date: 2026-10-15
> Gate: `G3S1_LOCAL_STRIPE_GATEWAY_STAGING`
> Evidence class: `OWNER_RELAY`; **not** durable Executor Evidence or Reviewer direct host readback
> Formal Reviewer disposition: `../../REVIEWER_DECISION_G3S1_RETURN_GITHUB_PLUGIN_TRANSPORT_CLOSED_2026-10-15.md`

## Owner-relayed Executor result

```text
EXECUTOR_RESULT=RETURN_GITHUB_PLUGIN_TRANSPORT_CLOSED
REPORTED_MUTATIONS=NONE
REPORTED_CONTAINERS_STARTED=0
REPORTED_BACKUPS_CREATED=0
REPORTED_STRIPE_PLUGINS_INSTALLED=0
REPORTED_G3C_CONTAINERS_STOPPED=4
REPORTED_G3C_VOLUMES_AND_NETWORKS=PRESENT
HOST_AND_MOUNT_IDENTITY_PROOF=NOT_COMPLETED
HTTP_DB_WOO_RUNTIME=NOT_CHECKED
BACKUP_RECOVERABILITY=NOT_CHECKED
PLUGIN_GATEWAY_ACTIVATION_FLAGS=NOT_CHECKED
DURABLE_EXECUTOR_EVIDENCE=NOT_WRITTEN
ROLLBACK_REQUIRED=NONE_REPORTED
```

Executor reported reading the latest G3S1 Gate, parent G3S0 Reviewer and Owner decisions, PR #64 metadata/change listing and G3C Compose source. During a GitHub PR read the Codex GitHub plugin returned:

```text
tool call error: tool call failed for codex_apps/github.fetch_pr — Transport closed
```

Executor then stopped rather than using an alternative GitHub channel. The exact `fetch_pr` plugin transport failure is **Executor-reported**, and not independently reproducible or resolved for the Codex session through the Reviewer connection.

## Independent Reviewer GitHub readback

- `REVIEWER_GITHUB_DIRECT`: Reviewer GitHub connector independently fetched current `main`, PR #64, current Handoff/G3S1 Gate, Governance v0.2.7, and the Owner/parent decision and MVP contract metadata.
- `main` at Reviewer pre-decision readback: `8b1eb83c7c442006685d957de615c60b2c3af1c2`.
- PR #64: open, unmerged, `mergeable=false`; head `c90e6f93803ad861745cd476106e00d01c68debb`.
- Comparing current `main` to prior Reviewer handoff head `dce21adbd9d610a4fac7a9f658d388912413f1d7`: four changed files, all under `curious-world-studio/`; **zero** `birthday-magazine-studio/` paths. No project-scope source/Gate drift detected.
- Reviewer GitHub success shows the **Reviewer** connection can read these sources. It does **not** prove the Codex GitHub plugin session is repaired.
- `OWNER_RELAY_DISCREPANCY`: earlier G3S0 report said **three** stopped G3C containers (WordPress, MariaDB, Mailpit); new G3S1 report says **four**. No current direct identity/mount evidence proves whether this is a count error, extra G3C service, or unrelated container.

## Coverage and limits

No host-native command outputs, sanitized exact container IDs, volume mounts, plugin inventory, consistent DB backup, package provenance/SHA, rollback compatibility check, nor post-write readback were persisted or inspected by Reviewer. Therefore none of the runtime/backup/install acceptance criteria has passed.

The report's non-action claims are maintained as `EXECUTOR_REPORTED_OWNER_RELAY`, **not** as observed operation counters. Do not assert a Stripe connection, installed plugin, preserved PayPal active state, or runtime readiness from this event.

## Next permitted step

Preserve the unchanged `G3S1_LOCAL_STRIPE_GATEWAY_STAGING` Gate; no newly authorized business action. Once Codex's **same approved** GitHub connector can fetch current PR/main successfully, repeat only the incomplete read-only Phase 0 preflight with fresh project-scoped source checks. Explicitly identify/classify all four reported containers and existing mounts before any start. On unresolved target/storage discrepancy or repeated transport failure, RETURN with exact cause. Continue Phase A/B/C only after all original Gate conditions hold.

No account authentication, Stripe Test/Live enablement, payment/refund, plugin activation, PayPal teardown, public ingress, production write, PR merge or frontend redesign is authorized.
