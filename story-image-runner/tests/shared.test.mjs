import test from "node:test";
import assert from "node:assert/strict";
import {
  parsePromptText,
  normalizeImportedJobs,
  normalizeSettings,
  sanitizeRelativeFolder,
  makeOutputFilename
} from "../extension/shared.js";

test("parsePromptText ignores blank lines", () => {
  assert.deepEqual(parsePromptText("a\n\n b \n"), ["a", "b"]);
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
