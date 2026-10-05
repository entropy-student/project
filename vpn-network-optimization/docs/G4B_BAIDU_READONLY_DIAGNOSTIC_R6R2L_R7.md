# G4-B Baidu Read-Only Diagnostic R6R2L-R7

Status: ACTIVE / OWNER_LOCAL_READ_ONLY_NETWORK_DIAGNOSTIC

## GATE_ID

`G4B_BAIDU_READONLY_DIAGNOSTIC_R6R2L_R7`

## PREVIOUS_RESULT

`PASS_R6R2L_R6_LOCAL_DIAGNOSTIC`

## ACCEPTED R6 FACTS

```text
POST_FAILURE_LOCAL_CLEANUP=PASS
HY2_DPAPI_UNPROTECT=PASS
HY2_FRAME_PARSE=PASS
HY2_CERTIFICATE_CONTRACT=PASS
MIHOMO_VERSION=PASS
MIHOMO_REALITY_KEYPAIR=PASS
BAIDU_NETWORK_ACTION=NO
SSH_OR_VPS_ACTION=NO
RECOVERY_WRITE=NO
NETWORK_MUTATION=NO
SECRET_VALUES_EMITTED=0
```

Therefore the remaining R5 P5 failure boundary is the Baidu read/parse/process path that occurs after pinned CLI installation and before local recovery/key generation.

## OBJECTIVE

Reproduce only the Baidu read-only boundaries used by P5 and return bounded classifiers without mutating Baidu or any runtime service.

## ALLOWED

- validate the existing local Baidu config directory and ACL metadata;
- create one temporary Owner-local diagnostic directory under the existing project runtime root;
- download the already pinned BaiduPCS-Go v4.0.2 archive from the accepted GitHub release URL;
- verify the accepted archive SHA-256;
- extract exactly one `BaiduPCS-Go.exe` into that temporary directory;
- run only:
  - `BaiduPCS-Go who`
  - `BaiduPCS-Go ls -l /vpn-network-optimization-g4b-recovery`
- collect expected numeric Baidu UID through hidden local input;
- classify process start/timeout/exit, UTF-8 stdout shape, UID parsing/match, directory-header parsing, and sanitized error categories;
- delete the temporary diagnostic directory after completion.

## FORBIDDEN

- `mkdir`, upload, download-from-Baidu, mv, rm, login, logout, config mutation or credential refresh;
- printing the UID, raw stdout/stderr, cookies, tokens, credentials, remote filenames or Secret values;
- SSH/VPS access;
- live G4-B runner invocation;
- recovery/profile/service/proxy/TUN/route mutation;
- G4-C.

## ACCEPTANCE

The diagnostic must return:

```text
BAIDU_CONFIG_ACL=PASS
BAIDU_PINNED_CLI=PASS
BAIDU_WHO_PROCESS=PASS|FAIL
BAIDU_WHO_UID_PARSE=PASS|FAIL
BAIDU_WHO_UID_MATCH=PASS|FAIL
BAIDU_LS_PROCESS=PASS|FAIL
BAIDU_LS_DIRECTORY_HEADER=PASS|FAIL|NOT_AVAILABLE
BAIDU_READONLY_DIAGNOSTIC_CLASSIFICATION=<bounded-code>
TEMP_RUNTIME_CLEANUP=PASS
BAIDU_MUTATION_ACTION=NO
SSH_OR_VPS_ACTION=NO
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

No live retry is authorized by this Gate.

## STOP

`STOP_AT_REVIEWER=YES`
