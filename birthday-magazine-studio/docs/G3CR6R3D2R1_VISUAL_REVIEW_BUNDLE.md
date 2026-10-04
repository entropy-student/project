# G3CR6R3D2R1 — Visual Review Bundle

## Gate

~~~text
GATE_ID=G3CR6R3D2R1_VISUAL_REVIEW_BUNDLE
OBJECTIVE=Make the already-captured Focusly reference and D2 implementation visuals directly reviewable by the current Reviewer without changing the application
MAX_ENDPOINT_THIS_ROUND=Compact side-by-side visual contact-sheet evidence + submission readback; no implementation or runtime mutation
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Existing D1 Focusly screenshots + existing D2 round2 screenshots + evidence-only files
APPLICABLE_CRITICAL_CONSTRAINTS=APPLICATION_MUTATION_0; WORDPRESS_MUTATION_0; RUNTIME_MUTATION_0; IMAGEGEN_0; PAYMENT_0; CHECKOUT_SUBMISSION_0; PR64_MERGE_0; PRODUCTION_DEPLOYMENT_0
PREFLIGHT=PR64 must contain candidate d2e31c532ace82c688554cad68e0464702268b24 and accepted screenshot evidence; do not regenerate the implementation
REQUIRED_EVIDENCE=One compact contact-sheet JPEG encoded as a UTF-8 base64 data-URI text file; manifest identifying every source screenshot; exact file size/hash; PR readback
ACCEPTANCE_CRITERIA=See below
ROLLBACK_STATUS_OR_PLAN=Evidence-only Git commit; Git revert if needed
OWNER_ONLY_ACTIONS=NONE
REVIEWER_TO_EXECUTOR_RELAY=SEE_BELOW
EXECUTOR_TO_REVIEWER_RELAY=SEE_BELOW
~~~

Governance: vps-project-governance v0.2.6.

## Purpose

This Gate exists only because repository PNG binaries are not directly decodable through the current Reviewer GitHub interface. It must not become a redesign or new screenshot round.

## Contact sheet requirements

Create **one** JPEG contact sheet from existing evidence, with labels burned into the sheet.

Target final contact sheet:
- width: 1600–2000 px;
- JPEG quality: choose the smallest value that still preserves typography/layout reviewability, normally around 55–70;
- expected JPEG preferably <= 650 KB;
- no crop that removes meaningful layout; use contain/letterboxing where necessary.

Include these side-by-side comparisons from the existing evidence:

1. Desktop Hero:
   - D1 Focusly: `docs/evidence/g3cr6r3d1/screenshots/desktop-section-1-0.png` or the strongest accepted desktop Hero/focus reference frame
   - D2: `docs/evidence/g3cr6r3d2/round2/screenshots/desktop-normal-hero.png`

2. Desktop editorial split/panel:
   - D1 Focusly: strongest accepted F2/F3/F4/F5 reference screenshot already present in D1 evidence
   - D2: the closest corresponding D2 section screenshot

3. Desktop Selected Work / Samples:
   - D1 Focusly: accepted Selected Work reference state
   - D2: `desktop-normal-samples.png` and, if space permits, `desktop-normal-sample-state-2.png`

4. Desktop Closing:
   - D1 Focusly: accepted closing-contact reference state
   - D2: `desktop-normal-bms-closing.png`

5. Mobile Hero:
   - D1 Focusly: accepted mobile Hero/focus reference
   - D2: `mobile-normal-hero.png`

6. Mobile full/page rhythm or key stacked sections:
   - D1 Focusly: accepted mobile full/section evidence
   - D2: `mobile-normal-full.png` or a contained representative crop

7. D2 fallbacks, smaller secondary row:
   - `desktop-reduced-hero.png`
   - `desktop-no-js-hero.png`
   - `mobile-reduced-hero.png`
   - `mobile-no-js-hero.png`

Do not claim pixel-identical reproduction. The goal is to let Reviewer judge composition, hierarchy, rhythm, photography treatment, motion-state styling and mobile translation.

## UTF-8 review transport

After creating the JPEG, do **not** rely on the binary JPEG alone.

Create:

`docs/evidence/g3cr6r3d2/reviewer-visual-contact-sheet.datauri.txt`

Contents must be exactly one data URI:

~~~text
data:image/jpeg;base64,<BASE64_BYTES>
~~~

This text file must be small enough for the GitHub connector to read as UTF-8 in one or bounded reads.

Also create:

`docs/evidence/g3cr6r3d2/reviewer-visual-contact-sheet-manifest.json`

Record:
- source screenshot paths;
- contact-sheet pixel dimensions;
- JPEG byte size;
- SHA-256 of JPEG bytes;
- base64/data-URI text byte size;
- no new screenshot generation;
- no app/runtime mutation.

The binary contact-sheet JPEG may also be committed for normal human browsing, but the data-URI text file is the Reviewer-critical artifact.

## Acceptance criteria

PASS_CANDIDATE requires:

1. No application/source/WordPress/runtime mutation.
2. No new Focusly crawl, implementation screenshot capture or image generation.
3. Contact sheet is derived only from already-submitted D1 and D2 screenshots.
4. All required comparison roles are represented and clearly labeled.
5. Data-URI text file is readable through GitHub as UTF-8 and decodes to the declared JPEG hash.
6. Contact sheet preserves enough resolution to judge typography, image crop, hierarchy and spacing.
7. PR #64 remains unmerged.
8. Stop at Reviewer.

## Reviewer to Executor relay

Read only:
1. this Gate;
2. `docs/REVIEWER_DECISION_G3CR6R3D2_RETURN_VISUAL_EVIDENCE.md`;
3. existing D1 screenshot manifest/evidence;
4. existing D2 round2 screenshot manifest/evidence.

Do not read full project history.
Do not modify the application.
Do not create new design decisions.

## Executor to Reviewer relay

~~~text
结果：PASS_CANDIDATE / RETURN_*
改动：仅新增 Reviewer 可读的视觉对比联系表及 manifest。
验证：说明 data-URI 可读/可解码、JPEG 尺寸/哈希、来源截图数量；应用/运行态修改为 0。
问题：NONE，或说明为何无法在大小限制内生成可读联系表。
回滚：仅证据文件 Git 可撤回；应用无需回滚。
请 Reviewer 检查：Focusly 对标相似度、桌面/移动质量和是否可正式 PASS D2 进入 Owner 视觉确认。
Owner 转交：NONE
~~~
