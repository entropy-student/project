# G4-B P5 Local Diagnostic R6R2L-R6

Status: ACTIVE / OWNER_LOCAL_DIAGNOSTIC / NO_LIVE_RETRY

## GATE_ID

`G4B_P5_LOCAL_DIAGNOSTIC_R6R2L_R6`

## PREVIOUS_RESULT

`RETURN_R6R2L_R5_P5_UNCLASSIFIED`

## FAILURE FACTS

```text
RUNNER_PHASE=P5_SECRET_AND_RECOVERY_PREPARE
BAIDU_CLI_VERSION=v4.0.2
BAIDU_CLI_RELEASE_ARCHIVE_SHA256=ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30
BAIDU_CLI_BINARY_SHA256=e44769b49156fa3f094431da87231021e6874b6519ea82da4b8af0637662576d
FAILURE_CODE=UNCLASSIFIED
CONSEQUENTIAL_MUTATION_STARTED=NO
STOP_AT_REVIEWER=YES
```

## OBJECTIVE

Identify the local P5 source of the unclassified exception without replaying the live Gate.

## ALLOWED

- read filesystem metadata below the project-owned local runtime/recovery roots;
- inspect whether prior G4-B Baidu runtime was cleaned;
- locally DPAPI-unprotect the accepted `hy2-g2a.dpapi` artifact and validate its framing/certificate fingerprint without printing any recovered value;
- invoke local `verge-mihomo.exe -v` and `generate reality-keypair`, capture output in memory, validate only shape, and never print generated key material;
- report only PASS/FAIL classifiers, exception type names and non-secret metadata.

## FORBIDDEN

- rerunning the G4-B live runner;
- Baidu network/API/CLI commands;
- SSH/VPS access;
- recovery upload/download/mkdir/mv/rm;
- writing any new recovery artifact;
- Clash profile/service/proxy/TUN/route mutation;
- printing HY2 auth, certificate/key bytes, REALITY keys/UUID/short-id, Baidu credentials or UID;
- G4-C.

## ACCEPTANCE

The diagnostic must produce a bounded classification for:
- post-failure local cleanup;
- DPAPI unprotect;
- HY2 framed payload structure;
- HY2 certificate parsing/fingerprint contract;
- local Mihomo version;
- local Reality keypair generation shape.

Stop at Reviewer after diagnostic output. No live retry is authorized by this Gate.

## STOP

`STOP_AT_REVIEWER=YES`
