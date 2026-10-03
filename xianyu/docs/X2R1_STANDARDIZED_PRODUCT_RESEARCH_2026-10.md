# X2R1 — Standardized Product Research — 2026-10-02

Status: PASS  
Selection axis: MARKET DEMAND × STANDARDIZATION  
Scope: Xianyu virtual/digital products  
Previous X2: retained as demand evidence, SUPERSEDED_FOR_SELECTION_AXIS

## 1. Why the research restarted

The previous X2 answered:

> 哪些闲鱼服务需求真实而且值得继续研究？

But the current business objective is narrower:

> 哪些真实需求能被做成 **同一商品重复卖**，或者变成 **结构化输入 → 固定流水线交付** 的半标品？

A high-demand service is therefore no longer sufficient.

## 2. Standardization taxonomy

### A — 纯标品

Same core deliverable for every buyer.

Examples:
- self-developed software/tool license;
- original tutorial/course + project files;
- importable workflow/template pack;
- original dataset;
- original template system.

Target:
- per-order human work approximately 0–5 min;
- automated/one-click delivery;
- no buyer-specific free-form production.

### B — 可产品化半标品

Buyer provides fixed fields/files; the same pipeline generates the result.

Examples:
- upload Excel → clean/validate → report/output;
- upload own images → batch standardize;
- JD + resume → fixed rubric diagnostic;
- website URL → fixed audit report.

Target:
- no requirement interview;
- human QA <=15 min/order after stabilization;
- 0 or 1 bounded correction.

### C — 套餐化服务

Fixed price/menu, but human still interprets the brief and produces a custom result.

Examples:
- PPT redesign;
- video editing;
- general resume rewriting.

Not eligible for current shortlist.

### D — bespoke

Each order is a project:
- custom development;
- CAD/modeling;
- consulting/integration.

Not eligible for current shortlist.

## 3. What current market evidence says about standardized products

### 3.1 Standardized AI knowledge products have real transaction evidence

Xianyu's 2026 H1 platform data says:
- AI-service orders: 9.816m;
- AI tutorials/courses: 8.1% of AI orders;
- AI templates/workflows: 6.6%;
- one seller sold 17,000 copies of an AI-manga-production tutorial in half a year.

This is the strongest current proof that **the same digital knowledge product can repeatedly transact on Xianyu**.

Counterevidence:
- tutorial/template shares are much smaller than skill-service share (45.1%);
- fast-moving AI topics create update burden;
- generic tutorials face piracy and free-content substitution.

### 3.2 Standardized software/tool demand is visible

Current public listing/recommendation evidence includes:
- ecommerce image download/productivity software: RMB 2.98–50.98, 722 “想要”, 5,163 views;
- Xianyu monitoring/reminder software: RMB 79.20, 147 “想要” in a current recommendation set;
- Xianyu seller automation monthly tool: RMB 30.50, 49 “想要”;
- AI bid-writing software/tool: RMB 8.60, 110 “想要”; the same market has many software-access/rental offers with much larger “想要” counts;
- online PDF tool: RMB 20, 15 “想要”;
- Python office-automation script pack: RMB 39.90 currently visible.

Interpretation:
- buyers do purchase reusable software/tool access;
- demand is very task-specific, not “software” in general;
- many visible products depend on platform automation, third-party accounts, scraping or resale rights and are therefore demand evidence only.

### 3.3 Template/workflow products are real, but provenance matters

Current evidence:
- platform: AI templates/workflows = 6.6% of AI orders;
- current WordPress “700+ templates” listing: RMB 25.90, 804 “想要”, about 10k views.

Interpretation:
- reusable assets can attract demand;
- large bundles are easy to clone and often have unclear license provenance;
- the executable thesis is **original or clearly licensed task-specific systems**, not “收集700个模板再打包卖”.

### 3.4 Data products are highly standardized and can attract strong intent

Current public data-product example:
- public-company executive-team-stability dataset;
- RMB 0.49 display / RMB 1 direct buy;
- 523 “想要”, 3,591 views;
- Excel delivery, auto-delivery described.

Interpretation:
- structured data is a true standard-product shape;
- this sample also shows the major risk: very low price, weak differentiation and uncertain transformation/redistribution rights when sellers merely collect public web data;
- only **originally processed, legally sourced, method-documented data products** remain executable.

### 3.5 Auto/virtual delivery exists as a platform capability

Official Xianyu service-provider documentation contains a virtual-delivery API and virtual-goods dispute/compensation fields.

Interpretation:
- standardized virtual fulfillment exists in the platform ecosystem;
- this does NOT prove an ordinary account automatically has the same API/qualification, so account-level eligibility remains UNKNOWN until later read-back.

## 4. Reclassification of the old X2 shortlist

| Old X2 direction | Demand | Standardization | New treatment |
|---|---:|---|---|
| Excel/data cleaning service | strong | C if custom; B if file-in/pipeline-out | TRANSFORM |
| fixed-scope website/custom micro-tool | very strong | C/D | REMOVE as direct candidate |
| PPT restructure + visual polish | strong | C | REMOVE |
| Workflow/Agent setup | strong | C/D if installed per client; A/B if reusable importable workflow | TRANSFORM |
| CAD/SolidWorks | very strong | D | REMOVE |
| resume/interview service | proven | C; B only as fixed diagnostic generator | TRANSFORM |
| ecommerce image standardization | moderate-strong | A/B if toolized | TRANSFORM |
| video editing | moderate | C/D | REMOVE |

Result:
- strong non-standard demand is preserved as Job evidence;
- it no longer consumes shortlist slots.

## 5. Standardized raw universe — 36

### Software / micro-tool
1. Excel merge/dedupe/clean local tool
2. Excel schema validator + error report
3. Word/PDF batch rename/convert/split/merge tool
4. buyer-owned image batch resize/compress/rename tool
5. ecommerce SKU image standardizer
6. subtitle format/timecode cleanup tool
7. transcript-to-structured-notes local/web tool
8. OCR-to-table fixed converter
9. bulk file organizer/naming tool
10. website fixed health/audit scanner
11. product-title/description compliance checker
12. resume/JD fixed rubric diagnostic tool
13. PPT structure/clarity diagnostic tool
14. single-purpose AI drafting tool for a narrow legal business task

### Workflow / template system
15. task-specific Dify/Coze/n8n workflow pack
16. role-specific AI agent starter workflow
17. Excel small-business CRM system
18. Excel inventory/profit dashboard system
19. quote/order/invoice tracking workbook system
20. Feishu/Notion content operations system
21. original PPT theme + layout system
22. original ecommerce image template system
23. original open-source WordPress starter kit
24. small-business SOP + live workbook system

### Knowledge product
25. AI niche tutorial + versioned project files
26. automation tutorial + scripts + demo data
27. workflow-building tutorial + importable workflow
28. tool-specific onboarding course + templates
29. original job-specific checklist/course + executable files

### Data product
30. legally sourced public-data cleaned dataset
31. original derived indicator/index dataset
32. regularly updated industry reference table
33. public-rule/reference database with changelog

### Structured-input generated product
34. JD + resume → diagnostic report
35. user-owned spreadsheet → validation/cleanup output
36. user-owned product images → standardized asset pack

## 6. Quick Kill under the standard-product lens

### KILL — standardized but structurally weak/unsafe

- generic Prompt bundle;
- generic PDF/resource dump;
- copyrighted template/course/software bundle without explicit redistribution rights;
- third-party membership/account rental, recharge or shared credential;
- cracked software/license resale;
- copied public dataset with no defensible transformation/right;
- platform-circumvention/搬运/去重/过审 utilities;
- software whose core value is unauthorized scraping/private-data access.

These can have high demand and still be bad products.

### HOLD — standardizable but current demand evidence too weak

- generic travel itinerary generator;
- generic Notion/Feishu template without a specific buyer Job;
- generic OCR/transcription utility;
- generic PPT template pack;
- broad “AI工具箱”.

## 7. X2R1 standardized shortlist — 8, not ranked

### P1 — Single-purpose self-developed productivity utility
Grade: A1

Shape:
one painful repetitive task → one tool → one clear before/after result.

Examples to validate next:
- Excel cleanup/validation;
- PDF/Word batch processing;
- file/image batch processing.

Why continue:
- current software/tool purchases are visible;
- AI office demand is growing;
- low marginal delivery cost.

Critical unknown:
Which one exact task has enough Xianyu-specific payment intent to avoid becoming a generic free utility?

### P2 — AI niche tutorial + project files
Grade: A0/A1

Shape:
versioned tutorial + source/project files + checklist + demo output.

Why continue:
- strongest exact transaction proof: 17k copies for one AI-manga tutorial;
- tutorials/courses are 8.1% of AI orders.

Critical unknown:
Which niche is still early enough that buyers pay instead of watching free content, while update burden remains manageable?

### P3 — Task-specific AI workflow / agent template pack
Grade: A1

Shape:
importable workflow + setup checklist + fixed inputs/outputs + demo + version notes.

Why continue:
- templates/workflows are 6.6% of AI orders;
- more standardized than per-client agent integration.

Critical unknown:
How much of the 6.6% category is actually reusable template demand versus custom setup?

### P4 — Excel / Office original business template system
Grade: A0/A1

Shape:
one job-specific workbook/system + demo data + onboarding video + bounded FAQ.

Examples:
inventory/profit; quote/order tracking; creator content ledger; small-business CRM.

Why continue:
- AI office category +264%;
- office automation products are visible;
- very low fulfillment cost.

Critical unknown:
Can a narrow vertical system beat free Excel templates strongly enough to justify payment?

### P5 — Buyer-owned ecommerce image / SKU batch tool
Grade: A1/B

Shape:
buyer supplies own images/SKU sheet → fixed batch resize/crop/naming/validation → output.

Why continue:
- current related ecommerce productivity software has 722 “想要”;
- result is measurable and batchable.

Critical unknown:
Does demand remain strong after removing the more controversial “download other-platform images” functionality?

### P6 — Original processed public-data product
Grade: A1

Shape:
lawful public sources → transparent transformation methodology → cleaned dataset + dictionary + version/changelog.

Why continue:
- current data product sample has 523 “想要” / 3,591 views;
- zero per-order customization;
- auto-delivery friendly.

Critical unknown:
Can an original higher-value dataset escape the RMB 1–10 commodity price floor and update/support burden?

### P7 — Structured-input diagnostic report generator
Grade: B

Shape:
fixed form/file input → fixed rubric/model → automated report → <=15 min optional QA.

Possible Jobs:
resume/JD gap; website health; product listing audit; spreadsheet quality.

Why continue:
- underlying service demand is already proven;
- converts a C service into a B product.

Critical unknown:
Will buyers pay for a standardized diagnostic without expecting human consulting and unlimited edits?

### P8 — Original / clearly licensed vertical Starter Kit
Grade: A1

Shape:
original or OSS-compatible starter project/template + install guide + fixed supported versions.

Why continue:
- current WordPress template listing shows 804 “想要” / about 10k views;
- site-building demand is very strong.

Critical unknown:
Can the product maintain clean licensing and low support, rather than becoming “帮我装/帮我改” after every sale?

## 8. Evidence-quality view

| Candidate | Payment evidence | Standardization | Support risk | Rights risk | Current confidence |
|---|---|---|---|---|---|
| P1 single-purpose utility | indirect + direct tool samples | A1 | low-medium | low if self-built | B/C |
| P2 AI tutorial + files | strong direct category + 17k case | A0/A1 | low-medium | low if original | A/B |
| P3 workflow pack | platform category | A1 | medium | low if original | B |
| P4 office template system | category + supply proxies | A0/A1 | low | low if original | C/B |
| P5 ecommerce batch tool | strong direct intent proxy | A1/B | low-medium | low only with buyer-owned inputs | B |
| P6 processed data product | direct intent | A1 | low-medium update burden | medium-high source/right risk | B/C |
| P7 diagnostic generator | underlying service demand | B | medium | low | C/B |
| P8 vertical starter kit | direct asset intent + site demand | A1 | medium-high | low only with clean license | B/C |

No final score is issued here.

## 9. Standardization economics to verify in X3

Every candidate must model:

~~~text
SELL_PRICE
- platform/payment cost
- API/compute/storage
- average support minutes × labor value
- update/maintenance amortization
- refund/dispute expected loss
= contribution per order
~~~

And must report:

- HUMAN_MINUTES_PER_ORDER
- SUPPORT_MINUTES_PER_ORDER
- DELIVERY_AUTOMATION_RATE
- MONTHLY_UPDATE_HOURS
- REFUND_TRIGGER
- VERSION_COMPATIBILITY_BURDEN
- RIGHTS_PROOF
- FREE_SUBSTITUTE_GAP

A product with low unit cost but 30–60 minutes of chat/support is not treated as a real standard product.

## 10. X2R1 result

~~~text
X2R1_STANDARDIZED_PRODUCT_REFRAME=PASS
PREVIOUS_X2_SHORTLIST=SUPERSEDED_FOR_SELECTION_AXIS
STANDARDIZED_RAW_UNIVERSE=36
STANDARDIZED_SHORTLIST=8
A_B_ONLY=YES
FINAL_TOP3=NOT_SELECTED
REAL_LISTING=0
REAL_PURCHASE=0
ACCOUNT_MUTATION=0
RUNTIME_MUTATION=0
NEXT=X3_STANDARDIZED_EVIDENCE_CARDS_AND_TOP3
~~~

## 11. Source ledger

Primary / high-confidence:
- Xinhua 2026 H1 Xianyu AI-service data:
  https://www3.xinhuanet.com/tech/20260729/3ba4f5d1aaf044229b890f40ce52f492/c.html
- Xianyu virtual-delivery/service-provider docs:
  https://open.goofish.com/doc/development/dev/server.html
- Xianyu current marketplace:
  https://www.goofish.com/

Current direct/recommendation examples:
- ecommerce image productivity software:
  https://www.goofish.com/item?categoryId=201453616&id=920219589301
- WordPress template bundle:
  https://www.goofish.com/item?categoryId=201454708&id=810121295766
- public-company processed dataset:
  https://www.goofish.com/item?id=966484455784
- AI bid-tool recommendation market:
  https://www.goofish.com/item?categoryId=0&id=968373210332
- office scripts / online PDF / digital-product recommendation set:
  https://www.goofish.com/item?categoryId=50023914&id=1056677193291
- software/tool recommendation set:
  https://www.goofish.com/item?categoryId=0&id=1042808803331

Counterevidence:
- many high-demand software listings rely on platform automation, third-party access, copying, scraping or rights-fragile supply;
- this research preserves their demand signal while rejecting their delivery model.
