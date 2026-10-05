# Asset provenance — 2026-10-06

Owner approved improving the magazine mockup, meaningful style presets and removing the How backing panel. Marketing image generation was already explicitly authorized for this frontend. Latest Owner excludes WooCommerce frontend work.

## Photographic paper assets

Exactly **2 design-time imagegen calls**, both successful, adopted unchanged. These are blank static paper assets, not generated customer imagery or product model jobs. Tool: built-in imagegen, transparent_background=true. Source output PNGs were copied byte-for-byte; no raster retouch/cutout. RGBA with alpha range0–254, clean paper faces and soft transparent shadows. No people, photos, printed text or template artwork. Source dimensions/hashes in asset-manifest.json.

- blank-cover.png: closed portrait magazine / layered edges / light curl; used as the cover's CSS background.
- blank-spread.png: open two-page magazine / real crease / curved paper and contact shadow; used as the shared spread background.

Live names, age, headings and local photos remain HTML. A page background is not mistaken for AI content generation. No real page flip. Mobile paper aspect differs slightly to keep existing copy inside the paper.

### Exact generation prompts

**Cover**

Use case: product-mockup. Production web asset: an isolated blank premium birthday-magazine cover mockup on a genuinely transparent background. ONE closed portrait-format softcover magazine, completely blank ivory paper front cover, no design. Camera almost straight overhead, front face aligned vertically with the image edges, NO rotation or tilted perspective in the asset (CSS will rotate it later). Subtle photographic fine paper texture, realistic thin layered cream page edges visible on the left and bottom, very gentle natural curl at the lower right, warm daylight from upper left, natural soft contact shadow underneath and to lower right. Magazine fills about 90 percent of the canvas, with transparent space for its shadow. Portrait 2:3 composition. The front paper face must be broad, flat and rectangular so real HTML typography and user photos can be overlaid. Keep paper clean luminous warm white, subtle imperceptible texture, physically convincing print-object quality. Absolutely no text, letters, logos, images, photo frames, decorative objects, hands, people, ribbon, flowers, tabletop or background. No embedded checkerboard. Deliver alpha transparency including soft shadows.

**Spread**

Use case: product-mockup. Production web asset: ONE isolated blank open premium portrait-page magazine spread on a genuinely transparent background. Two completely blank ivory portrait pages, one left and one right, opened flat and viewed almost straight overhead; central fold vertical and centered exactly at 50 percent. Landscape 3:2 composition, open book fills about 92 percent of image width and 90 percent height with transparent margin for its shadow. Keep top and bottom page edges nearly horizontal; page curvature gentle enough for real editable HTML text and user photos to overlay the usable inner 80 percent of each page. Photorealistic thin stacked page edges at the lower perimeter, subtle visibly curved outer corners and gently raised inner pages, elegant realistic center crease with narrow soft shadow and highlights. Very fine warm-white matte paper texture; soft warm daylight from upper left, soft natural contact shadow beneath and to lower right. Premium stationery product photography. No rotation in the image; CSS will apply overall rotation. Absolutely no text, letters, logos, photos, frames, printed designs, hands, people, ribbon, flowers, tabletop or background. No embedded checkerboard. Deliver actual alpha transparency, including soft contact shadow.

## Fonts

Unmodified font binaries, self-hosted with their full SIL OFL1.1 licenses. Exact name-table versions, sizes and SHA256 in asset-manifest.json. No proprietary template font or paid asset.

- Manrope: [Google Fonts source](https://raw.githubusercontent.com/google/fonts/main/ofl/manrope/Manrope%5Bwght%5D.ttf), [license](https://raw.githubusercontent.com/google/fonts/main/ofl/manrope/OFL.txt). Bold Editorial: 800-weight uppercase, blue editorial rules, borderless photograph.
- DM Serif Display: [Google Fonts source](https://raw.githubusercontent.com/google/fonts/main/ofl/dmserifdisplay/DMSerifDisplay-Regular.ttf), [license](https://raw.githubusercontent.com/google/fonts/main/ofl/dmserifdisplay/OFL.txt). Retro: different serif proportions, rust ink, arch photo frames, double rule.
- Soft & Warm reuses existing Playfair Display v1.203/OFL1.1 and Instrument Serif italic. This font/preset is unchanged in principle; existing gift backdrop and fictional sample photo are reused.

All presets share identical DOM, local-photo handling and fixed sample content. They are illustrative previews, not proof of changed production PDF layouts. The original Alex How photograph is reused; no replacement person was generated.
