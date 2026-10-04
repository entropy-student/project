# G3CR6R3D2R4 — Homepage Motion Polish

## Gate

~~~text
GATE_ID=G3CR6R3D2R4_MOTION_POLISH
OBJECTIVE=Upgrade the accepted static R2 homepage from technically animated-but-perceptually-static to clearly perceptible, premium Focusly-inspired motion while preserving the accepted visual system and protected product behavior
MAX_ENDPOINT_THIS_ROUND=Local motion-polished homepage + automated motion/fallback regression evidence + Owner live-browser verification checkpoint; no PR merge or production deployment
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Homepage-only presentational motion in home-motion.js/home.css and, only if structurally necessary for motion wrappers, presentation markup within Home858; accepted static imagery/copy/product structure remains frozen
APPLICABLE_CRITICAL_CONSTRAINTS=CURRENT_UPLOAD_PREVIEW_KEEP_AS_IS; PREVIEW_INTERNAL_MUTATION_0; WOO_ACCOUNT_PAYMENT_MUTATION_0; FREE_PREVIEW_MODEL_CALLS_0; FREE_PREVIEW_SERVER_PHOTO_UPLOADS_0; REAL_MONEY_ACTIONS_0; CHECKOUT_SUBMISSION_0; ORDER_CREATION_0; PR64_MERGE_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0
PREFLIGHT=Start from accepted R2 visual candidate 8d03464dbf1678468a289e4676ba975745bcb94d plus current Reviewer management state; create scoped rollback for every touched motion/presentation surface before mutation
REQUIRED_EVIDENCE=Source diff; timed/scroll motion measurements at multiple positions; desktop1440/mobile375 screenshots at distinct motion states; reduced-motion/no-JS/missing-controller fallbacks; Preview/Woo source correlation; rollback proof; Owner live-browser verification instructions
ACCEPTANCE_CRITERIA=See below
ROLLBACK_STATUS_OR_PLAN=Restore only D2R2 accepted motion/presentation state; preserve R2 static assets and Home content
OWNER_ONLY_ACTIONS=Owner performs final live visual motion check after Executor PASS_CANDIDATE
REVIEWER_TO_EXECUTOR_RELAY=SEE_BELOW
EXECUTOR_TO_REVIEWER_RELAY=SEE_BELOW
~~~

Governance: vps-project-governance v0.2.6.

## Accepted baseline — frozen

Preserve:
- current R2 static visual design;
- all five adopted original R2 marketing assets;
- Hero composition and text;
- editorial split/panel/offer/samples/closing content;
- current 8 Gutenberg Groups and 6 required anchors;
- upload/Preview interaction exactly as-is;
- Product1113 / USD39.99 / virtual;
- Woo/account/payment/private-workspace behavior;
- current menu/footer behavior except motion styling;
- no P1-P12 or core-Aha work.

This Gate is **not** permission to redesign the page or swap imagery merely to make motion easier.

## Reference motion contract

Use the already-accepted D1 Focusly observation as the motion reference, without revisiting or copying proprietary source.

Important observed reference behaviors:

1. **Hero focus/entrance**
   - strong sharp-vs-blurred visual relationship;
   - reference has time-varying focus/photo states, not only a one-time entrance;
   - Birthday Magazine CTA/headline must remain readable and usable at all times.

2. **Editorial section entry**
   - image scale/reveal changes are clearly visible during viewport entry;
   - headings/copy enter with controlled vertical/opacity motion.

3. **Photographic panels**
   - reference creates obvious background travel/retention during scrolling;
   - do not rely on fragile mobile fixed-background behavior.

4. **Selected Work / Samples**
   - cards visibly tilt/scale through the viewport;
   - motion must read while normal wheel/trackpad scrolling, not only in computed-style inspection;
   - no horizontal-scroll hijack.

5. **Closing**
   - desktop reference uses a long sticky reveal with moving lettering/mask and drifting decorative images;
   - mobile is intentionally lighter.

## Required repairs

### A. Hero — visible living focus

Current one-shot entrance is insufficient.

Implement an original, non-blocking recurring or scroll-responsive focus treatment that is visibly perceptible in ordinary browsing.

Required:
- sharp central frame remains readable;
- background/focal layer relationship visibly changes over time or scroll;
- effect must not make the headline/CTA disappear;
- no loader that delays interaction;
- no camera/Webflow/runtime dependency;
- no aggressive flashing.

Preferred direction:
- slow focus breathing/crossfade/scale/pan cycle using existing owned layers/assets;
- period long enough to feel premium, not like a banner carousel.

### B. Editorial split images — visible viewport choreography

For major split sections:
- use a clearly visible but bounded image scale/position reveal while entering/leaving viewport;
- pair with heading/copy reveal;
- avoid hiding essential content before JS;
- animation should remain smooth during normal scrolling.

### C. Photographic panels — stronger parallax

Desktop:
- make background travel clearly perceptible relative to the foreground dark panel;
- target motion should be visually obvious without breaking focal crop.

Mobile:
- use smaller translation/scale or static fallback where performance/readability demands it;
- do not use fragile background-attachment tricks.

### D. Samples — visibly dynamic card progression

Current values exist but Owner does not perceive them.

Repair:
- cards must visibly move through at least three perceptually distinct states as the user scrolls;
- combine bounded perspective/scale with vertical or depth translation if needed;
- middle/readable state must be visually flat/clear enough to inspect the sample;
- keep projected bounds inside document width;
- preserve all three R2 full-bleed sample images;
- do not implement horizontal scroll hijacking.

The target is a strong editorial scroll sequence, not a subtle hover effect.

### E. Closing — restore strong desktop sticky reveal

This is the largest missing motion identity versus Focusly.

Desktop:
- extend the closing interaction into a meaningful scroll-travel region;
- keep an inner closing composition sticky while the user scrolls through the reveal;
- progressively reveal/dim the headline and move the decorative images;
- CTA must remain visible/clickable throughout meaningful states;
- do not make the user scroll through excessive dead space.

Mobile:
- no long sticky trap;
- use a short, light reveal or static composition.

### F. Links/buttons

Keep the existing label-roll interaction where appropriate, but motion must also be visible without requiring the user to discover hover states.

## Reduced motion / accessibility

`prefers-reduced-motion: reduce` remains respected.

In reduced-motion mode:
- no recurring Hero focus loop;
- no scroll parallax/perspective/sticky reveal dependency;
- all content, CTA and sample imagery remain fully visible in final stable positions;
- navigation/focus/accessibility remains functional.

No-JS and motion-controller-unavailable states must also remain complete/static.

## Evidence requirements

Automated evidence must prove **change across states**, not merely existence of variables.

### Desktop 1440

Record/capture:
- Hero at at least 3 timed or scroll states;
- one editorial split section before/mid/after viewport entry;
- one photographic panel at 3 scroll positions;
- each Samples card at enter/mid/exit states;
- Closing at early/mid/late sticky reveal states;
- hover + keyboard focus state.

For each, record relevant numeric computed values such as transform/opacity/filter/sticky position.

### Mobile 375

Record/capture:
- Hero motion state;
- one split/panel motion state;
- Samples motion;
- Closing behavior;
- open/closed native menu;
- document width exactly 375 with no projected overflow.

### Fallbacks

Prove:
- reduced motion;
- no JS;
- motion script unavailable.

### Owner verification

After Executor PASS_CANDIDATE, Owner opens the retained local page and checks:

1. Hero visibly changes without hovering.
2. Scrolling through split/photo sections visibly moves imagery.
3. Samples cards visibly tilt/scale/depth-shift during ordinary scrolling.
4. Desktop Closing visibly performs a sticky reveal.

Formal motion PASS requires Owner to confirm motion is perceptible in the real browser, not only automation.

## Acceptance criteria

PASS_CANDIDATE requires:

1. Owner-static R2 visual composition is not materially degraded.
2. Motion is clearly perceptible in normal desktop browsing without DevTools.
3. Hero has visible non-hover motion.
4. Major editorial imagery has visible scroll choreography.
5. Photographic panels have perceptible desktop parallax.
6. Samples show at least three visually distinct scroll states.
7. Desktop Closing has a bounded sticky/reveal interaction.
8. Mobile motion is lighter but perceptible and never traps scrolling.
9. No horizontal overflow or broken image/resource/page error at 1440 or 375.
10. Reduced-motion, no-JS and missing-controller states remain complete.
11. Preview internals and Woo/account/payment/private-workspace behavior remain unchanged.
12. No Add-to-Cart, checkout submission, order, PayPal, model, production or shared-infra action.
13. Scoped rollback restores D2R2 accepted motion/presentation.
14. PR #64 remains open/unmerged.
15. Stop at Reviewer + Owner live motion verification.

## Reviewer to Executor relay

Read only:
1. this Gate;
2. `docs/REVIEWER_DECISION_G3CR6R3D2R3_PASS_MOTION_DIAGNOSTIC.md`;
3. current `home-motion.js`, `home.css`, and Home858 presentation;
4. `docs/G3CR6R3D1_FOCUSLY_VISUAL_MAPPING_REPORT.md` section 3 motion inventory only;
5. accepted R2 QA/rollback/source correlation as needed.

Do not reread full project history.
Do not revisit Focusly online.
Do not alter static imagery, Preview internals or business logic.

## Executor to Reviewer relay

~~~text
结果：PASS_CANDIDATE / RETURN_*
改动：一句话说明 Hero、图文区、Panel、Samples、Closing 的实际动效升级。
验证：说明1440/375多状态动效、reduced/no-JS、Preview/Woo冻结和回滚结果。
问题：NONE，或精确说明仍不可感知/性能/布局问题。
回滚：说明可恢复到已接受 D2R2。
请 Reviewer 检查：自动化多状态证据 + Owner真实浏览器是否明显感知动效。
Owner 转交：请在 http://127.0.0.1:8189/ 实际滚动页面，确认 Hero、图文/Panel、Samples 和 Closing 四类动效是否明显可感知。
~~~
