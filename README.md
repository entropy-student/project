<div align="center">

# 🗂️ Project Library（项目库）

### 一个用于长期沉淀、查阅和继续开发的个人项目仓库

**不是把不同项目文件堆在一起，而是让每个项目都有独立目录、独立说明、独立状态与独立交接记录。**

[English](./README_EN.md)

![Projects](https://img.shields.io/badge/projects-2-blue?style=flat-square)
![Language](https://img.shields.io/badge/language-中文%20%2B%20English-success?style=flat-square)
![Status](https://img.shields.io/badge/status-active-orange?style=flat-square)

</div>

---

## 当前 Projects

| Project | 主要解决什么问题 | 类型 | 状态 | 入口 |
|---|---|---|---:|---|
| 🎧 **Music Taste Analyzer（音乐口味分析器）** | 用户主动授权后读取私人歌单，并生成可解释的音乐口味画像 | App / Tool | Active | [进入](./music-taste-analyzer/) |
| 💳 **Unified Pay System（统一支付中台）** | 一次部署，多产品共享支付、验单、退款、对账与权益履约能力 | Shared Infrastructure | **Deploying** | [进入](./unified-pay-system/) |

---

## 这个仓库在做什么？

很多长期项目的问题不是“代码找不到”，而是：

- 项目散落在不同对话、不同文件夹和不同平台；
- 过一段时间后不知道做到哪一步；
- README 只介绍功能，却没有长期交接记录；
- 一个项目的部署文件会污染整个大仓库；
- 下一次继续开发时需要重新理解上下文。

这个仓库的目标是把每个真实项目整理成一个**可继续、可交接、可查阅**的独立项目单元：

```text
一个真实项目
    ↓
独立项目目录
    ↓
README / 状态 / 架构
    ↓
PROJECT_RECORD 长期记录
    ↓
代码 / 配置 / 部署资料
    ↓
持续迭代
```

---

## Project 的基本结构

不同项目可以按技术栈调整，但默认建议：

```text
project-name/
├── README.md           # 中文首页：是什么、怎么用、当前状态
├── README_EN.md        # 英文首页（需要时）
├── CHANGELOG.md        # 版本变化
├── PROJECT_RECORD.md   # 长期决策、当前进度、下一步、交接信息
├── docs/               # 架构 / 方法 / 深入说明
├── src/ / cmd/ ...     # 项目源码
├── config/             # 非敏感配置
├── deploy/ / railway/  # 项目自己的部署资料
└── assets/             # 图片与展示资源（如有）
```

不是所有项目都必须包含全部目录，但**任何属于某个项目的运行文件都应该留在自己的项目目录里**。

---

## 命名与整理规范

为了让大仓库长期可读：

- **文件夹 slug**：英文小写，例如 `music-taste-analyzer`；
- **展示名称**：优先采用 `English（中文）`；
- **一个一级子目录 = 一个项目**；
- 根目录只保留仓库导航与仓库级配置；
- `Dockerfile`、部署脚本、运行配置、项目文档不得散落到根目录；
- Secret、`.env`、私钥、数据库密码、支付 Secret 永远不进入 GitHub。

---

## 怎么使用这个仓库

如果只是查项目，先从上方项目表进入对应目录。

如果要继续开发某个项目，默认阅读顺序：

```text
README.md
   ↓
PROJECT_RECORD.md
   ↓
docs/
   ↓
代码 / 部署配置
```

其中 `PROJECT_RECORD.md` 用来回答四件事：

1. 这个项目最终要做到什么；
2. 已经完成了什么；
3. 当前卡在哪；
4. 下一步应该做什么。

---

## 当前重点：Unified Pay System

Unified Pay 正在被建设成一个**共享支付中台**，而不是某一个产品的专属支付模块：

```text
多个产品 / 插件 / 网站 / App
            ↓
      Unified Pay Hub
            ↓
 Alipay / PayPal / GMPay / ...
            ↓
统一订单 / 退款 / 对账
            ↓
License / Entitlement / Fulfillment
```

以后新增产品，原则上只需要：

```text
Register App
+ Register SKU
+ Configure Origins
+ Configure Fulfillment
```

而不是重新搭建一套支付系统。

---

## 设计原则

### 1. One project, one directory

一个项目的文档、运行文件和部署资料必须自洽，不污染仓库根目录。

### 2. Record before forgetting

重要决策、当前状态和下一步必须进入 `PROJECT_RECORD.md`，不能只存在聊天记录里。

### 3. Reuse infrastructure

支付、授权、部署骨架等可复用能力优先建设为共享基础设施，而不是每个项目复制一遍。

### 4. Keep secrets outside GitHub

项目可以记录 Secret 的“名字”和配置位置，但绝不能记录 Secret 的真实值。

### 5. Make continuation cheap

任何项目隔几个月重新打开，都应该能在几分钟内知道它是什么、做到哪、下一步是什么。

---

<div align="center">

### Build once. Record clearly. Continue easily.

**把一次开发，沉淀成以后还能继续使用的项目资产。**

</div>
