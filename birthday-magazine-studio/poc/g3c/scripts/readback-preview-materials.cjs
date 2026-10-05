// Read-only/local-browser visual evidence. Never clicks the Woo checkout handoff.
const { chromium } = require('playwright');
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const project = path.resolve(__dirname, '../../..');
const phase = process.argv[2];
if (!['before', 'after', 'confirm', 'scale-final', 'edge-final'].includes(phase)) throw Error('Use a named evidence phase');
const output = path.join(project, 'docs/evidence/g3cr7v2r4-preview-materials', phase);
fs.mkdirSync(output, { recursive: true });
const origin = 'http://127.0.0.1:8189';
const cover = path.join(project, 'poc/g3c/preview-plugin/assets/g3cr6r3d2r2/preview-memories-panel.png');
const photos = Array.from({ length: 12 }, (_, i) => path.join(project, 'poc/g2b/fixtures/photos', `photo-${String(i + 1).padStart(2, '0')}.png`));
const answers = [
 'Taylor remembers the small details and makes our weekend walks feel special.',
 'We spent a rainy afternoon making a birthday scrapbook at the kitchen table.',
 'I admire how Taylor listens and makes time for friends.',
 'Our inside joke is calling the kitchen table the creative department.',
 'Taylor is keeping a notebook of everyday moments this year.',
 'I want Taylor to know how much their friendship means to me.'
];
const geometry = [], checks = [], screenshots = [], network = [];
function hash(file) { return crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex'); }
async function snapshot(page, name, selector, width) {
 const target = selector ? page.locator(selector) : page;
 const file = name + '-' + width + '.png';
 await target.screenshot({ path: path.join(output, file), animations: 'disabled', ...(!selector && { fullPage: true }) });
 screenshots.push({ file, bytes: fs.statSync(path.join(output, file)).size, sha256: hash(path.join(output, file)) });
 geometry.push(await page.evaluate(({ name, width, selector }) => {
  const e = document.querySelector(selector || (name.startsWith('home') ? '.entry-content' : '.bms-g3cr7')), rect = e.getBoundingClientRect();
  const sels = name.startsWith('home') ? ['.bms-dark-panel .bms-heading', '.bms-preview-controls', '.bms-preview-stage', '.bms-preview-cover', '.bms-preview-spread', '.bms-coral-link', '.bms-cover-art', '.bms-spread-art'] : ['.bms-g3cr7-intro h1', '.bms-g3cr7-card', '[data-step]:not([hidden])', '[data-step]:not([hidden]) h2', '[data-step]:not([hidden]) .bms-g3cr7-step-body', '[data-step]:not([hidden]) input', '.bms-g3cr7-photo-grid', '.bms-g3cr7-nav'];
  const elements = sels.map(sel => {
   const x = e.querySelector(sel); if (!x) return { selector: sel, absent: true };
   const b = x.getBoundingClientRect(), s = getComputedStyle(x);
   return { selector: sel, width: b.width, height: b.height, x: b.x, y: b.y + scrollY, font: s.fontSize, weight: s.fontWeight, padding: s.padding, grid: s.gridTemplateColumns, background: s.backgroundColor, backgroundImage: s.backgroundImage, text: sel.includes('coral-link') ? x.textContent.trim() : undefined };
  });
  const brokenImages = [...e.querySelectorAll('img')].filter(x => x.getClientRects().length && !x.hidden && (!x.complete || x.naturalWidth === 0)).length;
  return { name, viewport: width, devicePixelRatio, scrollWidth: document.documentElement.scrollWidth, overflow: document.documentElement.scrollWidth > innerWidth, surfaceWidth: rect.width, elements, brokenImages };
 }, { name, width, selector }));
}
async function run() {
 const browser = await chromium.launch({ headless: true, executablePath: process.env.BMS_EDGE_PATH || 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe' });
 for (const width of [2048, 1440, 375]) {
  const context = await browser.newContext({ viewport: { width, height: width === 375 ? 812 : 1152 }, deviceScaleFactor: 1, reducedMotion: 'reduce' });
  const requests = { width, nonGetAttempts: 0, externalImageRequests: 0, failedResources: [], pageErrors: [] };
  await context.route('**/*', async route => {
   const request = route.request();
   if (!['GET', 'HEAD'].includes(request.method())) { requests.nonGetAttempts++; return route.abort(); }
   if (request.resourceType() === 'image' && /^https?:/.test(request.url()) && new URL(request.url()).origin !== origin) requests.externalImageRequests++;
   return route.continue();
  });
  const page = await context.newPage();
  page.on('pageerror', e => requests.pageErrors.push(e.message));
  page.on('requestfailed', r => requests.failedResources.push({ type: r.resourceType(), origin: /^https?:/.test(r.url()) ? new URL(r.url()).origin : 'local-object', error: r.failure()?.errorText }));
  await page.goto(origin, { waitUntil: 'domcontentloaded' });
  await page.locator('#preview').scrollIntoViewIfNeeded();
  await page.waitForTimeout(700);
  await page.evaluate(()=>document.fonts.ready);
  await snapshot(page, 'home-empty', '#preview', width);
  await snapshot(page, 'home-how', '#how-it-works', width);
  const empty = await page.locator('[data-bms-art]').evaluate(x => ({ text: x.textContent.trim(), backgroundImage: getComputedStyle(x).backgroundImage }));
  await page.locator('[data-bms-input="name"]').fill('Taylor');
  await page.locator('[data-bms-input="age"]').fill('30');
  assert.equal(await page.locator('[data-bms-name]').textContent(), 'Taylor');
  const requestCountBeforePhoto = requests.externalImageRequests;
  await page.locator('[data-bms-file]').setInputFiles(cover);
  await page.waitForFunction(() => document.querySelector('[data-bms-preview]').dataset.hasPhoto === 'true');
  const blob = await page.locator('[data-bms-image]').first().getAttribute('src');
  assert(blob.startsWith('blob:'));
  await snapshot(page, 'home-photo', '#preview', width);
  const presets=[];
  for(const mood of ['editorial','retro','romantic']){await page.locator('#bms-style').selectOption(mood);assert.equal(await page.locator('[data-bms-preview]').getAttribute('data-style'),mood);presets.push(await page.locator('.bms-cover-masthead').evaluate(x=>({font:getComputedStyle(x).fontFamily,weight:getComputedStyle(x).fontWeight})));if(width===1440||width===375)await snapshot(page,'style-'+mood,'#preview',width);if(phase!=='before')assert(await page.locator('.bms-preview-sheet').first().evaluate(x=>x.scrollHeight<=x.clientHeight),'Story page content outside paper');}
  if(phase!=='before')assert.equal(new Set(presets.map(x=>x.font)).size,3);
  const overlap = await page.evaluate(() => {
   const pairs = [['.bms-cover-photo-frame', '.bms-cover-headlines'], ['.bms-spread-photo-frame', '.bms-photo-copy']];
   // Compare layout coordinates: rotated AABBs overlap at adjoining edges even
   // when the actual image and copy frames are disjoint in their shared page.
   return pairs.some(([a, b]) => { const x = document.querySelector(a), y = document.querySelector(b); if (x.offsetParent !== y.offsetParent) throw Error('Different image/copy coordinate roots'); return Math.min(x.offsetLeft + x.offsetWidth, y.offsetLeft + y.offsetWidth) - Math.max(x.offsetLeft, y.offsetLeft) > 1 && Math.min(x.offsetTop + x.offsetHeight, y.offsetTop + y.offsetHeight) - Math.max(x.offsetTop, y.offsetTop) > 1; });
  });
  const paperSafeFrame=await page.evaluate(()=>{const p=document.querySelector('.bms-preview-spread'),s=document.querySelector('.bms-photo-sheet'),f=document.querySelector('.bms-spread-photo-frame');return{left:(s.offsetLeft+f.offsetLeft)/p.offsetWidth,right:(s.offsetLeft+f.offsetLeft+f.offsetWidth)/p.offsetWidth,top:f.offsetTop/p.offsetHeight,bottom:(f.offsetTop+f.offsetHeight)/p.offsetHeight};});
  if(phase==='edge-final'){assert(paperSafeFrame.left>=.54&&paperSafeFrame.right<=.916&&paperSafeFrame.top>=.11&&paperSafeFrame.bottom<=.66,'Photo frame must stay inside front-paper safe region');}
  const cta = await page.locator('.bms-coral-link').evaluate(x => ({ text: x.textContent.trim(), path: new URL(x.href).pathname, metadataOutside: !!x.parentElement.querySelector('p') }));
  await page.locator('[data-bms-remove]').click();
  assert.equal(await page.locator('[data-bms-image]').first().getAttribute('src'), null);
  await page.locator('[data-bms-file]').setInputFiles(cover);
  await page.waitForFunction(() => document.querySelector('[data-bms-preview]').dataset.hasPhoto === 'true');
  await page.locator('[data-bms-remove]').click();
  const privacy = { blob: true, replaceRemove: true, nonGetAttempts: requests.nonGetAttempts, externalImageDelta: requests.externalImageRequests - requestCountBeforePhoto };
  if(width===1440)await snapshot(page,'homepage-full',null,width);
  await page.goto(origin + '/make-your-magazine/', { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(350);
  await snapshot(page, 'intake-about', '.bms-g3cr7', width);
  await page.locator('[name="recipient_name"]').fill('Taylor');
  await page.locator('[name="age"]').fill('30');
  await page.locator('[name="relationship"]').selectOption('Friend');
  await page.locator('[name="tone"]').selectOption('heartfelt');
  await page.locator('[data-next]').click();
  await page.locator('[data-back]').click();
  assert.equal(await page.locator('[name="recipient_name"]').inputValue(), 'Taylor');
  await page.locator('[data-next]').click();
  await page.locator('[data-next]').click();
  assert.equal(await page.locator('[data-step="1"]').getAttribute('hidden'), null);
  await page.locator('#bms-g3cr7-files').setInputFiles(photos);
  for (let i = 0; i < 3; i++) await page.locator('[data-photo-grid] input[type="checkbox"]').nth(i).check();
  assert.equal(await page.locator('[data-photo-count]').textContent(), '12');
  assert.equal(await page.locator('[data-must-count]').textContent(), '3');
  assert(await page.locator('[data-photo-grid] input[type="checkbox"]').nth(3).isDisabled());
  await snapshot(page, 'intake-photos', '.bms-g3cr7', width);
  await page.locator('[data-next]').click();
  for (let i = 0; i < 3; i++) await page.locator('[name="q' + (i + 1) + '"]').fill(answers[i]);
  await snapshot(page, 'intake-story', '.bms-g3cr7', width);
  await page.locator('[data-next]').click();
  for (let i = 3; i < 6; i++) await page.locator('[name="q' + (i + 1) + '"]').fill(answers[i]);
  await snapshot(page, 'intake-little', '.bms-g3cr7', width);
  await page.locator('[data-next]').click();
  await snapshot(page, 'intake-review', '.bms-g3cr7', width);
  assert.equal(await page.locator('[data-review-answers] > div').count(), 6);
  assert(await page.locator('[data-checkout]').isVisible());
  const native = await page.locator('[data-bms-g3cr7]').evaluate(x => ({ product: x.dataset.productId, checkoutPath: new URL(x.dataset.checkoutUrl, location.origin).pathname, addEndpoint: new URL(x.dataset.addUrl, location.origin).searchParams.get('wc-ajax') }));
  const styles = await page.evaluate(() => [...document.querySelectorAll('link[rel="stylesheet"]')].map(x => x.href).filter(x => /magazine-preview|frontend-reproduction/.test(x)));
  checks.push({ width, empty, privacy, photoTextOverlap: overlap, paperSafeFrame, cta, native, styles, nextBack: true, minimumPhotosGuard: true, styleProfiles:presets, twelvePhotos: true, threeMustUseLimit: true, sixAnswers: true, checkoutNotClicked: true });
  network.push(requests);
  await context.close();
 }
 if(phase!=='before')for(const width of [1440,375]){const context=await browser.newContext({javaScriptEnabled:false,viewport:{width,height:1000}});const page=await context.newPage();await page.goto(origin,{waitUntil:'load'});await snapshot(page,'home-no-js','#preview',width);await context.close();}
 await browser.close();
 fs.writeFileSync(path.join(output, 'geometry.json'), JSON.stringify(geometry, null, 2));
 fs.writeFileSync(path.join(output, 'checks.json'), JSON.stringify({ phase, checks, network, screenshots, modelCalls: 0, checkoutSubmissions: 0, paymentActions: 0 }, null, 2));
 if (phase !== 'before') { assert(geometry.every(x => !x.overflow && x.brokenImages === 0)); assert(network.every(x => x.nonGetAttempts === 0 && x.externalImageRequests === 0 && x.pageErrors.length === 0)); for (const check of checks) { assert.equal(check.empty.text, ''); assert.equal(check.empty.backgroundImage, 'none'); assert.equal(check.photoTextOverlap, false); assert(!/39\.99|12 pages/i.test(check.cta.text)); assert.equal(check.cta.path, '/make-your-magazine/'); } }
 console.log(JSON.stringify({ phase, screenshotCount: screenshots.length, overflow: geometry.filter(x => x.overflow).map(x => x.name + '-' + x.viewport), output }));
}
run().catch(e => { console.error(e.message); process.exit(1); });
