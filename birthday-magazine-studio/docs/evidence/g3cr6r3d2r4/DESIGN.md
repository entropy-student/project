---
name: Birthday Magazine — G3CR6R3D2R4 Motion Amendment
description: Homepage presentation motion over the accepted R2 static visual contract.
---

# Design System: Birthday Magazine Home — R4 Motion Amendment

## Overview

**Motion thesis:** the magazine stays readable while its photographic surroundings breathe, editorial images travel through the viewport, sample cards settle into a flat inspection state, and the desktop closing reveals itself within a bounded sticky composition. This is original homepage presentation code, informed by the accepted Focusly observation; it introduces no template runtime or new imagery.

This scoped amendment records current `home.css` and `home-motion.js` under [G3CR6R3D2R4_MOTION_POLISH](../../G3CR6R3D2R4_MOTION_POLISH.md). It supersedes the motion description in [R2 DESIGN.md](../g3cr6r3d2r2/DESIGN.md), preserving its static visual contract and all five adopted assets. Starting head supplied for this task: `69b062be391a5b975aeef844378aa53f46fa6e47`. This documentation pass ran no browser, tests or Git operations and does not claim runtime PASS, formal acceptance or fresh upload regression. The Gate retains Reviewer and Owner live-browser verification.

## Layout

Eight editable Home **858** Gutenberg Groups, six anchors, non-image content, native destinations and R2 imagery remain the baseline. The 3:2 full-bleed sample layout remains (1280×853px) desktop and (343×229px) at the 375px target before transforms. The mobile header remains (343px) wide at that target, with (22px) brand type and (44×44px) minimum menu trigger.

The final inherited mobile Offer crop uses a (320px)-high image at `object-position: 24% 35%`, with warm `#d4c9b7` backing, inside the (650px) minimum-height bottom-aligned panel. Preview's outer panel remains (560px) minimum height. R4 does not alter those static choices.

Only the enhanced desktop closing changes scroll geometry. At widths above (700px), JavaScript moves its existing children into a temporary `bms-closing-sticky` wrapper. The outer closing is (190svh), at least (1600px), with zero padding; the inner composition is sticky at `top: 0`, (100svh), at least (700px), with (80px 32px) padding. Explicit `width: 100%`, `max-width: none` and `margin: 0` keep the wrapper at the full parent width, including the 1440px target, without Gutenberg container narrowing. The wrapper is removed when reduced motion or mobile mode activates. It is a runtime presentation wrapper, with no Gutenberg or database write.

## Components

**Hero focus.** Existing entrance timings remain: sharp frame (1.8s), hero message (1.2s), easing `cubic-bezier(.16,1,.3,1)`. The recurring photo treatment is a (14s) `ease-in-out` cycle. Desktop backdrop blur moves (12→22→12px), scale (1.04→1.13→1.04), and horizontal displacement (−8→8→−8px). The sharp image moves from scale (1) to (1.09) with (−12px) pan at midpoint, then returns. The recurring cycle affects photo layers; headline and CTA remain outside it. Hero IntersectionObserver/visibility handling pauses the cycle offscreen or while the document is hidden.

**Editorial split choreography.** Layout progress is clamped to (0…1), derived from `offsetTop`/`offsetHeight` and viewport scroll, avoiding transformed-card feedback. Desktop image scale ranges (1…1.2), with vertical travel (±50px). Copy displacement ranges (0…36px), opacity (.775…1). Mobile image scale ranges (1…1.045), travel (±14px); copy displacement is (0…12px), retaining the same opacity floor. These values are applied to display imagery/copy, not Preview controls. Dark-panel and sample headings retain a once-only (.9s) reveal at IntersectionObserver threshold (.12), from (18px) displacement, (2px) blur and (.75) opacity.

**Photographic panels.** Desktop images reserve (220px) of extra height with `height: calc(100% + 220px)` and `top: -110px`, then travel vertically (−110…110px) inside their clipped background containers. This replaces the earlier (1.3) scale and preserves the horizontal focal crop. Foreground dark panels remain stable. Mobile resets image top to (0) and height to (100%), with no transform or parallax; Offer retains its (320px) image height. These rules preserve the static mobile crop and avoid fixed-background dependence.

**Samples.** Desktop cards combine (1600px) perspective, tilt (+24°…−24°), scale (.78…1), vertical travel (+80…−80px) and depth (−140…0px). At middle progress (.5), each card is flat, scale (1), with zero translation/depth. Mobile bounds are tilt (±4°), scale (.955…1), vertical travel (±14px) and zero depth. The existing three full-bleed images and labels remain. This describes intended enter/middle/exit states from source, not verified projected bounds or perceptual acceptance.

**Closing.** Desktop progress spans the outer scroll travel. The heading's white/dim gradient advances (10→100%), with vertical settling (32→0px); left decorative image travel is (+110→−110px), right (−100→100px). The CTA is outside the heading transform and gradient. Mobile uses a complete (100%) text reveal with zero closing-image/text travel and the existing compact ordinary-flow closing, with no sticky wrapper.

**Links.** Existing label roll remains (.5s), with a decorative `aria-hidden` duplicate and stable accessible name/target. CTA dot feedback remains (.35s), scaling to (1.7). Keyboard focus retains the signal outline. Scroll/resize listeners are passive; updates are batched into one `requestAnimationFrame`, reading geometry before CSS-variable writes. There is no continuous JavaScript idle loop or scroll interception.

**Reduced motion and static fallback.** Reduced motion removes the motion class, temporary sticky wrapper and controller-owned variables. CSS disables recurring/entrance/reveal animations, image/card/copy transforms and label transitions, restores full copy opacity and white closing text. No-JS or an unavailable controller leaves the motion class/wrapper absent, exposing the R2 static page and native links. Missing IntersectionObserver leaves reveal content visible; hero activity still respects document visibility and reduced motion. These are source-defined fallbacks, not runtime results from this pass.

## Do's and Don'ts

- Do preserve R2 palette, OFL font provenance, static assets, editable groups, anchors, factual copy and destinations.
- Do apply this amendment only to homepage display containers and decorative link labels.
- Don't modify Preview shortcode internals, `preview.js`, `magazine-preview.css`, local-photo selection/replacement/removal or object-URL processing.
- Don't alter Product **1113 / virtual USD39.99**, Woo/account/payment/private-workspace ownership, entitlement/provider semantics, P1–P12 or core Aha.
- Don't introduce runtime model calls, photo uploads, real-money actions, order creation, deployment or shared-infrastructure changes through motion.
- Don't treat source amplitudes or fallback rules as automated evidence or Owner confirmation of perceptible motion.
