# G4D0 — Birthday Magazine P1–P12 visual layout discovery and candidate

Date: 2026-10-18
STATUS=HOLD_OWNER_ALTERNATE_PLAN_PENDING; DO_NOT_EXECUTE; NO COMMERCE/STRIPE_TRANSACTION
Authority: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7 §§0–10 and triggered 11C/11D/11E (no consequential provider actions allowed); initial inherited project brief in `birthday-magazine-studio/REVIEWER_HANDOFF.md` `PROJECT_GOAL` and selected accepted design/PDF pointers.
Prerequisite G3S4M phase is **ENDED AS PARTIAL_WITH_EXCEPTIONS**, NOT strict replay PASS, by [G3S4M reviewer closeout](./REVIEWER_DECISION_G3S4M_E3D260_STRIPE_TEST_PHASE_PARTIAL_CLOSEOUT_2026-10-18.md). This enables **design**; it does not accept Live payment or clear unmapped provider TEST activity.

```text
GATE_ID=G4D0_MAGAZINE_P1_P12_DESIGN_DISCOVERY_AND_VISUAL_CANDIDATE_20261018
OBJECTIVE=TAKE_REUSABLE_EXISTING_TWELVE_PAGE_PDF_SOLUTION_PROOF_AND_FROZEN_STOREFRONT_AS_BASELINE_TO_CREATE_COHERENT_VISUAL_MAGAZINE_PROTOTYPE_WITH_REALISTIC_SYNTHETIC_CONTENT
MAX_ENDPOINT_THIS_ROUND=SOURCE_INVENTORY_PLUS_ONE_REVIEWABLE_12_PAGE_DESIGN_CANDIDATE_WITH_EXPORT_OR_PREVIEW_AND_EVIDENCE;STOP_FOR_REVIEWER
MANDATORY_REVIEW_STOP=YES_OWNER_VISUAL_CHOICE_BEFORE_PRODUCTION_GENERATOR_INTEGRATION
TARGET_AND_SCOPE=BIRTHDAY_MAGAZINE_STUDIO_P1_TO_P12_TEMPLATE_AND_SAFE_SYNTHETIC_PREVIEW;PROJECT_SCOPED_PR64_BRANCH_ONLY_FOR_CANDIDATE_AND_EVIDENCE
APPLICABLE_CRITICAL_CONSTRAINTS=NO_NEW_STRIPE_PAYMENT_REFUND_EVENT_RESEND_OR_LIVE;NO_WOO_ORDER_PAYMENT_ORIGINAL_DATA_MUTATION;NO_REAL_USER_IMAGES;NO_SHARED_VPS_OR_CLOUDFLARE_CHANGE;NO_PR_MERGE
PREFLIGHT=VERIFY_PR64_HEAD_AND_SOURCE_SCOPE;TARGET_CANONICAL_GIT_ROOT;PRESERVE_EXISTING_WP_FRONTEND_AND_G2BR3_ACCEPTED_PDF_PROOF;CHECK_DIRTY_WORKTREE_FOR_UNRELATED_FILES;TRUST_AND_BACKUP_BOUNDARIES
REQUIRED_EVIDENCE=ACCEPTED_PDF_GENERATOR_AND_P1_P12_SOURCE_LOCATOR_WITH_COMMIT;TEMPLATE_PAGE_MAP_AND_VISUAL_HIERARCHY;SYNTHETIC_DATA_SET;12_PAGE_RENDER_SCREENSHOTS_OR_SINGLE_NAVIGABLE_HTML_AND_OPTIONAL_PDF;SOURCE_CHANGE_LIST;VISUAL_LEGIBILITY_CHECK;UNRESOLVED_AND_ROLLBACK
ACCEPTANCE_CRITERIA=REVIEWABLE_PAGE_BY_PAGE_SYNTHETIC_12_PAGE_LAYOUT_WITH_PRODUCT_READY_EDITORIAL_QUALITY_AND_PAGE_PURPOSES;NO_SECRET_OR_CUSTOMER_CONTENT;FRONTEND_PAYMENT_FLOW_UNCHANGED;REFINEMENTS_OWNER_VISUAL_APPROVAL_REQUIRED
ROLLBACK_STATUS_OR_PLAN=DESIGN_CANDIDATE_ADDED_AS_ISOLATED_FILES_PR64_ONLY_OR_SEPARATE_PROJECT_SCOPED_WORKTREE;NONPAYMENT_ASSETS_REVERTABLE_BY_GIT;EXISTING_ORDER_AND_STRIPE_CONFIG_UNTOUCHED
OWNER_ONLY_ACTIONS=NONE_DURING_SOURCE_INVENTORY_AND_FIRST_CANDIDATE;OWNER_LATER_CHOSES_DESIGN_DIRECTION
REVIEWER_TO_EXECUTOR_RELAY=SEE_BELOW
EXECUTOR_TO_REVIEWER_RELAY=GOVERNANCE_STANDARD_9_SHORT_PACKET_WITH_LINKS
```

## Frozen product goal, no reinterpretation

- English-first US-oriented **personalized birthday magazine**, buyers upload **12–25 photos** and answer structured questions; buyer does not manually write or design magazine. Deliver **12-page digital PDF**. Physical print deferred.
- Canonical WooCommerce order/customer, stored prepayment intake and paid entitlement are separate steps in future pipeline. Existing 5-step intake and browser-local preview visual/UX accepted and frozen for MVP: **do not redesign the storefront** in this Gate.
- An earlier **G2BR3** solution proof delivered *real-AI structured content plus deterministic 12-page PDF* but the final actual magazine editorial visual P1–P12 system remains unresolved. **Discover real accepted source paths and actual artifact** before claiming it is built or replacing it.
- Site/platform: original local WordPress + Blocksy/Woo; project can work in offline project-scoped files without public Tunnel. When `cloudflared` foreground window stops, public WordPress `home/siteurl` still points to `https://magazine.spikersun.com` and WP browser preview can be inaccessible. **Do not change WP canonical URL** just for design; use local file/isolated renderer or request restarting reviewed Tunnel for real public WP visual review.
- Stripe TEST financial business flow on PR64 `e3d2608...`: one original USD39.99 Woo order and TEST refund, owner revocation accepted. Sandbox has an unrelated unmapped HKD100 succeeded TEST charge and app-level replay logging gap. Both are explicitly tracked as **pre-Live hardening**; do not take payment actions as part of design.

## Expected design output

1. **READ-ONLY fast source inventory:** identify existing G2BR3 12-page PDF proof, rendering code/templates and page content schema from precise project references; choose what is reusable instead of rewriting from scratch. Locate the current P1–P12 visual requirements if present and mark gaps as `UNKNOWN`, not fabricated. Do not dump entire historical Gate archive.
2. **Page purpose map:** for each P1–P12, define title/feature role, required content fields, image/photo type/count, editorial hierarchy, readability/overflow concerns and how source photos/answers turn into personal story. Consider a cover, opener, editorial articles, visual spreads and closing, but **do not freeze invented page order**: preserve any accepted project structure if available, show a proposed order when unspecified.
3. **ONE coherent visual candidate:** produce an actual browsable 12-page magazine visual proof (e.g. standalone HTML/CSS paginated preview with user-controlled page navigation and optional PDF export), with believable English synthetic text and clearly artificial/placeheld visual media with no rights issues. Editorial magazine design (type/layout/grid/picture treatments), not a slide deck, not Woo checkout redesign. Ensure page count P1–P12, readable text with finite lengths, no clipped headlines, consistent imagery and hierarchy, landscape/portrait print/export constraints explicit. No requirement to generate real AI images or download large models; request Owner preference only where actual design choice needed.
4. **Validation:** capture safe source references and one synthetic visual preview of P1, representative interior, P12 plus 12-page page count; basic browser rendering/export/test for fonts/images/overflow if available. No personal uploads, no card testing, no live site navigation dependent on absent Cloudflare.
5. **Append** `docs/evidence/g4d0/` one concise design Evidence file and candidate files only on PR64 project-scoped branch, preserving old accepted code and rolling back by reverting added candidate source. Stop Reviewer, present 12-page navigable preview/repo relative links and one visual direction summary for Owner approval. If no reliable artifact export in the Codex runtime, don't claim PDF PASS from static HTML; report render boundary precisely.

## Reviewer-to-Executor relay

**Read only** this Gate; top `PROJECT_GOAL` and selected `CURRENT_ACCEPTED_STATE` entries in `birthday-magazine-studio/REVIEWER_HANDOFF.md` for **G2BR3** and frozen storefront UX; existing repo paths identified by narrow source discovery (not all historic notes). New Code should be isolated and non-payment. Do **not** read or modify Stripe settings/credentials/order data, Cloudflare Tunnel settings or customer uploads. The first candidate is a **design presentation**, not a finished production builder. Append one scoped candidate/evidence and STOP for Reviewer, no PR merge.

## Executor to Reviewer relay

```text
结果：PASS_CANDIDATE_DESIGN_PREVIEW / RETURN_EXACT_SOURCE_OR_RENDER_GAP
改动：仅新增或修改了哪些 P1–P12 设计候选文件。
验证：12 页实际可浏览/可导出状态，浏览器/渲染截图，未截断结果。
问题：NONE / 单个真实阻塞边界。
回滚：设计候选可按本次 PR 文件范围回退；Woo/Stripe/runtime 未变。
请 Reviewer 检查：逐页杂志编辑质感、照片可替换性、可读性及 MVP 输入契合度。
Owner 转交：NONE（等待设计方向评审时才询问）。
```


## 2026-10-18 Owner override — G4D0 on HOLD, wait for alternate production/design plan

**Latest direct Owner instruction:** "好的制作这块先不按照你说的方案来，我另有安排，请记录。明天我们再讨论。" Owner declines/defer the assistant-proposed G4D0 magazine-production/visual-design plan and will supply a different approach in the next discussion. **This Gate is now PREPARED HISTORICAL DRAFT / HOLD and is NOT authorized for Codex execution.** No source inventory, P1–P12 HTML, PDF, design asset generation, acceptance tests or other proposed magazine creation should be started under G4D0 until Owner states their alternative and Reviewer issues a new or explicitly revised Gate. Do not construe absence of the new plan as approval of this draft, and do not create a substitute design plan.

Previously accepted Stripe TEST partial closeout, prior payment/refund/source and PR64 state remain unchanged. No payment, Stripe/Webhook/Cloudflare/WooCommerce re-testing. No PR merge. **Next only: discuss Owner's proposed direction when they return.** No automatic reminder/task was requested.
