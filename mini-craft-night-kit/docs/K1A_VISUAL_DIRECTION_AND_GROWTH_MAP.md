# Mini Craft Night Kit — K1A Visual Direction & Growth-to-UI Map

Date: 2026-09-18
Status: REVIEWER PROPOSAL — OWNER REVIEW REQUIRED

## 1. Core Design Decision

Mini Craft 首页不按“手工材料商品页”设计，而按“已经替情侣策划好的在家约会”设计。

Primary hypothesis:

`Sell the night, not the supplies.`

First message hypothesis:

`Your next date night is already planned.`

Homepage job:

```text
让我意识到今晚缺一个计划
→ 让我马上理解这是什么体验
→ 让我看到两个人会怎么度过这晚
→ 让我相信它不麻烦、值得尝试
→ 让我知道我买到的是什么
→ 消除信任 / 配送 / 售后疑虑
→ Shop the Kit
```

## 2. Visual System

Reuse the accepted Mini Craft visual system from the archived route instead of inventing a new brand.

### Palette

- Ink: `#2F211D`
- Burgundy: `#6C2C22`
- Olive: `#53664B`
- Olive Dark: `#46583F`
- Cream: `#FBF6EE`
- Paper: `#FFFDF9`
- Beige: `#F3E8DC`
- Line: `#EADFD4`
- Muted: `#766861`
- Footer Surface: `#F5ECDF`

### Typography

- Display / emotional headline: `DM Serif Display`
- Body / UI / navigation: `Plus Jakarta Sans`

### Feel

`warm / tactile / cozy / editorial / giftable / human`

Avoid:

`SaaS / gadget / sterile ecommerce / tech specs / aggressive discount store`

### Photography direction

Prioritize:

- hands making;
- two people in the same activity;
- imperfect in-process moments;
- warm table light;
- finished keepsake in a real home;
- box/product only when it helps answer purchase uncertainty.

Do not make the page a grid of packshots.

## 3. Homepage Section Order

### Screen 1 — Hero

**Growth job:** answer in 3 seconds: “Why would I want this tonight?”

Layout:

```text
Desktop: 40% copy / 60% lifestyle image
Mobile: copy first / image second
```

Copy:

`Your next date night is already planned.`

Safe supporting copy:

`A screen-free craft night for two, built around making something together and having a night worth remembering.`

Primary CTA:

`Shop the Kit`

Secondary text link:

`See how the night works`

Image role:

show two people actually making something together, not a product-only hero.

Visual:

- Paper/Cream background;
- dark ink serif headline;
- olive primary CTA;
- one subtle burgundy accent;
- no badges, rating stars, countdowns, or fake scarcity.

### Screen 2 — The Experience

Headline:

`The kind of night you don't have to plan.`

**Growth job:** turn an abstract box into a concrete evening.

Use one wide lifestyle sequence or three visual beats:

```text
Open
→ Make
→ Keep
```

Support:

```text
Open the box
Make together
Keep the memory
```

Visual direction:
- three editorial crops rather than icon-heavy cards;
- captions short and secondary;
- emphasis on action and interaction.

### Screen 3 — Why this is different

Headline:

`Less planning. More doing something together.`

**Growth job:** defend against “I could just buy craft supplies myself.”

Three value ideas:

```text
Plan removed
Shared activity
Something remains after the night
```

Do not position materials as the primary value.

Recommended visual:

asymmetric editorial cards using beige / cream surfaces with one process photo.

### Screen 4 — Product / Offer

Headline:

`One kit. One night. Something to keep.`

**Growth job:** convert interest into a concrete product decision.

Reuse the canonical WooCommerce product surface rather than designing a fake product card.

Show:
- product image;
- product name;
- price once Owner/product truth is confirmed;
- Add to Cart / Shop the Kit;
- short verified product facts only.

Do not add invented:
- exact duration;
- difficulty;
- shipping promise;
- “everything included”;
- ratings/review count.

### Screen 5 — What's Inside

Headline:

`What's inside the night?`

**Growth job:** remove purchase uncertainty.

Layout:

```text
left: open-box / laid-out contents image
right: short grouped contents list
```

This section is structurally approved but factual copy remains blocked until actual kit contents are confirmed.

Executor may build the editable layout, but must not invent the list.

### Screen 6 — Beginner Objection

Headline direction:

`This isn't an art class.`

**Growth job:** address “we're not crafty / we'll be bad at it.”

Visual:

one playful imperfect in-process photo rather than a polished finished-product hero.

Copy must avoid unverified success-rate or difficulty claims.

### Screen 7 — Proof

**Growth job:** answer “Will real couples actually enjoy this?”

Current status:

`STRUCTURE READY / PROOF BLOCKED`

Do not publish imported demo reviews or fabricated UGC.

Until real proof exists:
- keep the section hidden; or
- use a real process/demo section instead.

Once real orders exist, preferred proof hierarchy:

```text
real making footage
> contextual UGC
> real finished work
> real review text
> generic star badge
```

### Screen 8 — Trust / Before You Order

Headline:

`Good to know before your craft night.`

**Growth job:** remove non-product purchase friction.

Approved trust topics once facts exist:
- shipping;
- returns/refunds;
- missing/damaged item support;
- secure payment.

Do not invent policy values. If policies are still unknown, keep this section minimal and factual.

### Screen 9 — Closing CTA

Headline:

`Make tonight feel like a date again.`

CTA:

`Shop the Kit`

**Growth job:** return to the emotional reason for purchase after factual objections are answered.

Visual:

wide cozy editorial photo + simple olive CTA.

## 4. Header / Footer

### Header

KEEP Kadence header structure.

ADAPT:
- brand → Mini Craft;
- nav simplified to only real destinations;
- right CTA → `Shop the Kit`.

Do not add account/search/wishlist clutter unless current WooCommerce flow truly needs it.

### Footer

KEEP mature Kadence footer structure.

ADAPT toward:
- Shop;
- FAQ;
- Shipping & Returns when policy exists;
- Contact;
- privacy/terms.

Do not add fake social links or policy pages that do not exist.

## 5. Kadence KEEP / ADAPT / DROP Mapping

### KEEP
- responsive container system;
- Gutenberg/Kadence native blocks;
- WooCommerce product/cart/checkout;
- existing spacing rhythm that works;
- mature header/footer mechanics.

### ADAPT
- Hero;
- brand tokens;
- typography;
- imagery;
- feature sections;
- CTA labels;
- product framing;
- section headings.

### DROP
- smart-speaker language;
- technical specifications;
- gadget benefit blocks;
- imported demo testimonials/reviews;
- irrelevant badges;
- duplicate feature sections;
- any content that makes the visitor think the store sells electronics.

## 6. Responsive Intent

Known inherited defect:

`375px Home clipping`

K1B must fix it.

Mobile rules:
- no forced desktop line breaks in Hero;
- headline width <= viewport content width;
- minimum side padding 20px target;
- CTA remains fully visible;
- image follows copy;
- no horizontal overflow;
- avoid fixed widths for cards / headings.

Required widths:

`320 / 375 / 390 / 430`

Regression:

`768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560`

## 7. Conversion Logic by Screen

```text
Hero
Problem recognition + promise
↓
Experience
Make the night concrete
↓
Differentiation
Why this is more than buying supplies
↓
Product
Turn desire into a purchasable object
↓
What's Inside
Reduce uncertainty
↓
Beginner objection
Reduce skill anxiety
↓
Proof
Reduce disbelief
↓
Trust
Reduce transaction risk
↓
Closing CTA
Return to the emotional outcome
```

## 8. What K1B is allowed to implement immediately

Can implement now:
- brand colors/fonts;
- Mini Craft name;
- Hero composition/copy;
- experience section;
- differentiation section;
- WooCommerce product framing;
- editable What's Inside shell;
- beginner objection section;
- final CTA;
- removal of irrelevant demo content;
- 375px fix.

Must remain held until factual input exists:
- exact contents list;
- exact price if not finalized;
- duration;
- difficulty claim;
- shipping times/costs;
- refund window;
- guarantee;
- review count;
- star rating;
- testimonials.

## 9. Owner Review Question

Owner approval should answer only:

`OWNER_K1A_VISUAL_DIRECTION=PASS`

or identify a visual/growth direction to return.

After PASS, Codex receives K1B implementation instructions.