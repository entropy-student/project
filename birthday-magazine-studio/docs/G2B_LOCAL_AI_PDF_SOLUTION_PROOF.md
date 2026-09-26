# G2B — Local AI → Magazine Pages → PDF Solution Proof

> Reviewer execution contract  
> Status: READY_FOR_EXECUTOR AFTER G2A2 PASS  
> Parent product contract: [MVP_PRODUCT_CONTRACT.md](./MVP_PRODUCT_CONTRACT.md)  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)

## Goal

Prove the core generation engine can turn one realistic synthetic birthday intake into a coherent **12-page magazine PDF** without inventing product decisions.

This Gate is a **local/test Solution Proof**, not commerce/payment/production deployment.

## Must prove

1. structured intake can be validated;
2. 12–25 synthetic source photos can be accepted and mapped;
3. up to 3 must-use photos are honored;
4. six narrative answers can be transformed into structured magazine content;
5. exactly two dynamic modules can be selected only from supported intake;
6. deterministic page templates render all 12 pages;
7. three visual presets can share one page architecture;
8. a PDF is produced and opens/renders;
9. deterministic QA catches contract violations;
10. generation is idempotent at the local job boundary.

## Required fixture

Create one realistic synthetic test fixture containing:

- factual recipient fields;
- six completed prompts;
- optional quick facts;
- 12–25 synthetic/non-private photos;
- up to 3 must-use markers;
- one chosen style preset.

No real customer data.

## AI boundary

AI is allowed only for:
- content structuring;
- grounded copy generation;
- headlines/captions;
- dynamic-module choice from the approved list.

No AI-generated images.

The system must use a provider abstraction so G2B does not hard-wire the product to one model vendor.

If an external model/API requires a credential not already available through an approved protected mechanism:
- do not place a secret in repository/chat;
- do not ask the Owner to paste it into ordinary text;
- implement the provider boundary and return the exact blocked checkpoint if a real generation call cannot safely be made.

A static hand-written final magazine alone is **not** sufficient to claim full AI Solution Proof. If the live model call is blocked, distinguish pipeline PASS from AI-call BLOCKED.

## Output architecture target

```text
synthetic intake
→ validation
→ normalized content schema
→ AI content generation / structured output
→ photo selection/mapping
→ approved page map
→ deterministic HTML/CSS or equivalent page composition
→ PDF render
→ deterministic QA
→ proof artifact
```

## Required content schema

At minimum represent:

- recipient identity;
- tone/style preset;
- grounded source facts;
- cover lines;
- opening note;
- personality/profile content;
- feature memory;
- two selected dynamic modules;
- why-they-matter section;
- current-era/photo-story content;
- birthday letter;
- captions/headlines;
- page-level photo assignments;
- provenance/source-field references sufficient to audit grounding.

## Hallucination guard

Every generated factual statement must be traceable to supplied fixture input or be clearly non-factual editorial language.

Forbidden:
- invented trips;
- invented quotes;
- invented dates;
- invented hobbies;
- invented relationships;
- invented achievements.

## PDF / page proof

Required:
- exactly 12 pages;
- US Letter target;
- readable text;
- no clipping/overflow;
- all intended images render;
- no blank required page;
- final file opens;
- non-zero file size;
- page count verified programmatically.

## Style proof

Do not build three separate magazines.

Prove:
- one shared page architecture;
- at least one full generated PDF;
- the other two presets can apply their palette/type/graphic treatment without changing the content/page schema.

## QA proof

Implement deterministic checks for at least:

- page count == 12;
- recipient name consistency;
- age/birthday consistency;
- required sections present;
- exactly two non-duplicate dynamic modules;
- 12–25 source photo contract;
- must-use count <= 3;
- must-use photos mapped;
- missing/broken image detection;
- text overflow or explicit bounded-text failure handling;
- no unsupported dynamic module;
- output PDF exists and opens.

## Idempotency proof

For one synthetic order/job key:
- duplicate invocation must not create two active canonical generation jobs;
- duplicate model spend must be prevented by the local orchestration boundary.

No payment callback is required in this Gate.

## Allowed

- local/test runtime;
- synthetic/non-private fixture data;
- project-local code;
- free/open-source PDF/render dependencies;
- bounded model call only through approved protected credential mechanism;
- deterministic local screenshot/PDF evidence;
- GitHub branch/commit/PR.

## Forbidden

- PayPal;
- real payment;
- real customer data;
- production email;
- public/VPS deployment;
- paid plugin purchase;
- Shared Infra changes;
- G3 work;
- changing the frozen product contract;
- AI-generated imagery.

## Evidence

Create/update:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Also retain:
- synthetic fixture;
- generated 12-page proof PDF;
- page screenshots/contact sheet if useful;
- QA output;
- dependency/version record.

## GitHub submission

Mandatory:
- dedicated branch;
- commit;
- push;
- PR to `main`;
- do not self-merge;
- return branch + final commit SHA + PR.

Suggested branch:
`codex/birthday-magazine-g2b-local-ai-pdf-proof`

## PASS_CANDIDATE

A full PASS_CANDIDATE requires:
- real structured AI generation path proven safely;
- 12-page PDF generated;
- grounded content audit passed;
- photo mapping/must-use behavior passed;
- deterministic QA passed;
- idempotency passed;
- artifacts committed;
- cleanup/read-back passed where disposable runtime exists;
- GitHub PR open;
- no forbidden action.

If safe AI credential/runtime is unavailable but the non-AI pipeline is proven, return a precise blocked result rather than claiming full PASS.

## Return format

```text
GATE=G2B_LOCAL_AI_PDF_SOLUTION_PROOF
RESULT=PASS_CANDIDATE_G2B_LOCAL_AI_PDF_SOLUTION_PROOF

INTAKE_VALIDATION=PASS
AI_STRUCTURED_GENERATION=PASS
GROUNDING_AUDIT=PASS
PHOTO_MAPPING=PASS
MUST_USE=PASS
DYNAMIC_MODULES=PASS
PAGE_COUNT_12=PASS
PDF_RENDER=PASS
DETERMINISTIC_QA=PASS
IDEMPOTENCY=PASS

GIT_BRANCH=<branch>
GIT_COMMIT=<sha>
GITHUB_PR=<number/url>

FORBIDDEN_ACTIONS=0
STOP_AT_REVIEWER=YES
```

Do not enter G3.
