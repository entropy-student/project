# Birthday Magazine Studio — MVP Product Contract

> Status: FROZEN MVP CONTRACT — OWNER FLOW UPDATE 2026-10-04  
> Date: 2026-10-04  
> Authority: Owner-approved G2A2 product contract + Owner pre-payment full-intake flow decision  
> Parent truth: ../REVIEWER_HANDOFF.md

## 1. Offer

- Market: United States first.
- Language: English first.
- Product: personalized digital birthday magazine.
- Price under test: **US$39.99**.
- Output: **12-page US Letter PDF**, including front and back cover.
- Physical printing: out of MVP scope.
- Customer-facing promise: upload photos + answer a few good questions → receive a polished, story-led birthday magazine without Canva, layout work or designer back-and-forth.
- AI is production infrastructure, not the primary customer-facing claim.

## 2. Free Preview + route into the core function

The homepage and the free Preview are discovery/activation surfaces, not the full intake.

Free Preview inputs:
- recipient name;
- age / birthday;
- style preset;
- optional **one** local cover photo.

Free Preview output:
- immediate cover preview;
- one sample interior spread.

Free Preview hard boundary:
- the optional Preview photo remains browser-local;
- **0 server photo upload** from the free Preview itself;
- 0 LLM;
- 0 vision API;
- 0 image-generation API;
- no full-resolution export.

The free Activation target remains:
> “This already looks like their magazine.”

After the user understands the product, both the homepage entry and free Preview CTA may route into the **core function page** for the complete pre-payment intake.

## 3. Pre-payment draft, checkout, account / private workspace

The complete intake happens **before payment**, but production generation happens **only after payment**.

Product UX requirement:
- do not force a separate registration page before checkout;
- the core function page may create a temporary pre-payment draft for full intake data and uploaded photos;
- the temporary draft must not itself grant paid entitlement or trigger production generation;
- after the user submits the complete intake, route to WooCommerce checkout;
- checkout email creates or attaches the WooCommerce customer account/workspace;
- successful paid entitlement binds/adopts the submitted intake draft to the canonical WooCommerce order/customer;
- proof/revision/final download remain inside the authenticated private workspace.

Pre-payment draft requirements:
- exact draft/session identity must be server-generated and unguessable;
- draft access must be bounded to the submitting browser/session before checkout;
- no model/provider generation before paid entitlement;
- abandoned/unpaid drafts must have automatic short-lived retention and deletion; exact TTL is deferred to the implementation Gate and must be disclosed to the buyer;
- no ordinary analytics/advertising system receives source photos or private answers.

Authentication implementation preference:
1. passwordless/magic-link if later proven feasible without unacceptable paid/vendor dependency;
2. otherwise standard WooCommerce email/password setup.

Guest/no-account **private fulfillment** remains out of MVP scope; an anonymous temporary pre-payment draft is not fulfillment authority.

## 4. Pre-payment full intake

### Required factual fields
- recipient name;
- birthday and/or age;
- buyer relationship to recipient;
- desired tone: heartfelt / playful / balanced.

Pronouns:
- optional.

### Photos
- minimum: **12 source photos**;
- maximum: **25 source photos**;
- buyer may mark up to **3 must-use photos**;
- system target use: approximately **10–14 unique photos**;
- unused source photos are allowed and expected.

Supported MVP image formats:
- JPG/JPEG;
- PNG;
- WebP.

Exact byte/file-size ceiling is an implementation detail for a later Gate, but must remain compatible with the 12–25 photo contract.

### Six required short prompts

1. **What makes them unmistakably them?**
   - traits, quirks, habits, personality.

2. **Tell us one memory you always come back to.**
   - one specific scene, trip, day or moment.

3. **What do you admire or appreciate most about them — and why?**

4. **What are the little things only people close to them know?**
   - inside jokes, phrases, rituals, funny habits.

5. **What are they into right now?**
   - hobbies, music, food, places, current obsession/era.

6. **What do you want them to hear on this birthday?**
   - message, wish, next chapter.

Guidance:
- ask for roughly 1–4 sentences per prompt;
- do not ask the customer to write polished magazine copy.

### Optional quick facts
- favorite song;
- favorite food/drink;
- favorite place;
- current obsession;
- one must-include phrase/quote.

### Incomplete intake behavior
The user may save/progress through the core function page before checkout, but **submission to payment requires**:
- required factual fields complete;
- six required prompts complete;
- at least 12 valid source photos present.

An incomplete intake remains an editable temporary pre-payment draft and must not start generation.

### Submit -> payment boundary
After complete intake validation:
1. user presses **Submit / Continue to payment**;
2. the server freezes a versioned intake snapshot for checkout correlation;
3. WooCommerce checkout begins;
4. payment success binds that exact intake snapshot to the canonical order/customer;
5. only then may one canonical generation-ready job be created.

A failed/cancelled payment does not generate the magazine and does not create a second intake snapshot unless the user edits and resubmits.

## 5. Visual system

MVP exposes **3 style presets** sharing one common deterministic page architecture.

Working presets:
- Bold Editorial;
- Soft / Warm;
- Retro / Playful.

Presets may change:
- palette;
- typography;
- graphic treatment;
- decorative framing.

Presets must not create separate page architectures or separate generation engines.

No third-party magazine masthead/brand imitation is required; use the project's original Good Issue identity.

## 6. Magazine structure

Use a **fixed emotional spine + 2 dynamic module slots**.

### Page map

**P1 — Front Cover**
- deterministic layout;
- recipient name / birthday issue identity;
- one dominant selected photo;
- 2–3 personalized cover lines derived from intake;
- no long body copy.

**P2 — Opening Note**
- AI-written short editorial introduction;
- explains why this person deserves the issue;
- grounded only in supplied intake.

**P3 — Who They Are**
- personality/profile feature;
- based on Q1 + relevant quick facts;
- may include one or two photos.

**P4–P5 — Feature Memory**
- one two-page story spread;
- based primarily on Q2;
- this is the most specific narrative feature;
- use must-use/relevant photos when available.

**P6 — Dynamic Module A**
Select one based on supplied evidence:
- The Lore / inside jokes;
- Favorites;
- Playlist;
- Travel;
- Then & Now;
- Year in Review;
- Current Obsessions;
- Mini Timeline.

Do not select a module without sufficient grounded input.

**P7 — Why They Matter**
- based on Q3;
- admiration / reasons / quote-led feature;
- emotionally specific, not generic praise.

**P8–P9 — Photo Story / Current Era**
- photo-led two-page spread;
- based on Q5 plus available source photos;
- lighter copy density than P4–P5.

**P10 — Dynamic Module B**
- same eligible module pool as P6;
- must not duplicate P6;
- only generated when supported by supplied data.

**P11 — Birthday Letter / Next Chapter**
- based on Q6;
- direct emotional close;
- may incorporate future wishes without inventing unsupported facts.

**P12 — Back Cover**
- deterministic layout;
- one strong image or graphic treatment;
- short closing line.

### Deliberate exclusions
- no table of contents;
- no fixed astrology, fragrance, makeup, handbag, dream-car or other demographic filler;
- no AI-generated imagery in MVP;
- no full blank-canvas editor;
- no 24+ page expansion in MVP.

## 7. AI/content boundary

AI may:
- transform structured answers into magazine copy;
- summarize or reframe supplied memories;
- choose among approved dynamic module types;
- generate headlines/captions/short editorial transitions.

AI may not:
- invent biographical facts;
- invent events, quotes, relationships or preferences;
- infer sensitive facts not supplied;
- create replacement/generated portraits or other AI imagery for MVP;
- decide page geometry or pixel-level layout.

Layout and PDF composition remain deterministic.

## 8. Proof / revision

### Initial proof
After generation:
- customer sees a private proof in the authenticated workspace;
- proof shows the complete 12-page magazine.

### Included revision
US$39.99 includes **one bounded revision batch**.

One batch may include multiple small requests submitted together:
- factual corrections;
- tone/wording adjustments;
- swap up to **3 photos**;
- remove/replace one weak quote, caption or short section.

Not included:
- changing recipient;
- complete new visual concept;
- changing 12 pages to a larger product;
- full new intake;
- unlimited regeneration;
- repeated independent revision rounds.

After the bounded revision:
- customer reviews revised proof;
- approves;
- final PDF is generated/delivered.

## 9. QA contract

Before a proof/final can be marked ready:

- recipient name consistent on every page;
- age/birthday consistent;
- exactly 12 pages;
- no missing required page;
- no empty image slot;
- no unsupported dynamic module;
- must-use photos honored unless a deterministic technical reason blocks one, which must fail closed rather than silently omit;
- no duplicated photo where a unique photo is expected;
- no invented factual claim;
- no text overflow/clipping;
- no broken image;
- PDF opens successfully;
- all pages render;
- proof and final revision version match the approved content state;
- final file is non-zero and downloadable through the authenticated order context.

## 10. Data handling

This product is **not** permanent photo storage.

### Retention
After final approval/delivery:

- source photos: **delete within 24 hours**;
- intermediate render assets / working files: **delete within 24 hours**;
- proof artifacts superseded by final: **delete within 24 hours**;
- final PDF: available for **72 hours**;
- after 72 hours, final PDF is automatically deleted from project storage.

Customer receives an email notification when the final magazine is ready.

Delivery preference:
- authenticated private download is canonical;
- a small enough PDF may additionally be attached to email as a convenience copy;
- email attachment must not be the sole canonical delivery mechanism.

The customer should be told clearly before final delivery:
> For privacy, source photos and working files are deleted within 24 hours after final delivery. Your final PDF remains available for 72 hours.

### Earlier deletion
Customer may request earlier project-asset deletion.

### What may remain
Minimal order/account/payment records required for commerce, accounting, refund/support or legal obligations may remain separately.

Those records must not retain the source photo set merely for convenience.

### Analytics boundary
Do not send:
- source photos;
- generated proof pages;
- final PDF;
- private prompt answers;
- private attachment URLs

to ordinary analytics/advertising systems.

## 11. Payment/generation boundary

Canonical customer flow:
> **Homepage -> Free Preview -> homepage/Preview CTA -> Core function page -> full photo + answer intake -> Submit -> WooCommerce payment -> automatic generation -> complete private magazine viewer/proof**

MVP production generation may start only when:
- a complete, server-validated pre-payment intake snapshot exists;
- WooCommerce/server-side paid entitlement is confirmed;
- that exact intake snapshot is bound to the paid order/customer;
- no active canonical generation job already exists for that order.

One paid order -> at most one active canonical generation job.

Duplicate refresh/callback/job dispatch must not duplicate model spend. Payment failure/cancellation must leave generation at 0.

## 12. G2B implementation invariants

G2B may choose technical implementation details, but it may not change:

- 12 total pages;
- 12–25 photo intake;
- up to 3 must-use;
- six required prompts;
- fixed spine + two dynamic modules;
- three style presets on one architecture;
- no AI imagery;
- one bounded revision batch;
- account-required private workflow;
- 24h source/intermediate retention;
- 72h final PDF retention.

Any need to change these returns to Reviewer/Owner instead of being silently invented during implementation.

## 13. Owner flow update — 2026-10-04

The earlier wording “Paid intake” is superseded. Full photos and answers are now gathered **before checkout** on the dedicated core function page. Payment remains the boundary that authorizes generation, not the boundary that begins intake.
