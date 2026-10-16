# Birthday Magazine Studio — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance: **vps-project-governance v0.2.7**  
> Canonical operational rules: `spike.skill/vps-project-governance/VNEXT.md`  
> External operational addenda: NONE  
> Last reviewed: 2026-10-16 (G3S3R PASS retained; Owner explicitly approves one bounded G3S4 Stripe TEST-only payment/refund round with mandatory recovery and source preflight)

## NEW_REVIEWER_ENTRYPOINT_2026_10_15

**Start here when this conversation has run out:** `docs/NEXT_REVIEWER_BOOTSTRAP_2026-10-15.md`.

- The bootstrap is a **snapshot and reading index**, not a new Gate or a replacement for this current Handoff.
- Latest G3S0 formal decision: `docs/REVIEWER_DECISION_G3S0_PASS_READINESS_WITH_RUNTIME_UNKNOWN_2026-10-15.md`.
- G3S0 Owner-relayed report and provenance: `docs/evidence/g3s0/OWNER_RELAY_AND_REVIEW_COVERAGE_2026-10-15.md`.
- **Current Gate G3S4 (Owner authorized, not executed):** `docs/G3S4_STRIPE_TEST_ONLY_PAYMENT_READINESS_AND_CYCLE_2026-10-16.md`. Scoped explicit Owner approval `docs/OWNER_AUTHORIZATION_G3S4_STRIPE_TEST_ONLY_2026-10-16.md` covers only Stripe TEST-mode account connection with Owner consent, local test gateway configuration, synthetic USD39.99 payment/negative paths, signed test webhook/replay and TEST refund. The **new qualified DB+WP/uploads backup, source/runtime verification and environment fail-closed checks are mandatory BEFORE provider/test order writes**. Prior G3S3R bounded runtime PASS preserved. PR #64 stays Open/unmerged at last verified `1b2e3c4e0b7c3c2f4961c991a2626f341dec5b7c`.
- Confirm current PR #64 and `main` before consequential future steps. **Latest G3S3R Executor-host readback**: original DB running/healthy, WordPress running/HTTP 200 when localhost proxy bypass is used, WP-CLI running, Mailpit stopped; this is accepted at the G3S3R stage only. Reviewer has not directly accessed Owner hardware.
- G3S0 historical PASS was **readiness classification only**, later superseded for local WordPress and inactive Stripe plugin by G3S1R and G3S1SV bounded PASS. **Stripe account existence is now OWNER_REPORTED registered**; legal entity/country, Stripe KYC/activation, HTTPS callback, payouts and real/Test payment remain unverified.
- Owner has accepted/frozen frontend visuals; payment integration may proceed without new UI rework; do not silently close pending independent final-source technical check.
- PayPal Sandbox stays; no OAuth/merchant onboarding, connection, Gateway activation, checkout, provider action, tunnel or merge is allowed by G3S1.

## PROJECT_GOAL

US-first personalized birthday magazine:
- buyer provides photos + structured answers;
- product delivers a polished personalized **12-page digital PDF**;
- buyer does not need to write or design the magazine manually.

Frozen MVP:
- English first;
- digital PDF;
- test price **US$39.99**;
- browser-local zero-model free Preview;
- authenticated customer account;
- WooCommerce canonical commerce/order system;
- complete pre-payment intake + paid entitlement are both required before one canonical generation-ready job;
- one bounded revision batch;
- source/intermediate deletion within 24h after final delivery/approval; final PDF retained 72h;
- physical print deferred.

## PROJECT_STAGE

```text
TECHNICAL_SOLUTION_PROOF=PASS
WOOCOMMERCE_ACCOUNT_PRIVATE_WORKSPACE=PASS
PAYPAL_SANDBOX_LIFECYCLE=PASS
FRONTEND_COMPOSITION_G3CR6R1=PASS
OWNER_OVERALL_VISUAL_DIRECTION=PASS_CURRENT_MVP_FRONTEND
CURRENT_GATE=G3S4_STRIPE_TEST_ONLY_PAYMENT_READINESS_AND_CYCLE_OWNER_AUTHORIZED_PREFLIGHT_PENDING
G3S1R_REVIEWER=PASS_LOCAL_RUNTIME_RESTORED
G3S1R_EVIDENCE_PR64=ee03136537fdf9fda9ee36022261f84ba78dca93
G3C_WORDPRESS=RUNNING_G3S3R_EXECUTOR_READBACK
G3C_DB=RUNNING_HEALTHY_G3S3R_EXECUTOR_READBACK
G3C_WPCLI=RUNNING_G3S3R_EXECUTOR_READBACK
G3C_MAILPIT=STOPPED_EXIT_0_G3S3_EXECUTOR_READBACK
G3C_SITE_LOOPBACK_8189=HTTP_200_WITH_EXPLICIT_LOOPBACK_PROXY_BYPASS_G3S3R_EXECUTOR
G3C_WOO_PRODUCT_1113=VIRTUAL_USD_39_99_EXECUTOR_READBACK
G3C_PPCP=NOT_INSTALLED_EXECUTOR_READBACK
G3C_STRIPE=11_1_0_INSTALLED_INACTIVE_REVIEWER_ACCEPTED_EXECUTOR_EVIDENCE
G3B_HISTORICAL_PAYPAL_PASS=SEPARATE_SANDBOX_CLEANED_UP
G3C_DB_BACKUP_RECOVERABILITY=G3S1SV_ISOLATED_DB_RESTORE_EXIT_0_58_OF_58_BOUNDED_PREPAYMENT_FRESH_BACKUP_REQUIRED
G3S1S_REVIEWER=RETURN_BACKUP_OR_ROLLBACK_UNVERIFIED
G3S1S_EXECUTOR_EVIDENCE=d0ae16640fe01db90093ca00738c130a6f8a9915
G3S1S_WP_FILES_ISOLATED_RESTORE=PASS_EXECUTOR_READBACK
G3S1S_DB_DUMP_HASH=PASS_EXECUTOR_READBACK
G3S1S_DB_ISOLATED_IMPORT=EXIT_1_CAUSE_UNKNOWN
G3S1S_STRIPE_INSTALLED=NO
G3S1SR_REVIEWER=RETURN_EXECUTION_POLICY_BLOCKED_DB_DIAGNOSTIC
G3S1SR_PR64=d13b27fd8290d0575bd3ac7733f3f3039b415a21
G3S1SR_DIAGNOSTIC_PROCESS_STARTED=NO
G3S1SR_DB_IMPORT=NOT_RUN
CODEX_LOCAL_DB_DIAG_RETRY=NOT_AUTHORIZED
PROJECT_EXECUTION_STATUS=G3S3R_PASS_G3S4_TEST_ONLY_OWNER_APPROVED_NOT_EXECUTED
G3S1SV_OWNER_REPORTED_IMPORT=EXIT_0_58_OF_58
G3S1SV_SOURCE_AND_ISOLATION=EXECUTOR_EVIDENCE_REVIEWER_ACCEPTED_WITH_SCRATCH_ID_UNRETAINED
G3S1SV_FORMAL_RESTORE_PASS=BOUNDED_REVIEWER_ACCEPTED_FOR_INACTIVE_INSTALL_ONLY
G3S1SV_DB_RESTORE=EXIT_0_58_OF_58_MARIADB_11_4_7_OWNER_REPORTED
G3S1SV_STRIPE_INSTALL=EXIT_0_INSTALLED_INACTIVE_REVIEWER_ACCEPTED_EXECUTOR_EVIDENCE
G3S1SV_POSTINSTALL_CLEANUP=BLOCKED_BY_POLICY_REPORTED
G3S1SV_TEMP_FILES=RETAINED_HOST_TEMP_AND_WPCLI_TMP_REPORTED
G3S1SV_REVIEWER=PASS_LOCAL_STRIPE_11_1_0_STAGED_INACTIVE_BOUNDED
G3S1SVE_REVIEWER=PASS_EVIDENCE_PERSISTED
G3S1SVE_PR64_COMMIT=4cb0d527d77a6d583e123acd3f62c45408669569
G3S1SV_TEMP_PACKAGE_CLEANUP=DEFERRED_POLICY_BLOCKED
G3S1SV_BACKUP_SNAPSHOT_RECORD_LEVEL_EQUALITY=UNKNOWN_NOT_CLAIMED
STRIPE_MERCHANT_ACCOUNT_STATUS=REVIEW_APPROVED_OWNER_REPORTED_ACTUAL_CHARGES_PAYOUT_UNKNOWN
STRIPE_GATEWAY_STATUS=INACTIVE_NOT_REGISTERED
STRIPE_REVIEW=APPROVED_OWNER_REPORTED_NOT_PROVIDER_READBACK
STRIPE_ACCOUNT_COUNTRY_ENTITY=UNKNOWN
STRIPE_CHARGES_ENABLED=UNKNOWN
STRIPE_PAYOUTS_ENABLED=UNKNOWN
PUBLIC_STATIC_FRONTEND=https://birthday-magazine-original.netlify.app/
NETLIFY_VISUAL=ORIGINAL_RESTORED_OWNER_REPORTED
NETLIFY_ANONYMOUS_ACCESS=NOT_INDEPENDENTLY_VERIFIED
WORDPRESS_WOO_PUBLIC_PRODUCTION=NOT_DEPLOYED
PR64_LAST_VERIFIED_HEAD=1b2e3c4e0b7c3c2f4961c991a2626f341dec5b7c
G3S1SVE_COMPLETED_SCOPE=EVIDENCE_ONLY_HOST_MUTATIONS_0_REVIEWER_PASS
G3S2_REVIEWER=PASS_READONLY_POLICY_RESEARCH_OWNER_ENTITY_UNVERIFIED
G3S2_OFFICIAL_STRIPE_HK=SUPPORTED_QUALIFYING_HK_BUSINESS_ONLY
G3S2_OFFICIAL_STRIPE_MAINLAND=NOT_STANDARD_PAYMENTS_MERCHANT_REGION
G3S2_HK_INDIVIDUAL_NONHKID=NOT_ELIGIBLE_PER_OFFICIAL_SOURCE
G3S2_HK_USD_WISE=STRIPE_HK_FEATURE_EXCLUDES_TRANSFERWISE
G3S2_HK_HKD_WISE=UNKNOWN_NOT_ASSUMED
G3S2_MERCHANT_ACCOUNT=EXISTS_OWNER_REPORTED_ELIGIBILITY_UNKNOWN
G3S2_OWNER_ACCOUNT_ISSUE=SUPERSEDED_BY_REVIEW_APPROVED_OWNER_REPORTED
G3S2_STRIPE_REGISTRATION_OWNER_UPDATE=docs/OWNER_UPDATE_G3S2_STRIPE_ACCOUNT_REGISTERED_ISSUES_PENDING_2026-10-16.md
G3S2_ACCOUNT_PROVIDER_HOST_MUTATIONS=0
G3S3_REVIEWER=RETURN_PREFLIGHT_DRIFT
G3S3_EXECUTOR_EVIDENCE_COMMIT=2eb033658ad0ed04dacfe3a0f2b26101ab4697e3
G3S3_G3C_LOCAL_SOURCE_HEAD=f50cc974ead65c9811f952cdf0a327c548f14efc
G3S3_LOCAL_VS_PR_COMMIT_LAG=46_AT_2EB0336
G3S3_LOCAL_UNCOMMITTED_CHANGES=3_SOURCE_EDITS_17_TRACKED_SCREENSHOT_DELETIONS
G3S3_VOLUME_NAMES=existing_database_and_wordpress_intact_METADATA_ONLY
G3S3R_OWNER_START_AUTHORIZATION=APPROVED_USED_ONCE_EXPIRED_FOR_NEW_ROUNDS
G3S3R_REVIEWER=PASS_BOUNDED_EXISTING_RUNTIME_RESTORED
G3S3R_EVIDENCE_COMMIT=1b2e3c4e0b7c3c2f4961c991a2626f341dec5b7c
G3S3R_G3C_SOURCE=EFFECTIVE_BIND_MOUNTS_RELEVANT_PATHS_MATCH_PR_EXECUTOR_REPORTED;OVERALL_DIRTY_WORKTREE_RETAINED
G3S3R_PROXY=DEFAULT_CURL_FAILED_LOCALHOST_BYPASS_HTTP_200
G3S3R_INTERNAL_DB_CRASH_RECOVERY=OBSERVED_TWO_MARKERS_NO_INNODB_FATAL
G3S3R_WOO_VERSION=11_1_2_ACTIVE
G3S3R_STRIPE_VERSION=11_1_0_INACTIVE
G3S3R_ORDER_PRODUCT=1113_VIRTUAL_USD_39_99
G3S4_OWNER_TEST_MODE_AUTHORIZATION=APPROVED_ONE_ROUND_TEST_ONLY
G3S4_OWNER_AUTH_RECORD=docs/OWNER_AUTHORIZATION_G3S4_STRIPE_TEST_ONLY_2026-10-16.md
G3S4_STRIPE_TEST_CONNECT=NOT_YET_STARTED
G3S4_TEST_PAYMENT_REFUND_WEBHOOK=NOT_YET_STARTED
G3S4_PREWRITE_FRESH_BACKUP=NOT_YET_PROVEN
G3S4_LIVE_PAYMENT_PERMISSION=NO
G3S4_FRESH_RECOVERY_POINT=NOT_YET_CREATED
G3S3R_ALLOWED_RUNTIME_START=CONDITIONAL_DB_WP_WPCLI_EXISTING_IDS_ONLY
SOURCE_BASELINE_PREFLIGHT=PASS
TEMPLATE_RESEARCH_QUALITY_BAR=OWNER_APPROVED
TEMPLATE_RESEARCH_CONTRACT=MANDATORY
MAGAZINE_WEB_VIEWER_DIRECTION=CONFIRMED_MAGAZINE_WEB_VIEWER
HOMEPAGE_FOCUSLY=AUTHORIZED_PUBLIC_VISUAL_REFERENCE
HOMEPAGE_HIGH_FIDELITY_REIMPLEMENTATION=AUTHORIZED_AFTER_D1_REVIEWER_PASS
HOMEPAGE_IMPLEMENTATION_STATUS=OWNER_ACCEPTED_WITH_RESERVED_CORE_ENTRY
D2_DESIGN_TIME_IMAGE_GENERATION=AUTHORIZED_QUALITY_FIRST
D2_ARTIFICIAL_LOW_IMAGEGEN_CAP=NONE
D2_TECHNICAL_REVIEW=PASS
D2_VISUAL_FIDELITY_REVIEW=PASS
D2_VISUAL_REVIEW_TRANSPORT=OWNER_MANUAL_IMAGE_UPLOAD
D2R1_OWNER_VISUAL_RELAY=FULFILLED
D2R2_REVIEWER_DECISION=PASS_STATIC_VISUAL_AND_TECHNICAL
D2R3_MOTION_DIAGNOSTIC=PASS
D2R3_ROOT_CAUSE=MOTION_RUNNING_BUT_NOT_PERCEPTIBLE
D2R4_AUTOMATED_REVIEW=PASS
D2R4_OWNER_LIVE_MOTION=PASS_OWNER_REPORTED
OWNER_RUNTIME_MOTION=PASS
OWNER_HOMEPAGE_VISUAL_FREEZE=PASS_WITH_CORE_ENTRY_RESERVED
D2_FORMAL_VISUAL_DECISION=PASS_G3CR6R3D2R2
G3CR6R3C_RESEARCH_STATUS=PARTIAL_CORE_AHA_RESEARCH_PASS_P1_P12_PENDING
CURRENT_UPLOAD_PREVIEW=KEEP_AS_IS
PREVIEW_INTERACTION_CHANGE=HOLD
CORE_AHA_INTERACTION_DIRECTION=REVIEWER_RECOMMENDS_PHOTO_TO_ISSUE_MORPH
CORE_AHA_EXACT_PRESENTATION=PHOTO_TO_COVER_TO_FIRST_SPREAD
CORE_AHA_RESEARCH=PASS
CORE_AHA_RESEARCH_CANDIDATES=82
CORE_AHA_SOURCE_ECOSYSTEMS=8
CORE_AHA_SATURATION=PASS
CORE_AHA_OWNER_SELECTION=PENDING
MAGAZINE_P1_P12_VISUAL_SYSTEM=UNRESOLVED_RESEARCH_AGAIN
PRIOR_G3CR6R3C_SATURATION=SUPERSEDED_FOR_INTERACTION_AND_P1_P12
MAGAZINE_WEB_PAGE_MOTION_MODE=UNRESOLVED
OWNER_VISUAL_FREEZE=PASS_CURRENT_MVP_FRONTEND
REAL_MONEY_TRANSACTION=UNVERIFIED
REAL_CUSTOMER_ACQUISITION=UNVERIFIED
REPEATABILITY=UNKNOWN
ECONOMICS=UNKNOWN
CUSTOMER_FLOW=HOMEPAGE_FREE_PREVIEW_CORE_FUNCTION_SUBMIT_PAY_GENERATE_VIEW
CORE_FUNCTION_PAGE=REQUIRED_PREPAYMENT_FULL_INTAKE_SURFACE
PREPAYMENT_FULL_INTAKE=OWNER_APPROVED
PREPAYMENT_DRAFT_STORAGE=REQUIRED_TEMPORARY_SERVER_DRAFT
PREPAYMENT_DRAFT_TTL=UNRESOLVED_IMPLEMENTATION_DETAIL
PAYMENT_AFTER_COMPLETE_INTAKE=YES
GENERATION_ONLY_AFTER_PAID_ENTITLEMENT=YES
FRONTEND_THREE_SURFACES=AUTHORIZED
HOMEPAGE_ENTRY_SURFACE=OWNER_PASS_FROZEN
CORE_FUNCTION_ONBOARDING_SURFACE=OWNER_PASS_FROZEN
POSTPAY_GENERATION_STATUS_SURFACE=PRODUCT_COMPONENT_STATUS_QA_PAGE_DEMOTED
P1_P12_VISUAL_WORK=DEFERRED_UNTIL_FRONTEND_THREE_SURFACES_CLOSE
G3CR7_SOURCE_CANDIDATE=REFERENCE_ONLY_NONAUTHORITATIVE
G3CR7_REFERENCE_PROTOTYPE_SOURCE_HEAD=0603706ca0441fb1cb65ff716f47f7a919e2e4f3
G3CR7_ACCEPTED_REPRODUCTION_BASELINE=e71f94377d341a88ba388f2c5da153e7cd6ee8b8
G3CR7_PAYMENT_TRUTH_REVIEW=INVALIDATED_ROLE_SEPARATION
G3CR7_PREVIEW_STYLE_HANDOFF=INVALIDATED_ROLE_SEPARATION
G3CR7_RUNTIME_VISUAL=UNVERIFIED
G3CR7_OWNER_VISUAL=PASS_ON_2026_10_15_LATEST_VISUAL
G3CR7R1_EXECUTOR_HEAD=88f45f5d712e3c1fe26f4386628703716b8eca3e
G3CR7R1_REVIEW=RETURN_EVIDENCE_INTEGRATION
G3CR7R1_CLEAN_SOURCE_DIFF=RETURN
G3CR7R1_WOO_ORDER_RECEIVED_POSITIVE=RETURN
G3CR7R1R1_EXECUTOR_RETURN=STALE_LOCAL_REF_RUNTIME_UNAVAILABLE
G3CR7R1R1_AUTHORITATIVE_PR_DRIFT=NO
G3CR7R1R1_EXECUTOR_STALE_REF=97aceb4a1a9990f2e203e90de8bd5965202d63b8
G3CR7R1R1_RECONCILED_PR_HEAD=c01843de4fb8bc139030930ad12caeb9ebbcd2b3
G3CR7R1R1_RUNTIME_WEB=UNAVAILABLE_EXECUTOR_REPORTED
G3CR7R1R2_EXECUTOR_HEAD=c0a1f2aab3913c96df7d2382f17ebfeabbdfae1c
G3CR7R1R2_SOURCE_CLEANUP=PASS
G3CR7R1R2_RUNTIME_RECONCILIATION=PASS_PROXY_INTERCEPTION_NO_RUNTIME_MUTATION
G3CR7R1R2_WOO_ORDER_RECEIVED=PASS
G3CR7_FORMAL_REVIEWER_DECISION=PASS
G3CR7_V1_OLD_CHECKPOINT=SUPERSEDED_BY_OWNER_PASS_2026_10_15
PR64_MERGEABILITY=DIRTY_DEFERRED_TO_PREMERGE_RECONCILIATION
G3CR7V1_VISUAL_REFINEMENT=AUTHORIZED
G3CR7V1_HOMEPAGE_TARGET=FREE_PREVIEW_TO_CORE_ENTRY
G3CR7V1_FUNCTIONAL_BEHAVIOR=FROZEN
G3CR7V1_EXECUTOR_HEAD=806907177ba48ef2ed11310e36f4cca0e209b421
G3CR7V1_REVIEWER_VISUAL=SUPERSEDED_BY_OWNER_RETURN_V2
G3CR7V1_1440=PASS
G3CR7V1_375=PASS
G3CR7V2A_STYLE_AUDITION=SUPERSEDED_BY_OWNER_DIRECT_SELECTION
G3CR7V2A_STYLE_A=NOT_REQUIRED
G3CR7V2A_STYLE_B=NOT_REQUIRED
G3CR7V2A_STYLE_C=OWNER_SELECTED_STRIPE_SOFT_TECH
G3CR7V2A_OWNER_CURRENT_PREFERENCE=STRIPE_SOFT_TECH
G3CR7V2A_FINAL_STYLE_LOCK=STRIPE_SOFT_TECH
G3CR7V2A_RUNTIME_MUTATION=0
G3CR7V2A_SVG_HUMAN_PLACEHOLDERS=FORBIDDEN
G3CR7V2_IMPLEMENTATION=AUTHORIZED
G3CR7V2_STYLE=STRIPE_SOFT_TECH
G3CR7V2_LOCAL_RUNTIME_CANDIDATE_MUST_REMAIN_MOUNTED=YES
G3CR7V2_DESIGN_MD=MANDATORY
G3CR7V2_DESIGN_MD_SOURCE_BLOB=589bd23baeb1344444f087043c060afd6239371f
G3CR7V2_DESIGN_MD_PROJECT_COPY=docs/design-references/stripe/DESIGN.md
G3CR7V2_DESIGN_ADAPTER=docs/design-references/stripe/PROJECT_ADAPTER.md
G3CR7V2_PREFLIGHT_RETURN=OVERRULED_FALSE_POSITIVE
G3CR7V2_ORDER_1131_ROUTE=INCONCLUSIVE_ACCESS_CONTEXT
G3CR7V2_FROZEN_PHP_JS_BLOBS=UNCHANGED_FROM_G3CR7R1R2
G3CR7V2_PAYMENT_TRUTH_REUSE=G3CR7R1R2_ACCEPTED
G3CR7V2R1_EXECUTOR_HEAD=18ab6b0e6d18d973bd4cc9376cec97b6fb89b830
G3CR7V2R1_REVIEWER_VISUAL=PASS
G3CR7V2R1_RUNTIME_VISUAL_ASSETS=PASS
G3CR7V2R1_RUNTIME_MAIN_PLUGIN=RETURN_IDENTITY_MISMATCH
G3CR7V2R1_OWNER_VISUAL=BLOCKED_UNTIL_RUNTIME_ALIGNMENT
G3CR7V2R1R1_GATE=SUPERSEDED_BEFORE_EXECUTION
G3CR7V2R2_OWNER_PRIMARY=#713F5D
G3CR7V2R2_OWNER_PRIMARY_DEEP=#5B314B
G3CR7V2R2_APPLICATION_BACKGROUND=#F7F8FB
G3CR7V2R2_DECORATIVE_MESH=REMOVE
G3CR7V2R2_REPLACEMENT_DECORATION=NONE
G3CR7V2R2_LAYOUT_STRUCTURE=FROZEN
G3CR7V2R2_CONTENT=FROZEN
G3CR7V2R2_EXECUTOR_HEAD=daff4101080d71aa0aa958986096d14975339deb
G3CR7V2R2_REVIEWER_DECISION=PASS
G3CR7V2R2_RUNTIME_IDENTITY=PASS
G3CR7V2R2_MESH_REMOVAL=PASS
G3CR7V2R2_BRAND_PALETTE=PASS
G3CR7V2R2_OLD_OWNER_CHECKPOINT=SUPERSEDED_BY_OWNER_PASS_2026_10_15
G3CR7V2R2_LATO_EXTERNAL_FONT_FALLBACK=NON_BLOCKING
G3CR7V2R3_OWNER_VISUAL=RETURN
G3CR7V2R3_HOMEPAGE_LIVE_STYLE=OLD_STYLE_OWNER_VISIBLE
G3CR7V2R3_INTAKE_SCALE=TOO_SMALL_TOO_SPARSE
G3CR7V2R3_STATUS_STANDALONE_PAGE=QA_ONLY_NOT_PRODUCT_SURFACE
G3CR7V2R3_STATUS_PRODUCT_ROLE=ORDER_WORKSPACE_COMPONENT
G3CR7V2R3_SAAS_STRUCTURE=KEEP
G3CR7V2R3_MULBERRY_PALETTE=KEEP
G3CR7V2R3_EXECUTOR_HEAD=43ebf7bb732e9e3be8d547364ca7b018f7f505f8
G3CR7V2R3_REVIEWER_DECISION=PASS
G3CR7V2R3_STYLE_DELIVERY=PASS_FILEMTIME_CACHE_BUST
G3CR7V2R3_INTAKE_SCALE=PASS
G3CR7V2R3_STATUS_STANDALONE_PAGE=QA_ONLY_NOT_PRODUCT_SURFACE
G3CR7V2R3_OWNER_HOME_INTAKE_VISUAL=RETURN
G3CR7V2R4_OLD_OWNER_RETURN=SUPERSEDED_BY_OWNER_PASS_2026_10_15
G3CR7V2R4_PRIMARY_DESKTOP_WIDTH=2048
G3CR7V2R4_PLACEHOLDER_ART=REMOVE_ALL_FAKE_PHOTO_ART
G3CR7V2R4_PLACEHOLDER_EMPTY_FRAME=YES
G3CR7V2R4_FEATURE_BG=#F3EEF1
G3CR7V2R4_CTA_ACTION_ONLY=YES
G3CR7V2R4_CTA_PRICE_META_SEPARATE=YES
G3CR7V2R4_INTAKE_WIDESCREEN=SCALE_UP
G3CR7V2R4_STATUS=QA_ONLY_NOT_PRODUCT_SURFACE
G3CR7V2R4_FINAL_PR_HEAD=c90e6f93803ad861745cd476106e00d01c68debb
G3CR7V2R4_OWNER_FINAL_VISUAL=PASS
G3CR7V2R4_FRONTEND_VISUAL_FREEZE=YES
G3CR7V2R4_NEXT_LAYER=BACKEND_FLOW_COMPLETION
G3CR7_FRONTEND_OWNER_PASS_DATE=2026-10-15
G3CR7_FRONTEND_OWNER_ACCEPTED_CANDIDATE=c90e6f93803ad861745cd476106e00d01c68debb
G3CR7_FRONTEND_OWNER_VISUAL_FREEZE=YES
G3CR7_LATEST_EXECUTOR_TECHNICAL_REVIEW=PENDING_INDEPENDENT_REVIEW
G3CR7_PR64=OPEN_UNMERGED_MERGEABLE_FALSE
G3CR7_STATUS_STANDALONE=QA_ONLY
G3CR7V1_OWNER_VISUAL=RETURN
COMMERCIAL_STATE=LOW_COST_VALIDATION_NOT_SCALE
G4_LIVE_PAYPAL=HOLD_NOT_AUTHORIZED
PAYMENT_TARGET_PROVIDER=STRIPE
STRIPE_MERCHANT_ACCOUNT_REGION=UNKNOWN
STRIPE_ACCOUNT_EXISTS=UNKNOWN_UNVERIFIED
STRIPE_TEST_GATEWAY_INTEGRATION=PENDING
STRIPE_LIVE_COLLECT_AND_PAYOUT=HOLD_UNVERIFIED
PAYPAL_RETIREMENT=OWNER_CONDITIONALLY_APPROVED_AFTER_STRIPE_END_TO_END_PASS
PAYPAL_RETIREMENT_NOW=NOT_AUTHORIZED
PAYPAL_DECOMMISSION_GATE=FUTURE_SEPARATE_REVIEWED_GATE
PAYPAL_HISTORICAL_RECORDS=RETAIN
PAYPAL_CURRENT_SANDBOX_EVIDENCE=RETAIN
FRONTEND_VISUAL_FREEZE=PASS_KEEP
STRIPE_READINESS_GATE=G3S0_PASS_LIMITED_READONLY
G3S0_OWNER_RELAY_EVIDENCE_INDEX=docs/evidence/g3s0/OWNER_RELAY_AND_REVIEW_COVERAGE_2026-10-15.md
NEXT_REVIEWER_BOOTSTRAP=docs/NEXT_REVIEWER_BOOTSTRAP_2026-10-15.md
G3S0_REVIEWER_DECISION=PASS
G3S0_PASS_SCOPE=READINESS_CLASSIFICATION_ONLY
G3S0_EXECUTOR_REPORT_PROVENANCE=OWNER_RELAY_NO_DURABLE_EXECUTOR_EVIDENCE
G3S0_LOCAL_RUNTIME=STOPPED_EXECUTOR_REPORTED_NOT_DIRECT_REVIEWER_READBACK
G3S0_WOO_PLUGIN_INVENTORY=UNKNOWN_DEFER_G3S1
G3S0_STRIPE_MERCHANT_AND_PAYOUT=UNKNOWN_OWNER_CHECKPOINT_LATER
G3S0_HTTPS_TEST_CALLBACK=NOT_PREPARED
G3S0_MAIN_SOURCE_FRESHNESS=PROJECT_SCOPED_NO_NEW_APPLICATION_SOURCE_DIFF
G3S1_RUNTIME_START=AUTHORIZED_EXISTING_CONTAINERS_ONLY
G3S1_STRIPE_PLUGIN_STAGE=CONDITIONAL_OFFICIAL_INACTIVE_ONLY
G3S1_STRIPE_PROVIDER_ACTIONS=0
G3S1_PAYPAL_REMOVAL=0
G3S1_ATTEMPT_1_REVIEWER=RETURN_GITHUB_PLUGIN_TRANSPORT_CLOSED
G3S1_ATTEMPT_1_EXECUTOR_EVIDENCE=OWNER_RELAY_ONLY_NO_HOST_NATIVE_EVIDENCE
G3S1_ATTEMPT_1_REPORTED_G3C_CONTAINERS=4_UNVERIFIED_VS_G3S0_3
G3S1_RUNTIME_STAGING=PARTIAL_DB_STARTED_EXECUTOR_REPORTED
G3S1_ATTEMPT_2_REVIEWER=RETURN_LOCAL_WORDPRESS_START_BLOCKED_BY_EXECUTION_POLICY
G3S1_ATTEMPT_2_EVIDENCE=PR64_715be642_EXECUTOR_PARTIAL_PREFLIGHT
G3S1_ATTEMPT_2_4TH_SERVICE=WPCLI_CONFIRMED_IN_PR_COMPOSE_SOURCE
G3S1_ATTEMPT_2_DB=RUNNING_HEALTHY_EXECUTOR_READBACK_NOT_REVIEWER_HOST_DIRECT
G3S1_ATTEMPT_2_WORDPRESS_MAILPIT_WPCLI=STOPPED_EXECUTOR_READBACK
G3S1_WOO_PLUGIN_INVENTORY=UNKNOWN_RUNTIME_NOT_READY
G3S1_BACKUP=NOT_CREATED
G3S1_OFFICIAL_STRIPE_INACTIVE_INSTALL=NOT_DONE
G3S1_RESUME_STAGING=ON_HOLD_PENDING_G3S1D_REVIEW
OWNER_G3C_LOCAL_RECOVERY_REQUEST=YES_CONDITIONAL_PRESERVE_DATA
OWNER_CLEANUP_CAUSE=UNVERIFIED_CLEANUP_REPORTED_ONLY
G3S1D_MISSING_RESOURCE_DIAG=READ_ONLY_CURRENT
G3S1D_POLICY_BYPASS=FORBIDDEN
CURRENT_GATE=G3S4_STRIPE_TEST_ONLY_PAYMENT_READINESS_AND_CYCLE_OWNER_AUTHORIZED_PREFLIGHT_PENDING
```

## SYSTEM_MAP

- CMS/storefront: WordPress 7.1.1 + Blocksy 2.1.57 + Gutenberg.
- Commerce/order: WooCommerce 11.1.2, canonical.
- Current local G3C runtime: project-isolated Docker/MariaDB/Mailpit; retained for Owner/Reviewer frontend review.
- Current local site: `http://127.0.0.1:8189/`.
- Public *static* original-frontend export: `https://birthday-magazine-original.netlify.app/` — visual restoration OWNER_REPORTED; no WordPress/WooCommerce/DB/webhook/paid generation behind this Netlify domain.
- Current wp-admin: `http://127.0.0.1:8189/wp-admin/`.
- Product: Woo product 1113, virtual, USD 39.99.
- Free Preview: project-local frontend component; its optional selected photo remains browser-local; no Preview server photo upload and no model request.
- Core function page: separate pre-payment full-intake surface; current implementation keeps answers/photos in browser memory and hands off only the Woo product to checkout. Durable temporary server draft persistence for the 12–25 photos + structured answers is REQUIRED NEXT and is not yet implemented.
- Account/private workspace: checkout creates/attaches authenticated customer + Woo order ownership; successful payment adopts the exact submitted pre-payment intake snapshot into that order/workspace.
- Payment baseline: official WooCommerce PayPal Payments; Sandbox proof accepted. Live/real-money not proven.
- Paid generation: exact production provider/runtime remains UNKNOWN.
- Production deployment/storage/private final delivery: UNKNOWN / not yet proven.
- Shared VPS dependency: NONE accepted for current Gate.

## CURRENT_ACCEPTED_STATE

- **2026-10-16 G3S4 explicit Owner authorization:** Owner responds `授权通过` directly to Reviewer request for **only Stripe TEST environment connection, synthetic payments and TEST refunds**. Authorization is recorded in `docs/OWNER_AUTHORIZATION_G3S4_STRIPE_TEST_ONLY_2026-10-16.md`; valid once for current G3S4 Gate only, no LIVE funds, bank/payout action, production deploy, PayPal removal or PR merge. **Not yet executed**; mandatory qualified recovery and source preflight remains unsatisfied until Executor proves it.

- **Latest formal Reviewer decision G3S3R PASS (bounded, 2026-10-16):** exact PR #64 single Evidence commit `1b2e3c4e0b7c3c2f4961c991a2626f341dec5b7c` reviewed. Executor restarted ONLY original G3C DB, WordPress, WP-CLI once each by existing ID with native exit 0; DB healthy, loopback HTTP200 on proxy bypass. Woo 11.1.2 active, Stripe 11.1.0 installed inactive, virtual product #1113 USD39.99, one existing owned Woo order checked. Mailpit stayed stopped; no Stripe/PayPal/checkout/provider/write or source mutation. Source checkout remains locally stale/dirty, not production-eligible by inference. See `docs/REVIEWER_DECISION_G3S3R_PASS_LOCAL_RUNTIME_RECOVERY_2026-10-16.md`.

- **2026-10-16 G3S3 Reviewer RETURN:** fresh Owner-Windows Executor evidence PR #64 `2eb033658ad0ed04dacfe3a0f2b26101ab4697e3` confirms all four named G3C containers stopped (DB/wpcli exit 137, root cause unknown), local checkout head `f50cc974...` behind current PR and dirty (three source edits + 17 tracked screenshot deletions). Current Woo/Stripe settings could not be freshly read. No runtime/code/payment write performed. Evidence commit added **only one Markdown file**; see `docs/REVIEWER_DECISION_G3S3_RETURN_PREFLIGHT_DRIFT_2026-10-16.md`.

- **2026-10-16 Owner milestone:** Stripe application review approved OWNER_REPORTED, not independent Stripe account-status verification; actual country/entity, charges enabled, payouts and payout-bank compatibility UNKNOWN. Prior 'review issues outstanding' Owner statement superseded for approval result only. See `docs/OWNER_UPDATE_G3S3_STRIPE_APPROVED_NETLIFY_STATIC_2026-10-16.md`.
- **Public site:** original WordPress frontend exported to Netlify and visual restoration Owner accepted. Static marketing/preview site != working WordPress/Woo checkout, uploaded draft, authenticated customer workspace or signed callback. Public external anonymous/static-assets check not independently inspected.

- **Owner UI visual acceptance 2026-10-15:** homepage / Free Preview / core five-step intake are now visually accepted and frozen for this MVP stage at PR #64 head `c90e6f93803ad861745cd476106e00d01c68debb`. Standalone status fixture remains QA-only. This Owner decision is distinct from independent Reviewer acceptance of latest branch-only source/evidence and does not authorize merge, backend readiness, live payment, P1-P12 final design or production deployment. See `docs/OWNER_DECISION_G3CR7_FRONTEND_VISUAL_ACCEPTANCE_2026-10-15.md`.

- **Owner flow correction 2026-10-04:** canonical flow is **Homepage -> Free Preview -> Core function page -> full intake -> Submit -> Payment -> automatic generation -> complete result**. The free Preview remains browser-local/zero-model; the separate core function page may upload/store the complete 12–25 photo + answer draft before payment. Payment still gates all production generation. This supersedes the earlier “paid intake after checkout” wording.

- G2BR3: real-AI structured content + deterministic 12-page PDF Solution Proof PASS.
- G3A: WordPress/WooCommerce commerce/account/private-workspace loop PASS.
- G3B/G3BR1: bounded PayPal Sandbox capture/entitlement/refund/revocation/cleanup PASS.
- G3CR2R3: Blocksy Wedding Gutenberg + Woo compatibility PASS.
- G3CR4/G3CR5: earlier frontend regressions PASS at their tested scope.
- G3CR6: RETURN because the visual direction was underexecuted.
- G3CR6R1: PASS; Warm Birthday Gift composition, Preview privacy, native Woo path, 375px behavior, and Owner editability accepted.
- G3CR6R3D1: RETURN only on fresh local-runtime readback; Focusly public desktop/375/motion evidence and 66 screenshots preserved as reusable evidence.
- G3CR6R3D1R2: PASS; fresh Home 858/runtime/theme/menu/CTA/Preview and read-only Woo route baseline closed at Executor commit `7a0a16cf0169980443f8bb760f7f9e919ff0d68c`.
- G3CR6R3D2: technical acceptance PASS; D2R1 direct visual review identified bounded quality gaps.
- G3CR6R3D2R2: PASS; Owner-uploaded R2 contact sheet was directly inspected. Samples/Selected Work, image diversity, mobile header and mobile rhythm now meet the Reviewer quality bar while accepted Hero/editorial panel/closing/Preview/Woo behavior remains preserved.
- G3CR6R3D2R4: **PASS** at latest PR #64 candidate `f50cc974ead65c9811f952cdf0a327c548f14efc`. Reviewer inspected the Owner-video calibration, dual-image Hero focus, expanded Hero travel, source correlation, 1440/375 multi-state QA and scoped rollback. Owner then reported that the homepage is now essentially satisfactory and authorized moving to the next stage. Homepage structure/visual/motion is frozen except for a future **bounded core-experience entry integration**.
- Owner Visual Checkpoint R2: resolved; Owner broadly accepts the overall composition but now explicitly rates the homepage around 7/10 for the intended quality bar, wants meaningful motion, wants the actual final magazine shown clearly, and rates the current upload-first Preview around 5/10.
- Owner editability at G3CR6R1 evidence scope: Administrator, edit Home, replace media, edit copy, reorder eight major Gutenberg Groups, edit Blocksy global style/palette; footer is editable WordPress block.
- PR #64 remains open/unmerged; latest accepted D1R2 evidence commit is `7a0a16cf0169980443f8bb760f7f9e919ff0d68c`. Project-scoped freshness, not whole-monorepo tip ancestry, controls execution.
- Fresh 2026-10-04 source-baseline closure: reconciliation anchor `83a8ad33ed70e2a391e4a4dacd71e0b812b15ef6` proved the bounded merge strategy and preserved the prior 7 G3C/G3CR6R1 branch commits/evidence. A later Executor correctly returned when unrelated `vpn-network-optimization/` commits moved repository `main`; Reviewer confirmed this was **not Birthday Magazine project drift** and corrected the preflight to project-scoped freshness. The approved PR #64 execution head must descend from the anchor and contain all current-main changes affecting `birthday-magazine-studio/**` or another path explicitly named by the Gate; unrelated monorepo commits do not block.

## CURRENT_GATE

**CURRENT G3S4 — explicitly Owner-authorized, NOT YET EXECUTED:** `docs/G3S4_STRIPE_TEST_ONLY_PAYMENT_READINESS_AND_CYCLE_2026-10-16.md`. Owner authorization: `docs/OWNER_AUTHORIZATION_G3S4_STRIPE_TEST_ONLY_2026-10-16.md`. The authorized maximum endpoint is Windows-local official Woo Stripe **TEST** mode connection (Owner personally handles authenticated login/consent), synthetic Woo product #1113 USD39.99 test checkout success/cancel/failure, authentic signed test webhook first/replay/invalid signature, TEST refund and entitlement revocation; finish with sanitized Evidence and mandatory Reviewer stop. No LIVE charge/refund/payout, production deployment or account-level merchant approval is inferred.

**PREREQUISITE / FAIL-CLOSED:** Fresh owner-machine, Docker, exact effective mounted source, dirty/untracked preservation, Woo/Stripe status, bank/merchant Test vs Live scope and account checkpoint; a newly created **consistent and verified restorable** DB + WordPress/files/uploads backup and rollback plan must all PASS before any test provider or Woo checkout write. If source drift, backup suitability, secret custody, provider mode, webhook delivery or permissions are unresolved, RETURN without improvising a larger Gate or repeating ambiguous test payments. Stripe CLI test forwarding is just a conditional candidate; secrets remain private.

**Latest accepted G3S3R PASS (bounded):** `docs/REVIEWER_DECISION_G3S3R_PASS_LOCAL_RUNTIME_RECOVERY_2026-10-16.md`, PR #64 evidence `1b2e3c4e0b7c3c2f4961c991a2626f341dec5b7c`. Original DB running healthy, WordPress HTTP 200 with loopback proxy bypass, WP-CLI running, Mailpit stopped; Woo 11.1.2 active, Stripe 11.1.0 installed **inactive**, product #1113 USD39.99; this is dated Executor-host readback, not a fresh G3S4 assertion. Dirty worktree (3 modified source files, 17 screenshot deletions, 13 untracked items) remains deliberately preserved. Historical DB isolated import is not fresh Test-write rollback.

**Separate blockers persist:** Server-side complete prepayment draft (12–25 photos+answers), authenticated order association, automatic PDF generation/private fulfillment, public live WordPress backend, real payouts and acquisition/validation remain pending. Static Netlify original frontend is not backend. PR #64 remains Open/unmerged; PayPal Sandbox evidence preserved, conditional retirement deferred.

## CRITICAL_CONSTRAINTS

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
WOO_COMMERCE_CANONICAL_ORDER_SYSTEM=YES
AUTHENTICATED_ACCOUNT_MVP=YES
GUEST_BEARER_PRIVATE_DELIVERY=NO
REAL_MONEY_ACTIONS=0
PAYPAL_ACTIONS_CURRENT_GATE=0
CHECKOUT_SUBMISSIONS_CURRENT_GATE=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PR_64_MERGE=0
G4_ACTIONS=0
HOMEPAGE_GLOBAL_REDESIGN=0
HOMEPAGE_ONLY_RESERVED_CHANGE=CORE_AHA_ENTRY_COMPATIBILITY_AFTER_REVIEW
```

Protected backend behavior for the current visual/research phase:
- Woo cart/order/checkout business logic;
- payment gateway;
- order state;
- account authorization;
- private-workspace ownership guard;
- entitlement/generation-job semantics;
- database schema;
- production provider.

## DEFAULT_EXECUTION_CHANNEL

- Canonical research/Gate authority is current GitHub `main`.
- Existing PR #64 branch is the **approved G3CR6R3C execution baseline** after source reconciliation; Executor should use the current branch head and current Gate/relay, not reconstruct project history.
- Freshness is **project-scoped**: current-main-only changes under `birthday-magazine-studio/**` (or another path explicitly named by this Gate) block execution; unrelated commits elsewhere in the shared monorepo do not.
- Research writes remain project-scoped to `birthday-magazine-studio/`; the 7 historical G3C/G3CR6R1 branch commits/evidence remain preserved.
- No new PR by default. No production/target-host execution in G3CR6R3C.

## CURRENT_ROLLBACK_STATUS

- G3S3R original existing-container startup succeeded, including internal MariaDB crash-recovery markers. Prior old backup files still exist but predate this startup, are NOT a fresh qualified Test-write rollback, and cannot guarantee bytewise reversible startup. G3S4 requires **new** selected database+WordPress/files/uploads backup with integrity and restore proof before test/provider writes. No routine reimport/restart required.
- **G3S3R conditional runtime start**: existing stopped DB/wpcli exit 137; startup may trigger internal crash recovery. Existing original volumes and prior manifest/SQL/WP archive remain protected. Pre-start snapshot/reference evidence and Owner approval are required by the Gate; **do not assert full bytewise rollback or run a blind restore**. If unsafe, remain stopped and RETURN.
- G3S3 is read-only, no mutation to undo. The next Test-only activation Gate must select/verify current restorable DB+WordPress files, exact rollback and original payment configuration before writing. Historical G3S1SV restore does not by itself qualify production rollback.
- Accepted rollback target: G3CR6R1 state.
- Prior G3CR6/G3CR6R1 rollback evidence must not be overwritten.
- G3CR6R2 is superseded before execution.
- G3CR6R3 must create its own scoped rollback point before mutation.
- Git history remains the source-code recovery baseline.
- PR #64 branch-only G3C/G3CR6R1 evidence is a preservation requirement during source-baseline repair; do not reset/drop it merely to match `main`.

## UNRESOLVED

- G3S3R recovered local existing WordPress/Woo runtime; former container-stop blocker FIXED. Exit-137 original cause still UNKNOWN (`OOMKilled=false`), not a current active runtime failure.
- Dirty/stale checkout remains intentionally intact with 3 source edits, 17 tracked screenshot deletions and 13 untracked items; Executor states runtime-relevant effective mounted source matches PR, but full source tree cleanliness/fingerprints for future source changes not independently documented. G3S4 must pin effective runtime source before writes; no forced sync.
- Stripe test-only account connection, signed webhook, test order capture/refund/replay and separate live payouts remain unverified, Owner TEST-only permission pending. Old private backup does not qualify as a new Test-write recovery point.
- G3S3 current Windows G3C runtime stopped; DB and WP-CLI exit 137 **cause UNKNOWN**, possible normal shutdown/kill/OOM must not be guessed; further diagnosis is pending.
- G3S3 local G3C dirty checkout `f50cc974...`, differs from PR #64 `2eb0336...`; 3 source edits/17 tracked screenshot deletions preserved, preview plugin differs, exact Test source correlation pending; do not forcibly sync.
- Stripe review APPROVED Owner-reported; merchant country/entity, payment/payout activation, compatible settlement bank, account restrictions and successful Test/Live charges not independently verified.
- Static Netlify original-frontend export accepted visually by Owner; publicly accessible asset/route/anonymous negative checks unverified. Netlify is not the WordPress production backend.
- Actual Stripe TEST-mode Woo payment, signed callbacks, cancellation, replay and refund/entitlement revocation NOT PROVEN.
- exact buyer segment within the broader US birthday-gift market;
- durable archive of Owner-reported Problem Evidence/VOC;
- real US customer payment at USD 39.99;
- repeatable acquisition;
- CAC/contribution economics;
- real per-order production AI/render/storage cost;
- unattended production provider/runtime and provider-spend idempotency;
- production storage/private delivery/recovery;
- production refund/cancellation policy;
- independent technical reconciliation of the latest Owner-accepted frontend branch candidate, distinct from completed Owner visual acceptance;
- G3S1 Codex execution-policy denial; exact cause/authorized compliant route still unknown;
- Owner-reported recent cleanup, with no currently proven deletion of the four G3C containers or the two named volumes;
- final P1–P12 magazine artifact design, still deferred; long-term source/branch packaging still requires separate PR #64 merge reconciliation.

## NEXT_STEP

1. **Execute G3S4 once on Owner Windows via Codex**: source/runtime and Test/Live account/mode verification read-only; establish *new* protected and verified restorable DB+WordPress/uploads snapshot **before** any Woo/Stripe Test-mode write. Owner signs in/consents only to TEST-mode Stripe account connection if necessary; never relay account keys in chat.
2. If preflight and backup PASS: enable only Test gateway, exercise bounded synthetic USD39.99 Woo successful/failed/cancelled checkout, authentic signed Test webhook/replay/invalid signature and TEST refund plus entitlement revocation; reconcile ambiguous outcomes rather than retry, retain evidence and STOP at Reviewer.
3. Reviewer separately accepts/returns G3S4. Only after PASS proceed to secure prepayment photo/question draft, paid automated generation and private PDF delivery, then public WordPress/Woo deployment and future real-money canary requiring new Owner decision.
4. Leave PR #64 open, preserve dirty source, original accepted frontend/Netlify, old backups, PayPal historical evidence and all LIVE provider settings. No production cutover now.

## OWNER_ACTION_REQUIRED

- **Test-mode action authorized:** Owner already approved this one G3S4 Test-only round and does not need to restate permission; relay both Gate and scoped Owner authorization document to Windows-local Codex.
- **Required Owner-only interactive checkpoint:** log in to the authentic Stripe account and grant **TEST-only** permission/consent if Codex reaches the safe authorized checkpoint. Record non-secret merchant account region/entity and Test/Live/payout restriction statuses only; never share API keys, password, 2FA, IDs or bank numbers in chat/GitHub.
- **No further consent for G3S3R**; its one-time startup authority is consumed. No current authorization for Live/production, purchases, public tunnel beyond explicitly reviewed TEST delivery, PayPal deletion or PR merge.

## EVIDENCE_POINTERS

0. `docs/OWNER_AUTHORIZATION_G3S4_STRIPE_TEST_ONLY_2026-10-16.md` — explicit Owner scope for one bounded TEST-only account link, synthetic checkout and TEST refund, with fail-closed guards.
0. `docs/G3S4_STRIPE_TEST_ONLY_PAYMENT_READINESS_AND_CYCLE_2026-10-16.md` — **current Gate, Owner-authorized, preflight pending**; exact Reviewer-to-Executor relay and bounded scope.
0. `docs/REVIEWER_DECISION_G3S3R_PASS_LOCAL_RUNTIME_RECOVERY_2026-10-16.md` — **CURRENT formal Reviewer PASS**, bounded local recovery and read-only Woo/Stripe state, with limitations.
0. `docs/G3S4_STRIPE_TEST_ONLY_PAYMENT_READINESS_AND_CYCLE_2026-10-16.md` — next combined **TEST-only** Gate, created but **not authorized** for provider/test order writes.
0. PR #64 `docs/evidence/g3s3r/G3S3R_EXISTING_LOCAL_RUNTIME_RECOVERY_2026-10-16.md` at `1b2e3c4e0b7c3c2f4961c991a2626f341dec5b7c` — single consolidated Evidence, existing DB/WP/WPCLI start and read-only diagnostics.
0. `docs/G3S3R_EXISTING_LOCAL_RUNTIME_RECOVERY_AND_SOURCE_RECONCILIATION_2026-10-16.md` — **CURRENT Gate**, conditional existing-container startup requires explicit Owner approval and safe preflight.
0. `docs/REVIEWER_DECISION_G3S3_RETURN_PREFLIGHT_DRIFT_2026-10-16.md` — formal Reviewer RETURN; PR #64 single-file Evidence independently checked.
0. PR #64 `docs/evidence/g3s3/G3S3_EXECUTOR_PREFLIGHT_2026-10-16.md` at `2eb033658ad0ed04dacfe3a0f2b26101ab4697e3` — G3S3 fresh Windows/Docker stopped-runtime and dirty source readback; no startup.
0. `docs/G3S3_LOCAL_WOOCOMMERCE_STRIPE_TEST_PREFLIGHT_2026-10-16.md` — ACTIVE Windows-local test-integration read-only Gate and complete Executor relay.
0. `docs/OWNER_UPDATE_G3S3_STRIPE_APPROVED_NETLIFY_STATIC_2026-10-16.md` — OWNER_REPORTED approved Stripe review and original static frontend site, with unresolved real provider/runtime capabilities.
0. `docs/OWNER_UPDATE_G3S2_STRIPE_ACCOUNT_REGISTERED_ISSUES_PENDING_2026-10-16.md` — latest Owner report: Stripe account now exists, issue unspecified, activation/KYC/payout not proven, no prompt.

Latest G3S2 read-only Reviewer PASS, awaiting Owner merchant eligibility decision / G3S1SV+SVE bounded PASS:
0. `docs/REVIEWER_DECISION_G3S2_PASS_READONLY_POLICY_PLAN_OWNER_ELIGIBILITY_PENDING_2026-10-16.md` — CURRENT formal Reviewer PASS for read-only policy research; actual merchant entity remains unknown
0. `docs/evidence/g3s2/G3S2_OFFICIAL_STRIPE_MERCHANT_ELIGIBILITY_AND_TEST_READINESS_READONLY_2026-10-16.md` — official Stripe HK/Mainland merchant eligibility, Wise payout restriction, Woo Test prerequisites
0. `docs/G3S2_STRIPE_ACCOUNT_ELIGIBILITY_AND_TEST_READINESS_READONLY_2026-10-15.md` — completed read-only Gate, no further execution delegated
0. `docs/REVIEWER_DECISION_G3S1SVE_AND_G3S1SV_PASS_INACTIVE_STRIPE_STAGING_2026-10-15.md` — Reviewer PASS for Evidence and inactive local Stripe staging; explicit limitations and deferred temp ZIP cleanup
0. PR #64 `docs/evidence/g3s1sv/G3S1SVE_EXECUTOR_EVIDENCE_RECOVERY_ONLY_2026-10-15.md` at `4cb0d527...` — reviewed retained Executor source evidence
0. `docs/G3S1SVE_EXECUTOR_EVIDENCE_RECOVERY_ONLY_2026-10-15.md` — completed Evidence-only Gate PASS
0. `docs/REVIEWER_DECISION_G3S1SV_RETURN_EVIDENCE_NOT_PERSISTED_2026-10-15.md` — historical RETURN now superseded by accepted PR Evidence
0. `docs/OWNER_RELAY_G3S1SV_STRIPE_INACTIVE_INSTALLED_EVIDENCE_PENDING_2026-10-15.md` — Owner-reported MariaDB exit 0, official Stripe 11.1.0 inactive, cleanup blocked, PR Evidence absent
0. `docs/G3S1SV_VERIFY_NEW_CHAT_DB_RESTORE_THEN_INACTIVE_STRIPE_2026-10-15.md` — previous execution Gate, install reported complete, Evidence missing
0. `docs/OWNER_RELAY_G3S1SV_NEW_CODEX_CHAT_DB_RESTORE_SUCCESS_2026-10-15.md` — Owner-reported native exit 0 and 58/58 tables in new Codex conversation, pending proof correlation
0. `docs/G3S1SH_CODEX_POLICY_HOLD_AND_RESUME_CRITERIA_2026-10-15.md` — previous HOLD based on former Codex executor denial; new Owner result prompts scoped review
0. `docs/REVIEWER_DECISION_G3S1SR_RETURN_EXECUTOR_POLICY_HOLD_2026-10-15.md` — latest Reviewer RETURN
0. PR #64 `docs/evidence/g3s1sr/G3S1SR_DB_RESTORE_DIAGNOSTIC_CONDITIONAL_STRIPE_INACTIVE_2026-10-15.md` at `d13b27...` — blocked-before-start evidence
0. `docs/G3S1SR_DB_RESTORE_DIAGNOSTIC_CONDITIONAL_STRIPE_INACTIVE_2026-10-15.md` — previous Gate RETURN; no longer an active execution request
0. `docs/REVIEWER_DECISION_G3S1S_RETURN_BACKUP_RESTORE_UNVERIFIED_2026-10-15.md` — latest formal Reviewer RETURN
0. PR #64 `docs/evidence/g3s1s/G3S1S_POST_RECOVERY_OFFICIAL_STRIPE_GATEWAY_INACTIVE_STAGING_2026-10-15.md` at `d0ae166...` — partial backup proof, SQL import exited 1
0. `docs/OWNER_DECISION_G3S_STRIPE_PASS_THEN_PAYPAL_RETIRE_2026-10-15.md` — advance Owner conditional authorization for later PayPal decommission, NOT current Gate
0. `docs/G3S1S_POST_RECOVERY_OFFICIAL_STRIPE_GATEWAY_INACTIVE_STAGING_2026-10-15.md` — previous Gate RETURN; Stripe not installed
0. `docs/REVIEWER_DECISION_G3S1R_PASS_LOCAL_RUNTIME_RESTORED_2026-10-15.md` — G3S1R formal PASS local runtime/Woo only
0. PR #64 `docs/evidence/g3s1/G3S1R_ONE_ROUND_WORDPRESS_LOCAL_RECOVERY_2026-10-15.md` at `ee031365...` — target-host readback
0. `docs/G3S1R_ONE_ROUND_WORDPRESS_LOCAL_RECOVERY_GATE_2026-10-15.md` — prior completed G3S1R recovery Gate
0. `docs/OWNER_DECISION_G3S1R_ONE_ROUND_LOCAL_RECOVERY_2026-10-15.md` — Owner fresh restart and conditional WordPress app reinstall request
0. `docs/G3S1P_OWNER_EXECUTION_PERMISSION_CHECKPOINT.md` — historical superseded Owner checkpoint
0. `docs/REVIEWER_DECISION_G3S1D_RETURN_POLICY_SOURCE_UNKNOWN_2026-10-15.md` — Reviewer RETURN (policy rule and approved route unknown)
0. PR #64 `docs/evidence/g3s1/G3S1D_READONLY_RUNTIME_POLICY_DIAGNOSTIC_2026-10-15.md` at `5903726a...` — Executor local diagnostic and missing historical screenshots
0. `docs/OWNER_DECISION_G3S1_LOCAL_RECOVERY_PRIORITY_2026-10-15.md` — Owner conditional restore intent; loss not proven
0. `docs/G3S1D_LOCAL_START_EXECUTION_POLICY_DIAGNOSTIC.md` — historical read-only diagnosis Gate
0. `docs/REVIEWER_DECISION_G3S1_RETURN_LOCAL_WORDPRESS_START_BLOCKED_2026-10-15.md` — latest Reviewer RETURN
0. PR #64 `docs/evidence/g3s1/EXECUTOR_PARTIAL_PREFLIGHT_2026-10-15.md` at `715be642...` — durable Executor summary, no independent Reviewer host readback
0. `docs/REVIEWER_DECISION_G3S1_RETURN_GITHUB_PLUGIN_TRANSPORT_CLOSED_2026-10-15.md` — formal Reviewer RETURN for initial G3S1 preflight; unchanged Gate
0. `docs/evidence/g3s1/OWNER_RELAY_GITHUB_TRANSPORT_RETURN_2026-10-15.md` — Owner-relayed Executor failure and independent Reviewer GitHub scope check
1. `docs/NEXT_REVIEWER_BOOTSTRAP_2026-10-15.md` — next Reviewer start-here
2. `docs/evidence/g3s0/OWNER_RELAY_AND_REVIEW_COVERAGE_2026-10-15.md` — preserved Executor relay / evidence limitations
3. `docs/REVIEWER_DECISION_G3S0_PASS_READINESS_WITH_RUNTIME_UNKNOWN_2026-10-15.md`
2. `docs/G3S1_LOCAL_STRIPE_GATEWAY_STAGING.md`
3. `docs/OWNER_DECISION_G3S_STRIPE_PRIMARY_PAYPAL_RETIREMENT_DEFERRED_2026-10-15.md`
4. `docs/G3S0_STRIPE_ACCOUNT_AND_GATEWAY_READINESS.md`


Current Stripe migration:
1. `docs/OWNER_DECISION_G3S_STRIPE_PRIMARY_PAYPAL_RETIREMENT_DEFERRED_2026-10-15.md`
2. `docs/G3S0_STRIPE_ACCOUNT_AND_GATEWAY_READINESS.md`
3. `docs/MVP_PRODUCT_CONTRACT.md` — payment-before-generation and pre-payment draft requirements
4. `docs/G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND.md` — historical PayPal provider-specific proof, not Stripe PASS


Current visual Owner acceptance 2026-10-15:
1. `docs/OWNER_DECISION_G3CR7_FRONTEND_VISUAL_ACCEPTANCE_2026-10-15.md`
2. PR #64 candidate `c90e6f93803ad861745cd476106e00d01c68debb`
3. `docs/evidence/g3cr7v2r4-preview-materials/README.md` — latest Executor candidate, pending independent technical acceptance
4. `docs/MVP_PRODUCT_CONTRACT.md` — frozen product contract


Current G3CR7:
1. `docs/REVIEWER_DECISION_G3CR7_SOURCE_PASS_RUNTIME_VISUAL_PENDING.md`
1. `docs/G3CR7_FRONTEND_SOURCE_CANDIDATE.md`
1. `docs/OWNER_DECISION_G3CR7_THREE_FRONTEND_SURFACES_2026-10-04.md`
2. `docs/G3CR7_THREE_FRONTEND_SURFACES.md`


Current product-flow authority:
1. `docs/OWNER_DECISION_PREPAYMENT_FULL_INTAKE_FLOW_2026-10-04.md`
2. `docs/MVP_PRODUCT_CONTRACT.md`

Core Aha current research:
1. `docs/REVIEWER_DECISION_G3CR6R3C_CORE_AHA_RESEARCH_PASS.md`
2. `docs/g3cr6r3c-core-aha/RESEARCH_LEDGER.md`
3. `docs/g3cr6r3c-core-aha/SOURCE_COVERAGE_AND_SATURATION.md`
4. `docs/g3cr6r3c-core-aha/SHORTLIST_AND_RECOMMENDATION.md`
5. `docs/g3cr6r3c-core-aha/REUSE_AND_IMPLEMENTATION_MAP.md`

Preserved parent-Gate / homepage state:
6. `docs/G3CR6R3C_TEMPLATE_SOURCE_DISCOVERY.md`
7. `docs/G3CR6R3C_TEMPLATE_DISCOVERY_RESEARCH_CONTRACT.md`
8. `docs/REVIEWER_DECISION_G3CR6R3D2R4_PASS_HOMEPAGE_FREEZE.md`

Core Aha research is PASS; Owner selection is pending. P1-P12 remains unresolved and was not researched in this round.
