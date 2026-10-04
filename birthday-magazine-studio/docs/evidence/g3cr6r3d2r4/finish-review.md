# G3CR6R3D2R4 — Advisory finish review

Date: 2026-10-04

**Internal disposition: ship**

This disposition covers the bounded R4 motion candidate and the scored final repairs. It is advisory visual QA, not an official Reviewer decision or formal motion PASS. Owner verification of perceptibility in ordinary live-browser scrolling remains required by the R4 Gate.

## Scope and evidence

Read the R4 motion-polish Gate and the current `home.css` / `home-motion.js` presentation implementation. Inspected the supplied round1 timed Hero, editorial split, photographic-panel and three-state Samples/Closing captures, mobile captures and representative reduced-motion/no-JS/controller-unavailable captures. Scored the completed round2 closing and photographic-panel repairs from saved screenshots and `round2/browser.json`.

No browser session, new test, new screenshot, reference crawl, source change or Git action was performed by this reviewer. Only this advisory record was written. Accepted R2 static imagery, product content and functional surfaces were outside redesign scope.

## Strongest concerns and final scoring

1. **Closing decorative images colliding with the headline — resolved.** Round1's constrained sticky wrapper pulled both vignettes into the central lettering. In round2 early/mid/late screenshots, the images occupy separate left/right regions and the headline is clear. Recorded inner width is 1440px and inner y is 0 in all three states. The CTA remains at y594.89–643.28px rather than drifting with the text.
2. **Photographic panel motion narrowing accepted focal crops — resolved.** Round1's scale(1.3) enlarged the photos horizontally and compressed the subjects' composition. Final captures show the broader scenes and clear faces. Recorded Preview and Offer matrices retain scale 1, with sampled vertical travel approximately -65.97px / 0 / +65.97px. The final mobile Offer retains the accepted face visibility, short photographic field and readable dark price/CTA panel.

No further in-scope motion blocker remains from this bounded review. No repair-batch regression was observed in the final surfaces inspected.

## Motion assessment

- **Hero:** three timed states show real focal-image pan/scale and background blur changes while the headline and CTA stay stable. The final report samples background blur near 16.02px / 22px / 16.12px and sharp-image scale near 1.037 / 1.09 / 1.037. Offscreen Hero animation is recorded as paused. The effect is slow rather than flashing; actual user perception remains an Owner live check.
- **Editorial splits:** supplied entry/middle/exit captures show bounded image choreography and copy entry. Final measurements for the included split record scale about 1.128 / 1 / 1.128, image travel about +32px / 0 / -32px, and copy settling from about 23px displacement and .856 opacity to its full readable state. The middle composition preserves the complete spread and accepted hierarchy.
- **Photographic panels:** final saved states demonstrate stronger vertical travel relative to stationary text cards without the initial horizontal crop enlargement. Mobile panel photography remains static, preserving the accepted subject visibility.
- **Samples:** all three owned R2 images remain full-bleed editorial objects. The supplied three-state sequences visibly change projected card shape/scale at entry and exit, with large flat readable middle states. This is a scroll progression rather than reliance on hover. Mobile captures use lighter projections and retain labels and image hierarchy.
- **Closing:** desktop early/middle/late states hold the composition at the viewport top while the recorded text reveal progresses 14.5% / 55% / 95.5% and decorative images drift. The CTA stays visible throughout the sampled states. Mobile retains a compact ordinary-flow closing with readable white text and no sticky trap.
- **Links and focus:** existing label-roll motion and visible focus treatment are retained. No motion dependency was introduced for reaching essential product information or canonical links in the reviewed evidence.

## Fallback and boundary evidence

The completed round2 browser report records eight desktop/mobile contexts: normal, reduced motion, no JavaScript and motion controller unavailable. All record viewport-matched document widths at 1440 or 375, zero page errors, zero failed resources and zero broken images. Eight Groups and all six required anchors remain recorded. Sticky closing is present only in normal desktop mode. Reduced-motion preference switching records restoration to the static layout and subsequent re-enablement.

Representative supplied fallback captures retain readable static imagery, copy, Samples, Closing and CTAs. The controller source limits its selectors to homepage presentation surfaces, labels and a runtime closing wrapper; it contains no Preview upload/state, Woo, account, payment or workspace hook. The parent reports protected-source hashes frozen. This review did not independently recompute those hashes or perform business/Preview interactions.

## Limits and handoff

Discrete PNGs and computed-state records establish change across sampled states; they cannot prove continuous smoothness, wheel/trackpad feel, GPU cost, touch-device performance or the Owner's real-browser perception. Frame-rate instrumentation, full keyboard navigation, rollback execution, source-hash correlation, PR state and infrastructure state were not independently audited here. The parent reports its existing R4 verification script passed; this reviewer did not rerun it.

Formal motion acceptance remains with the official Reviewer and the Owner's live check of Hero, editorial/photo sections, Samples and desktop sticky Closing. No merge, deployment or protected business action follows from this advisory disposition.
