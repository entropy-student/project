# Minshop｜免费部署、功能与改造清单

> 研究日期：2026-10-26。资料来源：上游官方 README/CUSTOMIZING 和 Cloudflare 官方文档；**文档核查不等于本人实例的运行测试**。最新额度以账户 Dashboard 和官方资料为准。

## 1. 基础链接
- 源码 / MIT：[GitHub ddyy/minshop](https://github.com/ddyy/minshop)
- 在线演示（上游测试站）：https://demo.minshop.dev/
- 一键创建实例：https://deploy.workers.cloudflare.com/?url=https://github.com/ddyy/minshop
- 换皮规范：https://github.com/ddyy/minshop/blob/main/CUSTOMIZING.md
- 官方额度：[Workers](https://developers.cloudflare.com/workers/platform/limits/) · [D1](https://developers.cloudflare.com/d1/platform/limits/) · [D1 计费](https://developers.cloudflare.com/d1/platform/pricing/) · [R2 计费](https://developers.cloudflare.com/r2/pricing/) · [R2 开通](https://developers.cloudflare.com/r2/get-started/)

## 2. 选型目的
**本项目在网站测试时优先使用。** 无需自购 VPS，无需 PC 常开；先用原版网站和 Stripe TEST 验证真实的支付成功签名通知、订单、数字文件交付、退款失效，再仅改自己的品牌和商品。不是 API 中转系统的现成替代品。

## 3. 已有功能（上游源码/README 声明）
- **商店**：商品/详情、分类、FTS 搜索、购物车、立即购买、商品图片及库存管理。
- **管理**：设置向导、产品/分类/媒体/页面/订单/客户、CSV 导出。
- **支付**：Stripe Checkout，Stripe Webhook；另有演示支付、Lightning、OpenNode，初期不开额外渠道。
- **交付**：PDF、ZIP、EPUB、MP3、M4A、TXT 上传（上游目前记载单文件 25MB），私有 FILES R2 受保护下载；全额退款后不允许继续访问下载；已被买家下载的文件不可追回。
- **辅助**：优惠码、可选 Stripe Tax、Resend/Cloudflare Email、Markdown 页面、主题文件、Turnstile、可选 MCP/Agent API。
- **不已内置**：通用卡密自动分配、API 用户充值与用量计费、AI 定制内容生成。此类需求应另立受审业务交付 Gate，而不是当成换商品即可使用。

## 4. 免费额度（全部为**账户共享**）
| 项 | Workers Free / Cloudflare 免费档 | 影响 |
|---|---|---|
| Worker 数量 | 100 个 / 账户 | 多个站可分别用 Worker |
| Worker 请求 | 100,000 次/天，共享 | 计入多站页面、图片与接口调用 |
| Worker CPU | 单请求 10ms | SSR/支付路由仍须真实测量 |
| D1 数据库数 | **10 个 / 账户** | 独立 Minshop 默认每站 1 个 D1，理论约 10 站的结构性上限 |
| 单 D1 大小 | 500 MB | 单站数据过大先触发 |
| D1 总空间 | 5 GB / 账户 | 多站共享 |
| D1 查询行 | 500 万行读/天、10 万行写/天 | 多站共享 |
| R2 标准存储 | 10 GB-month/月 | 公共商品图片 + 私有文件共用 |
| R2 操作 | A 类 100 万/月、B 类 1000 万/月 | 需留意商品下载和图像频率 |

- **多站建议**：从 **1 个**开始，后期将 **3–5 个**作为保守运营规划；**最多约 10 个**只是“一个 D1/店且账户没有其他 D1”情况下的理论结构上限，**不是稳定运行的保证**。现有 D1 数量会减少可用名额。静态站不必每站占一个 D1，不可把“最多 10 个商城”误写为“Cloudflare 只能托管 10 个网站”。
- 请求举例：5 站 × 每站 300 访客/天 × 10 Worker 请求/访客 ≈ 15,000 请求/天，仅为模型假设，非实测承载能力；还未计 CPU、数据库与 R2。
- **费用风险**：Stripe 正式交易手续费、税务相关服务与超额度/付费资源可能发生费用；R2 需先激活订阅，可能要求绑定支付方式。Resend 有独立免费额度（以其当期规则为准）。不启用图片付费优化、AI 搜索、Cloudflare 原生邮件（Workers Paid）等可选服务。
- **免费档不限于实测前提**：既不承诺 Cloudflare 永久不涨价，也不承诺默认站点永远不触发 10ms CPU 限制或请求数阈值。测试期间必须按账户读回统计。

## 5. 按上游推荐的一键部署路线（**尚未执行**）
1. 在 Owner 自己的 Cloudflare 中检查 Workers Free、D1、R2 订阅/配额和计费风险；如需 R2 订阅开通/支付方式，属于 Owner 检查点。
2. 用官方 Deploy to Cloudflare 按钮克隆项目、部署 Worker，预期自动创建 1 个 D1 与 2 个 R2，实际创建名单、资源隔离与花费须读回。
3. 使用安全执行环境 **分别随机生成** 两个独立 Secret：`AUTH_SECRET`、`SECRETS_KEK`；不得在 GitHub、聊天、日志、PR 或本资料里保存其值，也不得丢失加密密钥恢复路径。
4. 在 `/admin/setup` **立即**设管理员密码；设置前向导可被访问，完成初始化前应限缩公网访问或用 Cloudflare Access。
5. 后台 `Settings → Payments → Card (Stripe)` 填测试模式 `sk_test_`，配置 Stripe TEST Webhook `https://<实例域名>/api/webhook/stripe`。按上游要求至少处理 `checkout.session.completed`、`checkout.session.async_payment_succeeded`、`checkout.session.async_payment_failed`、`checkout.session.expired`、`charge.refunded`。`whsec_` 只能在受保护配置填写。
6. 创建测试数字商品，设置无需物流，上传测试文件。支付 → Stripe 端 success → 本地订单 paid → 可下载 → 退款后新请求不可下载；还需签名失败、重放防重、支付后异步失败/到期等负例。
7. 仅当原版验收通过，再按主题说明换品牌/字体/卡片/页面；变更后执行上游提供的检查与重部署。
8. 真正 Live/公开正式运营、真实费用、真实退款、其他供应商渠道均需另立 Gate、Owner 授权，不能由本记录自动推动。

## 6. 变成自己的项目需要改哪些
| 项目 | 修改位置 | 是否改代码 |
|---|---|---|
| 商城名字/时区、支付通道、邮件、优惠、内容页面 | `/admin/settings` 和 Admin 功能区 | 否 |
| 商品名称、价格、描述、图片、现成 PDF/ZIP 等 | `/admin/products` 等 | 否 |
| Stripe TEST/Live 密钥与 webhook 签名密钥 | Cloudflare 密文存储/后台与 Stripe 控制台 | 配置；Live 要另行授权 |
| 配色/字体/圆角 | `src/themes/<your-theme>/tokens.css` | 是，轻量 |
| 导航/页脚/商品卡片/首页目录/商品详情 | 自己的主题 `Header.astro`、`Footer.astro`、`ProductCard.astro`、`Catalog.astro`、`ProductDetail.astro` | 是 |
| 币种、favicon | `src/store.config.ts`、`public/favicon.*` | 是；币种改动可能牵涉既有商品数据，不可随意 Live 切换 |
| API 额度、卡密、动态 AI 生成 | 支付后的专属业务交付模块 | **要新增设计与开发** |

上游换皮约束：不得删掉依赖的购物车/搜索/购买表单控件及其数据标记；保留系统生成的价格与权限边界，不在前端自行计算支付价格；`src/features/` 属于核心上游，不为了美观修改。检查命令见官方文档：`npm run theme:check`、`npm run test:storefront-contract`、`npm run verify`。

## 7. 预设验收与风险
- **安全**：管理员初始入口、强密码、受保护的私有 FILES、Secret 长期恢复、Webhook 真实性与币种/金额/订单关联。
- **支付**：支付模式与商家身份、一次性/部分/全额退款、至少一次事件投递与幂等、Stripe 成功和本地 paid 必须分别验证；退款并不等于能删除买家已下载的副本。
- **恢复**：D1 Time Travel 免费档回溯窗口与 R2 对象/密钥恢复并不是一个东西，须准备适用备份和恢复演练；云端数据库或文件不能只依赖 GitHub 代码备份。
- **成本**：R2 和外部邮件都有独立用量；低 Star/年轻项目的可靠性只能通过压力、故障与业务回归验证，不能凭 README 声称生产成熟。
- **性能**：Cloudflare Workers 10ms CPU 限制，实际部署后压测初期主要路径并读回用量；不同国家访问质量需另验。
- **数据合规**：对外真实售卖前还需确认主体、Stripe Live 可用性、税费、退款政策、用户数据披露与交易邮件配置。

## 8. 本轮未做的事
未连接 Owner Cloudflare / Stripe、未创建任何真实 Worker、D1、R2，未运行应用或用户交易，未实测官方演示站的后台功能。**研究为部署决策输入，不是验收 PASS。**
