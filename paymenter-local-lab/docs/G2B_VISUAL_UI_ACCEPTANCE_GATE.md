# G2B — Paymenter 简体中文用户界面验收 Gate
GATE_ID: PAYMENTER-G2B-LOCAL-ZH-HANS-VISUAL-ACCEPTANCE-20261017
STATUS: PARTIAL_G2B_R1_UI_UNVERIFIED / REVIEWER_PENDING
PARENT_G2_OBJECTIVE: docs/G2_SIMPLIFIED_CHINESE_UI_GATE.md
GOVERNANCE: entropy-student/spike.skill@main:vps-project-governance/VNEXT.md v0.2.7
BASELINE: G1 本机 Docker/登录 PASS；G2A 源码补丁、CLI/HTTP/仅 paymenter 重启持久性正式 PASS；PR #148 merged commit a5a5f119eedd4cd56bd6e8f7a94865c935ebd7a3。禁止重新执行 G1/G2A。
SOURCE_PATCH: localization/g2a/paymenter-zh-hans-v1.5.9.patch 与 paymenter-runtime-theme-overlay-v1.5.9.patch。运行版本 Paymenter v1.5.9 / ee729f7d99ac18942625b79f3f93d8d8b21255e8。实际本机 Docker Compose paymenter_local_lab；app 使用专属 Docker /app 命名卷；127.0.0.1:8187。

## OBJECTIVE / MAX_ENDPOINT / STOP
对已运行的用户前台和管理员后台进行**真实可视/交互验证**，识别错译/漏译及可能由 G2A 新本地化逻辑引入的显示故障；最小修复实际核实到的问题（如经 Reviewer 判断修复不涉及范围扩张），反馈界面是否达到了“常用功能完整简体中文”的使用目标。最大终点：`G2B_UI_PASS_CANDIDATE` 或精准 PARTIAL/RETURN；完成 STOP_AT_REVIEWER。不得宣称实测了未检查的二级页面、Stripe/插件、真实支付。

## REAL VIEW EVIDENCE PATH
- 路线一：真实 Owner Windows 本地 Codex 通过正常的、**已通过 URL 安全校验**的官方浏览器操作能力查看现有本机 `http://127.0.0.1:8187`。上轮 G2 浏览器技能曾要求停止；**不得绕过浏览器工具的停止要求**，不能通过其他浏览器自动化、Playwright、脚本注入浏览器等替代方式规避。若新一轮技能仍无法确认页面 URL 则停止所有 Computer Use，不是本机/应用报错。
- 路线二：Owner 自己打开本机站点，提供清晰、已去掉敏感输入和用户身份的截图或逐页可核对的人工观察。Reviewer 直接审阅截图及文字；可作为可视验收证据。不要求 Owner 安装工具、运行命令或录屏。
- 服务和 HTTP 200、未经认证的 302、CLI 翻译解析均不替代此 Gate 的实际界面/交互证据。

## TARGET_AND_SCOPE / CRITICAL_CONSTRAINTS
现有本机实例的匿名首页、登录/注册、商店/虚构商品及用户 dashboard、账户/订单/工单入口，以及后台仪表盘、产品/套餐编辑、用户、优惠券、订单、支付网关、设置关键表单。仅核查展示/导航/空状态/可返回动作；**不得点击真实下单、提交订单、发信、删除、支付、开启网关或安装扩展**。保持当前管理员、商品、套餐、数据库、Stripe/网关配置与容器不变。
敏感边界：只观察需验收的 UI，不收集、不输出管理员密码、Cookie、Token、密钥或内部日志；截图遮挡真实个人信息。不是生产准入审查。

## PREFLIGHT_AND_VALIDATION
1. 使用已验收现存 G1/G2A 事实，不重复部署、迁移或翻译补丁。只读确认实例仍是 localhost Paymenter，且没有重大源码/数据漂移。检查启用语言为 zh / 后台 zh_CN，界面原则上是简体中文。
2. **优先验证 Owner 截图中原先的问题**：后台 Dashboard/Revenue/Tickets/Services/Support 表格、左侧全部分组 Administration/Configuration/Extensions/System、Search、用户登录 Remember me/忘记密码、繁体词汇。
3. 选择高价值页面连续导航检查（禁止任何产生真实业务后果的提交）：匿名首页、登录、注册、商店及商品详情；用户仪表盘/账户设置；后台仪表盘、商品编辑/套餐、优惠券、用户、订单、支付网关和通用设置。记录每个实际见到的页面、英文或繁体残留、是否版式溢出/功能报错。
4. 特别关注 G2A diff 未覆盖的**部分选项**：ProductResource 的套餐 `One Time`、`Separated`、`Combined`、`Month`，以及 vendor/扩展层面的空状态、弹窗、按钮；这是已知可能残留，不需在无可视证据前先重写大量代码。
5. 功能回归：不重新注册或使用真实邮箱；能看见现有已登录 dashboard/admin 页并点击无副作用的标签/切换；无访问权限越界、403/500、错误空白屏、菜单异常。无需任何实际支付/订单。重启验证已由 G2A 执行，不再无理由重启容器。
6. 如果发现显著残留/功能异常：记录**页面 + 控件 + 实际文字 + 期望简体中文 + 非敏感截图**，分类为 cosmetic / functional / UNKNOWN。普通翻译文本修复按同一 Gate 内最小范围完成，并追加补丁/执行证据；凡涉及认证、权限、数据、支付、架构的缺陷停止并另开有界 Gate。
7. 每类页面至少有一个可复核证据（截图、Owner 观察 + 可归因页面信息）；未检查的页面明确 UNVERIFIED，且不能以截图上看不到英文推导整站翻译 100%。
8. 如果浏览器工具仍不可用，**不要退回 G1/G2A、不重建 Docker**：立即进入 Owner 人工视觉观察路径；当 Owner 没有给出截图时，保持 `G2B_AWAITING_OWNER_VISUAL_EVIDENCE`，只做非破坏性等待/Reviewer记录，不反复让 Codex 失败回报。

## REQUIRED_EVIDENCE / ACCEPTANCE
- 实际访问页面名单、用户/管理员身份边界、看到的简体中文标签、漏译/错译清单和处理状态、页面截图或具体人工观察；与截图对照的原始问题清单。
- 本机 scope 不变的基本只读回归（服务地址、用户/商品/套餐、订单/网关仍未因 UI 修改改变），不再次运行无关数据库迁移。
- `PASS_CANDIDATE` 仅当主要前后台常用路径（包含至少 dashboard、商品/套餐、优惠券、登录/用户区）有足够可复核证据且关键文案为简体中文、无阻塞性的交互问题；允许明确列出个别非关键文本残留并分类 PARTIAL。严重或关键路径漏译影响判断，RETURN 精准项目。
- 回滚原则：如果本 Gate 只做观察则 NONE；若小范围文案修正，仅回滚新改文件/补丁，保留 G2A 已验收结果和项目所有数据。

## OWNER_ONLY / REVIEWER_TO_EXECUTOR_RELAY
Owner 已授权现有本机试用系统的 UI 汉化和验收；用户自己提供截图仅是可选择的可视证据通路，并非必须手动排障。Owner 未授权真实交易、第三方服务接入、破坏性改动。
若由 Codex 执行，仅读本 Gate、当期 Handoff 接受事实和 G2A README；不重读历史治理或执行 Gate。仅在真正能确认浏览器网址且工具允许时操作；如果浏览器工具要求 STOP，立即停止，不寻找替代 Computer Use 途径，并请 Owner 通过正常浏览器提供最少必要非敏感截图（建议：后台概览、商品套餐编辑、优惠券、用户区/登录），交 Reviewer 评审。无需启动新的应用实例。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE_G2B_UI / PARTIAL_G2B_VISIBLE_LANGUAGE_GAPS / RETURN_具体问题 / G2B_AWAITING_OWNER_VISUAL_EVIDENCE
改动：观察范围、实际小修补丁（如有）、未触碰的数据/容器。
验证：真实可见页面和具体简体文案、页面间导航与功能边界。
问题：可定位的剩余英文/繁体及功能错误或未核查页面。
回滚：NONE（纯检查）或最小文案补丁恢复。
请 Reviewer 检查：视觉证据是否足以支持核心路径汉化。
Owner 转交：NONE / 最少 4 类页面非敏感截图（浏览器受限时）。


## 2026-10-17 Reviewer G2B first visual review — PARTIAL and next scoped fix
STATUS: PARTIAL_G2B_VISIBLE_LANGUAGE_GAPS / G2B_R1_MINIMAL_TEXT_FIX_AUTHORIZED_NOT_EXECUTED
OWNER_SUPPLIED_VISUAL_EVIDENCE: 4 original 2048×1028 screenshots supplied in chat; images remain in Owner conversation, **not** uploaded to public GitHub. Reviewer directly inspected:
1. Admin dashboard: left nav/sidebar Administration/Configuration and main Dashboard/Revenue/Tickets/Services/graph labels now Simplified Chinese. Residual widget title `Support`; empty state `暂无 ticket`. Other visible labels readable and layout not visibly broken.
2. Admin product **list** (not edit): page/title/search/actions/sidebar in simplified Chinese; group header `Category:` English and column `Slug` technical identifier. Do **not** change stored slug or product/category names; translate display labels only, e.g. `分类：`, `网址标识（Slug）`.
3. Admin **create coupon form** (not saved): inputs/labels/options/buttons in simplified Chinese; date placeholder renders `yyyy/mm/日`, a mixed-format browser/date-picker localization issue (not proof date value corrupt). Diagnose whether native browser UI or Filament; no vendor patch just to change a native input placeholder.
4. Admin **notification template list**: navigation/columns/buttons in simplified Chinese, but stored template `subject` values remain English: `New login detected`, `New invoice created`, `Invoice paid`, `Invoice payment failed`, `New order created`, `Service activated`, `Service suspended`, `Service terminated`, and a ticket reply template containing Blade variable expressions. Footer shows `Sponsor`, `Star us on GitHub`, `Documentation`; `API 密钥` label can be standardized. Do not modify runtime email subject/body or interpolation merely to make list display Chinese.

### Minimal correction within the same G2B Gate
- FIRST: widget `Support` => `客服支持`, `暂无 ticket` => `暂无工单`, using Filament compatible heading/empty state API and existing `lang/zh_CN.json` (these mappings already exist). Check title/empty state do not default back to English in actual runtime.
- SECOND: product list `Category:` => `分类：`, and `Slug` column label => `网址标识（Slug）` (or consistent term). Change only presentation, never database slug/category.
- THIRD: notification template **list display only** maps known **exact default English subjects** to readable Chinese. Unknown/custom subjects stay unchanged; leave `key`, `subject`, `body`, `in_app_title`, `in_app_body`, Blade placeholders and any outgoing email behavior/data unchanged. Use display-only formatter or accessor scoped to admin list (not application/domain model mutator). Dynamic ticket placeholder must remain original in stored content; if translation cannot safely avoid side effects, retain English and report the limitation.
- FOURTH: localize admin-footer informational link labels (preserve actual external link URLs, source attribution/branding and icons), optionally normalize `API 密钥` casing. Footer is cosmetic low priority.
- FIFTH: diagnose `yyyy/mm/日`. Only fix through an officially compatible date display setting with valid date parsing; preserve DB date semantics. If it comes from native browser locale, leave as nonblocking browser/UI limitation, no custom JS monkey patch / vendor edit.
- Additionally, if quick & safe, fix already identified product/plan display option labels `One Time`, `Month`, `Separated`, `Combined`, preserving option keys. Do not broadly reopen G2A translation coverage.
- Verify with scoped PHP lint/translation probes, app-only cache clearing/restart **only if required**, readback no data changes. Browser Computer Use prior STOP remains binding on that attempt: no substitute browser automation; re-review visible changes using Owner screenshots or regular supported tooling only when independently URL-safe. Do not claim full G2B PASS without authenticated user front and product/plan edit evidence.
- Only G2B-R1 **source/UI text** corrections and non-secret Evidence in a GitHub PR. G2A passed patch remains immutable historical baseline; create **incremental** follow-on patch for currently localized Paymenter v1.5.9 and clear reverse/backup steps, not a new 117-file rewrite.
- STOP_AT_REVIEWER with `PASS_CANDIDATE_G2B_R1_TEXT_FIX` / `PARTIAL_G2B_R1_UI_UNVERIFIED` / specific RETURN. If browser tool still unavailable, submit source/CLI verification without fabricating GUI coverage. Full G2B remains PARTIAL until separately reviewed.

### Later final visual evidence (minimum to close)
One authenticated **user dashboard** screenshot, one product **edit/plan options** screenshot, and reinspection of dashboard + notification list after R1 (or equivalent genuine browser observations); verify no navigation/interaction regression. Do not request screenshots of every admin screen when key representative views suffice.


### 2026-10-17 Executor G2B R1 source/CLI result — Reviewer pending
STATUS: PARTIAL_G2B_R1_UI_UNVERIFIED
PATCH: localization/g2b-r1/paymenter-g2b-r1-v1.5.9.patch (incremental six-file patch on the accepted G2A baseline; SHA-256 cb064cdfc63601f2f9e7f06287a96e4814f09fd182fe2bff7a24e5e397c43fa4).
FIXED: dashboard Support heading and empty state; product-list Category: group label and Slug presentation label; exact known notification subject display titles; footer Sponsor / Star us on GitHub / Documentation; One Time / Month / Separated / Combined option display text. Notification values only format the list state; stored subjects/bodies/variables and behavior are unchanged. Coupon date placeholder diagnosed as native HTML date input locale output; left untouched.
VERIFIED: three PHP files lint clean; both JSON catalogs valid (642 original keys unchanged, 16 additions each); 19 Laravel `zh_CN` translation probes pass; Blade view compilation succeeds; read-only DB counts and notification-template hash unchanged; patch applies and reverses cleanly; anonymous read-only local HTTP checks pass.
NOT VERIFIED: authenticated post-fix dashboard/product/notification UI and user area; no browser automation was used. Anonymous admin/dashboard redirects and CLI/HTTP checks are not visual acceptance. Native date placeholder and dynamic/custom notification titles remain documented limitations.
ROLLBACK: reverse only the R1 patch; see localization/g2b-r1/README.md. Preserve G2A patch and all named volumes/data.
NEXT: Reviewer visually rechecks the original screenshot areas; retain PARTIAL until required authenticated user dashboard, plan options and post-R1 dashboard/notification evidence are reviewed.
