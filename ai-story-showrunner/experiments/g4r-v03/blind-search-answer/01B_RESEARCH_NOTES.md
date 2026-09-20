# Blind Case 04 — Research Notes

## External evidence used only to lock the mechanism

1. Leung et al., EACL 2026 — Classifying and Addressing the Diversity of Errors in Retrieval-Augmented Generation Systems
https://aclanthology.org/2026.eacl-long.147/

Relevant project takeaway:
RAG errors have diverse causes across a realistic pipeline; retrieved external knowledge does not make the final output automatically correct.

2. Elchafei et al., 2026 — Facet-Level Tracing of Evidence Uncertainty and Hallucination in RAG
https://arxiv.org/abs/2604.09174

Relevant project takeaway:
Relevant evidence can be present while generation still shows evidence misalignment / prior-driven override.

3. OpenAI Help — Does ChatGPT tell the truth?
https://help.openai.com/en/articles/8313428-does-chatgpt-tell-the-truth

Relevant project takeaway:
Search can improve factual/verifiable answers but model outputs may still be incorrect.

4. OpenAI Help — Searching the web with ChatGPT
https://help.openai.com/en/articles/9237897-chatgpt-search

Relevant project takeaway:
Search sources/citations themselves should be opened and checked when accuracy matters.

## Scope choice
This blind case intentionally tests only one failure mode:
correct/relevant page retrieved → wrong evidence facet selected/integrated → wrong answer.

Other failure modes such as bad retrieval, stale pages, malicious pages, context truncation, or inaccessible sites are out of scope.