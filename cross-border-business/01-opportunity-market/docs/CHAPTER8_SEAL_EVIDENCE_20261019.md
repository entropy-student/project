# 第⑧章｜Owner授权Reviewer定向修订及正式封板证据（2026-10-19）

> **OWNER_AUTHORIZED_DIRECT_REPAIR / FINAL_SEALED / STOP_WAIT_OWNER**  
> **项目**：`entropy-student/project/cross-border-business/01-opportunity-market/`  
> **范围**：第⑧章最终正文、核验记录与可复现自检脚本；框架及前七章零修改，②–⑤板块零修改；HTML未启动。

## 1. 版本、权限与封板决定

1. 正式框架保持唯一核心问题1、一级8、二级34、三级83的冻结原题；第⑧章结构为**1H1/4H2/7H3**。特例8.2直接成节、无三级。
2. Writer第⑧章R1→独立Reviewer RETURN（8组）；Writer R2→独立Reviewer R2 RETURN（2项残留）。
3. Owner明确授权“由你来修改完成之后，正式冻结，然后填入项目库，记得记录相关文档。完成之后等待我抉择下一步”。Reviewer据此直接使用**完整Writer R2原稿**做少量修订，**不存在独立Writer R3候选稿**。
4. 最终正文正式冻结  `FINAL_SEALED`，第一部分8章正文全部封板；不因此代表内容永久正确、实际市场需求/支付/监管已被现场证明。后续须待Owner新决定，不自动开启HTML。

## 2. 实际修复与非阻断小修

| 类型 | 最小修改内容 | 结果 |
|---|---|---|
| **阻断 R2-01** | 原Writer脚本只判断关键词并硬编码MCDA/预算/试错模型，四组故意错误正文仍返回PASS；改为从正文**提取六权重、X/Y六项成绩和实际乘法、加总、预算四项上下限与总额、两种试错比例和轮数**，检测值错时非零退出 | **PASS**，见第3节命令和真实回归 |
| **阻断 R2-02** | “数百位连续成功创业者”改成2001年关键研究的**27名专家创业者**，说明有成功失败经历，作为条件性方法论而非必然规律 | **PASS**，研究一手来源见第4节 |
| 非阻断 | 去掉5.75分没有预设规则的“不合格”标签 | DONE |
| 非阻断 | 180–540美元明确为本文四项测试预算模型，不宣称是大多数跨境业务的普遍开销 | DONE |
| 非阻断 | PO/订金效力与不可退的断言改为合同和法域条件下的可核查承诺 | DONE |
| 非阻断 | Stripe取消订阅后仍需核对未结发票、用量计费及退款，不能以关自动划扣代替全部结清 | DONE |

**最小化量化**：仅修改6处原稿正文文本；标准冻题逐项比对12/12完全相同；未替换图表、案例或重写任何一级问题。新录入的正文为独立Writer R2全稿经Owner授权Reviewer定向修订。

## 3. 自检脚本的真实执行与反例

仓库正式程序：`docs/CHAPTER8_SELFTEST_20261019.py`，Python标准库，无依赖；应传入正式Markdown正文路径。脚本检查冻题顺序与8.2无三级、6项权重和X/Y正文公式、预算项与合计、20%/30%轮次，且读取不到正文时失败。

```bash
python CHAPTER8_SELFTEST_20261019.py CHAPTER8_FINAL_SEALED.md
python CHAPTER8_SELFTEST_20261019.py MISSING.md
python 06_可复现反例脚本.py CHAPTER8_SELFTEST_20261019.py CHAPTER8_FINAL_SEALED.md
```

| 实际测试 | 退出码 | 通过依据 |
|---|---:|---|
| 正文基线 | **0** | 12/12冻题；X=5.75、Y=6.85；预算180/540；20%/30%试错轮次 |
| 正文缺失 | **2** | 必须报错，不允许缺文件仍PASS |
| 故意将X公式权重0.20篡成0.90 | **1** | 正文权重公式不一致，被程序阻断 |
| 故意将广告预算100–300改成900–3,000 | **1** | 实际分项与公开合计不一致 |
| 故意将X最后得分5.75改成6.75 | **1** | 加权结果与正文矛盾 |
| 故意将首轮消耗30%改成40% | **1** | 模型比例与正文叙述不一致 |

程序实际输出摘要：

```text
[PASS] 12 frozen titles in exact order; 8.2 directly a section
[PASS] MCDA X: six body factors match declared weights; score=5.75
[PASS] MCDA Y: six body factors match declared weights; score=6.85
[PASS] Budget: 4 body component ranges and formula totals $180–$540
[PASS] Alpha=20%: spent 20%, remainder 80%, further equal-size trials=4
[PASS] Alpha=30%: spent 30%, remainder 70%, further equal-size trials=2
[ALL PASS] Real document-derived checks passed; not a validation of legal facts or actual sales

baseline: exit=0, last=[ALL PASS] Real document-derived checks passed; not a validation of legal facts or actual sales
MCDA_factor: exit=1, last=[PASS] 12 frozen titles in exact order; 8.2 directly a section
budget_component: exit=1, last=[PASS] MCDA Y: six body factors match declared weights; score=6.85
MCDA_score: exit=1, last=[PASS] 12 frozen titles in exact order; 8.2 directly a section
trial_percentage: exit=1, last=[PASS] Alpha=20%: spent 20%, remainder 80%, further equal-size trials=4
missing_file exit= 2
All anti-test cases passed
```

以上是真正运行得到的结构和数学回归，不代表可以自动核实研究方法、法规法律、商业真实性或实际交易。作者原R2的自检PASS声明已在最终核验记录第七节撤销和替换。

## 4. 学术来源验证

- 原始期刊来源：Sarasvathy (2001), *Effectual Reasoning in Entrepreneurial Decision Making: Existence and Bounds*, Academy of Management Proceedings，<https://journals.aom.org/doi/10.5465/apbpp.2001.6133065>。摘要明确说明**27名专家创业者**参与口述协议研究；不是“数百位连续成功创业者”。
- 背景说明：<https://effectuation.org/effectuation-background-research>，同样说明27位有丰富经验且具有成功与失败经历的专家创业者。
- 对这类理论的定位是**启发式决策方法**，不视为适用于每个国家每类卖家的普适资金比例或经验法则。

## 5. 字节校验与留痕

| 资产 | SHA256 |
|---|---|
| Writer R2 原始 ZIP | `cafec6b60a0b24ee2b136c66f02a5b12d9e683e7fee53f9fa268ce31751c6616` |
| Writer R2 原始全文 | `437a0e60732458a8a3be5122b6dddd20bf27806e9e62d0ed8ba1b156ba8ffa13` |
| Writer R2 原始核验记录 | `235e8b09cef56b09471c508477017e1da3fe7dd132040a38e332170e92185d95` |
| 本次最终正式正文 | `d82300295521d9251ca26e5e86338b55cab36102dffe975ee383a1168b717a43` |
| 本次最终核验记录 | `cd0573519d736ae363514720c080e83d2b5bf1fbcab95f3699f9dcb4f86ab81d` |
| 本次独立自检脚本 | `77cfb7b924ade8c50c24d03fea46dd2d95ea9973e7373311ec6fbb2f47ff72dc` |

**GitHub落库**：`docs/CHAPTER8_FINAL_SEALED.md`、`docs/CHAPTER8_FINAL_RESEARCH_RECORD.md`、`docs/CHAPTER8_SELFTEST_20261019.py`、`docs/CHAPTER8_SEAL_EVIDENCE_20261019.md`。连同README、唯一交接、板块导航和协作规范更新至main；第⑧章旧Writer Gate和离线包清单退出当前main，仅留Git历史。

**后续停点**：第一部分框架与8/8正文正式冻结，**当前无活动Writer Gate，HTML `NOT_STARTED`，等待Owner决定下一步**。
