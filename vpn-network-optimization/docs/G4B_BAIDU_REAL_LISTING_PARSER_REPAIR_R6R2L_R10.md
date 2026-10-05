# G4-B Baidu Real Listing Parser Repair R6R2L-R10

Status: ACTIVE / OWNER_LOCAL_OFFLINE_VALIDATION

## GATE_ID

`G4B_BAIDU_REAL_LISTING_PARSER_REPAIR_R6R2L_R10`

## PREVIOUS_RESULT

`RETURN_R6R2L_R9_BAIDU_PENDING_UPLOAD_NOT_PRESENT`

## R9 LIVE FACTS

```text
RUNNER_PHASE=P5_SECRET_AND_RECOVERY_PREPARE
BAIDU_CLI_VERSION=v4.0.2
FAILURE_CODE=BAIDU_PENDING_UPLOAD_NOT_PRESENT
CONSEQUENTIAL_MUTATION_STARTED=NO
REMOTE_ROLLBACK=PASS
BAIDU_PENDING_ROLLBACK=PASS
STOP_AT_REVIEWER=YES
```

No live replay is authorized by this Gate.

## ROOT CAUSE

The live runner's `Get-BaiduRemoteObjectState()` assumes BaiduPCS-Go `ls -l` renders ASCII bordered rows:

```text
| ... | filename |
```

and matches only lines beginning with `|`.

Upstream BaiduPCS-Go v4.0.2 source proves the real table formatter is configured with:

```go
tb.SetBorder(false)
tb.SetHeaderLine(false)
tb.SetColumnSeparator("")
```

and detailed `ls -l` renders the filename as the final column, with directories represented by `filename + "/"`.

Therefore the production parser can classify a real existing remote object as `ABSENT`. The existing fake CLI fixture masked this defect by synthesizing pipe-delimited rows that do not match the real provider formatter.

Upstream v4.0.2 source used for this reconciliation:
- `pcstable/pcstable.go`
- `internal/pcscommand/ls_search.go`
- `internal/pcscommand/upload.go`

The upstream upload implementation also confirms a local file is saved under the supplied target directory using its basename. The pending basename/path design itself is therefore not the identified defect.

## LOCKED SOURCES

```text
R10_RUNNER_BLOB=2faf59ec5a1653a275b11504fe567d0fc871f94e
R10_VALIDATOR_BLOB=26eff5e0ec7c3d12fc436fe1b7b32b27929ab8d3
```

## REPAIR SCOPE

Only:
1. Replace the pipe-border-dependent remote-object listing matcher with an exact final-column matcher compatible with the v4.0.2 borderless table.
2. Preserve exact basename matching and directory trailing-slash distinction.
3. Change the fake Baidu `ls` fixture to emit borderless v4.0.2-style rows.
4. Add source and negative regression coverage proving the old pipe-only parser cannot return.
5. Run the full existing offline fixture validator.

No live Baidu, VPS, Secret, DPAPI, Clash, route, proxy, TUN or G4-C action.

## REQUIRED PARSER CONTRACT

The parser must:
- match only a line whose final field is exactly the requested basename;
- accept trailing horizontal whitespace;
- classify `<basename>/` as DIRECTORY;
- classify `<basename>` as FILE;
- return ABSENT when no exact final-field match exists;
- fail closed if more than one matching row exists;
- not require a leading or trailing ASCII pipe.

## REQUIRED FIXTURE CONTRACT

The fake CLI `ls -l` rows must model the real provider's no-border/no-column-separator rendering.

Required positive markers include:

```text
G4B_FIXTURE_R6R2L_R10_BAIDU_REAL_LS_FORMAT_PARSER=PASS
G4B_FIXTURE_R6R2L_R10_BAIDU_REAL_LS_FILE_MATCH=PASS
G4B_FIXTURE_R6R2L_R10_BAIDU_REAL_LS_DIRECTORY_MATCH=PASS
G4B_FIXTURE_R6R2L_R10_BAIDU_REAL_LS_EXACT_BASENAME=PASS
G4B_FIXTURE_R4_PENDING_UPLOAD_READBACK_PASS=PASS
G4B_FIXTURE_R4_PENDING_TO_FINAL_PROMOTION_PASS=PASS
G4B_FIXTURE_R4_ROLLBACK_REMOVES_PENDING_ONLY=PASS
```

Required negative marker:

```text
G4B_FIXTURE_NEGATIVE_BAIDU_PIPE_BORDER_ONLY_PARSER=PASS
```

And all existing positive/negative suites must remain PASS.

## FORBIDDEN

- live runner invocation;
- Baidu API/file operation;
- SSH/VPS action;
- DPAPI or real Secret access;
- recovery/profile/service/route/proxy/TUN mutation;
- G4-C;
- blind retry of R9.

## ROLLBACK

Source-only rollback. Revert only the R10 runner/validator/Gate/Evidence/Handoff changes. No runtime rollback is expected.

## STOP

`STOP_AT_REVIEWER=YES`
