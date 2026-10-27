# SPW API｜冰川折光 API 服务前端

基于 New API v1.0.0-rc.46，保留核心认证、权限、计费、网关与支付处理，只修改前端。面向外部用户的 SPW 品牌、首页、工作台、密钥、日志、模型广场与钱包已完成本地体验改造。

**当前状态与延期事项以 [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) 为准。** 本地前端阶段通过；线上部署、真实模型计费和支付接入均 DEFERRED_NOT_PASS，按 Owner 意愿暂时停在此阶段。

## 入口

- [当前交接](./REVIEWER_HANDOFF.md) · [执行证据](./EXECUTION_EVIDENCE.md)
- [设计与交付历史](./docs/DESIGN.md) · [本轮 Gate](./docs/GATE_CLOSEOUT_20261027.md)
- [重建与回滚](./docs/RECONSTRUCTION.md) · [源码清单](./SOURCE_MANIFEST.json)
- [验证摘要](./evidence/closeout-summary.json) · [配色对比度](./evidence/closeout-contrast-report.json)

## 本地入口与运行

页面 http://localhost:3000；API http://localhost:3000/v1；后端诊断 http://localhost:3001。仅本机绑定，没有公网生产部署。

现有本机部署目录执行 `docker compose -f compose.yaml up -d`。已有数据库和 .env 保留。不要为样式恢复数据库。

新目录重建先运行 `./scripts/reconstruct.ps1`；它检出固定上游并校验、覆盖全部 SPW 变更，拒绝覆盖已有 source/。目标环境的 Secret、初始化与数据迁移需要独立准备和验证，本归档不提供密码或会话密钥。

源码归档为精确上游＋完整改动文件覆盖层，包含所有此前尚未提交的本项目改动，不只是最后一份 CSS。无 node_modules、构建产物、DB、业务日志、Cookie、.env、凭据或敏感备份。

## 许可与素材

[上游 New API](https://github.com/QuantumNous/new-api) 的 AGPL-3.0、NOTICE 与第三方声明见 [licenses](./licenses/)。保留源码许可、版权头与页面归属。品牌 PNG 为本项目先前通过 OpenAI 生图生成的已选视觉，SPW 图标与页面样式为本项目改作；没有复制 React Bits/Animate UI 受附加条款约束的代码。实现为 AI 辅助开发。

治理参考 [VPS Project Governance v0.2.7](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md)。没有修改治理仓库。
