# Reviewer Decision — P2R1 Superseded by Owner-host Materialization Pattern

Status: SUPERSEDED_BEFORE_EXECUTION

Date: 2026-10-06

## Reason

The previously released P2R1 still allowed Executor to write directly into the Owner Windows `AppData\Local` tree.

Current Governance already requires a stricter rule for this recurring fault class:

- same absolute path in sandbox/container/redirected runtime does not prove real-host state;
- Windows path virtualization/redirected app storage must be ruled in/out;
- a host-local write requires real machine/user/privilege/target proof plus same-target host-local read-back;
- Owner-local checkpoints must be atomic, bounded, and designed by Reviewer/Executor rather than debugged interactively by Owner.

Because this AppData visibility mismatch has recurred, direct Executor claims of Owner-profile writes are no longer accepted for this project.

## Replacement

`3XUI_FASTPATH_P2R2_SERVER_STAGE_OWNER_MATERIALIZE`

Executor prepares protected transfer files on the accepted VPS only.

Owner then performs one exact local PowerShell materialization checkpoint from their real Windows session.

Formal P2 PASS requires the Owner-session checkpoint read-back.
