# G3CR6R3C Core Aha — Reuse and Implementation Map

## Recommended implementation stack

### Primary: vanilla GSAP + Flip + CSS

Use GSAP/Flip inside the existing WordPress/Gutenberg frontend rather than adding React/Framer/Webflow.

Reasons:
- the strongest inspected image→content references use FLIP/shared-element geometry;
- current GSAP licensing permits commercial use and previously paid plugins are available without the old Club paywall;
- vanilla JS fits the existing Preview architecture and keeps the mutation surface small.

### Optional progressive enhancement: native View Transitions

Native View Transition APIs can reduce some shared-element plumbing on newer browsers, including newer scoped/nested transitions. They are **optional enhancement only**; the Core Aha must retain a CSS/GSAP/static fallback for older devices.

## Reuse classification

| Source | Classification | Rule |
|---|---|---|
| Codrops downloadable demos | **DIRECT_REUSE_OK** for code when no specific exception is stated | MIT notice must be retained; do not copy demo photography/fonts/branding merely because code is MIT |
| Codrops C01/C02/C03/C05 families | **DIRECT_REUSE_OK / adapt primitives** | use transition mechanics, not their visual identity |
| GSAP + Flip | **LIBRARY_USE_OK** | current standard license supports commercial use |
| Browser View Transition API | **DIRECT_PLATFORM_API** | feature-detect; never sole path |
| StPageFlip | **DIRECT_REUSE_OK (MIT)** | reserve for later magazine reader evaluation |
| react-pageflip | **DIRECT_REUSE_OK (MIT)** | rejected for Core Aha because React dependency is unnecessary |
| turn.js | **REJECT** | repository license is non-commercial BSD; incompatible with intended paid product |
| Framer templates | **REFERENCE_ONLY_REIMPLEMENT** | inspected listings show Single-Use/Limited licenses; do not port template code/design wholesale |
| Webflow cloneables | **REFERENCE_ONLY_REIMPLEMENT** | cloneability is not treated as blanket cross-platform source license |
| Awwwards references | **REFERENCE_ONLY_REIMPLEMENT** | visual/motion reference only |
| Individual CodePens | **UNKNOWN_DO_NOT_COPY** unless their author/license is separately proven | observe mechanism, rewrite independently |
| Motion examples/components | **REFERENCE_ONLY_REIMPLEMENT** | React/Motion dependency not justified for current WP shell |

## Proposed technical boundaries for later implementation Gate

- Keep the existing browser-local photo blob/object URL; no network transport.
- Build one contained Aha controller with deterministic states: PHOTO → COVER → STACK → SPREAD → VIEWER.
- Preserve current Preview select/replace/remove behavior.
- No generated/customer content before payment beyond fields already allowed by the MVP contract.
- Use only supplied recipient name/age/date/style plus fixed product copy in cover labels.
- The sample interior spread is deterministic/demo content; do not invent recipient-specific memories.
- Feature-detect motion; static completed-state fallback is mandatory.
- No scroll hijack.
- No React introduction solely for this effect.
- No production model/provider calls.
- The first implementation Gate should build a bounded vertical slice only, not the full P1–P12 renderer.

## Sources checked for license/implementation

- Codrops licensing: https://tympanus.net/codrops/licensing/
- GSAP/Webflow license update: https://webflow.com/blog/gsap-becomes-free
- StPageFlip: https://github.com/Nodlik/StPageFlip
- react-pageflip: https://github.com/Nodlik/react-pageflip
- turn.js license: https://github.com/blasten/turn.js/blob/master/license.txt
- MDN ViewTransition: https://developer.mozilla.org/en-US/docs/Web/API/ViewTransition
- Chrome element-scoped transitions: https://developer.chrome.com/blog/element-scoped-view-transitions
