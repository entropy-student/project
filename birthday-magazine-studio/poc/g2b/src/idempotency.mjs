import fs from "node:fs/promises";
import path from "node:path";
import crypto from "node:crypto";

export function canonicalJobPath(directory, key) {
  const filename = crypto.createHash("sha256").update(key).digest("hex") + ".json";
  return path.join(directory, filename);
}

export async function claimCanonicalJob(directory, key, { createdBy = "g2b-local-proof" } = {}) {
  const file = canonicalJobPath(directory, key);
  await fs.mkdir(path.dirname(file), { recursive: true });
  const record = { orderKey: key, canonical: true, status: "active", createdBy };
  try {
    const handle = await fs.open(file, "wx");
    await handle.writeFile(JSON.stringify(record));
    await handle.close();
    return { file, created: true, record };
  } catch (error) {
    if (error.code !== "EEXIST") throw error;
    const existing = JSON.parse(await fs.readFile(file, "utf8"));
    if (existing.orderKey !== key || existing.canonical !== true) throw new Error("IDEMPOTENCY_KEY_COLLISION");
    return { file, created: false, record: existing };
  }
}

export async function saveCanonicalJob(file, record) {
  const temporary = file + "." + crypto.randomUUID() + ".tmp";
  await fs.writeFile(temporary, JSON.stringify(record, null, 2) + "\n", { flag: "wx" });
  try {
    await fs.rename(temporary, file);
  } catch (error) {
    await fs.rm(temporary, { force: true });
    throw error;
  }
}
