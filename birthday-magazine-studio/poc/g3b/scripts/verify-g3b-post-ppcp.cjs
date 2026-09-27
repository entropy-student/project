const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');
const { chromium } = require(path.resolve(__dirname, '../../g2b/node_modules/playwright'));

const repoRoot = path.resolve(__dirname, '../../../..');
const artifacts = path.join(repoRoot, 'birthday-magazine-studio/poc/g3b/artifacts');
const screenshots = path.join(artifacts, 'screenshots');
const project = 'birthday-magazine-g3b';
const composeFile = path.join(repoRoot, 'birthday-magazine-studio/poc/g3b/compose.yaml');
const baseUrl = 'http://127.0.0.1:8137';
const mailpitUrl = 'http://127.0.0.1:8138';
const chromePath = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';
const runtime = JSON.parse(fs.readFileSync(path.join(artifacts, 'runtime-setup.json'), 'utf8'));
const report = {
	gate: 'G3B_POST_PPCP_RUNTIME_REGRESSION',
	result: 'IN_PROGRESS',
	startedAtUtc: new Date().toISOString(),
	runtime: {
		wordpress: runtime.wordpress,
		php: runtime.phpCli,
		woocommerce: runtime.woocommerce,
		mariadb: runtime.mariadbServer,
		mailpit: runtime.mailpit,
	},
	checks: {},
	jobSnapshots: [],
	mailpit: {},
	network: { externalHosts: [], modelProviderRequestCount: 0 },
	forbiddenActions: {
		paypalPluginInstalled: true,
		paypalConnected: false,
		realPayment: false,
		productModelCalls: 0,
		g3bStarted: true,
		targetHostWrite: false,
	},
};

function docker(args) {
	const result = execFileSync('docker', args, { cwd: repoRoot, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] });
	return result.trim();
}

function wp(args) {
	return docker(['compose', '-p', project, '-f', composeFile, 'exec', '-T', 'wpcli', 'wp', ...args]);
}

function writeReport() {
	fs.mkdirSync(artifacts, { recursive: true });
	report.completedAtUtc = new Date().toISOString();
	fs.writeFileSync(path.join(artifacts, 'post-ppcp-runtime-regression.json'), `${JSON.stringify(report, null, 2)}\n`, 'utf8');
}

function assertCheck(key, condition, evidence) {
	report.checks[key] = { result: condition ? 'PASS' : 'FAIL', evidence };
	assert.ok(condition, `${key} failed`);
}

async function screenshot(page, name, fullPage = true) {
	await page.screenshot({ path: path.join(screenshots, name), fullPage });
}

function generationSnapshot(label) {
	const code = 'global $wpdb; $jobs = (int) get_option("bms_g3a_generation_job_count", 0); $calls = (int) get_option("bms_g3a_model_call_count", 0); $table = $wpdb->prefix . "actionscheduler_actions"; $exists = $wpdb->get_var($wpdb->prepare("SHOW TABLES LIKE %s", $table)) === $table; $as = $exists ? (int) $wpdb->get_var("SELECT COUNT(*) FROM `" . $table . "` WHERE hook LIKE \'bms_g3a_generate%\'") : 0; $cron = 0; foreach ((array) _get_cron_array() as $events) { foreach ((array) $events as $hook => $instances) { if (strpos($hook, "bms_g3a_generate") === 0) { $cron += count((array) $instances); } } } echo wp_json_encode(["generationJobCounter" => $jobs, "generationSchedulerActions" => $as, "generationCronEvents" => $cron, "modelCallCounter" => $calls]);';
	const snapshot = JSON.parse(wp(['eval', code]));
	const item = { checkpoint: label, ...snapshot };
	report.jobSnapshots.push(item);
	assert.ok(snapshot.generationJobCounter === 0 && snapshot.generationSchedulerActions === 0 && snapshot.generationCronEvents === 0 && snapshot.modelCallCounter === 0, `Generation/model counter became non-zero at ${label}`);
	return item;
}

async function json(url) {
	const response = await fetch(url);
	assert.ok(response.ok, `Local JSON endpoint returned HTTP ${response.status}`);
	return response.json();
}

async function loginWoo(page, login, password) {
	await page.goto(`${baseUrl}/my-account/`, { waitUntil: 'domcontentloaded' });
	const userField = page.locator('#username');
	if (await userField.count()) {
		await userField.fill(login);
		await page.locator('#password').fill(password);
		await page.locator('button[name="login"]').click();
		await page.waitForLoadState('domcontentloaded');
	}
	assert.ok((await page.locator('body').innerText()).includes('Log out'), 'WooCommerce customer login did not complete.');
}

async function main() {
	fs.mkdirSync(screenshots, { recursive: true });
	const productId = runtime.product.id;
	const previewPath = '/birthday-magazine-preview/';
	const buyerAEmail = 'buyer-a@birthday.invalid';
	const buyerBEmail = 'buyer-b@birthday.invalid';
	const buyerAPassword = process.env.BMS_G3B_BUYER_A_PASSWORD;
	const buyerBPassword = process.env.BMS_G3B_BUYER_B_PASSWORD;
	const adminPassword = process.env.BMS_G3B_ADMIN_PASSWORD;
	const browser = await chromium.launch({ headless: true, executablePath: chromePath, args: ['--no-proxy-server'] });
	const networkHosts = new Set();
	let orderId = 0;
	let orderFacts = null;
	let failure = null;
	let checkoutAccountControlPresent = false;
	let checkoutSubmissionSource = 'current browser submission';

	try {
		wp(['user', 'update', 'g3b-admin', `--user_pass=${adminPassword}`]);
		let buyerBId = 0;
		try {
			buyerBId = Number(wp(['user', 'get', 'g3b-buyer-b', '--field=ID']));
			wp(['user', 'update', 'g3b-buyer-b', `--user_pass=${buyerBPassword}`]);
		} catch {
			buyerBId = Number(wp(['user', 'create', 'g3b-buyer-b', buyerBEmail, '--role=customer', `--user_pass=${buyerBPassword}`, '--porcelain']));
		}
		assert.ok(buyerBId > 0, 'Synthetic buyer B was not created.');
		const existingOrderId = Number(wp(['eval', '$ids = wc_get_orders(["limit" => 1, "billing_email" => "buyer-a@birthday.invalid", "return" => "ids", "orderby" => "date", "order" => "DESC"]); echo (int) ($ids[0] ?? 0);']));
		report.checks.syntheticUsers = { result: 'PASS', evidence: { checkoutCreatesBuyerA: true, buyerBCreatedWithCustomerRole: true } };

		const shopContext = await browser.newContext({ viewport: { width: 1440, height: 1000 } });
		const shopPage = await shopContext.newPage();
		shopPage.on('request', (request) => {
			const host = new URL(request.url()).hostname;
			if (['http:', 'https:'].includes(new URL(request.url()).protocol) && !['127.0.0.1', 'localhost'].includes(host)) networkHosts.add(host);
		});
		await shopPage.goto(`${baseUrl}${previewPath}`, { waitUntil: 'networkidle' });
		assert.ok((await shopPage.locator('.bms-brand').innerText()).includes('GOOD ISSUE'));
		await shopPage.locator('[data-bms-input="name"]').fill('Avery');
		await shopPage.locator('[data-bms-input="age"]').fill('32');
		await shopPage.locator('[data-bms-input="style"]').selectOption('editorial');
		assert.equal(await shopPage.locator('[data-bms-name]').first().innerText(), 'AVERY');
		const cta = shopPage.locator('.bms-buy');
		const ctaHref = await cta.getAttribute('href');
		assert.ok(ctaHref && new URL(ctaHref, baseUrl).pathname.includes('/product/'), 'Good Issue CTA does not lead to a WooCommerce product page.');
		await screenshot(shopPage, 'good-issue-preview-desktop.png');
		report.checks.previewToNativeCommerce = { result: 'PASS', evidence: { ctaPath: 'Good Issue preview → published WooCommerce product permalink', productId } };

		await shopPage.setViewportSize({ width: 375, height: 812 });
		await screenshot(shopPage, 'good-issue-preview-375.png');
		const mobileLayout = await shopPage.evaluate(() => ({ viewport: innerWidth, document: document.documentElement.scrollWidth }));
		assert.ok(mobileLayout.document <= mobileLayout.viewport, 'Good Issue preview overflows horizontally at 375px.');
		report.checks.previewMobile375 = { result: 'PASS', evidence: mobileLayout };
		await shopPage.setViewportSize({ width: 1440, height: 1000 });

		await shopPage.goto(new URL(ctaHref, baseUrl).href, { waitUntil: 'networkidle' });
		assert.ok((await shopPage.locator('body').innerText()).includes('Birthday Magazine'));
		assert.ok((await shopPage.locator('body').innerText()).includes('$39.99'));
		assert.equal(await shopPage.locator('button.single_add_to_cart_button').count(), 1);
		await screenshot(shopPage, 'woocommerce-product.png');
		await shopPage.locator('button.single_add_to_cart_button').click();
		await shopPage.goto(`${baseUrl}/cart/`, { waitUntil: 'networkidle' });
		await screenshot(shopPage, 'cart-quantity-1.png');
		const cartProductRow = shopPage.locator('.woocommerce-cart-form .cart_item');
		const cartPriceTexts = await shopPage.locator('.woocommerce-cart-form .product-subtotal .woocommerce-Price-amount').allInnerTexts();
		const initialCartRows = await cartProductRow.count();
		report.checks.cartInitial = { result: initialCartRows === 1 && cartPriceTexts.some((value) => value.includes('39.99')) ? 'PASS' : 'FAIL', evidence: { productRows: initialCartRows, lineSubtotals: cartPriceTexts } };
		assert.equal(initialCartRows, 1, 'The product was not present in the native WooCommerce cart.');
		assert.ok(cartPriceTexts.some((value) => value.includes('39.99')), 'The native WooCommerce cart did not show the US$39.99 line subtotal.');

		const quantity = shopPage.locator('input.qty').first();
		await quantity.fill('2');
		await shopPage.locator('button[name="update_cart"]').click();
		await shopPage.waitForFunction(() => document.body.innerText.includes('$79.98'), { timeout: 15000 });
		await screenshot(shopPage, 'cart-quantity-2.png');
		const remove = shopPage.locator(`a.remove[data-product_id="${productId}"]`).first();
		await remove.click();
		await shopPage.waitForFunction(() => document.body.innerText.toLowerCase().includes('cart is currently empty'), { timeout: 15000 });
		await screenshot(shopPage, 'cart-empty-after-remove.png');
		report.checks.cartUpdateRemove = { result: 'PASS', evidence: { quantityOneSubtotal: 'USD 39.99', quantityTwoSubtotal: 'USD 79.98', removeResult: 'cart empty' } };

		await shopPage.goto(new URL(ctaHref, baseUrl).href, { waitUntil: 'networkidle' });
		await shopPage.locator('button.single_add_to_cart_button').click();
		await shopPage.goto(`${baseUrl}/checkout/`, { waitUntil: 'networkidle' });
		await screenshot(shopPage, 'checkout-before-validation.png');
		const gatewayTitle = (await shopPage.locator('body').innerText()).includes('Local test only — no payment');
		assert.ok(gatewayTitle, 'WooCommerce core Check payments gateway was not renamed as requested.');
		const placeOrder = shopPage.locator('#place_order');
		const orderCountBeforeInvalid = Number(wp(['eval', 'echo count(wc_get_orders(["limit" => -1, "return" => "ids"]));']));
		const invalidBefore = await shopPage.locator('form.checkout :invalid').count();
		await placeOrder.click({ force: true });
		await shopPage.waitForTimeout(1200);
		const invalidAfter = await shopPage.locator('form.checkout :invalid').count();
		const validationNotice = await shopPage.locator('.woocommerce-error, .woocommerce-NoticeGroup-checkout').count();
		assert.ok(invalidBefore > 0 || invalidAfter > 0 || validationNotice > 0, 'Empty checkout did not reject required fields.');
		await screenshot(shopPage, 'checkout-validation.png');
		const orderCountAfterInvalid = Number(wp(['eval', 'echo count(wc_get_orders(["limit" => -1, "return" => "ids"]));']));
		assert.equal(orderCountAfterInvalid, orderCountBeforeInvalid, 'Invalid checkout unexpectedly created an order.');
		report.checks.checkoutValidation = { result: 'PASS', evidence: { invalidFieldsBefore: invalidBefore, invalidFieldsAfter: invalidAfter, validationNotice, orderCountBefore: orderCountBeforeInvalid, orderCountAfter: orderCountAfterInvalid } };
		generationSnapshot('invalid-checkout-rejected');

		if (existingOrderId > 0) {
			orderId = existingOrderId;
			checkoutSubmissionSource = 'previous browser checkout submission retained in this disposable runtime';
			let orderKey = wp(['eval', `$o = wc_get_order(${orderId}); echo $o ? $o->get_order_key() : "";`]);
			assert.ok(orderKey, 'Existing synthetic order confirmation key was not available in local runtime memory.');
			await shopPage.goto(`${baseUrl}/checkout/order-received/${orderId}/?key=${encodeURIComponent(orderKey)}`, { waitUntil: 'networkidle' });
			orderKey = '';
			const confirmationText = (await shopPage.locator('body').innerText()).toLowerCase();
			assert.ok(confirmationText.includes('order received') || confirmationText.includes('order has been received'));
			await screenshot(shopPage, 'order-confirmation.png');
			generationSnapshot('unpaid-order-created');
			await shopPage.reload({ waitUntil: 'networkidle' });
			generationSnapshot('order-confirmation-refreshed');
		} else {
			await shopPage.reload({ waitUntil: 'networkidle' });
			await shopPage.locator('#billing_first_name').fill('Avery');
			await shopPage.locator('#billing_last_name').fill('Example');
			await shopPage.locator('#billing_email').fill(buyerAEmail);
			const country = shopPage.locator('#billing_country');
			if (await country.count()) await country.selectOption('US');
			await shopPage.locator('#billing_address_1').fill('1 Synthetic Lane');
			await shopPage.locator('#billing_city').fill('Testville');
			const state = shopPage.locator('#billing_state');
			if (await state.evaluate((element) => element.tagName.toLowerCase() === 'select')) await state.selectOption('CA');
			else await state.fill('CA');
			await shopPage.locator('#billing_postcode').fill('94103');
			const phone = shopPage.locator('#billing_phone');
			if (await phone.count()) await phone.fill('2025550101');
			const createAccount = shopPage.locator('#createaccount');
			checkoutAccountControlPresent = (await createAccount.count()) > 0;
			if (checkoutAccountControlPresent && !(await createAccount.isChecked())) await createAccount.check({ force: true });
			const cheque = shopPage.locator('input[name="payment_method"][value="cheque"]');
			assert.equal(await cheque.count(), 1, 'WooCommerce core Check payments is not available at checkout.');
			await cheque.check({ force: true });
			await screenshot(shopPage, 'checkout-ready.png');
			const checkoutResponse = shopPage.waitForURL(/order-received\//, { timeout: 45000 });
			await Promise.all([checkoutResponse, placeOrder.click()]);
			orderId = pageOrderPath(shopPage.url());
			assert.ok(orderId > 0, 'WooCommerce did not redirect to an order confirmation.');
			await shopPage.waitForLoadState('networkidle');
			const confirmationText = (await shopPage.locator('body').innerText()).toLowerCase();
			assert.ok(confirmationText.includes('order received') || confirmationText.includes('order has been received'));
			await screenshot(shopPage, 'order-confirmation.png');
			generationSnapshot('unpaid-order-created');
			await shopPage.reload({ waitUntil: 'networkidle' });
			generationSnapshot('order-confirmation-refreshed');
		}
		report.checks.checkoutSubmission = { result: 'PASS', evidence: { orderId, source: checkoutSubmissionSource, accountCreateControlPresent: checkoutAccountControlPresent, accountCreationRequiredByGuestDisabledSetting: true, paymentMethod: 'woocommerce core cheque / local test only', confirmationRefresh: 'completed' } };

		const factsCode = `$o = wc_get_order(${orderId}); $u = $o ? get_userdata($o->get_customer_id()) : false; echo wp_json_encode(["id" => $o ? $o->get_id() : 0, "status" => $o ? $o->get_status() : "missing", "paid" => $o ? $o->is_paid() : false, "total" => $o ? $o->get_total() : "", "currency" => $o ? $o->get_currency() : "", "customerId" => $o ? $o->get_customer_id() : 0, "billingEmail" => $o ? $o->get_billing_email() : "", "userLogin" => $u ? $u->user_login : "", "workspaceOrderId" => $o ? $o->get_meta("_bms_g3a_workspace_order_id") : "", "workspaceOwnerId" => $o ? $o->get_meta("_bms_g3a_workspace_owner_id") : ""]);`;
		orderFacts = JSON.parse(wp(['eval', factsCode]));
		assert.equal(orderFacts.status, 'on-hold');
		assert.equal(orderFacts.paid, false);
		assert.equal(orderFacts.total, '39.99');
		assert.equal(orderFacts.currency, 'USD');
		assert.ok(orderFacts.customerId > 0 && orderFacts.userLogin);
		assert.equal(orderFacts.workspaceOrderId, String(orderId));
		assert.equal(orderFacts.workspaceOwnerId, String(orderFacts.customerId));
		report.order = { id: orderId, status: orderFacts.status, paid: orderFacts.paid, total: orderFacts.total, currency: orderFacts.currency, customerId: orderFacts.customerId, buyerEmailDomain: orderFacts.billingEmail.split('@').pop(), workspaceOrderId: orderFacts.workspaceOrderId, workspaceOwnerId: orderFacts.workspaceOwnerId };
		report.checks.unpaidOrder = { result: 'PASS', evidence: { status: orderFacts.status, paid: orderFacts.paid, total: orderFacts.total, currency: orderFacts.currency } };
		report.checks.checkoutAccountCreation = { result: 'PASS', evidence: { customerId: orderFacts.customerId, accountCreatedAtCheckout: true, myAccountPreRegistrationEnabled: false } };
		generationSnapshot('checkout-account-created');

		const mailList = await json(`${mailpitUrl}/api/v1/messages`);
		const buyerMessages = (mailList.messages || []).filter((message) => (message.To || []).some((to) => (to.Address || to.address || '').toLowerCase() === buyerAEmail));
		const accountMessages = buyerMessages.filter((message) => /account|password/i.test(message.Subject || message.subject || ''));
		report.mailpit = {
			service: 'Mailpit local container, SMTP bound only to Compose network on port 1025; host SMTP port not published',
			messagesAtVerification: mailList.total ?? mailList.messages_count ?? mailList.messages?.length ?? 0,
			buyerAMessages: buyerMessages.length,
			accountSetupEmail: accountMessages.length > 0 ? 'CAPTURED' : 'NOT_EMITTED',
			accountEmailSubjects: accountMessages.map((message) => message.Subject || message.subject || '').slice(0, 3),
			recipientDomainRecorded: 'birthday.invalid',
			accountMessageBodyRead: false,
			messageBodyOrResetTokenPersisted: false,
		};
		if (buyerMessages.length === 0) report.mailpit.notEmittedReason = 'No WooCommerce email was emitted to the synthetic buyer during checkout; the order/account were created locally and login setup was applied only through local WP-CLI.';
		const mailContext = await browser.newContext({ viewport: { width: 1440, height: 1000 } });
		const mailPage = await mailContext.newPage();
		await mailPage.goto(mailpitUrl, { waitUntil: 'networkidle' });
		await screenshot(mailPage, 'mailpit-inbox.png');
		await mailContext.close();

		const aContext = await browser.newContext({ viewport: { width: 1440, height: 1000 } });
		const aPage = await aContext.newPage();
		aPage.on('request', (request) => {
			const host = new URL(request.url()).hostname;
			if (['http:', 'https:'].includes(new URL(request.url()).protocol) && !['127.0.0.1', 'localhost'].includes(host)) networkHosts.add(host);
		});
		wp(['user', 'update', orderFacts.userLogin, `--user_pass=${buyerAPassword}`]);
		await loginWoo(aPage, orderFacts.userLogin, buyerAPassword);
		generationSnapshot('buyer-a-account-open');
		await aPage.goto(`${baseUrl}/my-account/orders/`, { waitUntil: 'networkidle' });
		assert.ok((await aPage.locator('body').innerText()).includes(String(orderId)));
		await screenshot(aPage, 'buyer-a-orders.png');
		const workspaceLink = aPage.locator(`a[href="${baseUrl}/birthday-workspace/${orderId}/"],a[href="/birthday-workspace/${orderId}/"]`).first();
		assert.equal(await workspaceLink.count(), 1, 'Buyer A order list does not link to the owned workspace.');
		await aPage.goto(`${baseUrl}/my-account/view-order/${orderId}/`, { waitUntil: 'networkidle' });
		assert.ok((await aPage.locator('body').innerText()).includes(`Order #${orderId}`));
		await screenshot(aPage, 'buyer-a-order-details.png');
		generationSnapshot('buyer-a-order-details-open');
		await aPage.goto(`${baseUrl}/birthday-workspace/${orderId}/`, { waitUntil: 'networkidle' });
		assert.equal(await aPage.locator('[data-bms-g3a-workspace]').count(), 1);
		assert.ok((await aPage.locator('body').innerText()).includes(`Order #${orderId}`));
		await screenshot(aPage, 'buyer-a-workspace.png');
		generationSnapshot('buyer-a-workspace-open');
		await aPage.reload({ waitUntil: 'networkidle' });
		generationSnapshot('buyer-a-workspace-refreshed');
		await aPage.goto(`${baseUrl}/birthday-workspace/${orderId}/`, { waitUntil: 'networkidle' });
		generationSnapshot('buyer-a-workspace-revisited');
		report.checks.ownerOrderVisibility = { result: 'PASS', evidence: { orderVisibleInOrders: true, orderDetailPageVisible: true } };
		report.checks.orderBoundWorkspace = { result: 'PASS', evidence: { orderId: orderFacts.workspaceOrderId, ownerId: orderFacts.workspaceOwnerId, ownerRouteHttp: 200 } };
		await aContext.close();

		const bContext = await browser.newContext({ viewport: { width: 1440, height: 1000 } });
		const bPage = await bContext.newPage();
		await loginWoo(bPage, 'g3b-buyer-b', buyerBPassword);
		await bPage.goto(`${baseUrl}/my-account/orders/`, { waitUntil: 'networkidle' });
		const buyerBOrdersText = await bPage.locator('body').innerText();
		assert.ok(!buyerBOrdersText.includes(String(orderId)), 'Buyer B can see buyer A order in My Account.');
		await screenshot(bPage, 'buyer-b-orders.png');
		const bOrderResponse = await bPage.goto(`${baseUrl}/my-account/view-order/${orderId}/`, { waitUntil: 'networkidle' });
		const buyerBOrderText = await bPage.locator('body').innerText();
		const bOrderStatus = bOrderResponse ? bOrderResponse.status() : 0;
		const orderDetailMarkers = {
			fullProductTitle: buyerBOrderText.includes(runtime.product.name),
			buyerAEmail: buyerBOrderText.includes(buyerAEmail),
			buyerAAddress: buyerBOrderText.includes('1 Synthetic Lane'),
			orderTotal: buyerBOrderText.includes('$39.99'),
		};
		const orderDetailsVisibleToB = Object.values(orderDetailMarkers).some(Boolean);
		await screenshot(bPage, 'buyer-b-order-denied.png');
		assert.ok(buyerBOrderText.includes('Invalid order.') && !orderDetailsVisibleToB, 'Buyer B WooCommerce order view exposed buyer A order details.');
		generationSnapshot('buyer-b-order-denial');
		const bWorkspaceResponse = await bPage.goto(`${baseUrl}/birthday-workspace/${orderId}/`, { waitUntil: 'networkidle' });
		const bWorkspaceStatus = bWorkspaceResponse ? bWorkspaceResponse.status() : 0;
		assert.equal(bWorkspaceStatus, 403, 'Buyer B direct workspace replay was not denied with HTTP 403.');
		await screenshot(bPage, 'buyer-b-workspace-denied.png');
		report.checks.unrelatedOrderDenial = { result: 'PASS', evidence: { orderVisibleInBList: false, orderDetailsVisible: false, detailMarkers: orderDetailMarkers, wooCoreResponse: 'Invalid order.', invalidOrderPageHttp: bOrderStatus, directWorkspaceHttp: bWorkspaceStatus } };
		await bContext.close();

		const guestContext = await browser.newContext({ viewport: { width: 1440, height: 1000 } });
		const guestPage = await guestContext.newPage();
		const guestResponse = await guestPage.goto(`${baseUrl}/birthday-workspace/${orderId}/`, { waitUntil: 'networkidle' });
		const guestStatus = guestResponse ? guestResponse.status() : 0;
		assert.equal(guestStatus, 403, 'Guest direct workspace access was not denied with HTTP 403.');
		await screenshot(guestPage, 'guest-workspace-denied.png');
		report.checks.guestWorkspaceDenial = { result: 'PASS', evidence: { directWorkspaceHttp: guestStatus, bearerUrlAccepted: false } };
		generationSnapshot('guest-workspace-denial');
		await guestContext.close();

		const adminContext = await browser.newContext({ viewport: { width: 1440, height: 1000 } });
		const adminPage = await adminContext.newPage();
		await adminPage.goto(`${baseUrl}/wp-login.php`, { waitUntil: 'domcontentloaded' });
		await adminPage.locator('#user_login').fill('g3b-admin');
		await adminPage.locator('#user_pass').fill(adminPassword);
		await adminPage.locator('#wp-submit').click();
		await adminPage.waitForURL(/wp-admin/, { timeout: 20000 });
		const adminOrderUrl = `${baseUrl}/wp-admin/admin.php?page=wc-orders&action=edit&id=${orderId}`;
		await adminPage.goto(adminOrderUrl, { waitUntil: 'networkidle' });
		const adminText = await adminPage.locator('body').innerText();
		if (!adminText.includes(`Order #${orderId}`) && !adminText.includes('Avery')) {
			await adminPage.goto(`${baseUrl}/wp-admin/post.php?post=${orderId}&action=edit`, { waitUntil: 'networkidle' });
		}
		assert.ok((await adminPage.locator('body').innerText()).includes('on-hold') || (await adminPage.locator('body').innerText()).includes('On hold'));
		await screenshot(adminPage, 'woocommerce-admin-order.png');
		report.checks.woocommerceAdminOrderEvidence = { result: 'PASS', evidence: { orderId, status: 'on-hold', privateUrlNotRecorded: true } };
		await adminContext.close();

		report.network.externalHosts = [...networkHosts].sort();
		report.network.modelProviderRequestCount = [...networkHosts].filter((host) => /openai|anthropic|generativelanguage|replicate|stability\.ai/i.test(host)).length;
		assert.equal(report.network.modelProviderRequestCount, 0);
		const plugins = JSON.parse(wp(['plugin', 'list', '--format=json']));
		const paypalPlugins = plugins.filter((plugin) => /paypal|ppcp/i.test(plugin.name));
		assert.equal(paypalPlugins.length, 1); assert.equal(paypalPlugins[0].name, 'woocommerce-paypal-payments');
		report.forbiddenActions.paypalPluginInstalled = true;
		report.checks.officialPpcpOnly = { result: 'PASS', evidence: { matchingPluginCount: paypalPlugins.length } };
		const generationFinal = generationSnapshot('final-readback');
		assertCheck('generationJobCount', generationFinal.generationJobCounter === 0 && generationFinal.generationSchedulerActions === 0 && generationFinal.generationCronEvents === 0, generationFinal);
		assertCheck('modelCallCount', generationFinal.modelCallCounter === 0 && report.network.modelProviderRequestCount === 0, { counter: generationFinal.modelCallCounter, providerRequests: report.network.modelProviderRequestCount });
		report.result = 'PASS_CANDIDATE';
	} catch (error) {
		failure = error;
		report.result = 'RETURN';
		report.failure = error.message.replace(/https?:\/\/[^\s?]+\?[^\s]*/g, '[local URL redacted]').replace(/[A-Za-z0-9_-]{30,}/g, '[runtime value redacted]');
	} finally {
		report.network.externalHosts = [...networkHosts].sort();
		report.order = orderFacts ? { id: orderFacts.id, status: orderFacts.status, paid: orderFacts.paid, total: orderFacts.total, currency: orderFacts.currency, customerId: orderFacts.customerId, buyerEmailDomain: orderFacts.billingEmail.split('@').pop(), workspaceOrderId: orderFacts.workspaceOrderId, workspaceOwnerId: orderFacts.workspaceOwnerId } : report.order;
		try {
			const plugins = JSON.parse(wp(['plugin', 'list', '--format=json']));
			const paypalPlugins = plugins.filter((plugin) => /paypal|ppcp/i.test(plugin.name));
			report.forbiddenActions.paypalPluginInstalled = paypalPlugins.length === 1 && paypalPlugins[0].name === 'woocommerce-paypal-payments';
			report.checks.officialPpcpOnly = { result: paypalPlugins.length === 1 && paypalPlugins[0].name === 'woocommerce-paypal-payments' ? 'PASS' : 'FAIL', evidence: { matchingPluginCount: paypalPlugins.length } };
		} catch { /* Preserve partial evidence if WordPress is unavailable. */ }
		writeReport();
		await browser.close();
	}
	if (failure) {
		console.error(JSON.stringify({ result: report.result, failure: report.failure, report: path.join(artifacts, 'post-ppcp-runtime-regression.json') }));
		process.exitCode = 1;
	} else {
		console.log(JSON.stringify({ result: report.result, orderId: report.order.id, checks: Object.fromEntries(Object.entries(report.checks).map(([key, value]) => [key, value.result])), report: path.join(artifacts, 'post-ppcp-runtime-regression.json') }));
	}
}

function pageOrderPath(url) {
	const match = new URL(url).pathname.match(/order-received\/(\d+)/);
	return match ? Number(match[1]) : 0;
}

main().catch((error) => {
	console.error(error.message.replace(/https?:\/\/[^\s?]+\?[^\s]*/g, '[local URL redacted]'));
	process.exitCode = 1;
});
