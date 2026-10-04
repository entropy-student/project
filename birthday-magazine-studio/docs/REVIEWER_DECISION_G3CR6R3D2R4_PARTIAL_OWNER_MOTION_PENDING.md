# Reviewer Decision — G3CR6R3D2R4 Automated Review PASS / Owner Motion Pending

> Date: 2026-10-04
> Executor candidate: `d882e247a75930a0d019a0d355278c5007a73a6b`
> Gate: `G3CR6R3D2R4_MOTION_POLISH`

## Decision

~~~text
EXECUTOR_RESULT=PASS_CANDIDATE_G3CR6R3D2R4_MOTION_POLISH
REVIEWER_AUTOMATED_TECHNICAL_REVIEW=PASS
REVIEWER_SOURCE_SCOPE=PASS
REVIEWER_MULTI_STATE_MOTION_EVIDENCE=PASS
STATIC_R2_VISUAL_BASELINE=PRESERVED
PREVIEW_WOO_ACCOUNT_PAYMENT_FREEZE=PASS
REDUCED_MOTION=PASS
NO_JS=PASS
MISSING_CONTROLLER=PASS
ROLLBACK_TO_ACCEPTED_D2R2=PASS
OWNER_LIVE_MOTION_PERCEPTIBILITY=PENDING
FORMAL_GATE_DECISION=PARTIAL
PR64_MERGE=NO
PRODUCTION_DEPLOYMENT=NO
~~~

## Source scope

Only two application behavior files changed:
- `poc/g3c/preview-plugin/home-motion.js`
- `poc/g3c/preview-plugin/home.css`

No persistent Home858 mutation occurred. Static R2 assets and Home content remain frozen. Preview PHP/JS/CSS, Woo/account/payment/private-workspace sources remain unchanged.

## Reviewer-inspected motion evidence

### Hero

PASS for automated multi-state behavior.

- recurring focus cycle period: 14 seconds;
- focus loop pauses offscreen and while tab hidden;
- timed states show materially different scale/pan/blur values;
- headline and CTA remain outside the focus loop and readable.

### Editorial split

PASS for automated scroll choreography.

Major split imagery now changes scale/Y position through enter/mid/exit states, with copy settling tied to scroll progress. Existing static composition remains recognizable at the readable middle state.

### Photographic panels

PASS for automated parallax.

Desktop measured panel travel across sampled states is approximately 132px. The foreground dark panel stays stable while the underlying photo travels. Mobile remains intentionally lighter/static where required.

### Samples

PASS for automated multi-state progression.

Each card has enter/mid/exit states. Measured desktop tilt is approximately:
- enter: +14.39 degrees;
- middle: 0 degrees;
- exit: -14.39 degrees.

Projected width changes from approximately 1117px to 1280px and back, with additional Y/depth treatment. No horizontal overflow was found.

### Closing

PASS for automated sticky reveal.

Desktop sampled states:
- early: reveal 14.5%, sticky top 0;
- middle: reveal 55%, sticky top 0;
- late: reveal 95.5%, sticky top 0.

CTA remains visible throughout. Mobile has no long sticky trap.

## Visual screenshot inspection

Reviewer directly inspected representative committed JPG evidence for:
- Hero timed states;
- editorial/photo-section states;
- Samples enter/mid/exit;
- Closing early/mid/late.

The evidence is consistent with the numeric measurements and the intended Focusly-inspired motion direction. Static visual quality is not materially degraded in the sampled states.

## Fallbacks and protected behavior

Automated evidence passes:
- desktop 1440;
- mobile 375;
- no horizontal overflow;
- reduced-motion static state;
- live preference change;
- no-JS static state;
- missing-controller static state;
- native mobile menu;
- hover and keyboard focus;
- Product/Cart/Checkout/Account read-only routes.

Business mutation counters remain zero:
- Add to Cart: 0
- checkout submit: 0
- new orders: 0
- PayPal actions: 0
- product/model calls: 0
- image generation: 0
- production deployment: 0
- shared infrastructure: 0
- P1-P12/core-Aha: 0
- PR merge: 0

Orders remain 1 -> 1.

## Rollback

Scoped rollback proof is PASS and restores only the accepted D2R2 `home.css` and `home-motion.js` state. Home/menu/assets/DB do not require rollback.

## Remaining mandatory evidence

Formal D2R4 PASS is intentionally withheld until the Owner checks the retained local runtime in the actual browser and confirms that motion is **visibly perceptible without DevTools**.

Owner must verify:
1. Hero visibly changes while waiting several seconds.
2. Split/photo sections visibly move during normal scrolling.
3. Samples visibly tilt/scale/depth-shift during ordinary scrolling.
4. Desktop Closing visibly performs a sticky reveal.

Until then:

~~~text
G3CR6R3D2R4=PARTIAL
OWNER_HOMEPAGE_VISUAL_FREEZE=BLOCKED_ON_OWNER_LIVE_MOTION_CONFIRMATION
~~~
