# G3CR6R3D2R1 — Visual Review Bundle

> Transport revised by Owner on 2026-10-04:
> `OWNER_DECISION_G3CR6R3D2R1_MANUAL_VISUAL_RELAY_2026-10-04.md`

## Gate

~~~text
GATE_ID=G3CR6R3D2R1_VISUAL_REVIEW_BUNDLE
OBJECTIVE=Make the already-captured Focusly reference and D2 implementation visuals directly reviewable by the current Reviewer through one Owner-relayed JPEG contact sheet, without changing the application
MAX_ENDPOINT_THIS_ROUND=Compact side-by-side visual contact-sheet evidence + local-path handoff + PR evidence readback; no implementation or runtime mutation
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Existing D1 Focusly screenshots + existing D2 round2 screenshots + evidence-only contact sheet/manifest
APPLICABLE_CRITICAL_CONSTRAINTS=APPLICATION_MUTATION_0; WORDPRESS_MUTATION_0; RUNTIME_MUTATION_0; NEW_SCREENSHOT_CAPTURE_0; IMAGEGEN_0; PAYMENT_0; CHECKOUT_SUBMISSION_0; PR64_MERGE_0; PRODUCTION_DEPLOYMENT_0
PREFLIGHT=PR64 must contain candidate d2e31c532ace82c688554cad68e0464702268b24 and accepted screenshot evidence; do not regenerate the implementation or screenshots
REQUIRED_EVIDENCE=One compact labeled JPEG contact sheet; manifest identifying source screenshots + exact file size/hash/dimensions; exact local file path accessible to Owner; PR readback of evidence when committed
ACCEPTANCE_CRITERIA=See below
ROLLBACK_STATUS_OR_PLAN=Evidence-only Git commit; Git revert if needed; no application rollback
OWNER_ONLY_ACTIONS=Owner uploads the reported reviewer-visual-contact-sheet.jpg directly into the current ChatGPT conversation after Executor completion
REVIEWER_TO_EXECUTOR_RELAY=SEE_BELOW
EXECUTOR_TO_REVIEWER_RELAY=SEE_BELOW
~~~

Governance: vps-project-governance v0.2.6.

## Purpose

The D2 implementation has already passed technical Reviewer inspection. The remaining blocker is direct Reviewer visual inspection.

The Owner selected **manual image relay**. Do not use the previously proposed Base64/data-URI transport.

This Gate must not become a redesign or new screenshot round.

## Contact sheet requirements

Create **one** JPEG contact sheet from existing evidence, with clear labels burned into the image.

Required filename:

`reviewer-visual-contact-sheet.jpg`

Save it in:
1. the local project workspace under `birthday-magazine-studio/docs/evidence/g3cr6r3d2/`; and
2. PR #64 evidence when practical so the artifact remains durable.

Target:
- width approximately 1600–2200 px;
- enough JPEG quality to judge typography, image crop, hierarchy, whitespace and composition;
- prefer <= 2 MB if that preserves readability;
- no crop that removes meaningful layout; use contain/letterboxing where appropriate.

Include these comparisons using **only existing screenshots**:

1. Desktop Hero:
   - strongest accepted D1 Focusly desktop Hero/focus reference;
   - D2 `desktop-normal-hero.png`.

2. Desktop editorial split/panel:
   - strongest accepted D1 F2/F3/F4/F5 reference;
   - closest D2 corresponding section.

3. Desktop Selected Work / Samples:
   - accepted D1 Selected Work reference;
   - D2 `desktop-normal-samples.png`;
   - D2 `desktop-normal-sample-state-2.png` if space permits.

4. Desktop Closing:
   - accepted D1 closing reference;
   - D2 `desktop-normal-bms-closing.png`.

5. Mobile Hero:
   - accepted D1 mobile Hero/focus reference;
   - D2 `mobile-normal-hero.png`.

6. Mobile overall rhythm / key stacked sections:
   - accepted D1 mobile reference;
   - D2 `mobile-normal-full.png` or representative contained crop.

7. D2 fallbacks, smaller secondary row:
   - `desktop-reduced-hero.png`;
   - `desktop-no-js-hero.png`;
   - `mobile-reduced-hero.png`;
   - `mobile-no-js-hero.png`.

Labels must make it obvious which frame is **Focusly reference** and which is **Birthday Magazine D2**.

Do not claim pixel-identical reproduction.

## Manifest

Create:

`docs/evidence/g3cr6r3d2/reviewer-visual-contact-sheet-manifest.json`

Record:
- all source screenshot paths;
- contact-sheet pixel dimensions;
- JPEG byte size;
- SHA-256 of JPEG bytes;
- exact local absolute path of the Owner-accessible JPEG;
- PR path if committed;
- `NEW_SCREENSHOT_CAPTURE=0`;
- `APPLICATION_MUTATION=0`;
- `WORDPRESS_MUTATION=0`;
- `RUNTIME_MUTATION=0`;
- `IMAGEGEN_CALLS=0`.

Do **not** create:
- `reviewer-visual-contact-sheet.datauri.txt`;
- Base64 review files;
- ZIP packaging for Owner relay.

## Acceptance criteria

PASS_CANDIDATE requires:

1. No application/source/WordPress/runtime mutation.
2. No new Focusly crawl, implementation screenshot capture or image generation.
3. Contact sheet is derived only from already-submitted D1 and D2 screenshots.
4. Required comparison roles are clearly represented and labeled.
5. JPEG remains readable enough to judge composition, typography, image crop, spacing and desktop/mobile translation.
6. Manifest hash/size/dimensions match the actual JPEG.
7. Exact local Owner-accessible file path is reported.
8. PR #64 remains unmerged.
9. Executor stops at Reviewer and explicitly requests the manual Owner relay.

Formal D2 PASS remains blocked until Owner uploads the JPEG into the current ChatGPT conversation and Reviewer directly inspects it.

## Reviewer to Executor relay

Read only:
1. this Gate;
2. `docs/OWNER_DECISION_G3CR6R3D2R1_MANUAL_VISUAL_RELAY_2026-10-04.md`;
3. `docs/REVIEWER_DECISION_G3CR6R3D2_RETURN_VISUAL_EVIDENCE.md`;
4. existing D1 screenshot manifest/evidence;
5. existing D2 round2 screenshot manifest/evidence.

Do not read full project history.
Do not modify the application.
Do not create new design decisions.
Do not produce Base64/data-URI transport.

## Executor to Reviewer relay

~~~text
结果：PASS_CANDIDATE / RETURN_*
改动：仅新增 reviewer-visual-contact-sheet.jpg 与 manifest；应用/运行态未修改。
验证：说明 JPEG 尺寸/大小/哈希、来源截图数量、PR 路径和 Owner 可访问的本地绝对路径；NEW_SCREENSHOT_CAPTURE=0，IMAGEGEN_CALLS=0。
问题：NONE，或说明为什么联系表无法生成/保存。
回滚：仅证据文件 Git 可撤回；应用无需回滚。
请 Reviewer 检查：Owner 上传联系表后，检查 Focusly 对标相似度、桌面/移动质量并决定 D2 PASS / RETURN。
Owner 转交：请将本地 reviewer-visual-contact-sheet.jpg 直接上传到当前 ChatGPT 对话。
~~~
