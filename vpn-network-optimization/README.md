# VPN Network Optimization（可迁移 VPN 网络优化）

> 目标：把“自建 VPN 怎么配才更稳”沉淀成一套可验证、可回滚、可迁移到不同 VPS 的标准方案，而不是为某一台机器做一次性调参。

## 核心问题

当前自建 VPN 已能稳定连通，但在真实 Codex / OpenAI / 生图工作负载下仍可能出现尾部延迟、拥塞恢复慢、长任务卡顿等问题。项目要解决的是：

- 优化当前 VPN 的稳定性与长任务表现；
- 从 WireGuard、Hysteria2、MTU、UDP 转发、fq/BBR 等候选中筛出真正有效的最小配置；
- 不照抄单一文章或“一键优化脚本”，允许从官方文档和其他可靠来源引入更优方案；
- 把最终有效配置固化成可重复部署、可回滚、可验证的标准模板；
- 以后切换 DigitalOcean、Vultr、DMIT、HostDare 或其他 VPS 时直接复用。

## 当前基线

- 当前主力 VPS：DigitalOcean `24.199.118.137`；历史本地标签为 `SFO2-A`，fresh DigitalOcean metadata 实际 region 为 `sfo3`
- 当前公网 IP：`24.199.118.137`
- 当前主通道：WireGuard（当前生产/回退基线；IPv4 使用两个 /1 默认路由，严格 WFP kill-switch 已解除）
- 当前客户端：Windows；Clash Verge 2.5.6；当前 C2C Owner 侧 Mihomo 验证基线为 v1.19.32；历史 G2-C REALITY 互操作验证使用 Mihomo v1.19.31
- 当前 WireGuard active MTU：1420；历史 1280 仅保留为旧元数据，不是当前运行值
- 当前主要业务：Codex / OpenAI / AI 生图等长时间任务
- 最高约束：任何本项目动作不得干扰正在运行的前台任务

历史参考数据仅作为比较基线，不替代 G1 fresh read-back：

- 50 次短测：Median 约 0.595s，P95 约 0.773s，P99 约 0.985s
- 15 分钟低干扰测试：90/90 成功，Median 约 0.696s，P95 约 1.358s，P99 约 1.872s，>1s 为 13/90
- 2026-10-01 20:00 左右晚高峰 15 分钟：90/90 成功，平均约 0.845s，Median 约 0.756s，P95 约 1.628s，P99 约 2.190s；>1s 为 18/90，>1.5s 为 7/90，>2s 为 1/90；WG Ping 4/90 次无响应
- 同一晚高峰样本中，本机→VPS 公网 Ping Median 约 160ms、P95 约 187ms；WG 隧道 Ping Median 约 163ms、P95 约 180ms。说明基础 RTT 并未整体失控，当前重点更偏向尾部抖动、间歇性拥塞/重传及上游等待。WG Ping 无响应是路径抖动信号，不单独等同于已证明的传输层丢包率。

## 当前已知与待验证

- 已知：同一测试窗口内，WireGuard 与 HY2 均 60/60 成功；HY2 的 Median/P90/P95/P99 与慢请求尾部计数均更好。
- 已知：此前 HY2 连接失败的根因是 WireGuard Windows 严格 WFP kill-switch；修复后 UDP/8443、TLS、认证与证书 pinning 均通过。
- 待验证：晚高峰下该优势是否持续，以及 Codex / OpenAI / AI 生图等真实长任务是否实际受益；该验证后置到自动化与迁移能力基本完成后，作为最终封板前的真实场景验收。
- 已验证：Mihomo v1.19.31 REALITY 服务端先通过私网实现 A/B，随后公网 TCP/443 canary 也通过；动态物理出口 /32 路由命中，唯一一次 OpenAI 请求返回 curl 0 / HTTP 401，且临时 listener、runtime 与路由均完成清理。
- 待决策：最终 v1 采用 HY2 主通道、VLESS+REALITY TCP/443 备用、还是继续以 WireGuard 为主；以及最终 WireGuard 路由 / kill-switch 安全策略。

## MVP 范围

首版只解决最重要的部分：

1. WireGuard 当前配置与路径基线检查；
2. MTU / Keepalive 等 WireGuard 参数标准化；
3. Hysteria2 作为拥塞/高丢包场景的高性能候选；
4. VLESS + REALITY + XTLS Vision 作为 UDP 不可用/受限网络下的 TCP/443 互补候选；
5. Linux fq / BBR 只作为候选，先检查再决定是否应用；
6. 检查适用于 UDP VPN 出口的 GRO / forwarding 能力；
7. Clash Verge / Mihomo 作为客户端统一管理层，不强制替换现有 WireGuard 管理通道；
8. 自动部署、网络自适应、健康检查、回滚与迁移模板；
9. 先完成自动化与迁移能力，再在晚高峰/真实工作负载窗口做 HY2 / VLESS+REALITY / WireGuard 的最终代表性验证，筛选 v1 角色。

## 首版明确不做

- 不安装 3X-UI；
- 不引入 VLESS-Reality，除非后续证据表明需要；
- 不引入 TUIC 等更多协议，避免变量过多；
- 不使用魔改 BBR 或大批量 sysctl“一键优化”；
- 不做住宅 IP；
- 不做自动购买 VPS；
- 不在前台任务运行时切换路由、VPN 或应用系统级网络调优；
- 不为了 Speedtest 跑分牺牲长任务稳定性。

## 候选技术原则

- WireGuard：稳定基线；
- Hysteria2：高延迟 / 丢包 / 拥塞环境的增强候选；
- MTU：优先自动检测或按环境覆盖，不把单一数值永久写死；
- BBR / fq：只在适用场景使用，不视为 WireGuard/HY2 的万能加速器；
- Hysteria2：首版优先稳健默认拥塞控制，不直接照搬激进固定带宽；
- UDP GRO forwarding：作为 Linux UDP 转发节点的性能候选，按能力与证据决定；
- SQM / CAKE：若未来证明瓶颈来自本地 bufferbloat，再单独处理。

## 项目阶段

```text
P0   研究、范围冻结、立项                     ✅ PASS
G1   无干扰基线 + 可迁移第一版                ✅ PASS
G2   WG / HY2 / REALITY 多路径候选验证         ✅ PASS
G3-A 网络健康 / readiness / advisory          ✅ PASS
G3-B 迁移包 D1-D3（离线）                    ✅ PASS
G3-C 手动控制 / Synthetic UI                  ✅ PASS
G3-C C2C 包 + Secret scanner 修复             ✅ PASS
G3-C Secret Prepare 真实 Owner 主机复验       ✅ PASS
G3-C 真实 HY2-in-Clash canary R3R2           ✅ PASS
G3-B 新 VPS 真实迁移演练                      ⏸ DEFERRED
G4   晚高峰 + 真实工作负载最终验收            ⏳ PENDING
MVP v1 封板                                  ⏳ PENDING
```

当前顺序调整为：先完成 G2-C，再推进不依赖晚高峰时间窗口的 G3-A/G3-B；G4 放到近最终实现之后、MVP v1 封板之前。这样白天可以继续做确定性工程工作，晚高峰验证也会直接测到接近最终版本，而不是测一个随后还会变化的中间版本。G4 仍是封板前必做项，不因后置而取消。未来更换 VPS 使用同一模板部署并做 Provider Validation，不重新堆叠大量 Gate。

## 项目真相与 Reviewer 交接

唯一 Reviewer 当前真相：

- `REVIEWER_HANDOFF.md`

新 Reviewer 推荐读取顺序：

1. `REVIEWER_HANDOFF.md` — 当前状态、当前 Gate、授权边界、下一步；
2. `docs/REVIEWER_TRANSITION_2026-10-04.md` — 本次长对话收口后的完整已接受脉络；
3. `DECISION_LOG.md` — 已确认决策与理由；
4. `docs/G3C_C2C_REAL_HY2_CANARY_PACKAGE.md` — 当前真实 C2C canary 合同；
5. `EXECUTION_EVIDENCE.md` — 仅在需要证明具体事实时读取相关 Evidence。

`EXECUTOR_HANDOFF.md` 与 `EXECUTION_EVIDENCE.md` 记录执行事实与脱敏证据，不与 Reviewer Handoff 竞争。历史 Executor 中出现的旧 `Current` 标题不代表当前项目状态。

执行效率与超时复盘单独维护在 `docs/ROUND_TIMING_RETROSPECTIVE.md`，用于记录每轮预计/实际耗时、超时原因和流程优化，不改变项目真相层级。

## Secret 规则

任何私钥、密码、Token、HY2 认证值、证书私钥不得进入 GitHub、普通日志、Handoff 或聊天。项目仓库只保留变量名、位置、生成规则与非敏感模板。


## G2-A 已接受状态

- DigitalOcean sfo3 目标：`24.199.118.137`
- 当前生产通道：WireGuard，active MTU 1420
- Hysteria2：official v2.12.3，独立 systemd 服务，UDP 8443，已启动
- 当前流量：仍在 WireGuard；HY2 已通过临时 Mihomo 客户端完成真实握手和 60 次正式测试，但尚未作为持久默认客户端启用
- Clash Verge：2.5.6；Mihomo v1.19.31 / alpha-f103639 解析 HY2 + fingerprint 配置通过
- TLS：自签 P-256 + certificate fingerprint pinning
- Secret：未进入 GitHub / 聊天 / 普通日志；Windows DPAPI CurrentUser 恢复副本已验证
- Cloud Firewall：Owner 确认未绑定
- live BBR/fq/GRO/MTU 调优：未应用

G2-B 已完成：HY2 真实握手通过；同窗口 WireGuard 与 HY2 各 60/60 成功，HY2 在 Median/P90/P95/P99 与慢请求尾部计数上均更好。Owner 决定在最终封板前再补一个互补的 TCP/443 候选，因此 G2-C 新增 VLESS+REALITY 旁路集成。G2-C 已完成：私网实现 A/B 与公网 TCP/443 canary 均证明 Mihomo v1.19.31 在当前 VLESS+REALITY+Vision 语义下可互操作；公网 canary 的临时 /32 路由、listener、client/server runtime 均已清理，唯一请求预算已耗尽且不得重放。G3-A 已完成：动态物理出口发现、真实只读健康/readiness 采集、readiness→advisory plan 语义和 H2→H3 实时只读联调均 PASS；当前健康环境建议继续 `WIREGUARD_BASELINE`，HY2 与 REALITY 保持可单独激活候选，未实现或授权自动切换执行器。当前进入 G3-B VPS 迁移/回滚模板；G4 晚高峰 + 真实 Codex/生图工作负载验证仍作为 MVP v1 封板前最终真实场景验收。


## 当前交互目标

C2B synthetic UI、C2C package、Secret scanner 修复、R2R3V2 Owner 真实 Secret Prepare 复验以及 **R3R2 真实 HY2-in-Clash bounded canary 均已正式 PASS**。R3R2 已证明真实 Clash profile 生命周期中的 HY2 鉴权/连通性，并完成临时 profile、临时 /32 路由与运行时清理；WireGuard、系统代理、TUN 和路由快照均恢复到基线。下一步是单独设计并执行 G4 晚高峰 + 代表性真实工作负载最终验收，R3R2 的一次性授权不得复用。

连接连续性约束：
- Owner 的 ChatGPT 网页和 Codex Desktop 必须始终有至少一条可用 VPN。
- 当前 WireGuard 是主 VPN，但不是绝对不可断。
- 若后续测试确实需要断开 WireGuard，必须先由 Owner 切到另一条已确认可用的 VPN，并确认 ChatGPT/Codex 仍可通信，再进入对应 Gate。
- Executor 不得自行让 Owner 进入“无 VPN”状态。
