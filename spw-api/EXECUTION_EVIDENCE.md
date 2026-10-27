# SPW API — EXECUTION_EVIDENCE

## G-CLOSEOUT-20261027

- AUTHORIZED_GATE：Owner 2026-10-27 要求最小修复概览余额模块，排查相关问题、整理到 GitHub 项目库，项目暂时 PASS，线上部署与支付后续处理。
- PREFLIGHT_FACTS（DIRECT_READBACK）：本地源码 HEAD 与 GitHub 上游提交均为 7d8b91268dab69d7150f345c448b5e250163146a；原运行镜像与上一轮 workbench-report 一致。项目库 main 已有独立 saas-system，无 spw-api，本轮不改旧项目。备份镜像与目标 CSS/Compose 在修改前保留。
- ACTUAL_CHANGES：仅一份生产 CSS；移除固定深色变量/渐变，使用组件处的主题变量，降低水印强度，状态文字与语义图标分离，钱包按钮用 foreground/card 高对比配对。无 TS/TSX、API 或后端业务变更。
- OBJECTIVE_READBACK（BEHAVIORALLY_VERIFIED）：普通用户真实登录，余额为 $0，余额耗尽提示、钱包入口及无管理员菜单均可见。10 预设×2 明暗实测，背景随预设变化；状态文字、正文和钱包按钮对比度最低 11.63:1；原红字对比度在深色渐变两端约 2.59/3.21。采样时使用减少动态模拟避免采到颜色过渡中间值，完成后恢复原系统主题、默认预设与视口。
- VALIDATION：16 项概览/导航回归通过，tsgo -b 通过，目标 CSS 格式检查通过，生产构建成功，前端容器健康；代理 13/13（匿名对照，不是实际模型调用）；320px 无整页横向溢出；1440px 明暗与小屏截图已目视检查。
- REVIEW：独立只读复核确认展示范围；指出部分主色配对白字对比度风险后，本模块钱包按钮改为高对比配对，再重建并完成浏览器测量。没有修改全局主题来扩大范围。
- ANOMALIES：前端静态样式检查 0 FAIL / 0 WARN，2 项非阻断间距建议；首次颜色采样可能处于过渡中间值，已改为减少动态模式重新采集完整 20 组，正式报告只使用最终采样。无本轮业务故障。
- EVIDENCE_ARTIFACTS_AND_PURPOSE：evidence/closeout-summary.json 为本轮身份/计数；closeout-contrast-report.json 与 theme-samples 为对比度证据；closeout-balance-*.png 为实际普通用户页面；SOURCE_MANIFEST.json 与重建校验为完整源码覆盖层证据。
- ROLLBACK_EFFECT：前端镜像可回退至 pre-closeout-20261027；持久数据、会话配置、后端与原代理配置不变，不以 DB 回退样式。
- RESOURCE_OR_BUSINESS_DELTA：仅前端服务构建/重建，后端镜像和本机绑定端口不变；本轮无新增测试账户、真实上游调用、付款、退款、权限提升、数据删除或 Docker prune。普通用户仅正常登录与浏览器主题偏好验证。
- EXECUTOR_RESULT：LOCAL_PASS_CANDIDATE，GitHub 归档完成后独立回读再更新 Handoff；支付、生产和异机数据灾备不计入 PASS。

## 历史证据边界

上一轮 Workbench 合并回归 20 文件/201 项，之前整站回归 39 文件/628 项；它们为历史检查，不与本轮 16 项相加。归档内保留原报告的脱敏摘要以供续作，详细原始测试日志仍在本机 verification/。
