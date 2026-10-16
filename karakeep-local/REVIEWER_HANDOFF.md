# Karakeep Local · Reviewer Handoff

> REVIEW_DATE=2026-10-16
> IMPLEMENTATION_STATUS=`CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`（原安装结项不撤销）
> POST_CLOSE_MAINTENANCE=`G2B_READY_FOR_EXECUTOR`（一次性收尾，不重开安装或长期运维）
> CURRENT_GATE_ID=`KARAKEEP-WIN-G2B-ONE-SHOT-BACKUP-CANARY-CLEANUP-20261016`
> GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> `CLOSEOUT_REPORT.md` 保留正式安装结项；`DECISION_LOG.md` 记录新收尾决定；`EXECUTION_EVIDENCE.md` append-only。

## PROJECT_GOAL
Owner Windows 11 本机官方 Karakeep 已技术验收并登录使用，唯一 Web URL `http://localhost:3000`。本次是 Owner 要求的**单轮收尾**：项目本机文件安全清理、数据+Secret 备份和隔离恢复验证、一条无敏感内容的书签功能测试；**不做 Windows/Docker Desktop 重启验收、长时间监控或持续任务**。结果完成后恢复 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`，不自动继续。

## PROJECT_STAGE
- **安装已正式 Close**：G1J Reviewer PASS，G2A Owner 已实际进入登录后的 UI 并找到中文语言选项；原 `CLOSEOUT_REPORT.md` 的安装结项结论不更改。
- **2026-10-16 Owner 新决定**：希望把此前遗留的**备份/恢复、功能验收及本地安全清理**合并为**一次本机执行**；明确不做重启持久性/长期观察，未来若出问题再排查。Reviewer 依该要求开放一次有边界的 G2B maintenance Gate。
- **G2B NEXT**：以“验收/备份可验证优先、无破坏”为原则，完成可执行范围，记录 PASS/PARTIAL 及唯一真实阻碍；不能为了凑全部 PASS 而删除运行资产、在未经授权的备份目标上传秘密、或者称同盘复制是异机灾难恢复。
- **单次使用入口已冻结**：Docker Desktop 正在运行时直接访问 `http://localhost:3000`；若三个容器停止，则进入本机 PowerShell 运行：

  ```powershell
  Set-Location (Join-Path $env:USERPROFILE 'KarakeepLocal')
  docker compose -p karakeep-local up -d --pull never
  if ($LASTEXITCODE -eq 0) { Start-Process 'http://localhost:3000' }
  ```
  这是**未来按需启动命令**，不在 G2B 中为“测试重启”故意执行；必须在真实 Docker Desktop Engine 已启动、目录存在、镜像未被删除的前提下使用。若失败按当时错误精确诊断，不盲目 prune/重装。

## SYSTEM_MAP
- Target：Owner 原生 Windows 11 + Docker Desktop Linux Engine；此前 Powershell 7.6.5/Compose 5.4.0。未来 Executor 用 Owner 本机 PowerShell Codex，不在云端执行 Docker 写入。
- Runtime：project `karakeep-local`，服务 `web/chrome/meilisearch`，Web only `127.0.0.1:3000:3000`；Chrome 9222 和 Meili 7700 仅内部可见。G1J 已证明三镜像身份/Meili 健康/CDP 握手/登录页；后续 Owner UI 实际登录。
- Protected source：`$env:USERPROFILE\KarakeepLocal\docker-compose.yml` SHA256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`；同目录受保护 `.env` 四键及两个秘密 `NEXTAUTH_SECRET/MEILI_MASTER_KEY`。不输出、hash、轮换或 Git commit 任何值。
- Durable volumes：`karakeep-local_data`、`karakeep-local_meilisearch`；用户现在有本地登录账户，**真实数据**，不可清空或拿原卷做恢复实验。需要一份应用一致性的备份和与 Secret 配对的加密恢复物；以前均 `UNVERIFIED`。
- Reusable official images（本机 G1J readback）：
  - Web `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`
  - Chrome `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`
  - Meili `getmeili/meilisearch@sha256:860fa4baed04ae1c235de870edab0c8006227546dea1bbb6411fbfc5e27cf1db`。
- Non-target：其它 WordPress/MariaDB/Docker 项目、daemon/proxy/Clash/VPN/证书/Windows 全局配置禁止改变。当前有效访问仅 localhost；不打开公网端口。
- Resources：G1J 曾见 host available RAM 低至 424 MiB 但无 OOM/restart，Owner 已取消固定剩余内存门槛；只对本轮实际失稳做判定。
- Backup location：**Owner 尚未提供可证明不同故障域的备份目标**。Executor 可以只读查找已存在且 Owner 有写权限的独立物理盘/显式本机受控备份目标（不从路径名臆测物理独立性）；不默认 Google Drive/Dropbox/GitHub/云上传。安全、独立目标不可用时，可建立受保护的**同机临时恢复演练副本**，但必须标 `LOCAL_COPY_ONLY / OFF_DEVICE_RECOVERY_UNVERIFIED`，绝不能声称已经解决设备丢失风险。不得复制密钥到未经确认的外部位置。
- Recovery：G1I 已验证 `docker compose -p karakeep-local down`（**无** `-v`）可保留卷，不证明数据异机恢复。G2B 所有恢复实验只在隔离的新卷/临时测试目录进行，绝不覆盖原卷/.env/账户。

## CURRENT_ACCEPTED_STATE
安装关闭、服务保留运行（云端没有持续实时运行观测）。**G2B 尚未执行**，备份/恢复/真实 URL 抓取 E2E/本机临时文件清理均尚未有新 PASS Evidence。后续不做重启持久性、长期监控，由 Owner 自行按需启动，有问题再排查。简体中文界面是否已实际选择并刷新持久化仍 `UNVERIFIED`，不阻挡本轮既定功能测试。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G2B-ONE-SHOT-BACKUP-CANARY-CLEANUP-20261016`
**OBJECTIVE**：在同一个 Owner Windows 本机项目权限/证据边界内一次性完成可审计的安全备份与隔离恢复、单个可丢弃书签测试、严格保留运行资产的本地清理，并交 Reviewer 一次结论；明确排除重启/长时间观察。

**MAX_ENDPOINT_THIS_ROUND**：
1. **最小 preflight**：真实 Owner Windows 本机身份；已冻结 Compose/Secret ACL 和所需键格式（值仅受保护进程内）、三容器当前状态、唯一 loopback 绑定、两 named volumes 归属/非目标 baseline、现有账户登录已由 Owner 使用但不得收取/输出密码、可用存储与可用备份位置。不得重播安装或镜像/代理历史 Gates，禁止固定 RAM 剩余阈值。
2. **备份前安全性与方法确认**：核实 Web app 的持久数据库、资产目录、Meilisearch index/snapshot/dump 的实际存储与一致性要求；优先官方已存在的无停机、应用/数据库一致性导出能力，绝不把运行中 SQLite WAL 主文件的普通卷 tar 直接当作一致性备份；仅当来源一致性可证明时创建快照/备份。用户明确排除“重启测试”：本轮不做 Windows/Docker Desktop 重启或为了证明持久化的服务停启；如果安全一致性备份必须短暂停应用，应停在 RETURN 并给 Owner 最小权衡，而非自行断开当前应用。
3. **备份/Secret 恢复配对**：在经本机读回验证的受保护目标生成项目数据、必要配置及密钥的**加密/受权限保护**恢复物，区分两卷与数据库/索引状态、Secret 范围。Secret 只在受保护进程内操作，任何密码、key、真实环境值及原始档案不得出现在命令行参数、普通日志、聊天或 GitHub。异故障域目标存在且安全证明时才宣布 `OFF_DEVICE_BACKUP`；仅同盘或原 Host 的复制明示 `LOCAL_BACKUP_ONLY`。恢复密钥的保管方式如无法证明与恢复物配套，标 `UNVERIFIED` 而非虚假 PASS。
4. **隔离恢复验证**：只对**新建的临时测试卷/目录或副本**检验备份读回、完整性/解密能力、DB 一致性及数据/Secret 兼容性；若资源允许且已证明隔离、可做不暴露 Host port 的最小应用读兼容/只读搜索检验；不得把备份写回真实 `karakeep-local_data`、`karakeep-local_meilisearch` 或覆盖原 .env；不可复制登录密码/令牌到公开测试容器/网络。若没有受测数据或深度恢复不可行，报告 `BACKUP_OK_RESTORE_PARTIAL`，不能宣称完整灾难恢复。恢复副本和临时敏感材料除非证明可安全、精确清理，否则保留于受保护位置并报告例外。
5. **功能 Canary（唯一外部联网动作）**：使用登录后的 Karakeep UI 或已授权正常会话由 Owner 手动/受控界面添加**最多一条无个人信息、可丢弃、公开 URL**（例如 `https://example.com`，仅在来源可达时）；检测入库、Worker 下载/处理完成与否、搜索能否命中、页面内容及预览/截图是否如预期。禁止批量收藏、自动导入、付费服务、外部 AI key、对其他账户/资料操作。若没有可安全复用的 Owner session，不索取/抓取密码、Cookie、token；仅请 Owner 手动完成这一个动作并记录非秘密结果。可保留此条可丢弃书签，默认不删除；结果以原有账户当前数据为界，绝不清理别的条目。
6. **仅项目本地安全清理**：项目下已无引用、已验证可重建的临时下载/诊断文件，先按路径/所有权、引用、是否为保留的恢复物/唯一资料分类。只允许精确 allowlist 的 `LOCAL_DISPOSABLE` 文件在 read-before-delete 和可回退/参考验证后清理；未知或归属不清一律不删；绝不清理 Docker 全局镜像/layers/cache、其它项目、`.env`/Compose、账户、数据卷、备份、唯一未推送代码/资料。没有安全候选时明确 `CLEANUP_NOT_REQUIRED`，不得为清理结果强删。
7. **最终复核**：无需长时间观察/设备或 Docker Desktop 重启测试；当场对 Web/Meili/Chrome 必要依赖和 localhost 访问、非目标状态/宿主异常、项目数据卷及备份/恢复物 readback 验证。所有功能步骤按 `PASS/PARTIAL/RETURN` 分类，未完成项和原因精确记录，不能因某个子项未完成就虚构全部完成。
8. 按规范仅向 `karakeep-local/EXECUTION_EVIDENCE.md` 追加 G2B 脱敏结果、提交 main 并读回，停 Reviewer。由 Reviewer 更新最终 Handoff/Closeout 补充证据，保留安装结项状态；不要 Executor 自行改结项或启动下一 Gate。

**MANDATORY_REVIEW_STOP**：上述 G2B 一次完整执行后停在 Reviewer；禁止自动继续到额外安装、长期监控、重启或新的清理。
**TARGET_AND_SCOPE**：仅 Owner Windows 本机 `karakeep-local` 配置及两个命名卷的**只读数据验证/受保护备份复制**、新的隔离测试副本、用户本人的一条一次性可丢弃书签、确证项目独有的临时文件。其它 Docker 项目/共享代理/Windows/外部账户均无写权。
**APPLICABLE_CRITICAL_CONSTRAINTS**：Owner 仅授权此次一轮收尾和单书签 Canary；删除仅严格可证本项目可弃文件；不得修改/轮换 Secret、回写原卷、泄露凭据或建立未经授权的云端副本；备份真正一致且恢复经过独立验证才可 PASS；没有任何静态内存余量最低值。
**PREFLIGHT**：Owner 下发 G2B 指令即作为这次限定范围的授权；新鲜本机状态、当前运行项目/持久数据归属/备份目标或 LOCAL_ONLY 边界、可用账号会话且不暴露密码，恢复实验不改生产数据/系统设置。任意权限、来源和安全性不能验证时对应子项停止，不能触碰原始数据。
**REQUIRED_EVIDENCE**：常规 `AUTHORIZED_GATE/PREFLIGHT_FACTS/ACTUAL_CHANGES/OBJECTIVE_READBACK/VALIDATION/ANOMALIES/EVIDENCE_ARTIFACTS_AND_PURPOSE/ROLLBACK_EFFECT/RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT/EXECUTOR_RESULT`，另明确 `BACKUP_SCOPE/CONSISTENCY/DESTINATION_CLASS/ENCRYPTION_AND_KEY_CUSTODY_CLASS/RESTORE_TEST_SCOPE`、Canary 单条生命周期与搜索/截图结果、清理候选/已删个数与类型、非目标前后对照、当前运行 URL、后续 Windows PowerShell 启动命令 verified syntax；不记录密码、密钥、路径敏感部分、原始浏览内容、Cookie/DB 内容。
**ACCEPTANCE_CRITERIA**：备份范围与一致性可核验、秘密恢复受保护、隔离副本可读/可恢复；Canary 入库→抓取→搜索→预览/截图可用或准确指出不支持/失败子域；安全清理只覆盖已证实项目可弃对象；当前本机应用与其它项目无回归；不进行重启/长期观察。无独立备份目标时不得把 `LOCAL_COPY_ONLY` 标成异机灾难恢复 PASS；任何不可证据化项显式 `PARTIAL/UNVERIFIED`。
**ROLLBACK_STATUS_OR_PLAN**：使用原项目只读验证 + 独立恢复测试区，任何失败不覆盖原数据；创建的可丢弃书签最多一条，默认保留不误删；临时测试数据/备份若清理须先确认不会删除唯一恢复物；目标数据/Secret 不做迁移/覆盖。若服务异常或其它项目退化，停本轮写操作并记录，除非已证明允许，不擅自重启/修复 Docker。
**OWNER_ONLY_ACTIONS**：Owner 已要求一轮完成并跳过重启/长期监控；Codex 不得要求提供账户密码/密钥。无独立故障域备份目标或需额外服务中断/云端上传时，这部分必须明示 `PARTIAL`，仅把具体选项交 Owner（不让 Owner自己研究脚本）。单个 Canary 登录动作如果 Codex无法使用已授权会话，Owner 自己点击添加一条公共 URL 即可。
**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是 Owner Windows 本机 Codex Executor。原“Karakeep 安装实施”已 Close，Owner 现在授权**一次性 G2B 收尾维护**，不重新打开安装项目。读取最新 `entropy-student/project` main 的 `karakeep-local/REVIEWER_HANDOFF.md` 的 CURRENT_GATE / SYSTEM_MAP / CURRENT_ACCEPTED_STATE / CRITICAL_CONSTRAINTS 和 `karakeep-local/CLOSEOUT_REPORT.md` 中保留的资产/未解决事项，勿扫描历史 Evidence。以**当前运行的 `karakeep-local` 项目**为范围，本轮一次完成：①应用一致的数据备份+原 Secret 安全恢复材料（优先真正不同故障域，只有同机副本则必须标 LOCAL_ONLY）；②在完全隔离的副本中验证可解密、数据库/搜索资料可读，不回写原卷；③仅通过既有登录会话或 Owner 手动执行**一条可丢弃公共网页收藏**，验证抓取/搜索/预览；④仅对已确认项目可弃且无人引用的临时文件进行最小清理，无安全候选则不删。**不做 Windows/Docker Desktop 重启、长期监控或重启验收，不改 Compose/.env/Secrets/代理/其它容器，不全局 prune，不删除两个真实持久卷。** 如果安全条件阻挡某一子项，准确 PARTIAL，不伪造成功；最后只需保留本机运行状态、核验 `http://localhost:3000`，将脱敏 G2B Evidence append 到 main/read-back，交 Reviewer 一次审核。并检查用户未来按需启动的 PowerShell 命令 `Set-Location (Join-Path $env:USERPROFILE 'KarakeepLocal'); docker compose -p karakeep-local up -d --pull never` 的静态语法即可，不为此重启。
**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
安装 Close 保留、G2B 单轮维护；本机两原持久卷/帐号/.env/三镜像/运行容器和其它 Docker 项目不破坏；在线备份数据一致性证明、隔离恢复副本与加密 Secret 恢复绑定，不使用同盘副本冒充异机备份；Canary 仅一条非敏感公共 URL；项目 cleanup 仅明确可弃对象；排除设备重启与长期观察；结尾保持 `http://localhost:3000` 可访问（若已原本不可达如实上报）；Evidence 脱敏及 Reviewer stop。

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 本机 PowerShell Codex（单轮 post-close G2B）；项目正常运行期无需持续 Codex。

## CURRENT_ROLLBACK_STATUS
安装阶段安全项目停止（保留卷）曾测试；**G2B 严禁以恢复为名写回原卷/.env**。备份存不同故障域与验证前，灾难恢复能力仍为 `UNVERIFIED`；原服务运行资产保留。G2B 仅 GitHub Evidence/隔离恢复副本/单条 Canary/已证可弃临时文件许可。

## UNRESOLVED
有效异故障域备份位置与密钥恢复方式尚未确定；收藏抓取 E2E 尚未验证；中文界面最终选择/保存状态未知但不阻断收尾；其它尚未触发的长期/重启/资源问题**暂不检查**。

## NEXT_STEP
Owner 将下面一次性 G2B Relay 下发本机 Codex，等待 `EXECUTION_EVIDENCE.md` 新的单轮报告给 Reviewer。完毕恢复已 Close 记录，不自动进入 G2C。未来一般仅使用 `http://localhost:3000`；服务停下时按前面的 PowerShell 启动命令唤起。

## OWNER_ACTION_REQUIRED
仅将 G2B 提示词发给本机 Codex，无需密码/Secret。若确实没有独立盘/受控备份目标，后续需要 Owner 决定备份目的地，不能由 Codex自造可验证的异机容灾能力。

## EVIDENCE_POINTERS
G1J 安装 PASS `EXECUTION_EVIDENCE.md` commit `b801c2b629b303f730d05329c958cffca61686b3` blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4`；本机安装正式结项 `CLOSEOUT_REPORT.md`；本次 G2B Owner 请求来源 2026-10-16 当前对话；治理 `entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7。
