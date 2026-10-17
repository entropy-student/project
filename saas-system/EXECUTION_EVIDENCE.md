# SaaS System Lab — EXECUTION_EVIDENCE

> APPEND-ONLY。任何未来 Gate 的预检、实际修改、脱敏输出和 Reviewer 判定均在后续章节追加；不要用无证据的 `PASS` 代替实际读取。

## 2026-10-17 — G0_PROJECT_INITIALIZATION

- `AUTHORIZED_GATE`: Owner 在本对话明确要求“单独建一个 SaaS 系统的项目，在项目库里按顺序实验三个项目；先通读项目管理规范”。本轮 Reviewer 将最大端点界定为**项目初始化和只读 G1 Gate 的文档落库**，不是候选安装。
- `PREFLIGHT_FACTS`: GitHub `entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 完整读取 609 行；`entropy-student/project@main` 根目录无 `saas-system/`；既有 Paymenter 子项目当前根目录未见；项目库根 README 指定项目目录独立与 Handoff 为状态权威。
- `ACTUAL_CHANGES`: 新增 `saas-system/README.md`、`REVIEWER_HANDOFF.md`、`EXECUTION_EVIDENCE.md`、`docs/SERIAL_EXPERIMENT_PLAN.md`、`docs/G1_VELOBASE_READONLY_GATE.md`；根 `README.md` 增加一个导航项目条目。其他仓库和项目不变。
- `OBJECTIVE_READBACK`: GitHub main 当前版本和新文档需要在完成提交后逐项独立核验；提交身份参见 GitHub 历史。**不要把当前记录当成尚未发生的运行实测。**
- `VALIDATION`: 计划/范围级自检：串行次序 Velobase → Open SaaS → Wave；Docker 非硬要求；G1 只读；未经启动/支付/账号授权。新项目 Handoff 唯一真相。
- `ANOMALIES`: 无已知既有项目修改；候选执行环境实际状态 UNKNOWN。
- `EVIDENCE_ARTIFACTS_AND_PURPOSE`: 本文件留存初始化事实；Handoff 与 G1 Gate 提供后续交接和验收标准；GitHub 提交+路径回读作为持久化证明。
- `ROLLBACK_EFFECT`: 文档级 Git 回滚可恢复；没有 DB、Docker、VPS 或 Provider 侧回滚动作。
- `RESOURCE_OR_BUSINESS_DELTA`: 新增文档 5 个与根导航 1 行；真实服务/容器/数据库/支付/费用均 0。
- `EXECUTOR_RESULT`: `PASS_CANDIDATE_DOCUMENTATION_ONLY`，实际 GitHub read-back 前不主张正式 PASS。

## 2026-10-17 — G0_REVIEWER_READBACK_AND_PASS

- `REVIEWER_DECISION`: `PASS_G0_DOCUMENTATION_INITIALIZATION_ONLY`。**不包含** Velobase/Open SaaS/Wave 的任何安装、运行或支付验收。
- `DIRECT_READBACK`: 初始化 Commit [`90b40c397f84dbbecbb35f3eb9abc1ce789a29c1`](https://github.com/entropy-student/project/commit/90b40c397f84dbbecbb35f3eb9abc1ce789a29c1) 的 changed paths 仅 `saas-system/` 下 5 个 Markdown 和根 `README.md`；6 个路径已通过 GitHub main 重新读取，内容和导航链接存在。
- `CONCURRENT_UPDATE_RECONCILED`: readback 时 main 为 `744f11f290ce50ea5cec291126af826a77f6d2e1`，GitHub compare 表明这是本项目初始化 commit 的后继，新增内容仅是 `birthday-magazine-studio/` 独立文档；不归属、不修改或回滚那个项目。
- `VALIDATION`: 6/6 路径成功回读；项目原不存在，新建后未触碰其他项目内容；G1 仍为只读预检，串行实验尚未进入运行。
- `ROLLBACK`: 文档级 Git 回退可恢复；不涉及任何运行资源、Secret、支付或业务数据。

## 2026-10-17 — G1_VELOBASE_LOCAL_PREFLIGHT_REVIEWED_RETURN_RESOURCE

- `AUTHORIZED_GATE`: `SAAS-G1-VH-READONLY-PREFLIGHT-20261017`，只读。
- `PREFLIGHT_FACTS`: Owner 在会话转交本机 Codex 报告，Windows 11 Home build 26300、PS 7.6.5、非管理员；可用内存 1.12/1.55 GiB，磁盘余量 169.70 GiB；Docker 9 个项目/35 容器，运行中 3 个；端口 3003/54333/56380 未见冲突。**来源为 OWNER_RELAYED_EXECUTOR_REPORT，非本 Reviewer 对真实主机的直接读回**。
- `SOURCE_DIRECT_READBACK`: Reviewer 经 GitHub 读取固定 SHA `e88e259b974f883913f68ac74a9b8377765d005d`，核对 MIT、Compose、Dockerfile、Demo 脚本、退款处理、Affiliate 事件模块。
- `ACTUAL_CHANGES`: 本机 Codex 报告 `OWNER_SIDE_EFFECT_COUNT=0`；无下载、安装、构建、启动、服务停止、支付或运行时修改。GitHub 本轮仅追加文档结论与更新 Handoff。
- `VALIDATION`: 静态源码结果确认，但 `RUNTIME_PASS=NOT_TESTED`；Web `mem_limit: 8g` 为上限非最低；Node/pnpm 版本需隔离匹配。
- `ANOMALIES`: 少量 RAM 导致本轮预检无法安全进入演示。源码部分退款整笔置 `REFUNDED`、事件错误仅记录日志存在后续风险；未实测。
- `REVIEWER_DECISION`: **`RETURN_RESOURCE_HEADROOM_INSUFFICIENT`**，接受已取得的 G1 事实，不批准新的运行 Gate；详见 [Reviewer 决定](./docs/G1_REVIEWER_DECISION_20261017.md)。
- `ROLLBACK_EFFECT`: 无本机/Provider 更改，运行时回滚 `NOT_APPLICABLE`；文档变更通过 Git 记录。
- `RESOURCE_OR_BUSINESS_DELTA`: 仅项目文档修改，无成本、端口、账户、数据库或业务动作。
- `NEXT`: 等待资源改善后增量复测，或经 Owner 另行指定云端候选并进行只读费用/环境预检；不自动切换项目或修改已有系统。


## 2026-10-18 — OWNER_OVERRIDE_AND_G2_PRIVATE_DEMO_GATE_ISSUED

- `OWNER_DECISION`: Owner 明确指示「内存不设为限制条件，继续推进」；这是**取消固定空闲 RAM 作为 Gate 阻塞条件**的授权，不允许忽略实际 OOM/OS 异常/其他项目回归。
- `PREVIOUS_STATE`: G1 `RETURN_RESOURCE_HEADROOM_INSUFFICIENT` 仍是 2026-10-17 只读报告的历史事实，不删除、不伪改成 PASS。
- `REVIEWER_ACTION`: 签发 [G2 Velobase 私有演示 Gate](./docs/G2_VELOBASE_PRIVATE_PREVIEW_GATE_20261018.md)，锁定源码 commit `e88e259b974f883913f68ac74a9b8377765d005d` 和本机新 Docker Compose 项目 `saasvh-e88e259`，只做本地 UI/健康验证；动态资源实际异常触发停止，支付动作 0。
- `ACTUAL_RUNTIME_EXECUTION`: `NOT_STARTED`。本轮 ChatGPT 只操作 GitHub 项目文档，未访问 Owner 物理 Windows，不宣称本地安装/网页可达。
- `GOVERNANCE`: GitHub 当前 `entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 已读取，Owner 不要求也未授权修改治理规范。
- `NEXT`: 本地 Codex 直接执行已审 G2 Gate；结果返回后 Reviewer 依据真实证据判断是否完成首次预览，再进入 Stripe/裂变独立测试。


## 2026-10-18 — G2_REVIEWER_EXISTING_WORKLOAD_REGRESSION
- `AUTHORIZED_GATE`: `SAAS-G2-VH-PRIVATE-DOCKER-PREVIEW-20261018`
- `EXECUTOR_EVIDENCE`: [G2 执行证据](./docs/G2_EXECUTION_EVIDENCE_20261018.md) 已被 Reviewer 直接读取；本文是 `OWNER_RELAYED_EXECUTOR_REPORT`，不是对本机 Windows 的独立直接回读。相关截图尚未在可独立审查的文件中提供。
- `ACTUAL_CHANGES`: 以固定 SHA 构建/创建 G2 Web/Postgres/Redis、2 命名卷和网络，首页曾 200；三个原容器退出后执行器停止 G2。报告 G2 端口已关闭、源/镜像/卷/网络保留、未触碰旧项目配置。Reviewer 本轮只修改 GitHub 文档。
- `VALIDATION`: BUILD_CANDIDATE=PASS；UI_LANDING=PARTIAL；SIGNIN=PARTIAL；DASHBOARD/ADMIN/AFFILIATE/WORKER=UNVERIFIED；STRIPE/COMMISSION/REFUND=NOT_TESTED。
- `ANOMALY`: 三旧容器约 6 秒内退出（137/0/0），OOMKilled=false 且查询时间窗无 OOM event；根因 `UNKNOWN`，不能武断判定为内存/OOM 或直接归咎 Velobase。
- `REVIEWER_DECISION`: **`RETURN_EXISTING_WORKLOAD_REGRESSION`**；[详细审核](./docs/G2_REVIEWER_DECISION_20261018.md)。
- `ROLLBACK`: G2 容器停机并留资产；原容器仍退出的事实只限 G2 末次报告，不知现在是否恢复。
- `NEXT`: [G2R1 只读诊断 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)。禁止重启/恢复现有业务或重试 G2。
