# G2A1-D1 — Target Language + OCR Acceptance Calibration

> Reviewer / Owner decision checkpoint  
> Status: **CURRENT / OWNER DECISION REQUIRED**  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)  
> R2 evidence branch: `codex/family-cookbook-g2a1-input-ocr-component-feasibility`  
> R2 handoff HEAD: `1d2abddc6e0ea58ec55c75a29033fe1233a34ada`  
> Evidence run: `36262841714`; corrected WP evidence run: `36263385997`

## 1. Why this checkpoint exists

G2A1-R2 finally produced real OCR and WordPress/WooCommerce evidence.

The reusable commerce/input/delivery side is now sufficiently proven for this Gate:

- WordPress + WooCommerce + Kadence ephemeral testbed ran;
- browser-local pre-payment preview is proven with blob/local image handling and zero added HTTP/model call after image selection;
- order-bound upload positive and negative access checks passed;
- private PDF delivery positive and negative access checks passed;
- raw public URL did not bypass access control.

These facts are accepted and must not be retested in the next OCR-only run unless their implementation materially changes.

The OCR evidence is useful but cannot yet support a general product-level PASS/FAIL decision because two product-contract inputs were never frozen before benchmarking:

1. **target language / first market**;
2. **acceptable user-confirmation burden**.

The benchmark also mixed synthetic recipe pages with genuine German handwriting while the tested TrOCR checkpoint is fine-tuned on IAM and the Paddle recognition configuration was not a German-specific multilingual model.

Therefore the R2 observation is:

> the exact tested configuration is not acceptable as a finalized MVP OCR configuration;

not:

> local OCR or the one-primary/one-fallback product pattern is proven impossible.

## 2. Accepted R2 facts

### WordPress / commerce components — PASS for G2A1 feasibility

Accepted from Actions run `36263385997` artifact even though the workflow job itself ended failure on a post-test Docker image-inspection command:

- WordPress 7.1.2;
- WooCommerce 11.1.2;
- Kadence 1.5.2;
- preview `browser_local=true`;
- requests before/after local image selection: 17 → 17;
- server upload before payment: 0;
- model calls: 0;
- token usage: 0;
- order-bound upload positive access: PASS;
- anonymous/unrelated access: DENIED;
- private PDF intended access: PASS;
- anonymous/unrelated/raw-public access: DENIED;
- cleanup removed containers/volumes/networks/test credentials.

The Actions job failure is not interpreted as a product-test failure because the compact artifact reports the product assertions as PASS; the failing command attempted to inspect a non-existent historical image tag after those tests.

### OCR benchmark — accepted observation

Across 28 pages:
- 20 synthetic recipe/typography pages;
- 8 public genuine-handwriting samples;
- PaddleOCR pages processed: 28;
- raw exact-line errors: 62;
- exact missing lines: 32;
- recipe critical-token exact-match errors: 13;
- suspicious crops: 60;
- TrOCR-small fallback calls: 60;
- fallback auto-resolved under fail-closed policy: 0;
- `USER_CONFIRM_REQUIRED`: 69;
- average confirmations: 2.464/page;
- pages with zero confirmation: 0.

Important interpretation limits:

- exact-string mismatch is not the same as semantic recipe-fact error;
- examples such as `350°F → 350F`, `180°C → 180C`, `1/2 cup → 1/2cup`, or `2 min → 2min` preserve the underlying value/unit but fail the exact matcher;
- other cases such as a blank page, omitted ingredient line or digit/letter confusion are genuine critical failures;
- the 8 genuine-handwriting samples are German/general handwriting, not target-language family recipe handwriting.

## 3. TrOCR decision

The tested configuration:

`microsoft/trocr-small-handwritten`

is **not accepted as the MVP fallback**.

Reason:
- it reduced automated confirmation by 0 in this run;
- many crop outputs were semantically unrelated even on synthetic English recipe lines;
- maintaining a second framework/model has no demonstrated benefit under this evidence.

This does **not** authorize adding multiple new OCR providers/models.

The architecture principle becomes:

```text
ONE primary OCR
→ deterministic critical-risk checks
→ AT MOST ONE bounded fallback / second pass
→ USER_CONFIRM_REQUIRED
```

The exact fallback is reopened and must be selected only after the target language is frozen.

Reviewer preference for lowest development cost:
- stay inside the PaddleOCR ecosystem if possible;
- use a language-specific recognition model and/or crop/preprocessing second pass before introducing a separate model family.

## 4. Owner decision — RESOLVED 2026-09-27

### Decision A — first language / market

**English-first, not English-only.**

Meaning:
- storefront/product UX and benchmark priority start with English;
- multilingual input is allowed where the selected OCR stack supports it;
- non-English accuracy is not marketed as equally guaranteed until language-specific evidence exists;
- the technical architecture should prefer a multilingual main engine rather than creating a separate stack per language.

### Decision B — review / correction UX

**One consolidated user confirmation stage per order/proof cycle.**

The user should not receive repeated popup-style confirmations during OCR.

Flow:

```text
OCR + fallback complete
→ build one proof/review screen
→ highlight all uncertain / high-risk fields
→ user can manually edit any field
→ one final Confirm / Approve action
```

Severe unreadable-page cases may fail closed earlier and ask for a better image; this is an intake-quality exception, not a second proof cycle.

Primary product requirement:
- recognition must be strong enough that the review screen is a quick verification/correction step, not manual retranscription;
- no silently accepted wrong quantity, unit, temperature or timing;
- exact typography/spacing differences do not count as semantic errors when the underlying fact is preserved.

The previous proposed hard threshold of `≤2 confirmations/page` is **not frozen**. R3 will measure edit burden empirically and Reviewer will judge whether the single review step remains lightweight.

## 5. Next Gate

Open:

`G2A1-R3 — OCR Architecture Benchmark: Free Local Primary + Bounded API Fallback`

R3 is OCR-only and is a **selection benchmark**, not another broad product implementation.

Do **not** repeat:
- WordPress;
- WooCommerce;
- Kadence;
- preview;
- upload;
- private delivery.

R3 should benchmark:

### Free/local primary candidates
1. **PP-OCRv6_medium** — preferred baseline; Apache 2.0, single model supports 50 languages.
2. **PaddleOCR-VL-1.6** — challenger where photographed/warped/complex documents may benefit from the 0.9B document VLM; treat hallucination/fidelity risk explicitly.

Do not add EasyOCR as a serious handwriting candidate because its own roadmap still lists handwriting support as future work.

### Bounded paid/API fallback candidates
1. **Mistral OCR 4.1** — specialized OCR API, confidence/bbox support, 170 languages, current list price $4/1000 pages.
2. **Google Enterprise Document OCR** — explicitly supports handwritten text in 200+ languages; current list price $1.50/1000 pages for the primary volume tier.
3. **Gemini 3.8 Flash** — general multimodal VLM challenger only; include because it can interpret image crops and emit structured output, but penalize hallucination/normalization risk under Preserve-don't-invent.

Fallback should receive only suspicious pages/crops whenever practical to reduce cost and data exposure.

R3 must select:
- one free/local primary;
- at most one API fallback;
- one single consolidated user review/approval stage.

Selection criteria:
- semantic critical-field fidelity;
- silent-error rate;
- manual edit burden in the one review stage;
- handwriting robustness;
- multilingual usefulness;
- latency;
- cost;
- privacy/data exposure;
- integration/maintenance cost.

Stop at Reviewer after evidence-backed selection.
