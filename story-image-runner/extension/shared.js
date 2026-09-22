export const STORAGE_KEY = "sir_state_v1";
export const SESSION_KEY = "sir_session_v1";
export const MAX_QUEUE_JOBS = 500;
export const IMPORT_MODES = new Set(["single", "blankline", "line"]);

export const DEFAULT_SETTINGS = Object.freeze({
  projectId: "batch-001",
  outputFolder: "StoryImageRunner",
  aspect: "auto",
  delayMs: 2500,
  timeoutMs: 240000,
  newChatEvery: 1,
  promptPrefix: "Generate an image. ",
  closeOwnedTabWhenIdle: false,
  importMode: "single"
});

export const ALLOWED_ASPECTS = new Set(["auto", "1:1", "16:9", "9:16", "4:5", "5:4", "4:3", "3:4"]);

export function sanitizeId(value, field = "id") {
  const v = String(value ?? "").trim();
  if (!/^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$/.test(v)) {
    throw new Error(`${field} must match ^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$`);
  }
  return v;
}

export function sanitizeRelativeFolder(value) {
  const raw = String(value ?? "").trim().replaceAll("\\", "/");
  if (!raw) return "StoryImageRunner";
  if (raw.startsWith("/") || /^[A-Za-z]:\//.test(raw)) throw new Error("Absolute output paths are not allowed");
  const parts = raw.split("/").filter(Boolean);
  if (!parts.length || parts.some((p) => p === "." || p === "..")) throw new Error("Unsafe output folder");
  for (const part of parts) {
    if (!/^[A-Za-z0-9][A-Za-z0-9._ -]{0,63}$/.test(part)) throw new Error(`Unsafe folder segment: ${part}`);
  }
  return parts.join("/");
}

export function normalizeSettings(input = {}) {
  const out = { ...DEFAULT_SETTINGS, ...input };
  out.projectId = sanitizeId(out.projectId, "projectId");
  out.outputFolder = sanitizeRelativeFolder(out.outputFolder);
  if (!ALLOWED_ASPECTS.has(out.aspect)) throw new Error("Unsupported aspect ratio");
  out.delayMs = clampInt(out.delayMs, 0, 60000, DEFAULT_SETTINGS.delayMs);
  out.timeoutMs = clampInt(out.timeoutMs, 30000, 900000, DEFAULT_SETTINGS.timeoutMs);
  out.newChatEvery = clampInt(out.newChatEvery, 1, 1000, DEFAULT_SETTINGS.newChatEvery);
  out.promptPrefix = String(out.promptPrefix ?? DEFAULT_SETTINGS.promptPrefix).slice(0, 1000);
  out.closeOwnedTabWhenIdle = Boolean(out.closeOwnedTabWhenIdle);
  out.importMode = normalizeImportMode(out.importMode);
  return out;
}

function clampInt(value, min, max, fallback) {
  const n = Number.parseInt(value, 10);
  if (!Number.isFinite(n)) return fallback;
  return Math.max(min, Math.min(max, n));
}

export function normalizeImportMode(value) {
  const mode = String(value ?? DEFAULT_SETTINGS.importMode).trim().toLowerCase();
  if (!IMPORT_MODES.has(mode)) throw new Error("Unsupported import mode");
  return mode;
}

export function parsePromptText(text) {
  return String(text ?? "")
    .split(/\r?\n/)
    .map((x) => x.trim())
    .filter(Boolean);
}

export function splitPromptText(text, mode = DEFAULT_SETTINGS.importMode) {
  const normalizedMode = normalizeImportMode(mode);
  const raw = String(text ?? "").replace(/\r\n/g, "\n").trim();
  if (!raw) return [];
  if (normalizedMode === "single") return [raw];
  if (normalizedMode === "blankline") {
    return raw
      .split(/\n\s*\n+/)
      .map((block) => block.trim())
      .filter(Boolean);
  }
  return parsePromptText(raw);
}

export function previewImportCount(text, mode = DEFAULT_SETTINGS.importMode) {
  return splitPromptText(text, mode).length;
}

export function normalizeImportedJobs(input, settings = DEFAULT_SETTINGS) {
  const s = normalizeSettings(settings);
  if (!Array.isArray(input)) throw new Error("Jobs must be an array");
  if (input.length > MAX_QUEUE_JOBS) throw new Error(`Too many jobs: maximum queue size is ${MAX_QUEUE_JOBS}`);
  const seen = new Set();
  return input.map((raw, index) => {
    const prompt = String(raw?.prompt ?? "").trim();
    if (!prompt) throw new Error(`Job ${index + 1}: prompt is empty`);
    if (prompt.length > 12000) throw new Error(`Job ${index + 1}: prompt exceeds 12000 chars`);
    const projectId = sanitizeId(raw?.project_id ?? raw?.projectId ?? s.projectId, "project_id");
    const shotId = sanitizeId(raw?.shot_id ?? raw?.shotId ?? `S${String(index + 1).padStart(3, "0")}`, "shot_id");
    const aspect = String(raw?.aspect ?? s.aspect);
    if (!ALLOWED_ASPECTS.has(aspect)) throw new Error(`Job ${index + 1}: unsupported aspect`);
    const key = `${projectId}:${shotId}`;
    if (seen.has(key)) throw new Error(`Duplicate job: ${key}`);
    seen.add(key);
    return {
      key,
      projectId,
      shotId,
      prompt,
      aspect,
      status: "pending",
      attempt: 0,
      error: null,
      filename: null,
      downloadId: null,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };
  });
}

export function makeOutputFilename(settings, job) {
  const s = normalizeSettings(settings);
  const projectId = sanitizeId(job.projectId, "projectId");
  const shotId = sanitizeId(job.shotId, "shotId");
  return `${s.outputFolder}/${projectId}/${shotId}.png`;
}

export function publicState(state, liveEnabled) {
  return {
    ...state,
    liveEnabled: Boolean(liveEnabled),
    jobs: state.jobs.map(({ prompt, ...job }) => ({ ...job, promptPreview: prompt.slice(0, 100) }))
  };
}
