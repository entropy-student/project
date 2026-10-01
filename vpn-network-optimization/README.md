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

- 当前主力 VPS：DigitalOcean SFO2-A
- 当前公网 IP：`24.199.118.137`
- 当前主通道：WireGuard
- 当前客户端：Windows；已安装 Clash Verge（具体版本 / Mihomo 内核版本待 G1 fresh read-back）
- 当前 WireGuard 历史 MTU：1280（是否继续固定待验证）
- 当前主要业务：Codex / OpenAI / AI 生图等长时间任务
- 最高约束：任何本项目动作不得干扰正在运行的前台任务

历史参考数据仅作为比较基线，不替代 G1 fresh read-back：

- 50 次短测：Median 约 0.595s，P95 约 0.773s，P99 约 0.985s
- 15 分钟低干扰测试：90/90 成功，Median 约 0.696s，P95 约 1.358s，P99 约 1.872s，>1s 为 13/90
- 2026-10-01 20:00 左右晚高峰 15 分钟：90/90 成功，平均约 0.845s，Median 约 0.756s，P95 约 1.628s，P99 约 2.190s；>1s 为 18/90，>1.5s 为 7/90，>2s 为 1/90；WG Ping 4/90 次无响应
- 同一晚高峰样本中，本机→VPS 公网 Ping Median 约 160ms、P95 约 187ms；WG 隧道 Ping Median 约 163ms、P95 约 180ms。说明基础 RTT 并未整体失控，当前重点更偏向尾部抖动、间歇性拥塞/重传及上游等待。WG Ping 无响应是路径抖动信号，不单独等同于已证明的传输层丢包率。

## 当前问题假设

现有证据更支持“基础 RTT 尚可，但晚高峰尾部恶化”的方向，而不是单纯的高基础延迟问题。G1 应优先只读检查可能影响 UDP VPN 转发与路径稳定性的因素；不得把该假设写成已证实根因。

## MVP 范围

首版只解决最重要的部分：

1. WireGuard 当前配置与路径基线检查；
2. MTU / Keepalive 等 WireGuard 参数标准化；
3. Hysteria2 作为拥塞/高丢包场景的备用通道候选；
4. Linux fq / BBR 只作为候选，先检查再决定是否应用；
5. 检查适用于 UDP VPN 出口的 GRO / forwarding 能力；
6. Clash Verge 作为客户端统一管理候选，不强制替换现有 WireGuard 客户端；
7. 自动部署、健康检查、回滚与迁移模板；
8. 后续安全窗口内再做网络与真实 Codex A/B，筛选最终 v1 配置。

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
P0  研究、范围冻结、立项            ✅
G1  无干扰基线 + 可迁移第一版       ← CURRENT
G2  安全窗口验证 + v1 封板           ⏳
```

G2 完成后即视为 MVP 完成。未来更换 VPS 使用同一模板部署并做 Provider Validation，不重新堆叠大量 Gate。

## 项目真相

唯一 Reviewer 当前真相：

- `REVIEWER_HANDOFF.md`

进入执行阶段后，`EXECUTOR_HANDOFF.md` 与 `EXECUTION_EVIDENCE.md` 只记录执行事实与脱敏证据，不与 Reviewer Handoff 竞争。

## Secret 规则

任何私钥、密码、Token、HY2 认证值、证书私钥不得进入 GitHub、普通日志、Handoff 或聊天。项目仓库只保留变量名、位置、生成规则与非敏感模板。
