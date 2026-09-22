import {
  STORAGE_KEY,
  SESSION_KEY,
  DEFAULT_SETTINGS,
  normalizeSettings,
  normalizeImportedJobs,
  makeOutputFilename,
  publicState
} from "./shared.js";

let processing = false;
let fallbackWindow = null;
let downloadResolvers = new Map();

const defaultState = () => ({
  version: 1,
  settings: { ...DEFAULT_SETTINGS },
  jobs: [],
  run: {
    status: "idle",
    activeJobKey: null,
    ownedTabId: null,
    processedInConversation: 0,
    lastError: null
  },
  extension: {
    chatgptReady: false,
    lastHeartbeatAt: null,
    tabId: null
  }
});

async function getState() {
  const data = await chrome.storage.local.get(STORAGE_KEY);
  const state = data[STORAGE_KEY] ?? defaultState();
  state.settings = normalizeSettings(state.settings);
  state.jobs ??= [];
  state.run ??= defaultState().run;
  state.extension ??= defaultState().extension;
  return state;
}

async function setState(state) {
  await chrome.storage.local.set({ [STORAGE_KEY]: state });
  broadcastState().catch(() => {});
}

async function getLiveEnabled() {
  const data = await chrome.storage.session.get(SESSION_KEY);
  return Boolean(data[SESSION_KEY]?.liveEnabled);
}

async function setLiveEnabled(value) {
  await chrome.storage.session.set({ [SESSION_KEY]: { liveEnabled: Boolean(value) } });
  await broadcastState();
}

async function broadcastState() {
  const state = await getState();
  const liveEnabled = await getLiveEnabled();
  chrome.runtime.sendMessage({ type: "STATE_PUSH", state: publicState(state, liveEnabled) }).catch(() => {});
}

chrome.runtime.onInstalled.addListener(async () => {
  const data = await chrome.storage.local.get(STORAGE_KEY);
  if (!data[STORAGE_KEY]) await chrome.storage.local.set({ [STORAGE_KEY]: defaultState() });
  await chrome.storage.session.set({ [SESSION_KEY]: { liveEnabled: false } });
  if (chrome.sidePanel?.setPanelBehavior) {
    await chrome.sidePanel.setPanelBehavior({ openPanelOnActionClick: true }).catch(() => {});
  }
});

chrome.runtime.onStartup.addListener(async () => {
  await chrome.storage.session.set({ [SESSION_KEY]: { liveEnabled: false } });
  const state = await getState();
  let changed = false;
  for (const job of state.jobs) {
    if (["running", "submitting", "generating"].includes(job.status)) {
      job.status = "failed";
      job.error = { code: "INTERRUPTED", message: "Browser/service worker restarted during an unfinished job", submitted: true };
      job.updatedAt = new Date().toISOString();
      changed = true;
    }
  }
  if (state.run.status === "running") {
    state.run.status = "paused";
    state.run.activeJobKey = null;
    changed = true;
  }
  if (changed) await setState(state);
});

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  handleMessage(message, sender)
    .then((result) => sendResponse({ ok: true, ...result }))
    .catch((error) => sendResponse({ ok: false, error: serializeError(error) }));
  return true;
});

async function handleMessage(message, sender) {
  switch (message?.type) {
    case "GET_STATE": {
      const state = await getState();
      return { state: publicState(state, await getLiveEnabled()) };
    }
    case "SET_LIVE_ENABLED": {
      await setLiveEnabled(Boolean(message.enabled));
      return {};
    }
    case "SET_SETTINGS": {
      const state = await getState();
      state.settings = normalizeSettings({ ...state.settings, ...message.settings });
      await setState(state);
      return { state: publicState(state, await getLiveEnabled()) };
    }
    case "IMPORT_JOBS": {
      const state = await getState();
      const incoming = normalizeImportedJobs(message.jobs, state.settings);
      const existing = new Set(state.jobs.map((j) => j.key));
      for (const job of incoming) if (existing.has(job.key)) throw typed("DUPLICATE_JOB", `Duplicate job ${job.key}`, false);
      state.jobs.push(...incoming);
      await setState(state);
      return { count: incoming.length };
    }
    case "REPLACE_JOBS": {
      const state = await getState();
      if (state.run.status === "running") throw typed("RUN_ACTIVE", "Pause or stop before replacing the queue", false);
      state.jobs = normalizeImportedJobs(message.jobs, state.settings);
      state.run.activeJobKey = null;
      state.run.lastError = null;
      await setState(state);
      return { count: state.jobs.length };
    }
    case "CLEAR_JOBS": {
      const state = await getState();
      if (state.run.status === "running") throw typed("RUN_ACTIVE", "Pause or stop before clearing jobs", false);
      state.jobs = [];
      state.run = { ...defaultState().run, ownedTabId: state.run.ownedTabId };
      await setState(state);
      return {};
    }
    case "RETRY_FAILED": {
      const state = await getState();
      for (const job of state.jobs) {
        if (job.status === "failed" || job.status === "stopped") {
          job.status = "pending";
          job.error = null;
          job.updatedAt = new Date().toISOString();
        }
      }
      await setState(state);
      return {};
    }
    case "START_RUN": {
      if (!(await getLiveEnabled())) throw typed("SAFE_MODE_BLOCKED", "Live generation is disabled. Enable Live mode in the side panel first.", false);
      const state = await getState();
      if (!state.jobs.some((j) => j.status === "pending")) throw typed("NO_PENDING_JOBS", "No pending jobs", false);
      state.run.status = "running";
      state.run.lastError = null;
      await setState(state);
      processQueue().catch(async (error) => {
        const s = await getState();
        s.run.status = "paused";
        s.run.lastError = serializeError(error);
        s.run.activeJobKey = null;
        await setState(s);
      });
      return {};
    }
    case "PAUSE_RUN": {
      const state = await getState();
      state.run.status = "paused";
      await setState(state);
      return {};
    }
    case "STOP_RUN": {
      const state = await getState();
      state.run.status = "stopped";
      for (const job of state.jobs) if (job.status === "pending") job.status = "stopped";
      await setState(state);
      return {};
    }
    case "CHATGPT_HEARTBEAT": {
      const state = await getState();
      state.extension.chatgptReady = Boolean(message.ready);
      state.extension.lastHeartbeatAt = new Date().toISOString();
      state.extension.tabId = sender.tab?.id ?? null;
      await chrome.storage.local.set({ [STORAGE_KEY]: state });
      return {};
    }
    case "EXPECT_DOWNLOAD": {
      fallbackWindow = {
        jobKey: String(message.jobKey),
        filename: String(message.filename),
        expiresAt: Date.now() + 8000,
        tabId: sender.tab?.id ?? null,
        downloadId: null
      };
      return {};
    }
    default:
      throw typed("UNKNOWN_MESSAGE", `Unknown message ${message?.type}`, false);
  }
}

async function processQueue() {
  if (processing) return;
  processing = true;
  try {
    while (true) {
      if (!(await getLiveEnabled())) {
        const state = await getState();
        state.run.status = "paused";
        state.run.lastError = { code: "SAFE_MODE_BLOCKED", message: "Live mode disabled", submitted: false };
        state.run.activeJobKey = null;
        await setState(state);
        return;
      }
      let state = await getState();
      if (state.run.status !== "running") return;
      const job = state.jobs.find((j) => j.status === "pending");
      if (!job) {
        state.run.status = "idle";
        state.run.activeJobKey = null;
        if (state.settings.closeOwnedTabWhenIdle && state.run.ownedTabId) {
          await chrome.tabs.remove(state.run.ownedTabId).catch(() => {});
          state.run.ownedTabId = null;
        }
        await setState(state);
        return;
      }

      job.status = "running";
      job.attempt = (job.attempt ?? 0) + 1;
      job.error = null;
      job.updatedAt = new Date().toISOString();
      state.run.activeJobKey = job.key;
      await setState(state);

      try {
        const tabId = await ensureOwnedChatTab(state);
        await waitForContentReady(tabId, 30000);
        const composedPrompt = composePrompt(state.settings, job);
        const response = await sendTabMessage(tabId, {
          type: "RUN_JOB",
          jobKey: job.key,
          prompt: composedPrompt,
          timeoutMs: state.settings.timeoutMs
        }, state.settings.timeoutMs + 15000);
        if (!response?.ok) throw response?.error ? Object.assign(new Error(response.error.message), response.error) : typed("UNKNOWN", "No successful response from content script", true);
        await downloadImageForJob(tabId, job, response.imageUrl, response.imageKind, state.settings);
        state = await getState();
        const current = state.jobs.find((j) => j.key === job.key);
        if (current) {
          current.status = "completed";
          current.error = null;
          current.updatedAt = new Date().toISOString();
        }
        state.run.activeJobKey = null;
        state.run.processedInConversation = (state.run.processedInConversation ?? 0) + 1;
        await setState(state);
      } catch (error) {
        state = await getState();
        const current = state.jobs.find((j) => j.key === job.key);
        if (current) {
          current.status = "failed";
          current.error = serializeError(error);
          current.updatedAt = new Date().toISOString();
        }
        state.run.activeJobKey = null;
        state.run.lastError = serializeError(error);
        await setState(state);
        if (error?.code === "RATE_LIMITED" || error?.code === "NOT_LOGGED_IN" || error?.submitted) {
          state = await getState();
          state.run.status = "paused";
          await setState(state);
          return;
        }
      }

      state = await getState();
      if (state.run.status !== "running") return;
      if ((state.run.processedInConversation ?? 0) >= state.settings.newChatEvery) {
        if (state.run.ownedTabId) await chrome.tabs.remove(state.run.ownedTabId).catch(() => {});
        state.run.ownedTabId = null;
        state.run.processedInConversation = 0;
        await setState(state);
      }
      if (state.settings.delayMs > 0) await sleep(state.settings.delayMs);
    }
  } finally {
    processing = false;
  }
}

function composePrompt(settings, job) {
  const aspect = job.aspect && job.aspect !== "auto" ? ` Use a ${job.aspect} aspect ratio.` : "";
  return `${settings.promptPrefix}${aspect} ${job.prompt}`.trim();
}

async function ensureOwnedChatTab(state) {
  if (state.run.ownedTabId) {
    try {
      const tab = await chrome.tabs.get(state.run.ownedTabId);
      if (tab?.url?.startsWith("https://chatgpt.com/")) return tab.id;
    } catch {}
  }
  const tab = await chrome.tabs.create({ url: "https://chatgpt.com/", active: false });
  state.run.ownedTabId = tab.id;
  state.run.processedInConversation = 0;
  await setState(state);
  await waitForTabComplete(tab.id, 45000);
  return tab.id;
}

async function waitForTabComplete(tabId, timeoutMs) {
  const started = Date.now();
  while (Date.now() - started < timeoutMs) {
    const tab = await chrome.tabs.get(tabId);
    if (tab.status === "complete") return;
    await sleep(350);
  }
  throw typed("TAB_TIMEOUT", "ChatGPT tab did not finish loading", false);
}

async function waitForContentReady(tabId, timeoutMs) {
  const started = Date.now();
  let last;
  while (Date.now() - started < timeoutMs) {
    try {
      const res = await chrome.tabs.sendMessage(tabId, { type: "CHECK_READY" });
      last = res;
      if (res?.ok && res.ready) return;
      if (res?.error?.code === "NOT_LOGGED_IN") throw Object.assign(new Error(res.error.message), res.error);
    } catch (error) {
      last = error;
    }
    await sleep(700);
  }
  if (last?.error?.code) throw Object.assign(new Error(last.error.message), last.error);
  throw typed("UI_SELECTOR_MISSING", "ChatGPT composer was not ready", false);
}

async function sendTabMessage(tabId, message, timeoutMs) {
  return await Promise.race([
    chrome.tabs.sendMessage(tabId, message),
    new Promise((_, reject) => setTimeout(() => reject(typed("TIMEOUT", "Timed out waiting for ChatGPT generation", true)), timeoutMs))
  ]);
}

async function downloadImageForJob(tabId, job, imageUrl, imageKind, settings) {
  const filename = makeOutputFilename(settings, job);
  let downloadId = null;
  if (imageUrl && /^(https?:|data:)/i.test(imageUrl)) {
    try {
      downloadId = await chrome.downloads.download({ url: imageUrl, filename, conflictAction: "uniquify", saveAs: false });
    } catch {}
  }

  if (downloadId == null) {
    const arm = await chrome.tabs.sendMessage(tabId, { type: "CLICK_DOWNLOAD", jobKey: job.key, filename });
    if (!arm?.ok) throw Object.assign(new Error(arm?.error?.message ?? "Could not trigger ChatGPT download"), arm?.error ?? typed("DOWNLOAD_FAILED", "Could not trigger ChatGPT download", true));
    downloadId = await waitForFallbackDownload(job.key, 12000);
  }

  const item = await waitForDownloadComplete(downloadId, 120000);
  const state = await getState();
  const current = state.jobs.find((j) => j.key === job.key);
  if (current) {
    current.filename = item.filename || filename;
    current.downloadId = downloadId;
    current.imageKind = imageKind ?? null;
    current.updatedAt = new Date().toISOString();
    await setState(state);
  }
}

chrome.downloads.onDeterminingFilename.addListener((item, suggest) => {
  if (fallbackWindow && Date.now() < fallbackWindow.expiresAt && fallbackWindow.downloadId == null) {
    fallbackWindow.downloadId = item.id;
    suggest({ filename: fallbackWindow.filename, conflictAction: "uniquify" });
    return;
  }
  suggest();
});

chrome.downloads.onCreated.addListener((item) => {
  if (fallbackWindow && Date.now() < fallbackWindow.expiresAt && fallbackWindow.downloadId == null) {
    fallbackWindow.downloadId = item.id;
  }
});

chrome.downloads.onChanged.addListener((delta) => {
  const resolver = downloadResolvers.get(delta.id);
  if (!resolver) return;
  if (delta.state?.current === "complete") {
    downloadResolvers.delete(delta.id);
    resolver.resolve(delta.id);
  } else if (delta.state?.current === "interrupted") {
    downloadResolvers.delete(delta.id);
    resolver.reject(typed("DOWNLOAD_FAILED", `Download ${delta.id} was interrupted`, true));
  }
});

async function waitForFallbackDownload(jobKey, timeoutMs) {
  const started = Date.now();
  while (Date.now() - started < timeoutMs) {
    if (fallbackWindow?.jobKey === jobKey && fallbackWindow.downloadId != null) {
      const id = fallbackWindow.downloadId;
      fallbackWindow = null;
      return id;
    }
    await sleep(150);
  }
  fallbackWindow = null;
  throw typed("DOWNLOAD_FAILED", "No download was observed after clicking the ChatGPT download control", true);
}

async function waitForDownloadComplete(downloadId, timeoutMs) {
  const existing = await chrome.downloads.search({ id: downloadId });
  if (existing[0]?.state === "complete") return existing[0];
  if (existing[0]?.state === "interrupted") throw typed("DOWNLOAD_FAILED", `Download ${downloadId} was interrupted`, true);

  await new Promise((resolve, reject) => {
    const timer = setTimeout(() => {
      downloadResolvers.delete(downloadId);
      reject(typed("DOWNLOAD_FAILED", `Download ${downloadId} timed out`, true));
    }, timeoutMs);
    downloadResolvers.set(downloadId, {
      resolve: () => { clearTimeout(timer); resolve(); },
      reject: (error) => { clearTimeout(timer); reject(error); }
    });
  });
  const final = await chrome.downloads.search({ id: downloadId });
  return final[0] ?? { id: downloadId, filename: null };
}

function typed(code, message, submitted = false) {
  const e = new Error(message);
  e.code = code;
  e.submitted = submitted;
  return e;
}

function serializeError(error) {
  return {
    code: String(error?.code ?? "UNKNOWN"),
    message: String(error?.message ?? error ?? "Unknown error"),
    submitted: Boolean(error?.submitted)
  };
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
