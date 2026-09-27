# R3B Trigger

Purpose: trigger the bounded Mistral-first R3B benchmark after Owner configured `MISTRAL_API_KEY` in GitHub Actions Secrets.

Safety:
- fixed 11 public hard cases only;
- PP-OCRv6_medium remains primary;
- Mistral OCR 4.1 only;
- stop immediately if provider returns payment-required;
- no Google billing activation;
- no customer/private data;
- no secret values stored here.
