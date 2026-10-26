# G1 — Minshop Cloudflare / Stripe 只读预检 Gate（2026-10-26）

- **GATE_ID**: `MINSHOP-G1-CF-STRIPE-READONLY-PREFLIGHT-20261026`
- **OBJECTIVE**: 验证适用账号/免费配额与目标平台身份、R2 订阅和开通费用边界，核查 Minshop 原版运行兼容、部署资源预估、秘钥保管与恢复路线，形成下一 Gate 的可执行条件。
- **MAX_ENDPOINT_THIS_ROUND**: 只读结果包与 Reviewer 结论；最多更新项目本目录的脱敏状态和证据，**不**创建/安装云资源、不运行真实 Stripe 行为。
- **MANDATORY_REVIEW_STOP**: 只读清单完成即 `STOP_AT_REVIEWER`；不得自动进入部署。
- **TARGET_AND_SCOPE**: `entropy-student/project/minshop-cloudflare-store/` 及由 Owner 明确授权的 Cloudflare/Stripe TEST 控制台**只读**资料；不涉及其它已有 Worker、D1、R2、DNS、VPS、数据库或支付项目。
- **APPLICABLE_CRITICAL_CONSTRAINTS**: 目标先免费、零 VPS/PC 常开；Owner 授权任何账户侧付费、域名或真实交易；禁止 Secret 回显/导出、客户信息、未审公网；Github 项目库只存脱敏证据。
- **PREFLIGHT**:
  1. 新鲜核对 GitHub 已合并的 `REVIEWER_HANDOFF`、上游项目固定 SHA/许可证和官方一键部署入口；确定版本变动。
  2. Cloudflare 账户身份、Workers Free、当前 Worker 数量、D1 已用/可用个数和空间、R2 订阅状态及存储/操作额、Billing 是否可能触发收费：仅只读。如无访问权限标 `UNKNOWN`，不得猜测。
  3. Stripe TEST 账户是否可用、与将来商户身份的区别、Webhook 安全存放路线：只读；不读取/打印 Secret 值。
  4. 预估 Worker/一个 D1/两个 R2 的新资源名、项目隔离、域名及初始化管理员保护；现存冲突分类。
  5. 制定 D1/R2 备份/恢复、`AUTH_SECRET` 与 `SECRETS_KEK` 的恢复保管元数据与失效停机方案；不产生任何 Secret。
  6. 测试计划涵盖原版 Stripe TEST → 订单 → 私有 R2 下载 → 退款撤权、同事件重放和签名失败负例，确认所有资金动作单独授权。
- **REQUIRED_EVIDENCE**: 上游 SHA/许可证/部署说明来源；Cloudflare 账户控制面板的脱敏免费套餐/配额/资源数量读回（若不可获得，明确 `UNKNOWN`）；Stripe TEST 是否可用的脱敏事实；预算/资源冲突/恢复/保密计划；负面测试与验收清单。
- **ACCEPTANCE_CRITERIA**: 上述各事实有来源且可供 Reviewer 复查，所有关键未知项得到列明；没有资源与资金写操作；明确 G2 需要单独授权的目标/最大端点和回滚方案。G1 `PASS` 仅指只读预检通过，不等于任何部署/交易 PASS。
- **ROLLBACK_STATUS_OR_PLAN**: 只读，无云端/Provider 变更；文档可经 Git 回滚。若侦测已存在未归属资源/不明成本，停止并返回 Owner。
- **OWNER_ONLY_ACTIONS**: 云账户授权、R2 订阅开通及支付方式、Stripe 账户/KYC/Live 密钥、域名控制、费用套餐变更、真实收费/退款与任何不可逆活动；本 G1 都不自动执行。
- **REVIEWER_TO_EXECUTOR_RELAY**: 仅阅读本 Gate、项目 Handoff 的 `CURRENT_ACCEPTED_STATE`/`CRITICAL_CONSTRAINTS`、研究文档 §4–§7，以及上游固定 SHA 对应 README 与 Cloudflare 额度官方页面；先列可用的只读来源和目标身份，缺账户访问时用 `UNKNOWN` 返回。只收集脱敏事实/截图，不创建资源、不访问 Secret、不进入 G2；执行结束填入 `EXECUTION_EVIDENCE.md` 的 G1 新章节并停在 Reviewer。
- **EXECUTOR_TO_REVIEWER_RELAY**: 结果 `PASS_CANDIDATE/RETURN_*`；改动一句；验证一句；问题一句；回滚一句；请 Reviewer 检查一句；Owner 转交 `NONE` 或最小必要动作。
