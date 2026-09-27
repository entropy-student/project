# G2A1-R3B — Baidu Handwriting OCR Free-Quota Setup

> Owner setup guide  
> Status: **CURRENT OWNER ACTION**  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)  
> Current provider: **Baidu Handwriting OCR**  
> Primary remains: **PP-OCRv6_medium**

## 1. Why Baidu is being tested

Google Document AI technical integration is proven, but the available Google Cloud Billing account requires a USD 30 one-time prepayment before the 11-case OCR benchmark can run.

Mistral OCR 4.1 Free mode was also tested, but the first OCR request and bounded 15/30/60/90-second retries all returned HTTP 429 before any OCR output.

Baidu Handwriting OCR currently documents:
- public API access;
- handwriting recognition;
- English support;
- line text, location and confidence output;
- personal-account free test quota of 500 calls/month after required account verification.

The R3B benchmark uses only 11 fixed public/non-private handwriting crops.

## 2. Account boundary

Use Baidu AI Cloud / AI Open Platform.

Required:
1. log in;
2. complete the account verification required to receive OCR test quota;
3. enter the OCR / Text Recognition console;
4. create an application;
5. enable/select **Handwriting OCR / 手写文字识别** for that application;
6. obtain:
   - API Key;
   - Secret Key.

Do **not** enable pay-as-you-go merely for this Gate.

## 3. GitHub Actions Secrets

Repository:

`entropy-student/project`

Go to:

`Settings → Secrets and variables → Actions → New repository secret`

Create:

### `BAIDU_OCR_API_KEY`
Value: the application's Baidu OCR API Key.

### `BAIDU_OCR_SECRET_KEY`
Value: the application's Baidu OCR Secret Key.

Never paste either value into:
- chat;
- repository files;
- Markdown;
- Issues/PRs;
- Actions logs/artifacts.

## 4. Runtime flow

The benchmark obtains an access token at runtime using the API Key + Secret Key, then calls:

`/rest/2.0/ocr/v1/handwriting`

with:
- fixed 11 public handwriting crops;
- `recognize_granularity=small`;
- `probability=true`;
- `detect_direction=true`.

The token/key values are never persisted.

## 5. Free-only guard

Owner authorizes **free test quota only**.

The benchmark does not enable billing or paid mode.

If Baidu reports:
- no permission;
- free quota exhausted;
- total quota exhausted;
- insufficient available quota;

the Gate stops with a precise RETURN and `FALLBACK=UNKNOWN`.

No automatic purchase, resource pack, or pay-as-you-go activation is authorized.

## 6. Success decision

If Baidu materially reduces PP-OCRv6's 11 hard-case manual edits or recovers the missing critical fact without introducing new silent critical errors/hallucinations:

`FALLBACK=BAIDU_HANDWRITING_OCR`

Otherwise:

`FALLBACK=NONE`

The product still uses one consolidated review/edit screen after OCR.

## 7. Provider abstraction

Baidu is another adapter behind:

`OCRFallbackProvider`

The product/business flow must depend only on a canonical OCR result, preserving:
- raw text;
- confidence;
- location/bounds where available;
- provider/model provenance;
- uncertainty.

Google and Mistral remain replaceable adapters, so choosing Baidu for MVP does not lock the product to Baidu.

## 8. Stop boundary

After the two GitHub Secrets are configured, continue the same R3B Gate.

Do not:
- enable Baidu paid mode automatically;
- use customer/private recipe images;
- add another provider in this Gate;
- merge main;
- enter G2A2 before Reviewer closes R3B.
