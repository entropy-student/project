<div align="center">

# Project Library · 项目库

**把可运行项目按子目录独立归档，而不是让任何一个项目占据仓库根目录。**

[English](./README_EN.md) · [Music Taste Analyzer](./music-taste-analyzer/) · [Unified Pay System](./unified-pay-system/)

</div>

---

## 项目目录

| 项目 | 状态 | 简介 | 位置 |
|---|---|---|---|
| **Music Taste Analyzer** | Active | 用户主动授权音乐平台后，临时读取私人歌单并生成音乐口味画像；默认不把用户数据写入项目目录。 | [`music-taste-analyzer/`](./music-taste-analyzer/) |
| **Unified Pay System** | Archived / Existing | 可复用的支付编排与授权基础设施。该项目仅从仓库根目录归档迁移，内容未做功能性调整。 | [`unified-pay-system/`](./unified-pay-system/) |

## 仓库约定

```text
project/
├── README.md
├── README_EN.md
├── music-taste-analyzer/   # 当前维护项目
└── unified-pay-system/     # 已有项目，原样归档
```

- 一个子目录对应一个独立项目。
- 仓库根目录只承担**项目索引 / 导航**职责。
- 项目的代码、文档、构建脚本和依赖说明均保留在自己的子目录内。
- 新增项目时，不再把项目自身的 README、Dockerfile 或部署文件直接放到总项目库根目录。

## 当前重点

### Music Taste Analyzer

目标是把：

> **授权 → 私人歌单 → 数据清洗 → 行为/语义分析 → 音乐口味画像**

做成一个低配置、默认隐私友好、前后端一体的本地项目。

当前支持网易云音乐、QQ 音乐、酷狗音乐的页面扫码链路；汽水音乐保留上游歌单读取能力，但扫码登录仍处于不稳定状态。更多信息见 [`music-taste-analyzer/README.md`](./music-taste-analyzer/README.md)。

---

> 本仓库是多个独立项目的集合。进入具体子目录后，请以该项目自己的 README、许可证说明和第三方依赖声明为准。
