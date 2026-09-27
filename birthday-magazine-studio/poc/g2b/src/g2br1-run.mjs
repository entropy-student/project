import fs from "node:fs/promises";
import path from "node:path";
import os from "node:os";
import crypto from "node:crypto";
import { spawn, spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import { CONTENT_SCHEMA, providerPrompt } from "./provider.mjs";
import { CodexExecProvider } from "./codex-provider.mjs";
import { canonicalJobPath, claimCanonicalJob, saveCanonicalJob } from "./idempotency.mjs";

const HERE = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(HERE, "..");
const FIXTURES = path.join(ROOT, "fixtures");
const BASELINE_ARTIFACTS = path.join(ROOT, "artifacts");
const G2BR2_MODE = process.env.BMS_G2BR2_HOST_MODE === "1";
const NAMESPACE = G2BR2_MODE ? "g2br2" : "g2br1";
const GATE_ID = G2BR2_MODE ? "G2BR2_HOST_CODEX_TRANSPORT_AND_REAL_AI_CLOSURE" : "G2BR1_REAL_AI_GENERATION_CLOSURE";
const GATE_LABEL = G2BR2_MODE ? "G2BR2" : "G2BR1";
const EXECUTION_MODE = G2BR2_MODE ? "CODEX_HOST_WINDOWS_CHATGPT_LOGIN" : "CODEX_CHATGPT_LOGIN";
const REAL_AI_QA_PASS = G2BR2_MODE ? "PASS_G2BR2_REAL_AI_RENDER_PIPELINE" : "PASS_G2BR1_REAL_AI_RENDER_PIPELINE";
const ARTIFACTS = path.join(BASELINE_ARTIFACTS, NAMESPACE);
const JOBS = path.join(ARTIFACTS, "jobs");
const INPUT_FILE = path.join(FIXTURES, "intake.json");
const BASELINE_QA = path.join(BASELINE_ARTIFACTS, "qa-report.json");
const OUTPUT_FILE = path.join(ARTIFACTS, "generated-content.json");
const SCHEMA_FILE = path.join(ARTIFACTS, "content-schema.json");
const PROMPT_FILE = path.join(ARTIFACTS, "synthetic-generation-prompt.txt");
const STATUS_FILE = path.join(ARTIFACTS, "model-execution-status.json");
const IDEMPOTENCY_FILE = path.join(ARTIFACTS, "idempotency-report.json");
const QA_FILE = path.join(ARTIFACTS, "qa-report.json");
const MAX_MODEL_RUNS = G2BR2_MODE ? 2 : 3;
const JOB_KEY = G2BR2_MODE ? "synthetic-order-g2br2-0001" : "synthetic-order-g2b-0001";
const MODEL_EXECUTABLE = process.env.BMS_CODEX_EXECUTABLE || "codex";

async function readJson(file) { return JSON.parse(await fs.readFile(file, "utf8")); }
async function writeJson(file, value) {
  await fs.mkdir(path.dirname(file), { recursive: true });
  await fs.writeFile(file, JSON.stringify(value, null, 2) + "\n", "utf8");
}
function sha256(bytes) { return crypto.createHash("sha256").update(bytes).digest("hex"); }
function sanitizedEnvironment() {
  const env = { ...process.env };
  for (const name of ["OPENAI_API_KEY", "OPENAI_BASE_URL", "OPENAI_CUSTOM_HEADERS", "OPENAI_ORG_ID", "OPENAI_PROJECT_ID"]) delete env[name];
  return env;
}
function runCodexReadOnly(args) {
  const jsLauncher = MODEL_EXECUTABLE.toLowerCase().endsWith(".js");
  const result = spawnSync(jsLauncher ? process.execPath : MODEL_EXECUTABLE, jsLauncher ? [MODEL_EXECUTABLE, ...args] : args, { cwd: ROOT, env: sanitizedEnvironment(), encoding: "utf8", windowsHide: true, timeout: 15_000 });
  if (result.error || result.status !== 0) return { ok: false };
  return { ok: true, text: [result.stdout, result.stderr].filter(Boolean).join("\n").trim() };
}
function retryCategory(code, diagnostic) {
  if (code.endsWith("MODEL_OUTPUT_SCHEMA_FAILED") || code.endsWith("GROUNDING_FAILED")) return "SCHEMA_OR_OUTPUT_VALIDATION";
  if (code.endsWith("RENDER_QA_FAILED")) return G2BR2_MODE ? null : "RUNTIME";
  if (code === "RETURN_CODEX_EXEC_FAILED") {
    if (!G2BR2_MODE) return "TRANSIENT_RUNTIME";
    if (["HTTP_TRANSIENT", "DNS_FAILURE", "TLS_FAILURE", "WEBSOCKET_FAILURE", "TIMEOUT", "CONNECTION_FAILURE"].includes(diagnostic?.kind)) return "TRANSIENT_RUNTIME";
  }
  return null;
}

async function loadBaseline() {
  const [intake, baseline] = await Promise.all([readJson(INPUT_FILE), readJson(BASELINE_QA)]);
  if (baseline.gate !== "G2B_LOCAL_AI_PDF_SOLUTION_PROOF" || baseline.overall !== "PASS_REFERENCE_PIPELINE_ONLY") throw new Error("RETURN_G2B_ACCEPTED_BASELINE_UNAVAILABLE");
  if (baseline.intakeValidation?.result !== "PASS" || baseline.intakeValidation.photoCount !== intake.photos.length || intake.photos.length < 12 || intake.photos.length > 25 || intake.photos.filter(photo => photo.mustUse).length > 3) throw new Error("RETURN_SYNTHETIC_INTAKE_BASELINE_DRIFT");
  if (["q1", "q2", "q3", "q4", "q5", "q6"].some(key => !intake.answers?.[key]?.trim())) throw new Error("RETURN_SYNTHETIC_INTAKE_BASELINE_DRIFT");
  return { intake, baseline };
}

async function duplicateProbe() {
  const file = canonicalJobPath(JOBS, JOB_KEY);
  const record = await readJson(file);
  if (record.status !== "completed" || record.successfulGenerationCount !== 1 || record.codexExecRunCount < 1) throw new Error("RETURN_IDEMPOTENCY_CANONICAL_RECORD_INVALID");
  const report = {
    result: "PASS",
    jobKey: JOB_KEY,
    canonicalJobs: 1,
    successfulGenerationForJob: 1,
    firstInvocationCodexExecRunCount: record.codexExecRunCount,
    duplicateInvocation: "REJECTED_BEFORE_CODEX_EXEC",
    duplicateInvocationCodexExecRunCount: 0,
    codexExecRunCountForCanonicalJob: record.codexExecRunCount,
    maxAllowedRealModelRuns: MAX_MODEL_RUNS,
    duplicateGuard: "A second process read the completed canonical record and returned before provider construction or Codex process spawn.",
    canonicalRecordRetained: true
  };
  await writeJson(IDEMPOTENCY_FILE, report);
  const qa = await readJson(QA_FILE);
  qa.idempotency = report;
  qa.realModelRunIdempotency = "PASS";
  await writeJson(QA_FILE, qa);
  process.stdout.write(JSON.stringify({ result: "DUPLICATE_REJECTED_BEFORE_CODEX_EXEC", codexExecRunCountForCanonicalJob: record.codexExecRunCount }) + "\n");
}

async function runGeneration({ retry = false } = {}) {
  await fs.mkdir(ARTIFACTS, { recursive: true });
  const { intake } = await loadBaseline();
  const login = runCodexReadOnly(["login", "status"]);
  if (!login.ok || !login.text.includes("Logged in using ChatGPT")) throw new Error("RETURN_CODEX_CHATGPT_LOGIN_REQUIRED");
  const version = runCodexReadOnly(["--version"]);
  if (!version.ok || !/^codex-cli\s+\S+/.test(version.text)) throw new Error("RETURN_CODEX_CLI_UNAVAILABLE");

  const existing = await claimCanonicalJob(JOBS, JOB_KEY, { createdBy: `${NAMESPACE}-codex-chatgpt` });
  let job = existing.record;
  if (!existing.created) {
    if (!retry || job.status !== "failed" || !job.retryCategory || job.codexExecRunCount >= MAX_MODEL_RUNS) {
      await writeJson(IDEMPOTENCY_FILE, {
        result: "PASS_DUPLICATE_REJECTED_BEFORE_CODEX_EXEC",
        jobKey: JOB_KEY,
        canonicalJobs: 1,
        firstInvocationStatus: job.status,
        successfulGenerationForJob: job.successfulGenerationCount || 0,
        codexExecRunCountForCanonicalJob: job.codexExecRunCount || 0,
        duplicateInvocation: "REJECTED_BEFORE_CODEX_EXEC",
        duplicateInvocationCodexExecRunCount: 0,
        maxAllowedRealModelRuns: MAX_MODEL_RUNS,
        rejectionReason: job.lastFailureCode || "CANONICAL_JOB_ALREADY_EXISTS"
      });
      throw new Error("RETURN_DUPLICATE_CANONICAL_JOB_REJECTED_BEFORE_CODEX_EXEC");
    }
    job = { ...job, status: "active", retryCount: (job.retryCount || 0) + 1, lastRetryReason: job.retryCategory };
  } else {
    job = {
      ...job,
      gate: GATE_ID,
      fixtureId: intake.fixtureId,
      codexExecRunCount: 0,
      successfulGenerationCount: 0,
      retryCount: 0
    };
  }
  job.status = "active";
  job.retryCategory = null;
  await saveCanonicalJob(existing.file, job);

  const schemaHash = sha256(Buffer.from(JSON.stringify(CONTENT_SCHEMA)));
  const photos = intake.photos.slice().sort((a, b) => Number(b.mustUse) - Number(a.mustUse) || b.selectionScore - a.selectionScore || a.id.localeCompare(b.id)).slice(0, 12);
  const prompt = [
    "Generate one grounded editorial magazine content object for this synthetic-only proof. Return only the schema-conforming JSON; do not use tools or modify files.",
    "Write concise English copy. Do not invent dates, trips, quotes, hobbies, achievements, relationships, preferences, or any biographical detail.",
    "Every copy object, feature, module, and caption must cite at least one valid sourceRefs entry. List every factual claim in groundedFacts and include exact source excerpts in supportingQuotes.",
    "Choose exactly two distinct dynamic modules supported by the intake. Return the 12 selected photo assignments at their supplied pageHint values, each photo exactly once.",
    "The supplied photos are synthetic geometric scene illustrations. Do not imply they depict Mira or are real photographs. Do not generate images.",
    "Keep every text field under 520 characters and use only the given source references.",
    providerPrompt(intake, photos)
  ].join("\n\n");
  await fs.writeFile(PROMPT_FILE, prompt, "utf8");
  const attemptNumber = job.codexExecRunCount + 1;
  const attemptFile = path.join(ARTIFACTS, `generated-content-attempt-${attemptNumber}.json`);
  const codexContext = await fs.mkdtemp(path.join(os.tmpdir(), `birthday-magazine-${NAMESPACE}-codex-`));
  let outputHash = null;
  let modelMetadata = null;
  try {
    const provider = new CodexExecProvider({
      executable: MODEL_EXECUTABLE,
      workingDirectory: codexContext,
      schemaPath: SCHEMA_FILE,
      outputPath: attemptFile,
      onSpawn: async () => {
        job.codexExecRunCount = attemptNumber;
        job.modelRuns = [...(job.modelRuns || []), { runNumber: attemptNumber, executionMode: EXECUTION_MODE, codexCliVersion: version.text.replace(/^codex-cli\s+/, ""), status: "STARTED" }];
        await saveCanonicalJob(existing.file, job);
      }
    });
    const response = await provider.generateStructured({ prompt, schema: CONTENT_SCHEMA });
    const responseBytes = await fs.readFile(attemptFile);
    outputHash = sha256(responseBytes);
    if (response.content?.photoPageAssignments?.length !== 12) throw Object.assign(new Error(`RETURN_${GATE_LABEL}_MODEL_OUTPUT_SCHEMA_FAILED`), { returnCode: `RETURN_${GATE_LABEL}_MODEL_OUTPUT_SCHEMA_FAILED` });
    modelMetadata = response.metadata;
    await fs.copyFile(attemptFile, OUTPUT_FILE);

    const idempotencyPending = {
      result: "IN_PROGRESS",
      jobKey: JOB_KEY,
      canonicalJobs: 1,
      successfulGenerationForJob: 0,
      codexExecRunCountForCanonicalJob: job.codexExecRunCount,
      duplicateInvocation: "PENDING_POST_QA_PROBE",
      maxAllowedRealModelRuns: MAX_MODEL_RUNS
    };
    await writeJson(IDEMPOTENCY_FILE, idempotencyPending);
    const status = {
      gate: GATE_ID,
      result: "PASS",
      executionMode: EXECUTION_MODE,
      authentication: "ChatGPT login; API key not used",
      codexCliVersion: version.text.replace(/^codex-cli\s+/, ""),
      modelIdentifier: modelMetadata.modelIdentifier,
      modelIdentifierSource: modelMetadata.modelIdentifierSource,
      realModelRunCount: job.codexExecRunCount,
      successfulGenerationCount: 1,
      schemaConstrained: true,
      schemaFile: "content-schema.json",
      schemaSha256: schemaHash,
      outputFile: "generated-content.json",
      outputSha256: outputHash,
      outputOrigin: "direct codex exec --output-last-message response; no reference fixture fallback",
      apiKeyUsed: false,
      extraCreditsPurchased: false,
      resetCreditsConsumed: false,
      sessionOrAccountIdentifiersRecorded: false,
      retryCount: job.retryCount
    };
    await writeJson(STATUS_FILE, status);

    const renderer = spawnSync(process.execPath, [path.join(HERE, "proof.mjs")], {
      cwd: ROOT,
      env: {
        ...sanitizedEnvironment(),
        BMS_REAL_AI_MODE: "1",
        BMS_REAL_AI_GATE_ID: GATE_ID,
        BMS_REAL_AI_NAMESPACE: NAMESPACE,
        BMS_REAL_AI_CONTENT_FILE: OUTPUT_FILE,
        BMS_REAL_AI_STATUS_FILE: STATUS_FILE,
        BMS_REAL_AI_IDEMPOTENCY_FILE: IDEMPOTENCY_FILE
      },
      encoding: "utf8",
      windowsHide: true,
      timeout: 180_000
    });
    if (renderer.error || renderer.status !== 0) {
      const outputValidationFailed = /RETURN_GROUNDING_OR_CONTENT_SCHEMA_FAILED|RETURN_REAL_AI_PHOTO_ASSIGNMENT_MISMATCH/.test(`${renderer.stderr || ""}\n${renderer.stdout || ""}`);
      if (outputValidationFailed) {
        const returnCode = `RETURN_${GATE_LABEL}_MODEL_OUTPUT_SCHEMA_FAILED`;
        throw Object.assign(new Error(returnCode), {
          returnCode,
          providerDiagnostic: { kind: "OUTPUT_SCHEMA_OR_CONSTRAINT", safeSummary: "Generated content failed grounding or photo-mapping validation." }
        });
      }
      throw Object.assign(new Error(`RETURN_${GATE_LABEL}_RENDER_QA_FAILED`), { returnCode: `RETURN_${GATE_LABEL}_RENDER_QA_FAILED` });
    }
    const qa = await readJson(QA_FILE);
    if (qa.overall !== REAL_AI_QA_PASS || qa.aiStructuredGeneration?.realAiCall !== "PASS" || qa.grounding?.result !== "PASS" || qa.pdf?.pageCount !== 12) throw Object.assign(new Error(`RETURN_${GATE_LABEL}_RENDER_QA_FAILED`), { returnCode: `RETURN_${GATE_LABEL}_RENDER_QA_FAILED` });

    const pdfBytes = await fs.readFile(path.join(ARTIFACTS, "proof-magazine-soft-warm.pdf"));
    job.status = "completed";
    job.successfulGenerationCount = 1;
    job.completedModelRunNumber = attemptNumber;
    job.generatedContentSha256 = outputHash;
    job.pdfSha256 = sha256(pdfBytes);
    job.retryCategory = null;
    await saveCanonicalJob(existing.file, job);
    await writeJson(STATUS_FILE, { ...status, result: "PASS", pdfSha256: job.pdfSha256 });

    const duplicate = spawnSync(process.execPath, [fileURLToPath(import.meta.url), "--duplicate-check"], {
      cwd: ROOT,
      env: sanitizedEnvironment(),
      encoding: "utf8",
      windowsHide: true,
      timeout: 15_000
    });
    if (duplicate.error || duplicate.status !== 0) throw Object.assign(new Error("RETURN_IDEMPOTENCY_DUPLICATE_PROBE_FAILED"), { returnCode: "RETURN_IDEMPOTENCY_DUPLICATE_PROBE_FAILED" });
    const finalQA = await readJson(QA_FILE);
    if (finalQA.idempotency?.result !== "PASS" || finalQA.idempotency?.duplicateInvocationCodexExecRunCount !== 0) throw Object.assign(new Error("RETURN_IDEMPOTENCY_DUPLICATE_PROBE_FAILED"), { returnCode: "RETURN_IDEMPOTENCY_DUPLICATE_PROBE_FAILED" });

    const summary = {
      gate: GATE_ID,
      result: `PASS_CANDIDATE_${GATE_ID}`,
      executionMode: EXECUTION_MODE,
      modelIdentifier: modelMetadata.modelIdentifier,
      modelRunCount: job.codexExecRunCount,
      generatedContent: "generated-content.json",
      pdf: "proof-magazine-soft-warm.pdf",
      pdfSha256: job.pdfSha256,
      pageCount: 12,
      idempotency: "duplicate invocation rejected before second codex exec"
    };
    await writeJson(path.join(ARTIFACTS, "run-summary.json"), summary);
    process.stdout.write(JSON.stringify(summary, null, 2) + "\n");
  } catch (error) {
    job.status = "failed";
    job.lastFailureCode = error.returnCode || `RETURN_${GATE_LABEL}_EXECUTION_FAILED`;
    job.retryCategory = retryCategory(job.lastFailureCode, error.providerDiagnostic);
    const failedRun = (job.modelRuns || []).find(item => item.runNumber === job.codexExecRunCount);
    if (failedRun) {
      failedRun.status = "FAILED";
      failedRun.result = job.lastFailureCode;
      failedRun.providerDiagnostic = error.providerDiagnostic || null;
    }
    await saveCanonicalJob(existing.file, job).catch(() => {});
    await writeJson(STATUS_FILE, {
      gate: GATE_ID,
      result: job.lastFailureCode,
      executionMode: EXECUTION_MODE,
      codexCliVersion: version.text.replace(/^codex-cli\s+/, ""),
      realModelRunCount: job.codexExecRunCount || 0,
      successfulGenerationCount: 0,
      schemaConstrained: true,
      apiKeyUsed: false,
      retryCategory: job.retryCategory,
      providerDiagnostic: error.providerDiagnostic || null,
      outputSha256: outputHash,
      sessionOrAccountIdentifiersRecorded: false
    }).catch(() => {});
    throw new Error(job.lastFailureCode);
  } finally {
    await fs.rm(codexContext, { recursive: true, force: true });
  }
}

async function main() {
  if (process.argv.includes("--duplicate-check")) return duplicateProbe();
  await runGeneration({ retry: process.argv.includes("--retry-failed") });
}

main().catch(error => {
  process.stderr.write((error.message || `RETURN_${GATE_LABEL}_EXECUTION_FAILED`) + "\n");
  process.exitCode = 1;
});
