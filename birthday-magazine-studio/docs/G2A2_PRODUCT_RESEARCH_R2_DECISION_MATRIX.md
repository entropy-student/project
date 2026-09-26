# G2A2 Product Research R2 — Decision Matrix

> Status: CURRENT SUPPORTING RESEARCH / NOT A FREEZE  
> Date: 2026-09-27  
> Parent truth: ../REVIEWER_HANDOFF.md  
> Purpose: turn market/adjacent-product evidence into explicit Owner decisions for the MVP contract.

## 1. Executive finding

The category has a clear product gap:

```text
DIY Canva birthday magazine
$4–15-ish
beautiful + flexible
BUT buyer still selects pages, writes copy, uploads/crops photos, edits layout, exports/prints

          ↓ GAP ↓

Human done-for-you magazine
$72–125+ observed
finished result
BUT manual handoff, multi-day turnaround, designer communication, higher price
```

Birthday Magazine Studio should occupy:

> **Done-for-you depth with template-like speed.**

Primary promise:

> Upload photos + answer a few good questions → receive a polished story-led birthday magazine without Canva, layout work or designer back-and-forth.

AI is the production mechanism, not the customer-facing headline.

## 2. Strongest evidence from direct competitors

### DIY templates
Current Etsy examples commonly offer 35–100+ editable pages and sell the freedom to choose/edit everything.

Recurring universal-ish modules:
- cover;
- editor's note;
- recipient profile / "who is...";
- memories;
- year in review / timeline;
- favorites;
- playlist;
- reasons we love you;
- letter;
- travel / photo collage.

Demographic/lifestyle filler varies heavily:
- bag;
- fragrance;
- makeup;
- astrology;
- accessories;
- dream car;
- fashion;
- cocktail;
- vision board.

Implication:
> A large template library is useful for DIY choice, but it is not evidence that a finished automated magazine should be 40–100 pages.

Representative current sources:
- https://www.etsy.com/listing/4296954135/
- https://www.etsy.com/listing/4300011708/
- https://www.etsy.com/listing/4345458247/
- https://www.etsy.com/listing/4449721886/
- https://www.etsy.com/listing/4524604786/

One especially useful verified buyer review says the template helped, but the buyer still had substantial work uploading the right pictures, writing articles, and deciding which pages/sections fit the person:
- https://www.etsy.com/listing/4317493080/

Another verified review reported a Canva Pro/licensing surprise at print time:
- https://www.etsy.com/listing/4349715879/

### Human done-for-you
Observed current examples:

- 12-page printed custom magazine: US$72
  - https://lauprint.com/products/custom-best-friend-magazine-copy

- 24-page digital PDF: US$125
  - 3 revisions
  - 3–7 business days
  - user still sends photos, text, anecdotes, fun facts/interviews, style preferences and notes
  - https://www.etsy.com/listing/4356190860/

Implication:
> There is willingness to pay a large premium to remove design work. The remaining opportunity is to remove not only layout work, but also most copy-writing and back-and-forth.

## 3. Adjacent product evidence

### Mixbook Story Mode
Current flow:
- answer a few questions;
- upload photos;
- AI curates photos;
- arranges a beginning/middle/end;
- writes optional captions/story text;
- produces multiple finished book versions;
- user edits only if desired.

Mixbook explicitly says it may omit uploaded photos if similar/weaker, and lets users describe important moments in the prompt. It does not yet support a dedicated "must include" flag.

Sources:
- https://www.mixbook.com/try-story-mode
- https://help.mixbook.com/hc/en-us/articles/61128847260057-Story-Mode-How-Photos-Are-Arranged
- https://help.mixbook.com/hc/en-us/articles/61128847328025-Story-Mode-Text-Captions

Recent Reddit experience:
- one user with ~400 travel photos said Story Mode selected/arranged a coherent book in about 15 minutes rather than turning into a weekend project;
- they still changed a few photos/layouts afterwards.

Implication:
> "Strong automatic first draft + small user corrections" is a much better model than either blank canvas or zero-control automation.

### Shutterfly Make My Book
Shutterfly explicitly promises:
- upload/select whole albums;
- no need to organize;
- designers select strong photos and arrange them;
- draft within about 24 hours;
- user reviews and can change before ordering.

Source:
- https://www.shutterfly.com/photo-books/make-my-book/

Implication:
> Photo curation itself is part of the paid value. Do not require the buyer to perfectly choose the final 10 photos.

### Storyworth Celebrations
Birthday prompts emphasize:
- a memorable adventure;
- something you admire;
- a funny/specific story;
- meaningful contributions can be only a few sentences + photo(s).

Sources:
- https://welcome.storyworth.com/celebration-inspiration
- https://welcome.storyworth.com/blog/how-to-contribute-to-a-celebration-book

Implication:
> Good prompts should unlock specific memories; the buyer should not be asked to write polished magazine copy.

### Tribute
Tribute validates:
- collect raw emotional material;
- compile into one finished artifact;
- preview before finalizing;
- concierge tier charges a premium to remove editing work.

Source:
- https://www.tribute.co/pricing/

Implication:
> Proof/review is a trust mechanism. It should be built into the paid flow.

## 4. Decision 1 — 12 pages or 16 pages?

### Why this decision matters
It affects:
- perceived value;
- number of distinct content beats;
- amount of user input required;
- AI hallucination/repetition risk;
- template engineering;
- PDF QA;
- revision cost;
- later physical-print compatibility.

### Evidence
- Lauprint sells a real 12-page personalized printed magazine for US$72.
- Pixfold explicitly offers 8/12/16/20-page magazines; for one magazine category it labels 12 pages "Standard / Most Popular".
- A US$125 human done-for-you Etsy product uses 24 pages, but that service also requires much more buyer-provided text and 3 revisions.
- DIY 40–100-page listings are libraries of optional pages, not fixed finished-book requirements.

Sources:
- https://lauprint.com/products/custom-best-friend-magazine-copy
- https://pixfold.in/products/custom-birthday-magazine-unique-personalized-birthday-gift
- https://www.etsy.com/listing/4356190860/

### Reviewer recommendation
**12 total PDF pages, including front and back cover.**

### Why
- enough for 4–5 meaningful editorial beats plus photo-led spreads;
- divisible by 4 if physical printing is added later;
- keeps the first AI/PDF engine bounded;
- prevents filler;
- fits the current US$39.99 test price better than trying to imitate a US$125 human service.

### Cost of choosing 16 now
- ~33% larger layout/content/QA surface;
- more input required;
- higher chance of repetitive AI prose;
- slower route to Solution Proof.

### When to expand
Only after real buyers say the 12-page result feels too thin or repeatedly ask for more pages.

**Owner decision requested: ACCEPT 12 / CHOOSE 16.**

## 5. Decision 2 — How many photos should the buyer upload?

### Why this decision matters
Too few photos:
- weak curation;
- repeated images;
- low visual variety.

Too many required:
- onboarding friction;
- buyer feels they must curate first.

### Evidence
Pixfold's current recommendation:
- 8 pages: 10–15 images
- 12 pages: 20–25
- 16 pages: 30–35
- 20 pages: 40–50

Mixbook and Shutterfly both position automatic curation as a value: upload more than will be used, let the system select.

Sources:
- https://pixfold.in/products/custom-birthday-magazine-unique-personalized-birthday-gift
- https://help.mixbook.com/hc/en-us/articles/61128847260057-Story-Mode-How-Photos-Are-Arranged
- https://www.shutterfly.com/photo-books/make-my-book/

### Reviewer recommendation
```text
Upload: 12–25 source photos
Must-use: buyer may mark up to 3
System ultimately uses: ~10–14 unique photos
```

### Why
- enough redundancy for curation;
- significantly less work than asking buyer to select the exact final set;
- max 25 keeps upload/storage/vision cost bounded;
- 3 must-use selections preserve buyer control without becoming a design editor.

### Cost of requiring exactly 8–12
Buyer has to do more of the curation work and system has less ability to avoid blurry/repetitive/poorly framed images.

**Owner decision requested: ACCEPT 12–25 / MODIFY RANGE.**

## 6. Decision 3 — Questionnaire structure

### Why this decision matters
Question quality directly determines:
- emotional specificity;
- hallucination risk;
- copy quality;
- completion rate.

### Evidence
Storyworth repeatedly uses concrete memory prompts rather than broad "write their story" requests. Mixbook's model also begins with a few conversational questions.

### Reviewer recommendation

#### Required factual fields
- recipient name;
- birthday / age;
- buyer relationship to recipient;
- pronouns optional;
- desired tone: heartfelt / playful / balanced.

#### Five required narrative prompts
1. **What makes them unmistakably them?**
   - traits, quirks, habits, personality.

2. **Tell us one memory you always come back to.**
   - encourage a specific scene, trip, day or moment.

3. **What do you admire or appreciate most about them — and why?**

4. **What are the little things only people close to them know?**
   - inside jokes, phrases, rituals, funny habits.

5. **What do you want them to hear on this birthday?**
   - message, wish, next chapter.

#### One lightweight current-era prompt
6. **What are they into right now?**
   - hobbies, music, food, places, current obsession/era.

#### Optional quick facts
- favorite song;
- favorite food/drink;
- favorite place;
- current obsession;
- must-include phrase/quote.

### Why
These six inputs map directly to identity, memory, admiration, lore, present-day personality and emotional close.

Avoid:
- "write an article";
- asking user to choose 12 page types;
- mandatory astrology/fashion questions;
- long-form essays.

### Input guidance
Prompt for **1–4 sentences**, not essays.

**Owner decision requested: ACCEPT / MODIFY PROMPTS.**

## 7. Decision 4 — Fixed pages vs dynamic modules

### Why this decision matters
All-fixed pages create irrelevant filler.
All-dynamic pages create unpredictable layout and QA.

### Evidence
Cross-demographic Etsy listings show a stable emotional core, but lifestyle modules differ heavily between friend/woman/man/mom products.

### Reviewer recommendation
Use:

> **fixed emotional spine + 2 dynamic module slots**

Provisional 12-page map:

1. Front Cover — cover-star moment
2. Opening Note — short editorial introduction
3. Who They Are — personality/profile
4–5. Feature Memory — one strong shared story spread
6. Dynamic Module A
7. Why They Matter — admiration / reasons / quote-led feature
8–9. Photo Story / Current Era spread
10. Dynamic Module B
11. Birthday Letter / Next Chapter
12. Back Cover — short closing line / visual

Dynamic-module pool:
- The Lore / inside jokes
- Favorites
- Playlist
- Travel
- Then & Now
- Year in Review
- Current Obsessions
- Mini Timeline

Selection is based only on supplied data.

### Deliberate exclusions
- no table of contents for a 12-page MVP;
- no fixed fragrance/bag/makeup/star-sign/dream-car page;
- no generic module if data is weak.

### Why
It preserves a predictable rendering system while making the book feel like that person rather than a template.

**Owner decision requested: ACCEPT / MODIFY STRUCTURE.**

## 8. Decision 5 — Proof and revisions

### Why this decision matters
Fully automatic/no-review is risky for:
- factual mistakes;
- tone mismatch;
- wrong photo selection;
- gift trust.

Unlimited editing recreates Canva complexity and destroys unit economics.

### Evidence
- Shutterfly: draft → user review/change → order.
- Mixbook: finished book → edit if desired.
- US$125 done-for-you Etsy competitor includes 3 revisions.

### Reviewer recommendation
**One bounded revision submission included in US$39.99.**

Proof flow:
```text
generated proof
→ private account gallery
→ user may annotate requested changes
→ submit ONE revision batch
→ revised proof
→ approve
→ final PDF
```

Included revision may contain multiple small requests in one submission:
- factual corrections;
- tone wording;
- swap up to 3 photos;
- remove/replace a weak quote or short section.

Not included:
- new recipient;
- complete new visual concept;
- change from 12 to 16/24 pages;
- full new intake;
- unlimited regeneration.

### Why
This is a strong risk-reversal mechanism while keeping model/render cost bounded.

**Owner decision requested: ACCEPT ONE BOUNDED REVISION / CHOOSE OTHER.**

## 9. Decision 6 — Account UX

The Owner already fixed:
> authenticated customer account required.

### Evidence / implementation options
WooCommerce supports creating an account during checkout and using email as the login identifier. WooCommerce also documents passwordless login via magic link / OTP in its enhanced account tooling.

Sources:
- https://woocommerce.com/document/configuring-woocommerce-settings/accounts-and-privacy/
- https://woocommerce.com/document/customer-accounts/setting-up-passwordless-login/

### Reviewer recommendation
Product requirement:

> **Do not force a separate pre-checkout registration page.**

Desired UX:
```text
checkout email
→ account/workspace created or attached
→ order appears in private Magazine Workspace
```

Authentication preference:
1. passwordless/magic link if the later implementation Gate can support it without unacceptable paid/vendor dependency;
2. otherwise WooCommerce's normal email + password-setup flow.

This is a product requirement, not a G2A2 dependency on a specific login plugin.

**No new Owner decision required unless you want mandatory passwordless.**

## 10. Decision 7 — Data retention

### Why this decision matters
Customer photos are private/high-trust inputs.
Long retention increases privacy and breach surface.
Very short retention harms revision/recovery.

### Evidence
- Toodaloo, a personalized photo-book service, states it deletes uploaded photos and related production files within 30 days after shipping.
- Shutterfly keeps photos far longer because persistent photo storage is itself part of its product; deletion is account-level and can take up to 45 days after verification.
- Our product is a magazine-generation service, not a photo-storage service.

Sources:
- https://www.toodaloo.studio/help
- https://support.shutterfly.com/s/article/permanently-deleting-a-shutterfly-account
- https://support.shutterfly.com/s/article/shutterflys-unlimited-photo-storage-for-active-customers

### Reviewer recommendation
MVP privacy baseline:

```text
source photos + working render assets:
auto-delete 30 days after final approval/delivery

final PDF:
available in account for 90 days

buyer:
may request earlier project deletion
```

Keep only minimal non-sensitive order/account records after project assets expire, subject to later legal/accounting requirements.

### Why
- follows a privacy-first precedent for personalized photo production;
- gives enough revision/support recovery time;
- avoids accidentally turning the product into permanent photo storage.

The 90-day final-PDF window is a Reviewer tradeoff recommendation, not an externally validated magic number.

**Owner decision requested: ACCEPT 30d source / 90d final PDF / MODIFY.**

## 11. Decision 8 — Visual style choice

### Evidence
Direct competitors frequently sell dozens of visual page variants or 4 separate design directions. User reviews value good-looking starting points but also reveal the burden of large customization surfaces.

### Reviewer recommendation
For MVP:
- one shared deterministic layout system;
- max **3 visual style presets**;
- styles change palette/type/graphic treatment, not page architecture.

This preserves the current free-preview style choice without tripling the generation engine.

Suggested working labels:
- Bold Editorial
- Soft / Warm
- Retro / Playful

Exact naming/art direction can be refined later.

**Owner decision requested only if you want one style or more than three. Default recommendation: 3 presets.**

## 12. Acquisition Growth Radar interpretation

### Validation Spine
- Problem Evidence: strong enough to proceed.
- Attention/Interest: category currently has visible demand/trend signals.
- Solution Proof: still not proven for our actual generated output.
- Transaction: not proven for this project.

### Current bottleneck
**Solution Proof / Activation.**

The next meaningful proof is not another landing page or more competitor research.

It is:
> Can our fixed contract turn synthetic but realistic photos + answers into a 12-page result that feels specific, coherent and gift-worthy?

### Free Activation
```text
name + age + style + one photo
→ "this already looks like their magazine"
```

### Paid Activation hypothesis
```text
loose photo set + a few specific memories
→ "this could only be about them"
```

## 13. Reviewer recommended MVP package

Pending Owner approval:

```text
US$39.99
12 total pages
US Letter PDF
authenticated account workspace
12–25 uploaded photos
up to 3 must-use photos
system selects ~10–14
6 short narrative prompts + optional quick facts
fixed emotional spine + 2 dynamic modules
no AI-generated imagery
one bounded revision batch
private proof before final PDF
source photos/working assets delete after 30 days
final PDF retained 90 days
3 style presets sharing one layout system
```

## 14. Owner decisions needed

The following materially affect G2B and should be explicitly approved before G2A2 PASS:

1. **12 pages vs 16 pages**
   - Recommendation: 12.

2. **12–25 source photos, system uses ~10–14, max 3 must-use**
   - Recommendation: accept.

3. **Six-prompt structure**
   - Recommendation: accept.

4. **Fixed spine + 2 dynamic modules**
   - Recommendation: accept.

5. **One bounded revision batch**
   - Recommendation: accept.

6. **30-day source retention + 90-day final PDF**
   - Recommendation: accept for MVP.

7. **3 visual presets on one shared layout system**
   - Recommendation: accept.

No additional broad competitor research is recommended before these decisions. Remaining uncertainty should be resolved by the next synthetic end-to-end Solution Proof rather than more desk research.
