# Reusable Storefront — Re-skin Map

Date: 2026-09-22
Status: APPROVED OWNER/EXECUTOR MAP

## Goal

Future storefront re-skins normally change only:
1. global colors;
2. images;
3. text/product data.

No layout reconstruction should normally be required.

## Global replacement order

1. Update global brand color tokens.
2. Replace logo/site name/tagline.
3. Replace Header/Footer labels and real destinations.
4. Replace Home images and copy.
5. Replace WooCommerce product data and gallery.
6. Replace FAQ / Shipping & Returns / Contact copy.
7. Run responsive and WooCommerce regression checks.

## Per-page map

| Page | Fixed shell | Replaceable | Edit surface | Routine Owner edit |
|---|---|---|---|---|
| Home | section structure/order | images, text, CTA labels, colors | Gutenberg/Kadence + global theme colors | Yes |
| Shop | Woo archive/grid behavior | product data/images, global tokens | WooCommerce + theme | Product data yes; layout no |
| Product | Woo gallery/summary/Add to Cart + lower shell | gallery, product data, lower images/copy, colors | WooCommerce product + Gutenberg/Kadence/theme | Yes, excluding commerce logic |
| FAQ | hero + grouped accordion structure | FAQ text, hero image, colors | Gutenberg/Kadence | Yes |
| Shipping & Returns | hero + 3 policy cards + support block | policy text, hero image, colors | Gutenberg/Kadence | Yes |
| Contact | hero + native form + support blocks | hero image, support copy, colors | Gutenberg/Kadence | Yes; form structure normally fixed |
| Cart | native Woo structure | global colors/typography only | theme/WooCommerce | No structural edits |
| Checkout | native Woo structure | global colors/typography only | theme/WooCommerce | No structural edits |
| Thank You | native Woo order-result structure | global colors/typography only | theme/WooCommerce | No structural edits |
| My Account | native Woo account structure | global colors/typography only | theme/WooCommerce | No structural edits |

## Home replacement slots

H-01 Header: logo/site name, nav text/links, CTA label. Keep Kadence mechanics/mobile/cart.
H-02 Hero: image, eyebrow, H1, body, CTA. Keep geometry and responsive stacking.
H-03 Three-step strip: 3 labels/descriptions/icons. Keep 3-column desktop / stacked mobile.
H-04 Value cards: 3 titles/descriptions/icons. Keep 3-card layout.
H-05 Story split: lifestyle image, title/body/optional CTA. Keep split layout.
H-06 Contents grid: 3–5 truthful content images/titles/descriptions. Keep card-grid component.
H-07 Trust strip: truthful benefit/trust statements. Keep compact band/mobile stack.
H-08 FAQ + Shipping reassurance: FAQ questions and policy summary. Keep two-column/stacked structure.
H-09 Closing CTA: headline, support line, CTA, colors. Keep full-width CTA band.

## Product replacement slots

P-01 WooCommerce owns name, price, images/gallery, inventory, SKU, variations/options, short description.
P-02 Trust row: replace truthful labels only.
P-03 Experience/value panel: replace three value propositions.
P-04 Included/content grid: replace images and verified contents only.
P-05 Use-case/lifestyle: replace image and copy.
P-06 FAQ/policy summary: replace factual text only.

Never alter Add to Cart/payment behavior for a re-skin.

## FAQ

Replace hero image/title/subtitle, questions/answers, help-card copy.
Keep groups, accordion behavior, CTA/footer.

## Shipping & Returns

Replace hero image/title, Shipping copy, Returns copy, Damaged/Missing copy, FAQ/support copy.
Keep three-card structure and support CTA.

## Contact

Replace hero image/title/body, support-reason copy, reassurance cards, CTA copy.
Keep Name/Email/Message native Kadence Form behavior.
Do not invent contact data.

## Future re-skin checklist

- Create rollback point.
- Change global color tokens.
- Replace logo/site identity.
- Replace Header/Footer text/links.
- Replace Home hero/support imagery.
- Replace Home copy.
- Replace WooCommerce product title/price/gallery/data.
- Replace Product lower-page images/copy.
- Replace FAQ copy.
- Replace Shipping & Returns policy copy.
- Replace Contact copy.
- Check all business-truth claims.
- Validate Gutenberg blocks.
- Validate 320/375/390/430 mobile.
- Validate tablet/desktop/ultrawide.
- Smoke Product -> Add to Cart -> Cart -> Checkout without payment.
- Verify PayPal/WooCommerce settings untouched.
- Capture before/after screenshots.

## Executor image restriction

Executor must not generate images.

If a final image is unavailable:
- keep an existing approved image; or
- use a replaceable neutral placeholder.

Do not source or generate fake lifestyle/customer/review imagery.

## Definition of success

- new-product re-skin requires no layout code change in the normal case;
- no payment change;
- Owner can replace images;
- Owner can replace text;
- Owner can change global colors;
- responsive behavior preserved;
- WooCommerce behavior preserved.
