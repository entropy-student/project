# G2A1-R3B — Google Document AI Provider Setup

> Owner setup guide  
> Status: **WIF/PROCESSOR SETUP COMPLETE / BILLING OWNER ACTION REQUIRED**  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)  
> Returned execution HEAD: `dd9c07bbe64a3076bcfd38d27259ff56c2ed013a`  
> Returned Actions run: `36297499256`  
> Required next action: configure Google Document AI + GitHub Actions Secrets, then rerun R3B.

## 1. Accepted RETURN

Reviewer accepts:

`RETURN_G2A1_R3B_GOOGLE_CREDENTIAL_REQUIRED`

The R3B implementation is ready:
- fixed 11-case dataset validated;
- Google client implemented;
- scoring/materiality logic implemented;
- budget guard passed;
- Google/Mistral Secrets were absent;
- no external OCR API call occurred;
- actual API test cost = USD 0.00;
- `FALLBACK` remains `UNKNOWN`.

This is an account/provider-setup blocker, not an OCR or client-code failure.

## 2. Google Cloud Setup

Use a test-only Google Cloud project or an existing project suitable for this PoC.

Owner actions:

1. Select or create a Google Cloud project.
2. Ensure billing is enabled.
3. Enable the **Document AI API**.
4. In Document AI Processor Gallery, create **Enterprise Document OCR** / processor type `OCR_PROCESSOR`.
5. Record:
   - Google Cloud **Project ID**;
   - processor **Location**;
   - processor **ID**.

The R3B client validates that the processor:
- type is `OCR_PROCESSOR`;
- state is enabled;
- default processor version is deployed.

## 3. Test Service Account

Create a dedicated test service account.

Recommended least-privilege role for the current benchmark:

`roles/documentai.viewer` — Document AI Viewer

Reason: the R3B code needs to read processor/version metadata and process documents online. The Viewer role includes processor metadata access and document-processing capability through the Document AI API User permissions.

Do not grant Document AI Administrator merely for benchmark execution.

Processor creation itself should be performed by the Owner/user account with the required create permission, before the test service account is used.

## 4. Temporary JSON Key

The current bounded R3B client expects a Google service-account JSON credential.

For this test:
- create one JSON key for the dedicated test service account;
- treat it as temporary;
- never commit it;
- never paste it into chat;
- after R3B is complete, delete/rotate the key.

A production design should revisit keyless authentication rather than adopting this temporary PoC key pattern by default.

## 5. GitHub Actions Secrets

Repository:

`entropy-student/project`

Go to repository:

`Settings → Secrets and variables → Actions → New repository secret`

Create exactly these four Google secrets:

### `GOOGLE_DOC_AI_CREDENTIALS_JSON`
Value:
- the **entire contents** of the downloaded service-account JSON file.

### `GOOGLE_CLOUD_PROJECT`
Value:
- Google Cloud **Project ID**;
- not project display name;
- not numeric project number.

### `GOOGLE_DOC_AI_LOCATION`
Value:
- the exact processor location, e.g. `us` or `eu`;
- must match the processor.

### `GOOGLE_DOC_AI_PROCESSOR_ID`
Value:
- the Enterprise Document OCR processor ID from its Overview page.

Do **not** configure `MISTRAL_API_KEY` yet.

Mistral is only needed if Google is actually tested and fails the R3B material-improvement rule.

## 6. Security Boundary

Never put Secret values into:
- Git commits;
- Markdown docs;
- Issues/PR comments;
- Actions artifacts;
- ordinary Actions logs;
- chat.

The workflow only records boolean Secret presence.

## 7. After Secrets Are Configured

Rerun the R3B workflow:

`Family Cookbook G2A1-R3B bounded API fallback benchmark`

The workflow is branch-scoped to:

`codex/family-cookbook-g2a1-input-ocr-component-feasibility`

and guarded by commit marker:

`[g2a1-r3b-run]`

A rerun of the existing marked workflow may be used after Secrets are configured; otherwise trigger a new marked branch commit.

Expected flow:

```text
Google Secret preflight
→ processor metadata validation
→ 11 Google OCR calls
→ semantic/edit-burden scoring
→ if Google materially improves: select Google and STOP
→ otherwise require/test Mistral according to the existing Gate contract
```

## 8. Mistral Boundary

Do not configure Mistral in advance unless desired.

If Google is insufficient, Executor may return:

`RETURN_G2A1_R3B_MISTRAL_CREDENTIAL_REQUIRED`

At that point configure only:

`MISTRAL_API_KEY`

and continue the same Gate.

## 9. Budget

Current committed conservative estimate:
- Google 11 pages: USD 0.0165;
- Mistral 11 pages, only if required: USD 0.044;
- combined worst-case estimate: USD 0.0605;
- authorized cap: USD 0.20.

No retries should multiply billable calls without evidence.

## 10. Stop Boundary

After Google Secrets are configured, continue R3B only.

Do not:
- merge main;
- enter G2A2;
- use customer/private recipes;
- enable Gemini/general VLM;
- deploy production infrastructure.


---

## 11. 2026-09-27 WIF Update

The organization blocks long-lived service-account key creation via:

`iam.disableServiceAccountKeyCreation`

This policy was **not** weakened.

Instead, GitHub Actions now uses Workload Identity Federation:

- provider: `projects/72948840060/locations/global/workloadIdentityPools/github-actions/providers/entropy-student-project`
- service account: `family-cookbook-ocr@family-cookbook-ocr-test.iam.gserviceaccount.com`
- allowed repository: `entropy-student/project`
- allowed branch: `refs/heads/codex/family-cookbook-g2a1-input-ocr-component-feasibility`
- workflow permission: `id-token: write`
- authentication action: `google-github-actions/auth@v3`

The previous JSON-key GitHub Secret route is superseded and should not be used.

## 12. Current Verified Blocker — Billing

Actions run `36301652196` proved:

- WIF access-token authentication works;
- processor metadata HTTP 200;
- default processor-version metadata HTTP 200;
- processor is `OCR_PROCESSOR`;
- first real OCR `:process` request reached Google Document AI.

The first process request returned:

- HTTP 403;
- status `PERMISSION_DENIED`;
- ErrorInfo reason `BILLING_DISABLED`;
- service `documentai.googleapis.com`.

Current Owner action:

**Enable/link Google Cloud Billing for project `family-cookbook-ocr-test`.**

After Billing is enabled, allow a few minutes for propagation and rerun the same R3B workflow.

No IAM escalation is currently justified.
