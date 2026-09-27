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

## 4. Owner decision required

### Decision A — first language / market

Reviewer recommendation:

**English-only MVP first.**

Reason:
- creates a coherent benchmark boundary;
- PaddleOCR provides English-specific recognition options;
- genuine benchmark fixtures can be selected from English handwriting/recipe sources;
- avoids treating mixed German/French/English results as one product-quality number;
- minimizes OCR, QA and correction-UI complexity.

This recommendation is about technical/product-scope clarity, not a claim that English has the best market demand.

### Decision B — OCR UX acceptance threshold

Reviewer recommended MVP threshold:

1. **0 silently accepted wrong critical facts** for quantity, unit, temperature and timing;
2. average `USER_CONFIRM_REQUIRED` **≤ 2 per recipe page** on target-language recipe-like handwriting;
3. confirmation should normally be a tap/short correction against the source crop, not whole-recipe retranscription;
4. severe recognition failure/blank-page cases must fail closed and ask for a better image or manual correction;
5. exact typography/punctuation/spacing differences do not count as critical semantic errors when the underlying value and unit are preserved.

This threshold is a product/UX boundary, not an OCR benchmark convention.

## 5. Next Gate after Owner approval

Open:

`G2A1-R3 — Target-Language Semantic OCR Calibration`

R3 must be OCR-only.

Do **not** repeat:
- WordPress;
- WooCommerce;
- Kadence;
- preview;
- upload;
- private delivery.

R3 should:
- use the selected target language;
- use recipe-like genuine handwriting fixtures in that language;
- configure PaddleOCR for that language;
- score **semantic critical-field correctness**, not only exact strings;
- benchmark one bounded low-maintenance fallback/second-pass strategy;
- measure confirmation burden against the approved UX threshold;
- stop at Reviewer.

No execution prompt should be dispatched until this Owner checkpoint is resolved.
