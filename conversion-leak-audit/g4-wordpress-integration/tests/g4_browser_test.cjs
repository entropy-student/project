const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require(process.env.CLA_PLAYWRIGHT_MODULE || 'playwright');

const BASE = process.env.CLA_WORDPRESS_BASE || 'http://127.0.0.1:8081/';
const DEMO_HOST = 'https://demo-store-golden-v1.example/';
const screenshotDir = path.resolve(process.env.CLA_G4_SCREENSHOT_DIR || path.resolve(__dirname, '..', '..', 'docs', 'evidence', 'g4-screenshots'));
const incompleteReasons = new Set(['RATE_LIMITED', 'BLOCKED', 'LOGIN_REQUIRED', 'JS_INCOMPLETE', 'GEO_CONTEXT_MISMATCH', 'SITE_UNAVAILABLE', 'UNKNOWN_FAILURE']);
fs.mkdirSync(screenshotDir, { recursive: true });

async function loadHome(page, fixture) {
  await page.goto(`${BASE}?fixture=${fixture}`, { waitUntil: 'domcontentloaded' });
  await page.locator('[data-cla-g4-app]').waitFor();
  await page.locator('#cla-g4-store-url').fill(`${DEMO_HOST}?fixture=${fixture}`);
}

async function submitFixture(page, fixture) {
  console.error(`FIXTURE_START ${fixture}`);
  const api = { status: [], report: 0, create: 0 };
  const requestHandler = (request) => {
    const url = request.url();
    if (request.method() === 'POST' && /\/scans$/.test(url)) api.create += 1;
    if (request.method() === 'GET' && /\/scans\/[0-9a-f]{32}$/.test(url)) api.status.push(url);
    if (request.method() === 'GET' && /\/report$/.test(url)) api.report += 1;
  };
  page.on('request', requestHandler);
  await loadHome(page, fixture);
  await page.locator('[data-cla-submit]').click();
  await page.locator('[data-cla-results]').waitFor({ state: 'visible', timeout: 15000 });
  await page.waitForTimeout(100);
  page.off('request', requestHandler);
  const scanId = new URL(page.url()).searchParams.get('scan_id');
  const reference = await page.locator('[data-cla-scan-reference]').last().textContent();
  const findingRules = await page.locator('.cla-g4-finding').evaluateAll((nodes) => nodes.map((node) => node.dataset.ruleId));
  const resultText = await page.locator('[data-cla-results]').innerText();
  assert.doesNotMatch(resultText, /\b(?:G[1-5](?:\.\d+)?|V1|Gate|frozen rules?)\b/i, `${fixture}: no internal project language in public results`);
  const analyticsEvents = await page.evaluate(() => window.claAnalyticsEvents || []);
  const phases = await page.evaluate(() => window.claProgressPhases || []);
  assert.equal(api.create, 1, `${fixture}: exactly one create request`);
  assert.ok(api.status.length >= 3, `${fixture}: bounded polling observed`);
  assert.equal(api.report, fixture === 'timeout' ? 0 : 1, `${fixture}: report request count`);
  assert.ok(scanId && /^[0-9a-f]{32}$/.test(scanId), `${fixture}: scan id in URL`);
  assert.match(reference, new RegExp(scanId), `${fixture}: scan id bound to result`);
  console.error(`FIXTURE_DONE ${fixture} statuses=${api.status.length} phases=${phases.join(',')} report=${api.report}`);
  return { api: {...api, phases}, scanId, findingRules, resultText, analyticsEvents };
}

async function captureProgress(page, fixture, filename) {
  await loadHome(page, fixture);
  await page.locator('[data-cla-submit]').click();
  await page.locator('[data-cla-progress]').waitFor({ state: 'visible', timeout: 5000 });
  await page.screenshot({ path: path.join(screenshotDir, filename) });
  await page.locator('[data-cla-results]').waitFor({ state: 'visible', timeout: 15000 });
}

function assertAnalyticsContract(events) {
  const byName = new Map(events.map((event) => [event.name, event]));
  const required = {
    landing_view: ['referrer_type', 'campaign_source', 'device_class', 'locale'],
    scan_started: ['site_id_hash', 'normalized_host_class', 'device_class', 'source_page'],
    scan_completed: ['site_id_hash', 'pages_checked', 'finding_count', 'top3_available', 'scan_duration_bucket'],
    top3_viewed: ['site_id_hash', 'top3_count', 'scan_duration_bucket'],
    issue_expanded: ['site_id_hash', 'rule_id', 'priority_rank', 'finding_type'],
  };
  Object.entries(required).forEach(([name, properties]) => {
    const event = byName.get(name);
    assert.ok(event, `analytics event ${name}`);
    properties.forEach((property) => assert.ok(event.properties[property] !== undefined, `${name}.${property}`));
  });
  events.forEach((event) => {
    const serialized = JSON.stringify(event.properties);
    assert.doesNotMatch(serialized, /demo-store-golden-v1\.example|https?:\/\//, `${event.name}: no full URL analytics property`);
    if (event.name === 'scan_incomplete') assert.ok(incompleteReasons.has(event.properties.reason), `public incomplete reason: ${event.properties.reason}`);
    assert.ok(!['checkout_started', 'payment_completed'].includes(event.name), 'payment analytics disabled in G4');
  });
  assert.match(String(byName.get('scan_started').properties.site_id_hash), /^[0-9a-f]{64}$/);
  assert.match(String(byName.get('scan_completed').properties.site_id_hash), /^[0-9a-f]{64}$/);
}

async function main() {
  const launchOptions = { headless: true };
  if (process.env.CLA_BROWSER_EXECUTABLE) launchOptions.executablePath = process.env.CLA_BROWSER_EXECUTABLE;
  const browser = await chromium.launch(launchOptions);
  const desktop = await browser.newPage({ viewport: { width: 1440, height: 900 }, deviceScaleFactor: 1 });
  desktop.on('console', (message) => console.error(`BROWSER_CONSOLE ${message.type()} ${message.text()}`));
  desktop.on('pageerror', (error) => console.error(`BROWSER_PAGEERROR ${error.message}`));
  desktop.on('requestfailed', (request) => console.error(`BROWSER_REQUEST_FAILED ${request.method()} ${request.url()} ${request.failure()?.errorText || ''}`));
  const results = {};

  await loadHome(desktop, 'demo');
  await desktop.screenshot({ path: path.join(screenshotDir, 'g4-desktop-landing.png') });
  assert.match(await desktop.locator('.cla-g4-hero h1').innerText(), /Find friction that may be making customers hesitate/);
  assert.equal(await desktop.locator('.cla-g4-finding').count(), 0, 'landing has no findings');
  await captureProgress(desktop, 'demo', 'g4-desktop-progress.png');

  for (const fixture of ['demo', 'zero', 'one', 'two', 'incomplete', 'blocked', 'rate-limited', 'timeout']) {
    results[fixture] = await submitFixture(desktop, fixture);
  }
  assert.deepEqual(results.demo.findingRules, ['CORE-007', 'PHYS-002', 'PHYS-001']);
  assert.deepEqual(results.zero.findingRules, []);
  assert.deepEqual(results.one.findingRules, ['CORE-007']);
  assert.deepEqual(results.two.findingRules, ['CORE-007', 'PHYS-002']);
  assert.ok(results.demo.api.phases.includes('PRIORITIZING'), 'backend PRIORITIZING phase mapped by UI');
  assert.ok(results.demo.api.phases.includes('COMPLETE'), 'complete phase observed');
  for (const fixture of ['incomplete', 'blocked', 'rate-limited', 'timeout']) {
    assert.deepEqual(results[fixture].findingRules, [], `${fixture}: incomplete/failed scan has no ISSUE cards`);
    assert.match(results[fixture].resultText, /SCAN INCOMPLETE|SCAN NOT STARTED/);
  }
  ['incomplete', 'blocked', 'rate-limited'].forEach((fixture) => {
    const incompleteEvent = results[fixture].analyticsEvents.find((event) => event.name === 'scan_incomplete');
    assert.ok(incompleteEvent, `${fixture}: scan_incomplete event`);
    assert.ok(incompleteReasons.has(incompleteEvent.properties.reason), `${fixture}: frozen reason enum`);
  });

  await loadHome(desktop, 'unavailable');
  await desktop.locator('[data-cla-submit]').click();
  await desktop.locator('[data-cla-results]').waitFor({ state: 'visible', timeout: 5000 });
  assert.match(await desktop.locator('[data-cla-results]').innerText(), /local Scanner is unavailable/i);
  results.unavailable = 'PASS_FAIL_CLOSED';

  const golden = await submitFixture(desktop, 'demo');
  await desktop.locator('[data-evidence-detail]').first().click();
  await desktop.locator('[data-evidence-detail]').first().evaluate((detail) => {
    if (!detail.open) detail.open = true;
    detail.dispatchEvent(new Event('toggle'));
  });
  await desktop.waitForTimeout(100);
  assertAnalyticsContract(await desktop.evaluate(() => window.claAnalyticsEvents || []));
  await desktop.locator('[data-evidence-detail]').evaluateAll((details) => details.forEach((detail) => {
    detail.open = true;
    detail.dispatchEvent(new Event('toggle'));
  }));
  const evidence = (await desktop.locator('[data-evidence-content]').allTextContents()).join('\n');
  assert.match(evidence, /demo-store-golden-v1\.example\/products\/example/);
  assert.match(evidence, /demo-store-golden-v1\.example\/cart/);
  assert.match(evidence, /demo-store-golden-v1\.example\/faq/);
  assert.match(evidence, /page:1/);
  const demoSummary = await desktop.locator('[data-cla-demo-summary]').innerText();
  assert.match(demoSummary, /3 confirmed findings/);
  assert.match(demoSummary, /17 trusted checks/);
  assert.match(demoSummary, /Synthetic Demo/);
  assert.doesNotMatch(evidence, /severity|uplift|root cause/i, 'result avoids unsupported claims');
  await desktop.screenshot({ path: path.join(screenshotDir, 'g4-desktop-demo-results.png') });
  await desktop.reload({ waitUntil: 'domcontentloaded' });
  await desktop.locator('[data-cla-results]').waitFor({ state: 'visible', timeout: 15000 });
  assert.equal(await desktop.locator('.cla-g4-finding').count(), 3, 'refresh_result_page preserves Golden Demo result');
  assert.match(await desktop.locator('[data-cla-scan-reference]').last().textContent(), new RegExp(golden.scanId));

  await loadHome(desktop, 'incomplete');
  await desktop.locator('[data-cla-submit]').click();
  await desktop.locator('[data-cla-results]').waitFor({ state: 'visible', timeout: 15000 });
  await desktop.screenshot({ path: path.join(screenshotDir, 'g4-desktop-incomplete.png') });

  let rejectedCreateCount = 0;
  const unsafeRequestHandler = (request) => {
    if (request.method() === 'POST' && /\/scans$/.test(request.url())) rejectedCreateCount += 1;
  };
  desktop.on('request', unsafeRequestHandler);
  await loadHome(desktop, 'demo');
  await desktop.locator('#cla-g4-store-url').fill('http://127.0.0.1:8080');
  await desktop.locator('[data-cla-submit]').click();
  await desktop.locator('[data-cla-field-message]').waitFor({ state: 'visible', timeout: 3000 });
  desktop.off('request', unsafeRequestHandler);
  assert.match(await desktop.locator('[data-cla-field-message]').innerText(), /public websites/i);
  assert.equal(rejectedCreateCount, 0, 'unsafe URL rejected before Scanner create');

  const mobile = await browser.newPage({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 1 });
  await loadHome(mobile, 'demo');
  await mobile.screenshot({ path: path.join(screenshotDir, 'g4-mobile-landing.png') });
  await captureProgress(mobile, 'demo', 'g4-mobile-progress.png');
  const mobileGolden = await submitFixture(mobile, 'demo');
  await mobile.screenshot({ path: path.join(screenshotDir, 'g4-mobile-demo-results.png') });
  assert.equal(mobileGolden.findingRules.length, 3, 'mobile_form_submit and Golden Demo Top 3');
  const overflow = await mobile.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth);
  assert.equal(overflow, false, 'mobile layout has no horizontal overflow');

  await browser.close();
  console.log(JSON.stringify({
    landing: 'PASS',
    progress_phases: results.demo.api.phases,
    demo: results.demo,
    zero: 'PASS_NO_FINDINGS',
    one: 'PASS_ONE_FINDING',
    two: 'PASS_TWO_FINDINGS',
    incomplete: 'PASS_NO_TOP3',
    blocked: 'PASS_NO_TOP3',
    rate_limited: 'PASS_NO_TOP3',
    timeout: 'PASS_TERMINATED',
    unsafe_url: 'PASS_FAIL_CLOSED',
    refresh_result_page: 'PASS',
    analytics_event_contract: 'PASS',
    real_prioritizing_state: 'PASS_FIXTURE_BACKEND_MAPPING',
    mobile_form_submit: 'PASS',
    golden_demo: 'PASS_FOUR_PAGE_FIXTURE',
    screenshots: fs.readdirSync(screenshotDir).sort(),
  }, null, 2));
}

main().catch((error) => {
  console.error(error.stack || error);
  process.exitCode = 1;
});
