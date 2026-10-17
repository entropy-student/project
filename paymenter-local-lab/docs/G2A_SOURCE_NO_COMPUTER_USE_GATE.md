# Paymenter G2A — 无 Computer Use 的简体中文源码实施 Gate
GATE_ID: PAYMENTER-G2A-ZH-HANS-SOURCE-WITHOUT-COMPUTER-USE-20261017
STATUS: REVIEWER-AUTHORIZED / EXECUTOR-NOT-STARTED
PARENT: docs/G2_SIMPLIFIED_CHINESE_UI_GATE.md（全站汉化总目标未取消；**本 Gate 只验收源码和命令行可验证部分，禁止宣称 G2 整体 PASS**）
GOVERNANCE: entropy-student/spike.skill/vps-project-governance/VNEXT.md v0.2.7

## Reviewer 诊断 / 事实边界
Owner 转交本轮 Executor 结果：Paymenter v1.5.9、三容器和 127.0.0.1:8187 仍可用；浏览器技能在验证活动页面 URL 时无法得到足够确定性，工具要求**本轮停止 Computer Use**。Executor 未修改应用、未重启、未创建 PR。该结果是 `RETURN_BROWSER_TOOL_UNAVAILABLE`，不是系统失败，也不证明汉化不可能。
该信息当前为 OWNER_REPORTED/EXECUTOR_REPORTED，Reviewer 尚未直接在真实主机读回；下一次本机执行必须 fresh readback。

## OBJECTIVE / MAX_ENDPOINT_THIS_ROUND / MANDATORY_REVIEW_STOP
不使用任何浏览器 Computer Use/替代浏览器自动化的前提下，给 **已有 Paymenter 本机实例**实现可重放、可回滚的简体中文源码补丁。优先用户区 lang/zh 文案、管理员导航/资源/表单/仪表盘硬编码英文、首页欢迎语；以静态检查及项目限定 PHP/Laravel CLI 校验；可在达到严格前提时应用至现有 paymenter 服务，以只读本机 HTTP 检查页面响应与基础文字，并**只重启该 app 服务**确认补丁持久性。最大终点：`G2A_SOURCE_AND_CLI_PASS_CANDIDATE`；真实点击/浏览器截图、登录及二级页面 UI 验收留给 G2B。不预先扩大到 Stripe、推荐插件或生产。

## TARGET_AND_SCOPE
- Owner Windows 11 Home，本地 Codex，Docker Compose `paymenter_local_lab`；容器 `paymenter`，MariaDB + Redis 保持原样；网站 `http://127.0.0.1:8187`。
- Owner 本机项目数据根 `%USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab`；运行应用源码在 **项目所属 `/app` Docker 命名卷**（真实 mount 源、目标、配置 fresh readback）。
- 用既有 `paymenter-local-lab/localization/TRANSLATION_GLOSSARY.md` 和上游已运行版本 v1.5.9 的精确源码作为语义依据。项目 repo 只提交非秘密翻译补丁/应用方法/验证摘要，**不把整个 `/app`、数据库、秘密和 vendor 上传**。

## PREFLIGHT
1. 不启动或重试 Windows 浏览器技能、不切换其他 Computer Use 工具、不点击浏览器、不注入浏览器 JS；遵守本轮工具停止指令。
2. 先确认在 Owner **真实 Windows**、已有 G1 版本/Compose/容器/镜像（检查 app 卷）和原始非秘密源码；非本项目容器与数据不改。不存在合适运行环境则只产出可复核源码包，不假装本机已应用。
3. 先列清 `/app/lang/zh`、`app/Admin`、`app/Providers/Filament`、默认主题内实际可见文本的来源/已存在覆盖方式。不得简单假设 `APP_LOCALE=zh` 会改变写死英文。
4. 本机项目目录建立只含即将改动**非秘密文件**的原件备份、路径及 SHA 列表，验证可恢复；保留被审查的翻译补丁。禁止将 `.env`、APP_KEY、数据库凭证、Cookie/Token、日志、数据库卷包含进补丁/备份/PR；既有 G1 数据保留。
5. 确认占用/业务状态只读基线，记录 users/categories/products/plans/orders/invoices/services counts、支付网关是否为空；不修改测试账号权限和密码。

## IMPLEMENTATION（不等待浏览器）
- 将 `lang/zh/*.php` 译为自然简体中文，转换**展示值**，保持所有 PHP 键名、命名空间、占位符、命令/状态 key、参数格式不变；检查所有条目健全。繁简只做翻译文案，不随意替换代码字面量。
- 依照真实运行版本对 Paymenter 管理端 `AdminPanelProvider`、`app/Admin/Resources`、`app/Admin/Pages`、`app/Admin/Widgets`、Filament 自带 UI 语言加载进行本地化。能复用已有 Laravel/Filament 官方语言机制则优先；硬编码英文用兼容版本的翻译调用或静态翻译方法，保持导航组 key 语义和资源/权限关联；不要修改 vendor。
- 主题首页欢迎语可从现有保存位置修改**演示默认文案**，只有在读取并确认仍为默认英文且该字段归本机试用范围时可执行；避免覆盖未来主人自定义内容。尽量不进行 DB 写入，若非得写仅修改这一个已识别设置并具备恢复快照。
- **优先在项目限定独立源码副本中生成/验证补丁**，再依据验收条件原子应用到正在运行的项目 `/app` 命名卷。不得大范围导出和发布整个应用。
- 使用 `php -l` / Laravel CLI 只读测试/翻译 key 对比/占位符校验/可执行单元测试（若已有）、必要时 app-only `php artisan optimize:clear` 和 app-only restart。禁用浏览器测试；允许对 `127.0.0.1:8187` 的本机非交互 HTTP GET 来证明进程可达并只读检查公开 HTML 文案；这不是 GUI 验收，不可自动填写登录表单。
- 不做 `docker compose down -v`、`prune`、全局 Docker 改动、升级镜像/依赖、DB 初始化/迁移重跑、真实交易/网关配置。
- 无证据证明项目卷与重启文件持久性时，禁止直接重建容器，以免丢补丁。若修改生效异常，仅恢复此轮文件并对 app 单服务重启/缓存处理；失败应精确记录与 RETURN，不启用别的 Computer Use 通道。

## ACCEPTANCE_G2A_ONLY
1. 有 GitHub PR 的项目专属可重放非秘密源码 diff（或补丁及明确应用脚本）、翻译文件清单、完整性和 PHP 语法/键名/插值静态检查。
2. 若执行到本机写入：本机原件可恢复、文件落地 SHA 对照、`paymenter` app 正常运行、本地 HTTP GET 不低于先前基本可达状态、依靠 CLI 检查 locale/翻译值、单 `paymenter` 服务重启后同值仍存在；用户、商品、套餐、订单/发票/服务及网关状态无未授权改动。运行时不泄露秘密。
3. 如果仅完成独立补丁未能证明真实本机写入，则声明 `PASS_CANDIDATE_G2A_SOURCE_ONLY`，绝不声称已经看见汉化页面或 G2 PASS。
4. 原先 G2 全量浏览器视觉/交互验收保留为 **G2B_PENDING_BROWSER_EVIDENCE**，不得降级成“HTTP 200 等于 UI 汉化通过”。G2B 可在 Computer Use 正规工具可用的后续轮次核对，也可由 Owner 自主浏览提供截图/条目供 Reviewer 核对；不能为了本轮任务让 Executor 无视浏览器停止指令。
5. 若 UI 检查无法开展，页面级残留英文状态必须写为 UNKNOWN/UNVERIFIED，而不是“全部汉化”。

## REQUIRED_EVIDENCE / ROLLBACK_STATUS_OR_PLAN
项目 Gate ID、真实运行环境、GitHub 源版本及本机 `/app` 版本对应关系、非秘密改动文件/行数、PHP key/占位符静态测试、缓存清理、app 服务重启后的只读运行状态/HTTP 文本、数据计数、备份/回滚路径及实际恢复方法、结果/未测部分、无 Computer Use 的事实边界。结果提交 project repo 下 `localization/` 补丁和 `EXECUTION_EVIDENCE.md` 追加记录，停止在 Reviewer。
回滚粒度仅此轮实际修改的文件/主题设置，**保留数据库、命名卷与原镜像**；不删除现场。原件必须留在 Owner 本机项目专属路径，验证恢复方法，但无需破坏性现场回滚演练。

## OWNER_ONLY_ACTIONS
Owner 已授权本机简体中文翻译。无新付费、账号安全操作、数据删除、系统范围修改、支付、公开服务，不需要再次让 Owner 手工排障。

## REVIEWER_TO_EXECUTOR_RELAY
在 Owner Windows 本机执行。只读本文件、最新 `REVIEWER_HANDOFF.md` 的接受事实、`localization/TRANSLATION_GLOSSARY.md`，及这轮真正需改的项目源码。G1 已 PASS，不重部署。浏览器 Computer Use 本轮已被工具要求停止，不再触发或替代该能力。**继续实际制作汉化补丁而不是因为缺截图便整轮停止**；靠源码/CLI/只读 HTTP 做 G2A 验收，将补丁/必要的本地安全应用操作与证据提交 PR。浏览器级测试明确延期，结果不可升级到 G2 PASS；停止在 Reviewer。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE_G2A_SOURCE_ONLY / PASS_CANDIDATE_G2A_APPLIED_CLI_VERIFIED / RETURN_具体原因
改动：已汉化的源码和存续载体、是否实际应用本机。
验证：PHP/键名/占位/CLI/HTTP/单服务重启及数据不变，哪些有证据。
问题：浏览器工具本轮停止、哪些残留英文和页面未核实。
回滚：独立文件备份/恢复路线及命名卷边界。
请 Reviewer 检查：项目代码补丁可重放、运行验证及未冒称 UI PASS。
Owner 转交：NONE；除非产生具体无法自行解决的必要 Owner 输入。
