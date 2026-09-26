import { chromium } from 'playwright';
import { readFile, mkdir } from 'node:fs/promises';
import { resolve, dirname } from 'node:path';
import assert from 'node:assert/strict';

const base = process.env.FCS_WP_BASE_URL;
const idsPath = resolve(process.env.FCS_WP_IDS);
const imagePath = resolve(process.env.FCS_SYNTHETIC_IMAGE);
const outPath = resolve(process.env.G2A1_R2_ARTIFACT_DIR, 'wp', 'wp-test-summary.json');
const ids = JSON.parse(await readFile(idsPath, 'utf8'));
const requests = [];
const browser = await chromium.launch({ headless: true, executablePath: process.env.CHROME_PATH, args: ['--no-sandbox'] });
const result = {
  status: 'RUNNING',
  environment: 'localhost ephemeral GitHub Actions container network',
  versions: { wordpress: ids.wordpress_version, woocommerce: ids.woocommerce_version, mariadb: ids.mariadb_version, kadence: ids.kadence_version },
  browser: { chromium: browser.version(), playwright: '1.55.0' },
  dummy_orders: { order_a_id: ids.order_a_id, order_b_id: ids.order_b_id },
  preview: {},
  upload: {},
  delivery: {},
  cleanup: 'compose down -v scheduled by workflow',
};
const track = page => page.on('request', req => {
  const url = req.url();
  if (/^https?:\/\//i.test(url)) requests.push({ method: req.method(), url });
});
async function login(context, username, password) {
  const page = await context.newPage();
  track(page);
  await page.goto(base + '/wp-login.php', { waitUntil: 'domcontentloaded' });
  await page.locator('#user_login').fill(username);
  await page.locator('#user_pass').fill(password);
  await page.locator('#wp-submit').click();
  await page.waitForLoadState('domcontentloaded');
  if (page.url().includes('wp-login.php')) throw new Error('Dummy user login failed');
  return page;
}
async function callOnPage(page, path, method = 'GET', image = null, extraHeaders = {}) {
  return page.evaluate(async ({ path, method, extraHeaders }) => {
    const headers = { 'X-WP-Nonce': window.FCSProof.nonce, ...extraHeaders };
    let body;
    if (method === 'POST') {
      body = new FormData();
      const input = document.querySelector('#fcs-file');
      body.set('file', input.files[0]);
    }
    const response = await fetch(window.FCSProof.restBase + path, { method, headers, body });
    return { status: response.status, body: await response.json() };
  }, { path, method, extraHeaders });
}

const anonymous = await browser.newContext({ viewport: { width: 1280, height: 800 } });
try {
  const anonPage = await anonymous.newPage();
  track(anonPage);
  const anonymousUpload = await fetch(base + '/wp-json/family-cookbook/v1/orders/' + ids.order_a_id + '/uploads', { method: 'POST' });
  const anonymousDelivery = await fetch(base + '/wp-json/family-cookbook/v1/orders/' + ids.order_a_id + '/files/' + ids.delivery_file_id);
  result.upload.anonymous_status = anonymousUpload.status;
  result.delivery.anonymous_status = anonymousDelivery.status;
  result.preview.url = ids.preview_url;
  const previewPage = anonPage;
  await previewPage.goto(ids.preview_url, { waitUntil: 'networkidle' });
  const iframe = previewPage.frameLocator('iframe[title="Browser-local cookbook preview"]');
  const requestCountBeforeFileSelection = requests.length;
  await iframe.locator('#family').fill('Synthetic Family');
  await iframe.locator('#title').fill('Recipes We Keep — Test');
  await iframe.locator('#style').selectOption('sage');
  await iframe.locator('#local-image').setInputFiles(imagePath);
  await previewPage.waitForTimeout(300);
  const previewState = await previewPage.locator('iframe').evaluate(frame => {
    const w = frame.contentWindow;
    return w.__previewEvidence();
  });
  result.preview.evidence = previewState;
  result.preview.input_bindings_pass =
    previewState.family === 'Synthetic Family' &&
    previewState.title === 'Recipes We Keep — Test' &&
    previewState.style === 'sage' &&
    previewState.previewSections.length === 2;
  result.preview.network_requests_before_file_selection = requestCountBeforeFileSelection;
  result.preview.network_requests_after_file_selection = requests.length;
  result.preview.new_requests_after_local_file_selection = requests.length - requestCountBeforeFileSelection;
  result.preview.browser_version = browser.version();
  result.preview.image_sources_are_blob = previewState.localObjectUrl && previewState.imageSources.every(x => x.startsWith('blob:'));
  result.preview.server_upload_requests = requests.filter(x => x.method !== 'GET' && /upload|ocr|model/i.test(x.url)).length;
  result.preview.model_calls = 0;
  result.preview.token_usage = 0;
  result.preview.browser_local = result.preview.image_sources_are_blob && result.preview.new_requests_after_local_file_selection === 0 && result.preview.server_upload_requests === 0;
  await previewPage.setViewportSize({ width: 390, height: 844 });
  const mobileBox = await previewPage.locator('iframe').evaluate(frame => ({
    viewport: frame.contentWindow.innerWidth,
    document: frame.contentWindow.document.documentElement.scrollWidth
  }));
  result.preview.mobile = {
    outer_viewport_width: 390,
    iframe_viewport_width: mobileBox.viewport,
    iframe_document_width: mobileBox.document,
    responsive_no_horizontal_overflow: mobileBox.document <= mobileBox.viewport
  };

  const userA = await browser.newContext({ viewport: { width: 390, height: 844 } });
  try {
    const pageA = await login(userA, 'fcs-dummy-a', process.env.FCS_USER_A_PASSWORD);
    await pageA.goto(ids.proof_url, { waitUntil: 'domcontentloaded' });
    const proofMobileBox = await pageA.evaluate(() => ({ viewport: innerWidth, document: document.documentElement.scrollWidth }));
    result.upload.mobile = {
      viewport_width: proofMobileBox.viewport,
      document_width: proofMobileBox.document,
      responsive_no_horizontal_overflow: proofMobileBox.document <= proofMobileBox.viewport
    };
    await pageA.locator('#fcs-order-id').fill(String(ids.order_a_id));
    await pageA.locator('#fcs-file').setInputFiles(imagePath);
    const upload = await callOnPage(pageA, '/orders/' + ids.order_a_id + '/uploads', 'POST');
    result.upload.positive = { status: upload.status, access: upload.body.access, order_id: upload.body.order_id, mime: upload.body.mime, bytes: upload.body.bytes, sha256: upload.body.sha256, storage: upload.body.storage };
    result.upload.positive_pass = upload.status === 201 && upload.body.access === 'PASS' && upload.body.order_id === ids.order_a_id && upload.body.mime === 'image/png';
    const uploadedFileId = upload.body.file_id;
    const deliveryA = await callOnPage(pageA, '/orders/' + ids.order_a_id + '/files/' + ids.delivery_file_id);
    const deliveryDecoded = Buffer.from(deliveryA.body.content_base64 || '', 'base64');
    result.delivery.positive = { status: deliveryA.status, access: deliveryA.body.access, mime: deliveryA.body.mime, bytes: deliveryA.body.bytes, sha256: deliveryA.body.sha256, pdf_magic: deliveryDecoded.subarray(0, 8).toString('ascii') };
    result.delivery.positive_pass = deliveryA.status === 200 && deliveryA.body.access === 'PASS' && deliveryA.body.mime === 'application/pdf' && deliveryDecoded.subarray(0, 5).toString('ascii') === '%PDF-' && deliveryA.body.sha256 === ids.delivery_sha256;
    const ownUploadRead = await callOnPage(pageA, '/orders/' + ids.order_a_id + '/files/' + uploadedFileId);
    result.upload.own_access = { status: ownUploadRead.status, access: ownUploadRead.body.access, sha256: ownUploadRead.body.sha256 };
    result.upload.own_access_pass = ownUploadRead.status === 200 && ownUploadRead.body.access === 'PASS';
    const wrongOrder = await callOnPage(pageA, '/orders/' + ids.order_b_id + '/files/' + uploadedFileId);
    result.delivery.unrelated_order_status = wrongOrder.status;
    result.upload.unrelated_order_status = wrongOrder.status;

    await pageA.locator('#fcs-file').setInputFiles({ name: 'not-an-image.txt', mimeType: 'text/plain', buffer: Buffer.from('synthetic unsupported test') });
    const badType = await callOnPage(pageA, '/orders/' + ids.order_a_id + '/uploads', 'POST');
    result.upload.unsupported_type_status = badType.status;
    await pageA.locator('#fcs-file').setInputFiles({ name: 'over-limit.png', mimeType: 'image/png', buffer: Buffer.alloc(2097153, 1) });
    const tooLarge = await callOnPage(pageA, '/orders/' + ids.order_a_id + '/uploads', 'POST');
    result.upload.over_limit_status = tooLarge.status;
    await pageA.screenshot({ path: resolve(process.env.G2A1_R2_ARTIFACT_DIR, 'wp', 'proof-mobile.png'), fullPage: true });
  } finally {
    await userA.close();
  }

  const userB = await browser.newContext();
  try {
    const pageB = await login(userB, 'fcs-dummy-b', process.env.FCS_USER_B_PASSWORD);
    await pageB.goto(ids.proof_url, { waitUntil: 'domcontentloaded' });
    const unrelatedUserDelivery = await callOnPage(pageB, '/orders/' + ids.order_a_id + '/files/' + ids.delivery_file_id);
    await pageB.locator('#fcs-file').setInputFiles(imagePath);
    const unrelatedUserUpload = await callOnPage(pageB, '/orders/' + ids.order_a_id + '/uploads', 'POST');
    result.delivery.unrelated_user_status = unrelatedUserDelivery.status;
    result.upload.unrelated_user_status = unrelatedUserUpload.status;
    await pageB.locator('#fcs-order-id').fill(String(ids.order_b_id));
    await pageB.locator('#fcs-file').setInputFiles(imagePath);
    const ownOrderBUpload = await callOnPage(pageB, '/orders/' + ids.order_b_id + '/uploads', 'POST');
    result.upload.user_b_own_order_positive = { status: ownOrderBUpload.status, order_id: ownOrderBUpload.body.order_id };
    const unrelatedOrderUpload = await callOnPage(pageB, '/orders/' + ids.order_b_id + '/files/' + result.upload.positive.file_id);
    result.upload.unrelated_order_status = unrelatedOrderUpload.status;
    const unrelatedOrderDelivery = await callOnPage(pageB, '/orders/' + ids.order_b_id + '/files/' + ids.delivery_file_id);
    result.delivery.unrelated_order_status = unrelatedOrderDelivery.status;
  } finally {
    await userB.close();
  }

  const directRaw = await fetch(base + '/wp-content/uploads/family-cookbook-private/' + ids.delivery_file_id + '.pdf');
  result.delivery.direct_raw_public_url_status = directRaw.status;
  result.delivery.private_storage_outside_document_root = ids.storage_location;
  result.preview.all_assertions_pass = result.preview.browser_local && result.preview.input_bindings_pass && result.preview.mobile.responsive_no_horizontal_overflow;
  result.upload.all_access_assertions_pass =
    result.upload.positive_pass && result.upload.own_access_pass &&
    result.upload.anonymous_status >= 400 && result.upload.unrelated_user_status === 403 &&
    result.upload.unrelated_order_status === 404 &&
    result.upload.unsupported_type_status === 415 && result.upload.over_limit_status === 413 &&
    result.upload.mobile.responsive_no_horizontal_overflow &&
    result.upload.user_b_own_order_positive.status === 201;
  result.delivery.all_access_assertions_pass =
    result.delivery.positive_pass && result.delivery.anonymous_status >= 400 &&
    result.delivery.unrelated_user_status === 403 && result.delivery.unrelated_order_status === 404 &&
    result.delivery.direct_raw_public_url_status === 404;
  const postPaymentUploadRequests = requests.filter(x => x.method !== 'GET' && x.url.includes('/uploads')).length;
  result.network = {
    requests: requests.map(x => ({ method: x.method, path: new URL(x.url).pathname })),
    image_uploads_before_payment: result.preview.server_upload_requests,
    post_payment_upload_requests: postPaymentUploadRequests
  };
  result.status = result.preview.all_assertions_pass && result.upload.all_access_assertions_pass && result.delivery.all_access_assertions_pass ? 'PASS' : 'FAIL';
  await mkdir(dirname(outPath), { recursive: true });
  await (await import('node:fs/promises')).writeFile(outPath, JSON.stringify(result, null, 2) + '\n');
  assert.equal(result.status, 'PASS', 'Family Cookbook WP/WooCommerce evidence assertions failed');
} finally {
  await browser.close();
}
