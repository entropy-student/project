# 归档与本机文档清理

状态日期：2026-10-26。当前规范为根目录 DESIGN.md；当前运行状态以 REVIEWER_HANDOFF.md 加现场证据为准。

## 历史设计保留位置

设计提示词与方案说明的 canonical 历史位于 [GitHub docs/archive/design](https://github.com/entropy-student/project/tree/main/halo-spw-journal/docs/archive/design)。它们不再作为当前页面设计指令。本地 design 中的图片和 spike-reference 来源记录继续保留；组件 README 与许可证保留。

主要里程碑仍为：Fuwari 改版、放映室、三幕序章、SPIKE 星流、透明阅读与静态前台。当前风格与实现边界统一看 DESIGN.md，不从旧提示词重构现行目标。

## 本轮白名单

Gate：GOV-DOC-CLOSEOUT-20261026；分类均为 RECONSTRUCTIBLE_ARCHIVED_DOC。仅删除下表六份本地文件，不递归删除目录。

| 本地相对路径 | 字节 | 已读取远端 Git blob |
|---|---:|---|
| `design/cinema-20261025/hero-prompt.txt` | 1246 | `28a9da10d0df138c5db1ae2fca5c8ac9b5d078ac` |
| `design/concepts-20261025/README.md` | 1691 | `f78e2c63650236a85a1e8fd46bb51fbb982e791a` |
| `design/concepts-20261025/README-v2.md` | 3814 | `e1e3596cabe8aeaf69d3c260f1e74ce6e7afde60` |
| `design/concepts-20261025/prompt-v1.txt` | 4612 | `896134f39af7aae95358ddc26aa03b94ae2b1ca8` |
| `design/concepts-20261025/prompt-v2.txt` | 6057 | `9bec2a752098fa01aa9da9f064b1c8c0d17e53df` |
| `design/concepts-20261025/prompts-v2-single.txt` | 7251 | `c09870944e223eff883cbcad217270486001aeff` |

状态：CLEANUP_COMPLETE / PASS。2026-10-26T07:29:27Z 实际删除六个白名单文件，逻辑字节 24,671，原路径残留为 0。十四个保护路径仍存在，容器身份/停止状态及同级 Git 状态未变；公网首页、文章、搜索索引仍为 200，/console/ 为 404。

固定归档 commit：`b010874a225eeb1db95219987bb5082b470341a2`。每个 `design/<相对路径>` 对应远端 `halo-spw-journal/docs/archive/design/<相对路径>`。本轮已比对 Git blob 和全文，并在 verification/governance-20261026/reconstructed-design 下实际重建，六文件字节哈希均一致。总逻辑大小 24,671 字节。

## 重建与回退

后续 Agent 用 GitHub 插件 fetch_file，以仓库 `entropy-student/project`、上述固定 commit、对应远端路径读取；按原 UTF-8 字节写回本地 design 下原位置，再用 git hash-object 与表中 blob 对照。不要从后来修改过的 main 猜测旧内容。当前完整文档的修改前副本在本机 backups/docs-governance-20261026；其 8 文件哈希已逐一比对。

本轮重建证明和删除 read-back 保留在本机 verification/governance-20261026；远端只收录脱敏清理清单与结果。

## 明确保留的例外

- 当前 README、AGENTS、Handoff、Gate、Decision Log、Evidence、DESIGN、运维/开发/发布/恢复指南和组件 README：ACTIVE_DOC。
- design/spike-reference-20261025/README.md、上游 README、LICENSE/OFL/第三方来源：ACTIVE_PROVENANCE；仍有组件引用。
- .hallmark/before.json、before.txt：用途和敏感性未充分分类，UNKNOWN；本轮不读其全文、不删除、不上传。
- db、halo2、content、.env、LOCAL-ACCESS、backups、源码、组件、主题 ZIP、图片：DURABLE / RECOVERY / SECRET / ACTIVE_SOURCE，全部保留。
- .wrangler、运行日志、浏览器截图、临时报告：本轮不归档到 GitHub，不做宽泛缓存/日志清理。

## GitHub 与本地边界

档案仅在 entropy-student/project/main/halo-spw-journal 下；项目库根 README 只导航，不复制动态状态。此处未上传数据库、附件、原稿、凭据、私有恢复点或浏览器截图。Shared Git 无 HEAD 并不授权初始化独立历史或清理其他目录。

本轮是文档 closeout，不是整个项目的本地退役。完整恢复模型见 RECOVERY.md；文档可还原不等于运行数据可还原。
