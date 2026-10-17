# G2C — 恢复 Paymenter 原生多语言语义并修复审计详情运行时问题
GATE_ID: PAYMENTER-G2C-LOCALE-SEMANTICS-AND-AUDIT-RUNTIME-20261017
STATUS: EXECUTOR_CANDIDATE_G2C_LOCALE_AND_AUDIT_CLI / REVIEWER_PENDING; G2B_UI_REMAINS_PARTIAL
GOVERNANCE: entropy-student/spike.skill@main:vps-project-governance/VNEXT.md v0.2.7
RELEVANT_ACCEPTED_BASELINE: G1 本机 Docker/登录 PASS；G2A PR #148 主补丁已本机部署（仍是源码/CLI 范围 PASS）；G2B-R1 PR #149 增量补丁已本机部署（源码/CLI 范围 PASS）；完整 G2B 多页 UI 保持 PARTIAL。禁止因这个 Gate 重放 G1/G2A/R1。
TARGET: Owner 真正 Windows 11 本机；仅项目 Docker Compose paymenter_local_lab 中的 paymenter app 源码 /app（项目命名卷）及项目本地非秘密补丁。http://127.0.0.1:8187；DB MariaDB、Redis 与命名卷均保留。
OBJECTIVE: **不是**把所有语言页面强制变成中文，而是默认展示简体中文且**保留每个访客/登录用户原生语言选择**。修复 G2A 引入的后台固定 locale，以及另一个已从主补丁中直接确认的 audit view 函数参数缺失问题。避免把数据库中中文演示商品/网站品牌内容误判成语言切换失效。
MAX_ENDPOINT_THIS_ROUND: 仅修复 Paymenter 本地化源码/审计显示，生成可重放、可回滚的追加补丁，保持现有运行与业务数据。使用 source/CLI/可安全的只读 HTTP 验证；需要真实 UI 的证据与 Owner 截图结合审阅。 STOP_AT_REVIEWER；未经 Reviewer 验收不得宣称完整 G2B 或产品多语言 PASS。

## Reviewer 核实的根因（不可误读）
1. ORIGINAL Paymenter v1.5.9 `app/Http/Middleware/SetLocale.php` 从 `session('locale')` 取用户选定 locale，`app/Livewire/Components/LocaleSwitch.php` 校验 `settings.allowed_languages`、设置 session 并重定向。官方 `config/app.php` 提供 `fi => Suomi`、`zh => 中文` 等；芬兰语 `lang/fi/navigation.php` 本身含 `Koti`、`Kauppa`。原生切换流程存在。
2. OWNER_SCREENSHOTS 2026-10-17：切到 `Suomi` 后显示 `Koti / Kauppa / Näytä`，证明前台部分 `__()` UI 文案正确跟随芬兰语；但分类“演示产品（虚构）”、商品“云主机体验套餐（虚构）”、分类描述和品牌仍中文，因为它们是持久化的用户/管理员自填内容，原版主题用 `$category->name`、`$product->name`、`$category->description` 原样输出。**不**属于 UI locale bug；不在本 Gate 建立多语言商品 CMS，不自动翻译、复制、改写、删除商品/品牌数据。
3. G2A 本机补丁新增 `app/Http/Middleware/SetAdminLocale.php`，无条件 `App::setLocale('zh_CN')`，并注册到 `app/Providers/Filament/AdminPanelProvider.php` admin middleware。这会覆盖管理员已选语言；在后台保证简体中文的方式错误。另 `AdminPanelProvider::navigationGroups([__('Administration'),...])` 在 Panel Provider 初始化时即时求值，可能早于请求 session locale 解析，翻译组标签可能在非中文语言下保持中文；需要检查并以版本兼容、请求期懒求值方式纠正。
4. G2A 主补丁 `resources/views/admin/actions/audits.blade.php` 两处存在确凿源码缺陷：新增 `{{ __(str_replace('_', ' ', )) }}` 和 `{{ __(class_basename()) }}`，分别遗漏了原本的 `$audit->event` 与 `$audit->auditable_type`。Blade 可以编译，但审计详情渲染时可能抛出参数不足异常。需恢复变量参数并仅翻译显示文本，不改变审计记录或权限。G2A/R1 原始历史 patch 不得被直接改写，使用新增小型修复补丁。
5. OWNER_SCREENSHOTS 另外展示审计列表/失败任务页面的 `User id / Event / Ip address / Payload / Exception / Failed at` 英文字段，属于管理表格漏译或内置技术数据；不应将动态审计事件/失败任务负载字段重写为中文数据库值。R1 通知列表八个普通主题中文化已见真实截图；含 Blade 变量、`Email verification` 仍英文是已有明确的显示限制。
6. APP_LOCALE=zh 为本机**默认**语言允许保留，`zh`、`zh_CN` 词库都保留；不要全站锁定 zh_CN。具体 admin 中文 Filament UI 若需要 `zh_CN`，仅在当前用户偏好是 `zh` 的请求中映射；其他合法用户 locale 尊重选择。

## PREFLIGHT
- 只读核对真实 Windows 主机/服务、版本 v1.5.9、/app 源码及当前 G2A+R1 两层补丁 SHA 与可用文件级备份。保留所有 DB/Redis/镜像/端口/其他项目。若源版本/补丁状态和 GitHub 记录不匹配则停止写入、精准 RETURN_PREFLIGHT_DRIFT。
- 确认 `SetLocale` 应用在公开 web 路由和 Livewire request 的执行时机，后台 Filament middleware/PanelProvider 初始化时机；不用未经证实的硬编码替换。
- 修改前本机项目目录单独保存此轮将改文件的非秘密原件/哈希；补丁存至 `localization/g2c/`（不可上传 Cookie/Secret/数据或日志）。
- 原版语言保底是英语；验证 APP_LOCALE 是默认，而不是用户锁定值；不得覆盖 session language 或用户选择。

## IMPLEMENTATION — ONLY SCOPED DISPLAY CORRECTIONS
A. 把原先无条件 `App::setLocale('zh_CN')` 调整为遵循用户 session locale 与允许语言的请求级解析。原始 `zh` 映射到 `zh_CN` 仅在 admin 有必要时使用，`fi`、`en` 等保持原值，default 本地 zh。不能将所有 admin 语言继续强制中文。资源标签与导航组在切换语言后遵循相同选项，必要时消除 Panel 启动时过早静态 `__()` 求值，避免侧边栏出现重复/丢失分组。要维护 Filament 已安装版本支持的 API。
B. 对 `resources/views/admin/actions/audits.blade.php` 还原丢失的两个显示值参数，例如 `__(str_replace('_', ' ', $audit->event))` 和 `__(class_basename($audit->auditable_type))`（根据运行源码上下文核对）。禁止更改 audit 写入、数据、权限或将敏感审计详情提交公共仓库。
C. 可选仅在同一文件/表格且无副作用时翻译确定的固定管理列名（User id / Event / Ip address / Payload / Exception / Failed at）；不修改实际 user.name、audit.event、IP、payload 或 exception 内容。不扩大到整个新的汉化大包、翻译商品、主题数据。
D. 保留现有 G2A/R1 用户界面翻译、通知映射、品牌、商品、优惠券及 Stripe 状态；无需重新启动全部容器。对 PHP/Blade 必要时 view:clear，除非有明确证据不得重启非 app 服务。

## ACCEPTANCE_AND_PROOF
- 代码级：新补丁只含必要源码差异；PHP lint、Blade view compile 以外，**运行时执行**审计详情 view 关键展示表达式（用非敏感虚拟 fixture 或其他不修改业务的验证）以证明 event/type 传参有效。仅 PHP lint/Blade 编译不够。
- Locale 级：在真实应用代码下模拟 `fi`、`en`、`zh` 三种被允许的 session locale，检查前台翻译和后台 locale 解析；默认 zh => 简体；fi/en 不被强制中文；无效 locale 不可随意设置。必须验证实际请求时 Panel 导航组和资源标签的一致性，不可只在独立 CLI 中 `App::setLocale`。
- 数据级：用户、分类、商品、套餐、订单/发票/服务、通知主题 hash 和已配置网关（仍为空）在修改前后不变；不新建用户/商品/订单、发邮件或交易。
- 本机只读 HTTP：首页/商品/登录与 302 认证行为无异常；真实 UI 可以通过 Owner 原生浏览器截图（选中文/芬兰语菜单 + 管理后台）补证；若浏览器工具原有停止指令仍生效不可绕过，不以 HTTP 200 冒称用户多语言完整体验。
- 高优先级负面检查：默认简体不丢失；芬兰语切换保持 `Koti/Kauppa`；业务演示商品在所有语言仍显示原始中文是预期，不列为修复失败；后台非法/空 session 回退正确，中文 nav 分组无重复。
- 运行/重启持久性仅 app-owned 文件验证即可；必须可反向补丁回到本轮开始时 G2A+R1 源码状态。PR 提交 `localization/g2c/` 的补丁、README、无敏感 Evidence，并 `STOP_AT_REVIEWER`。不撤销旧 PR、不反复整套部署。

## ROLLBACK / OWNER_ONLY / COMPLETION
- 仅备份/回退 G2C 修改文件 + 清视图缓存，绝不回退 G2A/R1 补丁、碰数据库/卷或 Docker 全局配置；记录路径与 SHA。
- 用户已授权私有试用的汉化与回归修复，不需要普通文案修复逐步审批；未授权 Stripe Live、支付、退款、购买 Referrals、真实订单或公开网络。
- RESULT: `PASS_CANDIDATE_G2C_LOCALE_AND_AUDIT_CLI` / `PARTIAL_G2C_UI_EVIDENCE_PENDING` / `RETURN_<具体阻塞>`。不得用纯截图或 HTTP 代替审计视图运行时验证。

## REVIEWER_TO_EXECUTOR_RELAY
在原来的 Owner Windows 本机 Codex 中执行。只读本 Gate、当前 `REVIEWER_HANDOFF.md`、`localization/g2a/README.md`、`localization/g2b-r1/README.md` 和需修改的真实 v1.5.9 源码。无需重读其他历史 Gate。目标是恢复原生多语言切换语义并修复 G2A audit 视图参数缺失；只做最小追加补丁。不得误把中文演示商品数据翻译成芬兰语。做 fi/en/zh 请求级回归和非敏感审计详情渲染测试，源代码修复及 Evidence 交 PR 后 STOP_AT_REVIEWER。不要重启/重建数据库、Docker 或任何不相关服务；浏览器工具若停用，不绕过，凭 CLI 与 Owner 后续截图补证。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE_G2C_LOCALE_AND_AUDIT_CLI / PARTIAL_G2C_UI_EVIDENCE_PENDING / RETURN_*
改动：新增 G2C 追加补丁及本机实际文件修改范围。
验证：默认简体、fi/en 可切、admin 分组及审计模板运行时渲染、原数据计数/通知模板不变。
问题：未验证的真实视觉问题或确切故障。
回滚：仅 G2C 补丁反向应用与 view:clear，不回退 G2A/R1。
请 Reviewer 检查：跨语言请求语义与审计显示变量无损。
Owner 转交：NONE，除非唯一必需的低成本真实截图。


## EXECUTOR_TO_REVIEWER_RELAY — 2026-10-17

PR: https://github.com/entropy-student/project/pull/150

RESULT: `PASS_CANDIDATE_G2C_LOCALE_AND_AUDIT_CLI` / `PARTIAL_G2C_UI_EVIDENCE_PENDING`.

CHANGES: 仅三文件增量补丁 `localization/g2c/paymenter-g2c-locale-audit-v1.5.9.patch`；admin 尊重允许的 session 语言，zh 映射 zh_CN，Filament 分组延迟本地化；审计视图恢复 event/type 参数。补丁 SHA-256 `089f7a45674f2076eb3aa5c396a8a90b435c5c2af18f71b409fc6148e1bf60c2`。

VALIDATION: PHP lint、Blade cache 编译与虚构 fixture 详情运行时渲染通过；zh/en/fi 的实际 HTTP Kernel session 回归和 admin 导航组/资源分组标签通过；非法/空/缺失 admin locale 回退通过；新补丁重放/反向往返通过。数据行数与通知模板哈希不变，loopback HTTP 200/302 符合预期。

LIMITATION: 未认证 admin 请求为预期 302；未做登录态视觉/交互验收。Finnish 管理分组缺少芬兰语词条时使用英文 fallback。人工注入非法前台 session locale 的额外负向探测未返回 200；正常 LocaleSwitch 会阻止非法值写入。本 Gate 未扩大改写前台 SetLocale，交 Reviewer 决定是否开后续修复。G2B 全面 UI 状态仍 PARTIAL。

ROLLBACK: 只反向应用本 Gate 新增 G2C 补丁并清 Blade view cache，回到 G2A+R1；不触碰数据库、命名卷、账号、商品、订单、支付或其他项目。

请 Reviewer 核验 locale 请求语义和 audit 详情无参缺失后验收。