# G4.6 Acquisition / SEO Readiness Evidence

```text
GATE=G4_6_ACQUISITION_SEO_READINESS
CAPTURED=2026-09-23 (Asia/Shanghai)
BASE_MAIN=8e0f044541598a1eee6a304df8a7c6b6368bf473 (origin/main, unchanged at final fetch)
BRANCH=codex/g4-6-acquisition-seo-readiness
LOCAL_WORDPRESS=http://127.0.0.1:8084/
```

## Readiness outcomes

```text
MESSAGE_READINESS=PASS
DEMO_PROOF=PASS
NAV_READINESS=PASS
HOME_META=PASS
HOW_IT_WORKS_META=PASS
DEMO_META=PASS
FAQ_META=PASS
CANONICAL=PASS
SCAN_RESULT_NOINDEX=PASS
SCAN_RESULT_CANONICAL_HOME=PASS
SITEMAP=PASS
SITEMAP_UNFINISHED_SURFACES_EXCLUDED=PASS
ROBOTS_READINESS=PASS
H1_SANITY=PASS
PUBLIC_INTERNAL_TERMS=0
BLOG_PRIMARY_NAV=HIDDEN
BLOG_NOINDEX=PASS
BLOG_SITEMAP_EXCLUDED=PASS
PRICING_PRIMARY_NAV=HIDDEN
PRICING_NOINDEX=PASS
PRICING_SITEMAP_EXCLUDED=PASS
DEMO_PROOF=PASS
DEMO_SCAN_CTA=PASS
ANALYTICS_CONTRACT=PASS
SCANNER_REGRESSION=55/55 PASS
WORDPRESS_REGRESSION=20/20 PASS
SEO_READINESS_ACCEPTANCE=43/43 PASS
G4_BROWSER_REGRESSION=PASS
PAYMENT_ACTIONS=0
VPS_WRITES=0
PRODUCTION_SECRETS=0
OUT_OF_SCOPE_CHANGES=0
```

The retained Home H1 is “Find friction that may be making customers hesitate.” Its category label identifies an evidence-first ecommerce conversion audit; the supporting copy identifies a free public-page scan, evidence-backed Top 3, and no-admin-access boundary. The secondary “View sample audit” link is a low-weight text link alongside the scan boundary and points to `/demo/`; “Scan my store” remains the only strong scan CTA.

The Demo is explicitly labeled synthetic and contains exactly `CORE-007`, `PHYS-002`, and `PHYS-001`, with observed facts, fixture source paths, first moves, and claim limitations. It contains no merchant identity, testimonial, revenue-loss, or uplift claim. Its scan CTA points to the Home scan form. How it works uses six plain-language steps and retains “What a public scan cannot know.” Public static page checks and G4 browser result checks found no internal Gate/milestone language.

The primary navigation is Home, How it works, Demo, FAQ; Blog and Pricing are hidden in primary navigation and footer. Both pages remain available, have `noindex,follow`, and are absent from the native page sitemap. The native WordPress sitemap endpoint and child page sitemap returned HTTP 200 and include Home, How it works, Demo, and FAQ only. Local `robots.txt` returned HTTP 200, permits normal public page crawling, disallows only `/wp-admin/` (with the admin-ajax exception), and points to the local sitemap; it does not use robots.txt as the Blog/Pricing noindex mechanism.

Four page-specific title/description pairs are emitted for Home, How it works, Demo, and FAQ. Each normal indexable page has exactly one self canonical. A valid `?scan_id=` URL retains the result-restoration query, emits `noindex,follow`, uses the clean Home canonical, and keeps title/description static. Query result URLs are not part of the sitemap.

## Commands and evidence

Executed from the isolated project-scoped sparse workspace:

```text
py -3.12 -m pytest -q                                      # scanner/: 55 passed
py -3.12 -X utf8 acceptance/run_asset_checks.py            # TOTAL=20 PASS=20 FAIL=0
py -3.12 -X utf8 acceptance/run_seo_readiness_checks.py     # TOTAL=43 PASS=43 FAIL=0
node tests/g4_browser_test.cjs                              # PASS; deterministic fake Scanner fixture
py -3.12 -X utf8 acceptance/capture_g4_6_screenshots.py     # 4 PNGs
```

The G4 browser regression exercised backend-driven progress through `CHECKING_ACCESS`, `READING_PAGES`, `MATCHING_EVIDENCE`, `PRIORITIZING`, and `COMPLETE`; Golden Demo; 0/1/2/3 finding cases; incomplete, blocked, rate-limited, timeout and unsafe URL cases; scan refresh; analytics properties; and mobile form submission. Analytics event names and required properties passed; no payment or checkout events were emitted. Scanner rules and their semantics were not changed.

Playwright screenshots use Chromium, a 1440×900 viewport for the page captures, device scale factor 1, reduced motion, and no DevTools. The navigation image is a header-only crop. Final captures were made on 2026-09-23 around 04:48 Asia/Shanghai:

| File | Page / state | Capture |
| --- | --- | --- |
| `01-home-message-proof.png` | Home, initial viewport; message, trust boundary, scan form and sample-audit link | viewport |
| `02-demo-proof.png` | Synthetic Demo, all three findings and scan CTA | full page |
| `03-how-it-works-public-copy.png` | How it works, six public-language steps and limitations | full page |
| `04-nav-without-blog-pricing.png` | Home primary header, Blog/Pricing absent | header crop |

Screenshots are in `docs/evidence/g4-6-screenshots/`.

## Changed surface and deferred work

All source and evidence changes are within `conversion-leak-audit/**`. Changes are limited to Home / Demo / How-it-works / FAQ public copy, navigation visibility, the sample CTA, a lightweight SEO MU plugin and repeatable readiness tests/evidence. The only G4 integration changes are a sample-audit link in the existing scan card and a public-copy clarification; scanner behavior and rules are unchanged.

Production-deferred checklist (not executed in this local Gate): Search Console; formal-domain canonical; HTTPS; production `robots.txt`; production sitemap submission; favicon/site name; Privacy; Terms; Organization schema; real Core Web Vitals. No blog factory, platform landing-page batch, analytics provider, payment, VPS, domain, or production-secret work was done.

Known limitation: SEO behavior was verified on the local WordPress host only. Production-domain URL policy, crawler behavior, indexing, and live Core Web Vitals remain for a later production readiness Gate. Owner intervention required: `NONE`. Recommended Reviewer decision: `REVIEW_G4_6_ACQUISITION_SEO_READINESS`.
