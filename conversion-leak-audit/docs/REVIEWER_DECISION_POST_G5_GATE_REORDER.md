# Reviewer Decision — Deployment / Payment / LLM Gate Reorder

Date: 2026-09-23

Role: Reviewer / Architect / Gatekeeper

## Decision

The post-G5 roadmap is reordered to separate:
- infrastructure onboarding;
- local payment/entitlement logic;
- private deployment;
- public ingress;
- real payment-provider validation;
- real LLM-provider validation.

## New order

```text
G6    VPS read-only preflight + onboarding/storage
G6.5  Payment + Entitlement local closed loop
G7    VPS private deployment
G8    Domain + HTTPS
G9    Real payment provider validation
G9.5  Real LLM provider canary
G10   Production acceptance
G11   Acquisition / business validation
```

## Rationale

- Payment/entitlement domain logic does not require public deployment and should be tested before the application is deployed.
- Real payment-provider webhook validation does require a reachable HTTPS endpoint, so it remains after Domain/HTTPS.
- Real LLM provider integration is not a prerequisite for the deterministic paid report; it remains an optional production canary after public infrastructure is ready.
- Free Top 3 remains zero-LLM by default.
- Full Fix Queue remains usable without a live LLM provider.
- Payment success must unlock the correct report/scan entitlement; it must not implicitly trigger LLM usage.
- Model tokens are consumed only when the product explicitly invokes the configured real LLM provider.

## Owner approval rule

Before any formal deployment or any write to the VPS, Executor must stop and obtain explicit Owner approval.

Before that approval, G6 remote activity is read-only only.

This decision supersedes the previous post-G5 ordering where payment was entirely deferred until after deployment.
