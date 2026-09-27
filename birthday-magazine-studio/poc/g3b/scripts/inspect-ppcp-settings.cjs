const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require(path.resolve(__dirname, '../../g2b/node_modules/playwright'));

const repoRoot = path.resolve(__dirname, '../../../..');
const artifacts = path.join(repoRoot, 'birthday-magazine-studio/poc/g3b/artifacts');
const baseUrl = 'http://127.0.0.1:8137';
const chromePath = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';

async function main() {
	const password = process.env.BMS_G3B_ADMIN_PASSWORD;
	if (!password) throw new Error('BMS_G3B_ADMIN_PASSWORD is required in the current process.');
	fs.mkdirSync(artifacts, { recursive: true });
	const browser = await chromium.launch({ headless: true, executablePath: chromePath, args: ['--no-proxy-server'] });
	const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
	const requestHosts = new Set();
	page.on('request', (request) => {
		const url = new URL(request.url());
		if (['http:', 'https:'].includes(url.protocol) && !['127.0.0.1', 'localhost'].includes(url.hostname)) requestHosts.add(url.hostname);
	});
	try {
		await page.goto(`${baseUrl}/wp-login.php`, { waitUntil: 'domcontentloaded' });
		await page.locator('#user_login').fill('g3b-admin');
		await page.locator('#user_pass').fill(password);
		await page.locator('#wp-submit').click({ noWaitAfter: true });
		await page.waitForTimeout(1000);
		if (!new URL(page.url()).pathname.startsWith('/wp-admin/')) throw new Error('Synthetic WordPress admin login did not reach wp-admin.');
		await page.goto(`${baseUrl}/wp-admin/admin.php?page=wc-settings&tab=checkout&section=ppcp-gateway`, { waitUntil: 'domcontentloaded' });
		await page.waitForTimeout(1500);
		const advanced = page.locator('button.ppcp--toggler[aria-controls="advanced-options-content"]');
		if (await advanced.count() && (await advanced.getAttribute('aria-expanded')) !== 'true') {
			await advanced.click();
			await page.waitForTimeout(500);
		}
		const sandboxLabel = page.getByText('Enable Sandbox Mode').first();
		await sandboxLabel.scrollIntoViewIfNeeded();
		const sandboxLabelBox = await sandboxLabel.boundingBox();
		const switches = await page.locator('[role="checkbox"], input[type="checkbox"]').all();
		let sandboxSwitch = null;
		let nearestDistance = Infinity;
		for (const candidate of switches) {
			const box = await candidate.boundingBox();
			if (!box || !sandboxLabelBox) continue;
			const distance = Math.abs((box.y + box.height / 2) - (sandboxLabelBox.y + sandboxLabelBox.height / 2));
			if (distance < nearestDistance) {
				nearestDistance = distance;
				sandboxSwitch = candidate;
			}
		}
		if (!sandboxSwitch || nearestDistance > 80) {
			const toggleDiagnostics = await page.locator('[role="checkbox"], input[type="checkbox"]').evaluateAll((items) => items.map((item) => {
				let ancestor = item;
				const texts = [];
				for (let depth = 0; depth < 5 && ancestor; depth++, ancestor = ancestor.parentElement) texts.push((ancestor.innerText || '').trim().slice(0, 100));
				return { checked: item.getAttribute('aria-checked'), texts };
			}));
			throw new Error(JSON.stringify({ sandboxLabelCount: await page.getByText('Enable Sandbox Mode').count(), sandboxLabelBox, switchCount: switches.length, nearestDistance, toggleDiagnostics }));
		}
		const sandboxToggleBefore = await sandboxSwitch.evaluate((item) => ('checked' in item) ? String(item.checked) : item.getAttribute('aria-checked'));
		if (sandboxToggleBefore !== 'true') {
			if (await sandboxSwitch.evaluate((item) => item.tagName.toLowerCase() === 'input')) await sandboxSwitch.check();
			else await sandboxSwitch.click();
			await page.waitForTimeout(1200);
		}
		const sandboxToggleAfter = await sandboxSwitch.evaluate((item) => ('checked' in item) ? String(item.checked) : item.getAttribute('aria-checked'));
		const body = await page.locator('body').innerText();
		const controls = await page.locator('button, a, input[type="submit"]').evaluateAll((items) => items.map((item) => (item.innerText || item.value || item.getAttribute('aria-label') || '').trim()).filter(Boolean).slice(0, 30));
		const fields = await page.locator('input, select, button').evaluateAll((items) => items.map((item) => ({ name: item.name || '', type: item.type || item.tagName.toLowerCase(), label: item.getAttribute('aria-label') || item.getAttribute('placeholder') || '', checked: 'checked' in item ? Boolean(item.checked) : undefined })).filter((item) => item.name || item.label).slice(0, 40));
		const toggles = await page.locator('[role="switch"], [role="checkbox"], input[type="checkbox"]').evaluateAll((items) => items.map((item) => ({ role: item.getAttribute('role') || item.type, label: item.getAttribute('aria-label') || item.closest('label')?.innerText || item.parentElement?.parentElement?.innerText?.slice(0, 120) || '', checked: item.getAttribute('aria-checked') ?? (('checked' in item) ? String(item.checked) : '') })).slice(0, 20));
		const pagePath = new URL(page.url()).pathname;
		const ppcpTitleVisible = body.includes('PayPal Payments');
		const fatalErrorVisible = /critical error|fatal error|uncaught error/i.test(body);
		const activationButtonVisible = body.includes('Activate PayPal Payments');
		const connectControlVisible = activationButtonVisible || controls.some((label) => /connect.*paypal|start setup|setup.*paypal/i.test(label));
		const sandboxControlVisible = /sandbox/i.test(body);
		const liveControlVisible = /live mode|live environment|production mode/i.test(body);
		const result = {
			capturedAtUtc: new Date().toISOString(),
			requestedRoute: '/wp-admin/admin.php?page=wc-settings&tab=checkout&section=ppcp-gateway',
			finalPath: pagePath,
			pageTitle: await page.title(),
			ppcpTitleVisible,
			fatalErrorVisible,
			connectControlVisible,
			activationButtonVisible,
			sandboxToggleBefore,
			sandboxToggleAfter,
			sandboxModeSelected: sandboxToggleAfter === 'true',
			sandboxControlVisible,
			liveControlVisible,
			controlLabels: controls,
			fields,
			toggles,
			requestHosts: [...requestHosts].sort(),
			liveEnabled: false,
			merchantConnected: false,
			ownerOAuthActionPerformed: false,
		};
		await page.screenshot({ path: path.join(artifacts, 'ppcp-settings-direct.png'), fullPage: true });
		fs.writeFileSync(path.join(artifacts, 'ppcp-settings-health.json'), `${JSON.stringify(result, null, 2)}\n`, 'utf8');
		console.log(JSON.stringify({ result: ppcpTitleVisible && !fatalErrorVisible ? 'PASS' : 'RETURN', ...result }));
		if (!ppcpTitleVisible || fatalErrorVisible) process.exitCode = 1;
	} finally {
		await browser.close();
	}
}

main().catch((error) => {
	console.error(error.message.replace(/https?:\/\/[^\s?]+\?[^\s]*/g, '[local URL redacted]'));
	process.exitCode = 1;
});
