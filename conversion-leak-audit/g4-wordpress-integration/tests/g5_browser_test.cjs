const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require(process.env.CLA_PLAYWRIGHT_MODULE || 'playwright');

const BASE = process.env.CLA_WORDPRESS_BASE || 'http://127.0.0.1:8085/';
const FIXTURE_URL = 'https://demo-store-golden-v1.example/';
const screenshotDir = process.env.CLA_G5_SCREENSHOT_DIR;
if (!screenshotDir) throw new Error('CLA_G5_SCREENSHOT_DIR must point to the local artifacts root.');
fs.mkdirSync(screenshotDir, { recursive: true });

const expectedQueue = [
  'CORE-007', 'PHYS-002', 'PHYS-001', 'CORE-001', 'CORE-002', 'CORE-003', 'CORE-004',
  'CORE-006', 'CORE-009', 'CORE-010', 'SUB-001', 'SUB-002', 'SUB-003', 'SUB-004', 'SUB-005'
];
let browser;

async function loadHome(page, fixture) {
  await page.goto(`${BASE}?fixture=${fixture}`, { waitUntil: 'domcontentloaded' });
  await page.locator('[data-cla-g4-app]').waitFor();
  await page.locator('#cla-g4-store-url').fill(`${FIXTURE_URL}?fixture=${fixture}`);
}

async function submitFixture(page, fixture) {
  await loadHome(page, fixture);
  await page.locator('[data-cla-submit]').click();
  await page.locator('[data-cla-results]').waitFor({ state: 'visible', timeout: 20000 });
  const scanId = new URL(page.url()).searchParams.get('scan_id');
  assert.match(String(scanId), /^[0-9a-f]{32}$/i, `${fixture}: scan id is present`);
  return scanId.toLowerCase();
}

function assertG5Analytics(events) {
  const of = (name) => events.filter((event) => event.name === name);
  const required = [
    ['full_report_viewed', ['site_id_hash', 'report_mode', 'access_state', 'queue_count']],
    ['full_issue_expanded', ['site_id_hash', 'rule_id', 'queue_position']],
    ['llm_explanation_requested', ['site_id_hash', 'rule_id', 'schema_version', 'queue_position']],
    ['llm_explanation_viewed', ['site_id_hash', 'rule_id', 'source']],
    ['llm_explanation_failed', ['site_id_hash', 'rule_id', 'reason']],
  ];
  required.forEach(([name, keys]) => {
    of(name).forEach((event) => keys.forEach((key) => assert.notEqual(event.properties[key], undefined, `${name}.${key}`)));
  });
  const viewed = of('full_report_viewed').at(-1);
  assert.equal(viewed.properties.report_mode, 'local_preview');
  assert.equal(viewed.properties.access_state, 'not_entitled');
  assert.match(viewed.properties.site_id_hash, /^[0-9a-f]{64}$/);
  const properties = JSON.stringify(events.map((event) => event.properties));
  assert.doesNotMatch(properties, /https?:\/\/|demo-store-golden-v1\.example|page:0|visible_price|raw_html|prompt|api[_-]?key/i);
  assert.ok(!events.some((event) => ['checkout_started', 'payment_completed'].includes(event.name)));
}

async function main() {
  const launchOptions = { headless: true };
  if (process.env.CLA_BROWSER_EXECUTABLE) launchOptions.executablePath = process.env.CLA_BROWSER_EXECUTABLE;
  browser = await chromium.launch(launchOptions);
  const desktop = await browser.newPage({ viewport: { width: 1440, height: 900 }, deviceScaleFactor: 1 });
  const requests = { explanation: 0, forbiddenExternal: new Set() };
  desktop.on('request', (request) => {
    if (/\/full-reports\/[0-9a-f]{32}\/issues\/[A-Z]+-\d{3}\/explanation(?:\?|$)/i.test(request.url())) requests.explanation += 1;
    const host = new URL(request.url()).hostname.toLowerCase();
    if (/(?:openai|anthropic|cohere|mistral|posthog|segment|mixpanel|amplitude|google-analytics|googletagmanager)/.test(host)) requests.forbiddenExternal.add(host);
  });

  for (const [fixture, count] of [['zero', 0], ['one', 1], ['two', 2], ['demo', 3]]) {
    await submitFixture(desktop, fixture);
    assert.equal(await desktop.locator('.cla-g4-finding').count(), count, `${fixture}: truthful Free Top 3 size`);
    assert.equal(requests.explanation, 0, `${fixture}: Free Top 3 makes no explanation request`);
  }

  const scanId = await submitFixture(desktop, 'many');
  assert.equal(await desktop.locator('.cla-g4-finding').count(), 3, 'Free Top 3 remains capped at three');
  assert.equal(requests.explanation, 0, 'opening a scan result does not request LLM explanation');
  await desktop.locator('[data-cla-open-full-report]').click();
  await desktop.locator('[data-g5-queue-item]').first().waitFor({ state: 'visible', timeout: 10000 });
  const initialQueue = await desktop.locator('[data-g5-queue-item]').evaluateAll((nodes) => nodes.map((node) => node.dataset.ruleId));
  assert.deepEqual(initialQueue, expectedQueue, 'all unique evidence-backed issues use frozen Top 3 then Scanner report order');
  assert.match(await desktop.locator('[data-cla-results]').innerText(), /not an impact score/i);
  assert.equal(new URL(desktop.url()).searchParams.get('scan_id'), scanId, 'queue remains bound to the original scan id');
  assert.equal(requests.explanation, 0, 'full queue display still does not call the explanation provider');
  await desktop.locator('.cla-g5-preview-notice').evaluate((node) => node.scrollIntoView({block: 'start'}));
  await desktop.screenshot({ path: path.join(screenshotDir, 'g5-full-queue-desktop-viewport.png'), animations: 'disabled' });
  await desktop.screenshot({ path: path.join(screenshotDir, 'g5-full-queue-desktop-full.png'), fullPage: true, animations: 'disabled' });

  await desktop.locator('[data-g5-issue-detail]').first().locator('summary').click();
  const evidenceText = await desktop.locator('[data-g5-queue-item]').first().innerText();
  for (const label of ['Source', 'Evidence references', 'Scanner decision', 'Limitation']) assert.ok(evidenceText.includes(label), `expanded evidence includes ${label}`);
  await desktop.locator('[data-g5-explain]').first().click();
  await desktop.locator('[data-g5-explanation]:not([hidden])').first().waitFor({ state: 'visible', timeout: 8000 });
  assert.match(await desktop.locator('[data-g5-explanation]').first().innerText(), /Deterministic fake-provider explanation/);
  assert.equal(requests.explanation, 1, 'only the explicit explanation action invokes the fake provider route');
  await desktop.screenshot({ path: path.join(screenshotDir, 'g5-explanation-desktop.png'), fullPage: true, animations: 'disabled' });
  assertG5Analytics(await desktop.evaluate(() => window.claAnalyticsEvents || []));
  const events = await desktop.evaluate(() => window.claAnalyticsEvents || []);
  assert.ok(events.some((event) => event.name === 'full_issue_expanded'));
  assert.ok(events.some((event) => event.name === 'llm_explanation_requested'));
  assert.ok(events.some((event) => event.name === 'llm_explanation_viewed' && event.properties.source === 'deterministic_fake'));
  assert.deepEqual([...requests.forbiddenExternal], [], 'no external LLM or analytics provider endpoint was contacted');

  await desktop.reload({ waitUntil: 'domcontentloaded' });
  await desktop.locator('[data-g5-queue-item]').first().waitFor({ state: 'visible', timeout: 15000 });
  assert.deepEqual(await desktop.locator('[data-g5-queue-item]').evaluateAll((nodes) => nodes.map((node) => node.dataset.ruleId)), expectedQueue, 'refresh restores the same scan-bound queue');

  const mobile = await browser.newPage({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 1 });
  const mobileScanId = await submitFixture(mobile, 'many');
  await mobile.locator('[data-cla-open-full-report]').click();
  await mobile.locator('[data-g5-queue-item]').first().waitFor({ state: 'visible' });
  assert.equal(new URL(mobile.url()).searchParams.get('scan_id'), mobileScanId);
  assert.deepEqual(await mobile.locator('[data-g5-queue-item]').evaluateAll((nodes) => nodes.map((node) => node.dataset.ruleId)), expectedQueue);
  assert.equal(await mobile.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth), false, 'mobile full queue has no horizontal overflow');
  await mobile.screenshot({ path: path.join(screenshotDir, 'g5-full-queue-mobile.png'), fullPage: true, animations: 'disabled' });
  await mobile.locator('[data-g5-issue-detail]').first().locator('summary').click();
  await mobile.locator('[data-g5-explain]').first().click();
  await mobile.locator('[data-g5-explanation]:not([hidden])').first().waitFor({ state: 'visible', timeout: 8000 });
  await mobile.screenshot({ path: path.join(screenshotDir, 'g5-explanation-mobile.png'), fullPage: true, animations: 'disabled' });
  await mobile.route('**/issues/**/explanation', (route) => route.fulfill({
    status: 200,
    contentType: 'application/json',
    body: JSON.stringify({
      status: 'fallback', reason: 'provider_unavailable', provider: 'deterministic_fallback',
      explanation: {
        summary: 'The Scanner observed: the explanation provider is unavailable.',
        why_it_may_matter: 'Review the cited public-page observation in context.',
        recommended_next_step: 'Review the cited public evidence and verify the relevant purchase path.',
        caveat: 'This public-page observation is not proof of revenue loss or causal conversion impact.'
      }
    })
  }));
  await mobile.locator('[data-g5-explain]').nth(1).click();
  await mobile.locator('[data-g5-explanation]:not([hidden])').nth(1).waitFor({ state: 'visible', timeout: 8000 });
  assert.match(await mobile.locator('[data-g5-explanation]').nth(1).innerText(), /Deterministic fallback/);
  assertG5Analytics(await mobile.evaluate(() => window.claAnalyticsEvents || []));
  const fallbackEvents = await mobile.evaluate(() => window.claAnalyticsEvents || []);
  assert.ok(fallbackEvents.some((event) => event.name === 'llm_explanation_failed' && event.properties.reason === 'provider_unavailable'));
  assert.ok(fallbackEvents.some((event) => event.name === 'llm_explanation_viewed' && event.properties.source === 'deterministic_fallback'));

  const incompleteId = await submitFixture(desktop, 'incomplete');
  assert.match(await desktop.locator('[data-cla-results]').innerText(), /SCAN INCOMPLETE|No Top 3/i);
  await desktop.goto(`${BASE}?scan_id=${incompleteId}&cla_g5_full_report=1`, { waitUntil: 'domcontentloaded' });
  await desktop.locator('.cla-g4-incomplete').waitFor({ state: 'visible', timeout: 15000 });
  assert.match(await desktop.locator('[data-cla-results]').innerText(), /SCAN INCOMPLETE|No Top 3/i, 'incomplete report remains visibly incomplete');
  assert.equal(await desktop.locator('[data-g5-queue-item]').count(), 0, 'incomplete result is never promoted into a queue');
  await desktop.screenshot({ path: path.join(screenshotDir, 'g5-incomplete-desktop.png'), fullPage: true, animations: 'disabled' });
  const incompleteMobile = await browser.newPage({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 1 });
  await incompleteMobile.goto(`${BASE}?scan_id=${incompleteId}&cla_g5_full_report=1`, { waitUntil: 'domcontentloaded' });
  await incompleteMobile.locator('.cla-g4-incomplete').waitFor({ state: 'visible', timeout: 15000 });
  await incompleteMobile.screenshot({ path: path.join(screenshotDir, 'g5-incomplete-mobile.png'), fullPage: true, animations: 'disabled' });

  let invalidApiRequests = 0;
  const invalidPage = await browser.newPage({ viewport: { width: 1440, height: 900 }, deviceScaleFactor: 1 });
  invalidPage.on('request', (request) => { if (/\/wp-json\/cla\/v1\/(?:scans|full-reports)/.test(request.url())) invalidApiRequests += 1; });
  await invalidPage.goto(`${BASE}?scan_id=bad&cla_g5_full_report=1`, { waitUntil: 'domcontentloaded' });
  await invalidPage.locator('.cla-g4-incomplete.is-error').waitFor({ state: 'visible' });
  assert.equal(invalidApiRequests, 0, 'invalid or missing scan id fails closed before API access');

  const mismatchPage = await browser.newPage({ viewport: { width: 1440, height: 900 }, deviceScaleFactor: 1 });
  await mismatchPage.route('**/full-reports/**', async (route) => {
    if (route.request().method() === 'GET') {
      await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({
        scan_id: 'ffffffffffffffffffffffffffffffff', status: 'SUCCEEDED',
        report: { scan_id: 'ffffffffffffffffffffffffffffffff', requested_url: FIXTURE_URL, pages: [], decisions: [] }, fix_queue: []
      }) });
      return;
    }
    await route.continue();
  });
  await mismatchPage.goto(`${BASE}?scan_id=${scanId}&cla_g5_full_report=1`, { waitUntil: 'domcontentloaded' });
  await mismatchPage.locator('.cla-g4-incomplete.is-error').waitFor({ state: 'visible', timeout: 15000 });
  assert.equal(await mismatchPage.locator('[data-g5-queue-item]').count(), 0, 'mismatched scan report fails closed');

  await browser.close();
  console.log(JSON.stringify({
    full_queue: `PASS_${expectedQueue.length}_UNIQUE_ISSUES`,
    queue_order: 'PASS_TOP3_THEN_SCANNER_REPORT_ORDER_NO_SCORE',
    free_top3_llm_calls: 0,
    zero_one_two_three: 'PASS_NO_PADDING',
    evidence_traceability: 'PASS',
    refresh_binding: 'PASS',
    incomplete: 'PASS_FAIL_CLOSED',
    invalid_scan_id: 'PASS_FAIL_CLOSED',
    cross_scan_binding: 'PASS_FAIL_CLOSED',
    fake_provider: 'PASS_EXPLICIT_ON_DEMAND',
    analytics: 'PASS',
    mobile_overflow: 'PASS_NONE',
    screenshots: fs.readdirSync(screenshotDir).sort(),
  }, null, 2));
}

main().catch(async (error) => {
  console.error(error.stack || error);
  if (browser) await browser.close();
  process.exitCode = 1;
});
