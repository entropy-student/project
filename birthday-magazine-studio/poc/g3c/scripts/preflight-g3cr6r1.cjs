const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { spawnSync } = require('child_process');
const { chromium } = require('../.tmp/browser-tools/node_modules/playwright-core');
const base = path.resolve(__dirname, '..');
const reportDir = path.join(base, 'artifacts/reports');
const backup = path.join(base, 'artifacts/backups/g3cr6r1');
const sha = bytes => crypto.createHash('sha256').update(bytes).digest('hex');
const protectedFiles = ['compose.yaml', 'commerce-workspace-plugin/bms-g3a-commerce-loop.php', 'mailpit-plugin/00-g3a-local-mailpit.php'];
async function main() {
  if (fs.existsSync(backup)) throw new Error('Scoped rollback already exists; do not overwrite.');
  const php = spawnSync('docker', ['exec', '-i', 'birthday-magazine-g3c-wordpress-1', 'php', '--', 'snapshot'], {input:fs.readFileSync(path.join(__dirname, 'readback-g3cr6r1.php')), encoding:'utf8'});
  if (php.status !== 0) throw new Error('Runtime readback failed: ' + php.stderr);
  const snapshot = JSON.parse(php.stdout);
  if (snapshot.home_sha256 !== 'b45daee18bb450e958614e756bcb000742ab6cb2cf727dc45aa25152eafcbbfb' || snapshot.product.price !== '39.99' || !snapshot.product.virtual || snapshot.product.currency !== 'USD' || snapshot.theme !== 'blocksy') throw new Error('Material preflight drift.');
  const browser = await chromium.launch({headless:true, executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'});
  const page = await browser.newPage({viewport:{width:1440,height:1000}});
  const pages = [];
  for (const route of ['/', '/product/birthday-magazine/', '/cart/', '/my-account/']) {
    const response = await page.goto('http://127.0.0.1:8189' + route, {waitUntil:'networkidle'});
    if (response.status() !== 200) throw new Error('Preflight HTTP failure: ' + route);
    pages.push({route,status:response.status(), ...await page.evaluate(()=>({width:document.documentElement.scrollWidth,viewport:innerWidth,title:document.title,preview:!!document.querySelector('[data-bms-preview]')}))});
  }
  await page.goto('http://127.0.0.1:8189/', {waitUntil:'networkidle'});
  await page.evaluate(async()=>{document.querySelectorAll('img').forEach(i=>i.loading='eager');await document.fonts.ready;await Promise.all([...document.images].map(i=>i.decode().catch(()=>{})));});
  fs.mkdirSync(backup, {recursive:true});
  await page.screenshot({path:path.join(backup,'home-before.png'),fullPage:true});
  await browser.close();
  fs.writeFileSync(path.join(backup, 'presentation-before.json'), php.stdout);
  const copy = path.join(backup, 'preview-plugin-before');
  fs.mkdirSync(copy);
  for (const name of fs.readdirSync(path.join(base, 'preview-plugin'))) {
    const source = path.join(base, 'preview-plugin', name);
    if (fs.statSync(source).isFile()) fs.copyFileSync(source, path.join(copy,name));
  }
  const manifest = {gate:'G3CR6R1_FRONTEND_COMPOSITION_REDESIGN',preRunHead:'9f90c1e53058567010fcbd9f505ac99ceaacc6f9',createdAt:new Date().toISOString(),backup,protectedFiles:protectedFiles.map(name=>({path:name,sha256:sha(fs.readFileSync(path.join(base,name)))})),runtimeHashes:snapshot.protected_runtime_hashes,presentationSha256:sha(Buffer.from(php.stdout)),sourceFiles:fs.readdirSync(copy).map(name=>({name,sha256:sha(fs.readFileSync(path.join(copy,name)))})),pages,orderCount:snapshot.order_count};
  fs.mkdirSync(reportDir,{recursive:true});
  fs.writeFileSync(path.join(backup,'rollback-manifest.json'),JSON.stringify(manifest,null,2)+'\n');
  const {presentation_rollback,footer_placements,...safeRuntime}=snapshot;
  fs.writeFileSync(path.join(reportDir,'g3cr6r1-preflight.json'),JSON.stringify({manifest,runtime:safeRuntime},null,2)+'\n');
  console.log(JSON.stringify({backup,manifest,safeRuntime,footerPlacements:footer_placements},null,2));
}
main().catch(e=>{console.error(e);process.exit(1);});
