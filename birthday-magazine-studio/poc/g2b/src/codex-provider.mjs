import fs from "node:fs/promises";
import path from "node:path";
import { spawn } from "node:child_process";

function modelFromEvents(stdout) {
  const candidates = new Set();
  for (const line of stdout.split(/\r?\n/)) {
    if (!line.trim()) continue;
    let event;
    try { event = JSON.parse(line); } catch { continue; }
    const visit = value => {
      if (!value || typeof value !== "object") return;
      for (const [key, child] of Object.entries(value)) {
        if (typeof child === "string" && /^model(name|_name)?$/i.test(key) && /^(gpt|codex|o\d)[-_./a-z0-9]*$/i.test(child)) candidates.add(child);
        else if (child && typeof child === "object") visit(child);
      }
    };
    visit(event);
  }
  return candidates.size === 1 ? [...candidates][0] : null;
}

function failureKind(output) {
  if (/rate.?limit|plan allowance|usage limit|quota/i.test(output)) return "PLAN_OR_RATE_LIMIT";
  if (/schema|structured output|json output/i.test(output)) return "OUTPUT_SCHEMA_OR_CONSTRAINT";
  if (/sandbox|permission|access denied/i.test(output)) return "SANDBOX_OR_PERMISSION";
  if (/network|connect|timed out|dns/i.test(output)) return "NETWORK_OR_TRANSIENT";
  if (/login|auth|credential/i.test(output)) return "AUTHENTICATION";
  return "CODEX_EXEC_NONZERO";
}

export class CodexExecProvider {
  constructor({ executable, workingDirectory, schemaPath, outputPath, onSpawn }) {
    this.executable = executable || "codex";
    this.workingDirectory = workingDirectory;
    this.schemaPath = schemaPath;
    this.outputPath = outputPath;
    this.onSpawn = onSpawn;
  }

  async generateStructured({ prompt, schema }) {
    await fs.mkdir(path.dirname(this.schemaPath), { recursive: true });
    await fs.mkdir(path.dirname(this.outputPath), { recursive: true });
    await fs.writeFile(this.schemaPath, JSON.stringify(schema, null, 2) + "\n", "utf8");
    await fs.rm(this.outputPath, { force: true });

    const args = [
      "exec", "--cd", this.workingDirectory,
      "--sandbox", "read-only",
      "--skip-git-repo-check",
      "--ephemeral", "--ignore-user-config",
      "--output-schema", this.schemaPath,
      "--output-last-message", this.outputPath,
      "--json", "--color", "never", "-"
    ];
    const env = { ...process.env };
    for (const name of ["OPENAI_API_KEY", "OPENAI_BASE_URL", "OPENAI_CUSTOM_HEADERS", "OPENAI_ORG_ID", "OPENAI_PROJECT_ID"]) delete env[name];

    const jsLauncher = this.executable.toLowerCase().endsWith(".js");
    const command = jsLauncher ? process.execPath : this.executable;
    const commandArgs = jsLauncher ? [this.executable, ...args] : args;
    const { code, stderr, stdout } = await new Promise((resolve, reject) => {
      const child = spawn(command, commandArgs, { cwd: this.workingDirectory, env, windowsHide: true, stdio: ["pipe", "pipe", "pipe"] });
      let stdoutText = "";
      let stderrText = "";
      let settled = false;
      const timeout = setTimeout(() => child.kill(), 300_000);
      child.once("spawn", () => Promise.resolve(this.onSpawn?.()).then(() => child.stdin.end(prompt, "utf8"), error => { child.kill(); reject(error); }));
      child.stdout.setEncoding("utf8").on("data", chunk => { stdoutText += chunk; });
      child.stderr.setEncoding("utf8").on("data", chunk => { stderrText += chunk; });
      child.once("error", error => {
        if (settled) return;
        settled = true;
        clearTimeout(timeout);
        reject(error);
      });
      child.once("close", code => {
        if (settled) return;
        settled = true;
        clearTimeout(timeout);
        resolve({ code, stdout: stdoutText, stderr: stderrText });
      });
    });

    if (code !== 0) {
      const kind = failureKind(stderr + stdout);
      const detail = kind === "PLAN_OR_RATE_LIMIT"
        ? "RETURN_CODEX_PLAN_LIMIT_REACHED"
        : kind === "OUTPUT_SCHEMA_OR_CONSTRAINT"
          ? "RETURN_G2BR1_MODEL_OUTPUT_SCHEMA_FAILED"
          : kind === "AUTHENTICATION"
            ? "RETURN_CODEX_CHATGPT_LOGIN_REQUIRED"
            : "RETURN_CODEX_EXEC_FAILED";
      const error = new Error(detail);
      error.returnCode = detail;
      error.providerDiagnostic = { kind, exitCode: code };
      throw error;
    }
    const raw = await fs.readFile(this.outputPath, "utf8");
    let content;
    try { content = JSON.parse(raw); } catch {
      const error = new Error("RETURN_G2BR1_MODEL_OUTPUT_SCHEMA_FAILED");
      error.returnCode = "RETURN_G2BR1_MODEL_OUTPUT_SCHEMA_FAILED";
      throw error;
    }
    return {
      content,
      metadata: {
        modelIdentifier: modelFromEvents(stdout),
        modelIdentifierSource: modelFromEvents(stdout) ? "codex_exec_json_event" : "not_exposed_by_codex_exec",
        stdoutEventCount: stdout.split(/\r?\n/).filter(Boolean).length,
        exitCode: code
      }
    };
  }
}
