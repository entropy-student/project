const assert = require('node:assert/strict');
const { chromium } = require('playwright');

const BASE = process.env.CLA_WORDPRESS_BASE || 'http://127.0.0.1:8081/';
const TARGET = process.env.CLA_REAL_CANARY_URL || 'http://1.1.1.1/';

async function main() {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 }, deviceScaleFactor: 1 });
  const api = { creates: [], statuses: [], reports: [] };
  const responseHandler = async (response) => {
    const url = response.url();
    try {
      const method = response.request().method();
      if (method === 'POST' && /\/scans$/.test(url)) api.creates.push(await response.json());
      if (method === 'GET' && /\/scans\/[0-9a-f]{32}$/.test(url)) api.statuses.push(await response.json());
      if (method === 'GET' && /\/report$/.test(url)) api.reports.push(await response.json());
    } catch (error) {
      // The browser can close a response after the UI has already moved on.
    }
  };
  page.on('response', responseHandler);

  await page.goto(`${BASE}?real_canary=1`, { waitUntil: 'networkidle' });
  await page.locator('[data-cla-g4-app]').waitFor();
  await page.locator('#cla-g4-store-url').fill(TARGET);
  await page.locator('[data-cla-submit]').click();
  await page.locator('[data-cla-results]').waitFor({ state: 'visible', timeout: 75000 });
  await page.waitForTimeout(250);
  page.off('response', responseHandler);

  const scanId = new URL(page.url()).searchParams.get('scan_id');
  assert.equal(api.creates.length, 1, 'real Scanner create request through WordPress');
  assert.ok(scanId && /^[0-9a-f]{32}$/.test(scanId), 'real scan_id is bound to result URL');
  assert.equal(api.creates[0].id, scanId, 'WordPress preserves real Scanner scan_id');
  assert.ok(api.statuses.length >= 1, 'real Scanner polling observed');
  const terminal = api.statuses.find((job) => ['SUCCEEDED', 'AUDIT_INCOMPLETE', 'FAILED', 'CANCELLED'].includes(job.status));
  assert.ok(terminal, 'real Scanner terminal state observed');
  assert.ok(['SUCCEEDED', 'AUDIT_INCOMPLETE'].includes(terminal.status), `safe public canary did not fail: ${terminal.status}`);
  assert.ok(api.reports.length >= 1, 'terminal real Scanner report retrieval observed');
  const report = api.reports[api.reports.length - 1];
  assert.equal(report.requested_url, TARGET, 'report requested_url matches canary target');
  assert.ok(Array.isArray(report.pages), 'real report pages schema compatible');
  assert.ok(Array.isArray(report.decisions), 'real report decisions schema compatible');
  assert.equal(report.decisions.filter((decision) => decision.result === 'ISSUE' && (!Array.isArray(decision.fact_refs) || decision.fact_refs.length === 0)).length, 0, 'real report has no evidence-less ISSUE');
  assert.ok(await page.locator('[data-cla-scan-reference]').last().textContent().then((value) => value.includes(scanId)), 'result displays the real scan_id');

  await browser.close();
  console.log(JSON.stringify({
    real_scanner_canary: 'PASS',
    target: TARGET,
    scan_id: scanId,
    terminal_state: terminal.status,
    status_phases: api.statuses.map((job) => job.phase).filter(Boolean),
    report_pages: report.pages.length,
    evidence_less_issue: 0,
  }, null, 2));
}

main().catch((error) => {
  console.error(error.stack || error);
  process.exitCode = 1;
});
