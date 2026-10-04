# G3CR6R3D2R2 — Internal finish review

Date: 2026-10-04

**disposition: ship**

This is the bounded internal visual finish review of the local R2 candidate. It is not an official Reviewer decision, governance PASS, Owner acceptance, merge or deployment authorization. The official visual decision remains pending.

## Review scope and evidence

Reviewed the R2 visual-polish Gate, incumbent D2 `DESIGN.md`, generated-asset provenance, existing homepage CSS, supplied round1 desktop/mobile captures, and the refreshed round2 mobile Preview/Offer captures plus `round2/browser.json`. No independent browser session, additional screenshot capture, reference crawl or context.mjs run was performed. Inspection was limited to the two supplied capture rounds.

Primary final repair evidence:

- `round2/screenshots/mobile-normal-preview.png`
- `round2/screenshots/mobile-normal-offer.png`
- `round2/browser.json`

## Visual findings

- **Samples: resolved.** The three new photographic magazine scenes occupy most of their large cards. The terracotta Eli cover, cobalt/yellow open spread, and Lena kitchen gift scene have distinct compositions, materials and focal subjects. Desktop captures show dominant editorial scale; mobile captures retain near-full available width and readable card labels. The section explicitly labels the samples fictional and illustrative.
- **Repeated imagery: resolved.** Desktop Preview uses a photo-memory scene and Offer uses an outdoor birthday embrace, materially distinct from the retained magazine Hero and from each other. Provenance records five original static generated assets, five calls, zero rejected calls, fictional noncustomer people, and no runtime Preview dependency.
- **Mobile photo composition: resolved in final captures.** Round1 centered text cards obscured the new subjects' faces. The final Preview capture exposes both faces above the bottom-aligned card. The final Offer capture shows the embrace and both faces above the dark card; its shorter static photographic field transitions into a warm neutral surface. Copy, US$39.99 price and native purchase CTA remain readable.
- **Mobile header: resolved.** The product name reads on one line with comfortable separation from the native menu trigger. The rounded compact menu retains readable existing destinations. CSS records a 44px trigger target; captures establish appearance rather than full keyboard behavior.
- **Mobile rhythm: improved.** Tighter wrapper spacing and filled sample cards strengthen the sequence without removing Preview, product facts, Offer, FAQ or conversion links. The final mobile panel repair is a deliberate photographic interval rather than blank spacer content.
- **Accepted direction: retained.** Supplied full-page and section captures preserve the photographic focus Hero, editorial split, warm paper, Instrument Serif hierarchy, dark translucent panels and dark closing. No material regression was found within the bounded repair review.

## Craft and recorded functional evidence

The reviewed surfaces retain readable type, sufficient visual separation, strong photographic materials and clearly visible CTAs. The closing text treatment remains the previously authorized scroll reveal. No further in-scope visual blocker remains from this review.

The final browser report records all eight desktop/mobile contexts: normal, reduced-motion, no-JS and motion-controller unavailable. Each records viewport-matched scroll width at 1440 or 375, zero page errors, zero failed resources, zero broken images, eight Groups and all six required anchors exactly once. Normal contexts record three motion states; fallback contexts record motion disabled. These are supplied execution records, not tests run by this reviewer.

## Frozen boundaries and handoff limits

The parent reports protected-source hashes unchanged and `home-motion.js` unchanged. This reviewer made no source/runtime edits, Preview actions, cart/payment/order/model actions or commerce/account/workspace changes. Only this review record was written. The inspected Preview wrapper leaves its existing component visually recognizable; the review does not independently prove photo selection/replacement/removal, source-hash equality, ownership or payment behavior.

Generated-asset originality, fictional-subject status and call count are provenance declarations; this review does not independently establish legal rights or identity. Screenshots cannot establish continuous motion quality, touch-device performance or complete keyboard behavior. Incumbent D2 `DESIGN.md` still contains pre-R2 asset-count, generation-count and card-geometry facts; the scheduled document pass should record the adopted R2 changes. Rollback completeness, production state and PR merge status were not independently audited here.

The internal disposition closes the scored R2 visual findings only. Official Reviewer assessment and Owner visual confirmation remain pending.
