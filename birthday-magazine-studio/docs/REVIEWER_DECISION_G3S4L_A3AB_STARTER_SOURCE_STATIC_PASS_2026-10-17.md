# G3S4L Reviewer — complete launcher source independently verified; static Secret-safe PASS

Date: 2026-10-17
Evidence commit: `a3ab8b6ca06c4b6f6f1902a6d0e85ad4f2bf0467` (latest PR #64 at review); G3S4L existing Evidence file appended **complete** script, no actual Tunnel/WordPress/Stripe change.
Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7 §11B plus §§5–10/11C/11D/11E.
This decision supersedes the "launch-script source not yet reviewable" blocker in `REVIEWER_DECISION_G3S4L_73B8_LOCAL_PREP_PARTIAL_CLOUDFLARE_OWNER_CHECKPOINT_2026-10-17.md`, not historical factual evidence.

## Formal result

```text
SCOPE=UNMODIFIED_NONSECRET_STARTER_SOURCE_STATIC_REVIEW
RESULT=PASS_STATIC_LAUNCHER_SOURCE
PR64_HEAD=a3ab8b6ca06c4b6f6f1902a6d0e85ad4f2bf0467
EVIDENCE_PATH=birthday-magazine-studio/docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md
SOURCE=COMPLETE_POWERSHELL_FENCED_BLOCK_IN_LATEST_EVIDENCE
SOURCE_ENCODING=ASCII
SOURCE_LINES=REVIEWED_ALL
SOURCE_BYTES=4392
SOURCE_SHA256=E0C549D6769672B60EE58A72222F0E70387BDB26FECC5A1EAF9353FDE0E27DEC
HASH_RECOMPUTED_FROM_EXACT_FENCED_SOURCE=PASS
SHA256_IMPLEMENTATION_KNOWN_VECTORS_ABC_AND_EMPTY=PASS
SYNTAX_PS51=EXECUTOR_REPORTED_PARSE_PASS
SECRET_LITERALS_IN_SOURCE=NONE_OBSERVED
INPUT=POWERSHELL_READ_HOST_AS_SECURESTRING_MASKED
SECRET_VALUE_TO_ARGV_OR_ENV=NOT_IN_SOURCE
TOKEN_STORAGE=PROFILE_PRIVATE_FILE_OUTSIDE_GIT
TOKEN_READER=cloudflared_tunnel_run_TOKEN_FILE_PATH_ONLY
ACL_CHECK=OWNER_SID_SYSTEM_SID_ONLY_EXPLICIT_FULL_CONTROL_PROTECTED_NO_REPARSE
BINARY=PINNED_SHA256_PLUS_VALID_AUTHENTICODE_CLOUDFLARE_SIGNER
TOKEN_WRITE=EXCLUSIVE_EXISTING_ZERO_BYTE_FILE_WRITE_FLUSH_THEN_BUFFER_CLEAR
TOKEN_FILE_AT_REST=PLAINTEXT_SEPARATELY_PROTECTED_NOT_ENCRYPTED;OWNER_CUSTODY
SOURCE_REVIEW_CONFIRMS_RUNTIME=NO
OWNER_NORMAL_PS51_PATH_AND_HASH_READBACK=REQUIRED_AT_FIRST_REAL_RUN
REAL_OWNER_TOKEN_ENTRY=NOT_STARTED
CLOUDFLARE_TUNNEL_DNS=NOT_CREATED
PUBLIC_HTTPS=NOT_ACTIVE
WORDPRESS_HOME_SITEURL=ORIGINAL_LOOPBACK
STRIPE_TEST=NOT_STARTED
G3S4L_WHOLE_GATE=NOT_PASS_YET
NO_MORE_CODEX_SOURCE_RESUBMISSION_REQUIRED=YES
```

## What was independently checked

The exact full source under the latest Evidence heading `## 2026-10-17 G3S4L launcher source for Reviewer review` was extracted from `a3ab8b6c...`; the reviewed PowerShell block was 4,392 ASCII bytes with LF line endings and no source-terminal newline. Its independently recomputed SHA-256 matched the claimed file digest **exactly**. SHA-256 implementation was first checked against canonical known test vectors (ASCII `abc`, empty input). All source lines were visually/static reviewed for credential disclosure and named target scope.

The script resolves `$PSScriptRoot\cloudflared.exe`, checks **Valid** Authenticode signature Cloudflare signer, and exact binary digest `4D2490E74082C5D48DBFEDAF92576FA5BD1702379AB88EB7FAA0CFBE8DC891B6`. It verifies restrictive ACL of `$env:USERPROFILE\.birthday-magazine-studio\G3S4L-private` and the project token file `magazine.spikersun.com.connector-token`; only same Owner SID and SYSTEM are accepted, with no inherited/deny/other ACEs, no reparse on checked leaf objects. If file is zero bytes, it uses `Read-Host -AsSecureString`, bounds and converts input to ASCII, opens **existing** empty file with exclusive access, flushes the byte contents and clears temporary buffer/BSTR. The actual command is `& $exePath tunnel run --token-file $tokenPath`, which carries a **path only**, no token in argv or environment. It does not attempt Cloudflare login, install a service, edit DNS/WordPress or start payments.

**Qualification:** this is a static review of source GitHub claims equals Owner real file by reported SHA. The local helper has **never been run**, and no independent Owner-launched Windows PowerShell path+SHA readback or secure input execution has been witnessed. This PASS does not prove successful real token input, cloudflared healthy, SSL/DNS published, or Stripe TEST. The token is stored **plaintext at rest** in a tightly ACL-restricted user-profile file, so do not copy it into Git/OneDrive, logs, chat, Explorer screenshots or cloud-sync; treat this as an Owner-owned scoped connector credential with separate replacement/rotation if compromised.

## No extra Codex staging round; one Owner session next

**Next Owner-controlled action (as little as can safely be done):**

1. In **already logged-in Cloudflare dashboard** `Networking > Tunnels`, confirm `spikersun.com` zone control and exact `magazine.spikersun.com` has no DNS record or other Tunnel published route. Create a dedicated **remotely managed** tunnel (suggest `birthday-magazine-local-test`) if no conflict. Do not run the Cloudflare Windows wizard's `cloudflared.exe service install <TOKEN>` command.
2. Open a **separately started, Owner-visible native Windows PowerShell 5.1** (not Codex terminal), run only the reviewed no-secret launcher using a self-contained **same-target file digest guard** before any SecureString prompt:
```powershell
$launcher = Join-Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)) 'ChatGPT\BirthdayMagazineStudio\G3S4L\magazine.spikersun.com\Start-MagazineTunnel.ps1'
if ((Get-FileHash -LiteralPath $launcher -Algorithm SHA256).Hash -cne 'E0C549D6769672B60EE58A72222F0E70387BDB26FECC5A1EAF9353FDE0E27DEC') { throw 'LAUNCHER_DIGEST_MISMATCH_OR_MISSING' }
& $launcher
```
This directly tests real Owner-normal Windows file visibility and exactly the reviewed script bytes before secret input. If wrong/missing/fails, **do not enter token**, report only non-secret error. On success, enter **only** the dashboard connector token at the hidden prompt; never include token in shell argv, chat, Codex, GitHub, screenshot or installer command history. The foreground PowerShell should remain running.
3. Wait for Tunnel **Healthy** in Cloudflare, then `Continue`/the Tunnel's `Routes > Add route > Published application`. Choose subdomain `magazine`, domain `spikersun.com`, service **`http://127.0.0.1:8189`**, save only if no collision. This adds the exact named public route/DNS, not old `stripe-test` or Quick Tunnel.
4. Report only sanitized Cloudflare tunnel Healthy state, whether public `https://magazine.spikersun.com` loads, and any non-secret error. Codex can then continue with external WordPress/private-access positive-negative check, reversible HTTPS canonical/proxy and later official Woo Stripe TEST Owner OAuth one bounded synthetic charge/refund under existing G3S4L.
   
**No more repeated local backups/media audits, Cloudflare CLI account login, install/download, host path rereview or helper resubmission** unless actual runtime shows material new failure. Stop at exact account/host/published-route mismatch; do not reset old credentials or make up write permissions. PR #64 remains open/unmerged.
