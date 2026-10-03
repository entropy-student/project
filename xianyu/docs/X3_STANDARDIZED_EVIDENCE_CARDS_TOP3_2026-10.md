# X3 — Standardized Evidence Cards & Top 3 — 2026-10-03

> **SELECTION STATUS — SUPERSEDED BY X3R1 (2026-10-03):** 本文的 P1/P2/P4 Top 3 只保留为商品结构分析与历史 Evidence，不再是当前选品 shortlist。当前 selection unit 是具体商品/SKU，权威候选池见 `X3R1_CONCRETE_SKU_DEMAND_POOL_2026-10.md`。货源 UNKNOWN 不用于否定需求。

Status: PASS_CANDIDATE pending Reviewer fresh read-back  
Scope: Xianyu only  
Endpoint: research Top 3 only; no real listing, purchase, payment, account mutation or runtime mutation  
Selection axis: MARKET DEMAND × STANDARDIZATION × LEGAL REPEATABILITY

## 1. Gate question

对 X2R1 的 8 个 A/B 候选，哪一些已经具备足够强的 **闲鱼需求证据 + 可重复交付结构 + 可控售后/维护成本**，值得进入 Minimum Validation？

本轮不是选“最终赢家”，也不把公开网页上的“想要/浏览”当订单。

## 2. Evidence rules used

Evidence priority:

1. current official Xianyu agreement / official product docs;
2. Xianyu-reported transaction data carried by high-authority media;
3. current Goofish item/recommendation pages;
4. current first-party/free-substitute evidence;
5. inference.

Signal interpretation:

```text
Transaction/payment
> explicit purchase action / direct-buy structure
> qualified intent
> 想要
> views / supply visibility
```

Seller-wide “卖出 X 件宝贝” is seller-level only and is never assigned to one SKU.

Every card below separates FACT / INFERENCE / UNKNOWN.

## 3. Current rule and market refresh

### Official rule baseline

FACT:
- Current mainland Xianyu Community User Service Agreement shows latest version 2026-05-27, effective 2026-06-15.
- The agreement explicitly covers information and transactions for闲置物品/商品/服务 and requires publishers to possess lawful rights to what they publish.
- Current official Xianyu service-provider docs expose order, payment and virtual-delivery/dispute fields, proving virtual fulfillment exists in the platform ecosystem.

UNKNOWN:
- The current project account's exact eligibility for the relevant virtual/service category has not been read back inside the account.
- Service-provider API capability does not prove ordinary-account access to the same fulfillment route.

Decision effect:
- X3 may select research candidates.
- No candidate may become `PRIORITY TEST` until the account/platform path is proven in a later Gate.

### Platform transaction baseline

FACT:
- Xianyu-reported 2026 H1 AI-service orders: 9.816m, +157% YoY; nearly 5m buyers, +98%.
- AI tutorial/course orders: 8.1%.
- AI template/workflow orders: 6.6%.
- One seller reportedly sold 17,000 copies of an AI-manga-production tutorial in six months.
- AI programming/site-building grew +1732%; AI PPT/office grew +264%.

Counterevidence:
- AI skill gigs are still the largest share at 45.1%, so standardized products are not automatically the dominant format.
- Average seller economics are not proven by category growth alone.

Primary source:
https://www.xinhuanet.com/tech/20260729/3ba4f5d1aaf044229b890f40ce52f492/c.html

## 4. X3 disposition summary

| Candidate | X3 research score* | Critical confidence | Standardization | X3 disposition | Main reason |
|---|---:|---|---|---|---|
| P1 Single-purpose self-developed utility | 78/100 | B/C | A1 | TOP3_CONTINUE | current direct software offers + clear result + low marginal fulfillment |
| P2 AI niche tutorial + project files | 78/100 | B | A0/A1 | TOP3_CONTINUE | strongest platform transaction proof for repeated identical digital delivery |
| P3 Task-specific AI workflow / agent pack | 69/100 | C/B | A1 | HOLD | platform payment exists, but free template supply is extremely deep and category mixes customization |
| P4 Excel / Office vertical business system | 78/100 | C/B | A0/A1 | TOP3_CONTINUE | office demand + current paid reusable packs + very low fulfillment/support potential if vertical |
| P5 Buyer-owned ecommerce image/SKU batch tool | 70/100 | C/B | A1/B | HOLD | strong adjacent intent, but sampled demand is partly for cross-platform downloading and free batch tools are strong |
| P6 Original processed public-data product | 55/100 | C | A1 | HOLD_HIGH_RISK | current direct intent exists, but sampled market is ¥1-level and rights/provenance risk is structural |
| P7 Structured-input diagnostic report | 72/100 | C | B | HOLD | underlying job demand exists, but current standardized-payment proof is weak and free AI workflows substitute heavily |
| P8 Original / licensed vertical Starter Kit | 64/100 | C | A1 | HOLD | current asset intent exists, but free OSS/theme supply and post-sale setup support weaken economics |

* Research score uses the Xianyu Skill weights only as a comparative research aid. It is **not** a Final Priority Test because account policy/path and real payment validation remain unresolved.

Top 3 is **not ranked**.

## 5. Evidence Card — P1 Single-purpose self-developed utility

Candidate unit:
> specific buyer with one repetitive business task × current manual/spreadsheet workaround × self-developed narrow utility × one measurable result × direct download/license delivery.

Examples worth later narrowing:
- quote/order utility;
- Excel validation/cleanup utility;
- PDF/Word batch utility;
- narrow file-processing utility.

### E1 Job / Problem Reality — 4/5 — FACT + INFERENCE
FACT:
- A current Xianyu listing for a self-developed quotation-management application is priced at ¥13.50 / direct-buy ¥13.90, has 133 “想要” and 5,008 views.
- Its value proposition is concrete: product/customer database, automatic tax calculation, Excel/PDF export, backups, quick quote editing.

Source:
https://www.goofish.com/item?categoryId=0&id=974663190233

INFERENCE:
- Buyers pay to remove repetitive structured office work when the result is immediately measurable.

### E2 Payment Reality — 3/5 — C
FACT:
- Direct-buy structure exists on the live item.
- Current Xianyu recommendation pages also expose a Python Office automation script pack at ¥39.90.

UNKNOWN:
- SKU-level completed order count, refund rate and inquiry-to-purchase conversion are not public.

### E3 Reachable Platform Demand — 4/5 — B/C
FACT:
- Current product titles can express the job in one line: 报价软件 / Excel自动化 / PDF工具.
- AI PPT/office order growth is +264% at category level.

### E4 Timing / Persistence — 4/5 — STABLE/GROWING
Office repetition and document/file processing are durable jobs; the AI/automation framing is growing, while exact tools can commoditize.

### E5 Competition / Saturation — 3/5
Counterevidence:
- Many cheap tools/scripts exist.
- Platform recommendation sets contain ¥1–40 utilities.
- Generic “toolbox” positioning is easy to clone.

Gap:
- one narrow result with visible before/after proof is more defensible than a generic utility collection.

### E6 Product Thesis / Free Substitute Resistance — 4/5 if narrow, 2/5 if generic
Must Keep:
- local/self-contained or clearly bounded workflow;
- one-click operation;
- deterministic validation/export;
- visible sample input/output.

Must Fix:
- generic features that users can reproduce in free scripts/ChatGPT.

Must Prove:
- buyers pay for saved setup time, not merely for code files.

### E7 Xianyu Distribution Fit — 5/5
Search intent is explicit, title can name the task, screenshots can prove output, and immediate direct-buy is natural.

### E8 Trust / Proof Fit — 4/5
Strong proof artifacts:
- demo video;
- before/after files;
- supported input formats;
- known limitations;
- version and compatibility table.

### E9 Economics — 4/5
Research model, not account fact:
- likely price band to test: ¥19.9–69.9 depending on pain and packaging;
- target human work/order: 0–5 min;
- support becomes the dominant risk, not compute.

At ¥39.9, a 3-minute support target leaves wide room before platform fees. At ¥13.9, a 15-minute support case can erase the unit economics.

### E10 Delivery / Compliance / Dispute — 4/5
Rights are strong if self-developed.
Risks:
- Windows/macOS compatibility;
- antivirus false positives;
- “不会用” support;
- license/device replacement;
- overpromised automation results.

### Standardization Gate
CORE_INVARIANCE=PASS  
STRUCTURED_INPUT=PASS  
HUMAN_MINUTES=PASS_TARGET_0_5  
REVISION_BOUNDARY=PASS  
FULFILLMENT=PASS  
SUPPORT_LOAD=PASS_IF_SCOPE_NARROW  
RIGHTS=PASS_IF_SELF_DEVELOPED  
VERSION_BURDEN=MEDIUM

### Critical unknown
Which one exact job has enough payment intent above the free-tool floor?

Disposition: **TOP3_CONTINUE**

---

## 6. Evidence Card — P2 AI niche tutorial + project files

Candidate unit:
> fast-changing but concrete AI task × buyer wants to reproduce an outcome × versioned tutorial + original project/source files + checklist + demo output × identical digital delivery.

### E1 Job / Problem Reality — 4/5
FACT:
- Xianyu AI-service buyer volume is large and fast growing.
- AI tutorial/course is a distinct transaction category.

### E2 Payment Reality — 5/5 — A/B
FACT:
- Tutorials/courses are 8.1% of 9.816m H1 AI-service orders.
- Xianyu-reported example: one seller sold 17,000 copies of an AI-manga-production tutorial in six months.

Source:
https://www.xinhuanet.com/tech/20260729/3ba4f5d1aaf044229b890f40ce52f492/c.html

Cross-platform counterexample:
- Bilibili currently has a paid AI-manga course with 49 lessons at ¥198, showing the same job also has paid alternatives outside Xianyu.

### E3 Reachable Platform Demand — 4/5
Search terms are concrete when tied to a result/tool: AI漫剧全流程 / 某工具上手 / 项目文件 / 工作流实战.
Generic “AI赚钱教程” is intentionally excluded.

### E4 Timing / Persistence — 4/5 — GROWING but fast-changing
Demand is current and growing, but tool/model UI changes can invalidate course steps quickly.

### E5 Competition / Saturation — 2/5
High:
- abundant ¥1–10 tutorials and copied materials;
- free Bilibili/official docs/creator content;
- piracy/cloning is easy.

### E6 Product Thesis / Free Substitute Resistance — 2.5/5 generic; 4/5 only with executable assets
Must Keep:
- original project/source files;
- exact version;
- working demo;
- troubleshooting tree;
- changelog.

Must Fix:
- “视频讲一遍公开知识”.

Must Prove:
- project files + current executable path save enough time to justify payment.

### E7 Xianyu Distribution Fit — 5/5
Immediate search intent, easy title/cover comprehension, identical delivery.

### E8 Trust / Proof Fit — 4/5
Proof:
- sample lesson;
- demo final output;
- file tree screenshot;
- current-version date;
- “适用/不适用” boundary.

### E9 Economics — 4/5 only if update amortization is controlled
Base hypothesis:
- price ¥19.9+;
- delivery 0–2 min;
- support <=5 min;
- update work batched per version.

Bad case:
- ¥5–9.9 price + repeated “软件变了怎么办” support.

Stress:
- a major tool/model UI change forces complete re-recording; margin can turn negative without version cutoff.

### E10 Delivery / Compliance / Dispute — 4/5 if original
Hard rules:
- no pirated courses/project files;
- no redistributed paid software/accounts/API keys;
- no “包赚钱/包变现” claims;
- explicit version and no-guaranteed-result boundary.

### Standardization Gate
CORE_INVARIANCE=PASS  
STRUCTURED_INPUT=NOT_REQUIRED  
HUMAN_MINUTES=PASS_TARGET_0_5  
REVISION_BOUNDARY=PASS  
FULFILLMENT=PASS  
SUPPORT_LOAD=MEDIUM  
RIGHTS=PASS_IF_ORIGINAL  
VERSION_BURDEN=MEDIUM_HIGH

### Critical unknown
Can a narrow AI tutorial remain paid-worthy for 60–90 days without constant re-recording?

Disposition: **TOP3_CONTINUE**

---

## 7. Evidence Card — P3 Task-specific AI workflow / agent template pack

### E1 Job / Problem Reality — 4/5
Business automation jobs are real; Dify/n8n explicitly productize reusable workflows.

### E2 Payment Reality — 4/5 category / C for reusable pack specifically
FACT:
- Xianyu AI templates/workflows are 6.6% of AI-service orders.
- The same platform statement explicitly mixes workflow customization and AI-agent setup.

UNKNOWN:
- pure reusable template-pack share inside 6.6%.

### E3 Reachable Platform Demand — 4/5
Task-specific titles are searchable; generic “100套工作流” is not sufficient evidence.

### E4 Timing / Persistence — 4/5 — GROWING

### E5 Competition / Saturation — 2/5
Strong free substitute pressure:
- n8n currently exposes 12,895 community workflow templates.
- Dify Marketplace offers one-click reusable templates and many official/community examples.

Sources:
https://n8n.io/workflows
https://marketplace.dify.ai/templates

### E6 Product Thesis — 2/5 generic
A pack must add:
- Chinese business-specific configuration;
- tested credentials/setup map;
- failure handling;
- version compatibility;
- demo data;
- acceptance test.

Otherwise free marketplace templates dominate.

### E7 Distribution Fit — 4/5
Good search/title fit, but education/setup burden is higher than P1/P2/P4.

### E8 Trust / Proof — 4/5
Runnable demo and importable file are strong proof.

### E9 Economics — 3/5
Delivery is cheap; support is dangerous because API keys, credentials, OAuth and platform changes turn a “template” into consulting.

### E10 Delivery / Compliance — 3/5
Must never include third-party credentials/accounts. Integration permissions and privacy can expand support/dispute scope.

Standardization:
CORE_INVARIANCE=PASS  
HUMAN_MINUTES=CONDITIONAL  
SUPPORT_LOAD=MEDIUM_HIGH  
VERSION_BURDEN=HIGH

Critical unknown:
Can a reusable pack be sold without becoming per-customer integration work?

Disposition: **HOLD**

---

## 8. Evidence Card — P4 Excel / Office vertical business system

Candidate unit:
> one narrow operator role × recurring record/decision job × original workbook/system × demo data + dashboard + instructions × identical file delivery.

### E1 Job / Problem Reality — 4/5
FACT:
- AI PPT/office orders grew +264%.
- Current Xianyu recommendations expose a Python Office automation script pack at ¥39.90.
- A current public paid Xianyu-linked Excel pack is offered at ¥19.90 with dashboard, order ledger, cost/inventory, pricing and weekly-review sheets.

The latter proves a current executable offer shape, not verified independent sales volume.

### E2 Payment Reality — 3/5 — C
There are paid live offers; SKU-level orders remain unknown.

### E3 Reachable Platform Demand — 4/5
Strong when vertical:
- 库存利润表
- 报价订单管理
- 副业小店记账
- 客户跟进表
- 内容运营台账

Weak when generic:
- “1000个Excel模板”.

### E4 Timing / Persistence — 4/5 — STABLE
Spreadsheet-based operations are durable and less tool-version-sensitive than AI tutorials.

### E5 Competition / Saturation — 2.5/5
Free substitutes are very strong:
- Microsoft offers free Excel templates and template search.
- many Chinese SaaS/template products exist.

Source:
https://support.microsoft.com/en-us/excel/free-excel-for-the-web-templates

### E6 Product Thesis — 3/5
Must Keep:
- vertical-specific fields and workflow;
- protected formulas;
- sample data;
- dashboard;
- decision checklist.

Must Prove:
- buyer saves setup/decision time versus a free generic template.

### E7 Distribution Fit — 5/5
Excellent Xianyu search fit and easy proof screenshots.

### E8 Trust / Proof — 5/5
The deliverable is directly previewable; sample workbook can reduce uncertainty before purchase.

### E9 Economics — 4.5/5
Best structural economics of the 8 if the template is truly self-serve:
- near-zero variable compute;
- 0–3 min delivery/support target;
- low update cadence;
- simple versioning.

Risk:
- cheap price + Excel beginner support can still consume margin.

### E10 Delivery / Compliance — 5/5 if original
Low privacy/IP risk when original and delivered as editable files with clear use/license boundary.

### Standardization Gate
CORE_INVARIANCE=PASS  
STRUCTURED_INPUT=NOT_REQUIRED  
HUMAN_MINUTES=PASS_TARGET_0_3  
REVISION_BOUNDARY=PASS  
FULFILLMENT=PASS  
SUPPORT_LOAD=LOW_IF_SELF_SERVE  
RIGHTS=PASS_IF_ORIGINAL  
VERSION_BURDEN=LOW

### Critical unknown
Which vertical has enough payment intent to beat free Excel templates?

Disposition: **TOP3_CONTINUE**

---

## 9. Evidence Card — P5 Buyer-owned ecommerce image / SKU batch tool

### E1 Job / Problem Reality — 4/5
Image resizing/naming/normalization is a real repetitive ecommerce task.

### E2 Payment Reality — 3/5
FACT:
- current ecommerce image productivity listing: ¥2.98–50.98, 722 “想要”, 5,163 views.

Source:
https://www.goofish.com/item?categoryId=201453616&id=920219589301

### E3 Reachable Demand — 4/5
Keywords can be concrete: 批量改尺寸 / SKU图重命名 / 主图统一 / 压缩.

### E4 Timing — 4/5 — STABLE

### E5 Competition — 2.5/5
The sampled listing's strongest use is downloading other-platform product images, which is not the legal product thesis.
Free tools are strong.

### E6 Free-substitute resistance — 2/5
ImageMagick already supports resizing/cropping/conversion and batch processing for free.

Sources:
https://imagemagick.org/magick/
https://usage.imagemagick.org/windows/

A paid product needs non-technical UX + ecommerce-specific naming/validation presets.

### E7 Distribution — 4.5/5
Very clear task/search intent.

### E8 Trust — 4/5
Before/after batch sample is strong proof.

### E9 Economics — 3.5/5
Low delivery cost, but low visible price anchor and free substitutes cap pricing.

### E10 Compliance — 4/5 only with buyer-owned inputs
Do not copy/scrape third-party product assets without rights.

Critical unknown:
Does the legal “process my own images” sub-job retain enough willingness to pay after removing download/scrape features?

Disposition: **HOLD**

---

## 10. Evidence Card — P6 Original processed public-data product

### E1 Job / Problem Reality — 3/5
Researchers/operators do pay to avoid collecting and cleaning data manually.

### E2 Payment Reality — 3/5
FACT:
- current dataset listing: ¥0.49 / direct-buy ¥1, 523 “想要”, 3,591 views.

Source:
https://www.goofish.com/item?id=966484455784

### E3 Reachable Demand — 3/5
Search intent exists for exact datasets/variables, but each dataset can be narrow.

### E4 Timing — 3/5 — STABLE/NICHE

### E5 Competition — 2/5
Price floor is extremely low and many products are easy to copy.

### E6 Thesis — 2/5
Counterevidence from the live listing itself:
- seller states data are “搬运自网络” and updated irregularly.
- that is not an acceptable supply model for this project.

A valid product would need original transformation, methodology, data dictionary and reproducible provenance.

### E7 Distribution — 4/5
Exact variable/dataset search is strong.

### E8 Trust — 3/5
Methodology/sample rows can help, but source accuracy/support disputes can be substantial.

### E9 Economics — 2/5
At ¥1–10, even a few minutes of support or monthly maintenance can destroy contribution.

### E10 Compliance — 2/5
Rights, database terms, privacy and redistribution permission require dataset-by-dataset proof.

Critical unknown:
Can one legally sourced transformed dataset sustain a materially higher price than the current commodity floor?

Disposition: **HOLD_HIGH_RISK**

---

## 11. Evidence Card — P7 Structured-input diagnostic report generator

Candidate examples:
- resume + JD -> gap report;
- URL -> website health report;
- spreadsheet -> quality report.

### E1 Job / Problem Reality — 4/5
Underlying human-service jobs are already proven in X1/X2.

### E2 Payment Reality — 3/5
Human-service payment exists; standardized-report payment on Xianyu remains weakly evidenced.

### E3 Reachable Demand — 4/5
Search titles can name exact result: 简历JD匹配诊断 / 网站健康检查 / Excel错误报告.

### E4 Timing — 4/5 — STABLE

### E5 Competition — 3/5
Generic AI diagnostics are easy to generate.

### E6 Free-substitute resistance — 2/5
Dify Marketplace currently includes a free AI job-search workflow that accepts resume + JD and performs matching/optimization.

Source:
https://marketplace.dify.ai/template/teany/a270a957-6d92-45c4-8792-91b61cecdfe8

Paid value must be a fixed proprietary rubric + evidence + deterministic checks, not generic LLM advice.

### E7 Distribution — 5/5
Excellent result-oriented search fit.

### E8 Trust — 4/5
Sample annotated report and rubric are strong proof.

### E9 Economics — 3/5
Compute is cheap; quality disputes and “再帮我看看” consulting can inflate support.

### E10 Compliance — 4/5
Privacy is material for resumes/business files. Need deletion policy and no fabricated credentials/outcomes.

Critical unknown:
Will buyers accept a bounded automated diagnostic rather than expecting human consulting?

Disposition: **HOLD**

---

## 12. Evidence Card — P8 Original / licensed vertical Starter Kit

### E1 Job / Problem Reality — 4/5
Site-building/setup demand is strong; buyers seek a starting point rather than building from zero.

### E2 Payment Reality — 3/5
FACT:
- current WordPress “700+ templates” listing: ¥25.90, direct-buy ¥29, 804 “想要”, about 10k views.

Source:
https://www.goofish.com/item?categoryId=201454708&id=810121295766

### E3 Reachable Demand — 4/5
Strong keywords: WordPress模板 / 外贸站 / 企业官网 / Starter Kit.

### E4 Timing — 4/5 — STABLE

### E5 Competition — 2/5
WordPress.org currently lists thousands of free themes; free OSS is a direct substitute.

Source:
https://wordpress.org/themes/

### E6 Product Thesis — 2/5 generic; higher only when vertical
A legal Starter Kit needs:
- original/compatible OSS composition;
- narrow vertical demo;
- version-pinned install;
- sample content;
- upgrade path.

### E7 Distribution — 4/5

### E8 Trust — 3/5
Live demo helps, but buyers often ask for installation/config help.

### E9 Economics — 2.5/5
Post-sale setup can turn a ¥20–50 product into service work.

### E10 Compliance — 3/5
License compatibility and bundled asset rights must be proven.

Critical unknown:
Can support be capped without destroying conversion?

Disposition: **HOLD**

## 13. Standardization economics comparison

These are hypothesis bands for deciding what to validate next, not observed account economics. Platform/payment fee remains account/path dependent and therefore is not hard-coded.

| Candidate | Plausible test price band | Target human min/order | Update burden | Support risk | Economics view |
|---|---:|---:|---|---|---|
| P1 utility | ¥19.9–69.9 | 0–5 | medium | low-medium | GOOD if one-task and self-serve |
| P2 AI tutorial+files | ¥9.9–49.9 | 0–5 | medium-high | medium | GOOD only with version cutoff/assets |
| P3 workflow pack | ¥19.9–99 | 0–15 | high | high | FRAGILE until setup scope proven |
| P4 vertical Excel/Office | ¥9.9–49.9 | 0–3 | low | low | STRONGEST structural margin |
| P5 ecommerce batch tool | ¥9.9–39.9 | 0–5 | medium | low-medium | price capped by free tools |
| P6 data product | ¥1–49.9 | 0–5 | medium-high | medium | weak unless proprietary transformation |
| P7 diagnostic report | ¥9.9–59.9 | 3–15 | medium | medium-high | depends on bounded QA |
| P8 Starter Kit | ¥19.9–99 | 0–15 | medium-high | high | support can dominate |

### Support-stress rule

At a shadow labor value of ¥60/hour:
- 3 minutes = ¥3 labor;
- 5 minutes = ¥5;
- 15 minutes = ¥15;
- 30 minutes = ¥30.

Therefore a ¥9.9–19.9 product that routinely needs 15–30 minutes of chat/support is structurally non-standard even if file delivery itself is instant.

## 14. Top 3 independent pre-mortem

### P1 utility
1. Same-source risk: many tool listings may reflect one clone ecosystem rather than broad independent payment.
2. Intent-vs-payment: “想要” can be bookmarking.
3. Low-price trap: ¥1–15 utilities anchor willingness to pay down.
4. Free substitute: ChatGPT/scripts/free apps can reproduce generic functions.
5. New seller trust: executable files trigger malware/compatibility fear.
6. Refund trigger: cannot run / unsupported OS / antivirus warning.
7. Rule risk: platform policies around software or automation can change.
8. Support x2: still viable only if demo + compatibility matrix suppress questions.
9. 90-day failure: free OS/AI feature absorbs the task.
10. Kill evidence: real test shows most qualified inquiries expect custom development or support >15 min/order.

### P2 AI tutorial + project files
1. Same-source risk: one 17k seller is a standout case, not median economics.
2. Interest-vs-payment: AI hype drives views and “想要”.
3. Low-price/copy risk: pirated/copy bundles can create misleading price expectations.
4. Free substitute: Bilibili/free creator tutorials.
5. New seller trust: buyer asks “是不是网上拼的”.
6. Refund trigger: tool UI changed / project file fails / content outdated.
7. Rule risk: digital-content category qualification or IP enforcement.
8. Support x2: acceptable only with versioned FAQ and no live coaching.
9. 90-day failure: model/tool updates obsolete the workflow.
10. Kill evidence: version maintenance exceeds 20–30% of monthly product gross contribution or buyers mainly want copied third-party assets.

### P4 vertical Excel/Office system
1. Same-source risk: current direct reusable-pack samples are sparse.
2. Interest-vs-payment: free sample downloads do not prove purchase.
3. Low-price trap: generic template bundles at commodity prices.
4. Free substitute: Microsoft/free templates.
5. New seller trust: buyer may doubt formulas/fit.
6. Refund trigger: “不会用/字段不适合我”.
7. Rule risk: relatively low but category/virtual-delivery path still must be verified.
8. Support x2: remains viable only if onboarding is self-serve.
9. 90-day failure: SaaS/free AI template generators make the workbook generic.
10. Kill evidence: buyers repeatedly require custom columns/formulas and support >15 min/order.

## 15. Why P3/P5/P7 did not enter Top 3

P3 workflow pack:
- strong macro payment signal;
- but free n8n/Dify template supply is massive;
- pure-template payment share inside Xianyu's 6.6% category is unknown;
- integrations can convert a standard product into consulting.

P5 ecommerce batch tool:
- strongest direct “想要” among the non-Top3;
- but the current live demand sample centers on cross-platform asset downloading, while the legal buyer-owned batch-processing sub-job has not yet shown equally strong payment evidence;
- ImageMagick and other free utilities cap generic value.

P7 diagnostic generator:
- underlying human job is real;
- but standardized report payment is not directly proven;
- free AI workflows already perform resume/JD matching;
- support can become consulting.

These are HOLD, not rejected forever.

## 16. X3 result

```text
X3_STANDARDIZED_EVIDENCE_CARDS_AND_TOP3=PASS_CANDIDATE
E1_E10_CARDS=8/8
TOP3_COUNT=3
TOP3_RANKED=NO
TOP3=P1_SINGLE_PURPOSE_UTILITY;P2_AI_NICHE_TUTORIAL_PROJECT_FILES;P4_VERTICAL_EXCEL_OFFICE_SYSTEM
POLICY_ACCOUNT_PATH=UNKNOWN_CONDITIONAL
REAL_LISTING=0
REAL_PURCHASE=0
PAYMENT=0
ACCOUNT_MUTATION=0
RUNTIME_MUTATION=0
FINAL_PRIORITY_TEST=NOT_RUN
NEXT=X4_MINIMUM_VALIDATION_DESIGN_AND_ACCOUNT_POLICY_READBACK
```

## 17. Source ledger

Official/current platform:
- Xianyu Community User Service Agreement:
  https://terms.alicdn.com/legal-agreement/terms/suit_bu1_other/suit_bu1_other201708081618_51146.html
- Xianyu service-provider / virtual-order docs:
  https://open.goofish.com/doc/development/dev/server.html
- Xianyu order/payment page docs:
  https://open.goofish.com/doc/api/advanced/openPayment.html

Platform transaction reporting:
- Xinhua, 2026 H1 AI service transactions:
  https://www.xinhuanet.com/tech/20260729/3ba4f5d1aaf044229b890f40ce52f492/c.html

Current Xianyu examples:
- self-developed quotation software:
  https://www.goofish.com/item?categoryId=0&id=974663190233
- ecommerce image productivity:
  https://www.goofish.com/item?categoryId=201453616&id=920219589301
- processed public dataset:
  https://www.goofish.com/item?id=966484455784
- WordPress template bundle:
  https://www.goofish.com/item?categoryId=201454708&id=810121295766
- current recommendation set containing Python Office automation scripts:
  https://www.goofish.com/item?categoryId=50023914&id=1056677193291

Free-substitute / counterevidence:
- Microsoft free Excel templates:
  https://support.microsoft.com/en-us/excel/free-excel-for-the-web-templates
- n8n template library:
  https://n8n.io/workflows
- Dify Marketplace:
  https://marketplace.dify.ai/templates
- Dify free resume/JD workflow example:
  https://marketplace.dify.ai/template/teany/a270a957-6d92-45c4-8792-91b61cecdfe8
- ImageMagick batch processing:
  https://imagemagick.org/magick/
  https://usage.imagemagick.org/windows/
- WordPress theme directory:
  https://wordpress.org/themes/

## 18. Evidence limitations

- Public Goofish indexing is incomplete and unstable.
- “想要” and views are not orders.
- seller-wide sold count is not SKU sales.
- current account qualification is not yet proven.
- refund/dispute rates, qualified inquiry conversion and true support minutes remain UNKNOWN until Minimum Validation.
- Top 3 therefore means “best next research/test candidates”, not “best business” and not a final launch decision.
