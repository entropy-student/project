import {
  splitPromptText,
  previewImportCount,
  MAX_QUEUE_JOBS,
  DEFAULT_SETTINGS,
  normalizeImportMode
} from "./shared.js";

const $ = (id) => document.getElementById(id);

async function call(type, payload = {}) {
  const res = await chrome.runtime.sendMessage({ type, ...payload });
  if (!res?.ok) throw new Error(`${res?.error?.code ?? "ERROR"}: ${res?.error?.message ?? "Unknown error"}`);
  return res;
}

function settingsFromForm() {
  return {
    projectId: $("projectId").value.trim(),
    outputFolder: $("outputFolder").value.trim(),
    aspect: $("aspect").value,
    newChatEvery: Number($("newChatEvery").value),
    delayMs: Number($("delayMs").value),
    timeoutMs: Number($("timeoutMs").value),
    promptPrefix: $("promptPrefix").value,
    importMode: importModeValue()
  };
}

async function persistSettings() {
  await call("SET_SETTINGS", { settings: settingsFromForm() });
}

function importModeValue() {
  return normalizeImportMode($("importMode").value || DEFAULT_SETTINGS.importMode);
}

function promptBlocks() {
  return splitPromptText($("promptText").value, importModeValue());
}

function jobsFromPromptBlocks(blocks) {
  const projectId = $("projectId").value.trim();
  const aspect = $("aspect").value;
  return blocks.map((prompt, i) => ({
    project_id: projectId,
    shot_id: `S${String(i + 1).padStart(3, "0")}`,
    aspect,
    prompt
  }));
}

function refreshImportPreview() {
  const count = previewImportCount($("promptText").value, importModeValue());
  $("importPreview").textContent = `预计导入 ${count} 条`;
  const mode = importModeValue();
  $("importHint").textContent = mode === "single"
    ? "当前模式：整个文本框作为 1 条 prompt。适合长提示词和多行提示词。"
    : mode === "blankline"
      ? "当前模式：按空行拆分。两个 prompt 之间空一行。"
      : "当前模式：按每行拆分。每一非空行会变成 1 条任务。";
}

async function importText(replace) {
  await persistSettings();
  const blocks = promptBlocks();
  if (!blocks.length) throw new Error("请输入至少一条 Prompt");
  if (blocks.length > MAX_QUEUE_JOBS) throw new Error(`TOO_MANY_JOBS: 单次最多排队 ${MAX_QUEUE_JOBS} 条任务`);
  if (importModeValue() === "line" && blocks.length >= 20) {
    const ok = confirm(`你当前选择的是“按每行拆分”，本次将导入 ${blocks.length} 条任务。是否继续？`);
    if (!ok) return;
  }
  const result = await call(replace ? "REPLACE_JOBS" : "IMPORT_JOBS", { jobs: jobsFromPromptBlocks(blocks) });
  const verify = (await call("GET_STATE")).state;
  if (!(verify.jobs || []).length) throw new Error(`QUEUE_WRITE_MISMATCH: 后台返回写入 ${result.count ?? blocks.length} 条，但重新读取仍为 0 条`);
  $("promptText").value = "";
  refreshImportPreview();
  showDiagnostic(`队列写入成功：${verify.jobs.length} 条；待处理 ${verify.jobs.filter((j) => j.status === "pending").length} 条`, true);
}

$("replaceText").addEventListener("click", () => runUi(() => importText(true)));
$("appendText").addEventListener("click", () => runUi(() => importText(false)));
$("start").addEventListener("click", () => runUi(async () => {
  await persistSettings();
  const state = (await call("GET_STATE")).state;
  const hasPending = (state.jobs || []).some((job) => job.status === "pending");
  const blocks = promptBlocks();
  if (!hasPending && blocks.length) {
    await call("REPLACE_JOBS", { jobs: jobsFromPromptBlocks(blocks) });
    $("promptText").value = "";
    refreshImportPreview();
  }
  await call("START_RUN");
}));
$("pause").addEventListener("click", () => runUi(() => call("PAUSE_RUN")));
$("stop").addEventListener("click", () => runUi(() => call("STOP_RUN")));
$("retryFailed").addEventListener("click", () => runUi(() => call("RETRY_FAILED")));
$("clear").addEventListener("click", () => runUi(async () => {
  if (confirm("清空全部任务？")) await call("CLEAR_JOBS");
}));

$("selfTest").addEventListener("click", () => runUi(async () => {
  const ping = await call("PING");
  const state = (await call("GET_STATE")).state;
  showDiagnostic([
    `后台版本：${ping.runtimeVersion}`,
    `Storage：${ping.storageWritable ? "PASS" : "FAIL"}`,
    `队列：${ping.jobCount} 条 / pending ${ping.pendingCount} 条`,
    `Live：${ping.liveEnabled ? "ON" : "OFF"}`,
    `ChatGPT content-script：${ping.chatgptReady ? "READY" : "NOT READY"}`,
    `最后心跳：${ping.lastHeartbeatAt || "无"}`,
    `UI读取队列：${(state.jobs || []).length} 条`
  ].join("\n"), ping.storageWritable);
}));

$("liveEnabled").addEventListener("change", async (event) => {
  const enabled = event.target.checked;
  if (enabled) {
    const ok = confirm("开启 Live generation 后，点击“开始”会真的向当前浏览器中的 ChatGPT 提交 Prompt 并消耗图片生成额度。继续吗？");
    if (!ok) { event.target.checked = false; return; }
  }
  await runUi(() => call("SET_LIVE_ENABLED", { enabled }));
});

$("fileInput").addEventListener("change", async (event) => {
  await runUi(async () => {
    const file = event.target.files?.[0];
    if (!file) return;
    await persistSettings();
    const text = await file.text();
    let jobs;
    if (file.name.toLowerCase().endsWith(".json")) {
      const parsed = JSON.parse(text);
      jobs = Array.isArray(parsed) ? parsed : parsed.jobs;
      if (!Array.isArray(jobs)) throw new Error("JSON 必须是任务数组，或包含 jobs 数组");
      if (jobs.length > MAX_QUEUE_JOBS) throw new Error(`TOO_MANY_JOBS: 单次最多排队 ${MAX_QUEUE_JOBS} 条任务`);
    } else {
      const blocks = splitPromptText(text, importModeValue());
      if (blocks.length > MAX_QUEUE_JOBS) throw new Error(`TOO_MANY_JOBS: 单次最多排队 ${MAX_QUEUE_JOBS} 条任务`);
      jobs = jobsFromPromptBlocks(blocks);
    }
    await call("REPLACE_JOBS", { jobs });
    event.target.value = "";
  });
});

$("promptText").addEventListener("input", refreshImportPreview);
$("importMode").addEventListener("change", async () => {
  refreshImportPreview();
  await runUi(() => persistSettings());
});

chrome.runtime.onMessage.addListener((message) => {
  if (message?.type === "STATE_PUSH" && message.state) render(message.state);
});

async function refresh() {
  try {
    const res = await call("GET_STATE");
    render(res.state);
  } catch (error) {
    showError(error.message);
  }
}

function render(state) {
  $("liveEnabled").checked = Boolean(state.liveEnabled);
  $("projectId").value = state.settings.projectId;
  $("outputFolder").value = state.settings.outputFolder;
  $("aspect").value = state.settings.aspect;
  $("newChatEvery").value = state.settings.newChatEvery;
  $("delayMs").value = state.settings.delayMs;
  $("timeoutMs").value = state.settings.timeoutMs;
  $("promptPrefix").value = state.settings.promptPrefix;
  $("importMode").value = state.settings.importMode || DEFAULT_SETTINGS.importMode;
  $("maxQueue").value = String(MAX_QUEUE_JOBS);
  $("runBadge").textContent = String(state.run.status || "idle").toUpperCase();
  $("liveBadge").textContent = state.liveEnabled ? "LIVE ON" : "LIVE OFF";

  const jobs = state.jobs || [];
  $("countAll").textContent = jobs.length;
  $("countPending").textContent = jobs.filter((j) => ["pending", "running"].includes(j.status)).length;
  $("countDone").textContent = jobs.filter((j) => j.status === "completed").length;
  $("countFailed").textContent = jobs.filter((j) => j.status === "failed").length;
  $("jobs").innerHTML = jobs.map((job) => `
    <div class="job">
      <div class="job-top"><span class="job-title">${escapeHtml(job.projectId)}/${escapeHtml(job.shotId)}</span><span class="job-status">${escapeHtml(job.status)}</span></div>
      <div class="job-prompt">${escapeHtml(job.promptPreview || "")}</div>
      ${job.error ? `<div class="job-error">${escapeHtml(job.error.code)} · ${escapeHtml(job.error.message)}</div>` : ""}
    </div>
  `).join("");
  refreshImportPreview();
}

async function runUi(fn) {
  hideError();
  try { await fn(); await refresh(); }
  catch (error) { showError(error.message); }
}

function showDiagnostic(text, ok = null) {
  const el = $("diagnosticText");
  el.textContent = text;
  el.classList.remove("ok", "bad");
  if (ok === true) el.classList.add("ok");
  if (ok === false) el.classList.add("bad");
}

function showError(text) { $("errorBox").textContent = text; $("errorBox").classList.remove("hidden"); }
function hideError() { $("errorBox").classList.add("hidden"); }
function escapeHtml(value) { return String(value ?? "").replace(/[&<>'"]/g, (c) => ({"&":"&amp;","<":"&lt;",">":"&gt;","'":"&#39;",'"':"&quot;"}[c])); }

refresh();
refreshImportPreview();
setInterval(refresh, 1500);
