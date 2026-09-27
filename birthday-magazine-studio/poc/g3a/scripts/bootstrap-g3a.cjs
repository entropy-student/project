const crypto = require('node:crypto');
const path = require('node:path');
const { chromium } = require(path.resolve(__dirname, '../../g2b/node_modules/playwright'));

const baseUrl = 'http://127.0.0.1:8127';
const chromePath = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';

async function main() {
	const browser = await chromium.launch({
		headless: true,
		executablePath: chromePath,
		args: ['--no-proxy-server'],
	});
	try {
		const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
		await page.goto(`${baseUrl}/wp-admin/install.php`, { waitUntil: 'domcontentloaded' });
		if (!(await page.locator('#weblog_title').count())) {
			const initialText = (await page.locator('body').innerText()).replace(/\s+/g, ' ').trim();
			if (initialText.includes('Already Installed')) {
				console.log(JSON.stringify({ wordpressInstall: 'PASS', state: 'already-installed' }));
				return;
			}
			const languageForm = page.locator('body.language-chooser form');
			if (await languageForm.count()) {
				await languageForm.locator('input[type="submit"],button[type="submit"]').first().click();
				await page.waitForSelector('#weblog_title', { timeout: 20000 });
			} else {
				throw new Error(`WordPress first-run form is not available (${await page.title()}).`);
			}
		}

		const adminPassword = `${crypto.randomBytes(24).toString('base64url')}Aa7!`;
		await page.locator('#weblog_title').fill('Birthday Magazine G3A Synthetic Local');
		await page.locator('#user_login').fill('g3a-admin');
		await page.locator('#pass1').fill(adminPassword);
		await page.locator('#admin_email').fill('site-admin@birthday.invalid');
		const weakPasswordConfirmation = page.locator('#pw-weak');
		if (await weakPasswordConfirmation.count() && !(await weakPasswordConfirmation.isChecked())) {
			await weakPasswordConfirmation.check();
		}
		await Promise.all([
			page.waitForNavigation({ waitUntil: 'domcontentloaded', timeout: 20000 }),
			page.locator('#submit').click(),
		]);
		const confirmation = (await page.locator('body').innerText()).replace(/\s+/g, ' ').trim();
		if (!confirmation.toLowerCase().includes('success')) {
			throw new Error('WordPress first-run did not return its success confirmation.');
		}
		console.log(JSON.stringify({ wordpressInstall: 'PASS', adminUser: 'g3a-admin', adminPasswordStored: false }));
	} finally {
		await browser.close();
	}
}

main().catch((error) => {
	console.error(error.message);
	process.exitCode = 1;
});
