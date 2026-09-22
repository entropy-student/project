# Direct Implementation Evidence — v0.1.1

Date: 2026-09-22

Owner explicitly asked ChatGPT to implement directly.

Implementation branch:

`story-image-runner/plugin-v1`

## v0.1.1 usability fix

First Owner browser test proved:

- extension loads;
- side panel opens;
- Live generation can be enabled;
- no real generation occurred because the typed prompt had not yet been added to the queue;
- UI showed `NO_PENDING_JOBS`.

This exposed a usability defect: typing a prompt and pressing Start did not auto-enqueue it.

v0.1.1 changes Start behavior:

```text
IF queue has no pending job
AND prompt textarea contains one or more lines
THEN replace queue from textarea
AND immediately start
```

Manual “用文本替换队列” / “追加文本” controls remain available.

## Local checks

```text
node --check extension/sidepanel.js = PASS
npm test = 7/7 PASS
npm run check = PASS
```

Packaged extension SHA256:

`b45275f4b2df793fb31b4241aa26c27f81b1578888ffdf9144f65dc55f643869`

Packaged source SHA256:

`9f319d9f1d4643e2edee87c5946ffe36aa22e94f8b8912b5704ecd8ac3cb83c5`

Real image generations during v0.1.1 fix: 0.

Remaining evidence boundary: live prompt submission, fresh-image detection, and automatic download.
