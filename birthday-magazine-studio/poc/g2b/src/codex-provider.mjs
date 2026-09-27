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

function failureDiagnostic(output, { timedOut = false } = {}) {
  const text = String(output || "");
  const httpStatus = text.match(/\bHTTP(?:\/\d(?:\.\d)?)?\s+(\d{3})\b|\bstatus(?: code)?\s*[:= ]\s*([45]\d{2})\b/i);
  if (/rate.?limit|plan allowance|usage limit|quota/i.test(text) || httpStatus && Number(httpStatus[1] || httpStatus[2]) === 429) return { kind: "PLAN_OR_RATE_LIMIT", safeSummary: "Codex reported a plan, quota, or rate limit." };
  if (/ENOTFOUND|EAI_AGAIN|name resolution|DNS lookup|could not resolve/i.test(text)) return { kind: "DNS_FAILURE", safeSummary: "Host name resolution failed." };
  if (/TLS|SSL|certificate|CERT_[A-Z_]+|handshake failure|unable to verify/i.test(text)) return { kind: "TLS_FAILURE", safeSummary: "TLS or certificate negotiation failed." };
  if (/websocket|web socket|upgrade request|upgrade response/i.test(text)) return { kind: "WEBSOCKET_FAILURE", safeSummary: "WebSocket transport or upgrade failed." };
  if (httpStatus) {
    const statusCode = Number(httpStatus[1] || httpStatus[2]);
    if (statusCode === 401 || statusCode === 403) return { kind: "AUTHENTICATION", httpStatus: statusCode, safeSummary: `Codex returned HTTP ${statusCode}.` };
    return { kind: statusCode === 408 || statusCode >= 500 ? "HTTP_TRANSIENT" : "HTTP_FAILURE", httpStatus: statusCode, safeSummary: `Codex returned HTTP ${statusCode}.` };
  }
  if (/unknown option|unrecognized option|invalid argument|unexpected argument|usage:\s*codex|error:.*(?:argument|option)/i.test(text)) return { kind: "CLI_ARGUMENT", safeSummary: "Codex rejected a command-line argument." };
  if (/login|auth|credential|unauthorized|forbidden/i.test(text)) return { kind: "AUTHENTICATION", safeSummary: "Codex authentication was rejected or unavailable." };
  if (timedOut || /timed out|timeout|ETIMEDOUT/i.test(text)) return { kind: "TIMEOUT", safeSummary: "Codex execution timed out." };
  if (/sandbox|permission|access denied/i.test(text)) return { kind: "SANDBOX_OR_PERMISSION", safeSummary: "Codex execution was blocked by a permission boundary." };
  if (/schema|structured output|json output/i.test(text)) return { kind: "OUTPUT_SCHEMA_OR_CONSTRAINT", safeSummary: "Codex could not satisfy the structured output constraint." };
  if (/ECONNRESET|ECONNREFUSED|connection|network|socket/i.test(text)) return { kind: "CONNECTION_FAILURE", safeSummary: "Codex transport connection failed." };
  return { kind: "CODEX_EXEC_NONZERO", safeSummary: "Codex exited unsuccessfully without a classified diagnostic." };
}

function codexFailureCode(diagnostic) {
  if (diagnostic.kind === "PLAN_OR_RATE_LIMIT") return "RETURN_CODEX_PLAN_LIMIT_REACHED";
  if (diagnostic.kind === "AUTHENTICATION") return "RETURN_CODEX_CHATGPT_LOGIN_REQUIRED";
  if (diagnostic.kind === "CLI_ARGUMENT") return "RETURN_CODEX_CLI_ARGUMENT_ERROR";
  if (diagnostic.kind === "HTTP_FAILURE") return "RETURN_CODEX_HTTP_FAILURE";
  if (diagnostic.kind === "HTTP_TRANSIENT" || diagnostic.kind === "DNS_FAILURE" || diagnostic.kind === "TLS_FAILURE" || diagnostic.kind === "WEBSOCKET_FAILURE" || diagnostic.kind === "TIMEOUT" || diagnostic.kind === "CONNECTION_FAILURE") return "RETURN_CODEX_EXEC_FAILED";
  if (diagnostic.kind === "OUTPUT_SCHEMA_OR_CONSTRAINT") return process.env.BMS_G2BR2_HOST_MODE === "1" ? "RETURN_G2BR2_MODEL_OUTPUT_SCHEMA_FAILED" : "RETURN_G2BR1_MODEL_OUTPUT_SCHEMA_FAILED";
  return "RETURN_CODEX_EXEC_FAILED";
}

export class CodexExecProvider {
  constructor({ executable, workingDirectory, schemaPath, outputPath, onSpawn, httpOnlyChatGPT = false }) {
    this.executable = executable || "codex";
    this.workingDirectory = workingDirectory;
    this.schemaPath = schemaPath;
    this.outputPath = outputPath;
    this.onSpawn = onSpawn;
    this.httpOnlyChatGPT = httpOnlyChatGPT;
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
    if (this.httpOnlyChatGPT) {
      args.splice(1, 0,
        "-c", 'model_provider="g2br2_chatgpt_http"',
        "-c", 'model_providers.g2br2_chatgpt_http.name="G2BR2 ChatGPT HTTP"',
        "-c", 'model_providers.g2br2_chatgpt_http.base_url="https://chatgpt.com/backend-api/codex"',
        "-c", "model_providers.g2br2_chatgpt_http.requires_openai_auth=true",
        "-c", "model_providers.g2br2_chatgpt_http.supports_websockets=false",
        "-c", 'model_providers.g2br2_chatgpt_http.wire_api="responses"'
      );
    }
    const env = { ...process.env };
    for (const name of ["OPENAI_API_KEY", "OPENAI_BASE_URL", "OPENAI_CUSTOM_HEADERS", "OPENAI_ORG_ID", "OPENAI_PROJECT_ID"]) delete env[name];

    const jsLauncher = this.executable.toLowerCase().endsWith(".js");
    const command = jsLauncher ? process.execPath : this.executable;
    const commandArgs = jsLauncher ? [this.executable, ...args] : args;
    const { code, stderr, stdout, timedOut } = await new Promise((resolve, reject) => {
      const child = spawn(command, commandArgs, { cwd: this.workingDirectory, env, windowsHide: true, stdio: ["pipe", "pipe", "pipe"] });
      let stdoutText = "";
      let stderrText = "";
      let settled = false;
      let timedOut = false;
      const timeout = setTimeout(() => { timedOut = true; child.kill(); }, 300_000);
      child.once("spawn", () => Promise.resolve(this.onSpawn?.()).then(() => child.stdin.end(prompt, "utf8"), error => { child.kill(); reject(error); }));
      child.stdout.setEncoding("utf8").on("data", chunk => { stdoutText += chunk; });
      child.stderr.setEncoding("utf8").on("data", chunk => { stderrText += chunk; });
      child.once("error", error => {
        if (settled) return;
        settled = true;
        clearTimeout(timeout);
        const diagnostic = error.code === "ENOENT"
          ? { kind: "CLI_EXECUTABLE_UNAVAILABLE", safeSummary: "Codex CLI executable was not found." }
          : error.code === "EACCES"
            ? { kind: "CLI_EXECUTABLE_PERMISSION", safeSummary: "Codex CLI executable could not be started due to permissions." }
            : { kind: "PROCESS_SPAWN_FAILED", safeSummary: "Codex CLI process could not be started." };
        reject(Object.assign(new Error(diagnostic.kind === "CLI_EXECUTABLE_UNAVAILABLE" ? "RETURN_CODEX_CLI_UNAVAILABLE" : "RETURN_CODEX_EXEC_FAILED"), {
          returnCode: diagnostic.kind === "CLI_EXECUTABLE_UNAVAILABLE" ? "RETURN_CODEX_CLI_UNAVAILABLE" : "RETURN_CODEX_EXEC_FAILED",
          providerDiagnostic: diagnostic
        }));
      });
      child.once("close", code => {
        if (settled) return;
        settled = true;
        clearTimeout(timeout);
        resolve({ code, stdout: stdoutText, stderr: stderrText, timedOut });
      });
    });

    if (code !== 0) {
      const diagnostic = failureDiagnostic(stderr + stdout, { timedOut });
      const detail = codexFailureCode(diagnostic);
      const error = new Error(detail);
      error.returnCode = detail;
      error.providerDiagnostic = { ...diagnostic, exitCode: code };
      throw error;
    }
    const raw = await fs.readFile(this.outputPath, "utf8");
    let content;
    try { content = JSON.parse(raw); } catch {
      const returnCode = process.env.BMS_G2BR2_HOST_MODE === "1" ? "RETURN_G2BR2_MODEL_OUTPUT_SCHEMA_FAILED" : "RETURN_G2BR1_MODEL_OUTPUT_SCHEMA_FAILED";
      const error = new Error(returnCode);
      error.returnCode = returnCode;
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
