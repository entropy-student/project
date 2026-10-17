# SaaS System Lab｜下一位 Reviewer 完整交接（2026-10-18）

> PROJECT_REPOSITORY=`https://github.com/entropy-student/project`
> CANONICAL_DIRECTORY=`main:saas-system/`
> CURRENT_TRUTH=`saas-system/REVIEWER_HANDOFF.md`
> GOVERNANCE=`https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md` v0.2.7 ACTIVE_PROVISIONAL
> CURRENT_EXECUTION_GATE=`NONE`
> FINAL_REVIEWED_STATUS=`G2_RETURN_EXISTING_WORKLOAD_REGRESSION / G2R1_PARTIAL_G2R1_OWNER_CLASSIFICATION_UNKNOWN / CAUSE_UNKNOWN / OWNER_DECISION_PENDING`
> THIS_FILE=HANDOFF_SNAPSHOT_NOT_COMPETING_CURRENT_TRUTH

## 1. 为什么有这个项目、要达到什么结果

Owner 建立独立 **SaaS System Lab**，要找到一套能反复换产品的免费/开源 SaaS 底座，而非只有官网外观、只有商城、只有后台的项目。理想能力：营销公开首页、注册登录、实际可用的用户 Dashboard、**真正平台 Admin**、Stripe 一次性支付/订阅、客户分享推荐链接与注册关系、佣金或额度/会员奖励、续费、全额/部分退款正确撤权、幂等补偿、可运营可维护。先追求**快速实际使用并看到完整界面**，之后才验证真实支付/裂变。

**严格候选顺序**：① [Velobase Harness](https://github.com/velobase/velobase-harness)；② [Wasp Open SaaS](https://github.com/wasp-lang/open-saas)；③ [DevDojo Wave](https://github.com/thedevdojo/wave)。三者串行，未允许并行运行。Docker **不是**必选，可以考虑本机 Node、独立 VPS 或云部署；不得不经 Owner 同意制造额外费用/账号。

既有 Paymenter 项目先前已移除/结束；本项目不可恢复它、共用其配置，也不接管其他 Stripe/WordPress/Woo/Docker/网络项目。跨项目支付/财务系统完全独立。

## 2. 当前权威资料的最短阅读路线

1. [唯一动态状态 Handoff](../REVIEWER_HANDOFF.md) —— 从这里确认当时的 CURRENT_STAGE、CURRENT_GATE、NEXT_STEP 和 Owner 决定。
2. [G2R1 正式 Reviewer 裁定](./G2R1_REVIEWER_DECISION_20261018.md) 与 [G2R1 已结束的只读 Gate](./G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)。
3. [G2 Executor 脱敏执行记录](./G2_EXECUTION_EVIDENCE_20261018.md) 与 [G2 Reviewer 裁定](./G2_REVIEWER_DECISION_20261018.md)。
4. [项目增量执行历史](../EXECUTION_EVIDENCE.md) 与 [三项目串行计划](./SERIAL_EXPERIMENT_PLAN.md)。
5. 若涉及新执行任务，按现行 [Governance VNEXT](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md) 在 GitHub 读取适用规定（v0.2.7，§0–10/§11 triggers/§12–13 和实际触发的 §11A/B/C/D/E 等）。没有新 Gate 时不得执行写操作。

保留每轮历史 RETURN、PARTIAL 及证据，不用“已构建”“首页曾打开”覆盖当前运行状态。Reviewer 只通过 GitHub 阅读脱敏汇报，**没有直接访问用户物理 Windows / Docker Engine**；对本机事实统一标记 `OWNER_RELAYED_EXECUTOR_REPORT`，不虚构实时状态。

## 3. 阶段进度与关键决定

| 阶段 | 当前结论 | 客观范围 |
| --- | --- | --- |
| G0 立项 | **PASS** | `saas-system/` 独立目录、项目目标、三候选实验计划、Gate、统一状态与 Evidence 均在 main。 |
| G1 Velobase 只读预检 | **REVIEWED RETURN（历史）** | 固定 SHA、MIT、Demo Compose、Stripe/Affiliate 源码核查；当时因本机 RAM 可用仅 1.12/1.55 GiB 不建议启动。 |
| Owner 新指示（2026-10-18） | **有效** | “内存不设为限制条件，继续推进”：**没有固定最低空闲 RAM 作为前置 Gate**，并不是允许 OOM、系统受损、既有项目故障后盲目续跑。 |
| G2 Velobase 本机私有 Demo | **RETURN_EXISTING_WORKLOAD_REGRESSION** | 固定 SHA 构建成功、Web/Postgres/Redis 曾启动、首页曾 HTTP 200、显示本地管理员入口；原有三个容器在运行期间相继退出，所以只停止 G2。没有通过完整 SaaS 功能验收。 |
| G2R1 原有容器退出只读诊断 | **PARTIAL_G2R1_OWNER_CLASSIFICATION_UNKNOWN** | 有界调查已完成，三个原容器仍退出，真实原因 `CAUSE_UNKNOWN`，它们具体属于什么业务仍未知；不为凑 PASS 继续重复同类诊断。 |
| 后续 Velobase + Open SaaS + Wave | **PENDING** | 没有新 Gate 或费用批准；三候选顺序未变。 |

## 4. Velobase 已建立的真实实验资产

- 固定上游 `velobase/velobase-harness@e88e259b974f883913f68ac74a9b8377765d005d`、MIT；只查固定 commit，不用移动 `main` 重构已接受证据。
- Owner Windows 11 Home build 26300；本机源码目录 `%USERPROFILE%\Documents\ChatGPT\Velobase-Harness-e88e259`；Git `2.53.0`、Node `v24.19.0`、pnpm `11.25.0`；Docker Engine `29.7.2`、Compose `5.4.0`。这些是当时实测，**不是下一次可直接假定的当前状态**。
- G2 运行的是原生 `compose.demo.yml`、`Dockerfile.demo`；新 Compose project `saasvh-e88e259`，`web/postgres/redis` 三服务，唯一宿主绑定 `127.0.0.1:3003`。没有对 DB/Redis 公布宿主端口，没有应用覆盖文件。Web 容器 `mem_limit: 8g` 被 Engine 接受，**只是上限非最低内存需求**。
- 源码、Web 镜像、Compose 项目网络、两卷（上游服务级标识 `demo_state`、`preview_data`，实际 Docker 卷有项目命名空间）已保留。**G2R1 时 Web/Postgres/Redis 均 stopped、3003 无监听**；没有启动 Velobase 或做任何清理。勿执行 `down -v`、`docker system prune`、全局 Docker/WSL 改配或停止旧服务。
- 构建成功、锁文件依赖安装成功、Prisma Client 生成成功，Postgres/Redis 曾健康。G2 测得 Web 峰值 `≈3.866 GiB / 396.51% CPU`，Windows 可用 RAM 在预检约 `0.36 GiB`、运行最低约 `0.27 GiB`，G2 时磁盘可用约 `169.52 GiB`。这些数值不证明 OOM，也不自动允许重启。
- UI 验收矩阵：Landing 首页曾 200、截图据称在 Codex 浏览器会话中拍摄但未提供独立截图文件；登录弹窗显示“以本地管理员身份体验”，点击后请求超时，**未证明登录成功**；`/dashboard`、`/admin` 8 秒超时，正负管理员权限未验；`/affiliate` 307 重定向不是功能 PASS，`/account/affiliate` 超时；Worker 独立健康未验。当前不能交付可持续在线 Demo。
- 外部 Stripe 账户、TEST/Live Webhook、付费、退款、付款人身份、提现、推广登记与积分发放等**均未实施或验收**。不得要求真实 API Key 作为本机 UI 预览条件。

## 5. G2R1 三个既有容器的准确状态（本轮重点）

下面是 Owner 转交的本机 Codex 允许披露的**脱敏指纹**，不是可拿来直接执行 Docker 命令的完整 ID：

| 旧容器 | 脱敏指纹 | G2R1 当前状态 | Exit code | UTC FinishedAt | OOMKilled | Restart policy / count |
| --- | --- | --- | ---: | --- | --- | --- |
| A | `B1A52AC5143F8D42` | `exited` | **137** | **2026-10-17 16:32:30.385** | false | no / 0 |
| B | `F80E1D715DDC2D45` | `exited` | **0** | **2026-10-17 16:32:33.652** | false | no / 0 |
| C | `EA4E534D3ECBA0DE` | `exited` | **0** | **2026-10-17 16:32:36.264** | false | no / 0 |

三者来自**同一已脱敏 Compose 项目**，约 **5.9 秒**内相继退出。已报告当前健康字段一项 `unhealthy`、另两项 `none`，不能据此推知退出前健康状态；业务类型/生产属性/所属 Owner 未知。三者此时没有任何自动重启记录，**G2R1 也没有恢复它们**。

G2R1 排查覆盖：Docker events 查询退出前后各约 5 分钟，返回 0 条，但 Docker 事件留存覆盖范围未知；Docker Desktop 后端进程启动早于事发窗口，未获得该窗口重启直接证据；G2 没有保存当时 Engine ID，无法确认 G2 与 G2R1 始终是同一 Engine 实例。Windows System 同一窄窗口无匹配；Application 有 4 条但无 Docker/WSL/Hyper-V/资源耗尽/关机相关匹配；相关 WSL/Hyper-V Operational 通道不可用或无权限。主机与 Engine 成对时钟当时相差约 **1 秒**。

**根因最终为 `CAUSE_UNKNOWN`**：同时退出、低内存、Web 内存/CPU 负载均不等于证明由 Velobase 造成 OOM。Docker Engine 重启、共同停止、独立退出、宿主机压力等均未充分证实或排除。**无证据证明 Velobase 直接杀死三个容器，也不能因为这一点就否认 G2 期间真实发生了其他工作负载回退。**

## 6. 上游静态业务风险（未来不能遗漏）

Velobase 有免费开源 Affiliate/佣金账本以及 Stripe/积分源码，尚无运行 PASS；静态源码提示：（1）`src/server/order/services/refund-payment.ts` 接受部分退款金额但随后直接将 Payment/Order 标为 `REFUNDED` 并发出退款事件，可能整笔反转佣金；（2）`src/server/modules/affiliate.ts` 和事件总线在部分错误路径仅记录警告，持久化重试/对账需验证；（3）示例佣金率 **30%**、Stripe 冻结 **30 天**，累计支付资格 **$4.99**、最低人工提现 **$50**。提现不是已验证的自动银行结算；推荐人和被推荐人双向返利/赠会员期限也未证实内置。以上风险针对未来交易 Gate，不阻止仅 UI 的私有浏览验收，但**禁止在修复与测试前宣称生产资金闭环可靠**。

Open SaaS（Wasp）/Wave（Laravel）未开始任何独立本机/云运行：二者 Stripe 和基础用户/后台均有上游开源实现研究，现成免费裂变不如 Velobase，需各自正式核验，不能将研究当运行事实。

## 7. 授权边界、当前进展和下一位 Reviewer 要回答的问题

`CURRENT_GATE=NONE`，所以**下一位 Reviewer 接手时不能直接执行任何写动作**。原 G2/G2R1 Gates 均已结束，不能复用原授权。当前完整进度：

```text
G0   项目初始化                   PASS
G1   Velobase 只读预检           REVIEWED（历史 RAM RETURN）
G2   Velobase 构建+私有演示       RETURN_EXISTING_WORKLOAD_REGRESSION
G2R1 三旧容器退出原因有界调查    PARTIAL / CAUSE_UNKNOWN（调查已结束）
NEXT 旧业务恢复必要性与去向决策  OWNER_DECISION_PENDING
G3   Open SaaS                 PENDING
G4   Wave                      PENDING
G5   三方案选型                  PENDING
```

**Owner 未决定的唯一即时问题**：这三个已经退出的旧容器是否还需要恢复？如果不知道是什么，下一步只需要在**真实本机**的受控边界识别真实 Compose 项目及是否有重要业务，不能在对话里输出 Secret 或先恢复。Owner 明确要恢复时，归属项目先作最小前置核验（身份、服务范围、健康、数据/Secret、影响与恢复方式），另签项目专属恢复 Gate；否则明确记录为有意保留停止，不能随意删除。

随后针对 SaaS：优先提出不依赖现有共享 Docker Engine 的**独立隔离测试路径**，说明 VPS/云端费用、授权、部署复杂度；任何付费/开通/安装/公网开放都需要 Owner 新决定与新 Gate。保留 G2 已有构建、源码和资产，不以“排除所有理论根因”为前提反复诊断或同机复现。**先让 Owner 真正看到可靠的用户 Dashboard 和 Admin 页面，随后再开启 Stripe TEST/佣金/部分退款单独 Gate。**

新 Reviewer 的职责是独立评估是否仍有关键遗漏、是否需要最小修正，再向 Owner 说明下一步及唯一必要决定；不自称 G2R1 原因已找到，不拿云端或模型上下文当 Windows 直接证据。无必要不修改全局 Governance、不动其他项目、不扩大工程边界。

## 8. 证据与历史归档引用

- [2026-10-18 G2R1 Reviewer 裁定](./G2R1_REVIEWER_DECISION_20261018.md)
- [2026-10-18 G2R1 诊断 Gate](./G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)
- [2026-10-18 G2 Executor 执行证据](./G2_EXECUTION_EVIDENCE_20261018.md)
- [2026-10-18 G2 Reviewer 裁定](./G2_REVIEWER_DECISION_20261018.md)
- [2026-10-18 G2 原始运行 Gate](./G2_VELOBASE_PRIVATE_PREVIEW_GATE_20261018.md)
- [2026-10-17 G1 Reviewer 裁定](./G1_REVIEWER_DECISION_20261017.md)
- [2026-10-17 G1 原始只读 Gate](./G1_VELOBASE_READONLY_GATE.md)
- [项目工作 Evidence](../EXECUTION_EVIDENCE.md)
- [项目状态权威](../REVIEWER_HANDOFF.md)
- [统一项目管理规范](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md)
