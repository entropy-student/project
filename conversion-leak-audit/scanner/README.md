# Conversion Leak Audit Scanner — G2 Safe Scanner V0

G2 Reviewer status: **PASS（local / CI / pre-production scope）**  
Decision: `PASS_G2_SAFE_SCANNER_V0_2026-09-17`

当前不是生产服务，不创建公网路由。

## API

- `GET /healthz`
- `POST /v1/scans`
- `GET /v1/scans/{scan_id}`
- `GET /v1/scans/{scan_id}/report`
- `DELETE /v1/scans/{scan_id}`

## 固定边界

```text
public URL
→ URL / DNS 安全 Gate
→ Scrapy 静态优先
→ 必要时 Playwright 只读兜底
→ Normalized Facts
→ 17 条冻结规则
→ Evidence-backed Decision
→ SQLite 任务 / 证据元数据
```

## 资源上限

- pages <= 6
- depth <= 1
- redirects <= 5
- response body <= 5 MiB
- total runtime <= 45s
- browser pages <= 2
- scan concurrency <= 1
- queued <= 5
- interactive action <= 1（当前实现实际为 0）

## SSRF / DNS rebinding

静态层：
1. 请求前检查 URL；
2. 全量检查 A/AAAA，任一非公网即拒绝；
3. 选择已验证公网地址写入 pin registry；
4. `TWISTED_DNS_RESOLVER` 在 `CrawlerProcess` 级安装；
5. Twisted 真正连接时只返回固定地址；
6. redirect request 再次经过安全中间件。

浏览器层：
- Chromium 使用 `--host-resolver-rules` 固定目标主机；
- 私网 / 非允许请求直接 abort；
- 跨主机 / 地区上下文不一致时停止，不为了覆盖率放宽。

真实 CI：

```text
Scrapy:   pinned=104.20.23.154 remote=104.20.23.154 PASS
Chromium: pinned=104.20.23.154 remote=104.20.23.154 PASS
```

## 明确不做

- 不登录；
- 不进入 checkout/payment；
- 不提交真实购买；
- 不绕过 robots / 403 / 429 / WAF；
- 不保存 Cookie / 登录态 / 表单值；
- 不长期保存原始 HTML；
- 不让模型自由生成 Issue。

## 数据

SQLite 只保存任务、bounded facts、规则决定与事实引用；原始 HTML 仅存在临时 worker 生命周期内。

## G2 最终证据

本地：
- Scanner tests: 55/55
- Frozen rule fixtures: 51/51
- Static facts fixtures: 12/12
- Multi-offer fixtures: 4/4
- Network guard fixtures: 21/21
- SQLite restart read-back: PASS
- queue/resource bounds: PASS
- evidence-less ISSUE: 0

联网：
- actual connection-time Scrapy/Twisted pinning: PASS
- actual Chromium server-address pinning: PASS
- real Gold facts: 26/26
- real rules: 28/28
- unexpected ISSUE: 0
- context misuse: 0

生产上线仍需独立 VPS / target-host / network-egress / storage / backup Gate；G2 PASS 不等于生产安全完成。
