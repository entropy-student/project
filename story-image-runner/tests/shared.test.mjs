import test from "node:test";
import assert from "node:assert/strict";
import {
  parsePromptText,
  splitPromptText,
  previewImportCount,
  normalizeImportedJobs,
  normalizeSettings,
  sanitizeRelativeFolder,
  makeOutputFilename,
  MAX_QUEUE_JOBS
} from "../extension/shared.js";

test("parsePromptText ignores blank lines", () => {
  assert.deepEqual(parsePromptText("a\n\n b \n"), ["a", "b"]);
});

test("single import mode treats entire textarea as one prompt", () => {
  assert.deepEqual(splitPromptText("line1\nline2\nline3", "single"), ["line1\nline2\nline3"]);
});

test("blankline import mode splits only on blank lines", () => {
  assert.deepEqual(splitPromptText("a1\na2\n\n b1\n b2 ", "blankline"), ["a1\na2", "b1\n b2"]);
});

test("previewImportCount matches line mode count", () => {
  assert.equal(previewImportCount("a\n\n b \n c", "line"), 3);
});

test("normalizeImportedJobs assigns deterministic shot ids", () => {
  const jobs = normalizeImportedJobs([{ prompt: "one" }, { prompt: "two" }], { projectId: "demo" });
  assert.equal(jobs[0].key, "demo:S001");
  assert.equal(jobs[1].key, "demo:S002");
});

test("duplicate jobs fail closed", () => {
  assert.throws(() => normalizeImportedJobs([
    { project_id: "demo", shot_id: "S001", prompt: "one" },
    { project_id: "demo", shot_id: "S001", prompt: "two" }
  ]), /Duplicate job/);
});

test("empty prompts are rejected", () => {
  assert.throws(() => normalizeImportedJobs([{ prompt: "   " }]), /prompt is empty/);
});

test("absolute and traversal folders are rejected", () => {
  assert.throws(() => sanitizeRelativeFolder("../escape"), /Unsafe/);
  assert.throws(() => sanitizeRelativeFolder("C:/escape"), /Absolute/);
  assert.throws(() => sanitizeRelativeFolder("/escape"), /Absolute/);
});

test("safe nested folder and filename", () => {
  const settings = normalizeSettings({ outputFolder: "Story Image Runner/session 01", projectId: "demo" });
  assert.equal(makeOutputFilename(settings, { projectId: "demo", shotId: "S007" }), "Story Image Runner/session 01/demo/S007.png");
});

test("unsupported aspect is rejected", () => {
  assert.throws(() => normalizeSettings({ aspect: "21:9" }), /Unsupported/);
});

test("maximum queue size accepts 500 and rejects 501", () => {
  const jobs500 = Array.from({ length: MAX_QUEUE_JOBS }, (_, i) => ({ prompt: `p${i + 1}` }));
  assert.equal(normalizeImportedJobs(jobs500, { projectId: "demo" }).length, MAX_QUEUE_JOBS);
  const jobs501 = Array.from({ length: MAX_QUEUE_JOBS + 1 }, (_, i) => ({ prompt: `p${i + 1}` }));
  assert.throws(() => normalizeImportedJobs(jobs501, { projectId: "demo" }), /maximum queue size/);
});
