// Read-only candidate identity, ordinary-cache Edge delivery and viewport context.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { execFileSync } = require('node:child_process');
const assert = require('node:assert/strict');
const { chromium } = require('playwright');
const repo = path.resolve(__dirname, '../../../..');
const project = path.join(repo, 'birthday-magazine-studio');
const source = path.join(project, 'poc/g3c/preview-plugin');
const output = path.join(project, 'docs/evidence/g3cr7v2r4');
const baseline = '43ebf7bb732e9e3be8d547364ca7b018f7f505f8';
const backup = JSON.parse(fs.readFileSync(path.join(project, 'poc/g3c/.tmp/g3cr7v2r4-rollback/manifest.json')));
const origin = 'http://127.0.0.1:8189';
const hash = data => crypto.createHash('sha256').update(data).digest('hex');
const lf = data => data.toString().replace(/\r\n/g, '\n');
const git = file => execFileSync('git', ['show', baseline + ':birthday-magazine-studio/poc/g3c/preview-plugin/' + file], { cwd: repo });
const files = ['birthday-magazine-poc.php', 'frontend-reproduction.php', 'magazine-preview.css', 'frontend-reproduction.css'];
const identity = files.map(file => {
 const a = fs.readFileSync(path.join(source, file)), b = fs.readFileSync(path.join(backup.runtime, file));
 assert.equal(hash(a), hash(b));
 return { file, sourceSHA256: hash(a), runtimeSHA256: hash(b), exactMatch: true, bytes: a.length };
});
const frozenJS = ['preview.js', 'frontend-reproduction.js', 'home-motion.js'].map(file => {
 const a = fs.readFileSync(path.join(source, file));
 assert.equal(hash(lf(git(file))), hash(lf(a)));
 assert.equal(hash(lf(a)), hash(lf(fs.readFileSync(path.join(backup.runtime, file)))));
 return { file, baselineNormalizedSHA256: hash(lf(git(file))), candidateNormalizedSHA256: hash(lf(a)), runtimeNormalizedMatch: true, newlineNormalizationOnly: true };
});
const originalPHP = lf(git('frontend-reproduction.php'));
const currentPHP = lf(fs.readFileSync(path.join(source, 'frontend-reproduction.php')));
let unwrapped = currentPHP.replace(/<header class="bms-g3cr7-step-intro">([\s\S]*?)<\/header>\s*<div class="bms-g3cr7-step-body">/g, '$1').replace(/\s*<\/div>\s*<\/section>/g, '\n   </section>');
assert.equal(unwrapped.replace(/\s+/g, ''), originalPHP.replace(/\s+/g, ''));
const statusMarker = 'function bms_g3cr7_order_state';
assert.equal(currentPHP.slice(currentPHP.indexOf(statusMarker)), originalPHP.slice(originalPHP.indexOf(statusMarker)));
const originalMain = lf(git('birthday-magazine-poc.php'));
const currentMain = lf(fs.readFileSync(path.join(source, 'birthday-magazine-poc.php')));
const previewMarker = "add_shortcode('bms_preview'";
assert.equal(currentMain.slice(0, currentMain.indexOf(previewMarker)), originalMain.slice(0, originalMain.indexOf(previewMarker)));
const frozen = { baseline, frozenJS, intakePHPOnlyFivePresentationWrappers: true, statusAndWooPHPExactMatch: true, mainPHPBeforePreviewShortcodeExactMatch: true };
const docker = JSON.parse(execFileSync('docker', ['inspect', '--format', '{{json .Id}}', 'birthday-magazine-g3c-wordpress-1']).toString());
assert.equal(docker, '21892d72baebe6157fbeab15ad6a1e3949cf4663ca55b45360c3f4eb1f052f00');
const running = execFileSync('docker', ['inspect', '--format', '{{.State.Running}}', 'birthday-magazine-g3c-wordpress-1']).toString().trim();
assert.equal(running, 'true');
const network = [], geometry = [], css = [], routes = [], screenshots = [];
async function run() {
 const browser = await chromium.launch({ headless: true, executablePath: 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe' });
 for (const width of [2048, 1440, 375]) {
  // No request routing, cache clear, disabled cache or bypass headers here.
  const context = await browser.newContext({ viewport: { width, height: width === 375 ? 812 : 1152 }, deviceScaleFactor: 1 });
  const page = await context.newPage();
  const requests = { width, nonGET: 0, externalImage: 0, errors: [] };
  page.on('request', r => { if (!['GET', 'HEAD'].includes(r.method())) requests.nonGET++; if (r.resourceType() === 'image' && /^https?:/.test(r.url()) && new URL(r.url()).origin !== origin) requests.externalImage++; });
  page.on('pageerror', e => requests.errors.push(e.message));
  for (const [label, route, selector] of [['home', '/', '#preview'], ['intake', '/make-your-magazine/', '.bms-g3cr7']]) {
   await page.goto(origin + route, { waitUntil: 'networkidle' });
   await page.reload({ waitUntil: 'networkidle' });
   if (label === 'home') await page.evaluate(() => scrollTo(0, document.querySelector('#preview').getBoundingClientRect().top + scrollY - 24));
   const file = `${label}-viewport-${width}.png`;
   await page.screenshot({ path: path.join(output, 'confirm', file), animations: 'disabled', fullPage: label === 'intake' });
   const bytes = fs.readFileSync(path.join(output, 'confirm', file));
   screenshots.push({ file, bytes: bytes.length, sha256: hash(bytes), viewport: width, fullPage: label === 'intake' });
   geometry.push(await page.evaluate(({ label, selector, width }) => {
    const root = document.querySelector(selector), rect = root.getBoundingClientRect(), rootStyle = getComputedStyle(root); const usefulWidth = label === 'home' ? rect.width - parseFloat(rootStyle.paddingLeft) - parseFloat(rootStyle.paddingRight) : rect.width;
    const pick = s => { const e = root.querySelector(s); if (!e) return null; const r = e.getBoundingClientRect(), c = getComputedStyle(e); return { width: r.width, height: r.height, font: c.fontSize, lineHeight: c.lineHeight, background: c.backgroundColor, grid: c.gridTemplateColumns }; };
    const header = document.querySelector('header#header')?.getBoundingClientRect();
    return { label, viewport: width, scrollWidth: document.documentElement.scrollWidth, outerWidth: rect.width, contentWidth: usefulWidth, percentage: usefulWidth / width * 100, topY: rect.top + scrollY, headerToContentGap: header ? rect.top + scrollY - (header.bottom + scrollY) : null, h1: pick(label === 'home' ? '.bms-heading' : 'h1'), step: pick('.bms-g3cr7-step h2'), help: pick(label === 'home' ? '.bms-dark-panel .bms-copy' : '.bms-g3cr7-help'), fieldLabel: pick(label === 'home' ? '.bms-preview-controls label' : '.bms-g3cr7-field'), input: pick('input:not([type="file"])'), controls: pick('.bms-preview-controls'), stage: pick('.bms-preview-stage'), cover: pick('.bms-preview-cover'), spread: pick('.bms-preview-spread'), cta: pick(label === 'home' ? '.bms-coral-link' : '[data-next]') };
   }, { label, selector, width }));
   for (const url of await page.locator('link[rel="stylesheet"]').evaluateAll(xs => xs.map(x => x.href).filter(x => /magazine-preview\.css|frontend-reproduction\.css/.test(x)))) {
    const data = await page.evaluate(async u => { const r = await fetch(u); return { status: r.status, text: await r.text() }; }, url);
    const file = path.basename(new URL(url).pathname), sourceHash = hash(fs.readFileSync(path.join(source, file)));
    assert.equal(hash(Buffer.from(data.text)), sourceHash);
    assert.equal(new URL(url).searchParams.get('ver'), String(Math.floor(fs.statSync(path.join(source, file)).mtimeMs / 1000)));
    css.push({ viewport: width, label, url, status: data.status, responseSHA256: hash(Buffer.from(data.text)), sourceSHA256: sourceHash, versionFollowsMtime: true });
   }
  }
  network.push(requests);
  await context.close();
 }
 const context = await browser.newContext();
 const page = await context.newPage();
 await page.goto(origin, { waitUntil: 'domcontentloaded' });
 const targets = await page.locator('a').evaluateAll(xs => xs.map(x => x.href).filter(x => /\/product\/|\/cart\/?$|\/checkout\/?$|\/my-account\/?$/.test(x)));
 const product = targets.find(x => x.includes('/product/'));
 assert(product);
 for (const [label, url] of [['product', product], ['cart', origin + '/cart/'], ['checkout', origin + '/checkout/'], ['account', origin + '/my-account/']]) {
  const r = await page.goto(url, { waitUntil: 'domcontentloaded' });
  routes.push({ label, status: r.status(), requestedPath: new URL(url).pathname, finalPath: new URL(page.url()).pathname, nativeWoo: await page.locator('.woocommerce, .woocommerce-page, .wp-block-woocommerce-cart').count() > 0 });
  assert.equal(r.status(), 200);
 }
 await context.close(); await browser.close();
 assert(network.every(x => x.nonGET === 0 && x.externalImage === 0 && !x.errors.length));
 assert(geometry.every(x => x.scrollWidth <= x.viewport));
 assert(geometry.find(x => x.label === 'intake' && x.viewport === 2048).contentWidth >= 1400);
 assert(geometry.find(x => x.label === 'home' && x.viewport === 2048).contentWidth >= 1500);
 fs.writeFileSync(path.join(output, 'frozen-boundary-proof.json'), JSON.stringify(frozen, null, 2));
 fs.writeFileSync(path.join(output, 'source-runtime-identity.json'), JSON.stringify({ baseline, identity, dockerContainerId: docker, running: true, runtimePath: backup.runtime, site: origin, cacheEnabled: true, cacheCleared: false, requestRoutingUsed: false, css, geometry, network, routes, screenshots, providerCalls: 0, modelCalls: 0, paymentActions: 0, checkoutSubmissions: 0 }, null, 2));
 console.log(JSON.stringify({ exactCandidate: true, cacheSafe: true, frozenLogic: true, routes, output }));
}
run().catch(e => { console.error(e.message); process.exit(1); });
