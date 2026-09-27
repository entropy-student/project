# G2A1-R3B — Mistral OCR 4.1 Provider Setup

> Owner setup guide  
> Status: **CURRENT OWNER ACTION**  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)  
> Current provider order: **Mistral OCR 4.1 first**  
> Google status: **DEFERRED_DUE_TO_BILLING_PREPAYMENT_FRICTION**

## 1. Why Mistral is first now

Google Document AI technical integration is already proven through:
- Document OCR processor created;
- service account created;
- GitHub OIDC → Google Workload Identity Federation configured;
- processor metadata/version access succeeded;
- first real process request reached Document AI.

Google then returned `BILLING_DISABLED`. The Owner's billing account requires a USD 30 one-time prepayment before Document AI can process pages.

For the current 11-case feasibility benchmark, this account-level prepayment is disproportionate to the test itself.

Therefore R3B is now:

```text
PP-OCRv6_medium
→ 11 fixed hard handwriting cases
→ Mistral OCR 4.1
→ semantic/edit-burden scoring
→ select Mistral or FALLBACK=NONE
```

Google remains a future adapter and may be re-enabled later without redesigning the product flow.

## 2. Mistral account / Free mode

Mistral Studio Free mode currently supports API-key creation without requiring a credit card by default, subject to included usage and rate limits.

Owner should:
1. sign in or create a Mistral account;
2. open Studio;
3. open **API Keys**;
4. create a dedicated key, for example:
   `family-cookbook-r3b-test`;
5. optionally set a short expiration date;
6. copy the key immediately because it is only shown once.

If the account/API endpoint itself requires billing despite Free mode, stop and return that provider blocker rather than purchasing anything automatically.

## 3. GitHub Secret

Repository:

`entropy-student/project`

Go to:

`Settings → Secrets and variables → Actions → New repository secret`

Create exactly:

`MISTRAL_API_KEY`

Value:
- the API key copied from Mistral Studio.

Do not paste the key into chat, Markdown, Issues, PR comments, Actions logs, or project files.

## 4. Current R3B scope

The key authorizes only the previously approved benchmark:

- 11 public/non-private handwriting crops;
- Mistral OCR 4.1 only;
- no customer/private images;
- no production integration;
- total authorized real API spend remains ≤ USD 0.20;
- no Gemini/OpenAI/Claude/third OCR provider.

At current public standard list price ($4/1000 pages), 11 pages are approximately USD 0.044 before any Free-mode allowance.

## 5. Expected workflow

Once `MISTRAL_API_KEY` exists:

```text
fixed 11-case provenance check
→ budget guard
→ download/recreate fixed public crops
→ call mistral-ocr-4-1
→ semantic critical-fact scoring
→ manual-edit burden comparison
→ FALLBACK=MISTRAL_OCR_4_1
   OR
   FALLBACK=NONE
```

If Mistral materially reduces review burden or recovers critical facts without new silent errors/hallucinations, retain it.

If it does not, use:

```text
PRIMARY=PP-OCRv6_medium
FALLBACK=NONE
→ one consolidated manual review
```

## 6. Provider abstraction

Production/business code must not depend directly on a Mistral-specific response shape.

Use:

```text
OCRFallbackProvider
  process(image) -> CanonicalOCRResult
```

with provider adapters such as:

```text
MistralOCRProvider
GoogleDocumentAIProvider
```

Canonical output should preserve at least:
- raw text;
- confidence when available;
- bounding/layout data when available;
- provider/model provenance;
- semantic uncertainty flags.

This keeps a future Mistral → Google switch bounded to authentication + adapter + regression testing, without changing the PP-OCRv6 primary path, review UX, recipe schema, or PDF pipeline.

## 7. Stop boundary

After adding the GitHub Secret, continue the same R3B Gate.

Do not:
- enable Google Billing merely for this benchmark;
- add another OCR provider;
- use private/customer data;
- enter G2A2 before Reviewer closes R3B.
