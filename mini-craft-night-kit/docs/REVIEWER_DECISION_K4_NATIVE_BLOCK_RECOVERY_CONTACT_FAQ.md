# Reviewer Decision — K4 Native Block Recovery for Contact + FAQ

Date: 2026-09-23
Status: AUTHORIZED
Parent Gate: K4_STRICT_STOREFRONT_CLEANUP
Trigger: RETURN_REVIEWER_GUTENBERG_RECOVERY_BOUNDARY
Executor return commit: 973d9522f1dea09ae9513b2f056829b6a4bd48f1

## Reviewer determination

The Executor correctly stopped before mutation.

The 11 invalid blocks are pre-existing serialization/editor-validity defects and are now isolated to:
- Contact page 10: 1 Kadence Form + 3 core/column blocks
- FAQ page 1121: 7 core/details blocks
- Shipping & Returns page 9: 0 invalid blocks

A verified local rollback snapshot exists and the current Home/Product Gallery/payment/order baselines are unchanged.

The recovery path below is authorized because it is narrow, reversible, native-block-only, and preserves exact customer content.

## Gate

GATE=K4_NATIVE_BLOCK_RECOVERY_CONTACT_FAQ

This Gate repairs ONLY Gutenberg block validity on Contact and FAQ.

Do not continue the broader strict storefront cleanup in the same run.

## Recovery principles

1. DO NOT click or invoke Gutenberg "Attempt Recovery" / automatic destructive recovery.
2. DO NOT run a whole-page parse→serialize round trip.
3. DO NOT rewrite the whole Contact or FAQ post_content.
4. DO NOT hand-invent Kadence plugin block markup.
5. Use registered native/core/Kadence blocks and the current block-editor serializer.
6. Preserve all unfamiliar blocks/attributes/classes not directly in the invalid target.
7. Preserve all customer-facing text exactly in this Gate; copy cleanup belongs to the later resumed storefront-cleanup Gate.
8. Before every page write, retain a page-local rollback copy/hash and compare non-target block signatures.

## Contact page 10

Observed invalid targets:
- Kadence Form: 1
- core/column: 3

### A. Kadence Form recovery

The saved Kadence Form attributes already define three required fields:
- Name — text
- Email — email
- Message — textarea

The saved frontend markup currently contains labels for Name/Email but omits their input controls, while Message textarea and Send message button render.

Authorized recovery:
- recreate/replace ONLY the invalid Kadence Form block using the currently registered Kadence Form block in the native Gutenberg editor/runtime;
- preserve the intended visible fields exactly:
  - Name
  - Email
  - Message
  - Send message
- preserve required-state semantics;
- preserve honeypot if the native block carries it;
- do not invent email recipient, public email, phone, address, webhook, or external integration;
- do not send a real submission;
- do not hand-write the block's plugin HTML;
- use the registered current Kadence 3.7.11 block serializer/native editor path so saved attributes and markup are schema-consistent.

If native recreation cannot be performed without inventing a destination/action or losing unknown settings:
RETURN_REVIEWER_K4_CONTACT_FORM_NATIVE_RECREATE_BLOCKED

### B. Three invalid core/column blocks

Repair ONLY the three invalid core/column blocks.
Use native core blocks.
Preserve their exact heading/text content and column structure.
Any raw paragraph content inside those columns must become proper registered core/paragraph child blocks rather than unregistered raw HTML.
No copy rewrite in this Gate.

## FAQ page 1121

Observed invalid targets:
- 7 core/details blocks

Authorized recovery:
- recreate/replace ONLY those seven invalid core/details blocks with registered current core/details blocks;
- preserve each Summary text exactly;
- preserve each existing answer text exactly;
- preserve links exactly;
- use registered core/paragraph child blocks inside details as required by the current schema;
- preserve section headings and page order;
- do not merge/split/rewrite FAQ copy in this Gate.

Do not use raw HTML details as a substitute.

## Shipping & Returns

Read-only verification only.
Invalid count is already 0.
No mutation.

## Protected scope

Must remain unchanged:
- Home content/hash
- Header/logo
- Home four product media/order
- Owner-deleted Home sections
- Product page and Product Gallery
- Product gallery scoped CSS
- Shop/products/taxonomy/status
- site locale/admin locale
- WooCommerce settings
- PayPal settings
- orders/payment state
- Shipping & Returns page
- current business-policy facts

## Validation

After repair:
- Contact Gutenberg invalid blocks = 0
- FAQ Gutenberg invalid blocks = 0
- Shipping & Returns invalid blocks = 0
- total across these pages = 0
- Contact frontend visibly renders Name, Email, Message, Send message
- FAQ frontend renders all seven native details/accordion entries
- no customer copy change in this Gate
- no horizontal overflow at 390 and 1440 for Contact/FAQ
- Home HTTP 200
- Product HTTP 200
- Home hash unchanged
- Product Gallery CSS unchanged
- site locale unchanged
- product state unchanged
- order baseline unchanged
- PayPal config unchanged
- NEW_ORDER_ACTIONS=0
- PAYMENT_ACTIONS=0
- LIVE_ACTIONS=0

## Evidence

Commit:
- updated EXECUTION_EVIDENCE.md
- updated EXECUTOR_HANDOFF.md
- post-repair Contact desktop 1440 + mobile 390
- post-repair FAQ desktop 1440 + mobile 390

Package:
K4_NATIVE_BLOCK_RECOVERY_CONTACT_FAQ-visual-review.zip

ZIP only:
- contact desktop/mobile
- faq desktop/mobile
- manifest.txt

## Return

GATE=K4_NATIVE_BLOCK_RECOVERY_CONTACT_FAQ
RESULT=<PASS_CANDIDATE_K4_NATIVE_BLOCK_RECOVERY_CONTACT_FAQ | RETURN_REVIEWER_*>
SUMMARY=
CONTACT_INVALID_BLOCKS_BEFORE=4
CONTACT_INVALID_BLOCKS_AFTER=
FAQ_INVALID_BLOCKS_BEFORE=7
FAQ_INVALID_BLOCKS_AFTER=
TOTAL_INVALID_BLOCKS_AFTER=
CONTACT_FORM_VISIBLE_FIELDS=<NAME_EMAIL_MESSAGE_SEND | RETURN>
CONTACT_COPY_CHANGED=NO
FAQ_COPY_CHANGED=NO
NON_TARGET_BLOCK_SIGNATURES_PRESERVED=<YES | NO>
HOME_PROTECTED=YES
PRODUCT_GALLERY_PROTECTED=YES
SITE_LOCALE_UNCHANGED=YES
PRODUCT_STATE_UNCHANGED=YES
PAYPAL_ORDER_STATE_UNCHANGED=YES
EVIDENCE=
COMMIT=
VISUAL_REVIEW_PACKAGE=<absolute local zip path>
VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_ZIP_REQUIRED
OWNER_ACTION=UPLOAD_VISUAL_REVIEW_ZIP
NEXT=STOP_AT_REVIEWER

Do not resume K4_STRICT_STOREFRONT_CLEANUP automatically.
Do not enter K5.
