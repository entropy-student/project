# SPW SPIKE Starflow background

Build with `npm ci --no-audit --no-fund` and `node build.mjs`. Copy all files from `dist/` to the same local assets directory; `starflow.js` imports its hashed engine chunk. Include `starflow.css`, load `starflow.js` as a module and place `<spw-starflow></spw-starflow>` outside the site's replaced page container.

## Source and integration

The full upstream **Starflow 0.2.4 source** is vendored in `vendor/astra/`, retrieved through the GitHub connector on 2026-10-25. Each upstream blob SHA is recorded in `vendor/PROVENANCE.json`; the MIT license is retained. This replaces the previous npm 0.2.3 build, which lacked text skeleton extraction, stroke-center tubes and the matching particle depth implementation. Three.js 0.180.0 and postprocessing 6.39.5 are pinned in the lockfile, bundled locally with their licenses. There are no runtime CDN, font or image requests.

`build.mjs` applies a narrow adapter at build time, leaving the vendored sources unchanged. It changes the engine's input target from its canvas to `document`, guards interaction through the component's `canInteract`, avoids canvas pointer capture for document events, and exposes `setPaused` around the existing engine `running` gate. It also permits one initial frame when paused and exposes DOM diagnostics. Upstream particle generation, centerline extraction, shader math, GPGPU repulsion, drag rotation, inertia, bloom and lens flare are unchanged.

Canvas remains decorative with `pointer-events:none`. Normal pointer motion reaches the engine through document listeners; desktop left-button drag starts only outside links, controls and text blocks. Input events are never prevented or stopped. Touch drag is excluded so mobile page scrolling remains native. The scene ignores pointer events on navigation, links and the settings panel. `canvas[data-intro-progress]`, `[data-pointer-active]`, `[data-drag-active]` and the host's `[data-star-count]` / `[data-gpu-repel]` describe the current renderer for visual QA.

## Appearance and controls

The sole source is centered uppercase **SPIKE**, Arial/system sans-serif at weight 700, zero extra letter spacing, using upstream `stroke:center`. Entry uses the original 5.5-second particle convergence instead of the previous 0.8 seconds. The canvas has no positional offset, directional mask or darkening overlay. Default desktop settings are 16,000 source stars plus the engine's background stars, Astra palette, size 2.05, spread 1.3, fill 0.06, background ratio 0.14, depth 0.02, rotation depth 1.4, flow 0.35, twinkle 0.62, intensity 1.35, bloom 0.7, threshold 0.08 and lens flare 0.28. The page base remains #080B12.

The collapsed floating control panel retains three expandable groups: starfield, optics and motion. It provides GPGPU repulsion, lens, core spin and auto-rotation switches, replay, pause and reset. Controls never resize normal HTML content. Geometry parameters rebuild the field inside the **same renderer** after a 450 ms debounce or immediately on release; that deliberately replays convergence. Optical and motion sliders update live configuration without rebuilding the renderer. Settings are validated and stored under `spw-starflow-v2`, so the older shape/offset preferences do not override the new defaults.

## Lifecycle and fallback

Every public theme template with a `#content-wrapper[data-spw-template]` marker activates the background when `#spw-content` is visible; on the home route the Hello/words/globe opening remains excluded. Hello, words and globe remain independent. Leaving the home section, navigating away, hiding the tab and pressing pause freeze the existing WebGL frame; returning resumes the existing scene without resetting convergence. Renderer disposal occurs only when the component permanently disconnects or fails, with reparenting handled by a microtask guard.

Mobile caps source stars at 5,000, uses balanced postprocessing and a 1.2-megapixel budget. Desktop starts at full postprocessing / 2.4 megapixels. Upstream adaptive quality remains active. Reduced-motion preference renders the complete composition and freezes it. Missing WebGL uses the upstream static Canvas 2D fallback, and a failed engine load has a CSS starfield fallback. Exact frame rates depend on the device.


## Reading / immersive integration (SPW v5)

The optional “沉浸欣赏” control sets body[data-spw-immersive], fades #spw-content without changing layout, and marks that content inert/aria-hidden. The same control or Escape restores its original attributes and scroll position. The mode is not persisted; native navigation and component disconnection clean it up. Wheel / single-touch scroll is held outside the settings panel only during immersion; normal reading events remain unchanged. Keyboard page scrolling is held while immersed, leaving form controls usable. The theme supplies local glass reading surfaces; the underlying particle rendering, brightness and timing are unchanged.
