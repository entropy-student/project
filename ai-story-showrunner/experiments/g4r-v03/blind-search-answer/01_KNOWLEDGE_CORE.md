# Blind Case 04 — KnowledgeCore

## Locked question
为什么 AI 已经找到正确网页，最后仍然可能给出错误答案？

## One locked mechanism
**检索到相关/正确来源，不等于生成阶段会正确选择、理解并整合其中支持问题的证据。**

Search / retrieval and answer generation are different steps.
A system may retrieve a highly relevant page, yet the generated answer can still be wrong if it:
- selects the wrong sentence or wrong facet of that page;
- overlooks a qualifier, exception, scope condition, or contradiction;
- combines evidence incorrectly;
- lets prior assumptions override retrieved evidence;
- makes a conclusion that is not actually entailed by the cited passage.

## Story-specific failure mode
The fictional question asks whether a **platform service fee** is refunded.
The fictional official policy page contains both:
1. the order payment is returned to the original payment method;
2. the platform service fee is not refunded.

The AI cites the correct policy page but uses statement 1 to answer the service-fee question.

Therefore:
- retrieval = relevant/correct page;
- evidence selection / integration = wrong;
- answer = wrong.

## What this episode MUST NOT claim
- Search itself always worked perfectly in all cases.
- A citation guarantees the sentence supports the claim.
- RAG/search eliminates hallucination.
- Every wrong searched answer is caused by the same failure mode.
- The model literally reads webpages linearly like a human.

## Mental-model payoff
> **“找对资料”只是把证据拿到桌上；答案是否可靠，还要看结论有没有被那份证据真正支持。**

## Natural action payoff
For important answers, do not stop at “有没有来源”.
Ask/check:
> **来源里的哪一句，真的支持这个结论？**

## Evidence basis
- EACL 2026 work on RAG error diversity: real systems can fail at multiple stages, not retrieval alone.
- 2026 facet-level RAG work: relevant evidence may be retrieved but not correctly integrated during generation.
- OpenAI guidance: search/citations improve verifiability but cited/search results and model outputs can still be incorrect and should be checked.