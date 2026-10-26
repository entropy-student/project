# Minshop Cloudflare Store｜免费云端商城实验

> **核心定位：本项目在网站测试时优先使用。**
>
> 在尚无 VPS、又不希望个人电脑长期保持开机的阶段，优先使用 Minshop + Cloudflare 免费额度建立可重复的 **网站展示 → Stripe 测试收款 → 订单 → 数字文件自动交付 → 退款/撤权** 验证闭环。**测试优先，不等于任何真实收费、正式上线或 Cloudflare 付费升级已获授权。**

## 上游项目与演示
- 开源源码：[ddyy/minshop](https://github.com/ddyy/minshop)（MIT；不要复制上游全仓库到本项目库）。
- 在线演示：[demo.minshop.dev](https://demo.minshop.dev/)（测试环境，不填写真实敏感信息）。
- Cloudflare 一键部署：[Deploy to Cloudflare](https://deploy.workers.cloudflare.com/?url=https://github.com/ddyy/minshop)。
- 上游换皮规范：[CUSTOMIZING.md](https://github.com/ddyy/minshop/blob/main/CUSTOMIZING.md)。
- 项目库当前状态：[REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md)；执行记录：[EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md)。

## 为什么优先使用
- **无需 VPS、无需电脑常开**：默认运行在 Cloudflare Workers，D1 保存商品/订单，R2 保存图片与私有数字商品文件。
- **已有完整可用商店**：商品展示、分类、搜索、购物车、立即购买、管理员后台、Stripe Checkout、Webhook、数字文件交付、退款事件同步、订单邮件。
- **前期改造少**：品牌、商品、价格、Stripe、邮件主要可在后台配置；颜色和页面排版只改自身 Astro 主题文件。
- **免费额度内先做小规模验证**：不是永久零费用承诺；流量/CPU、数据库/R2 与交易手续费仍要评估。
- **有限交付边界**：官方原生支持 PDF/ZIP/EPUB/音频/文本文件（文档列出每商品文件上传上限 25 MB）；卡密池、API 余额/用量、AI 动态生成商品不可当作已内置。

## 系统架构（目标，非已部署事实）
```text
买家浏览页面（Astro SSR on Cloudflare Workers）
      → Stripe Checkout（测试模式优先）
      → 签名 Webhook /api/webhook/stripe
      → D1 订单/权限
      → 私有 R2 FILES 下载
          （可选 Resend 邮件）
```
- 默认项目使用一个 Worker、一个 D1 数据库、两个 R2 桶（商品图片与私有下载），实际配额/资源是否创建须在部署 Gate 中读取证据。
- 不启用自建 Lightning 节点、Cloudflare Images、Vectorize/Workers AI 或其他可选服务，除非后续单独评估并授权。
- `FILES` 必须私有；不可开启 r2.dev 公网访问或绑定公共域名。

## 项目库文档
- [免费部署结论、限制与修改清单](./docs/FREE_DEPLOYMENT_AND_CUSTOMIZATION.md)：本轮调研的可复用事实与费用/容量边界。
- [G1 只读预检 Gate](./docs/G1_CLOUDFLARE_STRIPE_READONLY_PREFLIGHT_GATE.md)：下一轮开始前的身份、费用、资源、支付和恢复预检。
- [REVIEWER_HANDOFF](./REVIEWER_HANDOFF.md)：唯一动态状态面板。
- [EXECUTION_EVIDENCE](./EXECUTION_EVIDENCE.md)：追加式证据索引。

## 边界
本轮仅登记项目资料，不创建 Cloudflare Worker/D1/R2、不开通支付、不开真实订单、不进行退款、不修改任何既有网站/VPS/支付系统。密钥、真实客户数据、Webhook 签名原文及账户个人信息不得进入 GitHub 或普通交接材料。

治理依据：[VPS Project Governance v0.2.7](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md)，本目录不创建竞争性规则。
