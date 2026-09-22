const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright');

const BASE = process.env.CLA_WORDPRESS_BASE || 'http://127.0.0.1:8081/';
const DEMO_HOST = 'https://demo-store-golden-v1.example/';
const screenshotDir = path.resolve(__dirname, '..', '..', 'docs', 'evidence', 'g4-screenshots');
fs.mkdirSync(screenshotDir, { recursive: true });

async function loadHome(page, fixture) {
  await page.goto(`${BASE}?fixture=${fixture}`, { waitUntil: 'networkidle' });
  await page.locator('[data-cla-g4-app]').waitFor();
  await page.locator('#cla-g4-store-url').fill(`${DEMO_HOST}?fixture=${fixture}`);
}

async function submitFixture(page, fixture) {
  console.error(`FIXTURE_START ${fixture}`);
  const api = { status: [], report: 0, create: 0 };
  page.on('request', (request) => {
    const url = request.url();
    if (request.method() === 'POST' && /\/scans$/.test(url)) api.create += 1;
    if (request.method() === 'GET' && /\/scans\/[0-9a-f]{32}$/.test(url)) api.status.push(url);
    if (request.method() === 'GET' && /\/report$/.test(url)) api.report += 1;
  });
  await loadHome(page, fixture);
  await page.locator('[data-cla-submit]').click();
  await page.locator('[data-cla-results]').waitFor({ state: 'visible', timeout: 15000 });
  const scanId = new URL(page.url()).searchParams.get('scan_id');
  const reference = await page.locator('[data-cla-scan-reference]').last().textContent();
  const findingRules = await page.locator('.cla-g4-finding').evaluateAll((nodes) => nodes.map((node) => node.dataset.ruleId));
  const resultText = await page.locator('[data-cla-results]').innerText();
  assert.equal(api.create, 1, `${fixture}: exactly one create request`);
  assert.ok(api.status.length >= 3, `${fixture}: bounded polling observed`);
  assert.equal(api.report, fixture === 'timeout' ? 0 : 1, `${fixture}: report request count`);
  assert.ok(scanId && /^[0-9a-f]{32}$/.test(scanId), `${fixture}: scan id in URL`);
  assert.match(reference, new RegExp(scanId), `${fixture}: scan id bound to result`);
  console.error(`FIXTURE_DONE ${fixture} statuses=${api.status.length} report=${api.report}`);
  return { api, scanId, findingRules, resultText };
}

async function main() {
  const browser = await chromium.launch({ headless: true });
  const desktop = await browser.newPage({ viewport: { width: 1440, height: 900 }, deviceScaleFactor: 1 });
  desktop.on('console', (message) => console.error(`BROWSER_CONSOLE ${message.type()} ${message.text()}`));
  desktop.on('pageerror', (error) => console.error(`BROWSER_PAGEERROR ${error.message}`));
  desktop.on('requestfailed', (request) => console.error(`BROWSER_REQUEST_FAILED ${request.method()} ${request.url()} ${request.failure()?.errorText || ''}`));
  const results = {};

  await loadHome(desktop, 'demo');
  await desktop.screenshot({ path: path.join(screenshotDir, 'g4-desktop-landing.png') });
  assert.match(await desktop.locator('.cla-g4-hero h1').innerText(), /Find friction that may be making customers hesitate/);
  assert.equal(await desktop.locator('.cla-g4-finding').count(), 0, 'landing has no findings');

  for (const fixture of ['demo', 'zero', 'one', 'two', 'incomplete', 'blocked', 'rate-limited', 'timeout']) {
    results[fixture] = await submitFixture(desktop, fixture);
  }
  assert.deepEqual(results.demo.findingRules, ['CORE-007', 'PHYS-002', 'PHYS-001']);
  assert.deepEqual(results.zero.findingRules, []);
  assert.deepEqual(results.one.findingRules, ['CORE-007']);
  assert.deepEqual(results.two.findingRules, ['CORE-007', 'PHYS-002']);
  for (const fixture of ['incomplete', 'blocked', 'rate-limited', 'timeout']) {
    assert.deepEqual(results[fixture].findingRules, [], `${fixture}: incomplete/failed scan has no ISSUE cards`);
    assert.match(results[fixture].resultText, /SCAN INCOMPLETE|SCAN NOT STARTED/);
  }

  await loadHome(desktop, 'unavailable');
  await desktop.locator('[data-cla-submit]').click();
  await desktop.locator('[data-cla-results]').waitFor({ state: 'visible', timeout: 5000 });
  assert.match(await desktop.locator('[data-cla-results]').innerText(), /local Scanner is unavailable/i);
  results.unavailable = 'PASS_FAIL_CLOSED';
  assert.doesNotMatch(results.demo.resultText, /severity|uplift|root cause/i, 'result avoids unsupported claims');

  await loadHome(desktop, 'demo');
  await desktop.locator('[data-cla-submit]').click();
  await desktop.locator('[data-cla-results]').waitFor({ state: 'visible', timeout: 15000 });
  await desktop.locator('[data-evidence-detail]').first().click();
  const evidence = await desktop.locator('[data-cla-results]').innerText();
  assert.match(evidence, /demo-store-golden-v1\.example\/products\/demo/);
  assert.match(evidence, /page:0/);
  await desktop.screenshot({ path: path.join(screenshotDir, 'g4-desktop-demo-results.png') });

  let rejectedCreateCount = 0;
  desktop.on('request', (request) => {
    if (request.method() === 'POST' && /\/scans$/.test(request.url())) rejectedCreateCount += 1;
  });
  await loadHome(desktop, 'demo');
  await desktop.locator('#cla-g4-store-url').fill('http://127.0.0.1:8080');
  await desktop.locator('[data-cla-submit]').click();
  await assert.doesNotReject(async () => desktop.locator('[data-cla-field-message]').waitFor({ state: 'visible', timeout: 3000 }));
  assert.match(await desktop.locator('[data-cla-field-message]').innerText(), /public websites/i);
  assert.equal(rejectedCreateCount, 0, 'unsafe URL rejected before Scanner create');

  const mobile = await browser.newPage({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 1 });
  await submitFixture(mobile, 'two');
  await mobile.screenshot({ path: path.join(screenshotDir, 'g4-mobile-two-results.png') });
  const overflow = await mobile.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth);
  assert.equal(overflow, false, 'mobile layout has no horizontal overflow');

  await browser.close();
  console.log(JSON.stringify({
    landing: 'PASS',
    demo: results.demo,
    zero: results.zero,
    one: results.one,
    two: results.two,
    incomplete: 'PASS_NO_TOP3',
    blocked: 'PASS_NO_TOP3',
    rate_limited: 'PASS_NO_TOP3',
    timeout: 'PASS_TERMINATED',
    unsafe_url: 'PASS_FAIL_CLOSED',
    evidence_traceability: 'PASS',
    screenshots: fs.readdirSync(screenshotDir),
  }, null, 2));
}

main().catch((error) => {
  console.error(error.stack || error);
  process.exitCode = 1;
});
