import fs from "node:fs/promises";

const manifest = JSON.parse(await fs.readFile(new URL("../extension/manifest.json", import.meta.url), "utf8"));
if (manifest.manifest_version !== 3) throw new Error("manifest_version must be 3");
for (const file of ["background.js", "content.js", "sidepanel.html", "sidepanel.js", "sidepanel.css", "shared.js"]) {
  await fs.access(new URL(`../extension/${file}`, import.meta.url));
}
if (!manifest.host_permissions?.every((x) => x.startsWith("https://chatgpt.com/"))) throw new Error("Unexpected host permission");
console.log("Extension static check: PASS");
console.log(`Name: ${manifest.name}`);
console.log(`Version: ${manifest.version}`);
console.log(`Permissions: ${manifest.permissions.join(", ")}`);
