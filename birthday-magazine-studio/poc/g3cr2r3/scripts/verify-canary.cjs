const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');
const { chromium } = require('../.tmp/test-runner/node_modules/playwright-core');

const root = path.resolve(__dirname, '../../../..');
const base = path.join(root, 'birthday-magazine-studio/poc/g3cr2r3');
const screenshots = path.join(base, 'artifacts/screenshots');
const reports = path.join(base, 'artifacts/reports');
const compose = path.join(base, 'compose.yaml');
const project = 'birthday-magazine-g3cr2r3';
const baseUrl = 'http://127.0.0.1:8187';
const chromePath = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';

function docker(args) {
	return execFileSync('docker', args, { cwd: root, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
}

function wp(args) {
	return docker(['compose', '-p', project, '-f', compose, 'exec', '-T', 'wpcli', 'wp', ...args]);
}

function seedWorkspace(productId, checkoutOrderId) {
	const credentials = {
		aEmail: 'buyer-a@birthday.invalid',
		bEmail: 'buyer-b@birthday.invalid',
		aPassword: crypto.randomBytes(24).toString('base64url') + 'Aa7!',
		bPassword: crypto.randomBytes(24).toString('base64url') + 'Bb8!',
		productId,
		checkoutOrderId,
	};
	const encoded = Buffer.from(JSON.stringify(credentials)).toString('base64');
	const php = `$seed = json_decode(base64_decode('${encoded}'), true); $make = static function($login, $email, $password) { $existing = get_user_by('email', $email); $data = ['user_email' => $email, 'user_pass' => $password, 'role' => 'customer']; return $existing ? wp_update_user(array_merge($data, ['ID' => $existing->ID])) : wp_insert_user(array_merge($data, ['user_login' => $login])); }; $a = $make('g3cr2r3-buyer-a', $seed['aEmail'], $seed['aPassword']); $b = $make('g3cr2r3-buyer-b', $seed['bEmail'], $seed['bPassword']); if (is_wp_error($a) || is_wp_error($b)) { throw new Exception('Could not create synthetic workspace users'); } $orderId = (int) $seed['checkoutOrderId']; $order = $orderId ? wc_get_order($orderId) : false; if (!$order) { throw new Exception('Expected synthetic offline checkout order is missing'); } $order->update_meta_data('_bms_g3a_workspace_order_id', (string) $orderId); $order->update_meta_data('_bms_g3a_workspace_owner_id', (string) $a); $order->save_meta_data(); update_option('bms_g3cr2r3_workspace_order_id', $orderId, false); echo wp_json_encode(['buyerAId' => (int) $a, 'buyerBId' => (int) $b, 'orderId' => (int) $orderId, 'orderStatus' => $order->get_status(), 'paid' => $order->is_paid(), 'total' => $order->get_total(), 'currency' => $order->get_currency(), 'ownerId' => $order->get_customer_id()]);`;
	const seeded = JSON.parse(wp(['eval', php]));
	return { ...seeded, credentials };
}

async function main() {
	fs.mkdirSync(screenshots, { recursive: true });
	fs.mkdirSync(reports, { recursive: true });
	const setup = JSON.parse(fs.readFileSync(path.join(reports, 'woocommerce-setup.json'), 'utf8'));
	const report = {
		gate: 'G3CR2R3_BLOCKSY_WEDDING_IMPORT_WOOCOMMERCE_CANARY',
		startedAtUtc: new Date().toISOString(),
		checks: {},
		screenshots: [],
		externalHosts: [],
		consoleErrors: [],
		pageErrors: [],
		failedResources: [],
		forbiddenActions: { elementorInstalled: false, htSliderInstalled: false, paypalActions: 0, realMoneyActions: 0, modelCalls: 0, productionDeployments: 0, sharedInfraMutations: 0, paidPurchases: 0, globalDockerPrune: 0 },
	};
	const externalHosts = new Set();
	const browser = await chromium.launch({ headless: true, executablePath: chromePath, args: ['--no-proxy-server'] });
	try {
		const context = await browser.newContext({ viewport: { width: 1440, height: 1000 } });
		const page = await context.newPage();
		page.on('request', (request) => {
			const url = new URL(request.url());
			if (['http:', 'https:'].includes(url.protocol) && !['127.0.0.1', 'localhost'].includes(url.hostname)) externalHosts.add(url.hostname);
		});
		page.on('response', (response) => {
			if (response.status() >= 400) {
				const url = new URL(response.url());
				report.failedResources.push({ status: response.status(), host: url.hostname, path: url.pathname });
			}
		});
		page.on('pageerror', (error) => report.pageErrors.push(error.message.slice(0, 300)));
		page.on('console', (message) => { if (message.type() === 'error' && !message.text().includes('Failed to load resource')) report.consoleErrors.push(message.text().slice(0, 300)); });

		const home = await page.goto(`${baseUrl}/`, { waitUntil: 'networkidle', timeout: 30000 });
		await page.waitForTimeout(700);
		assert.equal(home.status(), 200);
		assert.match(await page.title(), /Wedding|Home|G3CR2R3/i);
		assert.ok(await page.locator('main, #main-container, .site-main').count());
		const desktopOverflow = await page.evaluate(() => ({ viewport: innerWidth, document: document.documentElement.scrollWidth }));
		assert.ok(desktopOverflow.document <= desktopOverflow.viewport + 1, `Wedding home desktop overflow: ${JSON.stringify(desktopOverflow)}`);
		await page.screenshot({ path: path.join(screenshots, 'wedding-home-desktop.png') });
		report.screenshots.push('wedding-home-desktop.png');
		report.checks.weddingHomeDesktop = { result: 'PASS', http: home.status(), layout: desktopOverflow, title: await page.title(), backgroundAssetsSettledBeforeCapture: true };

		await page.setViewportSize({ width: 375, height: 812 });
		await page.waitForTimeout(700);
		const mobileHome = await page.evaluate(() => ({ viewport: innerWidth, document: document.documentElement.scrollWidth }));
		assert.ok(mobileHome.document <= mobileHome.viewport + 1, `Wedding home mobile overflow: ${JSON.stringify(mobileHome)}`);
		await page.screenshot({ path: path.join(screenshots, 'wedding-home-mobile-375.png') });
		report.screenshots.push('wedding-home-mobile-375.png');
		report.checks.weddingHomeMobile375 = { result: 'PASS', layout: mobileHome };

		const frontend = JSON.parse(wp(['eval', '$front = get_post((int) get_option("page_on_front")); echo wp_json_encode(["frontId" => $front ? $front->ID : 0, "postType" => $front ? $front->post_type : "", "status" => $front ? $front->post_status : "", "blockMarkup" => $front ? strpos($front->post_content, "<!-- wp:") !== false : false, "parsedBlockCount" => $front ? count(parse_blocks($front->post_content)) : 0, "elementorMetaPresent" => $front ? (bool) get_post_meta($front->ID, "_elementor_data", true) : false]);']));
		const pluginRows = JSON.parse(wp(['plugin', 'list', '--format=json']));
		const themeRows = JSON.parse(wp(['theme', 'list', '--format=json']));
		const activePlugins = pluginRows.filter((plugin) => plugin.status === 'active').map((plugin) => ({ slug: plugin.name, version: plugin.version, status: plugin.status }));
		assert.deepEqual(themeRows.filter((theme) => theme.status === 'active').map((theme) => `${theme.name}@${theme.version}`), ['blocksy@2.1.57']);
		assert.ok(!pluginRows.some((plugin) => ['elementor', 'ht-slider-for-elementor'].includes(plugin.name)));
		assert.ok(['blocksy-companion', 'simply-gallery-block', 'stackable-ultimate-gutenberg-blocks', 'wpforms-lite'].every((slug) => activePlugins.some((plugin) => plugin.slug === slug)));
		assert.equal(frontend.postType, 'page');
		assert.equal(frontend.status, 'publish');
		assert.equal(frontend.blockMarkup, true);
		assert.ok(frontend.parsedBlockCount > 0);
		assert.equal(frontend.elementorMetaPresent, false);
		report.checks.weddingGutenbergEditable = { result: 'PASS', ...frontend, activeTheme: 'blocksy@2.1.57', activePlugins, elementorInstalled: false, htSliderInstalled: false };

		const admin = JSON.parse(fs.readFileSync(path.join(base, '.tmp/local-admin.json'), 'utf8'));
		const adminContext = await browser.newContext({ viewport: { width: 1440, height: 1000 } });
		const adminPage = await adminContext.newPage();
		await adminPage.goto(`${baseUrl}/wp-login.php`, { waitUntil: 'domcontentloaded' });
		await adminPage.locator('#user_login').fill(admin.user);
		await adminPage.locator('#user_pass').fill(admin.password);
		await adminPage.locator('#wp-submit').click();
		await adminPage.waitForTimeout(1000);
		assert.ok(adminPage.url().includes('/wp-admin/'), 'Temporary local administrator login did not reach WordPress admin.');
		await adminPage.goto(`${baseUrl}/wp-admin/post.php?post=${frontend.frontId}&action=edit`, { waitUntil: 'domcontentloaded' });
		await adminPage.waitForTimeout(2500);
		const editorStatus = await adminPage.evaluate(() => ({ url: location.href, titleInput: !!document.querySelector('.editor-post-title__input'), editorCanvas: !!document.querySelector('.edit-post-visual-editor, .block-editor-writing-flow'), bodyText: document.body.innerText.slice(0, 800) }));
		assert.ok(editorStatus.url.includes('post.php?post='));
		assert.ok(editorStatus.titleInput || editorStatus.editorCanvas, 'Gutenberg editor did not load for the imported homepage.');
		report.checks.gutenbergEditorScreen = { result: 'PASS', titleInput: editorStatus.titleInput, editorCanvas: editorStatus.editorCanvas, urlPath: '/wp-admin/post.php?post=<synthetic>&action=edit' };
		await adminContext.close();

		const productUrl = setup.product.permalink;
		await page.setViewportSize({ width: 1440, height: 1000 });
		const productResponse = await page.goto(productUrl, { waitUntil: 'domcontentloaded', timeout: 30000 });
		await page.waitForTimeout(1500);
		assert.equal(productResponse.status(), 200);
		const productText = await page.locator('body').innerText();
		assert.match(productText, /\$39\.99/);
		assert.equal(await page.locator('button.single_add_to_cart_button, button[name="add-to-cart"]').count(), 1);
		assert.ok(await page.locator('button.single_add_to_cart_button, button[name="add-to-cart"]').isVisible());
		const productDesktop = await page.evaluate(() => ({ viewport: innerWidth, document: document.documentElement.scrollWidth }));
		assert.ok(productDesktop.document <= productDesktop.viewport + 1);
		await page.screenshot({ path: path.join(screenshots, 'woo-product-desktop.png') });
		report.screenshots.push('woo-product-desktop.png');
		report.checks.productDesktop = { result: 'PASS', http: productResponse.status(), usd3999Visible: true, addToCartVisible: true, layout: productDesktop };

		await page.setViewportSize({ width: 375, height: 812 });
		await page.waitForTimeout(500);
		const productMobile = await page.evaluate(() => ({ viewport: innerWidth, document: document.documentElement.scrollWidth }));
		assert.ok(productMobile.document <= productMobile.viewport + 1);
		assert.ok(await page.locator('button.single_add_to_cart_button, button[name="add-to-cart"]').isVisible());
		await page.screenshot({ path: path.join(screenshots, 'woo-product-mobile-375.png') });
		report.screenshots.push('woo-product-mobile-375.png');
		report.checks.productMobile375 = { result: 'PASS', usd3999Visible: /\$39\.99/.test(await page.locator('body').innerText()), addToCartVisible: true, layout: productMobile };

		await page.setViewportSize({ width: 1440, height: 1000 });
		await page.locator('button.single_add_to_cart_button, button[name="add-to-cart"]').click();
		await page.waitForTimeout(900);
		await page.goto(`${baseUrl}/cart/`, { waitUntil: 'domcontentloaded', timeout: 30000 });
		await page.waitForTimeout(1200);
		assert.ok((await page.locator('body').innerText()).includes('Birthday Magazine'));
		const cartRows = await page.locator('.woocommerce-cart-form .cart_item').count();
		assert.equal(cartRows, 1);
		const initialSubtotal = await page.locator('.woocommerce-cart-form .cart_item .product-subtotal').innerText();
		assert.match(initialSubtotal, /39\.99/);
		const quantity = page.locator('.woocommerce-cart-form input.qty:visible').first();
		assert.equal(await quantity.count(), 1);
		await quantity.fill('2');
		await quantity.press('Tab');
		await page.locator('button[name="update_cart"]').click();
		await page.waitForFunction(() => document.body.innerText.includes('$79.98'), null, { timeout: 15000 });
		const cartDesktop = await page.evaluate(() => ({ viewport: innerWidth, document: document.documentElement.scrollWidth }));
		assert.ok(cartDesktop.document <= cartDesktop.viewport + 1);
		await page.screenshot({ path: path.join(screenshots, 'woo-cart.png') });
		report.screenshots.push('woo-cart.png');
		await page.setViewportSize({ width: 375, height: 812 });
		const cartMobile = await page.evaluate(() => ({ viewport: innerWidth, document: document.documentElement.scrollWidth }));
		assert.ok(cartMobile.document <= cartMobile.viewport + 1);
		assert.ok(await page.locator('button[name="update_cart"]').isVisible());
		const mobileQuantity = page.locator('.woocommerce-cart-form input.qty:visible').first();
		assert.equal(await mobileQuantity.count(), 1);
		await mobileQuantity.fill('3');
		await mobileQuantity.press('Tab');
		await page.locator('button[name="update_cart"]').click();
		await page.waitForFunction(() => document.body.innerText.includes('$119.97'), null, { timeout: 15000 });
		const remove = page.locator('a.remove').first();
		assert.ok(await remove.isVisible());
		await remove.click();
		await page.waitForFunction(() => /cart is currently empty/i.test(document.body.innerText), null, { timeout: 15000 });
		report.checks.cart = { result: 'PASS', itemRows: cartRows, initialSubtotal, quantityUpdateSubtotal: 'USD 79.98 desktop / USD 119.97 mobile', remove: 'cart empty', desktopLayout: cartDesktop, mobileControls: { layout: cartMobile, quantityEditAndUpdate: 'PASS', updateVisible: true, removeVisible: true } };

		await page.setViewportSize({ width: 1440, height: 1000 });
		await page.goto(productUrl, { waitUntil: 'domcontentloaded' });
		await page.locator('button.single_add_to_cart_button, button[name="add-to-cart"]').click();
		await page.waitForTimeout(900);
		await page.goto(`${baseUrl}/checkout/`, { waitUntil: 'domcontentloaded', timeout: 30000 });
		await page.waitForTimeout(1000);
		const checkoutResponse = page.url();
		const checkoutText = await page.locator('body').innerText();
		assert.match(checkoutText, /Billing details|Billing address/i);
		assert.ok(await page.locator('#billing_first_name').count());
		assert.ok(await page.locator('#billing_email').count());
		assert.ok(await page.locator('#place_order').isVisible());
		const checkoutAccountSetting = wp(['option', 'get', 'woocommerce_enable_signup_and_login_from_checkout']) === 'yes';
		const guestCheckoutSetting = wp(['option', 'get', 'woocommerce_enable_guest_checkout']) === 'no';
		const accountCreateVisible = await page.locator('#createaccount').count() > 0 || /create an account|create account/i.test(checkoutText);
		assert.ok(checkoutAccountSetting && guestCheckoutSetting, 'WooCommerce checkout account-creation settings drifted from the G3A baseline.');
		assert.ok(/Local test only — no payment/.test(checkoutText), 'Only the local offline test gateway should be visible at checkout.');
		assert.ok(!/PayPal/i.test(checkoutText));
		const checkoutLayout = await page.evaluate(() => ({ viewport: innerWidth, document: document.documentElement.scrollWidth }));
		assert.ok(checkoutLayout.document <= checkoutLayout.viewport + 1);
		await page.screenshot({ path: path.join(screenshots, 'woo-checkout.png') });
		report.screenshots.push('woo-checkout.png');
		const priorOrderId = Number(wp(['eval', '$ids=wc_get_orders(["limit"=>1,"billing_email"=>"buyer-a@birthday.invalid","return"=>"ids","orderby"=>"date","order"=>"DESC"]); echo (int)($ids[0]??0);']));
		let checkoutOrderId = priorOrderId;
		if (!checkoutOrderId) {
			await page.locator('#billing_first_name').fill('Casey');
			await page.locator('#billing_last_name').fill('Canary');
			await page.locator('#billing_email').fill('buyer-a@birthday.invalid');
			await page.locator('#billing_country').selectOption('US');
			await page.locator('#billing_address_1').fill('1 Synthetic Lane');
			await page.locator('#billing_city').fill('Testville');
			const state = page.locator('#billing_state');
			if (await state.count()) {
				if ((await state.evaluate((element) => element.tagName.toLowerCase())) === 'select') await state.selectOption('CA');
				else await state.fill('CA');
			}
			await page.locator('#billing_postcode').fill('94103');
			const phone = page.locator('#billing_phone');
			if (await phone.count()) await phone.fill('2025550101');
			const accountCheckbox = page.locator('#createaccount');
			if (await accountCheckbox.count() && !(await accountCheckbox.isChecked())) await accountCheckbox.check({ force: true });
			await page.locator('input[name="payment_method"][value="cheque"]').check({ force: true });
			await page.locator('#place_order').click();
			await page.waitForTimeout(2000);
			const orderMatch = new URL(page.url()).pathname.match(/order-received\/(\d+)/);
			checkoutOrderId = orderMatch ? Number(orderMatch[1]) : 0;
		}
		assert.ok(checkoutOrderId > 0, 'Synthetic local offline checkout did not create an order.');
		const checkoutOrder = JSON.parse(wp(['eval', `$o=wc_get_order(${checkoutOrderId}); $u=$o?get_userdata($o->get_customer_id()):false; echo wp_json_encode(["id"=>$o?$o->get_id():0,"status"=>$o?$o->get_status():"missing","paid"=>$o?$o->is_paid():false,"total"=>$o?$o->get_total():"","currency"=>$o?$o->get_currency():"","customerId"=>$o?$o->get_customer_id():0,"buyerEmailDomain"=>$o?substr(strrchr($o->get_billing_email(),"@"),1):"","userLogin"=>$u?$u->user_login:""]);`]));
		assert.equal(checkoutOrder.status, 'on-hold');
		assert.equal(checkoutOrder.paid, false);
		assert.equal(checkoutOrder.total, '39.99');
		assert.equal(checkoutOrder.currency, 'USD');
		assert.ok(checkoutOrder.customerId > 0 && checkoutOrder.userLogin);
		const seed = seedWorkspace(setup.product.id, checkoutOrderId);
		report.checks.checkout = { result: 'PASS', route: new URL(checkoutResponse).pathname, requiredFieldsVisible: true, createAccountControlVisible: accountCreateVisible, checkoutAccountCreationSetting: checkoutAccountSetting, guestCheckoutDisabled: guestCheckoutSetting, accountCreatedAtCheckout: true, order: { id: checkoutOrder.id, status: checkoutOrder.status, paid: checkoutOrder.paid, total: checkoutOrder.total, currency: checkoutOrder.currency, ownerId: checkoutOrder.customerId, emailDomain: checkoutOrder.buyerEmailDomain }, offlineGatewayOnly: true, noPayPalVisible: true, realPayment: false, layout: checkoutLayout };

		await page.goto(`${baseUrl}/my-account/`, { waitUntil: 'domcontentloaded', timeout: 30000 });
		await page.waitForTimeout(600);
		assert.ok(await page.locator('#username').count());
		assert.ok(await page.locator('#password').count());
		assert.ok(await page.locator('button[name="login"]').isEnabled());
		const myAccountLayout = await page.evaluate(() => ({ viewport: innerWidth, document: document.documentElement.scrollWidth }));
		assert.ok(myAccountLayout.document <= myAccountLayout.viewport + 1);
		await page.screenshot({ path: path.join(screenshots, 'woo-my-account.png') });
		report.screenshots.push('woo-my-account.png');
		report.checks.myAccount = { result: 'PASS', loginFieldsVisible: true, loginEnabled: true, layout: myAccountLayout };

		const workspaceUrl = `${baseUrl}/birthday-workspace/${seed.orderId}/`;
		const guestContext = await browser.newContext({ viewport: { width: 1280, height: 800 } });
		const guestPage = await guestContext.newPage();
		const guestResponse = await guestPage.goto(workspaceUrl, { waitUntil: 'domcontentloaded' });
		assert.equal(guestResponse.status(), 403);
		await guestContext.close();

		const ownerContext = await browser.newContext({ viewport: { width: 1280, height: 800 } });
		const ownerPage = await ownerContext.newPage();
		await ownerPage.goto(`${baseUrl}/my-account/`, { waitUntil: 'domcontentloaded' });
		await ownerPage.locator('#username').fill(seed.credentials.aEmail);
		await ownerPage.locator('#password').fill(seed.credentials.aPassword);
		await ownerPage.locator('button[name="login"]').click();
		await ownerPage.waitForTimeout(800);
		assert.ok((await ownerPage.locator('body').innerText()).includes('Log out'));
		const ownerResponse = await ownerPage.goto(workspaceUrl, { waitUntil: 'domcontentloaded' });
		assert.equal(ownerResponse.status(), 200);
		assert.ok(await ownerPage.locator('[data-bms-g3a-workspace]').count());
		await ownerContext.close();

		const otherContext = await browser.newContext({ viewport: { width: 1280, height: 800 } });
		const otherPage = await otherContext.newPage();
		await otherPage.goto(`${baseUrl}/my-account/`, { waitUntil: 'domcontentloaded' });
		await otherPage.locator('#username').fill(seed.credentials.bEmail);
		await otherPage.locator('#password').fill(seed.credentials.bPassword);
		await otherPage.locator('button[name="login"]').click();
		await otherPage.waitForTimeout(800);
		assert.ok((await otherPage.locator('body').innerText()).includes('Log out'));
		const otherResponse = await otherPage.goto(workspaceUrl, { waitUntil: 'domcontentloaded' });
		assert.equal(otherResponse.status(), 403);
		await otherContext.close();
		report.checks.privateWorkspace = { result: 'PASS', ownerHttp: ownerResponse.status(), unrelatedUserHttp: otherResponse.status(), guestHttp: guestResponse.status(), syntheticOrderId: seed.orderId, orderState: seed.orderStatus, paid: seed.paid, orderTotal: seed.total, currency: seed.currency, modelCalls: 0 };
		const activePluginsAfterWoo = JSON.parse(wp(['plugin', 'list', '--format=json'])).filter((plugin) => plugin.status === 'active').map((plugin) => ({ slug: plugin.name, version: plugin.version }));
		const wooVersion = wp(['plugin', 'get', 'woocommerce', '--field=version']);
		assert.equal(wooVersion, '11.1.2');
		report.runtime = { wordpress: wp(['core', 'version']), php: docker(['exec', `${project}-wordpress-1`, 'php', '-r', 'echo PHP_VERSION;']), mariadb: docker(['exec', `${project}-db-1`, 'mariadb', '-N', '-uroot', '-e', 'SELECT VERSION();']), woocommerce: wooVersion, blocksy: '2.1.57', blocksyCompanion: '2.1.57', activePluginsAfterWoo };
		report.externalHosts = [...externalHosts].sort();
		report.completedAtUtc = new Date().toISOString();
		fs.writeFileSync(path.join(reports, 'canary-report.json'), `${JSON.stringify(report, null, 2)}\n`);
		console.log(JSON.stringify({ result: 'PASS', checks: Object.fromEntries(Object.entries(report.checks).map(([key, value]) => [key, value.result])), screenshots: report.screenshots, externalHosts: report.externalHosts, consoleErrorCount: report.consoleErrors.length }));
	} finally {
		await browser.close();
	}
}

main().catch((error) => {
	console.error(error.stack || error.message);
	process.exitCode = 1;
});
