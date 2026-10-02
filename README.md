<div align="center">

# 🗂️ Project Library（项目库）

### 长期项目的统一入口、状态导航与交接仓库

**每个项目独立存放；根目录只做地图，不做第二套项目真相。**

[English](./README_EN.md)

![Projects](https://img.shields.io/badge/projects-14-blue?style=flat-square)
![Language](https://img.shields.io/badge/language-中文%20%2B%20English-success?style=flat-square)
![Status](https://img.shields.io/badge/status-active-orange?style=flat-square)

</div>

---

## Project 目录

> 下面只负责导航。项目阶段、当前 Gate、风险和下一步以各项目的 REVIEWER_HANDOFF.md 为准；没有 Handoff 的项目以项目自己的 README/状态文件为准。

### 基础设施与运行时

| Project | 主要用途 | 当前状态入口 |
|---|---|---|
| **Shared VPS Infrastructure** | Shared Hostinger VPS、共享网络、Caddy/Ingress、跨项目基础设施 | [Handoff](./shared-vps-infrastructure/REVIEWER_HANDOFF.md) |
| **Unified Pay System** | 统一支付、退款、对账与权益/履约基础能力 | [Handoff](./unified-pay-system/REVIEWER_HANDOFF.md) |
| **VPN Network Optimization** | 自建 VPN 稳定性、尾延迟、对照测试与可迁移部署/回滚 | [Handoff](./vpn-network-optimization/REVIEWER_HANDOFF.md) |
| **Dujiao-Next** | 商城运行时、商品/订单/支付/履约相关能力 | [Handoff](./dujiao-next/REVIEWER_HANDOFF.md) |
| **Xianyu** | 闲鱼自动化运行项目 | [Handoff](./xianyu/REVIEWER_HANDOFF.md) |

### 产品与商业项目

| Project | 主要用途 | 当前状态入口 |
|---|---|---|
| **Conversion Leak Audit** | 独立站转化漏损扫描、Top 3 诊断与后续修复队列 | [Handoff](./conversion-leak-audit/docs/REVIEWER_HANDOFF.md) |
| **Mini Craft Night Kit** | WordPress / WooCommerce 单品电商与跨境实物验证 | [Handoff](./mini-craft-night-kit/REVIEWER_HANDOFF.md) |
| **Birthday Magazine Studio** | 照片与回忆自动生成生日纪念杂志 | [Handoff](./birthday-magazine-studio/REVIEWER_HANDOFF.md) |
| **Family Cookbook Studio** | 手写/拍照食谱 OCR、校对、排版与家庭食谱成书 | [Handoff](./family-cookbook-studio/REVIEWER_HANDOFF.md) |
| **Music Taste Analyzer** | 私人歌单授权读取与可解释音乐口味画像 | [README](./music-taste-analyzer/) |

### 故事、视觉与媒体生产

| Project | 主要用途 | 当前状态入口 |
|---|---|---|
| **AI Story Showrunner** | 故事型知识视频的选题、文案、Timing、分镜、资产与 E2E 验证 | [Handoff](./ai-story-showrunner/REVIEWER_HANDOFF.md) |
| **Story Image Runner** | 受治理的本地浏览器生图队列、资产导出与后续 QA | [Handoff](./story-image-runner/REVIEWER_HANDOFF.md) |
| **Story Visual Asset Engine** | 视觉资产复用、生成/派生决策、角色/风格一致性与素材库 | [Handoff](./story-visual-asset-engine/REVIEWER_HANDOFF.md) |
| **Visual Narrative Animation Lab** | Visual Beat、有限动画与可复用叙事动画生产实验 | [Handoff](./visual-narrative-animation-lab/REVIEWER_HANDOFF.md) |

## 怎么继续一个项目

~~~text
仓库 README
→ 对应项目 REVIEWER_HANDOFF
→ 当前 Gate / 最新 accepted Evidence
→ 项目 README / docs / 代码 / 部署配置
~~~

原则：**根目录不维护动态项目状态副本。** 如果项目表和项目 Handoff 冲突，以项目当前 Handoff + fresh Evidence 为准。

## 推荐项目结构

~~~text
project-name/
├── README.md               # 项目概览与导航
├── REVIEWER_HANDOFF.md     # 当前项目 Reviewer 接受的状态真相
├── EXECUTION_EVIDENCE.md   # 执行事实与脱敏证据
├── docs/                   # Gate / 架构 / 研究 / 深入说明
├── src/ / cmd/ ...         # 源码
├── config/                 # 非敏感配置
├── deploy/                 # 项目自己的部署资料
└── assets/                 # 图片与展示资源（如有）
~~~

不是所有项目都必须包含全部目录。旧项目中的 PROJECT_RECORD.md、EXECUTOR_HANDOFF.md 等文件可以作为历史/兼容记录保留，但不应与 REVIEWER_HANDOFF.md 竞争 current truth。

## 仓库边界

- **一个一级项目目录 = 一个项目**。
- 根目录的 README、README_EN、.github 与仓库级配置不是项目。
- 根 docs/ 只保留既有仓库级/历史材料；新的项目文档、截图、运行产物必须进入对应项目目录。
- 项目的 Dockerfile、脚本、配置、Evidence、素材和部署文件不得继续散落到根目录。
- Secret、.env、私钥、支付/API Secret、Cookie、浏览器凭据、真实客户私密数据不得进入 GitHub。
- 共享能力应放在明确的 shared infrastructure 项目里，不通过根目录文件偷偷形成第二套基础设施。

## 当前治理约定

项目管理统一参考 [VPS Project Governance](https://github.com/entropy-student/spike.skill/tree/main/vps-project-governance)。

~~~text
Current State
→ Gate
→ Preflight
→ Execute
→ Evidence
→ Review
→ New State
~~~

旧项目不会为了目录整齐被批量重写；下一次正式接管时再按当前 Governance 做局部 reconciliation。

---

<div align="center">

### Build once. Record clearly. Continue easily.

**把一次开发，沉淀成以后还能继续使用的项目资产。**

</div>
