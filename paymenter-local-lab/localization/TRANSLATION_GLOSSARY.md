# Paymenter 简体中文 UI 术语表（G2）
只规定**界面可见文案**，保留程序内部 key、路由、代码命名及支付品牌原名；数据状态的内部枚举值仍为英文。

| 原界面字符串 | 简体中文 |
|---|---|
| Dashboard | 仪表盘 |
| Administration | 业务管理 |
| Configuration | 业务配置 |
| Extensions | 扩展功能 |
| System | 系统管理 |
| Revenue | 营收 |
| Net Revenue | 净营收 |
| New Orders | 新订单 |
| Increased by | 增长了 |
| Decreased by | 下降了 |
| Last 7 days | 最近 7 天 |
| Tickets | 工单 |
| Ticket | 工单 |
| Support | 客服支持 |
| Services | 服务 |
| Service | 服务 |
| Subject | 主题 |
| Status | 状态 |
| User | 用户 |
| Created At | 创建时间 |
| No ticket | 暂无工单 |
| Invoices | 发票 |
| Invoice | 发票 |
| Order | 订单 |
| Product | 商品 |
| Category | 分类 |
| Config Option | 配置选项 |
| Coupon | 优惠券 |
| Currency | 货币 |
| Custom Property | 自定义属性 |
| Role | 角色 |
| Search | 搜索 |
| General | 基本信息 |
| Pricing | 定价 |
| Upgrades | 升级选项 |
| Gateway | 支付网关 |
| Payment Gateway | 支付网关 |
| Sign out | 退出登录 |
| Exit Admin | 返回网站 |
| Remember me | 记住我 |
| Log in / Login | 登录 |
| Register | 注册 |
| Forgot password? | 忘记密码？ |
| Cart | 购物车 |
| Checkout | 结账 |
| Shop | 商店 |
| Home | 首页 |
| Account | 账号 |
| Password | 密码 |
| Save | 保存 |
| Create | 新建 |
| Edit | 编辑 |
| Delete | 删除 |
| Cancel | 取消 |
| Welcome to Paymenter! | 欢迎使用 Paymenter 本机试用版！ |
| No gateway | 暂无支付网关 |
| No record | 暂无记录 |

## 质量约束
1. 全站**中文简体**而不是现有`zh`目录使用的繁体文案；统一用户区“仪表盘/账号/服务/发票/工单”，后台“业务管理/业务配置/扩展功能/系统管理”。
2. 优先 Laravel/Filament 的翻译 API 与本机持久文件覆盖；不要用 CSS/JS 覆盖可见文本制造假汉化。
3. 系统状态/字段/变量只翻译显示名，不修改数据库值；表单占位符、复数、动态值语义与权限均需保持。
4. 管理后台真实业务页覆盖优先于开发工具/日志中的技术术语；新增英文技术术语可保留商标/协议。
