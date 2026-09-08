<div align="center">

# Project Library · 项目库

**一个仓库，多个彼此独立的项目目录。仓库根目录只做导航，不承载任何单个项目的运行文件。**

[English](./README_EN.md)

</div>

---

## 项目目录

| 项目 | 类型 | 状态 | 说明 |
|---|---|---|---|
| [Music Taste Analyzer](./music-taste-analyzer/) | 应用 / 工具 | Active | 授权音乐平台后生成音乐口味画像。 |
| [Unified Pay System](./unified-pay-system/) | 共享基础设施 | Active / Deploying | 一次部署、多个产品复用的统一支付与权益编排服务。 |

## 仓库结构

```text
project/
├── README.md
├── README_EN.md
├── .gitignore
├── .github/                  # 仓库级 CI / Automation
├── music-taste-analyzer/     # 独立项目
└── unified-pay-system/       # 独立项目 / 共享支付基础设施
```

## 仓库规则

1. **一个子目录 = 一个项目。**
2. 根目录只允许项目索引、仓库级 `.gitignore` 和 `.github/` 等全局文件。
3. `Dockerfile`、项目配置、部署脚本、运行包、项目 README 等必须放在对应项目目录内。
4. 新项目优先采用：`README.md + README_EN.md + CHANGELOG.md + PROJECT_RECORD.md + docs/` 的结构。
5. 任何密钥、`.env`、数据库密码、支付 Secret 都不得提交到仓库。

## 当前重点

### Unified Pay System

目标不是给每一个产品重复搭一套支付，而是维护一个共享的支付中台：

```text
多个产品 / 插件 / 网站 / App
            ↓
      Unified Pay Hub
            ↓
 Alipay / PayPal / GMPay / ...
            ↓
支付确认 → 权益 / License / Fulfillment
```

以后新增产品原则上只需要**登记 App + SKU + 履约方式**，而不是重新部署支付系统。

---

进入具体项目后，请以该项目自己的 README 和 PROJECT_RECORD 为准。
