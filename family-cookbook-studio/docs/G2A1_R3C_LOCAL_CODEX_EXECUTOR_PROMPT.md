# Family Cookbook Studio — G2A1-R3C Local Codex Executor Prompt

你是 `entropy-student/project` 中 Family Cookbook Studio 的本地 Execution Agent。

本轮只执行：

`G2A1-R3C — ChatGPT-Plan Codex Vision Internal Benchmark`

## 1. 读取 GitHub canonical truth

读取：

1. `family-cookbook-studio/REVIEWER_HANDOFF.md`
2. `family-cookbook-studio/docs/G2A1_R3C_CODEX_PLUS_VISION_INTERNAL_BENCHMARK.md`
3. `family-cookbook-studio/docs/DOCUMENT_INDEX.md`

然后切到/读取执行分支：

`codex/family-cookbook-g2a1-input-ocr-component-feasibility`

重点文件：

- `family-cookbook-studio/g2a1/r3c/run_codex_plan_benchmark.py`
- `family-cookbook-studio/g2a1/r3c/codex-transcription.schema.json`
- `family-cookbook-studio/g2a1/r3c/requirements.txt`
- R3A corpus / fallback / scorer files

## 2. Authentication hard boundary

本轮必须使用**当前机器上已经通过 ChatGPT 登录的 Codex CLI**。

先执行：

```
codex --version
codex login status
```

只记录安全的分类结论，不得把 email、account id、token、auth 文件内容写入 GitHub。

如果当前是 API key / WIF / access token / 自定义 base URL：

`RETURN_G2A1_R3C_AUTH_NOT_CHATGPT_PLAN`

禁止切 API Key。

禁止 Sub2API。

禁止任何额外 API 计费。

## 3. Environment

执行前确认：
- `OPENAI_API_KEY` unset
- `OPENAI_BASE_URL` unset
- `CODEX_API_KEY` unset
- `CODEX_ACCESS_TOKEN` unset
- WIF env unset

不要删除当前 ChatGPT 登录态。

## 4. Install only the small local dependency if needed

在项目自己的临时 venv 或当前安全 Python 环境安装：

```
pip install -r family-cookbook-studio/g2a1/r3c/requirements.txt
```

不得安装大型 OCR/model runtime。

## 5. Run

直接执行：

```
python family-cookbook-studio/g2a1/r3c/run_codex_plan_benchmark.py
```

该 runner 会：
- 下载/校验原 R3A 两个公开历史手写来源；
- 重建相同 11 个 crop；
- 每个 sample 创建独立临时目录；
- 临时目录只放 `sample.jpg` + output schema；
- 调用 `codex exec`；
- 要求模型通过 local image-view 查看图片；
- 禁止把 ground truth / PP / 百度结果暴露给模型；
- 生成结构化 transcription；
- 最后才调用既有 R3A scorer 做公平比较。

不要自行修改 prompt 以提高分数。

不要把 ground truth 传给 Codex。

## 6. Expected outputs

执行后必须存在：

`family-cookbook-studio/g2a1/r3c/artifacts/codex-results.json`

`family-cookbook-studio/g2a1/r3c/artifacts/codex-comparison.json`

`family-cookbook-studio/g2a1/r3c/artifacts/final-internal-benchmark-decision.json`

## 7. Interpret only through the recorded scorer

最终只允许：

- `PASS_CANDIDATE_G2A1_R3C_CODEX_INTERNAL_WHOLE_TRANSCRIPT_BETTER`
- `PASS_CANDIDATE_G2A1_R3C_CODEX_CRITICAL_SECOND_OPINION_ONLY`
- `PASS_CANDIDATE_G2A1_R3C_CODEX_NO_MATERIAL_BENEFIT`
- 或精确 `RETURN_*`

不要自行把“看起来更好”当 PASS。

## 8. Evidence

更新执行分支：

- `family-cookbook-studio/EXECUTION_EVIDENCE.md`
- `family-cookbook-studio/EXECUTOR_HANDOFF.md`

提交：
- R3C runner outputs；
- comparison；
- final decision；
- 安全的 Codex version/auth classification。

不得提交：
- OAuth token；
- refresh token；
- `auth.json`；
- email/account ID；
- ChatGPT cookie；
- 用户私人文件。

## 9. Production boundary

即使 Codex 赢：

- 不接客户数据；
- 不把 Codex CLI 接进 WordPress；
- 不部署 ChatGPT 登录态；
- 不启用 Sub2API；
- 不改变生产 OCR 架构。

R3C 只是内部 benchmark。

## 10. Return

返回：

```text
<exact PASS_CANDIDATE or RETURN>

BRANCH=codex/family-cookbook-g2a1-input-ocr-component-feasibility
HEAD_COMMIT=<40-char SHA>

CODEX_AUTH=CHATGPT_PLAN
OPENAI_API_KEY_USED=NO
SUB2API_USED=NO
PUBLIC_SAMPLES=11

CODEX_MANUAL_EDIT_FIELDS=<n or UNKNOWN>
CODEX_MANUAL_EDIT_CHARS=<n or UNKNOWN>
CODEX_CRITICAL_ERRORS=<n or UNKNOWN>
CODEX_SILENT_CRITICAL_ERRORS=<n or UNKNOWN>

GITHUB_DELIVERY=COMMITTED
MAIN_MERGED=NO
STOP_AT_REVIEWER=YES
```

然后停止。
