# 重建、继续使用与恢复

## 本机继续使用

现有部署目录保留，`docker compose -f compose.yaml up -d` 可恢复已存在的服务。不要为样式回滚恢复数据库，不更换现有 `.env`，不删除 data/、logs/、backups/、verification/。本轮没有执行删除或项目卸载。

## GitHub 归档重建

归档采用固定上游＋完整改动文件覆盖层，避免保存一份难以追踪上游身份的重复仓库：

1. 将项目库的 `spw-api/` 下载到新目录。
2. 阅读 `SOURCE_MANIFEST.json`：固定上游为 QuantumNous/new-api commit `7d8b91268dab69d7150f345c448b5e250163146a`。
3. 运行 `scripts/reconstruct.ps1`。脚本拒绝覆盖已有 source/，检出固定提交后，逐项校验覆盖层 SHA-256 并还原到 source/。
4. source/web/package.json 与 bun.lock 沿用上游，不增依赖。Dockerfile.frontend 使用固定 Bun 镜像与 frozen lock。
5. 准备目标环境的独立会话配置后，才执行 `docker compose -f compose.yaml build frontend`。在线部署与跨机数据迁移不属于本次 PASS。

本轮可重建性验证使用本地保存的同一上游 Git 对象，导出到全新验证目录，应用归档覆盖层，检查所有文件摘要；没有依赖原脏工作树补漏，没有联网选择另一个版本。验证记录见 evidence/closeout-summary.json。完整上游不重复上传，保留 upstream URL、提交、许可与归属；若未来上游不可取得，需要独立保留基线源代码对象，不能只凭镜像恢复前端源码。

## 数据与 Secret 边界

归档只含源码、生成的公共品牌素材、非敏感部署配置及脱敏证据。它不含数据库、业务数据、密码、.env、Cookie、密钥或带 Secret 的备份。不能仅凭项目库恢复现有用户或会话；数据与 Secret 恢复需要 Owner 的独立保管和另一次验证。不得把源码重建称为完整业务灾备通过。

## 本机前端回滚

镜像 `spw-api-frontend:pre-closeout-20261027` 为本轮前已验证可运行的前端；相应 CSS/Compose/镜像 ID 位于本机 backups/pre-closeout-20261027。保留这些镜像和备份，不清理 Docker 缓存或其它项目资源。

```powershell
docker image tag spw-api-frontend:pre-closeout-20261027 spw-api-frontend:glacier
docker compose -f compose.yaml up -d --no-deps --no-build --pull never --wait frontend
```

回滚仅改前端服务，不恢复数据。恢复后检查首页、普通用户概览、/api/status 和代理验证。未来源代码重建不保证还原相同镜像二进制摘要，实际候选须重新验证并记录身份。

## 延期工作

公网部署、TLS/可信代理、生产灾备、真实上游模型与计费、SSE/WS 实际全链路、支付 TEST/回调/入账/幂等/退款均 `DEFERRED_NOT_PASS`。再次开始时另建目标明确的 Gate，不自动进入生产或真实交易。
