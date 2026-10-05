const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const { execFileSync } = require('node:child_process');
const { chromium } = require('playwright');
const project = path.resolve(__dirname, '../../..');
const repo = path.resolve(project, '..');
const baseline = '1bb5dedde256ad84fec02d7350430f051492ed0f';
const out = path.join(project, 'docs/evidence/g3cr7v2r4-preview-focus');
const backup = path.join(project, 'poc/g3c/.tmp/preview-focus-20261005');
const hash = x => crypto.createHash('sha256').update(x).digest('hex');
const normalized = x => x.toString().replace(/\r\n/g, '\n');
const manifest = JSON.parse(fs.readFileSync(path.join(backup, 'manifest.json')));
const backups = manifest.files.map(x => {
 const ok = hash(fs.readFileSync(path.join(backup, x.role, x.file))) === x.sha256;
 assert(ok); return { role: x.role, file: x.file, sha256: x.sha256, verified: ok };
});
const frozen = ['preview.js', 'frontend-reproduction.js', 'frontend-reproduction.php', 'frontend-reproduction.css', 'home.css', 'home-motion.js', 'studio.css'].filter(x => fs.existsSync(path.join(project, 'poc/g3c/preview-plugin', x))).map(file => {
 const relative = 'birthday-magazine-studio/poc/g3c/preview-plugin/' + file;
 const original = execFileSync('git', ['show', baseline + ':' + relative], { cwd: repo, maxBuffer: 8*1024*1024 });
 const current = fs.readFileSync(path.join(repo, relative));
 const mounted = fs.readFileSync(path.join(manifest.runtime, file));
 assert.equal(normalized(current), normalized(original));
 assert.equal(normalized(mounted), normalized(original));
 return { file, baselineSHA256: hash(normalized(original)), sourceSHA256: hash(normalized(current)), runtimeSHA256: hash(normalized(mounted)), normalizedNewlinesOnly: true, unchanged: true };
});
const php = fs.readFileSync(path.join(project, 'poc/g3c/preview-plugin/birthday-magazine-poc.php'));
const priorPHP = execFileSync('git', ['show', baseline + ':birthday-magazine-studio/poc/g3c/preview-plugin/birthday-magazine-poc.php'], { cwd: repo });
const title = '   <?php if (is_front_page()) : ?><h3 class="bms-preview-controls-title">Try it for free</h3><?php endif; ?>\n';
assert.equal(normalized(php).replace(title, ''), normalized(priorPHP));
async function run() {
 const browser = await chromium.launch({ headless: true, executablePath: 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe' });
 const context = await browser.newContext({ viewport: { width: 2048, height: 1152 }, reducedMotion: 'reduce' });
 // Deliberately no request routing, cache override, cache clearing or bypass.
 const page = await context.newPage();
 const responses = [];
 page.on('response', response => { if(response.url().includes('/magazine-preview.css')) responses.push(response); });
 await page.goto('http://127.0.0.1:8189/', { waitUntil: 'networkidle' });
 await page.reload({ waitUntil: 'networkidle' });
 const response = responses.at(-1); assert(response);
 const bytes = await response.body();
 const currentCSS = fs.readFileSync(path.join(project, 'poc/g3c/preview-plugin/magazine-preview.css'));
 assert.equal(hash(bytes), hash(currentCSS));
 const tokens = await page.locator('#preview').evaluate(x => ({ field: getComputedStyle(x).backgroundColor, headingWeight: getComputedStyle(x.querySelector('.bms-heading')).fontWeight, emphasis: getComputedStyle(x.querySelector('.bms-heading strong')).color, emphasisWeight: getComputedStyle(x.querySelector('.bms-heading strong')).fontWeight, scrollWidth: document.documentElement.scrollWidth, viewport: innerWidth }));
 assert.equal(tokens.field, 'rgb(244, 235, 240)'); assert.equal(tokens.headingWeight, '650'); assert.equal(tokens.emphasisWeight, '700'); assert.equal(tokens.emphasis, 'rgb(113, 63, 93)');
 assert(tokens.scrollWidth <= tokens.viewport);
 const delivery = { browser: browser.version(), ordinaryCache: true, routing: false, cacheCleared: false, bypass: false, cssURL: response.url(), status: response.status(), deliveredSHA256: hash(bytes), sourceSHA256: hash(currentCSS), tokens };
 fs.writeFileSync(path.join(out, 'delivery-and-boundary.json'), JSON.stringify({ baseline, backups, frozen, phpDifferenceOnlyHomeConditionalHeading: true, delivery }, null, 2));
 await browser.close();
 console.log(JSON.stringify({ backupHashesVerified: backups.length, frozenFiles: frozen.length, ordinaryCacheDelivery: 'PASS' }));
}
run().catch(e => { console.error(e); process.exitCode = 1; });
