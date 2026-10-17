# G2 简体中文界面修复 Gate
GATE_ID: PAYMENTER-G2-LOCAL-SIMPLIFIED-CHINESE-20261017
STATUS: REVIEWER_AUTHORIZED_OWNER_REQUEST / EXECUTOR_NOT_STARTED
GOVERNANCE: entropy-student/spike.skill@main:vps-project-governance/VNEXT.md v0.2.7
BASELINE: paymenter-local-lab/REVIEWER_HANDOFF.md 当前 G1 PASS，PR #145 已合并；仅 Paymenter 私有试用实例。这个 Gate 不能推翻已通过的 G1。

## OBJECTIVE / MAX_ENDPOINT / STOP
将现有本机 Paymenter 的日常可见**用户前台 + 管理员后台**统一为规范的**简体中文（zh-Hans）**：替换已有 lang/zh 的繁体词汇、补齐用户区/登录注册和后台导航、统计、表单、操作、校验与弹窗的可见英文。保持品牌 Paymenter、代码标识、API/Stripe 商标等术语原样。最大终点：完成 UI 汉化、实际两类账号/页面验收、持久化与可恢复性验证；STOP_AT_REVIEWER。以最小补丁在已运行环境内修改，不重新部署整套应用、不安装新 SaaS。

## TARGET / START FACTS
- 真实 Owner Windows 11、本地 Codex 执行，Project Compose=`paymenter_local_lab`，127.0.0.1:8187；项目文件根 `%USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab`。
- Service `paymenter` PHP/Laravel + Filament admin；`database` MariaDB，`cache` Redis。活跃 DB 存储项目命名卷 `paymenter_local_lab_database`。应用使用 app 命名卷挂载 `/app`，注意镜像更新和重建会影响实际源码：先确认实际路径与挂载视图，谨慎制定持久化策略。
- 官方核实源码：`lang/zh/navigation.php` 包含「首頁」「購物車」「登入」等繁体；`app/Providers/Filament/AdminPanelProvider.php` 中导航分组直接写 `Administration/Configuration/Extensions/System` 和 `Exit Admin/Sign out`；`app/Admin/Widgets/Overview.php` 直接写 `Revenue/Tickets/Services/Increased by...`；`app/Admin/Widgets/Revenue.php` 直接写 `Revenue/Net Revenue/New Orders`；`app/Admin/Widgets/Support.php` 直接写 `Subject/Status/User/Created At`；`app/Admin/Resources/ProductResource.php` 有 `General/Pricing` 等硬编码，且多个资源的 `$navigationGroup` 为常量。Filament 自身内置翻译与项目写死的英文必须分开处理。
- `themes/default/theme.php` 内 `home_page_text` 默认值是英文 `Welcome to Paymenter!`，此设置可能已存数据库；直接翻译 lang 文件不改变此值。应通过既有 UI 或项目级主题配置替换为简体演示文案，不破坏 Owner 自定义内容。
- G1 未授权真实支付；当前仅 1 个本机演示管理员、1 分类、1 商品、1 免费方案，订单、发票、服务均为 0；无已配置支付网关。

## PREFLIGHT
1. Fresh 证明是实际 Owner Windows + 当前 Compose + 相同应用镜像/命名卷/服务。记录应用/DB/缓存运行状态、端口、现有虚构商品与 0 订单状态；检查非本项目容器未变化。
2. 仅只读确认 locale 来源优先级（settings.app_language、session(locale)、`APP_LOCALE`），实际 `lang/zh` 目录及 Filament 语言加载机制、`/app` 和子挂载、默认主题结构。识别与中文相关的前后台文件；不要推定 APP_LOCALE=zh 就能覆盖当前用户 session。
3. 在**项目独占的本地路径**备份将要改动的非秘密源文件/翻译文件、保留可恢复原件和 SHA；切勿备份/复制 `.env`、密钥、数据库卷等秘密或业务状态到 GitHub。此任务为 UI 更改，不需数据库重建或清理。
4. 优先基于固定 Paymenter 版本执行；禁止为汉化自行升级镜像、Laravel/Filament 或重建数据库。

## CHANGE PLAN（必须落实而不是仅出清单）
- 先做简体中文术语表和**可重放**的非秘密项目级翻译/源码差异文件，保存在本项目 `paymenter-local-lab/localization/`；不要仅在临时运行容器里 `sed` 修改并丢失来源。将这份补丁安全落在真实本机已有 app 源码；提供受项目边界约束的应用方法。
- 先覆盖 15 个 `lang/zh/*.php` 中用户可见翻译。可用可靠的繁体转简体工具处理**翻译值**，随后人工校正业务术语；严禁把 PHP key、数组键名、路径、变量、占位符、:attribute/:count、复数占位、HTML 结构或代码标识一起转写。检查原有插值、数量规则不被破坏。
- 后台 Filament 翻译：区分厂商标准 UI（选用官方现有的合法 locale/translation files）与 Paymenter 写死的 PHP 标签。为导航、资源、字段、表格、筛选、弹窗、Dashboard/Widgets、设置、网关、扩展、优惠券等加持久化的本地化标签；不要简单改成中文常量导致其它语言不正常/分组名称不匹配。动态字符串优先翻译 helper，静态属性使用兼容所锁定 Filament 版本的合法方式（如覆盖访问器）；必要时保持单语言本机预览的最小稳定实现。不要翻译数据库状态 key、模型字段/内部枚举值。
- 用户前台：登录、注册、找回密码、记住我、首页欢迎语、商店、商品详情、购物车入口、用户 Dashboard、资料/安全/发票/工单；可本机 UI 修改首页默认内容。注意繁体及英文混杂，页面整体要自然、符合简体中文常用词（登录、注册、账号、密码、订单、商品、服务、发票、工单、优惠券、配置）。
- 不采取页面加载后大范围替换 DOM 文本/浏览器翻译插件/全站 CSS 伪元素这种脆弱遮挡手法，不直接覆盖 vendor 下游包使升级不可维护。
- 只在 Paymenter app 服务上按需清除 Laravel 的视图/翻译/配置缓存并热加载，必要时仅重启 `paymenter` 服务。不得更新或重置 DB/cache 容器、清空卷、`down -v`、全局 prune。
- 如果发现翻译量显著超过一次安全修改能力，先覆盖截图和常见前后台完整路径，列出**实际未汉化页面列表**并保持可用状态，不为了完美化而改动无关业务。

## REQUIRED ACCEPTANCE
A. 浏览器**实际操作**并列出检查过的前台：匿名首页、登录、注册、找回密码、商店与虚构商品详情；已登录用户 dashboard、账户设置、订单/发票/工单导航。
B. 浏览器**实际操作**并列出后台：首页及 Revenue/Tickets/Services/日期筛选、Administration / Configuration / Extensions / System 导航及子项、商品/套餐、用户、优惠券、订单、支付网关、设置里的关键表单/按钮。现有已验证页面应以简体中文呈现；记录每页可见尚未翻译的具体条目。
C. 语义正确：Revenue=营收；Net Revenue=净营收；New Orders=新订单；Tickets=工单；Services=服务；Payment Gateway=支付网关；Coupon=优惠券；Dashboard=仪表盘；Remember me=记住我；Sign out=退出登录。不要将 service 实例与客服工单混为一谈。
D. 功能回归：现有管理员登录正常，/admin 正常；虚构商品与免费套餐无损；订单、发票、服务数没有意外变化；支付网关仍为空；不进行真实支付。
E. 持久性：只重启 `paymenter` 服务后，关键翻译仍生效；核对项目本地保存的覆盖文件与容器运行文件一致。不能把已翻译的临时容器画面当作持久成功。
F. 可恢复：记录翻译文件的源版本、补丁路径、恢复命令/方式；仅允许恢复这轮修改的文件，DB/应用数据保持不变。

## REQUIRED EVIDENCE
真实宿主证据、翻译改动文件清单/哈希或 PR diff、备份/恢复位置（非秘密）、页面截图或描述性逐页 readback、重启后同页前后对比、订单/发票/服务数据的非敏感计数、容器/端口、错误与剩余未翻译条目；`EXECUTION_EVIDENCE.md` 仅追加；不泄露密码、cookie、Token、DB 凭据，也不提交用户的真实资料。

## OWNER-ONLY / ROLLBACK
Owner 已授权调整私有本机 UI；无须额外审批正常汉化文件变化。Owner 未授权真实 Stripe/KYC/订单支付、公开路由、升级整个镜像、购买/安装 Referrals、破坏性删除。写入前做好**项目内文件级回滚**；若应用异常，恢复本 Gate 所改文件并重启 paymenter 单服务，保留 DB/卷、历史 Evidence 和其他项目。目标不确定则先只读诊断，不盲目重装。

## REVIEWER_TO_EXECUTOR_RELAY
入口仅本 Gate、`REVIEWER_HANDOFF.md` 的最新已接受事实、`localization/TRANSLATION_GLOSSARY.md` 与为了执行修改所需的本地源码。G1 已 PASS，不重复部署、不要求主人手工调 Docker。使用 Owner Windows 本机 Codex 执行本 Gate；直接改成简体中文并做核心 UI 测试，最小修正直到本 Gate 范围可用。适度减少英文残留，但绝不牺牲正常功能或范围。非秘密翻译补丁、测试证据提交到项目 GitHub PR，RETURN_TO_REVIEWER，不能自行封板。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_具体原因
改动：项目级翻译/后台标签、实际更改和备份边界。
验证：前台/后台/刷新/单服务重启后的实际页面与登录回归。
问题：仍存在的具体页面或英文短语，不泛称失败。
回滚：文件级恢复位置、操作影响范围。
请 Reviewer 检查：翻译覆盖、功能无损、可重放与证据。
Owner 转交：NONE，除非真实主机不可访问或一个不可替代的 Owner 输入。
