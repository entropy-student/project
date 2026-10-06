# G4-B R19 Local Mihomo Parse Diagnostic R6R2L-R19R1

Status: PREPARED / LOCAL_CODEX_OFFLINE_DIAGNOSTIC / NO_LIVE_ACTION

## GATE_ID
`G4B_R19_LOCAL_MIHOMO_PARSE_DIAGNOSTIC_R6R2L_R19R1`

## PREVIOUS_RESULT
`RETURN_R19_P5_MIHOMO_CONFIG_PARSE_FAILED`

## OBJECTIVE
Reproduce and repair the local rendered `SELF-VPN-V1.yaml` parse failure that stopped R19 at P5 before any remote consequential mutation.

The failure boundary is:
```text
RUNNER_FAILED_PHASE=P5_SECRET_AND_RECOVERY_PREPARE
FAILURE_CODE=MIHOMO_CONFIG_PARSE_FAILED
CONSEQUENTIAL_MUTATION_STARTED=NO
REMOTE_ROLLBACK=PASS
BAIDU_PENDING_ROLLBACK=PASS
```

## CURRENT LOCKED SOURCE IDENTITIES
```text
RUNNER_BLOB=2faf59ec5a1653a275b11504fe567d0fc871f94e
LIVE_FIXTURE_VALIDATOR_BLOB=26eff5e0ec7c3d12fc436fe1b7b32b27929ab8d3
THREE_ROLE_TEMPLATE_BLOB=21c9a73f965e55da0c5d161b3c051e0d3bab1aa0
PACKAGE_VALIDATOR_BLOB=a4c5b3bd7875b16eb56cafc1f45ac3035f9a3b69
```

## LEADING HYPOTHESIS
The current VLESS/REALITY client template has no explicit `encryption` field. Current Mihomo VLESS documentation includes `encryption: ""` for the traditional non-VLESS-encryption form. Treat this only as a hypothesis until executable local reproduction proves it.

## MAX SCOPE
Allowed source changes only if executable evidence proves the root cause:
- `templates/clash/self-vpn-v1-three-role.yaml.template`
- `scripts/g4b-three-role-package-validator.ps1`
- `scripts/g4b-live-runner-fixture-validator.ps1`
- `scripts/g4b-persistent-three-role-live-runner.ps1` only if the parse diagnostic/output contract itself needs the smallest safe seam.

Do not touch server/VPS templates unless evidence proves the local client template is not the fault.

## REQUIRED DIAGNOSTIC
Use local Codex / non-consequential PowerShell only.

1. Safe-sync canonical main and prove the identities above.
2. Do not invoke runner `-Live`.
3. Do not read real HY2 auth, Baidu UID, DPAPI recovery data, SSH private key contents, or any Secret.
4. Build a synthetic rendered three-role profile from the exact template with:
   - syntactically valid synthetic UUID;
   - syntactically valid synthetic REALITY public key;
   - syntactically valid 16-hex short ID;
   - synthetic HY2 password/certificate fingerprint;
   - safe existing local physical interface name OR a controlled synthetic parse variant that does not perform networking.
5. Invoke the actual installed `C:\Program Files\Clash Verge\verge-mihomo.exe -t` against the synthetic profile in an isolated temp directory.
6. Capture only a sanitized parser error classification; do not persist raw Secret-like values.
7. Reproduce the current failure before changing source.
8. Test the smallest candidate repair independently. In particular test whether adding `"encryption": ""` to the VLESS proxy changes FAIL→PASS.
9. If that hypothesis is false, continue one-fault-domain diagnosis using the parser error only. Do not shotgun-edit unrelated fields.
10. Update validators so the exact repaired rendered profile is executable-parse tested, not merely JSON-structure tested.
11. Run all existing live-runner fixture regressions.
12. No network/service/profile/route mutation and no real provider/SSH/VPS action.

## REQUIRED EVIDENCE
```text
R19R1_PREFLIGHT=PASS
R19R1_CURRENT_FAILURE_REPRODUCED=PASS
R19R1_SANITIZED_PARSE_ERROR_CLASS=<non-secret classification>
R19R1_ROOT_CAUSE=<bounded description>
R19R1_MINIMAL_REPAIR=PASS
R19R1_SYNTHETIC_RENDERED_PROFILE_MIHOMO_PARSE=PASS
R19R1_PACKAGE_VALIDATOR=PASS
R19R1_LIVE_FIXTURE_VALIDATOR=PASS
R19R1_CHANGE_SCOPE=<exact files>
R19R1_SECRET_ACCESS=NO
R19R1_PROVIDER_ACTION=NO
R19R1_SSH_OR_VPS_ACTION=NO
R19R1_NETWORK_MUTATION=NO
R19R1_CLASH_PROFILE_MUTATION=NO
R19R1_LIVE_RUN_EXECUTED=NO
FINAL_RUNNER_BLOB=<sha>
FINAL_LIVE_FIXTURE_VALIDATOR_BLOB=<sha>
FINAL_TEMPLATE_BLOB=<sha>
FINAL_PACKAGE_VALIDATOR_BLOB=<sha>
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE
PASS_CANDIDATE only if the current failure is first reproduced with synthetic values using the real local Mihomo parser, a single bounded root cause is demonstrated, the repaired synthetic rendered profile parses successfully, all existing offline regressions pass, and no consequential action occurs.

## RETRY POLICY
No R19 live retry is authorized by R19R1. After durable source repair and Reviewer formal PASS, a new consequential live Gate and fresh release decision are required.

## OWNER ACTION
None expected. Local Codex can execute this Gate without Administrator privileges unless the installed Mihomo binary itself is inaccessible; if that happens, return the access constraint rather than escalating privileges.

## STOP
`STOP_AT_REVIEWER=YES`
